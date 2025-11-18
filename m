Return-Path: <kvm+bounces-63539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2391C6938C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 12:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 943162AE1A
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 11:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13FB134F473;
	Tue, 18 Nov 2025 11:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="aPOk51sz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A4C31984C
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 11:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763466978; cv=none; b=IQsiWIQwDxv2kc4IXCfN7yaHAexBbZQTP/jhC5SnzGgDStYZVCp8qXTBracLt1wGSPzKay9WmP/F6DccPBPfzRhVGwrfPn/Y9Sgu73RAnzEDXlDalVbQ+Wq3v3wHp02Wa8iRF1Ia+3ewedu/kNr/vXwHU711p0cqifQCBHMiOsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763466978; c=relaxed/simple;
	bh=qzcZIddEA1VxDvQb9GkLctVL+UH7omrMWlZmQBeGfaY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PSpSTz4rgcO7bztwzrtjfRBEeh0NRAIzPT7oWuyws/MAAkEJCJ+YCM7Nwz/B+fIUHhEJmmFoh0UdZ8YHYWIl2HPzIVU12tXhbms9OLJogkJECO63rz96yxGjM7rrAy+h70w8RoHBw0xsxORWQKP3+TvWvLHqBrufv3msHo0ZWXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=aPOk51sz; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-882475d8851so56942806d6.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763466975; x=1764071775; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LQRr7ykcKRuQ2H+DZ+tTFQTOL6/+JF18/rTcAWF2fUE=;
        b=aPOk51sz/5TVpo/mFiQK6pV/McQdpo+m7xClDObo29Bu2cjkd9V7GQ5MSrZ3+gLQyV
         /g8oX8UkyRosLkR32Qjtvs+PDuPvTvMeaveGmG8nu6BV5VY8U6DJaF9wIYML4MhgJ1hc
         BVFFBH2zjZH7DzbS21E9yjn05yZfDS23M245xXDqbkwQPToWq2sPqBGurKd80JH0Rxon
         2a5JHG6o/za7/AXxm+fY3SdPl8p2kVESfIdJAotR7x/V40yGdfTvNKkMZbOfVzZUp9ps
         JHOlVAkW2Vb5nl/CeNgJKNAy6xLn+F7eepxTCcD+cR0aDfyiM/w5hN9HCjhmiV4SEpzV
         k0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763466975; x=1764071775;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQRr7ykcKRuQ2H+DZ+tTFQTOL6/+JF18/rTcAWF2fUE=;
        b=BGYzaxNuax7qfvFK53/cbdTUs0ro3eZos2z/sLPY8GKZK0w3uMQ7qtvK8rzmvcgQuh
         /kw7uns2HlgzKh1YsRcL5OO5vGlSTcJBeoYWv8HoweFSewJ4I8P3fiAIgu3UtYkCbFiD
         2U9HJM2V+8k16INhFMlaj26d3qH0Yl8Fd0umTTfEDaQeZaoDXjSRUxXC2tpWB73MzWZ7
         a5nDornNiCK9Zy9RqkS/teOfER7s6tbx/66DydvbS6VzOt4z5IIQUIBc6XnrCfVHPdZK
         9VmIArAD2gS9RbB3i7Ua3W2zxcPbkBRiZjM2Z3lQSNoVZioM8Xvgic5wqZ3cJgjT2FEI
         9reg==
X-Gm-Message-State: AOJu0YwcAZN0Mf8m1vMZB19vJODR/k1bX2RQZY5vFdGSTUwx3JmdOgya
	bxbx/1sf/vTL9I6LhoMfpbdifyR4HXxwpLrkJXKze/tu+/1bxK3dHPoi1AMaDhF2EYw=
