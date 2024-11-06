Return-Path: <kvm+bounces-31002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B449BF344
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9C701C22213
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F8D204F77;
	Wed,  6 Nov 2024 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JscTBjRW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D33C18C006
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730910743; cv=none; b=epOsnypi0XfU7Go7/uqx1EIym4ILU7LFiL1yMQ/h88f4OxKI9iHG3q5aAEL5tz+VQKQpJ8au5YW57xNyA6m8jkC0/j7uAoHzJsRMV9BoYRu5I/QqRooHC97HWR0VnGCq9M/ebCld14VrVJOFla6bVde0hh0vKHHg0Ua0gbY53Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730910743; c=relaxed/simple;
	bh=nSd24sVQRoAp1t1XZEnlfr+xfgk2O456H2Wp8H2P1nw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uOUoaEh2aF9hUCCtP/8IdE8B/hofM7opzdCv2CCtAFvTxnqBfaqypnbgeft6O0VzkOOTbRPU5HhvwfQyrii59HrR6s1DyyKOXBN4uE5kNe1FlQRZ2J6WE1aFcB+pXoahi5hobfbk+nKanuVEkzLOBKyKqV5VvVJ7edrjQDyTl2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JscTBjRW; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea8a5e862eso579067b3.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 08:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730910741; x=1731515541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qbY6DKBNE1QQfrptJr4NxQ9zPHPnsHZbV4Pcue/bRDM=;
        b=JscTBjRWbsnkmZMNBYhHZxNS7LieviJgdLlZtDvtklsWpWF8waRK00EaIoiY44VroH
         51loxkKLEtcHrKDZrB+Gs1uPoKXaM1sZRf56a6HIAMQKt30taz/KGJ37DkjlBgtvQK9e
         eQR+UM9FUsjUrhoEoMCI9ruynh7LEIYltJbT4BsVYPeyB7G49klvH18y4ZOagZJCad63
         hK9ZHyiW7USXYwkgTZv6DYr424rRgSVzpau3O+yAFf+gTZV/92eqVh583+IDpyfdSqo4
         AtNCAL3mbMsPJR+8mS/pr3Ur90gRj5UiGhzKGLvxttTi+GFtczPKvT3cw7ytwOmIHljS
         yEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730910741; x=1731515541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qbY6DKBNE1QQfrptJr4NxQ9zPHPnsHZbV4Pcue/bRDM=;
        b=NG/dN+kyGUV/8jgQI7H+XL6jf6gi6l+K4valxx7OZWsP8n97WjoAsxvuKDJIsBRU7h
         G693GOEU6GGAQYP4DwHwj7c54KjZ8U10a2jU3TCYHuAuiTqUaDEszs+L8R0UlylElgLB
         cqz2/BwzX6bwDS8lKHpW0iF37DuJQSvshTD/HdMLbY1eAnKJQsAB9lkOxljD8t7IbG12
         oz2q3fHpH7Xjyzl/rgjZZYzy+VHZGa3T0OMrK6RUn+g1Wt62GIhIUORFb5vkWLbrfT7B
         5Nf1O+EdCuw3+LnPDN/MCai1EBmy3lfuajtwA7v8vckx5YSDJYXWimfbd8x7SbwBJAQP
         AfEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcy9TNxKLKZSjeSl8mhnoxTXDsp/bLMBsDzUBRDVFnvtmBmYRS6ajO5P27S1aTOnM7QqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjiWdHQRLB0PhOpKmSJePiDPIXZgZZZPgzCvb/N5b5JpTSppJ8
	+J+RwHJWZxP5rYF70o+mzLIHg+sMANGILkkzFYE6McCse6H3es6p/mXnXQd2wf+wkm5kBCjuzHY
	cfg==
X-Google-Smtp-Source: AGHT+IFRjqQNM953xMuFIWpGheosTFQ4blOhXMTFf4OB6HIR2lAkuX9eFWWNIVkf9x2I18xzmZhDojhoW+Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6305:b0:6ea:4b3a:6703 with SMTP id
 00721157ae682-6eabeee1708mr857197b3.5.1730910741352; Wed, 06 Nov 2024
 08:32:21 -0800 (PST)
Date: Wed, 6 Nov 2024 08:32:19 -0800
In-Reply-To: <00a94b5e31fba738b0ad7f35859d8e7b8dceada7.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <ZjLP8jLWGOWnNnau@google.com> <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
 <838cbb8b21fddf14665376360df4b858ec0e6eaf.camel@intel.com>
 <8e9f8613-7d3a-4628-9b77-b6ad226b0872@intel.com> <00a94b5e31fba738b0ad7f35859d8e7b8dceada7.camel@intel.com>
Message-ID: <ZyuaE9ye3J56foBf@google.com>
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 06, 2024, Rick P Edgecombe wrote:
> On Wed, 2024-11-06 at 09:45 +0800, Yang, Weijiang wrote:
> > > > Appreciated for your review and comments!
> > > It looks like this series is very close. Since this v10, there was some
> > > discussion on the FPU part that seemed settled:
> > > https://lore.kernel.org/lkml/1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com/
> > 
> > Hi, Rick,
> > I have an internal branch to hold a v11 candidate for this series, which
> > resolved Sean's comments
> > for this v10, waiting for someone to take over and continue the upstream work.
> > 
> > > 
> > > Then there was also some discussion on the synthetic MSR solution, which
> > > seemed
> > > prescriptive enough:
> > > https://lore.kernel.org/kvm/20240509075423.156858-1-weijiang.yang@intel.com/
> > > 
> > > Weijiang, had you started a v2 on the synthetic MSR series? Where did you
> > > get to
> > > on incorporating the other small v10 feedback?
> > 
> > Yes, Sean's review feedback for v1 is also included in my above v11 candidate.
> 
> Nice, sounds like another version (which could be the last) is basically ready
> to go. Please let me know if it gets stuck for lack of someone to take it over.

Or me, if Intel can't conjure up the resource.  I have spent way, way too much
time and effort on CET virtualization to let it die on the vine :-)

