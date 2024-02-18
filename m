Return-Path: <kvm+bounces-8985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B13785961B
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 10:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 290CD1C21312
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 09:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FBC1CD0A;
	Sun, 18 Feb 2024 09:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y8xwqYBo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF66112E61;
	Sun, 18 Feb 2024 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708249913; cv=none; b=LGkYCqxSP4ammdvNhdgwvQAnXVmSb3Mq3szDBgd4a573/Y06nNtb+CMBMh1laz6rHBNCpaHULZGubTIim4Vnz2Jl1iqJ2H6WW5bvsf41ZCadqiz0gfZ+AXm/yZM1nbOfdkTwgHg6ULTUuBPCj0LhuUV88WKDEMbBheDE5C0Byhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708249913; c=relaxed/simple;
	bh=jHjHvEjAA/RhoLWSIKDlWeb7THxIVIJEBNEhkFgNP70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aYJAKPPyA5d5WSDhn/KIlBW161Stk/tYLM0XeSwvUEXihvd/SU62hnTvcR2zFIaKRVPM+ik/Pk+ZyL0qQT5t7B2eJlHguDNoiEs4bmEjOYVjpU36p0PswXq3gjBOO+SNP9nH/Tx5o6n5eF4JCycge8cA8VWiD6BFX9iWRshAYmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y8xwqYBo; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6e2db19761fso1649323a34.1;
        Sun, 18 Feb 2024 01:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708249911; x=1708854711; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/JuFlw0+x8wXUHToJkVUHN6ReDOJkSSSekYTFPFk/Jg=;
        b=Y8xwqYBo0ki3T04TSKNHC/+pwgi5jYpc8BVhEbC4wE9kopdxpJU+fuQrFrBXHc8TWp
         iVPslY8uBT860C9Eu3gJwf3wQnM0qXUcyHCKXYLeRjudeUkxmyXqrJVHF2dxYQfV0JOF
         sCpZp4lhlePddnG/37R5ov+aP4QemYfiHQEuAhfcWlXGAMmeHD3m/zFymkMfQkvVwrqn
         VN1ccl22t/SXKp29EFE/rEaEJLEE0ykNPvAKyYKUXQjMGDx/Nq9iIqdpmd84BJ4NfW0W
         QBDt7vEDiYmzApGzP972su+/6nHbErK2wyV93uRj4NNsVqPgui9i3MNaiQ9QBDrMJTKH
         SdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708249911; x=1708854711;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/JuFlw0+x8wXUHToJkVUHN6ReDOJkSSSekYTFPFk/Jg=;
        b=tx7FdwFT4sdayJp4MR79n2wJnGb1PePvQZhHiU5RNezHa82uQTIWLZo98q4rDEovIj
         4SnStniXSMprFRB45nk+54AEv57DHNpCfyl1pqEBisDMsA6XGPwLZz6xKShn7qYGjYbK
         uPA4c5a13hXqBsAqD5tHrZwk1SCSOSJVAZPlb2lwpEPi+cVRg/cLY5bWujkLqXvGDIX3
         UcP5wcyghEh7s0nBBC/LQjH99jY7MDyKt8iBl0tVXA2+ay/OalKEDt5tu7FtxgdEENni
         TldfylB8z9s0CEph2HuvpNgp84A+tDPNGGISvjdco7ului+bLN2j84QyMgjf5XUE0u7a
         86Uw==
X-Forwarded-Encrypted: i=1; AJvYcCWR1WhID1+tgAfcmY1I3lTln3E9tREWV43xDw2Xw1LIiQnjn98xw0LHmSawfKWIXfMswhJihwwIshzJlO6m/4pqvHnGLEc53xaxBx8MmCrfWO5i8ktrUjg4Lp9aZNKu2lyu
X-Gm-Message-State: AOJu0Yy+hNh8/Ak7ZJ/x8grOF0PSTvtQz82uDKVTO933wwecOnxpkWzY
	rqJRbBAYXc4+RbzwMgx2uVqk+XANRSEeLQcAWHFQOcO3W97FoM/3
