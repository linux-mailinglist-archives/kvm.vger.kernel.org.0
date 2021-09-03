Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CA44005D7
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 21:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347144AbhICTcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 15:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbhICTcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 15:32:10 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB421C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 12:31:09 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id c8-20020a7bc008000000b002e6e462e95fso252473wmb.2
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 12:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5AI83WewnZnYkPXwZnd2Q/eU9eygrBsbivngRE4BXiQ=;
        b=P4ISVXfvobqG12Z6RoTOI5UGIr/4McKEzBRjkpnJVeCZevklJ/WV/0lQBT+voH2SUY
         t0dVslctqlM5DOtyjeqjkUvPjGWjj1dhiEdyZQeWioK8rQRoWy5A5NcKlSGuzKW3aWqj
         t2bT7b9xG9bD7XISjXwWDKsCHqd+100iir2zh/3XRm8EAkGO06KgFLng+vuhbRGyvSoR
         AObhwaMSw7osyojtzotiYTY7cxvr3JYasdODvCk6KW0vBIVPJ0cpLiVEP0EFP/cmNIcL
         vTd4VlnM3ebyqP3INvEw9GWo/Z410XL/Oo2itgtLLE/TkG/P7c4oBYv9h2IqwiQYnS7X
         J5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5AI83WewnZnYkPXwZnd2Q/eU9eygrBsbivngRE4BXiQ=;
        b=AvkjSO4OYRa5QcJVCjEuXZUA5UyuFnIyzn1vPyoRAzJcvwKKKQ/Dr1mEywm6u2eBee
         3j6+aG5tnglhZFS9DMlu9uKQfCJlR2Xpyh6dCwAOROhyxSLkV8kv8GqxaQeG7luJD17V
         9pToCbpLUr2kPGdeqMNeExVXjqK/KWDTPzMPC6azJ9QAgFm/wwQCNn4AGNguEbnCj0Bu
         a0qlNm+zAY6NqXpeCXNLY+v4wfvM4Nlr5iVG5w1e9ywQv2MnDZSTPVk18yYCwstaQdOK
         hF4XJS6J5guU1++XO3pR/YGH+OkK1lflMVCq9QqRLtFpKThnY4BIxZQ2Eq10X9TpFXPx
         /iyw==
X-Gm-Message-State: AOAM5300FXjUURdavCK99+BSoG8G/6yvbOUIV35DoU92D/ZFdHBw1e95
        uzZdfU9qvTqttbWMwkNPE4iypJ8eW0K/s4BUaBo=
X-Google-Smtp-Source: ABdhPJyNPnhhhAtbo2njo6bCAr3WAaEKFNGmuE7LF325krCnfwymK4ah4w6eYAokj7v99c7wD74wnA==
X-Received: by 2002:a1c:1c2:: with SMTP id 185mr289419wmb.11.1630697468395;
        Fri, 03 Sep 2021 12:31:08 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id f17sm286460wmf.4.2021.09.03.12.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 12:31:08 -0700 (PDT)
Subject: Re: [PATCH v3 01/30] accel/tcg: Restrict cpu_handle_halt() to sysemu
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kurz <groug@kaod.org>, haxm-team@intel.com,
        Kamil Rytarowski <kamil@netbsd.org>, qemu-ppc@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Michael Rolnik <mrolnik@gmail.com>, qemu-riscv@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Chris Wulff <crwulff@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, qemu-s390x@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Paul Durrant <paul@xen.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        xen-devel@lists.xenproject.org, Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Stafford Horne <shorne@gmail.com>,
        Reinoud Zandijk <reinoud@netbsd.org>, kvm@vger.kernel.org
References: <20210902161543.417092-1-f4bug@amsat.org>
 <20210902161543.417092-2-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <cdbffa64-98a4-859d-d8f1-50d959197542@linaro.org>
Date:   Fri, 3 Sep 2021 21:31:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-2-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> +#ifndef CONFIG_USER_ONLY
>   static inline bool cpu_handle_halt(CPUState *cpu)
>   {

Hmm, slightly better to move the ifdef just inside here,

> @@ -607,6 +608,7 @@ static inline bool cpu_handle_halt(CPUState *cpu)
>   

and here,

>       return false;
>   }
> +#endif /* !CONFIG_USER_ONLY */
>   
>   static inline void cpu_handle_debug_exception(CPUState *cpu)
>   {
> @@ -865,9 +867,11 @@ int cpu_exec(CPUState *cpu)
>       /* replay_interrupt may need current_cpu */
>       current_cpu = cpu;
>   
> +#ifndef CONFIG_USER_ONLY
>       if (cpu_handle_halt(cpu)) {
>           return EXCP_HALTED;
>       }
> +#endif

which would eliminate this one.


r~
