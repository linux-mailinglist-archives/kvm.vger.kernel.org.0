Return-Path: <kvm+bounces-8730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B847855C5C
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 09:23:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D0381F227F1
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 08:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE869134C3;
	Thu, 15 Feb 2024 08:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QcQceDLn"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3D5134AF;
	Thu, 15 Feb 2024 08:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707985274; cv=none; b=QRnUeBXhfcP4+gODV2Wze7sk2ye8i3ZJ2vscbRiTYPMVy9E1L6NmBv6z86Fw+9Qt8lTIR6s15U6UWtwrTC9+hu2+wtddeE+qI8ZMiMr+ixifU9mpClafg2xmLG6Rqc7POHirfQj5p1p5drqVreAtddQobcmdQNGIx/lEiTvqnVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707985274; c=relaxed/simple;
	bh=KAnHYlZlXBpsFLWEGUL3Tjg1f+BLm1z7YZe32xRCU6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyT/WPQpBbsRHHNZrTfS3xs5X/iVI1SN6laE5/gsPAPXpFtdgC5Z1Gx7CtMojCKB8wTA+KKDC0GJE0M1OJPkWBcdIidqmN8OxX+VcDqhWIwfyuGPC/5k7bC4uuwLilNZfDfjhpZZS0O5cVqkrWH4/DKIVe6M+FpD5Vufc1+yvx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QcQceDLn; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Feb 2024 08:21:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707985268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WmAuT0et8a/8e1AvRSIGG17UwteqlvW45FNd3PQ2k5c=;
	b=QcQceDLnbWXQIsGjFsLeH/8KiFcGR+Zu5hdPwyREW4Z+kLXctt86y/cWky70NdeP3SbPYw
	1SDDOPl/FM8WBnh86JRY1VTJUJx2Tw+Bn3VN5osUsU3HzxmA81Yx4e0D4VGDuiHDuU8+lb
	G60acbUMLMMKG6JXIr1C18jCoxUdM0U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	Michael Krebs <mkrebs@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test forced instruction emulation in
 dirty log test (x86 only)
Message-ID: <Zc3JcNVhghB0Chlz@linux.dev>
References: <20240215010004.1456078-1-seanjc@google.com>
 <20240215010004.1456078-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215010004.1456078-3-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 14, 2024 at 05:00:04PM -0800, Sean Christopherson wrote:
> Add forced emulation of MOV and LOCK CMPXCHG instructions in the dirty log
> test's guest code to verify that KVM's emulator marks pages dirty as
> expected (and obviously to verify the emulator works at all).  In the long
> term, the guest code would ideally hammer more of KVM's emulator, but for
> starters, cover the two major paths: writes and atomics.
> 
> To minimize #ifdeffery, wrap only the related code that is x86 specific,
> unnecessariliy synchronizing an extra boolean to the guest is far from the
> end of the world.

Meh, I wouldn't say the end result in guest_write_memory() is that
pretty. Just ifdef the whole function and provide a generic implementation
for the other architectures.

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 36 ++++++++++++++++++--
>  1 file changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index eaad5b20854c..ff1d1c7f05d8 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -92,6 +92,29 @@ static uint64_t guest_test_phys_mem;
>   */
>  static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
>  
> +static bool is_forced_emulation_enabled;
> +
> +static void guest_write_memory(uint64_t *mem, uint64_t val, uint64_t rand)
> +{
> +#ifdef __x86_64__
> +	if (is_forced_emulation_enabled && (rand & 1)) {
> +		if (rand & 2) {

Can't you invert the logic and drop a level of indentation?

	if (!(is_forced_emulation_enabled && (rand & 1))) {
		*mem = val;
	} else if (rand & 2) {
		movq
	} else {
		cmpxchg8b
	}

> +			__asm__ __volatile__(KVM_FEP "movq %1, %0"
> +					     : "+m" (*mem)
> +					     : "r" (val) : "memory");
> +		} else {
> +			uint64_t __old = READ_ONCE(*mem);
> +
> +			__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchgq %[new], %[ptr]"
> +					     : [ptr] "+m" (*mem), [old] "+a" (__old)
> +					     : [new]"r" (val) : "memory", "cc");
> +		}
> +	} else
> +#endif
> +
> +	*mem = val;
> +}
> +

-- 
Thanks,
Oliver

