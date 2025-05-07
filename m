Return-Path: <kvm+bounces-45669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F1BBAAD1D0
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 02:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED7F97A4AD2
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 00:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1B48C1E;
	Wed,  7 May 2025 00:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y7uHFtvT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A6A4A00
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 00:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746576229; cv=none; b=jEWKCZhXNGhU/ofpxziJFfNGIe+didUSQ/qgoj8dyEdywAkIEWkN6ffYhyNCwjB+04tdvG7kfLCDoRUqTQAce5wHM322lhhBMDzUX/CGs/uWlaJBvC4xpv3JTJ1NDdO6MbyKf1eeQsdcJpeFTLx4YlkaywxSGRHl1ahqAS1KmDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746576229; c=relaxed/simple;
	bh=VrNSbBLOCr7NEwSbl8xm2RoaraSzVHKq/zWcp73SSJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aAFbuHPQ4bn/HU0u4wq/bHwef6Cv3bpB9s6VWy1gvVOsmL4gjoT1kq0t+Uz3BB0DHZAFvh30OaGd8+k4Fo2EhChLs3zqUy8QU3kwwADevLXyN7NtHUj23zos9YY23mOk0mGf4AkJ3++ILrB/jGQ8jU2++JWj3Ixt5D7ctqvjtE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y7uHFtvT; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-86195b64df7so1124577739f.2
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 17:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746576227; x=1747181027; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5+m6HPDtb0R18pUg/qJCD2U+j03ktvX2ktaHxXO8cS8=;
        b=y7uHFtvTiHiaBSNpWx5YxO1QVW4x6TEKij8Uib+yD5dev3coUfLCtILfO7amthO1f1
         IME0961vjuEmVuYbjkGzrkFeCKlGwLJe0ZwGae3vQNSc/RXoBCiojN7+e8wJVzXbuqt7
         HUOyLSMg6SdPLLu62AIB+aAfNuugRsloknUoYZT6gh6JMlUXfxkWGml0MNW8pAAwxAK/
         RvRDCrvdShYLvs41etEwt7Kq7DIllQhLh/TzYg0RURmG4Fa0POHU5qx8PS2CU3m8XZhr
         RyA2NelFFgeE9z+xqngEgI8EswVm1QbU0v7yHbkhsH0/35wC9fHNd4X8nvjaN8Ps4I/+
         ns4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746576227; x=1747181027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5+m6HPDtb0R18pUg/qJCD2U+j03ktvX2ktaHxXO8cS8=;
        b=ni4e5RyKw3A5pNY7ymIX52A9lCRo8jIffzpFS2rSrgkoLhheeNKHdhk7CAmyEaJhZJ
         0mGA69zz+5NUVuAoC/8nNAK9EF8Cd/0aWAb02a1rF2wUZBeJg3t4nXM0mt59uUT1svrZ
         Y+dOxSXujyzUPiLsRI2eugcCuJEtHgSq2go5WInlwawGZjgezUSVI4PFlPzLDH3uFwCk
         BiDFdxvofw8fuv93/iaZuETlm580TOk0hJ1ssNaMoBTnSWyypcoLh08WjP35+rRsvV1i
         CeZUVHHOQsoVUEM5Dvaee/EgBCyv/b5dC4ZbhKtD5IWjdwRXwKx3r2ftgKaczY2P/TCu
         itOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyRfbwjBBCt5pE0jJd/d/T3sDerCgn5iBnxhMd7wgZrudkqjzMs5ismevM51ubaXNAsNg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvkzOXSkzfEp38kDS4LTAcqwNh+q77tdjNIduxQlV3amMn2ktm
	vLIARiLraGlOa/lIMOxUdmqqVRwyNvezDPV6LR2AOpbRRf4n/fohmv0dlFVUVPCxIpDSRa3+i4r
	4ug==
X-Google-Smtp-Source: AGHT+IG6Fxa93Bz0YoXvtTYguCqgLiKUWD1kixt49zVH2HtfKhQptZBHYIAFUFv7wo+hSUraRC2rqINWD4c=
X-Received: from pjbnb1.prod.google.com ([2002:a17:90b:35c1:b0:30a:7c16:a1aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d8c:b0:2f2:a664:df1a
 with SMTP id 98e67ed59e1d1-30aac156361mr2370837a91.2.1746576217154; Tue, 06
 May 2025 17:03:37 -0700 (PDT)
Date: Tue, 6 May 2025 17:03:35 -0700
In-Reply-To: <20250109204929.1106563-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com> <20250109204929.1106563-4-jthoughton@google.com>
Message-ID: <aBqjV40pb-s9gvsz@google.com>
Subject: Re: [PATCH v2 03/13] KVM: Allow late setting of KVM_MEM_USERFAULT on
 guest_memfd memslot
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, James Houghton wrote:
> Currently guest_memfd memslots can only be deleted. Slightly change the
> logic to allow KVM_MR_FLAGS_ONLY changes when the only flag being
> changed is KVM_MEM_USERFAULT.
> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  virt/kvm/kvm_main.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4bceae6a6401..882c1f7b4aa8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2015,9 +2015,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
>  			return -EINVAL;
>  	} else { /* Modify an existing slot. */
> -		/* Private memslots are immutable, they can only be deleted. */
> -		if (mem->flags & KVM_MEM_GUEST_MEMFD)
> -			return -EINVAL;
>  		if ((mem->userspace_addr != old->userspace_addr) ||
>  		    (npages != old->npages) ||
>  		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
> @@ -2031,6 +2028,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  			return 0;
>  	}
>  
> +	/*
> +	 * Except for being able to set KVM_MEM_USERFAULT, private memslots are
> +	 * immutable, they can only be deleted.
> +	 */
> +	if (mem->flags & KVM_MEM_GUEST_MEMFD &&
> +	    !(change == KVM_MR_CREATE ||
> +	      (change == KVM_MR_FLAGS_ONLY &&
> +	       (mem->flags ^ old->flags) == KVM_MEM_USERFAULT)))
> +		return -EINVAL;

Oof.  I don't even want to decipher this.  Let's just drop the blankent immutable
restriction, and simply say guest_memfd slots can't be MOVED.  guest_memfd doesn't
support RO memslots (and never will), and doesn't support dirty logging, so this
is effectively dead code anyways.  Then the diff is much nicer:

@@ -2012,14 +2027,15 @@ static int kvm_set_memory_region(struct kvm *kvm,
                if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
                        return -EINVAL;
        } else { /* Modify an existing slot. */
-               /* Private memslots are immutable, they can only be deleted. */
-               if (mem->flags & KVM_MEM_GUEST_MEMFD)
-                       return -EINVAL;
                if ((mem->userspace_addr != old->userspace_addr) ||
                    (npages != old->npages) ||
                    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
                        return -EINVAL;
 
+               /* Moving a guest_memfd memslot isn't supported. */
+               if (base_gfn != old->base_gfn && mem->flags & KVM_MEM_GUEST_MEMFD)
+                       return -EINVAL;
+
                if (base_gfn != old->base_gfn)
                        change = KVM_MR_MOVE;
                else if (mem->flags != old->flags)

> +
>  	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
>  	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
>  		return -EEXIST;
> @@ -2046,7 +2053,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	new->npages = npages;
>  	new->flags = mem->flags;
>  	new->userspace_addr = mem->userspace_addr;
> -	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
> +	if (mem->flags & KVM_MEM_GUEST_MEMFD && change == KVM_MR_CREATE) {
>  		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
>  		if (r)
>  			goto out;
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 

