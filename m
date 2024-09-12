Return-Path: <kvm+bounces-26679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD9D9765E3
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24A602846D0
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BF919CC16;
	Thu, 12 Sep 2024 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DsDWue+6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E2618C90C
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 09:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726134076; cv=none; b=a5c6BgDtQx0rxcMIFiR7SMejO55lnY2CKBb//TvQlLYJNfOyTXzNVQzGbd0CjXjDL0sFI6pbqiknYlbPZGE9RQHbZEam/RHFPtHYvbDSHHJWK2SFDGuvXeDBIPVU4EGMC1NGlvgBCfSvV9tEjSPRI0PQkK//WIlP+qOs7n0SoCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726134076; c=relaxed/simple;
	bh=j4p7rekU9XpaxoYQxOygTZbro1GDTOZAkbJ5AtXBJiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNtD/Mfo4vuVPnKEXJEzCFd/Zz11jRKyX//8Y228fsPrkIbE5rs+SXUj4/HgzrnZJdQLFDKOC2fFy9gUKrzFjVjV5jRwVze9J/2fwmX2PWcnN3jYxsz/Zg+gtgkSxix/+721nebuaYplANV9oez9qLCyX/vK70/U7KMZ/YB/J+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DsDWue+6; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5365aa568ceso972697e87.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 02:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726134073; x=1726738873; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aiemgFzmdlVArSRtl/VBHqqgaU54TtFT6LBWQAz3Kr8=;
        b=DsDWue+6/1tXAablIqROh0kHi9x4kA/MclEZq4ced9AkzHcxKHnJe5d1iYSLylJSeO
         NcH4R6wgh1qDYMQP1WWsDjJ9MmFWCghXq9hpMc/8QlTq+WrmDiu3XQI5QXSJRBoo+UYs
         csel8rdu9bcE1suO+371l9kWHOMAYWeSj3XmIIl9oxaJUnaUQbFojxeREJ88AnYNdJVr
         f+ZgXFhiZaX1Dd09kOp8OTMH8QmJk5svpAsd4ofZt7KyQ4iaMAPS5S8Vhgpd+CX0jk8s
         jS2amX2vUzezPH2Pep2wP0gsbWiDXBqS7Ckw9vAlm+6V5KlEP3D6/o9RqN7J5HymQN9c
         An1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726134073; x=1726738873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiemgFzmdlVArSRtl/VBHqqgaU54TtFT6LBWQAz3Kr8=;
        b=Q5W0SeEN1sh4/23+9Cwo3joI2GQQD3lCDCOCbCAwEsggAFuCybRXAZ3d3MzozmOWEY
         5Q0Yj9gqHH9slHTRAw1Z0HIglTRalhH3vCntqSrhbT8123rkN3SRKazM/+ztdznr3h3A
         tz2JwX/TNoy0yFx6lJOP1064lnQZn9pVelsmdz9QwbyvWj/fjv5irAis01ZCAGyq8LfT
         demW5pZ6kufKgY80G9AUy45NmN1VPHH6KxY7Ps+RWFOwof5gLPKEb3cdz1MNphtg2bEa
         fa0Jh3jkZtcUc21jF6Fpdokh6+mRz5USr6vSIC3PoQI02tDBeet2p9R+aqQhi3lrG6Dd
         hIIA==
X-Forwarded-Encrypted: i=1; AJvYcCUcJh6yYN+wVjzXDdtriAHsCX1nmYdkC/AOVkzNrXmX0ZRYPSuTljXTEiER4boNpSMYgg8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkADjHnxhHesGlduwen7Y9c9chvjhEuJTxcVn3vQ8hS8Yhq2zU
	CQcRRbrIQ9T9hC80y+vOAPIe+6Aqqld7bix516g5i3Ilfh0Klqgc1agskIdu1LU=
X-Google-Smtp-Source: AGHT+IE8hrIDE8jMWqmlxIeW/6mf22/C3WP/B4LyK9EfIJcAxDLa0UZEL1XXRZvbqP4WfQWiTVCnKg==
X-Received: by 2002:a05:6512:31d3:b0:536:5509:8857 with SMTP id 2adb3069b0e04-53678fb7196mr1697881e87.21.1726134072038;
        Thu, 12 Sep 2024 02:41:12 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72757sm721848266b.103.2024.09.12.02.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 02:41:11 -0700 (PDT)
Date: Thu, 12 Sep 2024 11:41:10 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Subject: Re: [PATCH v2 04/13] KVM: selftests: Assert that vcpu_{g,s}et_reg()
 won't truncate
Message-ID: <20240912-75f992936cd9878d0e507498@orel>
References: <20240911204158.2034295-1-seanjc@google.com>
 <20240911204158.2034295-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911204158.2034295-5-seanjc@google.com>

On Wed, Sep 11, 2024 at 01:41:49PM GMT, Sean Christopherson wrote:
> Assert that the the register being read/written by vcpu_{g,s}et_reg() is
> no larger than a uint64_t, i.e. that a selftest isn't unintentionally
> truncating the value being read/written.
> 
> Ideally, the assert would be done at compile-time, but that would limit
> the checks to hardcoded accesses and/or require fancier compile-time
> assertion infrastructure to filter out dynamic usage.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 429a7f003fe3..80230e49e35f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -683,6 +683,8 @@ static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
>  	uint64_t val;
>  	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
>  
> +	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
> +
>  	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
>  	return val;
>  }
> @@ -690,6 +692,8 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val
>  {
>  	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
>  
> +	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
> +
>  	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
>  }
>  
> -- 
> 2.46.0.598.g6f2099f65c-goog
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Shouldn't patches 3 and 4 come before patch 2 in this series?

Thanks,
drew

