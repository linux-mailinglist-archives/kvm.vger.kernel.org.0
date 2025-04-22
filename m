Return-Path: <kvm+bounces-43745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2916DA95D1A
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 06:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E9063A2BFC
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 04:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D39199935;
	Tue, 22 Apr 2025 04:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GtlBnowg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993B763D;
	Tue, 22 Apr 2025 04:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745297269; cv=none; b=JnIFtclhs2yaEO04yq/8t7uJS6G2N7dvz6SxkNK6OzA8cx0w0l2boFZDK4+evaGgZsF34RimgkoItdo3ib/5vIlaTHaHgJ8xLcqz5RA5gNoaTuIZunm+KESktRi0RfVkYBK1mKSSVsF1xAxSySjoih/yEa9CLH2f/PLc2KrzZzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745297269; c=relaxed/simple;
	bh=KVG9KWbN6/cnNR50GbGJYhUY3P3Piy5EguSCvW/S0co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFssScQt7ZY0KKIOinSClkVVUrU4g9VMfzLaW9wlkzMrmmIzIGuPgH17UYgjylKLAY9YNtXVjigBF4MLtz4WU0de6iMzoy/awmsYViyhmoOHkpKBTaxFbZOOdD4ZL87Is8oqPbxTRIk7iK3zYpBXkmN4UPiNnSB05MUWt4fduXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GtlBnowg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF59FC4CEE9;
	Tue, 22 Apr 2025 04:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745297269;
	bh=KVG9KWbN6/cnNR50GbGJYhUY3P3Piy5EguSCvW/S0co=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GtlBnowgS5FbGtspKIR9H6/s5boiKbMt2wiWeyWtWXQKHnODDHU+l1+lOb5WGqD4k
	 sVrGthObwZBirgAaR6jDiVw5c8uP1XZlbTWjnmurPhXgG3z88ArVwUCYYpx4rutuVM
	 Vy7vKr8uGhWu08RVbyMN2HRFxHYUGmhqbtxAUJ2UbIizp03rJU+xDanBX5mJZwsfy6
	 gd8dC+M/TuzuzdRLw+HHaOiCQeaXvYJQ26t8Djr7fIbnuQZynJLYzZtf4dzuJnpNEv
	 h80H1phHIW3wyv47FiJ6i43B4+pk/eztYRTNUW2Fm3tlGKuPFRW+4qTXELGPT9v127
	 2jnsGrNbCsrNw==
Date: Tue, 22 Apr 2025 04:47:44 +0000
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org
Subject: Re: [PATCH v5 1/2] KVM: x86: Advance guest TSC after deep suspend.
Message-ID: <aAcfcB8ZyBuz7t7J@google.com>
References: <20250325041350.1728373-1-suleiman@google.com>
 <20250325041350.1728373-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325041350.1728373-2-suleiman@google.com>

On Tue, Mar 25, 2025 at 01:13:49PM +0900, Suleiman Souhlal wrote:
> Advance guest TSC to current time after suspend when the host
> TSCs went backwards.
> 
> This makes the behavior consistent between suspends where host TSC
> resets and suspends where it doesn't, such as suspend-to-idle, where
> in the former case if the host TSC resets, the guests' would
> previously be "frozen" due to KVM's backwards TSC prevention, while
> in the latter case they would advance.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>

Tested with comparing `date` before and after suspend-to-RAM[1]:
  echo deep >/sys/power/mem_sleep
  echo $(date '+%s' -d '+3 minutes') >/sys/class/rtc/rtc0/wakealarm
  echo mem >/sys/power/state

Without the patch, the guest's `date` is slower (~3 mins) than the host's
after resuming.

Tested-by: Tzung-Bi Shih <tzungbi@kernel.org>

[1]: https://www.kernel.org/doc/Documentation/power/states.txt

Some non-functional comments inline below.

> @@ -4971,7 +4971,37 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  	/* Apply any externally detected TSC adjustments (due to suspend) */
>  	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
> -		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
> +		unsigned long flags;
> +		struct kvm *kvm;
> +		bool advance;
> +		u64 kernel_ns, l1_tsc, offset, tsc_now;
> +
> +		kvm = vcpu->kvm;

It will be more clear (at least to me) if moving the statement to its declaration:
  struct kvm *kvm = vcpu->kvm;

Other than that, the following code should better utilitize the local
variable, e.g. s/vcpu->kvm/kvm/g.

> +		advance = kvm_get_time_and_clockread(&kernel_ns,
> +		    &tsc_now);
> +		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
> +		/*
> +		 * Advance the guest's TSC to current time instead of only
> +		 * preventing it from going backwards, while making sure
> +		 * all the vCPUs use the same offset.
> +		 */
> +		if (kvm->arch.host_was_suspended && advance) {
> +			l1_tsc = nsec_to_cycles(vcpu,
> +			    vcpu->kvm->arch.kvmclock_offset +
                            ^^^^^^^^^
                            kvm

> +			    kernel_ns);
> +			offset = kvm_compute_l1_tsc_offset(vcpu,
> +			    l1_tsc);
> +			kvm->arch.cur_tsc_offset = offset;
> +			kvm_vcpu_write_tsc_offset(vcpu, offset);
> +		} else if (advance)
> +			kvm_vcpu_write_tsc_offset(vcpu,
> +			    vcpu->kvm->arch.cur_tsc_offset);
                            ^^^^^^^^^
			    kvm

> +		else
> +			adjust_tsc_offset_host(vcpu,
> +			    vcpu->arch.tsc_offset_adjustment);

Need braces in `else if` and `else` cases [2].

[2]: https://www.kernel.org/doc/html/latest/process/coding-style.html#placing-braces-and-spaces


> @@ -12640,6 +12670,7 @@ int kvm_arch_enable_virtualization_cpu(void)
>  				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>  			}
>  
> +			kvm->arch.host_was_suspended = 1;

Given that it is a bool, how about use `true`?

