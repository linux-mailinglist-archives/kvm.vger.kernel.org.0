Return-Path: <kvm+bounces-40284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2ACBA55A1C
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 224261899398
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 22:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A8E27D769;
	Thu,  6 Mar 2025 22:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x32PhdbC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB98420409E
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 22:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301171; cv=none; b=sWUZtX2sUuPa3VjpDXtIAUAQH9fKWv9dAcY93o4SWosHqf5QiYp0WzRit3e41SDd5pRvpaGjOYbxF+6cmFlmgIWnKAkQ9imfXWW05OW1J5q1ZCrHzeycTIJR/NKglN2O/tw2N0z4pjttjlxPpt0B0pbW+BNa4KxbXyc5RLDuuMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301171; c=relaxed/simple;
	bh=YVX4GT+ZzmgfK5JX56yR/tOvPTdkgsfh+1AFyQ6I5S0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=OOcwv0Cmgaae1tL5JH1doDQV6A9GCkXMIRi9Tw0rmZzj83zI+WkfY/UfO0tLoxF+yfiB46HkjNsRCFVjtkv04vrnLmTyrBH/87wNkS2JzOSB3TSYoZhbYYMlhnk1qOkxJ7+XLoLPP4LSzVvsbipMTBODcEyOEhA5EiBjVZpuI+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x32PhdbC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22379af38e0so18610295ad.2
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 14:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741301169; x=1741905969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y0NsttGtPOa6aPjdJtUAKVOWBQ7pVkWFh+ciuZTdfp0=;
        b=x32PhdbC9imOVlr8/rAuWnoEWzDtCgoENXXRCHAVfhuMcGRm95IqgFfb8y03TVkNHl
         qutyj3HjaJfAZAVetKkYkpFwQsfSG4qPN7L5aWjDch/a28/SZeVg1OCOXkTE5xsTNUih
         L0PocoD67dY7xy/aPVH2DjpAIQXhZLTorAS7P65soAiv+rTl0gbVH+6oPPXszhsNsuMN
         TEJb9aayUsTQmjfPYDAi9L6PeXn2rD4DRTZvwmXQam8kz0QbWWD3cYaiaWfUB6ylEmqv
         Dq5CuFnDDmoZD4XHzc8DHhgEjJOwhMfk5hNz3AOqMQCgkH+rWywLxndtg7xYtKOTgWUx
         jmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741301169; x=1741905969;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0NsttGtPOa6aPjdJtUAKVOWBQ7pVkWFh+ciuZTdfp0=;
        b=sVcSI5SZ+02DEhFXccYpoFVXRaQoDPbbv4VotYpGHnDhLhR9H0qk0whFFRxa+y59IX
         +tDVlbrPIFgZWz99K8DpIrayDAJ3chAjYrRqEfp9t8GH5hqltCTwngtJfiX8S0agPUCS
         vuA3e3icukl47L6YEqULawdE26mFmIjzTEBA1ENlmQaHnTm1zofKA28UJWTDUk5nEW4O
         tOGKiL9PgYuWDsXmdmXXZWFwG1L0YvzXwzcWZRIbpTJ8P4zkzF+X0ndSR/gge4XHVfnY
         Q+XJlzhoe7d/nD27ISGgRMl9ZdWoQ5Lw9b6cu3K1Lc2MFjuueIspWeMj6fLb6OrHBiOt
         U0zA==
X-Gm-Message-State: AOJu0YxrC2F9rXpVXOBlv1wafF9VT2J5QuawdMWZLHhcbNZNRv+4hTaw
	k9Qn9Xz6P0LdN+Hr2JWwYAssaSyKGrLZGMVxmW2TGXIRmwi5uRMVMI/Uy9WJ9MJDj5Om9KXHILp
	07E5C4nLB2K60SeqdgIlYcQ==
X-Google-Smtp-Source: AGHT+IFemCZqo/G29BZRvL9EujlnBiad8J9v1NkFh754+RwKgvTtlkq1l41H+ZyGu1lpLJvNdp5teFxIgVrsU9Dk8w==
X-Received: from pfbeb21.prod.google.com ([2002:a05:6a00:4c95:b0:736:3cd5:ba3f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2450:b0:1f3:3493:b64a with SMTP id adf61e73a8af0-1f544b163b9mr2425567637.21.1741301169176;
 Thu, 06 Mar 2025 14:46:09 -0800 (PST)
Date: Thu, 06 Mar 2025 22:46:07 +0000
In-Reply-To: <20250303171013.3548775-4-tabba@google.com> (message from Fuad
 Tabba on Mon,  3 Mar 2025 17:10:07 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzfrjpu6a8.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Add support for mmap() and fault() for guest_memfd backed memory
> in the host for VMs that support in-place conversion between
> shared and private. To that end, this patch adds the ability to
> check whether the VM type supports in-place conversion, and only
> allows mapping its memory if that's the case.
>
> Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> indicates that the VM supports shared memory in guest_memfd, or
> that the host can create VMs that support shared memory.
> Supporting shared memory implies that memory can be mapped when
> shared with the host.
>
> This is controlled by the KVM_GMEM_SHARED_MEM configuration
> option.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h |  11 ++++
>  include/uapi/linux/kvm.h |   1 +
>  virt/kvm/guest_memfd.c   | 105 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |   4 ++
>  4 files changed, 121 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7788e3625f6d..2d025b8ee20e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  }
>  #endif
>  
> +/*
> + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> + * private memory is enabled and it supports in-place shared/private conversion.
> + */
> +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)

Is this a copypasta error? I'm wondering if this should be
!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM).

Also, would you consider defining a __weak function to be overridden by
different architectures, or would weak symbols not be inline-able?

> +static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +
>
> <snip>

