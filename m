Return-Path: <kvm+bounces-7498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09169842D1D
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:42:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B33EE28220B
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 19:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DAE26AFC;
	Tue, 30 Jan 2024 19:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R8BWegSU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8149A7B3C3
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 19:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706643724; cv=none; b=tEhrkxEcswi69bqvMVxeBI0FnEZUOXvR3hIdG4iRb5t5if1OY8oIfctfE1o2uwMxGH+9SXkrLxFC1C88kXF3hADcmSK8fCilSsNSb58rlZuzQpITcNSRZrPRzKE8zdGXeiwDPkABpwTyGB1QWAXQLU41UZGOQh0X3CSBNe6B/+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706643724; c=relaxed/simple;
	bh=bpBlUG7tmAiiG8HgxWw/3bbxCo/qQ1cSl06c6rqWptQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eEqJfbNt9xUb+6PN9vYaf4Mm6ro0VGOH2nKRCGObrc+7VdAgtZgFEioXHCVUqZU/KF50OHBU7unoGLQkZ3PR3+aJej1Af0JMjY4UgcwI9TINw+PZm0wapSrgU4yXMJk4acAlmJb8JH7UdUvkK7f5GLFr/jN34gqytjhLJtMdpaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R8BWegSU; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-603f3a66294so16786137b3.1
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 11:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706643721; x=1707248521; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uiC6lDNYPacxijwp+TEOsYnfgAgHzQpJUcjk2C9MEX8=;
        b=R8BWegSUzJ6UjS6sD5zTU9V4lDR0KNHKFxuCQoHvZuoe870svDXfwU7GK/DgwhUzQj
         biCTOFg6qg6v7WJ0ZJe87F0qm6eHf0FEwsKw4lRihxolHMkjPrsVPZfB/IBqMkJ7oWRb
         QyCT9YCWRLZu2kL94h+6UutZ2O0xvkBDVOopIfbyBKIzYYlH3iQnEwK34NWxWbBhRFvk
         8tacm7BdVRcXOgPX/YK2CcbkLivXRu4orgYNEW8hJemPl/4l4nO3faf1U7j6tGF5NDjg
         ykkizCkh5fcV+E3JruUjyzg9GnBpccOKnxtpgkN7I9u4boGLVtpdNZGP5CK0FR5MGOoA
         dc2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706643721; x=1707248521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uiC6lDNYPacxijwp+TEOsYnfgAgHzQpJUcjk2C9MEX8=;
        b=Kwd3AFR1Kot/jfuII8OoeY04mIBbOujBZB3REX/XeYBh+LGm9LWceyphJn8gjsm2Y+
         r4EdXS3HN3fn+VwWVOXlrZwEydLS2oT0kLnO2BfL7OZraLR90J+NEHNx6730cnw6AS1B
         CLuRBnhPYqNlucWtiJWRO+vRPAAbmB75WUgd2b9dNkepCU5HGgxlPexE4zLVdjvTrHI3
         egqpdVU+tqwh9Rv6ak1f8KE/SZ1JhMznL8/tld49t55iOjG8DwvqwQjbVIEuCsj+JgPx
         qER9XE4OPYP8UJo2eIY5+GmqQtavQ7j/nWfjvJS4EJ+tId43ElpFRPHqBr7+ahRRTkwO
         0u7A==
X-Gm-Message-State: AOJu0Yw44N3u5mOUjiQzklfTcVCt72eK9lCnOO8/nGlp7l9eBlCTJZNy
	6XZkjoj0LEADzWWlvv03IPZUjCebA9HotL2J/Ltvgu5I2ur9AjD3aZDkLN5VwWJfpB+QhLXfH1N
	p3w==
X-Google-Smtp-Source: AGHT+IFHHxGWUEqLe7N1xAEh4N7i1S0F3fTyyhZhLrkLKn0sznbAPWpgIM9DmL6pSZMQEnDDFJEOTcmxBoU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2205:b0:dc2:23f5:1791 with SMTP id
 dm5-20020a056902220500b00dc223f51791mr3280187ybb.6.1706643721548; Tue, 30 Jan
 2024 11:42:01 -0800 (PST)
