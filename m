Return-Path: <kvm+bounces-59239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05453BAF38A
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 08:22:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FCB1170EC7
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 06:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E7F2D739C;
	Wed,  1 Oct 2025 06:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g83fPaov"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451A926D4CA
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 06:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759299712; cv=none; b=HQQmCCEBiONjGk22m5dPirTTMWSssPbdsvSEvxI5iP/GggwPVaUM5ZXaLEAdgIppOewE8W71NrKnFX7+R8tq83bLT96j/8TA/UiL9pC3+FwU62zEH2oTBj/jDavgmcnvEiazdxLPXTJSfjuvXrLs6QXEagrTvuCChYQ1gzbOuxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759299712; c=relaxed/simple;
	bh=CnpYtzn8PUc0ZBYLdHGVpOdTJPVwWMwJAwS94JAPcks=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cxXfexyavRgmrEJuk4eRErACAlkmaYwP25Mpfoeeh4Dha3fr2VylTUJUoEH2mUT93UrbTlGqO9KYrRUNrosO1VumtKOieHWu2DIPTimpLedXc1ctsmcROzwNI+/ihn8PLZwVNhBPvoaCY1A2HC3wiip0gVv4qDYx06H/2L9Cj+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g83fPaov; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-269880a7bd9so82957585ad.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 23:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759299708; x=1759904508; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gKyzk1pWtrNabjmeFySfVdKtKDt4rOVB/cSEsmccNXs=;
        b=g83fPaov2u0cDHkCnR3/lI62BOO7z45fEvMJ42bbRY2JHWLE2gm6K/XMqfEz3COvTd
         Af1pl36jnPeYTE3JQXHnRta4hZMGs8CnuUte8NrR4foGZts5w5u/uteEW5V7/weTcL2q
         LP4X2pyeWlVIIgldfuvZOB7o4Df3B+j/I+hSIDrpS15VElNbbQqwlxc2n4prLJ+vc5O9
         jfXwXPikix3fuejz14TbEpEx8z6Nczw2xFJl29pM3BtD61gBAqxRo4kUCCrvaOiAnvlh
         PE1FXfWtk5boNvTBr4u6egTqUc42WsaPfTcWbca9VGjjHIJAckly5WpQOJ0jpNddGDje
         ZRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759299708; x=1759904508;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gKyzk1pWtrNabjmeFySfVdKtKDt4rOVB/cSEsmccNXs=;
        b=et+mSt0lFdp5tRzaSqggCq9YOwRqW9+XrVy7N2R0bFGzS/o+CiS1WSfU9JohiRq5MP
         ci9u2SbEIDpaFpHzIC67SkLUXotbeFtx5TvMkCKhypqNoGUUjhX9XWaL9yzGw6urwnb0
         yfWLcbP3ixwumuRN12bLs5EziQI0dF1V1ebqGYLs16dGYwW9Jw+Bzuf5+QgMCwxEtFHv
         FwV6y5tYKld8VWWI1gMfcFP6b6EYoq1Fm3J9syuReYW2lsY907uBhV3JYt+ieyCWBOiI
         b2vfqkWFxbadZvBGMPczZE96hJdps8XDT+6Lc8Ssrk7t0MDnCmrMu2ELbVRPzgHso/Uh
         he5g==
X-Forwarded-Encrypted: i=1; AJvYcCUeADkKqvB4SnnxdcHoyz6m6l//ZW1I5TBKyikXipGXiywS9H+qRD+dmyOaJPLm5bdvMr0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb+Jq3DV/LzO/zp4xbZoSkQstODqMfFwzpBQvBihcJ5o5oQAer
	bEl5FgVofZBorDSXcoVoxYA4Tp/SOfbRfLCmLZYqx2StCjMVfSeBPCI/9MG1XK0c7ZZ4daP7YdM
	HybmqJFnpIBeEyr1dsE+c0O8Uwg==
X-Google-Smtp-Source: AGHT+IHE0M7fuh9/BYVbAm929jP+iKH/pWdowlRc+CxCehWBNW7QMDY1Rz46MkircjbJVl76AmtAEEEYRxQN81OqOg==
X-Received: from plbjw19.prod.google.com ([2002:a17:903:2793:b0:273:c5f4:a8ca])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1251:b0:283:c950:a783 with SMTP id d9443c01a7336-28e7f437ef7mr31963025ad.56.1759299708586;
 Tue, 30 Sep 2025 23:21:48 -0700 (PDT)
Date: Wed, 01 Oct 2025 06:21:47 +0000
In-Reply-To: <20250807094503.4691-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094503.4691-1-yan.y.zhao@intel.com>
Message-ID: <diqzh5wj2lc4.fsf@google.com>
Subject: Re: [RFC PATCH v2 17/23] KVM: guest_memfd: Split for punch hole and
 private-to-shared conversion
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, seanjc@google.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vannapurve@google.com, vbabka@suse.cz, 
	thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com, 
	fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	chao.p.peng@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

