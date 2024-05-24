Return-Path: <kvm+bounces-18128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 704CE8CE69C
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB439B214DD
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52C2012C482;
	Fri, 24 May 2024 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QRLeeLgx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BF339ACC;
	Fri, 24 May 2024 14:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716559422; cv=none; b=rn0eCUWGJYqVeptutU9HPPrpwo58AXqUQ1HCadeLRsPmTpXrmW1GS6IgnH+0K2Vgb1P17E1jbBJeXWcNADziXLZCEabz1x6/KK2OE+V6VbR4+G4cTX5EPkUWiKwM2SKcNw+T5NpOqzNm8q+0JKSxG28xBNEaiSwFcrXm9wqXVuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716559422; c=relaxed/simple;
	bh=r24Qga0ed7HOag24vEjlFAJ6R/BjnaRDrz7HKRoHTFs=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=sBsgUIIiKEk+3DCJiN1Bnlf03QmIrdlj7lkD6u+Jhwdmmep3HLd5mNuroW29USrcAQBAD12XHevo1IziA3AgqoVbns9wVp/1XHoA+4Y5E+c6aEuBdDTJtjp+75lKnbF2Ey7zRuwTCPabBfVqDsPutSZomZyWToMwfwnde2VA4lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QRLeeLgx; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2e95a883101so11073951fa.3;
        Fri, 24 May 2024 07:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716559419; x=1717164219; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gK/kt0+G1Gu5Dj3cp1xqTKPcVZ4x2Lbeq9ePii2LIz4=;
        b=QRLeeLgxVCQMe62VhQiwOnXgyn38Is5I7KDRY/fxdhs8vgXwhGpGAQMUrBSy0Jee+R
         nQV7+Shnx4Pl8Vn0NRS/b8rKTaSV1bOEehuEnbOI60j1iYDgBqqEHjcl5TRgLr/9VjLO
         OKl9MvxWz/pLX5AgkSEPV1cM8ci9t9HniWFOpKEVcp7IHWXSSD0InhIUyBOfY0L6BdQK
         E5O5Tuiju6g6jAP8dbNP+OGFgskNUsTSKPgQKuBE5nFJO5axDgy/zIAqlAvPsnycx89L
         b2cA6fDtxdt3Sjt8Efw0sxn4CbxayLdLd+1opgtgTThieltouR37Dno0rq52xUhVe9wi
         YdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716559419; x=1717164219;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gK/kt0+G1Gu5Dj3cp1xqTKPcVZ4x2Lbeq9ePii2LIz4=;
        b=l0i94828RU2pv043XJECrkVlfy2wm2+V77cl7gw+2haLqxv6CuYDVpF48juKeRtLIu
         mNhDZgIQ+xE6kVXKey/IPECAOGY42oeCxUxGybeVuH9J1Ydu+8tej4VZqy3iyk4GgzQF
         OErU/krDpDBB/QnayoNhZee05Je5QQB2QLi3vHX8Ped/MS8UMla2eJ1W92qw/EPQ3zJA
         dpgaeGuNwIb8s609EUR2AwCUmqzsVCOU8xj1+XnZ8K7bXkynvkEEcYVchaPAjfNQ/NSU
         FRqvZf3w5dGjV3QDaaiboixQZH+UWC2PkzsxRGdGd/17mJf8IrjVl3nh4oTK26PWgi7r
         fedg==
X-Forwarded-Encrypted: i=1; AJvYcCWlg1pEnVOdVkC4HD21jBndJJh8xRpdSpminYQLZX6+Iu/KQB4/PG5Z6mwUe7gstFwxl+DGcJexsduMs1k8o/PdQshV4Q0lxqWcBZIPzNBLJpJJQzYv3J/gjULXnmhRPh35bc7jtn9FbmdM5PzKDuspLpD07E2BjOOizLYk
X-Gm-Message-State: AOJu0YwoVfu4gTbXOtDm76Wch6H726m3sDOqPU3bmfP2UX/3sqOSk62q
	zWqXsues7rCZjeqSzjLznk6Zix03oP6LLD1aiuNuQzyVt2NU/QDn
X-Google-Smtp-Source: AGHT+IHGurczt6IqfWzkF2qKuyA2yqPccpX12/gbuVBEgw864yeetZeX5cJUgG/EqRUsCkCHBBVSCg==
X-Received: by 2002:a2e:a315:0:b0:2e0:a39b:2b25 with SMTP id 38308e7fff4ca-2e95b27f5cbmr16925081fa.48.1716559418969;
        Fri, 24 May 2024 07:03:38 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100ee806esm54025705e9.3.2024.05.24.07.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:03:37 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <04ec9d6c-e761-4cfc-a2fe-a2d7d398c334@xen.org>
Date: Fri, 24 May 2024 15:03:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 13/21] KVM: x86: Improve synchronization in
 kvm_synchronize_tsc()
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
 <20240522001817.619072-14-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-14-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When synchronizing to an existing TSC (either by explicitly writing zero,
> or the legacy hack where the TSC is written within one second's worth of
> the previously written TSC), the last_tsc_write and last_tsc_nsec values
> were being misrecorded by __kvm_synchronize_tsc(). The *unsynchronized*
> value of the TSC (perhaps even zero) was bring recorded, along with the
> current time at which kvm_synchronize_tsc() was called. This could cause
> *subsequent* writes to fail to synchronize correctly.
> 
> Fix that by resetting {data, ns} to the previous values before passing
> them to __kvm_synchronize_tsc() when synchronization is detected. Except
> in the case where the TSC is unstable and *has* to be synthesised from
> the host clock, in which case attempt to create a nsec/tsc pair which is
> on the correct line.
> 
> Furthermore, there were *three* different TSC reads used for calculating
> the "current" time, all slightly different from each other. Fix that by
> using kvm_get_time_and_clockread() where possible and using the same
> host_tsc value in all cases.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/x86.c | 32 ++++++++++++++++++++++++++++----
>   1 file changed, 28 insertions(+), 4 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


