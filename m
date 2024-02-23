Return-Path: <kvm+bounces-9559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCEDA861A0A
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 776452887D7
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1102C14037B;
	Fri, 23 Feb 2024 17:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vZVfto5x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF9213DB81
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 17:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709820; cv=none; b=adtwFLQ80PXhHxmz2jE5F71+b7ps8YmjbzGHdkE+FV63cH+8JMw+qZpBB2Q9OHrCi3FNZiyzaRba+Cmy30UDRGRJ+JGJmw8bO0CKy/zXCaqCdI1fxu3u1K4ob5CB2PTvCPQ+tz2KFLt8ZJGnMTJhln/MdOBYPlE1w1IbdRxdpAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709820; c=relaxed/simple;
	bh=mPq99SHVDAlyu/Lw6k/HCBY8a5P8RgeYGBIuIYVU8jU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VzduhiXoJZ5eCAlJ/KuqFbYlDeZfLBrtBtfRq7VvYmTaoKBv8TKm9QzwE4noUaIHuHw20Q2CU1VlJlWei1ybYhy0EUSANnck18o+AqSFh6J61Df/bRX/rtIcRN9/2GSdtSBEyNCatlGmgx4FmNn2u6QLTJVSiQ+XOnYfjG7WJO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vZVfto5x; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so1693062276.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 09:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708709818; x=1709314618; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vQFkD/yeaXafYTambjNc8nGAaM5dCANMqU9RXbu0aLA=;
        b=vZVfto5xhOFCLp49Hgi85KvUoY/pi52vzZf5i2PPR+Mx1mzavSmBIjMWZdobDQv7jc
         uQR3zDF6XXOgf0E/Bza0yv57kNq+IlARkyHSl1ibhABzpULF74xsSs3/8jnxVI61YT7m
         jyjPkAR31z9lNJGcDKClUEAzamfKXHOUSE3N8XJxcUonKxXkacg8Ucjrlk9U1qopaM8V
         SGrFG4kDrYIgFD86g8bhTFHrJoS0UE5ZjrxXHHCyBC/JgBEnWA9EgvdtKaFpnqsSliP3
         b5jpUbsMNDeIEvkxwRMQSBPkWC33urPVQBcV7gkzGaykj0+5tJISmH+Vwvj65BoepVr5
         mx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708709818; x=1709314618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vQFkD/yeaXafYTambjNc8nGAaM5dCANMqU9RXbu0aLA=;
        b=VvXEBrxhf4oamxRPv3+THWzFfLdVgLaNI2DOkq0fr9sZKex3J97pmv41rwR1uOtsRD
         kqR0bE5Dk7INBjWzAovjHo86GzhTrFOP06A0L19Wllijv2H2tpwq4C9yVRvXgJDyfF/0
         Y4y4LmsBpmZW6pnBIq/y2pTHDF48Yt6TzjOOwVEASDzKgXLfF8qu1neq1PcYzVHD1x9+
         UvfvGZ2EKxz0gEofqPHUhMjPAwq5TPT+TXuHMFzTIW1vqsX4G5+S8sZBKBOZFMM0JrYM
         q1wt06WOLm8nP0N/o6viJCcT3l8amK5nt9rqHOVW7q13kfQLHPy1GD6gKpDxK8P14Set
         /YZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKRQL/pRCb7DBTvAX6uVdRXkd0g5JRDucgryNN0sWYFG/tWY/1v8SVmLD9rGpHKhDdF523wCeDyegB+B4K2/UZ6yRI
X-Gm-Message-State: AOJu0YyDIxNItmDNOg/+98YBCCIRF2AOv/9iNFhVEWhU1cdFFSuXGtBY
	5ayxZRc9FNdkxCNZ/j+KY3j05C9/ucLeUqoBo92uxLi2XiwmdHuKi2mdbdFNJnf4RUbUd0s098w
	bRA==
X-Google-Smtp-Source: AGHT+IF6qHLLb++rm38SnHHY1oMkxzeH9qs55zcOOM7YnS3PnobaoRSUe6xFvYZWf184A1ED5DElZhno5QQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad9a:0:b0:dc2:550b:a4f4 with SMTP id
 z26-20020a25ad9a000000b00dc2550ba4f4mr124968ybi.1.1708709817812; Fri, 23 Feb
 2024 09:36:57 -0800 (PST)
Date: Fri, 23 Feb 2024 09:36:56 -0800
In-Reply-To: <20240221072528.2702048-10-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240221072528.2702048-1-stevensd@google.com> <20240221072528.2702048-10-stevensd@google.com>
Message-ID: <ZdjXuH4jBaAZCrgy@google.com>
Subject: Re: [PATCH v10 7/8] KVM: x86/mmu: Track if sptes refer to refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 21, 2024, David Stevens wrote:
> + * Extra bits are only available for TDP SPTEs, since bits 62:52 are reserved
> + * for PAE paging, including NPT PAE. When a tracking bit isn't available, we
> + * will reject mapping non-refcounted struct pages.
> + */
> +static inline bool spte_has_refcount_bit(void)
> +{
> +	return tdp_enabled && IS_ENABLED(CONFIG_X86_64);
> +}
> +
> +static inline bool is_refcounted_page_spte(u64 spte)
> +{
> +	return !spte_has_refcount_bit() || (spte & SPTE_MMU_PAGE_REFCOUNTED);

The preferred way to handle this in KVM's MMU is to use a global variable, e.g.

  extern u64 __read_mostly shadow_refcounted_mask;

that avoids conditional branches when creating SPTEs, and arguably yields slightly
more readable code, e.g.

	return !shadow_refcounted_mask || (spte & shadow_refcounted_mask);

