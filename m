Return-Path: <kvm+bounces-15933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3284B8B244E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C79DB26769
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD9514A623;
	Thu, 25 Apr 2024 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hO8QjXa9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5258A14A4EA
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714056329; cv=none; b=oWYHnTKKEMWB9q3t2vvY9nDJb+MWBkT00zXIi2Z6rtQwcUfE7VLtjMn+Ow8THeav2bmv8t3Jtwufl854n1YWJKSNe8rvcSsavxjjIPTRPiM4in+LcPbcRHdqsi0/biPp56jxAtl2mPCmfu+8AKC+/Gzoo1Xw2mknDSeYF5XuxV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714056329; c=relaxed/simple;
	bh=IJ3J9+qMMc5AcpPKGPwrAuPLaO9e0GfSfZ8R0+bwFng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mJ3WKU3Ky3+oXatjWqhhmnzONbf8899kFYgz267hBNJsptB55Eim8ocrlfTN+xVXcydb5plu/yVSVoxfrMIMghQEtgN6gXW6vDiQjatTTbN9l6wcWvmvl40aYZlqiClWVnJCUmrj8wfRUnuWJDCzdF+3qQnOrg+xCmjup+gJ/RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hO8QjXa9; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6ecf1d22d78so66951b3a.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 07:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1714056328; x=1714661128; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Upe9hXc85SfykUK8OSJyDQtUplWhtMiTd1jA3tMRXuo=;
        b=hO8QjXa9lALXbwUsKXaff/iSO59Zbkn009rIlqZSCTTs5fi3iWw7w0869tbnDvi0rr
         uVk4tKOMW8eURFiwROT9wn9tu1s/k4yyjGRr4TfEno57Ab9msTY+G7tLLBikp7Djbv0K
         VEmmMQ1Ob3RkrKeZUGT3O07/ag/h4VifsNM+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714056328; x=1714661128;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Upe9hXc85SfykUK8OSJyDQtUplWhtMiTd1jA3tMRXuo=;
        b=PhDSynOxP1lEmOge4uCgRZsV/LGWVgTv4Q5mz02IlYY8doAEvgWF2BU0RQQDHHJGH2
         Vh1AqmZv2pze2yahn5e8FmrTECVnxFFI9G5rZA3G/jH1V+gE4iAPimAjq6sTQPfGgxH4
         nBVkNw+9gj2NuCv52C3bMvH+TSNzwDnU298dPeghwGYp13F9oHTKjv0n6YQPtkFq8grR
         ud64yh3VPtaOzNJt7emn/w7fyMC0qqdkDtZvIfZa1EyOOLOb3QHn22InJ7B6+Byyrnrr
         zLqb/kr/wWp0EqzU2bZahr9HKxlyGEUHiqpYTfdFa6VqrntdAyioKhQPdILFOO9bcv0w
         I1xA==
X-Forwarded-Encrypted: i=1; AJvYcCUPBEqQc6J3G+5yhFIwDbt9A0Upp0nU3bU+CQt/uVNegOBrr5gYu+sFMO5DV3VzVIiyJTDfL9oEhMRWqz+HVWl1nDao
X-Gm-Message-State: AOJu0YwKgEsH1v33IDnJTjeswowiolyxb/nSS+XiwafvmPr5SIR/MchV
	bdL1yV1I5GSLb4KqHTdQ7gWtCQQMBqDlbuqJi7M7ZLjxE+vyxL6v3qlMsKxWfX0=
X-Google-Smtp-Source: AGHT+IH2ZWIxVnWGlxZ14mWcvRqLtKyE6u0gRzo1WyBlfFhqv5treC26C0VPwnpQrTOD05hYIY1E7A==
X-Received: by 2002:a05:6a00:731:b0:6ea:ba47:a63b with SMTP id 17-20020a056a00073100b006eaba47a63bmr6568081pfm.0.1714056327589;
        Thu, 25 Apr 2024 07:45:27 -0700 (PDT)
Received: from [192.168.43.82] ([223.185.79.208])
        by smtp.gmail.com with ESMTPSA id k124-20020a633d82000000b005f7d61ec8afsm11351461pga.91.2024.04.25.07.45.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Apr 2024 07:45:27 -0700 (PDT)
Message-ID: <3848a9ad-07aa-48da-a2b7-264c4a990b5b@linuxfoundation.org>
Date: Thu, 25 Apr 2024 08:45:07 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 25/35] KVM: selftests: Convert lib's mem regions to
 KVM_SET_USER_MEMORY_REGION2
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>,
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8?=
 =?UTF-8?Q?n?= <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerley Tng <ackerleytng@google.com>,
 Maciej Szmigiero <mail@maciej.szmigiero.name>,
 David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>,
 Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
 Liam Merwick <liam.merwick@oracle.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Naresh Kamboju <naresh.kamboju@linaro.org>,
 Anders Roxell <anders.roxell@linaro.org>,
 Benjamin Copeland <ben.copeland@linaro.org>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231027182217.3615211-1-seanjc@google.com>
 <20231027182217.3615211-26-seanjc@google.com>
 <69ae0694-8ca3-402c-b864-99b500b24f5d@moroto.mountain>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <69ae0694-8ca3-402c-b864-99b500b24f5d@moroto.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/25/24 08:12, Dan Carpenter wrote:
> On Fri, Oct 27, 2023 at 11:22:07AM -0700, Sean Christopherson wrote:
>> Use KVM_SET_USER_MEMORY_REGION2 throughout KVM's selftests library so that
>> support for guest private memory can be added without needing an entirely
>> separate set of helpers.
>>
>> Note, this obviously makes selftests backwards-incompatible with older KVM
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> versions from this point forward.
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Is there a way we could disable the tests on older kernels instead of
> making them fail?  Check uname or something?  There is probably a
> standard way to do this...  It's these tests which fail.

They shouldn't fail - the tests should be skipped on older kernels.
If it is absolutely necessary to dd uname to check kernel version,
refer to zram/zram_lib.sh for an example.

thanks,
-- Shuah

