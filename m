Return-Path: <kvm+bounces-21929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0691A93785D
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 15:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02C381C218A4
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 13:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5FB1411DF;
	Fri, 19 Jul 2024 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ny+7Hlct"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083584A28
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 13:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721395304; cv=none; b=GjL4TB4uqNr1kfPiAk0uKZTOrSjGngBpajt3S6uf2kM50or37Fe6qG3DoOkb7hmxVnVqnocMFrExmrIvwWYdX6OJoZcAv1Vd0iV5sgp9S1FxChDthhlqT47u1EJwLhG7s5jQKE1lsGR9xTr5f8et+smwvpGNHLNfl9+/azfAzek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721395304; c=relaxed/simple;
	bh=pBCELV1emGyTdHUUECzmmuBjT1BLgOKgPI0z0ymr6gk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DxqkIWpeBadEd41/vR1o9rrlM6CYy5jKdpsJ6OCDUYVQmUpBQSVlp7ZToQB+zrXbndF/iDuJL8FZdnrbq7lIYhWznY9PNVjAOLIjVyS98WX8/EF/YdIWCdvix6z4jk8DCbWsSau4IjbU7ROiKBfqyYtTL45RLsdwAcE20qH0BJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ny+7Hlct; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-664bc570740so31039617b3.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 06:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721395301; x=1722000101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BO/f/Vk8BV7M1BnnRk7syCEofzWPotH46dIzExxE5KM=;
        b=Ny+7HlctailgVYhXJ6vbaBr3dw0ZsczYJgvBPLuXzCgy/N/JQHa1dS/NRTkxR9g6Rq
         /lqFljwrXOFdY/jol4KWoNtSZYNhcBd8XnmtbMTWbetbU8MOqx6OfaZXdlfiBti/P+it
         622H62/n6jFWN711+uSS5yO2QJ3OFeJrM9GDvh18F9katwoqNNL4q+Iw/YrNNQtCuVut
         NENPHyvxo9B2ZZO2Ww7fMvSXmjQvijD9O35UB01qxIj7u/mMNIDX65eHWI+ZN4D2D9Fp
         8JEM+K/aetjgQVZE73VwNcLmU1Fms17suWKXMrXj+luCqRtUcjLTugNXfYbP8T2/yeXj
         R/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721395301; x=1722000101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BO/f/Vk8BV7M1BnnRk7syCEofzWPotH46dIzExxE5KM=;
        b=EqRI36CHALE1pycx4gnAg4eKWuhMPBBs3bTsd0awC9OmZsWF2eymI1VylRyJx5/gtz
         H0hHB9UILkKUlDp8jI8aJedNttTA9VMaltJD1mjVvreZmIbuorVXiJJnM1k2IMYcVm8M
         3CssQsIUVl1bMcFy8bxHDlzeSwavUzeOKWZTLg//1YMzRtEd4HiA9XJn+gH5W8uZKwNQ
         MVOBX89XGqDad8yLngcHEDPqTUAxhVkNlsTfxa/g1+lE64s/BqHA/l646CW2g/RbBC4y
         ntIB0zrPTkq/WTk8uXT00VLHVO/WKrxT3ztzq7akqDbfg8ac8cmul0qhiZp/sj2a3k+a
         Ztbw==
X-Forwarded-Encrypted: i=1; AJvYcCXJZqSVa+HxKPPiT2GNu8Dj3d/mu8puIQ9k0BO2Nl8dkkYMncy+SfyMZEiYL85nXNbnl3Y7/tIXDHcgwBZ7bNR0zEFX
X-Gm-Message-State: AOJu0YxwaA7TbS5nFPWaWuLmWkeIHStPz0nfYtgzWupk7p+fngT9AZl3
	pFoFzsIXmgSj35mcSkjZa+2JitdqP66w1UdwHitV2xjQxmhYW0xInWa43Xadf3VXeIPfh2F2aCo
	ajg==
X-Google-Smtp-Source: AGHT+IEPtqovB6+nL+dEpY3lKDt9cE/kxszu/7IvqhKdMhwuBfYDyqi39g8sSH2tXQipBPBpmTlSJHz4wXE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:188f:b0:dfd:da3f:ad1c with SMTP id
 3f1490d57ef6-e05ff517e74mr278214276.4.1721395301549; Fri, 19 Jul 2024
 06:21:41 -0700 (PDT)
Date: Fri, 19 Jul 2024 06:21:40 -0700
In-Reply-To: <20240719134446.440ad28c@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719134446.440ad28c@canb.auug.org.au>
Message-ID: <ZppoPjq1HX0xnR1s@google.com>
Subject: Re: linux-next: duplicate patches in the kvm-x86 tree
From: Sean Christopherson <seanjc@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 19, 2024, Stephen Rothwell wrote:
> Hi all,
> 
> The following commits are also in the kvm-fixes tree as different commits
> (but the same patches):
> 
>   2a2cc315c0ab ("KVM: x86: Introduce kvm_x86_call() to simplify static calls of kvm_x86_ops")
>   b528de209c85 ("KVM: x86/pmu: Add kvm_pmu_call() to simplify static calls of kvm_pmu_ops")

Resolved, thanks for the heads up!

