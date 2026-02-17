Return-Path: <kvm+bounces-71191-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6F0+CNjmlGmjIgIAu9opvQ
	(envelope-from <kvm+bounces-71191-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:08:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7791514EC
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9223C304EF4E
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 22:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFFD3148C1;
	Tue, 17 Feb 2026 22:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="acVR9QC3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C9831328B;
	Tue, 17 Feb 2026 22:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771366016; cv=none; b=gKRfKOAntnfoeKms1kWTiDglNq8TW5T6aKvfYAqaYH6P+Pu3G/nxJBajYPuAPDepDvbpOjrencpVwpO1haJGbNLcoH6Oipj8BheZ9u5v/PcgJanxFC9qvXjMOuGja9D+2D8ezNk5ImE7G6mFrDgM4PVZ9+++lQImeD4ndobNLHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771366016; c=relaxed/simple;
	bh=BPmbyvwBEsI4sxobiBe6zuZ0lUDUnmgeTgA9zi+Fypw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FvBqZSgs5hHNAb0MFDCkBQvzaCNMbQWcYHzS90vQ7TYhfypdQEjT1gML+raqzDcD0hjgQa4qOzQ7vsrii2hmr3VdxZqkes3WgS+PXmCME2eHqMX1AsksDlAy9pOFLzTVhJrHunMYo2+QSmjOP6cPZGLGQed6T6FdkDzb5un1Jmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=acVR9QC3; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771366014; x=1802902014;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BPmbyvwBEsI4sxobiBe6zuZ0lUDUnmgeTgA9zi+Fypw=;
  b=acVR9QC32vPdaeDFjGETJC5967dRZvRx2y8KCkbPDp52o5C2cRnyWocx
   x9yvGLUVxo9k2LSb7QMKVy5HvnqGIOfn9QLt4B5fobTqwY1c2YYtfI0kP
   YhHRHPnYiUC2PyGs9hLHwvP6+Lw1MOxjdGqJOaSxzPyCPhi9087Ne7hJJ
   76MmZhz6nr9lCr81iGYPKzUuoKRegMZr8wc6fMTqDIiFVhekmhYEiG4h8
   Xi/nYRFXHJkg3TdyGIWrtfwxrF9FPQEK36Na4zkTKi8i5HdxQqgjVZqE6
   XIA2AR4IERjSTBYXHzLXW6+jEolbooem7U29uEgPOCkp+Uf0U8fgk+Auy
   Q==;
X-CSE-ConnectionGUID: Ydw/JKo8TzqDgNWjtx9+vw==
X-CSE-MsgGUID: 5DNLuHVjRymua4QqY7ZYrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="82773766"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="82773766"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 14:06:53 -0800
X-CSE-ConnectionGUID: O/zHxrATTEW3SyeLtbCxsw==
X-CSE-MsgGUID: yvdq/h1hQ6iWlnGT99Ectg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="244604341"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO [10.125.109.135]) ([10.125.109.135])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 14:06:53 -0800
Message-ID: <10baddd3-add6-4771-a1ce-f759d3ec69d2@intel.com>
Date: Tue, 17 Feb 2026 14:06:52 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] x86/sev: add support for enabling RMPOPT
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <7df872903e16ccee9fce73b34280ede8dfc37063.1771321114.git.ashish.kalra@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <7df872903e16ccee9fce73b34280ede8dfc37063.1771321114.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71191-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: AF7791514EC
X-Rspamd-Action: no action

> +#define RMPOPT_TABLE_MAX_LIMIT_IN_TB	2
> +#define NUM_TB(pfn_min, pfn_max)	\
> +	(((pfn_max) - (pfn_min)) / (1 << (40 - PAGE_SHIFT)))

IMNHO, you should just keep these in bytes. No reason to keep them in TB.

> +struct rmpopt_socket_config {
> +	unsigned long start_pfn, end_pfn;
> +	cpumask_var_t cpulist;
> +	int *node_id;
> +	int current_node_idx;
> +};

This looks like optimization complexity before the groundwork is in
place. Also, don't we *have* CPU lists for NUMA nodes? This seems rather
redundant.

