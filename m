Return-Path: <kvm+bounces-18130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA3268CE6B6
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60B8E2823EF
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A794312C52E;
	Fri, 24 May 2024 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lNkh7Rlu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B94112C466;
	Fri, 24 May 2024 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716559839; cv=none; b=KdoXzB3S7DIRjEpD/Qboiw07Psed85O2VgaCysfOrVbZofWBrPI/Q78F9uWY3xrnnWXAsGtw1ErXu3KtRKvjnjFbablBjKv0DjuYYU41nl47q6Fu2Bt5RyVVSK+ZtNAkLPes6fdXMJ3M6tonEm9U7kg84zZmaqh17mjMuwsQIXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716559839; c=relaxed/simple;
	bh=hJyg2YZ2WeH0Q9liuVLFHR9OibhRwupUtgr0ma4XRbo=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=dkCpFPgrT733Ajhw3j4Wmk+xEjg5y0OgpEjGkipGDtvt6LQRBwMNN24h1vBtZxUg2ze4HhCDMbITgUdOfCitPfB0MKRz/rg3dvMbeWBiYAn1zE/MR9D6B4bUW1u/MqW1YapS4ZzZKp+sVXUn5DusZCisf5ogk8yriGCatsRcQhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lNkh7Rlu; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-35507dfe221so585677f8f.1;
        Fri, 24 May 2024 07:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716559836; x=1717164636; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QveJEjdigPYVmEFYMrUNMB5K+Jm/VE2z4qre0BBpK4A=;
        b=lNkh7RluM5SxuuPVy+ibwP//VXOYDc1PyyBseaGy+OCMSvW+i1fobInd3YE78GF1mX
         Nk2upxKim+6zu8cZeK1JarwIrAFBo8aHFtO336U5hxD2m9wBze2ttV7wa5jCxcbygB7W
         bFl4lSWYUU0s0hibbamP2Pqqon3ASdKyOqClVPlL/9xSY9EfwAXlPinXoumxL8/Z+CQ2
         aNvAQqp5t5hEEQN6FQHnowhGJP1dKGLKgCptuqZ4LJodHi9mZn2qBKiBQfoPjS/ZVlXG
         uSinEovkIlrIXySFob3X8rgCq7CbmHjCMsDMfSf0kfoc7mWK3mQdq/lNeJZFiRv+t172
         ocig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716559836; x=1717164636;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QveJEjdigPYVmEFYMrUNMB5K+Jm/VE2z4qre0BBpK4A=;
        b=gTrWu5NQnNq7/VtgJF6ifAaEObdN9dPNwE0j0ErieG99HerAsXEuVtP5dHkpHgvca/
         qX4J5hMPpzdkm8HskZZNfo7R/w26EBIKm4/t4q/z4mQvFbIBlYsJfbwc32qdqAo612ug
         B8H0NHK+aBhTSVCLcM3TzHL4kZ44OufrEAc0ayiK+mavvu2CIS9yLvhRl2P5xSU9SGzb
         7gadTTdn8JZSRb9w6yI7EJD/QGE37VsBFRM4WKUUU7UMJrMeA7X3HoYOw6QNtLhZjqk5
         Ou2broUev5fmPKk9YYQW6+WmUjdXhVgbVteHBzjR6+sXy52VPXy/wz10dFexw8/Jq1pM
         tpKA==
X-Forwarded-Encrypted: i=1; AJvYcCVG1rIK+7D0RSSakxY+iv28tQIwvve1bBwuaCx2sSfyTl3+tm6M0Gh9Eyk2vGeml23bemlB46+WTJrOcVZyPmCdf1v9ZICC/wdUf0SIWL4VqF/Y5GwRSV5MBCKQdLBahwKVqgj8HJv9ZzF0/JENahv7Gs7813XVgAKz1bvm
X-Gm-Message-State: AOJu0Yx2PzQhBfEGBXkWqWgP9YR4wMb8ulPEV/jWuA0fhUoGcJusf53v
	0Fd4y1AIMxN5joLBsTSofWKpQoF650+kj898j8o72FszXQGWjCqn
X-Google-Smtp-Source: AGHT+IHHeXsQHs1F6X587eHgOckB4m1ejeDsmQpqoDkOBkHcRNjJ821RInFYpzgiea348JO51njZPQ==
X-Received: by 2002:adf:db43:0:b0:354:f724:641a with SMTP id ffacd0b85a97d-3552fdc5d99mr2035164f8f.44.1716559836317;
        Fri, 24 May 2024 07:10:36 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3557a1c938fsm1673617f8f.76.2024.05.24.07.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:10:35 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <c36f5401-05e9-4c13-a24e-31ebab8ae4f7@xen.org>
Date: Fri, 24 May 2024 15:10:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 15/21] KVM: x86: Allow KVM master clock mode when
 TSCs are offset from each other
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
 <20240522001817.619072-16-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-16-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> There is no reason why the KVM clock cannot be in masterclock mode when
> the TSCs are not in sync, as long as they are at the same *frequency*.
> 
> Running at a different frequency would lead to a systemic skew between
> the clock(s) as observed by different vCPUs due to arithmetic precision
> in the scaling. So that should indeed force the clock to be based on the
> host's CLOCK_MONOTONIC_RAW instead of being in masterclock mode where it
> is defined by the (or 'a') guest TSC.
> 
> But when the vCPUs merely have a different TSC *offset*, that's not a
> problem. The offset is applied to that vCPU's kvmclock->tsc_timestamp
> field, and it all comes out in the wash.
> 
> So, remove ka->nr_vcpus_matched_tsc and replace it with a new field
> ka->all_vcpus_matched_tsc which is not only changed to a boolean, but
> also now tracks that the *frequency* matches, not the precise offset.
> 
> Using a *count* was always racy because a new vCPU could be being
> created *while* kvm_track_tsc_matching() was running and comparing with
> kvm->online_vcpus. That variable is only atomic with respect to itself.
> In particular, kvm_arch_vcpu_create() runs before kvm->online_vcpus is
> incremented for the new vCPU, and kvm_arch_vcpu_postcreate() runs later.
> 
> Repurpose kvm_track_tsc_matching() to be called from kvm_set_tsc_khz(),
> and kill the cur_tsc_generation/last_tsc_generation fields which tracked
> the precise TSC matching.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/include/asm/kvm_host.h |   6 +-
>   arch/x86/kvm/x86.c              | 130 +++++++++++++++++---------------
>   2 files changed, 71 insertions(+), 65 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


