Return-Path: <kvm+bounces-55577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D77B33028
	for <lists+kvm@lfdr.de>; Sun, 24 Aug 2025 15:38:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 036281B262FC
	for <lists+kvm@lfdr.de>; Sun, 24 Aug 2025 13:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CAF2DC349;
	Sun, 24 Aug 2025 13:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2kEy2cBn";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Kk4JeDNz"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14C023A9BE;
	Sun, 24 Aug 2025 13:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756042696; cv=none; b=IcffHQHKXVGOlp1l7/GFeTV9KjjrUO15faSY8ZHEg7AYerCWZpgfxxnm4tAj0wfZOei4miCrikcYetSIH6KYyDUldI2fSFeoeGGIkez3VRS3UmKH8vtht87Hw3fvBMyYet4ku6CMas6SPd0jE4xNT2qqmtal3zEEJBSmtFh+8Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756042696; c=relaxed/simple;
	bh=HN8vItz0GigpFkrZnRZytRlm3Um2RFY5Kv7NOzjU2Io=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=C8bhgamlglgOIWo2Q97iCsF0/+iTzUIRg/3qEq0TAEcIcggTI6DtYQVI6pFpXPCQc2/xm+lii5fxfrGF84eSR4k4HSS8Ph6wKamZWzFKkP1ZjgFnSnBNRSRJMtL+vCLHe7qiEypJe7I1P1ERzjh6vPgUNExGJxClThac+pZOqvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2kEy2cBn; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Kk4JeDNz; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756042686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zR6KLU5duIFq19gpDRX9O5axG8cxVDQ8Pv15dsa5XIA=;
	b=2kEy2cBnKlglNeO+h/it0wcuXrEMznyvIjnmXCGEi15tKTJcTgypRde6/o3Xz+a6ldgbYr
	sfF3BNnyaJwZfoO8Eg9XBGFpfvIsVbMtrfLdp6k2t56XYmqDbIibkJs97FIlNox7xSUH7R
	EPc0m6D4BB76zEYLcdKUi9Jfso2YbLvJgTq+h6FxIHCNpulH+UDvq87NDyoKiEBVhY0Le9
	nWDAbUba1VssZpfECBDv1kRG4o0be0mQORnT6BRH0NAynIwyv1rnzflKTDXNtOKTdoLyDB
	Z777AkS9hvJXJl2HvEXCobdVzo2KkxsfEGR7fviP+CTVVIZV9lwH059Ni8rYVw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756042686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zR6KLU5duIFq19gpDRX9O5axG8cxVDQ8Pv15dsa5XIA=;
	b=Kk4JeDNzCcK0wKv024ApAj1o+6NjiY5OsZagycH/aPvPYG9zLG0RKS9zdqwp04UND6TQa9
	yQk69VR7DubkrnAA==
To: K Prateek Nayak <kprateek.nayak@amd.com>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org
Cc: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
 <peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
 <pawan.kumar.gupta@linux.intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Mario Limonciello <mario.limonciello@amd.com>,
 "Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
 <babu.moger@amd.com>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>
Subject: Re: [PATCH v3 4/4] x86/cpu/topology: Check for
 X86_FEATURE_XTOPOLOGY instead of passing has_topoext
In-Reply-To: <20250818060435.2452-5-kprateek.nayak@amd.com>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250818060435.2452-5-kprateek.nayak@amd.com>
Date: Sun, 24 Aug 2025 15:38:05 +0200
Message-ID: <87ms7o3kn6.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Aug 18 2025 at 06:04, K. Prateek Nayak wrote:

> cpu_parse_topology_ext() sets X86_FEATURE_XTOPOLOGY before returning
> true if any of the XTOPOLOGY leaf could be parsed successfully.
>
> Instead of storing and passing around this return value using
> "has_topoext" in parse_topology_amd(), check for X86_FEATURE_XTOPOLOGY
> instead in parse_8000_001e() to simplify the flow.
>
> No functional changes intended.
>
> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
> ---
> Changelog v2..v3:
>
> o Use cpu_feature_enabled() when checking for X86_FEATURE_XTOPOLOGY.
> ---
>  arch/x86/kernel/cpu/topology_amd.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
> index 3d01675d94f5..138a09528083 100644
> --- a/arch/x86/kernel/cpu/topology_amd.c
> +++ b/arch/x86/kernel/cpu/topology_amd.c
> @@ -59,7 +59,7 @@ static void store_node(struct topo_scan *tscan, u16 nr_nodes, u16 node_id)
>  	tscan->amd_node_id = node_id;
>  }
>  
> -static bool parse_8000_001e(struct topo_scan *tscan, bool has_topoext)
> +static bool parse_8000_001e(struct topo_scan *tscan)
>  {
>  	struct {
>  		// eax
> @@ -81,7 +81,7 @@ static bool parse_8000_001e(struct topo_scan *tscan, bool has_topoext)
>  
>  	cpuid_leaf(0x8000001e, &leaf);
>  
> -	if (!has_topoext) {
> +	if (!cpu_feature_enabled(X86_FEATURE_XTOPOLOGY)) {
>  		/*
>  		 * Prefer initial_apicid parsed from XTOPOLOGY leaf
>  		 * 0x8000026 or 0xb if available. Otherwise prefer the

That's patently wrong.

The leaves might be "available", but are not guaranteed to be valid. So
FEATURE_XTOPOLOGY gives you the wrong answer.

The has_topoext logic is there for a reason.

https://github.com/InstLatx64/InstLatx64.git has a gazillion of CPUID
samples from various machines and there are systems which advertise 0xB,
but it's empty and you won't have an APIC ID at all...

So all what needs to be done is preventing 8..1e parsing to overwrite
the APIC ID, when a valid 0xb/0x26 was detected.

Something like the below.

Btw, your fixes tag is only half correct. The problem existed already
_before_ the topology rewrite and I remember debating exactly this
problem with Boris and Tom back then when I sanitized this nightmare.

Thanks,

        tglx
---
 arch/x86/kernel/cpu/topology_amd.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -81,20 +81,25 @@ static bool parse_8000_001e(struct topo_
 
 	cpuid_leaf(0x8000001e, &leaf);
 
-	tscan->c->topo.initial_apicid = leaf.ext_apic_id;
-
 	/*
-	 * If leaf 0xb is available, then the domain shifts are set
-	 * already and nothing to do here. Only valid for family >= 0x17.
+	 * If leaf 0xb/0x26 is available, then the APIC ID and the domain
+	 * shifts are set already.
 	 */
-	if (!has_topoext && tscan->c->x86 >= 0x17) {
+	 if (!has_topoext) {
+		tscan->c->topo.initial_apicid = leaf.ext_apic_id;
+
 		/*
-		 * Leaf 0x80000008 set the CORE domain shift already.
-		 * Update the SMT domain, but do not propagate it.
+		 * Leaf 0x8000008 sets the CORE domain shift but not the
+		 * SMT domain shift. On CPUs with family >= 0x17, there
+		 * might be hyperthreads.
 		 */
-		unsigned int nthreads = leaf.core_nthreads + 1;
+		if (tscan->c->x86 >= 0x17) {
+			/* Update the SMT domain, but do not propagate it. */
+			unsigned int nthreads = leaf.core_nthreads + 1;
 
-		topology_update_dom(tscan, TOPO_SMT_DOMAIN, get_count_order(nthreads), nthreads);
+			topology_update_dom(tscan, TOPO_SMT_DOMAIN,
+					    get_count_order(nthreads), nthreads);
+		}
 	}
 
 	store_node(tscan, leaf.nnodes_per_socket + 1, leaf.node_id);

