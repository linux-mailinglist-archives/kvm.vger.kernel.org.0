Return-Path: <kvm+bounces-23684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 005FA94CC5F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 10:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CDE3B24F20
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 08:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A68918FDD0;
	Fri,  9 Aug 2024 08:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q7Jaxm49"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4868118E05C
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 08:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723192565; cv=none; b=qBjS9t/PO/jOtB/WnZMwhIHrGKpoaRm4iJvDtOhwfpi2YgnN3k6AfFY3iND/53Qoozd6n0tUyocVENif+S8hp6ltB8ZnBkZu4Wk/dnCxRIW+SRrQFter26++xMwsD6wIYQYbMPzJgmfDdFlTAK0W9QXaL2YvjWXqiE81UbY7Dtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723192565; c=relaxed/simple;
	bh=Ny5F9426Jn13U9Y6S4ojrazmy84wbDgbVFRfNFm4xeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LhkglLj4P2IWJmw4+xnhyKcqUHGd6FQp0pa/SBY0u2o4DyKbZT3+I+8ohAWgm6qyMJNnc746T2pHGR6dG7bfD4Q7tuhv02pJ8UjPYQzGjmDqwKIii6I3WeU34OYtptqmGcuTkTPKKofMko/k9LnHd5pd+mAaLll+9OrOVNOwzLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q7Jaxm49; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4257d5fc9b7so17366525e9.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 01:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723192562; x=1723797362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RmPnqqIvpdZM4vhUuidGITgg4c+/KkmwE6KbcUE8uOE=;
        b=q7Jaxm49XpbiB2rEWvhAKQrMBeVnikCtqc+zljwGI6KfKLkCVeg3NWHaPose2SK5SJ
         JqUqJphshgy3a3e0WxczkI+EpZMz6q0l44UFoRS39iXRoeNeNDSm+5bGJVJ1i6mkxS+I
         vHx1v98eXXjqqC0t2Y2hwKDpvl4i8fW87Ac959maknXmElq2WttdIp89jXdOzPXuha3S
         gHwp3xH5t1OiszYx+b3AFOYGoFD0A8pJd3ZLlgyElI4gY9EXXLzUyKSLPhyOJTy4ic4T
         PdjTsHSYnaE2JQwYnWYWJ+y4y+7fW5AVk21ZsJEXeK9AekCy7kpMx4Wzsk/occz3TRwh
         wQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723192562; x=1723797362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RmPnqqIvpdZM4vhUuidGITgg4c+/KkmwE6KbcUE8uOE=;
        b=XxX+oSUBE8ESN7P5rVZb7HVuBKEtdYY0xUPCXOQyrNZtDdhpIvKhd/afPhPXd+Bki1
         UdFMs0yhKS+yrpveaucWOxxmywPaAO8QRk2OK9ZQmj0XhuOduQDdve+AGW1m7Ron04yt
         jFANsTauA5FAdz0nT+fFnqBunLS9Z916dVZWhUECr2/uqXmdy/lK7Jh2EFwZMZe/zBGF
         8nq+AiDxWsc1zmX+NaAUuo3RlkrPFyRVKXE3vAB0ZdMeKrh1GtK+kkvJUYBtMD+AqyyW
         P/hiUUWY2yidMZw/fLzi9E4bxN7iS0dqidp6r3SyCS0zNWHeYt60TPpNYBxfPXzko5Ea
         8EMg==
X-Forwarded-Encrypted: i=1; AJvYcCUvc89orH6Csp6sBp5urkB8u2cC0nq7Rqp2RlgiZ6GV0AmbJ9ePHDM5uwhmtNH9RLOdUPJpLiJ9KJGzHQ4N11k9/qR7
X-Gm-Message-State: AOJu0Yy3Iwb7ylJKtzTqy0R47nzqaKk+zRXP6j3VB1jhc12c9ujEKYzC
	Ua6YLd0NXxbtf1BiLcO5lkAu+t1SsFvGN2H7NZCN9eaP4R0w3RyOV+M0+auy00o=
X-Google-Smtp-Source: AGHT+IEa3cisiuaD0zuqPELtHiYuT/1QmPpy3KQHu8b3fcyhdByakMcRk0FZJDOOY6bwpRsFOFsvvg==
X-Received: by 2002:a05:600c:a48:b0:428:fcb:962 with SMTP id 5b1f17b1804b1-429c3a5c30fmr6542285e9.36.1723192561442;
        Fri, 09 Aug 2024 01:36:01 -0700 (PDT)
