Return-Path: <kvm+bounces-71283-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KMYnMJFDlmmYdAIAu9opvQ
	(envelope-from <kvm+bounces-71283-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:56:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE9715AB75
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 80FB1300DCEC
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4411339856;
	Wed, 18 Feb 2026 22:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WoSM+5W0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB6F338939;
	Wed, 18 Feb 2026 22:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771455367; cv=none; b=qa3C3+sCx7KsnY1xyGfXlJFU2KFawDb/FmUqL01984qd+aut54qeDsFAF6+aFxzW1G6Jv3uIKpE7EPFNxjENF4Ac+b3axk+OMetKBCSupoDodbV8/xRuYFqG1DT4IINrktc+E1QDj+TkEAT9EJu8qbK8cGA/YXZ9cOY4DPisT3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771455367; c=relaxed/simple;
	bh=UzfjcaaPR5s5Szb5LBtuVDWYAZXATlyBw0MrHEBSTyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DssAizKd6FH7O0+Nput7Fx4eOR+e0EbeTITO4ZK9KvURErC9ORfWueBVXGVChUNhfX/jEiZOuU4vTMzxVnibCP4IZVgs4AQD63sppwY1mRS5WYJRzOxWYtLqdmzRs6hoy/syrRBcAbq/425wk7LrYj+PiLhvmgS2dRpjuBBUZIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WoSM+5W0; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771455366; x=1802991366;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UzfjcaaPR5s5Szb5LBtuVDWYAZXATlyBw0MrHEBSTyI=;
  b=WoSM+5W07VBfSGxFpVraJ0TfMj5bzg5DCcyL1XvKJI8zmKLAsgXEW4UW
   6cano/jG/JEuYKIhvxGxBNoqoaeSS7YKxydaLQcVaLcv1KOTzNNUh4UiO
   L/vCYlltL+ZwfQ/UN+azllQipNbCz6waW8lA6jt+iRIRMFVPgAA3BvkuV
   UFmWY2qAZTIVsoLAo9TfBlc4xo4DHOgQ0aZFYaMqdg3Oigz+0H5gA+d46
   pjmCqy92PfPUqmfgnaiv/JmtzZ3LvasRcnRERRXYGRAqXJ7pQQHeWA3hu
   Jz49BFxyoUHAVdlz7O/x9QgvzbWFaRx/hq/7k4at2rAsNUU61E1ue/POM
   Q==;
X-CSE-ConnectionGUID: YKn4bjaRS2uvyY/AHXFMHQ==
X-CSE-MsgGUID: Fy36qt++TQK3kS4sGD/Y3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="83645565"
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="83645565"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 14:56:05 -0800
X-CSE-ConnectionGUID: musoQcFeR3icuGJ7BgwEyA==
X-CSE-MsgGUID: PPVsSIy7R2Gw0LJkKXuVZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="212370350"
Received: from ray2.jf.intel.com (HELO [10.24.81.147]) ([10.24.81.147])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 14:56:03 -0800
Message-ID: <b41a2b0f-3ca7-4f2a-8b71-5e8e189b41fa@intel.com>
Date: Wed, 18 Feb 2026 14:56:03 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] x86/sev: add support for enabling RMPOPT
To: "Kalra, Ashish" <ashish.kalra@amd.com>, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <7df872903e16ccee9fce73b34280ede8dfc37063.1771321114.git.ashish.kalra@amd.com>
 <10baddd3-add6-4771-a1ce-f759d3ec69d2@intel.com>
 <bab6afd4-b197-4a7b-b9d1-f518d192524f@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <bab6afd4-b197-4a7b-b9d1-f518d192524f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71283-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 6BE9715AB75
X-Rspamd-Action: no action

On 2/18/26 14:17, Kalra, Ashish wrote:
> Yes, by default Venice platform has the NPS2 configuration enabled by default,
> so we have 'X' nodes per socket and we have to consider this NPSx configuration
> and optimize for those groups. 

Why, though?

You keep saying: "We have NPS so we must configure sockets". But not *why*.

I suspect this is another premature optimization. Nodes are a bit too
small so if you configure via nodes, the later nodes will have RMPOPT
tables that cover empty address space off the end of system memory.

Honestly, I think this is all just done wrong. It doesn't need to even
consider sockets. Sockets might even be the wrong thing to look at.

Basically, RMPOPT gives you a 2TB window of potentially "fast" memory.
The rest of memory is "slow". If you're lucky, the memory that's fast
because of RMPOPT is also in a low-distance NUMA node.

Sockets are a good thing to use, for sure. But they're not even optimal!
Just imagine what's going to happen if you have more than 2TB in a
socket. You just turn off the per-socket optimization. If that happens,
the last node in the socket will end up with an RMPOPT table that has
itself at the beginning, but probably a nonzero amount of off-socket memory.

I'd probably just do something like this:

Given a NUMA node, go through each 1GB of memory in the system and see
what the average NUMA distance of that 2TB window of memory is. Find the
2TB window with the lowest average distance. That'll give you a more or
less optimal RMPOPT window. It'll work with NPS or regular NUMA or
whatever bonkers future fancy thing shows up.

But that's all optimization territory. Please squirrel that away to go
look at in 6 months once you get the rest of this merged.

