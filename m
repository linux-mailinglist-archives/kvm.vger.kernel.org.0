Return-Path: <kvm+bounces-35913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29044A15AC6
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 02:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C64E3A8483
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43C317C61;
	Sat, 18 Jan 2025 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="toKG0H5r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC3E1853
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 01:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737162204; cv=none; b=UdRcS4fhuIWzHNxc7+BY1dyFRZEEgN5U3rz3ygKlkPCQyDxPAjwBbooq4Bis/FH8i8AWIzVYUEKO7oE66SsUENiLIr0vYRFBBUDS8IoZmXuNHxbHNV4qO1Dn15PlnuJ7i1JC+6R2S77ic7NHDvCCP+b3J4uNpRItEWPn2TpqqZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737162204; c=relaxed/simple;
	bh=HlxP1ROhyAwe+sd3E3k/ENg7lbYK6YOws5OMifhDAOE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DW+ytfd2j7nJyUzWWixBiCgJMa38WjVCGe9UJeBDUPGLpAg77SyTLRLEqm+E0bWHRm/uOcQHFccJBlCbvZ4dAQcq9R6FNH3TiWLIBidVE8LoWc48zZ841wUDEIZvopd8OCmkEEVi6C+cXnsaRmHj2IInS8KF7FMqnvM2LvhkrkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=toKG0H5r; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef114d8346so5001211a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 17:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737162202; x=1737767002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zonpfQT/ajJGPh0ub+FuSmkrsukWr4fji6jPEoxB7w8=;
        b=toKG0H5rh5MJiBJjs9lljSuI2NcHt2xd6nKMeaFPJcnRw5B+XTuq93JVDoi3UdwQ8d
         GL1FBmiwYmjJj376N/NW+68GfSAZZCV8QQ5eUi4Z+a8OYtLcswzyyLRB8NfLOAqsPfbd
         7UNKWVdZpJtPzKzSZ3J2Hgj7LxrVTu96k9lYJGZZARs5MstcbabRFooQsqOkG7zkwmQw
         X5s3oK3vz8E2KgsM0X5KU9v08y8Z13k/a7AWHJzo3BEBX0PCfQJ9WOJ2L8zvs/aH62Wz
         1b1OksCjNKpjXO3MgRnUAon9EtGwP9lqmKFpO/ZItWj3K/KOGW8HCComfwfNE2e6spg4
         m1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737162202; x=1737767002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zonpfQT/ajJGPh0ub+FuSmkrsukWr4fji6jPEoxB7w8=;
        b=WzOoyfWFoYKYcjEVc6rZ4fLTHVYSyUINHLt3w3gsazbtYa+MsAzkckhmqL3wdNL7Ni
         SIDJqqgkuhDDLNqKkeJyavHoX10c/OYoPbfvbdfMTInt1HOpU/JL4LvCA0hzYtMH9u07
         4av67Gj+uwcceM/cDXH7rF05cDS41SU2iDEm8b5esgT+D4Lvff5LLx+OyOS4Gze3xTL9
         AdP2VLEb9myKdPs+pbyKSuoVtiBTbVcz68BjgrRHfxKRBDQ4Ad5WyykB0C2Mgt7sfANp
         rTJ04bAOmGQLHlbQmZ3ZnzO/hQ/WA/u8i3aH/pDbQHhj31ns/jj9Gh6WX9vgQyNAJAr6
         nEFg==
X-Forwarded-Encrypted: i=1; AJvYcCUTgRRv0inhDlM3rtrLoBqyasfpfp7BzqY+UM5NZzFDJqy53aIVWs0DknL/ioZYIh6umsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcXQwB2oh/UowW05aj5A0GR4KAS+glZxwWWtJ6tM3FO/IT8/yN
	fqW/T3WDwW5JwlbrJmT/j+2mh8+wxaRCmPaphJhhFOwobXfzUlhsva6LrxYxreLPqA7UTLl+i7G
	D/A==
X-Google-Smtp-Source: AGHT+IHZ09xqZNOKCu4yQuHB4sHubgEBTOhXjbMbVTOVHGeTcnsry9C/bl1de60TMr6Z/3+U/QQUwnXhzZ4=
X-Received: from pjc15.prod.google.com ([2002:a17:90b:2f4f:b0:2e0:52d7:183e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c890:b0:2ee:cd83:8fe7
 with SMTP id 98e67ed59e1d1-2f782d9ee9amr6677906a91.35.1737162202024; Fri, 17
 Jan 2025 17:03:22 -0800 (PST)
Date: Fri, 17 Jan 2025 17:03:20 -0800
In-Reply-To: <20241222193445.349800-9-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241222193445.349800-1-pbonzini@redhat.com> <20241222193445.349800-9-pbonzini@redhat.com>
Message-ID: <Z4r92AG5zhYvYWvs@google.com>
Subject: Re: [PATCH v6 08/18] KVM: x86/mmu: Support GFN direct bits
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, yan.y.zhao@intel.com, 
	isaku.yamahata@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Dec 22, 2024, Paolo Bonzini wrote:
> Since TDX only needs to shift the mapping like this for the shared bit,
> which is mapped as the normal TDP root, add a "gfn_direct_bits" field to
> the kvm_arch structure for each VM with a default value of 0. It will
> have the bit set at the position of the GPA shared bit in GFN through TD
> specific initialization code. Keep TDX specific concepts out of the MMU
> code by not naming it "shared".

...

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cae88f023caf..95f2b0890a58 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1542,6 +1542,8 @@ struct kvm_arch {
>  	 */
>  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>  	struct kvm_mmu_memory_cache split_desc_cache;
> +

Not urgent, i.e. shouldn't hold up anything, but can someone add a comment here
to explain what "direct" means?  I know all of the concepts and code in play,
and I still don't really know what "direct" means in this context.  I doubt
others will fair much better :-)

> +	gfn_t gfn_direct_bits;
>  };