> +/*
> + * Build a cpumask of online primary threads, accounting for primary threads
> + * that have been offlined while their secondary threads are still online.
> + */
> +static void get_cpumask_of_primary_threads(cpumask_var_t cpulist)
> +{
> +	cpumask_t cpus;
> +	int cpu;
> +
> +	cpumask_copy(&cpus, cpu_online_mask);
> +	for_each_cpu(cpu, &cpus) {
> +		cpumask_set_cpu(cpu, cpulist);
> +		cpumask_andnot(&cpus, &cpus, cpu_smt_mask(cpu));
> +	}
> +}

Don't we have a primary thread mask already? I thought we did.

> +static void __configure_rmpopt(void *val)
> +{
> +	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
> +
> +	wrmsrq(MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> +}

I'd honestly just make the callers align the address..

> +static void configure_rmpopt_non_numa(cpumask_var_t primary_threads_cpulist)
> +{
> +	on_each_cpu_mask(primary_threads_cpulist, __configure_rmpopt, (void *)0, true);
> +}
> +
> +static void free_rmpopt_socket_config(struct rmpopt_socket_config *socket)
> +{
> +	int i;
> +
> +	if (!socket)
> +		return;
> +
> +	for (i = 0; i < topology_max_packages(); i++) {
> +		free_cpumask_var(socket[i].cpulist);
> +		kfree(socket[i].node_id);
> +	}
> +
> +	kfree(socket);
> +}
> +DEFINE_FREE(free_rmpopt_socket_config, struct rmpopt_socket_config *, free_rmpopt_socket_config(_T))

Looking at all this, I really think you need a more organized series.

Make something that's _functional_ and works for all <2TB configs. Then,
go add all this NUMA complexity in a follow-on patch or patches. There's
too much going on here.

> +static void configure_rmpopt_large_physmem(cpumask_var_t primary_threads_cpulist)
> +{
> +	struct rmpopt_socket_config *socket __free(free_rmpopt_socket_config) = NULL;
> +	int max_packages = topology_max_packages();
> +	struct rmpopt_socket_config *sc;
> +	int cpu, i;
> +
> +	socket = kcalloc(max_packages, sizeof(struct rmpopt_socket_config), GFP_KERNEL);
> +	if (!socket)
> +		return;
> +
> +	for (i = 0; i < max_packages; i++) {
> +		sc = &socket[i];
> +		if (!zalloc_cpumask_var(&sc->cpulist, GFP_KERNEL))
> +			return;
> +		sc->node_id = kcalloc(nr_node_ids, sizeof(int), GFP_KERNEL);
> +		if (!sc->node_id)
> +			return;
> +		sc->current_node_idx = -1;
> +	}
> +
> +	/*
> +	 * Handle case of virtualized NUMA software domains, such as AMD Nodes Per Socket(NPS)
> +	 * configurations. The kernel does not have an abstraction for physical sockets,
> +	 * therefore, enumerate the physical sockets and Nodes Per Socket(NPS) information by
> +	 * walking the online CPU list.
> +	 */

By this point, I've forgotten why sockets are important here.

Why are they important?

> +	for_each_cpu(cpu, primary_threads_cpulist) {
> +		int socket_id, nid;
> +
> +		socket_id = topology_logical_package_id(cpu);
> +		nid = cpu_to_node(cpu);
> +		sc = &socket[socket_id];
> +
> +		/*
> +		 * For each socket, determine the corresponding nodes and the socket's start
> +		 * and end PFNs.
> +		 * Record the node and the start and end PFNs of the first node found on the
> +		 * socket, then record each subsequent node and update the end PFN for that
> +		 * socket as additional nodes are found.
> +		 */
> +		if (sc->current_node_idx == -1) {
> +			sc->current_node_idx = 0;
> +			sc->node_id[sc->current_node_idx] = nid;
> +			sc->start_pfn = node_start_pfn(nid);
> +			sc->end_pfn = node_end_pfn(nid);
> +		} else if (sc->node_id[sc->current_node_idx] != nid) {
> +			sc->current_node_idx++;
> +			sc->node_id[sc->current_node_idx] = nid;
> +			sc->end_pfn = node_end_pfn(nid);
> +		}
> +
> +		cpumask_set_cpu(cpu, sc->cpulist);
> +	}
> +
> +	/*
> +	 * If the "physical" socket has up to 2TB of memory, the per-CPU RMPOPT tables are
> +	 * configured to the starting physical address of the socket, otherwise the tables
> +	 * are configured per-node.
> +	 */
> +	for (i = 0; i < max_packages; i++) {
> +		int num_tb_socket;
> +		phys_addr_t pa;
> +		int j;
> +
> +		sc = &socket[i];
> +		num_tb_socket = NUM_TB(sc->start_pfn, sc->end_pfn) + 1;
> +
> +		pr_debug("socket start_pfn 0x%lx, end_pfn 0x%lx, socket cpu mask %*pbl\n",
> +			 sc->start_pfn, sc->end_pfn, cpumask_pr_args(sc->cpulist));
> +
> +		if (num_tb_socket <= RMPOPT_TABLE_MAX_LIMIT_IN_TB) {
> +			pa = PFN_PHYS(sc->start_pfn);
> +			on_each_cpu_mask(sc->cpulist, __configure_rmpopt, (void *)pa, true);
> +			continue;
> +		}
> +
> +		for (j = 0; j <= sc->current_node_idx; j++) {
> +			int nid = sc->node_id[j];
> +			struct cpumask node_mask;
> +
> +			cpumask_and(&node_mask, cpumask_of_node(nid), sc->cpulist);
> +			pa = PFN_PHYS(node_start_pfn(nid));
> +
> +			pr_debug("RMPOPT_BASE MSR on nodeid %d cpu mask %*pbl set to 0x%llx\n",
> +				 nid, cpumask_pr_args(&node_mask), pa);
> +			on_each_cpu_mask(&node_mask, __configure_rmpopt, (void *)pa, true);
> +		}
> +	}
> +}

Ahh, so you're not optimizing by NUMA itself: you're assuming that there
are groups of NUMA nodes in a socket and then optimizing for those groups.

It would have been nice to say that. It would make great material for
the changelog for your broken out patches.

I have the feeling that the structure here could be one of these in a patch:

 1. Support systems with <2TB of memory
 2. Support a RMPOPT range per NUMA node
 3. Group NUMA nodes at socket boundaries and have them share a common
    RMPOPT config.

Right?

> +static __init void configure_and_enable_rmpopt(void)
> +{
> +	cpumask_var_t primary_threads_cpulist;
> +	int num_tb;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT)) {
> +		pr_debug("RMPOPT not supported on this platform\n");
> +		return;
> +	}
> +
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
> +		pr_debug("RMPOPT optimizations not enabled as SNP support is not enabled\n");
> +		return;
> +	}
> +
> +	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)) {
> +		pr_info("RMPOPT optimizations not enabled, segmented RMP required\n");
> +		return;
> +	}
> +
> +	if (!zalloc_cpumask_var(&primary_threads_cpulist, GFP_KERNEL))
> +		return;
> +
> +	num_tb = NUM_TB(min_low_pfn, max_pfn) + 1;
> +	pr_debug("NUM_TB pages in system %d\n", num_tb);

This looks wrong. Earlier, you program 0 as the base RMPOPT address into
the MSR. But this uses 'min_low_pfn'. Why not 0?

> +	/* Only one thread per core needs to set RMPOPT_BASE MSR as it is per-core */
> +	get_cpumask_of_primary_threads(primary_threads_cpulist);
> +
> +	/*
> +	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory for RMP optimizations.
> +	 *
> +	 * Fastpath RMPOPT configuration and setup:
> +	 * For systems with <= 2 TB of RAM, configure each per-core RMPOPT base to 0,
> +	 * ensuring all system RAM is RMP-optimized on all CPUs.
> +	 */
> +	if (num_tb <= RMPOPT_TABLE_MAX_LIMIT_IN_TB)
> +		configure_rmpopt_non_numa(primary_threads_cpulist);

this part:

> +	else
> +		configure_rmpopt_large_physmem(primary_threads_cpulist);

^^ needs to be broken out into a separate optimization patch.


