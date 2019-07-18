Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7799A6C8A2
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 07:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfGRFSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 01:18:51 -0400
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:44853 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725959AbfGRFSv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jul 2019 01:18:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id C4B22180A68BF;
        Thu, 18 Jul 2019 05:18:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2559:2563:2682:2685:2692:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:6119:6120:7901:7903:8531:8985:9025:10004:10400:10848:11026:11232:11658:11854:11914:12043:12296:12297:12438:12555:12740:12760:12895:12986:13069:13095:13311:13357:13439:14181:14659:14721:14777:21080:21212:21433:21627:21819:30034:30045:30054:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: power11_12a7847651600
X-Filterd-Recvd-Size: 2231
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Thu, 18 Jul 2019 05:18:48 +0000 (UTC)
Message-ID: <9eda0e29f524275a217411ea81352271b782baa4.camel@perches.com>
Subject: Re: [PATCH] KVM: x86/vPMU: refine kvm_pmu err msg when event
 creation failed
From:   Joe Perches <joe@perches.com>
To:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Avi Kivity <avi@scylladb.com>
Cc:     kvm@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        like.xu@linux.inetl.com, linux-kernel@vger.kernel.org
Date:   Wed, 17 Jul 2019 22:18:46 -0700
In-Reply-To: <20190718044914.35631-1-like.xu@linux.intel.com>
References: <20190718044914.35631-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-07-18 at 12:49 +0800, Like Xu wrote:
> If a perf_event creation fails due to any reason of the host perf
> subsystem, it has no chance to log the corresponding event for guest
> which may cause abnormal sampling data in guest result. In debug mode,
> this message helps to understand the state of vPMC and we should not
> limit the number of occurrences.
[]
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
[]
> @@ -131,8 +131,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  						 intr ? kvm_perf_overflow_intr :
>  						 kvm_perf_overflow, pmc);
>  	if (IS_ERR(event)) {
> -		printk_once("kvm_pmu: event creation failed %ld\n",
> -			    PTR_ERR(event));
> +		pr_debug("kvm_pmu: event creation failed %ld\n for pmc->idx = %d",
> +			    PTR_ERR(event), pmc->idx);

Perhaps this was written as printk_once to avoid
spamming the log with repeated messages.

Maybe this should use pr_debug_ratelimited.
(and it should also have a \n termination like:)

		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
				     PTR_ERR(event), pmc->idx);

Perhaps Avi Kivity remembers why he wrote it this way.
https://lore.kernel.org/kvm/1305129333-7456-6-git-send-email-avi@redhat.com/


