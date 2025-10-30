Return-Path: <kvm+bounces-61489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A479C21006
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 74A354ECD43
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 15:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 833DF3655F2;
	Thu, 30 Oct 2025 15:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I3C8cnKH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A903655E2
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 15:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761838944; cv=none; b=QkzHPYUApkEONkTTBm4KOZ+6zmBsj0VZGFpA1EA3oAFciE6tUctikoEfUBYr2RDHwjljtxYHLSlk5gtAnmpvuio5aRc6FVWxITSx2ZYoYU8YbcP9WcUQ22ZH/5DJa+clAS+EaPKk7Tu15jnms1K3HvX+jKt81k8rgMteGF2QutE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761838944; c=relaxed/simple;
	bh=G82bnRITGyqKjw4vCwsGZ99kE0549Ia3SE8bIF8kwK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNGKRoWONFldA3nQiKTlLuM0lkJoKy9hHlusxuhs72oKHn+rj7Kc+ms/5Bor/OkPIol2rO3LE0FgHoklsq/++0xGJ1qHG7fEYoSzt2QWmPhImtaYOIfxfBN4Juv/yLgnCmtXtxoNg+x5gWtMz5htHdlg3uZCb7ryeRgnGMMJtjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I3C8cnKH; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761838943; x=1793374943;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G82bnRITGyqKjw4vCwsGZ99kE0549Ia3SE8bIF8kwK0=;
  b=I3C8cnKH/iUyu132PwMN6KUXLjf7j2QWvtsrVgNAzUifF9U0yJunRdsz
   o8fEwYf44pXPJ9aCStSOf3WNMGaZ20Gd5fpilLGfc6B3u7WkE/3v0Ne2t
   8yXc3q6obuPz3tHx3VSGe2HSqM8vzkxfbrV8sjTiqqD+5WfhHbU4ZfyJ9
   dcOshL68cQtAEeYcDewQtqxisX/pfNo4TEFbGPprXsEx2xqYMiFTBWOFF
   d3l29ow504m8SZrXlR3BYOar3nINxlmwG16PmPtJSLb8SFzTtRru9OgLZ
   sh36Z/M8Yn0vhdm1ChXgvYnYuoETWuF/VOdjzhsLXeTXCqC7vQs+ss5cc
   g==;
X-CSE-ConnectionGUID: fQfTRa2MQIOhnehCSpBBbg==
X-CSE-MsgGUID: GK0AU3UMT1a7eGspuGVKFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63684838"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="63684838"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 08:42:23 -0700
X-CSE-ConnectionGUID: LzuJ36b8QLq7/qznGsTrwA==
X-CSE-MsgGUID: G6SewhZcS8q1HQtR95fX1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185678709"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 30 Oct 2025 08:42:18 -0700
Date: Fri, 31 Oct 2025 00:04:30 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: Re: [PATCH v3 15/20] i386/machine: Add vmstate for cet-ss and cet-ibt
Message-ID: <aQOMjlHnjgwdYfFX@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-16-zhao1.liu@intel.com>
 <445462e9-22e5-4e8b-999e-7be468731752@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <445462e9-22e5-4e8b-999e-7be468731752@intel.com>

On Tue, Oct 28, 2025 at 04:29:58PM +0800, Xiaoyao Li wrote:
> Date: Tue, 28 Oct 2025 16:29:58 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v3 15/20] i386/machine: Add vmstate for cet-ss and
>  cet-ibt
> 
> On 10/24/2025 2:56 PM, Zhao Liu wrote:
> > From: Yang Weijiang <weijiang.yang@intel.com>
> > 
> > Add vmstates for cet-ss and cet-ibt
> > 
> > Tested-by: Farrah Chen <farrah.chen@intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > Co-developed-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > ---
> > Changes Since v2:
> >   - Split a subsection "vmstate_ss" since shstk is user-configurable.
> > ---
> >   target/i386/machine.c | 53 +++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 53 insertions(+)
> > 
> > diff --git a/target/i386/machine.c b/target/i386/machine.c
> > index 45b7cea80aa7..3ad07ec82428 100644
> > --- a/target/i386/machine.c
> > +++ b/target/i386/machine.c
> > @@ -1668,6 +1668,58 @@ static const VMStateDescription vmstate_triple_fault = {
> >       }
> >   };
> > +static bool shstk_needed(void *opaque)
> > +{
> > +    X86CPU *cpu = opaque;
> > +    CPUX86State *env = &cpu->env;
> > +
> > +    return !!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK);
> > +}
> > +
> > +static const VMStateDescription vmstate_ss = {
> > +    .name = "cpu/cet_ss",
> > +    .version_id = 1,
> > +    .minimum_version_id = 1,
> > +    .needed = shstk_needed,
> > +    .fields = (VMStateField[]) {
> > +        VMSTATE_UINT64(env.pl0_ssp, X86CPU),
> > +        VMSTATE_UINT64(env.pl1_ssp, X86CPU),
> > +        VMSTATE_UINT64(env.pl2_ssp, X86CPU),
> > +        VMSTATE_UINT64(env.pl3_ssp, X86CPU),
> > +#ifdef TARGET_X86_64
> > +        /* This MSR is only present on Intel 64 architecture. */
> > +        VMSTATE_UINT64(env.int_ssp_table, X86CPU),
> > +#endif
> 
> It seems we need to split int_ssp_table into a separate vmstate_*
> 
> Its .needed function needs to check both  CPUID_7_0_ECX_CET_SHSTK &&
> CPUID_EXT2_LM.

Ok, will split this entry into a subsection. Thanks.

> > +        VMSTATE_UINT64(env.guest_ssp, X86CPU),
> > +        VMSTATE_END_OF_LIST()
> > +    }
> > +};
> > +
> > +static bool cet_needed(void *opaque)
> > +{
> > +    X86CPU *cpu = opaque;
> > +    CPUX86State *env = &cpu->env;
> > +
> > +    return !!((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) ||
> > +              (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT));
> > +}
> > +
> > +static const VMStateDescription vmstate_cet = {
> > +    .name = "cpu/cet",
> > +    .version_id = 1,
> > +    .minimum_version_id = 1,
> > +    .needed = cet_needed,
> > +    .fields = (VMStateField[]) {
> > +        VMSTATE_UINT64(env.u_cet, X86CPU),
> > +        VMSTATE_UINT64(env.s_cet, X86CPU),
> > +        VMSTATE_END_OF_LIST()
> > +    },
> > +    .subsections = (const VMStateDescription * const []) {
> > +        &vmstate_ss,

here:       ^^^^^^^^^^^^^

> > +        NULL,
> > +    },
> > +};
> > +
> >   const VMStateDescription vmstate_x86_cpu = {
> >       .name = "cpu",
> >       .version_id = 12,
> > @@ -1817,6 +1869,7 @@ const VMStateDescription vmstate_x86_cpu = {
> >   #endif
> >           &vmstate_arch_lbr,
> >           &vmstate_triple_fault,
> > +        &vmstate_cet,
> 
> missing &vmstate_ss

I made vmstate_ss as a subsection in vmstate_cet

Regards,
Zhao


