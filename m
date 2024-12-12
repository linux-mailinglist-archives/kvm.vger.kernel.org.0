Return-Path: <kvm+bounces-33634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 696699EF038
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 17:26:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 809CD16A125
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 16:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA9C22EA07;
	Thu, 12 Dec 2024 16:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="amPRM8fh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C531622E9FB
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 16:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019446; cv=none; b=bdh/LZavRhSh2oXkUOaW9JrLT69356p3QNNhIm+DEBJNuK03zZPXMdsNLPOj4oz2H3dGY9nJF17qQmb8qHVLo9gM+5OygMPfjiwjuuRwViE2rbdzgttzLd+5ZDt/anSr7r6ERlboxDKVw7XiukT47ksF0xdSHdLkXumNIGPikQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019446; c=relaxed/simple;
	bh=pJc+2qM5Sq7Cg/gdJjgXhLcWJdjJfJo13FssK4YlO9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=coXtMxkWUd82xPcle8EHHYGr91I68eYd0rg3pFFHmM5OHdcghTHKM3VkIMOOdaVxbyVn6Qjn23+vwcy22pclhXF309e9r3Ip6pOLJCrOpvrkbOZ/pb5b/qQyQdMIvYRQiQ6gzJksypQ8gS5zlKVFBkbLjXzjbyKewsR92iaO6OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=amPRM8fh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734019440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=O2FeCasfTCDWNjup0wvu4++3ookbsXZ8av7Z7qJZrMY=;
	b=amPRM8fhD574qOnAAarBAYJwHg3tdTDQIC3+k321wmGN1GuJKFqsgyczqWmE5N316s2BGC
	aeOd76+0QLC1pp+u/Gt9P/dbkJ6a+j8nOS2eNU2L3FpSo6e53ZA+K/hdIFefGtSZMSYnR3
	k7CtFu6eW1osoDPo5nWqIGtoHF41OAY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-EQmWxc3KNXWrwVXccjybNg-1; Thu, 12 Dec 2024 11:03:59 -0500
X-MC-Unique: EQmWxc3KNXWrwVXccjybNg-1
X-Mimecast-MFC-AGG-ID: EQmWxc3KNXWrwVXccjybNg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361ac8b25fso4984865e9.2
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 08:03:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734019438; x=1734624238;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O2FeCasfTCDWNjup0wvu4++3ookbsXZ8av7Z7qJZrMY=;
        b=kPOnBRPf4UUFzh/MLB8RfduQ/KARQ17EQmmJphX/yZvc+DU05xmnx6WcvPONQ3uOHL
         iMOL8HxVoqXXFuwHwlKcU4kKdRVE5rW6LuaKWMYgKGsO8rQKKdI5LCcMCQlNV63Vuxzw
         Qimrl8XET1TIRIgLHrt6j4NqppnCxnqjmMRZ2ZfAVykDyZ72fXtcW7+Jn8Bo9vjdSFkb
         ZmgnXdZbOcPciz+bgH9nnKqAudsqpGc7fT0PCBfJXj5xBi4rhH7WviSluMQHn9gLQn85
         pMbAcA2i9/SI4ogwzQu+sQ9LlxrDGTw8ReGaJunAFoI+Wk8AkPltkXSEX72A7bxEOKEz
         yAcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtyLx19/8xHUWeK2SCVZ7vBzSgUA8qtLSTsXrcu3K4aXHdoSN0CCEUzmmcVnYi8PvJn/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqkAB+F+0ca5c56gX45tgld6R3W23kxJP8/e9AmaPu1Q1LsweP
	7ll8Wl2XaLkoGkRGPaoXa+LtQaTeFkl40hrLIsAQ7HR+FiU8fjIzAmZugkSE39jqlIRuPtfgL9O
	ar0VF84Je/hGzsu+5H07nZMFus6pAncRYI2IVclx99tFR8Rh26w==
X-Gm-Gg: ASbGncsLDdJK0kD+dQmfnW8CQFug8zbFiBtPNCUeSqOepO5zlRtMLj6YfVT+NglEPES
	YCF9CeXYnHc/bwnH3JncOQCpNieDF/Y0i54soFBh6XVBN16NxDiW1l1NgXLp5O8ujOTXJDw5kkF
	ZHwrzYOXQCg6PGaZpGj/1RemaRQ8uTjRj/dx4B++ARXtkSYThOJHvMKFRe/jlxFMxlteZ97byG7
	5lgzO6CUo+DfLzWm1yWNFXEB7aRKQ7IjOXRlwAao76NTkXQElwEzumGhjVP
