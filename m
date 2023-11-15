Return-Path: <kvm+bounces-1823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 359AD7EC2AB
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 13:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 955B6B20A96
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 12:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7599171D3;
	Wed, 15 Nov 2023 12:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dQZrzXJa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFC6525F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 12:42:53 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC26F125;
	Wed, 15 Nov 2023 04:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+r8ivjIfgLZ88YUedyxhSyz2DStbFMG0ACvLMyfn4T8=; b=dQZrzXJarcPyscofRf+ECdjQh3
	s2ZanwodO9ept5SfgdHuqz+W3dpJJaRsGTClg1RCPbdW4uwkneSurlUMt6KsqbZ/eF6FB8TlgPlJ6
	m1PPue2AYsmhzXh1mR5lgXggeZl4dGJ7Ka1275y6fMwAF0zeAMlb3uxXd367bWr5AuXHrC4bnFSVf
	0jWyCxQm1IRy3oE/Mz+/H/t6I48ZPo1b9uLaeEXDNyJoAcPThLzw6OO/gxC4H0URpdJppHV+WuzzJ
	496rAqlN0u8oycYWDFB9hetPDb225KM9vZnsqzjOnh31C8x4B4Tq+xHgT4I1ivsjg4wxvG7BmFMl1
	CpjaXSDQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r3FDq-00EEE7-0q; Wed, 15 Nov 2023 12:42:22 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id ABAE4300427; Wed, 15 Nov 2023 13:42:21 +0100 (CET)
Date: Wed, 15 Nov 2023 13:42:21 +0100
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
Message-ID: <20231115124221.GE3818@noisy.programming.kicks-ass.net>
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

Might as well use arch_xchg() and save the atomic64_t casting.

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