Date: Tue, 30 Jan 2024 11:41:59 -0800
In-Reply-To: <20231218161146.3554657-4-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com> <20231218161146.3554657-4-pgonda@google.com>
Message-ID: <ZblRB9IyXl9BE_4P@google.com>
Subject: Re: [PATCH V7 3/8] KVM: selftests: add hooks for managing protected
 guest memory
From: Sean Christopherson <seanjc@google.com>
To: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 18, 2023, Peter Gonda wrote:
> Add kvm_vm.protected metadata. Protected VMs memory, potentially
> register and other state may not be accessible to KVM. This combined
> with a new protected_phy_pages bitmap will allow the selftests to check
> if a given pages is accessible.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Originally-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h        | 15 +++++++++++++--
>  tools/testing/selftests/kvm/lib/kvm_util.c       | 16 +++++++++++++---
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index ca99cc41685d..71c0ed6a1197 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -88,6 +88,7 @@ _Static_assert(NUM_VM_SUBTYPES < 256);
>  struct userspace_mem_region {
>  	struct kvm_userspace_memory_region region;
>  	struct sparsebit *unused_phy_pages;
> +	struct sparsebit *protected_phy_pages;
>  	int fd;
>  	off_t offset;
>  	enum vm_mem_backing_src_type backing_src_type;
> @@ -155,6 +156,9 @@ struct kvm_vm {
>  	vm_vaddr_t handlers;
>  	uint32_t dirty_ring_size;
>  
> +	/* VM protection enabled: SEV, etc*/
> +	bool protected;
 
Yet another bool is unnecessary, just add an arch hook.  That way it's impossible
to have a discrepancy where vm->arch says a VM is protected, but vm->protected
says it's not.

> @@ -1040,6 +1041,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  
>  	region->backing_src_type = src_type;
>  	region->unused_phy_pages = sparsebit_alloc();
> +	region->protected_phy_pages = sparsebit_alloc();

There's zero region to allocate protected_phy_pages if the VM doesn't support
protected memory.

>  	sparsebit_set_num(region->unused_phy_pages,
>  		guest_paddr >> vm->page_shift, npages);
>  	region->region.slot = slot;
> @@ -1829,6 +1831,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  			region->host_mem);
>  		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
>  		sparsebit_dump(stream, region->unused_phy_pages, 0);
> +		if (vm->protected) {

And this should check region->protected_phy_pages, not vm->protected.

> +			fprintf(stream, "%*sprotected_phy_pages: ", indent + 2, "");
> +			sparsebit_dump(stream, region->protected_phy_pages, 0);
> +		}
>  	}
>  	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
>  	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
> @@ -1941,8 +1947,9 @@ const char *exit_reason_str(unsigned int exit_reason)
>   * and their base address is returned. A TEST_ASSERT failure occurs if
>   * not enough pages are available at or above paddr_min.
>   */
> -vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> -			      vm_paddr_t paddr_min, uint32_t memslot)
> +vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> +				vm_paddr_t paddr_min, uint32_t memslot,
> +				bool protected)
>  {
>  	struct userspace_mem_region *region;
>  	sparsebit_idx_t pg, base;
> @@ -1975,8 +1982,11 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  		abort();
>  	}

And here, assert that:

	TEST_ASSERT(!protected || region->protected_phy_pages,
		    "Region doesn't support protected memory");

> -	for (pg = base; pg < base + num; ++pg)
> +	for (pg = base; pg < base + num; ++pg) {
>  		sparsebit_clear(region->unused_phy_pages, pg);
> +		if (protected)
> +			sparsebit_set(region->protected_phy_pages, pg);
> +	}
>  
>  	return base * vm->page_size;
>  }
> -- 
> 2.43.0.472.g3155946c3a-goog
> 

