Return-Path: <kvm+bounces-18140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E52C98CE6F2
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A2E3281520
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E5D12C498;
	Fri, 24 May 2024 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dYQYwDMt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9168885266;
	Fri, 24 May 2024 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560737; cv=none; b=TubRpTW+6ztE/KK2xdGl6Y2N7ctN7xmVPJ/oFrS9X8Yntmb+Ug3MDdfhCQKeS7g9BtGRr1OKGsrzldGphYO74iAamPEi7hrfxSRZNQ+u4Zfq9pE/hy20X9dzuuQpdzq7EQtiSnEhWLa1PslxRFJsr2LzdyElEpMRawteJav/f1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560737; c=relaxed/simple;
	bh=i5T8VMX6883AD5ny1iMp8S+d+BTgiK5gX6VGoj+n/ZQ=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=fLm0iCKt4pjGcjmKw3rzbBXvi4Jh1qTsR1qKinMcB039uFCnss96SaoUpOZe3OcLA2SxPeGAKdwfV3rbuPOAVv6cz8qu/n0TBhYC9bULjBggUKcaMEB4JEl9z7IcWZVDUsb34PDUObSiC9KkDPxtuR1whT7qeCg5ML/tAlJZvCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dYQYwDMt; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2e724bc466fso73794361fa.3;
        Fri, 24 May 2024 07:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716560734; x=1717165534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V+SbCl88kDWu5JpkM+zDsYPeWdf6fmH2eQbKUIgxY/c=;
        b=dYQYwDMtTzgN7nTanA2cmoKu900z9FINwb1zCi3N5QOVIO0aKxtERDnQM4yBK6gVSi
         7epuFhsm3Ydn93yu4+RVEdv+EJ6nKBOhp9vLXn4mQHaJNqYPP9UpQQ6YK6q3MGcPVtaC
         1Y685Y3Nz9nE7dTfmgLUAKSLwVonzNJ+efacBwjCm+0wM+TGf/JjiucEPY9lkUsgCfuQ
         rYnpMv88ISOI95LVEZZnZQriG5oQ5mcwKbbq2JnYadba8YkagZ9K7AmOeV+ds07XskC9
         V3F3ZB+4Vp/BzVL1rtLHEGqC2OFDor14yoYV4cg8gztm4YqAGgBwVxuSLjzKVy4A1MTU
         daXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716560734; x=1717165534;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V+SbCl88kDWu5JpkM+zDsYPeWdf6fmH2eQbKUIgxY/c=;
        b=S4Nt+KXBAY0uqNk8gYDWpeLkw0DAbB5BPMqUBa97nA79TrMa7huDTtUsGKRZ4d3PTA
         7KVGTG/lYj9+7i8UVY1+MfJxNqFWsJNPVQRukY5HVPrHrin6g/KZjiuPBp3xh1s1OIp2
         rMUluZ1dK3ZMkZlGYe8r1BLWubAsd4S4ePyBxRq3YoHEggg3Xx7d77LHg83y5D7Iae7S
         v6CmZF3lzUJl1T8askvuUZciWFvCcohAeGdQ4LnDsY9OmhvbChWQvWut0auAd85Ih3o6
         oe2gWtCqb5vkVLoEydQwRr5DzCCE0tfT5Y9UMPe/eigjxI9yg6dN9OBPgM/RF+4pUeEx
         tj+A==
X-Forwarded-Encrypted: i=1; AJvYcCVtM5ULPEMiQb2zbZd/XpBlI7XSep/tG9T6MWmvwomUuEFGzm7azmA/IzebL40zERL/RedG/RzNx1RybsR3FRRzOT3USlE8Hr3uobvUQGCQDtiplK3i0XNp5h7Qp5IOSZkyoOzeyhPN22b2dxs0VlYaTNp1e1NU3IH8u3gO
X-Gm-Message-State: AOJu0YyvbkS8nLKmfxQjaJF02wXeUimwYgeJ+PhkCHkG/2gdVIzbF4vl
	kNfy7NSP9tUNDnYEa6hvsxz5v4Z/6wsbg/dVMPv07b6P6dnrT+kh
X-Google-Smtp-Source: AGHT+IF65XQ0cUVmyUZKrF/14T3P1SnC/3B+ci8mfINEO6z/lWuS4ZdxUoexWOW1r9iA0cAXNnnNqg==
X-Received: by 2002:a2e:ba14:0:b0:2df:1e3e:3280 with SMTP id 38308e7fff4ca-2e95b0c4febmr20430861fa.28.1716560733620;
        Fri, 24 May 2024 07:25:33 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100f15f66sm53951795e9.14.2024.05.24.07.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:25:33 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <80f8ea7b-f767-4760-8a6e-b260da637903@xen.org>
Date: Fri, 24 May 2024 15:25:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 21/21] sched/cputime: Cope with steal time going
 backwards or negative
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
 <20240522001817.619072-22-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-22-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> In steal_account_process_time(), a delta is calculated between the value
> returned by paravirt_steal_clock(), and this_rq()->prev_steal_time which
> is assumed to be the *previous* value returned by paravirt_steal_clock().
> 
> However, instead of just assigning the newly-read value directly into
> ->prev_steal_time for use in the next iteration, ->prev_steal_time is
> *incremented* by the calculated delta.
> 
> This used to be roughly the same, modulo conversion to jiffies and back,
> until commit 807e5b80687c0 ("sched/cputime: Add steal time support to
> full dynticks CPU time accounting") started clamping that delta to a
> maximum of the actual time elapsed. So now, if the value returned by
> paravirt_steal_clock() jumps by a large amount, instead of a *single*
> period of reporting 100% steal time, the system will report 100% steal
> time for as long as it takes to "catch up" with the reported value.
> Which is up to 584 years.
> 
> But there is a benefit to advancing ->prev_steal_time only by the time
> which was *accounted* as having been stolen. It means that any extra
> time truncated by the clamping will be accounted in the next sample
> period rather than lost. Given the stochastic nature of the sampling,
> that is more accurate overall.
> 
> So, continue to advance ->prev_steal_time by the accounted value as
> long as the delta isn't egregiously large (for which, use maxtime * 2).
> If the delta is more than that, just set ->prev_steal_time directly to
> the value returned by paravirt_steal_clock().
> 
> Fixes: 807e5b80687c0 ("sched/cputime: Add steal time support to full dynticks CPU time accounting")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   kernel/sched/cputime.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