X-Google-Smtp-Source: AGHT+IFRnCiBoZY/IJLiyHv/jUKntft7MLsa6+sZ+FzMAjX3sVpz7axj62k3ebNbjpxlqEoSlyLAPA==
X-Received: by 2002:a9d:7ad7:0:b0:6e2:eb00:7551 with SMTP id m23-20020a9d7ad7000000b006e2eb007551mr10040684otn.21.1708249910880;
        Sun, 18 Feb 2024 01:51:50 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.22])
        by smtp.gmail.com with ESMTPSA id c11-20020aa781cb000000b006e0322f072asm2742266pfn.35.2024.02.18.01.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Feb 2024 01:51:50 -0800 (PST)
Message-ID: <585a36d2-6e46-44a0-8224-8d4cd54d0dd3@gmail.com>
Date: Sun, 18 Feb 2024 17:51:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andi Kleen <ak@linux.intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231206032054.55070-1-likexu@tencent.com>
 <ZcKKwSi7FdbSnexE@google.com> <ZcKf3RvyoVJ77sUQ@google.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZcKf3RvyoVJ77sUQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/2024 5:08 am, Sean Christopherson wrote:
> On Tue, Feb 06, 2024, Sean Christopherson wrote:
>> +Oliver
>>
>> On Wed, Dec 06, 2023, Like Xu wrote:
>>> Note that when vm-exit is indeed triggered by PMI and before HANDLING_NMI
>>> is cleared, it's also still possible that another PMI is generated on host.
>>> Also for perf/core timer mode, the false positives are still possible since
>>> that non-NMI sources of interrupts are not always being used by perf/core.
>>> In both cases above, perf/core should correctly distinguish between real
>>> RIP sources or even need to generate two samples, belonging to host and
>>> guest separately, but that's perf/core's story for interested warriors.
>>
>> Oliver has a patch[*] that he promised he would send "soon" (wink wink) to
>> properly fix events that are configured to exclude the guest.  Unless someone
>> objects, I'm going to tweak the last part of the changelog to be:
>>
>>      Note that when VM-exit is indeed triggered by PMI and before HANDLING_NMI
>>      is cleared, it's also still possible that another PMI is generated on host.
>>      Also for perf/core timer mode, the false positives are still possible since
>>      that non-NMI sources of interrupts are not always being used by perf/core.
>>      
>>      For events that are host-only, perf/core can and should eliminate false
>>      positives by checking event->attr.exclude_guest, i.e. events that are
>>      configured to exclude KVM guests should never fire in the guest.
>>      
>>      Events that are configured to count host and guest are trickier, perhaps
>>      impossible to handle with 100% accuracy?  And regardless of what accuracy
>>      is provided by perf/core, improving KVM's accuracy is cheap and easy, with
>>      no real downsides.
> 
> Never mind, this causes KUT's pmu_pebs test to fail:
> 
>    FAIL: Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x1): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x2): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x4): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x1f000008): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: GP counter 0 (0xfffffffffffe): No OVF irq, none PEBS records.
>    FAIL: Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x1): GP counter 0 (0xfffffffffffe): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x1): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x2): GP counter 0 (0xfffffffffffe): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x2): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x4): GP counter 0 (0xfffffffffffe): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x4): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x1f000008): GP counter 0 (0xfffffffffffe): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x1f000008): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x1): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x2): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x4): Multiple (0x700000055): No OVF irq, none PEBS records.
>    FAIL: Adaptive (0x1f000008): Multiple (0x700000055): No OVF irq, none PEBS records.
> 
> It might be a test bug, but I have neither the time nor the inclination to
> investigate.

For PEBS ovf case, we have "in_nmi() = 0x100000" from the core kernel and
the following diff fixes the issue:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 995760ba072f..dcf665251fce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1891,7 +1891,7 @@ enum kvm_intr_type {
  /* Enable perf NMI and timer modes to work, and minimise false positives. */
  #define kvm_arch_pmi_in_guest(vcpu) \
  	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
-	 (in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
+	 (!!in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))

  void __init kvm_mmu_x86_module_init(void);
  int kvm_mmu_vendor_module_init(void);

, does it help (tests passed on ICX) ?

> 
> 
> Like,
> 
> If you want any chance of your patches going anywhere but my trash folder, you
> need to change your upstream workflow to actually run tests.  I would give most
> people the benefit of the doubt, e.g. assume they didn't have the requisite
> hardware, or didn't realize which tests would be relevant/important.  But this
> is a recurring problem, and you have been warned, multiple times.

Sorry, my CI resources are diverted to other downstream projects.
But there's no doubt it's my fault and this behavior will be corrected.

