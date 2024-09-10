Return-Path: <kvm+bounces-26325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C11A974033
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:39:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 810CB1C20DF2
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE771ABECA;
	Tue, 10 Sep 2024 17:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QzkZ8D6p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065821ABEB3
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725989483; cv=none; b=dCFo83H1J0hG8qMdXD96q+8Y73jc0vUgOwiuFoVKJluSDd9iPGe7+l3kPY5PJUX3JIu9rovja3FFiu76K1WsTIHpti+67EtxWmDJq1W/n8FnI6eR4ASKxI2Mc9CrvIDG0ZQhEUg++tAQn2A8ZICTXAS3ZcMBPHGLokztodQBdHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725989483; c=relaxed/simple;
	bh=zLg14Q65wu05Yz0CdocNRo3LsUGTtqQTpYBpH3ca0cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MSGjEVwF64nKmzReGNUWmggOfvT3Gz44s4ARGR8EDQL89aPYI4F0EHcpvkm1rj/gNag58YtKk4ajZmIiLUYrb34EkR8Lwoo7ZTgttfCaIy3jMAt8QrSBbuJ14LUAjDaIjmBWzkAhRJLBk9czkX/meUxdlAIwyZG4X7MGFau2rpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QzkZ8D6p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725989480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xLcvqp5chP2dPZGzNdVbZn2ZJp4vCGE1ONukxZlZVHE=;
	b=QzkZ8D6pVF4bvMvypgy57k8m0oMaDSoxQ/oUXCL3gAgiXgkShpQ8vNNsz9oapaL8ToC50I
	yo9nAxp9QioPgui1Eppo6dqHjJWv80BPP23CJJI/DLD0Nq4RXOGIyWxPh9bRpigz/CDhdI
	YQ84ImDbkhsyhlwbQOCfv8P/C68d1s8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-My7c0JopM3y9KoN1T5HEPw-1; Tue, 10 Sep 2024 13:31:19 -0400
X-MC-Unique: My7c0JopM3y9KoN1T5HEPw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cc4345561so4975885e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725989478; x=1726594278;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xLcvqp5chP2dPZGzNdVbZn2ZJp4vCGE1ONukxZlZVHE=;
        b=g5jkl1tfm0hqam9AYzV0leM7wLjOAxbCft66xCCaKJyEy6DCT16bHErwgA0vRulv3O
         8ThEAal4BgpuPNXp3cRDHnlJYVOFGduAuOy97gqYaNy08cWEolrceXcc2Y+Viaq+FfyC
         uISRGZHGmPNW2eCh/kVIEKzYmFNxgPjugbmLrOT60pGAHpXcZORaKscRMzydluSuNfM4
         UwUDi1cBVNAJJd0mmWQMOiJP1xKEDrMyJGIa6D95gpFEpgjsLAh6p1C8/fis9I2aENnr
         G3AJdxD4a5OP602UxTIXgplHXWaOSiDPZ/XXpLJQSqPQxMdXQ2Mmce6wPuKKQ0dNaLaL
         nYiA==
X-Forwarded-Encrypted: i=1; AJvYcCU44majDAf+FofyvOwXf1s8N7VIwwGQ+2Ew4GDw1uf2hwA5E5Ay+Vm6ghoGr4S/20qsUQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxLMRbj/xrAuS5LGlQMZ5E0GqJwHuRqrQtIHWBEGu4l0A5kmjy
	K8q6i0bS8DXLN+68gQlEo3FCnAPFv8nd1Z9CsBFsKBCq16PC9bjvsydUYCVC/u2/jClWJU6OQG/
	wfOgQg3ziW1+j4a/D6ScUYu/nqsxHc/autkeIq25HNbVM/Jm//g==
X-Received: by 2002:a05:600c:1c16:b0:42b:afe3:e9f4 with SMTP id 5b1f17b1804b1-42cad746525mr90187365e9.3.1725989478429;
        Tue, 10 Sep 2024 10:31:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFM6s6VhdPe9bBCCI8bOowhCo7zDIQhAJP38VRyGZKXGtWax0aiQPX7UTyQyQY8XSUWwg0yg==
X-Received: by 2002:a05:600c:1c16:b0:42b:afe3:e9f4 with SMTP id 5b1f17b1804b1-42cad746525mr90186995e9.3.1725989477901;
        Tue, 10 Sep 2024 10:31:17 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37895649bafsm9642275f8f.7.2024.09.10.10.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 10:31:17 -0700 (PDT)
Message-ID: <7ba0756f-3a7f-4aed-b0d1-d47c1d4cbd5b@redhat.com>
Date: Tue, 10 Sep 2024 19:31:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/25] KVM: TDX: Use guest physical address to configure
 EPT level and GPAW
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-23-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240812224820.34826-23-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 00:48, Rick Edgecombe wrote:
> @@ -576,6 +575,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
>   		value->ebx = entry->ebx;
>   		value->ecx = entry->ecx;
>   		value->edx = entry->edx;
> +
> +		if (c->leaf == 0x80000008)
> +			value->eax &= 0xff00ffff;
>   	}
>   
>   	return 0;

Ah, this answers my question in 21/25.  It definitely needs a comment 
though!  Also to explain what will future support in the TDX module look 
like (a new feature bit I guess).

Paolo


