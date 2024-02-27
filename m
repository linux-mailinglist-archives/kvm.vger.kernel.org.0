Return-Path: <kvm+bounces-10109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CB8869E45
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3510D1C21C12
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726654EB46;
	Tue, 27 Feb 2024 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tQZfyJUY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525A14E1CB
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 17:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709056167; cv=none; b=F6gJiDujZ/VXso6Fgrl7oI5NFHyQsY1cq6v4GbiQX6kR6UtZ/NevGrFaKrwjI6mGp7Yn1EA31Hl+n9bDsl8yRWHchhrZA9a2hoL2IO0cWlEAJyRUeGG6h05Dbd/ru1qk67Jv89H1TB1DJ3NQPxS1LwZ4bQPx+RVCTquBCrgagFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709056167; c=relaxed/simple;
	bh=6+V6OSADcX/vEjE+xgKzWwNNKrKAesyUgRAe5v37S8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tTaphKRd2e8T+/jUp89I3sHNwSalqjyx3VrBhTl2M+eM7YwpWd2w+bkXdq7lBy6h+ns7/V5Bwwb8t6vLjSHyXBiB6UiFWDDtU6w3ymTJ5y40JH/c1L6moTwQo2KRhnny9cu7ol0ErhuuDe0/cLp0Ac1cKR5TkLmE9ddHujGzW10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tQZfyJUY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e44fd078bdso3298570b3a.2
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 09:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709056166; x=1709660966; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TrybOGpA3KrE+weUQifOFjRx5HANss1evz1Ds6moCuA=;
        b=tQZfyJUYXdG9adGsfMnv4C8dVTtUyYmmNRqLgPDkuCubr/byEOvoUeO4zmA4+4WGwD
         cY5RaP5L+RsHspnVFugCQx4T7OYTGYlYIJC822servyH3clu43j6wM/u4BAYdI9nXu8P
         jR/SGm7tIMWFzmm96qZfMoiLTmWoBGQXS4rufyFXL/q9GbjkF8nO6vclKSiZTt92MAy0
         MQDI/3L2dvwj6puxgXTTV6AwfQlZBSoxm003MVSlC7CbM1J7NMnwE0DpjjI5Ivg5pJIt
         j6Fw1E5hX1TcPshD+783OZUs4dH6eLcvhndqXJBmD75eTYBC5HVu9RtJydEkdfcT4aY5
         evKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709056166; x=1709660966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TrybOGpA3KrE+weUQifOFjRx5HANss1evz1Ds6moCuA=;
        b=HNiR4XKB5+UnFXoUjBouiJiRAPoh8ZxpGXzh2erF8nDvi5KMIUumUjU1J6P1oOahUR
         NMd/N5rHFWjYAal8LHp2CDVyM0hvL7uK8yxUX44/8t/5jZaaR5utGrcK9UIBRJzfiQUb
         xnSrysoaltwD6XOrm3HlXfnfStg6ybl5o2TdOr4RsO5MTaW7tCzv3RbPHM8PGJjNb7rL
         GBeSxvWpJEpiH+PVRQBn91ikMDXpYBVVHm+fwV0EJgXMTaIpXMBUm+RX2oBKwKFsY07R
         rj5PsOaF/+6uzN7FEoXSC5DtbNa7UndIf+EKWMfdcoaoVUp/6aHqCD1qUTQt3zVGZ34C
         W+aA==
X-Forwarded-Encrypted: i=1; AJvYcCWWS4gkChZ145iHY39pqRAbzWn62v3mnwvDiYeYaj/PTBTWA1sRZY5vmfadn2w7lB6sVRLChgRBEz1LKCYOwV3elrjK
X-Gm-Message-State: AOJu0Yyqf76dOefyvDKo3TPuEmM4jmCeopR/7ahVUR90rjBLiMc+c+Vk
	EDO9qg5sxahXw2n29KIls+q21Izdj71GkfMQ8NK0pd/IrznS4XKR0tu55uB0Epf1XSDT4c4fxTS
	YFg==
X-Google-Smtp-Source: AGHT+IEmY3v+Iz9HPMVJv3+02pq8QcN82tX4wn6YwqxRnJ7X8vRVimOUt1XbUH1ndPffcj7NIJaQ6+wvSeg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d96:b0:6e5:3e08:cbeb with SMTP id
 fb22-20020a056a002d9600b006e53e08cbebmr233643pfb.2.1709056165746; Tue, 27 Feb
 2024 09:49:25 -0800 (PST)
Date: Tue, 27 Feb 2024 09:49:24 -0800
In-Reply-To: <Zd1cDyyx65J1IVK1@archie.me>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240226190344.787149-1-pbonzini@redhat.com> <Zd1cDyyx65J1IVK1@archie.me>
Message-ID: <Zd4gpBsmTdXEZkWS@google.com>
Subject: Re: [PATCH v3 00/15] KVM: SEV: allow customizing VMSA features
From: Sean Christopherson <seanjc@google.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.roth@amd.com, aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, Bagas Sanjaya wrote:
> On Mon, Feb 26, 2024 at 02:03:29PM -0500, Paolo Bonzini wrote:
> > v2->v3:
> > - use u64_to_user_addr()
> > - Compile sev.c if and only if CONFIG_KVM_AMD_SEV=y
> > - remove double signoffs
> > - rebase on top of kvm-x86/next
> 
> I can't apply this series on top of current kvm-x86/next. On what exact
> commit the series is based on?

Note that kvm-x86/next is my tree at https://github.com/kvm-x86/linux/tree/next.
Are you pulling that, or are you based off kvm/next (Paolo's tree at
git://git.kernel.org/pub/scm/virt/kvm/kvm.git)?

Because this series applies for me on all of these tags from kvm-x86.

  kvm-x86-next-2024.02.22
  kvm-x86-next-2024.02.23
  kvm-x86-next-2024.02.26
  kvm-x86-next-2024.02.26-2

