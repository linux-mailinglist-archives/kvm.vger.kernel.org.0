Return-Path: <kvm+bounces-37979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56534A32C95
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 17:57:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A922416812E
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 16:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D42253B5B;
	Wed, 12 Feb 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fh8g+JEj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1A120C49B
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739379329; cv=none; b=jdpx3VnUBsFPzOCGD1fHI/dPBo5rYfakAxenGo1sQPxGZrejR2Js2zMt7RjGsn4cxOnT1g4tbg9OAna9u3H3atr0/Me8FPSa1yp+vR/G++0IFsxunoz8P8fVsEqI3xCDIYeUn+VelwJa0iQSqU+eZuqZF7tCfpD9a6c3UEasbSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739379329; c=relaxed/simple;
	bh=YtzoYDgzpy6pcZX2IAgQDHvkotWEKTU0BuzcJgQ9MPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UGimvHN7FhLi6fawsaG9Ud/Q3N+X204HFxSAh+yd5ASlLMGRzNB0MGH9IwNOmc+UdiMa3IUfmMeXtgm7rmG7idYMjlJkg+HO0Kxsh0Bta0DXJItQsyXrYJzrKrKI2x9emIQE3msB0dXTSQi3ZwCZXMa8Xix262Yth1ZJxC+jhsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fh8g+JEj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739379326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pT6CTjFrOLhJorGKJn+D4FrRUNui6hX7fK3tVGEIdYQ=;
	b=Fh8g+JEjo9T3rGuYJr0QulaJzz8tJHF26HKSuzzh8QlqA4JS10UHtfdybKsZArMBOvbOo7
	47nhtxzBWEzrVkX/DYNL+/PPgl9fFerbj1qWeJ3owcC+hHD8XOr930lMPe7bgM+zDVQZEz
	ZbazmJIx5ZBD8MoZE9y20J3BVf3jbBg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474--hhu9PKXPo6sXgmWbgl-qQ-1; Wed, 12 Feb 2025 11:55:22 -0500
X-MC-Unique: -hhu9PKXPo6sXgmWbgl-qQ-1
X-Mimecast-MFC-AGG-ID: -hhu9PKXPo6sXgmWbgl-qQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38ddcb63ed1so2266808f8f.1
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 08:55:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739379321; x=1739984121;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pT6CTjFrOLhJorGKJn+D4FrRUNui6hX7fK3tVGEIdYQ=;
        b=bQpXdRQfaxJkvLB25UuAwv7xfTQp4gK+RVhkVRefnLH3QXS0pWghG65XrohjSi5Acd
         aiYzxCr7MGCzX5CfGx8apkL9L/WoKwlogUBooSizH/ZT/igv3fPGFy9jRpTJM0ygq0Er
         5ZiQQksOtrQC2gUf/OlvP/sZ/OYii0p25c8SS0UOD7sfOFOgjWNmHcFMLRJf5vd0B5os
         HxvtkMJ0LD6820AvusZXPpla4ZkG9AVGSviSxoNbZ4//xSey+ebCw8ImzdEJxCyLDx3q
         eYq5P/LFjD5cfkrjatGOUi81hjy8x3ikyn7TQvhWBrf6bkiKZJTXraxb9n17myEMnH6X
         +nzA==
X-Gm-Message-State: AOJu0YxtJekKwJGQW8VRaLdme6mHcJogSb5jzLHxzQu2eXbrOL+WK1tR
	ziEc+UaAcOe49DHXwTeOHz7+5udcRp4444i421tfJSKlZZHKfcxCk4JsxMwzkvyaM3sMXeY23Qy
	uS61TbrQ/ueI2V3MchMxJeNmuGK0M4NflfIvhOU8ympXDj4uiXA==
X-Gm-Gg: ASbGnctRQSS3/06AkudTVRz0PUaZdgwweiNdpGxmzXOGaP2MMJwA3YIST27hrW9eknj
	9rfDLtlmTPHkTVCLMBXeCSXnNgISl0HOzS3tQignUimGp0e//fVl7vrpirMx86n8b1ka5zDZm6I
	/7Q+WUAH9zvniUOmd4/whsJBzcJbBzI5QpAd9QICVQqe1LSWz3s3rnGN/2Qshs8ZBVFlSsZJK+d
	KuTCdfkN8vT8fLpHUGYdoW3d2+DDi5o7h5AzrYozNyYuRP2Fez/wg0Fmkjfb/evwO3DJtHitjnM
	7xUpjt37/WRXlqexmnn8X6sewbytc6yTXzJlPdkDsGzVTcNNyEmYBW1aeLEgHu9Yzs4+ZPTar5x
	IWPFirTNaHQL5H3wiPU53D0czr29w3Q==
X-Received: by 2002:a05:6000:1887:b0:38d:dee1:e2c5 with SMTP id ffacd0b85a97d-38dea258b98mr3147091f8f.1.1739379321508;
        Wed, 12 Feb 2025 08:55:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHL06ur7FX+LjTYf/yM5jysT2/Yd7qfRICLBRwLuqnvhK/1h8ilRWQNZoESX9MlTdPpnUb6cw==
X-Received: by 2002:a05:6000:1887:b0:38d:dee1:e2c5 with SMTP id ffacd0b85a97d-38dea258b98mr3147070f8f.1.1739379320922;
        Wed, 12 Feb 2025 08:55:20 -0800 (PST)
