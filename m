Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6854D3F1F77
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 20:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhHSSA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 14:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhHSSAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 14:00:53 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ABFC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 11:00:16 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id y3-20020a17090a8b03b02901787416b139so3357906pjn.4
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 11:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fgj1be2lYTnEccMqJY8pfghLKR/GOjvNRFO7wD8waAU=;
        b=KP210tjAXleOG5PS8J/OAoKFw0ahf2SBXkvvBkc9GII9QUlC1mtbp7cNh4IB+zYOpV
         CrwAzP4cleLm6e/c8HgE36pd6IxhB3uZm52re+NDV9m2o3GAhrQQKZf6mX9iauR7YpZb
         OcqWn3xqiBdsLSMGr/1BjlPu7hUvPTHzvjOz3vn25o+OQkwxRCZOxDomHJkI5TVOGvaZ
         j71SB7MhsINd19vw4kWYChD3s42mfY8uVphU00sBuFPS5ceB48EOBZKiiAfJbbXoh+oO
         6dWMnL3IFhZo0YMvSAever8MBh+DJOA7UBbWRDUwLIqpWPfOW8nwmyG/yAcLgTQh1a/Z
         UVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fgj1be2lYTnEccMqJY8pfghLKR/GOjvNRFO7wD8waAU=;
        b=hflvTqg227eYpxn80+f3tOs4UnkFbWrPC66WQ88bP0IEjONI17RrUb6yo0JRMwIVEu
         Zgdb7D9cP495x5j6hMz10y3gSnhJbO1ZgAvK87KWz73A8nmJw6j9u7UjHs1zWJBEJc2x
         gcoxIzgIBruzjVgl+C9UWM5afxEvIA9CiRmSc5guHiEkvLn+zIGM3p4LAQDucnIDKtHr
         /EMiQVZxQPPfYCTYSjHE7hzEQTW1w3YY+AgAnm4YN0kYzoit5z8zrtPqgs0p1WcCeTah
         qIOX8AEOHt0df9pL9Gd2dC1YXsZE4iU1qYtocVswC2ndl2+dqLa2njHNI/ixYnqwvWYh
         fA7g==
X-Gm-Message-State: AOAM530AKyxg0bxJyPae4M6LOGaU5n31ptcRfVfMJtc0HOVW+Vtc0PS9
        YbUNGx3DnwKUqwdKIXxziMDCNMZYdaNX55dkY2w65LNMh8z/rLdjzwEOT2+QUV6gmvkNQL/py4D
        NTSDHmw/icJe7vcLtTMZcXRyqOR6FbJN7f+OXajnzJz+Gn/CC4vgBVOoNB2nl/NDvpv3oJF4=
X-Google-Smtp-Source: ABdhPJyLPY8kYCJ6cqRGpdJWkQLiz68+H+gVdl/Yp6cxugMpjO/U1UluVKx90qjnprP+4cuvwy+shGcyrKatIVV6ug==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:aa47:b029:12d:693f:14a0 with
 SMTP id c7-20020a170902aa47b029012d693f14a0mr12765292plr.68.1629396015765;
 Thu, 19 Aug 2021 11:00:15 -0700 (PDT)
Date:   Thu, 19 Aug 2021 18:00:12 +0000
Message-Id: <20210819180012.744855-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] KVM: stats: x86: vmx: add exit reason stats to vt-x instructions
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These stats will be used to monitor the nested virtualization use in
VMs. Most importantly: VMXON exits are evidence that the guest has
enabled VMX, VMLAUNCH/VMRESUME exits are evidence that the guest has run
an L2.

