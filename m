Return-Path: <kvm+bounces-26676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A770976542
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:11:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D0411C2335C
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E513D193099;
	Thu, 12 Sep 2024 09:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="buJOqwK3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582711922EE
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726132294; cv=none; b=mYXhwoaxAiUR1xoSrHS/Loj2+Vq3xTGAXU9zTrCfpTuYG0ven4JNT5rmRQxuoZjt/IrMkWLnKeLmYI7REyozGxQ5cb3bzBAb9GJo90wPHuWnZM0w9GdJ3XTnhKJDNxZuuZgH9V3+/JcoDYEsOK+yMe9sfrY19b4Ikhs19/JHnQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726132294; c=relaxed/simple;
	bh=9rBEz/3jZQ2qE0fBtpr1iiAKAP97cuv1yvGYvb/WCo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0hnb5XmbqbvmQg00w85IMXaZTxRivi9hxm2jl/0AYYM1xcCEcY713PvvlCr03NUd0W+ntOg00hV9sXz6HHkvo6A4bFa8CiLVskU/kd6CdwyuLFlKZNnsoVJNwjsEaS6EZRZ1pU+5KzryCNbggmMHfy8Rf8rOeHn/97ZuXFcW08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=buJOqwK3; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c3c30e6649so730891a12.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 02:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726132291; x=1726737091; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KDYukj80mIHPYCgHSB2w3O30EP7PG7QCtWy9R/+4O+8=;
        b=buJOqwK3y3GvOuJZiesLN4brrpm4cqyijN2r48mC21RdyehpgzUkO7zdjOLdtbL2rs
         X4f/xrANVfOPiq1Sgxr4r5OT5mosoTbGIf0QHTsAo7zrz8jqDMw1+77smOmjT5smInpS
         qUPeRRyUyGfeHwlWNElrf8cpZLi7dPh0RT6CejQyFBs+tuJFjUZtYhKGLEzumVhP3hjO
         8KeP+zCj7JTs9eFZ6eKE7l9L2gR6LFOQMsxlKEnk578lSDI5J1GipIDs1mI25ZyEnIAD
         CHEYrItfWmK1TytNkO8AjLEQIlSZ8h1fTJNKEhkGgNDo7y7HCVKO3x/3ly9AzJvjLoRv
         J0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726132291; x=1726737091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDYukj80mIHPYCgHSB2w3O30EP7PG7QCtWy9R/+4O+8=;
        b=lg34MyFuYXc2Y8gLnZKz4xUCaMCMua4ilYvpuOkXaToYpBLxbihI9mlhiSfQ5nVTpW
         APc9EbrNjwxZeIOBzDmBFqrrR/YXX5mwe9OxJdIKqVEV4csm6JRA0sym7pNhKegnr8Xo
         p9IE5/WNFBrrEWnC2F/YqvNWfszeaMATUI50Q13UOYxETeGQCJX7aPwxVrUItTdGLzx2
         QS4mf+1fRWawgRvKg9gB2OvpBMyFgDJDs4pDATo9SLMJVrbduVphdlOWMUeUi7AP/4L6
         W5xHwJiQun14L9rNPlqEzcUF+3u1036bFlAQRkpApkSmDWsa9CjBmeEfZhg4t32Qlpzi
         v3Jg==
X-Forwarded-Encrypted: i=1; AJvYcCUVW3sSGtL7wJs3GDuBB7qmMccuukV9ZCnQTIhiLMTAh6I6fTHkoVVlKcU54821H5FgDh0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcN/NmmJkrjkDc6HZSierb/ZxE7PJlXEg1cGjQx8s1dEyhxpc1
	5H+r5ZRTuq8Bzj+OEqueIEEnjRl6uo2R5Eyvlx/RRfHIi3HAdnUOMpwKCPv1bBM=
X-Google-Smtp-Source: AGHT+IFYGstY7Ee7hZURlNK3JZABLF8M1RnLjnl2KXSy/Qm7bwNeqA+fGuOPSyrnOfiIz4Olnre2Gw==
X-Received: by 2002:a50:cdd4:0:b0:5c2:1f74:114f with SMTP id 4fb4d7f45d1cf-5c413e54913mr1194735a12.34.1726132289759;
        Thu, 12 Sep 2024 02:11:29 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd467desm6239500a12.40.2024.09.12.02.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 02:11:29 -0700 (PDT)
Date: Thu, 12 Sep 2024 11:11:28 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Subject: Re: [PATCH v2 02/13] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
Message-ID: <20240912-a3894135370bf3fe551ed018@orel>
References: <20240911204158.2034295-1-seanjc@google.com>
 <20240911204158.2034295-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911204158.2034295-3-seanjc@google.com>

On Wed, Sep 11, 2024 at 01:41:47PM GMT, Sean Christopherson wrote:
> Return a uint64_t from vcpu_get_reg() instead of having the caller provide
> a pointer to storage, as none of the KVM_GET_ONE_REG usage in KVM selftests

"none of the vcpu_get_reg() usage"

(There is KVM_GET_ONE_REG usage accessing larger registers, but those are
 done through __vcpu_get_reg(). See get-reg-list.c)

> accesses a register larger than 64 bits, and vcpu_set_reg() only accepts a
> 64-bit value.  If a use case comes along that needs to get a register that
> is larger than 64 bits, then a utility can be added to assert success and
> take a void pointer, but until then, forcing an out param yields ugly code
> and prevents feeding the output of vcpu_get_reg() into vcpu_set_reg().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/aarch64/aarch32_id_regs.c   | 10 +--
>  .../selftests/kvm/aarch64/debug-exceptions.c  |  4 +-
>  .../selftests/kvm/aarch64/hypercalls.c        |  6 +-
>  .../testing/selftests/kvm/aarch64/psci_test.c |  6 +-
>  .../selftests/kvm/aarch64/set_id_regs.c       | 18 ++---
>  .../kvm/aarch64/vpmu_counter_access.c         | 19 +++---
>  .../testing/selftests/kvm/include/kvm_util.h  |  6 +-
>  .../selftests/kvm/lib/aarch64/processor.c     |  8 +--
>  .../selftests/kvm/lib/riscv/processor.c       | 66 +++++++++----------
>  .../testing/selftests/kvm/riscv/arch_timer.c  |  2 +-
>  .../testing/selftests/kvm/riscv/ebreak_test.c |  2 +-
>  .../selftests/kvm/riscv/sbi_pmu_test.c        |  2 +-
>  tools/testing/selftests/kvm/s390x/resets.c    |  2 +-
>  tools/testing/selftests/kvm/steal_time.c      |  3 +-
>  14 files changed, 77 insertions(+), 77 deletions(-)
>

Other than the commit message not being quite right,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew

