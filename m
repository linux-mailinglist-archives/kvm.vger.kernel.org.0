Return-Path: <kvm+bounces-48303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E78CACC9BC
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDB5D16B52D
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F3023BD06;
	Tue,  3 Jun 2025 15:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aOwDhbZP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF03B23BCFA
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748962816; cv=none; b=prewJzeHfZiLOo2GddD+QpDsl80WUsKFBFisgg+OelY7WsFuPUIWlHvrelQMMRnNDKWLatHsENc6lr2Dy3KiZGAg6kh7Wq4tAx+AtmFQc6NwXH7bLn1LknQnZrJLZzSZH98arH00lMmE0bDoOlNtamBbllZdF5a1dp1CbUfktnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748962816; c=relaxed/simple;
	bh=2wCcZ40YlHg1AP69vHb743eYrYArwutGgJ4BTNHP0fQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SC/nc2zZ3fvORm3wC+j9mHvApKB6k3VfHxpU59EOi9F52JwGQRh6mbpsIILkNUS+4XaLoBd8KHj5mjNcYL2Ntk26WhU0ImW9gOxvp7Sjp+p3zf2cB2UKYonnbOMsm5y09C7lczClHqNKRzbsDLUeKLitn7O3bXPytRV3ahA6y4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aOwDhbZP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748962813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g+dIIIYyxHS9v9K4PBJF74g0AZoB1AyRX95eDD+xEyg=;
	b=aOwDhbZPb88DoIpiIbCQ3S0P2caIqRZA/vjdv/JJ42KwcH9+mKkF1S5I2U5/mAFKoyLeWx
	fUJyyxei9xREbPxK0YEBj/Q42diWujfaZAJFsWQMoJRlUYUwjqu24V4mtobVfFXHy2pe3r
	gHKEoo/hNmWDz5xvhTm2dzuZtFJDLmM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-H2xbNq7oP8i8Z6gQCRNprw-1; Tue, 03 Jun 2025 11:00:12 -0400
X-MC-Unique: H2xbNq7oP8i8Z6gQCRNprw-1
X-Mimecast-MFC-AGG-ID: H2xbNq7oP8i8Z6gQCRNprw_1748962811
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4e6d426b1so3338785f8f.1
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 08:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748962810; x=1749567610;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g+dIIIYyxHS9v9K4PBJF74g0AZoB1AyRX95eDD+xEyg=;
        b=Jke9VV8o43CvIwXUMIaEcf/9A0fw7i+LXrnbbaRfAI2FD5ShjuQzhMdO2mg2stUHg/
         HvsWBEUMhHvGOAhMB/T9RPGFSisyvUlhezNaAWXAEsozj0GhM7EUhnoBzgPI7sNkRzoa
         b6wr0zDgpKWZm9yMi6ZE8dAZ8LLJBwq+lQdtp+xf/z6yN/uumB9mawBKU1eDWZiexwhz
         pzVCmIVPnsD9FMkUZqUPp8MuNIM2MRVdNzvDaNU9buo3SkYOCKxSUjU0qlgLcD9NpuQy
         5AnEXg7g1zDkzJEYnXYO1U/fMb+HibzK9az5exQfgtGjmgSyAo3oNndqAanQsZRRGTk5
         JbSQ==
X-Forwarded-Encrypted: i=1; AJvYcCV31w7Q3z8MMLismoTKmeQnnRLTwGf3mNK1832HRjZ6YKfqS5Cc0ee8jhMbp4oAV4t1CzI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/h28DcTNdhBKezOj+KbrQlkPkljPjE1oYzGNxdCgW/h0VzKQj
	y0vdk933XBAS3QwdhKiyZYBmlS43TTxWH5JeXJwQcUs/0uynqseeKQKib/YfhCsDsgbhP0HFovI
	ryVd9YPz2KPnyFboH4hXkjX9bvqKI16w+CrwMW7JsalWET89KT+nL8ZjmPUyHNg==
X-Gm-Gg: ASbGncuNzBNUm3tPCbuBY/XnBpJEVtDDYpdUvgGFPfkS0qqzOngA6clWr7/O9mcBK5I
	9RIHE+ZWB3rdJneFRsSJ0zH8ubsxdl2uwP6HOUVILq6NGLcS9412Ju5ZiIxpQdtH7ZdnGbD/dtk
	ID86CcuOiESSlUyxhoqk8tsSFjf1FYY9dJ2ndFUB2hHY6K+a38jWLt+UnRHKxCZGMd8gk5WgOHN
	gOmnopAxviWfJ8xzUnpVxxLPPeiky7XW0r19uj0zo9eLE9b9Nhkcv7K84yQk7m2XIBWBWPS5SfW
	2voCWavnSkWMpQ==
