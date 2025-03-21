Return-Path: <kvm+bounces-41654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D45ECA6BB47
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F12618874E2
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 12:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA0922AE7E;
	Fri, 21 Mar 2025 12:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SnlyvJ34";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="4WI+jTYd"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CDF22A7FD;
	Fri, 21 Mar 2025 12:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742561617; cv=none; b=cUMNRbjuX16lZ8BKBNgKzm4qOKtHu76p8iNXFgJ9XZ21K0epi0ZLSd+wtukXaqPxd4QJsaGBrlQXQDl0PVdU8supz2JA0x6/VtoNdSCb0OEI0O8bi/ZdUjZVzRHenGqd5/W7b8swqyGj+Otdr3Do6wlCusHKuVvr8zeiAC+H/Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742561617; c=relaxed/simple;
	bh=aBAET/lES4NSQO8sibgQ3bClN8JuLjhCvkLvXNFXUBc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=X+4h2l2Q56eABaMXOW8Apq9lVsVpjHIo1gsY87woXZ95ELsMuQO0extNyKwtE6bqMsSBKrWWcrws61WLPJGGgNHFVJ6Sm9vZ7qKhg1x2Atl/Lad7B3wOBefm2ak/GayhcexLx14JD5SsPTbm7cDtTu/YeoNEulaiiShsbPOrBCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SnlyvJ34; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=4WI+jTYd; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742561613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ORnYV+7gu7XamQTgzT1UwvEguLeAv3ZmQ2vwtTbBVRo=;
	b=SnlyvJ34EDMUWV/JVRrU1MBXx3fMEo1sqb9XdqaRs+/Doim0p3MG1SlFm04PrkFH7crY0V
	+OvgukD/aung1VL/LTAGw7qGy0X+gnwDYKhcasX4PcjN3hcetm85YisAMAp8ELCOT1Sqzn
	3dYlngzQRQ9FZiTrcSDydMlu2hsACJNUNGgvwPC0EszWc8J8lMbvmCTklEHcdNnxxvReHq
	NJ+/nTfEsshtqfcOcD+66xR52lgYyzwNjFa+NXo8SSKNULoRIPoq5NL7Q8kPccn4kv4oFr
	4qEMKMGmeNtIZDTNHiZA/7N/aYzUs2P/m5fir3ucoNZI17PYEb8f6XiNHB3jDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742561613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ORnYV+7gu7XamQTgzT1UwvEguLeAv3ZmQ2vwtTbBVRo=;
	b=4WI+jTYdzocwVYeI+pFWX6SZyJSSFXgN47ji0RxENrSkV2uiudKNAYEv8yNGYFP+a5LJPX
	ibPvB7FP7KZSycAw==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
In-Reply-To: <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
Date: Fri, 21 Mar 2025 13:53:32 +0100
Message-ID: <87v7s235pv.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
> +static void x2apic_savic_send_IPI(int cpu, int vector)
> +{
> +	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
> +
> +	/* x2apic MSRs are special and need a special fence: */
> +	weak_wrmsr_fence();
> +	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
> +}
> +
> +static void
> +__send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
> +{
> +	unsigned long query_cpu;
> +	unsigned long this_cpu;
> +	unsigned long flags;
> +
> +	/* x2apic MSRs are special and need a special fence: */
> +	weak_wrmsr_fence();
> +
> +	local_irq_save(flags);
> +
> +	this_cpu = smp_processor_id();
> +	for_each_cpu(query_cpu, mask) {
> +		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
> +			continue;
> +		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
> +				       vector, APIC_DEST_PHYSICAL);
> +	}
> +	local_irq_restore(flags);
> +}
> +
> +static void x2apic_savic_send_IPI_mask(const struct cpumask *mask, int vector)
> +{
> +	__send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
> +}
> +
> +static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
> +{
> +	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
> +}

The above are identical copies (aside of the names) of the functions in
x2apic_phys.c.

Why can't this simply share the code ?

Thanks,

        tglx

