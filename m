Return-Path: <kvm+bounces-53501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38264B129C6
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 10:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D12023A85C0
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 08:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C167121E094;
	Sat, 26 Jul 2025 08:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="E2ZYAvTE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568DF19F461
	for <kvm@vger.kernel.org>; Sat, 26 Jul 2025 08:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753520345; cv=none; b=ciffmrEPOzJ/vsXES4iDgdG23vBoVMzJ+dg57Q5G37YqSCccm2YrLto/dTZYBKylvH/PPF0o4eUAXXy++RoOXnEAoAewpYvPJZLY12uCeQBvx6Np2dAM2mn/9imz71vPeJOpLfKaWIHxE38vkm1I99F5vkLPhTwZOBhoR8ijxNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753520345; c=relaxed/simple;
	bh=BAlyNZBIlPoNcyJn72zqkAHVHCI4YLaoZhEYbwrktkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoJE+jWmivlI72r3IDnT/Dr3yBuN+sTIJSEaTtHff98AXe449mgWl6Ah47JEH3Yg5SptO7EWbBiEvOtLduzZ0T+dP4f1BIXyUiS1ikLfB+Cbh+d1IiISjVpeK9blH/HByuASifiCm6imDezZRAd1GnJrr+OUgAOLhtO6xLdNBA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=E2ZYAvTE; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2350b1b9129so20393355ad.0
        for <kvm@vger.kernel.org>; Sat, 26 Jul 2025 01:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1753520340; x=1754125140; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IsSwfYx72SBzxWb7IltAxR/7pX8mu/ij+8zDC/fxnNE=;
        b=E2ZYAvTE5NTjaik8ICEcC8vs9mEDwedtonIM0Nn70yqutUkIUtLypEhK8J37IXwR+x
         MuWIYyGBwAuzzOgTVPQCvrK55HQQwixuJ5vs8Dlfc0WFDcogFxlWP72sbpMUkZ6O1qGf
         m7ScLjuWhoMwhcyC67nIyWdf6DLFutsIkn12LiIej5/ha/o/tzFP1nyH0JKLlGuvgJVh
         WCSVDptXAhYocqhU1rqk8oleLDLPPI2a92juYBWSbcamOWG6kgv7jzr67mgkTdV9PQ8V
         sy3QtLq4Nuby8ATK8eR48CBGVvkye2Lhq8mupWOXHBvZeCIgJwts7OGLkqxiydax9pFv
         DP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753520340; x=1754125140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsSwfYx72SBzxWb7IltAxR/7pX8mu/ij+8zDC/fxnNE=;
        b=GPuOGrrD2neaRQGOZ9DUO4ABmTkKEsl7uW8TN4ih2sOdOgvxVyIQxkq1C8tjPAKNbw
         9R5TVzTyHLGPl0QbTZaL5J3TPKfDE4f8nqTk3/tYLQS1pxYyv0On8jPmt2ZlNR7FtGbU
         p/9kw+QEG2qX0D7TpsvwSv0eBw7RPiQQCmhWyUKPFc10Ux66ammNa79nUjCFlzsWTL2H
         97xZmDcGGDB0OZ76sRAAw8O6SBvodHwvgcHo+tji+tKYnnIieNT6Gsxpm6NwxyH4QUDj
         ZFkeLakPSsY16Sbw7J50IVwy7/da9rDnxnE1elLAWnHyvwj2QlrN4Os3uUIIimWJL5JR
         IUpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJQnK+ZkrujfAjOKbo7oEkSuXZoG2q2aXXnX/c7+LY1uMFPTDfJzbk036wm0NiGYsFuWU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKOrqj4tjm5cDUApl1s6uLBG8AUSnkj9f8BExikkCTSPBXSK69
	+WlUdGnFBLPXeq0t1DzCtCJKYEBp2j7NTGsh2W9FqrpfMD0mWdWI/jOX03itKi+ptrHQ0a6Cdcd
	jLx1bgppERm5oXORbqospq+NR2nLr1UuSfJv/TVwWW8SSmDVIXW3ntWNjJcN1reE=
X-Gm-Gg: ASbGncuOAJgfvWVJFuysSuFclri9lXHn4rMpVhZ7f5C9Dn4DMOo5GGPude46+Zow/92
	grJwaFQE1ouTO05PnJBijDusUEFRZ2UXcwzG8GEoR02kEGBbGPTwPLt5clUNatVJMkwvLDiS5WD
	rKNS3bAUG+yDSgnvM/Et33zEpN/o59Avr0QCgL99nrXH2AGP7tsYJ8o2RxfIBdeAMBcLp6MvT93
	HNUGPdQOj32V/Ld5wQHFlN1oUyenq4K+H1hbGHKw71Ongi01q36wcplBWZ9aiTHkZfcQNLrDmBC
	75PbaAFLAG7ir438udoadQs3CJcWTXJySGGfdgTG/0Uzl3qIG7iqxLgc0RgMhslPSl+3fIby/mh
	FeGMO04skOyl5Wm+yvKt2xZIeMYzXszI+a2LMw1wtl/LwaJ9ekdFP2JMDeGTbNEXz2k56Dhs=
