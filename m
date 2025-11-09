Return-Path: <kvm+bounces-62416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 224E0C439DB
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 08:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 579AD346EDC
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 07:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49DB273D81;
	Sun,  9 Nov 2025 07:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="heyXYyDW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7sLJHUH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FB1193077
	for <kvm@vger.kernel.org>; Sun,  9 Nov 2025 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762674183; cv=none; b=Qvg5BkWR2ZP+GgUDMY+C0jSuzQyjTq9K2qPQPl2OmAkXvNUrLlbofhkBewClAiv41C0BjfSPPffpike7aR7WEuGkwoxnE4ql8QfC8ogLl/5APZk0mH/usJ9DGkoj4wAq8OCHUzmQZUrmOjLon9MXTdfx6PVfqj/ai/ujBXnLVtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762674183; c=relaxed/simple;
	bh=0l6kSDxuZolXxPvtX81Imos77pzD4xL9UNkd4sLU+f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O0SaAR+eUspTGvyhyX8ZsV8mKAsmKUiz/vA6+AJFwZZJ8SzQnqQ9kSu6vrOXblsyxh32lPiL+0n4tHhjhBs10fajH0VInbh2cnKAtGc1L+eN46h2UY2DBZhbXoXvUYzoD/61itk0r49vucfIpzi0KLZcEt9pOXJT9Hif0Z69u3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=heyXYyDW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=R7sLJHUH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762674179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7l+lGeZ8zBElsB2/hWui9sncARHZER0YlsEox3jgWYg=;
	b=heyXYyDWxnUgYhXlqoAy/oC1oU8R1Zpgf0s7KF/9MQek3EYZF5rAdmycwayAXRiB8UmA/o
	aLgS95ol2hdScxL/x60G9lvPzE7uFYeql8/EkUtiRlde7w1MdZQPv0ig6TO9pwDTtjTafa
	Xh6odeV23ceWezq33+OaQ7N3XWcAUr4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-AqeMQFwsPk28qttllV0mdA-1; Sun, 09 Nov 2025 02:42:57 -0500
X-MC-Unique: AqeMQFwsPk28qttllV0mdA-1
X-Mimecast-MFC-AGG-ID: AqeMQFwsPk28qttllV0mdA_1762674176
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b7270cab7eeso193961466b.1
        for <kvm@vger.kernel.org>; Sat, 08 Nov 2025 23:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762674176; x=1763278976; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7l+lGeZ8zBElsB2/hWui9sncARHZER0YlsEox3jgWYg=;
        b=R7sLJHUH6CsxJXxK3EMgG8rDA5qWp3H6m3fSMvf0hX62iwoTDD92Nog7A6J6/Ex+Bi
         HLZdvlqMeAbWdYEz2tAlBSF1hNcIn/Ws6yj6oa3uode2q4z14Z+t1NoekqneohkoXjys
         4fKmPjJ3F8Ro/g/hHsQolL4qo+KUAegIBK5NAM3kCcRj4jpBu/8LpDe11P5U2zWKSMJp
         TjaiWcRhDnKpf85QjZ/xXSuxHyc88V6UtHsJor9e0r1rSFZmzitucYW/lC80vAMYHack
         HsZnceElFy4Y/B0G0+/d6DH8m6DCc8C5PbYj1OnvaE//+/+oYNn0h1v1q8MldeGidYdG
         H4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762674176; x=1763278976;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7l+lGeZ8zBElsB2/hWui9sncARHZER0YlsEox3jgWYg=;
        b=aspXPaRyRIehB6SCsbxqLd8w8VGVpRuxCzzYI2cpYuoYc9L4p0OH9Z+Wa2VC/kGlM5
         LYW6wJMRF7TbU6J4vCYxS6T6+Rc4v3++fiWAfvfKRIMybJSneXaDV+D14lWccHEczNkQ
         CBS9ksbtJ6puX+XOqnf6KTbOt519aBjW5vsP7ULjl8wAfWqUJW9r/QYen050f1BkWcUg
         CcqcGrLJgf7JG7aMEuroKd1eFALa93fV1COQgVkyXrgzHZdOVTC4fzYYEl0ACjwUVJ9N
         3Cgn/xBEJVYmATmJmNn4LunM1etC14rKCSqkNhM+zOYZZfQQ5n7XROvTB8OxJA1yl2ir
         sQlw==
