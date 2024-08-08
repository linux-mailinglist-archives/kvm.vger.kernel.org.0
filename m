Return-Path: <kvm+bounces-23648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 122F294C48B
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 20:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35CE61C22A7C
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 18:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF0414A08E;
	Thu,  8 Aug 2024 18:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n7z5RBhe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E9380C13
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 18:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723142392; cv=none; b=Qe/EKEm8a7KH6eDd5YdbEWyGcmWtW0U+pg0Y5P7i5fxqcNdbDoBYrEREWf/mqlXfbul1K2azdeLe9O/qcjTOsuMqyioLNseSiLMFQnlGSIqOMAXFCrHyhn5h7Wftl4Et/PLetEX8P5QI89HPAn5thSU6rE+1fcst1Q9sMfHRujs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723142392; c=relaxed/simple;
	bh=RwFJhJLgvF0/ZS2geOC+B9PruxoqhM8ayNYYcVVP5GI=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ectG1piSLYvCh1UowU3qOVRzeZgw+ImdI2Pr4vxgJ2uaqu77uTULNty2ch9IoOSE+OtmtLm/8is26BWDP+L18WYxl525iojJVZFeU6pkhS93OG5LsK9AH16OZHlGaTaPEyikexS1J+Zpw3Wj9TFbCXHvfJNtgZ8/1syn4+Pb2gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n7z5RBhe; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-200618d71dfso10699925ad.1
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 11:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723142390; x=1723747190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rGCKEHWds3nLjc1rwbe/3j/9p13PqyT95btT2PVEHJQ=;
        b=n7z5RBheyozDL2PIH3VQaVWA1lBvvOfW4pcZEJGePnZpjQCiKrU3NxY3yMS/UrGEPp
         Zjk8Vs1Smf76VZjamessf27kixf6PkKHcuFPS4TrCso7Z0zCJYmiHouiG3KF5GoO03M4
         GwC1jgeSbwuOYgcOfa5Z3TCcqN0hLTWOmFgQOn201U8m3MywJ/+jQD6MR1vMH9q0/Pab
         qanETUxtnylFaEMZr28s89ecx64kSD3mRRSpMF9nhJRu7+Bv0978+CANCs+lN3F8doN3
         LFG+YXZsNg4Vu4rdW1U/ifhSoY/MQkZi5v8DAcZq4evleLOA76KIbpQ/pMe9h/NnKBmG
         DCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723142390; x=1723747190;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGCKEHWds3nLjc1rwbe/3j/9p13PqyT95btT2PVEHJQ=;
        b=UDbqlCl28KLy899b8N1qrQhe0Jrga7/wnUx0HJJuUrgplVt485eJ9BxobR0sdXJCTB
         WXveWA/pzhLHE8fobY8rrhFfX214DPhezuATheHb2S1d7XHSsIeQKzLq/RcrgsYl5/bK
         KoBZeET6QTNJFWx8y1C97abQjrcVfycxFaV60IpGP91AvXRMkr1j3QzyJWDgdl13+Fr7
         udpWQVjaCVCw8+NcL4vmpkaSCwd+2EKpyraPjugwjFbXyIYtE+CGykf5a4BeEVmgYiQy
         PF+HienOEiGoY+PPMp3qioKyrUl7kgW4gKKRwNcdy8+JHKC0T5g2Fhqmfhz8eruDgN10
         x3kg==
X-Forwarded-Encrypted: i=1; AJvYcCWWXjjT9EaO21KiX/YM6lx3a4OTSQ8bXKYOvuT+P9T0bCoyCRWyNmwWF5yfD/Dzydix6GQnIdBHBM5Pl0onQuGktTvv
X-Gm-Message-State: AOJu0YxPktcY5o/UcOJX/CTaHcwfrMfsT9cPBtqXWkeWAniRO17jOEhI
	4ho+bt45bi4EHs2HZfXOUpSFgsSmUAVZPXCxEe8PxkYrMbxa8Mt/NSio3IKiVl8TfOxbs1UCEYA
	BH5fiKM8FheEGeIflQBSLMQ==
X-Google-Smtp-Source: AGHT+IFHR6HjyQprVWt7cfvq/+n/27mLEEJUa7fdG1j2U7c3HTuf0p1YaAhdrnA4goWQYkAB/MjKv4gqqjBOaHPwkQ==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:903:1105:b0:1fb:526a:5d60 with
 SMTP id d9443c01a7336-20096d3b493mr1368265ad.4.1723142389804; Thu, 08 Aug
 2024 11:39:49 -0700 (PDT)
