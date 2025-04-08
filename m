Return-Path: <kvm+bounces-42928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33CDDA80361
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 248B13A52F7
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 11:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59800267B89;
	Tue,  8 Apr 2025 11:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VgOuMwfE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486EC227BA4
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 11:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112989; cv=none; b=BEINt4tjYVHDp9MYybUZIFXOOGBx6VxeMII/Nq2xkP0IiQei7pE6JHO/UTmlyx8VN0n09PC0um/zAOqd0aF7TX2FL7e35d9ZAGpWct6GuEzKjqQmYrKMZvRzJilh9zeDLeFq6wxHKkykGZPHhsOM5yakzT2pzrx7X/Ia1r++g48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112989; c=relaxed/simple;
	bh=juga/NFhbOp5HXMYDZ5mhk5mcegQzBe3II+n7ob2+yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNG7phjhogLwRUn4p+8wO+8ggbBp2gALuXWttClJ/ljdmWyAHfHH5Q71Zxk04ELCHOYoflsJHS5HX8Xqk0Wa1qqQ5L9oBr4lhnH8ohF8sI77K50iAEum7sNRjGfc4vyoNoWlxjNTAC9E5qJp66tAffyc2pkSnmJbIO3OhaxKwvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VgOuMwfE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744112986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y007czW7nolro/BBbr+wWrRJwbjuQk2oO7pcjblsRYQ=;
	b=VgOuMwfE5w6Ft2eRlrtDqgN0SazOWA2GPNZwwsbJoXuoLlLQMB/IOiMKs/JVpsUFIe9uu+
	uZmzOJUM8mTY4dhjq8b8HOUhjuzogKFoKqYdxqH1Zbpf84uhCZ0oh01CuTdtN4Lub/fAIF
	UT++38Dgr7yoerc6c2+I5LjCaB3M0MA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-_Vl9pOyZNa24GCj6DNC9Kg-1; Tue, 08 Apr 2025 07:49:44 -0400
X-MC-Unique: _Vl9pOyZNa24GCj6DNC9Kg-1
X-Mimecast-MFC-AGG-ID: _Vl9pOyZNa24GCj6DNC9Kg_1744112984
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43eed325461so15169725e9.3
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 04:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744112983; x=1744717783;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y007czW7nolro/BBbr+wWrRJwbjuQk2oO7pcjblsRYQ=;
        b=BfERB67K7LP6RprYFTHQXSQ6NS8lSJSA0upvRaY0TiOow/eqH3hRJATRDLA7mVbj2p
         0NR1g4TMSN+aJbFCOf3IvP/+kaKVBO5r3PKYq0XkL0d3QmZZ7G8ojnSFumJZF3Nvz376
         /pf9gGNGlS7g9hU2Mc1YoydmtkKcCyaqIbE40fmai8PL+i6fXDJvRsUf5EYvAVuj7xKy
         Uhly/3ShsgL6sSHfKYNhJRq1vvBPkShq0AuPJDc/0HJmUnjrZ5F7h8EKfrNKlsw61BRc
         EFfLDWgpRo//HWwvn8kdo3P1QNQw2EN6/MFqnx54HED/kyPsJ+2Q1j0RgEBRWTXphVRy
         hhgw==
X-Forwarded-Encrypted: i=1; AJvYcCX20GYFLfDJ+Mw5HGwBGtil7YyY1S2Qf+fMCnVfZwuLhi5S4bwJEVRzRjv3+GuOzA3fyow=@vger.kernel.org
X-Gm-Message-State: AOJu0YydFbIgBXRJXUbhra3RPXOaoloNTkBkHzJN9MWncuP3/w/NGGpS
	D7wXwziMUjZ0im8lEjoWffzFINX2lO4+VBoLAW9BXUpV1656iIJZE6a0R8ofjLraDCsVFs7W6cK
	ufJWJOf5yRD3eQY5hQu4u+vhIhEUh34ZuHZj2l1CUZ58bXIlp0Q==
