Return-Path: <kvm+bounces-7174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C4C83DCDF
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:58:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C99BA1F22826
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E375F1CA96;
	Fri, 26 Jan 2024 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dQlxVfmJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC721B963
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706281097; cv=none; b=jDTPWNDRssGKOAqYwSV3THdf1LOe9imjcBXIezp1/RqNP7HKEFFN/8YKoHrZXQ8KW5aiWUgdUzRUYj//ZWHwD/xfF8KtQah36bdOu2uiVOY4qOzvNYUSUgOwXrSWMplURFp3CBD5TCJ3MHwzO8zYh6oD76PuLVQIEshA8ohaQ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706281097; c=relaxed/simple;
	bh=7uE4uGoKVUgvlnPnLQf6zA8SWoG6b+rnHlSWFJLDayI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=faNPZYNaq5x/22ijvqoml7DbMoJM8VHQqoJxrUN9GdVT1xncU6lCZatGwfEJaBN9xhrqVJ2QCaA56PdeqiEDON2TG0QDRyYpC8T0ixBzdGyQB1Htu7sJm6LWXr2MtVX4N/asRSEX+U17sk97svjDcugquPt4XX4+332TTLOS9ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dQlxVfmJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706281094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UiMCoKLwNFlZXmg0/26CoeZ6ykuGiB8pBUG69g8yN6o=;
	b=dQlxVfmJOHPuDyJHABMuCwCW8cKnSpb2bQjgAOUbcu0dRBzDxhwW11/XavVModTHfTAIaL
	9hS+HGJTZoT6WLwNbhTQfoEoWM3e10xbmlljrMwtho0bZZixG7BD3Pf69rHFuAIRW9xxTK
	rllwLkIOrxCjAON6p+IMYWmn2ETKFag=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-l2izabhXPNaLIVe_EQJ4RQ-1; Fri, 26 Jan 2024 09:58:12 -0500
X-MC-Unique: l2izabhXPNaLIVe_EQJ4RQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3392c5e6dcdso773039f8f.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 06:58:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706281092; x=1706885892;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UiMCoKLwNFlZXmg0/26CoeZ6ykuGiB8pBUG69g8yN6o=;
        b=sdXY+gHdh7uazoSvOyLLMejJVqAXCUJx1TQKQb5K27szbPHj71tG2qKFWp3yqWRrXK
         c3KzzPUgmzEZ4kJSteovkxnzkqGLyN++o8AC4jwWl3yGXlmL8jl0+v7O2lFNC7C+jN8G
         18Qz1Ao9aaKfo1/CivCWkaJRUVLS6v0rinqdmKkVQ15zAxl2TRoGYYAgLccUhTDuFAtF
         mj0HfsRO0PLFPlZ7faA/kz0QZVGVNAk21bhOQgfYngzeC4sQejo2dEYJJ7+vr+fK3+v6
         JM7OjtUIL8ZRewk/GDJnFW7cNk5IcIJ1T2aEP0FV7dDn7xYZfwSgwaN0xdn7hUOpGwI+
         cNUQ==
X-Gm-Message-State: AOJu0YxrCObU8Lw0d5UbqTys3z3+hXZXdvgH2jwHe1aZIjzNMAP7trrF
	ra8Q1J683rlG9V2hXKU3Nv5maE5lT+7MzwsPFnUBfbqA3H2ger47Dry1Q0Z/GmdF/Khjz4v5g8d
	LXHgBLpOF/LPN+ZZNyXQgdmQFYfq5kAYLdz0NPG2XpqPHJw5VEg==
X-Received: by 2002:a5d:4d4d:0:b0:337:d989:151b with SMTP id a13-20020a5d4d4d000000b00337d989151bmr666988wru.23.1706281091688;
        Fri, 26 Jan 2024 06:58:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQFRdIn65agjeL9w6CHxSKXBYk6Io9/rYTWq/PbX3qs8RyyCnz2Zx7IpSOyx5LtcWOT1Zo8w==
X-Received: by 2002:a5d:4d4d:0:b0:337:d989:151b with SMTP id a13-20020a5d4d4d000000b00337d989151bmr666971wru.23.1706281091291;
        Fri, 26 Jan 2024 06:58:11 -0800 (PST)
Received: from ?IPV6:2003:cb:c70a:5100:7e95:22ff:3f9b:1e92? (p200300cbc70a51007e9522ff3f9b1e92.dip0.t-ipconnect.de. [2003:cb:c70a:5100:7e95:22ff:3f9b:1e92])
        by smtp.gmail.com with ESMTPSA id n12-20020a5d51cc000000b003392a486758sm1420832wrv.99.2024.01.26.06.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 06:58:10 -0800 (PST)
Message-ID: <12d89ebd-3497-4e60-8900-7a7a1ffbd6e2@redhat.com>
Date: Fri, 26 Jan 2024 15:58:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 33/66] i386/tdx: Make memory type private by default
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-34-xiaoyao.li@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240125032328.2522472-34-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25.01.24 04:22, Xiaoyao Li wrote:
> By default (due to the recent UPM change), restricted memory attribute is
> shared.  Convert the memory region from shared to private at the memory
> slot creation time.
> 
> add kvm region registering function to check the flag
> and convert the region, and add memory listener to TDX guest code to set
> the flag to the possible memory region.
> 
> Without this patch
> - Secure-EPT violation on private area
> - KVM_MEMORY_FAULT EXIT (kvm -> qemu)
> - qemu converts the 4K page from shared to private
> - Resume VCPU execution
> - Secure-EPT violation again
> - KVM resolves EPT Violation
> This also prevents huge page because page conversion is done at 4K
> granularity.  Although it's possible to merge 4K private mapping into
> 2M large page, it slows guest boot.
> 
> With this patch
> - After memory slot creation, convert the region from private to shared
> - Secure-EPT violation on private area.
> - KVM resolves EPT Violation
> 
> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   include/exec/memory.h |  1 +
>   target/i386/kvm/tdx.c | 20 ++++++++++++++++++++
>   2 files changed, 21 insertions(+)
> 
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 7229fcc0415f..f25959f6d30f 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -850,6 +850,7 @@ struct IOMMUMemoryRegion {
>   #define MEMORY_LISTENER_PRIORITY_MIN            0
>   #define MEMORY_LISTENER_PRIORITY_ACCEL          10
>   #define MEMORY_LISTENER_PRIORITY_DEV_BACKEND    10
> +#define MEMORY_LISTENER_PRIORITY_ACCEL_HIGH     20
>   
>   /**
>    * struct MemoryListener: callbacks structure for updates to the physical memory map
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 7b250d80bc1d..f892551821ce 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -19,6 +19,7 @@
>   #include "standard-headers/asm-x86/kvm_para.h"
>   #include "sysemu/kvm.h"
>   #include "sysemu/sysemu.h"
> +#include "exec/address-spaces.h"
>   
>   #include "hw/i386/x86.h"
>   #include "kvm_i386.h"
> @@ -621,6 +622,19 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>       return 0;
>   }
>   
> +static void tdx_guest_region_add(MemoryListener *listener,
> +                                 MemoryRegionSection *section)
> +{
> +    memory_region_set_default_private(section->mr);
> +}

That looks fishy. Why is TDX to decide what happens to other memory 
regions it doesn't own?

We should define that behavior when creating these memory region, and 
TDX could sanity check that they have been setup properly.

Let me ask differently: For which memory region where we have 
RAM_GUEST_MEMFD set would we *not* want to set private as default right 
from the start?

-- 
Cheers,

David / dhildenb


