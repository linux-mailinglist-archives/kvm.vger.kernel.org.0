Return-Path: <kvm+bounces-14917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C5D98A79F1
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 02:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6596DB2147E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51545EBB;
	Wed, 17 Apr 2024 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MBSL+D/0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AEA364
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 00:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713314473; cv=none; b=D72P64n7beIMOTVIGS/uQAbdJop65DzENLFPVL+DCSOzCnS9Nhw/YUDlWqXc+2dVGhfkzuRC5zTIM3+tZ9U/LOMteHJ3PZ/W+H6iW1Jl+k/kxZuYZ4EZW0MF3V/Lg1AOQuysgf43Ufa32i1D9F/UzPiOHUsVb9MbWcRN/KrS764=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713314473; c=relaxed/simple;
	bh=zvD4XMdGTzFY0Wym9GpZCUT0mTRBCcf3hzycyqsbzCY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KOj4o807vfEGvEbodWN32aJaRQ6o2CXLrjM0jci+JfNg9vI0Dbhztx/oKzRX8vwx/v60X73F9vbG10oPG1HwOMYHkgIwRxVguNKJCt+2MKWt8GLIhbN4kfxl9NkDIuabZdZ87RPoNHk5RpKGvwSZ8qrwlURHqecEC+VguTmxcLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MBSL+D/0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a4b48d7a19so234108a91.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713314471; x=1713919271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xsd2FsNYrExxge3t8q+jEIhidNdHyk8FEItAsJ0XUOo=;
        b=MBSL+D/03Z17yEnR6uTzeH6hw9OqjWeWNVmkpOdfKkqHHmuimN/zCQv4TwjIol6nkY
         dNbqssCHQ5zIRbmsPpCfFiwpmSLQrntlbIO7JMuhMvCHPVj7Jr5cM89f8q1iVBO5Z+W6
         CjIUgVDgFGviEZytBpJiXZt+YXINme0KcYB0rsxcsjd+qYdZ43QCzW37X+u/k7///trk
         6vqYaChENzQJqdGJrCyIReOOGhofeFR0aBJSXzome9d8fxK4NRLm5vK7Fve0iUR1NaV6
         EKbB62JtYn0pxSJ20+gIVoiHk8VzJnVitWYheMrQREnkpo1IN/OFwRucIOW++Mq12dLT
         uAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713314471; x=1713919271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xsd2FsNYrExxge3t8q+jEIhidNdHyk8FEItAsJ0XUOo=;
        b=i9ZYrJix7sscKbVYpSHl0R/ZDoAflcdR0EoaaPBkJFpt+C44yJMloZint2qYcXssR6
         I8yqjh5tTnFjSlFFYRWx01wAh82XHoQNW/z+4dm1Yg+XtAV4J8VbEL3LqFvihxhURHsW
         JzI6RBq9jX5G9HjlVd8z+JjomHgdv87r8DFu8NbmvIWSR8LCHlr/9JlV7KbPrhYeJzey
         CEA8wzIrlXaYwZVYdVcrgSsCu5lhkqmnG9clL1G2yHOICwKj7VK63xZ1sqP/PCLgkGZM
         98JbGcrK5cV7xz76lsEwKxf0dronADZVWwzwFvJQv2N5L7hGmpLx83DkNZN0RbR3FRYQ
         tBLg==
X-Gm-Message-State: AOJu0Ywo+xD5RVtAQSskbHSKqvaMdV/mfLJXYMfBzQK5oRWJ4Hm4azJG
	Zt7TndFXyqARCwJNKXjiZYkIPZODIR0ZiKGvYZU/pAkUmAmejGM5toK/c01mz/1lVdBBOGd8E09
	B7w==
X-Google-Smtp-Source: AGHT+IFq1gDvPYY8ymsQjmyAfQZkOKYaHVR9royRVZPhqq+SmgF9D/N7aBkyaE+/yEqqmMSivsChBS4uIBo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:bd8d:b0:2a4:2d22:6721 with SMTP id
 z13-20020a17090abd8d00b002a42d226721mr30200pjr.2.1713314471395; Tue, 16 Apr
 2024 17:41:11 -0700 (PDT)
Date: Tue, 16 Apr 2024 17:41:10 -0700
In-Reply-To: <20240404232651.1645176-1-venkateshs@chromium.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404232651.1645176-1-venkateshs@chromium.org>
Message-ID: <Zh8aphM4dbC8DFIa@google.com>
Subject: Re: [PATCH] KVM: Remove kvm_make_all_cpus_request_except
From: Sean Christopherson <seanjc@google.com>
To: Venkatesh Srinivas <venkateshs@chromium.org>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 04, 2024, Venkatesh Srinivas wrote:
> except argument was not used.

Please write changelogs with a bit more verbosity.  This one is easy enough to
fixup when applying, but for the future...

> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> ---
>  include/linux/kvm_host.h |  2 --
>  virt/kvm/kvm_main.c      | 10 +---------
>  2 files changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9807ea98b568..5483a6af82a5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -193,8 +193,6 @@ static inline bool is_error_page(struct page *page)
>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>  				 unsigned long *vcpu_bitmap);
>  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
> -bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
> -				      struct kvm_vcpu *except);
>  
>  #define KVM_USERSPACE_IRQ_SOURCE_ID		0
>  #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d1fd9cb5d037..53351febb813 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -311,8 +311,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>  	return called;
>  }
>  
> -bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
> -				      struct kvm_vcpu *except)
> +bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct cpumask *cpus;
> @@ -326,8 +325,6 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
>  	cpumask_clear(cpus);
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {

Nit, curly braces are no longer necessary (also can fixup when applying).

> -		if (vcpu == except)
> -			continue;
>  		kvm_make_vcpu_request(vcpu, req, cpus, me);
>  	}
>  
> @@ -336,11 +333,6 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
>  
>  	return called;
>  }
> -
> -bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
> -{
> -	return kvm_make_all_cpus_request_except(kvm, req, NULL);
> -}
>  EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
>  
>  void kvm_flush_remote_tlbs(struct kvm *kvm)
> -- 
> 2.44.0.478.gd926399ef9-goog
> 

