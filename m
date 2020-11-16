Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4E2B4EEF
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbgKPSLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:11:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730775AbgKPSLc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 13:11:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605550292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xf1LJn8hGte4D+k0k0YeB9oW653XA/c4TK7Y8k7TCcw=;
        b=OXpaTSlRQlisd2LLVGYNkbeTRarapVHiGg/pwK38QgipXP71zdcFTDtZc/3PLvX+/sIZZj
        8iPX0xPwG15wdyITpNphcCjrCv4mUcMHVlE0Z1egLNAuoLNN7d8IRPOpjNbaSmTQTgz20p
        zgw6J0zz5uA+Rv3Hy848f5/Xd8b+Myg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-VP9hCMv8MP6yJjyKGGRZHw-1; Mon, 16 Nov 2020 13:11:28 -0500
X-MC-Unique: VP9hCMv8MP6yJjyKGGRZHw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C8571084D72;
        Mon, 16 Nov 2020 18:11:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0D8A5C1CF;
        Mon, 16 Nov 2020 18:11:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Subject: [PATCH] KVM: SVM: check CR4 changes against vcpu->arch
Date:   Mon, 16 Nov 2020 13:11:26 -0500
Message-Id: <20201116181126.2008838-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similarly to what vmx/vmx.c does, use vcpu->arch.cr4 to check if CR4
bits PGE, PKE and OSXSAVE have changed.  When switching between VMCB01
and VMCB02, CPUID has to be adjusted every time if CR4.PKE or CR4.OSXSAVE
change; without this patch, instead, CR4 would be checked against the
previous value for L2 on vmentry, and against the previous value for
L1 on vmexit, and CPUID would not be updated.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3b53a7ead04b..6dc337b9c231 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1691,7 +1691,7 @@ static bool svm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
-	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
+	unsigned long old_cr4 = vcpu->arch.cr4;
 
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
 		svm_flush_tlb(vcpu);
-- 
2.26.2

