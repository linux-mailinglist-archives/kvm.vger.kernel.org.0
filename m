Return-Path: <kvm+bounces-59016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C594BAA124
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B45716E685
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B6B30CB50;
	Mon, 29 Sep 2025 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nb1eBvOE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DE6271A94
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 16:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759164963; cv=none; b=Znr9/gYGvevOX/AV+VehoPj14BGNzQOlpDqago/No9/2ZveATtznfa+/7r3UzHL0DX4URfDf4Epa5awmfE3xZ6ThS7oI4iGD35d8woK1WYJ5V97aubFqR9J1+QD+bVDbvSZLJxp4NDjk/nYcFBIMU9l6YBsKqbnvYH/w/A0wm8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759164963; c=relaxed/simple;
	bh=aq3fWZR1dXZm7LJywJmxuW6r/1l6NXgn+AwCN9U5644=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VqNZwo4Y2G51glMnc84pKak8kO2CS8N8k5Gd7lnlF9QDEFZcN2vAAwQqdbO5y4KgxKgMkCGiIYw+qIF9rYlfU834+cfynGHyXnKzkZ1lxVE4t5uj4kZV67YYlTxqEk3GQldp2tfvOMTjnGmyc6HErC/cy7UdbABg8B1FmO/DplM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nb1eBvOE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee157b9c9so4241628a91.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759164961; x=1759769761; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9XbXmWXQ6yw7jgUXJGOGhYyHRPmszq8E1Tp17tZVzwo=;
        b=Nb1eBvOE6obtmOsCmHrBvHnCawNY9rIrIH/iH1NKD/aNY9viljgBfQRjYqEJlTtFEn
         UrtBM2RXIe3I7eF+NA2z7mDZf77VtTdjJUpFOPdyFQodPgf9XoI6nZIN8D2nccXURpwy
         5aiDWfrDmm8wmmq0SjTXQqIv8b50uZLh3dHK/+2cswdL9mp7Kl8w4GGk1WOBPr/cMiKH
         xkOzjQp9g//jPnIj97D5CCYS/JtjpsIHIUqAzmUcUu4yr2GD/d8LI5LT7GHF37QzsMpI
         CtwZYNsIihyoK6OUmNh9JAEDUELZRPCodiWI+KNe+j9OBXQAU2SXpzTDxoemqzWg8QG8
         efBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759164961; x=1759769761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9XbXmWXQ6yw7jgUXJGOGhYyHRPmszq8E1Tp17tZVzwo=;
        b=gV2kAz1nd7QV8K04kwdInMYAe5C60aieCnr3B2+Ehg/emzMVd2ES4Y3EJUVrnQFI6t
         2wmM9QhfNo53YXSukbmndPqvAuFoD33MbNS+sZIOPaEPYiv/89wobIEX+MZjRKRCsUxq
         f25G/sGsET7o4tuknJPBs/mTTpvmBuLXxktSU7+ZfSlQx59H7lDuFCtAcS18s/7ImnLl
         crltromucJaDptkqVY3GsLiCnSu4TkHlBTovsiM+k337c0TBjfYBU8+KY2UkqEmRZBAw
         mElKutSqB/50qQ6QwyScJGs5E6jx725LXaO7nU5kkVSLFAKDbkb3E61HVs2mlIz2pzgs
         hxNw==
X-Forwarded-Encrypted: i=1; AJvYcCX+RhIGeKyHbY6yzSqzZLXc1xm3tOob5NKiBseSJT3og5Mu2G9PzFrNEClbJxrQ/c8Kx3A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSpE6TKpy0HyKPsffuwRSWTPJpu42jKERJ63t7CAp9BdbCKKZn
	WOWpNJfz2tfAHBYQaKSUijjj2lgeY0FN9+wEcbQ81mzCzO4kjUpVgtn5i9WKfKUH7sFpXS0hj4S
	RBn5VnA==
X-Google-Smtp-Source: AGHT+IFLjIzTUpc45LEGOUkPN7hnf1kgAXdO/j3/rwcUcXXzok9aWCqi6sPp1tEcnfxySBXZMf749JBhUC8=
X-Received: from pjst22.prod.google.com ([2002:a17:90b:196:b0:330:7be2:9bdc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ece:b0:32b:6145:fa63
 with SMTP id 98e67ed59e1d1-3342a216f73mr17472559a91.4.1759164961433; Mon, 29
 Sep 2025 09:56:01 -0700 (PDT)
Date: Mon, 29 Sep 2025 09:55:59 -0700
In-Reply-To: <diqz4isl351g.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-2-seanjc@google.com>
 <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com> <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com> <diqz4isl351g.fsf@google.com>
Message-ID: <aNq6Hz8U0BtjlgQn@google.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand <david@redhat.com>, Patrick Roy <patrick.roy@linux.dev>, 
	Fuad Tabba <tabba@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nikita Kalyazin <kalyazin@amazon.co.uk>, shivankg@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 29, 2025, Ackerley Tng wrote:
> David Hildenbrand <david@redhat.com> writes:
> 
> >                           GUEST_MEMFD_FLAG_DEFAULT_SHARED;
> >>>>
> >>>> At least for now, GUEST_MEMFD_FLAG_DEFAULT_SHARED and
> >>>> GUEST_MEMFD_FLAG_MMAP don't make sense without each other. Is it worth
> >>>> checking for that, at least until we have in-place conversion? Having
> >>>> only GUEST_MEMFD_FLAG_DEFAULT_SHARED set, but GUEST_MEMFD_FLAG_MMAP,
> >>>> isn't a useful combination.
> >>>>
> >>>
> >>> I think it's okay to have the two flags be orthogonal from the start.
> >> 
> >> I think I dimly remember someone at one of the guest_memfd syncs
> >> bringing up a usecase for having a VMA even if all memory is private,
> >> not for faulting anything in, but to do madvise or something? Maybe it
> >> was the NUMA stuff? (+Shivank)
> >
> > Yes, that should be it. But we're never faulting in these pages, we only 
> > need the VMA (for the time being, until there is the in-place conversion).
> >
> 
> Yup, Sean's patch disables faulting if GUEST_MEMFD_FLAG_DEFAULT_SHARED
> is not set, but mmap() is always enabled so madvise() still works.

Hah!  I totally intended that :-D

> Requiring GUEST_MEMFD_FLAG_DEFAULT_SHARED to be set together with
> GUEST_MEMFD_FLAG_MMAP would still allow madvise() to work since
> GUEST_MEMFD_FLAG_DEFAULT_SHARED only gates faulting.
> 
> To clarify, I'm still for making GUEST_MEMFD_FLAG_DEFAULT_SHARED
> orthogonal to GUEST_MEMFD_FLAG_MMAP with no additional checks on top of
> whatever's in this patch. :)