X-Google-Smtp-Source: AGHT+IGSfqKHy9SGFb/1/uiPQ8AY7vue0rGViceJfxWSMYoCR4FrxJn5LaDGauIUCkJl8iR0dcK/wA==
X-Received: by 2002:a17:903:3bcc:b0:23f:adc0:8ccb with SMTP id d9443c01a7336-23fb3030e96mr62904435ad.16.1753520340556;
        Sat, 26 Jul 2025 01:59:00 -0700 (PDT)
Received: from zenbook (1-162-100-110.dynamic-ip.hinet.net. [1.162.100.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe4fc7dasm13280705ad.116.2025.07.26.01.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jul 2025 01:59:00 -0700 (PDT)
Date: Sat, 26 Jul 2025 17:01:25 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>, Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will@kernel.org>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v2 5/6] arm64: add FEAT_E2H0 support (TBC)
Message-ID: <zbgu6irpeytcpymaxpg55tvijeppfpdpwcju275g3h6bx4u5qn@35vb5ymt55hx>
References: <20250725144100.2944226-1-andre.przywara@arm.com>
 <20250725144100.2944226-6-andre.przywara@arm.com>
 <86cy9o8bwn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cy9o8bwn.wl-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi all,

On Fri, Jul 25, 2025 at 05:37:12PM +0100, Marc Zyngier wrote:
> Hi Andre,
> 
> Thanks for picking this. A few nits below.
> 
> On Fri, 25 Jul 2025 15:40:59 +0100,
> Andre Przywara <andre.przywara@arm.com> wrote:
> > 
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > To reduce code complexity, KVM only supports nested virtualisation in
> > VHE mode. So to allow recursive nested virtualisation, and be able to
> > expose FEAT_NV2 to a guest, we must prevent a guest from turning off
> > HCR_EL2.E2H, which is covered by not advertising the FEAT_E2H0 architecture
> > feature.
> > 
> > To allow people to run a guest in non-VHE mode, KVM introduced the
> > KVM_ARM_VCPU_HAS_EL2_E2H0 feature flag, which will allow control over
> > HCR_EL2.E2H, but at the cost of turning off FEAT_NV2.
> 
> All of that has been captured at length in the kernel code, and I
> think this is "too much information" for userspace. I'd rather we
> stick to a pure description of what the various options mean to the
> user.
> 
> > Add a kvmtool command line option "--e2h0" to set that feature bit when
> > creating a guest, to gain non-VHE, but lose recursive nested virt.
> 
> How about:
> 
> "The --nested option allows a guest to boot at EL2 without FEAT_E2H0
>  (i.e. mandating VHE support). While this is great for "modern"
>  operating systems and hypervisors, a few legacy guests are stuck in a
>  distant past.
> 
>  To support those, the --e2h0 option exposes FEAT_E2H0 to the guest,
>  at the expense of a number of other features, such as FEAT_NV2. This

Just a very small thing:

Will only mentioning FEAT_NV2 here lead people to think that FEAT_NV is
still available with --e2h0?
Maybe s/FEAT_NV2/FEAT_NV/ makes it clearer?

Thanks,
Wei-Lin Chang

>  is conditioned on the host itself supporting FEAT_E2H0."
> 
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm64/include/kvm/kvm-config-arch.h | 5 ++++-
> >  arm64/kvm-cpu.c                     | 2 ++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
> > index 44c43367b..73bf4211a 100644
> > --- a/arm64/include/kvm/kvm-config-arch.h
> > +++ b/arm64/include/kvm/kvm-config-arch.h
> > @@ -11,6 +11,7 @@ struct kvm_config_arch {
> >  	bool		has_pmuv3;
> >  	bool		mte_disabled;
> >  	bool		nested_virt;
> > +	bool		e2h0;
> >  	u64		kaslr_seed;
> >  	enum irqchip_type irqchip;
> >  	u64		fw_addr;
> > @@ -63,6 +64,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
> >  	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
> >  		"Specify the counter offset, defaulting to 0"),			\
> >  	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
> > -		    "Start VCPUs in EL2 (for nested virt)"),
> > +		    "Start VCPUs in EL2 (for nested virt)"),			\
> > +	OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,					\
> > +		    "Create guest without VHE support"),
> >  
> >  #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> > diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
> > index 42dc11dad..6eb76dff4 100644
> > --- a/arm64/kvm-cpu.c
> > +++ b/arm64/kvm-cpu.c
> > @@ -76,6 +76,8 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
> >  		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
> >  			die("EL2 (nested virt) is not supported");
> >  		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
> > +		if (kvm->cfg.arch.e2h0)
> > +			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
> 
> This really should also check the capability in order to fail
> gracefully on system that have no E2H0 support at all (or have it so
> buggy that it is permanently disabled by the kernel):
> 
> +		if (kvm->cfg.arch.e2h0) {
> +	  		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2_E2H0))
> +				die("FEAT_E2H0 is not supported");
> +			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
> +		}
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

