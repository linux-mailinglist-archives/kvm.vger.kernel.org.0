Return-Path: <kvm+bounces-31949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3909CF2B1
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8D6B1F22C18
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 17:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2801D5AAD;
	Fri, 15 Nov 2024 17:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLZUGV/m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0AB15573A
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731691230; cv=none; b=pRnH77E+3RVMyjd7qFBXpbYnRuzVi4Yo8RCpm3+IH6iBhcEBSu+9eWTwwdQ/hb7po8BDLQ712I2LbPKSFHY4WY0cg0LoH725Dq/crRsCsFHB7ZJidNWMoZz/8Zb3EuwnxlrunM5crVOYWuTwUcyyTLMsYOfOcc188/ysfLXvngc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731691230; c=relaxed/simple;
	bh=HtTOt1WYSRmKLfVNSmRQh+Y+jvBZR1tvqD02X2OOGb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P04igR5G4VKYhOGN5c9hWoFnt2EG4jp7RwMJkUSPTFWx/T/GmAdHOd50hlSyrwjcRmqkW2fvJ6Y2pf5oMvcJyGeqebgkVArGI1yH+KFguBDY8y7L5g/E8JdihKptRXldLigU0wC+a0bQgUkZKCSpPMKY98130y1eJflpwIQkrRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DLZUGV/m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731691227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0+ejgmuJB3V2O2WYI8XqlXSmKnq9xsdZLaYqBP/ydSQ=;
	b=DLZUGV/mB/hcrZ7WBoX7TxgVnKRBxzIVclPyN8QdqfPzQeTG8M8d0AiXtadjSUeCGBCqt9
	x/sopKQpRYY8bQmtDZF1uCLh+tfkeBl1bBR3QTlKM/nL7e8z40ipOLPHd+LwecZkoVBdcj
	tLzTsLmPJchaOFOAUv4LVgYuNRul1ig=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-sVkhd3Q1Ot-clOwb__QN-g-1; Fri, 15 Nov 2024 12:20:25 -0500
X-MC-Unique: sVkhd3Q1Ot-clOwb__QN-g-1
X-Mimecast-MFC-AGG-ID: sVkhd3Q1Ot-clOwb__QN-g
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3822f550027so177564f8f.1
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 09:20:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731691225; x=1732296025;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0+ejgmuJB3V2O2WYI8XqlXSmKnq9xsdZLaYqBP/ydSQ=;
        b=ASOUKScfHcNljvBkDtKvnlp1EBWcEd1qi47sQLlTf4xuxB6B1nG+j1MpHZYcHX+3Ne
         8kclqeJEspTU3C0tG/5zHGkz+AK+xhNlVGk/PXZFycj63z0bGHFJryEvkuLVwZ/l22sM
         TDBHpRjP1TM6j7rK4zniQSavWxAHLoYdVDtQT/xK3VxdQvIyFVPGfyYTwEFLFWoDGJ8a
         Tv5nMBZGMHl0BfIOpTUQ5hf50kZM9Wd2+Wefy0i4epNR70MRgK/SzI3i6hp0WhQ8WKK/
         bNodCxaJ/Fe+EBBNdJoNWPK+Td8aXTo8bhWAOZ0XAhjxq5YByK2yvfpPXyNSY686Uu4C
         eOqg==
X-Forwarded-Encrypted: i=1; AJvYcCVQvKyJv0Vt4bgK8r0A8cnWb+vaEUYLPsFJ2VQ/LEXCOVojoySgWIvGZgbRYhPZ7vhktyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJpbr4e0xDlbW8Pzq5SHS0HyZL78la0LRVZQi56mcqY0gO+lYE
	4ipW8HYLMHE396NApRmgRPQpQbya3vKdGXqc1KynC9WoxK3KNnU2y7awsFN6NbMRQUgwYk19P+j
	U9XScsKhSQX1xOi279vhq7LJx4adRVHMm7Y4FxS8DqH2/0AWfcp1n5Vs35Q==
