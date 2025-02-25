Return-Path: <kvm+bounces-39140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 834EDA44868
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:36:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB32919E42E4
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7315819C558;
	Tue, 25 Feb 2025 17:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0j7GZOTS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE77199238
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504531; cv=none; b=AFDlDev+eQN+o7RtTZleqsfC7Kp0kJ9G/3QF4cSN4ABByBZxr9V8TiV0s6XE+j3++gKYmrbzc3QjK08w9SoyLEaOQ6z87Dihpjba4X/M3ohHv7CagFHbJ1cZkisa08wr9xOTF4MNEbLAc3l2HtA+koTU60AtBXNNnh6+FT7ZP9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504531; c=relaxed/simple;
	bh=xssk7r6GD77nVJokw+O90QXNptvnUYuZqjKgbyfdpCk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tQSh4WSW+Z3W486ySIoFEZzf42+10B6vSxYzo6O78eYwQxy/PNq4Q7AurNiSbx3+Ailu6uetU01gdVsazllATFXIB/iA+gwEwFFLHt2+7L7aM4wzkAVLs3BQxRSnTfzTJRPFAgLxEddPvAIkVwrdh9wizjmmMFYeiJCt7ipKZVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0j7GZOTS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc43be27f8so19417821a91.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 09:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740504529; x=1741109329; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kp/kK8Nq6EAHPL6vafMzGhBPqvyWvzwjvBM1N34P0S0=;
        b=0j7GZOTSjM7IjeSUDXLznQZBeCvPZZyBkFEjH9I53mT8S0swA5LZMBqlfbe8cGbcmY
         sY7FYXh60SQHOauNyobNLAK8WEnXrOuML59Y8jYYPqrlt1Bkp/8UaGYD0RJolmVcBYSV
         Y8EO5e2jyM7TkLZTiuBXf7Iet90L0xDIKiu4CloX9/kZsZTE2ttLr2pGc84nzXF6Pgmi
         tqqYwaXwEqkBB6gbeXrCq7ATXzP7CB3/ePjM9EYaqd+CUp7SyzsryUrpKDf5mhMuEx1G
         plgOKJZaqvadKc3gasJ1+Fa3RyuU1la7dQodtgrSx4RDij0NuDxFE3nx55PZPkSZoy2E
         RKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740504529; x=1741109329;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kp/kK8Nq6EAHPL6vafMzGhBPqvyWvzwjvBM1N34P0S0=;
        b=WwSMPhtuJ/4bMIxK6L7crE8jGQdD/UFMYOqEBC7Kg9Ji/A4u73Se1RUdt5NYxWeKlF
         E0rKDYZ7ppDEfR3MRfdNfz7qNej7BaZniZffYwQsOLD78sR2eM1m0+KbirbieuB37p3j
         0D0WA0hzUMXd8VVhhtWOdGY7zHDWiEqaUSxiSpCN+/Ac3rQX1FKKhRThSarYYW74DNua
         bZUHw1Dd0pWKmZmLphJgCOcGyi01R5QYJ4dasMfm0gArg2IVo6Uu6/mH/YrlsvEYpTgX
         1xKu0v580bNEMJ1CcvfK647XMDtjCNGxHPYulsKkCC7kp+X3A2Wlfrnmrnp+ITNwjg1/
         3oFA==
X-Forwarded-Encrypted: i=1; AJvYcCVV/sc/WVa4kCN3Hu1EJ9xNSJrU99jPBT1yM2BGEWObkQY+Sa5F/HR/19teyLU8IfM0RpM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR1lgzweKnpraNhSnB70k5svdTS4MDXfXx/t6FvbnWbe+dtXpl
	80MAj7ff+/izLep69Jv123ROtEZFZw0iFMoNOWnlNfDNkqXwkK2cvjTP6bhqC3CeNQIYEgxr7bk
	oTQ==
