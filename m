Return-Path: <kvm+bounces-18117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5690E8CE5D3
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AC2A1F21F1A
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D18886AFB;
	Fri, 24 May 2024 13:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ItkAGTu7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46FBEC7;
	Fri, 24 May 2024 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716556489; cv=none; b=ilBvpdb34jMfAh5uwK+jTECC4rAaXP4+fMRvKMPmOPrlIFcXCBsnwMU94UgrbsozJLEXjGah21qL9OdGdwlrVCcqUpXG0kWRZgRjHAKwmgCjqleEJ2ml0LIdp6qS7jeoH+5F+MslYQYzXEdR2cVAW35ZEs8fxQMywlHrxy2DYx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716556489; c=relaxed/simple;
	bh=1bWP5BSJi3sN2bmMu9/wD3/5H4olW17rkTqaCPmms5E=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=mwHXp/JZ0nnlSYc6xDCd8XCY9eYJQuY46XZasG0qP3blMXR1ENFir6zuW0q2Yfb41D9EsN03FFiIGpnIX0+3q+PXe3iglLIx5j7G45sVtJHnuKBvjiaBFBx59gdioh6Lw10pajabxPnhW5C/rHDMOvQpG5UZSv9jJ1EXYf7HLCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ItkAGTu7; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2e538a264f7so100598931fa.0;
        Fri, 24 May 2024 06:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716556486; x=1717161286; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7CkrZDg9KiBlwYWcFd0hqqNHkLmgaD6TL+n9418lL9A=;
        b=ItkAGTu7J2M4Mkd/U4YRTNkE5ebsZ6t9y7dBZ9XOWOmfOrSDJFZNVM8g78aSRN6bli
         3tWC0IJc7fmk6Jhe/8BIc28KnIgvMXHAnAeyQE+GAYlV5fsFowrSwJRTnTYaGngMFvg0
         hURdpZYv2GIckc1VbNjbAameDeFWCRAvUF1g73ELBnKK2NPUJxuIGmtcGTJGOGPubntK
         oqQfc/tA7G+hPN5IZXpR38ii3Z0R+vSzn3oGMff4XFJQ4TjbEWEnQm6OV9nkqFMIw9Tj
         NqW5KrZBwLCIMwxXkCtb4DLnuZd/xK1EPfu4HZ/rXvnGVXdS9bHr28Qipy/pX9Df/2BZ
         qBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716556486; x=1717161286;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7CkrZDg9KiBlwYWcFd0hqqNHkLmgaD6TL+n9418lL9A=;
        b=Pr1nP6jrTh/Uof6mTNzQrDKFTBa1DSp8aBaFCN3YfzT5L9zw0v+oS9S42dXG1STZmx
         z2TaLdWjPq2hMgquaeJOL7OgpISa8McJxoiw/xoLM8tdRg4UvYvnXFo+1CSw+qeBSfPm
         YmqydrEMIllGmDCH3cmFpkMaIvjZYTE8zj7VBP8f9qzitj0A1fIcEijVSYNnKjN5L+vy
         yJvjbZmyn72KUGbkZ/D2ig2EJJcMH4dKOC67AYXXvB8yAEo2v66Fe6x570oHwM7q/5I9
         sy2QO85O9tRmx3k1HdXa379gxnBJJkICOIoGN9icKVSIXXhiPt3QTcs18BiglAIyN+Hw
         yajw==
X-Forwarded-Encrypted: i=1; AJvYcCUFpum8fogXkDQZEczGUzJ6Jh3PdoMxWHcCtqCax9My5sR52HhGJBCyry4DbwgtNu1rfeLJScGWSe3+kUW7ld1mqYnKJ0Lp1Lkr1PaY7ZPB8lgSqXEyfkTl17ADgUQe5cpq3gO398yvpouxHVvHf90yQtFutjSq0EdpmV8o
X-Gm-Message-State: AOJu0Yybgz4pNR/igpjw6wPbepX6yJiu0/2+T0VktEYssFh7pONaQxK9
	wkgag8/uB3R+CRMZNdlxSaVv6r/KR5/4XLpKkMgJvjla7DUiD43l
X-Google-Smtp-Source: AGHT+IEpjir0nWSdDBLjVdgdmmdQivMBwqoIVBY7XITjEqSx/dWcLWlJT1Vb+Olee+Vra2Ej5aW8dA==
X-Received: by 2002:a2e:9646:0:b0:2e1:bdfd:ce70 with SMTP id 38308e7fff4ca-2e95b096f1fmr12952091fa.6.1716556485714;
        Fri, 24 May 2024 06:14:45 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100fb8f56sm53281045e9.40.2024.05.24.06.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 06:14:45 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <fda6e53f-da08-4899-81e1-8e90d44a7ead@xen.org>
Date: Fri, 24 May 2024 14:14:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 04/21] UAPI: x86: Move pvclock-abi to UAPI for x86
 platforms
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
 <20240522001817.619072-5-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-5-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:16, David Woodhouse wrote:
> From: Jack Allister <jalliste@amazon.com>
> 
> KVM provides a new interface for performing a fixup/correction of the KVM
> clock against the reference TSC. The KVM_[GS]ET_CLOCK_GUEST API requires a
> pvclock_vcpu_time_info, as such the caller must know about this definition.
> 
> Move the definition to the UAPI folder so that it is exported to usermode
> and also change the type definitions to use the standard for UAPI exports.
> 
> Signed-off-by: Jack Allister <jalliste@amazon.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/include/{ => uapi}/asm/pvclock-abi.h | 24 +++++++++----------
>   1 file changed, 12 insertions(+), 12 deletions(-)
>   rename arch/x86/include/{ => uapi}/asm/pvclock-abi.h (83%)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


