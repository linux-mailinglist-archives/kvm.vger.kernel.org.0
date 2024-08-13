Return-Path: <kvm+bounces-23954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6F5F9501FF
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC4051C219D0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E34B189F2A;
	Tue, 13 Aug 2024 10:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JPNGQhJ7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBE218953E
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 10:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543551; cv=none; b=eAeeDWDVnhMxEd8Xqo1GeS3+cYVKc/wrmzNdWyKK7VcgcpHE0SAqrvc/Y4igUBIFD3Zstf/ZsX9ZdeZscFOfR9d3y3vXQs7q0vxxYDFg9Na8XYznx3EOgkN1PdQBXbnlMx0R3L0olqHq4gkRPfuMYlGrxYgJkUEm0jgFCv6J/Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543551; c=relaxed/simple;
	bh=SIqkAmHVUUXo9gIo/oirsfR0e+gn7P2a/puEtNWyr+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JQHB6hXsbGNuoFOCtXsbQDEj52brofpJJJU3tSoCturK7kWK6pXu1uTeY/A8ZTkFsFAGcM4KPuPQ1x0A7ei2OoYbbeRCdKJM/OWP4FGNLdv6qV8kh1e4i6SDd74WdNsO5ckYLFieGawMbJgno+ATt3TG6IiJlMNnfaQbkCEkkdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JPNGQhJ7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723543548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uROH7v1naDO1yoBW6O+4CuT2I7Tx636SclZAGT40JcU=;
	b=JPNGQhJ7FJx7XiE+foAjqb9UQclUsk+oe1DyynFun1VyHsgg97XQyGfR6SYuds9X/UenmH
	GLHOgk7UE6BazXlFNwGOpNZEG5RMMuVVj5uZ9wB3aGcpL0uLdedvQ4CYuel7JEuJ14YJA6
	X9amQoK62MSAOZtXAyplj2aGmuC9bno=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-VGplRzJIPQ2kF2-nk_hAaQ-1; Tue, 13 Aug 2024 06:05:47 -0400
X-MC-Unique: VGplRzJIPQ2kF2-nk_hAaQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a7a83f54fdeso429664466b.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 03:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723543546; x=1724148346;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uROH7v1naDO1yoBW6O+4CuT2I7Tx636SclZAGT40JcU=;
        b=AIVyr+GtbBjnh2zwZO9ME+7YHzpDuuanSKxh3fcfQi4Z0Rm/ue3YLLevVURovtYQZ8
         GDeHwP5hBtKW0ZZrZzHXQFHzgGFqQM9bnkcAzxxVMQ1oLVQnqSVVrnq/k7a9Q6fR5ETE
         zCQoLiGl5wyhMA2BsfFPW8oPDyuZbH/oJiosW4miyBSzrKmLaSe1zdsJC4JIGDQSXz0C
         hrjwTq/BlajVtZOnVNkU4xS6Wng+y29axJ3Sil1jD2ODmPuaVFE4tUpIV0Ixu9i0zAnX
         p/stCxEKcZ7NvJXkPlZBl3OmcWtd4TqUS3rtYvzqExPK7QwTjDM73vhnwjmLUoAeaQky
         V6mQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6Npo5ZRICUX80GSkRQuNR65UrQ5yVxh+2U1ARIz0hPivh1c4b38k0Jgy1eSk3V5unH3r/G0ilFYwb/tAC6wh4ulvQ
X-Gm-Message-State: AOJu0YzISTJNdIKRJDk+CoPDP12OBqr618BXR/MoNH/MuKnnaimtGucl
	8MFChIMsZ4X0qRtb1Gwo2eTV1LbaNaJ5UzBtMEyy+h5+OH7769NCFNYvn+hFdFtNW9dFfqAA9DN
	aGtSarsl9NGjMz6knaI+F3b7defvXsm/x12xSC4bQiJwe1dDBbA==
X-Received: by 2002:a17:907:97c7:b0:a6f:e47d:a965 with SMTP id a640c23a62f3a-a80ed24e0b9mr214469366b.41.1723543546414;
        Tue, 13 Aug 2024 03:05:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnARFcmXdlzQ9tLl1mHMjR3SzbPtHmebygC46BjheDqodgjcVDCVIod5rD3BeTIayx73Q5pQ==
X-Received: by 2002:a17:907:97c7:b0:a6f:e47d:a965 with SMTP id a640c23a62f3a-a80ed24e0b9mr214466866b.41.1723543545916;
        Tue, 13 Aug 2024 03:05:45 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a80f3feab58sm56342766b.95.2024.08.13.03.05.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 03:05:45 -0700 (PDT)