X-Google-Smtp-Source: AGHT+IGTvcRUA6OpnNrnqKRmtujbXTgGf5Jtp8a1i0NXeuvpsdxCzwhvJ/m9zCtVPFCeAGo5v7x+9YDTpxg=
X-Received: from pjbtb12.prod.google.com ([2002:a17:90b:53cc:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350e:b0:2ee:9902:18b4
 with SMTP id 98e67ed59e1d1-2fe7e39f1bbmr248876a91.27.1740504529279; Tue, 25
 Feb 2025 09:28:49 -0800 (PST)
Date: Tue, 25 Feb 2025 09:28:33 -0800
In-Reply-To: <5582cf56-0b22-4603-b8e2-6b652c09b4fa@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241001050110.3643764-1-xin@zytor.com> <20241001050110.3643764-4-xin@zytor.com>
 <ZxYQvmc9Ke+PYGkQ@intel.com> <10aa42de-a448-40d4-a874-514c9deb56a3@zytor.com>
 <ZxcSPpuBHO8Y1jfG@intel.com> <5582cf56-0b22-4603-b8e2-6b652c09b4fa@zytor.com>
Message-ID: <Z739wdGmk4ZuWJ8v@google.com>
Subject: Re: [PATCH v3 03/27] KVM: VMX: Add support for the secondary VM exit controls
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com
Content-Type: multipart/mixed; charset="UTF-8"; boundary="6p5+kLFLXaqTdVYq"


--6p5+kLFLXaqTdVYq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 22, 2024, Xin Li wrote:
> > > > > 		_vmentry_control &= ~n_ctrl;
> > > > > 		_vmexit_control &= ~x_ctrl;
> > > > 
> > > > w/ patch 4, VM_EXIT_ACTIVATE_SECONDARY_CONTROLS is cleared if FRED fails in the
> > > > consistent check. this means, all features in the secondary vm-exit controls
> > > > are removed. it is overkill.
> > > 
> > > Good catch!
> > > 
> > > > 
> > > > I prefer to maintain a separate table for the secondary VM-exit controls:
> > > > 
> > > >    	struct {
> > > >    		u32 entry_control;
> > > >    		u64 exit2_control;
> > > > 	} const vmcs_entry_exit2_pairs[] = {
> > > > 		{ VM_ENTRY_LOAD_IA32_FRED, SECONDARY_VM_EXIT_SAVE_IA32_FRED |
> > > > 					   SECONDARY_VM_EXIT_LOAD_IA32_FRED},
> > > > 	};
> > > > 
> > > > 	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit2_pairs); i++) {
> > > > 	...
> > > > 	}
> > > 
> > > Hmm, I prefer one table, as it's more straight forward.

Heh, that's debatable.  Also, calling these triplets is *very* misleading.

> > One table is fine if we can fix the issue and improve readability. The three
> > nested if() statements hurts readability.
> 
> You're right!  Let's try to make it clearer.

I agree with Chao, two tables provides better separation, which makes it easier
to follow what's going on, and avoids "polluting" every entry with empty fields.

If it weren't for the new controls supporting 64 unique bits, and the need to
clear bits in KVM's controls, it'd be trivial to extract processing to a helper
function.  But, it's easy enough to solve that conundrum by using a macro instead
of a function.  And as a bonus, a macro allows for adding compile-time assertions
to detect typos, e.g. can detect if KVM passes in secondary controls (u64) pairs
with the primary controls (u32) variable.

I'll post the attached patch shortly.  I verified it works as expected with a
simulated "bad" FRED CPU.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9e5576d99d0..4717d48eabe8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2621,6 +2621,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
        u32 _vmentry_control = 0;
        u64 basic_msr;
        u64 misc_msr;
