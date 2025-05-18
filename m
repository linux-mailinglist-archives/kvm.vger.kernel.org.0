Return-Path: <kvm+bounces-46941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF08CABB184
	for <lists+kvm@lfdr.de>; Sun, 18 May 2025 22:11:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45AFA18947F3
	for <lists+kvm@lfdr.de>; Sun, 18 May 2025 20:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC921FDE14;
	Sun, 18 May 2025 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MkYBZt6k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90A11EB18A
	for <kvm@vger.kernel.org>; Sun, 18 May 2025 20:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747599058; cv=none; b=s4J5JTwsv8HCMLKgCgCh7JmiQMBDLM3gB8GNvhRzlEddld3GShzACdf/jzWLmqjvZz6o3USXD9WyRAgKGTpfrW9JtcT0+XQqvMsdPwP6Bd2uUFMnvw6M9B5L5oGzH4tBXROy7IAtAUT471hTOC0TM5TUBas3L6pvvRBcndc4CUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747599058; c=relaxed/simple;
	bh=BZghFxnzXNSsmGXc+tWUOfKJ3tXV3mjjGNZeuOUUjHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLIZ6kUbLS43g7X0fSOqE9S4bWLTgvraGGTGyKX2EJNA36kNNIteCI8dEVRAP4NY2gvRs16TZe+u6y2GTPhnTTzhDQvp7VkR95qrdXkAcoYZlfxy6/+4HJiUhsz6yA5YwNoDsOkqvqjcx7EzN2N9MCL++R6BmfCOMubApBQzF7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MkYBZt6k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747599053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3OJIBHhQbvH4C7u2Xf44+7JcPKOKfrafXSUikraTic=;
	b=MkYBZt6kh8zX2DOq93FdRGfgaaTnZvLEJ8uhlCkuOK72tksb2vWzs731E/Lj+4lY4jLCFO
	qifwpD81rwD9x5c3bjoVtZDH/D5f2CrRYWBPgOXIZoxU/djHGjfqXjdEr4/o6bscllIJxd
	qUGEaJRr1RTABNKoSUSSUTc95/Cvizc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-nl4sGyM7NhqRK8sESXg1aw-1; Sun, 18 May 2025 16:10:52 -0400
X-MC-Unique: nl4sGyM7NhqRK8sESXg1aw-1
X-Mimecast-MFC-AGG-ID: nl4sGyM7NhqRK8sESXg1aw_1747599051
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43eed325461so21107295e9.3
        for <kvm@vger.kernel.org>; Sun, 18 May 2025 13:10:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747599051; x=1748203851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o3OJIBHhQbvH4C7u2Xf44+7JcPKOKfrafXSUikraTic=;
        b=vKzg6QA68bx91TQD9J1rUur6r80FWiTkF5EqPFWlw4WZQYrLl+JB3/vAVuxc0qiIxK
         WjlUhg5/ek9I4pBhHBHhX3Cq3lx7NymcayquQOKr4cjxgOYCYGrIohHITkfHnLHia2Rc
         WdglZcuv7y05aKybIXqjprdJSO0Wg7+JCGAiL2GuNujBbhGAsXIy+DfXLp/sorqZqmG3
         eoS2uqY7m4yhAxTOiv1fR7hi8tArI+cKj6ytYzgsgmcsIbAozORr1rYmBIGLjBkGM+QL
         RhEy3QipZdVmgR2iYRuKTCEP7S3niZlq7rW908MCYyWoDfXq1fNEgO3hcrp3u9dVsjhu
         shnA==
X-Forwarded-Encrypted: i=1; AJvYcCVzooxAldegSpVKoQmsZ9VLQouhCQTfGivwc9merPuJaKHDBneqLwuiLBQeufxxMb9CH1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWXHQxhE4gRTSds2c7mXRwZk06iK+EeLI7zGyBymZsrSEeeq4g
	K4CeH066OsBW7b0gqNi0pN3XF7XtDL93VFP31vil4BHa3RhCHTY3GHDAimNo+cfwuCsPhgYtK11
	+mo3SXwhTEvYrLICdpoug2KQKpA6ynoJsILfClRyMtosIip5CxYAVQg==
X-Gm-Gg: ASbGnctm3ukDrsmUiYpxFDi4HmKlYBkdDVBtj/W1WWSMXZ6uP/IEkp0ACC1DKRwFV4H
	qEXKFjSnEp54T0xWH2b9ZefCpuTtNVoXsGESbPqfuSrhC9Tth3lkhSFzE0NVilw9N5+0X5wNLOJ
	fE87P1+rvi52sSFVJOnktNm2TZsqL+1S4k1VDpDW9Nkct6+ktGp/V/uDuLur6n4KofzCZQd1eS4
	+SksyMVeDqivT4yd2sgq7FpTIiaQ436Xi/WBR3M/T+e71YfsWX1eAWkxdRfVtl1kc5Pb+Jqz1ki
	1asEVw==
