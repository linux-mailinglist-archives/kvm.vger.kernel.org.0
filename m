Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A91400659
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350130AbhICUMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhICUM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:12:29 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52827C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:11:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b10so351299wru.0
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EaCWOOldFpTJW/62GNcO8hnd0wqc8elIcEfaX69jVvw=;
        b=YyrzMqwR7pTY4UVwmQkF/b6/6vs1u7pbVcrnFbJ2IcW6P4fipRJVT8PmaEsbbFpg5m
         Ymv96X1royzInIGobPF2j09Z1yc16HGEdliJIXhC7BdkL4CkDrSv4ViHU6bzRWnn7dZV
         qZBXE7dHM+4+DbAAXk77dXGymyVlTIpYSq7C1i3JEZlTfiNoWgj2wqws++sPnSgcptat
         mA18BowRdXGHFl+/0fRO7ZQ0GtRH00yJ/XcRK/OYqcLDp/RR8ktqw1Cg+Aoha/XNDyBg
         8cWnsyWPtksyXCOTBNPJZ0SnF8sr/Z1rLMwoCoGs5MDwwc19FX55U9jh0cE3apvw4e/O
         +6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EaCWOOldFpTJW/62GNcO8hnd0wqc8elIcEfaX69jVvw=;
        b=bQdCZU32oR2oJ1+57bRRj3ut1/nO5tmmUv6iHjKNGizfyzy6gJrrjPrI/4Vk2rIfFG
         P51n99+KqoqG7MQwVQkJL54ozq9sFLBoQttmjgv8nIjy/9y7xc1uk8vVBTFTe+atpnVK
         HuT27OxsHQI74cElIkGQJiYK5+dedDMxpkzxHdaMC5p36c6ItQoX2QUSI9udKJbqIYzp
         FrM8LG+4sIxwk5RzDcY6e9uzD7haXKKBIJtkx9G7wXn8eMwj9b5UICpHl9b5i/Ha/rws
         9DqWNIkNNH8omvXUJeUWlFQVEEDNx0ZO+lBt9zZh8qzmbfDXbTiF59Y6ppHKGItZAI2/
         Lz0Q==
X-Gm-Message-State: AOAM533ee56yG0PugEFB0BDU6ouYM1ZwlYGWLLrJ1yQYPxT3oTXm8JCa
        OliWbJ31/HYV8yC4fKu5ajzzHsiApwIt4XDw1dE=
X-Google-Smtp-Source: ABdhPJwhD7ZLlhNK9IfRlsfSxTpaQWDz0Xn28SyMeYUyzG5cv49AdD3Ojc4LM0ShmrKJ0X1u+d3JqQ==
X-Received: by 2002:a5d:5712:: with SMTP id a18mr758059wrv.367.1630699887867;
        Fri, 03 Sep 2021 13:11:27 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id o26sm331500wmc.17.2021.09.03.13.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:11:27 -0700 (PDT)
Subject: Re: [PATCH v3 02/30] hw/core: Restrict cpu_has_work() to sysemu
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
 <20210902161543.417092-3-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <ee2f2d27-cc3d-c398-74a0-c0ca439d84ef@linaro.org>
Date:   Fri, 3 Sep 2021 22:11:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-3-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> cpu_has_work() is only called from system emulation code.
> 
> Signed-off-by: Philippe Mathieu-Daudé<f4bug@amsat.org>
> ---
>   include/hw/core/cpu.h | 32 ++++++++++++++++----------------
>   1 file changed, 16 insertions(+), 16 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
