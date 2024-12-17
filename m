Return-Path: <kvm+bounces-34007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD4D9F5AD7
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 969647A0746
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 23:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FCFF1FA8E6;
	Tue, 17 Dec 2024 23:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aEqBqRnX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8891E489
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 23:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734479989; cv=none; b=MgvLlQX8k/Dte024KV0Spd5OoWyqlVE/9yq3I2Rxd8SY9+qkPW8HfJL6lbRTjHzaaFaiVQ3pR7qPD3++DwB6FvS1jpS+5s8VaK5LctuL1o5VNmaN/UWcGEP7TI2yELyL7JO3Ae7+xjJ8I2HLDl8fZ3RIYAFDPKhDDbcl0gMDLS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734479989; c=relaxed/simple;
	bh=HQcTbZF4VMZK8Gh4tXVj30gF2zRoK9ozXa54vb+6DVg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PSp4NSKdhjOTqc8BltpzMQ1dJQPVLaAJu5TB/VSHhsWSMXiGALDdGk1AUeQtiZdDcE7s8RM+EZjpbcbqKmJ3hiTkCY8KJjVMmlO5dbauKEW4c7UBvPPkvxWyRnSo2Q/IVtKAS1+LjL6qgrvdcUfwVXXlmrjMk9md1EMPmLxM9bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aEqBqRnX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734479986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xsypa/lk2ZGEp9VFcicxVIBsaAtVG1MIYQ3EBVCbIQM=;
	b=aEqBqRnX2pe2cM0XM0SHZESy0zTzYj7z66y1NPAas8e4iCNXWFxfyDQkVWSmmY3z7YAYvd
	XR96UvLei4NYQqRvJW1Pl3fAYn5Sl+xY1o/bCEQEGHMm7WT2GLVuykVoaO9rYnPp1jf56g
	J2w7VXemqAJqhyDWPHQw48JpLHdvm1I=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-jLcfPw_fMnyS-9CUNTXRFw-1; Tue, 17 Dec 2024 18:59:45 -0500
X-MC-Unique: jLcfPw_fMnyS-9CUNTXRFw-1
X-Mimecast-MFC-AGG-ID: jLcfPw_fMnyS-9CUNTXRFw
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a9d195e6e5so60465725ab.2
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 15:59:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734479984; x=1735084784;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xsypa/lk2ZGEp9VFcicxVIBsaAtVG1MIYQ3EBVCbIQM=;
        b=a0M7sreDldedZv7p1smZ2g/YnyIdPJnJ0Q94tDcf96zm0xpMso+jXiRS9Yi8le2nlZ
         oimxnIAwEkT54p2QYTXTMJI7Y3P/4/0xBinQShjCAmpgP0f6A5nq7bX2U229jR56Qmgi
         J2H/XaRiZvYXOwKku8J4s3zjuKkDpRsw5lYy69Jv9wS/WW1/4Rk58Bq3GbkzS+3UJb0Y
         cuSue6wArqmOhveGd/C2gSvKPVpbLv3YIvC2xLfsNXTwhuyAVZot++1wtozuiK5axpQp
         1CLzn5yDmuzIEALEyod5HrWeoGbJyY3AFx1Cl6odeZGgEENsGooNFU754E2Hjb1h4pAx
         DAzg==
X-Gm-Message-State: AOJu0YykU797alxNHH2VAMvxoy9kIryqlsWNxC2CBJ0yBjEd9nuQeMQe
	Bjbw1x1SGl1AMIk5bmKeanefMkNA6BzvIhUYwAcDrKJH/bXjAaLlyxo4L+bDfu89+SrOKk1wbFi
	J+0kQxj8v6caJKhtKWFG1CeVPv/UbpeJUv9Y9HtiBgTNPSsdRjw==
X-Gm-Gg: ASbGnct2auBFoAq+FAjdYKw/+M65dLfD/3G3Gx8J0u7TSdGcwOj09TcKaSKf7re3V7Z
	I/ufCkSiEvcEQb37SIyGU1dUX8gOTN/SxU9z/2W1BQeX11+EI99tdju5v6hn8fLLFnqDRzqSo46
	ENWYOUTEUdFFmIQA/waGKMQZT5H/INcMhE9EhE+/m3roCTKLhkF+FUT8qY33CtEZrwSPlJ7TUyl
	Ty04SYxlpaVJidp8AtEQgiLUWrtRThYUmMiqBcgwISJSpL+BVxCCHOn
