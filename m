Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FC9309790
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 19:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhA3ShI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 13:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhA3ShH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 13:37:07 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109A5C061573
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 10:36:27 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 190so9297245wmz.0
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 10:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1mNh9mlH0J+zMjgMzcqZVDvGumB7ljSHk0DeAaBnlyo=;
        b=WbGzkcuAeKstM9npuwuwjBnsuEZm3r5ywk/P67nlhSNsqQWcxGtIyp/B/UlSUyJqWe
         rWBBL0Hz04hYGcGKDbdlr+Q5TbjmlDYeP5aAaN0R5Ay5zodmCvmp+ggN5wHssG7x7vyD
         3JMGGA5AK75ov59qdcqNoZf8s+vtn2UJxw1pfb79km+kvaVW4eKgDH3lx4Mh0ZHyu1Es
         c8DrTbZ1CxgbbiLIZJsUSSC8Q0FPV6OGKMYCyFML2qBkeE7xTcngCuC6pXhF6fRDpxw8
         rRY35sV+EjjJAipw1mYL04unB71LVdiuXGyJ5HxfzbLH8oo7/z0NEn0QORV5RNgzd6a6
         q3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1mNh9mlH0J+zMjgMzcqZVDvGumB7ljSHk0DeAaBnlyo=;
        b=Jx0Phsjk2wRzjYp5w8TNjHYh31on0YkdqS+D9L0RIFE86M47AhgZZRmP75pfGbXb0p
         At11eY8TqqXDL2xPTFsCwgNfQDK5Ysp8u9aK4ZQE+NgZ4ic6tq52YHuO23iuplHPF6Zb
         VAWxaO3vHilfGTzp08y8bca0l8TBpPoftG/hc3xRz6SeTQ/iUKzuPvPpLE5qL05YHD8m
         rQTkOhDXOqMUVIrJ6G9ktVb34LfBANrbOfutwrVYKS7p+ITKELex6V/ZobwAHxxfNGi6
         MxLa7kRyMN0hhFzeoOyBrtMwbqKduCbM59PFsRWVHvKIP8TlchzZ1ujVscVq1eA8vt6R
         z3gg==
X-Gm-Message-State: AOAM5300kKQgK00oacDqX+bzqLZ1g7RFTie45LxIlP4DRKOxuAEcdW97
        Re06w3ZB3xAOZk+vLJHjybo=
X-Google-Smtp-Source: ABdhPJyXkcz3LAR4E0+PEoeKblLFblLD+ThxjmdYgyS8ayJSPNpoC+HMjVsKg7NDgRMrHhT3Y4wlJQ==
X-Received: by 2002:a1c:3587:: with SMTP id c129mr8531992wma.76.1612031785730;
        Sat, 30 Jan 2021 10:36:25 -0800 (PST)
Received: from [192.168.1.36] (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id y67sm15807411wmg.47.2021.01.30.10.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jan 2021 10:36:24 -0800 (PST)
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
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <2871f7db-fe0a-51d6-312d-6d05ffa281a3@amsat.org>
Date:   Sat, 30 Jan 2021 19:36:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA8UCFghGDb4oMujek_W_wsyYz+duiQ-d8JyN09NYoff-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 1/30/21 4:37 PM, Peter Maydell wrote:
> On Sat, 30 Jan 2021 at 01:52, Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>>
>> KVM requires a cpu based on (at least) the ARMv7 architecture.
> 
> These days it requires ARMv8, because we dropped 32-bit host
> support, and all 64-bit host CPUs are v8.

Oh, this comment is about the target, to justify it is pointless to
include pre-v7 target cpus/machines in a KVM-only binary.

I'll update as:

"KVM requires the target cpu based on (at least) the ARMv7
architecture."

Is that OK?

Thanks,

Phil.
