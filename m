Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BC2309CF4
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 15:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhAaOcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 09:32:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:44628 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232302AbhAaOSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 09:18:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C0275ABDA;
        Sun, 31 Jan 2021 14:18:10 +0000 (UTC)
Subject: Re: [PATCH v6 01/11] sysemu/tcg: Introduce tcg_builtin() helper
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Markus Armbruster <armbru@redhat.com>
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-2-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <87d562ba-20e5-ee50-8793-59d77564f4da@suse.de>
Date:   Sun, 31 Jan 2021 15:18:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210131115022.242570-2-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/21 12:50 PM, Philippe Mathieu-Daudé wrote:
> Modules are registered early with type_register_static().
> 
> We would like to call tcg_enabled() when registering QOM types,


Hi Philippe,

could this not be controlled by meson at this stage?
On X86, I register the tcg-specific types in tcg/* in modules that are only built for TCG.

Maybe tcg_builtin() is useful anyway, thinking long term at loadable modules,
but there we are interested in whether tcg code is available or not, regardless of whether it's builtin,
or needs to be loaded via a .so plugin..

maybe tcg_available()?

Ciao,

Claudio

> but tcg_enabled() returns tcg_allowed which is a runtime property
> initialized later (See commit 2f181fbd5a9 which introduced the
> MachineInitPhase in "hw/qdev-core.h" representing the different
> phases of machine initialization and commit 0427b6257e2 which
> document the initialization order).
> 
> As we are only interested if the TCG accelerator is builtin,
> regardless of being enabled, introduce the tcg_builtin() helper.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
> Cc: Markus Armbruster <armbru@redhat.com>
> ---
>  include/sysemu/tcg.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/sysemu/tcg.h b/include/sysemu/tcg.h
> index 00349fb18a7..6ac5c2ca89d 100644
> --- a/include/sysemu/tcg.h
> +++ b/include/sysemu/tcg.h
> @@ -13,8 +13,10 @@ void tcg_exec_init(unsigned long tb_size, int splitwx);
>  #ifdef CONFIG_TCG
>  extern bool tcg_allowed;
>  #define tcg_enabled() (tcg_allowed)
> +#define tcg_builtin() 1
>  #else
>  #define tcg_enabled() 0
> +#define tcg_builtin() 0
>  #endif
>  
>  #endif
> 

