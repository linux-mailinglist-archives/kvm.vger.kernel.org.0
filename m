Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AC559553A
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 10:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiHPI27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 04:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbiHPI2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 04:28:24 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49074B5A47
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 22:39:43 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id li17-20020a17090b48d100b001f516833f62so3685862pjb.9
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 22:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=P0QIT2XK77Oto7YfWYKIYTTpEvk6YfjHVC+uFLOR+IA=;
        b=NzY/qYDCAX1OabbgRWx0wtYEA2CUeMf6owA3/r4PfaVjeUKIL4hZExtdsfzmywIg9n
         Cw5b9ckoW4An4P6wAJmV25rn0F3XONKUZZR/xYB5qSFE9hMMsGpmZAXFlnNsveQq2TLZ
         zlgma0LVwLU7GAG0uov2lR3M2iJ+ua45SuAjfBT1Xnn/2RMSIfMPfyafgJNmXX2F1kLp
         HE/JFHdOofKBsIiTrrfaK+wffTLBDWBEJFgBGspl6+cdZ6xhDrstzQmHTg57fJke+zV3
         6W6Ef2kzuFMAp/Py8Nj6SKzJOLxYVwfFh/8B6mYojTj6tTjwKaKHitQSSFkAJovYn6t4
         MGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=P0QIT2XK77Oto7YfWYKIYTTpEvk6YfjHVC+uFLOR+IA=;
        b=O/OH3PfMQIlPwMVy52UZq6Nyz4YQnqSw5dRYR+5x6hDDaKTEI+FcaKnkh2ZUTR4dFO
         gEW2Pv6k6/ahTuzyvq2HOVEz0zFhwkETypz63gWxeVio+zYga2MSM18gbumBKnlw0vuw
         jOy46+tjDH6sx2Vz3XFTdvTJATAMVKqiuIKOoCcu6tc5sdC/9exrQTpmSdH3kGPcrlZd
         jAXCwfLpCVrtP+vznbwzGkB8lInsNOx+kWEvnQ6Q3afFp9h7SD3eAINZwUrtSL8NVF3y
         B3xfiafpOSRySbD1v0B/H6OKLep0+XeSE4z+0z/GhwbUYabvulKvLWc4FXy8rqtFWUjU
         kLJg==
X-Gm-Message-State: ACgBeo3hGbUJqVae6RNUPBIOe0KymIwsiZCSvRtWkKqxRJftR+lT32Jm
        JkedkgXM9UVo3pnOvWQNOn1P3MlL//Y=
X-Google-Smtp-Source: AA6agR7m2l1CO8dy3dV9yhEXh1qMXWAWmdxxK8NBRv7niQaxroUaXjWUgUW5OKoKHJrpvfiU9kteOBnCPb0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1bc7:b0:1f5:37a6:e473 with SMTP id
 oa7-20020a17090b1bc700b001f537a6e473mr21624786pjb.87.1660628382882; Mon, 15
 Aug 2022 22:39:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 16 Aug 2022 05:39:35 +0000
In-Reply-To: <20220816053937.2477106-1-seanjc@google.com>
Message-Id: <20220816053937.2477106-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220816053937.2477106-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 1/3] KVM: Properly unwind VM creation if creating debugfs fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com,
        Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Properly unwind VM creation if kvm_create_vm_debugfs() fails.  A recent
change to invoke kvm_create_vm_debug() in kvm_create_vm() was led astray
by buggy try_get_module() handling adding by commit 5f6de5cbebee ("KVM:
Prevent module exit until all VMs are freed").  The debugfs error path
effectively inherits the bad error path of try_module_get(), e.g. KVM
leaves the to-be-free VM on vm_list even though KVM appears to do the
right thing by calling module_put() and falling through.

Opportunistically hoist kvm_create_vm_debugfs() above the call to
kvm_arch_post_init_vm() so that the "post-init" arch hook is actually
invoked after the VM is initialized (ignoring kvm_coalesced_mmio_init()
for the moment).  x86 is the only non-nop implementation of the post-init
hook, and it doesn't allocate/initialize any objects that are reachable
via debugfs code (spawns a kthread worker for the NX huge page mitigation).

Leave the buggy try_get_module() alone for now, it will be fixed in a
separate commit.

Fixes: b74ed7a68ec1 ("KVM: Actually create debugfs in kvm_create_vm()")
Reported-by: syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com
Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 515dfe9d3bcf..ee5f48cc100b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1211,9 +1211,13 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_mmu_notifier;
 
+	r = kvm_create_vm_debugfs(kvm, fdname);
+	if (r)
+		goto out_err_no_debugfs;
+
 	r = kvm_arch_post_init_vm(kvm);
 	if (r)
-		goto out_err_mmu_notifier;
+		goto out_err;
 
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
@@ -1229,18 +1233,14 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	 */
 	if (!try_module_get(kvm_chardev_ops.owner)) {
 		r = -ENODEV;
-		goto out_err_mmu_notifier;
-	}
-
-	r = kvm_create_vm_debugfs(kvm, fdname);
-	if (r)
 		goto out_err;
+	}
 
 	return kvm;
 
 out_err:
-	module_put(kvm_chardev_ops.owner);
-out_err_mmu_notifier:
+	kvm_destroy_vm_debugfs(kvm);
+out_err_no_debugfs:
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	if (kvm->mmu_notifier.ops)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
-- 
2.37.1.595.g718a3a8f04-goog

