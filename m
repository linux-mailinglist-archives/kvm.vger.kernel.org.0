Return-Path: <kvm+bounces-25230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FBF796219D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 09:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFCE31F22218
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 07:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59CC15AADE;
	Wed, 28 Aug 2024 07:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XdlWGO6b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF57154C14
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 07:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724831054; cv=none; b=rFVcQGs+lLu/e3dfs0Kh8uwXwX2XrINuxgqtjFZwP3G1ieZpGOVRbR7wooFzArWstklCgAFwZzH2EEk1l+Eyd2TE1qx4vpA12nQL+EqPr27E5mxPqmWwHCUeA0eWVrPKVDuCYbz9ADUUabio1JZmw7YJluVno9lHmevFf8i41Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724831054; c=relaxed/simple;
	bh=pBLtJq4s73xh2cjpN4kC6RLgw89TDOXstgUBrcX9m40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KrLAqitsnAeikin0I8hK0Rl+kxHksImnH+6r3IHnaqcFcbpFCbwNvyTnFLhZYhgZdttpHqQnmfYtxNcLkN1U/Ft9y20lUfsCsufBZTi+x+8UlRiFoGUPmf4lU3csKiaay6+jd7UOlKLmurPkHxegQmqCAiON3jZI5IDkheYPf9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XdlWGO6b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724831051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7N/N7EySHgMZNfOn7Q8wISSQCYSIyWuumjkgTJGfaus=;
	b=XdlWGO6bO1qrh9qCU76Qlap3ng8X2YLQV9fpeRkztw/761NR2tffSOiIfScPXX9+Kmb/AK
	Qs1AiQis4yPHl0cJ2RSpZxc47scOHI9PwqriDOKhdg59IamKhYN6XHmjsrXfASmfYn45ty
	0itH/mkZZYll5u6ftJlfQzm7ZcLSsUI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-YPNcwXjsM_yshPGpD0Nzww-1; Wed, 28 Aug 2024 03:44:09 -0400
X-MC-Unique: YPNcwXjsM_yshPGpD0Nzww-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42b8a5b7fd9so41046635e9.0
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 00:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724831047; x=1725435847;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7N/N7EySHgMZNfOn7Q8wISSQCYSIyWuumjkgTJGfaus=;
        b=RO1XHy5l62q6xE4aqtTlKsFiuzM7+mmcYVC1rbIGLhxjwKsiWBTTzsbhQdK4VyeAU4
         6zTFkpI73tQ138Rxyy6cSuRXACo9Hq+3U/gCohch5sSbJcHmR/8gpw/SXmGZPioGyK+b
         HHEc482adxaYxdg1MX21UXdentoUjuQoeLgCx6kQsYoPWhETeh5B7Pbo68yqscBMxTgI
         jIcEm2ifjmqqAuPQyp2mMf1aHCBcWaOcTupAij/UK2m3lmHB0h2uDvuXuY4N/izX4O43
         4MS7A4xjQF9yxaknO5lDwC2L/IZ4UubxthI1pCiEYTVUwUwrmdUTQqK4Lh8DQTx3gmyh
         hVaA==
X-Forwarded-Encrypted: i=1; AJvYcCVT2c8TGiXT9HzuQSZNcdWzlFXLHjh964y1TnipnS4slfexTS0YBQVKKgyzqo4hhkI0lSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEJ+/uzFxIpNQlsXmxG9Gbl+NU8B1S0fhgwFJVAe3GclhR1PkI
	X7JEwo89p2vkWkXRth6IydQw/ZLo0xEpXlKZBrLX3MC7aRXty8U0ZBs4VrgEHCDCuGaTRyfuDOY
	Ik0RdUZSGOAB5SJXSQecJDroMJilaimNBxVw+7lJOHcQscGDX5w==
X-Received: by 2002:a05:600c:1c84:b0:428:ea8e:b48a with SMTP id 5b1f17b1804b1-42ba668f868mr7870915e9.8.1724831047508;
        Wed, 28 Aug 2024 00:44:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGNfE/x5JNboZ3wOdvgwPEyQhfNJxFysCUo6sWqqNsWoDvs7V4uxx3adC2CETnntwi3H68mg==
