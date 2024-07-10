Return-Path: <kvm+bounces-21363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1268992DB82
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 00:05:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42C781C216B6
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 22:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADAF5143C65;
	Wed, 10 Jul 2024 22:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nhez7E8f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7139212F365
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 22:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720649100; cv=none; b=gnPEbBhQHC/lepZdxOpU46UjHOR8H4UicOGsw/JDYqJdIUTF2O8ethtYcUKB86A6Lr3s3rbI8fJo53XyKZvyWlTrsAKlIi01E5RAaFkE1ykdX5hMAPE4l7pfSoVaUUxt+HvOeFKXLRUwyPNTRPG+oe/+xR1oUU2boelFb5wEqGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720649100; c=relaxed/simple;
	bh=VoJ/gJl5xvnTdhEHVHw45a7iTQIUHdeoCoeJEKThHDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ABXIx9pqsu4l2BQnzb1uWlQPz96nHyFBqUWbD+NEXiaNs1GGH3pjc5FVpwxhjrafh5wQ1l2diF8gJeQ5qBh4+8qG4TqE2TB3VWYfyEp7AdlHdzVj0+kA0Gh6JOow0Ivjs6xuvaWTTIqokDB6OQJ1UktjIsGKOoX77LaW4j6pUEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nhez7E8f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720649098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4p2Yj6Wm6bNDeAQEfGI5P0AFWtl3OHuV5/lNYpxb6YA=;
	b=Nhez7E8fafIV3G6nafJpyMZYQB0kgzOEo8uFXQK7cI17PAv0PfWn7Idz5qXtH8BNnjoi4t
	yT6iVxej9+aoq5w3VZwn3AI/DBHPQRWgJY23p9y1pmLVhMRs7i2kju6HRmY52kZfVi5KDR
	z+k3WOOp4irXeqOZ/D6aoNN+d/u2gow=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-XI9SVmDAMqavh2fFdY3zaA-1; Wed, 10 Jul 2024 18:04:56 -0400
X-MC-Unique: XI9SVmDAMqavh2fFdY3zaA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-36787ba7ad4so228981f8f.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 15:04:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720649095; x=1721253895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4p2Yj6Wm6bNDeAQEfGI5P0AFWtl3OHuV5/lNYpxb6YA=;
        b=BUyBPXGWLqzOGbmvlGbWhG30xIlzja82lcShuMR6L3ywl/Cpotg8Etdh9ZFDen+lQz
         TaFgYEtHqpcAVHe4c4XxxMTobO9j4tMG0lm7rwZCu3ey/nhUEBZ3YZzwHiThx3RYKLYd
         qSaA+XOumhZb3aRiQ48gRrhB6Zho6UWkYlZwY4I/NpP95N8Np/7kHez3vKy4LiJi5+lC
         Rg81brDUkJn03tizAjCAiQIiJrbcTvXdZafW4+yaCm8dVI9YHewsnUydDwbBS0xgZJd6
         +Di5FVUx0hobLcU+zeH2tVUEXMCaibHzspzqmo87MLBWoVyMDy3kveuaFub2LchK9uuU
         X6pQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWniRaFWDTp/v4BfWLLyZZVQvRE50/zpZntRybrz4/SFr6kQp3K9rKRe2jT6cVuHt/cMfCN+qVCjNCx0ytjA7G/vCU
X-Gm-Message-State: AOJu0YwukY3+AuqNdyx+M2cvh1i0hYJMuvg0YchWovYCLVVrTm7zBHD4
	dU+H0+6Q1E6pkZBgj9Za2EauiH616FsrWg1vtp9zwJesmduspdxrZ2ZQIah+REaksnRcT/HM5WJ
	5ORsSyozuKeCrcWIkmf3TeSFwStVM5tGgQWhQeWO8knRvlHMNs5ys2NbifP8fOdQKdL1yLvgvIu
	/pkHhbz9RhxmwbZDbm0JojIZul
X-Received: by 2002:a5d:5f88:0:b0:367:2945:4093 with SMTP id ffacd0b85a97d-367cea9641amr5288869f8f.40.1720649095639;
        Wed, 10 Jul 2024 15:04:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4RsMhRx4b7K69gGzPS4i9eFbJL1CdwzkwON4Rx/q599P28tz2n1hwhqhx+Aw4ba05nmViVYYj3SyKU2p+3i4=
X-Received: by 2002:a5d:5f88:0:b0:367:2945:4093 with SMTP id
 ffacd0b85a97d-367cea9641amr5288861f8f.40.1720649095355; Wed, 10 Jul 2024
 15:04:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710174031.312055-1-pbonzini@redhat.com> <20240710174031.312055-3-pbonzini@redhat.com>
 <CAF7b7mogOgTs5FZMfuUDms2uHqy3_CNu7p=3TanLzHkem=EMyA@mail.gmail.com> <Zo8DjhQq3GOpmO5f@google.com>
In-Reply-To: <Zo8DjhQq3GOpmO5f@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Jul 2024 00:04:42 +0200
Message-ID: <CABgObfbfA6oGVcHwFH10YC7EEMw2A9W-L1aJjHAWGRajog6uwA@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to
 pre-populate guest memory
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, binbin.wu@linux.intel.com, xiaoyao.li@intel.com, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 11:56=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, Jul 10, 2024, Anish Moorthy wrote:
> > On Wed, Jul 10, 2024 at 10:41=E2=80=AFAM Paolo Bonzini <pbonzini@redhat=
.com> wrote:
> > >
> > > +       if (!PAGE_ALIGNED(range->gpa) ||
> > > +           !PAGE_ALIGNED(range->size) ||
> > > ...
> > > +               return -EINVAL;
> >
> > If 'gpa' and 'size' must be page-aligned anyways, doesn't it make
> > sense to just take a 'gfn' and 'num_pages'  and eliminate this error
> > condition?
>
> The downside is that taking gfn+num_pages prevents supporting sub-page pr=
e-faulting
> in the future.  I highly doubt that sub-page mappings will ever be a thin=
g in KVM,
> but two PAGE_ALIGNED() checks is super cheap, so it's soft of a "why not?=
" scenario.

With ARM having multiple page sizes, and not necessarily the same size
in host and guest, using a gfn argument is also unnecessarily
confusing.

Paolo


