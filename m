Return-Path: <kvm+bounces-17830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E13808CA97B
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 09:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F1A01C20EEC
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 07:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5DC45674E;
	Tue, 21 May 2024 07:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="tRSIHZVI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5698055C33
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 07:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716278311; cv=none; b=a1FsCJbnQquRxK5rUqpsLvt7OdEeSTCde5f2khHL1jhgaHwbnP6c8Q4OjM8pDVHquaBUexN4YyCJpRXqD9IEOfz6N7Q7HOmQxTCkBg89TS3jVMJm2kzIMuv3XHupAxsccapEEThqlSr7Fg0MrW6mnKY8PwdpApDRlkvIa9WrHkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716278311; c=relaxed/simple;
	bh=YbW/ijAGccFQlQTqAfJm9lN3VLgscw+sw3OGEMReWk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JIHMETmBrAWXp1d98i5nuzJtBkrwq7PcxnhXSXLynwjwyeTP4lEX/a2J+MlYmidyEAiDfMKKaxzyJICr4Y1cXYEl5iQx6bsNCU98jtNV6wxNiApLGPFLM6xKP1Pik7EhnjkXT3S1M2jfZ34O7dbPEuGbCibqK58r1vJiNWQi4is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=tRSIHZVI; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-354c3a7f972so69459f8f.1
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 00:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1716278307; x=1716883107; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GBb6iShuxHaV7v6bJv2LipIX1/0KjJPEPWALv2DbLcM=;
        b=tRSIHZVIGlH4zuEM4xjxevPKjIjyEAC7TRQMEzuN/x7oZnnoRXErQdwagNObslHH9Q
         4o/O20kCD3/rOzIDpSRuQBNHLC6F0eKPsWpJ+j2bkiBL5mY5DtjNMGfrbxOWWUN9J2f9
         SiK0EvVLTRBDnq8+NF3PKD/iE9F0ztId7AlHJc/k8DbgtdSeAPcYAWvCBR+N4vQirYg9
         3bQ4Aj19SyPzZo9Rh5lhxH4VhCsCEpv9kCyh985X/wmyy4hXj/tpiBZyu0pQIJShKUQf
         D2bj4QGrUQzjNCBXlVGxfM7OHMnIIyfaUW9MNRMpvgFuDHLRDQ+eJTqTJAuMS0A2v+Mh
         /Jrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716278307; x=1716883107;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBb6iShuxHaV7v6bJv2LipIX1/0KjJPEPWALv2DbLcM=;
        b=SbLgZsGzQtRi1TN8Aq0uQ7DbdhuwMWZiLa8+cWPsrE3x+Euyt+17YUKMJ7bWsqBLtd
         uGsV/coLTQQh7xxJAuEsWPH0pf/GUWBO9XtmW4CTQ7KuAlKPTvS33a6j/9jcKbq2SeFP
         j4dxRN4EN1ZoUkwhbQ9RgypVGF8a9U+17E5WSTcYawuAm7tScqQ7l9kZ79SfnybYKJHg
         jFAi4oCFOaKjHpdzpQzjnal8gwT1Ho0qx/V5fHylkZ/6hqp3yCIqGPRJWT+KvE2MYYhk
         oRluNa6NWMVD/WLeuXb9e9MKOh0Hx7+HsCrV+fWJn7pvDP/WLSx/VTb18CmWIk9bSKb6
         IKAg==
X-Forwarded-Encrypted: i=1; AJvYcCXKj5ru2dqH92xgnwZ5NqfPYz61I/JDXydg+54iAqD2+kIwdmD2AB6dAIpAmmhLk6xr5pckQfA5tQGnXerbvwA7tLBn
X-Gm-Message-State: AOJu0YzJfx9Pa3RpjV+wvA53a7HvdmdYKOsBZCqPE1yPZqOsBc0ps1ta
	Ag9gU0+hT1e0GAUSKhozuhJNl7a/P0lU0vA/49FERxbQe3rjyF+fl+F+52TzIGU=
X-Google-Smtp-Source: AGHT+IHfRRdzTlFAebZ7wRlj20qZMeakja/n64TG1vwKypRDd/Ir6iJk3WrsYiVjjhgxZ9RFdOvn+A==
X-Received: by 2002:adf:eed1:0:b0:34d:7201:460a with SMTP id ffacd0b85a97d-3504a10f308mr21256806f8f.0.1716278307420;
        Tue, 21 May 2024 00:58:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:813a:5863:97f7:aca7? ([2a01:e0a:999:a3a0:813a:5863:97f7:aca7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502bbbbefdsm31017829f8f.94.2024.05.21.00.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 00:58:26 -0700 (PDT)
Message-ID: <6d2eb1ec-010d-4390-a25e-afd2fca0311d@rivosinc.com>
Date: Tue, 21 May 2024 09:58:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/16] riscv: add ISA extensions validation callback
To: Conor Dooley <conor@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
References: <20240517145302.971019-1-cleger@rivosinc.com>
 <20240517145302.971019-8-cleger@rivosinc.com>
 <20240517-scrunch-palace-2f83aa8cc3ce@spud>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20240517-scrunch-palace-2f83aa8cc3ce@spud>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 17/05/2024 18:44, Conor Dooley wrote:
> On Fri, May 17, 2024 at 04:52:47PM +0200, Clément Léger wrote:
>> Since a few extensions (Zicbom/Zicboz) already needs validation and
>> future ones will need it as well (Zc*) add a validate() callback to
>> struct riscv_isa_ext_data. This require to rework the way extensions are
>> parsed and split it in two phases. First phase is isa string or isa
>> extension list parsing and consists in enabling all the extensions in a
>> temporary bitmask (source isa) without any validation. The second step
>> "resolves" the final isa bitmap, handling potential missing dependencies.
>> The mechanism is quite simple and simply validate each extension
>> described in the source bitmap before enabling it in the resolved isa
>> bitmap. validate() callbacks can return either 0 for success,
>> -EPROBEDEFER if extension needs to be validated again at next loop. A
>> previous ISA bitmap is kept to avoid looping multiple times if an
>> extension dependencies are never satisfied until we reach a stable
>> state. In order to avoid any potential infinite looping, allow looping
>> a maximum of the number of extension we handle. Zicboz and Zicbom
>> extensions are modified to use this validation mechanism.
> 
> I wish we weren't doin' it at all, but since we have to, I think what
> you've got here is good.

Yup, this is what you got with a fast evolving architecture I guess ;)

> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> 
> Do you want me to send some patches for the F/V stuff we discussed
> previously?

Sure go ahead, I did not have anything written yet.

Thanks,

Clément

> 
> Cheers,
> Conor.

