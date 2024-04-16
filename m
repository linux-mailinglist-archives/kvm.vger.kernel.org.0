Return-Path: <kvm+bounces-14731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C1038A6568
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17A7F1F22E9C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 07:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF9D84D3E;
	Tue, 16 Apr 2024 07:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ChhlrCLW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B36F386
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 07:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713253672; cv=none; b=rtr90xCi7NUeBTHNDuNuNC17pCDTFmqPv9omkEhYXvqryjTGfAb4Pdr5PoHsZwxj+hkFtSsYRNS4U2Pw58Htx6o1AnCWtAuhQYRSDgdBxpD+j2TQowxgULzICPGLu72B6QJAWmydnmukp5a5Sa3G7crhjzF9he2xWh+pVgUjvUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713253672; c=relaxed/simple;
	bh=V5lasIlS67SnEE7ZPDne4U5js1S5I42RAux0QHJL8FA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZhtwULkgdGMlDACr2TQ4bOMnyt36ktUZMUpNG61PbGWK8WP2bRwx79UBjhh2JO8bqBYjvLPl8HVq5P1POip8ImZUnulB18A9kOLyMs7v7c3xwXDfEovVzfUeCt8MsfezmIS1T//+29vT8oHeyVqEKgjNK4l4LeKfF/1NnnUTUBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ChhlrCLW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713253669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+ua83BZdc5k0K/1LGqgW/mLhHYV5FbFxuQ3/oCEZ8HY=;
	b=ChhlrCLW8Jf4qwR/X3jNlTD/Yu8NBRUYd2Yz6KwcLXI5IWM/oSiGIYKmMcW1PS5Y6vnLFX
	4higlST0jAfuc13XhiLhTsH4thrOKwQ53HynFnQDgLMW2LICPgluEXAx4vKINKwKWhFlr7
	ECtom8vegPvR/09vy6RFXZfMfLlgAcg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-Z4xv6ZPSPuKS1qVrT1CB1Q-1; Tue, 16 Apr 2024 03:47:48 -0400
X-MC-Unique: Z4xv6ZPSPuKS1qVrT1CB1Q-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-518f6868850so1607744e87.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 00:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713253666; x=1713858466;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ua83BZdc5k0K/1LGqgW/mLhHYV5FbFxuQ3/oCEZ8HY=;
        b=wGSZBv02TcJ/syHgHdOcC1QpOo/ccS6LYcGvxYWsZTLub2Pg7FEO1v/Q5sm/bOnJTI
         ZO39GCbjo4gmaxs1I+g/jro0abw95DlWV8BEcIPv5iq0z4SGFlEOsysO9FFXlrOd0ZgA
         8MGkIgIulO0GvP/MLGdr03RjUAkoX1mk3MyyBa3a6csMF7u5IhPvCfCUpw4BncUEoWPT
         mJZ0WDJrKwqUixTts3l9fRAy76RwkZ4/0tV+PjaK2hKi8n92ivC4cUsbPgH+D+1RvUBE
         sW6SngYajB3agTb2VbMvl114Gr65rSz8nIEFT9DQ/3MyfWNHA/rkUO4J0yZgxvpNN0x0
         WM5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUBgVwaS55PoXcQ6eOhgvSSDFWjDqcHXlDvsKkcvJNGQU5Mge4G3DdRuwWxH+XiAcQTwfhYvtN7yAdaukRTc0Zvsvqf
X-Gm-Message-State: AOJu0YwfTWJjYN9h7MXKdCZCMgBP+P2mB3+JMp5d/JC9GEGg/ceQWEz3
	r+l+Gk/FTfAXWHEsQau3sFUM7A5s8cGDpNA6pfbU7PPcHuAJPN3ny+7TjbdEpX83EZHcX4CAoBx
	tAVT8wEUTAOZZI5PBW6HpVVLOyBjVJ+398iiErTOJM1hYbgJXyA==
X-Received: by 2002:ac2:4c39:0:b0:518:a518:be22 with SMTP id u25-20020ac24c39000000b00518a518be22mr5043906lfq.55.1713253666814;
        Tue, 16 Apr 2024 00:47:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBI4YhGrRTrXRG+BQ7/DzU9JtvaiDYupjsqe88ZfKKQXB9zmPX9FMji5+O7gP+5wnvbzQxYg==
X-Received: by 2002:ac2:4c39:0:b0:518:a518:be22 with SMTP id u25-20020ac24c39000000b00518a518be22mr5043893lfq.55.1713253666463;
        Tue, 16 Apr 2024 00:47:46 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-50.web.vodafone.de. [109.43.179.50])
        by smtp.gmail.com with ESMTPSA id q26-20020a056402041a00b0056e78224d82sm5717431edv.81.2024.04.16.00.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 00:47:46 -0700 (PDT)
Message-ID: <e4bf3383-6f8c-4378-a19c-b022224e3f45@redhat.com>
Date: Tue, 16 Apr 2024 09:47:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v8 10/35] powerpc: interrupt stack
 backtracing
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-11-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240405083539.374995-11-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/04/2024 10.35, Nicholas Piggin wrote:
> Add support for backtracing across interrupt stacks, and add
> interrupt frame backtrace for unhandled interrupts.
> 
> This requires a back-chain created from initial interrupt stack
> frame to the r1 value of the interrupted context. A label is
> added at the return location of the exception handler call, so
> the unwinder can recognize the initial interrupt frame.
> 
> The additional cstart entry-frame is no longer required because
> the unwinder now looks for frame == 0 as well as address == 0.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---

Acked-by: Thomas Huth <thuth@redhat.com>


