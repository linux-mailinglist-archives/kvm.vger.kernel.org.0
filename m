Return-Path: <kvm+bounces-35042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F8FA08FC8
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:53:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E8497A1265
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB2620C00C;
	Fri, 10 Jan 2025 11:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XZv/vaO+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D2720B21B
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736510000; cv=none; b=HqBIXa71RG7NHQvf5jVgB5OhoRYcUacN9I2866DgqFZUiowregaRBMGI+288MnzaQF3IzTP8Jq5Sdt3gvlNmX4BmoaxN2bHqZmyDlRGOQzqgW35jrD6PVGforSktZgiONvoLB4kybJ8qQbkDbdQIqFGozC6WgEMkDFcyQga/Nfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736510000; c=relaxed/simple;
	bh=7p1z5DJHAHpITG2rSdZ+5jr/3hm1yrjKREgyWp5znQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RSK5JSFLGfFxeDuJ/ThoFeVoz+FPZpR86BfGMbO5AkaNobYeqZjgqNmlQDOdhRDPSPtRhoOqsdv+6jdez0IMGd1OX91fsXzBLjR7J2TdfCK8dUpgzb+KxrsP8+7sPnurDaHjV6jAaiAy3NQQJ1rHaLnBwC7s3vB+366t57NE/94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XZv/vaO+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736509997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OJ7D7jd77wgn7TfbcIkjiA6ENc25epVzOEpkgfz5J3g=;
	b=XZv/vaO+SWpFEHbXMLM7uziH+PmZoKDCqdy9VlfX+HOmq9QPwgD28gH9YV/LKFfdWrKFYM
	ZpxQWVxnxHLKVW0f+mEdluA4/iMZLzuj1VRUf6c4r212sSFoShOwrR/rPtG8aw0HSEphjj
	zLITvZDr/XZvQ6N8FFkDBN5PJTPrhNQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-cL2ddgwSN2-fygcF9TZZIg-1; Fri, 10 Jan 2025 06:53:15 -0500
X-MC-Unique: cL2ddgwSN2-fygcF9TZZIg-1
X-Mimecast-MFC-AGG-ID: cL2ddgwSN2-fygcF9TZZIg
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4362f893bfaso10647045e9.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:53:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736509994; x=1737114794;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OJ7D7jd77wgn7TfbcIkjiA6ENc25epVzOEpkgfz5J3g=;
        b=W4DoZFQEyHNyJ82eWIUtLRc5ZmH8LKv7Epx8a0TG1Muv/iccJ6e/bDhw3g9QniToRI
         IwDbOKJDonc3GYGtD/Hgv+kFPARTqrJ4uQDhr7PJ/qS5ZPHIvoFvRivYtBvJiUIq4VXY
         KgIWDXBCmtMAa+BA5ogZiFBBWkYYZVOe0t52EvJJxiqVPwxOsn2VHrZWcioGSi1yW0YF
         a3EUbSA5BebhbOkqOOBvv3YpCTzud4U3YIDlD03ncN2k2A/D2qx4V1rmcTysAr63XrLW
         GqBhSoGOkkRDFg9ZLbCsuZTAPuAUVjNcVHEd4QGbDnbVHKpHJ01DtNfhS/pXkpncc6+O
         5OcA==
X-Gm-Message-State: AOJu0Yz/wXVo1qVt29hVZf6O1xkxw5+DeJyo9bSz5f3Gf5XU2PUwikqH
	6xXHhEep/sSKUTURl5hEXAUC146G6GashTVfrstQ7Id2WVJJR3c8QDxoDYoutZF2gbMoreWmIPu
	YnZgfe4fdYlDyYhYiYoXB6ygToMToatKXYDJhK5mO6ScXRdDiww==
X-Gm-Gg: ASbGncuexz/oLdlMjMC3PBQHwok74m6yKBgj3BFhYb85EMd+icXOWfJ5fAPQ5QnViKR
	Fd88kazJ46MK9vEHhh1aAMLTiGqTwv93Q34k7EFpMBUbVM//n8hk72IQf/1l3erGCLlD6dS1ixl
	7PsA0nzcU7/iDwSJTFnn+BzwHVVlHkCVuQPXNx+8QBhKhKJkU2KlLykkYkl3W5sL0n2xpDi/4C5
	m22EM7r49VHHvKDev08NentXBempZaIRJAaKvzizOEgBq8Oxe8YMhnSrt/hU/+ehJPq2BszaE6F
	m6TZCdkrDW0pnKjXKT6lIQSBiaGR/YdSDBZoLehryr4/Ezi2JpwAEU5lkYmXhLmeBkCrRGWOtHQ
	Bt1br4jTC
X-Received: by 2002:a05:600c:4449:b0:435:192:63ca with SMTP id 5b1f17b1804b1-436e26f481cmr83759115e9.21.1736509994496;
        Fri, 10 Jan 2025 03:53:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEr04+sG9GmLMzU7iQ10X3OopNgvus89461G5VzLiMDTUS+KSY8jOUmzTxuMTk+ZhTm3AOnHQ==
