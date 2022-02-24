Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4474C37BE
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 22:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbiBXV17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 16:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbiBXV1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 16:27:36 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8EF5DA73
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 13:26:49 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id f2-20020a17090a4a8200b001b7dac53bd6so1811273pjh.4
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 13:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=LYW4tNkSjo8Kza5Anc4vEfQiliyM+KZge7Rmu6VCVnE=;
        b=nvJroVS5w4YiBdoajw4bTdlmRcmJOcYL7hlW2pw5ntI2yuD5N9Ne3w/gdgRr8o3aE+
         avlAmiyPUzVZ4c0Gc5Rtd8r8cTZsSu4CycPsEo/qOtxh16hmqeXEFlJaJkgEC9xY8jx3
         HfDERmfIugyXppTnzHxT6Odb8TGv6c5lmKtG9GdfIw6+bT/C8r0rHCjFka9SKd/wCSv6
         mDQfBi2IqFZgBeuXQ+Jsm9eoWpjOEGzkc5nLxsFnR3JsQlniMyCweHPrcVE9k2Jy895A
         wZSet1mYnEpr9EyUc3Xs8zLHiqVEr7WgMJqVLzQG1DVwBjzHPTsGs2F9GlX2J40RCHzP
         z2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=LYW4tNkSjo8Kza5Anc4vEfQiliyM+KZge7Rmu6VCVnE=;
        b=m8Rx9euIXp3dJTg3oVvypNPjTgG3JkSdauPtOCBHDWTiOOBkU8MZtRYqfdWtzCzhFJ
         UGiBapSy7PM6VKmCqdoHe48gjPZsPm+wXIu8dlbScGQzfvFjB59ZE2DenuNPG2t5G3l3
         yeAnP3I+W+eRxZA8os+dltqjUZ3xR6z3SRQdFa1kmks7S2vvzEJJ8YA5f4jIBP0i6562
         p6fHfde3fAj5nch8LjKQMaeJqG2IXIYcl6OZKMYwYOBdVjn9WHbajGitG6hQfqn4I5Zu
         +X4CzCtvLfGHwMs4P4toJWk5lqfStyme35LII+Y/iAQVmXTNupx0d5x3emcuYLbIYQcL
         Gjsw==
X-Gm-Message-State: AOAM531RZszG8Ao+CbsG4Tl9KluWPiJjNX7PSOtnZjLyoLm+5781F5Jy
        5ZXfd8rDAApdQknjBJL324gXkOGP4UY=
X-Google-Smtp-Source: ABdhPJzPDQZXA1odOppqUTuAknQnuT64yHKJ4XrZyfWr2ZIkun1193cHSK8wONvU1q0CgVJHzHLVrWzU6Zo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:244d:b0:4e0:1f65:d5da with SMTP id
 d13-20020a056a00244d00b004e01f65d5damr4426131pfj.6.1645738008579; Thu, 24 Feb
 2022 13:26:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Feb 2022 21:26:46 +0000
Message-Id: <20220224212646.3544811-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH] KVM: x86: Temporarily drop kvm->srcu when uninitialized vCPU
 is blocking
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Temporarily drop kvm->srcu before invoking kvm_vcpu_block() on a vCPU
that hasn't yet been initialized.  Best case scenario, blocking while
holding kvm->srcu will degrade guest performance.  Worst case scenario,
the vCPU will never get a wake event and the VM's tasks will hang
indefinitely on synchronize_srcu(), e.g. when trying update memslots.

E.g. running the "apic" KVM unit test often results in the test hanging

  ==> 6409/stack <==
  [<0>] __synchronize_srcu.part.0+0x7a/0xa0
  [<0>] kvm_swap_active_memslots+0x141/0x180
  [<0>] kvm_set_memslot+0x2f9/0x470
  [<0>] kvm_set_memory_region+0x29/0x40
  [<0>] kvm_vm_ioctl+0x2c3/0xd70
  [<0>] __x64_sys_ioctl+0x83/0xb0
  [<0>] do_syscall_64+0x3b/0xc0
  [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

  ==> 6410/stack <==
  [<0>] kvm_vcpu_block+0x36/0x80
  [<0>] kvm_arch_vcpu_ioctl_run+0x17b1/0x1f50
  [<0>] kvm_vcpu_ioctl+0x279/0x690
  [<0>] __x64_sys_ioctl+0x83/0xb0
  [<0>] do_syscall_64+0x3b/0xc0
  [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

While it's tempting to never acquire kvm->srcu for an uninitialized vCPU,
practically speaking there's no penalty to acquiring kvm->srcu "early"
as the KVM_MP_STATE_UNINITIALIZED path is a one-time thing per vCPU.  On
the other hand, seemingly innocuous helpers like kvm_apic_accept_events()
and sync_regs() can theoretically reach code that might access
SRCU-protected data structures, e.g. sync_regs() can trigger forced
existing of nested mode via kvm_vcpu_ioctl_x86_set_vcpu_events().

Fixes: 5d8d2bfc5e65 ("KVM: x86: pull kvm->srcu read-side to kvm_arch_vcpu_ioctl_run")
Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e55de9b48d1a..8fd60887f38d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10411,7 +10411,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * use before KVM has ever run the vCPU.
 		 */
 		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
+
+		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 		kvm_vcpu_block(vcpu);
+		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
+
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
 			goto out;

base-commit: 991f988b43c5ee82ef681907bfe979bee93a55c2
-- 
2.35.1.574.g5d30c73bfb-goog

