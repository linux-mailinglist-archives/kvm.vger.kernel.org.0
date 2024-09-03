Return-Path: <kvm+bounces-25712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22AFE96952A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE6512836E4
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D851DAC7E;
	Tue,  3 Sep 2024 07:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aq4Y3IbE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EDA1DAC6D;
	Tue,  3 Sep 2024 07:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725348003; cv=none; b=kkkCCq777hOePg9NYUATWCGVd8zV8BHhEgkPPYssZkQlse2+MzyvAbUgxqKrU8hoj2tGWRYyMvk14HNgENPvCrz3mYnBSbMACaoOmiLedaKzoM8LnE6FUzH3OY2zxG6eQJYrwU6M9kaAzUFuzXdO8Zoyi4FrxMEhFih3nmBg58I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725348003; c=relaxed/simple;
	bh=DHW7NICE+LcNrqAW7xjgjiuqbTvKnJhwbzK7L48yvQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WndDZ8PsuLc4/131d83PeuncG00PvF4p7qf/cD5V+PzOD/6mb1cbB8I4fTtXiZZm4z1ucL8lxkgxPLIXuRYE9ad3VYA8KwzbkbiWIspdwl0Fhhp0jdjmV0QMG64nWealM9vvgecq6Zsb3cGFJpz+dDaXcEla2d9gXuyX/Yn9xLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aq4Y3IbE; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725348001; x=1756884001;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DHW7NICE+LcNrqAW7xjgjiuqbTvKnJhwbzK7L48yvQk=;
  b=aq4Y3IbE2sKTsIT/zq8dxclOvfqiE+RQg+t2uqijuR96Cr0tNDtjC9ib
   Pb8IocSbRJDNtKNIBMAJXJBLD8M3r30gU/63jwjhYpc1CZecqGEauc10j
   Ep2hNzgJR4EqbOjO2JxiGfn9Su9TqmIw2VG9kooq1VUvOlPnMoTIYutQM
   JER3IGbrxrwcfkZhBLEteAGa9AhxFhULqYEDs3ak/nhGMmYYSGSllztON
   s9+9Y8CP/izgnFSLiFAYaMzTl5lQ8eF1vhOrPLEynOo065UgtB5j8gVH3
   fT9Oj5eC0zztQGfx8BwrAMLwjM0Ro4z41ZEERKVgyd3z6P/DCDzTdP7qg
   g==;
X-CSE-ConnectionGUID: EY5TV3eXRYiWYVsz9/oAmA==
X-CSE-MsgGUID: 458xvi4eTl+4ALz6Gc4PlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="13339616"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="13339616"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:19:53 -0700
X-CSE-ConnectionGUID: G83tkmQXS3mEurencB8+gQ==
X-CSE-MsgGUID: 8K9DLz4pQfSYV6zolKDtgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="69675664"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.115])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:19:48 -0700
Date: Tue, 3 Sep 2024 10:19:37 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Message-ID: <Zta4if4oEHiAIkz7@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
 <ZsLRyk5F9SRgafIO@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsLRyk5F9SRgafIO@yilunxu-OptiPlex-7050>

