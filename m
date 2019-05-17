Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEEAC215AD
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 10:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfEQIuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 04:50:04 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35523 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbfEQIuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 04:50:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id g5so3056594plt.2;
        Fri, 17 May 2019 01:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LXdojfs9tV6rnZ/fXmeiGAyGOFlNjDR2xUpvGACHON0=;
        b=EG+mPKckPfuZ2vfk8a6ttfLtJ+/laZpt7eB1TWVIm2VkpYk/ukPr+nsXXk5elLZlMD
         NV8i3ZybA4tKsIYD23t+H9z5McPcNQalHXvM/Zc359jp6nH5dT/VjUw1CiLzrKM+v62I
         zeLFcywisHAc+lMh+j3VbDjV9/LMkepD6ezDp4BJNGKjevFijsZdiYbGc9zDlwIV8qVE
         uFWxP5l27aXZgURttQRNn2O9SyabMmKmNgN4iZUuvlcM4HTklAvI5pphFEoWo//wN/0w
         hGEAoOEG+t8HaTOWTQ94DieJcjffwOkfIXVv8stpZjysMiPcpsy9S82sNZghzQuE3Ubx
         OS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LXdojfs9tV6rnZ/fXmeiGAyGOFlNjDR2xUpvGACHON0=;
        b=PnsEBpe27t6m4Q51otH5El4u5vDZbOWQD8dFbWiGLOeE3lUNlmuiSpBGqzvYQmlaNA
         c8X5HZDPLRM2vCR0PkEkrMiZf5ML3k183FKKL2JNSVK3AoiRMRY6oyqSeM6QXCrzioQi
         IRraLjgO/J805rNNOFVQWm2hlrx6s5DsjQTd8hg/vnMSklAGm2J2/EWJ8kMj4ARDzfEg
         EmhwpXkQ+H0SQlWahPO3ByiXfX/4a6NlTccDVQMsF0HxIlp4/E+puEz+m6xhzQRJPsQO
         1uYJke61LN2+f9c5iilN6WlwssifCFwWPqj+gYRWYlajtfd41CnFGIGMAIUio5rT3THW
         mRig==
X-Gm-Message-State: APjAAAUHUXtY9BlJcT8qVDNExrBOo6bBbZhdwf/fe6tvINuLn9ZwnRFT
        NRJhMyB+AO4Z1k+trDqJipnjhPws
X-Google-Smtp-Source: APXvYqx6UZmeM1Meepadf6z2mpg8VSstpYtAyfG5btHRv7xogLmK8f4zFUKNMaJW9hanOFnKfnyYuQ==
X-Received: by 2002:a17:902:b492:: with SMTP id y18mr50545153plr.96.1558083001916;
        Fri, 17 May 2019 01:50:01 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 63sm10417127pfu.95.2019.05.17.01.50.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 17 May 2019 01:50:01 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 4/4] KVM: nVMX: Fix using __this_cpu_read() in preemptible context
Date:   Fri, 17 May 2019 16:49:50 +0800
Message-Id: <1558082990-7822-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
References: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

 BUG: using __this_cpu_read() in preemptible [00000000] code: qemu-system-x86/4590
  caller is nested_vmx_enter_non_root_mode+0xebd/0x1790 [kvm_intel]
  CPU: 4 PID: 4590 Comm: qemu-system-x86 Tainted: G           OE     5.1.0-rc4+ #1
  Call Trace:
   dump_stack+0x67/0x95
   __this_cpu_preempt_check+0xd2/0xe0
   nested_vmx_enter_non_root_mode+0xebd/0x1790 [kvm_intel]
   nested_vmx_run+0xda/0x2b0 [kvm_intel]
   handle_vmlaunch+0x13/0x20 [kvm_intel]
   vmx_handle_exit+0xbd/0x660 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0xa2c/0x1e50 [kvm]
   kvm_vcpu_ioctl+0x3ad/0x6d0 [kvm]
   do_vfs_ioctl+0xa5/0x6e0
   ksys_ioctl+0x6d/0x80
   __x64_sys_ioctl+0x1a/0x20
   do_syscall_64+0x6f/0x6c0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Accessing per-cpu variable should disable preemption, this patch extends the 
preemption disable region for __this_cpu_read().

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c601d0..8f6f69c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2792,14 +2792,13 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	      : "cc", "memory"
 	);
 
-	preempt_enable();
-
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	if (vmx->msr_autoload.guest.nr)
 		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
 	if (vm_fail) {
+		preempt_enable();
 		WARN_ON_ONCE(vmcs_read32(VM_INSTRUCTION_ERROR) !=
 			     VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 		return 1;
@@ -2811,6 +2810,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 	if (hw_breakpoint_active())
 		set_debugreg(__this_cpu_read(cpu_dr7), 7);
+	preempt_enable();
 
 	/*
 	 * A non-failing VMEntry means we somehow entered guest mode with
-- 
2.7.4

