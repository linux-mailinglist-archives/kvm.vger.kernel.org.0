Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC94400680
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350362AbhICUXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350319AbhICUXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:23:37 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCC9C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:22:36 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so296908wml.3
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UnbOiyADd1ZMlxRvNb9HZP0pt1hL83FL8WVZjS8Ogcw=;
        b=COG3NPL3Vxpz88wlWI3lGdCLg/LDdsQZJexfhJnrghpwFEqcukZveIdAk/fFiP0wKB
         7HNAWQIl6rmgV04BpIshszyQzk9qq0Q2NwrgljJCneyfFgOJ0xAXKUZsaU/hrF0B0/AT
         3w+VRd6HCQDmcDCjwEVjMOfRX4d+x+Lya4wftnpVkB2KXN3pr43vNkh+vseHQcZijosS
         Q3FflSz6b5FTlNEGFg6AgPTW3cZ3FSliEWoFoIHYG+zwm5ACts2RQXEeZ5OBwv2FsHiM
         zzHD5y43SWWwvU4sjxJD/8SKKcD/qNm8NbTssviVjN3cg7xbLdiiJSNeDTXPZ9eqrqkH
         KpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UnbOiyADd1ZMlxRvNb9HZP0pt1hL83FL8WVZjS8Ogcw=;
        b=iZuhDrI5ZKHsElCNjDYRlxm/IrBKvE7ZHSRAUFOy16Yyt18Ow7mBPTvw/1b+3uawSh
         mdHcDIy8nFI3iKvVATSBwMwTETZwKVW1DYqyZ1w3EPcaQFxr0Niq3HvT5cDmi7wFlvye
         0dDeanu/xE2Vax8Yftc9LJOUOKrafr4cEwNI1JS6PswbARJhOHx/W2IFjcxX9xGwswal
         lT8KXYrdSBVCLdyzgkM6g4eruJSnR6EaP7/uicQzx15LyW4c1QTEds4CNNi2kK/lM0zo
         8R2xG0oauua15sodJbGsgYGb+gg9tLQjuoRT276VfXifZA/alxRiaq39ofbASDDbSphm
         FRnA==
X-Gm-Message-State: AOAM5307tCz4OZilxHCd2f6C7SeJI7wnKMxkzeywSNZdNOqEwm2RXhok
        DqtqwOBkdO42ab3Az2u+5Sqz1jVl6QSwW3zLghI=
X-Google-Smtp-Source: ABdhPJxPwO0cHTUIrMGmZMtVOl8TUayc1aTCNm++vMgNkxvRpyKHD/crU8kG261DTumMzBNsNkV5GA==
X-Received: by 2002:a05:600c:19ca:: with SMTP id u10mr432498wmq.178.1630700555348;
        Fri, 03 Sep 2021 13:22:35 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id p13sm244311wro.8.2021.09.03.13.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:22:34 -0700 (PDT)
Subject: Re: [PATCH v3 13/30] target/hppa: Restrict has_work() handler to
 sysemu and TCG
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
 <20210902161543.417092-14-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <1f644d61-92e9-2161-284b-0643edd4892b@linaro.org>
Date:   Fri, 3 Sep 2021 22:22:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-14-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> Restrict has_work() to TCG sysemu.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>   target/hppa/cpu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/target/hppa/cpu.c b/target/hppa/cpu.c
> index e8edd189bfc..cf1f656218f 100644
> --- a/target/hppa/cpu.c
> +++ b/target/hppa/cpu.c
> @@ -60,10 +60,12 @@ static void hppa_cpu_synchronize_from_tb(CPUState *cs,
>       cpu->env.psw_n = (tb->flags & PSW_N) != 0;
>   }
>   
> +#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
>   static bool hppa_cpu_has_work(CPUState *cs)

No CONFIG_TCG, otherwise
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
