Return-Path: <kvm+bounces-22752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25E38942BBE
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 12:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48FEE1C21E57
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 10:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9262B1AB531;
	Wed, 31 Jul 2024 10:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C3Va1Mnk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE01A721F
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 10:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722420764; cv=none; b=YhwBDzKPi+yppfupIcoanJXaMNlhLg7/spIfOtY3ZNIOeyLINjxoMazEAeOLoZb+eAdKjUyxHeGhG1f/7lH8bnExritpCvCre1RxwDnxdTDCFu1L9M1f/qKHHKLGyBVPbWkI3O5yoj2WF+OHWnAcbrDZA0r8g10z88rHF0q3MH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722420764; c=relaxed/simple;
	bh=yfS7leuz4MtF3tluYvWC4+0Ie6a/fa+MMjIPKi6ChBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uiMp4gADtgdXY+L++n3JE1DPmVGxQghiLgu/Ckd4wmTDYcJvcBKwUQITwqDDgyCTs4ycUF8pvXq7FyUXR/elWGTM/SNFbeq9+LpfEF78yXMdvhiFlLK8gPNEg5am644IHdZMmHbZVGyNV3NNim4ylQgPGBa/j6Lsken2AQrUiDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C3Va1Mnk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722420762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Bn9tfbIdSVCZqAMkxg8q5HTQiaczDdPE94ihy0l7iSo=;
	b=C3Va1MnkBdXaIxQ0qq3ggChElcvaJWJqQxRxk5dLLutRjNGSsj7yDzN6fnNbCcZUCZLhZN
	pSwQXFhVG+ybclYzGXA0CL2Ps1zU1BFZL7844cu9ccdVcTTTd1HXPliAfL6FxuvhWWrZWg
	LJDVT/RpSceF1bm4ZVPG8MNjDuIUSU8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-2j36rjnuOyOoJDRetDR13A-1; Wed, 31 Jul 2024 06:12:41 -0400
X-MC-Unique: 2j36rjnuOyOoJDRetDR13A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a7a9c275447so354330766b.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 03:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722420760; x=1723025560;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bn9tfbIdSVCZqAMkxg8q5HTQiaczDdPE94ihy0l7iSo=;
        b=PNahYCpUJ95KK8MPGlDRRechYq88nfUB/smaxSfHM5jD9yF14PWFLjmaZMT6eedsy5
         FUbBo/TdnQYW3i9QU4vB2j/Hmv6mykbC68gzVAAiYn2TuAIDEabuG0bzsUe/9WKfFDQG
         Dn5DfDf0LDgt68ALRLuM0YTdS/ycA658c6PSWRrg6/CTGUxpNXVaows7hItv9+5nbwGy
         +amPDxr24jd2zaa87z7UtXCfyHTIJpaKGXLLFEfgdiOq+hiKvAFSyK88J04Pfsy6Rwqd
         sOkQi0ViDSV22Pox/imAAQjgLZfnVaX72cwzWAdupi5OXW523uRXDIBmvlHoWjzMkb6S
         oMvg==
X-Forwarded-Encrypted: i=1; AJvYcCUXJcrX3UClPMG83AZmPB7PwubeQFAUOfyaFb3gx7/VT8LuD6OkVKuOvqDPU1u9L+4PP/op4G9ulUFPwzz0VU9Svr5A
X-Gm-Message-State: AOJu0YzGtz6dfLupMYx4UpZHpMf3fcIwjQ0Ss21DJ6sSSbbPR/TZKHTr
	qBkSawOpv96NkYjwoSm1oVzYZXOG85tfvOTPX4GKpo1QPQAV5R67+iy/UInOgUif1bAr+uZmVBP
	xypcUMjGCaQmnZCVPydu8LoqHlr1zFbuu63U6Te81ksqVbr8S4g==
X-Received: by 2002:a17:906:d26a:b0:a7a:c256:3c5 with SMTP id a640c23a62f3a-a7d40161c68mr868866766b.46.1722420759949;
        Wed, 31 Jul 2024 03:12:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5PK2N6SVlp21V74v51wpDQW38LtkY7BoBaQqhGgHQsZ4igHg8AC/1gwfVPPR89SMfLALrEQ==
X-Received: by 2002:a17:906:d26a:b0:a7a:c256:3c5 with SMTP id a640c23a62f3a-a7d40161c68mr868863766b.46.1722420759395;
        Wed, 31 Jul 2024 03:12:39 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a7acad41164sm746659566b.102.2024.07.31.03.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 03:12:38 -0700 (PDT)
Message-ID: <10429875-b9a1-4454-b54a-1c3be5630771@redhat.com>
Date: Wed, 31 Jul 2024 12:12:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 45/84] KVM: guest_memfd: Provide "struct page" as
 output from kvm_gmem_get_pfn()
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
 <20240726235234.228822-46-seanjc@google.com>
 <2da6b57e-d5c2-4016-b89b-d51700eeb845@redhat.com>
 <ZqlGcaESdxw5vzl8@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZqlGcaESdxw5vzl8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 22:00, Sean Christopherson wrote:
> The probability of guest_memfd not having struct page for mapped pfns is likely
> very low, but at the same time, providing a pfn+page pair doesn't cost us much.
> And if it turns out that not having struct page is nonsensical, deferring the
> kvm_gmem_get_pfn() => kvm_gmem_get_page() conversion could be annoying, but highly
> unlikely to be painful since it should be 100% mechanical.  Whereas reverting back
> to kvm_gmem_get_pfn() if we make the wrong decision now could mean doing surgery
> on a pile of arch code.

Ok, fair enough.  The conflict resolution is trivial either way (I also 
checked the TDX series and miraculously it has only one conflict which 
is also trivial).

Paolo