X-Received: by 2002:a05:6e02:1a6f:b0:3a7:6566:1e8f with SMTP id e9e14a558f8ab-3bdc437a770mr6531585ab.16.1734479984509;
        Tue, 17 Dec 2024 15:59:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEh6/ypJZLhK7ivl0lgAtAroRZ1XmcT/bT9+gVvRVYoPSUO/W9REARAZoYFbA0fbPyZB29Hmg==
X-Received: by 2002:a05:6e02:1a6f:b0:3a7:6566:1e8f with SMTP id e9e14a558f8ab-3bdc437a770mr6531445ab.16.1734479984103;
        Tue, 17 Dec 2024 15:59:44 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b24cf3ae02sm24028405ab.49.2024.12.17.15.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 15:59:43 -0800 (PST)
Message-ID: <5b5b12bdc8a653901f28c754fcdced9103ae5c27.camel@redhat.com>
Subject: Re: [PATCH 05/20] KVM: selftests: Precisely track number of
 dirty/clear pages for each iteration
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 18:59:42 -0500
In-Reply-To: <20241214010721.2356923-6-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> Track and print the number of dirty and clear pages for each iteration.
> This provides parity between all log modes, and will allow collecting the
> dirty ring multiple times per iteration without spamming the console.
> 
> Opportunistically drop the "Dirtied N pages" print, which is redundant
> and wrong.  For the dirty ring testcase, the vCPU isn't guaranteed to
> complete a loop.  And when the vCPU does complete a loot, there are no
Typo
> guarantees that it has *dirtied* that many pages; because the writes are
> to random address, the vCPU may have written the same page over and over,
> i.e. only dirtied one page.

Counting how many times a vCPU wrote is also a valid statistic

I think it would be the best to include it as well (e.g call it number of
loops that vCPU did).

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 55a744373c80..08cbecd1a135 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -388,8 +388,6 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
>  
>  	if (READ_ONCE(dirty_ring_vcpu_ring_full))
>  		dirty_ring_continue_vcpu();
> -
> -	pr_info("Iteration %ld collected %u pages\n", iteration, count);
>  }
>  
>  static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
> @@ -508,24 +506,20 @@ static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu)
>  static void *vcpu_worker(void *data)
>  {
>  	struct kvm_vcpu *vcpu = data;
> -	uint64_t pages_count = 0;
>  
>  	while (!READ_ONCE(host_quit)) {
> -		pages_count += TEST_PAGES_PER_LOOP;
>  		/* Let the guest dirty the random pages */
>  		vcpu_run(vcpu);
>  		log_mode_after_vcpu_run(vcpu);
>  	}
>  
> -	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
> -
>  	return NULL;
>  }
>  
>  static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  {
> +	uint64_t page, nr_dirty_pages = 0, nr_clean_pages = 0;
>  	uint64_t step = vm_num_host_pages(mode, 1);
> -	uint64_t page;
>  	uint64_t *value_ptr;
>  	uint64_t min_iter = 0;
>  
> @@ -544,7 +538,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  		if (__test_and_clear_bit_le(page, bmap)) {
>  			bool matched;
>  
> -			host_dirty_count++;
> +			nr_dirty_pages++;
>  
>  			/*
>  			 * If the bit is set, the value written onto
> @@ -605,7 +599,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  				    " incorrect (iteration=%"PRIu64")",
>  				    page, *value_ptr, iteration);
>  		} else {
> -			host_clear_count++;
> +			nr_clean_pages++;
>  			/*
>  			 * If cleared, the value written can be any
>  			 * value smaller or equals to the iteration
> @@ -639,6 +633,12 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  			}
>  		}
>  	}
> +
> +	pr_info("Iteration %2ld: dirty: %-6lu clean: %-6lu\n",
> +		iteration, nr_dirty_pages, nr_clean_pages);
> +
> +	host_dirty_count += nr_dirty_pages;
> +	host_clear_count += nr_clean_pages;
>  }
>  
>  static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,


