Return-Path: <kvm+bounces-36935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EFE3A23243
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 17:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C04067A15C4
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 16:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69EA51EE019;
	Thu, 30 Jan 2025 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a42Ray6y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA0113FEE
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 16:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738255877; cv=none; b=GdaAIxmrAU8gOURmF2Nl7j5VhLYeBtYm9SQFQjjhBMFVOjNBlKfL30mginQ1LCDm+RUWk72pyYivvsOuYlf1ylHku5AluoZmM/5AjBVNGT+l7XCdg8AtgEyrBFN1505Ba2csj8I37Q3NgKy9ToBc5J87SzGhNR2Tuy+jTbdrXWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738255877; c=relaxed/simple;
	bh=yXjWfiPGgTunhpgpDpNeBfnxSmINpiCrGt+axRPEEag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QukWdG4z9DIChPdrbaKP46dhIRSjv07Rv/SUuVI/X+HpGDM21DFMkr30Egy/598M7INZpOpjVPxYVoPtMxG9d4l9oBe7YNgF/ODCRFxXihlIR1PtfuIt28M27dbUFMiN6U+RZHKfyOyOjsO3Mg8bpCK/HQSTj2oHZAsy+oFlYKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a42Ray6y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738255873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vSQbe4vosYMcB5B7Ti4t8tkhw8boR1ASmLvUEX8zDMk=;
	b=a42Ray6y/tt4NETperxU6QgFI9999XIv+QE+ZAdUFArd9YGJ5j67PepO5ft0+FVEpVB+ak
	qihSRbzED3Nb+g9J5qFhGiw6PGNARu6iuGIuPK8wyBdXm7lCOTr0N5RxPFE4EQ2KGcb4Kr
	JEAZsZtT5U7/9pYTZ9hHUHYveRwIYPk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-R5F_op_nMJ27vLgHtfl6Yw-1; Thu, 30 Jan 2025 11:51:12 -0500
X-MC-Unique: R5F_op_nMJ27vLgHtfl6Yw-1
X-Mimecast-MFC-AGG-ID: R5F_op_nMJ27vLgHtfl6Yw
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361b090d23so5314105e9.0
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 08:51:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738255871; x=1738860671;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vSQbe4vosYMcB5B7Ti4t8tkhw8boR1ASmLvUEX8zDMk=;
        b=klulifRkuixlxQ5rO4tkRArv8yU6YgyMRdzue61mhjcnSt9P6xJJ4HZ7Gig8INKnKF
         qY+D2QtWSy/hUobzuAkTCoicrmVQu2dyNaMuqwQKfFKLQBWCslVmRJAGprSY2KzHJUcz
         0FgE3PiKdZCS8hFOSLRy7lp9AwSY639dHA2J8P5ElH6cCMFgrnyDlOurEre3BlQHd3hA
         b54pea9kRzkF7oXl4aNROwyeoMP33/Vu9QSul4DGty3BmXxsr1gqxM9ATPE+eU1n62rS
         IS5ifqydOht34kZRzItatKxoPviSSv3lxQL0Xj4cfrN02v/+WZ9q89BtToZ9/7EQ+03K
         kgIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMOXGd/pbe1y47K4pd3jNJWo46uwBRRSiVA/aYHFpr7v6+ICEZyJXyGZZWh/sI8LHwHbc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsBrluZvnwScGQE8/2vLPQbp+5cpVgw4zt/+j89WL3+M4MDYB+
	1PmGRu+Cyj2yW+NF5BvMhCOxomB4CkDjmP0gWuEPHHXDI3aYOfrU2PTp29c99ZmZTYuXiDBorZb
	XBLhCD9olTrqx8koLDyVlqYccggZtKhNH2FpVIj6BpQKjWTwzYG3KR/ZNtA5M
