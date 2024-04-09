Return-Path: <kvm+bounces-14033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3262089E5BC
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6C241F222D8
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 22:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96C4158D76;
	Tue,  9 Apr 2024 22:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YktLj9do"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FF35B1EA
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 22:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712702969; cv=none; b=i3VVxNVnnLR+pDZohvvCRgkjzcx3pMg47BeVUq6+uro7EKAI95BSf/0Ybb3nnvkU72y4BRtnAaR0ZUmbesuVEV3h/VfDPiUxgGzr8+0mAB6gHpCJnGeSGWeKVaih2LEtakCWcnCTfjFQppmsNKnFrxWxtyz3P0vTTY9M/jSmM/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712702969; c=relaxed/simple;
	bh=pHkGzG7uY0hK1agTCuiDlZZKkMXpmtSgWgjAy8SNNHY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CUPbBTtlVng5JFWQw6u+QP+cOMJYCYa2v+n8NE7Jtr3aURCFPwvW62EpQwz82mCcPmLjPtS8sTvRRppD4YFIk8GksfCbwiRl3VUkVxpH+On28FsIhVcBdYUUCUQEBxX/2Ts9rBkjM82UZlXMbBc2SVmm9hOOHRYuk8xeax2NLZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YktLj9do; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dbddee3694so3260874a12.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 15:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712702967; x=1713307767; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X7BDOAdXGb6PM9j/Ro0cuDsmudWi0lw4fAoXWjZNUDM=;
        b=YktLj9dol0vzt94nWv27n4IvO9JYLCGzZau3EWPMxfmyMJNgADVzHHUW3XkJ7g0jBP
         +8LFnhjnwWgqMAI/FoLbYXDyo9zEN8HlrxEvmPmboc56kEPxmgYogKAsDEj2O2k8nf5y
         FiuQ64xEUW4dpafMfKg/zyrvY5M3jEBxpbMbQHxpPnpZKl87r1s77Zj7+5IQfXVuFj9E
         7orNEsz/OX3iqV+pN/QB/GMYZK0yDJfgug4ClxMFgSrHWGbZKNXFgM358EKww5ev+t98
         x3jNCc4LZk98tdhIGiIyr2m/J7ANDw85ZMKMUh466YpwdrERTgpH1Ut9w8WI10ieM0YN
         mvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712702967; x=1713307767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X7BDOAdXGb6PM9j/Ro0cuDsmudWi0lw4fAoXWjZNUDM=;
        b=UF8WDJNYmSXtWr8e4tUprEEQfM5tfp0NTFiIEDWjNPaLPgC+MHiQA1yThQvZemb64r
         /oz0p1C4TlMvOfIYuoIe4JkwEUuhpotiJIuST/ekEOrk7N6qEy4tn8s+Xea5CegGATRN
         iOc5HTD8czfKIpwsfZcuiG89CIxy5moUCtUZzJCHvJEUvPsh4pZ3Bmg04c1II9sT2daA
         cs8iiV9lbYuBjNgzIcQsOPzjSze5nf0ApDr+e5vkf33bw8xzfZRhsknqm0fsNDFx4vrG
         zVcFea/qbXxPXTf5BkYlKev1J4UlPt/DWscBBBNTOcktgFpsYJVKS04RL2HpLbqi3f6F
         GkRQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2BsyHkACtS5nmTIvcs17Ivv7ZiG7pKM7v9ld9Zd/l9b9JJr4yExxMyEgAkZWhMcnDEB8RhgU6TPldKEkDpcvzAitP
X-Gm-Message-State: AOJu0YzTciB6QOHWseBYNnlyOUa4LYDXleP5sNDmnP/9EodkaKFeQJ/g
	vPz8E96IJnpn+MMRZZCNrjgN7Rspilq5dcMpJpT6PLilRQKOMvKh7Vjdb7psbHbumpSEWlcBqxE
	j4w==
X-Google-Smtp-Source: AGHT+IGuB80kepjVY6GU7N10vM5dzh4IgkERFfdumXmvvWAycN/WJPPjMEVepXbJZUSB39DoOq+2y2AV3HE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6c16:0:b0:5dc:4a5f:a5ee with SMTP id
 y22-20020a656c16000000b005dc4a5fa5eemr27846pgu.1.1712702966899; Tue, 09 Apr
 2024 15:49:26 -0700 (PDT)
Date: Tue, 9 Apr 2024 15:49:25 -0700
In-Reply-To: <20240215235405.368539-11-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-11-amoorthy@google.com>
Message-ID: <ZhXF9QTBgKHVO0ay@google.com>
Subject: Re: [PATCH v7 10/14] KVM: selftests: Report per-vcpu demand paging
 rate from demand paging test
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
> Using the overall demand paging rate to measure performance can be
> slightly misleading when vCPU accesses are not overlapped. Adding more
> vCPUs will (usually) increase the overall demand paging rate even
> if performance remains constant or even degrades on a per-vcpu basis. As
> such, it makes sense to report both the total and per-vcpu paging rates.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 09c116a82a84..6dc823fa933a 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -135,6 +135,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	struct timespec ts_diff;
>  	struct kvm_vm *vm;
>  	int i;
> +	double vcpu_paging_rate;
>  
>  	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
>  				 p->src_type, p->partition_vcpu_memory_access);
> @@ -191,11 +192,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  			uffd_stop_demand_paging(uffd_descs[i]);
>  	}
>  
> -	pr_info("Total guest execution time: %ld.%.9lds\n",
> +	pr_info("Total guest execution time:\t%ld.%.9lds\n",
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
> -	pr_info("Overall demand paging rate: %f pgs/sec\n",
> -		memstress_args.vcpu_args[0].pages * nr_vcpus /
> -		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
> +
> +	vcpu_paging_rate =
> +		memstress_args.vcpu_args[0].pages
> +		/ ((double)ts_diff.tv_sec
> +			+ (double)ts_diff.tv_nsec / NSEC_PER_SEC);

*sigh*

For the umpteenth time, please follow kernel coding style.  Either

	vcpu_paging_rate = memstress_args.vcpu_args[0].pages /
			   ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC);

or

	vcpu_paging_rate = memstress_args.vcpu_args[0].pages /
			   ((double)ts_diff.tv_sec +
			    (double)ts_diff.tv_nsec / NSEC_PER_SEC);

I don't have a strong preference, so I'll go with the first one when applying.

