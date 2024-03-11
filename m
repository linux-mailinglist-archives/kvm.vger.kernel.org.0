Return-Path: <kvm+bounces-11578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA496878640
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 18:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 909A21F22F0C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8D64D9E7;
	Mon, 11 Mar 2024 17:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ztfqIqbC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CD94C61C
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710177812; cv=none; b=YwgLHucwNKZqh2FJwSgLhOW1bdKyEQcwAhytsUo3xGSGUSUSB5VlWFZbd20nnLArQpIYR0Ou+oTXQuWie6Lk6k5zTw5AEwG8jPI8MIEx5EwKTdSfBNWjje8JFkz0u03AYarsF5DImU1FFBToBa9dru+4cm8kZJStXy+7BPhgJCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710177812; c=relaxed/simple;
	bh=yZFlhLhcrB6kOYi8DhWwE3UELCDKt6BcqMyQlgjCIUw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g/Y/alRd+qLCoESq1Y7xgl1ebJWWU+PcEELQfQb9IwmoiN5yAvQd/sZHDicYxeZzhiPLzGoMA2QNaRIIRnZWEgG6/inVivF1cvo4jW5FAqlfdgQwq3XuaMu6lHqavZ3QUn4SZJPSyOEfUIKFjNwq4eG3HtrbAIImPGhyTDio5LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ztfqIqbC; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dce775fa8adso7936388276.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710177810; x=1710782610; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/HhEj7VyFIjZW59B2BWeffYMQd7D2SERuY842EgbKa4=;
        b=ztfqIqbCzFZ/pFnoANMPCTO6KTWWGamV1tZz42QEOrkhRWh8G3wxmcTRIHsUrYwqE7
         Lrk9rmExio4sApihshiBZ66l+u0Z+6gVWBLIBSEsDUd0b+mYKPX6hFdbo272SYcxvY6H
         /Ft9lUy+yaHgKOH0fvFh2wH1le/LZx5MwCU880GXCd/D++qWb0I0OL93fpySu/sd2uvo
         vkLDJVYzR/VE6+8Fk8Ac2x7KDNNrPQDnePObTsH0sy1PFFw3Vym+eebj+yWDaTEPXQ+F
         VhcoQi67eYiTp/a0cBsfrDlQSAFEwsmb/9OTIvfy7dNHARU+MP4YV2idanzbB4Mi9brA
         L9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710177810; x=1710782610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/HhEj7VyFIjZW59B2BWeffYMQd7D2SERuY842EgbKa4=;
        b=TegvqZ1mAxGK6AHUPZBcv8MNBz55HVSw7NtmKaUmDtDgVTSynx4kaBIjSvL2bx/mJU
         lztRMMtdxC5Zy9R2h7FsAHL4q4lPcvA2syFzLLEWcz59JyYPf4Bhbo9VmCG31uDwPkPu
         Gn/I4XgGWfPZGSuFJ3MC2c/Uro52hqFP68S8NDn5wKLs7ZsHjgsKyBp+qmTVaxRDfIBc
         VtIBWokkE0ZPXqvGr+dIdXdXxDHYkkkK8btLYCvcn6g4SpeJRrx0H9ihPWu+i02iB33D
         keq7KIC4mPLDLLwwoj+Ouepu+zbogrOagW3fVSV1keRVREkXz+RbYaZ2stKFIWzTwhan
         oKYg==
X-Gm-Message-State: AOJu0Yzby6iWKdB2F1yHiotDZTfURsSA0Z4jI8sKXIU/UxGA6l8t5iBn
	SXdAc8JGEXcuywxi/4eM6jU/7F6qRmx9yteCqC0uXxWY3eIX/DRL1qE+YmSrM5KfDhEwD2wxieK
	ikQ==
X-Google-Smtp-Source: AGHT+IG0mnBtxFHLaktut+V3gXYUB62C0a0lN7Q53NFVUdtJgunINK62Mbm+Ikuf1ZYr3tHtvitWzHlQ5kE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1889:b0:dc6:dfc6:4207 with SMTP id
 cj9-20020a056902188900b00dc6dfc64207mr1961789ybb.10.1710177809878; Mon, 11
 Mar 2024 10:23:29 -0700 (PDT)
Date: Mon, 11 Mar 2024 10:23:28 -0700
In-Reply-To: <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com> <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>
Message-ID: <Ze8-EFtsIONMyO3o@google.com>
Subject: Re: [RFC PATCH 2/8] KVM: Add KVM_MAP_MEMORY vcpu ioctl to
 pre-populate guest memory
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Michael Roth <michael.roth@amd.com>, David Matlack <dmatlack@google.com>, 
	Federico Parola <federico.parola@polito.it>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 01, 2024, isaku.yamahata@intel.com wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d1fd9cb5d037..d77c9b79d76b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4419,6 +4419,69 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
>  	return fd;
>  }
>  
> +__weak int kvm_arch_vcpu_pre_map_memory(struct kvm_vcpu *vcpu)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +__weak int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
> +				    struct kvm_memory_mapping *mapping)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int kvm_vcpu_map_memory(struct kvm_vcpu *vcpu,
> +			       struct kvm_memory_mapping *mapping)
> +{
> +	bool added = false;
> +	int idx, r = 0;

Pointless initialization of 'r'.

> +
> +	if (mapping->flags & ~(KVM_MEMORY_MAPPING_FLAG_WRITE |
> +			       KVM_MEMORY_MAPPING_FLAG_EXEC |
> +			       KVM_MEMORY_MAPPING_FLAG_USER |
> +			       KVM_MEMORY_MAPPING_FLAG_PRIVATE))
> +		return -EINVAL;
> +	if ((mapping->flags & KVM_MEMORY_MAPPING_FLAG_PRIVATE) &&
> +	    !kvm_arch_has_private_mem(vcpu->kvm))
> +		return -EINVAL;
> +
> +	/* Sanity check */

Pointless comment.

> +	if (!IS_ALIGNED(mapping->source, PAGE_SIZE) ||
> +	    !mapping->nr_pages ||

> +	    mapping->base_gfn + mapping->nr_pages <= mapping->base_gfn)
> +		return -EINVAL;
> +
> +	vcpu_load(vcpu);
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	r = kvm_arch_vcpu_pre_map_memory(vcpu);

This hooks is unnecessary, x86's kvm_mmu_reload() is optimized for the happy path
where the MMU is already loaded.  Just make the call from kvm_arch_vcpu_map_memory().

> +	if (r)
> +		return r;

Which is a good thing, because this leaks the SRCU lock.

> +
> +	while (mapping->nr_pages) {
> +		if (signal_pending(current)) {
> +			r = -ERESTARTSYS;

Why -ERESTARTSYS instead of -EINTR?  The latter is KVM's typical response to a
pending signal.

> +			break;
> +		}
> +
> +		if (need_resched())

No need to manually check need_resched(), the below is a _conditional_ resched.
The reason KVM explicitly checks need_resched() in MMU flows is because KVM needs
to drop mmu_lock before rescheduling, i.e. calling cond_resched() directly would
try to schedule() while holding a spinlock.

> +			cond_resched();
> +
> +		r = kvm_arch_vcpu_map_memory(vcpu, mapping);
> +		if (r)
> +			break;
> +
> +		added = true;
> +	}
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +	vcpu_put(vcpu);
> +
> +	if (added && mapping->nr_pages > 0)
> +		r = -EAGAIN;

No, this clobbers 'r', which might hold a fatal error code.  I don't see any
reason for common code to ever force -EAGAIN, it can't possibly know if trying
again is reasonable.

> +
> +	return r;
> +}

