Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6388C44815
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404611AbfFMREH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40410 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404587AbfFMREG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so21600051wre.7;
        Thu, 13 Jun 2019 10:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9yV6J7ifAff8sWvhUN35A0JwiLFUyPYJf7ITEUIAEwY=;
        b=XcXPi//KbdBrUANkJJ839VnUYpRtH6R60bRuX+VZF3do4Z2nJOvmZLktvhHnGgI1Cl
         RcJmnNm+KTAAUmBNetFr5nLpIXPIGJ7cFVvLeM4xKoZSqO1FI/4myUWYrWq/dZnCb93c
         ftRKTxUoAL1FeGsTkZqLpoYwg3h6hturfqbZ0dvH6kVxMzz2ua1Hx4AgYmHgfRlmk9Lf
         tkllHjdMFinG14GumL5bwYh1LmP0feQQ0tXTiEk47oDe6upevUf5cS2po86bF+5ZLZNc
         fVg8sutV7HWUbjStTYYumzMXqaZpLDQGbi9MpueK1T69rZzsZ8K70uzGeXF1TmgIRPCp
         3jhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=9yV6J7ifAff8sWvhUN35A0JwiLFUyPYJf7ITEUIAEwY=;
        b=fa67IHZPQxraItY9VQ0kGN0xgTA80Wfe2ySXSvfEkDRyKvTeFTohMi2Z9kxKmdmBQA
         Jvc1QMFhi2Asrqe5UmhyVFLWui/xXLKon+/21moFji1H7+8auDTBp/CnqzqS/UiNRqHn
         rCXeJwqFJ2yavWSpV47yZ+iRz8JVG1OPhClqQsrljAJ+j65UYGWi40IPmkJohWVEHta1
         bpFgfZornIVGeDaNjzOuY1V/ohS5/R5Pl+GNvTW7FOotzbHj8149c9knSElfZ6/IRskz
         izAjPAeiJrz3p1dW7drkjPCxcqcD6PWqSMtRRV1cBppqR+vnJyF7lVv7gIbO5zWcwqkT
         jD/w==
X-Gm-Message-State: APjAAAVekS8ajhQAEWhr6isdIpZHNbde8rWzRna9TE53F3tn63zHGd9s
        D/RjILfG1el0bbnquKG2jQvyw/s1
X-Google-Smtp-Source: APXvYqzTv5lKKWnyD2CHpXvxDr9rukfvyo7jfaRY6n1f3tIgwX9edkVd/dB6Ujuu1zNBb2ZIp8cwrQ==
X-Received: by 2002:a5d:4841:: with SMTP id n1mr2133314wrs.320.1560445443889;
        Thu, 13 Jun 2019 10:04:03 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:03 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 31/43] KVM: nVMX: Use adjusted pin controls for vmcs02
Date:   Thu, 13 Jun 2019 19:03:17 +0200
Message-Id: <1560445409-17363-32-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

KVM provides a module parameter to allow disabling virtual NMI support
to simplify testing (hardware *without* virtual NMI support is hard to
come by but it does have users).  When preparing vmcs02, use the accessor
for pin controls to ensure that the module param is respected for nested
guests.

Opportunistically swap the order of applying L0's and L1's pin controls
to better align with other controls and to prepare for a future patche
that will ignore L1's, but not L0's, preemption timer flag.

Fixes: d02fcf50779ec ("kvm: vmx: Allow disabling virtual NMI support")
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 5 ++---
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 1 +
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1b42bd0bf354..f5612b475393 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2013,10 +2013,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	/*
 	 * PIN CONTROLS
 	 */
-	exec_control = vmcs12->pin_based_vm_exec_control;
-
+	exec_control = vmx_pin_based_exec_ctrl(vmx);
+	exec_control |= vmcs12->pin_based_vm_exec_control;
 	/* Preemption timer setting is computed directly in vmx_vcpu_run.  */
-	exec_control |= vmcs_config.pin_based_exec_ctrl;
 	exec_control &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
 	vmx->loaded_vmcs->hv_timer_armed = false;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ede565bec19e..91e43c03144d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3825,7 +3825,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
 }
 
-static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
+u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 {
 	u32 pin_based_exec_ctrl = vmcs_config.pin_based_exec_ctrl;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 36a2056fafd4..136f22f2e797 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -480,6 +480,7 @@ static inline u32 vmx_vmexit_ctrl(void)
 }
 
 u32 vmx_exec_control(struct vcpu_vmx *vmx);
+u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx);
 
 static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
-- 
1.8.3.1