+       u64 _vmexit2_control = BIT_ULL(1);
 
        /*
         * LOAD/SAVE_DEBUG_CONTROLS are absent because both are mandatory.
@@ -2638,6 +2639,13 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
                { VM_ENTRY_LOAD_IA32_RTIT_CTL,          VM_EXIT_CLEAR_IA32_RTIT_CTL },
        };
 
+       struct {
+               u32 entry_control;
+               u64 exit_control;
+       } const vmcs_entry_exit2_pairs[] = {
+               { 0x00800000,                           BIT_ULL(0) | BIT_ULL(1) },
+       };
+
        memset(vmcs_conf, 0, sizeof(*vmcs_conf));
 
        if (adjust_vmx_controls(KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL,
@@ -2728,6 +2736,12 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
                                       _vmentry_control, _vmexit_control))
                return -EIO;
 
+       if (vmx_check_entry_exit_pairs(vmcs_entry_exit2_pairs,
+                                      _vmentry_control, _vmexit2_control))
+               return -EIO;
+
+       WARN_ON_ONCE(_vmexit2_control);
+
        /*
         * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
         * can't be used due to an errata where VM Exit may incorrectly clear

--6p5+kLFLXaqTdVYq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-VMX-Extract-checks-on-entry-exit-control-pairs-t.patch"

From b1def684c93990d1a62c169bb23706137b96b727 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Feb 2025 09:10:32 -0800
Subject: [PATCH] KVM: VMX: Extract checks on entry/exit control pairs to a
 helper macro

Extract the checking of entry/exit pairs to a helper macro so that the
code can be reused to process the upcoming "secondary" exit controls (the
primary exit controls field is out of bits).  Use a macro instead of a
function to support different sized variables (all secondary exit controls
will be optional and so the MSR doesn't have the fixed-0/fixed-1 split).
Taking the largest size as input is trivial, but handling the modification
of KVM's to-be-used controls is much trickier, e.g. would require bitmap
games to clear bits from a 32-bit bitmap vs. a 64-bit bitmap.

Opportunistically add sanity checks to ensure the size of the controls
match (yay, macro!), e.g. to detect bugs where KVM passes in the pairs for
primary exit controls, but its variable for the secondary exit controls.

To help users triage mismatches, print the control bits that are checked,
not just the actual value.  For the foreseeable future, that provides
enough information for a user to determine which fields mismatched.  E.g.
until secondary entry controls comes along, all entry bits and thus all
error messages are guaranteed to be unique.

To avoid returning from a macro, which can get quite dangerous, simply
process all pairs even if error_on_inconsistent_vmcs_config is set.  The
speed at which KVM rejects module load is not at all interesting.

Keep the error message a "once" printk, even though it would be nice to
print out all mismatching pairs.  In practice, the most likely scenario is
that a single pair will be mismatch on all CPUs.  Printing all mismatches
generates redundant messages in that situation, and can be extremely noisy
on systems with large numbers of CPUs.  If a CPU has multiple mismatches,
not printing every bad pair is the least of the user's concerns.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 48 +++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b71392989609..c9e5576d99d0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2582,6 +2582,34 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 	return  ctl_opt & allowed;
 }
 
+#define vmx_check_entry_exit_pairs(pairs, entry_controls, exit_controls)	\
+({										\
+	int i, r = 0;								\
+										\
+	BUILD_BUG_ON(sizeof(pairs[0].entry_control) != sizeof(entry_controls));	\
+	BUILD_BUG_ON(sizeof(pairs[0].exit_control)  != sizeof(exit_controls));	\
+										\
+	for (i = 0; i < ARRAY_SIZE(pairs); i++) {				\
+		typeof(entry_controls) n_ctrl = pairs[i].entry_control;		\
+		typeof(exit_controls) x_ctrl = pairs[i].exit_control;		\
+										\
+		if (!(entry_controls & n_ctrl) == !(exit_controls & x_ctrl))	\
+			continue;						\
+										\
+		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, " 		\
+			     "entry = %llx (%llx), exit = %llx (%llx)\n",	\
+			    (u64)(entry_controls & n_ctrl), (u64)n_ctrl,	\
+			    (u64)(exit_controls & x_ctrl), (u64)x_ctrl);	\
+										\
+		if (error_on_inconsistent_vmcs_config)				\
+			r = -EIO;						\
+										\
+		entry_controls &= ~n_ctrl;					\
+		exit_controls &= ~x_ctrl;					\
+	}									\
+	r;									\
+})
+
 static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			     struct vmx_capability *vmx_cap)
 {
@@ -2593,7 +2621,6 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _vmentry_control = 0;
 	u64 basic_msr;
 	u64 misc_msr;
-	int i;
 
 	/*
 	 * LOAD/SAVE_DEBUG_CONTROLS are absent because both are mandatory.
@@ -2697,22 +2724,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				&_vmentry_control))
 		return -EIO;
 
-	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
-		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
-		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
-
-		if (!(_vmentry_control & n_ctrl) == !(_vmexit_control & x_ctrl))
-			continue;
-
-		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
-			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
-
-		if (error_on_inconsistent_vmcs_config)
-			return -EIO;
-
-		_vmentry_control &= ~n_ctrl;
-		_vmexit_control &= ~x_ctrl;
-	}
+	if (vmx_check_entry_exit_pairs(vmcs_entry_exit_pairs,
+				       _vmentry_control, _vmexit_control))
+		return -EIO;
 
 	/*
 	 * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they

base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.658.g4767266eb4-goog


--6p5+kLFLXaqTdVYq--

