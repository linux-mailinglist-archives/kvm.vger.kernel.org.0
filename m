Return-Path: <kvm+bounces-58960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8839BBA869A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 10:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F21601897A36
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 08:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3232126A0B3;
	Mon, 29 Sep 2025 08:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z87CiL/a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D399622F74E
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759135136; cv=none; b=WePmtdv5NCYgboRigc+pJn+Io1x7e575VAQjeS6nH7Xz5h7IfPqXKRf2RnmoXm0KuZQZnFVxHiOJgjnVJ0pBqucd4QzH5eX31U6Sa+sayxjBtEsDAy0cSraJIvVhNDuV86JH9clVX6rjvAG6Ix86gJHauLkz+2Fc28K+j9n3yX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759135136; c=relaxed/simple;
	bh=DGXaWOvvKM7o4hekCoZdxdQgjfWoeYeqiar+JIXO8BI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jjvA6Qffp7vsQ4+a0CC/vbc3Rk+9SspahQELsqBeiPM/s9qLMQNY40HEDk3zK3K0HA3j/ex0R9Yxddx5ytUKLtSxNUMgOlFVkiVcdqXEk8+ksrNUlYoIADTgjlTRfR+1ht6F2L09BTdb4vReVbJz5UvvVcPndE4JfOWJFxmQjYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z87CiL/a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759135133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AsaMWIYtbBtVBfpmpyiR+SeKnf95HfK7yUC9+oaG6D8=;
	b=Z87CiL/aVJ17tVsAAp8K9zqnYIVRwfvkGIiKNyww7oNZy1Q145xtFme+80zcqrTvZdQwv9
	219HrwadnirYhPZ02KwTAHtZ0okEwkBxVYIk2ORYUBpU0kzbyZ8KMsAQ6gFLN53uFm3+iB
	qUJpIc/B6zQTeb3TFyEPROlYPkZiwvs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-DWpqM4CUNF2wPgUOIi4INg-1; Mon, 29 Sep 2025 04:38:51 -0400
X-MC-Unique: DWpqM4CUNF2wPgUOIi4INg-1
X-Mimecast-MFC-AGG-ID: DWpqM4CUNF2wPgUOIi4INg_1759135131
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e4c8fa2b1so3758975e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 01:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759135130; x=1759739930;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AsaMWIYtbBtVBfpmpyiR+SeKnf95HfK7yUC9+oaG6D8=;
        b=PbhSW9CbfibrTyUJWBV1uNgO60929XRrhlzPpy8THeNoL4a75qPeXg7xRjanRUXtpI
         qBJcoqIKEY8qOmdLl7DH72X666GSqGIMJSkV01lmVIO5BImccH3C+c3W5YFCBhe1WatB
         PFbN8imDMvhd7VVH43b13jAoiGlgiShRm8rNMzkOJ0tg11vuUFZ6/f5Bt9ybBgkeofAL
         bxqJYVWRQK76w0CcKayim///OGXMidv7LScp9L7+uPhP+eLBf/r338cIADAb68rUPYeF
         mw2OLO6fGJ1Zfv3lvwzOI+IbXDPujV8B4fGZGinsHp8wH97Ib4URQDOAwTD9VN3OsswF
         GcYA==
X-Gm-Message-State: AOJu0Yywvr7DhyTdIq9Lf3FtMmkXuqasTdJseKaxX82Gs42gKetufdNv
	QTq0Br4XnEBna2kGrjAWFPd8Dka7+4/2bMSAjRbVExsGscjZy0bL4PteOy1jLLnyszip6LWCuky
	n6fCc4bslSBlGp5ViVkT7ux52e5KbA+KEahH2j8bBbTPKNv+oc+pvMQ==
X-Gm-Gg: ASbGncuWBJwsQEwFPES0p28D0HdBaVTgPnRfwyMCGBPdPvHGoIO0EVd9p/acPPLI6Cw
	/Eh7gKjj4u/JWXyDDdLNxbEKAPkhJr+gvjnfmC8K/cNX7+EMPv8bmUrc8XdHVTvNlm854uZJYgt
	sAPuWYQcg6pIg3aQ2OYhRTNQKCV/FPh/RngRiYNZwuWnxmbA2Zhdg4ZAPXameSEn4TrUWiqlGav
	I/qidwjCoxg+AktrQs+I6h8A/aYbf4xE8C5fZlqtPHOvJPUlsLTS0VNVfVue1v7q3vWzsvaugnO
	y5HQNvD+RVZYjmbweY53l9V3cP3oE+0vC1yE4fzpSRCE2xI6Or7NG25hXLPUhiLqgrVew9ozCNE
	3ugdPvPFH/ub7Ohk0m1WfWePu/ohPOBkcwD2IBy2IELjfoC96NDzlTr2Df3ZI8+MFIg==
X-Received: by 2002:a05:600c:630f:b0:46e:1c16:7f42 with SMTP id 5b1f17b1804b1-46e329aec2dmr153481025e9.11.1759135130595;
        Mon, 29 Sep 2025 01:38:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcV6BjsdOdU1GfaihKJ08y3WjEiB6j1KPpJKZ3FGWr7FHfxfJvDumut+aa2UJzUHnPY07gaw==
X-Received: by 2002:a05:600c:630f:b0:46e:1c16:7f42 with SMTP id 5b1f17b1804b1-46e329aec2dmr153480715e9.11.1759135130200;
        Mon, 29 Sep 2025 01:38:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e4c048f73sm56989435e9.24.2025.09.29.01.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 01:38:49 -0700 (PDT)
Message-ID: <7ce29e23-aea9-4d4d-b686-3b7a752e0276@redhat.com>
Date: Mon, 29 Sep 2025 10:38:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>
References: <20250926163114.2626257-1-seanjc@google.com>
 <20250926163114.2626257-2-seanjc@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250926163114.2626257-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26.09.25 18:31, Sean Christopherson wrote:
> Add a guest_memfd flag to allow userspace to state that the underlying
> memory should be configured to be shared by default, and reject user page
> faults if the guest_memfd instance's memory isn't shared by default.
> Because KVM doesn't yet support in-place private<=>shared conversions, all
> guest_memfd memory effectively follows the default state.

I recall we discussed exactly that in the past (e.g., on April 17) in the call:

"Current plan:
  * guest_memfd creation flag to specify “all memory starts as shared”
    * Compatible with the old behavior where all memory started as private
    * Initially, only these can be mmap (no in-place conversion)
"

> 
> Alternatively, KVM could deduce the default state based on MMAP, which for
> all intents and purposes is what KVM currently does.  However, implicitly
> deriving the default state based on MMAP will result in a messy ABI when
> support for in-place conversions is added.

I don't recall the details, but I faintly remember that we discussed later that with
mmap support, the default will be shared for now, and that no other flag would be
required for the time being.

We could always add a "DEFAULT_PRIVATE" flag when we realize that we would have
to change the default later.

Ackerley might remember more details.

-- 
Cheers

David / dhildenb


