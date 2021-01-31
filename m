Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E560309C59
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 14:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhAaNbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 08:31:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232004AbhAaMob (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Jan 2021 07:44:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612096969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r+fgSsYmJt0f3GPKQSs64Hq+gfQen9Lha7MbKdEpdgY=;
        b=OrBIfkmRuf7eqQSyugnz9icJlufK2Mb16k5XH4+IUrhpaQKLAZT9n64bsODLrv7exs4TJY
        K+dggR14XB/tFVdoICT2O/AjlQNh9O6B2VbwT/qnoVY8YYMH6BDt8ptg0wtjMXOskNPKSX
        +NW42QdigYZKSZOxMuA4rN+N2jFWLPk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-mbZmxvLvOrqn8uMiSlvEJA-1; Sun, 31 Jan 2021 07:42:45 -0500
X-MC-Unique: mbZmxvLvOrqn8uMiSlvEJA-1
Received: by mail-wm1-f71.google.com with SMTP id z188so6734971wme.1
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 04:42:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r+fgSsYmJt0f3GPKQSs64Hq+gfQen9Lha7MbKdEpdgY=;
        b=asEkBTqGcC8+CAY8y2LxRcldVSNVnU7IxDfkP2ixEqzr3eZmtNympvIMaAuJtGYbpo
         KUnn7okO8EyyjG/gRh+8U5x3vyPrn9ja0cDG8g/4JxufYZmBST+arvZKbzOIDy3nhUrs
         y3lLsXg1C8nS1VLQhQuPTfJx8qjq5hf9s9vMoH8Cin94eehgLJkAZBpWuI9UMloTpxMv
         9LeAk0ONXwr2PZeGrjGcJN7665xZZI5g8K6Cih21KJ6RvgKc02qI1GgFIRGdUa3kA4lH
         KLsx5ay0iybYqSNLEiwNrv2aU7idx1gt9gzXu1CqQXtA4o3vX7tqpQS9BDSDH2YBYxOi
         dkww==
X-Gm-Message-State: AOAM530Q2ErL9BR8QHuqls6G62A65ht53m25S9lHLgtZoJTz8GuJ2ZVT
        T944Ifa1Va/cFIhHqPZdvs7HXcxGgVhI+JXv32I8MdtLw5x9gWhnwoonYAAMh9fWn4zf2JfFD1G
        5qj2CyKVUNeto
X-Received: by 2002:a5d:4c84:: with SMTP id z4mr13064334wrs.289.1612096964635;
        Sun, 31 Jan 2021 04:42:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzs9GPD9xtKflLpJnbdjV3KK6LBZIj+1CU+JafEN0VHboDucTozFmqLuwCNxpKvag0RcpZQhQ==
X-Received: by 2002:a5d:4c84:: with SMTP id z4mr13064319wrs.289.1612096964476;
        Sun, 31 Jan 2021 04:42:44 -0800 (PST)
Received: from [192.168.1.36] (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id h207sm15855648wme.18.2021.01.31.04.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 04:42:43 -0800 (PST)
Subject: Re: [PATCH v6 06/11] target/arm: Restrict ARMv7 R-profile cpus to TCG
 accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-7-f4bug@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <80af7db7-2311-7cc5-93a0-f0609b0222d0@redhat.com>
Date:   Sun, 31 Jan 2021 13:42:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210131115022.242570-7-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/21 12:50 PM, Philippe Mathieu-Daudé wrote:
> KVM requires the target cpu to be at least ARMv8 architecture
> (support on ARMv7 has been dropped in commit 82bf7ae84ce:
> "target/arm: Remove KVM support for 32-bit Arm hosts").
> 
> Beside, KVM only supports A-profile, thus won't be able to run
> R-profile cpus.
> 
> Only enable the following ARMv7 R-Profile CPUs when TCG is available:
> 
>   - Cortex-R5
>   - Cortex-R5F
> 
> The following machine is no more built when TCG is disabled:
> 
>   - xlnx-zcu102          Xilinx ZynqMP ZCU102 board with 4xA53s and 2xR5Fs
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  default-configs/devices/aarch64-softmmu.mak | 1 -
>  hw/arm/Kconfig                              | 2 ++
>  target/arm/Kconfig                          | 4 ++++
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/default-configs/devices/aarch64-softmmu.mak b/default-configs/devices/aarch64-softmmu.mak
> index 958b1e08e40..a4202f56817 100644
> --- a/default-configs/devices/aarch64-softmmu.mak
> +++ b/default-configs/devices/aarch64-softmmu.mak
> @@ -3,6 +3,5 @@
>  # We support all the 32 bit boards so need all their config
>  include arm-softmmu.mak
>  
> -CONFIG_XLNX_ZYNQMP_ARM=y
>  CONFIG_XLNX_VERSAL=y
>  CONFIG_SBSA_REF=y
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index 6c4bce4d637..4baf1f97694 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -360,8 +360,10 @@ config STM32F405_SOC
>  
>  config XLNX_ZYNQMP_ARM
>      bool
> +    default y if TCG && ARM

The correct line is:

      "default y if TCG && AARCH64"

>      select AHCI
>      select ARM_GIC
> +    select ARM_V7R
>      select CADENCE
>      select DDC
>      select DPCD
> diff --git a/target/arm/Kconfig b/target/arm/Kconfig
> index fbb7bba9018..4dc96c46520 100644
> --- a/target/arm/Kconfig
> +++ b/target/arm/Kconfig
> @@ -18,6 +18,10 @@ config ARM_V6
>      bool
>      depends on TCG && ARM
>  
> +config ARM_V7R
> +    bool
> +    depends on TCG && ARM
> +
>  config ARM_V7M
>      bool
>      select PTIMER
> 

