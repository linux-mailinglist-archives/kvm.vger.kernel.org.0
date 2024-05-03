Return-Path: <kvm+bounces-16544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5D38BB5C3
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64C1C2842ED
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EDB54BD8;
	Fri,  3 May 2024 21:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xq67X2Km"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839FB2AEEE
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 21:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714772003; cv=none; b=iu261F7pbwRYg12GRHQrcb3efpVQFjTHMYjiQ1fDIiIgBkaEHSNDnuXeJDHrCMveoLi2kDiYG3o1aLjIr8SWeqtoV7f1SoNMEZQKl22ENfbfohgkZ1VkG/wwA3aQo76QYuHMbK0I0qzrCYwrRcZ9H3wfYlcHiJ+Gtz7em4SNqtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714772003; c=relaxed/simple;
	bh=WqWc8suVd1Df3ueM1A2CgaqKlvPzR3CdLdrTJnLXcxA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=FAvtovpFT5/bn8vjmIFXij8BLSYjghSRK5GsXRE9zVyctwhpbrtAfDr/qJvY0KDPIzeQuCMPEOWNpydoMuvw06g5EXYOuJS5m/DCAiAvauEvXOVrXBSpek+FN9+Kv6msd/Rb+PE2YprRaJQdo3K2KsYmJQ5BgfnclLpioGhUGoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xq67X2Km; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ec3e871624so1188595ad.2
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 14:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714772002; x=1715376802; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0RoYswLMrwyNTK07fZtKkAYuz7VD/335YhXH33cGgm4=;
        b=Xq67X2KmX/1kXyfF7/Kvfp5fiRihsehhRfHnozQVI5u8wwBDjg0/fxZDLe81wuekwA
         jtIAeeJvzXqGGzUJdci14ztgOhM5Nf3bvQq/o/52iNuSQTNjDGGjzm9s9hHLUaMkofIM
         27Qu4XjKGBewCR3J2KrQ4OWzVQbRukO2eOC/0sv4mHYSSmbIB8w09IoyWIL/twyeSQAB
         75pps2FXk0pWYflkakQD++BF+FamRnPWkrPodNl4i9fR5MNfmI5uqnVJTEoiWdA5aSyv
         DNinGwytC+mAUk+Z456/wJf7dk5kYhRdIwmO7b/hRWvuRWNhj2VLoNwUST9IDn2pGGDd
         bOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714772002; x=1715376802;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0RoYswLMrwyNTK07fZtKkAYuz7VD/335YhXH33cGgm4=;
        b=Q/Bbuh5efiLFRmlRO9wQBfuKs9/VvYaRsL49u7u8zhb7sAWnG++k3XzGaU1+i4HxWT
         miaKUJlZ3PCXXodvZSKRrslod5QCq4UJjRX0VwAx6Ok+HeJDfNB+9wUEOHQE2xUr9eMJ
         pWLjzUzq3ulBJmpVSkwpgIZp3iKbiIeUcZQE4uR88J8JoZd/yAv5PV8CQZGKE91lgZ8e
         UFvh71Ke99K2rtrBiXry1rAMxjCT6wXyn2p2q621y3yAdvP8sOFz5a/t0NXmUeCM7Gh1
         gMcfQ4rMY3o1n7qThCzqJiFURHUU2Q6AqP7NLs8MzGfYHpV/HmK34uUgv5nusRc0HMh6
         zUXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUH4axjrdNcnmePs6JqgU4qXIyNiZM1IwY5iAl+Pixo2nqwGXP8Xy3fIs35hruzVeBD5hUrv5OhB0m6BMuKcnPfhKNr
X-Gm-Message-State: AOJu0YwmkLeamj/YE1skidnnEXGGpQJmj8qOEDlR5uGWlii4nhxZ7o91
	x4E6lWEq3yDVvA2msnT4YoAzkRAiLGKaYM5/iL9sDFRflYHcKgG9bbL1GV46KGKz3q157FHSrU3
	GOA==
X-Google-Smtp-Source: AGHT+IFhaiHPssHnlXzdxwO6av6mBuLGwFQjQOUGMHO4ZCfgub0Pc/6hTx7C18hdUNKrU+GMoA0xj5I/V6A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:124c:b0:1eb:826:a241 with SMTP id
 u12-20020a170903124c00b001eb0826a241mr9750plh.11.1714772001723; Fri, 03 May
 2024 14:33:21 -0700 (PDT)
Date: Fri,  3 May 2024 14:32:12 -0700
In-Reply-To: <20240404232651.1645176-1-venkateshs@chromium.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404232651.1645176-1-venkateshs@chromium.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <171466127070.768556.12609702796312030081.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Remove kvm_make_all_cpus_request_except
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="utf-8"

On Thu, 04 Apr 2024 23:26:51 +0000, Venkatesh Srinivas wrote:
> except argument was not used.

Applied to kvm-x86 generic, with a much more verbose change.  Thanks!

[1/1] KVM: Remove kvm_make_all_cpus_request_except
      https://github.com/kvm-x86/linux/commit/82e9c84d8712

--
https://github.com/kvm-x86/linux/tree/next

