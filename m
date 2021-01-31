Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A14309DA3
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 16:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhAaPgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 10:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhAaPgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 10:36:43 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188F0C061573
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 07:36:01 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id p15so13852676wrq.8
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 07:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tj9ynb2vRPFjqtE44EpTjMkFQtoIUjhfjhxMTiCpavE=;
        b=bKISEXILOqbBKSyWxvRZTuqbFnMi0zbFX7AD4hLA5WBrs5OH0WAyfczzJO+CNwqZsH
         Px6aqJnUVVzUonDQ10/D4g69YH1ddYR09nffJI/ZWFikuSfuVxu3j6deINIQFetTavz5
         7CB+cq5ySm37Y8rJ8MwxUmhoZdKCfu36fgGzfloOWPaLi22Cp9ygPjj8aGlQIaaQHq8p
         2IHzfac/aVBfZIQQtBiotSnheZvuijwqcKpFhuI1E5CjikLGMbyONtbX/FkkDI2N54ec
         G0A6Ytwl9tirRcjmpbOsSElN5Jz/07qnnKLQNXGICM/tyABc8/kd8gkD8S3sorOVk8M9
         9RCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tj9ynb2vRPFjqtE44EpTjMkFQtoIUjhfjhxMTiCpavE=;
        b=HLRFlfiFG5+ZZc/PAQwPiyQeP9gM4rdN3K5ZSRmiLCWF1yFH7FghALXysvLJ0j6+2c
         qh3fIUm76/Xf/Wcanil/6LDM4KFCFpUz1+4rE72ytK43Gq/v4D6DFPwGUAFsYiHaWSxw
         OlNm6qE9EaFx72dlVfy/UV/dLQHxNEqX59FzuPQn3J5YkO6eFtgyopmArAsMaT/x2Dem
         +Z2jqR8cdcyR2QOaLlAJ3vefpxXHhaMKtgFIawPvxkwTuYEtfx5K58rZ4TUCx9iUzrdX
         qWMKRZnY9w23e379D5s8aVMeY+INuIv+5nR/SAjlQX/vy1DjqQJiR5gTTYvv3eVXTsbg
         ustA==
X-Gm-Message-State: AOAM5315GVWHW5GDNIuvkB5SiAcR3MFRfZVKh/bT+VT+dC8eRaigsrXy
        KFRJ7NpIk1QibUXU5BOt+nQ=
X-Google-Smtp-Source: ABdhPJwxwfwJ1O3wZnQXDc1ZmYatUowqBlUM5eDlN14YoQfKfNZKRQ03jZH9GWmo0RCtIQi/fXcy0A==
X-Received: by 2002:adf:ecc5:: with SMTP id s5mr13603929wro.423.1612107359885;
        Sun, 31 Jan 2021 07:35:59 -0800 (PST)
Received: from [192.168.1.36] (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id f4sm23839332wrs.34.2021.01.31.07.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 07:35:59 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v5 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Fam Zheng <fam@euphon.net>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm <qemu-arm@nongnu.org>
References: <20210130015227.4071332-1-f4bug@amsat.org>
 <20210130015227.4071332-4-f4bug@amsat.org>
 <CAFEAcA8UCFghGDb4oMujek_W_wsyYz+duiQ-d8JyN09NYoff-g@mail.gmail.com>
 <2871f7db-fe0a-51d6-312d-6d05ffa281a3@amsat.org>
 <CAFEAcA-W1tcRREaPTfMw98cNsHs7JHk4gjaJWaJNLpxZoVnKaw@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <40ca4720-7adf-8469-2593-6e6689d03fd6@amsat.org>
Date:   Sun, 31 Jan 2021 16:35:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-W1tcRREaPTfMw98cNsHs7JHk4gjaJWaJNLpxZoVnKaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/30/21 7:54 PM, Peter Maydell wrote:
> On Sat, 30 Jan 2021 at 18:36, Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>>
>> Hi Peter,
>>
>> On 1/30/21 4:37 PM, Peter Maydell wrote:
>>> On Sat, 30 Jan 2021 at 01:52, Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>>>>
>>>> KVM requires a cpu based on (at least) the ARMv7 architecture.
>>>
>>> These days it requires ARMv8, because we dropped 32-bit host
>>> support, and all 64-bit host CPUs are v8.
>>
>> Oh, this comment is about the target, to justify it is pointless to
>> include pre-v7 target cpus/machines in a KVM-only binary.
>>
>> I'll update as:
>>
>> "KVM requires the target cpu based on (at least) the ARMv7
>> architecture."
> 
> KVM requires the target CPU to be at least ARMv8, because
> we only support the "host" cpu type, and all KVM host CPUs
> are v8, which means you can't pass a v7 CPU as the target CPU.
> (This used to not be true when we still supported running
> KVM on a v7 CPU like the Cortex-A15, in which case you could
> pass it to the guest.)

Indeed:

$ qemu-system-aarch64 -M xilinx-zynq-a9
qemu-system-aarch64: KVM is not supported for this guest CPU type
qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0):
Invalid argument
