Return-Path: <kvm+bounces-25257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4CF8962A19
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:25:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DD0A285842
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451BA189512;
	Wed, 28 Aug 2024 14:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OtGOxm54"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBF82D600
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855130; cv=none; b=W6yQPbAyfB6bjhg+1B2NeW41owovHXpY7t6gMPgJkbuSe7xDL9PYjOp5BoEDkuhvzmzO4w59j1m/G5M7b80mzd+VPLfrLQ0LsRwBL3HqRYiwz1khzZOwK8SF3j8FPvZTnKG90GUP384PbCJg/5Na3f+b+7nZPL9Mi1sJTBEjp7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855130; c=relaxed/simple;
	bh=5OV5I8EAvjcw59+MdOsPShmRZQTALAIUu+vDJQFWwVQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JAM+4LE87TfPCubmU4JQzrSV3VwkWdnstVhT1i97DHIGPcsfzXdNIxb/kvnefLqbaTDEr6+gp4JPJZHaiOmP3Upz2GZnR2ucCYjpTisUdee0HwxihwHWPmLdMZcyqGYFEaV0TJ61qhXFAk7eF0K6CWgszilGNFnjqp4Ux2ORRj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OtGOxm54; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d3c9a5c673so6643281a91.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 07:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724855128; x=1725459928; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5aV2pEkEmcmotOLMl1kO7HOygVc5jULiwcJ3HQpHR/I=;
        b=OtGOxm5412+6OvsncGttKEUGrPsDTGTVP1x0dsvoXwmhvpCjSb8sUsbDoKy3ENeMf6
         pEuggbWqbSHEp58FLJyVhEdJE5UuGc9TFsg1F80UAnq4a65gnPW4RrgNDWMb41Nfufzx
         CVse4JbbHDwKCW4zt42WuS7HcT2pjPSqlLfWaIG2tYq7n2ZXdfLqA5HRFygpXWz4iZZe
         I0dxV7PWOBose4jMceLAHIiRf/H3Bk5CGEFZDrUXkXBurC1GbqxIM9lKHuDIGcgnBsy2
         PaAo0dwpCss4H4CwyY7f0kbNQjSYsVJPphQ+j6LCnv1GiyU8CrS+7tbpyFB6XHMKOqoU
         PnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724855128; x=1725459928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5aV2pEkEmcmotOLMl1kO7HOygVc5jULiwcJ3HQpHR/I=;
        b=nC9I09wBUmA5hVtKK6HzcfYqwz1cxxbeTOfnfigyPh4LXWbySRcVG6FlVdfES3Mkjn
         KnhSHHth5M90wQCcVbGXsmjrMrBuDJlo1LTXr5uNQjvhdG1OZzXsaWOmTJWnaPreVnZM
         uSH0zgva5MPh1faRN24SZ0/R9hgLdLwnMlVbURxAip0iwy9Fld9tZNkzeO6G3Jh29Rm3
         80zhO/GpsLsmpQenojrPy/SiomQIsP8tZMOatz2/wtKIzg2jgufxQRpRsL3UhL/DmB9a
         ok3nrq6NPkqe8eaBQq9hcyHcD+Btqtq9ek3lwKzVty1E3cNQ33OqBEEhjENkXoeUkCK0
         rSOQ==
X-Gm-Message-State: AOJu0YzQSbfuWXkqCWsYKmT5rBUD4l1W2FWg5iTKZu3rUrYev/rGn5DO
	7u6yvVuedMj4yJSsG6YHWuUkVAK5LrOtOeLzfYU/17U32Txs3WD0Yykf7nYey0P74knFLZMTNBe
	2Eg==
X-Google-Smtp-Source: AGHT+IH7HV05EY9i+PKNU2bPYOrbNHlyhYm7y0kmHSmEOAi2u7uNUNSpXyT+SZ8OgZFp4Pi43qwVQPWCdZw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4dca:b0:2d3:b41f:ec6d with SMTP id
 98e67ed59e1d1-2d8441a9d04mr4955a91.4.1724855127932; Wed, 28 Aug 2024 07:25:27
 -0700 (PDT)
