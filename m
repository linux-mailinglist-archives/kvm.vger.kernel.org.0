Return-Path: <kvm+bounces-18717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3896D8FA9F9
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B738E28975B
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B696013D8B5;
	Tue,  4 Jun 2024 05:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ysen/vuH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B5013D517
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 05:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717478865; cv=none; b=RbA/5HpG+mZRvzcOThJcbwlP6MRYNOKAuViam8408pGv/z8PEbGR5SS7ZY0pNiz8KPtxud83wv8mLvViGvtYKcbcueFUHdUFsGznA/oFze4zUkaZvKlvEwgZW5m14gth/mPmrUs8PGyKMObeqG1UPfcFoAdV6Dlb5pVJR4p6vhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717478865; c=relaxed/simple;
	bh=hw4vOMV3X+rl8R8NqyhtXR0AIaZjjaK77kA1QDS6C68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qx0ND++nM3lldJOx4j7vF18Y8woCw1S7YDAeOYtxVyE36icBG9lHljaKnVXp7D3+bzGcHOe8AW+oabYgLscSBd9lq07js5ox9mu0QIILGy5G2bVa+B4tpHGHTwPZ5gcvuEiLiEUkyFSO/onD5IMLAK1b38SJMu1v6jyTRvM3I5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ysen/vuH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717478863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rkyxHo7ufzbasDB9OUIpiQqoV4IGCeFkLm4TuBa0NBI=;
	b=Ysen/vuHlFttkFROWUYRRt3HvFisrd0yQZUVbrskDNyOfur4CeDya7oyieZRUc3Qmg9Byl
	2dH9vUSXKSXyzojoFj6wRgaPYO50XPflQj2FRXVGb1772hh6NLSn4+iWjqGgazq0/n8zIo
	tLHaEjLHO09J8BLYI+cZsu5V0wS/c8o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-DGlLcLRCO_qItUE7EHz5Nw-1; Tue, 04 Jun 2024 01:27:41 -0400
X-MC-Unique: DGlLcLRCO_qItUE7EHz5Nw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35dcde1be6cso495843f8f.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 22:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717478860; x=1718083660;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rkyxHo7ufzbasDB9OUIpiQqoV4IGCeFkLm4TuBa0NBI=;
        b=FYp8/LPNdEjlpvi2e/AnC6mcLdiC++LuGMCtN52WEO6e/RYqfKCvUbpZBbIJHQkzwj
         m3WapLoyV4IWwoGABBQuGumLP3qIz/rML9dVc30xYyLQYMxKi1UPPzJgdUtdDqN7EVxO
         ylxguqpgbdhJn+exODkUGF9aoJrepXX3/sVCxvtQmOfaaFMtKRr0PikrsuNS4Fkqdvvj
         WvYizTt5VRr648FH1B61wVyAAHdoPVs7lbTLSsaIZ4PW1jKHoadHFkwR8Ss+zKsc6wwh
         6PIx0rRoD1qDbEjTcorVyPflZ3y3zCxzsFyzzFYSR1LA7MwB9ibnP3QbYB5y+46Cr7t2
         hVEw==
X-Forwarded-Encrypted: i=1; AJvYcCXEAiPJ/0JsIGZ9ghO9fcmtpKhfQT7+f9z/dQiRKk60FsZfL6krD2rkcEHkJwJC6dXRErlFIWcVnlmfySnKPX8PZAQX
X-Gm-Message-State: AOJu0YxIeFbcfugHQPLA/tShIl9ppB0VjGtWu4tWJpKwrqHNY0p82yM2
	HPH3wdBTubp4xl4QyTziNtOVlvY+WnyRht0+CtAwmbSWzonWGCOU6tnEdwCOSooKULKDOq+H3i8
	2uo3qkqBKOYOJbZDcIkmELP97MZZCd8R+z5fkvYje4S+0VZR9v5KaBf5p6w==
X-Received: by 2002:adf:a44e:0:b0:357:bd78:4960 with SMTP id ffacd0b85a97d-35e0f271b59mr8241100f8f.25.1717478860736;
        Mon, 03 Jun 2024 22:27:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPQaJeJxNttypGyKrmvK9Ifm7PqtsuYviQXcOojYJWptCb/11okIHqFzbP5dzGjicRAbNg/Q==
X-Received: by 2002:adf:a44e:0:b0:357:bd78:4960 with SMTP id ffacd0b85a97d-35e0f271b59mr8241079f8f.25.1717478859519;
        Mon, 03 Jun 2024 22:27:39 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd062ec29sm10397651f8f.81.2024.06.03.22.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:27:39 -0700 (PDT)
Message-ID: <d167cb31-11d4-4a0f-8b4e-056fc2afaaf0@redhat.com>
Date: Tue, 4 Jun 2024 07:27:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 19/31] powerpc: Avoid using larx/stcx.
 in spinlocks when only one CPU is running
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-20-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-20-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> The test harness uses spinlocks if they are implemented with larx/stcx.
> it can prevent some test scenarios such as testing migration of a
> reservation.

