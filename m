Return-Path: <kvm+bounces-25422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C02965409
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A1351F23CD2
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC89F4C98;
	Fri, 30 Aug 2024 00:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MDmnWAng"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12E82595
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 00:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724978092; cv=none; b=FhyU9xaELBBrT4b8lH+Pmukv7gDl6OKf7FS87eoAs1WK+rJ5H18nMN9iYYjRwF0nGj4ecovUrpw6rZXc80dJgZ61aviaWgEZVjAfN6JXH995gvAjDMcRhg7MvZL74wyr5Ob4JzVkC2G7DUi/jEPMcYGQo+d31s+Q0SFModaZ/Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724978092; c=relaxed/simple;
	bh=FqpnbV2f9pzqLhpgsHuN0fCsazH+X/gkpf6dLbPjAVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AHvBol5yYe5hJ9envIpQU6lmV8LCBCxALeMTOJiSFBk2OLcBdJnj4LEggiCZa8DZ/50w1gK3vaPMo21ocZkxskHiZimqzoFznMm3r40yCp3GpyZzgwRk2ruCyxoL+TBagL9KMKW+fZ2LVKn4RUzc7kkYYNXfXYKs6BU5uf2VP1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MDmnWAng; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6c130ffa0adso13046007b3.3
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 17:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724978089; x=1725582889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScuyZghAxUsq77xlIUmB3FT5rIh3r/8m9ZVZaLG04YU=;
        b=MDmnWAngL+nP73hzjjGKxpceEJdM8OWOTpTgpjSmyW0UaKUesZu3hB2zTJNwQmijRW
         RXyM860vWZyJ6YXD/fJrbR7SLtAd+XxwZMntcu2IKITfj5G1/cCBoVBJgRWPeCzeLRWV
         AYroBUfc2cTinfa3XrpjakCY2EF6JOU4jAIJCUWux4KFKTs3LN3jh4vnUfvgN7gJoHAq
         k7b7PeX0xpEy4zHd2WIMhkSv7m78+GptqGcsWHl971cA3yHTr14zWPZwUWIgF4eTc4nU
         XNiyq/A7gEnR7q5o5F1+79jS0GsBExfhhvYPFyKgd2ufZ+KyZeYMZYtCfkykO4KmSnbJ
         2a+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724978089; x=1725582889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScuyZghAxUsq77xlIUmB3FT5rIh3r/8m9ZVZaLG04YU=;
        b=PpfsUlKCjw73Gk3zHTQjUrxern7RTphibWhHsinRwLx/jmIQGa4NvyJlxtSbZFeyW5
         GRjfL9hfU7gwne0aNqKXyuSY+Ok4RQbGd40HC8CGUtcRwIKP9qeL7rJ9qOveUpXYSPYJ
         3K9p99Zc0FrGJgIdJgjJ7Y9qzT8+iRb0PlTNOUkb+Z0SH0ZyBjHx8OWHwia/pQMagjFm
         QIuRUeHd8iduzev9w+HB9Gl4Fn7Dc6yH9l60PWcG9OXy3idH6DzEzFS2S11cqNfkawrk
         Ari+bs+fifO6HbQdsPk4EXV3uO43sY0+ZVYFd31BWgxuyFR+RSlKNtTQ858FwTz6hrUN
         pbWw==
X-Forwarded-Encrypted: i=1; AJvYcCUJBIKyMtO2dRrs67aA6zNVGxkZ8ywpFhIUmNkyVs2ZdVoON/8UVsvIFTp0YKZohOCtnCY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm4qMqWS11OmE5D4s2ijS7jPhfuJImGBd4crmHQxBsNe2a/Qpp
	WC/lcvkOd0TpKmq/pmR9qZEBh2yJQwoSO8veX6NzE7IkfOMEXQ+kmERjwkzY4bFTOmabjDCDlqU
	eVUjR/AsqHEReGWy2dSJvHPvtkCFRUAOvq5zL
X-Google-Smtp-Source: AGHT+IEHfgQ7ITmpC9nLKgn2p9q5pKXn+MuPyh1yHF6iMxunaqm5ZCNB9dh715WRCvs589w6aHZcopQzVWBPqtznylA=
X-Received: by 2002:a05:690c:7409:b0:6ae:d19f:8b62 with SMTP id
 00721157ae682-6d40ff0ca84mr4280747b3.43.1724978089470; Thu, 29 Aug 2024
 17:34:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-9-jthoughton@google.com> <ZqKWxfqRoJzUWroG@google.com>
 <Zr_2Qhflx5xBhFCY@google.com>
In-Reply-To: <Zr_2Qhflx5xBhFCY@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 29 Aug 2024 17:34:13 -0700
Message-ID: <CADrL8HXnV8cmpytBSvGPvqvhjryWwT__MwWLbjzxX6hbd2UxFQ@mail.gmail.com>
Subject: Re: [PATCH v6 08/11] KVM: x86: Optimize kvm_{test_,}age_gfn a little bit
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 6:00=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jul 25, 2024, David Matlack wrote:
> > On 2024-07-24 01:10 AM, James Houghton wrote:
> > > Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the
> >
> > nit: Use () when referring to functions.
> >
> > > shadow MMU by, rather than checking if our memslot has rmaps, check i=
f
> > > there are any indirect_shadow_pages at all.
> >
> > What is optimized by checking indirect_shadow_pages instead of
> > have_rmaps and what's the benefit? Smells like a premature optimization=
.
>
> Checking indirect_shadow_pages avoids taking mmu_lock for write when KVM =
doesn't
> currently have shadow MMU pages, but did at some point in the past, where=
as
> kvm_memslots_have_rmaps() is sticky and will return true forever.

Thanks for the clear explanation.

> > > Also, for kvm_test_age_gfn, reorder the TDP MMU check to be first. If=
 we
> > > find that the range is young, we do not need to check the shadow MMU.
> >
> > This should be a separate commit since it's a logically distinct change
> > and no dependency on the other change in this commit (other than both
> > touch the same function).

Done.

> > Splitting the commits up will also make it easier to write more specifi=
c
> > short logs (instead of "optimize a little bit" :)
>
> +1.  Especially code movement and refactoring, e.g. factoring out
> tdp_mmu_clear_spte_bits_atomic() would ideally be in a standalone patch t=
hat's
> dead simple to review.

I have now split out the creation of tdp_mmu_clear_spte_bits_atomic()
into its own patch. Though I'm not entirely convinced splitting out
every refactor like that is always a good thing.