X-Received: by 2002:a05:600c:1d15:b0:434:9e1d:7626 with SMTP id 5b1f17b1804b1-4362285f785mr31423205e9.25.1734019436608;
        Thu, 12 Dec 2024 08:03:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEGNuUDavo2N97B2FMW5UKpbHf0RFUutY5rTGY18bxlvfv4bGoqwSTNNV0Sa0WrOYgeMBL3Kw==
X-Received: by 2002:a05:600c:1d15:b0:434:9e1d:7626 with SMTP id 5b1f17b1804b1-4362285f785mr31420475e9.25.1734019433975;
        Thu, 12 Dec 2024 08:03:53 -0800 (PST)
Received: from [192.168.10.27] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43625550518sm20682295e9.5.2024.12.12.08.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 08:03:53 -0800 (PST)
Message-ID: <1a5e2988-9a7d-4415-86ad-8a7a98dbc5eb@redhat.com>
Date: Thu, 12 Dec 2024 17:03:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Set return value after handling
 KVM_EXIT_HYPERCALL
To: Zhao Liu <zhao1.liu@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Cc: xiaoyao.li@intel.com, qemu-devel@nongnu.org, seanjc@google.com,
 michael.roth@amd.com, rick.p.edgecombe@intel.com, isaku.yamahata@intel.com,
 farrah.chen@intel.com, kvm@vger.kernel.org
References: <20241212032628.475976-1-binbin.wu@linux.intel.com>
 <Z1qZygKqvjIfpOXD@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z1qZygKqvjIfpOXD@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 09:07, Zhao Liu wrote:
> On Thu, Dec 12, 2024 at 11:26:28AM +0800, Binbin Wu wrote:
>> Date: Thu, 12 Dec 2024 11:26:28 +0800
>> From: Binbin Wu <binbin.wu@linux.intel.com>
>> Subject: [PATCH] i386/kvm: Set return value after handling
>>   KVM_EXIT_HYPERCALL
>> X-Mailer: git-send-email 2.46.0
>>
>> Userspace should set the ret field of hypercall after handling
>> KVM_EXIT_HYPERCALL.  Otherwise, a stale value could be returned to KVM.
>>
>> Fixes: 47e76d03b15 ("i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE")
>> Reported-by: Farrah Chen <farrah.chen@intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Tested-by: Farrah Chen <farrah.chen@intel.com>
>> ---
>> To test the TDX code in kvm-coco-queue, please apply the patch to the QEMU,
>> otherwise, TDX guest boot could fail.
>> A matching QEMU tree including this patch is here:
>> https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu-upstream-v6.1-fix_kvm_hypercall_return_value
>>
>> Previously, the issue was not triggered because no one would modify the ret
>> value. But with the refactor patch for __kvm_emulate_hypercall() in KVM,
>> https://lore.kernel.org/kvm/20241128004344.4072099-7-seanjc@google.com/, the
>> value could be modified.
> 
> Could you explain the specific reasons here in detail? It would be
> helpful with debugging or reproducing the issue.
> 
>> ---
>>   target/i386/kvm/kvm.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 8e17942c3b..4bcccb48d1 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -6005,10 +6005,14 @@ static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
>>   
>>   static int kvm_handle_hypercall(struct kvm_run *run)
>>   {
>> +    int ret = -EINVAL;
>> +
>>       if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
>> -        return kvm_handle_hc_map_gpa_range(run);
>> +        ret = kvm_handle_hc_map_gpa_range(run);
>> +
>> +    run->hypercall.ret = ret;
> 
> ret may be negative but hypercall.ret is u64. Do we need to set it to
> -ret?

If ret is less than zero, will stop the VM anyway as
RUN_STATE_INTERNAL_ERROR.

If this has to be fixed in QEMU, I think there's no need to set anything
if ret != 0; also because kvm_convert_memory() returns -1 on error and
that's not how the error would be passed to the guest.

However, I think the right fix should simply be this in KVM:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146f..e2118ba93ef6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10066,6 +10066,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
  		}
  
  		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
+		vcpu->run->ret                = 0;
  		vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
  		vcpu->run->hypercall.args[0]  = gpa;
  		vcpu->run->hypercall.args[1]  = npages;

While there is arguably a change in behavior of the kernel both with
the patches in kvm-coco-queue and with the above one, _in practice_
the above change is one that userspace will not notice.

Paolo

>> -    return -EINVAL;
>> +    return ret;
>>   }
>>   
>>   #define VMX_INVALID_GUEST_STATE 0x80000021
>>
>> base-commit: ae35f033b874c627d81d51070187fbf55f0bf1a7
>> -- 
>> 2.46.0
>>
>>


