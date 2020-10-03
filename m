Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCEA28234B
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJCJnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgJCJnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 05:43:07 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A285C0613D0
        for <kvm@vger.kernel.org>; Sat,  3 Oct 2020 02:43:07 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id o8so3862306otl.4
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 02:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3qxl6W6Hb5YLbw/EY9qvXKmVt4aFa32zNvMsgWDEaIs=;
        b=SuhKbrNebolkmv1zwZgG2kxF9agEk7c2jEVgSYCLSypk30ZV/r2YEXK7QIrm+r4gtp
         eRBa2cd/gMWSxN1vX8fqaHjZ321eW12DraZF3z6BsG+a21g41NVo41hx5N8HvVF4AL9u
         5btqslJfJtnb9p1R8SKwfTjxvN/Cr1NJSP2JCd7jMyvrZs2AMjJo5Uz5mr5up188/C15
         d5XslaZvfBmwWOpsvW+5lv/FavNKA+kPbFn5BONrnCYQymXsCAU3oWZkATag0TaRO0l7
         zBT5FPnO60q0d+HljcfWs0ZvF+s5kSxDxpfZMX6JzgwFoxdr87MBqtq3n+lgjP5joAzr
         7vjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3qxl6W6Hb5YLbw/EY9qvXKmVt4aFa32zNvMsgWDEaIs=;
        b=BIQv5RJ0839GVb0C+g4e2Muoq63OUI0CTXhzOF6jFTUKjRkR22ODVs6ywAMHF2zJQv
         HPBwyH/n+Ip0tyk0szVjHrMnUHEVgJb8K3B5R8QaDIQ6kYebBI5jh995S+kl7YvjJaCh
         ILOI5DPp6p63Q4FGJxy3LL714lwMOuy8JXBVnCNbmE1kJAdd0mAlKZU1L+wbOlC6IKuV
         izETQoSdl27M3cJC0tuyJjk5D9hmv8i+5otSYW4SHLvCeSL9I66+VVX76qZ6DNWY+tUu
         jS4hozQkKHlCBAbHFyOPwuzoh3E6X61tCDLkQ5qt06Yx0kekCo1Wz7xz5IFCCaDfxIE7
         12qQ==
X-Gm-Message-State: AOAM532IfdnmDK0GCUrFKNcTYfXNzRqtqmLmQew5Bd5OqOewx9J/9baI
        otUmpq92CXjTyEvXQ/yvlMI5Gw==
X-Google-Smtp-Source: ABdhPJwU72xkcylEdZMYoJ1HBTqlZvVLkH052G+WpZXaCQazKqWtTdpYlIkYrQ7bPjCXeqGbvd/ehg==
X-Received: by 2002:a05:6830:105:: with SMTP id i5mr4739874otp.68.1601718186724;
        Sat, 03 Oct 2020 02:43:06 -0700 (PDT)
Received: from [10.10.73.179] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id k3sm1181783oof.6.2020.10.03.02.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 02:43:06 -0700 (PDT)
Subject: Re: [PATCH v4 03/12] target/arm: Select SEMIHOSTING if TCG is
 available
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-4-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <3d418adc-60f6-492e-0852-2e52a3c1c5b0@linaro.org>
Date:   Sat, 3 Oct 2020 04:43:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-4-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
> Add a kconfig entry which not explicitly selected by another
> entry, but which selects SEMIHOSTING if TCG is available.
> 
> This avoids:
> 
>   /usr/bin/ld: libqemu-aarch64-softmmu.fa.p/target_arm_arm-semi.c.o: in function `do_arm_semihosting':
>   target/arm/arm-semi.c:784: undefined reference to `qemu_semihosting_console_outc'
>   target/arm/arm-semi.c:787: undefined reference to `qemu_semihosting_console_outs'
>   /usr/bin/ld: target/arm/arm-semi.c:815: undefined reference to `qemu_semihosting_console_inc'
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  target/arm/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
>  create mode 100644 target/arm/Kconfig

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
