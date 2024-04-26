Return-Path: <kvm+bounces-16046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA9A68B3680
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 13:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC5EB1C21991
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 11:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C602114533D;
	Fri, 26 Apr 2024 11:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gQDdbq2i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F82A13C9A7
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 11:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714130822; cv=none; b=SaU2+81SaowA1F9MTS5XR3ZSFt5TKtyJCqN1ChBtyIBdDOYfAG+HL7xNTPDJDPhY7tx0VvEToKS7V3bfF4/ehsW43q40KbATck7aQBbQdmQnPody4HQk2D5wazzGXJwk0CWmY74M6YQqNiBYaOG9nzcL+eHfE5/U3pm7nnKnbNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714130822; c=relaxed/simple;
	bh=lJH1vAUzuD2xAYeKTWYUa/NPnYuLuV53+qYSGVI77ow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P6ty6MwpoX6yktLnb5heznvJvvrrpMNW6dlfbRy/NlRPnFqxUU9ovufNOTLhJqSKaBFhM5BNwoxXKBaUUfbi19fo3qT1CX3f1lW73c4WGEyFIe75b3WhfDCN1QIIqykgKD96uZAlV0GUZjCFsWCr+1e/QvruxObXEczTbMfwqc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gQDdbq2i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714130819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JRBls/m74qSZorjaqM9e4x5+tWNgtnFayg/PS7KECKA=;
	b=gQDdbq2ibZQbtSgjhqLXfnsuwkTEJn4anlMQXBjQnuPyVYxln3OQ+XSMZgnEa1KC1ez9x9
	mGsqU86Ua2SH5NMMrzs5mhS6aLfgpjEwjRhDwutqLC2te44myMEvmZOJ0mwGgdvrag1xuM
	OUJyiI7QfsEwfqFA1DLhvOYDBNOW1lI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-79ol58NNP-2Jfjrnb5iCYA-1; Fri, 26 Apr 2024 07:26:57 -0400
X-MC-Unique: 79ol58NNP-2Jfjrnb5iCYA-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-56c3dc8d331so1421035a12.2
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 04:26:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714130816; x=1714735616;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JRBls/m74qSZorjaqM9e4x5+tWNgtnFayg/PS7KECKA=;
        b=GemecnHGMhV9Ho9Gfklwg1EFriWbpJdAzZzK67/E5ClRjMAEabEapviCYt/K0N9eXp
         0kM46qGDc3hvcXCMixMzTTfW17/uWMMlvFjG6hFC2mE8xSGDEvYVWYPkxTky0BME1z0J
         2X92SZVWyf8m0w3Zc8JEJ1MYoNXhQIFkJLmCfCfTQw3N1rof5ahsG72jPrhkmaht5311
         cdvcrltowMKePoU83DqQBKc6j00QC+yCATZI1kqvNDnMTP/LkBY7EVpv6P5v/GlUd/1k
         mZLMgOW4ODfdzccmRFi0DjGeyFW9QCmkRFNTNyKp3kQjX2zG6DLLXdxYz5UnZYNj8PBt
         kVug==
X-Forwarded-Encrypted: i=1; AJvYcCW04pv+FlilMOmmXWj70r32nrD3CicA+u/3SZe3ZXC+4UC7xQdG/mPyacjcZc1KQV+DHiEIuf0B3PGO0dDLH223ZQgi
X-Gm-Message-State: AOJu0YxR9mfHob82inPENlJcgEqVz/RFCSaSauyh+MZRu7TcDhBHx79B
	SuAFLxU6VjCZMTrKetBBYAq65BnELi/CMu2YBlSR00MkMfanvnAbDLfUO321iYX3GVY8SnAn0p/
	kxmdd0RDDKRqFSc92SXQIlxvT65E0SoQAAAW4flSIRpUZtHOeMg==
X-Received: by 2002:a17:906:2543:b0:a55:be99:60d5 with SMTP id j3-20020a170906254300b00a55be9960d5mr1777773ejb.23.1714130816368;
        Fri, 26 Apr 2024 04:26:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTmS2RNHwSZo0ZMPFetXxqXDSHWpcVU3RNwabCfGGCM1vM9kw57Jrbn4SH8q65/QjO73PKTg==
X-Received: by 2002:a17:906:2543:b0:a55:be99:60d5 with SMTP id j3-20020a170906254300b00a55be9960d5mr1777757ejb.23.1714130815956;
        Fri, 26 Apr 2024 04:26:55 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-20.web.vodafone.de. [109.43.179.20])
        by smtp.gmail.com with ESMTPSA id g10-20020a1709067c4a00b00a4e5866448bsm10422001ejp.155.2024.04.26.04.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Apr 2024 04:26:55 -0700 (PDT)
Message-ID: <c1a69fc4-8bce-4aa6-8641-5d651df0fc33@redhat.com>
Date: Fri, 26 Apr 2024 13:26:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Use TAP interface in the
 set_memory_region test
To: Muhammad Usama Anjum <usama.anjum@collabora.com>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Shuah Khan <shuah@kernel.org>
References: <20240426085556.619731-1-thuth@redhat.com>
 <26993de8-0e4f-4d08-9009-730d674b16c7@collabora.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <26993de8-0e4f-4d08-9009-730d674b16c7@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/04/2024 12.07, Muhammad Usama Anjum wrote:
> On 4/26/24 1:55 PM, Thomas Huth wrote:
>> Use the kselftest_harness.h interface in this test to get TAP
>> output, so that it is easier for the user to see what the test
>> is doing. (Note: We are not using the KVM_ONE_VCPU_TEST_SUITE()
>> macro here since these tests are creating their VMs with the
>> vm_create_barebones() function, not with vm_create_with_one_vcpu())
> Thank you for the patch. I'm unable to apply the patch on next-20240426.

Ah, I was using the master branch ... it's a context conflict due to 
https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=dfc083a181bac ... 
I'll send a v2 rebased to the next branch.

  Thomas



