Return-Path: <kvm+bounces-15176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8299C8AA4E3
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 23:54:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C40828224E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2CD199E97;
	Thu, 18 Apr 2024 21:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X9CCQAGP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA163178CE4
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 21:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713477279; cv=none; b=ZvQCNQCwEfFBm7Up0tMZEhv3MuYtlNvehK71fklcc/Ej80PV32YotLI7KhuZD8VRZZViACvr4Tdx5rklFaIfvaILF3Rc223dA1u0RF5dQtKwJfc0xLvWNVcKMtwJoFo0M+1OSZB2H460+Rxn+YnhtuBFiN+ZX+avbMUgQqyY1ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713477279; c=relaxed/simple;
	bh=/fIZnrTgxkprElJlF6zWXgMXsg0CVEGbxuta0DCFlM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIBVZJWcDlfqXfRpLC9VY0/EsKcHOoY5rDrDus2Z3JwrVoaaFfMIYQeXkmn4zU+KBQklPtv+rjWdojhQEL4qseJx3cVuNAuZFMtPGk28Z1myiIaY0m2ELuq7WezIJ/g9msLeUu98QsQEapdW+EIztozEdKrmrlNKN06w60/oSfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X9CCQAGP; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ed627829e6so1529792b3a.1
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713477277; x=1714082077; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UzoUB/DlZEEpnQQocpp8LNj0cC4Hbh3hYFeNjb1gymQ=;
        b=X9CCQAGPZ99SN2MkP9S6gDKVi6ocby6DNLHtZcj6MwvEp1nmeacQZb++EMmDCHE9+W
         aOvPUB4UsnBY0lgm7Zr7IlzW1DKehF5DXMEEMvXGFzYiquQWqHxaQen37pQB8PqD4T7N
         7PaE8vS0VkI31dEtGCbF3lUZeUvQ8kQ2r3ZOmmYyuEJXqI+04C5SRJiVk8fF+HTyFeDm
         h/kK/06ygZ+cPhZm5RBpMPsMZWf50zSVeEVOv9qlX7rD3Pj/gIyAGjjNDHxyQ8mNy+qV
         KAHXfbwEsbEBJJI8GKuoDyNPL2wJmeePkJKyP5NELwmOIWWbtjKgynB8UyjEgHdSuJqN
         /xNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713477277; x=1714082077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UzoUB/DlZEEpnQQocpp8LNj0cC4Hbh3hYFeNjb1gymQ=;
        b=SoXbtGADzdueVbWyKUL7W1DE5dBosXzHxprngSpOUd3E+77Rn9MYZntKsUDdG8e6Ox
         fBt9SjJh9uBJkcaK4XnR3vidkvY5UFchLShyU5EPHdoBKLDoZSM5crnjxRj9K3XXxvyg
         eVOF1mz1tv5JDQmNu1j0vAjyaLZeZavMNfB5zjMOIXsQX4dil5i1wdRVBNBUKzzj1IxM
         wAit5TeRfLZa4Do9PVBbwf+L476XSdu/+bNB6Rr8yPkfvlzAIuGihrfpjXhe9emMLZK6
         nJVyKLJsRNSdflMPpFt0hKApwK/rT7Y2hgnHOZnn+LS2ffrOga9oBaQMiwEXNjLgCYN7
         8T0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWYhLDEOpE+0DMS62FgK0wQmbZQ1EU6RfAgmnxrTOwl3HD9yIzp8xbueC1jV2oqHX1hA9p4iHp64sQHpz/GIFt6JSe2
X-Gm-Message-State: AOJu0YzdQLvMIn/FANeaCjewDvKhwmiSHdnbzNj8vxVz4Rr3vo3MOWQU
	rqOdrv8fASSqlwtnyHjdIKYk8mKxKd9wncvGZnMozv21HhVXzh5aUND5MY3Xaw==
X-Google-Smtp-Source: AGHT+IE3z+8bNqqr4xeyAId229RXIQ3OirfWY3drhqnoI012Iq7hg1mMY9eY9ZzsD1VRqnMYJE/4/g==
X-Received: by 2002:a05:6a00:2e8f:b0:6ea:86f2:24fb with SMTP id fd15-20020a056a002e8f00b006ea86f224fbmr541761pfb.25.1713477276564;
        Thu, 18 Apr 2024 14:54:36 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id z8-20020a056a00240800b006ecf6417a9bsm1970815pfh.29.2024.04.18.14.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 14:54:35 -0700 (PDT)
Date: Thu, 18 Apr 2024 21:54:32 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com, jmattson@google.com,
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com,
	eranian@google.com, irogers@google.com, samantha.alt@intel.com,
	like.xu.linux@gmail.com, chao.gao@intel.com
Subject: Re: [RFC PATCH 40/41] KVM: x86/pmu: Separate passthrough PMU logic
 in set/get_msr() from non-passthrough vPMU
Message-ID: <ZiGWmCgu8fGZHULu@google.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-41-xiong.y.zhang@linux.intel.com>
 <ZhhvyhdvF-1LZNlu@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhhvyhdvF-1LZNlu@google.com>

On Thu, Apr 11, 2024, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > From: Mingwei Zhang <mizhang@google.com>
> > 
> > Separate passthrough PMU logic from non-passthrough vPMU code. There are
> > two places in passthrough vPMU when set/get_msr() may call into the
> > existing non-passthrough vPMU code: 1) set/get counters; 2) set global_ctrl
> > MSR.
> > 
> > In the former case, non-passthrough vPMU will call into
> > pmc_{read,write}_counter() which wires to the perf API. Update these
> > functions to avoid the perf API invocation.
> > 
> > The 2nd case is where global_ctrl MSR writes invokes reprogram_counters()
> > which will invokes the non-passthrough PMU logic. So use pmu->passthrough
> > flag to wrap out the call.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/pmu.c |  4 +++-
> >  arch/x86/kvm/pmu.h | 10 +++++++++-
> >  2 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 9e62e96fe48a..de653a67ba93 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -652,7 +652,9 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		if (pmu->global_ctrl != data) {
> >  			diff = pmu->global_ctrl ^ data;
> >  			pmu->global_ctrl = data;
> > -			reprogram_counters(pmu, diff);
> > +			/* Passthrough vPMU never reprogram counters. */
> > +			if (!pmu->passthrough)
> 
> This should probably be handled in reprogram_counters(), otherwise we'll be
> playing whack-a-mole, e.g. this misses MSR_IA32_PEBS_ENABLE, which benign, but
> only because PEBS isn't yet supported.
> 
> > +				reprogram_counters(pmu, diff);
> >  		}
> >  		break;
> >  	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > index 0fc37a06fe48..ab8d4a8e58a8 100644
> > --- a/arch/x86/kvm/pmu.h
> > +++ b/arch/x86/kvm/pmu.h
> > @@ -70,6 +70,9 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
> >  	u64 counter, enabled, running;
> >  
> >  	counter = pmc->counter;
> > +	if (pmc_to_pmu(pmc)->passthrough)
> > +		return counter & pmc_bitmask(pmc);
> 
> Won't perf_event always be NULL for mediated counters?  I.e. this can be dropped,
> I think.

yeah. I double checked and seems when perf_event == NULL, the logic is
correct. If so, we can drop that.

Thanks.
-Mingwei

