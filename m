Return-Path: <kvm+bounces-43272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F302EA88CB5
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 22:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F03B47A56B9
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 20:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B951D63E4;
	Mon, 14 Apr 2025 20:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnOtYSaO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06464C74
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 20:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744661212; cv=none; b=aiPbpoL7VdNSzRMtz8G8updsjYezzKB+GtbeNANvRoVtG43b0PmLDtX840zEiBMcHOxErHwzjNH7Kf4A7hog/aJCMdsOafQcRNhsT4/RDrdi1eFgtKsr/YiAvYGniWNIadMqSTPnN7PAO4igVZc0HU4QAc2jEpQnAZcqoPh3dGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744661212; c=relaxed/simple;
	bh=bjof40Oe8oZffe5m0H7UXVU1SJyZUkGNNoMuWi0YE4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q0i2tlKbhsTV8wuMuy8FEMqskUtq7NLrXwAOUsnA/GnY8GyI5BanHUecY8tlgRm+y1BgrJBYW7ljFwJCJoFtT8xxf2rUhEaktE3TsPtdRpShdrxe71mBG5DzHa/hAtB81wGrU3bvS37JG3gjrt7sRP361ZWjpSRhbPkegjdam+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QnOtYSaO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744661209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/VoNLY522EUSQix+UxcqxZxQw3e+mWwlSzo4SaHBxWA=;
	b=QnOtYSaOmG6UNmL0JTGulqxuijWB1N2d9SNR/Rcol6XelRymAmhsQp8f9ljSkMxr9mTWEW
	EX8r5MK3HosHc1cv9z0pHIoAHBwZRMxDINBLBMuGpn5g1IehmXSnNerxUsaZtWwo9u/c66
	ELr3PUwqcrwqKg37WaYahvHcXc+3JHw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-VAQOjAEmPxe3ZEpkrnhg-A-1; Mon, 14 Apr 2025 16:06:48 -0400
X-MC-Unique: VAQOjAEmPxe3ZEpkrnhg-A-1
X-Mimecast-MFC-AGG-ID: VAQOjAEmPxe3ZEpkrnhg-A_1744661207
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cf327e9a2so41767315e9.3
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 13:06:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744661207; x=1745266007;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/VoNLY522EUSQix+UxcqxZxQw3e+mWwlSzo4SaHBxWA=;
        b=ocI3pOWjnHN8+GH8UzXDRkPQyYCuyd0oINq9p1MnsrA4l2jGvc//yzd/n3QBPJno5h
         Z3GzXynbEgRK57yioiimFkXxfrX9DlbAJ/PFjThTpyQDbyOhOivHOVw/NMigpFagwPov
         FLfZHgPuShXVnpvFbz0dkVBjBYm6U0atXD/7KgsdUchokw8dcwegi6fsXFOFbeyUa6Hj
         7g/P0gMV5phn2mxKtdDWbj55mkTBLohcculbGKmQ9zZFQ5Xz3OlKt8bZSOVufDLEUl9W
         /+e1LLs3P19WBqHTdXbeg2pnVKfgGAGQn+xptiE37z2DXIIFFdcy7Milf5ula4BDcwYx
         D4mQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1LPGSpbeQwahJ/Kr/Iy5ZiYvxQiBLrig3D/B08JQhcfpH9mEQjs2HDd2493LulnMBN2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDTbPexfFbT6XSF0ANpNOFujKe/T8iwSPdjBcpsOaP0aLohNgS
	/BMOthgq4Uxws+QKQGtU6ncElM8Oolb7L9wdw4yRJQAn5eCKDYaaOKSWV1LgedTUF6BvlCbZ6lm
	OvcXm5qNBnvChzMUD2O7L/dqbve0wiy3hJxCbx5WYrOh4FCy29w==
X-Gm-Gg: ASbGncthSIY4q31CeiSzDT2HQ5NEVYzlEG+eqS1hZUuXtSKEF0LWmMhg0/4+ULrke4o
	cChAJprBEwN7XKq7WFHasb4nlEfyrW+d2QbkA9ARGVEDbQw0m5EjN3Z5Ct+gmEozMDzX9MyWoDM
	4dYoKriy3ZoX0s9PucJmcMxi+d9wlF7z7QgoFuc+yuOU2zKH+32iQ3viMdDI6IlzTz+CvVOKCyQ
	3Koikg5POv9F+km+T5Y0ZwM4I8rHoSIlPXW4phKlPIetil1eQ15A7y4C7QBd/6/0gnHmwSiXW+W
	AmhTYVD0OV3S/N7ScMo/7I2Ha/VU1ZV7SheYQ5lc9Q4/DpzpQVyGu1wldq7zKuuaB4SMse03cn/
	0YpyD+h2NGzdooEKNsoFRjfRSShNReI2hQAD3Yg==
