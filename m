Return-Path: <kvm+bounces-62417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3FDC439FF
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 08:57:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 38D134E3B59
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 07:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9977126FD9D;
	Sun,  9 Nov 2025 07:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UurDqlvZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HO8dLVd9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28BD1BCA1C
	for <kvm@vger.kernel.org>; Sun,  9 Nov 2025 07:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762675049; cv=none; b=p2H6OCPbj/tzbEH8Y76W4yiCUwDEhEgNL1gfNZgNYa1l4Y1LZfVPWFZu2K6KJDIQcNjLDpyUh3it1v1elMqhkAGS0ll47rjIOXpC3XerIP0NmsAubw17Awl6KTBOHXo86LFGZ1q5lvg2dnZvYXG4tEbFi9G47so80TmaWgirbHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762675049; c=relaxed/simple;
	bh=aMVY8ydjIK+gBsyjP/Qdj9zuQ38V6U+yFDnq3j8ElaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rM5/1/15D2HjdHwB5XCaQxaewgHHvyWgSruISRWgi+spSEGQwnDU7StAEg51ABoBT/5fQ1+FpO62e+fYO3S2lwBb+UgNnnRbFSKyMi2M/JO/gFFxVeXDuguyIiUPrypjvZ7OwgphIRwwK4P/jg3q1RniuvhCPjqdCO3JKNoZtTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UurDqlvZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HO8dLVd9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762675045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ggXgIZ4Av8adM96XYVeUSve/XM/3H02+HEMRjGXlR6Q=;
	b=UurDqlvZi3I74vZF5c+Z1LI0wPjAlINIvWOlO3orAE9uJb61RqFZxzjOQbjzQ0aJmnNA8H
	6sL15e2KEfPYQFlsJbisQl9FI9I3tBW5ZhEnRvBnJmErQjKn8yOw1ZrDpJ1gPv/y9GXS1c
	c+dYW95ozkI/1NDYcOvA8S+ZfrZNdAY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-yEWNzwoAO6-h4sKq3syz-w-1; Sun, 09 Nov 2025 02:57:24 -0500
X-MC-Unique: yEWNzwoAO6-h4sKq3syz-w-1
X-Mimecast-MFC-AGG-ID: yEWNzwoAO6-h4sKq3syz-w_1762675043
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b72a11466c2so245620366b.1
        for <kvm@vger.kernel.org>; Sat, 08 Nov 2025 23:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762675043; x=1763279843; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ggXgIZ4Av8adM96XYVeUSve/XM/3H02+HEMRjGXlR6Q=;
        b=HO8dLVd9haqhjt74i0I2pcpLjd5r3nvssE/a1eO9x5oL+7YKTy/fbh54pu9iJzA+aZ
         O4hR1TMzy2owVN0E6CFL7QpnQJvhmveA6BkCd+PfjXhy9cWevpJfjsmdiUxJUUIj/eMv
         rjOBS2PukrdJpvj+APS3T4a+Sz/EeIF1QgExvirJvklqmT9gnwesFyo226wEL0qVo6QO
         LdJKvX5F70mGjVkCiX7EAG6c8iOTP2zB2erzS9SJcyQjhg0z4xy02gD6+HlNpR/W1/Kz
         4sGb5Jv2sCV7qZPNU9qdpPLpVe7ASVTjDq5Po8W6SCahdjQUAyX52jv9x3D5P+89a86G
         6MHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762675043; x=1763279843;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggXgIZ4Av8adM96XYVeUSve/XM/3H02+HEMRjGXlR6Q=;
        b=QqIqi9VwrpudpbBkj3AaOw8bAMkjDKm5wgXaUApHgcQ0BugYHpR0HBY66L8JOl29f/
         F6E1P8IkvIVt3mlAbHudTF2xJTuDd+L2/fFWA97lHRtdFZaErH0uqPU6KyPTHf3V8Kef
         d/v1shf2Bz9C/cqHnPGGoPb2JY21tMlu+ebkqm0KliR76zZV26rzqyzDsZCAn6Orp2+7
         Dax3CYMBajMlwgX03PxvbOnHpT7gOPwljJOB3sKgXuFbGV272lGyy7/wNr+1n8dRAKOQ
         BSUaTVckgHgVOHUu68fQzpjy69kY9nVQOl76m8pLBZGvXU9uqKuAxtZk7FpwUlAuQCNa
         FJkw==
