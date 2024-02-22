Return-Path: <kvm+bounces-9346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE8585EECF
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 03:01:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60C4FB22294
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 02:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FAE14016;
	Thu, 22 Feb 2024 02:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WqpejVnj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525D612E4A
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 02:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708567256; cv=none; b=OSodxj6h1Pru+NAD4VQw4sLNHiRQ87oLjsBLW3VthW/DFsFAK+1jkqCUBidrk+5WZvWr7whLVpdygyuieg//QhfmfWbIEL3W6e+udRC/gie8s4TMq9X2cwTN8hPMZL2qQMblc5ARro1Ag/Iz4uvDQ2jjz3hkLRxoUr+/H1Pn1tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708567256; c=relaxed/simple;
	bh=pxnzBZPf3Y57moBuqwrZ+mXTr0TWWE42Za9WtFgQFVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T2p3XkW4q2ZzXTmF/t6zki2oZgZ99nYOuYF4qtnJrGyPdYpNY98VP+OTpcrZGm+1JPF4SrgTBVxefy31UTBqcjyUKLPRTRfz7F4N89S4UJx/Yto2oamqAEFZ/MEyLK4SHkqxUWgCiiuztreQl4coB1G0y4LGOwDuRoEZK5XbdAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WqpejVnj; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2184133da88so4087763fac.0
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 18:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708567254; x=1709172054; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4m7uuY2o7dfFqKZ7pBGGjpT/6w9LnqMmhZoknTrW1TA=;
        b=WqpejVnj3Vy3wh4wevlEDnbBLNBmcQHx8TH+uKHoi9nJORGOekUy6jss2+eC+GpwCN
         Wst1/rFU4h7DwTuHmONWH6mE8E1BPVCOOz2Qeaiq/YPFQ7M8r0R4Cm3TppERo3wsdZB2
         m9pSkbo5rfK4PDW0HWR4BSRA283BJ0KjYp8/Fa8pBNMCigqCk5hlQGs7ivEOGALb0Mii
         ulBUpPp47KOXrW/X7MhcV5ogK0FJhr23HuyOCxiLiPUc6uji6tdl0+YbF5x9u7RSPCKo
         cJsda/BHiJR0hmogIxHB0p15iPRDfviJQWJ35NHWPFVP6z9YzN5M118ClzOSGR+MZ3eI
         o8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708567254; x=1709172054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4m7uuY2o7dfFqKZ7pBGGjpT/6w9LnqMmhZoknTrW1TA=;
        b=JEPD6G5aVkvxZJ+pK4D7dS3U+0FEhcb6L88IUD+tky7YxAHLDDqaiRHOYb5FHlEc4g
         lXJIg4DMnWCnS5d1YmhH/hu+ThKrb3ES3p263mux8UVcl80VJFbpOquJ3KW+XB38j8Vg
         m8aLydCK/E3i6QH1yDi3SWF2cSTgTQOm5FbQv5tyDDiDzz/0CSwRoupHq/q+sz7znpFW
         TIH2aUe0bNHCJbGMbjT92qgHBQDncj2OrVxpCMQd0D+h1re66/eAZqA2RTX/skNizTac
         RQlcznRpNnDYkpF1ASGATjJC3PbwrEtIN/ZOoYr42r2AbmE+PreD+XGr/sJKxpmzkbCU
         as3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWD4/DYfRY5rExNEVY4gNfCmcO//EfWuzhkl5aDjbBvttfPNHsW3LfM6KTG8uNgDMNTO1MqW7aQxT+1C1XEK7oTDMWo
X-Gm-Message-State: AOJu0Yz4IK9p0M/3FAUAYkL4D/qU2kqrJizwpt9EELFFnBU7fPBulIm6
	OWPCjy+FuyDNhTJY/CdpDfnRfb/wXm5+I9pSvMahxOMsDrQ9vauZr2KqGVu++yPde5aXNj8uB3t
	rh/HCNBgcDEM0/o3tI84NIQLwFFm9Sf2jpv2P
