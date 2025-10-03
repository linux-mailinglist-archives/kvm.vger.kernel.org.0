Return-Path: <kvm+bounces-59472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D827BB81F0
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 22:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B3416348285
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 20:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C9C2459C6;
	Fri,  3 Oct 2025 20:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rJtTLg5s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176A323DEB6
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 20:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759524124; cv=none; b=Zt2Mw0dmqLWzb9Bs7eELGV5aXWeM/mIL7BwYLcV8hi8rcvvqoEgEVOOvfPMCQKHT3oOkum3BMoDdpn/m8P8sGLtuoN38Im/eVq283DBJI/em1l1efvpT8raAbesf4Zo6/wO+h9YBBl0gQV06Punl6EhobZahbJf2CSVHG2beKbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759524124; c=relaxed/simple;
	bh=gTNbgu7xQfrbQBba9WrkFqyMqct4IZYtd82T1wj6w+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SiP2wkXPSraRqZVQjX3VA4YzJ4DbUeQ1le46YiuA4N4kgCz8VbvVQFJw6ELZVeOiWOxT1J/Gih0hPzWIwP3Zox7d9dSBMZvdoP7VriO9ufPIn9FpfvuDK52L/O6JUkXuyA+j9Xruzx9u78Z5Bj40s30xqCf9PAfRL7LszVzt+54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rJtTLg5s; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e2c3b6d4cso21712095e9.3
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 13:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759524121; x=1760128921; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PW5k2zL3fmegA2ZxrF2uAnfp4SXP4L2O5lee8nx3mSc=;
        b=rJtTLg5sWf9E8Q2DnnTgFnyoK6wVsVqW5uMRHZd5nsgVSIwwQumEfeHZ3dQIVcy2T2
         0ltu3xND/4eRtW0Kx6QJ9T4f1A0jxS0HAtQIA9SaYyL26/z3+AqYn0CdCtygs3E9yoTC
         hsfwrNFBe3uJqusF53sIbRy5XD8x4FzPvAgylDYy6Rq5WB2GQYjaNzOwuQKgMRmxRhbQ
         Qi8nrtv39pnI+srqBF5XZNoyV8R3mLDg0FtM9HZ9vTaeigG6T5koAwgiq3kd+x0hPTgi
         1WCS/Py/GQYwKG4QAPkat5uH6CfnlZqKwdNtco2Ot1ujM0oaenLu/r05ak4m3G2pb0v7
         qFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759524121; x=1760128921;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PW5k2zL3fmegA2ZxrF2uAnfp4SXP4L2O5lee8nx3mSc=;
        b=eejxeGWMaDNfb1uOi8vlECAQpDv3X1cpmKVZNlbEg0oD9Mawdeu6AIG1s9zlFGfVqR
         WTBbDkZTRev0z9kFLWlXZu3sF0Aqt/aO0FiyyPIeO1IRchWSICN20rEBguI7YuwhR3oV
         3BObPzUnFzGk/kHT8H0NyLibnyuHLk1U6gkbfz2lLX4EHFfImfGxUqJiMkVMT4pKLmac
         dOfMFvbdETgi1UrvJ56SDaRJkwmF6Qj0a2+CO9d6ObK8wGdplRZxXOuSy4nhevl9O9IN
         If9mlCiykhvt8gVrp0BgPM+2e3ldA3Bqo7xN6KA6AfD1lj329OFH1DshP4y+WKJabbDH
         NjGg==
X-Forwarded-Encrypted: i=1; AJvYcCVWA/P5+4IUuSH2yE4eES6Y+cnphZGG+ww9AVrDzmTwR/fojCVd82aOvWek3oWnuwjE7TY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBEhgZNRReWckl3RNW+YfBKQ9F3bJBE3XzU6Di41su6OM/EqnY
	fJbTglLOTy4wuEbaEhUs6IjMYhH55x5s4yxZD4DTnoqeXfNW5Ews2EiGps5fikbSORY=
X-Gm-Gg: ASbGncvk5vq0BHyyASx2vMBlNPmXDR6+OlaOgNi/lWxymC4pTYkDD+aFwJ0aLqJt173
	0W6RxfrxI9eOXin8zt282lgcSSZvqpoK4CMc1IrG12Oj/ly2we4VIVdBXdT7uNCaB+Ns+0vZbjx
	EPSlUBcj07QcbJ555wOKxCWo2+aeQPH0R6/YMy2t/DfkiATcAwqsYOepM9Lr17GYAuG5V9w3Kbx
	KNpX7SGfBB2nXoW2OoxSzdWtpyyopCYm7gSh9ShvYSP4JOccAhgOW8FZIUi4ACJTmFiDABD6WJd
	uaUes4STWww6SZDjVvRDvG4VCtpGYOYJM7tDwAtm9hg9EJnb6281iPL6cWZbb+A/oZK+0lfj6PP
	LE+/fIPcd7vwIxh6YtD7RqDmSFpv+FOO1Vq5gS7FJXDVLlwWmEhpgOidgqL/oW7fxuQdV4o4LnZ
	rSMuu4DAKKWJaEuqyI/MG9gdOHSxSTf2al3jAluYI=
X-Google-Smtp-Source: AGHT+IHHpUVAOz/kW4FY5inemqoIDxzaObgtHSvRK94Nk1VfVB9QmYTxm3ZfXZPywnWOkC76eMfSUA==
X-Received: by 2002:a05:6000:3111:b0:402:7afc:1cf5 with SMTP id ffacd0b85a97d-4256719e6cemr2721575f8f.35.1759524121296;
        Fri, 03 Oct 2025 13:42:01 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a25dbcsm155655605e9.19.2025.10.03.13.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 13:42:00 -0700 (PDT)
Message-ID: <c80928c3-0a54-4cdc-858f-b2ac4670e38d@linaro.org>
Date: Fri, 3 Oct 2025 22:42:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/17] system/physmem: Remove cpu_physical_memory
 _is_io() and _rw()
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org, kvm@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20251002084203.63899-1-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/10/25 10:41, Philippe Mathieu-Daudé wrote:

> Philippe Mathieu-Daudé (17):
>    docs/devel/loads-stores: Stop mentioning
>      cpu_physical_memory_write_rom()
>    system/memory: Factor address_space_is_io() out
>    target/i386/arch_memory_mapping: Use address_space_memory_is_io()
>    hw/s390x/sclp: Use address_space_memory_is_io() in sclp_service_call()
>    system/physmem: Remove cpu_physical_memory_is_io()
>    system/physmem: Pass address space argument to
>      cpu_flush_icache_range()
>    hw/s390x/sclp: Replace [cpu_physical_memory -> address_space]_r/w()
>    target/s390x/mmu: Replace [cpu_physical_memory -> address_space]_rw()
>    target/i386/whpx: Replace legacy cpu_physical_memory_rw() call
>    target/i386/kvm: Replace legacy cpu_physical_memory_rw() call
>    target/i386/nvmm: Inline cpu_physical_memory_rw() in nvmm_mem_callback
>    hw/xen/hvm: Inline cpu_physical_memory_rw() in rw_phys_req_item()
>    system/physmem: Un-inline cpu_physical_memory_read/write()
>    system/physmem: Avoid cpu_physical_memory_rw when is_write is constant
>    system/physmem: Remove legacy cpu_physical_memory_rw()
>    hw/virtio/vhost: Replace legacy cpu_physical_memory_*map() calls
>    hw/virtio/virtio: Replace legacy cpu_physical_memory_map() call

Series queued, thanks.