Original-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++++++++++
 arch/x86/kvm/vmx/nested.c       | 17 +++++++++++++++++
 arch/x86/kvm/x86.c              | 13 ++++++++++++-
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09b256db394a..e3afbc7926e0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1257,6 +1257,17 @@ struct kvm_vcpu_stat {
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
 	u64 guest_mode;
+	u64 vmclear_exits;
+	u64 vmlaunch_exits;
+	u64 vmptrld_exits;
+	u64 vmptrst_exits;
+	u64 vmread_exits;
+	u64 vmresume_exits;
+	u64 vmwrite_exits;
+	u64 vmoff_exits;
+	u64 vmon_exits;
+	u64 invept_exits;
+	u64 invvpid_exits;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..8696f2612953 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4879,6 +4879,7 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 	const u64 VMXON_NEEDED_FEATURES = FEAT_CTL_LOCKED
 		| FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 
+	++vcpu->stat.vmon_exits;
 	/*
 	 * The Intel VMX Instruction Reference lists a bunch of bits that are
 	 * prerequisite to running VMXON, most notably cr4.VMXE must be set to
@@ -4964,6 +4965,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 /* Emulate the VMXOFF instruction */
 static int handle_vmoff(struct kvm_vcpu *vcpu)
 {
+	++vcpu->stat.vmoff_exits;
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
@@ -4984,6 +4986,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	u64 evmcs_gpa;
 	int r;
 
+	++vcpu->stat.vmclear_exits;
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
@@ -5025,6 +5028,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 /* Emulate the VMLAUNCH instruction */
 static int handle_vmlaunch(struct kvm_vcpu *vcpu)
 {
+	++vcpu->stat.vmlaunch_exits;
 	return nested_vmx_run(vcpu, true);
 }
 
@@ -5032,6 +5036,7 @@ static int handle_vmlaunch(struct kvm_vcpu *vcpu)
 static int handle_vmresume(struct kvm_vcpu *vcpu)
 {
 
+	++vcpu->stat.vmresume_exits;
 	return nested_vmx_run(vcpu, false);
 }
 
@@ -5049,6 +5054,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	short offset;
 	int len, r;
 
+	++vcpu->stat.vmread_exits;
+
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
@@ -5141,6 +5148,8 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	 */
 	u64 value = 0;
 
+	++vcpu->stat.vmwrite_exits;
+
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
@@ -5245,6 +5254,8 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 	gpa_t vmptr;
 	int r;
 
+	++vcpu->stat.vmptrld_exits;
+
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
@@ -5311,6 +5322,8 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	gva_t gva;
 	int r;
 
+	++vcpu->stat.vmptrst_exits;
+
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
@@ -5351,6 +5364,8 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	} operand;
 	int i, r;
 
+	++vcpu->stat.invept_exits;
+
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_EPT) ||
 	    !(vmx->nested.msrs.ept_caps & VMX_EPT_INVEPT_BIT)) {
@@ -5431,6 +5446,8 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	u16 vpid02;
 	int r;
 
+	++vcpu->stat.invvpid_exits;
+
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_VPID) ||
 			!(vmx->nested.msrs.vpid_caps & VMX_VPID_INVVPID_BIT)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a00af1b076b..c2c95b4c1a68 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -277,7 +277,18 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, nested_run),
 	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
-	STATS_DESC_ICOUNTER(VCPU, guest_mode)
+	STATS_DESC_ICOUNTER(VCPU, guest_mode),
+	STATS_DESC_COUNTER(VCPU, vmclear_exits),
+	STATS_DESC_COUNTER(VCPU, vmlaunch_exits),
+	STATS_DESC_COUNTER(VCPU, vmptrld_exits),
+	STATS_DESC_COUNTER(VCPU, vmptrst_exits),
+	STATS_DESC_COUNTER(VCPU, vmread_exits),
+	STATS_DESC_COUNTER(VCPU, vmresume_exits),
+	STATS_DESC_COUNTER(VCPU, vmwrite_exits),
+	STATS_DESC_COUNTER(VCPU, vmoff_exits),
+	STATS_DESC_COUNTER(VCPU, vmon_exits),
+	STATS_DESC_COUNTER(VCPU, invept_exits),
+	STATS_DESC_COUNTER(VCPU, invvpid_exits),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {

base-commit: 47e7414d53fc12407b7a43bba412ecbf54c84f82
-- 
2.33.0.rc2.250.ged5fa647cd-goog

