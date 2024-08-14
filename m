Return-Path: <kvm+bounces-24147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B87951D57
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:38:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E20312856C1
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4893A1BBBDC;
	Wed, 14 Aug 2024 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h6j+Ovcn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1091BB69C
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 14:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646105; cv=none; b=u0SUN6S+bwryKx/3GU1m3L9xnuFQXs3ie2ahX2i7Rp7RzmJbybTOBjWOp+FzaH14/vF+Kjjj2eMpGXFNwUObcj2321BOKz+B+T3sOvCEa8E64rQb8UTXGe6Yh0GJ/1mZL7grc6jwCk7q1Yh0f6c+vNd4rlS3nFFjw8HM0qjhfWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646105; c=relaxed/simple;
	bh=kUgF0cUl3dMj466Jcm5VVUd/sQE57nGiTyxbsxext2w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z3lQNIzbBgP53rzHBcp8XVyaL4KkJHQo5EVTRFxN7FO2ZXvTukpR9h/WKXX/36PNXYBq8wewKuGKi+2GIQmb+SuPNgRZQuopJTRYtHb+PNiJcd/QS22oGAf0/BEOs3UyCnrkIHHKcW7k+Yk81TudveSRrNdFb0da5DtRUq7yylc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h6j+Ovcn; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bbd1ca079so11618272276.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 07:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723646103; x=1724250903; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vZO6m2EPCg+BEClD5O/UaD6XP5dearzPGgfE50iwHdM=;
        b=h6j+Ovcnw8BEQ3WGKLmdwxY7SwAoRxT7IfSsLJMrubpJVDFGvK55tCzuA1YwAg3fbE
         Dw7ZFJQZlrfH9RJy62DsnDOBnbdCtM9Jr4GWqZnMmxmSQKc8aX5PiCrxWgMZMX3fEP0E
         D2pf2h7qx9ct69AXuXmYeJEkGWOutq0GUUMUNXuUMfCR2j31/X/Rue4bk6ujRRdFTbTI
         P4BvpV29qUxxn3+xyeA7wr+8aueDi+DQkRKVb+siBxp674nUy3PcB5ZUgePOg0MnQ03F
         Jt8DJpydVD/4UnofYJ1lnc9nWsN5Hr6ALqytPDBcfdJ7jvOmxFvbYsCCOksAZ7HouNx6
         Lbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723646103; x=1724250903;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZO6m2EPCg+BEClD5O/UaD6XP5dearzPGgfE50iwHdM=;
        b=wyw9S61wY+VHDkFXlWj7kH0zjqwJO27fePc0VBQ0O8qe6srvL61B9V/uitHd3Zvb/o
         75DU49A8nEBoNwhpFVc00E3z+hOy2Y4Wl0iQAYrFIh6lt4xAwLRW8fUxN6/CD0a1H2IL
         EgcFUz47njWG48+M+36+Lnuz5IzgdqYIPGvIMupASoFFHkvhloYlGy4TGjJKDZqCXe76
         BX8GuPv1gSP0xcFwKSux3LIAW4fTrNobZd7o8Rtp+oB6nKf6srz06rn/LK/1PjGCOykr
         DDVaKum+OWPkWA2Xg7CYaxbbL7o/IZm1wI5JrxckVaeT0Sg9DQRQ9ttIxaFa7RQzfdMg
         knUw==
X-Forwarded-Encrypted: i=1; AJvYcCXmYWaEX9Bhy2CUVEntiaUXGevzrTfGmmPuX4+Nv8ROqNDDlSO0lMJgHGUkuU+BzmKT2ho=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr4JTe0WSzrD7lyT8BOzQgZPXlRT8dHv/SB1YwMKqeoLcLSJkp
	EGBjsDYXFLVbgS3qbFy1lJq2IcqnjJm6Bpm2Xk/PBHlsfLPwDQ4Qps7RBQI1xm73brydp5hdlqM
	emg==
X-Google-Smtp-Source: AGHT+IFu38/YQ+6pcEZAPERvSvU9PJFoT7OocvzhIr4N07sxW+6eXQk76yQEUC3C3MeMfUmPczeM3hOUO48=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dc44:0:b0:e11:4401:ee1f with SMTP id
 3f1490d57ef6-e1155baf4d7mr38937276.12.1723646102797; Wed, 14 Aug 2024
 07:35:02 -0700 (PDT)
Date: Wed, 14 Aug 2024 07:35:01 -0700
In-Reply-To: <20240814123715.GB2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240814123715.GB2032816@nvidia.com>
Message-ID: <ZrzAlchCZx0ptSfR@google.com>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Jason Gunthorpe wrote:
> On Fri, Aug 09, 2024 at 12:08:50PM -0400, Peter Xu wrote:
> > Overview
> > ========
> > 
> > This series is based on mm-unstable, commit 98808d08fc0f of Aug 7th latest,
> > plus dax 1g fix [1].  Note that this series should also apply if without
> > the dax 1g fix series, but when without it, mprotect() will trigger similar
> > errors otherwise on PUD mappings.
> > 
> > This series implements huge pfnmaps support for mm in general.  Huge pfnmap
> > allows e.g. VM_PFNMAP vmas to map in either PMD or PUD levels, similar to
> > what we do with dax / thp / hugetlb so far to benefit from TLB hits.  Now
> > we extend that idea to PFN mappings, e.g. PCI MMIO bars where it can grow
> > as large as 8GB or even bigger.
> 
> FWIW, I've started to hear people talk about needing this in the VFIO
> context with VMs.
> 
> vfio/iommufd will reassemble the contiguous range from the 4k PFNs to
> setup the IOMMU, but KVM is not able to do it so reliably.

Heh, KVM should very reliably do the exact opposite, i.e. KVM should never create
a huge page unless the mapping is huge in the primary MMU.  And that's very much
by design, as KVM has no knowledge of what actually resides at a given PFN, and
thus can't determine whether or not its safe to create a huge page if KVM happens
to realize the VM has access to a contiguous range of memory.

