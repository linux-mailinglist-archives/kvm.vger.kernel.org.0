Return-Path: <kvm+bounces-59441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D49BB4B6F
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 19:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9A467ADA24
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 17:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F342727EA;
	Thu,  2 Oct 2025 17:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IqnwB4Sr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3208B236A70
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759426734; cv=none; b=BPyPxCGwWhlow00Q0LutDNQIIwRQgmE79pUrvw8Ws7LFfqfJ0qImswpT5ICLxROS0UWZ7CtfqpIjzu9i/93ghdqo4W1GjMAyKpgBobAF4fmv5t4r+g1rL0RLVxrouatIHmnf5SxjJncaWFW9EoNCmPvkCLAGvjjVv3s7y7CUQbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759426734; c=relaxed/simple;
	bh=wrs/gJ/jh5JajI8A3qsgEnd/1PhG9BkN98YYml/K4oc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t9r4luy6bsaF/rULVfDbUxNi538KlvmYugqOMYWKSo9ELQxxX5pvKELvTZyspHKCqFyrreUkq77h4tW3LvPuB5z7cuUD2hnPDA8LdDFnb+F2qjO81zvuVqFVQkkbBcPqBary357WthlsgqrJ9zppH8nSPLXgAyQ3hFRD1MVswnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IqnwB4Sr; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-46e4f2696bdso16284305e9.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 10:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759426730; x=1760031530; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+V2wPuGfCio4QUFBc5XwSn82EF99kzO0rV5pMclAj8k=;
        b=IqnwB4SrATeq5dE8g1zEZMJxKQf4M1WmDpTCGaJ1tzSWCHiOHGnlBJelDXI/dXjBsi
         gKY7e2u2TQ5m905ceRzkoACNTvwYMylYNBOr6Sj23zbicR9aPFnwLmB0HMHLLYmrkY7e
         8rKU8ScfEn3r7i7/lFYJnR2rhz/aTVyGCQp1y/gorQT9zTrYPVq8CtJ5juSXqx71d/hl
         It5bi4Xg/tH43adVPEkgigtuNFl2bunYfpwKVzj8qX4eA63GDeXhKcWHhbh99JDG2Bn2
         6jewsNwZuBye7m0ENY91S2PqsOBRpOJLTJGVKpC6JEs+bPF02nSX+P7TV6D1r+HRNREZ
         YVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759426730; x=1760031530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+V2wPuGfCio4QUFBc5XwSn82EF99kzO0rV5pMclAj8k=;
        b=GKEnHtz5p0iot8ZyAp1ajCPq0+vF/tcbQt3yPXc0gsVERlhqDgQ9QX/0gWa69kLQrD
         teCaHRb3IGClI+Slp8DbmEpV4lkty2epvDoIGHvJNjWK3Qwybem8Mqg+9zL8P26UTqM5
         p4XnuuT6TAD9eXyPRyOsLf6oCQBem3u2A0NPU7JU+jsMfySZO5laKBV+6EV8jvYCjOIN
         XmLIP0FjUrvoaEkXjv4J9KivUXp06IBpOgbZMobdYiyyYDlj+2zPeYowa5W43a/5p2FT
         HQVijT6pigGqbxkZrpdJA/FfoK9xGSwLxOV/tioF3SY0EuJUnTCFCXb8TwspdKREwIlB
         uyww==
X-Forwarded-Encrypted: i=1; AJvYcCX8igP9DP00aK5YtuMJaKu1R3aMGSsg/wFpHNcmrPuWZ7k+qr/Z1dVSLxVxCbiqS4a6EZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YydR6UEFIp0YUmf9mVqxA0qYo01fpQyZuiG0wAQoEunFtoJks9b
	TAxhpWAkLeu//aVClcELIrpU61mTUjNTolvdjgU/lfnCj25Lr3WUGZ8p02/eSRAjre0=
X-Gm-Gg: ASbGncsjUWxLWIOwzmNOkH+AQRGOkAevRqG0N9EFV4C1iPMW9yqK/9eUiiA+V/sCcLN
	PEM7fjcIPs5k09orNAktOREqVGpPDfgsAXaD2VcLwa8SEay1ecK/njZY1u7UpOHcA9Xhf3EQjJj
	H8ynohOwWIBtSZsJItF0OW2dWBnnBOYhQDFc789WJbXWJN0usr5/zlB4+djtoPq5/MnJ1OqjK2l
	DcFmbpKoiKbXtgq9AeKugp2ToaB0N1+/tdaeRns6RmjHlVMyuRrq79Jx8r4SqqqJqGn9An2k5nk
	Xf4nwi6glJ8teqSiALoiZRHRmg8mHiIxmkSvNjPGnExcY8plNi2NMqvUpbq4AiRvzJ4+k7+3n4n
	dA4rzlpjqvENInw8GsQaWuRRN2pEp3rL6NoD83eW2vZC5S3SkkM3l5QoRvxesg/JtDmd+BAIEvv
	/tCNNdSVc7gdeaHnx1Eg==
X-Google-Smtp-Source: AGHT+IEzLXvjBFsflezIs0tpM1/mJV+Aj4RSV5J6Itd4MVihCEh67jQ9oba/kdfrPT1zTJ0LBEFfLg==
X-Received: by 2002:a05:6000:2203:b0:40f:288e:9990 with SMTP id ffacd0b85a97d-425671abae4mr77123f8f.48.1759426730275;
        Thu, 02 Oct 2025 10:38:50 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e97fbsm4401347f8f.34.2025.10.02.10.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 10:38:49 -0700 (PDT)
Message-ID: <cb828163-d23f-4a1c-b312-4ff24c4e02f1@linaro.org>
Date: Thu, 2 Oct 2025 19:38:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/18] hw: Remove unnecessary 'system/ram_addr.h'
 header
