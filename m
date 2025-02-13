Return-Path: <kvm+bounces-38098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 374C3A34F3D
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 21:17:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7EB016DE30
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 20:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4B626618D;
	Thu, 13 Feb 2025 20:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CvXanDkF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D37C24BBF5
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 20:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477841; cv=none; b=Zw+DlLcc51mTcUPKEyb4lbmE52332Z55TvfVIx8BOszqb2I28tG3K8Yfamq+u07PG6pS/bKu+Anu6g9S+t8g5PXhpEqQ7/wDRO8Dc5DgxI4xxeBXAfxyNunz8h6Rsp32QqjEKQOmGpbxn04Z9x6K0Nr/9suITD6Y5ZpR11NnF9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477841; c=relaxed/simple;
	bh=HoQdF3QeQ4LrH7HA1RKzuYHX+mrbRfrzTEJLz+xuTIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M0hZxC+WLLLOnFccRdcJwl+cCQ9F23utOPa9nqplERpcMRz2Ea1S7Sg9ny+TEOkXPW1+ZBciPJzLFwsYQjxzvBNRpZR2nXpCtFGWz/iUxeTyOBdNYLteYnvqgOSbHGtaXm0pUE9uYOGsA79bChOYEVQSRXSadEqEzRPU8B4h/fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CvXanDkF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BGo3+h2k5TPDqtNzkqC5kdvh2J3BneuEnbq2jY5Hj3I=;
	b=CvXanDkF7HwEOTQ3ry2JfYpUarAaDxOE06qkqBYWCjHsVSnJ6gQJLILD92Hkf5CGt6kGcj
	rbaQIq56jMFIAoh7bD7/fTHg+N0uotBftc3ClJOyxmn3otdxjZUGcg0tFcrD6pYp5GcO0h
	KOfhkHMMdz6p2XTsReHajaAa7tbM2iI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-A4ARV3ZLMHOszOwVYa1A1w-1; Thu, 13 Feb 2025 15:17:15 -0500
X-MC-Unique: A4ARV3ZLMHOszOwVYa1A1w-1
X-Mimecast-MFC-AGG-ID: A4ARV3ZLMHOszOwVYa1A1w_1739477834
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4395f1c4366so7138695e9.3
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 12:17:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477834; x=1740082634;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BGo3+h2k5TPDqtNzkqC5kdvh2J3BneuEnbq2jY5Hj3I=;
        b=PzHILXTIMWct2xDTnRxwdszBjiYeJSfhXegbSUHfFJDleJsyQa0ci5imeMiu3T8dUt
         aWEWQZa3t1OKlDku6H+9rIJvqywpdZ7bx68ST3RDvC0W81s2R/Zr6RoLojOxKBeUwFZ8
         2A7NHBYyDy4dnNb6H8GtU4Z0y+GBMszBCrSlK4XogVpwaBWio5i3AtQjtliVY9ePYbDl
         X9UUbLXdEWal8G2pYoZCEUZlayYt7jy4346yo1iodx8aYE7g5u79xe4dImbM40D3KY+R
         3U4S0UV1YOKKOeM51DIdLTKAJvFNqGGx4qxH3wHKYg6HLjTqdeduA3np+tDTfDp7e69h
         uyMg==
X-Forwarded-Encrypted: i=1; AJvYcCXwvCA/JTAImOTBHPmydRZA75kl1PJjnqWV/mbXEBPT1E5BrzMbdK/v9Bw23zOOYRzqRSg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvYHJMPbH9v+3O93MYaYB7CwR1JjBXdeT7ASIhHyDUH5azGH45
	0lhjG3j2KrEMzfpzKDnJBEqFafkbA3aQBepR/7UbZywFs2+sfKZ0rqaETHeGnxf1o+m9pY3he3t
	BpJhdMMPyB9id+TLfxjILJawvC3GNhwtzDXz8lCDC+1mUMDNecYoGejl2xlsB
X-Gm-Gg: ASbGncvdGCmeXvkFlosyvh2Bei9XARE1AEjODfMA//YwfMjjVt9fXOMEVzNimXtLpmb
	uGwboD37VcgqhGAfHu9MSZO8mE63ZN0xmLDm/0h5/+ooJA1rRfhiGMjIASvaem3yAVXfLdz6ldA
	UHHCb06pWvISwvWSapslCKNx9CLNTmcqxi6AhEWRkm/un3bq8Pb/I7ONhK9CwZY7GrJub+ndrrI
	2sjEI7iSdaNuw7ZX6wDAjPEUM/ylN1FsrhE3ICOcKce75vv/cXrsMVYEAoRoc966tWmDgJsEFFn
	etVUlBQ/b1+dpGqQqR/j+4HdXganMFx87io=
X-Received: by 2002:a05:600c:1c84:b0:434:fa55:eb56 with SMTP id 5b1f17b1804b1-43958169fa4mr113436225e9.7.1739477834104;
        Thu, 13 Feb 2025 12:17:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGOwQrzMx6mzF34oagv4phSuZe+sFnsgm7REJuXPhoW4eKwVPGPx8edkZ281TMbOD8fUrHCnw==
X-Received: by 2002:a05:600c:1c84:b0:434:fa55:eb56 with SMTP id 5b1f17b1804b1-43958169fa4mr113435915e9.7.1739477833820;
        Thu, 13 Feb 2025 12:17:13 -0800 (PST)
Received: from [192.168.3.141] (p5b0c6c7e.dip0.t-ipconnect.de. [91.12.108.126])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a04f217sm56924685e9.1.2025.02.13.12.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 12:17:12 -0800 (PST)
Message-ID: <e58310a9-0fd7-44fa-b66b-b98502dbed30@redhat.com>
Date: Thu, 13 Feb 2025 21:17:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] KVM: s390: fix issues when splitting folios
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com,
 seiden@linux.ibm.com, nsg@linux.ibm.com, schlameuss@linux.ibm.com,
 hca@linux.ibm.com
References: <20250213200755.196832-1-imbrenda@linux.ibm.com>
 <20250213200755.196832-2-imbrenda@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250213200755.196832-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


> +	struct folio *folio = page_folio(page);
>   	int rc;
>   
>   	lockdep_assert_not_held(&mm->mmap_lock);
> @@ -2645,7 +2646,11 @@ int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool
>   	lru_add_drain_all();
>   	if (split) {
>   		folio_lock(folio);
> -		rc = split_folio(folio);
> +		rc = min_order_for_split(folio);
> +		if (rc > 0)
> +			rc = -EINVAL;
> +		if (!rc)
> +			rc = split_huge_page_to_list_to_order(page, NULL, 0);

split_huge_page() ?

But see my reply to #2. Likely we should just undo the refactorings you 
added while moving the code.

-- 
Cheers,

David / dhildenb


