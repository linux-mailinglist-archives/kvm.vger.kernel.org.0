Return-Path: <kvm+bounces-18876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 520AD8FC955
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 398D31C2115A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED7219006E;
	Wed,  5 Jun 2024 10:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SfHaQ0up"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC531946D0
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 10:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717584397; cv=none; b=rfEr5KHUQSUPa1JS7Ox4x5aVU2wi1ZMNPSxnd5Hs6vbKFtTj75n+i8rpuckClUPas0n9LtRB6TJHUTQbohvSda9lU7r/kdnLEJf85dzQbxohN6Zb/owFBqAHEWjmzAYLyWObo1Py0GEaUbUEZBH/DNJLxd8MtY8VUaF05gN5koU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717584397; c=relaxed/simple;
	bh=fEqWz9lSEPJ56grJIIXBS8+JXz0DLy3M+EOW9vJRYUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qmIYkYwAl941vnSWYIf7Sj4mIzSUZukBlWCUpoaWn5oBp/CFsTjQlqKRuzORnUwuCUbotrYQvT1k7YRgijvyT3Oj1oQMltuEXgWZwbe46HcKrQdzYT07uc8hrn8rQJxac9hf9R3RADXB4xQaet96v0UJNh2B2z2wPOYSCEXcDxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SfHaQ0up; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717584395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ciz/gvIYpVq77qLNwBMshBGRenVUb3Ok72zIDJkPbHg=;
	b=SfHaQ0upQKMPhqWPfBfRLkIa+n6YICBM6ijekzAZALMKjsDFrFgSC5lm/0ma+fzeUhQQKO
	pV3kzOc+/pMRMCcc2DI7bUCkZRIcFB19AEUrGbGxeBF4zZu8YqQTfSFyzQcIp6mTZc0QUJ
	gflNgGYHJWRkKP/f4LCibqC2WHm5Jb8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-VsfcRDYSOCed8wjioe8b9w-1; Wed, 05 Jun 2024 06:46:34 -0400
X-MC-Unique: VsfcRDYSOCed8wjioe8b9w-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-579c69260bbso2288831a12.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 03:46:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717584393; x=1718189193;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ciz/gvIYpVq77qLNwBMshBGRenVUb3Ok72zIDJkPbHg=;
        b=EC8AD8uG9D7b1yOA3nQpvY+hwBkE83lc0MYV7F5jCuQmz7Wm1yz9IdnD+NEZp7nuiB
         OKmpcphDSSUFWmxRFy3SMU0zXxT2OCFNAurKnR/FVbfMKFe/8V8Ni7BBi4qsoWJf0vm7
         Pn1TslnBkWeuC3Hd8Fd113f6L3l53pPYUhJbDj55K6AUfGGSOymC7eT2qoLFM40mGGSY
         ty/ARIhT2CRt+W4GUpqa6iEFQbJuD5titjd5Nj5KWwGTwzBLpzM8ke+lbxuEhrvs2Otp
         IP1nJdRCUrVp5+Fmxg90QCnDT6wmSSX4mAkwGXcN+0oWuHZIBkX/QMGKF08FcrDzdMXX
         fIoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIt26XZbLqCoMBhzjLV+sMFUQ0jjYEfT71R8LQWQWii+g8a9PVJDALhA8UTyzifp1rckgPFW7RdkeC0pAqr3NO/qIY
X-Gm-Message-State: AOJu0Yw223GU2mKfK/pC5cZ4vsgVZXxFp/jxPyondaPUg7aW17bp3t6H
	z5Vt/2TF3RxahW0oxn34jIQcc/NmHfeEewVY2d/oeOrx/QZe6XUUWPFZG12Br/1ANxtCmdLwhDd
	kh+GVkNJHOCHCUq/al5gjaol0zLvKzxbIDUMzCD4SjYRYO6SYKQ==
X-Received: by 2002:a50:cd9a:0:b0:57a:33a5:9b71 with SMTP id 4fb4d7f45d1cf-57a8bc8d22amr1765018a12.33.1717584392910;
        Wed, 05 Jun 2024 03:46:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQFzfdDbSc14e9Aj/X5FFoBJEYAecXRJYzf6/1xXjXLvYi1xq1uKRBj9XA5g2XoFwQ74x5cw==
X-Received: by 2002:a50:cd9a:0:b0:57a:33a5:9b71 with SMTP id 4fb4d7f45d1cf-57a8bc8d22amr1765000a12.33.1717584392527;
        Wed, 05 Jun 2024 03:46:32 -0700 (PDT)
Received: from [192.168.10.81] ([151.81.115.112])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-57a31b99a3fsm9046103a12.9.2024.06.05.03.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 03:46:32 -0700 (PDT)
Message-ID: <7889d02e-95a5-4928-abed-05809506c980@redhat.com>
Date: Wed, 5 Jun 2024 12:46:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: Don't save mmu_invalidate_seq after
 checking private attr
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 Tao Su <tao1.su@linux.intel.com>
Cc: chao.gao@intel.com, xiaoyao.li@intel.com
References: <20240528102234.2162763-1-tao1.su@linux.intel.com>
 <171754258320.2776676.10165791416363097042.b4-ty@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <171754258320.2776676.10165791416363097042.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 01:29, Sean Christopherson wrote:
> On Tue, 28 May 2024 18:22:34 +0800, Tao Su wrote:
>> Drop the second snapshot of mmu_invalidate_seq in kvm_faultin_pfn().
>> Before checking the mismatch of private vs. shared, mmu_invalidate_seq is
>> saved to fault->mmu_seq, which can be used to detect an invalidation
>> related to the gfn occurred, i.e. KVM will not install a mapping in page
>> table if fault->mmu_seq != mmu_invalidate_seq.
>>
>> Currently there is a second snapshot of mmu_invalidate_seq, which may not
>> be same as the first snapshot in kvm_faultin_pfn(), i.e. the gfn attribute
>> may be changed between the two snapshots, but the gfn may be mapped in
>> page table without hindrance. Therefore, drop the second snapshot as it
>> has no obvious benefits.
>>
>> [...]
> 
> Applied to kvm-x86 fixes, thanks!
> 
> [1/1] KVM: x86/mmu: Don't save mmu_invalidate_seq after checking private attr
>        https://github.com/kvm-x86/linux/commit/f66e50ed09b3

Since I'm already sending a much larger pull request for -rc3, I guess 
you don't mind if I also queue this one. :)

Paolo