X-Forwarded-Encrypted: i=1; AJvYcCV/yNbU4ThW0+9iZ5O7noW+INkUVRlm+VM/f++PLTKhoObK9KNSnRaFDVZsiLYr244muKg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCXR0XiN2hw09YrykC8UZfbemRqT4LjKPo9IVU8OFzDP6prE9O
	K6wsLKInsDBa74n625PFDqbiq3ZVJeGQco6dUqhrj6Vc4N87gcoeuWTCuSci1J3T7NXjnS4tui5
	odimqzM+8kyzYqbdPybinefvJWJ0+u3rEYaRwzi0/rbNXqG1CwJyOJQ==
X-Gm-Gg: ASbGncsk7W+Gj4fzcohLJuNSy4lkf0hTWfeg02aRAw6yUsaUYCi7eCc01gkehS87IJE
	u2lB5QJO64xZZ0zpFSHhKsNwFgmEMH0KaDX+bduKGxSGDFgYjnCSjxYyvs8/jcYAbAjxWkQ95TO
	vMiVZWPb36IgrYk4BsL3EsbDBNNc+1rihj98HGfOlT4Peo98myCFulqno4m+39k5WXgwmeZtCcr
	Ez7jnontJ/bQSYdMk2RyCYHxUXBbfcrg15WSAa7OQn8iP/fEG0oqp9ZtGfK/8/c/ZdJSpO7ZkLm
	pMv1BLSEGqiTSC0ph32r7+Q+KnhrcItrEeNdVsGEj2W138Zdz7hTwY07kgxZGfHGitelYV3h8Hc
	afQsXRJdD18jc9w8V79WiIsou36ilhvrgGadIj9lXKQOoC7+PvgpuVUCsEGqTgK+vR5Dpe1SqWy
	d4HtyU
X-Received: by 2002:a17:907:60c8:b0:b4c:137d:89bb with SMTP id a640c23a62f3a-b72e037ab1amr450224166b.29.1762675043260;
        Sat, 08 Nov 2025 23:57:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEY/mAo+2HtrMHSZJM1dBAA4+rvfrevI858WJSml1/nFkNtAp06GLC7ns/SqzWwTfuAzgf5VQ==
X-Received: by 2002:a17:907:60c8:b0:b4c:137d:89bb with SMTP id a640c23a62f3a-b72e037ab1amr450222766b.29.1762675042852;
        Sat, 08 Nov 2025 23:57:22 -0800 (PST)
Received: from [192.168.10.48] ([151.95.110.222])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b72fcde0779sm93426566b.40.2025.11.08.23.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Nov 2025 23:57:22 -0800 (PST)
Message-ID: <35d28432-349c-4157-8c9e-7d4a9d8bd50f@redhat.com>
Date: Sun, 9 Nov 2025 08:57:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] KVM: SVM: LBR virtualization fixes
To: Yosry Ahmed <yosry.ahmed@linux.dev>,
 Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/25 01:45, Yosry Ahmed wrote:
> This series fixes multiple problems with LBR virtualization, including a
> fun problem that leads to L1 reading the host's LBR MSRs. It also
> considerably simplifies the code.
> 
> The series has a selftest in the end that verifies that save/restore
> work correctly. I will send a couple of new kvm-unit-tests separately
> that exercise the bugs fixed by patches 2 & 3.

Thanks, I've applied patches 1-3 for now.

Save/restore has been broken for 17 years so it can wait the next 
release anyway. :)

Paolo

> 
> Yosry Ahmed (6):
>    KVM: SVM: Mark VMCB_LBR dirty when MSR_IA32_DEBUGCTLMSR is updated
>    KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()
>    KVM: nSVM: Fix and simplify LBR virtualization handling with nested
>    KVM: SVM: Switch svm_copy_lbrs() to a macro
>    KVM: SVM: Add missing save/restore handling of LBR MSRs
>    KVM: selftests: Add a test for LBR save/restore (ft. nested)
> 
>   arch/x86/kvm/svm/nested.c                     |  31 ++--
>   arch/x86/kvm/svm/svm.c                        |  98 ++++++-----
>   arch/x86/kvm/svm/svm.h                        |  10 +-
>   arch/x86/kvm/x86.c                            |   3 +
>   tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>   .../selftests/kvm/include/x86/processor.h     |   5 +
>   .../selftests/kvm/x86/svm_lbr_nested_state.c  | 155 ++++++++++++++++++
>   7 files changed, 236 insertions(+), 67 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
> 


