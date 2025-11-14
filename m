Return-Path: <kvm+bounces-63186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 038C7C5BE5D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:11:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 776DF349A7B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 08:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4B82F7456;
	Fri, 14 Nov 2025 08:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Srz9cZ/l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9442EDD7D
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 08:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763107831; cv=none; b=RYgCGuhw2LOh+xTmfCYxoKQsPdOSTrUMVFTDeqpgiwEhym4HtJC65BguICqi7WBk5n6QOexYICCHDAQiDioxpg6pfnCTw0Dkr0Ftyj5zzgjw9XptcxEic6Qw4LOZwZG9y3rYZpwxLsm+YsIVLUMvfvap9Hjy/pebzixcQSmecXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763107831; c=relaxed/simple;
	bh=JAy2XF+H57mQLi5iD+SEiog6zHCxesT8sGRMBL0o6XA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BiIdCZzujdrnp2zeYf9pmDvUonlG4fZFd4JoEz9JKWA6nEyBXn52Sg7deNsLRJvdm184ueYMkx5iBtbxXRNrB4+Ur4szjDrTaVP/V7agCHFpncYoJ6c5w9KWVekVU1cCbnfqReFgINqrlbdzkDqeINQY2mOEQgVVXjTMY8/qroQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Srz9cZ/l; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8738c6fdbe8so17183146d6.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763107828; x=1763712628; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BveDjWQS+lDCk+T79CjJHLJRu/8FGKZtDMFVn8ERQPM=;
        b=Srz9cZ/lkm2YFoO45e02xbS+mz67WvFokESu27R6RqxysKGnxuIwtDskn3995+/bwX
         V1JxsZS1xZGMWSnuL91FM0gLLxyU46SE6dM5+4oEPACc3OILMJFvrTcYew3tqEXO+sad
         WzdwMcEfs9HFLch2RyDpTqAbHvoqGEl5ce8grQbLgJDAl8yOIJ/X46Y/1GiMTH0J2ErF
         n022WTRlbuE0VF2yTQwo9ISuQY7ShtWyeRZGYdEj++xXoZIl6dJNV88OYhTv62KXrDpR
         XF2h7EJ9HC704T+WiqW9Q+JS3PVBKG707BazMZSuwDqrAvYwyfYeuJR/5ADvgsJwNwCC
         HVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763107828; x=1763712628;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BveDjWQS+lDCk+T79CjJHLJRu/8FGKZtDMFVn8ERQPM=;
        b=V8gVQk6Amf0U3ORD5qIT8Y5NLPynemoeSI7PdBMIgeywNJ/iN49CFN75UJFBgYJ9+D
         SEueL1syQilDTcz18KKHIhLX4Gsi2nmltYrwjsBiTchdG4DX3khZDgVqmYwwG3JDYIZH
         RkDUVQaQjJyFJ8TMkXIjJG+HI99xl/9+oIaII6zQTWNv29bLdrnWa2Ch+h8dCW7Nj8nC
         aAv7KAUmVCo4l8ToGzo17laPpXT+VOb+Z0nmTXlwUUVfkzdQ4XoChKmobLjvMRafHdcN
         v0Mqk40i35fPVMpBQ7ka+fGtfWrRUHGqFTJQtZsseDeQ4i/RgHqE/lApRq3mXHkCCAFR
         KPwQ==
X-Gm-Message-State: AOJu0YwYHY6oUTlDKXlD2Duz14Xqut6Y7CZ3GOyXOMUENSXi+a8KHzQt
	nmlX39i3PzLjmdJUluhCpgoveyP+N1qPdaRyuAMeG2TOy3DjzssV7k/l5aRbj8RKvFdjE1V1Hxt
	fLQTh
X-Gm-Gg: ASbGncsCIpKVWykKsZ2ZCTo9c92jjBtVYJlr7yWo7fCZgR++tqq6NJfCA0FHzVnvk4w
	/WQ/dnx1lI/upQMCVjnEu7FGTmjIHbjrKLZF2EbOoGKNE/LkCXaXYoFcpVMs9KH3u5TcA9g/yET
	LCS4WuhxwK6S363PyhmOxmhMu9P7osPOYPuq9ZPsb5uPO/2z7x8PoD0CZtcXX99TTQAbixDGt1H
	lLbZF0N/V8gzCZxROMLTODT5lCnKVDUFFhNwN4UQ6Gfx9PTcckFg9f2JRCeoUaKamyJggK5JfMg
	iOcIGrV4oDOuw+LUxh2WXA3DMMXkQWv1qZuyeqvBgxNcnYIJUQfY3hPEBzkAty+sak7gsmZAuUR
	XYAJBtk3Pyh1wK7cOIfKasN2nmXGAiDkwKta02/8Tti/kvRZYo1b9qf/u/iKCGE2OnailWGMOP0
	4hX4HrYWwaDc5882FFjzhh9prGi8MwB9RbkTTTMkiiOfhs+fn529GRgma83B3EYPIjym/oGjp4D
	Pao2QFkP8AwOr+aAb+A1Y3EHCHjNgYMeznfvGiGPCk9Ow==
X-Google-Smtp-Source: AGHT+IGXnxuxrzHXuFngs+bln0DBTZJ91XL+qmQwPVRBHzrhuJHlKnpQ4XCqIlqNVnkLW68hbLjOWg==
X-Received: by 2002:a05:6214:1d06:b0:880:3eb3:3b0a with SMTP id 6a1803df08f44-8828179e982mr89597246d6.4.1763107828358;
        Fri, 14 Nov 2025 00:10:28 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-882865342b9sm26841836d6.31.2025.11.14.00.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 00:10:27 -0800 (PST)
Message-ID: <c95c22ac-a319-475f-b87a-254041c9fbb0@grsecurity.net>
Date: Fri, 14 Nov 2025 09:10:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 09/17] x86: cet: Validate CET states
 during VMX transitions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20251114001258.1717007-1-seanjc@google.com>
 <20251114001258.1717007-10-seanjc@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20251114001258.1717007-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 01:12, Sean Christopherson wrote:
> [...]
>  
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index acb8a8ba..ec07d26b 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -453,6 +453,13 @@ arch = x86_64
>  groups = vmx nested_exception
>  check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
>  
> +[vmx_cet_test]
> +file = vmx.flat

> +extra_params = -cpu max,+vmx -append "vmx_cet_test"

This is missing the fixup from
https://lore.kernel.org/kvm/e5377f36-bc19-4b16-bbbe-884951fb414b@grsecurity.net/:

-extra_params = -cpu max,+vmx -append "vmx_cet_test"
+test_args = "vmx_cet_test"
+qemu_params = -cpu max,+vmx

> +arch = x86_64
> +groups = vmx
> +timeout = 240
> +
>  [debug]
>  file = debug.flat
>  arch = x86_64
> [...]

Thanks,
Mathias

