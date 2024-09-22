Return-Path: <kvm+bounces-27244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26CCF97E071
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 09:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B52DF1F21553
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 07:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B370F1917F2;
	Sun, 22 Sep 2024 07:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PZEp07Wp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790492E3EB
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 07:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726990304; cv=none; b=hsuDV7iBd4jSRO2msRrG5/trr0FQiozkHoAg1WPC6uRigcaVrKvZ2kfdZ32cwxEpv07D0kEmzZ7J7K+B5vDrcUUrl5kZDg8ziLQm9+Hilv1tjmOgFpaYDLK4LNzoaAgUJMbLlkRcD06HmtTmI+RR40P1nrgvuOku187shCVdjBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726990304; c=relaxed/simple;
	bh=sagTyMwDQf6oqhlNbK5yePYTnl+Q91neOadm6aaFV7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e1hqbM0LyBjWE1GHxT7ddL+hB3bucx412e/IF0sVb8DnXI/LloJG8+3jaA+ezaga2QGf63Ezzobe+ppR0JNmO2PtWHZRF/MkEtXII1IHqU5i3VEG7tbjOoz7FxSh9kiXV0gOip0ALXTiioJTK3BG+BOGoqG+P3rTOXIj2XDSUg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PZEp07Wp; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1a8de19f5fso4762011276.3
        for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 00:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726990302; x=1727595102; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nBV3T7A9lGf4z4agZRwanlUY0yet1e8wVfV/GXg9FNs=;
        b=PZEp07WpmDIzgd1q3j4sQDYUU9LRlTTjDNsbhcka+lUIZMmycFmRnALM1XrnKs//lE
         mi94qXxWMgDs46wbTS8fkKd2zdQUJFPiA88A7buq7Q2FQMkEV0db9rZbaq824ZZS/dMA
         IIV/i8mIJd87rLnGKKxHo/emCJ2YtS4hmrjPu3jEnL2tTxiHqzskg7q7QX9/hbkmgFVO
         WkEVP1jSyRLElBVFFrfqsIARmJ/0FCJB1BXRAUqiDoyyCoRxZf0afbcLP5MbXP/4sgHe
         BCWRuwx719D2gIyATstDwq6VVjSMESM6ky908tM6EXhgVzx8uda4u5PtvIP/6VrHNaij
         cFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726990302; x=1727595102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nBV3T7A9lGf4z4agZRwanlUY0yet1e8wVfV/GXg9FNs=;
        b=Y3AbfGklg56QnSh8DtBeSsNoV7Ro4wJBASzZXykgtvy/BT66O+Gap8phvEaXMvWi0U
         R4lqrVFZZWTUKQBT+h/bsw2FlQVMOK3ZZK/ODXUYix8+tlPchwiBbKe+bFw/sAz5ME/F
         Qw412i2kZzNOxe300kzscYhHf17J1C6kVEFbCsjDNQ9TCGUAh3PBs2CzDEhubYblSzdG
         NrjhzulYcDr70+h2GNSNsweZ57nNwbcRTAf1VwraJIqt1zQCy85BiOy+8lzcg1FDkq3M
         P/rN1raQ1lccE/AkENgPg5J6cOD7Nv9XDCKJO4nJJrGq/FlBxP35oj0GzSNUmq2QVXAy
         MeWg==
X-Gm-Message-State: AOJu0YxpqYPMmzBdjlQjK/HoVVMVGI9CWFrwCkLkREGmRR5HRO+Qb7Fw
	FHgwD05PG3Mhpjhbg7pCqFZFPha21MziPFYXOniVah5vyFgV1aRF9vltXU0AUU9jZvX/E5m4ZO+
	szw==
X-Google-Smtp-Source: AGHT+IF0nnSzQW3E87OwtSOd+QfouvMUw0MoW0KJ/lx3IcDOjujFUvMfRxiwVEKpOP17gjM0wzUMN4hC+yI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b110:0:b0:e1a:aa41:5170 with SMTP id
 3f1490d57ef6-e2250cc4dc8mr17256276.8.1726990302262; Sun, 22 Sep 2024 00:31:42
 -0700 (PDT)
Date: Sun, 22 Sep 2024 00:31:40 -0700
In-Reply-To: <20240918152807.25135-4-lilitj@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240918152807.25135-1-lilitj@amazon.com> <20240918152807.25135-4-lilitj@amazon.com>
Message-ID: <Zu_HqRaVnJyKpgpR@google.com>
Subject: Re: [PATCH 3/8] KVM: arm64: use page tracking interface to enable
 dirty logging
From: Sean Christopherson <seanjc@google.com>
To: Lilit Janpoladyan <lilitj@amazon.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 18, 2024, Lilit Janpoladyan wrote:
> +static int kvm_commit_memory_region(struct kvm *kvm,
> +				    struct kvm_memory_slot *old,
> +				    const struct kvm_memory_slot *new,
> +				    enum kvm_mr_change change)
>  {
> +	int r;
>  	int old_flags = old ? old->flags : 0;
>  	int new_flags = new ? new->flags : 0;
>  	/*
> @@ -1709,6 +1710,10 @@ static void kvm_commit_memory_region(struct kvm *kvm,
>  		int change = (new_flags & KVM_MEM_LOG_DIRTY_PAGES) ? 1 : -1;
>  		atomic_set(&kvm->nr_memslots_dirty_logging,
>  			   atomic_read(&kvm->nr_memslots_dirty_logging) + change);
> +		if (change > 0)
> +			r = kvm_arch_enable_dirty_logging(kvm, new);
> +		else
> +			r = kvm_arch_disable_dirty_logging(kvm, new);

There's zero reason to add new arch callbacks, the entire reason
kvm_arch_commit_memory_region() exists is to let arch code react to memslot
changes.  As evidenced by the fact that multiple architectures already handle
dirty logging changes in their commit hooks, it's trivial to detect changes, i.e.
not worth moving to generic code.