X-Google-Smtp-Source: AGHT+IH/FIELy+n3Sf+UZaPWve8VJAkQePjUC3htDy2kjRr14jCTuZA+Og7M07ULj4H96g4bHLkCQqwcbEyvbqlRq00=
X-Received: by 2002:a05:6870:242a:b0:21f:67a:198 with SMTP id
 n42-20020a056870242a00b0021f067a0198mr8690167oap.56.1708567254248; Wed, 21
 Feb 2024 18:00:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com> <20240221195125.102479-2-shivam.kumar1@nutanix.com>
In-Reply-To: <20240221195125.102479-2-shivam.kumar1@nutanix.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 21 Feb 2024 18:00:16 -0800
Message-ID: <CAF7b7mqHWFnZbN5CHvggYYOZepcu9sVzUgNFwi89bLNxgnP_WQ@mail.gmail.com>
Subject: Re: [PATCH v10 1/3] KVM: Implement dirty quota-based throttling of vcpus
To: Shivam Kumar <shivam.kumar1@nutanix.com>
Cc: maz@kernel.org, pbonzini@redhat.com, seanjc@google.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, aravind.retnakaran@nutanix.com, 
	carl.waldspurger@nutanix.com, david.vrabel@nutanix.com, david@redhat.com, 
	will@kernel.org, kvm@vger.kernel.org, 
	Shaju Abraham <shaju.abraham@nutanix.com>, Manish Mishra <manish.mishra@nutanix.com>, 
	Anurag Madnawat <anurag.madnawat@nutanix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I just saw this on the mailing list and had a couple minor thoughts,
apologies if I'm contradicting any of the feedback you've received on
previous versions

On Wed, Feb 21, 2024 at 12:01=E2=80=AFPM Shivam Kumar <shivam.kumar1@nutani=
x.com> wrote:
>
> Define dirty_quota_bytes variable to track and throttle memory
> dirtying for every vcpu. This variable stores the number of bytes the
> vcpu is allowed to dirty. To dirty more, the vcpu needs to request
> more quota by exiting to userspace.
>
> Implement update_dirty_quota function which

Tiny nit, but can we just rename this to "reduce_dirty_quota"? It's
easy to see what an "update" is, but might as well make it even
clearer.

> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes);
> +#else
> +static inline void update_dirty_quota(struct kvm *kvm, unsigned long pag=
e_size_bytes)
> +{
> +}
> +#endif

Is there a reason to #ifdef like this instead of just having a single
definition and doing

> void update_dirty_quota(,,,) {
>     if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_QUOTA)) return;
>     // actual body here
> }

in the body? I figure the compiler elides the no-op call, though I've
never bothered to check...

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 10bfc88a69f7..9a1e67187735 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3626,6 +3626,19 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, un=
signed long len)
>  }
>  EXPORT_SYMBOL_GPL(kvm_clear_guest);
>
> +void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes)
> +{
> +       struct kvm_vcpu *vcpu =3D kvm_get_running_vcpu();

Can we just make update_dirty_quota() take a kvm_vcpu* instead of a
kvm* as its first parameter? Since the quota is per-vcpu, that seems
to make sense, and most of the callers of this function look like

> update_dirty_quota(vcpu->kvm, some_size_here);

anyways. The only one that's not is the addition in mark_page_dirty()

>  void mark_page_dirty_in_slot(struct kvm *kvm,
>                              const struct kvm_memory_slot *memslot,
>                              gfn_t gfn)
> @@ -3656,6 +3669,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
>         struct kvm_memory_slot *memslot;
>
>         memslot =3D gfn_to_memslot(kvm, gfn);
> +       update_dirty_quota(kvm, PAGE_SIZE);
>         mark_page_dirty_in_slot(kvm, memslot, gfn);
>  }

Is mark_page_dirty() allowed to be used outside of a vCPU context? The
lack of a vcpu* makes me think it is- I assume we don't want to charge
vCPUs for accesses they're not making.

Unfortunately we do seem to use it *in* vCPU contexts (see
kvm_update_stolen_time() on arm64?), although not on x86 AFAICT.