Received: from ?IPV6:2003:cb:c70c:a600:1e3e:c75:d269:867a? (p200300cbc70ca6001e3e0c75d269867a.dip0.t-ipconnect.de. [2003:cb:c70c:a600:1e3e:c75:d269:867a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38e54f521f3sm1966427f8f.83.2025.02.12.08.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 08:55:19 -0800 (PST)
Message-ID: <d5ef124a-d353-4074-925e-a2721be3ce5d@redhat.com>
Date: Wed, 12 Feb 2025 17:55:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL v2 09/20] KVM: s390: move pv gmap functions into kvm
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
 borntraeger@de.ibm.com
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
 <20250131112510.48531-10-imbrenda@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250131112510.48531-10-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31.01.25 12:24, Claudio Imbrenda wrote:
> Move gmap related functions from kernel/uv into kvm.
> 
> Create a new file to collect gmap-related functions.
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> [fixed unpack_one(), thanks mhartmay@linux.ibm.com]
> Link: https://lore.kernel.org/r/20250123144627.312456-6-imbrenda@linux.ibm.com
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Message-ID: <20250123144627.312456-6-imbrenda@linux.ibm.com>
> ---

This patch breaks large folio splitting because you end up un-refing
the wrong folios after a split; I tried to make it work, but either
because of other changes in this patch (or in others), I
cannot get it to work and have to give up for today.

Running a simple VM backed by memory-backend-memfd
(which now uses large folios) no longer works (random refcount underflows /
freeing of wrong pages).



The following should be required (but according to my testing insufficient):

 From 71fafff5183c637f20830f6f346e8c9f3eafeb59 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Wed, 12 Feb 2025 16:00:32 +0100
Subject: [PATCH] KVM: s390: fix splitting of large folios

If we end up splitting the large folio, doing a put_page() will drop the
wrong reference (unless it was the head page), because we are holding a
reference to the old (large) folio. Similarly, doing another
page_folio() after the split is wrong.

The result is that we end up freeing a page that is still mapped+used.

To fix it, let's pass the page and call split_huge_page() instead.

As an alternative, we could convert all code to use folios, and to
look up the page again from the page table after our split; however, in
context of non-uniform folio splits [1], it make sense to pass the page
where we really want to split.

[1] https://lkml.kernel.org/r/20250211155034.268962-1-ziy@nvidia.com

Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
  arch/s390/include/asm/gmap.h |  3 ++-
  arch/s390/kvm/gmap.c         |  4 ++--
  arch/s390/mm/gmap.c          | 13 +++++++++++--
  3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 4e73ef46d4b2a..0efa087778135 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -139,7 +139,8 @@ int s390_replace_asce(struct gmap *gmap);
  void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
  int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
  			    unsigned long end, bool interruptible);
-int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
+int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio,
+		struct page *page, bool split);
  unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
  
  /**
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 02adf151d4de4..c2523c63afea3 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -72,7 +72,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
  		return -EFAULT;
  	if (folio_test_large(folio)) {
  		mmap_read_unlock(gmap->mm);
-		rc = kvm_s390_wiggle_split_folio(gmap->mm, folio, true);
+		rc = kvm_s390_wiggle_split_folio(gmap->mm, folio, page, true);
  		mmap_read_lock(gmap->mm);
  		if (rc)
  			return rc;
@@ -100,7 +100,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
  	/* The folio has too many references, try to shake some off */
  	if (rc == -EBUSY) {
  		mmap_read_unlock(gmap->mm);
-		kvm_s390_wiggle_split_folio(gmap->mm, folio, false);
+		kvm_s390_wiggle_split_folio(gmap->mm, folio, page, false);
  		mmap_read_lock(gmap->mm);
  		return -EAGAIN;
  	}
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 94d9277858009..3180ad90a255a 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2631,12 +2631,18 @@ EXPORT_SYMBOL_GPL(s390_replace_asce);
   * kvm_s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split
   * @mm:    the mm containing the folio to work on
   * @folio: the folio
+ * @page:  the folio page where to split the folio
   * @split: whether to split a large folio
   *
+ * If a split of a large folio was requested, the original provided folio must
+ * no longer be used if this function returns 0. The new folio must be looked
+ * up using page_folio(), to which we will then hold a reference.
+ *
   * Context: Must be called while holding an extra reference to the folio;
   *          the mm lock should not be held.
   */
-int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
+int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio,
+		struct page *page, bool split)
  {
  	int rc;
  
@@ -2645,7 +2651,10 @@ int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool
  	lru_add_drain_all();
  	if (split) {
  		folio_lock(folio);
-		rc = split_folio(folio);
+		/* Careful: split_folio() would be wrong. */
+		rc = split_huge_page(page);
+		if (!rc)
+			folio = page_folio(page);
  		folio_unlock(folio);
  
  		if (rc != -EBUSY)
-- 
2.48.1


With that, the VM still starts to freeze at some point.



There are other issues with this patch: you are no longer holding the PTL
while doing the conversion, so concurrent GUP-slow is now possible while
converting pages.

The refcount freezing (that I previously raised as problematic) is now
*more wrong* than before.


You buried way too many non-subtle changes in this patch with a
two-line patch description, I'm afraid ...

-- 
Cheers,

David / dhildenb