Content-Language: en-US
To: Harsh Prateek Bora <harshpb@linux.ibm.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Jagannathan Raman <jag.raman@oracle.com>, qemu-ppc@nongnu.org,
 Ilya Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Jason Herne <jjherne@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Fabiano Rosas <farosas@suse.de>, Eric Farman <farman@linux.ibm.com>,
 qemu-arm@nongnu.org, qemu-s390x@nongnu.org,
 David Hildenbrand <david@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>
References: <20251001175448.18933-1-philmd@linaro.org>
 <20251001175448.18933-7-philmd@linaro.org>
 <a8be844e-5f9d-478a-a96e-b76bfed9c764@linux.ibm.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <a8be844e-5f9d-478a-a96e-b76bfed9c764@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/10/25 17:59, Harsh Prateek Bora wrote:
> 
> 
> On 10/1/25 23:24, Philippe Mathieu-Daudé wrote:
>> None of these files require definition exposed by "system/ram_addr.h",
>> remove its inclusion.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> ---
>>   hw/ppc/spapr.c                    | 1 -
>>   hw/ppc/spapr_caps.c               | 1 -
>>   hw/ppc/spapr_pci.c                | 1 -
>>   hw/remote/memory.c                | 1 -
>>   hw/remote/proxy-memory-listener.c | 1 -
>>   hw/s390x/s390-virtio-ccw.c        | 1 -
>>   hw/vfio/spapr.c                   | 1 -
>>   hw/virtio/virtio-mem.c            | 1 -
>>   8 files changed, 8 deletions(-)
>>
>> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
>> index 82fb23beaa8..97ab6bebd25 100644
>> --- a/hw/ppc/spapr.c
>> +++ b/hw/ppc/spapr.c
>> @@ -77,7 +77,6 @@
>>   #include "hw/virtio/virtio-scsi.h"
>>   #include "hw/virtio/vhost-scsi-common.h"
>> -#include "system/ram_addr.h"
>>   #include "system/confidential-guest-support.h"
>>   #include "hw/usb.h"
>>   #include "qemu/config-file.h"
>> diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
>> index f2f5722d8ad..0f94c192fd4 100644
>> --- a/hw/ppc/spapr_caps.c
>> +++ b/hw/ppc/spapr_caps.c
>> @@ -27,7 +27,6 @@
>>   #include "qapi/error.h"
>>   #include "qapi/visitor.h"
>>   #include "system/hw_accel.h"
>> -#include "system/ram_addr.h"
>>   #include "target/ppc/cpu.h"
>>   #include "target/ppc/mmu-hash64.h"
>>   #include "cpu-models.h"
>> diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
>> index 1ac1185825e..f9095552e86 100644
>> --- a/hw/ppc/spapr_pci.c
>> +++ b/hw/ppc/spapr_pci.c
>> @@ -34,7 +34,6 @@
>>   #include "hw/pci/pci_host.h"
>>   #include "hw/ppc/spapr.h"
>>   #include "hw/pci-host/spapr.h"
>> -#include "system/ram_addr.h"
>>   #include <libfdt.h>
>>   #include "trace.h"
>>   #include "qemu/error-report.h"
> 
> I am seeing error while applying patch series:
> 
> harshpb:patches$ git log --oneline -n1
> 29b77c1a2d (HEAD -> review-20251002, upstream/master, master) Merge tag 
> 'rust-ci-pull-request' of https://gitlab.com/marcandre.lureau/qemu into 
> staging
> harshpb:patches$ git am ./ 
> v2_20251001_philmd_system_physmem_extract_api_out_of_system_ram_addr_h_header.mbx
> 
> 
> Applying: system/ram_addr: Remove unnecessary 'exec/cpu-common.h' header
> Applying: accel/kvm: Include missing 'exec/target_page.h' header
> Applying: hw/s390x/s390-stattrib: Include missing 'exec/target_page.h' 
> header
> Applying: hw/vfio/listener: Include missing 'exec/target_page.h' header
> Applying: target/arm/tcg/mte: Include missing 'exec/target_page.h' header
> Applying: hw: Remove unnecessary 'system/ram_addr.h' header
> Applying: system/physmem: Un-inline cpu_physical_memory_get_dirty_flag()
> Applying: system/physmem: Un-inline cpu_physical_memory_is_clean()
> Applying: system/physmem: Un-inline 
> cpu_physical_memory_range_includes_clean()
> Applying: system/physmem: Un-inline cpu_physical_memory_set_dirty_flag()
> Applying: system/physmem: Un-inline cpu_physical_memory_set_dirty_range()
> Applying: system/physmem: Remove _WIN32 #ifdef'ry
> Applying: system/physmem: Un-inline 
> cpu_physical_memory_set_dirty_lebitmap()
> Applying: system/physmem: Un-inline 
> cpu_physical_memory_dirty_bits_cleared()
> Applying: system/physmem: Reduce cpu_physical_memory_clear_dirty_range() 
> scope
> Applying: system/physmem: Reduce cpu_physical_memory_sync_dirty_bitmap() 
> scope
> Applying: system/physmem: Drop 'cpu_' prefix in Physical Memory API
> error: patch failed: hw/vfio/container.c:255
> error: hw/vfio/container.c: patch does not apply
> Patch failed at 0017 system/physmem: Drop 'cpu_' prefix in Physical 
> Memory API
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> harshpb:patches$
> 
> However, changes for ppc/spapr looks fine to me.

Sorry, I forgot the 'Based-on' tag on v1 and added it separately:
https://lore.kernel.org/qemu-devel/ef4baceb-671f-4afe-8a41-cafb89ea1707@linaro.org/
then forgot to add it again on v2 :/

> 
> Thanks
> Harsh



