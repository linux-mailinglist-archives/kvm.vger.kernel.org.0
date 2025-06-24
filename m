Return-Path: <kvm+bounces-50512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E56CAE6B36
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 17:35:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22A2F1C41E25
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B53B2DF3CF;
	Tue, 24 Jun 2025 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IHWnNSXK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4232D660E
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750777912; cv=none; b=PZBp3TeKAuggjWX52hPfITPyFNmWAeGhxGdm+OLBNrR9Nrfcb1p+HnZgT3vXl13u0+SUbOUfmS4mD0b8XUUNOeIoOud6WTK7pTkRK+FH0XeJLMxhyX/knLXe2nxMXtwkDqHtyERhjM0B5mv3UdJ1rld210OrdrBrds4sP5WpSdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750777912; c=relaxed/simple;
	bh=CdAFv/xVUpFnGKJp2gXfaJa/aJLO9CnnuadlnNfNGoM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W2+kMX6AdjZUyDW5ZRBK5eribn94mZvnEc3SzOXiZpaL0415hV62q8VMxt1BrXxGD03DpdzFA+1B9vUIzFijEyncgqp9EvXheXJFO/wxyKu1kXoEJAfyGluvGDTMU6eH4DbFVdfoPnARFJM6iO/sJzlybZXxFwQyRO6GW0dJLpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IHWnNSXK; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2369261224bso64744335ad.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 08:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750777910; x=1751382710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WHKmMEcEYJNjmiM+o7K2OQjNjaHqWv9qs7NUDNHU0tM=;
        b=IHWnNSXKQ+5a44BpWYlhLElb6mQU9gh4QUmqcjGfDW4DYDkO7FUTxVmQL1UvwdQlec
         xGpgaZ+kHhOBh4qT6dQdaA7AilV7ZCju/+voU0nPEfR7txr1MnMCyaASK1J1gyUaaWKk
         7ValI2uG3cZShoRBfSekqz9m+8X87ZJyc7NzobgJhdD8V/NA8A1bFWmOmKIIzGlvsM1o
         28PDfet/HJk+q7e2zjgEX56B4mjPk22qSVBFHLiZcvXGn23X2G4kE0Jm1P5Z/hwe98ri
         uW1gCR5JljJwh5H9O/KrhDD9/V9dg1hu9g550pOU5Lh/iS26+tdRkgUU9JAA96yTZzcA
         rGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750777910; x=1751382710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WHKmMEcEYJNjmiM+o7K2OQjNjaHqWv9qs7NUDNHU0tM=;
        b=rXXs3osH8JDqPdRoaXHMssiYBH+LwS5ESQwl1kZohsebIAHhFe2lipAIP5IGNsURKA
         xiF7bu9TbOqitFlzm4ohijFRRG57pWJq/WxjbxXgGUh8VJwk26eeDCIrpYK58OhFYjat
         RzJJ6TElHFCyB2y2tB64ql8YDJg1wmaSKhsWXWgr46fB9J4u+JW2SNnWkdhoA35JZyiP
         fcoek2+0H4s4AFD8BPLGbgO5JnBI5VhQlL+ZCRNpdeiS+9IYL23KY0KE86PgmIRhd81i
         VeNkaAqS3KNeLf7vktqwwT1NBgkDJkmJgfI9QWpsytEn/IGXuhmwhEPgL8mYT1AEQmGB
         t/QA==
X-Forwarded-Encrypted: i=1; AJvYcCUpOG2yg0Ku1phVnwbwSd+J7zbz7bZPgwUB4QKLqVIg0RvSfYDYFx4ija/iliIkWzXhqtM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEPhGB96KF4QNrkEzRJYjRMDDudRllETsUAtZ4vR4Lxap2pi9K
	EtdXhjdlCwRppMSgWVq1eilzQSWpqB5prQJ2xHPUp0QZonkBTUR3RQBYsDf6wkR0n7ikdwHQuYQ
	C0DuabA==
X-Google-Smtp-Source: AGHT+IGIcs7zWWGHBq54IJpoK0NjWgqGqhr9KSussfq3VS+c6BJCA+ru+8d4BCqJ7jSWww4QOGTH7M3EVhE=
X-Received: from plbkr7.prod.google.com ([2002:a17:903:807:b0:234:8ec2:bf02])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f68e:b0:22e:3c2:d477
 with SMTP id d9443c01a7336-237d9917bafmr230431315ad.25.1750777910502; Tue, 24
 Jun 2025 08:11:50 -0700 (PDT)
Date: Tue, 24 Jun 2025 08:11:49 -0700
In-Reply-To: <20250624092256.1105524-4-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250624092256.1105524-1-keirf@google.com> <20250624092256.1105524-4-keirf@google.com>
Message-ID: <aFrANSe6fJOfMpOC@google.com>
Subject: Re: [PATCH 3/3] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
From: Sean Christopherson <seanjc@google.com>
To: Keir Fraser <keirf@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="us-ascii"

+Li

On Tue, Jun 24, 2025, Keir Fraser wrote:
> Device MMIO registration may happen quite frequently during VM boot,
> and the SRCU synchronization each time has a measurable effect
> on VM startup time. In our experiments it can account for around 25%
> of a VM's startup time.
> 
> Replace the synchronization with a deferred free of the old kvm_io_bus
> structure.
> 
> Signed-off-by: Keir Fraser <keirf@google.com>
> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 10 ++++++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3bde4fb5c6aa..28a63f1ad314 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -205,6 +205,7 @@ struct kvm_io_range {
>  struct kvm_io_bus {
>  	int dev_count;
>  	int ioeventfd_count;
> +	struct rcu_head rcu;
>  	struct kvm_io_range range[];
>  };
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index eec82775c5bf..b7d4da8ba0b2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5924,6 +5924,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>  }
>  EXPORT_SYMBOL_GPL(kvm_io_bus_read);
>  
> +static void __free_bus(struct rcu_head *rcu)
> +{
> +	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
> +
> +	kfree(bus);
> +}
> +
>  int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  			    int len, struct kvm_io_device *dev)
>  {
> @@ -5962,8 +5969,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  	memcpy(new_bus->range + i + 1, bus->range + i,
>  		(bus->dev_count - i) * sizeof(struct kvm_io_range));
>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> -	synchronize_srcu_expedited(&kvm->srcu);
> -	kfree(bus);
> +	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);

I'm 99% certain this will break ABI.  KVM needs to ensure all readers are guaranteed
to see the new device prior to returning to userspace.  I'm quite confident there
are other flows that rely on the synchronization, the vGIC case is simply the one
that's documented.

https://lore.kernel.org/all/aAkAY40UbqzQNr8m@google.com

