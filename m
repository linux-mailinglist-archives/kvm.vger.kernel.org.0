Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC4E400674
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350017AbhICUUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhICUUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:20:23 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BCBC061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:19:23 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m9so344618wrb.1
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hrfT6D6r8NgV0kbWbMFB7eJ0H5Q19iawpNSQkwrO3Zw=;
        b=UP4L3x90K9R0Xv9kUPD2k1ldA8cppgKzxB41aZwVXYD7x/qndJVah80MG87/CBUxKF
         TQsp6BHab8hbEiq0EVctWDjgUQRASZHj3+eAB2JftZU4rDgjFNuJfnOUODTXjmvHq+Wb
         CO5SRo4MZKWNpVLFkz1S9LBbag1wL73cRaGdVxll7VdzLyexwvlp0cZN9dy4/9ct+32O
         xuGIsIHPC9o6Pv+TjnwbzRCalBEKUw0bgwH95SVmBcNFszNxj5KOrbihoohVlg16IcU/
         cuE0LBDTSZg+bzpqf7VDLPEdO9axqPBJ8doVS6whQR+pz75s6Bv4Yx4dkv7Omkpgzy1I
         2uGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hrfT6D6r8NgV0kbWbMFB7eJ0H5Q19iawpNSQkwrO3Zw=;
        b=NO6sw5B1vYG5vHYxvR+3jF3y/SiAJA/SlZzb5TAU+KZ8uMKHwqAbXxhhIqS9YlVua3
         dXvNgGMEOfkTjF28Yq936kIuJtgH2VkN4dEv7ZmZorbmKcWOIQlwEYKus/y3Gk7tUY8b
         D3bk2QFcy2EIbmWPl2lnRHDCAXUcIIyNdruVcWbj8ZVFq/Jli5Z2h5SlPvBrbJWfMR3O
         YfJZqUNkiML2dWH43us3QoMfxvc4QdVapOgcC5dqihPm9Ri1PolMJ+xLOOQfPTDEnQgm
         U+Tq+VgJyNmhf9A/6JRnYklQv5pQWggqPjA/GiRPozntiVIs3orSGfgoRvGRWqnfBjRj
         vjNg==
X-Gm-Message-State: AOAM532/O+/+O53ZLXBDyAYL0TPU5KDOlh3uGm2JP1NHiDtgQ92Co3Tq
        mLBf9j4ZU8+xf5+xschowU+YJMojs7bfl5XH2Ds=
X-Google-Smtp-Source: ABdhPJxOkyr3cz4gxEh2Ke6ki62uWZywliZS86PJZb/UyH5xriM04K4qsIBYKGhxLIpR8DxkeTkVHg==
X-Received: by 2002:a5d:5262:: with SMTP id l2mr826597wrc.190.1630700361562;
        Fri, 03 Sep 2021 13:19:21 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id i4sm360865wmd.5.2021.09.03.13.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:19:21 -0700 (PDT)
Subject: Re: [PATCH v3 09/30] target/arm: Restrict has_work() handler to
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
 <20210902161543.417092-10-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <318478f2-6cea-e9ee-dc9d-442589aa8f56@linaro.org>
Date:   Fri, 3 Sep 2021 22:19:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-10-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> Restrict has_work() to TCG sysemu.
> 
> Signed-off-by: Philippe Mathieu-Daudé<f4bug@amsat.org>
> ---
>   target/arm/cpu.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
