Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524A41E926B
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 17:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbgE3P6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 11:58:31 -0400
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:60224 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729029AbgE3P6a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 30 May 2020 11:58:30 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 9CCB74DD8;
        Sat, 30 May 2020 15:58:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2894:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:4321:4605:5007:7903:8603:10004:10400:10848:11026:11232:11658:11914:12043:12048:12296:12297:12438:12740:12760:12895:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:3,LUA_SUMMARY:none
X-HE-Tag: ink56_0c0299e26d6d
X-Filterd-Recvd-Size: 2145
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Sat, 30 May 2020 15:58:28 +0000 (UTC)
Message-ID: <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
Subject: Re: [PATCH] KVM: Use previously computed array_size()
From:   Joe Perches <joe@perches.com>
To:     Denis Efremov <efremov@linux.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 30 May 2020 08:58:26 -0700
In-Reply-To: <20200530143558.321449-1-efremov@linux.com>
References: <20200530143558.321449-1-efremov@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2020-05-30 at 17:35 +0300, Denis Efremov wrote:
> array_size() is used in alloc calls to compute the allocation
> size. Next, "raw" multiplication is used to compute the size
> for copy_from_user(). The patch removes duplicated computation
> by saving the size in a var. No security concerns, just a small
> optimization.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>

Perhaps use vmemdup_user?

> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
[]
> @@ -184,14 +184,13 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  		goto out;
>  	r = -ENOMEM;
>  	if (cpuid->nent) {
> -		cpuid_entries =
> -			vmalloc(array_size(sizeof(struct kvm_cpuid_entry),
> -					   cpuid->nent));
> +		const size_t size = array_size(sizeof(struct kvm_cpuid_entry),
> +					       cpuid->nent);
> +		cpuid_entries = vmalloc(size);
>  		if (!cpuid_entries)
>  			goto out;
>  		r = -EFAULT;
> -		if (copy_from_user(cpuid_entries, entries,
> -				   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
> +		if (copy_from_user(cpuid_entries, entries, size))

		cpuid_entries = vmemdup_user(entries,
					     array_size(sizeof(struct kvm_cpuid_entry), cpuid->nent));
		if (IS_ERR(cpuid_entries))
			...

etc...


