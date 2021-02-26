Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19610325E91
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 09:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhBZIBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 03:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhBZIAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 03:00:50 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C028C06174A;
        Fri, 26 Feb 2021 00:00:10 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id j24so5744922pfi.2;
        Fri, 26 Feb 2021 00:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SGKC+JVft3JHE0DGY/zfVH90D0jA8OCfIOyzcJ20Wcc=;
        b=XffIAJbzfF4FyjDlJxNDHc5mU8K/77RZLqJY5xBu0uRny+QbYcdpYFDPREhFxOlqix
         lrGIs9z2Y2XGFmY6pm7B9DKLyHjhLkZTRFW/wwFhQIrcuAZT6mW0O7jYWZOIB9acIbhw
         9xxaiFwOG7UgnRoSU5z3nCsTGLdKJlPdgYMeLg7OE1fAh+xw/iLBKELLpcPM2i0JfSQY
         UhZzSfahv/u/+IXT2AVo4DwVQ0V5Xyl3kvqIV7wex8wLiI0TfAZfp8V4X3/6qk3pOpOK
         IpyvdF87hkmFEKDg5oUm4Th4TZ4uNgSYlLdTCSOCFCZgzL/knheRrii92UXoBIcoCwrL
         Mfcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SGKC+JVft3JHE0DGY/zfVH90D0jA8OCfIOyzcJ20Wcc=;
        b=aTn5ca/Oh7muRoFzdWffcev9wcBBJwJdtWhxcqAkQbsymNxg0m27aeUavRYJfmPZd7
         wQcmg8VtHxpYUqw1nBXzlEJlmpodwuSdm57R5ObC6E8v4lw6R1etIiwUOUQpb1tImZlB
         WN1PHOPKLcwyQPcXFH5JUFuaziJx4cWAhPHlxuvypiZWJ7iCGdemfVJf6wCf+GoZAUSO
         T4Q3ao53/t8OotikLTzgSx52GjcMoCPn2TLGrnIyiYrS2zoMfj5CDGlOHhziQY3ZmsR4
         EkB7j4dXaS1HAqKRo/jVgKV2mv/q+ujN+bRsveKH2qGO4T2Ld460aAy1Q+oIEwZucatz
         QEBw==
X-Gm-Message-State: AOAM533TyF6yxy49uXEbGErwLc6SpEo0vFFJVZigvZ6sgs4erqMa5hTf
        rteIlZshMCIyTv3XsFygKi/taxBlheXhcw==
X-Google-Smtp-Source: ABdhPJxawGKZ4ZgAsRE/UqeSM6fJzqrwWfMq6XhqheJIZuUgfWr+DWX8mVWgINCwXXDMPA8ZxrbQPw==
X-Received: by 2002:a63:dd49:: with SMTP id g9mr1900154pgj.175.1614326409597;
        Fri, 26 Feb 2021 00:00:09 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id b18sm8785961pfi.173.2021.02.26.00.00.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Feb 2021 00:00:09 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: x86: hyper-v: Fix Hyper-V context null-ptr-deref
Date:   Fri, 26 Feb 2021 15:59:59 +0800
Message-Id: <1614326399-5762-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reported by syzkaller:

    KASAN: null-ptr-deref in range [0x0000000000000140-0x0000000000000147]
    CPU: 1 PID: 8370 Comm: syz-executor859 Not tainted 5.11.0-syzkaller #0
    RIP: 0010:synic_get arch/x86/kvm/hyperv.c:165 [inline]
    RIP: 0010:kvm_hv_set_sint_gsi arch/x86/kvm/hyperv.c:475 [inline]
    RIP: 0010:kvm_hv_irq_routing_update+0x230/0x460 arch/x86/kvm/hyperv.c:498
    Call Trace:
     kvm_set_irq_routing+0x69b/0x940 arch/x86/kvm/../../../virt/kvm/irqchip.c:223
     kvm_vm_ioctl+0x12d0/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3959
     vfs_ioctl fs/ioctl.c:48 [inline]
     __do_sys_ioctl fs/ioctl.c:753 [inline]
     __se_sys_ioctl fs/ioctl.c:739 [inline]
     __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
     do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
     entry_SYSCALL_64_after_hwframe+0x44/0xae

Hyper-V context is lazily allocated until Hyper-V specific MSRs are accessed 
or SynIC is enabled. However, the syzkaller testcase sets irq routing table 
directly w/o enabling SynIC. This results in null-ptr-deref when accessing 
SynIC Hyper-V context. This patch fixes it.
     
syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=163342ccd00000

Reported-by: syzbot+6987f3b2dbd9eda95f12@syzkaller.appspotmail.com
Fixes: 8f014550dfb1 ("KVM: x86: hyper-v: Make Hyper-V emulation enablement conditional")
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 7d2dae9..58fa8c0 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -159,7 +159,7 @@ static struct kvm_vcpu_hv_synic *synic_get(struct kvm *kvm, u32 vpidx)
 	struct kvm_vcpu_hv_synic *synic;
 
 	vcpu = get_vcpu_by_vpidx(kvm, vpidx);
-	if (!vcpu)
+	if (!vcpu || !to_hv_vcpu(vcpu))
 		return NULL;
 	synic = to_hv_synic(vcpu);
 	return (synic->active) ? synic : NULL;
-- 
2.7.4

