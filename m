Return-Path: <kvm+bounces-26321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EBF3973EF7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57D06285564
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE471AC450;
	Tue, 10 Sep 2024 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q3U9sRwX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79101A76BC
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725988527; cv=none; b=lA6ORpXpFh3hl4zHz1KyyW/zek0tt5igBFBsU2tyS1FRBeiXT6l1SI1NCGOFPS2Q3HaoUE5AgNHSxGT4L8KZHP0HQXDXrtSe5ZYiWtAjvBuS7s756zQGAMgJQCfk73tWblrSsIUvcXXPFHX9+ZAk+69C88dzZe30Ek6EYT/GSlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725988527; c=relaxed/simple;
	bh=XFPw4yEHmK4Uj+n0pqWuMAmjYZ3OQyW2kdeqzb+wy1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QvNxoMYoXRX+h0IG0rHqvRUtvHZD3sKkcGLlzKTSKhe21v/N7oExKzEno6hZhHqCoN6C2NuPdIsCGTB0OBrVkKh26Z2DKIw+53MVuVncRjee42iCbegSHHpXJ8ZhTK0MQ/AVlxP9GgzpBl+7XIPb3Fk/556y0F3gCIcZUb8itFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q3U9sRwX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725988518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=USNHgAWTu7Xz/dUY/5bkNTj1kC3g7jbwqT+OELqU7Dc=;
	b=Q3U9sRwXtAbVwYx70FN1laE0l/CPACKuwLqXaU09z8FjgJITkxUG7TswaHa8hXjBRclnMs
	ba9l1AhVy4higs6DH5G1RcKOyMg+e1nuAoyyKc2pbDFrwNsSxjL2/+IxGalOglA/Mb/5hG
	h7iQ6fQRLM488+pOAcfygppjlfkjyRQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-EcjF0RsQOHmLEnegqZ-Hag-1; Tue, 10 Sep 2024 13:15:17 -0400
X-MC-Unique: EcjF0RsQOHmLEnegqZ-Hag-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42cb99afa97so17680095e9.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725988516; x=1726593316;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=USNHgAWTu7Xz/dUY/5bkNTj1kC3g7jbwqT+OELqU7Dc=;
        b=RCEDdQi2+r5neQNsgTj0WDR6an90JKMUHVSKEWZdUzn8JEwVE0hVfFntq4XHpPdvW2
         v15bYq4/F9c/oarLbtNhxRqP8alnz6bftwAJvFEkbEJvSdv3R+d/zPOpLTFpG45mk+Ju
         guiBIatIy6gqT9sus7ErETH1dTDQKaejTD/kN3L6qX7vNX2r+4Ost2uS7vnf1KO+AnCK
         8yHrbhBV9v0Ro+fU93HYoARi1dFdaDoeseOOElexlrWOcCQSILcyX2RqyuSB1gJJV74R
         xxBH9oDERpCQ8kigKXXRB2CO4OMBUdC2fFcKfY0dFi/slaU+XOh2dVJ2v8AQ92fR3PjL
         Z2bA==
X-Forwarded-Encrypted: i=1; AJvYcCWjrH0qz7d3cDQ07D9BOewVbY5XTxQvGiyXkqsijG+jaMyP/RyElU73QFn3WAkzXHIECnU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxFdqx2Xah2IeGIiYNcXDSaJdeOMKeqy8AEdvMDgoEmiSk1n7Z
	AfCWwYooS6dfauB98gI61eThkQxons6Bxjr+LwRqjOb0E3vHlXC5+issmHIPzduiYqmJEEwxlOI
	skDQf7tmXKDRqdxfGzVlUlcvWM++gulbgnm9WJM+amtKqYOe4SA==
X-Received: by 2002:a05:600c:358a:b0:42c:ba1f:5482 with SMTP id 5b1f17b1804b1-42cba1f598fmr45156655e9.35.1725988515940;
        Tue, 10 Sep 2024 10:15:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECXXwCUHaWoTl/1CJaefS9Qy2T+MFosNsOAumT3kcXW2Zq1atmXfCBm7JIbbwUJ75y4Z2WHw==
X-Received: by 2002:a05:600c:358a:b0:42c:ba1f:5482 with SMTP id 5b1f17b1804b1-42cba1f598fmr45156495e9.35.1725988515441;
        Tue, 10 Sep 2024 10:15:15 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42caeb81ac0sm120131165e9.34.2024.09.10.10.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 10:15:13 -0700 (PDT)
Message-ID: <b3a46758-b0ac-4136-934b-ec38fc845eeb@redhat.com>
Date: Tue, 10 Sep 2024 19:15:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Tony Lindgren <tony.lindgren@linux.intel.com>,
 Nikolay Borisov <nik.borisov@suse.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
 xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <b8ed694f-3ab1-453c-b14b-25113defbdb6@suse.com>
 <Zs_-YqQ-9MUAEubx@tlindgre-MOBL1>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zs_-YqQ-9MUAEubx@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/24 06:51, Tony Lindgren wrote:
>> nit: Since there are other similarly named functions that come later how
>> about rename this to init_kvm_tdx_caps, so that it's clear that the
>> functions that are executed ones are prefixed with "init_" and those that
>> will be executed on every TDV boot up can be named prefixed with "setup_"
> We can call setup_kvm_tdx_caps() from from tdx_get_kvm_supported_cpuid(),
> and drop the struct kvm_tdx_caps. So then the setup_kvm_tdx_caps() should
> be OK.

I don't understand this suggestion since tdx_get_capabilities() also 
needs kvm_tdx_caps.  I think the code is okay as it is with just the 
rename that Nik suggested (there are already some setup_*() functions in 
KVM but for example setup_vmcs_config() is called from hardware_setup()).

Paolo


