Return-Path: <kvm+bounces-16192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC548B6351
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 22:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAB8F28395B
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 20:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAED0141987;
	Mon, 29 Apr 2024 20:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cu62vQiO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7F91422C6
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 20:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714421607; cv=none; b=dEZc45yA8lPaMs9TXDDnNBt1AVRDByAYhNO+VUhGlo8Y1pknZ4q4XaLDP8uNp9jZiXjln6n6UPsY7w+D2PBG8K2jEMKH5IyqxeI70h7CiyL3fX8b2lh555ZIUcEL4zOce9NbE/Kb/pXReaYTcGq0UpB2q/znDpMLROdbJgTqcwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714421607; c=relaxed/simple;
	bh=mGDBw08jwclV2/Usl0LbH8eCl3nupNz84hqMoPwtcpg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hQfARIUMPBM9J+DFMhqXWwvtyrVRkT5nDpeCjAt1lGYtL49gAHWnuIYGq+AzgAl3ZDvnC7yg+WW9zdbc8z0d1FeddkfxRG/nFYNfYrA/FCSXp1S+0JWt4gq80EshzxQKoDkmgIKfPrZbbYfR0PEtFv8kogXTvzOliWs1JM1mNv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cu62vQiO; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc64f63d768so9640340276.2
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 13:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714421605; x=1715026405; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mGDBw08jwclV2/Usl0LbH8eCl3nupNz84hqMoPwtcpg=;
        b=cu62vQiOumAzDp5sqJCoOO7HfIugQQ8ljEOBXqFn2L7wp1IGeY6nuKGKdZs6InoHjY
         enr5DRQMN/AzN17l2k8Y8CzqPFgzmljWogHD3GW3ragDs7XXiKmdXRE4vqUZ89VP6i+d
         u/Wc6w7G6rz/pmwCC0aJ80b6ARiseTqQ2CeS7OaMX7khk22vT0evgAIBSjO47BwjlKjt
         s1uhyXDY/S/70CLVKoyIxVz1hUcz8yKJG2n8tWxl097GpHkRAjzLU4G3mWFmBwFJ++3x
         hdfMFxKuDJ4Ai5ZDX57U2z+APTX6QjYvE7Szzz4v6STc5c8QradLlw0piAMaT523Fs8q
         Uu2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714421605; x=1715026405;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mGDBw08jwclV2/Usl0LbH8eCl3nupNz84hqMoPwtcpg=;
        b=w1xrqJ/UDtSIHj8p5PzakacEx+Kn71FdAf55nbtIlkhJuOrLZ5jYw/KXKnzlf1/uj4
         5pOj6tUqZKBktTRzoopHaAgrkzuxHR+dVvYhljnmGu93km+QjNUVP7MTzfdoT7EBd6c7
         4og8xvPXRPCnzTeVH1rokhp5AvE9wQlUaI0VycKkySPsyK2sEE8OqYZ69LSN6jPG1m9l
         Gn8EAKw7w71HTzABMLAyJuCh3qiICA6cHG8dSsEhqLfOlEqQ/KUtb7LIUJUWHoQLtOoI
         G+y/SX1XPdhvYAitznHwUcbt6xxuygSYOzYzO4JWFoBV1HdCe8yPd1uRaMGavuk1B4IJ
         KcGw==
X-Forwarded-Encrypted: i=1; AJvYcCWSMYQj0O0A9zwdGUHcm3wzXoGLfcBZ95yvu1BL2W474U5MBR4oPlGJ19A+dFHcyVlFvMIUV4RFPTVlzY41M0ZnS/cP
X-Gm-Message-State: AOJu0YwbDjDsG6zkkm904qIby6kHR/BzVbrESiQaaT+0dj2PRQFDgyac
	qNRgZkzFxEaYjL8IxWoXVstH1kEj+9Rw4rRrfXX/EUs2StPcfO8K4Gq5nxmzK3Z5RgyvwiglFO3
	d6A==
X-Google-Smtp-Source: AGHT+IHjDqwZzVZOdkMIdoNtlrbF2jMShdObuIn9ReDuQkS3FkeKyRuyz6S9asMeDRgcN9m+fLWxaXsOvH0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2281:b0:de5:2325:72dc with SMTP id
 dn1-20020a056902228100b00de5232572dcmr3419262ybb.5.1714421605683; Mon, 29 Apr
 2024 13:13:25 -0700 (PDT)
Date: Mon, 29 Apr 2024 13:13:24 -0700
In-Reply-To: <CAOfLF_L+bxOo4kK5H6WAUcOeTu5wFiU57UtR5qmr1rQBT5mAfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423024933.80143-1-kele@cs.columbia.edu> <de0096bf-08a8-4ee4-94d7-6e5854b056b4@intel.com>
 <CAOfLF_L2UgSUyUsbiBDhLPskt2xLWujy1GBAhpcWzi2i3brAww@mail.gmail.com>
 <CAOfLF_+ZP-X8yT7qDb0t57ZZu7RNhdOGyCNfR2fheZG+h_jZ7w@mail.gmail.com>
 <ZivTmpMmeuIShbcC@google.com> <CAOfLF_L+bxOo4kK5H6WAUcOeTu5wFiU57UtR5qmr1rQBT5mAfA@mail.gmail.com>
Message-ID: <Zi__ZF5SY2k7BtTE@google.com>
Subject: Re: [1/1] KVM: restrict kvm_gfn_to_hva_cache_init() to only accept
 address ranges within one page
From: Sean Christopherson <seanjc@google.com>
To: Kele Huang <kele@cs.columbia.edu>
Cc: Zide Chen <zide.chen@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Apr 27, 2024, Kele Huang wrote:
> Although, it is a bit not straightforward to me because it needs to call
> designed functions to do the guest memory read and write even though people
> assume the cache is initialized, or need to do the ghc->memslot checking
> manually before using the fast path.

Oh, don't get me wrong, I completely agree that the code isn't straightforward.
But I don't think this is a problem that can be reasonably solved in the caching
code, at least not easily, as a lot of the oddities stem from KVM's memslots, and
KVM's contracts with userspace and the guest.