X-Received: by 2002:a05:600c:4449:b0:435:192:63ca with SMTP id 5b1f17b1804b1-436e26f481cmr83758985e9.21.1736509994119;
        Fri, 10 Jan 2025 03:53:14 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:e100:4f41:ff29:a59f:8c7a? (p200300cbc708e1004f41ff29a59f8c7a.dip0.t-ipconnect.de. [2003:cb:c708:e100:4f41:ff29:a59f:8c7a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9e62126sm49842585e9.34.2025.01.10.03.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 03:53:12 -0800 (PST)
Message-ID: <1d020344-37e0-4386-a064-ddd0ca71d110@redhat.com>
Date: Fri, 10 Jan 2025 12:53:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] KVM: SEV: fix wrong pinning of pages
To: yangge1116@126.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
 21cnbao@gmail.com, baolin.wang@linux.alibaba.com, liuzixing@hygon.cn
References: <1736509376-30746-1-git-send-email-yangge1116@126.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <1736509376-30746-1-git-send-email-yangge1116@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.01.25 12:42, yangge1116@126.com wrote:
> From: yangge <yangge1116@126.com>
> 
> When pin_user_pages_fast() pins SEV guest memory without the
> FOLL_LONGTERM flag, the pages will not get migrated out of MIGRATE_CMA/
> ZONE_MOVABLE, violating these mechanisms to avoid fragmentation with
> unmovable pages, for example making CMA allocations fail.
> 
> To address the aforementioned problem, we propose adding the
> FOLL_LONGTERM flag to the pin_user_pages_fast() function.
> 
> Signed-off-by: yangge <yangge1116@126.com>
> ---
> 
> V2:
> - update code and commit message suggested by David
> 
>   arch/x86/kvm/svm/sev.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd07..96f3b8e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -630,6 +630,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>   	unsigned long locked, lock_limit;
>   	struct page **pages;
>   	unsigned long first, last;
> +	unsigned int flags = FOLL_LONGTERM;
>   	int ret;
>   
>   	lockdep_assert_held(&kvm->lock);
> @@ -662,8 +663,10 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>   	if (!pages)
>   		return ERR_PTR(-ENOMEM);
>   
> +	flags |= write ? FOLL_WRITE : 0;
> +
>   	/* Pin the user virtual address. */
> -	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
> +	npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
>   	if (npinned != npages) {
>   		pr_err("SEV: Failure locking %lu pages.\n", npages);
>   		ret = -ENOMEM;

Sorry, looking into it in more detail, there are some paths that immediately unpin again,
and don't seem to have longterm semantics.


Could we do the following, so longterm pinning would be limited to the memory regions
that might stay pinned possible forever?

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d37..4b0f03f0ea741 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -622,7 +622,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
  
  static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
                                     unsigned long ulen, unsigned long *n,
-                                   int write)
+                                   int flags)
  {
         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
         unsigned long npages, size;
@@ -663,7 +663,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
                 return ERR_PTR(-ENOMEM);
  
         /* Pin the user virtual address. */
-       npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
+       npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
         if (npinned != npages) {
                 pr_err("SEV: Failure locking %lu pages.\n", npages);
                 ret = -ENOMEM;
@@ -751,7 +751,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
         vaddr_end = vaddr + size;
  
         /* Lock the user memory. */
-       inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
+       inpages = sev_pin_memory(kvm, vaddr, size, &npages, FOLL_WRITE);
         if (IS_ERR(inpages))
                 return PTR_ERR(inpages);
  
@@ -1250,7 +1250,8 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
                 if (IS_ERR(src_p))
                         return PTR_ERR(src_p);
  
-               dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
+               dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n,
+                                      FOLL_WRITE);
                 if (IS_ERR(dst_p)) {
                         sev_unpin_memory(kvm, src_p, n);
                         return PTR_ERR(dst_p);
@@ -1316,7 +1317,8 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
         if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
                 return -EFAULT;
  
-       pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
+       pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n,
+                              FOLL_WRITE);
         if (IS_ERR(pages))
                 return PTR_ERR(pages);
  
@@ -1798,7 +1800,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
  
         /* Pin guest memory */
         guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-                                   PAGE_SIZE, &n, 1);
+                                   PAGE_SIZE, &n, FOLL_WRITE);
         if (IS_ERR(guest_page)) {
                 ret = PTR_ERR(guest_page);
                 goto e_free_trans;
@@ -2696,7 +2698,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
                 return -ENOMEM;
  
         mutex_lock(&kvm->lock);
-       region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
+       region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
+                                      FOLL_WRITE | FOLL_LONGTERM);
         if (IS_ERR(region->pages)) {
                 ret = PTR_ERR(region->pages);
                 mutex_unlock(&kvm->lock);


Thoughts?

-- 
Cheers,

David / dhildenb


