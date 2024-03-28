Return-Path: <kvm+bounces-12938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47E8688F57F
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B35CE1F2B803
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D31F2A8D7;
	Thu, 28 Mar 2024 02:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="14JQ7/Dj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1257E28E6
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594114; cv=none; b=kgeLqbhhl4lRJzRcTJTydTLgd17jzwZOe0zP3LffXNPTO10cEXwlJP9OI5OenYuGA4pX7tYjqpObWGTqbItalq6IoKHk0PWh9JU7/M80ibb9Uu7UoNw9PQYQIUNfYxGnZ0YJLUGddv1lTBIYQ6qJNDIJ3DdKWP8+F39KgGcKc/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594114; c=relaxed/simple;
	bh=5eGGDSk4BD3UY2fAfn703dVtF9ub3OwUFQVO9EkJFY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h67iAuOlF8KigXMdoDLIEujlwPnPnsO2q4ctuu8WNkvCo31IARTEfMBn/BouM0AGMYJDC7tNiogXAZY/eqe4r0JSyQb/CC3LXrOdkHQr9dpWyV5F2pfWeGMzVLmXbF0aQ75fnkO9Cb/LqFYTAfKRqrzBut5u13laCyPQgE8Fjlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=14JQ7/Dj; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ddaf165a8d9so725465276.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594111; x=1712198911; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9X/k4Ur7ktRAsFVEZTgADbEiXncvofPy+APEnCk0Uuc=;
        b=14JQ7/DjxpcIpqUPcpkmm6lMZhr4UkwbX/x7BaUlaHUJEBi0y2C2z+x+MCSdYG3UIi
         bZfRthj5MtMXl7eOAd2r5kXnN6bx+dtN8fJMBag+lfr80xlY51sWpuQ5LEu1OjHNOlov
         BBwW/hICZYjFQDDivmf3+uYOvP6aPNltYHZgvKKsGqWOXSqC3yBjH7QELecDNnMqn1Ya
         0WTvoygudERs5neAdqJRKrKJ3KD8zUvBGJbuPndfK5yCfIdPM1NcHMsp5W2F9HfJMg69
         ac4+EXNu9V4jPHUENiUbFpFdNrJisQhFzXyjsIPKkobIQ29l/721Orj4PnsWX1yNMsWI
         9O6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594111; x=1712198911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9X/k4Ur7ktRAsFVEZTgADbEiXncvofPy+APEnCk0Uuc=;
        b=s+fPg5EzhVWFvw5dLmJ3w8/8afQjeFlZ7rosNehtaPV34iV1FmkmuUNqYbNIZAHFQe
         YPpn8gRDP6iUeFl5SP6UTGcF9rqo7Pdj889j9bPEvSD9Xi9EbD6mjiF3rGpziBm52iUA
         cQYXuk78fA4sz4s4VoVfyFmpAxFR1LuwXBEYlVUNygWrFxYrJ0MgJ2nYRQ8+eJuDC6Dv
         iGpLC92r1yotGenRA9hRCJ8UbpBIQIgZcQUwv6fse2zsa6djzVNdW1JPs2GYmFPszP8N
         ebOCXFmO25Mm4XT2Ck2pmObAN3hGt7c9v2rDYAVY5ifaLhF0+QYqiJyLSDfson6/hj54
         ohoA==
X-Forwarded-Encrypted: i=1; AJvYcCX/Qya1aN8rKJX5yeUOMkXYAOQX52Xj4FtZ2gMY1vYzvss/bZl+kQl0fvAjxzVjjX7pfgLSd+5kL5dXElkJvftXzvsY
X-Gm-Message-State: AOJu0Yx1weOgQFOguXLEAECfhIUcrE9mmrf1yL0zu7TlQFrX3HV3Sz+A
	2/16ItX/AwRqkA9vhkhmfBLeWXvQ1sxm+k2AiGoI7h6aAExS6cfUgYqzF8y0OtbYRn8KvNdQEaq
	HDzD3dcSiQOZeRWrvGktXKw==
X-Google-Smtp-Source: AGHT+IHCBcXGdwnKOw373UKcOQTGGrOXXtILBB7knODDR6g2De9IJeAdRjNIMJCvIjU14tTQdEZAyXnNc8ki3rX1vA==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:260b:b0:dc8:27e6:cde1 with
 SMTP id dw11-20020a056902260b00b00dc827e6cde1mr124693ybb.5.1711594111169;
 Wed, 27 Mar 2024 19:48:31 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:48:27 +0000
In-Reply-To: <20240314232637.2538648-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-3-seanjc@google.com>
Message-ID: <diqzle63kr5w.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 02/18] KVM: sefltests: Add kvm_util_types.h to hold common
 types, e.g. vm_vaddr_t
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Move the base types unique to KVM selftests out of kvm_util.h and into a
> new header, kvm_util_types.h.  This will allow kvm_util_arch.h, i.e. core
> arch headers, to reference common types, e.g. vm_vaddr_t and vm_paddr_t.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 16 +--------------
>  .../selftests/kvm/include/kvm_util_types.h    | 20 +++++++++++++++++++
>  2 files changed, 21 insertions(+), 15 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/kvm_util_types.h
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 95baee5142a7..acdcddf78e3f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -21,28 +21,14 @@
>  #include <sys/ioctl.h>
>  
>  #include "kvm_util_arch.h"
> +#include "kvm_util_types.h"
>  #include "sparsebit.h"
>  
> -/*
> - * Provide a version of static_assert() that is guaranteed to have an optional
> - * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/assert.h)
> - * #undefs and #defines static_assert() as a direct alias to _Static_assert(),
> - * i.e. effectively makes the message mandatory.  Many KVM selftests #define
> - * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOURCE.  As
> - * a result, static_assert() behavior is non-deterministic and may or may not
> - * require a message depending on #include order.
> - */
> -#define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
> -#define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
> -
>  #define KVM_DEV_PATH "/dev/kvm"
>  #define KVM_MAX_VCPUS 512
>  
>  #define NSEC_PER_SEC 1000000000L
>  
> -typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
> -typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
> -
>  struct userspace_mem_region {
>  	struct kvm_userspace_memory_region2 region;
>  	struct sparsebit *unused_phy_pages;
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
> new file mode 100644
> index 000000000000..764491366eb9
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef SELFTEST_KVM_UTIL_TYPES_H
> +#define SELFTEST_KVM_UTIL_TYPES_H
> +
> +/*
> + * Provide a version of static_assert() that is guaranteed to have an optional
> + * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/assert.h)
> + * #undefs and #defines static_assert() as a direct alias to _Static_assert(),
> + * i.e. effectively makes the message mandatory.  Many KVM selftests #define
> + * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOURCE.  As
> + * a result, static_assert() behavior is non-deterministic and may or may not
> + * require a message depending on #include order.
> + */
> +#define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
> +#define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
> +
> +typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
> +typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
> +
> +#endif /* SELFTEST_KVM_UTIL_TYPES_H */
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

