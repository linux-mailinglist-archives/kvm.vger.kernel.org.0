Return-Path: <kvm+bounces-66627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 13EA0CDAD01
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:13:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 310AB3019BDE
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19D130F549;
	Tue, 23 Dec 2025 23:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wSCfNvGk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5090227EB9
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766531591; cv=none; b=o7jD+EUtS24qNd+GdZsSIOsx+aKOSWWg2tH13XVu5sZhCvX1rR1zpAkhwJ3d+pfzhm5Nmn0gsBOfg9MAkEG0TVkvgLn31GzjM1YdUBGzyb2Vkm7HNZuQl5vjw6jKLVQMMBAdXOIL/xVti/dFJxPsV4guer33tHffRR7X3MHn5cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766531591; c=relaxed/simple;
	bh=5w5B+VTiwQYahGBulKy2nMzvnVhceVxrwSZU6RxYxOk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=juvB3fdIf/kJlSHVGEe3TipMBzvp0dt7fwGh6WCBHYya1rruuMValRLmovDJ4bwuU3HuZvje8iY7I4n1fQ3j9HgLEUTQXzmUHG1T0Gzw7zY/4nuMEZiJCGf1KP4xC1wfnxQNStfV9W79YktAW3GvdDnWw7Agf8YiHe8qtDtaDdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wSCfNvGk; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7d5564057d0so10818715b3a.0
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 15:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766531589; x=1767136389; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nAjw9xAsX3Up9hZd9vxqQvG59DsVgwu4e5m3aPL20t4=;
        b=wSCfNvGkcgL299MLIeuv9GGif8jAYfXvqa2tvzKto5s/kvdTAUULDLoVIuh2ql+VbX
         nC9+nrflshuHiQ+oGujF59Q5j3FPRIRNnzcxerYuMb0RVjrp+mFvWsPt7BdrjF+bTf0u
         n6/YtOzDjTpKOi+8ZuvbuiGLVz+irlNQCeF2acrk6EHSJVTnyFB5/rB0IcU3SSmS3BUv
         cNOkv3XPDLdNRPmGo1ldZs7RzJewNYOQyVTGCpVlQyL66796s+ctQv6Wm2f17Q+GxdgA
         /8Obt9xuENuHHY+m4uFeBFUIH8PExbLjQ0UQT8KmaH/tp9BVOREp5yVpkiyR1taOVJN+
         x+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766531589; x=1767136389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nAjw9xAsX3Up9hZd9vxqQvG59DsVgwu4e5m3aPL20t4=;
        b=j+wRnCRyX6clFGQ/HX8DpxobnzokN7thZ8rJL4QERUFeaOuVHlzDStel4355zL6q7t
         vFPQkGXGBbx+CARgsDVyR8erocfDLc8vqGs9XVspobmBkRh+hhTqNNfrh+ccNzY8SJb4
         X8xg+eJTSGnAMMzVOyG+neaIEKptX4YNCmFEQvfh0BdWhgSQwThovxJSIdxLYLXCz3Qi
         WSm3hRcwxTM4obJhJ5nBvjW6tRUlyVei7MeIEzXhz2uHrGRKyWDbimDSzOzKEybRee8G
         KvUgNkia+cW5KT1gFDPWCGYDGqpZkedXVYTDxRXM8rxmd963KfLf6QnCpzJbK+4k7kBJ
         LgsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3K4D089wwK2GQtGHg5LAOBYFu3XnhyWnhFfXzFLG3wFezHgUuhCSaK1VECvQi8vGh8G0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw66C3Ag80iD7n5wmbAQgZRtHM286TDWyvJsLK5Lk46A/zTDjxM
	evJp6SjhDT3RUH+UwoW/H7IuCPKya1bIAikvWvN9TJ5RBClGs/fUEwsTHsN73LijllvQvZsK2FA
	3EJShpQ==
X-Google-Smtp-Source: AGHT+IGP22zhOhgzkN1r2AQZwnGHyQl5Jj6jxDY+NIHSobFPuQvY2I25qLFQ63/rRfcOA+OnBa+tucH4R30=
X-Received: from pfij11.prod.google.com ([2002:aa7:800b:0:b0:7b2:129d:2cc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:9a85:0:b0:7f7:5d81:172b
 with SMTP id d2e1a72fcca58-7ff664807a0mr15860071b3a.42.1766531589107; Tue, 23
 Dec 2025 15:13:09 -0800 (PST)
Date: Tue, 23 Dec 2025 15:13:07 -0800
In-Reply-To: <20251127013440.3324671-12-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev> <20251127013440.3324671-12-yosry.ahmed@linux.dev>
Message-ID: <aUsiAzbf85ZHA2Bv@google.com>
Subject: Re: [PATCH v3 11/16] KVM: selftests: Move TDP mapping functions
 outside of vmx.c
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index 8b0e17f8ca37..517a8185eade 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -467,6 +467,77 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  	}
>  }
>  
> +/*
> + * Map a range of TDP guest physical addresses to the VM's physical address
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   nested_paddr - Nested guest physical address to map
> + *   paddr - VM Physical Address
> + *   size - The size of the range to map
> + *   level - The level at which to map the range
> + *
> + * Output Args: None
> + *
> + * Return: None
> + *
> + * Within the VM given by vm, creates a nested guest translation for the
> + * page range starting at nested_paddr to the page range starting at paddr.
> + */

Eh, opportunistically drop this function comment.  If the reader can't figure out
what tdp_map() is doing, a failure generic comment isn't likely to help.

> +void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
> +	       uint64_t size, int level)
> +{

