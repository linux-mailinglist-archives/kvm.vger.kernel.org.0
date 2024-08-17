Return-Path: <kvm+bounces-24465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D01A9955458
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 02:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE6C3B20B4A
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53E820E6;
	Sat, 17 Aug 2024 00:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tx07eVrf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E204621
	for <kvm@vger.kernel.org>; Sat, 17 Aug 2024 00:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723855023; cv=none; b=cuMCnT4X7k4pFiXCqBqHKRiRIc0o+oU5kw9lkOdyAC6Jq8x32RHV8ANI0RDwicaGSxj79vWTcQWFwYxeGH/SS745AGiqkCy1+KLL1/HK45WY9m6/reAuro3tsuC/5QyiKSiso6E/C8d1447cvBRHZf4ag0Rc+FOci9suKkiduyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723855023; c=relaxed/simple;
	bh=yc9+A/Uk5OXYnMrfS9Q6tibndCnwTYd4w8hdihTIqgw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fTZOaeRyYGggvQfr1JCBzCM5LYV0ALqyPVSTL6vP0990G71iRMtjDcEnqQyrq7GlQteWmE1jnvTDfaoml+C46QevwKBKKIls9QLRap8GpGo4mZevnbuJVt0M6XTZmcC10Lotr1egnZtYfV0nFEncyeqQv6oRtLndD9uWv4P9X2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tx07eVrf; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a2a04c79b6so2755841a12.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723855021; x=1724459821; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g5Q6h7EE6e8oo9nNsCy9xEJB2cXV2SHEUM21EUk4+m0=;
        b=Tx07eVrfciDYT2i8l5npjcQTfxk52TiSYwpSlxm9t3TmqdzDFQ1z1bBbvsRRZdIQiV
         UknJHMZ2ks6dbRdOMZCrvEd+ZZSgV368WMeeyYYuxJ0F3aTBtQLu3nJ0lrQN36vhqJir
         lQCw/GFQ5M2204EoMmYv+TcWPl+THzqO22Kv7iMjLdY5SvO/x4//FYuCNv+XLnIxRTQO
         cHAW/Px5iWMmTn/WGoHOyOvOMhrFUEHV7Pdkx2HYHWyFDUR5d9NYCBzXcsHd1LhT0L9X
         HnuhEzLoasEFmkB85V/4ayra+l/XLiQ9UziZ6RakQ0Q2FUwgOtOQzV2gB6lox5aZXHuC
         OZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723855021; x=1724459821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g5Q6h7EE6e8oo9nNsCy9xEJB2cXV2SHEUM21EUk4+m0=;
        b=oJdmUlxlfgHlcPtWyFWy1qRP9tI6cWsEJk5KAZ92PwZq260uFYWC0hS4fjffcDymH9
         l7dHFgkrqO9BGb/1kX8zLPdIuBe5/r/uEQM4NNkGmrSmVd/CkYspD8at0R0r/5LPjjVE
         qaEC10kubbfX2t+qhOmv5F+7//gMGzzkkIrsreXBXh8oQDwsAtzuThILaWrybP35Awgv
         VN4JYNa3yRu73iAe/79H/3BRaAq9x4OINGHReYfI8TrO2945UBC3LbOJb/9zSdYMrEwJ
         IY7caehzOQ4vcF181CQopEuX5TKo/eBzKl19/Ykwp3nFuMaGVi0fv6642+cq2ws0ijHc
         zRyA==
X-Gm-Message-State: AOJu0YyVX4a/uyEaNJU2/IpdmqMz2R/jxzNWSYSyXNbf9oYfrMILuato
	0zte9dwzEq/2h7LIGE3Hsm+YLGBwReSIF3yBK0ut/U8QupTcG/BOiNd41+ryBzcpJj2i1Q4fr0p
	7rA==
X-Google-Smtp-Source: AGHT+IGiBpclHGyWuS7xZtzrOqLm5PMe4TcLt5eNJ1T28qlJ7YY/aJlKoNUGNUB0wDqeiXBdtHnsFdHJx5Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:283:b0:2cf:93dc:112d with SMTP id
 98e67ed59e1d1-2d3e276895cmr48051a91.4.1723855019662; Fri, 16 Aug 2024
 17:36:59 -0700 (PDT)
Date: Fri, 16 Aug 2024 17:36:58 -0700
In-Reply-To: <20240718193543.624039-5-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240718193543.624039-1-ilstam@amazon.com> <20240718193543.624039-5-ilstam@amazon.com>
Message-ID: <Zr_wqv7HiFNR2aCz@google.com>
Subject: Re: [PATCH v2 4/6] KVM: Add KVM_(UN)REGISTER_COALESCED_MMIO2 ioctls
From: Sean Christopherson <seanjc@google.com>
To: Ilias Stamatis <ilstam@amazon.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk, nh-open-source@amazon.com, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 18, 2024, Ilias Stamatis wrote:
> Add 2 new ioctls, KVM_REGISTER_COALESCED_MMIO2 and
> KVM_UNREGISTER_COALESCED_MMIO2. These do the same thing as their v1
> equivalents except an fd returned by KVM_CREATE_COALESCED_MMIO_BUFFER
> needs to be passed as an argument to them.
> 
> The fd representing a ring buffer is associated with an MMIO region
> registered for coalescing and all writes to that region are accumulated
> there. This is in contrast to the v1 API where all regions have to share
> the same buffer. Nevertheless, userspace code can still use the same
> ring buffer for multiple zones if it wishes to do so.
> 
> Userspace can check for the availability of the new API by checking if
> the KVM_CAP_COALESCED_MMIO2 capability is supported.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> Reviewed-by: Paul Durrant <paul@xen.org>
> ---
> 
> v1->v2:
>   - Rebased on top of kvm/queue resolving the conflict in kvm.h
> 
>  include/uapi/linux/kvm.h  | 16 ++++++++++++++++
>  virt/kvm/coalesced_mmio.c | 37 +++++++++++++++++++++++++++++++------
>  virt/kvm/coalesced_mmio.h |  7 ++++---
>  virt/kvm/kvm_main.c       | 36 +++++++++++++++++++++++++++++++++++-
>  4 files changed, 86 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 87f79a820fc0..7e8d5c879986 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -480,6 +480,16 @@ struct kvm_coalesced_mmio_zone {
>  	};
>  };
>  
> +struct kvm_coalesced_mmio_zone2 {
> +	__u64 addr;
> +	__u32 size;
> +	union {
> +		__u32 pad;
> +		__u32 pio;
> +	};
> +	int buffer_fd;

Dunno if it matters, but KVM typically uses __u32 for file descriptors and then
does the verificaton on the backend (which needs to be there regardless).

> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 64428b0a4aad..729f3293f768 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -17,6 +17,7 @@
>  #include <linux/kvm.h>
>  #include <linux/anon_inodes.h>
>  #include <linux/poll.h>
> +#include <linux/file.h>
>  
>  #include "coalesced_mmio.h"
>  
> @@ -279,19 +280,40 @@ int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm)
>  }
>  
>  int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
> -					 struct kvm_coalesced_mmio_zone *zone)
> +					 struct kvm_coalesced_mmio_zone2 *zone,
> +					 bool use_buffer_fd)
>  {
> -	int ret;
> +	int ret = 0;

Heh, init ret to zero, and then return a pile of error before ret is ever touched.
I assume ret can be set to '0' after mutex_unlock(&kvm->slots_lock); in the happy
path, which would also show that it is indeed the happy path.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9eb22287384f..ef7dcce80136 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4892,6 +4892,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #ifdef CONFIG_KVM_MMIO
>  	case KVM_CAP_COALESCED_MMIO:
>  		return KVM_COALESCED_MMIO_PAGE_OFFSET;
> +	case KVM_CAP_COALESCED_MMIO2:
>  	case KVM_CAP_COALESCED_PIO:
>  		return 1;
>  #endif
> @@ -5230,15 +5231,48 @@ static long kvm_vm_ioctl(struct file *filp,
>  #ifdef CONFIG_KVM_MMIO
>  	case KVM_REGISTER_COALESCED_MMIO: {
>  		struct kvm_coalesced_mmio_zone zone;
> +		struct kvm_coalesced_mmio_zone2 zone2;
>  
>  		r = -EFAULT;
>  		if (copy_from_user(&zone, argp, sizeof(zone)))
>  			goto out;
> -		r = kvm_vm_ioctl_register_coalesced_mmio(kvm, &zone);
> +
> +		zone2.addr = zone.addr;
> +		zone2.size = zone.size;
> +		zone2.pio = zone.pio;
> +		zone2.buffer_fd = -1;
> +
> +		r = kvm_vm_ioctl_register_coalesced_mmio(kvm, &zone2, false);
> +		break;
> +	}
> +	case KVM_REGISTER_COALESCED_MMIO2: {

Ah, the curly braces were just early :-)

> +		struct kvm_coalesced_mmio_zone2 zone;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&zone, argp, sizeof(zone)))
> +			goto out;
> +
> +		r = kvm_vm_ioctl_register_coalesced_mmio(kvm, &zone, true);

