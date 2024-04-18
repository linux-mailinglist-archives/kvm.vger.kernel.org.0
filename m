Return-Path: <kvm+bounces-15116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 659AD8A9FB4
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D2F3283A34
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243FC16F909;
	Thu, 18 Apr 2024 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rG8oYPZx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A3B16078D
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713456713; cv=none; b=GPv4QisUo9KFfGqzfvGKcuLOsgVU92mx9QumaUGvDprOu1opmfKJ65f+3anS4AKLAoizNXHfIfqyq0Nqoqeke7UNerLiGz6KbnLTBv0JZ6vht2usLUDYfPGeP0mQn4q5M6wBOwwszmE0Dcvdt7GDH4HerOYKwmvlA3MU0BIokVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713456713; c=relaxed/simple;
	bh=x3+WlO+0LAXP8uQDsB5xiS+LPQq9LE56J9dxO3ax1z8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=asQMDospWFbh9gjU26tXlJHxU9C+IZWDIFJ/axfsWp3Xs0p4gSrBuEI3k8F4x3f1z9zMYlmhhkqUX9CD5sVmNv0OpKF8KFKC27Ud3So6asrrrLOFwQG4KRONWNYjAf1oGlp3Ks5Uux398XJz+rAdvSv6Q2EiDUmOIQbdBV5Ge0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rG8oYPZx; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b028ae5easo19533467b3.3
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 09:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713456710; x=1714061510; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YYC+ElnlnIhIYtT3pTmbpV3Sx6LVeGekU37IYxjEoOk=;
        b=rG8oYPZxj9hljCcywnA5vP6jjy4i5nHEhQsdoNsnj3R0npMJh/qPo6E43KLmbL0HH1
         euVeNkZItiJdIjESi/0IAnSNd6OfsdNSL7cQRqiWzqfks/8/aEEbUtGP3s4vJ8WOTN3u
         NPETkYh2Z1kW3TLkbi7qwgKAONjPSgm6HHEezEAjN313MEI5hGw5uiaVr/hj5pSjd9sl
         1msS6BpLn7p6uTyStcf0pwT161yRCuWu5aJwUr4lsQwvwyIf6OKlIk1L+BWzHsdD76Ur
         rgluC1RVyiV51AwOLDmm6L3Wh5XjckOGb65hQnKFD9HNcMaF2I74VNTcqwkP1yI6QXgW
         HUXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713456710; x=1714061510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YYC+ElnlnIhIYtT3pTmbpV3Sx6LVeGekU37IYxjEoOk=;
        b=pEnyjArdMh/1pDuFWfD/kqdljiW2hNDFP3nzYY+AzCMqwp0KkDLNcXO+VHwBaauuRE
         FhzNQYMw1ce5zaVXFqXEuC2PturATcXDjZ8BnHh0am86eUTQYwB144PlJCzR4f8CU153
         nOT2/L9fYFMyhhQTklWEYaavkuXBuIxTSlcubuPv+0scZgNE/q5DsD3U7cmmBJYwaqg3
         9F/bKqyF3kO/QolX48h0/VXO5EJw3j7mdISJVjHtc9FRdxqwCT2VzhekyPu2kQ8YzS1I
         jHHYLkcj/RX8UpdzW3RbstSsTMXQnDqCmlBBe8tCw1h19LtTPn6dSi1Dlb8tde3S5Td3
         kPdA==
X-Forwarded-Encrypted: i=1; AJvYcCU+hX+om90iRd8dr1ENdk9pMkjEoEitR9ZAhDWI9BND53K+eHXR43Wm8c9HQaYOOPXi2kzLBuAgJhQStf1ifXPbCTa6
X-Gm-Message-State: AOJu0YzrYLY2YHnUwJfaZFLId/7haUbFqmvLzVwlHzW3mglR5hrseHiz
	lC/S+0bkHcawM19gGK0CmsdOCfqfR39c4qQWXSlU96IELQAqDgGkuiGDWUCkvYE6HhNewG6hfSZ
	Qxw==
X-Google-Smtp-Source: AGHT+IGBG0Jt5UIr5Hv3ErOh24L4EYGuYkMTUr3on3b8sqAWcVn4NNfmefrFusmoxB6a86KjwyKVnEISv+U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c1:b0:dc6:e8a7:fdba with SMTP id
 w1-20020a05690210c100b00dc6e8a7fdbamr827651ybu.4.1713456710299; Thu, 18 Apr
 2024 09:11:50 -0700 (PDT)
