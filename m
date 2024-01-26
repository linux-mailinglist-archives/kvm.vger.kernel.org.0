Return-Path: <kvm+bounces-7188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6018483E0F7
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:02:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7FF0B235D2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930E5208BA;
	Fri, 26 Jan 2024 18:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KySqJPcN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4302E2033A
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 18:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292111; cv=none; b=Ynj8dbo/961f8PEljZjJnljPni+Kz+7LMnZQgKz4QU5Aq9nBZkBScEe2NqWA8+i+jh4OhLS8BiTxByr3jYXjL+C4zx3X9jRHcjKg8yYyh1kd9qiWTUK6gWn5+7UNXZUJwsJHv7nMxjuFIXZfLED8nELe+Jak++d2u4MmNL6uHw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292111; c=relaxed/simple;
	bh=ILNAcCRYxFV2hBwDPjxHOp/jkyTMR71/MVIQgy9Ru1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XFMxhfS+hMXrvMUjQPO4dr5FCgfkls/1wc+CU0o3MDfSbEVJ4VitHIUpfmKdyvC81ybYrYyjHepwGz3F2e1ADfsAPctKWSYxRHSkZ5S7FcS3Kn6PfYRZFXpam0dkaqiZLxnETzVe3ourq+mZBfyPPdHLotMfncq5ids7YWifQvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KySqJPcN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706292106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h1idEZmiqZ0PAWapQhsolthHnuhF6TvOu+W3q8ZLhUs=;
	b=KySqJPcNXtCdLbNoC638InqsCoBOSwEnuCtnm7ruF//kn1f451pcakQPvT4UlkkrUgehvk
	nP6U8zmiItgw/q8M0QYyfzcpKHREK61uLqVZWwh2gqTyBnYR4usXDyZkj4f5K5dqH1gqQ5
	frlt3EYVO1J/TpjXi2bv2peWis8ndPI=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-YNr_mtCoPjW1rs_NKqfKHA-1; Fri, 26 Jan 2024 13:01:26 -0500
X-MC-Unique: YNr_mtCoPjW1rs_NKqfKHA-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6e0bcaceb20so523699a34.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 10:01:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706292078; x=1706896878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h1idEZmiqZ0PAWapQhsolthHnuhF6TvOu+W3q8ZLhUs=;
        b=Dhwcc3mMlwqDJO6KJ9XIKCrov3lJnoHVlVvvDtRdM0EGdMHMur9zpMY46dwh2i/d5K
         xZGPArkVZ9sP1OxNq/pfcDj/+x2Y3rNzEiQ54kaOhNvX9Bl9y9JrwNkcDcwdmP0hV7uU
         GU+GNMEnLU3WE1HaiAya/7Iu4wfxI2oD01qTYK2Jx1E14uUyy9qEMn7GRw6poF3cjbD2
         v5fcvwM/hABsfHTnS5XuNIh5y8I2Kwxy30KN9EJUAvaX43oksewcfZbmlwftAMhmNypp
         2vP76f5J+LBigUt2jfpFTe7x80419d/YTbqunNhTFVyg/GEpIUkMFgqwaE2qPbjz5wc6
         BnHg==
X-Gm-Message-State: AOJu0YyfDySQSo0xAlLnA5SMcxorI3kx6Lo8AiIV7+FhsRdbTUOcmB01
	G/tA14Cmx7iulQXM9cmlqBZCVDE4xmlFvZzGMbd4by2GgILtsl3yeNpH6/Q2wO0qPHP0H1sDpBt
	Sp7M2e6Z+Ycp2lXmgXkRlKU+p7pzcLQzD/V7In9bfVe87f1lYdo32GzbdcR2O7+H5tZSz4owF8f
	FicRxTc8T47uQ+HX4NYC9qJpGhUckcWiWe
X-Received: by 2002:a05:6359:321a:b0:175:b57e:7be1 with SMTP id rj26-20020a056359321a00b00175b57e7be1mr63145rwb.52.1706292078538;
        Fri, 26 Jan 2024 10:01:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/FiWt3RhBG2eZaUchUIE9MWYT+Vtp8D1XAoXVuiI7s21J/GldQs2rrbA47me4Q5yktW3RDvlHGE5BtjxRS6Q=
X-Received: by 2002:a05:6359:321a:b0:175:b57e:7be1 with SMTP id
 rj26-20020a056359321a00b00175b57e7be1mr63124rwb.52.1706292078152; Fri, 26 Jan
 2024 10:01:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231115090735.2404866-1-chenhuacai@loongson.cn>
In-Reply-To: <20231115090735.2404866-1-chenhuacai@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Jan 2024 19:01:06 +0100
Message-ID: <CABgObfYbv_rHto8eEWLB3srmCPj6Le7wDfG5XtYpUH17HBTcCw@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix build due to API changes
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 15, 2023 at 10:14=E2=80=AFAM Huacai Chen <chenhuacai@loongson.c=
n> wrote:
>
> Commit 8569992d64b8f750e34b7858eac ("KVM: Use gfn instead of hva for
> mmu_notifier_retry") replaces mmu_invalidate_retry_hva() usage with
> mmu_invalidate_retry_gfn() for X86, LoongArch also need similar changes
> to fix build.
>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>

Applied, thanks.

Paolo

> ---
>  arch/loongarch/kvm/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 80480df5f550..9463ebecd39b 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -627,7 +627,7 @@ static bool fault_supports_huge_mapping(struct kvm_me=
mory_slot *memslot,
>   *
>   * There are several ways to safely use this helper:
>   *
> - * - Check mmu_invalidate_retry_hva() after grabbing the mapping level, =
before
> + * - Check mmu_invalidate_retry_gfn() after grabbing the mapping level, =
before
>   *   consuming it.  In this case, mmu_lock doesn't need to be held durin=
g the
>   *   lookup, but it does need to be held while checking the MMU notifier=
.
>   *
> @@ -807,7 +807,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsign=
ed long gpa, bool write)
>
>         /* Check if an invalidation has taken place since we got pfn */
>         spin_lock(&kvm->mmu_lock);
> -       if (mmu_invalidate_retry_hva(kvm, mmu_seq, hva)) {
> +       if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
>                 /*
>                  * This can happen when mappings are changed asynchronous=
ly, but
>                  * also synchronously if a COW is triggered by
> --
> 2.39.3
>


