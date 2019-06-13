Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBA044867
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393289AbfFMRDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:03:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36696 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbfFMRDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so21629200wrs.3;
        Thu, 13 Jun 2019 10:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HxGWvvkcjHZyUe+PK8/i3cEvG07jumxhELUvt9aNYAI=;
        b=WdLrHOMhoartmEAYdPzp9AU9A6dUM6GI8jCdiAEEcjzPqXzBzCoFpDQYA8j9m7hQHV
         l+vvihF+DSCc0h/LCgbZ2Xf38rpWpmidv/Vfwjh8Q4ZqDaseq02+B7G3OQESAz/Zuvxe
         bH814uIdijOsQ/PMqG19jaojmMYruj2iMO5M5QqZf3BauO5Q4BgwEmAFzRZZZAJDWa82
         hnnsFURXVSCnXWpuKLspbaP1r+m2PGydxpdOxleDe32w/J6G4MYeqTQTWyK3YOP6jafF
         hgu4iT0m03nJ9XoXJnZXRj8gw/2gdiAJKAxwLRyQkoZyJPefW6j8w7oClVAj+4rrx3Gh
         kWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=HxGWvvkcjHZyUe+PK8/i3cEvG07jumxhELUvt9aNYAI=;
        b=nyLh94EPpVTFpcDTzaQois1oPaTicsUTo7gHMYcAlZcXsglStE12SS1oZV6cITYx2g
         dxf/AhYQWDqhmNH0PSoSynXvn29fLdfo3YHK6q7OtqH2dIJMYdd9eKxk1nXXL/49GRmQ
         SPPEudo4Xoy9yr5awTWLY1a4Mpv8gmyIREUJGA4KWXm6gmGGw7KCykIhC7bpqbXL6ZPZ
         PLOZcGHcG3LiNgVBPCe4FBinytESlYUDXMMTY1GQLiSibKNQkzLSStJKYuj6hN7hIJYr
         aWuMbu/u2ynHcI8dCKm6kRBy5U0YbQP7R2/s+rbzWH9CHaus94kJrruHdoTMmW+58TOH
         j1AQ==
X-Gm-Message-State: APjAAAXC3qQkH7PpkVSeWIu689lgyUkBbfRCwKCXn4JipDqCia+nE4jC
        KXmpJ8ou/AUiA4ncBZfN9ikKqdfd
X-Google-Smtp-Source: APXvYqzhiso8yN6Srr+T7nOtfYB4w1CdiB/mEAKepa/FoKr6hC0RJ0zosW72xi2uv92Wjet1QEte3w==
X-Received: by 2002:adf:ce03:: with SMTP id p3mr33867177wrn.94.1560445415725;
        Thu, 13 Jun 2019 10:03:35 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:35 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 05/43] KVM: x86: Move kvm_{before,after}_interrupt() calls to vendor code
Date:   Thu, 13 Jun 2019 19:02:51 +0200
Message-Id: <1560445409-17363-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

VMX can conditionally call kvm_{before,after}_interrupt() since KVM
always uses "ack interrupt on exit" and therefore explicitly handles
interrupts as opposed to blindly enabling irqs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c     | 2 ++
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 arch/x86/kvm/x86.c     | 2 --
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 302cb409d452..acc09e9fc173 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6174,6 +6174,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 
 static void svm_handle_external_intr(struct kvm_vcpu *vcpu)
 {
+	kvm_before_interrupt(vcpu);
 	local_irq_enable();
 	/*
 	 * We must have an instruction with interrupts enabled, so
@@ -6181,6 +6182,7 @@ static void svm_handle_external_intr(struct kvm_vcpu *vcpu)
 	 */
 	asm("nop");
 	local_irq_disable();
+	kvm_after_interrupt(vcpu);
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c90abf33b509..963c8c409223 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6145,6 +6145,8 @@ static void vmx_handle_external_intr(struct kvm_vcpu *vcpu)
 	desc = (gate_desc *)host_idt_base + vector;
 	entry = gate_offset(desc);
 
+	kvm_before_interrupt(vcpu);
+
 	asm volatile(
 #ifdef CONFIG_X86_64
 		"mov %%" _ASM_SP ", %[sp]\n\t"
@@ -6165,6 +6167,8 @@ static void vmx_handle_external_intr(struct kvm_vcpu *vcpu)
 		[ss]"i"(__KERNEL_DS),
 		[cs]"i"(__KERNEL_CS)
 	);
+
+	kvm_after_interrupt(vcpu);
 }
 STACK_FRAME_NON_STANDARD(vmx_handle_external_intr);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ec87ded17db..6e2f53cd8ea8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7999,9 +7999,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_before_interrupt(vcpu);
 	kvm_x86_ops->handle_external_intr(vcpu);
-	kvm_after_interrupt(vcpu);
 
 	++vcpu->stat.exits;
 
-- 
1.8.3.1


