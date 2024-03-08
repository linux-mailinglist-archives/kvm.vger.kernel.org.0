Return-Path: <kvm+bounces-11397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0644876CA6
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFDEC1C2115C
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292245FDAF;
	Fri,  8 Mar 2024 22:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hePtGrNI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF391E515
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 22:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709935637; cv=none; b=reAkpDpeAtixwwLMVrUIRf+aqKtJtJ92cf7IM2JjSGNluXocRaJOuyumK/Z7QhWTg8dKx444bbF0E77fiz9BAKlnGzoZZwA/Es7egX6+BK1Na/DQpDZV7UnellL56+tkfXW55wUDtelsTZ334j8LUbb3vnJt8QZRkTWBbUfEuhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709935637; c=relaxed/simple;
	bh=/VWEFaB91VYuq/7FP3hbWaFOlEC3Se8rWQyqpo8SkjQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bo9poo4pACvgy4moYqn5vkuyJp6GMScS/MX+2nW5Yfz7gYqEITxiIFmRjv4DhKeyK0qC1STzQGl/E0FurNWlyu0DG21IZA3i29m2apLshDDQaODR89na9PsN9ZzfTvo2e3McTLV355zYFUhiSuf9k5KWdrn2duZwhIzMwkv7aEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hePtGrNI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-29ba8f333easo1493686a91.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 14:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709935635; x=1710540435; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AL4ZgvwyGuJh/ix6P2kmz5yj0R+a2NL9R/hhgMUybJw=;
        b=hePtGrNIROVbf7ZxDeS+91UTOCSX1fORgmzz1ZlSwdmzyJzCFotkXhIoiY+btYuXP9
         qSJR7//yNie0o1vpgACG8w1BKNO6zwsabMfp7WMQJNtHSklFAUGhKQA0hKGqoZyOBnN2
         iY3pHhVqnGkUuDvje8P8A1HRaW8+ZtV7G5dK7P2U/8hYpBAbNjsED/eJu7ztqrUUHZCI
         EDoKKK7JPv93dFZ1DEq4+HvW8RDoLIvQagl6xp1PGxqZkzfV+oS4HjR/41QccHM1DPh2
         q+9kz01xF9T/HF/0qxpVoY6spemrGXoRUfLW8cQnc1Ye6zmLMzck8kdawXcKbjA701vR
         j9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709935635; x=1710540435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AL4ZgvwyGuJh/ix6P2kmz5yj0R+a2NL9R/hhgMUybJw=;
        b=bkMyzIkXKyZv1jXRJMy1zSBiBOmNA4a2Z8yxrVUD29LCm0A/SI6YBTmrIdhIWFNg93
         MZG8e7u+3U6OpcZArDQWoGa9jGYomAQkPxuYZgj5HPZdBb2FSHPCH0GzP8w03uwyGfsF
         xNm/Lx2gGQvtB6sHfbaEblX0riBIJ3sEvPm7HUW8drcQqzu1tSrpGa6GurhTYqHFk51a
         Zymm5SifDGRU7WkXotYVxj0J3pd1YstvZ7/UJjGZyK4JcZH+8pjFdU2KHUZq1siVy3gn
         j5F/N5z2nPyeCNud5p3/8Dr8h9YdrOTTSC9bybzbex6xqQ7wMmVqMmtEHW6D/W4C3FKm
         7p7A==
X-Forwarded-Encrypted: i=1; AJvYcCXqeNwsDVCa3dR5hX7S0RfGWSI/r0EWJUov/cmtYgt4yaFa1GCvs3QHbicJy6AQuJDI6NQvu06iLqyH0lkyyxoU8mJd
X-Gm-Message-State: AOJu0YyQlx4Il7/RQ/NzitAHXhX3s7gDSJhm73BQyHwoGnPz9QDBCqRV
	OHx7fFIqEQN3JyGCMMWgk6qZiYSbac5Yo6kzo/qlXjhlYpJsZGf5kUBlPpEyrR2lWQA1hxMAX2a
	QNA==
X-Google-Smtp-Source: AGHT+IFpb3dLKOMGT5haa9ES8rvCErnpQz1aA1UcmD01kGlHWr03OeYxf+VGbagktBOC6J1UCTh2s0w09TU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a92:b0:29b:c1c8:8f19 with SMTP id
 lp18-20020a17090b4a9200b0029bc1c88f19mr1873pjb.6.1709935635098; Fri, 08 Mar
 2024 14:07:15 -0800 (PST)
Date: Fri, 8 Mar 2024 14:07:13 -0800
In-Reply-To: <20240215235405.368539-7-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-7-amoorthy@google.com>
Message-ID: <ZeuMEdQTFADDSFkX@google.com>
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9f5d45c49e36..bf7bc21d56ac 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1353,6 +1353,7 @@ yet and must be cleared on entry.
>    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>    #define KVM_MEM_READONLY	(1UL << 1)
>    #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
> +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)

David M.,

Before this gets queued anywhere, a few questions related to the generic KVM
userfault stuff you're working on:

  1. Do you anticipate reusing KVM_MEM_EXIT_ON_MISSING to communicate that a vCPU
     should exit to userspace, even for guest_memfd?  Or are you envisioning the
     "data invalid" gfn attribute as being a superset?

     We danced very close to this topic in the PUCK call, but I don't _think_ we
     ever explicitly talked about whether or not KVM_MEM_EXIT_ON_MISSING would
     effectively be obsoleted by a KVM_SET_MEMORY_ATTRIBUTES-based "invalid data"
     flag.

     I was originally thinking that KVM_MEM_EXIT_ON_MISSING would be re-used,
     but after re-watching parts of the PUCK recording, e.g. about decoupling
     KVM from userspace page tables, I suspect past me was wrong.

  2. What is your best guess as to when KVM userfault patches will be available,
     even if only in RFC form?

The reason I ask is because Oliver pointed out (off-list) that (a) Google is the
primary user for KVM_MEM_EXIT_ON_MISSING, possibly the _only_ user for the
forseeable future, and (b) if Google moves on to KVM userfault before ever
ingesting KVM_MEM_EXIT_ON_MISSING from upstream, then we'll have effectively
added dead code to KVM's eternal ABI.

