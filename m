Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B106146E246
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 07:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhLIGJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 01:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbhLIGJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 01:09:39 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E530C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 22:06:06 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id s18-20020a63ff52000000b00320f169c0aaso2688867pgk.18
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 22:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qAEfZ2xuep7I9JLVyKIo4U/BDGIUNFDaTBmgxcU/j+s=;
        b=pyuFZ1gNznZ5qcPLbFP2grkrDVTeCwJ32laSXwUw/wqFt9QwZE1AfYELp3SP/4njv4
         mPaY4LCL5l+CplssK7ze1rhFH+ONtfYwu/yKZMnOLuceGdlBGn8BOzQ6lOWGoGFigcMj
         y00beyYI2kKSDEhi19hpZkvzzjN6lNiYsBfcJm6P3I1RJORgaOM0YZW8vXb+Wil0TpyG
         J6cKz92/YpEoTsUz5eP8vKFaKSCx0GaR4HDG5aqnUB3oYpep3RFv4QZWV2KehotsBrgL
         2BSKeZ7MAxFUNY9VmLFQRWeCvMDt/ygAN4dwFh+6e/pCOKPAtUBL2bNhRRDna0P1ytr8
         OfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qAEfZ2xuep7I9JLVyKIo4U/BDGIUNFDaTBmgxcU/j+s=;
        b=H1sgDdj0d9B5GgFzknzAROCo+OWR2cTR9C4QDL+ugNqW3EAbCuamnULprZIMB1dUdq
         KKOx4sV0Mg4Mwoab31ZvXc6VmZzZfuOKL6IAwHl0AH4Nvx2THlMAO80lXvCmBpaZkpr6
         Pla662FKjIYOFr77U2eY/p37xJKTyBbKth6L/sExv/Iqo6gGi8BmculXtMFUSDMFgL6K
         gyver+qjBzHkGMryl9Krinj7+f93KkYdXIE2DVuUA8sJT6H5X4vRtt5vasUs+pg26S+k
         zaRydxCUhBCyFKc1sNbcIxVBdp1wDhV41NTmH7d0HYGd6B2u0zt1bJAp+Cmd1Vqu9tJs
         OKWQ==
X-Gm-Message-State: AOAM530JxH7nV3nfrU5nIl6Cbhib6Hlfo/MQ3rD4e2dzYCEu/BDBjhzL
        hLWT5+ZfgpRvvnuQPw5oGFHae2kFRe8=
X-Google-Smtp-Source: ABdhPJwRGYZdVpleiLGsWqn2ocbNgP1sfvyN0ZyU5JhgNJ9jxovRtrHuXKXDH8/QlqZKz3yJYgnO2u9qFz0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1ad3:b0:4a0:36d:d067 with SMTP id
 f19-20020a056a001ad300b004a0036dd067mr9826946pfv.19.1639029966049; Wed, 08
 Dec 2021 22:06:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Dec 2021 06:05:50 +0000
In-Reply-To: <20211209060552.2956723-1-seanjc@google.com>
Message-Id: <20211209060552.2956723-6-seanjc@google.com>
Mime-Version: 1.0
References: <20211209060552.2956723-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 5/7] KVM: s390: Replace KVM_REQ_MMU_RELOAD usage with arch
 specific request
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an arch request, KVM_REQ_REFRESH_GUEST_PREFIX, to deal with guest
prefix changes instead of piggybacking KVM_REQ_MMU_RELOAD.  This will
allow for the removal of the generic KVM_REQ_MMU_RELOAD, which isn't
actually used by generic KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/include/asm/kvm_host.h | 2 ++
 arch/s390/kvm/kvm-s390.c         | 8 ++++----
 arch/s390/kvm/kvm-s390.h         | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a22c9266ea05..766028d54a3e 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -45,6 +45,8 @@
 #define KVM_REQ_START_MIGRATION KVM_ARCH_REQ(3)
 #define KVM_REQ_STOP_MIGRATION  KVM_ARCH_REQ(4)
 #define KVM_REQ_VSIE_RESTART	KVM_ARCH_REQ(5)
+#define KVM_REQ_REFRESH_GUEST_PREFIX	\
+	KVM_ARCH_REQ_FLAGS(6, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define SIGP_CTRL_C		0x80
 #define SIGP_CTRL_SCN_MASK	0x3f
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index dd099d352753..e161df69520c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3394,7 +3394,7 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 		if (prefix <= end && start <= prefix + 2*PAGE_SIZE - 1) {
 			VCPU_EVENT(vcpu, 2, "gmap notifier for %lx-%lx",
 				   start, end);
-			kvm_s390_sync_request(KVM_REQ_MMU_RELOAD, vcpu);
+			kvm_s390_sync_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
 		}
 	}
 }
@@ -3796,19 +3796,19 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 	if (!kvm_request_pending(vcpu))
 		return 0;
 	/*
-	 * We use MMU_RELOAD just to re-arm the ipte notifier for the
+	 * If the guest prefix changed, re-arm the ipte notifier for the
 	 * guest prefix page. gmap_mprotect_notify will wait on the ptl lock.
 	 * This ensures that the ipte instruction for this request has
 	 * already finished. We might race against a second unmapper that
 	 * wants to set the blocking bit. Lets just retry the request loop.
 	 */
-	if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu)) {
+	if (kvm_check_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu)) {
 		int rc;
 		rc = gmap_mprotect_notify(vcpu->arch.gmap,
 					  kvm_s390_get_prefix(vcpu),
 					  PAGE_SIZE * 2, PROT_WRITE);
 		if (rc) {
-			kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
+			kvm_make_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
 			return rc;
 		}
 		goto retry;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 60f0effcce99..219f92ffd556 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -105,7 +105,7 @@ static inline void kvm_s390_set_prefix(struct kvm_vcpu *vcpu, u32 prefix)
 		   prefix);
 	vcpu->arch.sie_block->prefix = prefix >> GUEST_PREFIX_SHIFT;
 	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-	kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
+	kvm_make_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
 }
 
 static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
-- 
2.34.1.400.ga245620fadb-goog

