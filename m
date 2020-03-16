Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C7418737C
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732437AbgCPTgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:36:31 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37122 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732413AbgCPTga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 15:36:30 -0400
Received: by mail-pj1-f66.google.com with SMTP id ca13so9232371pjb.2
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4LmArg3GTu54ll1HNRtasTPkMr+nwPGShFSLJ6YeUnI=;
        b=UCMqjmpftx/SVaAcJC2uV0Mh8wWzRMNLzGmKyg2r9FKUh1a+nm610urYYMC0euiben
         wdwoaeK8aZNWW1uvuVCokCyF6UkNhWiNY5jCrf+HgruIXY/G5m50tQXxoxFlkiIom4MS
         IiF2qaNcF93JRGICwiVHlhDp2cCEJEo+x8QqVw0gURa/ImowPkDSrmW6x+KoYXKea6Yr
         29tCDsvaYT2r+dK4EyvqXlxis3TyjerqTa1H40pQIx9hKRogNjk6VIWWbLUz0Gf/FSAt
         UyppgclCH3Qu/wwEdAhfir7lWmTSo1YcnN8uXe+rUAextBb53XOLcYO3Opcq0rNjWnn7
         1oYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4LmArg3GTu54ll1HNRtasTPkMr+nwPGShFSLJ6YeUnI=;
        b=l81UO0LpDV9QK+9QDtRxeGooUQPHoUGgylxPB2hhyfisdBfJwLDqX7ojEsOg8BDZ+E
         HStbF1MUSjPJtbPZd4m6RH9IN8A+C7W2+/AjUNddHEltzF6KjyFxet0nBCxP6Y2cNB5O
         oX5Xi8O8Q5vRV/89kUdoxLAn2QtyW6cD0gCvuayD2T5D5jgXPGuJj/Gy6NQ5jed+PXcO
         E/uF7ebaEEszjyyCjbUYVwfkU6XTJOA4uAuqCEjXUeBSvz9EpuIJqz/0earclqNZ/kHy
         CcZcPIWaU28oA4IGr/EZfMzPmXFJK8ZaSkUGOrnjE8R8RP3CuQ+t/AocrHWZfQ11kxID
         Eu7A==
X-Gm-Message-State: ANhLgQ2sXKuOPzL4Vl9VAJFwQS9fmpyLiacLGl6g4qwQQkg/zsnDs8Nq
        r13miWqJzU0ZJZe0HobaUE/WBQ==
X-Google-Smtp-Source: ADFU+vtZgb/dz6XW3yb1GA5ZDRSuPFgkv5SJph2TK2P9VA40H7gjfL+36QxLD2o/1YkyWhcuBFX92A==
X-Received: by 2002:a17:90a:faa:: with SMTP id 39mr1196481pjz.190.1584387387544;
        Mon, 16 Mar 2020 12:36:27 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id i197sm655801pfe.137.2020.03.16.12.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:36:26 -0700 (PDT)
Subject: Re: [PATCH v3 03/19] target/arm: Restrict DC-CVAP instruction to TCG
 accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-4-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <f570579b-da9c-e89a-3430-08e82d9052c1@linaro.org>
Date:   Mon, 16 Mar 2020 12:36:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-4-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> Under KVM the 'Data or unified Cache line Clean by VA to PoP'
> instruction will trap.
> 
> Fixes: 0d57b4999 ("Add support for DC CVAP & DC CVADP ins")
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  target/arm/helper.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index b61ee73d18..924deffd65 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -6777,7 +6777,7 @@ static const ARMCPRegInfo rndr_reginfo[] = {
>      REGINFO_SENTINEL
>  };
>  
> -#ifndef CONFIG_USER_ONLY
> +#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
>  static void dccvap_writefn(CPUARMState *env, const ARMCPRegInfo *opaque,
>                            uint64_t value)
>  {
> @@ -6820,9 +6820,9 @@ static const ARMCPRegInfo dcpodp_reg[] = {
>        .accessfn = aa64_cacheop_poc_access, .writefn = dccvap_writefn },
>      REGINFO_SENTINEL
>  };
> -#endif /*CONFIG_USER_ONLY*/
> +#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */

I'm not 100% sure how the system regs function under kvm.

If they are not used at all, then we should avoid them all en masse an not
piecemeal like this.

If they are used for something, then we should keep them registered and change
the writefn like so:

#ifdef CONFIG_TCG
    /* existing stuff */
#else
    /* Handled by hardware accelerator. */
    g_assert_not_reached();
#endif


r~

>  
> -#endif
> +#endif /* TARGET_AARCH64 */
>  
>  static CPAccessResult access_predinv(CPUARMState *env, const ARMCPRegInfo *ri,
>                                       bool isread)
> @@ -7929,7 +7929,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>      if (cpu_isar_feature(aa64_rndr, cpu)) {
>          define_arm_cp_regs(cpu, rndr_reginfo);
>      }
> -#ifndef CONFIG_USER_ONLY
> +#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
>      /* Data Cache clean instructions up to PoP */
>      if (cpu_isar_feature(aa64_dcpop, cpu)) {
>          define_one_arm_cp_reg(cpu, dcpop_reg);
> @@ -7938,8 +7938,8 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>              define_one_arm_cp_reg(cpu, dcpodp_reg);
>          }
>      }
> -#endif /*CONFIG_USER_ONLY*/
> -#endif
> +#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */
> +#endif /* TARGET_AARCH64 */
>  
>      if (cpu_isar_feature(any_predinv, cpu)) {
>          define_arm_cp_regs(cpu, predinv_reginfo);
> 

