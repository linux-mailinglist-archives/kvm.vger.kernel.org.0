Return-Path: <kvm+bounces-18126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 209FC8CE677
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0882282056
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA3B12C471;
	Fri, 24 May 2024 13:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnv85tLf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB46786120;
	Fri, 24 May 2024 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716559019; cv=none; b=MQJ0cUAdgvoeCosu1NNfYuzwLOHXX9t8pli1Ad3hx2x273T8Hj9gCKQDhfNBk0XEIajAKchxS2tQTkUcWkdXi563j9kGjmwB12a/sdazEc13srJ2+Gk64gO2ulj48gsrHDgN16ct555iEiJR8V312GMoonx46/YywaYbBCKE0vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716559019; c=relaxed/simple;
	bh=TbI1b1nQhIM/TWlonzYbHmL/h2K+W+tquMtOW1q6Oto=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=BkW5+4RcdIIKfCLp/bFgbtR4vt0z0ePpA0NM5b//RtHWvSky7xH7y6+Tk4ZVCgqhTzUIFYONcUwR9OfhteLljbyYBGH2dF2Gougrewc/lMRLqiAbr/9itotpxF+F6UtK0btNi2N5aOWxCQEg1l7a+NqfpfSIXvc+PRe+Al6wvig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fnv85tLf; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2e538a264f7so101204591fa.0;
        Fri, 24 May 2024 06:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716559016; x=1717163816; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DnGCZeDgq06e4yJxv3zYBUOrTNbIwkOVZezg5gdIpJc=;
        b=fnv85tLf9xERd7u1q6vWGyNstsJNAk/7uSIn0M+OBE2WXJizTBzl30vq06zZan7qQT
         b5aeWNeRRzLfPCX7x0e9h/03AdIOR/k+qqdDN9RFw8rXAuiVeTFy9alegIduBNvEDy9v
         6RpQKqMAVHSnuDvZB72eNjb6tlnss+ag/17rD6zHTucOkkirEGtYupw6gdH/NopCa8sR
         JHsiUWRPLT0mQu4QQxt0Z0pyn5Vz8bjLzP4RCZ2y1Q2iDsqcd79WJSU5vY7T5EhwWuYs
         LMS4ZhmTvenNP7j9hZIdVjnwa5npSJ+KJ6+zwlJzI1dNfKPXCnBjkC1HMlD43AXJA5ei
         x3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716559016; x=1717163816;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnGCZeDgq06e4yJxv3zYBUOrTNbIwkOVZezg5gdIpJc=;
        b=OM8eIpSeZqucTMMOtW9BTlthLu3fb4foAU3uUGpM1ZQ7XgauCWbITIfM6tb7L4rV9G
         3c5Us51WQOj8dy1v1oQeXYMkOCTlY5gbJFLPhWQ4XxCnWWvUrA0imuzdP7ZZVQxl1OSv
         PazLOSHYMEZSaRzVx3o6Q6Fvunh/xRjrfj5TTJ1nG1+fhDtbgHqOK7xY6MrgNBJ2xjV9
         MSNxXntm4phMiqtl+m8/QDGZLUHPyC4zsjfneNUIkqTxd96RKYWAEv6+vVrtPtLZVusJ
         OO218CdeKliUjZBVOdna0hbg7fN/VNqhovBNBA44SZ20cumM7MPKbYi55V5lf1T+spGV
         sM7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWKnzUgE7t8D/l+eq3Qda/U6UGehyU+1cLTtYibu35KMfrhUEa0sz46XyKMcJ4O//8Qm12qpTgITm8FD8Uclt+9F8nTQRi1S+3YLnXE97YnDtaPvyP6yMMFQZzvoCrYnm7VfaG8pvuYnFdCl3JKivRfMtX8QhEDBl6slde1
X-Gm-Message-State: AOJu0Yz/Lx8RLEjxl1I5N3Le3GKdQfX8KbJ8fnTd5hSHnLxvRXfbY2j3
	RNdTDSbD9V2atItzKkxMluw3rqhBhGxJoc2BTgQcBIxanE9drYEB
X-Google-Smtp-Source: AGHT+IHetKRmg0p6ec20FHTRXCN/whjCZU8/Nl0XsjhlMJEnyWnCU0egaJ69kA4sx+zMiu/9CyYB0Q==
X-Received: by 2002:a2e:b3c9:0:b0:2e1:2169:a5cc with SMTP id 38308e7fff4ca-2e95b0c2343mr12132001fa.15.1716559015865;
        Fri, 24 May 2024 06:56:55 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100fad970sm54296835e9.37.2024.05.24.06.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 06:56:55 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <e62157f2-d691-4cf1-8cb0-717580b8a836@xen.org>
Date: Fri, 24 May 2024 14:56:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 12/21] KVM: x86: Remove implicit rdtsc() from
 kvm_compute_l1_tsc_offset()
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
 <20240522001817.619072-13-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-13-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Let the callers pass the host TSC value in as an explicit parameter.
> 
> This leaves some fairly obviously stupid code, which using this function
> to compare the guest TSC at some *other* time, with the newly-minted TSC
> value from rdtsc(). Unless it's being used to measure *elapsed* time,
> that isn't very sensible.
> 
> In this case, "obviously stupid" is an improvement over being non-obviously
> so.
> 
> No functional change intended.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/x86.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


