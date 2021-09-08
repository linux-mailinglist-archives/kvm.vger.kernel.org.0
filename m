Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE3D40351D
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 09:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349253AbhIHHRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 03:17:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348375AbhIHHRr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 03:17:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631085398;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVcnxqH4ZqJw6GWyOzcoVHdPqx/ncSD3ywy2ZrdHJuQ=;
        b=KvbojsG32GyEWVEvaf63KxbUG+sut00DN+pkeB6b6QfltANjQHG+HQSMc4FteqNpCRV3GG
        nQPegm7w+pckl1qjsLTLEMRbZAEDYsdzEwSHz60iC0w+yeLFZR6xeIoaBz84ZPgCmtm6V9
        vsx0rtswVHUOOY5/6EMPNr+t6MqE1sA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-Zl16bDfiM0-h20-AGvbpLA-1; Wed, 08 Sep 2021 03:16:37 -0400
X-MC-Unique: Zl16bDfiM0-h20-AGvbpLA-1
Received: by mail-wm1-f69.google.com with SMTP id o20-20020a05600c379400b002e755735eedso524293wmr.0
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 00:16:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=QVcnxqH4ZqJw6GWyOzcoVHdPqx/ncSD3ywy2ZrdHJuQ=;
        b=Gat/sqpqiK+nL7VGQiJ5HMHBVaadP5pCjErQWQ8706Wfms1oq+yFQu6D4LMk3rerCF
         S04i7OcGAlgyGfeuCqL5EhqrkKsBWRL1OiT/Q4WrHyqyk3GbgU+O4PV913mMeYiyvpFv
         S7AvFbLw2AGukLX1qlSBOomLowxe/RWKUl8yyFwETzvd7Ob/GT9hix8YOfejkiZ/dJVa
         VskQu/fvLU4RVk4WJGqc3dsjHYvbZEMR029VtAL7pW66uAoZFJZx8RC4qgQzCLF2GK8z
         qz9zZDoDkk20xO76k3/YLP/dk4Hk68i3dAAS20QvqOvpZDljKxNu4lwItRFU0lUCnNbM
         CtGQ==
X-Gm-Message-State: AOAM530tlxq6QXcIrbUKnifPZGZFeMQ0MpxI2blb2Dj2wBrtrkO8lzdO
        P1ANBGpBkpX/CiOnTQ5EH86jkRyNPKYVlG76r7pvhkg++TfjEYiaoKX5smJU+4E+4gw4g4OTicl
        u5nSvmHRcVp50
X-Received: by 2002:a05:600c:3502:: with SMTP id h2mr2063429wmq.182.1631085396045;
        Wed, 08 Sep 2021 00:16:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwylCkktON4n0tuWNbSRxevfGzWWZe7Oajxrq8VSijl8FtjLV0eusWXE2xNxDIPwLnilJrmvw==
X-Received: by 2002:a05:600c:3502:: with SMTP id h2mr2063409wmq.182.1631085395846;
        Wed, 08 Sep 2021 00:16:35 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n14sm1213320wrx.10.2021.09.08.00.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 00:16:35 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 1/3] hw/arm/virt: KVM: Probe for KVM_CAP_ARM_VM_IPA_SIZE
 when creating scratch VM
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
References: <20210822144441.1290891-1-maz@kernel.org>
 <20210822144441.1290891-2-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <a38b75a7-4f75-e42c-5804-6115e5d52394@redhat.com>
Date:   Wed, 8 Sep 2021 09:16:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210822144441.1290891-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 8/22/21 4:44 PM, Marc Zyngier wrote:
> Although we probe for the IPA limits imposed by KVM (and the hardware)
> when computing the memory map, we still use the old style '0' when
> creating a scratch VM in kvm_arm_create_scratch_host_vcpu().
>
> On systems that are severely IPA challenged (such as the Apple M1),
> this results in a failure as KVM cannot use the default 40bit that
> '0' represents.
>
> Instead, probe for the extension and use the reported IPA limit
> if available.
>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  target/arm/kvm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index d8381ba224..cc3371a99b 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -70,12 +70,17 @@ bool kvm_arm_create_scratch_host_vcpu(const uint32_t *cpus_to_try,
>                                        struct kvm_vcpu_init *init)
>  {
>      int ret = 0, kvmfd = -1, vmfd = -1, cpufd = -1;
> +    int max_vm_pa_size;
>  
>      kvmfd = qemu_open_old("/dev/kvm", O_RDWR);
>      if (kvmfd < 0) {
>          goto err;
>      }
> -    vmfd = ioctl(kvmfd, KVM_CREATE_VM, 0);
> +    max_vm_pa_size = ioctl(kvmfd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE);
> +    if (max_vm_pa_size < 0) {
> +        max_vm_pa_size = 0;
> +    }
> +    vmfd = ioctl(kvmfd, KVM_CREATE_VM, max_vm_pa_size);
>      if (vmfd < 0) {
>          goto err;
>      }

