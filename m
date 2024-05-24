Return-Path: <kvm+bounces-18131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BFF88CE6BD
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4785D2811AB
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34EF612C488;
	Fri, 24 May 2024 14:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZNTN49S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF09385933;
	Fri, 24 May 2024 14:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716559989; cv=none; b=Mn0Ty2DH2GzGId6CbCJan34PsYh8UjqDKGHWexbna4zwnKMUwg7PskAXU3joWYcdSwHOARTPfy/U/1JDexbQihol/xcY+dDSjt4MB29zYymvWMyjl07n5CvqeT87w14GtgyT4E9zFCXR+jZFTKHGnojctJqXjFPgWVmNdLmvGvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716559989; c=relaxed/simple;
	bh=YxlpxnAvu/dOAFR4HiHkvmKzMo8zhWdu8PHes8ZOYBE=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=g5C0y1761ATQ9zKGuDHpqg2LK27/94mf8SOYMl/6BsZgSteMMVLPDtBzRahLtxOnEHHogtoi/88iWB/JTLG0sTauRK9Tv+U1e7eI2Ogw7zd+vbC++fdc7zM4OZZ+Onq0mkY8bhPpF4bd7bCGNni4Ec0Ntlq4Hi8J9TWF+ScQD/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kZNTN49S; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-351d309bbecso6137934f8f.2;
        Fri, 24 May 2024 07:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716559986; x=1717164786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LIXRmETsPlPipZyoH/zKNgJDW/uAVRzPgiJ3jVW/v6w=;
        b=kZNTN49SzksxwanMzbirTJAHmotgdeEut93X4C7pEJBjUFSm5J7E8XHyv6k5H+gjQj
         TjPmXrpD9yP025UfFebZZ2ZzxHu826+cNVruTNi+ZvK9wbtqSXkhSGht/5BnR7MWFdAJ
         1Lm2dzdyRN2JrQgVekogsh/nDT9Fgv02pKGTLSHwt6+q4EbiIRwNnQeGKHKfOCeEfvth
         G+hD+VTGrd5C4CBWuU9oC9NyMMW8p7E/HudHEFw8Er6y4SvK+TDIX3AOKpbE4mQIvnHu
         kVDHHNBdZVo/ZUFN61aex6q/sKIFU6XdTGBpe9ylYkGos2o8ykmbpwSgOpwtiEN/+guY
         8WSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716559986; x=1717164786;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIXRmETsPlPipZyoH/zKNgJDW/uAVRzPgiJ3jVW/v6w=;
        b=Td3QNObuuRUsS5XnxA+AtzAIohqczkT30Bf6xtz2fSVEBK5G3kT13iScYrCor3hf4E
         ZU0mJ5Scw6J9d27Hh1fA+V6Fgjnxv++TCkCI8RJW815iiwSNWhJ+lpvlMFvkGJY5thuC
         YF3KJwDSj+fbUgBNOUWuYTcHg/Ta0QhFX3QhDFX1V+pDc+X3K7o4fc3iqyF6Yniodh5k
         0u7juikTQkG9FA0aYZi+/CxecQMY7TqqovWahfytbanFyBkDEMNZut0UKCQ+j+dU7QvT
         chKDx3rmqRWx9e1cA4bI0CNZsv3E8VU0+p2u4dlcCy5ROmXnucumwxjxkCPq3ozKvhBX
         w+Tg==
X-Forwarded-Encrypted: i=1; AJvYcCUEvKJUAh8lj3rqIgApM+FZCJYtKjrHl6FN+v8UTbHSJj2GhnohSbEdEm0tmMku4MSWIgILIA+Ip2VpTinDcANI0vt0p+S5o5Q6/TFx8K7bSwGWK5Eb/lQ3gO5Z7QN1pRgY0yI+pEUSisX5elJnEUhFArT+4bIAdex/Q4KN
X-Gm-Message-State: AOJu0YxOck33OljQcEt96cQ/Ow0o8x4LUJE9GreXKkEpTvV1w9rWBFSF
	Ozeetv3LjW0lpfDxZmUPZ44a6PkerAS29DN4crdGfVho83AI+bMr
X-Google-Smtp-Source: AGHT+IFpZvhYYO5p+X8RvnaHaktMtmd6wJtUb7B3pM5HVUaET70KBsAXDd1FRaAUGWaRlo3Sk/st9w==
X-Received: by 2002:adf:fe91:0:b0:355:2cc:2f3a with SMTP id ffacd0b85a97d-3552f4fd766mr1876855f8f.18.1716559986127;
        Fri, 24 May 2024 07:13:06 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3557a08ab76sm1698469f8f.34.2024.05.24.07.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:13:05 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <2b4c8233-9168-4e92-88fc-9dee0afec48c@xen.org>
Date: Fri, 24 May 2024 15:13:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 16/21] KVM: x86: Factor out kvm_use_master_clock()
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
 <20240522001817.619072-17-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-17-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Both kvm_track_tsc_matching() and pvclock_update_vm_gtod_copy() make a
> decision about whether the KVM clock should be in master clock mode.
> 
> They use *different* criteria for the decision though. This isn't really
> a problem; it only has the potential to cause unnecessary invocations of
> KVM_REQ_MASTERCLOCK_UPDATE if the masterclock was disabled due to TSC
> going backwards, or the guest using the old MSR. But it isn't pretty.
> 
> Factor the decision out to a single function. And document the historical
> reason why it's disabled for guests that use the old MSR_KVM_SYSTEM_TIME.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++----
>   1 file changed, 23 insertions(+), 4 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


