Return-Path: <kvm+bounces-18139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF1E8CE6E7
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9E7E1F22682
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DED712C496;
	Fri, 24 May 2024 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gs0lSSQI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4878624F;
	Fri, 24 May 2024 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560513; cv=none; b=S6/VCEpAfqWUShQw+c16pQI1s71+VBFw5eDpCUPZsb5VS5N7QT0JLAYE2t0J1OVlkBKv95NA8VG+WNZIoqJxxVNUO+16rx/UQI5RLVXqSi/zZrEvFEnksVODs1E7J4D0iqdaiTMZKQFOujbE3V74n5YKbXyV3hJML9e/aEpX5Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560513; c=relaxed/simple;
	bh=I1fVQ8aruzVXFejrnCOpq85Ssr3vo69cTffIdP7BZpc=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=p3RLFEb+pqg4W4SvYECC+ftts/lxL0IrisrokQXh2NPnjXtLBkkKYSyqYduQu6bn/KCWAdQ97Xk/K6ZuHuZ/s0jBv3/kUqkqdK4ytY07E23/D/d5eV3UbaBZdCY0AcgG/Bcze0TGVaWtu/8gh8DZqwdRinFDSAdyXteuDF1pA/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gs0lSSQI; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2e95a7545bdso10951111fa.2;
        Fri, 24 May 2024 07:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716560510; x=1717165310; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EO6JyY37GyM7MbMeX101SjHOud1jj3bTq3LVAy1mWdM=;
        b=Gs0lSSQInsS9FCmkM1tvp1o0bo7sz/lHlcDykFQ5R/J6gb0aQqmv45T518rsdIVUa8
         vs1kN9n8S57Wmax8Nvs62rZByToKCHxTdXOqxHtH7mWid2aQD9XF6TY5wIsueIOf7caE
         FT47DY0i9bx2qa5yWHdQQRSpHqD0wo76TyGXkkFqqYuxjN1ndd8TYAyd9KgjRYcXPy3a
         M8KgvCex2LmCoUyY4F8SUna9xWFYrAomZ/KO+vHs/g1AhAT8eKlH7QcqLZulsvlii93a
         fWrBi8MNjB+0Q8AfxcRXCEMXxfgUYG0N6Z5NPYRIEwx0lssR5DS2bwq29brqzzAQa3ni
         sTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716560510; x=1717165310;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EO6JyY37GyM7MbMeX101SjHOud1jj3bTq3LVAy1mWdM=;
        b=O3zeqhCA36RuTPxAvCb3q2ttKexu+N1vMVf/9eT9Puu9PpHzKk2afb4u6wcVAy5gQ2
         YfaaEQ+dAOUFBncwG6ZBtlRKL93b1YMYCJ9W1n0wSH460uFHl/nOrXaf8b5icSyiceWt
         VAPvuxImG1fFyTHGEFS489s7NwPWPw08I8uvoTJyUEgikwuLi263Jqb8qfenEfzoXSK4
         tKroSQPEKdA3addU1QggnUbN2GYxTtq2r7SpQQ5T4+x/RNqzfkKB9/gTJBf6QkJ4gh22
         IgXmOTTCjd7/kSse0eF3U5wKcYn4x08WVgPVsKgPrySvBf9HJs24DRmN7cyag+3LFd/2
         v7Nw==
X-Forwarded-Encrypted: i=1; AJvYcCXsz/6XNC968+e1gBW+MwNDD1WkX5Mbpu4LoRA8MKw+42kYglJOoBAe9Lo0egtNKPmxxDpAWGxGbqOaDbjXS+1Etc7/GzUCr8Y1yoqpJcb+p1cLe/fFzP4Wu9XisimJgodStZ7yGZIDccDmTc/hyFKrEMAoMDnH+VQNDfzh
X-Gm-Message-State: AOJu0YxKH/kh3UJL+SpOws1/98tAUPxMUWTb6I1sB5+My3AI/DnRWyvP
	axvgz4vSV9/NVFrMS0afP8fbqewrrpM+M+LGSAHlfbJ7vw3aMwFF
X-Google-Smtp-Source: AGHT+IFaM5cCCStOymrSMk1BCIm0WOr58TUeWH/uU5BPxIKAbgFTc7roakKxooYtc8e5UIaxLJNLfQ==
X-Received: by 2002:a2e:7e12:0:b0:2e9:53fc:4434 with SMTP id 38308e7fff4ca-2e95b256643mr14752221fa.42.1716560510085;
        Fri, 24 May 2024 07:21:50 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421089b0410sm21761915e9.29.2024.05.24.07.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:21:49 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <7d318473-a16f-455f-9ea0-0c0b2d919ff2@xen.org>
Date: Fri, 24 May 2024 15:21:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 20/21] KVM: x86/xen: Prevent runstate times from
 becoming negative
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
 <20240522001817.619072-21-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-21-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When kvm_xen_update_runstate() is invoked to set a vCPU's runstate, the
> time spent in the previous runstate is accounted. This is based on the
> delta between the current KVM clock time, and the previous value stored
> in vcpu->arch.xen.runstate_entry_time.
> 
> If the KVM clock goes backwards, that delta will be negative. Or, since
> it's an unsigned 64-bit integer, very *large*. Linux guests deal with
> that particularly badly, reporting 100% steal time for ever more (well,
> for *centuries* at least, until the delta has been consumed).
> 
> So when a negative delta is detected, just refrain from updating the
> runstates until the KVM clock catches up with runstate_entry_time again.
> 
> The userspace APIs for setting the runstate times do not allow them to
> be set past the current KVM clock, but userspace can still adjust the
> KVM clock *after* setting the runstate times, which would cause this
> situation to occur.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


