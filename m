Return-Path: <kvm+bounces-18134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 377438CE6D9
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:18:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD506B22691
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6378112C495;
	Fri, 24 May 2024 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R3ncpc2z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB7439FF4;
	Fri, 24 May 2024 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560296; cv=none; b=LSoYR8Fj95H2BMbxszNACJI54tqOk4CHIC/D4uS9tOzKY/aT6RuyWUz52XVkdev9WvcJ6VwajDJvEkUqM03mb7j6+M0VjZcS9vFxBG1IEoLOWbCjU5EwQBt7vors1j83t5wB7Ca257ICRMIe74ql/svryylIjsjHo6iLBm7b9SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560296; c=relaxed/simple;
	bh=NY8YdGL7ms66sxZ2wcs4Q4KtZZk9+ISmVct2OPO9gnQ=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=hEU//DcskWy1RrqN2/tniTMmuEAdrfPGdOp/WXhVJlbp+0Txeu0tnsh9Gat12gdBjC+E+M0V5HExAHH/6RebD+/nKWaWqGnSUaiG5hesnD3kjZYT9pEKvxOg/WQGBQS8VRKJTpzQH6/YSbtgnuIDfgoD5AEak7TeA84MXwvwt/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R3ncpc2z; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42016c8db2aso31336895e9.0;
        Fri, 24 May 2024 07:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716560293; x=1717165093; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bOhN+K4MQEPHmraxcKoGfFFGKaOrlPJMqWUZiK5bPS8=;
        b=R3ncpc2zgsR3mxNkGFvXuemhjPVU5I97ajc8uQR4Dmj9GhYS+ek6YiSqHkBTD7jmIY
         Wl3G2UIzDMOZsPMQw5crIyGLSnbnl33a5oOEQwUcVL1uzO34CW5bzGCB/NaIaprq5c3R
         5C7d7b+qUkaUXc8JYnEkhP1x1kBgSx+dEisOF+7kdCpUnYL4KPTcfzSLaRp6ykZScNnW
         1SwIF7jzMljKcQp08zOeZNCx0qHTmOwm2xdINB82nhSRakXEjchpqXGPY7mkrhooeBsh
         uU6uU/zkwsdrL4XwosED6Ws9LW1Hqtg/CSD8lAPWdXc4A66XnHxw4QZAmr6btZIYNGd4
         Iegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716560293; x=1717165093;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOhN+K4MQEPHmraxcKoGfFFGKaOrlPJMqWUZiK5bPS8=;
        b=ap0tI8f7DPxjC7j+1Ct/XXixNaOYoTqs3Hu7yepWHDyQh60k6mBjkH7TMXv9EEuXnE
         /y5F9ppfExMUWLE7/r+1e8z/NxqG0I+FgVOuRtpuAC773IG4urJcvxsF6mPaSIWxtMgV
         YOBPpFL4/b8ZohEudy0G8FgCa5SiWhfQR5QA3iCioElCI+aIZ3kOKHdRbR0HPxJsbMNl
         tkssJkx/5kOg5+w6HXQKjqWrvTnp0gw3FGV5a7WHBT1ewz6xHMvWp9lXA+HfFmwRaUI4
         GLQ1VKN+ZqPSIJqiWrNCFk8XIKyrelWYyVWeYnSI5O/9SThPT4gJ/clEiwj8hMtqv7iS
         Cizw==
X-Forwarded-Encrypted: i=1; AJvYcCUxClvNN+jL4tE/8Z8GoEDEmDlrmvVMZEy6Au0JIOUy2vA4QW8u4HiicRma5v9TjgYRdW2Xub/nQ7Ctd0KnAS0wHul3AOmdyTQFyopjCKeEOYXl4XrQtJZagR+L89iChbgor9zB3SXdrQt79db5t71P6vkN2M6jiW8wFRrZ
X-Gm-Message-State: AOJu0YzCumaz3ETImTlSbKjWch2RMj+Ha7TTymdtR1063dm1MlGjbq8W
	KbajXNgW9h/pQ6O5LXq86SV4HBVWhWsWp2qauD4xB7CLDxYkTyu3
X-Google-Smtp-Source: AGHT+IENmGtjYoWphFB7uTohfBjfa6/lyQohW/GvX3LNtGQLqfFkv/9Y5j5qgcHoHjhWIAOiaJXDDQ==
X-Received: by 2002:a7b:cc97:0:b0:420:66e:f5c with SMTP id 5b1f17b1804b1-421089f874bmr17983875e9.14.1716560293301;
        Fri, 24 May 2024 07:18:13 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421088f9d3csm22238855e9.0.2024.05.24.07.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:18:12 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <b1b02044-761b-48e3-b58f-b9c31b64ccfa@xen.org>
Date: Fri, 24 May 2024 15:18:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 19/21] KVM: x86: Avoid periodic KVM clock updates
 in master clock mode
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira
 <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, jalliste@amazon.co.uk, sveith@amazon.de,
 zide.chen@intel.com, Dongli Zhang <dongli.zhang@oracle.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240522001817.619072-1-dwmw2@infradead.org>
 <20240522001817.619072-20-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-20-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When the KVM clock is in master clock mode, updating the KVM clock is
> pointless. Let the periodic work 'expire', and start it running again
> from kvm_end_pvclock_update() if the master clock mode is ever turned
> off again.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/x86.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


