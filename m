Return-Path: <kvm+bounces-29507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3CA9ACAA5
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6CB81C20CBD
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 12:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD7E1AD9C3;
	Wed, 23 Oct 2024 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DH6x5Zr3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADFB14D2AC
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 12:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729688323; cv=none; b=T4SAPVba+U6U8PZ+YduIZqt7H6oQu8VX7nx51UcZ8o38ZRpPaxlYaALGDw0jo6MxFFkycEu1fL8HQEBS8u33M7rwP7TO22DQ3JB/b3+qZ0yE6KWF2KUKvU4C5/zTdDFWsP1ph9B+8RMRsApe+ZmcSz9ljs5LGMULKYb3m/axdTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729688323; c=relaxed/simple;
	bh=jFFsV+7qXKcZbB1QpgWXBO43D1kMLy2XtiXCrHjAheM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aAjnp3cFAvwwWkJW9moLF8ikJW6E776uwerrqsRtuLZMPBpgtB6NHkTGeKaYDIgvujh0rbVsL4VLtrP+0gSxteIaUOB7NDrO8QlDt9WIzidla/8NCNvtRcTqUyF945oiXOiXOY7sZwInt2iwL0rdByoqiudi+sBRPBq7NK+oO7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DH6x5Zr3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729688320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cmc0ZXr9HAxJy8JyfDlIHzfWmtCzYV/tdIH6aM6k9ag=;
	b=DH6x5Zr3EYuQHcruwMAs74iw1DEQ6Zq+sRl2dGaPG+sCq9WCTdSwLmZz7jnubjdNt1NuI2
	rlEYN6ZF53ciFQ9VYMiFxQx2+V5Cfa9NuKMGm51P4wzV42SmOIOQc9DmbJcSeU7z75EZxa
	AVjAOCORyWOF6EgjlqC42AUDbup6L94=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-Fl8Tbqj_NIipo7F4MzaZ7w-1; Wed, 23 Oct 2024 08:58:39 -0400
X-MC-Unique: Fl8Tbqj_NIipo7F4MzaZ7w-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4315af466d9so47302325e9.3
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 05:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729688318; x=1730293118;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cmc0ZXr9HAxJy8JyfDlIHzfWmtCzYV/tdIH6aM6k9ag=;
        b=GHJUqNI+0CCczB0YE1SrxlxZ0OarzlSIe9hIw9uC9aCxnBmnG4x3fUE5B5sFyZx0qz
         Xz/qw9FGDsF556vQWTsC2EVbpipa4qewlQutSKwdWXfr/5aJX0p3pn/zutqNnIZGhKfh
         j7fff0u+/N/9nGm01B9jL5yrAGczbu15b0CGo4/zd84cNG4RMSQhK5usfNZAa7mHdQ/H
         VlxpOPtYtWOcfUm5lp2gprw79NrQjIWHC+sbRib+FvxvlI2BbERo4I2SaYLpgy+t9ubx
         M9iFfhIWQINkdztRllqjqVPe4dKZX9YB7BNy+ns7twVkw0JX0mg/Q9sGysDH7ygLkkBG
         o8hA==
X-Forwarded-Encrypted: i=1; AJvYcCVtHJR3eu/mYYGGvR0bzPlVIsOPhSdwkO0HLwd8nPIqwFfmLmfUqiRUNJOtkTp6clO7pW8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yymkr80J56L3pEWqHGhNv8CzVfu0aYSyhoLb633nQdvOhNFGjgG
	DeRfpQGAiI/j+6oV7N7IgOPYGxgIuecDzc9PdiF35Vc7LmQ+FTf6NpM1ePPmGGBOOKqU/IrVBsV
	qG5ZkQg2h7/Kov3iL4XPFnUTqEnW5HgZ1Kswh3V/1XlHzULXyHg9o20uv9pBz
X-Received: by 2002:a05:600c:4e48:b0:426:6f27:379a with SMTP id 5b1f17b1804b1-4318421150amr22824685e9.13.1729688317718;
        Wed, 23 Oct 2024 05:58:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRqhovKJglA+voaQrphSfrRMVD0g6zoIKMkSl73MqSyuppwrsC7R63Gw4JXp3527O9cedgiw==
X-Received: by 2002:a05:600c:4e48:b0:426:6f27:379a with SMTP id 5b1f17b1804b1-4318421150amr22824475e9.13.1729688317286;
        Wed, 23 Oct 2024 05:58:37 -0700 (PDT)
Received: from [192.168.10.3] ([151.95.144.54])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4317d03b8b4sm44004325e9.0.2024.10.23.05.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 05:58:36 -0700 (PDT)
Message-ID: <cd69f611-6478-4df6-907e-433ac559a20a@redhat.com>
Date: Wed, 23 Oct 2024 14:58:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Array access out of bounds
To: Liu Jing <liujing@cmss.chinamobile.com>, mpe@ellerman.id.au
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org,
 maddy@linux.ibm.com, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241023120111.3973-1-liujing@cmss.chinamobile.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241023120111.3973-1-liujing@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/24 14:01, Liu Jing wrote:
> In the kvmppc_mmu_book3s_64_xlate function,
> r = be64_to_cpu(pteg[i+1]); i used is 16 after the last loop and adding 1 will cross the line.
> 
> Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
> 
> diff --git a/arch/powerpc/kvm/book3s_64_mmu.c b/arch/powerpc/kvm/book3s_64_mmu.c
> index 61290282fd9e..75d2b284c4b4 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu.c
> @@ -284,11 +284,16 @@ static int kvmppc_mmu_book3s_64_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
>   		second = true;
>   		goto do_second;
>   	}
> +	if (i < 14) {

This should be i <= 14 (not "<").  And in fact, if you get here you must 
have found == true, and therefore i is indeed <= 14.  The code right 
above is this:

         if (!found) {
                 if (second)
                         goto no_page_found;
                 v_val |= HPTE_V_SECONDARY;
                 second = true;
                 goto do_second;
         }

and  "found = true" is set just before a break statement.

Paolo

> +		r = be64_to_cpu(pteg[i+1]);
> +		pp = (r & HPTE_R_PP) | key;
> +		if (r & HPTE_R_PP0)
> +			pp |= 8;
> +	} else {
> +		dprintk("KVM: Index out of bounds!\n");
> +		goto no_page_found;
> +	}
>   
> -	r = be64_to_cpu(pteg[i+1]);
> -	pp = (r & HPTE_R_PP) | key;
> -	if (r & HPTE_R_PP0)
> -		pp |= 8;
>   
>   	gpte->eaddr = eaddr;
>   	gpte->vpage = kvmppc_mmu_book3s_64_ea_to_vp(vcpu, eaddr, data);


