Return-Path: <kvm+bounces-33873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F25CD9F394D
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 19:51:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 316EC16A6BC
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 18:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C745D207A31;
	Mon, 16 Dec 2024 18:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i1Qz3GlO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B92345C1C
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 18:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734375078; cv=none; b=L1ViQ/c7m/W28y9ciS2gnnU6yOhYTJFOsvmrb7Y75+Gh0Sa9grdroKSG/I932jIzkoWTl4z6RYCTZz1GOSElOL+4uWXcqt2kZ+RrsipPbahsERWlkTJA9FOYU66sZcA73A5qmwk2wCilY4A+vd3y1TlaabPLPTsZjhqYKvJi5vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734375078; c=relaxed/simple;
	bh=HkIO0XQYqz3cAZDQsG913wPRFn/kho7r6jvSNHliltg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O/H2fUL+0c4STGdw30mPH3j02iWVUFxXhloAxUOJabYJ3TyJx+21s1bwC59dxHWvr5kquqd4GyBcSllZmI762rT2/LSy9qsnQ7uC7mnP2u/n9wvbQQTBUe+0wPUNT5kKdoZSFkotCT8zHp69zb2eyb95D9cJxAhXNNJEpS6vVuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i1Qz3GlO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-728e3d9706dso3909586b3a.3
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 10:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734375075; x=1734979875; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JLoNLY5L/ShxOSwj9IhGgOpBuBhnacmRbyveuEehm/0=;
        b=i1Qz3GlORdlyTqRz4zcLithoFqFDcZvGJ7IS5MLiHGM9JfUL6oGgub3+9nNg6mzlxW
         /L9fCyxH+DpRxQnq5UirhxIiuiljp6eaiO4i9w83SgEvlwn8fS43mP5NK3m97sev5Yqm
         085f2KoiOKS1H9vs958H3cgZXODGqw4cOIA/ss2a28gnUR10So/5K6bI9T/Blwme2brw
         jlMXs0p3nMppCbLBps2VJAWfvxtF3CqDXIl7cLyB7n3iqPqQy4zxDBreryFU9uBkXODV
         EJ+Ge5vhRJ6RK7/dZTEqIPmSN9g4V0B7HVwsXp4+bVmSL4OCotulUhK680tFNh5Sqb0O
         Eidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734375075; x=1734979875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JLoNLY5L/ShxOSwj9IhGgOpBuBhnacmRbyveuEehm/0=;
        b=vQG/mTvzQVWu5eF1pV/zyokKo+8SVX9zYiy2CUMJHyqQwzUXTrmQ+k+X+QV4JQwYxS
         d3NF/XhNvfm3UpB3yZ5JCgiCilLG/8V8u1w8sZoQWhmEyoL/yGdGDoPtGvjKWngh4tVt
         OczdktDARJzxJ9UoYfYlrhX2H5lieOZFqUerMHQT5njiBj3RsXbrN4XHSKxa2LcyjmR6
         C3uKywvC56S4ZREIVbkZKw5SifPD55MAyjQXJIZiNbQY7CicKcIKlpQ+Gs/sFEPyOtLS
         XJ9DqE1AI2pN0yKAqWOyMjeWzs2UcH3RVMacV6iG3pziXD1SBeBH1YOMCUwkT4VgejM1
         E7sg==
X-Forwarded-Encrypted: i=1; AJvYcCXRM1CTR4ZbA0ATvdbuO2NxUkRvrb/8M4hP8UAa/toS3wbmV25nqy8Hj71ap4TpgY3Ja2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmFMRnLVJfRWUwIndJtyM6hd1P5Cds18C6DRzRjY8GxkchO08A
	spdabAhUKpAsQ82TAHk/nXwMvDBelR65TISIJmoOO/wrRyho3vWIZNJv1PhheHe8LTjzGm1XGhU
	wpA==
