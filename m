Return-Path: <kvm+bounces-58425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F09D7B937BB
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:29:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 185271906891
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622F13148AE;
	Mon, 22 Sep 2025 22:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IX5E30KV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E3E28B415
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 22:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758580144; cv=none; b=RUYYH1PjH3wGG0V6JTpwcnbBaIrAxpojQSfDG8JEN1xgOFkLMBIF6c4968qUNz5wRQv0+tX2+JASOUbi878n/ewQVVYqvzQwTdzciYppKMha3plglc7GgNo2NHwJrbp7Xx0o+tCqSFmWj6E9HBbfVmkvYIxv0pq4zbr/K3bsNgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758580144; c=relaxed/simple;
	bh=bnoVvW7A4MZboCUWUp3uJoL/5QHRg63EHvbJEX0C48k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dw0H2BIgqgnc1h5J+/YcEB7TbmppKyY4FcwQlaReTjuKHm4z+/H4JLoTUfrprB8cUvMy1rd3xXRszCzUcOO7bx7vS8oJLIi/cVoRpXo9339zORp/NTXuUqRA1ZwN8Gvh+LKPWP/QkQG+x9wWNpGTXx+wjn7jzZb01K3ajUiMrPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IX5E30KV; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b555ed30c1cso376777a12.1
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 15:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758580141; x=1759184941; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BtoT7lETDiyBBBUdd6zpmqK1Q4j9ahP216sTNQ0nsxM=;
        b=IX5E30KVxgFPJ6p2dHUpUxJRlT0Z0s83563QpBj3WbExEofAH4EUzOd3Sa4/OvtHdI
         pz0DWgou/hhLEq0Y+bU/L4UEJ/8CWpNBYtOpE7Zx7MIm+7jScXnD8OqztbfRm3QMA/63
         +oxrnjL7NNyg/wXArhqBEgm61tsTA0dGcRDFCZC9bSB3BFjKISIcx12mhZmrpZkBMCWf
         IW/ZVCumH3zDLWz0kVZG9DjWmrOQSM0A4m5cFKzNF2Z3DzNOx8ydCWeNKfgdOrS76iAB
         YH87T9V1nLB2NVBQ0ORRQNcsAwnWaRPmGshhNrDMtRldhPUF91VQlOh/YYdLRASXc6hP
         O6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758580141; x=1759184941;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BtoT7lETDiyBBBUdd6zpmqK1Q4j9ahP216sTNQ0nsxM=;
        b=pXJXWCnZJ7TZ1OQL+Z2Jr4V3/IgNFJoODuE0rGl1W62scuWOBngZIKrs4bncjN44O7
         BIaJwxLmzgKjAamOfaBn8s980B0yUtJKLaIUVXOxcYiGJr9vqFNtY6BvO0QxGF3XKXl6
         iFDvm16cXmanHEGTZzorrcpbifuJ2Uz0ljzsHKhKndyYNnienNtoI9EokhKKkG42S4Ck
         oR3bqNalv9J0KCLP01IRD5OeBlcMTEec516pAk2OZfOV+k4nA6IU8FDk5jfSeYowk70X
         zRXtGegygAPN9E/FfJkN0a+/Gx47s03h27Oi2gsytIMPc3M4RYlyOcyH1eM36/oo5gax
         sF6g==
X-Forwarded-Encrypted: i=1; AJvYcCX+j2lbhFkaw54WSsLSZVZxXNCqUWBDLjhp1/B/ZQMOM8mTrzkUO4ZiPrbezXzmu0BsEi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyITOfAJ/bJT9q8BpGs0cjGT3X+a63XzN2kluHie0yZ5/vHOz8C
	siKgFKQg4JsdpJMXVK5kUdN3h2VBOpcyWXGmEX+ID9KHwcJwIUtvRk5H
X-Gm-Gg: ASbGnctR57TZdQ2wOd86vgO7ft0Ybozh7Kch+lvNpHlMb/RgMOALTze/vzaklivgfQk
	yv93pJ8UjMnH0cRh5gKDdvhutvrjKsMoub5G0LjvE9Ad+XDQwUoybDmdnBHef77XIFbgLIUZ7hb
	QtXWhJ2Ezulu+Gt4ss7GRxRsxkdDwi2xKQXLXgYOqkoq9ZtWMmD6wjTBhFAQKfyRU8QeTYL2HrK
	jAPvuyyjovvcqemkNz1w9VDR3uVhjuRs2CZbHqhmRO4FzXhhEGE5P5Q5nvCMLCZ4IhcgZNsBZXS
	vKJEsBK1lJ02KGT75tJ8IexB0R+LCiC/GC6DvAC//0H4ZogAI3M+JMLWC8AAEWP/rruntmSUFuD
	fc3sXkS2hvRXczunLO9l9N8hXyhluJA==
X-Google-Smtp-Source: AGHT+IEr9MnnfuaOnEgl5Ok6lmMqyEMDd1YwFlpFnduveoNyqRB+X6CgKFY+fvDTCnEk46JVsmmqkQ==
X-Received: by 2002:a17:90b:3a8c:b0:32d:f352:f764 with SMTP id 98e67ed59e1d1-332a9542d69mr564005a91.2.1758580141402;
        Mon, 22 Sep 2025 15:29:01 -0700 (PDT)
Received: from [192.168.0.150] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b551518480asm10765908a12.28.2025.09.22.15.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 15:29:00 -0700 (PDT)
Message-ID: <864b1042-9494-44da-b87e-d4cd8aa1ec11@gmail.com>
Date: Tue, 23 Sep 2025 05:28:57 +0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Fix hypercalls docs section number order
To: Sean Christopherson <seanjc@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux KVM <kvm@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Wanpeng Li <wanpengli@tencent.com>
References: <20250909003952.10314-1-bagasdotme@gmail.com>
 <aNEAtqQXyrXUPPLc@archie.me> <aNFYL2Os3rbfMbh6@google.com>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <aNFYL2Os3rbfMbh6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 21:07, Sean Christopherson wrote:
> On Mon, Sep 22, 2025, Bagas Sanjaya wrote:
>> On Tue, Sep 09, 2025 at 07:39:52AM +0700, Bagas Sanjaya wrote:
>>> Commit 4180bf1b655a79 ("KVM: X86: Implement "send IPI" hypercall")
>>> documents KVM_HC_SEND_IPI hypercall, yet its section number duplicates
>>> KVM_HC_CLOCK_PAIRING one (which both are 6th). Fix the numbering order
>>> so that the former should be 7th.
>>
>> Paolo, Sean, would you like to apply this patch on KVM tree or let Jon
>> handle it through docs-next?
> 
> I'll take it.

OK, thanks!

-- 
An old man doll... just what I always wanted! - Clara

