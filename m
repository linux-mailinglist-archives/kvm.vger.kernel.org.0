Return-Path: <kvm+bounces-18368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8E58D44C4
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 07:24:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EA491C21965
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 05:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFFF143C52;
	Thu, 30 May 2024 05:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ttKbXe+s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD27143878
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 05:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717046652; cv=none; b=FB7saUt55Ivk5ugptLl/9Jq2rwB8lCfVBfHiqvUTrdpa6V652rifCyyNBoFXuTdyDO009m4y1OphX9ucAemrkpGAoSqMnsHdEJJGEoeQ/rTnp588ETr+YazCzFYyyT/LGDTrWkvLfgkgSZusiHTbPBdoetmjqyClYkKakrEcmIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717046652; c=relaxed/simple;
	bh=nAp7Ui3eE8r0yzISWWdMuqo5A6VFhIVEixEGPJwZ1ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLD/4V0T8ANNscFaVqwAuccsKgEPuKZ95q/1OD9ozHBmFi9LE/qR1e0zcspcQCYkadaJn3KGbUd+qzzlVFnXUDlRPU7LRmsbaRIy6kW9tYLbINqEDPnhRD3tHPhoytwtBAjGA9Zs7SbsyB3tdmQwuKVxgGgmW3NyKSOu8ygqLlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ttKbXe+s; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-66629f45359so444198a12.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 22:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717046650; x=1717651450; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzZ0z/nISp6Koqal7Cqbdy5CWQdp0RJJu2pXq19837E=;
        b=ttKbXe+sos+FP+HlZuC26kn8tH5SR0XfTU5srRRLBFFEK0pn5bxH8h55fBndEOvWjv
         1419ep1jhFgcF8HdgwHPSwuwsuOsj/naeaB+GyCv3JOa4UXFI593J33R0P6ywPUUFJe/
         BHta18asfXCB0ZigZi1i5KfEgPg3AOF379VjggR/3xMDuThLz5g4sVZcY8UPl6QHEDxV
         AwbJ+3c0y0Q5sXSUOC43VTa978VOHBhyHZTpN3OaOiyxtomUpWDveV32ha5TTsxFKGfp
         5ClZijkglg/aVMmKhGHtsTXxYsf19TW4vtbbV+oHQI8VRZolBCG3QmYq+GfsuW5qddwE
         1j6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717046650; x=1717651450;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzZ0z/nISp6Koqal7Cqbdy5CWQdp0RJJu2pXq19837E=;
        b=i6lFdzF3DpTng3SuvH4LyALlVz8EXrPPFdYiEK8EdmeVb6EQuvDkk3oYPf9wgC7Xfg
         0RXb8fopfc0NT/VtpSqBodOwUDgib9Fts5wmR6AmPI6dLbNjFk82koqTNSq3g6hq7HGK
         WMHxwfRMnyNTk6FIGdlrMAILBnrhUOjLZDPOZEwv5CwCJkRXDiK5jPCZKSHBqwZ+hOtl
         6EbJe+8FJYHTSoBLM9+lhWmVPeATC/J2jxM5ZdwL+4vhr8qJ+llDAVPaFoWk1fQZnFRa
         ZWFgAWO0fymx0A8CIObBnth90HBIV3ZrQ0bXCFPkohYFnBvKra5/LJQmLrwqLJ3GnxvP
         SfGw==
X-Forwarded-Encrypted: i=1; AJvYcCUNDdl5LvTjwDaICzBb8CMzGU85+ZK/10yPW+uXNh27r+2YWk2FUPamzO1czP3SzPkKUgZmqlerOgSHocyXFkrqDs1s
X-Gm-Message-State: AOJu0Yx4CWy1h7tPBA2Zz9L0EJu7ASX4jBg6tSFLzy+18+xrjo3Ud5YG
	hUdcY5PHnJEmT+U4evVynB9K9EHh4AAEOTX/8QPVzK4mn5wyhUoPMEtKkzQBpg==
X-Google-Smtp-Source: AGHT+IGV6BIEnRZi0PqpB/961ewnt6yhBoOY6Ydo3S23LbKkA5ccEdYiFd2NC1Zr8QNEZk1s8Cj8iw==
X-Received: by 2002:a05:6a20:3952:b0:1b0:1ce0:1a2e with SMTP id adf61e73a8af0-1b2645469a2mr1157815637.19.1717046649314;
        Wed, 29 May 2024 22:24:09 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f479010035sm85280765ad.82.2024.05.29.22.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 22:24:08 -0700 (PDT)
Date: Thu, 30 May 2024 05:24:05 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Chen, Zide" <zide.chen@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 24/54] KVM: x86/pmu: Create a function prototype to
 disable MSR interception
Message-ID: <ZlgNdfzVUkoqjGhQ@google.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-25-mizhang@google.com>
 <ee652d0a-2b5c-4dbc-ab48-d0608ab87d79@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee652d0a-2b5c-4dbc-ab48-d0608ab87d79@intel.com>

On Wed, May 08, 2024, Chen, Zide wrote:
> 
> 
> On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
> > Add one extra pmu function prototype in kvm_pmu_ops to disable PMU MSR
> > interception.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-pmu-ops.h | 1 +
> >  arch/x86/kvm/cpuid.c                   | 4 ++++
> >  arch/x86/kvm/pmu.c                     | 5 +++++
> >  arch/x86/kvm/pmu.h                     | 2 ++
> >  4 files changed, 12 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> > index fd986d5146e4..1b7876dcb3c3 100644
> > --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> > @@ -24,6 +24,7 @@ KVM_X86_PMU_OP(is_rdpmc_passthru_allowed)
> >  KVM_X86_PMU_OP_OPTIONAL(reset)
> >  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
> >  KVM_X86_PMU_OP_OPTIONAL(cleanup)
> > +KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
> >  
> >  #undef KVM_X86_PMU_OP
> >  #undef KVM_X86_PMU_OP_OPTIONAL
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 77352a4abd87..b577ba649feb 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -381,6 +381,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
> >  
> >  	kvm_pmu_refresh(vcpu);
> > +
> > +	if (is_passthrough_pmu_enabled(vcpu))
> > +		kvm_pmu_passthrough_pmu_msrs(vcpu);
> > +
> >  	vcpu->arch.cr4_guest_rsvd_bits =
> >  	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
> >  
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 3afefe4cf6e2..bd94f2d67f5c 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -1059,3 +1059,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
> >  	kfree(filter);
> >  	return r;
> >  }
> > +
> > +void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
> > +{
> > +	static_call_cond(kvm_x86_pmu_passthrough_pmu_msrs)(vcpu);
> > +}
> 
> Don't quite understand why a separate callback is needed. It seems it's
> not messier if put this logic in the kvm_x86_vcpu_after_set_cpuid()
> callback.

One of the key point here is whether we _can_ intercept RDPMC. We have
to intercept it if there is _any_ counters / MSRs that is accessible by
rdmpc. In Intel CPU, the PERF_METRICS MSR is accessible from RDPMC. This
MSR is a vendor specific one. So that's why we added another vendor API.

Thanks.
-Mingwei