Date: Thu, 08 Aug 2024 18:39:48 +0000
In-Reply-To: <20240805-guest-memfd-lib-v1-1-e5a29a4ff5d7@quicinc.com> (message
 from Elliot Berman on Mon, 5 Aug 2024 11:34:47 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzttfun9jf.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH RFC 1/4] mm: Introduce guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: Elliot Berman <quic_eberman@quicinc.com>
Cc: akpm@linux-foundation.org, pbonzini@redhat.com, seanjc@google.com, 
	tabba@google.com, david@redhat.com, roypat@amazon.co.uk, qperret@google.com, 
	linux-coco@lists.linux.dev, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	quic_eberman@quicinc.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"

Elliot Berman <quic_eberman@quicinc.com> writes:

> In preparation for adding more features to KVM's guest_memfd, refactor
> and introduce a library which abstracts some of the core-mm decisions
> about managing folios associated with the file. The goal of the refactor
> serves two purposes:
>
> Provide an easier way to reason about memory in guest_memfd. With KVM
> supporting multiple confidentiality models (TDX, SEV-SNP, pKVM, ARM
> CCA), and coming support for allowing kernel and userspace to access
> this memory, it seems necessary to create a stronger abstraction between
> core-mm concerns and hypervisor concerns.
>
> Provide a common implementation for other hypervisors (Gunyah) to use.
>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>  include/linux/guest_memfd.h |  44 +++++++
>  mm/Kconfig                  |   3 +
>  mm/Makefile                 |   1 +
>  mm/guest_memfd.c            | 285 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 333 insertions(+)
>
> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> new file mode 100644
> index 000000000000..be56d9d53067
> --- /dev/null
> +++ b/include/linux/guest_memfd.h
> @@ -0,0 +1,44 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
> + */
> +
> +#ifndef _LINUX_GUEST_MEMFD_H
> +#define _LINUX_GUEST_MEMFD_H
> +
> +#include <linux/fs.h>
> +
> +/**
> + * struct guest_memfd_operations - ops provided by owner to manage folios
> + * @invalidate_begin: called when folios should be unmapped from guest.
> + *                    May fail if folios couldn't be unmapped from guest.
> + *                    Required.
> + * @invalidate_end: called after invalidate_begin returns success. Optional.
> + * @prepare: called before a folio is mapped into the guest address space.
> + *           Optional.
> + * @release: Called when releasing the guest_memfd file. Required.
> + */
> +struct guest_memfd_operations {
> +	int (*invalidate_begin)(struct inode *inode, pgoff_t offset, unsigned long nr);
> +	void (*invalidate_end)(struct inode *inode, pgoff_t offset, unsigned long nr);
> +	int (*prepare)(struct inode *inode, pgoff_t offset, struct folio *folio);
> +	int (*release)(struct inode *inode);
> +};
> +
> +/**
> + * @GUEST_MEMFD_GRAB_UPTODATE: Ensure pages are zeroed/up to date.
> + *                             If trusted hyp will do it, can ommit this flag
> + * @GUEST_MEMFD_PREPARE: Call the ->prepare() op, if present.
> + */
> +enum {
> +	GUEST_MEMFD_GRAB_UPTODATE	= BIT(0),
> +	GUEST_MEMFD_PREPARE		= BIT(1),
> +};

I interpreted the current state of the code after patch [1] to mean that
the definition of the uptodate flag means "prepared for guest use", so
the two enum values here are probably actually the same thing.

For SEV, this means calling rmp_make_private(), so I guess when the page
allowed to be faulted in to userspace, rmp_make_shared() would have to
be called on the page.

Shall we continue to have the uptodate flag mean "prepared for guest
use" (whether prepared for shared or private use)?

Then we can have another enum to request a zeroed page (which will have
no accompanying page flag)? Or could we remove the zeroing feature,
since it was meant to be handled by trusted hypervisor or hardware in
the first place? It was listed as a TODO before being removed in [2].

I like the idea of having flags to control what is done to the page,
perhaps removing the page from the direct map could be yet another enum.

> +
> +struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags);
> +struct file *guest_memfd_alloc(const char *name,
> +			       const struct guest_memfd_operations *ops,
> +			       loff_t size, unsigned long flags);
> +bool is_guest_memfd(struct file *file, const struct guest_memfd_operations *ops);
> +
> +#endif

> <snip>

[1] https://lore.kernel.org/all/20240726185157.72821-15-pbonzini@redhat.com/
[2] https://lore.kernel.org/all/20240726185157.72821-8-pbonzini@redhat.com/

