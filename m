Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC68A87F48
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437161AbfHIQPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:40 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52862 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437143AbfHIQPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B0DAB305D35D;
        Fri,  9 Aug 2019 19:01:38 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E6041305B7A5;
        Fri,  9 Aug 2019 19:01:37 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 75/92] kvm: x86: disable gpa_available optimization in emulator_read_write_onepage()
Date:   Fri,  9 Aug 2019 19:00:30 +0300
Message-Id: <20190809160047.8319-76-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the EPT violation was caused by an execute restriction imposed by the
introspection tool, gpa_available will point to the instruction pointer,
not the to the read/write location that has to be used to emulate the
current instruction.

This optimization should be disabled only when the VM is introspected,
not just because the introspection subsystem is present.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 965c4f0108eb..3975331230b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5532,7 +5532,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	 * operation using rep will only have the initial GPA from the NPF
 	 * occurred.
 	 */
-	if (vcpu->arch.gpa_available &&
+	if (vcpu->arch.gpa_available && !kvmi_is_present() &&
 	    emulator_can_use_gpa(ctxt) &&
 	    (addr & ~PAGE_MASK) == (vcpu->arch.gpa_val & ~PAGE_MASK)) {
 		gpa = vcpu->arch.gpa_val;
