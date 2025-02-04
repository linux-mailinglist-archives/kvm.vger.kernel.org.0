Return-Path: <kvm+bounces-37214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE90A26E47
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 962AF1883425
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 09:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E47207DE5;
	Tue,  4 Feb 2025 09:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5b3DVGS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0DD206F17;
	Tue,  4 Feb 2025 09:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738661327; cv=none; b=p2IAtESzm2QDn8C8YtsXc6oLvJfiX7N/9bop9A7VwxVMF7nzeR+y8OaFB/RfnmlXMMpbzSOFJN27BmLNpm4/ZvlaioyzSrh9SC6S925Et3HcRux0k02zIXcp1P8yDA56vt1Xiv3cPviBXETMm2mjQxJkF08I8xcYhnifj6IBjrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738661327; c=relaxed/simple;
	bh=VnS31rylgHiREySqv8HKPVWOHC16dcRlvpLngN8T+54=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=h7ojvxKOG+IqmH32GidrQht2VY1vNeKGd5hafQXsZw8n6i28AOfkCITkmas/Rh/zUuTxS/wjV5bqUuARNshhjCg1gNnWNZsQWmeASgDhMW3RbZyRvwFXdtzbU826LtnpHM6S6kxnup5kWod0B9a+UVb4t1I5268AH9ckkSi2rVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5b3DVGS; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ab70043cd05so826101766b.0;
        Tue, 04 Feb 2025 01:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738661324; x=1739266124; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XTwc9Th5siWMiTD7kn0j7u1V80IUDrClcubkNNtYRvo=;
        b=V5b3DVGSV3Fh56CUfpEPRj1AxXVlkF2xgH5pvMEN6WNdrNh+/WiF4iOCSrA1cIr1fw
         dm/UFN+DbE9ETtOe5goxb5TW6Jg3ayq+SYNo0w39yk0JJlfvaWMmulKN+nAonCrQno0+
         DHC7CvpRxDeGRIFexKJfQPVfv37h1EVNsK6xj2FIuTOYegU5vfAA+MDwqMH1qnLa1F94
         hgBvPUwQ7/LVpN8SehYJhLEB0It0CaXoE5y2mLr+WqBsG0php5mMPcCwU3OhITJUSfep
         tw86DmfA7WWe/OSpmzu3YhEKQ0nup0XkwdF+Ze+Qn8ALrjN3DuN1VgI+PxTXEv8s8O1M
         7AOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738661324; x=1739266124;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTwc9Th5siWMiTD7kn0j7u1V80IUDrClcubkNNtYRvo=;
        b=AMpIhahALvRqWCQ/96tyqwSkNRNA/+8WqPznHW1A9D7iQXMtMr1HH72vUJg+ID8+XA
         eGGn8dtqG0PbiFeWOz7PSBjxdc73dPtc1g+9Gciv1q8UCzSJTAmgU9s1kAZC3zuQmwBN
         23mCTZzybJ4evbPWBJOioMpTZt6SH4CI/NDvpGVBIigxhOwEdWt1cXZFL8GO7t+CWSm+
         RZdfEBdbhVx30Fdqz5llm4XwUkV191/P5U3ukywX4H6Uk2RkBJso2EA73A6bLQr+Z3N7
         4Ee+NgGOGuylKTEYfERa/S+zUXcIsRLLPExQtzjBmtlJOsgAuB3FwRY7jVEUZx26Tl1q
         oDcw==
X-Forwarded-Encrypted: i=1; AJvYcCVsOs+BVPj4AUuPvznyhBhcziuCQtYehX2zFM61MfLCA0l6sNemNY2Q70fzYu35KEYoT/IQ251B+BJ8NL0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPX6RJKCs9tFR9QXejBiSio1QdjtOsMMUwuAibbNVid6u5aAyp
	ajruJDSgXwThHwVI8k7cl0GPERYXKVCQTFho386o1wNl4bL+QUDkEZF3v9Vxi5M=
X-Gm-Gg: ASbGnctGz0Xvtt/aVUHqPZ5TjD1VZEczQh2FNlroT97Hl5d9qZIxfWD9TmfDqoyykJ1
	/EaR7T30Oc1dHSIC6Ori0A08i2Q7Zze3Iw9XUz/kYyZlQlbbhYemDjpSq+mEps83kVVQ1n7yPnL
	FG13w1TzIGfcgy6Dj48gxMdCaoxalSDS39Y8OC9kdYuxNxks7UOedVHW2V7kTMPlVa4qN/vLhSa
	JJkHqeGahD5uz1MUOWNLNjEoiL8c6fFqCN1Neghw0a7p3dS8G8AtGs2xRJ1RrNmrTGqOtw5jPCL
	/NS+CvnjxyyywuRvFVCrv8iXYvXcPFMtGVF+ZgLW/8cqcnQ=
X-Google-Smtp-Source: AGHT+IFLBtYophIm6tAO2aFSfswyWwr/aSH+r86kCltIEVfR3E92Fg2lpP+VlbBSyBgC7qImjOtqeA==
X-Received: by 2002:a17:907:940f:b0:ab7:1012:3ccb with SMTP id a640c23a62f3a-ab710123dd0mr1177789666b.14.1738661323862;
        Tue, 04 Feb 2025 01:28:43 -0800 (PST)
Received: from [192.168.20.51] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e49ffd42sm903597866b.95.2025.02.04.01.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 01:28:43 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <e82ad865-8c04-404a-94e4-d9d7e5c10717@xen.org>
Date: Tue, 4 Feb 2025 09:28:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 06/11] KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED
 across PV clocks
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250201013827.680235-1-seanjc@google.com>
 <20250201013827.680235-7-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201013827.680235-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:38, Sean Christopherson wrote:
> When updating a specific PV clock, make a full copy of KVM's reference
> copy/cache so that PVCLOCK_GUEST_STOPPED doesn't bleed across clocks.
> E.g. in the unlikely scenario the guest has enabled both kvmclock and Xen
> PV clock, a dangling GUEST_STOPPED in kvmclock would bleed into Xen PV
> clock.
> 
> Using a local copy of the pvclock structure also sets the stage for
> eliminating the per-vCPU copy/cache (only the TSC frequency information
> actually "needs" to be cached/persisted).
> 
> Fixes: aa096aa0a05f ("KVM: x86/xen: setup pvclock updates")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

