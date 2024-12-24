Return-Path: <kvm+bounces-34361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7DF09FBFD2
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 16:53:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30A3D165C95
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 15:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC911D89E5;
	Tue, 24 Dec 2024 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VfhuQd5F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC83A1CDFBE
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735055624; cv=none; b=WngprBlJa+TzbhWvPqBwgXogS/9M4d/DAjfURv1r6NWGNhkGwQrVpvRZS58dIhbf4LF6UwNh2lpB2dBgXCdeIxyu7jDb/6Ypbx3dJJgFGl/r1xL1JleX7G68zj5ZQ0O065sVBt+xSvy8I0P7LE5URKAmTC4OVPBmy45yZ7kgncU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735055624; c=relaxed/simple;
	bh=HYZ7hP9NTN5X0igQ0C+hlitkL1EermLuoCf0M9OAlUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r2G2aLQjWT4BXdgdSGcCmevUSRNgcZYQxBi6X55hsLruBL40zCHllqYKTP3RN+11d3b8nhgT+YsS1mj5kR/VbYRjqm691i3Qojr/AC2+ctzi4SNLU4y6/QkOmTpRdV9nQEs4c9sCZau6SMQWK802jBqnZ+j3QcJxpoX676/nni4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VfhuQd5F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735055621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rpwUlF2+hfvdP8OnbqhutbLTrztQBNU9uyxVoaDuj+0=;
	b=VfhuQd5FNS/dEfpXkT5dmMuJ41FRuUMrpTly8xIVPsQLubx4j+ZFuDavslz5hfe2wCzGD9
	p/s+1+CJdqHZ2kmoE1Gp3FA/u+kH68OGBm7wmGdfvba7/h7mOq91qZi55jJk7zGtvQ932p
	FuRbtCLhxfi/uKXTAywjs0NEPVq6sLo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-JyANjT67M_mmEL-20PwOPQ-1; Tue, 24 Dec 2024 10:53:40 -0500
X-MC-Unique: JyANjT67M_mmEL-20PwOPQ-1
X-Mimecast-MFC-AGG-ID: JyANjT67M_mmEL-20PwOPQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e9c69929so2199603f8f.1
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 07:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735055619; x=1735660419;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rpwUlF2+hfvdP8OnbqhutbLTrztQBNU9uyxVoaDuj+0=;
        b=llfE3QM10cGIhsvcAWgKFifZGSMna2K46XzSoV8PdhjwsJH2Vty/8vtn3i/vp7q7Cb
         nb/wle+4wGnXLlUnLZeKpLK+lcCpqn+GHoMLWp8KHHUJfojBieywLCPAWICAuXXyJBC5
         l3Y6j1fcScopa+gZGPczfvgNkMIFH2wRgXat1wgBCEt+GS9VOkDwyk6TJpFFk8clWfzN
         DRcvf3yDtzBc8nX0uOO0FfnJASC8b0kvvMrK09sN/5HNVX6CMUt7yhhWJSwo/mHr9T3d
         U64DDlGwvmfS8402+CdrnETmlPImbDfZ6/uDtOROis0NVRV4QQaTLv7uexgjYF/xdI2l
         BOrg==
X-Forwarded-Encrypted: i=1; AJvYcCVDrvgvBQ3xW0/UjTAg1dk9BkctjcrTnl6cKK5GRS6Yzy/08gBJmhY6Ee/t47DSVXwCFF8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPYeMfpoAuMC1Z6b/oMOv+WwBkrncN6pytjTPO4JtAwO1NdfOY
	DToQrVMt04Xj+QuJrY1HUCbKb3dxeScvkik1FfXsrNTA57o21puh8r1BUifmBzeWOj9tWmTkhJt
	/QOAK2YQ0dlc/HhcIYztGJtWfGgDXe1YQ3OXdrVUbEv1THReFpA==
X-Gm-Gg: ASbGnctt6gIkHjnr9gyOFqI7pQMBZPqCTFSB+J7XssP0zG3ce+o3mF1kdkE7+DHzCr1
	JQHM9KW6iQCYyA4NEEXyBf3SCI2fD7sVd0ViBDqDtYdO0gD5vXGOaphgYCZQA5ArCBqi8uwtE9v
	rJpymYhRCh9db2rX8kZR1D/DOrsbF5s1bQrtl2/bzQjMzWue08XGXlsjbNLFCklNJlYAaRgAfg3
	PSQU5bpcRwNa4DH6Bg1AdsSvsqY+s3lETPSpXGxNJkQ1/V/AK3La/YunI5I
X-Received: by 2002:a05:6000:4a0a:b0:385:ef39:6ce9 with SMTP id ffacd0b85a97d-38a221f1716mr17022025f8f.21.1735055619026;
        Tue, 24 Dec 2024 07:53:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFy9XW2NulrQYqV0MVeF/XsUmbOaFu2z92cG6Vt4kGG5ZVAIDbCB38c22EYDJB0tagRQEFq8A==