X-Gm-Gg: ASbGncvBUc7Ug1a/NSDnBKVp6pvt4v/ieRwPk8qRvGKZ0pkOG0WWz5Z04kK1nnNu6E7
	Kof4Sz2dEDJ65PAUy4dyHGNBSSAK5+ST8Btcg7vKvEhlER2ymIYnIkoqS1JFkvnPHDqfEMA6dWz
	nGU0bcm+lyswDZ+gEnGbr0phPetL//UYTONsjMT3bd1sf/d5u+u7lLE61ZBfUHJzUSyXYh3rihK
	d+zxX8Rm/e4IpnLQhy8fyKf8KqwNsmAZHfxhiKHHhSVbCSJJHfSPanUv8DkOk+UUGUj7QuBnzsT
	jzH6zcs8cQ==
X-Received: by 2002:a05:6000:1a8d:b0:397:8f09:5f6 with SMTP id ffacd0b85a97d-39cba93cd39mr15652806f8f.47.1744112983550;
        Tue, 08 Apr 2025 04:49:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+o1zR3VRcPlBcclW24I6ljtmxJ4Chpl0YFxpgvpmk6R76rTIbQ1hLofb7K+neh4PaWzsX0g==
X-Received: by 2002:a05:6000:1a8d:b0:397:8f09:5f6 with SMTP id ffacd0b85a97d-39cba93cd39mr15652780f8f.47.1744112983180;
        Tue, 08 Apr 2025 04:49:43 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b69c4sm14561074f8f.43.2025.04.08.04.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 04:49:42 -0700 (PDT)
Date: Tue, 8 Apr 2025 07:49:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	David Matlack <dmatlack@google.com>,
	Like Xu <like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Subject: Re: [PATCH 0/7] irqbypass: Cleanups and a perf improvement
Message-ID: <20250408074907-mutt-send-email-mst@kernel.org>
References: <20250404211449.1443336-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404211449.1443336-1-seanjc@google.com>

On Fri, Apr 04, 2025 at 02:14:42PM -0700, Sean Christopherson wrote:
> The two primary goals of this series are to make the irqbypass concept
> easier to understand, and to address the terrible performance that can
> result from using a list to track connections.
> 
> For the first goal, track the producer/consumer "tokens" as eventfd context
> pointers instead of opaque "void *".  Supporting arbitrary token types was
> dead infrastructure when it was added 10 years ago, and nothing has changed
> since.  Taking an opaque token makes a *very* simple concept (device signals
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
> To address the use case where huge numbers of VMs are being created without
> _any_ possibility for irqbypass, KVM should probably add a
> KVM_IRQFD_FLAG_NO_IRQBYPASS flag so that userspace can opt-out on a per-IRQ
> basis.  I already proposed a KVM module param[2] to let userspace disable
> IRQ bypass, but that obviously affects all IRQs in all VMs.  It might
> suffice for most use cases, but I can imagine scenarios where the VMM wants
> to be more selective, e.g. when it *knows* a KVM_IRQFD isn't eligible for
> bypass.  And both of those require userspace changes.
> 
> Note, I want to do more aggressive cleanups of irqbypass at some point,
> e.g. not reporting an error to userspace if connect() fails is *awful*
> behavior for environments that want/need irqbypass to always work.  But
> that's a future problem.
> 
> [1] https://lore.kernel.org/all/20230801115646.33990-1-likexu@tencent.com
> [2] https://lore.kernel.org/all/20250401161804.842968-1-seanjc@google.com

vdpa changes seem minor, so

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> Sean Christopherson (7):
>   irqbypass: Drop pointless and misleading THIS_MODULE get/put
>   irqbypass: Drop superfluous might_sleep() annotations
>   irqbypass: Take ownership of producer/consumer token tracking
>   irqbypass: Explicitly track producer and consumer bindings
>   irqbypass: Use paired consumer/producer to disconnect during
>     unregister
>   irqbypass: Use guard(mutex) in lieu of manual lock+unlock
>   irqbypass: Use xarray to track producers and consumers
> 
>  drivers/vfio/pci/vfio_pci_intrs.c |   5 +-
>  drivers/vhost/vdpa.c              |   4 +-
>  include/linux/irqbypass.h         |  38 +++---
>  virt/kvm/eventfd.c                |   3 +-
>  virt/lib/irqbypass.c              | 185 ++++++++++--------------------
>  5 files changed, 88 insertions(+), 147 deletions(-)
> 
> 
> base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
> -- 
> 2.49.0.504.g3bcea36a83-goog


