Return-Path: <kvm+bounces-22754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A759942BD1
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 12:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 255DD1F21D3B
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 10:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608541AC430;
	Wed, 31 Jul 2024 10:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YyNnEVCt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0704953370
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 10:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722421106; cv=none; b=d/xsHEaQUhdjZPF8DCLtuMdGFSaB78AoLmbwT+ByZ5YadyVZM8zVj8QIpVaHVYCRZ8JlimYpR2/F0xmn7qSblF39FwPuRwp9kvCz3WmdNTdhSX1Fm6B3VzAIZI8Ck+qSi3VLTLYrefpjSHDptavQiCiUiirRSeBqUxJom99U3C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722421106; c=relaxed/simple;
	bh=+PrbklTeRiXOHSRdGh97gn5y602otpyl/4PgxVx+Rds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p7yjnFemLrspV+aTxNQVUQ6FyAMyo5mkco+6XLtWYcsruaDSitLnWXYuctoKED2pPoxQdIJIeqj/mDmvXld0wN6Lv7ub6UHdvO/5tAo+bTbg7CMB2AaqAnHe1ClTAprCwIM6qqDU/eTZ5R2HvLYDi8UO7IuXT9j2TVMHZwzhNtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YyNnEVCt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722421103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+NI98OckWfv6J2NFyowBM8d76asTvKwKn+KYX73y9eY=;
	b=YyNnEVCtxmJ5kdzZ1LkhKrp7iY8y3Is0Zgf6OAOOctVMsDMQVRLNxp/MElcZ/ETVl8aFg4
	EzOna+NZ4rdRS5mSDjVYlkiSeO52rHxKTY20en3YZfPjZCMGwCFp+stc23RuZ8zYUTM+FE
	Mx1yoZbxOtSE1xPIX8yUbja88xjzuSc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-9m-5gUfLNbyM3oGDR6IlNw-1; Wed, 31 Jul 2024 06:18:22 -0400
X-MC-Unique: 9m-5gUfLNbyM3oGDR6IlNw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a7ab4817f34so481913766b.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 03:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722421101; x=1723025901;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+NI98OckWfv6J2NFyowBM8d76asTvKwKn+KYX73y9eY=;
        b=Aob8RWZKTvWWnDUhE0cl9BSWBy5+720zjj6mp29X6E3Bvanop2RSTBKOvIGMGHCsyF
         AJnmHZt581uSBeIvqFqfDlbX2GetpbFWN3UzzoS+s1JPjbu7YnEsiIj1xVgwq1NqUrZj
         856mrdXZhQWhJ4JP7ZD0C5UFc79+Gp3+3Zlt4+OZeSCv4lij/YC/jK+BNQpDMwZvoile
         Oj3tVcP2ClBR3p9aHH8tDCw/RMgwY8VPClsr1vrPI0gEtBIZU1YTwC28OULiBsF6rlXc
         y8QeXsddZLqVqPNYA3YyjdLMwlVQJWR7tzmuszFZPeuj7ewmyNiUunJfr1EyMSPh2TXc
         ToNg==
X-Forwarded-Encrypted: i=1; AJvYcCU3hZQfDGBSDuVdxPXu2+CvS42EjTlQUWJxNJMLv5E4/zb/QHfOLzrQY0J8iAcejgFVx6o/G+K799SDx7sq2KOJOObR
X-Gm-Message-State: AOJu0YwupcU85gvKkXhIoZBQHPezXxFUA5vHIOE/K414mwgm6p8Ne5+f
	L4c7eJ8r1pKJ7hkqpp578Fe18K6ABLzZlX6gTfUoFc4COA4p7MO7x7ajHbdVow+BCSRlAAIqDmm
	qXkgj3N/s0q/pTjtjqw8+d/IWPeuFSxzMOiKnfJPxDJAex7Kg0g==
X-Received: by 2002:a17:907:3faa:b0:a7a:9f0f:ab2c with SMTP id a640c23a62f3a-a7d40087cdamr1036564666b.29.1722421100739;
        Wed, 31 Jul 2024 03:18:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbiyRYwcc7mzxbNr2j9CKiWLwtYHnw4iXERZ6Q+gmmNAwBwkH3zd03419QU5BCHgaYtt01lw==
X-Received: by 2002:a17:907:3faa:b0:a7a:9f0f:ab2c with SMTP id a640c23a62f3a-a7d40087cdamr1036561866b.29.1722421100197;
        Wed, 31 Jul 2024 03:18:20 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a7acab52d51sm750409766b.79.2024.07.31.03.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 03:18:19 -0700 (PDT)
Message-ID: <a76a83de-5dfd-495b-904a-878e1483e5f6@redhat.com>
Date: Wed, 31 Jul 2024 12:18:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 48/84] KVM: Move x86's API to release a faultin page
 to common KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-49-seanjc@google.com>
 <96df1dd5-cc31-4e84-84fd-ea75b4800be8@redhat.com>
 <Zqk72jP1c8N0Pn1O@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zqk72jP1c8N0Pn1O@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 21:15, Sean Christopherson wrote:
>> Does it make sense to move RET_PF_* to common code, and avoid a bool
>> argument here?
> After this series, probably?  Especially if/when we make "struct kvm_page_fault"
> a common structure and converge all arch code.  In this series, definitely not,
> as it would require even more patches to convert other architectures, and it's
> not clear that it would be a net win, at least not without even more massaging.

It does not seem to be hard, but I agree that all the other 
architectures right now use 0/-errno in the callers of 
kvm_release_faultin_page().

Paolo


