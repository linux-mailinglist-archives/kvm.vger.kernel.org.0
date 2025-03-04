Return-Path: <kvm+bounces-40050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E74D0A4E5F9
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 17:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8E258A7D60
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 16:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2EF290BAF;
	Tue,  4 Mar 2025 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIMNmZqD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4B8280CED;
	Tue,  4 Mar 2025 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741103967; cv=none; b=XnK1jzPZaJuDjIgIwtWvAGCk9eMMoap9LDjWVvk+Qn1EjyXqJsdmDnC34zHfpbdJjqWxutqE6W6WvA77m891G5EvlZKXWcFfYpDwa/l6RWSCROc8LsMyfdWHizIfb5Cmao8yShp7dCiFkKDJ6faySrEpkIKNwOvMIuePCeUInH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741103967; c=relaxed/simple;
	bh=tI6CbCvS+99CHCQx7LJm9mNgwjQ9J7iVbxCGtnr8+fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7IO2qROupBsow9eky4En5Zt7CUcOdDvvL/VPQ1y8bQB8UoQL0+Rh445X79c5cPGLHMD9JJP+sOmdwrSsmxNVHsy9VmyJ3PAUIBs09TbOmpIOLH1Alhrtribjkk4XtIQOQzL5E+lb7OCQwOo4GtBOD085lxmDAK2hWi8ZdHupuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIMNmZqD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D6BC4CEE5;
	Tue,  4 Mar 2025 15:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741103966;
	bh=tI6CbCvS+99CHCQx7LJm9mNgwjQ9J7iVbxCGtnr8+fQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tIMNmZqDisrL76UptuAOhjHSW+UiAkyJ2gaH+awH4iAAKfoxt7iZqOXwR5IePZ3ro
	 q41SyS/9rmbREFaBed1aKwEDhUgTXaRpkxzUbKu9wSdqnPsKCgEultTvwcRA7sFdRO
	 /KBSryGK2UYAy4CUglw0PhMSHvTBEx6uLcdyhJuf4BJ8K1ch1H+a5WtfJBK/Xny83l
	 o+kCNSsVY1RC8SgbRyUkH3WO+9YbGiCZAZZRptkA7jclMSOnVA5wA9e0ZP4HLic0mS
	 em3O22UNAm5FNHoSPvXN3YngXT0xcM84WLPFQn1N4Z52nauxCjcaI23Ee7yHd4EMAe
	 5lbcat7EoOKqg==
Date: Tue, 4 Mar 2025 15:59:22 +0000
From: Simon Horman <horms@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	leiyang@redhat.com, virtualization@lists.linux.dev, x86@kernel.org,
	netdev@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 2/2] kvm: retry nx_huge_page_recovery_thread creation
Message-ID: <20250304155922.GG3666230@kernel.org>
References: <20250227230631.303431-1-kbusch@meta.com>
 <20250227230631.303431-3-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227230631.303431-3-kbusch@meta.com>

On Thu, Feb 27, 2025 at 03:06:31PM -0800, Keith Busch wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> A VMM may send a signal to its threads while they've entered KVM_RUN. If
> that thread happens to be trying to make the huge page recovery vhost
> task, then it fails with -ERESTARTNOINTR. We need to retry if that
> happens, so call_once needs to be retryable. Make call_once complete
> only if what it called was successful.
> 
> [implemented the kvm user side]
> Signed-off-by: Keith Busch <kbusch@kernel.org>

...

> diff --git a/include/linux/call_once.h b/include/linux/call_once.h
> index 6261aa0b3fb00..ddcfd91493eaa 100644
> --- a/include/linux/call_once.h
> +++ b/include/linux/call_once.h
> @@ -26,20 +26,26 @@ do {									\
>  	__once_init((once), #once, &__key);				\
>  } while (0)
>  
> -static inline void call_once(struct once *once, void (*cb)(struct once *))
> +static inline int call_once(struct once *once, int (*cb)(struct once *))
>  {
> +	int r;
> +
>          /* Pairs with atomic_set_release() below.  */
>          if (atomic_read_acquire(&once->state) == ONCE_COMPLETED)
> -                return;
> +		return 0;
>  
>          guard(mutex)(&once->lock);
>          WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
>          if (atomic_read(&once->state) != ONCE_NOT_STARTED)
> -                return;
> +                return -EINVAL;

Hi Keith,

A minor nit from my side:

As you are changing this line, and it seems like there will be another
revision of this series anyway, please consider updating the indentation to
use tabs.

>  
>          atomic_set(&once->state, ONCE_RUNNING);
> -        cb(once);
> -        atomic_set_release(&once->state, ONCE_COMPLETED);
> +	r = cb(once);
> +	if (r)
> +		atomic_set(&once->state, ONCE_NOT_STARTED);
> +	else
> +		atomic_set_release(&once->state, ONCE_COMPLETED);
> +	return r;
>  }
>  
>  #endif /* _LINUX_CALL_ONCE_H */
> -- 
> 2.43.5
> 
> 

