Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1DA50337E
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiDPDpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 23:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiDPDpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 23:45:31 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44D7A996C
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:43:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id bf10-20020a656d0a000000b0039d4f854e22so4947165pgb.5
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=caqu0al6aFmQHXaPlReX326/jFRGqosx2auDWDfhBPQ=;
        b=SwKv8s/c28NnnnbLE/cbqmbLUPgd8fpbH5uKyMCuZB6jBUzNdjU5Y7JqrPWdPom3W3
         dRe+5mqjucysqxNnPB8xVHTBekr25NSePYB2y1GgxF5lmnaSmmfTIxNcQXyRPo68hOB0
         8T3xf/m+thy6eprcBYl/y+elw1abR6YTvqx8pi/zGLHfJnjPJkxgvN1IIWcLGLaL0d8c
         pnPNGCNGPTbUEBRqpwZ7eMQd3LvBsH+aR4/GRjVG/HedLCVnj5L7CTH0akGACovLWUM8
         LmdGex+yz3gTbS0KFZLJt5mlcQbBhnOT6wFzLvO9S/DgEdYaliuwTtHwEmtEmDvOxngN
         lTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=caqu0al6aFmQHXaPlReX326/jFRGqosx2auDWDfhBPQ=;
        b=PN/aSfa8OcDQcVSOBHrwccrOXO9Gaac++0H8WZWwN1IZEUh4270dOnMQvdRU21Z2iJ
         ckZsgO7XlkbD6LEm1AuL4i8oICSKkucjkR/+i5ue7T/FEDMrBgi95I2dAugoIygYFvnL
         l5SCNgi5AMSR9Z6fKcvLcqFY8TCKewTUgx9VLSxBR19Ks7q/4ZEICDpCtVvWThmz+MJs
         E8Cfgz4uckfAwVqWBIYHPNj7/jeHLICxZWP7Tp2kkRAh4EQyr+rzNwOAlNdImkVn3tpG
         wr+hWrzsTq/Vgf58OyBgWwPXeCuFPMrKL5WL2dDfMfB3uGcGmsTF+WcvF9yeJTuTM5yx
         MqLg==
X-Gm-Message-State: AOAM531x5SjpiOucb2qmCSsXQ3Cw1owk3dZ9wangBN1WtQ/zQo0m8ljV
        ogNLFgi3lRe93bmdsG3aegSfTVLOC3Y=
X-Google-Smtp-Source: ABdhPJyHsbFf+EH9ItsYl+BgL1VUszDxaKAtCuTyWv0tlQVgPpMhvXVRP0ykF9P9wQNkqSyzMEbix9lcVkw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74d:b0:156:9d3c:4271 with SMTP id
 p13-20020a170902e74d00b001569d3c4271mr1691164plf.79.1650080580330; Fri, 15
 Apr 2022 20:43:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 16 Apr 2022 03:42:48 +0000
In-Reply-To: <20220416034249.2609491-1-seanjc@google.com>
Message-Id: <20220416034249.2609491-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220416034249.2609491-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 3/4] KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU creation
 to fix a race
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>,
        Maxim Levitsky <mlevitsk@redhat.com>
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

Make a KVM_REQ_APICV_UPDATE request when creating a vCPU with an
in-kernel local APIC and APICv enabled at the module level.  Consuming
kvm_apicv_activated() and stuffing vcpu->arch.apicv_active directly can
race with __kvm_set_or_clear_apicv_inhibit(), as vCPU creation happens
before the vCPU is fully onlined, i.e. it won't get the request made to
"all" vCPUs.  If APICv is globally inhibited between setting apicv_active
and onlining the vCPU, the vCPU will end up running with APICv enabled
and trigger KVM's sanity check.

Mark APICv as active during vCPU creation if APICv is enabled at the
module level, both to be optimistic about it's final state, e.g. to avoid
additional VMWRITEs on VMX, and because there are likely bugs lurking
since KVM checks apicv_active in multiple vCPU creation paths.  While
keeping the current behavior of consuming kvm_apicv_activated() is
arguably safer from a regression perspective, force apicv_active so that
vCPU creation runs with deterministic state and so that if there are bugs,
they are found sooner than later, i.e. not when some crazy race condition
is hit.

  WARNING: CPU: 0 PID: 484 at arch/x86/kvm/x86.c:9877 vcpu_enter_guest+0x2ae3/0x3ee0 arch/x86/kvm/x86.c:9877
  Modules linked in:
  CPU: 0 PID: 484 Comm: syz-executor361 Not tainted 5.16.13 #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1~cloud0 04/01/2014
  RIP: 0010:vcpu_enter_guest+0x2ae3/0x3ee0 arch/x86/kvm/x86.c:9877
  Call Trace:
   <TASK>
   vcpu_run arch/x86/kvm/x86.c:10039 [inline]
   kvm_arch_vcpu_ioctl_run+0x337/0x15e0 arch/x86/kvm/x86.c:10234
   kvm_vcpu_ioctl+0x4d2/0xc80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3727
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:874 [inline]
   __se_sys_ioctl fs/ioctl.c:860 [inline]
   __x64_sys_ioctl+0x16d/0x1d0 fs/ioctl.c:860
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

The bug was hit by a syzkaller spamming VM creation with 2 vCPUs and a
call to KVM_SET_GUEST_DEBUG.

  r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x0, 0x0)
  r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
  ioctl$KVM_CAP_SPLIT_IRQCHIP(r1, 0x4068aea3, &(0x7f0000000000)) (async)
  r2 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0) (async)
  r3 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x400000000000002)
  ioctl$KVM_SET_GUEST_DEBUG(r3, 0x4048ae9b, &(0x7f00000000c0)={0x5dda9c14aa95f5c5})
  ioctl$KVM_RUN(r2, 0xae80, 0x0)

Reported-by: Gaoning Pan <pgn@zju.edu.cn>
Reported-by: Yongkang Jia <kangel@zju.edu.cn>
Fixes: 8df14af42f00 ("kvm: x86: Add support for dynamic APICv activation")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 753296902535..09a270cc1c8f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11259,8 +11259,21 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
-		if (kvm_apicv_activated(vcpu->kvm))
+
+		/*
+		 * Defer evaluating inhibits until the vCPU is first run, as
+		 * this vCPU will not get notified of any changes until this
+		 * vCPU is visible to other vCPUs (marked online and added to
+		 * the set of vCPUs).  Opportunistically mark APICv active as
+		 * VMX in particularly is highly unlikely to have inhibits.
+		 * Ignore the current per-VM APICv state so that vCPU creation
+		 * is guaranteed to run with a deterministic value, the request
+		 * will ensure the vCPU gets the correct state before VM-Entry.
+		 */
+		if (enable_apicv) {
 			vcpu->arch.apicv_active = true;
+			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+		}
 	} else
 		static_branch_inc(&kvm_has_noapic_vcpu);
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

