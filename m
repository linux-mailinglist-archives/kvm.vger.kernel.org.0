Return-Path: <kvm+bounces-28819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C52B399D9ED
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 00:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80E45282D56
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 22:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CDB21D90CC;
	Mon, 14 Oct 2024 22:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GYBcK0R0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAFE1D5AD8
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 22:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728946743; cv=none; b=TgwHGQSzihW/ivgaB4DwBOhKHZX4MoK3J8ydpcmk2MA4PSvbLNIvdjn3euTPmYwJCEywGG2bSXi90BRJCeoe0AP5Q/r/uDLzyrzF+vQRIVuOrYS/KIl+D52FSFn1/Uo+FiW5zXSQvMhBFm5TJHPt/1TG9rvSsdqGusty9yxPFJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728946743; c=relaxed/simple;
	bh=IYIMs+Vb5pHawT/UbRBAdNS7wptXzhLpkWOqqdo427E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rJdwNBwQ6JdY+tzCtFepblJ9n9kO+9ol9+sSFSou4fsqf/GcznXAzXCMNCmeLojjpVPdzK+NGk5aVxxFxxyMMj/ywlrQuygHgaDMf6ZO/QJ3nBysoDz8H9/SrofrEw9VShclUxJhKwAV3pG1pdkKHNE3A4Nbr5RkvrG28pJkgLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GYBcK0R0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e2e5e376fcso91660687b3.2
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 15:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728946741; x=1729551541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v2ddKs4pr/oGDZNGpWz3RN/6TEGuqxNwNVJKN0VyWtY=;
        b=GYBcK0R0G6XzCwXYj5YPHptnmF6JQNP9UnqNevWxFft2kMxcznMakkHFRrsJekgzpa
         fISwzAcFvOevKrcTCYMY9eTV2iKljHeup/n/VDyGtHQS3liImjDRo6JNvQ3ap7zJIn9B
         zI+PPLQgEjfCJPXGBUomgzcnJ5B6guN+Sj+C4N6YSnetG3ha4vHZtL68+YTvK2oCCe/Y
         xSdkKxDB3M3XQhkGdMt/VXkJvZ7dL0d5LnoqQ6ClfHwfGugrryoeT95tnjHj0ILjizeK
         GWpF4BcB2HLEhCsuZmgeovughaMtcTJVw/ItVPl0E502TH9INbdm0sCQpjixwSnIOAqi
         D8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728946741; x=1729551541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v2ddKs4pr/oGDZNGpWz3RN/6TEGuqxNwNVJKN0VyWtY=;
        b=C8NRRgtrfakh0JZu+BUsu0narPnudDiBsLSHFbwsQ67MWJMJErwK58x66Q5hFda2Se
         fpTZsiyRNZPAN+b9Q7oAU7tbdzgVoEa2m42SDaQM7cnWDvJJinjuEg/k4BsXu0U/9M4U
         PVolYM9aRj1sQJlstjQdYd+ManJwBz0hsKkpcVKQE7EBOSdd/XCKpTmVyi7+B026xopt
         VyJ/oTq2CV34RUCXRTlsCVZRyU00jrPx2h3/n+zY07kapmCo2cuUf9Kx7RbEMVF/ARwY
         lc+squdk4r+YtSo7ydWPngDjZ/qm0Kx65IZaWfGRwvz2HB4KfOTBJvvPTOt0E6JhuP64
         sUYg==
X-Gm-Message-State: AOJu0YyZaWikBgWukHfQuEoRm6i/4WgNzqntKlHZZi/lnQfSL5pS99RQ
	mBYBO/0G1nXSMmOo7FscTp7AQb0hBPfjR4xtOrdApZC86xFNSAmZRjnlvtXPzyiEWDInFV8q62C
	vrw==
X-Google-Smtp-Source: AGHT+IGpLsSiK/rKJNShVTkYFCgu2dMnbIWSrYdXBymaWQf2b5qLxnWcy4A3vb9cmXQqHQtjEByeOIcpWAQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:5c07:b0:6e3:189a:ad66 with SMTP id
 00721157ae682-6e347c52ab6mr917617b3.5.1728946741156; Mon, 14 Oct 2024
 15:59:01 -0700 (PDT)
Date: Mon, 14 Oct 2024 15:58:59 -0700
In-Reply-To: <20240905124107.6954-8-pratikrajesh.sampat@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240905124107.6954-1-pratikrajesh.sampat@amd.com> <20240905124107.6954-8-pratikrajesh.sampat@amd.com>
Message-ID: <Zw2iM0tVmwy-8nPe@google.com>
Subject: Re: [PATCH v3 7/9] KVM: selftests: Add interface to manually flag
 protected/encrypted ranges
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pgonda@google.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 05, 2024, Pratik R. Sampat wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> For SEV and SNP, currently __vm_phy_pages_alloc() handles setting the
> region->protected_phy_pages bitmap to mark that the region needs to be
> encrypted/measured into the initial guest state prior to

Nothing needs to be measured, no?  (because there's no attestation)

> finalizing/starting the guest. It also marks what GPAs need to be mapped
> as encrypted in the initial guest page table.

...

>  static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
>  				      uint64_t size)
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index bbf90ad224da..d44a37aebcec 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1991,6 +1991,43 @@ const char *exit_reason_str(unsigned int exit_reason)
>  	return "Unknown";
>  }
>  
> +/*
> + * Set what guest GFNs need to be encrypted prior to finalizing a CoCo VM.
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   memslot - Memory region to allocate page from
> + *   paddr - Start of physical address to mark as encrypted
> + *   num - number of pages
> + *
> + * Output Args: None
> + *
> + * Return: None
> + *
> + * Generally __vm_phy_pages_alloc() will handle this automatically, but
> + * for cases where the test handles managing the physical allocation and
> + * mapping directly this interface should be used to mark physical pages
> + * that are intended to be encrypted as part of the initial guest state.
> + * This will also affect whether virt_map()/virt_pg_map() will map the
> + * page as encrypted or not in the initial guest page table.
> + *
> + * If the initial guest state has already been finalized, then setting
> + * it as encrypted will essentially be a noop since nothing more can be
> + * encrypted into the initial guest state at that point.
> + */
> +void vm_mem_set_protected(struct kvm_vm *vm, uint32_t memslot,
> +			  vm_paddr_t paddr, size_t num)
> +{
> +	struct userspace_mem_region *region;
> +	sparsebit_idx_t pg, base;
> +
> +	base = paddr >> vm->page_shift;
> +	region = memslot2region(vm, memslot);

Please no, doing a memslot lookup in a helper like this is only going to encourage
proliferation of bad code.  vm_mem_add() really should be able to mark the region
as protected.

E.g. practically speaking, the only code that will be able to use this helper is
code that is marking the entire memslot as protection.  And ability to _clear_
the protected_phy_pages bit is conspicuously missing.

> +
> +	for (pg = base; pg < base + num; ++pg)
> +		sparsebit_set(region->protected_phy_pages, pg);
> +}