Received: from [192.168.178.175] (41.red-95-127-42.staticip.rima-tde.net. [95.127.42.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429059714d5sm117810195e9.13.2024.08.09.01.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 01:36:01 -0700 (PDT)
Message-ID: <8913b8c7-4103-4f69-8567-afdc29f8d0d3@linaro.org>
Date: Fri, 9 Aug 2024 10:35:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] kvm: replace fprintf with error_report/printf() in
 kvm_init()
To: Ani Sinha <anisinha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-trivial@nongnu.org, zhao1.liu@intel.com, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, Markus Armbruster <armbru@redhat.com>
References: <20240809064940.1788169-1-anisinha@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240809064940.1788169-1-anisinha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ani,

On 9/8/24 08:49, Ani Sinha wrote:
> error_report() is more appropriate for error situations. Replace fprintf with
> error_report. Cosmetic. No functional change.
> 
> CC: qemu-trivial@nongnu.org
> CC: zhao1.liu@intel.com

(Pointless to carry Cc line when patch is already reviewed next line)

> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>   accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
>   1 file changed, 18 insertions(+), 22 deletions(-)
> 
> changelog:
> v2: fix a bug.
> v3: replace one instance of error_report() with error_printf(). added tags.
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 75d11a07b2..5bc9d35b61 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>       QLIST_INIT(&s->kvm_parked_vcpus);
>       s->fd = qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
>       if (s->fd == -1) {
> -        fprintf(stderr, "Could not access KVM kernel module: %m\n");
> +        error_report("Could not access KVM kernel module: %m");
>           ret = -errno;
>           goto err;
>       }
> @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
>           if (ret >= 0) {
>               ret = -EINVAL;
>           }
> -        fprintf(stderr, "kvm version too old\n");
> +        error_report("kvm version too old");
>           goto err;
>       }
>   
>       if (ret > KVM_API_VERSION) {
>           ret = -EINVAL;
> -        fprintf(stderr, "kvm version not supported\n");
> +        error_report("kvm version not supported");
>           goto err;
>       }
>   
> @@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
>       } while (ret == -EINTR);
>   
>       if (ret < 0) {
> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
> -                strerror(-ret));
> +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
> +                    strerror(-ret));
>   
>   #ifdef TARGET_S390X
>           if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "Host kernel setup problem detected. Please verify:\n");
> -            fprintf(stderr, "- for kernels supporting the switch_amode or"
> -                    " user_mode parameters, whether\n");
> -            fprintf(stderr,
> -                    "  user space is running in primary address space\n");
> -            fprintf(stderr,
> -                    "- for kernels supporting the vm.allocate_pgste sysctl, "
> -                    "whether it is enabled\n");
> +            error_report("Host kernel setup problem detected.

\n"

Should we use error_printf_unless_qmp() for the following?

" Please verify:");
> +            error_report("- for kernels supporting the switch_amode or"
> +                        " user_mode parameters, whether");
> +            error_report("  user space is running in primary address space");
> +            error_report("- for kernels supporting the vm.allocate_pgste "
> +                        "sysctl, whether it is enabled");
>           }
>   #elif defined(TARGET_PPC)
>           if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "PPC KVM module is not loaded.

\n"

Ditto.

" Try modprobe kvm_%s.\n",
> -                    (type == 2) ? "pr" : "hv");
> +            error_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
> +                        (type == 2) ? "pr" : "hv");
>           }
>   #endif
>           goto err;
> @@ -2526,9 +2522,9 @@ static int kvm_init(MachineState *ms)
>                           nc->name, nc->num, soft_vcpus_limit);
>   
>               if (nc->num > hard_vcpus_limit) {
> -                fprintf(stderr, "Number of %s cpus requested (%d) exceeds "
> -                        "the maximum cpus supported by KVM (%d)\n",
> -                        nc->name, nc->num, hard_vcpus_limit);
> +                error_report("Number of %s cpus requested (%d) exceeds "
> +                             "the maximum cpus supported by KVM (%d)",
> +                             nc->name, nc->num, hard_vcpus_limit);
>                   exit(1);
>               }
>           }
> @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
>       }
>       if (missing_cap) {
>           ret = -EINVAL;
> -        fprintf(stderr, "kvm does not support %s\n%s",
> -                missing_cap->name, upgrade_note);
> +        error_printf("kvm does not support %s\n%s",
> +                     missing_cap->name, upgrade_note);

Similarly, should we print upgrade_note using error_printf_unless_qmp?

>           goto err;
>       }
>   


