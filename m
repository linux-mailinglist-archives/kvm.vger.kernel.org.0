Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688BF3D2B72
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhGVRMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 13:12:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhGVRMH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 13:12:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626976361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6xP1fQO51T9rbjc3uyLaA5nbJ0QVtK1z6ySypVm5jHw=;
        b=bgsceQF65RMtShBDCgXsVm+nmWygmPNkX8+tPoBpTFG64mEINS3JzptTeEErb6e2sEcPEF
        Y1V2Y3XklE9y9mIianilGbGY3ZKjzhe9qYcc0cuAsxQPXMdBDQ3Y4g+8XsG2TrTR7p3xay
        D6knZdh1O6sPZNw2o7FOkEqwIdjBgqw=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-Udji69TnMbKKmfkS-aV5MA-1; Thu, 22 Jul 2021 13:52:37 -0400
X-MC-Unique: Udji69TnMbKKmfkS-aV5MA-1
Received: by mail-oi1-f199.google.com with SMTP id s24-20020a0568080b18b029025cbda427bbso1886582oij.5
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 10:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6xP1fQO51T9rbjc3uyLaA5nbJ0QVtK1z6ySypVm5jHw=;
        b=DRwIgi6RVRe+Zz1DdK8j6uLcz4fOegFLfL1ZXm5+dg/lJ8FO8SlqfEunpMo/fcDzcM
         LFyHczSqKzhseaSMZicHQm0uiZSpEYGiOaYUUXofg1M7HlroS1HrFua0eKJlLIEU0X4v
         soFbDMEv6ibG0q3NvPxs9q0UPdKZsQKLdVzBahvg2Ye/M7UjPTuw3K7kchPbGc/fcRHy
         +8982MXfIsXhiwKxq/yoa0ZJoERBIIaegfFlmqU/Y+yPISvUCBD3KeGHqr7bq2vqIzbG
         pB0cSfjm8dgRSbmRZUApDPVligLDCX31RMkYBf1VYCRxkOLrgVlBsdU8+K9pUQDF4B/1
         vPQQ==
X-Gm-Message-State: AOAM530OB/GrfYQNms3T90B82dtNXR5GA95SfFbv+O3lLxY+HHYh3SKr
        EnDo4KS4eEDg2QCpupuAJALSh7bbRE6t5FvFTeAqBdCt9aWamEpOZOqNIY3s2kdJPjRhqUhdKIb
        sEHgC4E/I6QlZIbf0Wr6k9paq1bck9+0y/eVskjarCVuLU5ugf+WI4KGL+ccflA==
X-Received: by 2002:a05:6830:91b:: with SMTP id v27mr614085ott.337.1626976356693;
        Thu, 22 Jul 2021 10:52:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+9pKEg/reu5tUbtic0HLiZ6i9qpLtI8ghgmTFbVHFC+qdtBXV1CIM8yzw+km4VeXwZ+UqXg==
X-Received: by 2002:a05:6830:91b:: with SMTP id v27mr614064ott.337.1626976356484;
        Thu, 22 Jul 2021 10:52:36 -0700 (PDT)
Received: from [192.168.0.173] (ip68-102-25-176.ks.ok.cox.net. [68.102.25.176])
        by smtp.gmail.com with ESMTPSA id 68sm5187184otd.74.2021.07.22.10.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:52:36 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v2 02/44] kvm: Switch KVM_CAP_READONLY_MEM to a per-VM
 ioctl()
To:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <20f5a78e8c704adcf4e96dac4aa160b9b6a7c17c.1625704980.git.isaku.yamahata@intel.com>
Message-ID: <d5c778b5-9c1d-908b-2d26-108b3bcd8aef@redhat.com>
Date:   Thu, 22 Jul 2021 12:52:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20f5a78e8c704adcf4e96dac4aa160b9b6a7c17c.1625704980.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 7:54 PM, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Switch to making a VM ioctl() call for KVM_CAP_READONLY_MEM, which may
> be conditional on VM type in recent versions of KVM, e.g. when TDX is
> supported.
> 
> kvm_vm_check_extension() has fallback from kvm_vm_ioctl() to
> kvm_check_extension(). fallback from VM ioctl to System ioctl for
> compatibility for old kernel.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   accel/kvm/kvm-all.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index e5b10dd129..fdbe24bf59 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2531,7 +2531,7 @@ static int kvm_init(MachineState *ms)
>       }
>   
>       kvm_readonly_mem_allowed =
> -        (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
> +        (kvm_vm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
>   
>       kvm_eventfds_allowed =
>           (kvm_check_extension(s, KVM_CAP_IOEVENTFD) > 0);
> 

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>

