Return-Path: <kvm+bounces-65191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 20697C9E101
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 08:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BFECD346627
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 07:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A032629B8EF;
	Wed,  3 Dec 2025 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H1KeWrEC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FB8220F47
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 07:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764747420; cv=none; b=Qifb1TzPSI68cVnbD/aHznosDNqv8e2eL2V1lI0yhvIAkdB82J3Dypxbwl4rRNrBBnHF3x+3KtY0TMXU0dcIvBzve2ieCY7hDFSfhrzhOUgoYpZUwrwV/JKSds0jjnoUi6skAUkR3Z7HYf85td9G91WIPCCU86iQKXdU79T/G7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764747420; c=relaxed/simple;
	bh=gam9OfGxugucsnHmzv6jS28VQx00K5Zo85K0AfjR5kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YzSdN//J61KznPf7E7SWAP/gdCozecjD6uxlHTULhHCUaHDyYL18w1y/fFBosf7Ls63Oe6BoVnw8wj2i6w+GNXFIL2uCE0U7ZSBnwo5Mv6HplwBWQFmOxC+v3rpH+oFcP4SWSCS5IN6+E4eKy3f6wpaETh8TJD821LUfq317p1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H1KeWrEC; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764747420; x=1796283420;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gam9OfGxugucsnHmzv6jS28VQx00K5Zo85K0AfjR5kM=;
  b=H1KeWrECD2U9Ea9f7q5H36Cs3CjnxRCkKmqAHEYCY4k40asYLdANRwns
   IG1YK6nE177wRXi/OYnEz+OZrGR8WbiTCn6VIZMmPdRQ2KjgKuE3asoLk
   VbrwhRE0PELKIqs93G6J5mGoxUsgWvM965Xx0/iyURHgPeqtgqbJ89laR
   /+S/sYNNL+DsZzyg76jYyYwWBznqTT7eePg64jMHisnWS9HW1yNeX0u34
   IktE4A2FknUKnQVAkMm5Tl9rculqKwJ18Jj6AsstmDCxzPuKGKI1LXIlN
   uDwz30vWG3lZ7939+JhXO2sUR9hEO+ISbXp1slf56Yk5vrtC9XIgCs2f2
   w==;
X-CSE-ConnectionGUID: RVk18bZ3R5uE4Sp9ypZOQw==
X-CSE-MsgGUID: NoxT0tfMQYK9agu6m3qurg==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="70589657"
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="70589657"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 23:36:59 -0800
X-CSE-ConnectionGUID: bwdHCBTDQXGYqXfwRTZ5Kw==
X-CSE-MsgGUID: IdPsXWdTSl6gGmFHnAy9fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="225277840"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 02 Dec 2025 23:36:54 -0800
Date: Wed, 3 Dec 2025 16:01:37 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>, John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v4 17/23] i386/cpu: Migrate MSR_IA32_PL0_SSP for FRED and
 CET-SHSTK
Message-ID: <aS/uYR8n7j4OjK/p@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
 <20251118034231.704240-18-zhao1.liu@intel.com>
 <3103289d-e86c-486d-a3c0-95d7615099c6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3103289d-e86c-486d-a3c0-95d7615099c6@redhat.com>

On Mon, Dec 01, 2025 at 06:01:48PM +0100, Paolo Bonzini wrote:
> Date: Mon, 1 Dec 2025 18:01:48 +0100
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: Re: [PATCH v4 17/23] i386/cpu: Migrate MSR_IA32_PL0_SSP for FRED
>  and CET-SHSTK
> 
> On 11/18/25 04:42, Zhao Liu wrote:
> > From: "Xin Li (Intel)" <xin@zytor.com>
> > 
> > Both FRED and CET-SHSTK need MSR_IA32_PL0_SSP, so add the vmstate for
> > this MSR.
> > 
> > When CET-SHSTK is not supported, MSR_IA32_PL0_SSP keeps accessible, but
> > its value doesn't take effect. Therefore, treat this vmstate as a
> > subsection rather than a fix for the previous FRED vmstate.
> > 
> > Tested-by: Farrah Chen <farrah.chen@intel.com>
> > Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> > Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > ---
> > Changes Since v3:
> >   - New commit.
> > ---
> >   target/i386/machine.c | 26 ++++++++++++++++++++++++++
> >   1 file changed, 26 insertions(+)
> > 
> > diff --git a/target/i386/machine.c b/target/i386/machine.c
> > index 45b7cea80aa7..0a756573b6cd 100644
> > --- a/target/i386/machine.c
> > +++ b/target/i386/machine.c
> > @@ -1668,6 +1668,31 @@ static const VMStateDescription vmstate_triple_fault = {
> >       }
> >   };
> > +static bool pl0_ssp_needed(void *opaque)
> > +{
> > +    X86CPU *cpu = opaque;
> > +    CPUX86State *env = &cpu->env;
> > +
> > +#ifdef TARGET_X86_64
> > +    if (env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
> > +        return true;
> > +    }
> > +#endif
> > +
> > +    return !!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK);
> 
> Can you just make it return "!!(env->pl0_ssp)"?  If all of these bits are
> zero the MSR will not be settable, and this way you can migrate VMs as long
> as they don't use PL0_SSP.

Yes, it's a good idea.

Thanks,
Zhao



