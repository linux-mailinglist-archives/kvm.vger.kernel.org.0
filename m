Return-Path: <kvm+bounces-3386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8BA3803A86
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 17:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 599061F2124B
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03282E41C;
	Mon,  4 Dec 2023 16:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ugkvx+DH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5747BAC
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 08:38:19 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d05f027846so16256375ad.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 08:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701707899; x=1702312699; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qDk8VCjkq3XxlHbdv1HgLMD6AIZzaNXkLSxsVVtlfDU=;
        b=ugkvx+DHP4h3V/3/qYu0LuPwb9lAqPV+dulupC0KssmtHBP1Tpaumi3PxrGrbcq9MK
         9weBh3Z259AeuD+nMjPDM5uv7Fbun/MYMp7h3svlIwI19jvBxCFe1HaVVmOPY099BakM
         XzVliDimplLnuHzE7IX3BL8IW6tG0t4w31qHQy9TRQ52GpRSWJOfBndVP99NSqfPDCs2
         PdyXMpm51l4WZEqqZEq1SdXEifBJ18N+ICz/E2DkKDU2iwKmBRYVdYtPqG2WI3UPqVXy
         zbAadWjmTop2y4iYkc7MvUU1tfJ/DUIFpoRHyR256ihxYV01KJGeOzc6n22oHr3cT7eT
         YhmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701707899; x=1702312699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qDk8VCjkq3XxlHbdv1HgLMD6AIZzaNXkLSxsVVtlfDU=;
        b=oQq6/npbceMTJrzySrLXv5f6IsKj9AOTXasi1ijHQqvYg6F9pHIJ76GWcHsryrq0mx
         wigFfcR6zysI6ox3TLaGqnpvKKbm8rRkaivhcI2ippHSAJFQxBvyMjItmGwUqTlrBTFS
         To1kliNbT7UlgrD8Lr8K2qLg5nfphNcHR+X9YWVvjPmbWC6XxWWFHtGyS+zb0oeMZ/mf
         WFFS4nUmvxbqWPeIYIYfqPGyRIhLBupNLd+8W3ekAh2cQ6jc5Q5voD/tUHtNzRpSDg0D
         HWj3jxb+/a5cJ2dQuR8r+UYvXKCu/xwr7GYW6S8rVi7sAuNSmdWDCjJJb1B41sx56Coi
         Ujvw==
X-Gm-Message-State: AOJu0YxMyutao3tZCXjo50O2iw22Z0CBRGSjs+A/HoHdjNkM2PlTaWms
	KMxcaTlvZWtYPFUO6u0bc16VLcS47HY=
X-Google-Smtp-Source: AGHT+IH0KOf6e9SiOq5ykueCM2o/G5wmIdosmf1/SYoTYHBbgp+mKLWEKcRI/yzXpAEsOcbbgjKj2C8Ipoo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8204:b0:1d0:71fc:b39c with SMTP id
 x4-20020a170902820400b001d071fcb39cmr163767pln.3.1701707898848; Mon, 04 Dec
 2023 08:38:18 -0800 (PST)
Date: Mon, 4 Dec 2023 08:38:17 -0800
In-Reply-To: <20231204150800.GD1493156@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202091211.13376-1-yan.y.zhao@intel.com> <20231204150800.GD1493156@nvidia.com>
Message-ID: <ZW4AeZfCYgv6zcy4@google.com>
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com, 
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 04, 2023, Jason Gunthorpe wrote:
> On Sat, Dec 02, 2023 at 05:12:11PM +0800, Yan Zhao wrote:
> > In this series, term "exported" is used in place of "shared" to avoid
> > confusion with terminology "shared EPT" in TDX.
> > 
> > The framework contains 3 main objects:
> > 
> > "KVM TDP FD" object - The interface of KVM to export TDP page tables.
> >                       With this object, KVM allows external components to
> >                       access a TDP page table exported by KVM.
> 
> I don't know much about the internals of kvm, but why have this extra
> user visible piece?

That I don't know, I haven't looked at the gory details of this RFC.

> Isn't there only one "TDP" per kvm fd?

No.  In steady state, with TDP (EPT) enabled and assuming homogeneous capabilities
across all vCPUs, KVM will have 3+ sets of TDP page tables *active* at any given time:

  1. "Normal"
  2. SMM
  3-N. Guest (for L2, i.e. nested, VMs)

The number of possible TDP page tables used for nested VMs is well bounded, but
since devices obviously can't be nested VMs, I won't bother trying to explain the
the various possibilities (nested NPT on AMD is downright ridiculous).

Nested virtualization aside, devices are obviously not capable of running in SMM
and so they all need to use the "normal" page tables.

I highlighted "active" above because if _any_ memslot is deleted, KVM will invalidate
*all* existing page tables and rebuild new page tables as needed.  So over the
lifetime of a VM, KVM could theoretically use an infinite number of page tables.