X-Gm-Gg: ASbGncsSOE68n3Xt+mzSxw0PGa0kiHmPd6BnFL4zSLrpkuK0vz4kG6x0VCpzeEUxN8I
	7niDzKDuHywaXfZ4zR2k80Nu/1JbFPCdJtPTdim149PykCO5XnFNxdF564+GBLDlRVpBUNbLB5V
	BDtcRi1KWfMZMPyxVEtpEeNMabGSyv0+cLXUHJ1BrBphAlYuRpkc+8vGyiFVNeGCzJdhdLV5s67
	gEiKCdyCSfabnNPDb9AHjN65mdBFdW3QaS+zQ2SpdEKAgZ1F9gUcDpCDH27eXTWpYJj5bpS/JG1
	g1dQnBRrlqA52OLHsQaHE0K3TU0bfKGSsf0eNs4h2oHwbfVdsx+9V5ff5Dp6jYv4BtcNNmeBvXO
	9slUvXgQW7pDZ9EJnFLHvPGL4a/+78GEWHFCXo6KvHoK8khfNz7wrGdwRMSEuu+ZPogaCMVpkL7
	qgwOl8adL6dFaAYxpsHRcfySYaDlecL3srCRJhTQCfulgReRx2iguT2nHhbFcDn36sX3LQ5JEuy
	DwfElrRdylAb+bmPR9d+CWBsgIsG5NrXsMQAjO4dKc8Udc1/lvr+qPPLL6odnUHBaQ=
X-Google-Smtp-Source: AGHT+IGAMniWDVOnPyf6j8g6qorhYih+6sXf8RQPPiUffUe4eSaS7J46wfc1A0WuZcSwDnIsjBg/EA==
X-Received: by 2002:a05:6214:21c5:b0:880:1fb9:a30a with SMTP id 6a1803df08f44-882925ed0c1mr237008176d6.3.1763466975446;
        Tue, 18 Nov 2025 03:56:15 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-882862cf6d5sm112908506d6.11.2025.11.18.03.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 03:56:15 -0800 (PST)
Message-ID: <8a42b563-71b7-4bab-9f1d-248c81295704@grsecurity.net>
Date: Tue, 18 Nov 2025 12:56:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <d67ede24-0b75-4bdb-bdc9-272b9608f632@grsecurity.net>
Content-Language: en-US, de-DE
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <d67ede24-0b75-4bdb-bdc9-272b9608f632@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18.11.25 05:04, Mathias Krause wrote:
> On 18.11.25 02:47, Mathias Krause wrote:
>> On 18.11.25 02:33, Mathias Krause wrote:
>>> On 17.11.25 23:19, Sean Christopherson wrote:
>>>> Spoke too soon :-(
>>>>
>>>> The x86 change breaks the realmode test.  I didn't try hard to debug, as that
>>>> test is brittle, e.g. see https://lore.kernel.org/all/20240604143507.1041901-1-pbonzini@redhat.com.
>>
>> Bleh, I just noticed, f01ea38a385a ("x86: Better backtraces for leaf
>> functions") broke vmx_sipi_signal_test too :(
>>
>> Looking into it!
> 
> Can't see it. The issue is, the call to hypercall(1) does return in
> x86/vmx.c:guest_entry() with f01ea38a385a applied but not w/o it. But
> that makes no sense to me whatsoever. :/

After some sleep it makes lot more sense. Well, not really, but it's a
race that f01ea38a385a, apparently, makes easier to hit.

> 
> Below debug diff shows the issue:
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index c803eaa67ac6..e49668f5ff95 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -806,4 +806,5 @@ asm(
>         "       mov $1, %edi\n\t"
>         "       call hypercall\n\t"
> +       "       ud2"
>  );
That hypercall call shouldn't return, as it's HYPERCALL_VMEXIT which
makes vmx_run() return and not re-enter the guest. But, apparently, it
does so and it does so because the guest/VMM shared variable
'hypercall_field' to communicate to the VMM what to do can also be
modified concurrently by the other CPU/guest #2 after it was written by
CPU/guest #1 but before read by the VMM. Bummer!

I'll send a fix in a few.

Thanks,
Mathias

