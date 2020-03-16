Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA15D187391
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732487AbgCPTqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:46:18 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40208 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732416AbgCPTqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 15:46:18 -0400
Received: by mail-pj1-f66.google.com with SMTP id bo3so7816743pjb.5
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fg2dIkWCB/O1LDCS9geq5EAQZZnI+9IQOwUr+ztmSSo=;
        b=mGKIQ3rE/W8YR3Tzqn81ilyK3CO1Ckuz06TR4oE12XPjyGjnVygcOSBCEyTP/ur6wK
         ZhZSaPC3s5+Ajp8rFzkY1Mcl68rlCzQf4AbCKoUhdl5++AWnjsrEXDI8shYLaXRJACCm
         ZMrewNmmoGQEYKPq044ZuJMeddaSyT+h/V0puTLnwSZ0RP99deWKvo8uuJ8dlvQdkZrk
         n6W2JHtyS+NLry3j+lRtQznf6WtI8/dgD3OoVRPRvu38VnItydo87odGkP22hDsIghqa
         772EEJQPrVqPlmr3rrabk/n15X6Kwod4NPjAJFArFpcZPoAic684k9ktoYHlQQq3NLIO
         F0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fg2dIkWCB/O1LDCS9geq5EAQZZnI+9IQOwUr+ztmSSo=;
        b=nr6TRdfrvjRV8KblP30fAEkMN/WL5Am7NoFHVd1cuHd9dRKx2wka/xVIzs/Jgi7sR8
         yxN8DHCh5DAEN5IALTQ5nAcdHvA4L8UnCpN8pN2SvRTuKMFxevDY3Ep0YK9n7ctkkR+X
         /983UJi2I3/RG01MzaQQrQ69aGz9NFVx530mjmSXKfNFvXwgMQKBKuthkI0w6aJDPkmX
         eiXvWCiGb1c0XxXOsG5uapDhT+inEzybKInVX3taLjKTCl2tMfzeWRrF81X1MVrw7guz
         BGIgEIUtKKpe/a3CY40KareD523G4h1WbQxQBMBWmCoitjNNzZ+NcdnFJfNnEeLh3rqD
         rSTQ==
X-Gm-Message-State: ANhLgQ0m18P7LIwP4HHnC7+x7qutPFGHrwFOET9agDanFzWm14sDQQzb
        31/fOgc47rkGargQUOzGuO7Yyg==
X-Google-Smtp-Source: ADFU+vuJRnVHlZ/NwMSs1hoyK2nwN/EKxc3cwui5H4fXByD28JtCPHowfGZeHQezFemq4Tc7M7mueg==
X-Received: by 2002:a17:90a:2489:: with SMTP id i9mr1069737pje.183.1584387976837;
        Mon, 16 Mar 2020 12:46:16 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id u41sm335812pgn.8.2020.03.16.12.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:46:16 -0700 (PDT)
Subject: Re: [PATCH v3 08/19] target/arm: Add semihosting stub to allow
 building without TCG
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-9-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <a0aba55b-61d7-c0f4-9fc7-bf6b5675281f@linaro.org>
Date:   Mon, 16 Mar 2020 12:46:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-9-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> Semihosting requires TCG. When configured with --disable-tcg, the
> build fails because the 'do_arm_semihosting' is missing. Instead
> of adding more few more #ifdeffery to the helper code, add a stub.
...
>  ifeq ($(CONFIG_TCG),y)
>  
> -obj-y += arm-semi.o
> +obj-$(CONFIG_SEMIHOSTING) += arm-semi.o
> +obj-$(call lnot,$(CONFIG_SEMIHOSTING)) += arm-semi-stub.o
>  
>  endif # CONFIG_TCG

This code doesn't match the comment.

Why isn't this

obj-$(call land,$(CONFIG_TCG),$(CONFIG_SEMIHOSTING)) += arm-semi.o
obj-$(call lnot,$(call land ...)) += arm-semi-stub.o


r~