Date: Thu, 18 Apr 2024 09:11:48 -0700
In-Reply-To: <9056f6a2-546b-41fc-a07c-7b86173887db@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-3-xiong.y.zhang@linux.intel.com> <ZhgmrczGpccfU-cI@google.com>
 <23af8648-ca9f-41d2-8782-f2ffc3c11e9e@linux.intel.com> <ZhmIrQQVgblrhCZs@google.com>
 <2342a4e2-2834-48e2-8403-f0050481e59e@linux.intel.com> <ab2953b7-18fd-4b4c-a83b-ab243e2a21e1@linux.intel.com>
 <998fd76f-2bd9-4492-bf2e-e8cd981df67f@linux.intel.com> <eca7cdb9-6c8d-4d2e-8ac6-b87ea47a1bac@linux.intel.com>
 <9056f6a2-546b-41fc-a07c-7b86173887db@linux.intel.com>
Message-ID: <ZiFGRFb45oZrmqnJ@google.com>
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
From: Sean Christopherson <seanjc@google.com>
To: Xiong Y Zhang <xiong.y.zhang@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>, pbonzini@redhat.com, peterz@infradead.org, 
	mizhang@google.com, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	dapeng1.mi@linux.intel.com, jmattson@google.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 17, 2024, Xiong Y Zhang wrote:
> On 4/16/2024 8:48 PM, Liang, Kan wrote:
> >> x86_perf_get_mediated_pmu() is called at vm_create(),
> >> x86_perf_put_mediated_pmu() is called at vm_destroy(), then system wide
> >> perf events without exclude_guest=1 can not be created during the whole vm
> >> life cycle (where nr_mediated_pmu_vms > 0 always), do I understand and use
> >> the interface correctly ?
> > 
> > Right, but it only impacts the events of PMU with the
> > PERF_PMU_CAP_MEDIATED_VPMU.  For other PMUs, the event with exclude_guest=1
> > can still be created.  KVM should not touch the counters of the PMU without
> > PERF_PMU_CAP_MEDIATED_VPMU.
> > 
> > BTW: I will also remove the prefix x86, since the functions are in the
> > generic code.
> > 
> > Thanks,
> > Kan
> After userspace VMM call VCPU SET_CPUID() ioctl, KVM knows whether vPMU is
> enabled or not. If perf_get_mediated_pmu() is called at vm create, it is too
> early.

Eh, if someone wants to create _only_ VMs without vPMUs, then they should load
KVM with enable_pmu=false.  I can see people complaining about not being able to
create VMs if they don't want to use have *any* vPMU usage, but I doubt anyone
has a use cases where they want a mix of PMU-enabled and PMU- disabled VMs, *and*
they are ok with VM creation failing for some VMs but not others.

> it is better to let perf_get_mediated_pmu() track per cpu PMU state,
> so perf_get_mediated_pmu() can be called by kvm after vcpu_cpuid_set(). Note
> user space vmm may call SET_CPUID() on one vcpu multi times, then here
> refcount maybe isn't suitable. 

Yeah, waiting until KVM_SET_CPUID2 would be unpleasant for both KVM and userspace.
E.g. failing KVM_SET_CPUID2 because KVM can't enable mediated PMU support would
be rather confusing for userspace.

> what's a better solution ?

If doing the checks at VM creation is a stick point for folks, then the best
approach is probably to use KVM_CAP_PMU_CAPABILITY, i.e. require userspace to
explicitly opt-in to enabling mediated PMU usage.  Ha!  We can even do that
without additional uAPI, because KVM interprets cap->args[0]==0 as "enable vPMU".

The big problem with this is that enabling mediated PMU support by default would
break userspace.  Hmm, but that's arguably the case no matter what, as a setup
that worked before would suddenly start failing if the host was configured to use
the PMU-based NMI watchdog.

E.g. this, if we're ok commiting to never enabling mediated PMU by default.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47d9f03b7778..01d9ee2114c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6664,9 +6664,21 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
                        break;
 
                mutex_lock(&kvm->lock);
-               if (!kvm->created_vcpus) {
-                       kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
-                       r = 0;
+               /*
+                * To keep PMU configuration "simple", setting vPMU support is
+                * disallowed if vCPUs are created, or if mediated PMU support
+                * was already enabled for the VM.
+                */
+               if (!kvm->created_vcpus &&
+                   (!enable_mediated_pmu || !kvm->arch.enable_pmu)) {
+                       if (enable_mediated_pmu &&
+                           !(cap->args[0] & KVM_PMU_CAP_DISABLE))
+                               r = x86_perf_get_mediated_pmu();
+                       else
+                               r = 0;
+
+                       if (!r)
+                               kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
                }
                mutex_unlock(&kvm->lock);
                break;
@@ -12563,7 +12575,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
        kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
        kvm->arch.guest_can_read_msr_platform_info = true;
-       kvm->arch.enable_pmu = enable_pmu;
+
+       /* PMU virtualization is opt-in when mediated PMU support is enabled. */
+       kvm->arch.enable_pmu = enable_pmu && !enable_mediated_pmu;
 
 #if IS_ENABLED(CONFIG_HYPERV)
        spin_lock_init(&kvm->arch.hv_root_tdp_lock);