X-Gm-Gg: ASbGncv/ngh7FLqJMZnlNiwAcwUgEAwFuX3rXGAIEExzqwEt+ZLq59lp9uPThbyxTKS
	pGt1BdjUdHMl8PUKzIK/hVVavgA/jrmG3r246M6G6PvBh7Mj+nK/BlHtE4v+nJYLMhIkvfI3/Bp
	sP0G9EqhGVufa0Cuise4xHzqFenT0s3Yuv6UisdBSrkrGUD0RGw3p5kBnZzkpKdY8oR1lav2zIG
	1uBWajC03W7wPLm0r9FPPcRAk514lVGYYhdxyRVwInaFHm1BEVv3WY6eiAGY3f8MGOsoruTM/tY
	U4pSK8pCw3xN7uQpcoTqjMdWnzsaukPcA3mG0JD8ybD+vmAsPMUrmFPKy8D6rR4oGNcQ5wMg/RE
	yx58jKXnZt1asg1EXRm9d7x1ELu/JqS/s
X-Received: by 2002:a05:600c:4f08:b0:438:da66:fdf9 with SMTP id 5b1f17b1804b1-438dc3c87a5mr70163015e9.18.1738255870903;
        Thu, 30 Jan 2025 08:51:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE+YeKPmVzedXw+G5H15HnlT3K5Bk8St8bibSxXEtr+ee9TSYkrjNyM+ePPJ1ZPHWd0MzMKxQ==
X-Received: by 2002:a05:600c:4f08:b0:438:da66:fdf9 with SMTP id 5b1f17b1804b1-438dc3c87a5mr70162785e9.18.1738255870554;
        Thu, 30 Jan 2025 08:51:10 -0800 (PST)
Received: from ?IPV6:2003:cb:c713:3b00:16ce:8f1c:dd50:90fb? (p200300cbc7133b0016ce8f1cdd5090fb.dip0.t-ipconnect.de. [2003:cb:c713:3b00:16ce:8f1c:dd50:90fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438e23d443esm29966775e9.1.2025.01.30.08.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 08:51:09 -0800 (PST)
Message-ID: <3c126ed2-f7d5-49f8-98f6-be28238f1e78@redhat.com>
Date: Thu, 30 Jan 2025 17:51:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Peter Xu <peterx@redhat.com>, Xu Yilun <yilun.xu@linux.intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, Chenyi Qiang
 <chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050> <Z4-6u5_9NChu_KZq@x1n>
 <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050> <Z5EgFaWIyjIiOZnv@x1n>
 <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050> <Z5Jylb73kDJ6HTEZ@x1n>
 <Z5NhwW/IXaLfvjvb@yilunxu-OptiPlex-7050> <Z5O4BSCjlhhu4rrw@x1n>
 <Z5WtRYSf7cjqITXH@yilunxu-OptiPlex-7050> <Z5uom-NTtekV9Crd@x1.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z5uom-NTtekV9Crd@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.01.25 17:28, Peter Xu wrote:
> On Sun, Jan 26, 2025 at 11:34:29AM +0800, Xu Yilun wrote:
>>> Definitely not suggesting to install an invalid pointer anywhere.  The
>>> mapped pointer will still be valid for gmem for example, but the fault
>>> isn't.  We need to differenciate two things (1) virtual address mapping,
>>> then (2) permission and accesses on the folios / pages of the mapping.
>>> Here I think it's okay if the host pointer is correctly mapped.
>>>
>>> For your private MMIO use case, my question is if there's no host pointer
>>> to be mapped anyway, then what's the benefit to make the MR to be ram=on?
>>> Can we simply make it a normal IO memory region?  The only benefit of a
>>
>> The guest access to normal IO memory region would be emulated by QEMU,
>> while private assigned MMIO requires guest direct access via Secure EPT.
>>
>> Seems the existing code doesn't support guest direct access if
>> mr->ram == false:
> 
> Ah it's about this, ok.
> 
> I am not sure what's the best approach, but IMHO it's still better we stick
> with host pointer always available when ram=on.  OTOH, VFIO private regions
> may be able to provide a special mark somewhere, just like when romd_mode
> was done previously as below (qemu 235e8982ad39), so that KVM should still
> apply these MRs even if they're not RAM.

I agree.

-- 
Cheers,

David / dhildenb


