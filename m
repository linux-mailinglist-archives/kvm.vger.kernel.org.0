Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62476487DA2
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 21:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiAGUX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 15:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiAGUX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 15:23:57 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC50AC061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 12:23:56 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g2so6346336pgo.9
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 12:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xDdfZmWyqdSVTAXVBADg0hD3oX2PNa9PSothirQTFSc=;
        b=GwFaMgbOJ7vA6rwcaZq6QXY9LSIBtiqYffH5RrxDF70uezPqIy7HuzeQ2SjW+QEbUz
         CKT8I/s+pt1nYnGQZ/O3D5QH7UcQu7QSnMS81azkgUo+9wjFyuwZlaQ5CPLw+ZzBDHOR
         Q9t2e0yQCppOMHHOEWhdFw9AO4HLdkdBAFpOZNtu9bjQ3ej25vV1ttXJXhy/EBqNHtgx
         pJuI4xCtsiAznyoXE0fPfCUSWmOcp40jwUOKW4vI4q98KxU7hhnQAcdPfRMy1F3v6sOp
         568KU5kdPZthHU8gwNSyJJ7e7GHeazy13Jg2fKMA5yeEKAIAjqyb9NtPvAA5vX+MJR+e
         GMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xDdfZmWyqdSVTAXVBADg0hD3oX2PNa9PSothirQTFSc=;
        b=vBeQpOI+b0tr71kwry9uqzDDWm8WKFvtgi8/VHZLuMs58TzSxCSgX1UDAoQNnVaJ9d
         LdSvua6AU8cTxzoQciLHlxrQWEoW781qd7DkY8vRiDHFjLMbB41n49qEZDBQ584+X9pg
         tWpbi0z6LehC9touPKxcmwLGMaGHtw/XpinZZ8UCw+MQUeieutsQZP0UyMUJicw65G+v
         Vx1i0A5BcQ2TPZ68gRAVYYwN/J8+S1RnNBYzls99CpCfdfCOvD5QtV+6aLGRsFtwDOWU
         E6Tsere4677cClY4DhdYgfDzIDOF9xFUBc3AGbU5zK2MmDCZYt+abrtmDClexoxxuEVb
         Zn1g==
X-Gm-Message-State: AOAM533e+rxylfiOcV2m80X4AHZqSrlFw1abmxnKeNH1CaXY+31CB2cJ
        rozAm4g8pSBhUJYHsbKPafk4Lgoq52nI1w==
X-Google-Smtp-Source: ABdhPJzftw4PEotEHASckTN5Gy0MMQebU7XjsnC+2xdRTZQFdnCEJ67BUd0zbNp7g3vfVMes2gAU8A==
X-Received: by 2002:a63:9602:: with SMTP id c2mr42975234pge.538.1641587036373;
        Fri, 07 Jan 2022 12:23:56 -0800 (PST)
Received: from [192.168.1.13] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
        by smtp.gmail.com with ESMTPSA id p24sm6121962pfn.33.2022.01.07.12.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 12:23:55 -0800 (PST)
Subject: Re: [PATCH v3] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jones <drjones@redhat.com>
References: <20220107150154.2490308-1-maz@kernel.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <a3d32f18-dbbb-e462-82ce-722f424707f9@linaro.org>
Date:   Fri, 7 Jan 2022 12:23:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220107150154.2490308-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/22 7:01 AM, Marc Zyngier wrote:
> @@ -1380,17 +1380,10 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
>               return;
>           }
>   
> -        /*
> -         * KVM does not support modifications to this feature.
> -         * We have not registered the cpu properties when KVM
> -         * is in use, so the user will not be able to set them.
> -         */
> -        if (!kvm_enabled()) {
> -            arm_cpu_pauth_finalize(cpu, &local_err);
> -            if (local_err != NULL) {
> +        arm_cpu_pauth_finalize(cpu, &local_err);
> +        if (local_err != NULL) {
>                   error_propagate(errp, local_err);
>                   return;
> -            }
>           }

Indentation is still off -- error + return should be out-dented one level.

Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
