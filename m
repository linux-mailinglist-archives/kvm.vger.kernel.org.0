Return-Path: <kvm+bounces-47785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4DD0AC4CBC
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 13:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B8497A9F98
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F800259C94;
	Tue, 27 May 2025 11:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tLm1kvsZ"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D303253F3C;
	Tue, 27 May 2025 11:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748344088; cv=none; b=I1YL6Vx9ip74TXvYtdcxIpA0nuj431tC0HPBawAGBqQMUtGN8BiQWRf1Z8j59SUIQHhj4bTsfHA3adpvfXn0lfRw4i0sEP9iWtwO/j899nCZd/0pObcm91t6K/m1NHZf1o3NTgtb+UggZ+nbKL3exNF7/PPBNutuEaob35gbciI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748344088; c=relaxed/simple;
	bh=E7bNt32qDpsHOMWfni+psBuHQzSfDTOA8Woeh3rLbVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gw2dOEtIYfW5kCZBGgWWDv34iQToQlV5HSY+AJROxRYwGQ+lY5Ij85TsYqetCXhnLewwo2ftwLYxniQQ35/qFliXir+AIYnYmkbOUhHDcjve0+w7Yjam6BsXhhM8sIhmfZcmOYQSPN4P9q1moiXVsrWtDyFxhJfJGYoE/1Ut8mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tLm1kvsZ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GnhN3/GW9Q+J5WgED8El/uqbV7zOwytVWS06BcQmKo4=; b=tLm1kvsZA2VmSvLknsXeHw8L4N
	5o9ZzBgEzfjDWcgT4hcFQHckj3Jm69YVdgrH/TSO8Pi/wuqyRn2qmAoRhb1JPO+fn8xe1QO+HgWvK
	mqhfapoFlUdwEipmSFSlU9wN0+hgoVdk7bKkMwX9SpMAmgrBtfxK2+qXQDzglXxJ31vv5gSChqKCR
	S2/YUqqJUvoPmGIwBNioegzZeu67bAMW8OOODfO0J1cVZQuQ5RS/MCfDxCOGl6s09rAwX6AOfP/bg
	6q6SqFvSuuwKPPg2GSanbEOJ9i/pMEBt73qI1n/wWkJOgPL29HaYJLYrv/mVi4GQcXOI6WlSmMr6W
	yJ9KU6aQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJs9x-0000000CLvh-028i;
	Tue, 27 May 2025 11:07:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9431B3002CE; Tue, 27 May 2025 13:07:52 +0200 (CEST)
Date: Tue, 27 May 2025 13:07:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: binbin.wu@linux.intel.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
	tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Message-ID: <20250527110752.GB20019@noisy.programming.kicks-ass.net>
References: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
 <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>

On Tue, May 27, 2025 at 04:44:37PM +0800, Edward Adam Davis wrote:
> is_td() and is_td_vcpu() run in no instrumentation, so use __always_inline
> to replace inline.
> 
> [1]
> vmlinux.o: error: objtool: vmx_handle_nmi+0x47:
>         call to is_td_vcpu.isra.0() leaves .noinstr.text section
> 
> Fixes: 7172c753c26a ("KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct")
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> V1 -> V2: using __always_inline to replace noinstr
> 
>  arch/x86/kvm/vmx/common.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 8f46a06e2c44..a0c5e8781c33 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -71,8 +71,8 @@ static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
>  
>  #else
>  
> -static inline bool is_td(struct kvm *kvm) { return false; }
> -static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
> +static __always_inline bool is_td(struct kvm *kvm) { return false; }
> +static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
>  
>  #endif

Right; this is the 'right' fix. Although the better fix would be for the
compiler to not be stupid :-)

