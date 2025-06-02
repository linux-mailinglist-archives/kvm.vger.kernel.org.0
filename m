Return-Path: <kvm+bounces-48185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 734C0ACBB49
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 20:55:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10F14175651
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 18:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E5B227E9B;
	Mon,  2 Jun 2025 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XVULdCes"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2421FDA6D
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 18:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748890490; cv=none; b=KVOyeWzTOCRVgc3UJy0SlU90aiq95rD/gByTyIR/xPhFzMr8Rzb89KqUh349MWcxOSP2GvQ66Hhn4H5wrK4mrNb2UkxWa1Z0y9usWuleHZ43402ztT8Mwc41aqSw7Psk8xsBv2X2JLFPOjPm1qNacPzd/EzubZ7M+cLDCvrounE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748890490; c=relaxed/simple;
	bh=ADW9xya+1oa2cmviacIcm+dB4kYEr+YRKtM/wxWuyc4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0hPsJoG7kGz/7cLEb3ckrQhGB4B3+My5bC+jQqsSAYRHuVaXGAa9vx9EDSFdfSFOIUV0dKNhe0csLWoklWJLdBXJb9A0t0AAR5/jmLfmdEmDsudugHxiKUXf2AmKi1uyLluI41L8RLV6iLen346iJOYkjMJhKDaFYlrrWC0TWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XVULdCes; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748890487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6C/P1ic66cDx0vo/JBziwVz7kRWsMBGoIIf4HEtYsGQ=;
	b=XVULdCesiDBOHgkMpNnXAJTBQlmj67y+PwfAapVb4Hqb9s7FLcyQyBYHYG/EgTe2XGmUo7
	jj+aNFBTfzORiT6KO6Inacia4KS+k91IE/ae6llLVVuwq+1brw3vPPbG/cuO3K5kdT/Mt1
	k8yjlWeSRm1IAKZXyzsUVtT7UY5fnxE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-xoaV8K8ZNy6YzzgI-K06-A-1; Mon, 02 Jun 2025 14:54:46 -0400
X-MC-Unique: xoaV8K8ZNy6YzzgI-K06-A-1
X-Mimecast-MFC-AGG-ID: xoaV8K8ZNy6YzzgI-K06-A_1748890485
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-86cf7803786so21254539f.1
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 11:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748890485; x=1749495285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6C/P1ic66cDx0vo/JBziwVz7kRWsMBGoIIf4HEtYsGQ=;
        b=t8rVEUuAB4Faekx5aa+bvE3sTBVvG2PVmiroKIAS8yiI7jY41T7fQ4JmbXpab/K+tN
         Zp+AsJJOAo2+nTVIW/BZGBQZKoSpkCovCQa3aC618k8ogKkM3CUVYHsUK2WPj+TTwkSz
         NayNHYwu7gyM1cH4ANkuJSzOgWiaSIiwarWXWWgfLZ/E21xP0a1JdZ+/yCTH0IYFHoJw
         SDcGEdU+GB7pyFNaLiv4d8c8Gp9eftrud6xM7GpzkC6HXq0K4Vp/ljq9VFpVHoyLmcb8
         umhnZgYNQoLbNmCF71vxw/i6tuBbTk84bmlHa0Gibgn0IPhKq99n5j24ezz2tClgF4Vy
         Apzg==
X-Forwarded-Encrypted: i=1; AJvYcCXs6pjydYv+AH7vvk7Jkt4uU8wfIXx3Eeef7vZs0Rnn862rwsyNvDd1NjLqmUmHZmatT6w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxse1XfkXYET4JLhE3zcTw2/UlbJUdprSTOjF74c5WOGpcGoHAk
	2bHlkHBkKOU9y4MMtbadqGP2VCK+vFxzW8XD/xQLYCfptxPuRt/k1VYbF6DUL8m30GkbAifLdxe
	1kf/JCFSTq4V0JntMg7Tc03LvNm45GcApVhDMYqM6xE0CVvCALzd/OQ==
X-Gm-Gg: ASbGncttsAV8eZNtpz5Nqq2qjjet0PFcVFclvuqDta7a6pCcJ9BrYtpXafn3eh3ZggI
	82yoZaCRNhWOsGgtr0wu9IhQQhySGwvRQVDczeDZJS6pWRCuJlJMqQnLEiGCbpAb8yxkiSVcLnY
	50y2MMl45RnDWXNQkH/QnT1q+VZ6c8zTg/mj/vRYFHe6Ax2tadwtOo3ildny70FkF5f9LQiLvji
	vO7YVKbnV2VNJKKRxh/mUXpNK2mAsr+OPrWD3ISo2sx02e7VwQD8CwbztfW8HGRCo0rj25Ba0Zv
	b5C/NNfQaCmZAVs=
X-Received: by 2002:a05:6e02:258a:b0:3dd:869e:d1d9 with SMTP id e9e14a558f8ab-3dd9bb04986mr43707945ab.4.1748890485378;
        Mon, 02 Jun 2025 11:54:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDB2BJKvNT8wrVq77BTo5j1RKq7jCh6zygyLgk4tNvo1VWUIo2Syvkw5u3DYlSjqc4/evPNg==
X-Received: by 2002:a05:6e02:258a:b0:3dd:869e:d1d9 with SMTP id e9e14a558f8ab-3dd9bb04986mr43707735ab.4.1748890484945;
        Mon, 02 Jun 2025 11:54:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd93534293sm23059685ab.13.2025.06.02.11.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 11:54:44 -0700 (PDT)
Date: Mon, 2 Jun 2025 12:54:42 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>, Oliver
 Upton <oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like
 Xu <like.xu.linux@gmail.com>, Binbin Wu <binbin.wu@linux.intel.com>, Yong
 He <alexyonghe@tencent.com>
Subject: Re: [PATCH v2 0/8] irqbypass: Cleanups and a perf improvement
Message-ID: <20250602125442.19d41098.alex.williamson@redhat.com>
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>
References: <20250516230734.2564775-1-seanjc@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 May 2025 16:07:26 -0700
Sean Christopherson <seanjc@google.com> wrote:

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
> 
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

Sorry for the delay.  Do you intend to take this through your trees?

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>


