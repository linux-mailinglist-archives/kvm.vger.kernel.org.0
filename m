Return-Path: <kvm+bounces-18367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68B658D44BB
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 07:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08C891F221C3
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 05:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40286143C4E;
	Thu, 30 May 2024 05:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4I/x7I0n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BB822083
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 05:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717046409; cv=none; b=Np02ZWAM+2YOQeGunl3nUlx8TRgB0k6RjIh+dQjSfcZIHtqPuqMjJoshPGv7IVfJXDB0GmnGFpsD7FmGx5EkoEU2xSPT539ow1zMctCBgI5iXd2dKgBHJjZxLZYj8zwRsAcLnYizE/v7GJ5dV+kjwRfQWd6bjM+3b4Enp1KWmvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717046409; c=relaxed/simple;
	bh=RE7/rHD6hA0HZU8BNTxAYNZyZXrYAewC2lvAFnovzcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ko52iZxtg+8Tk8Efn2NJuTPJ4NUAK7LGN5IPD6iqg0dqO62+Kq0QAEGVpoSWm63Jr86yBQ9Ri2qqCR2Ui8kTd55ryZqt+slMqQ4rJ2hzGpUlcKo3PkxhL8mUSAu8jelAGv1VU32rY9MgzBef1ZK2xHcofb+T/1NNA7CkpuaMR9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4I/x7I0n; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-681ad081695so345857a12.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 22:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717046407; x=1717651207; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qCiXp86mmPaO4lRyFEc5txWVo+t4xtzMhe/cX0w+gk=;
        b=4I/x7I0nCuezROlzTM9AVyC3qOw5dd5+i9iibxgUUi7ADnLX85BfFJCUeAj2C964bD
         GYRvh0b6QsIvtRcgeAcpr82IQLKEg+1CYqnT874OnKAQhPQbAQxYIisgC3+VhEYOIfWi
         AO3OT/0cXm1lpr9PYVVX8szivARhRxGyyYw8k/oc+nW+h62f7UP+ZoymH7bo9DKTHcMG
         Lzy4h/mhOvLva3Z3LAtlrqJoZVwzvAGxpQys/CJRaZe5Ixi3BDImtxCdbjQR4bQeF/hV
         sb0LjMmkYUdvpQvIcBiToHQzmTrk/LQZmcXpw7MbHUjRhJJdSdgeHt25TjWFxVXjnYUY
         xx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717046407; x=1717651207;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qCiXp86mmPaO4lRyFEc5txWVo+t4xtzMhe/cX0w+gk=;
        b=g2yEMP5bpsgZK6ROHL+UrffXHtO1dH45nBHb5wjtE5DNPYDdm1UBvdG2vEPBwKdFri
         sP8P2HXP7NMORfUc5n0fE3JEQA0C0o9TOswI1yyvL8Dw0lcsFErKevyML8kjWx2hplMO
         kB7ba5/cTEHUzFZiAw7N5rizLGQXCuSALthNf31syDXUP3FM0kE6YWBXAes+6Q66J5oX
         zo1a3Iz3Rmyo7ZaRnLKUmB8PZ5TGtsfzce0Zf1DgQOUr8jzdEZPKinekDZYncKp58i/9
         BAXDWIeQIAffPSv6Y7S/mCwpuY2bd++Oq0gwf6ppDaCVJbhI67Z9rAFgnTQVUf1AH3fh
         Swew==
X-Forwarded-Encrypted: i=1; AJvYcCVksY3K2OOP+ebjNYYM+1sETAUKAfIO6HodwVj/Gz610i1bQ0Rv/2RtInHqHmD5nWp27Iv3TwIJyBC2S0rr+Q+mtWo7
X-Gm-Message-State: AOJu0YwWiX6GJaj13IjnJEY++Jtb5GK4xsKB6FZM0QszjdFnegahHdD8
	Ppg1RPuaswmYc9AzWdmKt9J5mxKc3vxKlVkg+Ece3aH+JoJMzPCs4VfHS6CwKw==
X-Google-Smtp-Source: AGHT+IEkGs4CSbz/gwJsBDQ8mRLv3uu+Olu7bNWDsblBZs23v8KVVAp+lA23RbpWR6ezd91uErJiqg==
X-Received: by 2002:a17:90b:4acb:b0:2bd:f439:546b with SMTP id 98e67ed59e1d1-2c1ab9e3aaamr1154730a91.19.1717046407152;
        Wed, 29 May 2024 22:20:07 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1a775d28asm688632a91.8.2024.05.29.22.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 22:20:06 -0700 (PDT)
Date: Thu, 30 May 2024 05:20:02 +0000
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
Subject: Re: [PATCH v2 20/54] KVM: x86/pmu: Allow RDPMC pass through when all
 counters exposed to guest
Message-ID: <ZlgMgucwDSOhzV7f@google.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-21-mizhang@google.com>
 <f2a9d5ba-e0ae-41fb-ae54-2456c826ac2c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2a9d5ba-e0ae-41fb-ae54-2456c826ac2c@intel.com>

On Wed, May 08, 2024, Chen, Zide wrote:
> 
> 
> On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index a5024b7b0439..a18ba5ae5376 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7860,6 +7860,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  		vmx->msr_ia32_feature_control_valid_bits &=
> >  			~FEAT_CTL_SGX_LC_ENABLED;
> >  
> > +	if (kvm_pmu_check_rdpmc_passthrough(&vmx->vcpu))
> > +		exec_controls_clearbit(vmx, CPU_BASED_RDPMC_EXITING);
> > +	else
> > +		exec_controls_setbit(vmx, CPU_BASED_RDPMC_EXITING);
> > +
>
> Seems it's cleaner to put the code inside vmx_set_perf_global_ctrl(),
> and change the name to reflect that it handles all the PMU related VMCS
> controls.

I prefer putting them separately, but I think I could put the above code
into a different helper.

Thanks.
-Mingwei
> 
> >  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
> >  	vmx_update_exception_bitmap(vcpu);
> >  }

