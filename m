Return-Path: <kvm+bounces-11232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B22FB87454E
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:49:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E40FE1C21E0F
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5594A24;
	Thu,  7 Mar 2024 00:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fNbd3WtW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613EC1859
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 00:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709772565; cv=none; b=PrpkIjnfOyD1IYjwPCptHQQZePE+Luv3Qu8tfOt1zfUoBbpaMhAj0EZeg+zBERzPoLcKzNVCt8k50kH0/marIKiEjUAhOItpPNr+oNUHw8yMUkRzLej614L47fDJsNxDjfU7vD7zI+f3DpFsz7saWGcKmbQQjyUHUv5bGRqPg68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709772565; c=relaxed/simple;
	bh=ZXHeEF1Tuz439WtPB8jKFh9bcbueJkjxcw5I0qWXpQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DetrTZEifPwpx475tLolPe+1pUH9W+cMRNh8PTmqeoarCJ631B0q/jpHXYYOGWHCUnKHczRQZ9DpP0eUZIJgBCk1Sfz+TIw5Y8sgNmuM7ZMvW56e7jxvWkqvzRbgK5gHzPKpkIOUTOAKXhy7XdkFFWOHYP/Ho4PjqZFR9oOeGI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fNbd3WtW; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5bdbe2de25fso253209a12.3
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 16:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709772564; x=1710377364; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjPGiwQvnTtLunk5gRoXOklrJz8rTHIOs7mBmB6Z+/U=;
        b=fNbd3WtW9o3bkeGiMwDVTcfnuQO9U5YxjMMq15FxUPUADLMpxBk3ots+V6p8pV6iDN
         htTRSklxXQ/H0qXFl2MQIHJ97VuFvnKXj9lPXD2nhp00J01c1d7MJIBqt/TeaAULqUxW
         Gi61ZWsfXtxheC92v2DzFGB1avuYq61/1oNU8AYGc1sbr47iDRP/dNdGP+Cro0cdTAtS
         KPcZalOX5sYrqIXtRIxXp62q5J/WJfyhOfm49xusDDoQZ2r3TwhtpznqgOGMnoUAWIWm
         NytRm1PmWBC3THRl7LR0W8QU9GkGBMAlzyeikJ2Tx2D+aqA+gSkpzi9/7cgagKQYM7l7
         F3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709772564; x=1710377364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjPGiwQvnTtLunk5gRoXOklrJz8rTHIOs7mBmB6Z+/U=;
        b=XhBmDEFbFW/wXl3WpwyLM1vZproP35uy39w1OShF5XMFFZd4Ynut9ErUxqQx95rGQl
         K134DxvRIiolX69Bz3MQnHtbXbXAh9cwYIQk0M3PDixHtGmPouZSXL7i7P9ni57YQSeQ
         c0KCT8v/Cqy6eFCqpJQGDRAliUulskb9lX/VUsaIU25UrGNGNv09g4ohGjo+DRbIFFsK
         zJbz2ZlYrEz9S157/OAavc3urYdcTZVx/rN6NkoYDg0nFr0f4LHRh6TXteI31a2faTHf
         fu0q2Wv8amTKbS30mTf6KA2PhjV6iVmkIlA41P01JZ4hG53jucM+rfzEG/MEUmZizA3Y
         zUIQ==
X-Gm-Message-State: AOJu0Yz5GLlnxJJhQUCXaNzrUFbwX2+1WdNLt3GGPPiYn7CmCIILziA8
	z+bIMrlz+idooURA2ZUk97kmcR8aZo6nOpRmSQuBWglolsj5m56lwEPXEkVf6A==
X-Google-Smtp-Source: AGHT+IGQtxeEYtT1tmzduqmZR9FFf73CQ0GVzIsakv/s4eVcBNahugTQqSN97AIf6yHqpcaURdAsCg==
X-Received: by 2002:a05:6a20:2d26:b0:1a1:4c48:5ca0 with SMTP id g38-20020a056a202d2600b001a14c485ca0mr8020815pzl.42.1709772563591;
        Wed, 06 Mar 2024 16:49:23 -0800 (PST)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id j6-20020a170903024600b001db2ff16acasm13102369plh.128.2024.03.06.16.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 16:49:22 -0800 (PST)
Date: Wed, 6 Mar 2024 16:49:19 -0800
From: David Matlack <dmatlack@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>
Subject: Re: [RFC PATCH 2/8] KVM: Add KVM_MAP_MEMORY vcpu ioctl to
 pre-populate guest memory
Message-ID: <ZekPD_L7vam2W-CJ@google.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>

On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d1fd9cb5d037..d77c9b79d76b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> +static int kvm_vcpu_map_memory(struct kvm_vcpu *vcpu,
> +			       struct kvm_memory_mapping *mapping)
> +{
> +	bool added = false;
> +	int idx, r = 0;
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
> +	if (!IS_ALIGNED(mapping->source, PAGE_SIZE) ||
> +	    !mapping->nr_pages ||
> +	    mapping->base_gfn + mapping->nr_pages <= mapping->base_gfn)
> +		return -EINVAL;
> +
> +	vcpu_load(vcpu);
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	r = kvm_arch_vcpu_pre_map_memory(vcpu);
> +	if (r)
> +		return r;
> +
> +	while (mapping->nr_pages) {
> +		if (signal_pending(current)) {
> +			r = -ERESTARTSYS;
> +			break;
> +		}
> +
> +		if (need_resched())

nit: Is need_resched() superfluous when calling cond_resched()?

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

This can overwrite the return value from kvm_arch_vcpu_map_memory().

