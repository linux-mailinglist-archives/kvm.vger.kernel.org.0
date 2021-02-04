Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A6F30C6FA
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbhBBRGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:06:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233840AbhBBREN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:04:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612285368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9UCxeo6v7NOgmWOxRaq0ZSAmgBbuaMdBo8v8dZDVug4=;
        b=U6/WdOb5umOA6ttJvWFaM+EQ/6aE+H6a8qMqIWX8teVkY7qEbLrIYSKCdatfqrTjsR4Dht
        3SXKfDZYJClu34HldO8MUzIBvZMpNLRZyWT6t3NHYscOxz5zaFqlxjw7QRy8T9f3SMZXTN
        mSjosPkBlg6bZzxK5npMevpyQuEEmtA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-vB5OzQl9PWiMRF2K2wsCIg-1; Tue, 02 Feb 2021 12:02:46 -0500
X-MC-Unique: vB5OzQl9PWiMRF2K2wsCIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BE1B192CC40;
        Tue,  2 Feb 2021 17:02:45 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDAA760C5F;
        Tue,  2 Feb 2021 17:02:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH] KVM: x86: cleanup CR3 reserved bits checks
Date:   Tue,  2 Feb 2021 12:02:44 -0500
Message-Id: <20210202170244.89334-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If not in long mode, the low bits of CR3 are reserved but not enforced to
be zero, so remove those checks.  If in long mode, however, the MBZ bits
extend down to the highest physical address bit of the guest, excluding
the encryption bit.

Make the checks consistent with the above, and match them between
nested_vmcb_checks and KVM_SET_SREGS.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 12 ++----------
 arch/x86/kvm/svm/svm.h    |  3 ---
 arch/x86/kvm/x86.c        |  2 ++
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index eecb548bdda6..9ee542ea3f56 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -244,18 +244,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 
 	vmcb12_lma = (vmcb12->save.efer & EFER_LME) && (vmcb12->save.cr0 & X86_CR0_PG);
 
-	if (!vmcb12_lma) {
-		if (vmcb12->save.cr4 & X86_CR4_PAE) {
-			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
-				return false;
-		} else {
-			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
-				return false;
-		}
-	} else {
+	if (vmcb12_lma) {
 		if (!(vmcb12->save.cr4 & X86_CR4_PAE) ||
 		    !(vmcb12->save.cr0 & X86_CR0_PE) ||
-		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
+		    (vmcb12->save.cr3 & svm->vcpu.arch.cr3_lm_rsvd_bits))
 			return false;
 	}
 	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0fe874ae5498..6e7d070f8b86 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -403,9 +403,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
 }
 
 /* svm.c */
-#define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
-#define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
-#define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define MSR_INVALID				0xffffffffU
 
 extern int sev;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b748bf0d6d33..97674204bf44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9660,6 +9660,8 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		 */
 		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
 			return false;
+		if (sregs->cr3 & vcpu->arch.cr3_lm_rsvd_bits)
+			return false;
 	} else {
 		/*
 		 * Not in 64-bit mode: EFER.LMA is clear and the code
-- 
2.26.2