X-Received: by 2002:a5d:5f8b:0:b0:3a4:e61e:dc93 with SMTP id ffacd0b85a97d-3a514168df6mr2905657f8f.1.1748962810469;
        Tue, 03 Jun 2025 08:00:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERxE6vjPv3Alya/l3ZEG+0zNp6BtrLK0c6PZq+9U/5Tde4ILNEcZxIBkCuMYqeuJyMe6KRzg==
X-Received: by 2002:a5d:5f8b:0:b0:3a4:e61e:dc93 with SMTP id ffacd0b85a97d-3a514168df6mr2905615f8f.1.1748962810036;
        Tue, 03 Jun 2025 08:00:10 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a4efe6c4f2sm18313949f8f.22.2025.06.03.08.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 08:00:09 -0700 (PDT)
Message-ID: <d0983ba3-383b-4c81-9cfd-b5b0d26a5d17@redhat.com>
Date: Tue, 3 Jun 2025 17:00:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Prefault memory on page state change
To: Xiaoyao Li <xiaoyao.li@intel.com>, Tom Lendacky
 <thomas.lendacky@amd.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Michael Roth <michael.roth@amd.com>
References: <f5411c42340bd2f5c14972551edb4e959995e42b.1743193824.git.thomas.lendacky@amd.com>
 <4a757796-11c2-47f1-ae0d-335626e818fd@intel.com>
 <cc2dc418-8e33-4c01-9b8a-beca0a376400@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <cc2dc418-8e33-4c01-9b8a-beca0a376400@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/25 13:47, Xiaoyao Li wrote:
> On 6/3/2025 3:41 PM, Xiaoyao Li wrote:
>> On 3/29/2025 4:30 AM, Tom Lendacky wrote:
>>> A page state change is typically followed by an access of the page(s) 
>>> and
>>> results in another VMEXIT in order to map the page into the nested page
>>> table. Depending on the size of page state change request, this can
>>> generate a number of additional VMEXITs. For example, under SNP, when
>>> Linux is utilizing lazy memory acceptance, memory is typically 
>>> accepted in
>>> 4M chunks. A page state change request is submitted to mark the pages as
>>> private, followed by validation of the memory. Since the guest_memfd
>>> currently only supports 4K pages, each page validation will result in
>>> VMEXIT to map the page, resulting in 1024 additional exits.
>>>
>>> When performing a page state change, invoke KVM_PRE_FAULT_MEMORY for the
>>> size of the page state change in order to pre-map the pages and avoid 
>>> the
>>> additional VMEXITs. This helps speed up boot times.
>>
>> Unfortunately, it breaks TDX guest.
>>
>>    kvm_hc_map_gpa_range gpa 0x80000000 size 0x200000 attributes 0x0 
>> flags 0x1
>>
>> For TDX guest, it uses MAPGPA to maps the range [0x8000 0000, 
>> +0x0x200000] to shared. The call of KVM_PRE_FAULT_MEMORY on such range 
>> leads to the TD being marked as bugged
>>
>> [353467.266761] WARNING: CPU: 109 PID: 295970 at arch/x86/kvm/mmu/ 
>> tdp_mmu.c:674 tdp_mmu_map_handle_target_level+0x301/0x460 [kvm]
> 
> It turns out to be a KVM bug.
> 
> The gpa passed in in KVM_PRE_FAULT_MEMORY, i.e., range->gpa has no 
> indication for share vs. private. KVM directly passes range->gpa to 
> kvm_tdp_map_page() in kvm_arch_vcpu_pre_fault_memory(), which is then 
> assigned to fault.addr
> 
> However, fault.addr is supposed to be a gpa of real access in TDX guest, 
> which means it needs to have shared bit set if the map is for shared 
> access, for TDX case. tdp_mmu_get_root_for_fault() will use it to 
> determine which root to be used.
> 
> For this case, the pre fault is on the shared memory, while the 
> fault.addr leads to mirror_root which is for private memory. Thus it 
> triggers KVM_BUG_ON().
So this would fix it?

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7b3f1783ab3c..66f96476fade 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4895,6 +4895,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
  {
  	u64 error_code = PFERR_GUEST_FINAL_MASK;
  	u8 level = PG_LEVEL_4K;
+	u64 direct_bits;
  	u64 end;
  	int r;
  
@@ -4909,15 +4910,18 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
  	if (r)
  		return r;
  
+	direct_bits = 0;
  	if (kvm_arch_has_private_mem(vcpu->kvm) &&
  	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
  		error_code |= PFERR_PRIVATE_ACCESS;
+	else
+		direct_bits = kvm_gfn_direct_bits(vcpu->kvm);
  
  	/*
  	 * Shadow paging uses GVA for kvm page fault, so restrict to
  	 * two-dimensional paging.
  	 */
-	r = kvm_tdp_map_page(vcpu, range->gpa, error_code, &level);
+	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
  	if (r < 0)
  		return r;
  


I'm applying Tom's patch to get it out of his queue, but will delay sending
a pull request until the Linux-side fix is accepted.

Paolo