X-Google-Smtp-Source: AGHT+IGhW7jZdnGmxiJJkLet2z5eeW6CYDtlLgSGQkyPA6NHGvymoWrHZBjqv7w88bhkzeMkZyGmoVjBFik=
X-Received: from pgqm11.prod.google.com ([2002:a65:530b:0:b0:7fd:5126:2bab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1796:b0:1e0:ca95:3cb3
 with SMTP id adf61e73a8af0-1e1dfe96d96mr21339997637.37.1734375074665; Mon, 16
 Dec 2024 10:51:14 -0800 (PST)
Date: Mon, 16 Dec 2024 10:51:13 -0800
In-Reply-To: <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241202120416.6054-1-bp@kernel.org> <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com> <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
Message-ID: <Z2B2oZ0VEtguyeDX@google.com>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 16, 2024, Borislav Petkov wrote:
> On Wed, Dec 11, 2024 at 02:27:42PM -0800, Sean Christopherson wrote:
> > How much cost are we talking?
> 
> Likely 1-2%.
> 
> That's why I'm simply enabling it by default.
> 
> > IIUC, this magic bit reduces how much the CPU is allowed to speculate in order
> > to mitigate potential VM=>host attacks, and that reducing speculation also reduces
> > overall performance.
> > 
> > If that's correct, then enabling the magic bit needs to be gated by an appropriate
> > mitagation being enabled, not forced on automatically just because the CPU supports
> > X86_FEATURE_SRSO_MSR_FIX.
> 
> Well, in  the default case we have safe-RET - the default - but since it is
> not needed anymore, it falls back to this thing which is needed when the
> mitigation is enabled.
> 
> That's why it also is in the SRSO_CMD_IBPB_ON_VMEXIT case as it is part of the
> spec_rstack_overflow=ibpb-vmexit mitigation option.
> 
> So it kinda already does that. When you disable the mitigation, this one won't
> get enabled either.

But it's a hardware-defined feature flag, so won't it be set by this code?

	if (c->extended_cpuid_level >= 0x8000001f)
		c->x86_capability[CPUID_8000_001F_EAX] = cpuid_eax(0x8000001f);

srso_select_mitigation() checks the flag for SRSO_CMD_IBPB_ON_VMEXIT

	case SRSO_CMD_IBPB_ON_VMEXIT:
		if (boot_cpu_has(X86_FEATURE_SRSO_MSR_FIX)) {
			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
			break;
		}

but I don't see any code that would clear X86_FEATURE_SRSO_MSR_FIX.  Am I missing
something?

> > And depending on the cost, it might also make sense to set the bit on-demand, and
> > then clean up when KVM disables virtualization.  E.g. wait to set the bit until
> > entry to a guest is imminent.
> 
> So the "when to set that bit" discussion kinda remained unfinished the last
> time.

Gah, sorry.  I suspect I got thinking about how best to "set it only when really
needed", and got lost in analysis paralysis.

> Here's gist:
> 
> You:
> 
> | "It's not strictly KVM module load, it's when KVM enables virtualization.  E.g.
> | if userspace clears enable_virt_at_load, the MSR will be toggled every time the
> | number of VMs goes from 0=>1 and 1=>0.
> | 
> | But why do this in KVM?  E.g. why not set-and-forget in init_amd_zen4()?"
> 
> I:
> 
> | "Because there's no need to impose an unnecessary - albeit small - perf impact
> | on users who don't do virt.
> | 
> | I'm currently gravitating towards the MSR toggling thing, i.e., only when the
> | VMs number goes 0=>1 but I'm not sure. If udev rules *always* load kvm.ko then
> | yes, the toggling thing sounds better. I.e., set it only when really needed."
> 
> So to answer your current question, it sounds like the user can control the
> on-demand thing with enable_virt_at_load=0, right?

To some extent.  But I strongly suspect that the vast, vast majority of end users
will end up with systems that automatically load kvm.ko, but don't run VMs the
majority of the time.  Expecting non-KVM to users to detect a 1-2% regression and
track down enable_virt_at_load doesn't seem like a winning strategy.

> Or do you mean something else different?

The other possibility would be to wait to set the bit until a CPU is actually
going to do VMRUN.  If we use KVM's "user-return MSR" framework, the bit would
be cleared when the CPU returns to userspace.  The only downside to that is KVM
would toggle the bit on CPUs running vCPUs on every exit to userspace, e.g. to
emulate MMIO/IO and other things.

But, userspace exits are relatively slow paths, so if the below is a wash for
performance when running VMs, i.e. the cost of the WRMSRs is either in the noise
or is offset by the regained 1-2% performance for userspace, then I think it's a
no-brainer.

Enabling "full" speculation on return to usersepace means non-KVM tasks won't be
affected, and there's no "sticky" behavior.  E.g. another idea would be to defer
setting the bit until VMRUN is imminent, but then wait to clear the bit until
virtualization is disabled.  But that has the downside of the bit being set on all
CPUs over time, especially if enable_virt_at_load is true.

Compile tested only...

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e4fad330cd25..061ac5940432 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -256,6 +256,7 @@ DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
  * defer the restoration of TSC_AUX until the CPU returns to userspace.
  */
 static int tsc_aux_uret_slot __read_mostly = -1;
+static int zen4_bp_cfg_uret_slot __ro_after_init = -1;
 
 static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
@@ -608,9 +609,6 @@ static void svm_disable_virtualization_cpu(void)
        kvm_cpu_svm_disable();
 
        amd_pmu_disable_virt();
-
-       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
-               msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -688,9 +686,6 @@ static int svm_enable_virtualization_cpu(void)
                rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
        }
 
-       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
-               msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
-
        return 0;
 }
 
@@ -1547,6 +1542,11 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
            (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
                kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
+       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
+               kvm_set_user_return_msr(zen4_bp_cfg_uret_slot,
+                                       MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT,
+                                       MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+
        svm->guest_state_loaded = true;
 }
 
@@ -5313,6 +5313,14 @@ static __init int svm_hardware_setup(void)
 
        tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX)) {
+               zen4_bp_cfg_uret_slot = kvm_add_user_return_msr(MSR_ZEN4_BP_CFG);
+               if (WARN_ON_ONCE(zen4_bp_cfg_uret_slot) < 0) {
+                       r = -EIO;
+                       goto err;
+               }
+       }
+
        if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
                kvm_enable_efer_bits(EFER_AUTOIBRS);


