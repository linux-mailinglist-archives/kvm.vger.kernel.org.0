Return-Path: <kvm+bounces-59773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48EF1BCD68C
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 16:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 897D519A2152
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 14:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A032F5482;
	Fri, 10 Oct 2025 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LEJAyIzd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961E836124
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 14:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105436; cv=none; b=C/XX40ejBWaYPH6vSpQ0jInHpLqgfTD/lb5YxFS3sY48/yOXuQc3f6iIlxqm6f34+OiDdzYco9zfz7ilAsBxShdx2vK3NwoZwp+MVpxdFAS7LmuGEeDLcVQrLb5jXLc2fedbIYiJV5Fypo/vU+XZV8twmSicJseIFpq5zt41P8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105436; c=relaxed/simple;
	bh=WnTmIG8sv2E9DFWrV1Hwbbd3JgLJq3uxzP2sJdAHZ+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cl9WnGJkxlGLMoYNr8jskI9E7dPWr9+Vj2jRnQ1GvUUcuJnRPPygDwgaL52nZKhYgJNY/i4Kj/OITd9wwioECveJZIPlVUA04G9NCHNdmuacQ8OGeRBbcz5nMMHRJeqkSg3Nz5sT2t9JrT38vIEWsSSUWogPMC8PvVNrmJMz/9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LEJAyIzd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760105433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UXNK1UFl6W0l26ln9nbDxXcrbpbOOX+5O3MHtvsZ0hY=;
	b=LEJAyIzd8Kpfx87GdUmBOBDDGz+M08dHrIMAt3DZHt8rHNhXQQuX1i541QLL9faD0GhXv2
	oWnUNCtJDfzJo6AAVHwNtPq1cSEEjqVHJk3CNrwvJFI0XolLboOd8XB92cPt3MQXgFrhBl
	APq9RKLq8YflqHIoohpzjVij1Hb2GSM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-xRY9UVu3NyO2zU3gbWgY_w-1; Fri, 10 Oct 2025 10:10:32 -0400
X-MC-Unique: xRY9UVu3NyO2zU3gbWgY_w-1
X-Mimecast-MFC-AGG-ID: xRY9UVu3NyO2zU3gbWgY_w_1760105431
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ee1317b132so1248575f8f.0
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 07:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760105431; x=1760710231;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UXNK1UFl6W0l26ln9nbDxXcrbpbOOX+5O3MHtvsZ0hY=;
        b=JoLHTC2O9//uo+1mArQ9fiRj3sRwau2lKE4DeBCphRr18JRmIPI08JowVSL79T3698
         r0URjbQfnHvDJdvSCA/QTsXicpkC4mRCYpC1TvYVUr3dogZpiXIHa97z2kP0gwUwuAHi
         DoGLozUC4ww01S2qt3Yqf+D7e2XW4H753hl5C74wpvZ5YxWRdPuapwHPg4D3DFEUGQK5
         2uW0IPewwHO6lNNUSUFSwnsShhvToN9aEbzUHCdH6T/rFmp54QDC0/SRTOuzHssA65XY
         aCaeckoZVzdB5LCMPITgKJZgAy3+3/34XtS3N7rwbs8Ju3DOjurtz5j91PUjecb4Mr13
         NILg==
X-Gm-Message-State: AOJu0YwkK0AjOQjEr7/81itZeJkdTh9NheqtBuWMKv6PKRVo0/uL4+Xs
	dledveTyFakjwEVrSLpL5sH++Oc7t4yErxc5z3V71CAgMmlQ/On+2YjPKlIRL613bdodkhXOjGD
	KB515UnfOnqD50uq/48S3vT62s4R3bfuv1j92c9UP9iAQ8qA0Rcu5Jw==
X-Gm-Gg: ASbGncvmvrAb0I0Eq2peLguUCj9sVhHuoA6Ajmabus9GGr9TycQ+Mj6SvIBq1vTCoh7
	LQNKrbuJviK/isY698aK9ss+XFUtaFzP4XWjm5/I3CYFN8VSXdKNMaoj79fkCYoaTSxj4eo+Vv2
	JHtGil//+w9U0woNU4ewRxUaTpDcx/Te3yyJ95iJ/3///87dArvnZVR+UhFaOXB0vtduXbeqBbs
	pa9xP06+gOMoRF17xTctjLU6tPpW3osYLexxt0MwVbPYjFEOcD0psrw6nbkDEZvzanis+5BK6f0
	smmYJ0QUt5/cNVlDT8AQ5PLBoLDClFu0po7Cf8zjycUa6+/Poo4glVWO76brQtSNKKLTIF0coCr
	PpiI=
X-Received: by 2002:a05:6000:2001:b0:3ec:ce37:3a6d with SMTP id ffacd0b85a97d-4266e8d8edfmr8204771f8f.47.1760105430987;
        Fri, 10 Oct 2025 07:10:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeDViCkv/zeiFQe+qhOSbnoB6Cx/cQORfdroTZVj8/gk9Wc8lB3fQGvcgICSDxiRBWO4gvKg==
X-Received: by 2002:a05:6000:2001:b0:3ec:ce37:3a6d with SMTP id ffacd0b85a97d-4266e8d8edfmr8204754f8f.47.1760105430562;
        Fri, 10 Oct 2025 07:10:30 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e0987sm4329846f8f.38.2025.10.10.07.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 07:10:30 -0700 (PDT)
Message-ID: <1cb0a11a-e389-4be9-a51c-1b59de1356ff@redhat.com>
Date: Fri, 10 Oct 2025 16:10:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] KVM: Explicitly mark KVM_GUEST_MEMFD as
 depending on KVM_GENERIC_MMU_NOTIFIER
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>
References: <20251003232606.4070510-1-seanjc@google.com>
 <20251003232606.4070510-5-seanjc@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251003232606.4070510-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.10.25 01:25, Sean Christopherson wrote:
> Add KVM_GENERIC_MMU_NOTIFIER as a dependency for selecting KVM_GUEST_MEMFD,
> as guest_memfd relies on kvm_mmu_invalidate_{begin,end}(), which are
> defined if and only if the generic mmu_notifier implementation is enabled.
> 
> The missing dependency is currently benign as s390 is the only KVM arch
> that doesn't utilize the generic mmu_notifier infrastructure, and s390
> doesn't currently support guest_memfd.
> 
> Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


