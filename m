Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1031978EA
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgC3KU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:26 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43752 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729744AbgC3KUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4F9873074B70;
        Mon, 30 Mar 2020 13:12:54 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 24CC5305B7A1;
        Mon, 30 Mar 2020 13:12:54 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 36/81] KVM: x86: intercept the write access on sidt and other emulated instructions
Date:   Mon, 30 Mar 2020 13:12:23 +0300
Message-Id: <20200330101308.21702-37-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is needed for the introspection subsystem to track the changes to
descriptor table registers.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d35cdda115cc..2aaa0dd8b02a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5539,11 +5539,14 @@ static int kvm_write_guest_virt_helper(gva_t addr, void *val, unsigned int bytes
 
 		if (gpa == UNMAPPED_GVA)
 			return X86EMUL_PROPAGATE_FAULT;
+		if (!kvm_page_track_prewrite(vcpu, gpa, addr, data, towrite))
+			return X86EMUL_RETRY_INSTR;
 		ret = kvm_vcpu_write_guest(vcpu, gpa, data, towrite);
 		if (ret < 0) {
 			r = X86EMUL_IO_NEEDED;
 			goto out;
 		}
+		kvm_page_track_write(vcpu, gpa, addr, data, towrite);
 
 		bytes -= towrite;
 		data += towrite;
