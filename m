Return-Path: <kvm+bounces-1827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9BF7EC316
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 13:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F04BD1F26DEC
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 12:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B40918AE5;
	Wed, 15 Nov 2023 12:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Snfq2Cof"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BA718053
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 12:57:02 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16CB109;
	Wed, 15 Nov 2023 04:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HPjEWIhnSuL1f7Paftq9Sr+qAgNhcC6rAQvLdNO2Hjo=; b=Snfq2CofR7AgtxEF/jzHVtc8n6
	dylBdVfNE8zwOO/gDzd/NTiavyZ54aOk9rUoS6qLTKHB1FkSucX2xNCtBzeC8O3OyR8Yko/L/OXT0
	ITFOlahO+Q6TpPQbYmMo+t66jEWjfb/QplPmNB4HiB4FRCRy6lTkQVU1WLVNgRc9LiK+s6OSxfKBe
	/GQ1fLmZjBhqLbDhINdY5/0mmUrIzYqcDfefUye/ov8V3idJZUWHOYqSQdxDgzZDcEewTPnt/cFVr
	jl5RpF9ZZKid8zVeLcjhzpHh1auv1Momfv0DI5+1mS/LowQ3LMg8KhGINNslseI3fVOgw2/hoKc9m
	/ryksRNw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r3FRR-0041qC-0g;
	Wed, 15 Nov 2023 12:56:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D1958300427; Wed, 15 Nov 2023 13:56:24 +0100 (CET)
Date: Wed, 15 Nov 2023 13:56:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
	iommu@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>, Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>, maz@kernel.org,
	seanjc@google.com, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH RFC 09/13] x86/irq: Install posted MSI notification
 handler
Message-ID: <20231115125624.GF3818@noisy.programming.kicks-ass.net>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-10-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231112041643.2868316-10-jacob.jun.pan@linux.intel.com>

On Sat, Nov 11, 2023 at 08:16:39PM -0800, Jacob Pan wrote:

> +static __always_inline inline void handle_pending_pir(struct pi_desc *pid, struct pt_regs *regs)
> +{

__always_inline means that... (A)

> +	int i, vec = FIRST_EXTERNAL_VECTOR;
> +	u64 pir_copy[4];
> +
> +	/*
> +	 * Make a copy of PIR which contains IRQ pending bits for vectors,
> +	 * then invoke IRQ handlers for each pending vector.
> +	 * If any new interrupts were posted while we are processing, will
> +	 * do again before allowing new notifications. The idea is to
> +	 * minimize the number of the expensive notifications if IRQs come
> +	 * in a high frequency burst.
> +	 */
> +	for (i = 0; i < 4; i++)
> +		pir_copy[i] = raw_atomic64_xchg((atomic64_t *)&pid->pir_l[i], 0);
> +
> +	/*
> +	 * Ideally, we should start from the high order bits set in the PIR
> +	 * since each bit represents a vector. Higher order bit position means
> +	 * the vector has higher priority. But external vectors are allocated
> +	 * based on availability not priority.
> +	 *
> +	 * EOI is included in the IRQ handlers call to apic_ack_irq, which
> +	 * allows higher priority system interrupt to get in between.
> +	 */
> +	for_each_set_bit_from(vec, (unsigned long *)&pir_copy[0], 256)
> +		call_irq_handler(vec, regs);
> +
> +}
> +
> +/*
> + * Performance data shows that 3 is good enough to harvest 90+% of the benefit
> + * on high IRQ rate workload.
> + * Alternatively, could make this tunable, use 3 as default.
> + */
> +#define MAX_POSTED_MSI_COALESCING_LOOP 3
> +
> +/*
> + * For MSIs that are delivered as posted interrupts, the CPU notifications
> + * can be coalesced if the MSIs arrive in high frequency bursts.
> + */
> +DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi_notification)
> +{
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +	struct pi_desc *pid;
> +	int i = 0;
> +
> +	pid = this_cpu_ptr(&posted_interrupt_desc);
> +
> +	inc_irq_stat(posted_msi_notification_count);
> +	irq_enter();
> +
> +	while (i++ < MAX_POSTED_MSI_COALESCING_LOOP) {
> +		handle_pending_pir(pid, regs);
> +
> +		/*
> +		 * If there are new interrupts posted in PIR, do again. If
> +		 * nothing pending, no need to wait for more interrupts.
> +		 */
> +		if (is_pir_pending(pid))

So this reads those same 4 words we xchg in handle_pending_pir(), right?

> +			continue;
> +		else
> +			break;
> +	}
> +
> +	/*
> +	 * Clear outstanding notification bit to allow new IRQ notifications,
> +	 * do this last to maximize the window of interrupt coalescing.
> +	 */
> +	pi_clear_on(pid);
> +
> +	/*
> +	 * There could be a race of PI notification and the clearing of ON bit,
> +	 * process PIR bits one last time such that handling the new interrupts
> +	 * are not delayed until the next IRQ.
> +	 */
> +	if (unlikely(is_pir_pending(pid)))
> +		handle_pending_pir(pid, regs);

(A) ... we get _two_ copies of that thing in this function. Does that
make sense ?

> +
> +	apic_eoi();
> +	irq_exit();
> +	set_irq_regs(old_regs);
> +}
>  #endif /* X86_POSTED_MSI */

Would it not make more sense to write things something like:

bool handle_pending_pir()
{
	bool handled = false;
	u64 pir_copy[4];

	for (i = 0; i < 4; i++) {
		if (!pid-pir_l[i]) {
			pir_copy[i] = 0;
			continue;
		}

		pir_copy[i] = arch_xchg(&pir->pir_l[i], 0);
		handled |= true;
	}

	if (!handled)
		return handled;

	for_each_set_bit()
		....

	return handled.
}

sysvec_posted_blah_blah()
{
	bool done = false;
	bool handled;

	for (;;) {
		handled = handle_pending_pir();
		if (done)
			break;
		if (!handled || ++loops > MAX_LOOPS) {
			pi_clear_on(pid);
			/* once more after clear_on */
			done = true;
		}
	}
}


Hmm?

