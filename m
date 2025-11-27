Return-Path: <kvm+bounces-64893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A695C8F8E9
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7C01E34441D
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 16:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A083385B9;
	Thu, 27 Nov 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="ZD8DZort"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6C925332E
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764262532; cv=none; b=kRxbXnTmojButsgYUY4pefdBQNcZpR/0eDBWsqkJBNAmE/hpn2JaLCojarn5fWl6zFX0thhZqfJ7vw31waKsAg1VaSij8ITSRVbKu6piPLLNtu1Z4BBDqsworwIWcHlSaXexxrbDgg5c2cT5KYgGFSNBrjRE1KZv+kCXpBJhUGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764262532; c=relaxed/simple;
	bh=IeJtPHg77YUC6PRv69OZcOoEvbzlzVHFg4enDQEEKAw=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=I8PYZEAHpXBzmM1JqkKZwZnfoIC+xIqlQOa6thFhs8fU2mGfhxFuL5+Hu1dJwvcxTKVWtkcZvP7UsS9uSdq3LK/IsmIR07RT32TRMyNPT5AxgdrmYKtL+FKesgCEcW+8e5cTlqeJudif2ZPHZv2yjRx1v+VD8pxdGRkrNwZttM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=ZD8DZort; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477b1cc8fb4so6082385e9.1
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 08:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1764262529; x=1764867329; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IeJtPHg77YUC6PRv69OZcOoEvbzlzVHFg4enDQEEKAw=;
        b=ZD8DZortgSKH9k8526fMPvGkY8LKo4aia8Py8fFPIz2h/RnWtEOj5Mft+aJwJSqfEg
         lVQcHCGR9x60b4q6rJO7JkaV5A+SGhesyxRjz/FbJ9DU11ImUqBQO9/z6Ur29eNyFCSA
         ai4xQWQ+fszjCqQM2Amqy/ZpoW2LAyAl2o6yU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764262529; x=1764867329;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IeJtPHg77YUC6PRv69OZcOoEvbzlzVHFg4enDQEEKAw=;
        b=D9JpQFqQSck1dZAIV5MpL10oQ1nuxEF8XmZJwPorGq7lFZEXDxQZdbr3MOdZxuab0M
         NblcvNDxN+ITaGcUWip0gWxVXy6z7h9LUnFD0b71UkkmLtGAYydw5zR4db/JJtALoU9N
         zmFkYUXt/H+h435VuUvmAGHoE059dc9dB1cs9hHy0Q/qADni+gEG2L/ljWfzKgnMVKzP
         Zua5wFTv0On4tM/00w21nSaVRFhwxBvt5RClQkRnuoc4UsuyK2Tu53S8AcY9XvU6atz1
         vRBZb73Z7JZ49mmUMcAoZkT5gn4IclB+DxQZ9q3nFixwr6B7nBzJMQHXknu8z8pRez9R
         egXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDdSleJCJLEglXuaYbdBlSxy35IkKzvgVNddbVXfP0k8B8CRb9e5Z0XNfrlECT6xvhjKo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwjk9o1xX2PFlcp7mB4NcOiLNulmJTvDB8XMUB0IgjTiETO7Uw
	bjbcKHOaOLDXmAPngi3iIS2dn6reAzkhlpi7jJF1d8oGbmk1bSCgvivF++muTmiK8vo=
X-Gm-Gg: ASbGnctyzcGGELFuzCGeEJc5UUdUw8l/ds9jt2qPC96+bXRE/8KF+2RGIUiYKcTf7t1
	RXxm7xmLeRWdhSYhYw5rGCr/C+KSw+c8EmY507prLyeUTxX//gWZmFHN1f5fRFkMB0vulMwEgkc
	Wgbe+CN4AGpRr8z582q+vKUpBVnFPWpDvh3yI6ZXvbyLWxDjVjeklvXhBRJkl9683369YjcGvWB
	mayeMbw7d4JF30bXkbWTNQyWEweSH5pmV9UtuFbsJvLoKzZSUlurbTb11432x628OfGAiSOs6Ge
	cv0B0wtA5E+UgdzwS2hDjYhiDAXTPXnotU064DWnTto7O8yyH2zdk5TTFCrTVaxcPHKAMuHk+Rb
	1c9GBCAvDtvBIZreEhVQhS8dRcTgEqSQKMfdFPy2YyV5RXlV3Arjsx3nSzoCgdpMxek1KJyjI1E
	O7OaOzVZ/IdINUf/5UdQFZoQpVzxTRWFLb6vBo9l7lfiSb1nWFdBQ5
X-Google-Smtp-Source: AGHT+IFqLmk3E13nTcdaR5/YH8vHx+R6IrCKP0URG1h1SzYYVaO5JZAy86O9ETe+kCquQNS6YUPBjQ==
X-Received: by 2002:a05:600c:4ed3:b0:477:b734:8c22 with SMTP id 5b1f17b1804b1-47904ad05bbmr111716425e9.8.1764262528611;
        Thu, 27 Nov 2025 08:55:28 -0800 (PST)
Received: from [192.168.1.37] (host-92-29-237-183.as13285.net. [92.29.237.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479052def4bsm69390685e9.13.2025.11.27.08.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 08:55:28 -0800 (PST)
Message-ID: <4676722f-98a3-4217-a357-068440dc6e14@citrix.com>
Date: Thu, 27 Nov 2025 16:55:27 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kas@kernel.org
Cc: bp@alien8.de, chao.p.peng@intel.com, chenyi.qiang@intel.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com,
 reinette.chatre@intel.com, rick.p.edgecombe@intel.com, tglx@linutronix.de,
 x86@kernel.org, xiaoyao.li@intel.com,
 Andrew Cooper <andrew.cooper3@citrix.com>
References: <f2hkqt5xtmej7cfnuytigcfszr3qja4l6ywww4qrqxjbqmlko2@r75b6deae2hd>
Subject: Re: [PATCH 1/2] x86/split_lock: Don't try to handle user split lock
 in TDX guest
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <f2hkqt5xtmej7cfnuytigcfszr3qja4l6ywww4qrqxjbqmlko2@r75b6deae2hd>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> I am not sure. Leaving it as produces produces false messages which is
> not good, but not critical.
>
> Maybe just clear X86_FEATURE_BUS_LOCK_DETECT and stop pretending we
> control split-lock behaviour from the guest?

(Having just played with this mess for another task) you're talking
about two different things.

Sapphire Rapids has an architectural BUS_LOCK_DETECT (trap semantics,
#DB or VMExit), and a model-specific BUS_LOCK_DISABLE.

It's BUS_LOCK_DISABLE which generates #AC, with fault semantics,
preventing forward progress.  It also means the Bus Lock didn't happen,
and there's nothing to trigger the BUS_LOCK_DETECT (trap) behaviour.

Given that TDX is enabling BUS_LOCK_DISABLE, it's probably also enabling
UC_LOCK_DISABLE (causes #GP) too.

Looking at the backtrace:

  x86/split lock detection: #AC: split_lock/1176 took a split_lock trap at address: 0x5630b30921f9
  unchecked MSR access error: WRMSR to 0x33 (tried to write 0x0000000000000000) at rIP: 0xffffffff812a061f (native_write_msr+0xf/0x30)


First, "took a split_lock trap" is wrong.  It's a fault, not a trap.

Second, because the attempt to disable BUS_LOCK_DISABLE was blocked,
simply retrying the instruction will generate a new #AC and livelock. 
Linux probably ought to raise SIGSEGV with userspace, for want of
anything better to do.

It looks like software in a TDX VM will simply have to accept that it
cannot cause a bus lock.

~Andrew