X-Received: by 2002:a05:600c:3c82:b0:43d:7588:667b with SMTP id 5b1f17b1804b1-445229b42b7mr37633445e9.10.1747599050883;
        Sun, 18 May 2025 13:10:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9jnPJWyH4uHKeXx423hSexRvEamch9ljSyzfnly8GcWhHz5Jv8eYgLruUdeBR+mLa1dJkMw==
X-Received: by 2002:a05:600c:3c82:b0:43d:7588:667b with SMTP id 5b1f17b1804b1-445229b42b7mr37633235e9.10.1747599050463;
        Sun, 18 May 2025 13:10:50 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f3951854sm183062725e9.24.2025.05.18.13.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 May 2025 13:10:49 -0700 (PDT)
Date: Sun, 18 May 2025 16:10:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	David Matlack <dmatlack@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yong He <alexyonghe@tencent.com>
Subject: Re: [PATCH v2 0/8] irqbypass: Cleanups and a perf improvement
Message-ID: <20250518161024-mutt-send-email-mst@kernel.org>
References: <20250516230734.2564775-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>

On Fri, May 16, 2025 at 04:07:26PM -0700, Sean Christopherson wrote:
> The two primary goals of this series are to make the irqbypass concept
> easier to understand, and to address the terrible performance that can
> result from using a list to track connections.
> 
> For the first goal, track the producer/consumer "tokens" as eventfd context
> pointers instead of opaque "void *".  Supporting arbitrary token types was
> dead infrastructure when it was added 10 years ago, and nothing has changed
> since.  Taking an opaque token makes a very simple concept (device signals
> eventfd; KVM listens to eventfd) unnecessarily difficult to understand.
> 
> Burying that simple behind a layer of obfuscation also makes the overall
> code more brittle, as callers can pass in literally anything. I.e. passing
> in a token that will never be paired would go unnoticed.
> 
> For the performance issue, use an xarray.  I'm definitely not wedded to an
> xarray, but IMO it doesn't add meaningful complexity (even requires less
> code), and pretty much Just Works.  Like tried this a while back[1], but
> the implementation had undesirable behavior changes and stalled out.
> 
> Note, I want to do more aggressive cleanups of irqbypass at some point,
> e.g. not reporting an error to userspace if connect() fails is awful
> behavior for environments that want/need irqbypass to always work.  And
> KVM shold probably have a KVM_IRQFD_FLAG_NO_IRQBYPASS if a VM is never going
> to use device posted interrupts.  But those are future problems.
> 
> v2:
>  - Collect reviews. [Kevin, Michael]
>  - Track the pointer as "struct eventfd_ctx *eventfd" instead of "void *token".
>    [Alex]
>  - Fix typos and stale comments. [Kevin, Binbin]
>  - Use "trigger" instead of the null token/eventfd pointer on failure in
>    vfio_msi_set_vector_signal(). [Kevin]
>  - Drop a redundant "tmp == consumer" check from patch 3. [Kevin]
>  - Require producers to pass in the line IRQ number.


VDPA bits:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> v1: https://lore.kernel.org/all/20250404211449.1443336-1-seanjc@google.com
> 
> [1] https://lore.kernel.org/all/20230801115646.33990-1-likexu@tencent.com
> [2] https://lore.kernel.org/all/20250401161804.842968-1-seanjc@google.com
> 
> Sean Christopherson (8):
>   irqbypass: Drop pointless and misleading THIS_MODULE get/put
>   irqbypass: Drop superfluous might_sleep() annotations
>   irqbypass: Take ownership of producer/consumer token tracking
>   irqbypass: Explicitly track producer and consumer bindings
>   irqbypass: Use paired consumer/producer to disconnect during
>     unregister
>   irqbypass: Use guard(mutex) in lieu of manual lock+unlock
>   irqbypass: Use xarray to track producers and consumers
>   irqbypass: Require producers to pass in Linux IRQ number during
>     registration
> 
>  arch/x86/kvm/x86.c                |   4 +-
>  drivers/vfio/pci/vfio_pci_intrs.c |  10 +-
>  drivers/vhost/vdpa.c              |  10 +-
>  include/linux/irqbypass.h         |  46 ++++----
>  virt/kvm/eventfd.c                |   7 +-
>  virt/lib/irqbypass.c              | 190 +++++++++++-------------------
>  6 files changed, 107 insertions(+), 160 deletions(-)
> 
> 
> base-commit: 7ef51a41466bc846ad794d505e2e34ff97157f7f
> -- 
> 2.49.0.1112.g889b7c5bd8-goog


