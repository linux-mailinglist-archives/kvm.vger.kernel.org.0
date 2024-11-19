Return-Path: <kvm+bounces-32040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB869D1D8A
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 02:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A1C61F21075
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 01:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51767126BF9;
	Tue, 19 Nov 2024 01:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cjNDM81x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128D93EA83
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 01:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731980801; cv=none; b=UcGBCq1rIxXuWFUDzE5CIkdLt76EiQ7IfP3RNYzyhai8trwXBSfnA4k2nVwQpRy2LqgpPy3AbJaWc8rhujF8CkDnWD+C3XQUr9U1dHxv/i5D8kZhzT3QR8ZoUD3/MFgcz6A6dZHC9NUS3BsIgId9FNdQwjZzRMVrJ9n3X8g60B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731980801; c=relaxed/simple;
	bh=E3d+OEbP3yMOILCnS9+hFYuwOyXhhrnM8bXkOY1xVrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cfPmLe3MOaUNUkxyOGvQ2/9aH4CgB60kWgPN9RVru1ozclmePe2ypFUx5C6MjXh8UO2w8269h19y9WBn6nq2vDZwWrdJ5HY2M/spUsEM9DLc13ph/YG+3P82ZvE4hMheCpXA18pgZ6E8STf+idq7I4EXogP+S3YzOGbOi08Un3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cjNDM81x; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7fb966ee0cdso164910a12.1
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 17:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731980799; x=1732585599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GT1zL1Urke9HJNtThpCY9mwLIe9gpw5HbnqMkgZMySc=;
        b=cjNDM81x4AfKtSlCtHlJLFSW33ii/dZwEIjsRl0zWGLdzfijwG5eLsyd2IIhHLyT6T
         TNuCJiDQrobj2qNH9WrD2aiVgNooO11d+68LcBJ6E7sQR3Ow23kfx/+T0oEXjp1U/5sp
         ulrADf3XSuvMcbgV6aZYONGlZttcAGmdiNNbsqoe+dn1NEU0vjVdcHwijl44sGRbqzYA
         u7U+ppkQaJmc5f3N/TnI1X941QqvcSHX+zfgME0XLHPUoh78Nh6l5lz7d/3WPFL8EW/u
         /LyCF/anjUxQMRUb3eOsUDZtR4imQjzEtGgGtWjrtT1qpsTgFRMc5p77qjO/VMoHYf9H
         3z8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731980799; x=1732585599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GT1zL1Urke9HJNtThpCY9mwLIe9gpw5HbnqMkgZMySc=;
        b=MSkOLPzPTY++dJ+3VeEgjcU3a3Ke1gDMVhm3vrTperAs0kY+kL6PVtpnCqtFH9br2x
         kkdZqx1RWm/iW3Sx+lEOp4J+reIJ9iGbhbu5t+N66unNL2zJplAmvdwUOOWS9Oj8JGJU
         vFW34tzc0e8WosMa9svi4DVSSKhs5ZO0zeN7j7XZyGJBMBDNGyWsPviWBb7WX+NydS79
         Z7PXCVyVNKsWm3U7m+mSOpXdp19GI+h02ewCBL99sBNcwMnd8IVLk+SXNoTjmInL1ub4
         axek8+ug4/fuSC/TT1BlAN8CyMvqDxWrAtL4IvWyBLG2S59EjhXXsxLagfFzOrenhWMu
         zerw==
X-Forwarded-Encrypted: i=1; AJvYcCWH6Y/XCw6XB3dfgc3O/Xq03b6D5Q+IM6tQ6g//xgY9a/w/9lmGkq0i1RwoNBlNs6CSCHs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDE8ZkSIlQGwtXFfYYjPmpZUtDe3YHynge6vYLpeYGL/Mzs5SL
	z5fdkx0SIiMV2tnDomwlVnmTsU42+2rYtD38Hmjzom24vd0ejAPkOn62cZ0FasL0nTdfO/QW0kK
	q3g==
X-Google-Smtp-Source: AGHT+IFyAMUt271Gd1mpsf5l1hRbbPI4yGCXbfh1zdsuqozjfDlwn6H+U1HYbzeXnhb/CkuByt2bxALOXYQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:7352:0:b0:7ea:8c4c:d07c with SMTP id
 41be03b00d2f7-7fb92f3a224mr2388a12.3.1731980799107; Mon, 18 Nov 2024 17:46:39
 -0800 (PST)
Date: Mon, 18 Nov 2024 17:46:37 -0800
In-Reply-To: <c21d02a3-4315-41f4-b873-bf28041a0d82@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-38-mizhang@google.com>
 <5309ec1b-edc6-4e59-af88-b223dbf2a455@intel.com> <c21d02a3-4315-41f4-b873-bf28041a0d82@linux.intel.com>
Message-ID: <Zzvt_fNw0U34I9bJ@google.com>
Subject: Re: [RFC PATCH v3 37/58] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL
 at VM boundary
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Zide Chen <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>, 
	Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>, 
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 25, 2024, Dapeng Mi wrote:
> 
> On 10/25/2024 4:26 AM, Chen, Zide wrote:
> >
> > On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
> >
> >> @@ -7295,6 +7299,46 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> >>  					msrs[i].host, false);
> >>  }
> >>  
> >> +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
> >> +{
> >> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
> >> +	int i;
> >> +
> >> +	if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL) {
> >> +		pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
> > As commented in patch 26, compared with MSR auto save/store area
> > approach, the exec control way needs one relatively expensive VMCS read
> > on every VM exit.
> 
> Anyway, let us have a evaluation and data speaks.

No, drop the unconditional VMREAD and VMWRITE, one way or another.  No benchmark
will notice ~50 extra cycles, but if we write poor code for every feature, those
50 cycles per feature add up.

Furthermore, checking to see if the CPU supports the load/save VMCS controls at
runtime beyond ridiculous.  The mediated PMU requires ***VERSION 4***; if a CPU
supports PMU version 4 and doesn't support the VMCS controls, KVM should yell and
disable the passthrough PMU.  The amount of complexity added here to support a
CPU that should never exist is silly.

> >> +static void load_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
> >> +{
> >> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
> >> +	u64 global_ctrl = pmu->global_ctrl;
> >> +	int i;
> >> +
> >> +	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
> >> +		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
> > ditto.
> >
> > We may optimize it by introducing a new flag pmu->global_ctrl_dirty and
> > update GUEST_IA32_PERF_GLOBAL_CTRL only when it's needed.  But this
> > makes the code even more complicated.

I haven't looked at surrounding code too much, but I guarantee there's _zero_
reason to eat a VMWRITE+VMREAD on every transition.  If, emphasis on *if*, KVM
accesses PERF_GLOBAL_CTRL frequently, e.g. on most exits, then add a VCPU_EXREG_XXX
and let KVM's caching infrastructure do the heavy lifting.  Don't reinvent the
wheel.  But first, convince the world that KVM actually accesses the MSR somewhat
frequently.

I'll do a more thorough review of this series in the coming weeks (days?).  I
singled out this one because I happened to stumble across the code when digging
into something else.

