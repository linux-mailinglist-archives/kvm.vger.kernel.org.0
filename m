Return-Path: <kvm+bounces-48676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F548AD0A0F
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 00:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A30F17ACAE
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 22:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C0023D2A0;
	Fri,  6 Jun 2025 22:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1HylqXX4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEE023BD13
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 22:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749250252; cv=none; b=PPbE20sTJnfkvPy7xxlWslleZJhrpsgZE232NlBsjK8hvUJocTAVOpTVkIhGCpOlPoq69H7wGPLPdzFvaDYzQzsMXoqHp8LY1F92T2tgryPGiu2+wBl+31aQPIDeU9uF/TpHfVbe36el8eDy2lhyCMFz+D98aCSCs9jhQqcVQ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749250252; c=relaxed/simple;
	bh=9FBus/nnrcqkp3TJXG8U7uwI7fgPTt0YtA5BGlfV2DQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jMwCtpwyugZqddM6CqirdcAXlFGGL3nFkL5j7hvGciMcbzu9cnoGayx+H0bxj1GydKU08EXpT27YuZhgqnBYwF43MqtJ943iPWnJRVxhEYlyBA0YXweJ+tVVFker/MK2QYHhWRuuZ39qvSnCKaSCO/FL1mPtnPr6hYGfdHYwLeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1HylqXX4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ea0e890ccso2551654a91.2
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 15:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749250250; x=1749855050; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8gcR8HNVhw7S1UUII4jwvRqVvrX7swbwirtPPR2NdXI=;
        b=1HylqXX4yiB2/orE9LI9qmGyi2MabIDyCS5+HW6sc2OkQhqRAydxlfHIj07tRDykRu
         aeNV1pq3yZDg1rufsnlwbfMRCPxM2H+aM2zSfk7+yGGz6J5MZHKh/vnYZ4BaopVaKav2
         BK2zvF61XUcPb/AkIMjRWYErkJ2LWkgS4TOfHRwnpTHHy/igHPlbyLFWP2+QRkoh6wpB
         uZch11XBA0Q+yvFOsfaBb1wOWDBI2YqiMZ7CeJTUfNf3ahMARIxFjaLaZreWO270qwVC
         GxDYxqgGKRCkESgFtB2/PuUzATRhd8xRfnu4JaWXlOPXgJD69qzcAdnS5uua+t4vlSgk
         EHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749250250; x=1749855050;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8gcR8HNVhw7S1UUII4jwvRqVvrX7swbwirtPPR2NdXI=;
        b=PTdq7k3YdwcagLNY3tgiUxmZmkR7np80x3tT/NM5QZ9+uapFPgpZhlYciROVmt2rlQ
         wcgEIY2AuoARjMAHkSiT38PmIXigE151LCHLdFEUfpZVloyF7xkvuQ27yODtdOzVApn+
         W8VzhWU8ADJBBaRg8+3EOMo0r6szCDJiiYwmyr+u7n5MtjIHPuGq2kazafrS4T1TF/Ix
         pPOht1yWmzPB3+fjHIzLmVEXq4eqBLp+t3HlJYYdzZBrTa4M98hNQvxSwX2q12cXdGUx
         KrBd9zNOaTt3/N8oTdEGkJb45S9vWqKxoIf0+YWpK52MSzrpR3L7qdUtJWdv9bEy5SOT
         OYQg==
X-Forwarded-Encrypted: i=1; AJvYcCUtiBGOabaH16W0XFkXYysdnBvD7ZJFhphjnviupafJFBNHQqAwEgthUNwsRHvz7aOWNAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBBCX/Dht6S4+UqUmgXto+krIdQqgYyTjO3Fm5Kwyy/o6o650v
	aSHHlkT3/v2QjgmN6Ukdf1Ngw3jPAbJRSR3N4g955QQWxcWPs/zBRRt3evm3WqBgqjN0DgY5U49
	iPPZBbA==
X-Google-Smtp-Source: AGHT+IFul6Ywu0HaZHphQDwEhl1qPeTTs97xLcKkRSWk3IxbD9Y9UJK3+wGAtrWLanrf6df0kDoQ8hBuIB8=
X-Received: from pjq8.prod.google.com ([2002:a17:90b:5608:b0:312:f650:c7aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d88d:b0:311:b0ec:1360
 with SMTP id 98e67ed59e1d1-3134706d56bmr7978630a91.29.1749250250354; Fri, 06
 Jun 2025 15:50:50 -0700 (PDT)
Date: Fri, 6 Jun 2025 15:50:48 -0700
In-Reply-To: <20250401161106.790710-7-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161106.790710-1-pbonzini@redhat.com> <20250401161106.790710-7-pbonzini@redhat.com>
Message-ID: <aENwyCpSTV6niX8A@google.com>
Subject: Re: [PATCH 06/29] KVM: move mem_attr_array to kvm_plane
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com, 
	thomas.lendacky@amd.com, ashish.kalra@amd.com, michael.roth@amd.com, 
	jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 01, 2025, Paolo Bonzini wrote:
> Another aspect of the VM that is now different for separate planes is
> memory attributes, in order to support RWX permissions in the future.
> The existing vm-level ioctls apply to plane 0 and the underlying
> functionality operates on struct kvm_plane, which now hosts the
> mem_attr_array xarray.

...

> -bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> +bool kvm_arch_post_set_memory_attributes(struct kvm_plane *plane,
>  					 struct kvm_gfn_range *range)
>  {
> +	struct kvm *kvm = plane->kvm;
>  	unsigned long attrs = range->arg.attributes;
>  	struct kvm_memory_slot *slot = range->slot;
>  	int level;
> @@ -7767,7 +7770,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  			 */
>  			if (gfn >= slot->base_gfn &&
>  			    gfn + nr_pages <= slot->base_gfn + slot->npages) {
> -				if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
> +				if (hugepage_has_attrs(plane, slot, gfn, level, attrs))
>  					hugepage_clear_mixed(slot, gfn, level);
>  				else
>  					hugepage_set_mixed(slot, gfn, level);

I don't see how this can possibly work.  Memslots are still per-VM, and so
setting/clearing KVM_LPAGE_MIXED_FLAG based on a givne plane's attributes will
clobber the state of the previous plane.

I think we could make this work by having a per-plane KVM_LPAGE_MIXED_FLAG?  I'm
99% certain we can use disallow_lpage[31:28], and _probably_ bits 31:16?  But I'd
rather

Note, to handle shared/private, we could make planes mutually exclusive with
tracking that state per-VM (see the many guest_memfd discussions), but unless I'm
missing something, we'll need the same logic for mixed RWX attributes, so...

Also, as mentioned in a later respone, planes need to be keyed in kvm_mmu_page_role
for this to work.

