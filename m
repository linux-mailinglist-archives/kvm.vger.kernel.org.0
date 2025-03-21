Return-Path: <kvm+bounces-41660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75664A6BC11
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:53:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F53F3B6FA7
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DCA27DA6D;
	Fri, 21 Mar 2025 13:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="f3mD02cC";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SHi5wr1F"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2FA7082D;
	Fri, 21 Mar 2025 13:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742565167; cv=none; b=EoxKYoYZ0sRM0kgTGPWTBzqrYDEl0j4xs8/aqtVhOaXkTZt7CQFfeY+KRPIUkaYtzakQUZsskJQV/evaCFmj5IA4Q2GxpJoSLTMoGnjhEoJEuX76dyAXBsRH1EtC7QcamMMllGrCKTj4lZ0acl2z2CtTB4DQLsOPFhoJd8BAFZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742565167; c=relaxed/simple;
	bh=KDYzCh9V5eVHzXGipaqIBLXNoOw/gScI2DQmEmTb5n4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Kv9HcF1/s28fURnSJSfUMiHKoLSiOOr+4iYuZK+3q/panKP+V1rzT5fjU+yOpRJXLCY8jNZGuT4FCFNOZNjEwkgwk3PLDHJMMI/95Dt0FYo/oH73b8Mn5grX2PTi5tlhIQ01HHjkiK9LTi3XJpTUju/sDoY+I5dzD1vc2mCLwGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=f3mD02cC; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SHi5wr1F; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742565164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6CwkrlhgWck2N/CVWRnqhVlubjgAoi4xH51EyOXCvdc=;
	b=f3mD02cC+Hfx9kDBClHCH7sTKfBjEBREXHTkWclRkvUfGg/UZ2/YvlnRqPF+yqOuxPy4YZ
	Hmd4ys6ASDcOgq5+vNlPWckf1B2Hgj+0nvIIrPbqtNm740U0aFkwsmuRxHPE5Yefqj/CTe
	UhVdgsi9YHCHD7FNCOJe9Sy7B14yVDJ777+cdVPjEDA1X5ozmnphBP+roFWF0F/jL/mwUd
	WcWBqHcAB3aW4BsQ2oqa9C0z7F6mFXb/v9mEY7QtZGHlEG/OldjtEOHcnk8MWeVrrNQrar
	LsQ/ZZ0KHJ7VwnCAQ/b128y+Lg8+iZnvRTw+GCWkMqiJ+XDOUsKsIitI45O6MA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742565164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6CwkrlhgWck2N/CVWRnqhVlubjgAoi4xH51EyOXCvdc=;
	b=SHi5wr1FnZm8oGiMYxFxsJoyL2Bo0doM3Kn3olr1YVscPszQji1VSpJi8dutvUQE08aO87
	RLqxsywgTvWzSOAA==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 04/17] x86/apic: Initialize APIC ID for Secure AVIC
In-Reply-To: <20250226090525.231882-5-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-5-Neeraj.Upadhyay@amd.com>
Date: Fri, 21 Mar 2025 14:52:43 +0100
Message-ID: <87msde32z8.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
> Initialize the APIC ID in the Secure AVIC APIC backing page with
> the APIC_ID msr value read from Hypervisor. Maintain a hashmap to
> check and report same APIC_ID value returned by Hypervisor for two
> different vCPUs.

What for?
 
> +struct apic_id_node {
> +	 struct llist_node node;
> +	 u32 apic_id;
> +	 int cpu;
> +};

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#struct-declarations-and-initializers

and please read the rest of the document too.

> +static void init_backing_page(void *backing_page)
> +{
> +	struct apic_id_node *next_node, *this_cpu_node;
> +	unsigned int apic_map_slot;
> +	u32 apic_id;
> +	int cpu;
> +
> +	/*
> +	 * Before Secure AVIC is enabled, APIC msr reads are
> +	 * intercepted. APIC_ID msr read returns the value
> +	 * from hv.

Can you please write things out? i.e. s/hv/hypervisor/ This is not twatter.

> +	 */
> +	apic_id = native_apic_msr_read(APIC_ID);
> +	set_reg(backing_page, APIC_ID, apic_id);
> +
> +	if (!apic_id_map)
> +		return;
> +
> +	cpu = smp_processor_id();
> +	this_cpu_node = &per_cpu(apic_id_node, cpu);
> +	this_cpu_node->apic_id = apic_id;
> +	this_cpu_node->cpu = cpu;
> +	/*
> +	 * In common case, apic_ids for CPUs are sequentially numbered.
> +	 * So, each CPU should hash to a different slot in the apic id
> +	 * map.
> +	 */
> +	apic_map_slot = apic_id % nr_cpu_ids;
> +	llist_add(&this_cpu_node->node, &apic_id_map[apic_map_slot]);

Why does this need to be a llist? What's wrong about a trivial hlist?

> +	/* Each CPU checks only its next nodes for duplicates. */
> +	llist_for_each_entry(next_node, this_cpu_node->node.next, node) {
> +		if (WARN_ONCE(next_node->apic_id == apic_id,
> +			      "Duplicate APIC %u for cpu %d and cpu %d. IPI handling will suffer!",
> +			      apic_id, cpu, next_node->cpu))
> +			break;
> +	}

This does not make any sense at all. The warning is completely useless
because two milliseconds later the topology evaluation code will yell
about mismatch of APIC IDs and catch the duplicate.

So what is this overengineered thing buying you? Just more
incomprehensible security voodoo for no value.

Thanks,

        tglx