Thanks Yan! Just got around to looking at this, sorry about the delay!

> In TDX, private page tables require precise zapping because faulting back
> the zapped mappings necessitates the guest's re-acceptance. Therefore,
> before performing a zap for hole punching and private-to-shared
> conversions, huge leafs that cross the boundary of the zapping GFN range in
> the mirror page table must be split.
>
> Splitting may result in an error. If this happens, hole punching and
> private-to-shared conversion should bail out early and return an error to
> userspace.
>
> Splitting is not necessary for kvm_gmem_release() since the entire page
> table is being zapped, nor for kvm_gmem_error_folio() as an SPTE must not
> map more than one physical folio.
>
> Therefore, in this patch,
> - break kvm_gmem_invalidate_begin_and_zap() into
>   kvm_gmem_invalidate_begin() and kvm_gmem_zap() and have
>   kvm_gmem_release() and kvm_gmem_error_folio() to invoke them.
>

I think perhaps separating invalidate and zip could be a separate patch
from adding the split step into the flow, that would make this patch
smaller and easier to review.

No action required from you for now, I have the the above part in a
separate patch already (not yet posted).

> - have kvm_gmem_punch_hole() to invoke kvm_gmem_invalidate_begin(),
>   kvm_gmem_split_private(), and kvm_gmem_zap().
>   Bail out if kvm_gmem_split_private() returns error.
>

IIUC the current upstream position is that hole punching will not
be permitted for ranges smaller than the page size for the entire
guest_memfd.

Hence no splitting required during hole punch?

+ 4K guest_memfd: no splitting required since the EPT entries will not
  be larger than 4K anyway
+ 2M and 1G (x86) guest_memfd: no splitting required since the entire
  EPT entry will have to go away for valid ranges (valid ranges are
  either 2M or 1G anyway)

Does that sound right?

> - drop the old kvm_gmem_unmap_private() and have private-to-shared
>   conversion to invoke kvm_gmem_split_private() and kvm_gmem_zap() instead.
>   Bail out if kvm_gmem_split_private() returns error.
>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> 
> [...snip...]
> 
> @@ -514,6 +554,8 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
>  					   struct conversion_work *work,
>  					   bool to_shared, pgoff_t *error_index)
>  {
> +	int ret = 0;
> +
>  	if (to_shared) {
>  		struct list_head *gmem_list;
>  		struct kvm_gmem *gmem;
> @@ -522,19 +564,24 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
>  		work_end = work->start + work->nr_pages;
>  
>  		gmem_list = &inode->i_mapping->i_private_list;
> +		list_for_each_entry(gmem, gmem_list, entry) {
> +			ret = kvm_gmem_split_private(gmem, work->start, work_end);
> +			if (ret)
> +				return ret;
> +		}

Will be refactoring the conversion steps a little for the next version
of this series, hence I'd like to ask about the requirements before
doing splitting.

The requirement is to split before zapping, right? Other than that
we technically don't need to split before checking for a safe refcount, right?

>  		list_for_each_entry(gmem, gmem_list, entry)
> -			kvm_gmem_unmap_private(gmem, work->start, work_end);
> +			kvm_gmem_zap(gmem, work->start, work_end, KVM_FILTER_PRIVATE);
>  	} else {
>  		unmap_mapping_pages(inode->i_mapping, work->start,
>  				    work->nr_pages, false);
>  
>  		if (!kvm_gmem_has_safe_refcount(inode->i_mapping, work->start,
>  						work->nr_pages, error_index)) {
> -			return -EAGAIN;
> +			ret = -EAGAIN;
>  		}
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
> 
> [...snip...]
> 
> @@ -1906,8 +1926,14 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
>  	start = folio->index;
>  	end = start + folio_nr_pages(folio);
>  
> -	list_for_each_entry(gmem, gmem_list, entry)
> -		kvm_gmem_invalidate_begin_and_zap(gmem, start, end);
> +	/* The size of the SEPT will not exceed the size of the folio */

I think splitting might be required here, but that depends on whether we
want to unmap just a part of the huge folio or whether we want to unmap
the entire folio.

Lots of open questions on memory failure handling, but for now I think
this makes sense.

> +	list_for_each_entry(gmem, gmem_list, entry) {
> +		enum kvm_gfn_range_filter filter;
> +
> +		kvm_gmem_invalidate_begin(gmem, start, end);
> +		filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED;
> +		kvm_gmem_zap(gmem, start, end, filter);
> +	}
>  
>  	/*
>  	 * Do not truncate the range, what action is taken in response to the
> -- 
> 2.43.2

