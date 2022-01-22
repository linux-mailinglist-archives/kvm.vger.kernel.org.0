Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38884496947
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 02:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiAVBwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 20:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiAVBwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 20:52:16 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52602C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 17:52:15 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f18-20020a63dc52000000b0034d062c66a0so5461400pgj.17
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 17:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=z+3EWiN+IOa2yb8TQhQaeWhNbe8EUxoWdUuFJ8ZwbGs=;
        b=NaKcTihZ99kBInGtf3wfQbs8x/mgdqZ6UeRCa85pMtbgbH9h0AsGf7VHIkPCuVA43n
         QMWe71diKz3CfQrVlu/n21cyO6X8yo+3b3iXo7HCwHiUWXY8kJvQwrdwziVUkFn6CUAH
         w8qRIdv3qK8bHfIeOOuLVrUAdRabSurkJ4UviaEVSMwSb+xCuBaD1fvxrLdjx8zlj8kR
         thbyBooHecsMChdltRwHTL4N6ou+nX0mO2Rf23Fx3Xib7lg3Rg0+Ic45EhdeLadY7XHl
         3Y4Wmtn4szqIahkNkkIXsBUDP5dYarhjFFFVzIKmR2THHco9tnT41inmJGfe74YaFBMq
         +KYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=z+3EWiN+IOa2yb8TQhQaeWhNbe8EUxoWdUuFJ8ZwbGs=;
        b=3X6lXBAliGviRyDkEm9GcGzsm/6k9PF5HvCe8gbx5qVeRvUqZrn972YE3ltfzxCSf7
         Ay5W+FO1AKIcH3NDyYeSyvmwTrHtln8eS36g5gVNnKmrnLp2D+jzrwlC/lNCLywL73CJ
         n4dBOHm4tP1iCdr8oFT13iOXgDAPwiPan4a+AB6ylQmMtl9AGDD+xzp2L8fvsY0JWuC4
         VYsNkln49yauY+xbjQPmQir7m1SpbSt5K+YUP/8VyRkA4kLujeD1dbZMT6fjGbf936s0
         0Xieojz4yuGlUh0jRXfvNz2wrktUAqdxavj7MyvhRKE8Eg/m0Q5rvzKrQDm4faGA0vZo
         sCxg==
X-Gm-Message-State: AOAM532ZhsIvs/HJNE7mk545mgSvepbXueux+fDdVz26MvcnkX6WWT/s
        9BMXsCfzus7L+scbAbpsXxXlJQ/mefg=
X-Google-Smtp-Source: ABdhPJxGjzzW6EvGfkNdQzYrixlt8QLnhmW3eK8m717GT5kCrjEBi4Xmt4tD+VoR75mMUBFDRhEmzbQZPOY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7786:: with SMTP id
 v6mr3308141pjk.11.1642816333665; Fri, 21 Jan 2022 17:52:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 22 Jan 2022 01:52:11 +0000
Message-Id: <20220122015211.1468758-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] KVM: VMX: Zero host's SYSENTER_ESP iff SYSENTER is NOT used
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zero vmcs.HOST_IA32_SYSENTER_ESP when initializing *constant* host state
if and only if SYSENTER cannot be used, i.e. the kernel is a 64-bit
kernel and is not emulating 32-bit syscalls.  As the name suggests,
vmx_set_constant_host_state() is intended for state that is *constant*.
When SYSENTER is used, SYSENTER_ESP isn't constant because stacks are
per-CPU, and the VMCS must be updated whenever the vCPU is migrated to a
new CPU.  The logic in vmx_vcpu_load_vmcs() doesn't differentiate between
"never loaded" and "loaded on a different CPU", i.e. setting SYSENTER_ESP
on VMCS load also handles setting correct host state when the VMCS is
first loaded.

Because a VMCS must be loaded before it is initialized during vCPU RESET,
zeroing the field in vmx_set_constant_host_state() obliterates the value
that was written when the VMCS was loaded.  If the vCPU is run before it
is migrated, the subsequent VM-Exit will zero out MSR_IA32_SYSENTER_ESP,
leading to a #DF on the next 32-bit syscall.

  double fault: 0000 [#1] SMP
  CPU: 0 PID: 990 Comm: stable Not tainted 5.16.0+ #97
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  EIP: entry_SYSENTER_32+0x0/0xe7
  Code: <9c> 50 eb 17 0f 20 d8 a9 00 10 00 00 74 0d 25 ff ef ff ff 0f 22 d8
  EAX: 000000a2 EBX: a8d1300c ECX: a8d13014 EDX: 00000000
  ESI: a8f87000 EDI: a8d13014 EBP: a8d12fc0 ESP: 00000000
  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00210093
  CR0: 80050033 CR2: fffffffc CR3: 02c3b000 CR4: 00152e90

Fixes: 6ab8a4053f71 ("KVM: VMX: Avoid to rdmsrl(MSR_IA32_SYSENTER_ESP)")
Cc: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a02a28ce7cc3..ce2aae12fcc5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4094,10 +4094,13 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	vmcs_write32(HOST_IA32_SYSENTER_CS, low32);
 
 	/*
-	 * If 32-bit syscall is enabled, vmx_vcpu_load_vcms rewrites
-	 * HOST_IA32_SYSENTER_ESP.
+	 * SYSENTER is used only for (emulating) 32-bit kernels, zero out
+	 * SYSENTER.ESP if it is NOT used.  When SYSENTER is used, the per-CPU
+	 * stack is set when the VMCS is loaded (and may already be set!).
 	 */
-	vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);
+	if (!IS_ENABLED(CONFIG_IA32_EMULATION) && !IS_ENABLED(CONFIG_X86_32))
+		vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);
+
 	rdmsrl(MSR_IA32_SYSENTER_EIP, tmpl);
 	vmcs_writel(HOST_IA32_SYSENTER_EIP, tmpl);   /* 22.2.3 */
 

base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
-- 
2.35.0.rc0.227.g00780c9af4-goog