X-Received: by 2002:a05:600c:3b93:b0:43c:f64c:44a4 with SMTP id 5b1f17b1804b1-43f3a93ce18mr104254045e9.8.1744661206918;
        Mon, 14 Apr 2025 13:06:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvTvYarqLTM4UYcLcjnVp1vOLoR8wE0NcgvLEBgH0WfuPeaJ6KS6r/LWs2p+n3Gn9skxc81A==
X-Received: by 2002:a05:600c:3b93:b0:43c:f64c:44a4 with SMTP id 5b1f17b1804b1-43f3a93ce18mr104253705e9.8.1744661206503;
        Mon, 14 Apr 2025 13:06:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f02:2900:f54f:bad7:c5f4:9404? (p200300d82f022900f54fbad7c5f49404.dip0.t-ipconnect.de. [2003:d8:2f02:2900:f54f:bad7:c5f4:9404])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f235a5d57sm188361965e9.34.2025.04.14.13.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Apr 2025 13:06:45 -0700 (PDT)
Message-ID: <6121b93b-6390-49e9-82db-4ed3a6797898@redhat.com>
Date: Mon, 14 Apr 2025 22:06:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
To: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-5-tabba@google.com>
 <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
 <diqzplhe4nx5.fsf@ackerleytng-ctop.c.googlers.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <diqzplhe4nx5.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> I've been thinking long about this, and was wondering if we should instead
>> clean up the code to decouple the "private" from gmem handling first.
>>
> 
> Thank you for making this suggestion more concrete, I like the renaming!
> 

Thanks for the fast feedback!

>> I know, this was already discussed a couple of times, but faking that
>> shared memory is private looks odd.
>>
>> I played with the code to star cleaning this up. I ended up with the following
>> gmem-terminology  cleanup patches (not even compile tested)
>>
>> KVM: rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
>> KVM: rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
>> KVM: rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
>> KVM: x86: rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
>> KVM: rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
> 
> Perhaps zooming into this [1] can clarify a lot. In
> kvm_mmu_max_mapping_level(), it was
> 
>    bool is_private = kvm_slot_has_gmem(slot) && kvm_mem_is_private(kvm, gfn);
> 
> and now it is
> 
>    bool is_gmem = kvm_slot_has_gmem(slot) && kvm_mem_from_gmem(kvm, gfn);
> 
> Is this actually saying that the mapping level is to be fully determined
> from lpage_info as long as this memslot has gmem and

With this change in particular I was not quite sure what to do, maybe it should
stay specific to private memory only? But yeah the ideas was that
kvm_mem_from_gmem() would express:

(a) if guest_memfd only supports private memory, it would translate to
kvm_mem_is_private() -> no change.

(b) with guest_memfd having support for shared memory (+ support being enabled!),
it would only rely on the slot, not gfn information. Because it will all be
consumed from guest_memfd.

This hunk was missing

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d9616ee6acc70..cdcd7ac091b5c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2514,6 +2514,12 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
  }
  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
  
+static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
+{
+       /* For now, only private memory gets consumed from guest_memfd. */
+       return kvm_mem_is_private(kvm, gfn);
+}
+


> 
> A. this specific gfn is backed by gmem, or
> B. if the specific gfn is private?
> 
> I noticed some other places where kvm_mem_is_private() is left as-is
> [2], is that intentional? Are you not just renaming but splitting out
> the case two cases A and B?

That was the idea, yes.

If we get a private fault and !kvm_mem_is_private(), or a shared fault and
kvm_mem_is_private(), then we should handle it like today.

That is the kvm_mmu_faultin_pfn() case, where we

if (fault->is_private != kvm_mem_is_private(kvm, fault->gfn)) {
	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
	return -EFAULT;
}

which can be reached by arch/x86/kvm/svm/svm.c:npf_interception()

if (sev_snp_guest(vcpu->kvm) && (error_code & PFERR_GUEST_ENC_MASK))
	error_code |= PFERR_PRIVATE_ACCESS;

In summary: the memory attribute mismatch will be handled as is, but not how
we obtain the gfn.

At least that was the idea (-issues in the commit).

What are your thoughts about that direction?

-- 
Cheers,

David / dhildenb