X-Received: by 2002:a05:600c:1c84:b0:428:ea8e:b48a with SMTP id 5b1f17b1804b1-42ba668f868mr7870465e9.8.1724831046443;
        Wed, 28 Aug 2024 00:44:06 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:1700:6b81:27cb:c9e2:a09a? (p200300cbc70617006b8127cbc9e2a09a.dip0.t-ipconnect.de. [2003:cb:c706:1700:6b81:27cb:c9e2:a09a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3730814602asm14910248f8f.44.2024.08.28.00.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 00:44:05 -0700 (PDT)
Message-ID: <9f9d7e96-b135-4830-b528-37418ae7bbfd@redhat.com>
Date: Wed, 28 Aug 2024 09:44:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/19] mm/pagewalk: Check pfnmap for folio_walk_start()
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Sean Christopherson <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>,
 Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
 Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-7-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240826204353.2228736-7-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.08.24 22:43, Peter Xu wrote:
> Teach folio_walk_start() to recognize special pmd/pud mappings, and fail
> them properly as it means there's no folio backing them.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   mm/pagewalk.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index cd79fb3b89e5..12be5222d70e 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -753,7 +753,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
>   		fw->pudp = pudp;
>   		fw->pud = pud;
>   
> -		if (!pud_present(pud) || pud_devmap(pud)) {
> +		if (!pud_present(pud) || pud_devmap(pud) || pud_special(pud)) {
>   			spin_unlock(ptl);
>   			goto not_found;
>   		} else if (!pud_leaf(pud)) {
> @@ -783,7 +783,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
>   		fw->pmdp = pmdp;
>   		fw->pmd = pmd;
>   
> -		if (pmd_none(pmd)) {
> +		if (pmd_none(pmd) || pmd_special(pmd)) {
>   			spin_unlock(ptl);
>   			goto not_found;
>   		} else if (!pmd_leaf(pmd)) {

As raised, this is not the right way to to it. You should follow what
CONFIG_ARCH_HAS_PTE_SPECIAL and vm_normal_page() does.

It's even spelled out in vm_normal_page_pmd() that at the time it was
introduced there was no pmd_special(), so there was no way to handle that.



diff --git a/mm/memory.c b/mm/memory.c
index f0cf5d02b4740..272445e9db147 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -672,15 +672,29 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
  {
         unsigned long pfn = pmd_pfn(pmd);
  
-       /*
-        * There is no pmd_special() but there may be special pmds, e.g.
-        * in a direct-access (dax) mapping, so let's just replicate the
-        * !CONFIG_ARCH_HAS_PTE_SPECIAL case from vm_normal_page() here.
-        */
+       if (IS_ENABLED(CONFIG_ARCH_HAS_PMD_SPECIAL)) {
+               if (likely(!pmd_special(pmd)))
+                       goto check_pfn;
+               if (vma->vm_ops && vma->vm_ops->find_special_page)
+                       return vma->vm_ops->find_special_page(vma, addr);
+               if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
+                       return NULL;
+               if (is_huge_zero_pmd(pmd))
+                       return NULL;
+               if (pmd_devmap(pmd))
+                       /* See vm_normal_page() */
+                       return NULL;
+               return NULL;
+       }
+
+       /* !CONFIG_ARCH_HAS_PMD_SPECIAL case follows: */
+
         if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
                 if (vma->vm_flags & VM_MIXEDMAP) {
                         if (!pfn_valid(pfn))
                                 return NULL;
+                       if (is_huge_zero_pmd(pmd))
+                               return NULL;
                         goto out;
                 } else {
                         unsigned long off;
@@ -692,6 +706,11 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
                 }
         }
  
+       /*
+        * For historical reasons, these might not have pmd_special() set,
+        * so we'll check them manually, in contrast to vm_normal_page().
+        */
+check_pfn:
         if (pmd_devmap(pmd))
                 return NULL;
         if (is_huge_zero_pmd(pmd))



We should then look into mapping huge zeropages also with pmd_special.
pmd_devmap we'll leave alone until removed. But that's indeoendent of your series.

I wonder if CONFIG_ARCH_HAS_PTE_SPECIAL is sufficient and we don't need additional
CONFIG_ARCH_HAS_PMD_SPECIAL.

As I said, if you need someone to add vm_normal_page_pud(), I can handle that.

-- 
Cheers,

David / dhildenb


