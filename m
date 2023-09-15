Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4757A2763
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbjIOTs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237080AbjIOTsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:48:24 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6EB1BC7
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:48:19 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-502fd1e1dd8so382287e87.1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694807297; x=1695412097; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oxxvMdlKt/HRFm5Hf+lIe0aLbT3VZ7UC4ihb/IBSqXw=;
        b=jpae/dXDKdU5uusKovXqZbb6Nd37Qs5eTeohUlh0XJ505UY0mLz6U4z7B06HOWkA/F
         Czm7AQw47xEtGPDZ/gcxb9/wYY7SUpjmFIK4S23H3wT5LP43fN027f9V9E0jnwT7H4qo
         OoJ9GH1T+GtlU9YZ0rclJ8O6LcD+uakh36riIpEv6sEFnP1R20BKXtNpKk4aeVV1GzxA
         ckEqW+Yf8VMFSmmChbOdP6zYFE0I7SFq/wa/YXZ050znzsIMDh1GliVMG2zPoM7SPY/a
         zPXtOiIv4dHditVeOUWPxk0M2A0DR7pjcaYpmzrjvTZGgReLu4lkzMu/y4RIrd5j1KIj
         agqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694807297; x=1695412097;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oxxvMdlKt/HRFm5Hf+lIe0aLbT3VZ7UC4ihb/IBSqXw=;
        b=GuBbAC+mIIcVCcs71H6DSu+/36a82y6jg1LJMHuLCfxa8eoTL9PJXWUL0NlErrkGDR
         GtdVG0ZbaGOkAjusS1CvJA4P1MDat6ef3G0/Sbw7AppS4EJUfCfup+xJ1Lb0l2bsovKd
         rEHgsnwQ42R4UT9V4V13g7BEpZ9v/u/wSLixd+2jWn+OIddufzvfTotUWhEEc4f8dgLG
         4ZxAymSgFF5D11PY2a/S7ZRyscuIdWYHEsgdsgpJlQAgxZvs8cPKzE2oRZjmFZ0L0Bqh
         p73jKg/mfqmz/AVSH3Pi3qQ9eAudEdZ05hyNqxgEaT4tS8ZK3cZjls2QZ1Iu7Mcz9aN/
         888Q==
X-Gm-Message-State: AOJu0YxkPOEFbRoOsb8KgD3a7R+csFXkJP8hyHSUPwIBW7trIUhxzErX
        Da5v6Xf30/dU2TrjThhzjC0wexlAUFA4R1P9bBU=
X-Google-Smtp-Source: AGHT+IEeqBOTpSaUZ0HHwBWzCkrNyr493kdPBxVETf+eT+nCt/rTFhAP6/TQdHGJhUKExZXObPYtbg==
X-Received: by 2002:a05:6512:3b9d:b0:500:807a:f1a4 with SMTP id g29-20020a0565123b9d00b00500807af1a4mr3112150lfv.18.1694807297453;
        Fri, 15 Sep 2023 12:48:17 -0700 (PDT)
Received: from [192.168.69.115] (6lp61-h01-176-171-209-234.dsl.sta.abo.bbox.fr. [176.171.209.234])
        by smtp.gmail.com with ESMTPSA id c6-20020a17090620c600b009888aa1da11sm2834435ejc.188.2023.09.15.12.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Sep 2023 12:48:16 -0700 (PDT)
Message-ID: <882e6f4c-0df4-6a90-9464-f41c764c882d@linaro.org>
Date:   Fri, 15 Sep 2023 21:48:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 2/5] accel: Introduce accel_cpu_unrealize() stub
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230915190009.68404-1-philmd@linaro.org>
 <20230915190009.68404-3-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230915190009.68404-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/9/23 21:00, Philippe Mathieu-Daudé wrote:
> Prepare the stub for parity with accel_cpu_realize().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/qemu/accel.h | 6 ++++++
>   accel/accel-common.c | 4 ++++
>   cpu.c                | 3 ++-
>   3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/qemu/accel.h b/include/qemu/accel.h
> index cb64a07b84..23254c6c9c 100644
> --- a/include/qemu/accel.h
> +++ b/include/qemu/accel.h
> @@ -96,6 +96,12 @@ void accel_cpu_instance_init(CPUState *cpu);
>    */
>   bool accel_cpu_realize(CPUState *cpu, Error **errp);
>   
> +/**
> + * accel_cpu_unrealizefn:

"accel_cpu_unrealize"

> + * @cpu: The CPU that needs to call accel-specific cpu unrealization.
> + */
> +void accel_cpu_unrealize(CPUState *cpu);

