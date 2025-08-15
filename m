Return-Path: <kvm+bounces-54806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B936B28667
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 21:28:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A58093B532A
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 19:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F3B29A32D;
	Fri, 15 Aug 2025 19:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ujw8AG/E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C91BAD21
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 19:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755286086; cv=none; b=mpLUpIUXH/V+SHJHFP4crOtDI5H8GaQIkqiYCzg7bnn2R3hEPazrQoJZI8Ejr2vd+dXFsmZiXQX06UREr6QBpKcME/X2YVv24WVDq9t/CI8vbfr3ym33JCOaNhkySWeIJXXPW7K2xXfONW6WjZYlzBXwr3ARcc9yK6yzBZg4kwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755286086; c=relaxed/simple;
	bh=03ai3+jPXw+qIgPjJjhYeat8FHaMCcAxTtMV6J8Fauw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DJYNpUN88weBz+L/uxNRcykZsdi398ELnDjtTrjbnYH0ssPsHiu8xfZkXUQHPr9zSlWYxDnXtEpKbQO7tpy9LEIRqo55K2STt9gHe4QG6p7Wca2sulFeWglmze5pywx7lW26leDZ9rm6Gt8+gOvH4umcOBFXqUT09c5l9O7WLCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ujw8AG/E; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326bd712cso2125299a91.2
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 12:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755286085; x=1755890885; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CtxMP1qLySSUVXufrp6NxftESi55Z9nJ+C2xCceAidg=;
        b=ujw8AG/EyBE6stXLKMTbm3ehnQ3ocfhmgWd3ZJRIh2n/xHq6eVan/HhZnu/rEOHn/f
         1hbzBAa8BPYmYo98FgkWBN5EYsmsg2Uixs1mbz9y3KbjnD2lrxoTbg3zJeP4C/YlzOKw
         631IfSgOnBF3sBN7xIt0hWySpCG/ipacwYiiOH/E+D42Ec3PNck5PKd7Bs4WJYko4fxx
         DpotTIWxgYs8TM3HuBVagv2uc/GvoWF65QkpeFRQHtMvU0ey+/fM29bAA8dYnk4wfgda
         r9rWS8KCSNiua3Bx92LJ+bYmaPRKoUizzWNceGjUXK792P4dp6xVdBjRu0Ps+83ZAmyO
         0mRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755286085; x=1755890885;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtxMP1qLySSUVXufrp6NxftESi55Z9nJ+C2xCceAidg=;
        b=hfPcpRRZHC52lD914v8B8NoVDaqhyyre6wrbvLX2Z7YXMvid1Z/4lpQMRek5oPZ4oF
         bF1CsMgodv2LOX84ULuKtpA2O26TlqZrKeNC2M5JwoPumG88BUqf7jvAfwftG1MqQ+0+
         Ti1A6CZnfYKeB2DAz6hZidNfEot9B1gfiR6wgT2zdj1DCoEmERB/JsHqVl4hPv7OOP9k
         BoYrMRdp2KogtYs794QoRK+O6EU0ZANS3TZ2abbbpchKTrRH1Tw4Ka10K/iwxSd9S+bG
         lK5AEOGTeyymfgDoD4XrYe/pgGsVOUWiTWe/TBqIAmxOa4+ez94rCVaSTw7x54xsjMYm
         tTxw==
X-Forwarded-Encrypted: i=1; AJvYcCWiPQ8BvlYlwa0E1HlvEhKMghbA4UnHHHSEQRdg2kbcYQ6XNqvAjqEK7DFev7jAjgBMlvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiBrLiSm4ClW2VmmRmtYrbk5mpAzcCFwdPaMNaQL+lMkMSCROP
	KpFRkgJlVk61Ou4oWBFB4t4f1XPqRhBv+aqW9qpUKc9phnWHnsA2Q7KVjsnQw1yolIhvzhC1vwX
	Tbu0MDA==
X-Google-Smtp-Source: AGHT+IFheb7H3vGWMwDpPa/ZTz43jwwEwav9YvOcV9yuk5MWwK/8m1Y/ywXNiBd1O4MgZl8Zxb99lnXh3Wc=
X-Received: from pjbph13.prod.google.com ([2002:a17:90b:3bcd:b0:31f:232:1fae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b10:b0:30a:4874:5397
 with SMTP id 98e67ed59e1d1-32341ebf8bemr4526630a91.9.1755286084895; Fri, 15
 Aug 2025 12:28:04 -0700 (PDT)
Date: Fri, 15 Aug 2025 12:28:03 -0700
In-Reply-To: <20250722110005.4988-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250722110005.4988-1-lirongqing@baidu.com>
Message-ID: <aJ-KQ5811s2E5Dj9@google.com>
Subject: Re: [PATCH][v2] x86/kvm: Prefer native qspinlock for dedicated vCPUs
 irrespective of PV_UNHALT
From: Sean Christopherson <seanjc@google.com>
To: lirongqing <lirongqing@baidu.com>
Cc: pbonzini@redhat.com, vkuznets@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The commit b2798ba0b876 ("KVM: X86: Choose qspinlock when dedicated
> physical CPUs are available") states that when PV_DEDICATED=1
> (vCPU has dedicated pCPU), qspinlock should be preferred regardless of
> PV_UNHALT.  However, the current implementation doesn't reflect this: when
> PV_UNHALT=0, we still use virt_spin_lock() even with dedicated pCPUs.
> 
> This is suboptimal because:
> 1. Native qspinlocks should outperform virt_spin_lock() for dedicated
>    vCPUs irrespective of HALT exiting
> 2. virt_spin_lock() should only be preferred when vCPUs may be preempted
>    (non-dedicated case)
> 
> So reorder the PV spinlock checks to:
> 1. First handle dedicated pCPU case (disable virt_spin_lock_key)
> 2. Second check single CPU, and nopvspin configuration
> 3. Only then check PV_UNHALT support
> 
> This ensures we always use native qspinlock for dedicated vCPUs, delivering
> pretty performance gains at high contention levels.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

