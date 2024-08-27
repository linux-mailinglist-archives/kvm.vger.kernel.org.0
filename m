Return-Path: <kvm+bounces-25174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E0DC96126E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 436191F22112
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F7D1D175C;
	Tue, 27 Aug 2024 15:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VdQ7jn1w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011621D174F
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 15:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772528; cv=none; b=sYRA1PNIBTTSwrRoJjRpliI5eQJSCDHg5BRvPYqYkSjCWdCuYM5xIUFUjY6rbbgDHRfsIQmZ03CJ0wXbsINc/soe4kZS4SWPE8V/94xdkgyxhcIV1Oh3nEk/KZQ+Gq5RN8TgALuasA4d1ZDPo9AuWjoYAnYO1Ji7V48RnbmGfRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772528; c=relaxed/simple;
	bh=4yAlMlBA4ouTt0DGe3f9cAnewU9Z5AuKZeGQC3oO/yM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=texQyGEtkUpHf3++q7AoQsRJN3rzMrPWqf1u0UkwNUfU7RK+CtTepLsoew/QrCV9rRdzLagehSsmb38437pMB+06Joc48mxFQnbjaY0gp65XSTJffoXGszuNsskGK81lUc71/MnqkVjSYptSxl0fA5PJQd9y6SwDCyL/bIED7HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VdQ7jn1w; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5a108354819so7213473a12.0
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 08:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724772524; x=1725377324; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4yAlMlBA4ouTt0DGe3f9cAnewU9Z5AuKZeGQC3oO/yM=;
        b=VdQ7jn1wip+jJkRbLVv/B7OdHaT0+Fa2uSC5kJ7EXx+IKP7WRULpzpW4qvqrT85ai9
         Ln8YVmGzbrD4FJJYqNaAb/rlOEA17dcXL8wUY4wmzDIJSUeAXhgfIJCd61H25fSju3zc
         /sjZ0NLHQCixsT7SeWtO9ofF6AdJoRR38NQFEreFc2biWNX+4mCgY1lFzqw8F+WAzhIu
         U+aA93SffqUdlWBynGxgG1xFHDCheySAMeYrnT/EiR66W5E4Yr5ts0rYvLniJsjoOnNj
         dryeLk3IuqEwzPC7p/tXecIAfgZYLPvve10Os2FNWlnOxnjzPk6iTzcFm8b93hMSML/4
         4sAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724772524; x=1725377324;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4yAlMlBA4ouTt0DGe3f9cAnewU9Z5AuKZeGQC3oO/yM=;
        b=Ex+1acErz0VAJL7E5ARZGZk7KeHDXlcqOTOensLviPh1YlUlyAvoTU5LKYpQ0yx849
         OICwUMjCV7bTTyMBGTzwKI/Yt4D9KLLDXi4CSAe3mtQ8eFm5NqnWXcpasvCHqo+8CM/a
         1dPoqknyByw+EZqFlgsOdmUVttJjfQ0BkC88LCJs2OPvokJEaISwbYLqCveQtvcpi6+b
         EO8xDMqOOZGg+/HgsMd2g6qy9AXSLmBbi5usLcQTyACcDkV2sUC6xf3TznsAPA/ZglvF
         dzbrHj58m4urTm7Sfm9T3JEhBJZfmOUDuuY9fJ5ibe8Jka5vlAU51ZmXwC4/sCLKA86c
         PRJA==
X-Forwarded-Encrypted: i=1; AJvYcCViAgqhTQXvjsxFrghUiebTN4kPRu81YSzvuNBndkp2pWb/ywEsYV61zugpqZ7FKmxFWUo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxdxuD0rALuqgWIBS4zLMwcRB5M72keI0wInpGYUeKZ/1SaRWY
	eLbtMup5cAXEawWLFqwDgZB/rEzgaEZb5QeNppNZsUun5lgzd6dYOmndcabS5gW9gy9UTra68z9
	U6tgXZ1ExKpOP3XO04yrDKfhLlqaYd2RLPrdCEw==
X-Google-Smtp-Source: AGHT+IHNXYKP+BrjeVYDN3n2Nvk0pm4G3DyCjzZQTu06RSPdP2LyJjWIHGARVO3uX/jlq7P9dttqNx7mclhmD5yRb5U=
X-Received: by 2002:a05:6402:1f4e:b0:5c0:c4d3:9017 with SMTP id
 4fb4d7f45d1cf-5c0c4d39303mr1334841a12.38.1724772524119; Tue, 27 Aug 2024
 08:28:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827151022.37992-1-anisinha@redhat.com> <20240827151022.37992-3-anisinha@redhat.com>
In-Reply-To: <20240827151022.37992-3-anisinha@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 27 Aug 2024 16:28:33 +0100
Message-ID: <CAFEAcA9Xq7S6_-hYkNYdv6-z7tM7xSgDGyC92L19kTm02qScAw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] kvm: refactor core virtual machine creation into
 its own function
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, zhao1.liu@intel.com, cfontana@suse.de, 
	armbru@redhat.com, qemu-trivial@nongnu.org, kvm@vger.kernel.org, 
	qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Aug 2024 at 16:11, Ani Sinha <anisinha@redhat.com> wrote:
>
> Refactoring the core logic around KVM_CREATE_VM into its own separate function
> so that it can be called from other functions in subsequent patches. There is
> no functional change in this patch.

What subsequent patches? This is patch 2 of 2...

thanks
-- PMM