X-Received: by 2002:a5d:59ad:0:b0:382:2f62:bd45 with SMTP id ffacd0b85a97d-3822f62bff4mr1029809f8f.29.1731691224704;
        Fri, 15 Nov 2024 09:20:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGiHc0aA9rNB4klNL+ebkxJEuTEkAuN+XQpT94vaI8oEt4AheK1W4WQXFlmF2ArotLZ+4sP4Q==
X-Received: by 2002:a5d:59ad:0:b0:382:2f62:bd45 with SMTP id ffacd0b85a97d-3822f62bff4mr1029789f8f.29.1731691224330;
        Fri, 15 Nov 2024 09:20:24 -0800 (PST)
Received: from ?IPV6:2003:cb:c721:8100:177e:1983:5478:64ec? (p200300cbc7218100177e1983547864ec.dip0.t-ipconnect.de. [2003:cb:c721:8100:177e:1983:5478:64ec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821adbeb47sm4844132f8f.63.2024.11.15.09.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 09:20:22 -0800 (PST)
Message-ID: <23912b62-9a91-4489-abc1-5d8b34231303@redhat.com>
Date: Fri, 15 Nov 2024 18:20:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
To: Rob Nertney <rnertney@nvidia.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Edgecombe Rick P <rick.p.edgecombe@intel.com>,
 Wang Wei W <wei.w.wang@intel.com>, Peng Chao P <chao.p.peng@intel.com>,
 Gao Chao <chao.gao@intel.com>, Wu Hao <hao.wu@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <b7197241-7826-49b7-8dfc-04ffecb8a54b@intel.com>
 <84ef5f82-6224-4489-91be-8c1163d5b287@intel.com>
 <Zzd69pa75CKM1OzU@rnertney-mlt>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zzd69pa75CKM1OzU@rnertney-mlt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.11.24 17:47, Rob Nertney wrote:
> On Tue, Oct 08, 2024 at 04:59:45PM +0800, Chenyi Qiang wrote:
>> Hi Paolo,
>>
>> Kindly ping for this thread. The in-place page conversion is discussed
>> at Linux Plumbers. Does it give some direction for shared device
>> assignment enabling work?
>>
> Hi everybody.

Hi,

> 
> Our NVIDIA GPUs currently support this shared-memory/bounce-buffer method to
> provide AI acceleration within TEE CVMs. We require passing though the GPU via
> VFIO stubbing, which means that we are impacted by the absence of an API to
> inform VFIO about page conversions.
> 
> The CSPs have enough kernel engineers who handle this process in their own host
> kernels, but we have several enterprise customers who are eager to begin using
> this solution in the upstream. AMD has successfully ported enough of the
> SEV-SNP support into 6.11 and our initial testing shows successful operation,
> but only by disabling discard via these two QEMU patches:
> - https://github.com/AMDESE/qemu/commit/0c9ae28d3e199de9a40876a492e0f03a11c6f5d8
> - https://github.com/AMDESE/qemu/commit/5256c41fb3055961ea7ac368acc0b86a6632d095
> 
> This "workaround" is a bit of a hack, as it effectively requires greater than
> double the amount of host memory than as to be allocated to the guest CVM. The
> proposal here appears to be a promising workaround; are there other solutions
> that are recommended for this use case?

What people we are working on is supporting private and shared memory in 
guest_memfd, and allowing an in-place conversion between shared and 
private: this avoids discards + reallocation and consequently any double 
memory allocation.

To get stuff into VFIO, we must only map the currently shared pages 
(VFIO will pin + map them), and unmap them (VFIO will unmap + unpin 
them) before converting them to private.

This series should likely achieve the 
unmap-before-conversion-to-private, and map-after-conversion-to-shared, 
such that it could be compatible with guest_memfd.

QEMU would simply mmap the guest_memfd to obtain a user space mapping, 
from which it can pass address ranges to VFIO like we already do. This 
user space mapping only allows for shared pages to be faulted in. 
Currently private pages cannot be faulted in (inaccessible -> SIGBUS). 
So far the theory.

I'll note that this is likely not the most elegant solution, but 
something that would achieve in a reasonable timeframe one solution to 
the problem.

Cheers!


-- 
Cheers,

David / dhildenb


