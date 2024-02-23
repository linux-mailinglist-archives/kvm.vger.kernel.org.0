Return-Path: <kvm+bounces-9526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A4A861518
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04F1A1F2320B
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC318823B3;
	Fri, 23 Feb 2024 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8BWlIjs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B9481AD4
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708700623; cv=none; b=CcoxVNI8VTNwIRHc7JpDFValexdY4UZGRWzMA+u94nkv/M28QJtnKGCfDlh3f7kGGUfHoQe5sV09uOOOjj9OIgRQ7M7zJQ2wjDzw8YGP2geOYDuwgLm1LWshxw7lsr4aIpmDFSPJz8ojBqfWXSDsqe7mU9fu8D0A5LM1ZwNalag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708700623; c=relaxed/simple;
	bh=8jil4mbSESgq2jO/a3+fL4kkeJu1icvqEgSgVIwduTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FYiW+JiPwDzH8PC4kHdwbWBzflmS5yXwXrTTkn6Y44JXyL9gdgesVBZ7KIj23INeOUVPXOEQ+yjJnCuzDLsGLMDvCnxDWA6ft8E7mpejPeJD2A6/5qCvY5QjDTPcuENW+a8gaAryYou4WPPEGtBDdXxqZrci7bPpaaj4WBzhZDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8BWlIjs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708700621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ecX1ZPlY/o2pCTZHa4NF2QdsLPgZkb3A5+qcr4AfsNg=;
	b=a8BWlIjsFFIQaFak8sNaCq93K3ipq3Xo2AKSUCot620v/DKoSXaNcCFzEJWXo11GGJFNXT
	ABEON+Mcis27lzAIXUt30So106VqiOAL6PjA8mJGCHUiJlhAMiDatkvhIojfy3GeE/1ut0
	4ppk1dqEXSktJfFnn6H4MFlFfsJNzpA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-l3LSLNygP_KLKW3RTE-W7A-1; Fri, 23 Feb 2024 10:03:39 -0500
X-MC-Unique: l3LSLNygP_KLKW3RTE-W7A-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-564fec337b1so471348a12.0
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 07:03:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708700618; x=1709305418;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ecX1ZPlY/o2pCTZHa4NF2QdsLPgZkb3A5+qcr4AfsNg=;
        b=PvbfTwOL6SZrF0SOC4VuJk1zbZmOh/VPZXgKuv7Tx+BqOAzufkN+qUG7lAPD7R3C6D
         3X61TgZHz9ehZrHZgg2cXzZAqqyEZy1HXHPS9va7D0ZVw4ZeFvDRcpIwjlv74GfuepYJ
         en3tQz1WpW6OYonMYw7KZuNZaObi4FfVENvq3Zbgoh2ofvnLTbPiEb2sGfwf3x76k/i6
         /othw23xxfyaEXnndYeXJwepHcqI4G2pYZrgwBCLX4sCjKRNSPTwBAz4AdaqC3fIfgme
         6zM4aqex/aTYGO5gYBdRuGlEFOSKpQzVpijD4Y81jsPQGrueSKDsw+0FVKOSbbwMFpLB
         zk+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJ5MYBd3sADOnyAy4TlpgySYFhTRhru6MjXW4u8Y0py/oBFbZivMqftYaScILN/CUfNvu+7Y1dkM6tapILPjMt4O64
X-Gm-Message-State: AOJu0YxNMFfIIUTVVspnGRyoftWH2CEZ3+HId6WwgWJlZ/1njcnfdIZK
	WL7CLZk0nL+z8mLmymAuY4l7iHUWV1oESWtGsXuv0THlVi4UaLfFIykXaj9YsG7NSIre6cKl5FI
	Trvfzs1W00N/5R1uykSks+6HoxWFNr3sVUoifbcPHUIF7TaILrA==
X-Received: by 2002:aa7:d314:0:b0:565:78ff:f066 with SMTP id p20-20020aa7d314000000b0056578fff066mr89564edq.5.1708700618623;
        Fri, 23 Feb 2024 07:03:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFqlD1AAnBGfo+7yBY7w2ih/9JAT8JlEWHA/Zh1Qj8q87uZI6FDoqnsd4bhnIUJx7wE7MAsyw==
X-Received: by 2002:aa7:d314:0:b0:565:78ff:f066 with SMTP id p20-20020aa7d314000000b0056578fff066mr89548edq.5.1708700618315;
        Fri, 23 Feb 2024 07:03:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id e26-20020a50d4da000000b00564024b7845sm6944716edj.38.2024.02.23.07.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 07:03:37 -0800 (PST)
Message-ID: <0fab8859-5dd1-4a83-8ddf-8d74401ba298@redhat.com>
Date: Fri, 23 Feb 2024 16:03:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/11] KVM: introduce new vendor op for
 KVM_GET_DEVICE_ATTR
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com,
 aik@amd.com
References: <20240223104009.632194-1-pbonzini@redhat.com>
 <20240223104009.632194-3-pbonzini@redhat.com> <Zdivel5TiNLG8poV@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zdivel5TiNLG8poV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/24 15:45, Sean Christopherson wrote:
> And as I recently found out[2], u64_to_user_ptr() exists for this exact reason.
> 
> I vote to convert to u64_to_user_ptr() as a prep patch, which would make this all
> quite a bit more readable.

Sounds good.

Paolo


