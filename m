Return-Path: <kvm+bounces-7513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4EC843260
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:00:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EF451F26F34
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630C3E544;
	Wed, 31 Jan 2024 00:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VUfHScXT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AADCA62
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 00:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706662779; cv=none; b=o8i10bvjKcQN8AvorDjRDGYxB3Q3p9Cm58IQ1Q8yUOuhiuYuRljeryIXfnmUHQAukDqkRWGfb1YaN8TNwYjnOaT9/0kr5LFzcfbiP16rbKHQS6M1DKHUHpmwldCHojbab2e/p/VYoizRxKWcJE9PvY47PbjjK27Omfm2v2SXSJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706662779; c=relaxed/simple;
	bh=a3e/knvwUFk/+6p5cl7jRlVgDjdA27E0WtmF3pWVYY4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iQMJDYqoRFhif8Nc/C63EyzQjUZL2DTd48dbMZJpISJ9xShv20xp41fI2Ob6HnqzJFWMVC4gH1xBr8MaymH61fx1VKwHKR5hq7Ju9cQ9VpveFDbd10kDtaB4zBCinOX9o48rkZKYKJhi5yqGXwCMWRBOjYZrASRb5Cu+T2DEy1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VUfHScXT; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf216080f5so8225871276.1
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 16:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706662777; x=1707267577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=90q1CdG4fldsEQKSI5ABvCuyjkkZoVa1ihGQCUX71GE=;
        b=VUfHScXT3+I0J12CRw46xSJD004xfPga3yr91FA3yXgQ/LPMniW6CvjVqG6Lw3QPo7
         6a3ED77HNLVgnOBQA2rv2VjPEuyYM/SAkZxHF5y5TKbrAwICpFYKMomHvWM+NnHL2/bE
         It8wb1monj9TviHsJFB/MXn/OQb2hroqsdnhaI8J5u+PaHtw3JS/JVLVxJ1lwYuOJ6uh
         94PA9/IscSa4r0s3ZIdq5LsjGIFybx7VdO4LpKIl8RdNeUpdJkx/ihFrGBhG9VXu2WhN
         UhONZfHn11pychJPEQaTESAjEm2TyaB0EL1tj/649lI3aeonW5xDZstxtmWIToezwcwz
         WNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706662777; x=1707267577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=90q1CdG4fldsEQKSI5ABvCuyjkkZoVa1ihGQCUX71GE=;
        b=QUOdDL6DiuTgoU1e7IVdn6ZieJJ0tb5EiH/o09bGqSTqvPDlrHesXtP7aZIc/KAa4W
         wouegE7Dl+fDsNO4MH4G4HsB9rRPz5PzUHUl8CDwe4P3azvQW2FCM2UWJVj9z3Hu2yTS
         l77Eim+Ktu8uQkhtovUH/+3VXGboAfFz48O6r2Q9mx4Jk+ZPfThLGf2u0XBKHXt1O7Ji
         mvdGBCIuDyBNkMxn+B7g5ZoLJ9dRW+6fm/h5HQps9MA6Qj/Q68OevQSV/CLK6DgGate1
         qqpcphz2O2z54+jp9EuLk7r40WysIjBSbEBss3uUX+zxYmPL4aRk4WW/zDTaaK3r5rxR
         5gAw==
X-Gm-Message-State: AOJu0YziToUKVMKiwKBggc7t9sRdcCo2/ETUt24H0Kv3BVJe1ypp6gUN
	apIz1NxR/QNEbRGCf+hDpTvkzcn1LCbDBUbBYWzW4AHxjEt55sJSVtBXf9uKufAxtMH7WlONjcH
	Yqg==
X-Google-Smtp-Source: AGHT+IHhehnaZ+PJDYlxfoOUSUPsYKa2to+EQTN7X63j1zwisjsEvbZ6WBMrgf0oBHzbx414Rt/VF5JY9Sk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2687:b0:dc6:2054:fc89 with SMTP id
 dx7-20020a056902268700b00dc62054fc89mr66813ybb.0.1706662777130; Tue, 30 Jan
 2024 16:59:37 -0800 (PST)
Date: Tue, 30 Jan 2024 16:59:17 -0800
In-Reply-To: <20231030141728.1406118-1-nik.borisov@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231030141728.1406118-1-nik.borisov@suse.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <170629109916.3097852.3849458152684678421.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: User mutex guards to eliminate __kvm_x86_vendor_init()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Nikolay Borisov <nik.borisov@suse.com>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 30 Oct 2023 16:17:28 +0200, Nikolay Borisov wrote:
> Current separation between (__){0,1}kvm_x86_vendor_init() is superfluos as
> the the underscore version doesn't have any other callers.
> 
> Instead, use the newly added cleanup infrastructure to ensure that
> kvm_x86_vendor_init() holds the vendor_module_lock throughout its
> exectuion and that in case of error in the middle it's released. No
> functional changes.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Use mutex guards to eliminate __kvm_x86_vendor_init()
      https://github.com/kvm-x86/linux/commit/955997e88017

--
https://github.com/kvm-x86/linux/tree/next

