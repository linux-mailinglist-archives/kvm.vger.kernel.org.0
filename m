Return-Path: <kvm+bounces-43879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D874CA98239
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDB891885E49
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F44278168;
	Wed, 23 Apr 2025 07:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="stsLIYbz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2AE27780B;
	Wed, 23 Apr 2025 07:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745395060; cv=none; b=ZC6RWzcNSOrH9yFRJWU6V05FQaARXPSs7Gc1Wj6YhyOKrQWMVRNOyLZm/CyaRJt1+hKNFmL2OsMeB5Bo0ZbL6J8GavByak5EqIjTRXsdOWJCXdPFUkslWJPEnqVAI56hTzpjztDzST8js8Tpz2YSLf5zT0ODapAyY/SCDpDULKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745395060; c=relaxed/simple;
	bh=yNmwVGrDgbCtRlFwMtWRCumYMQG64ApPT+3w1d4vZrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nyzCXRqGAtkdz6cJun1/GNzQfymxiOCtgwvsH3ARm93mRg0nxvdIR6ipiuTrgz43JV4knHqfYZba4V1kbaJOSUR6QBgIGh1pu6tweaFsOzE+0wpAdx6UUPr8/JWFCf7GP+54I8TK+vlg/GDmvVpFNY7yEUYZF3t1XWPGDE8dq5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=stsLIYbz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF6EC4CEE2;
	Wed, 23 Apr 2025 07:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745395059;
	bh=yNmwVGrDgbCtRlFwMtWRCumYMQG64ApPT+3w1d4vZrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=stsLIYbzqNWZwwaLBX20CHWv2vLU9ObmcgpySg69lUSemrfLfGiwXtytZWtTi/WUX
	 NxT4pxjQIerCiwLSt9Uf8oBibxzDPd/U3XsRExW5Du4Wyw5E8X07biYxDZNyCsv9gc
	 PLQDdNy+wuMkW0JX/kmBDLY6ktXaclvACPFMJx93KlpIbZbNvdqS2uL+2/kwaITiKI
	 x9fMCdSwCGGydHR9iLqYws2JK+M5UtYEC4sqR4Ik9vucnxLDjTCfrCcxdjxobR3NpL
	 zZAvXpqmAh7kZfENSANnf8ZqBz7DBivw6YyesAkEliBTVnfcdllAf9JVpecDRaT6zQ
	 q804Nr0hxCFwA==
Date: Wed, 23 Apr 2025 07:57:35 +0000
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
Subject: Re: [PATCH v5 2/2] KVM: x86: Include host suspended time in steal
 time
Message-ID: <aAidb496s6ke8RoO@google.com>
References: <20250325041350.1728373-1-suleiman@google.com>
 <20250325041350.1728373-3-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325041350.1728373-3-suleiman@google.com>

On Tue, Mar 25, 2025 at 01:13:50PM +0900, Suleiman Souhlal wrote:
> When the host resumes from a suspend, the guest thinks any task
> that was running during the suspend ran for a long time, even though
> the effective run time was much shorter, which can end up having
> negative effects with scheduling.
> 
> [...]
> 
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>

Saw the corresponding host suspended time has been compensated in
update_rq_clock_task():
Tested-by: Tzung-Bi Shih <tzungbi@kernel.org>

With 1 minor comment:
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>

> @@ -917,8 +918,13 @@ struct kvm_vcpu_arch {
>  
>  	struct {
>  		u8 preempted;
> +		bool host_suspended;

Use it in bool manner.

> +static void wait_for_resume(struct kvm_vcpu *vcpu)
> +{
> +	wait_event_interruptible(vcpu->arch.st.resume_waitq,
> +	    vcpu->arch.st.host_suspended == 0);

E.g.: !vcpu->arch.st.host_suspended.

> @@ -6939,6 +6954,19 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
>  
>  	mutex_lock(&kvm->lock);
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		vcpu->arch.st.last_suspend = ktime_get_boottime_ns();
> +		/*
> +		 * Tasks get thawed before the resume notifier has been called
> +		 * so we need to block vCPUs until the resume notifier has run.
> +		 * Otherwise, suspend steal time might get applied too late,
> +		 * and get accounted to the wrong guest task.
> +		 * This also ensures that the guest paused bit set below
> +		 * doesn't get checked and cleared before the host actually
> +		 * suspends.
> +		 */
> +		vcpu->arch.st.host_suspended = 1;

E.g.: true.

> +static int kvm_arch_resume_notifier(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	mutex_lock(&kvm->lock);
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		vcpu->arch.st.host_suspended = 0;

E.g.: false.

