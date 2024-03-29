Return-Path: <kvm+bounces-13055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F41E89145D
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 08:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA0DF1C22FD6
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 07:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F724086E;
	Fri, 29 Mar 2024 07:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZlFXF9r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963833C6BA;
	Fri, 29 Mar 2024 07:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711697530; cv=none; b=UE6UD6a/ZjA9Wc6Vb9QA4Endw3OeuE5Xei5vq08UOwaoJCsvNJeqMlaJt25gVOUgyG5TuiUajpZMfGfDALt21KwfXjeqhH7hvtfBtZdApwplkLR9tVQ6Q8wCxjmdydCK1EUbimrW76K110vMdamw9jXpOSWXlK23Lz6obD+3i2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711697530; c=relaxed/simple;
	bh=3M6OWiyX2jCszgbg+gKZllism2OVuQShgvdmfShoSr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXAuZSEjWc2ZRMpwrn8uRxRfS5fA3tIcv8lSspDie3wOpGAPA3ubEdcZ9JNikmPay0h/giiISDaDITshPyL1I/ItuwO/c7S9jW3l9PYayXBeSECcMuuyKKBhBLixK5M70/4To6n8afRHJxyziEgvQQAxWyPirc5UAUo31eOZItk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZlFXF9r; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711697529; x=1743233529;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3M6OWiyX2jCszgbg+gKZllism2OVuQShgvdmfShoSr8=;
  b=NZlFXF9rHVWYWPPKRop1GhOBIIEM+a71uzw6TYQYj93oiPyocNg7r5GZ
   0uHKuFJjrvuxqOKEth+yYdDpKbwHGsbMPlodY6Hx35vHL8AJAWAgxENaQ
   Mz1lpOk3rvryKi8wkAAATZaF2bIFGUFFem0AJsXCSn7rW6AcBdNxv686F
   Vsnbfy9zz0DGYNon3bLdCmRRZXHmgfcmYDBqs3Z9O42AjgPk0RPEF4IjY
   LcdXxNr9o6bZgCmIMA2+wnxuAJN58s4YMzf8TdbiFTOoDWl4h5b1BctjP
   UsYvnzYT/+Jr8MPvuAxcBWvtx2mnJz/RCOVa+wNTHfiw6XJ8FcZFIaox6
   Q==;
X-CSE-ConnectionGUID: zq+nTeguTAG32jgwWLQCrw==
X-CSE-MsgGUID: SGBPKhkXTsCltO/FUCHoHg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="17605218"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="17605218"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 00:32:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="16785904"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.3.174]) ([10.238.3.174])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 00:32:03 -0700
Message-ID: <a4f169fa-663d-4a94-878b-d783f67d48c9@intel.com>
Date: Fri, 29 Mar 2024 15:32:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/15] x86/irq: Install posted MSI notification handler
Content-Language: en-US
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
 LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Hansen, Dave" <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>
Cc: "Luse, Paul E" <paul.e.luse@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
 "Raj, Ashok" <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "maz@kernel.org" <maz@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 Robin Murphy <robin.murphy@arm.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
 <20240126234237.547278-10-jacob.jun.pan@linux.intel.com>
From: Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <20240126234237.547278-10-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/27/2024 7:42 AM, Jacob Pan wrote:
> @@ -353,6 +360,111 @@ void intel_posted_msi_init(void)
>   	pid->nv = POSTED_MSI_NOTIFICATION_VECTOR;
>   	pid->ndst = this_cpu_read(x86_cpu_to_apicid);
>   }
> +
> +/*
> + * De-multiplexing posted interrupts is on the performance path, the code
> + * below is written to optimize the cache performance based on the following
> + * considerations:
> + * 1.Posted interrupt descriptor (PID) fits in a cache line that is frequently
> + *   accessed by both CPU and IOMMU.
> + * 2.During posted MSI processing, the CPU needs to do 64-bit read and xchg
> + *   for checking and clearing posted interrupt request (PIR), a 256 bit field
> + *   within the PID.
> + * 3.On the other side, the IOMMU does atomic swaps of the entire PID cache
> + *   line when posting interrupts and setting control bits.
> + * 4.The CPU can access the cache line a magnitude faster than the IOMMU.
> + * 5.Each time the IOMMU does interrupt posting to the PIR will evict the PID
> + *   cache line. The cache line states after each operation are as follows:
> + *   CPU		IOMMU			PID Cache line state
> + *   ---------------------------------------------------------------
> + *...read64					exclusive
> + *...lock xchg64				modified
> + *...			post/atomic swap	invalid
> + *...-------------------------------------------------------------
> + *
> + * To reduce L1 data cache miss, it is important to avoid contention with
> + * IOMMU's interrupt posting/atomic swap. Therefore, a copy of PIR is used
> + * to dispatch interrupt handlers.
> + *
> + * In addition, the code is trying to keep the cache line state consistent
> + * as much as possible. e.g. when making a copy and clearing the PIR
> + * (assuming non-zero PIR bits are present in the entire PIR), it does:
> + *		read, read, read, read, xchg, xchg, xchg, xchg
> + * instead of:
> + *		read, xchg, read, xchg, read, xchg, read, xchg
> + */
> +static __always_inline inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
> +{
> +	int i, vec = FIRST_EXTERNAL_VECTOR;
> +	unsigned long pir_copy[4];
> +	bool handled = false;
> +
> +	for (i = 0; i < 4; i++)
> +		pir_copy[i] = pir[i];
> +
> +	for (i = 0; i < 4; i++) {
> +		if (!pir_copy[i])
> +			continue;
> +
> +		pir_copy[i] = arch_xchg(pir, 0);

Here is a problem that pir_copy[i] will always be written as pir[0]. 
This leads to handle spurious posted MSIs later.

> +		handled = true;
> +	}
> +
> +	if (handled) {
> +		for_each_set_bit_from(vec, pir_copy, FIRST_SYSTEM_VECTOR)
> +			call_irq_handler(vec, regs);
> +	}
> +
> +	return handled;
> +}
> +
> +/*
> + * Performance data shows that 3 is good enough to harvest 90+% of the benefit
> + * on high IRQ rate workload.
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
> +	/*
> +	 * Max coalescing count includes the extra round of handle_pending_pir
> +	 * after clearing the outstanding notification bit. Hence, at most
> +	 * MAX_POSTED_MSI_COALESCING_LOOP - 1 loops are executed here.
> +	 */
> +	while (++i < MAX_POSTED_MSI_COALESCING_LOOP) {
> +		if (!handle_pending_pir(pid->pir64, regs))
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
> +	handle_pending_pir(pid->pir64, regs);
> +
> +	apic_eoi();
> +	irq_exit();
> +	set_irq_regs(old_regs);
>   }
>   #endif /* X86_POSTED_MSI */
>   

