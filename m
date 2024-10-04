Return-Path: <kvm+bounces-27996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C23529910D2
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 22:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25D52B326A5
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 20:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D52CB1E47A5;
	Fri,  4 Oct 2024 20:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y4rSMPJL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0051DF72E
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 20:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728072340; cv=none; b=Oy9H/5XY6SqMwSk0Ctcua5zZPKVJoZfXImapU7VeFbRPTNnrRdSWaJicsVBkpsut/Elh+82PigZDTsMHP/79GMMJs+oZkIevxNhTCWsBJgQiXv5xXUMd6JvvXOH3Ik+sfYreHDWgUSBTEti9k2+I8U74Ju8MhU0f0ZL6WgC8ffc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728072340; c=relaxed/simple;
	bh=JiMxay4gnW+6wgKIgt9nl2obDExo8a/GF1PhTk/kOIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OqCNzs/rmHyOmPNsysqiza4eqi4E1qNwevGct/iNu44VyE/Fn+ySCzm0oV7BLmH0n5A1FbM75zf+VVeHVAhtgQDHn+bkCGV8KTGvRfBZiOYBnQDuXgQY8qmYwjT5t/QTDHAwXo+ZbA8CFhxoa5DqiO2dN8s7wo36aviNQsBags4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y4rSMPJL; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5c87a7782beso920a12.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 13:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728072336; x=1728677136; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JiMxay4gnW+6wgKIgt9nl2obDExo8a/GF1PhTk/kOIA=;
        b=Y4rSMPJLXHmImyc9TcWFVcyPr2WszUekMzKkg3UtAAlSBLaBUYvrFYg6OfhT6u/iGm
         OFjQdQnGI/b7h+CU74FtcbQEaS+d+/lHBEcpL/uioBXdy3Aewt9ZXVPlCu1JN9SjB+0B
         7d0d0aayzk8M9ZiL2q+xsJpcpxm0lflFyZoQ2Ix5L31mFOVd4+7Qtp77fi7ifAySQ2dY
         sIG34iCjiFUWFnzrvPLwkw8Fwnv4jX4QrCFbqaWH95OSXwrbk8ay6ZWboBelPXAqD2QU
         myY2/qaQBnt+ARpaoPYanM/GZn9xi7L7BWKjz/hDMVOqZcXLFw1nEZ5GJqJhc+r7Q7IN
         4NOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728072336; x=1728677136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JiMxay4gnW+6wgKIgt9nl2obDExo8a/GF1PhTk/kOIA=;
        b=qgzWNzNmN1cNqqaUOQCbhjgNgZ5Wt0h2u6QGz3dVe7RBdh5k0aH1q1j4oUicKLh0do
         XKdJN0t6lklDRrKlVPVAugmr+L5US2254WRN937W1CGvfa1KnvXEWGUgYDtzoVr1HGdS
         DMHPZYl+NnF6NaKaGug7vcK683mIBxzWi5GCQCu/5FwtIDfmwmIQhxTchsUDvGy1xfRg
         fgaI5j2a6/4qs1G3p0lRW3fp08ZZ3NtZurcYdeONfM0Tc379B6CfAdzhQ5gS7rfo8179
         uBSYQn76MftQEAHztO1vyU1BhsxEgP9fhnsOBxuE8/J+6zKUnfac5bXI47J1JaoMVWVx
         LZGg==
X-Forwarded-Encrypted: i=1; AJvYcCVvqj0vGMOcturyM7zs61yr8eTzh3Cao7NjqzafUtvKh+mv8N9D7z0ACWKqXpBC9OeuUWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSGc1VubHyG/W8FEVDfTF2cvFFneeqa5M368oS2busADBgzA4M
	BRM1tZ8oXfIhzKFgLExGC0y5BZrID4feAcqqHeKMclTr74yNrMZvnmLzOsMP+ZDjBr4T9Jx4oFg
	P4Dg7jXVzmtoxLHtcD9Tlbd+BgIkRSmNp/0C4
X-Google-Smtp-Source: AGHT+IGKj4ecSq7kiQmR5mFeEjukbtjqOAnsrq9GPARLECwAIVL7N3BRgGkc9MB+SMxU+dPJJPhJacrNmaMHMUr9wxo=
X-Received: by 2002:a05:6402:42cb:b0:5c7:18f8:38a6 with SMTP id
 4fb4d7f45d1cf-5c8e124ffe2mr74647a12.5.1728072335495; Fri, 04 Oct 2024
 13:05:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241004195540.210396-1-vipinsh@google.com> <20241004195540.210396-3-vipinsh@google.com>
In-Reply-To: <20241004195540.210396-3-vipinsh@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Fri, 4 Oct 2024 13:04:58 -0700
Message-ID: <CAHVum0eXVwpwsrVC21XN1H0JvJ_QWnr3ERPYvSyRpwudVFtg8Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: x86/mmu: Use MMU shrinker to shrink KVM MMU
 memory caches
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: zhi.wang.linux@gmail.com, weijiang.yang@intel.com, mizhang@google.com, 
	liangchen.linux@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 4, 2024 at 12:55=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> Use MMU shrinker to iterate through all the vCPUs of all the VMs and
> free pages allocated in MMU memory caches. Protect cache allocation in
> page fault and MMU load path from MMU shrinker by using a per vCPU
> mutex. In MMU shrinker, move the iterated VM to the end of the VMs list
> so that the pain of emptying cache spread among other VMs too.
>
> The specific caches to empty are mmu_shadow_page_cache and
> mmu_shadowed_info_cache as these caches store whole pages. Emptying them
> will give more impact to shrinker compared to other caches like
> mmu_pte_list_desc_cache{} and mmu_page_header_cache{}
>
> Holding per vCPU mutex lock ensures that a vCPU doesn't get surprised
> by finding its cache emptied after filling them up for page table
> allocations during page fault handling and MMU load operation. Per vCPU
> mutex also makes sure there is only race between MMU shrinker and all
> other vCPUs. This should result in very less contention.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>

I also meant to add
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: David Matlack <dmatlack@google.com>

I can send v3 or please take it from v2.

