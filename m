Return-Path: <kvm+bounces-17796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E81BF8CA29C
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 21:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1767C1C21114
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 19:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6081386B3;
	Mon, 20 May 2024 19:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lz++x3Gq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC3CE552;
	Mon, 20 May 2024 19:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716232491; cv=none; b=WmjM4k0iItKIqeNFGQP7G6LIzOjReR9DFfMxX1voOR+bxWPe6Mpy6Hv2uSVkaDHkcZlN6pQXN1QKyZ4F6c8krift2RleE+LIqli+ieS89a2vvjsoqgC9Jma4ITvDVMbbgK75PnWV+n7vSlsXbBbNYiRoEc1DMa71TqBL7LsaHkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716232491; c=relaxed/simple;
	bh=JMmxMc4KxFDgWYo64T8S+XbqNNYGK47LMWQHk3hYL4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pt5B1bzTzMD/COuFpexsjkwlucG1ephOREpypwSPBR38aNhRGwF51e467bN18YS9yjIB60sG1BDOEGVYtNlGogJa+zJE0upYTojVdq8yA6HVWcood41DsNlIvl6yKeZe2HdegPAwcQbw3U+Y/SekWTpVMQ0gssPIpr+nCGQnlZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lz++x3Gq; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716232489; x=1747768489;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JMmxMc4KxFDgWYo64T8S+XbqNNYGK47LMWQHk3hYL4g=;
  b=Lz++x3Gqebd7BRbH7USCZOiuaLscP+s17VYWiGr0ZABagpIPK9GOhHWV
   yBwel/EXPBkQQwWKz7DLC9KU0JqZpyGO8ST0UUy1pyleO9HzSqVg1jh5C
   QJyvVcEiSkk5UXP0VainPi53omG0pYTSGVby9jD+pKse2LTQZrnkpKPmR
   NNBrN8GFqk06+vqpSeOHnJN3eD1SjGvPu1IyIe1aiYvmZt1Oc1GgNdSqO
   KTyRhKMZ5Kot8lxCgGaFwdUc4bS4HETaV+VuGAQMGcFcoC3dqzvjURDqA
   cJOZ+uD1VFZ+8BdzPjRkpTlmzuASdSJP+hWBGhPQXQdv+lfTAkRl0Skp+
   Q==;
X-CSE-ConnectionGUID: OCMtqep3Ss2ZlBBBPLAfCQ==
X-CSE-MsgGUID: mhWXYgOoQFWx/VUUBb5Hhg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12178323"
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="12178323"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 12:14:48 -0700
X-CSE-ConnectionGUID: hcN/iEklQZy2RiPWZ3fsxw==
X-CSE-MsgGUID: UFs0ZNCiQ8OklrWpLsAV+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="63470070"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 12:14:47 -0700
Date: Mon, 20 May 2024 12:14:47 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"tobin@ibm.com" <tobin@ibm.com>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>,
	"alpergun@google.com" <alpergun@google.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"jmattson@google.com" <jmattson@google.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"ak@linux.intel.com" <ak@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
	"slp@redhat.com" <slp@redhat.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"seanjc@google.com" <seanjc@google.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
	"Rodel, Jorg" <jroedel@suse.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"kirill@shutemov.name" <kirill@shutemov.name>,
	"jarkko@kernel.org" <jarkko@kernel.org>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	isaku.yamahata@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v15 13/20] KVM: SEV: Implement gmem hook for initializing
 private pages
Message-ID: <20240520191447.GB22775@ls.amr.corp.intel.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-14-michael.roth@amd.com>
 <41d8ba3a48d33de82baa67ef5ee88e5f8995aea8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <41d8ba3a48d33de82baa67ef5ee88e5f8995aea8.camel@intel.com>

On Mon, May 20, 2024 at 10:16:54AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Wed, 2024-05-01 at 03:52 -0500, Michael Roth wrote:
> > This will handle the RMP table updates needed to put a page into a
> > private state before mapping it into an SEV-SNP guest.
> > 
> > 
> 
> [...]
> 
> > +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	kvm_pfn_t pfn_aligned;
> > +	gfn_t gfn_aligned;
> > +	int level, rc;
> > +	bool assigned;
> > +
> > +	if (!sev_snp_guest(kvm))
> > +		return 0;
> > +
> > +	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
> > +	if (rc) {
> > +		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %llx error %d\n",
> > +				   gfn, pfn, rc);
> > +		return -ENOENT;
> > +	}
> > +
> > +	if (assigned) {
> > +		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
> > +			 __func__, gfn, pfn, max_order, level);
> > +		return 0;
> > +	}
> > +
> > +	if (is_large_rmp_possible(kvm, pfn, max_order)) {
> > +		level = PG_LEVEL_2M;
> > +		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
> > +		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
> > +	} else {
> > +		level = PG_LEVEL_4K;
> > +		pfn_aligned = pfn;
> > +		gfn_aligned = gfn;
> > +	}
> > +
> > +	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
> > +	if (rc) {
> > +		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
> > +				   gfn, pfn, level, rc);
> > +		return -EINVAL;
> > +	}
> > +
> > +	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
> > +		 __func__, gfn, pfn, pfn_aligned, max_order, level);
> > +
> > +	return 0;
> > +}
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index b70556608e8d..60783e9f2ae8 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5085,6 +5085,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> >  	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
> >  	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
> > +
> > +	.gmem_prepare = sev_gmem_prepare,
> >  };
> >  
> > 
> 
> +Rick, Isaku,
> 
> I am wondering whether this can be done in the KVM page fault handler?
> 
> The reason that I am asking is KVM will introduce several new
> kvm_x86_ops::xx_private_spte() ops for TDX to handle setting up the
> private mapping, and I am wondering whether SNP can just reuse some of
> them so we can avoid having this .gmem_prepare():

Although I can't speak for SNP folks, I guess those hooks doesn't make sense for
them.  I guess they want to stay away from directly modifying the TDP MMU to add
hooks to the TDP MMU.  Instead, They intentionally chose to add hooks to
guest_memfd.  Maybe it's possible for SNP to use those hooks, what's the benefit
for SNP?

If you're looking for the benefit to allow the hooks of the TDP MMU for shared
page table, what about other vm type? SW_PROTECTED or future one?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

