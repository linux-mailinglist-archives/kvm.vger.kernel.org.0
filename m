Return-Path: <kvm+bounces-24837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F9C95BC7B
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 18:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8250D1C21A0A
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCEF01CDFC5;
	Thu, 22 Aug 2024 16:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qGFLLSnF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73401CDA1E
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724345516; cv=none; b=N9wkz+TbsuC8Gjc61rFd5qN2m/EqhlFaMRTAsd4UuiiSKnqdJ7n/FKXinXRga/xRdqiHAdtFDTpVykmKAqQow5gNHDNT/RZ3LxpBNKI4orA71tntvaJ5YRHAKT8cynnctMHtpT6XPCxFqQea7njRN0/OTXBQBmu9xRYbQINEoJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724345516; c=relaxed/simple;
	bh=cVNamRgTTPUph/x/fshdqE346mjYXp6WSqqsiB6idt8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NB4XD0YPpx3G0aRs/06jkL0s68hZXKPz/GrKYp4qvRVKOI5ekApaxcAu22XJwFM74HUd0wXzr/GXyAss9jkJmpiyTPUM8Con8sATwCRXGBpjwSPYqspJ9j6NZz/4tn3zLJkC2otXDoJBApzxPs1/AooP09jWg13/UUCck1pS0Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qGFLLSnF; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ad9ffa0d77so22737007b3.2
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 09:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724345513; x=1724950313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5zCSmE1QYxaiHFt6KetUwFCv8uHKoHBDLEP/u43ooJI=;
        b=qGFLLSnFmyXnYbqE/WLsE5p/QOli4gCVsrFJWPdH3LrwbT5ymRT1NIpG/Decq10VnT
         yI+6P5uquQUr3mX6XOlqFc7gXVKBcbPs51UifRA0sP9X5wUkgxHh0y9iR0z3oQLcqyjk
         CIHMVIDXcdcjE9zRYbkJ0ETJ8bpWj6Z4/AK8lmcVEXUGfQQnuJALHBRzCi0uao3R1LAk
         v46wPmPI7QHTSpY0nNs3xxhb/aAgkyAmtb1OTOqw/NoryB5p4wjxLZiLfcYueeF6y5lX
         kliBSo0v57GrrMtiPR7v8E0GfzFkOvvQ1hAxk/EawkOUl9rusmUguZ0wUVAQuKLu0YP3
         bGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724345513; x=1724950313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5zCSmE1QYxaiHFt6KetUwFCv8uHKoHBDLEP/u43ooJI=;
        b=PRMSFavK3UBuC6+iZpI2bZEhoH9kywlFmzVr+hxwa1lB31Kd5HZPEN8pU+oPxGC3Fj
         7QrTGmRIN2saUuyDR0I3pBe2PvKTmdeVOXHYcWF6ge7yxHrYHRwQJOb6ihO+aShlxIzB
         /co1nsKorI9SmQcB03nmTkfKdae12Mbadkrue8A370pewsvckZf+Apwzb7ReJA+oGDS7
         za4Lae9kLxZDe9cPOCjitXtUaKUEBr8OEZumv58dFkzlWQg1rr8rEUDFt1mxn0NLIROz
         kgblzxK0Hxqg71A8pisFbMVEzSANKxl0inK42bQz3J3IMr5qVgKONBENtzPGec6/pQG4
         bp6w==
X-Forwarded-Encrypted: i=1; AJvYcCUhjnb9BEh66a7w9SJ/s35onhOIFY2i6rtuE8CqmaqREd5/1y2eQvOy4pSO/S+SNA4Ulv4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/3loNvUXaSbLko8BD+JYQe/90iYHO8JnfD270ZSR1WZLu5iEI
	oAXUlmiW1wgTyV4duL2jpr2P0vuJApFiQ/gWoXrmM4IV58VSwLhfbi8GMxCxuPMMdrGD5UH3z7O
	saQ==
X-Google-Smtp-Source: AGHT+IFHOWS5Qeaqc0Nhr6r3oYMWdFCr1ADlrhpJoXEsAKlJvD8VkWrvIUhtoln4+l7SBE5HM5Lsnip04DE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2ca:b0:e03:31ec:8a24 with SMTP id
 3f1490d57ef6-e17a45012e7mr580276.8.1724345513652; Thu, 22 Aug 2024 09:51:53
 -0700 (PDT)
Date: Thu, 22 Aug 2024 09:51:52 -0700
In-Reply-To: <20240822065544.65013-1-zhangpeng.00@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240822065544.65013-1-zhangpeng.00@bytedance.com>
Message-ID: <ZsdsqHOtsMDSWMuC@google.com>
Subject: Re: [PATCH RFC] KVM: Use maple tree to manage memory attributes.
From: Sean Christopherson <seanjc@google.com>
To: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: pbonzini@redhat.com, chao.p.peng@linux.intel.com, Liam.Howlett@oracle.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 22, 2024, Peng Zhang wrote:
> Currently, xarray is used to manage memory attributes. The memory
> attributes management here is an interval problem. However, xarray is
> not suitable for handling interval problems. It may cause memory waste
> and is not efficient. Switching it to maple tree is more elegant. Using
> maple tree here has the following three advantages:
> 1. Less memory overhead.
> 2. More efficient interval operations.
> 3. Simpler code.
> 
> This is the first user of the maple tree interface mas_find_range(),
> and it does not have any test cases yet, so its stability is unclear.
> 
> Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
> ---
>  include/linux/kvm_host.h |  5 +++--
>  virt/kvm/kvm_main.c      | 47 ++++++++++++++--------------------------
>  2 files changed, 19 insertions(+), 33 deletions(-)
> 
> I haven't tested this code yet, and I'm not very familiar with kvm, so I'd
> be happy if someone could help test it. This is just an RFC now. Any comments
> are welcome.

Unfortunatley, you are unlikely to get much feedback (although Matthew already
jumped in).  We (KVM folks) know the xarray usage for memory attribute is
(very) suboptimal, and it's on the todo list to address.  We specifically went
with a simple-but-slow implementation in order to prioritize correctness above
all else for initial merge.