I'm having a hard time to understand that patch description. Maybe you could 
rephrase it / elaborate what's the exact problem here?

  Thanks,
   Thomas


> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/smp.h    |  1 +
>   lib/powerpc/smp.c        |  5 +++++
>   lib/powerpc/spinlock.c   | 29 +++++++++++++++++++++++++++++
>   lib/ppc64/asm/spinlock.h |  7 ++++++-
>   powerpc/Makefile.common  |  1 +
>   5 files changed, 42 insertions(+), 1 deletion(-)
>   create mode 100644 lib/powerpc/spinlock.c
> 
> diff --git a/lib/powerpc/asm/smp.h b/lib/powerpc/asm/smp.h
> index c45988bfa..66188b9dd 100644
> --- a/lib/powerpc/asm/smp.h
> +++ b/lib/powerpc/asm/smp.h
> @@ -15,6 +15,7 @@ struct cpu {
>   
>   extern int nr_cpus_present;
>   extern int nr_cpus_online;
> +extern bool multithreaded;
>   extern struct cpu cpus[];
>   
>   register struct cpu *__current_cpu asm("r13");
> diff --git a/lib/powerpc/smp.c b/lib/powerpc/smp.c
> index 27b169841..73c0ef214 100644
> --- a/lib/powerpc/smp.c
> +++ b/lib/powerpc/smp.c
> @@ -276,6 +276,8 @@ static void start_each_secondary(int fdtnode, u64 regval __unused, void *info)
>   	start_core(fdtnode, datap->entry);
>   }
>   
> +bool multithreaded = false;
> +
>   /*
>    * Start all stopped cpus on the guest at entry with register 3 set to r3
>    * We expect that we come in with only one thread currently started
> @@ -290,6 +292,7 @@ bool start_all_cpus(secondary_entry_fn entry)
>   
>   	assert(nr_cpus_online == 1);
>   	assert(nr_started == 1);
> +	multithreaded = true;
>   	ret = dt_for_each_cpu_node(start_each_secondary, &data);
>   	assert(ret == 0);
>   	assert(nr_started == nr_cpus_present);
> @@ -361,10 +364,12 @@ static void wait_each_secondary(int fdtnode, u64 regval __unused, void *info)
>   
>   void stop_all_cpus(void)
>   {
> +	assert(multithreaded);
>   	while (nr_cpus_online > 1)
>   		cpu_relax();
>   
>   	dt_for_each_cpu_node(wait_each_secondary, NULL);
>   	mb();
>   	nr_started = 1;
> +	multithreaded = false;
>   }
> diff --git a/lib/powerpc/spinlock.c b/lib/powerpc/spinlock.c
> new file mode 100644
> index 000000000..623a1f2c1
> --- /dev/null
> +++ b/lib/powerpc/spinlock.c
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: LGPL-2.0 */
> +#include <asm/spinlock.h>
> +#include <asm/smp.h>
> +
> +/*
> + * Skip the atomic when single-threaded, which helps avoid larx/stcx. in
> + * the harness when testing tricky larx/stcx. sequences (e.g., migration
> + * vs reservation).
> + */
> +void spin_lock(struct spinlock *lock)
> +{
> +	if (!multithreaded) {
> +		assert(lock->v == 0);
> +		lock->v = 1;
> +	} else {
> +		while (__sync_lock_test_and_set(&lock->v, 1))
> +			;
> +	}
> +}
> +
> +void spin_unlock(struct spinlock *lock)
> +{
> +	assert(lock->v == 1);
> +	if (!multithreaded) {
> +		lock->v = 0;
> +	} else {
> +		__sync_lock_release(&lock->v);
> +	}
> +}
> diff --git a/lib/ppc64/asm/spinlock.h b/lib/ppc64/asm/spinlock.h
> index f59eed191..b952386da 100644
> --- a/lib/ppc64/asm/spinlock.h
> +++ b/lib/ppc64/asm/spinlock.h
> @@ -1,6 +1,11 @@
>   #ifndef _ASMPPC64_SPINLOCK_H_
>   #define _ASMPPC64_SPINLOCK_H_
>   
> -#include <asm-generic/spinlock.h>
> +struct spinlock {
> +	unsigned int v;
> +};
> +
> +void spin_lock(struct spinlock *lock);
> +void spin_unlock(struct spinlock *lock);
>   
>   #endif /* _ASMPPC64_SPINLOCK_H_ */
> diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
> index b98f71c2f..1ee9c25d6 100644
> --- a/powerpc/Makefile.common
> +++ b/powerpc/Makefile.common
> @@ -49,6 +49,7 @@ cflatobjs += lib/powerpc/rtas.o
>   cflatobjs += lib/powerpc/processor.o
>   cflatobjs += lib/powerpc/handlers.o
>   cflatobjs += lib/powerpc/smp.o
> +cflatobjs += lib/powerpc/spinlock.o
>   
>   OBJDIRS += lib/powerpc
>   


