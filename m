Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F0A50C662
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiDWCRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiDWCRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:13 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED3121A671
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:16 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i69-20020a636d48000000b003aa4ae583bcso5960575pgc.14
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4V4fYOOx19aLgtO3bZkAZcLhXo54aE7TN/hmI1hVjK0=;
        b=fxN5sEadn4wpsVuyRDEN1xnjtYATl9Jnlz1X/u04pUWGdAY7yRwdXgWYouii6v/Ynh
         0L0GDMLYsS7xNqWEudFlq/aNhrB4XVYfEICu7PnqkeRyXItjj/rELzxkxwvDiC4EuD10
         SkQcdHOLprj8bmaFKELTi7uxOvKfbe+48AJ/ux7HSl2f7pvIIH4YxfhT98DB0t2+jRVU
         EH/CzjKSbZQwiCQzcSHbYUlGb8QpHPBr/JCLqTn8O4qLIVCKMYm/O3o462bqzh5H8gSJ
         boAtGxiSCbxfcGn0d9Zf2OWpNZR/qCbo2eWlUQNgZLYUH8yuOHOZCecEFgViDq6nI5Fh
         vPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4V4fYOOx19aLgtO3bZkAZcLhXo54aE7TN/hmI1hVjK0=;
        b=6GPnwnueKIozkX7Ig3r5HgD3bMnqkrA9a/Y6PVihka/OfNLzAnRWqV9FomE+jD9RS9
         yf5bJw/nmQWHGnR6R5AwQjW583WEjLKHaZ+8zjl5lDKpuAnKidIG25uaezOMXNOrh3dB
         cjfEgMWwPoFKl7kOzmNVNR8vzpARxQZQ9arlmkSlUW2C/fsKeHSDngpWTHJgpVQeXWmX
         taTMYMcOr/glZsqGh0+GJoC+hrcWnV17gHg8C4tDYj2m8qCzGPFpH0fPIAYGLq58PrFN
         ZbDIDbXJqblBp8amVwpdVjP5gBkrKl1KmdLSe8sb7yq9WjifxpL0HxGhq+DbvgPKHW0b
         I3Cw==
X-Gm-Message-State: AOAM533oAJy68tmINotP7fXfz0bE13FVnqBu9I1C9rHUZ/1DQvi243Qq
        toKFZ0voM6KQWiDA1EbfMMfIDwGioqA=
X-Google-Smtp-Source: ABdhPJzQ/xbiIP/rNdWA1KVR1iUlC6bHzhLcVP7dnu4Hsyaxr1/n90CtPDb8g5YEeO16z5rt0uFKMql6qFg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8a92:b0:1d7:3cca:69d8 with SMTP id
 x18-20020a17090a8a9200b001d73cca69d8mr10179857pjn.61.1650680056056; Fri, 22
 Apr 2022 19:14:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:02 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 02/11] KVM: SVM: Don't BUG if userspace injects a soft
 interrupt with GIF=0
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Don't BUG/WARN on interrupt injection due to GIF being cleared if the
injected event is a soft interrupt, which are not actually IRQs and thus
not subject to IRQ blocking conditions.  KVM doesn't currently use event
injection to handle incomplete soft interrupts, but it's trivial for
userspace to force the situation via KVM_SET_VCPU_EVENTS.

Opportunistically downgrade the BUG_ON() to WARN_ON(), there's no need to
bring down the whole host just because there might be some issue with
respect to guest GIF handling in KVM, or as evidenced here, an egregious
oversight with respect to KVM's uAPI.

  kernel BUG at arch/x86/kvm/svm/svm.c:3386!
  invalid opcode: 0000 [#1] SMP
  CPU: 15 PID: 926 Comm: smm_test Not tainted 5.17.0-rc3+ #264
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:svm_inject_irq+0xab/0xb0 [kvm_amd]
  Code: <0f> 0b 0f 1f 00 0f 1f 44 00 00 80 3d ac b3 01 00 00 55 48 89 f5 53
  RSP: 0018:ffffc90000b37d88 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff88810a234ac0 RCX: 0000000000000006
  RDX: 0000000000000000 RSI: ffffc90000b37df7 RDI: ffff88810a234ac0
  RBP: ffffc90000b37df7 R08: ffff88810a1fa410 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
  R13: ffff888109571000 R14: ffff88810a234ac0 R15: 0000000000000000
  FS:  0000000001821380(0000) GS:ffff88846fdc0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f74fc550008 CR3: 000000010a6fe000 CR4: 0000000000350ea0
  Call Trace:
   <TASK>
   inject_pending_event+0x2f7/0x4c0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x791/0x17a0 [kvm]
   kvm_vcpu_ioctl+0x26d/0x650 [kvm]
   __x64_sys_ioctl+0x82/0xb0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

Fixes: 219b65dcf6c0 ("KVM: SVM: Improve nested interrupt injection")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 75b4f3ac8b1a..151fba0b405f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3384,7 +3384,7 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	BUG_ON(!(gif_set(svm)));
+	WARN_ON(!vcpu->arch.interrupt.soft && !gif_set(svm));
 
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
 	++vcpu->stat.irq_injections;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