Message-ID: <d8265f6d-8867-4c1a-b715-70bd8c5fb2b2@redhat.com>
Date: Tue, 13 Aug 2024 12:05:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SVM: Fix an error code in
 sev_gmem_post_populate()
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Sean Christopherson <seanjc@google.com>
Cc: error27@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Brijesh Singh <brijesh.singh@amd.com>,
 Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240612115040.2423290-2-dan.carpenter@linaro.org>
 <20240612115040.2423290-4-dan.carpenter@linaro.org>
 <ZrrbSFVpVs0eX1ZQ@google.com>
 <bed4d818-ef19-4e87-8cdf-cca00d34e6f7@stanley.mountain>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <bed4d818-ef19-4e87-8cdf-cca00d34e6f7@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 09:51, Dan Carpenter wrote:
> On Mon, Aug 12, 2024 at 09:04:24PM -0700, Sean Christopherson wrote:
>> On Wed, Jun 12, 2024, Dan Carpenter wrote:
>>> The copy_from_user() function returns the number of bytes which it
>>> was not able to copy.  Return -EFAULT instead.
>>
>> Unless I'm misreading the code and forgetting how all this works, this is
>> intentional.  The direct caller treats any non-zero value as a error:
>>
>> 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
>>
>> 		put_page(pfn_to_page(pfn));
>> 		if (ret)
>> 			break;
>> 	}
>>
>> 	filemap_invalidate_unlock(file->f_mapping);
>>
>> 	fput(file);
>> 	return ret && !i ? ret : i;
>>
> 
> No, you're not reading this correctly.  The loop is supposed to return the
> number of pages which were handled successfully.  So this is saying that if the
> first iteration fails and then return a negative error code.  But with the bug
> then if the first iteration fails, it returns the number of bytes which failed.

Yes, you're supposed to return 0 or -errno, so that you return -errno on 
the first round.  Applying the patches, 1/2 is also a bugfix even if the 
printks may be overkill.

Thanks for the report!

Paolo

> The units are wrong pages vs bytes and the failure vs success is reversed.
> 
> Also I notice now that i isn't correct unless we hit a break statement:
> 
> virt/kvm/guest_memfd.c
>     647          npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> 
> If there isn't enough pages, we use what's available.
> 
>     648          for (i = 0; i < npages; i += (1 << max_order)) {
> 
> If we exit because i >= npages then we return success as if we were able to
> complete one final iteration through the loop.
> 
>     649                  struct folio *folio;
>     650                  gfn_t gfn = start_gfn + i;
>     651                  bool is_prepared = false;
>     652                  kvm_pfn_t pfn;
>     653
>     654                  if (signal_pending(current)) {
>     655                          ret = -EINTR;
>     656                          break;
>     657                  }
>     658
>     659                  folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &is_prepared, &max_order);
>     660                  if (IS_ERR(folio)) {
>     661                          ret = PTR_ERR(folio);
>     662                          break;
>     663                  }
>     664
>     665                  if (is_prepared) {
>     666                          folio_unlock(folio);
>     667                          folio_put(folio);
>     668                          ret = -EEXIST;
>     669                          break;
>     670                  }
>     671
>     672                  folio_unlock(folio);
>     673                  WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
>     674                          (npages - i) < (1 << max_order));
>     675
>     676                  ret = -EINVAL;
>     677                  while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
>     678                                                          KVM_MEMORY_ATTRIBUTE_PRIVATE,
>     679                                                          KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>     680                          if (!max_order)
>     681                                  goto put_folio_and_exit;
>     682                          max_order--;
>     683                  }
>     684
>     685                  p = src ? src + i * PAGE_SIZE : NULL;
>     686                  ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
>                          ^^^^^^^^^^^^^^^^^^^^
> post_populate() is a pointer to sev_gmem_post_populate() which has is supposed
> to return negative error codes but instead returns number of bytes which failed.
> 
>     687                  if (!ret)
>     688                          kvm_gmem_mark_prepared(folio);
>     689
>     690  put_folio_and_exit:
>     691                  folio_put(folio);
>     692                  if (ret)
>     693                          break;
>     694          }
>     695
>     696          filemap_invalidate_unlock(file->f_mapping);
>     697
>     698          fput(file);
>     699          return ret && !i ? ret : i;
>     700  }
> 
> regards,
> dan carpenter
> 
> 


