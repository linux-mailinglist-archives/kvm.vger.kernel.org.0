Return-Path: <kvm+bounces-18132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F538CE6C7
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAC561F217C4
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE9512C55D;
	Fri, 24 May 2024 14:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THaFEYLz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4BC12C496;
	Fri, 24 May 2024 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560084; cv=none; b=iDusGQAZBZZt4weOlSraxdJxY02+tHZ9tLuXYyXrqLujvct2ySr1Bj/ulgCFnFqxyLs8xBVuPZa1uwo+ATmMXcE/Mu5eJ9LwpOCv7bkwI3FeAs7PpRhAYBBzaQwiIN17Cp4bsWvCMiSHDG0mN4j2/IU4KD/GYW7mc+gDJqipeiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560084; c=relaxed/simple;
	bh=MI4xf5CZRh3JkSQUXneg4YB/Rd6XH4dXyTAjqy7XGYE=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=FDX2SVhr7PmpdHcaBNBorjHeyEnAEIE/UMMyLKvfNveN5T/Q/U5+17N3rNu7tklRPQOSMCECV3L/seGtf6NJVvMGfQTJTZTlyjzN/7w/Qdl1PQslUo7n6EGxyor5i8mtPC9v+9aUz8sGdvwlXNizLHUsDhmInlROlVLEVSasfag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THaFEYLz; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4202dd90dcfso30200015e9.0;
        Fri, 24 May 2024 07:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716560082; x=1717164882; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xEluKMmcJIBqWSHwgH41oln24FVPrkhhhNsUp8d02/0=;
        b=THaFEYLzII4nH4qsOpGuJinHSJw1HCV5C6rHmDghWMhof43p4cy3+hdX9USqWNpbf0
         JX6M1uS37iWK3wcLpkkzjzBrlESmql3kRWKQqDzz6BDsNZCg854d9gwL4mVVzmgS4GYf
         mjtmMxqGU4sCbAY16WkXgU6wEshA0uql+z7YH5zlLSYnCeDT6O8fBZ91KSQyCrsf5g33
         ZYr+xjwxYFonoDZXs5qfLwnbJTrd3jGujRbF6+1vk3WLKQmWkYstp1DVHz289/wehoFO
         iGkUrlBo39MbhTPH+sAwcqkusRbJicbou2b7moWhG+YyOwxMgMBPQexi46shpF88p7DA
         LAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716560082; x=1717164882;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xEluKMmcJIBqWSHwgH41oln24FVPrkhhhNsUp8d02/0=;
        b=iMSM5qL8h08XnR0ZinUelCqT2SUadTat6YBqoQoGE4QzpK2fLvfoWlSio98VY0UCJp
         vn52aKHw9ztFnIlZQUC+bBup3GLk/W7C/HOqmn1CUmpW7P/PNXOdE5h89CnqUcHsHdAB
         Ngbe85/iIYiYNopBEErvb9LN+oIYM8/U7dbZZbhEqtVRr++HGfchTq9KoEy4iiq34t2U
         P9T2/uzEC0ZRLh06Kus7WIc5VRZLVs2ANDs6SPJTeQL041GJUbJRhY+7edcQCZgo6drJ
         zpVhs3DowarfZXGbM5a3/tlrLx/7aFSnOj3way3MitWa8HCq7zaSGhXIdr1e1WvXdhcu
         1a5w==
X-Forwarded-Encrypted: i=1; AJvYcCVvVNw/1QbZB7VHcrs+tyd2g0HPWKdFQg3pG6NJiJNOMmgSEvqepSp6RdiNXZOyghr+DkDb+UBJCkZB8o34/OrpisqsGiO+OD62O1pPb8sulmkzDmvfrie+0iBzQTlTU1Z/4vUb16sMroZV1N2y8JXxBHcOiBN4TuXN4rP6
X-Gm-Message-State: AOJu0YyssVLE6MvHC4mM6AuuelFz1ijNAm+/beLILd6j+dEcamWAtYmg
	BDlg5keV69DT/6s8NdJEnW8QPa8w3yGESnCZC4QdTviaGefWUsjU
X-Google-Smtp-Source: AGHT+IHXRFsNK2wnj4sp/3fO9zgJ3Kk2UE7eYwFqdvn8zfF9+N46EqzzK+tUaYA7zWaNVbRzRusQGQ==
X-Received: by 2002:a7b:cbd0:0:b0:420:1284:475 with SMTP id 5b1f17b1804b1-421089cd413mr20419145e9.12.1716560081669;
        Fri, 24 May 2024 07:14:41 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421010b97c9sm54598375e9.45.2024.05.24.07.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:14:41 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <497d4ba9-5ba2-4e6c-b697-bdf7442b2488@xen.org>
Date: Fri, 24 May 2024 15:14:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 17/21] KVM: x86: Avoid global clock update on
 setting KVM clock MSR
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
 <20240522001817.619072-18-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-18-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Commit 0061d53daf26 ("KVM: x86: limit difference between kvmclock updates")
> introduced a KVM_REQ_GLOBAL_CLOCK_UPDATE when one vCPU set up its clock.
> 
> This was a workaround for the ever-drifting clocks which were based on the
> host's CLOCK_MONOTONIC and thus subject to NTP skew. On booting or resuming
> a guest, it just leads to running kvm_guest_time_update() twice for each
> vCPU for now good reason.
> 
> Just use KVM_REQ_CLOCK_UPDATE on the vCPU itself, and only in the case
> where the KVM clock is being set up, not turned off.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/x86.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