X-Forwarded-Encrypted: i=1; AJvYcCUFVUoG5vwT+3x4XhFX6IKB9H4zetTCgtPzv/rhHCT6vbHB3xx4uVcwhMdayT2KAz4BnY8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRRgsUG8g/ZfMIoi+McvHPNOdzq6QAGLAvgzMh31+/j82u6Ecr
	h5RO+jfYEncDsBnME51bOpuzjfGX7jYhmxXxVHo7i/Xf/EJj8ghNMrbQi0EH9JIASc1aDjU8ogb
	vsQm5jJtUk78071j0XZC47ucXusihpla7wJ8Ad5FZKQsqIs5+CCSiAA==
X-Gm-Gg: ASbGncvZQe5DqXGtshgCmvmyJCdeGpHM082xe5yMlSgb+yzAMJIHFoPXPm1g/jfss92
	O0C99VWHz1KyzcG2rtY6gp2jq9BTzIwZKrKF4fpif5mI5H+57IQqqeawkoWKYnCN2LIiNIfMO4Y
	OkJ2rQM+j6UBOGKF3VlpnY5FRn9nlnqc3exWjzAt7SEZHgQKoQsClqZgkBdDTFLpMuJV5QVfYYi
	6BsdyuJStIh58pnswRhcSOw8+06H2g5fwhSdDIV2EX5O/AtYPHiipySsBVKXP4P0OoXP+0pyPRJ
	cWYxnOWfoEVC3TboPjatAv+7v6WdSBvjJ+cbIs9+LyByiuZvp4JpiSN9nDaYn5lXWqtFKOWMHs1
	dyo4qIPN560ddks2loH/HNMevhYTxvbIkE6ayFZkjTeiNA812erq2tz5S3jx7kA1h34VRczk4MK
	lqvvUB
X-Received: by 2002:a17:907:2d22:b0:b6d:7b77:ff33 with SMTP id a640c23a62f3a-b72e02db6bfmr380120766b.19.1762674176075;
        Sat, 08 Nov 2025 23:42:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZQB94vRvTudvuLEaO7R+cm3s9oXIrJERucltzdm1MPb3XJt9DN7Y2H/ORMphe6ximrdmO9A==
X-Received: by 2002:a17:907:2d22:b0:b6d:7b77:ff33 with SMTP id a640c23a62f3a-b72e02db6bfmr380119166b.19.1762674175662;
        Sat, 08 Nov 2025 23:42:55 -0800 (PST)
Received: from [192.168.10.48] ([151.95.110.222])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b72bf9bd36csm766237366b.61.2025.11.08.23.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Nov 2025 23:42:55 -0800 (PST)
Message-ID: <b46bfeef-c728-4598-a047-fcdad2d42d6e@redhat.com>
Date: Sun, 9 Nov 2025 08:42:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] KVM: SVM: Mark VMCB_LBR dirty when
 MSR_IA32_DEBUGCTLMSR is updated
To: Yosry Ahmed <yosry.ahmed@linux.dev>,
 Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Matteo Rizzo <matteorizzo@google.com>, evn@google.com
References: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
 <20251108004524.1600006-2-yosry.ahmed@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251108004524.1600006-2-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/25 01:45, Yosry Ahmed wrote:
> Clear the VMCB_LBR clean bit when MSR_IA32_DEBUGCTLMSR is updated, as
> the only valid bit is DEBUGCTLMSR_LBR.
> 
> The history is complicated, it was correctly cleared for L1 before
> commit 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when
> L2 is running"), then the latter relied on svm_update_lbrv() to clear
> it, but it only did so for L2. Go back to clearing it directly in
> svm_set_msr().

Slightly more accurate:

The APM lists the DbgCtlMsr field as being tracked by the VMCB_LBR clean
bit.  Always clear the bit when MSR_IA32_DEBUGCTLMSR is updated.

The history is complicated, it was correctly cleared for L1 before
commit 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when
L2 is running").  At that point svm_set_msr() started to rely on
svm_update_lbrv() to clear the bit, but when nested virtualization
is enabled the latter does not always clear it even if MSR_IA32_DEBUGCTLMSR
changed. Go back to clearing it directly in svm_set_msr().

Paolo

> Fixes: 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
> Reported-by: Matteo Rizzo <matteorizzo@google.com>
> Reported-by: evn@google.com
> Co-developed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>   arch/x86/kvm/svm/svm.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 55bd7aa5cd743..d25c56b30b4e2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3009,7 +3009,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   		if (data & DEBUGCTL_RESERVED_BITS)
>   			return 1;
>   
> +		if (svm_get_lbr_vmcb(svm)->save.dbgctl == data)
> +			break;
> +
>   		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
> +		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
>   		svm_update_lbrv(vcpu);
>   		break;
>   	case MSR_VM_HSAVE_PA:


