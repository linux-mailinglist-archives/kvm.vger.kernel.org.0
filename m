Return-Path: <kvm+bounces-6739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F1498398F5
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 20:02:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2167E289C7F
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 19:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B0512BF20;
	Tue, 23 Jan 2024 18:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cqkMf2BT"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ED712BEB7
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 18:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706036100; cv=none; b=p8KLbEvLlbBUKLYPo3eH2NwzW8C9augTNjvCpTM0TcjMpluj4ZBON/9wVkW4k5EdYg/m0mEgqbWtSwcJqfMFX5p5ZPD5DQsS6EmSLenbNZklyv/gNPzZB+e6p8wu/85cnnsbc2V6cXmUKynSD+osZUimwi2UR+c2N/av6HxAZCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706036100; c=relaxed/simple;
	bh=dFiL7y+6wi3O9vGhVa4U/27ru8/dc6wr+PS2fFgMbyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GH2KtUXmi8Jm+GJsDRMXCIi0GfKRfv24U/HNaugmodKkm7c6xoz3CNwb82XYO7yiRuX4IMUuxHalV6ZwqnYshOz/nWiqEZUpqu64qQjS+jS14haR8fFZX/DwkDTWd2X/W6iwSVCXI48YbO6SO/fuLJ+jG6tfjd6EGLBKucoVepg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cqkMf2BT; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 23 Jan 2024 18:54:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706036096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hUcehH7JdLXvWS7hq4xaUhvH1ukHoNmc8fJo0jHw5Pw=;
	b=cqkMf2BTXq0M2fyg8agzaTwh+PfZcAQ35mKhfewNaqbMZbqRLeYo0/xEhtXkwEVVCT4ggJ
	I+zt6tSnSpfM3FZNYBXTJPlbcT5UVxJ3UkR80M5JVEMFenSsHMxUHkFmPgHB9NaLvwtzM0
	2/KY8RV9t8jzcn5pvfFf2yk5VLnKdqY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Yi Wang <up2wing@gmail.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, wanpengli@tencent.com,
	foxywang@tencent.com, maz@kernel.org, anup@brainfault.org,
	atishp@atishpatra.org, borntraeger@linux.ibm.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [v2 4/4] KVM: s390: don't setup dummy routing when
 KVM_CREATE_IRQCHIP
Message-ID: <ZbALemDF9sAYS2AM@linux.dev>
References: <20240121111730.262429-1-foxywang@tencent.com>
 <20240121111730.262429-5-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240121111730.262429-5-foxywang@tencent.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 21, 2024 at 07:17:30PM +0800, Yi Wang wrote:
> As we have setup empty irq routing in kvm_create_vm(), there's
> no need to setup dummy routing when KVM_CREATE_IRQCHIP.
> 
> Signed-off-by: Yi Wang <foxywang@tencent.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index acc81ca6492e..7c836c973b75 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2999,14 +2999,11 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		break;
>  	}
>  	case KVM_CREATE_IRQCHIP: {
> -		struct kvm_irq_routing_entry routing;
> -
> -		r = -EINVAL;
> -		if (kvm->arch.use_irqchip) {
> -			/* Set up dummy routing. */
> -			memset(&routing, 0, sizeof(routing));
> -			r = kvm_set_irq_routing(kvm, &routing, 0, 0);
> -		}
> +		/*
> +		 * As we have set up empty routing, there is no need to
> +		 * setup dummy routing here.
> +		 */

Where exactly?

In the context of this patch series it is rather obvious, but this
comment does not stand on its own. You can either throw the reader a
bone by mentioning where the dummy routing is created or just drop the
comment altogether.

> +		r = 0;
>  		break;
>  	}
>  	case KVM_SET_DEVICE_ATTR: {
> -- 
> 2.39.3
> 

-- 
Thanks,
Oliver

