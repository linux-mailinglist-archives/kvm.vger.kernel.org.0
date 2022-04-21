Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAEF50A920
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391949AbiDUT3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 15:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391947AbiDUT3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 15:29:40 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578424D27D
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:26:48 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id ij17-20020a170902ab5100b00158f6f83068so2953318plb.19
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=pYTGRH9m6FXqJR4L+bWg9iL3P8n7mz5/SSSW+uscXcU=;
        b=cS+n8bxQM/A1/ZgETYgDa5x1CtPSE1Qu/H5qpj+w0FJtSZWXmOj9RzBH+vbJ2RpoUV
         fgtV+41Kc50f29QLlxSwt7K3jw/ND1vzTKzsl9Ef+DhUbPYg5BaU4R4VuA5dgbcFdt0v
         OXiD6DPNxDMDIQBrsoNCramULrhtzeFuvH2+I6HuYxRzlTJVyjmwjNNNi2g0n+A892nY
         fea2+w/qmvAHVVzcLwmRxGsVe52x5t2NctDrOiMPfsZgzBLG4vqn2hHSA2GYAA6aTZvY
         4WPQ9vkir/iI1gz3a0jcooB78gPbPYKk4lr22kv8fIwZF6pM5YJyOITmGgzPA72hHDwF
         KVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc:content-transfer-encoding;
        bh=pYTGRH9m6FXqJR4L+bWg9iL3P8n7mz5/SSSW+uscXcU=;
        b=vMgo/MFCQaVzJ53Rp9Ax5d2EuscH7MchKy/5VPVIw2ml22/i0FbBrVvoxrEYKaaru3
         tzQ7guQqCFNtkYAmp33oGy8Q71qxRZ2vV77t2pQzWhgiYQsD3Rx3GpgOjEbfZXVtj8+t
         vkv4rutSUKOshIon7VVdRjXT5lPnF1b+gyoc7QmCfofMcddngtFIcIYky7QCFZof4VWH
         wVn+s2vzOeFO9zqN7F7V9gdxyag0n6Nc9BQPBTAsQnz7FLbZOV7AB9CfBUD2pZsWnNwA
         WSkcfaB5PE0pvuyVUQqHYw2Au2FkE3zVHrTxtBQwggtUazCIt6KMS92nHKEbCzBvN52V
         eiXQ==
X-Gm-Message-State: AOAM531gc9DklMF3hA0g5ftpBr7b0ITDBN9t8Oy4jJK5Lf2Oc9BMaC2c
        ar9PtMMrzsPMNYONKBctCbUKu8ijPa4=
X-Google-Smtp-Source: ABdhPJyS0P04sjI+415b9D+u4Kmv2Rb1iKP7eBbOCt6rEWlUPXNLiEL0pRj0uObl7iOF6vaL7e9ZO5MlKfo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:484f:0:b0:3aa:3f25:25a0 with SMTP id
 x15-20020a63484f000000b003aa3f2525a0mr792921pgk.559.1650569207841; Thu, 21
 Apr 2022 12:26:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Apr 2022 19:26:45 +0000
Message-Id: <20220421192645.3762857-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH] KVM: Fix build error on s390 due to kvm_flush_shadow_all()
 being hidden
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hoist kvm_flush_shadow_all() out of the #ifdef block that depends on the
mmu_notifier being enabled and wanted by KVM.  KVM s390 doesn't utilize
the mmu_notifier, and so the direct call to kvm_flush_shadow_all() in
vm_destroy() rightly complains.

virt/kvm/kvm_main.c: In function =E2=80=98kvm_destroy_vm=E2=80=99:
virt/kvm/kvm_main.c:1248:9: error: implicit declaration of function =E2=80=
=98kvm_flush_shadow_all=E2=80=99;
did you mean =E2=80=98kvm_arch_flush_shadow_all=E2=80=99? [-Werror=3Dimplic=
it-function-declaration]
 1248 |         kvm_flush_shadow_all(kvm);
      |         ^~~~~~~~~~~~~~~~~~~~
      |         kvm_arch_flush_shadow_all

Fixes: b56a4ff6bff3 ("KVM: SEV: add cache flush to solve SEV cache incohere=
ncy issues")
Cc: stable@vger.kernel.org
Cc: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a719e52f3eb7..f30bb8c16f26 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -361,6 +361,12 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 #endif
=20
+static void kvm_flush_shadow_all(struct kvm *kvm)
+{
+	kvm_arch_flush_shadow_all(kvm);
+	kvm_arch_guest_memory_reclaimed(kvm);
+}
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache=
 *mc,
 					       gfp_t gfp_flags)
@@ -820,12 +826,6 @@ static int kvm_mmu_notifier_test_young(struct mmu_noti=
fier *mn,
 					     kvm_test_age_gfn);
 }
=20
-static void kvm_flush_shadow_all(struct kvm *kvm)
-{
-	kvm_arch_flush_shadow_all(kvm);
-	kvm_arch_guest_memory_reclaimed(kvm);
-}
-
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 				     struct mm_struct *mm)
 {

base-commit: b56a4ff6bff38fc49d8e583a3fbb5e18d1a99963
--=20
2.36.0.rc2.479.g8af0fa9b8e-goog

