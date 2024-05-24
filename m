Return-Path: <kvm+bounces-18118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 008E58CE60F
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 245901C21B25
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0F412BE89;
	Fri, 24 May 2024 13:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QoI6gY+i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D281292DE;
	Fri, 24 May 2024 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716556815; cv=none; b=YUzGUUUKX5QOsJag/UdwphEBj1C4tp19MrEVCPvDGmfteQoVCpRfjmSRUaRPu8dwdxua3zwYLYhmzGHS0AWxQ+3cDlK5Kg9vK10hUUIauk/kFtsZnqojfUv8+50Tb0C07QsJ68G/d4FWQwtKuz0bt+szH767PZVdXDsvNk7B73U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716556815; c=relaxed/simple;
	bh=biZ7qAWdW7zPaeONCmHV0StXEtQawhsNoESZ/hmM5VA=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=KUb3rlHnMRXgmNZ/Sr0omnOsh5Wcrb1ROJbbrbX52MZadIGQPhauFuQAMiBwaGpNIHJul1pf4VfyeEw8jv6EvyXEkzs7MGYYlS9GMRNiS+0gtsEKvfgtJ/naa+QWJ7VY9daeQMdMlrR2RLJbz6IwPDpvPe78lxIOSaisZAiyJTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QoI6gY+i; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2e6792ea67fso107285401fa.1;
        Fri, 24 May 2024 06:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716556811; x=1717161611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XjUlSi6b7spXDtsoszPBRMpQom7fNDT5+VmBArxwsxM=;
        b=QoI6gY+iDjh8A3//EEmlMY7tCiWrqFnS6/FkKTAjeU61oMayN8Q0qIMh2F4INsDEvu
         yhRX5f/5hadhOsMTUuDJQPmVloQVfdnpVNrLTY8RR7xnGHHWVVUQli/C3YO7t6CUxJx1
         rkvAiZ+ZVF8YKjiNchA370cLMcunCNdlKToBoJIupbXcNS+ZkK8x+Ky6tMBhhqmhvA1c
         7SCW1jBP2g/CsLKKaRKEnmF8iWrPNiVJYrhoY1NGJUL+wi3LfPF+qihkAxrMOKD5kKIR
         O4l5N8fNcm6NiFfZFlRZNl7x4gHH2pvtkvWVRbi2e26+BH2NnUi4qnaJWT/mguH+90PK
         +jAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716556811; x=1717161611;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjUlSi6b7spXDtsoszPBRMpQom7fNDT5+VmBArxwsxM=;
        b=hk5j9jIbGPG/o9CWxxFYOwZFHcUmSVjCEx+lXKSL23o3OrDXjjj7sf31qYjg7/9UOh
         3pAluYVFVjIJ//I9lMioBCafwWHQOm2GLrju9U4iIN2QMnPrrcK2E7qXovahV5IFUA74
         JQlRrbC665QT9TX/gh5k1QLvrzL8Zdm5cW/FstxA9QtY1y/4LsR/wQ2TcWWtm5KOG7pb
         5eTiwqcBpKPSYzoccEOr0RiD/aQO/z3Fv/SdBl4ILrOZXPpMDcOjKpjd6Skj+gM0tdU7
         5mM20+D4pOZlOZ3GnIKRk+sqPmoJwR7BqHIB84MrHLweWf5AESeBKQ4qMTMkepcOTeMz
         zhXw==
X-Forwarded-Encrypted: i=1; AJvYcCUcaGKyFXwFaB5IYlLu+DQ3vS9KTF9zZM//nYTN1RMf7CDChH9zCKHYtLYUjeW7raVyQ0bCddywcf3ZNBIbWCqT0fCt43S5Uu/+APbJEPT7W8I9vYGnOBTgUAlJzAHiWqbXGBLmiLCvvlccDsHjdRhsEf37/D3NJt67koab
X-Gm-Message-State: AOJu0YyQk1RdpVwlSdmvoMh4X9Y4i5XC1kfKzWMlaRSiVKn6vSEMaCDp
	3LMZW9w3uHdpzS3RxrkHSQ+wVThhuLbZLPmXOo1I2dLWW/cWEYJ9
X-Google-Smtp-Source: AGHT+IF7RpdA2xi0Lhf2AfbZme43FQtrch2j5C+6jRLDqFDj/U04J5HmragkJQIHB0bawHG5GcOJJg==
X-Received: by 2002:a2e:bc08:0:b0:2e2:72a7:843c with SMTP id 38308e7fff4ca-2e95b24dea3mr17566441fa.36.1716556811361;
        Fri, 24 May 2024 06:20:11 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100fb8f4asm53192065e9.41.2024.05.24.06.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 06:20:11 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <9255f42a-7549-4b4f-8654-e0bdc6c643b6@xen.org>
Date: Fri, 24 May 2024 14:20:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 09/21] KVM: x86: Fix KVM clock precision in
 __get_kvmclock()
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
 <20240522001817.619072-10-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-10-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When in 'master clock mode' (i.e. when host and guest TSCs are behaving
> sanely and in sync), the KVM clock is defined in terms of the guest TSC.
> 
> When TSC scaling is used, calculating the KVM clock directly from *host*
> TSC cycles leads to a systemic drift from the values calculated by the
> guest from its TSC.
> 
> Commit 451a707813ae ("KVM: x86/xen: improve accuracy of Xen timers")
> had a simple workaround for the specific case of Xen timers, as it had an
> actual vCPU to hand and could use its scaling information. That commit
> noted that it was broken for the general case of get_kvmclock_ns(), and
> said "I'll come back to that".
> 
> Since __get_kvmclock() is invoked without a specific CPU, it needs to
> be able to find or generate the scaling values required to perform the
> correct calculation.
> 
> Thankfully, TSC scaling can only happen with X86_FEATURE_CONSTANT_TSC,
> so it isn't as complex as it might have been.
> 
> In __kvm_synchronize_tsc(), note the current vCPU's scaling ratio in
> kvm->arch.last_tsc_scaling_ratio. That is only protected by the
> tsc_write_lock, so in pvclock_update_vm_gtod_copy(), copy it into a
> separate kvm->arch.master_tsc_scaling_ratio so that it can be accessed
> using the kvm->arch.pvclock_sc seqcount lock. Also generate the mul and
> shift factors to convert to nanoseconds for the corresponding KVM clock,
> just as kvm_guest_time_update() would.
> 
> In __get_kvmclock(), which runs within a seqcount retry loop, use those
> values to convert host to guest TSC and then to nanoseconds. Only fall
> back to using get_kvmclock_base_ns() when not in master clock mode.
> 
> There was previously a code path in __get_kvmclock() which looked like
> it could set KVM_CLOCK_TSC_STABLE without KVM_CLOCK_REALTIME, perhaps
> even on 32-bit hosts. In practice that could never happen as the
> ka->use_master_clock flag couldn't be set on 32-bit, and even on 64-bit
> hosts it would never be set when the system clock isn't TSC-based. So
> that code path is now removed.
> 
> The kvm_get_wall_clock_epoch() function had the same problem; make it
> just call get_kvmclock() and subtract kvmclock from wallclock, with
> the same fallback as before.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/include/asm/kvm_host.h |   4 +
>   arch/x86/kvm/x86.c              | 151 ++++++++++++++++----------------
>   2 files changed, 79 insertions(+), 76 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