Date: Wed, 28 Aug 2024 07:25:26 -0700
In-Reply-To: <20240820133333.1724191-3-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820133333.1724191-1-ilstam@amazon.com> <20240820133333.1724191-3-ilstam@amazon.com>
Message-ID: <Zs8yV4M0e4nZSdni@google.com>
Subject: Re: [PATCH v3 2/6] KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
From: Sean Christopherson <seanjc@google.com>
To: Ilias Stamatis <ilstam@amazon.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk, nh-open-source@amazon.com, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 20, 2024, Ilias Stamatis wrote:
> The current MMIO coalescing design has a few drawbacks which limit its
> usefulness. Currently all coalesced MMIO zones use the same ring buffer.
> That means that upon a userspace exit we have to handle potentially
> unrelated MMIO writes synchronously. And a VM-wide lock needs to be
> taken in the kernel when an MMIO exit occurs.
> 
> Additionally, there is no direct way for userspace to be notified about
> coalesced MMIO writes. If the next MMIO exit to userspace is when the
> ring buffer has filled then a substantial (and unbounded) amount of time
> may have passed since the first coalesced MMIO.
> 
> Add a KVM_CREATE_COALESCED_MMIO_BUFFER ioctl to KVM. This ioctl simply

Why allocate the buffer in KVM?  It allows reusing coalesced_mmio_write() without
needing {get,put}_user() or any form of kmap(), but it adds complexity (quite a
bit in fact) to KVM and inherits many of the restrictions and warts of the existing
coalesced I/O implementation.

E.g. the size of the ring buffer is "fixed", yet variable based on the host kernel
page size.

Why not go with a BYOB model?  E.g. so that userspace can explicitly define the
buffer size to best fit the properties of the I/O range, and to avoid additional
complexity in KVM.

> returns a file descriptor to the caller but does not allocate a ring
> buffer. Userspace can then pass this fd to mmap() to actually allocate a
> buffer and map it to its address space.
> 
> Subsequent patches will allow userspace to:
> 
> - Associate the fd with a coalescing zone when registering it so that
>   writes to that zone are accumulated in that specific ring buffer
>   rather than the VM-wide one.
> - Poll for MMIO writes using this fd.

Why?  I get the desire for a doorbell, but KVM already supports "fast" I/O for
doorbells.  The only use case I can think of is where the doorbell sits in the
same region as the data payload, but that essentially just saves an entry in
KVM's MMIO bus (or I suppose two entries if the doorbell is in the middle of
the region).

> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> Reviewed-by: Paul Durrant <paul@xen.org>
> ---

...


> +static void coalesced_mmio_buffer_vma_close(struct vm_area_struct *vma)
> +{
> +	struct kvm_coalesced_mmio_buffer_dev *dev = vma->vm_private_data;
> +
> +	spin_lock(&dev->ring_lock);
> +
> +	vfree(dev->ring);
> +	dev->ring = NULL;
> +
> +	spin_unlock(&dev->ring_lock);

I doubt this is correct.  I don't see VM_DONTCOPY, and so userspace can create a
second (or more) VMA by forking, and then KVM will hit a UAF if any of the VMAs
is closed.

> +}
> +
> +static const struct vm_operations_struct coalesced_mmio_buffer_vm_ops = {
> +	.close = coalesced_mmio_buffer_vma_close,
> +};
> +
> +static int coalesced_mmio_buffer_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct kvm_coalesced_mmio_buffer_dev *dev = file->private_data;
> +	unsigned long pfn;
> +	int ret = 0;
> +
> +	spin_lock(&dev->ring_lock);
> +
> +	if (dev->ring) {

Restricting userspace to a single mmap() is a very bizarre restriction.

> +		ret = -EBUSY;
> +		goto out_unlock;
> +	}

