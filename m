Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BB1155D82
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgBGSQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:49 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40778 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727564AbgBGSQr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:47 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2D0EA305D340;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 16A403052070;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 34/78] KVM: x86: intercept the write access on sidt and other emulated instructions
Date:   Fri,  7 Feb 2020 20:15:52 +0200
Message-Id: <20200207181636.1065-35-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
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
index 8c6a8d03e41a..6e665341cc80 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5450,11 +5450,14 @@ static int kvm_write_guest_virt_helper(gva_t addr, void *val, unsigned int bytes
 
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