On Mon, Aug 19, 2024 at 01:02:02PM +0800, Xu Yilun wrote:
> On Mon, Aug 12, 2024 at 03:48:16PM -0700, Rick Edgecombe wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > +static int tdx_mask_cpuid(struct kvm_tdx *tdx, struct kvm_cpuid_entry2 *entry)
> > +{
> > +	u64 field_id = TD_MD_FIELD_ID_CPUID_VALUES;
> > +	u64 ebx_eax, edx_ecx;
> > +	u64 err = 0;
> > +
> > +	if (entry->function & TDX_MD_UNREADABLE_LEAF_MASK ||
> > +	    entry->index & TDX_MD_UNREADABLE_SUBLEAF_MASK)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * bit 23:17, REVSERVED: reserved, must be 0;
> > +	 * bit 16,    LEAF_31: leaf number bit 31;
> > +	 * bit 15:9,  LEAF_6_0: leaf number bits 6:0, leaf bits 30:7 are
> > +	 *                      implicitly 0;
> > +	 * bit 8,     SUBLEAF_NA: sub-leaf not applicable flag;
> > +	 * bit 7:1,   SUBLEAF_6_0: sub-leaf number bits 6:0. If SUBLEAF_NA is 1,
> > +	 *                         the SUBLEAF_6_0 is all-1.
> > +	 *                         sub-leaf bits 31:7 are implicitly 0;
> > +	 * bit 0,     ELEMENT_I: Element index within field;
> > +	 */
> > +	field_id |= ((entry->function & 0x80000000) ? 1 : 0) << 16;
> > +	field_id |= (entry->function & 0x7f) << 9;
> > +	if (entry->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)
> > +		field_id |= (entry->index & 0x7f) << 1;
> > +	else
> > +		field_id |= 0x1fe;
> > +
> > +	err = tdx_td_metadata_field_read(tdx, field_id, &ebx_eax);
> > +	if (err) //TODO check for specific errors
> > +		goto err_out;
> > +
> > +	entry->eax &= (u32) ebx_eax;
> > +	entry->ebx &= (u32) (ebx_eax >> 32);
> 
> Some fields contains a N-bits wide value instead of a bitmask, why a &=
> just work?

There's the CPUID 0x80000008 workaround, I wonder if we are missing some
other handling though. Do you have some specific CPUIDs bits in mind to
check?

The handling for the supported CPUID values mask from the TDX module is
a bit unclear for sure :)

> > +static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> > +{
> > +	struct kvm_cpuid2 __user *output, *td_cpuid;
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +	struct kvm_cpuid2 *supported_cpuid;
> > +	int r = 0, i, j = 0;
> > +
> > +	output = u64_to_user_ptr(cmd->data);
> > +	td_cpuid = kzalloc(sizeof(*td_cpuid) +
> > +			sizeof(output->entries[0]) * KVM_MAX_CPUID_ENTRIES,
> > +			GFP_KERNEL);
> > +	if (!td_cpuid)
> > +		return -ENOMEM;
> > +
> > +	r = tdx_get_kvm_supported_cpuid(&supported_cpuid);
> 
> Personally I don't like the definition of this function. I need to look
> into the inner implementation to see if kfree(supported_cpuid); is needed
> or safe. How about:
> 
>   supported_cpuid = tdx_get_kvm_supported_cpuid();
>   if (!supported_cpuid)
> 	goto out_td_cpuid;

So allocate in tdx_get_kvm_supported_cpuid() and the caller frees. Sounds
cleaner to me.

> > +		/*
> > +		 * Work around missing support on old TDX modules, fetch
> > +		 * guest maxpa from gfn_direct_bits.
> > +		 */
> > +		if (output_e->function == 0x80000008) {
> > +			gpa_t gpa_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
> > +			unsigned int g_maxpa = __ffs(gpa_bits) + 1;
> > +
> > +			output_e->eax &= ~0x00ff0000;
> > +			output_e->eax |= g_maxpa << 16;
> 
> Is it possible this workaround escapes the KVM supported bits check?

Yes it might need a mask for (g_maxpa << 16) & 0x00ff0000 to avoid setting
the wrong bits, will check.

...
> > +out:
> > +	kfree(td_cpuid);
> > +	kfree(supported_cpuid);
> 
> Traditionally we do:
> 
>   out_supported_cpuid:
> 	kfree(supported_cpuid);
>   out_td_cpuid:
> 	kfree(td_cpuid);
> 
> I'm not sure what's the advantage to make people think more about whether
> kfree is safe.

I'll do a patch for this thanks.

> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -25,6 +25,11 @@ struct kvm_tdx {
> >  	bool finalized;
> >  
> >  	u64 tsc_offset;
> > +
> > +	/* For KVM_MAP_MEMORY and KVM_TDX_INIT_MEM_REGION. */
> > +	atomic64_t nr_premapped;
> 
> This doesn't belong to this patch.
> 
> > +
> > +	struct kvm_cpuid2 *cpuid;
> 
> Didn't find the usage of this field.

Thanks will check and drop.

Regards,

Tony

