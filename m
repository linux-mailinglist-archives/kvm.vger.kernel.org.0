Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D88640066A
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350030AbhICURo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhICURn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:17:43 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB08C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:16:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u16so316739wrn.5
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ksvR3vXBtwALfl0I6bUYOq6zF1YdgeJMV8dFDRL1P+g=;
        b=F+LmEPrSCssgf1eqjM+WBloAvOVq2tL7NMyM6LZCHirhU39DXiDO2uLD9ug3iNaHCK
         qAQxo2bwgbel/l5ZzJa4uPRl/EqjN0sQA7XIe3XklYehe60QyUJs5qg1vnpnfs/LYzJ8
         F50mpECSrD9JTS8cWWsDSVPn2dEFp7h2GfA9zAOn6e5EfN/aiCylKqANnhUX+0GyzxMA
         5YbCx/uH9oIK3BVZImpikPWK6g5wC7VESYux9bpW/knmD2hNngQDnsSLtz91Hsh54IH+
         4JT7IufJEjtYH/tbJ32xqBZvfx5N5H001O4TnBoFg7L9NuRj3KiL2d3ZfaMPEXO0z6EN
         fEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ksvR3vXBtwALfl0I6bUYOq6zF1YdgeJMV8dFDRL1P+g=;
        b=YKKwS/feDNeNuPIM26PlmrSKLu6enkiq8zXTjflLAV1TmPZe4HYvSUX7AKJpCWrzHa
         pshEW8vmWWGkBSVsk4Nd7cYU01InM2zFA5Q+RQNR1zRW5HTHxpUpYWtQOoEdlQp8Es7J
         7VBzGMYUwJTLyysaVhdc/YcIJm3sQGTfud1uMt2KkVk1zZuRfEoVyXAe1fxGETN1+AZp
         KYhQFoGuE/KNrj3rYFbk9SEsKi4kbk4BOzL25BHuhIbN/6L2hXQ0mxHr5qsCUXXg/DAF
         VNAZA9JI0W9jbfo9I1XzDbxA3iIe4KaM3K8XD3j2u68p9CIu9C1vzn509IhZzU9R5C+r
         ZKTg==
X-Gm-Message-State: AOAM5324/EuLuEH3xivds+6Dsw+M/MH4z+6FOEo0npWPkt32IKv7WNQY
        j07TcYsmO3rL9OMex+bXQuVz8nDCF2eU4Qa7hLE=
X-Google-Smtp-Source: ABdhPJzV+oCZLVl1R3jywIXOYAACRgU/ouMC2nXN7qXT1ry456hLKIT4YtHfUNsVqaTI8qbV2+dfAA==
X-Received: by 2002:adf:eb4a:: with SMTP id u10mr794817wrn.11.1630700201045;
        Fri, 03 Sep 2021 13:16:41 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id b18sm201319wrr.89.2021.09.03.13.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:16:40 -0700 (PDT)
Subject: Re: [PATCH v3 06/30] accel/whpx: Implement AccelOpsClass::has_work()
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
 <20210902161543.417092-7-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <c7d58bfa-20f7-502b-f307-9ed8f9f4def6@linaro.org>
Date:   Fri, 3 Sep 2021 22:16:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-7-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> Implement WHPX has_work() handler in AccelOpsClass and
> remove it from cpu_thread_is_idle() since cpu_has_work()
> is already called.
> 
> Signed-off-by: Philippe Mathieu-Daudé<f4bug@amsat.org>
> ---
>   softmmu/cpus.c                    | 4 +---
>   target/i386/whpx/whpx-accel-ops.c | 6 ++++++
>   2 files changed, 7 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