X-Received: by 2002:a05:6000:4a0a:b0:385:ef39:6ce9 with SMTP id ffacd0b85a97d-38a221f1716mr17022007f8f.21.1735055618638;
        Tue, 24 Dec 2024 07:53:38 -0800 (PST)
Received: from [192.168.10.27] ([151.62.105.73])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c8acc02sm14301906f8f.104.2024.12.24.07.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 07:53:38 -0800 (PST)
Message-ID: <ff866f4c-766c-4637-ba73-bbbdd4b15a2c@redhat.com>
Date: Tue, 24 Dec 2024 16:53:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/11] target/i386/kvm: Clean up error handling in
 kvm_arch_init()
To: Zhao Liu <zhao1.liu@intel.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-11-zhao1.liu@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241106030728.553238-11-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 04:07, Zhao Liu wrote:
> Currently, there're following incorrect error handling cases in
> kvm_arch_init():
> * Missed to handle failure of kvm_get_supported_feature_msrs().
> * Missed to return when kvm_vm_enable_disable_exits() fails.

At least in these two cases I think it was intentional to avoid hard 
failures.  It's probably not a very likely case and I think your patch 
is overall a good idea.

Paolo

> * MSR filter related cases called exit() directly instead of returning
>    to kvm_init(). (The caller of kvm_arch_init() - kvm_init() - needs to
>    know if kvm_arch_init() fails in order to perform cleanup).
> 
> Fix the above cases.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Zide Chen <zide.chen@intel.com>
> ---
> v5: cleaned up kvm_vm_enable_energy_msrs().
> v3: new commit.
> ---
>   target/i386/kvm/kvm.c | 25 ++++++++++++++++---------
>   1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 69825b53b6da..013c0359acbe 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3147,7 +3147,7 @@ static int kvm_vm_enable_userspace_msr(KVMState *s)
>       return 0;
>   }
>   
> -static void kvm_vm_enable_energy_msrs(KVMState *s)
> +static int kvm_vm_enable_energy_msrs(KVMState *s)
>   {
>       int ret;
>   
> @@ -3157,7 +3157,7 @@ static void kvm_vm_enable_energy_msrs(KVMState *s)
>           if (ret < 0) {
>               error_report("Could not install MSR_RAPL_POWER_UNIT handler: %s",
>                            strerror(-ret));
> -            exit(1);
> +            return ret;
>           }
>   
>           ret = kvm_filter_msr(s, MSR_PKG_POWER_LIMIT,
> @@ -3165,7 +3165,7 @@ static void kvm_vm_enable_energy_msrs(KVMState *s)
>           if (ret < 0) {
>               error_report("Could not install MSR_PKG_POWER_LIMIT handler: %s",
>                            strerror(-ret));
> -            exit(1);
> +            return ret;
>           }
>   
>           ret = kvm_filter_msr(s, MSR_PKG_POWER_INFO,
> @@ -3173,17 +3173,17 @@ static void kvm_vm_enable_energy_msrs(KVMState *s)
>           if (ret < 0) {
>               error_report("Could not install MSR_PKG_POWER_INFO handler: %s",
>                            strerror(-ret));
> -            exit(1);
> +            return ret;
>           }
>           ret = kvm_filter_msr(s, MSR_PKG_ENERGY_STATUS,
>                                kvm_rdmsr_pkg_energy_status, NULL);
>           if (ret < 0) {
>               error_report("Could not install MSR_PKG_ENERGY_STATUS handler: %s",
>                            strerror(-ret));
> -            exit(1);
> +            return ret;
>           }
>       }
> -    return;
> +    return 0;
>   }
>   
>   int kvm_arch_init(MachineState *ms, KVMState *s)
> @@ -3250,7 +3250,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           return ret;
>       }
>   
> -    kvm_get_supported_feature_msrs(s);
> +    ret = kvm_get_supported_feature_msrs(s);
> +    if (ret < 0) {
> +        return ret;
> +    }
>   
>       uname(&utsname);
>       lm_capable_kernel = strcmp(utsname.machine, "x86_64") == 0;
> @@ -3286,6 +3289,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           if (ret < 0) {
>               error_report("kvm: guest stopping CPU not supported: %s",
>                            strerror(-ret));
> +            return ret;
>           }
>       }
>   
> @@ -3317,12 +3321,15 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>   
>           if (s->msr_energy.enable == true) {
> -            kvm_vm_enable_energy_msrs(s);
> +            ret = kvm_vm_enable_energy_msrs(s);
> +            if (ret < 0) {
> +                return ret;
> +            }
>   
>               ret = kvm_msr_energy_thread_init(s, ms);
>               if (ret < 0) {
>                   error_report("kvm : error RAPL feature requirement not met");
> -                exit(1);
> +                return ret;
>               }
>           }
>       }


