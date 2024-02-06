Return-Path: <kvm+bounces-8070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A96D84ACCD
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 04:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDB321C230D9
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 03:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94C0745C9;
	Tue,  6 Feb 2024 03:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nipICXxH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8883E73188
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 03:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707189807; cv=none; b=joPy2wkKbE8pXMDt7YciMvCiR2UZYiMs9A/g2IXg8UcC1E4V22GSaL3ucpwPXz8P9ASZ+Vl/2ZekRdtIbYd2QA4W2Y/Dx6m1AqNPNnCwJFr7bGi75hPXYTHzGmoAep6pBtMKcqDP3WShtRwaN+RuEfEl0kLhWDqiMRJsdN6dDfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707189807; c=relaxed/simple;
	bh=UDDsuWPSW+daCIoSbgJFsD9FLwQJiP9p3QmcFSmkrL8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JNuu41Iv8aPmI/vJdVLK0kUXCR91A89oWUisYLrTWBzPy5USn55ML5V213m2u3iXAXRXEQnrmy3iW7Di5QzCLXlkrBCldeg/rc59MVsMz4PC1vBtqNltgq/aqTN4KQ6PFXU0gfEa+Plan8bWQCblbx4gFs0yjcnkQGTOx2cq+hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nipICXxH; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d45d23910aso4527865ad.1
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 19:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707189806; x=1707794606; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8R1ERRzsuzMxbDKKjiu7D3XS5GbZ63vNtb/cSGihhOs=;
        b=nipICXxHO1nJjO+JmKGVfaCij6btPcykHvyqG9bf2rUQif6VsjiZLuo7ESkFIDPC5B
         3yAyxA9kkaM8evZWqeY4tjv/8EBsT4AulFXuK2NeYcMFHMRckW6vkAU7HFwI55wYIz8p
         ivwVuCYE89R+gAKY+B0jMfQWSmxLeJ/0ETDNx9lTa1BOJqxmacy0cxAKjGGoKvRR/dmn
         aWFW7rNgjGazQ6RSzuCYAr/hZ9I0yPWdA/b0V/5XMLVl2HCUaGIWfj7c6veBV/894Joj
         iEKqeE+4hxeSREhz2Uu30Xh7bAdZaHuIT1hdAadVDOFwSKK2eRcXH5WrZEBx+FMitjqu
         ajPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707189806; x=1707794606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8R1ERRzsuzMxbDKKjiu7D3XS5GbZ63vNtb/cSGihhOs=;
        b=jovC7CNBGXB835OB4PcUTEwkDWXFzmocUWicG3EiLnjGiqjZG05C7AoVUoLVTupCAg
         35tqdsP1NfnOM9Cjtm+oQRW9j0JpM+HnfBnnqMoJbgn5v4PAB7k0PQd9lBoF8IjVMduc
         4ZzUfWRdao1Rb7IYBsbf27MiTcjGJSSDFD2g/9mmLFbzR5UkEF5EsOXTwWxovhhgzprW
         Z1zwVreiOcJ9sjI3TcPCFHaGcvCgUIA4BoPfclpWYEJC5pkQixALtiWn2vDe3wYsxbk9
         it6IrMVayA7r+xrSDH0jZVWok7pqub70Ss34CgOtPSF5ImMjGqft+nQV2wLaOugwYjoW
         h14g==
X-Gm-Message-State: AOJu0YxzQRZYejScb+2sHf4jXu+wWL2CbvwvktXpvqyyMTxQD9vWV2R1
	F4ulZPcRcrPqIgyb9sjwHYdBcHtIH7rVzuN7+tJYbnQxe6owkj153nx8vSomJlIHwinLFGN0Uvz
	JLg==
X-Google-Smtp-Source: AGHT+IE0G4SfzxxNcKBnPCRpYFdxC7UqdFDNFLn6IxTgkrQsyF2NU6Q4LbGrsElpxhUbA99G5w1BV9ZQ7JY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22c4:b0:1d9:6380:5485 with SMTP id
 y4-20020a17090322c400b001d963805485mr1077plg.13.1707189805737; Mon, 05 Feb
 2024 19:23:25 -0800 (PST)
Date: Mon, 5 Feb 2024 19:23:24 -0800
In-Reply-To: <20230911021637.1941096-7-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-7-stevensd@google.com>
Message-ID: <ZcGmLKbLV2bVTxD1@google.com>
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 11, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Handle non-refcounted pages in __kvm_faultin_pfn. This allows the host
> to map memory into the guest that is backed by non-refcounted struct
> pages - for example, the tail pages of higher order non-compound pages
> allocated by the amdgpu driver via ttm_pool_alloc_page.
> 
> The bulk of this change is tracking the is_refcounted_page flag so that
> non-refcounted pages don't trigger page_count() == 0 warnings. This is
> done by storing the flag in an unused bit in the sptes. There are no
> bits available in PAE SPTEs, so non-refcounted pages can only be handled
> on TDP and x86-64.

Can you split this into two patches?  One to add all of the SPTE tracking, and
then one final patch to allow faulting in non-refcounted pages.  I want to isolate
the latter as much as possible, both for review purposes and in case something
goes awry and needs to be reverted.

> @@ -4254,13 +4265,18 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> +	/*
> +	 * There are no extra bits for tracking non-refcounted pages in
> +	 * PAE SPTEs, so reject non-refcounted struct pages in that case.
> +	 */
> +	bool has_spte_refcount_bit = tdp_enabled && IS_ENABLED(CONFIG_X86_64);

Eh, just drop the local variable and do

		.allow_non_refcounted_struct_page = tdp_enabled &&
						    IS_ENABLED(CONFIG_X86_64);
(but keep the comment)


