Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CF74006C2
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350523AbhICUjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350538AbhICUju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:39:50 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13151C061757
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:38:49 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id g135so96665wme.5
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GL9M66YPePviEeJIanaWkTBsfl1Vxvfhn+ruVwm7BCY=;
        b=M/vaAbEmKAIlbeJ47KCqDEuoW1fU8OLbdaCXy0Pvl+0fPEdToeVM22GDpxEzsjWt9v
         WbAqalwQ/WT+6kAtmN1B0nIOitKaIhJ157SyDHY79vxDGA3ucdaq3AJgPv1Ovs1Fv/aB
         1lSLTga+m6SS4hdqpDGzD3Th0/yrB0aZiBPiOV1Y9NoKc6DtcGD50FEYbqTQdUvsRoIH
         T4tRlzq2k7HSirKjelg2CrSPUYVuJ22AUaoX7n0jXoOTIEfbt+eiTX7puG0QvsvjemoW
         Tfwd8Zr/L/8FyDF1XuV7Wb/Ws8ZaMEPMWJ3/JlWVrBtMcJoHyoGb+mo3WTtGcH+kKg2w
         oQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GL9M66YPePviEeJIanaWkTBsfl1Vxvfhn+ruVwm7BCY=;
        b=WWq6P/z6PSZFvq7WQazn/g24k8qs1qsbAMaT/YTL6ZzhxMlRF4vnmOzgitigov+M2s
         r1dQ5vOCyMFtwSuhWS3WcesI284UX2loec2jlq62VBkOkweeRLigPlSbP7315+kdq/ro
         5cvNMTIFPw7Y9mWTY/SHs3dCwBZtpqOIWxX7E/HZfHV6d7nELG8DQ0S0UIr5ED2wZP27
         aGArP/u7h4eoXrihdw9R1b32ZrGs9Iep3Y1r0TvYihhUqLycpr8oSwrhr6W/jwOVq7BQ
         R3RbAp38NnEvkRp2uTqN9tPsGSlA8souUheCJeAyEr07DgrVgPVQCjoEAS5RzM0DOgsM
         xoEQ==
X-Gm-Message-State: AOAM532P0Lrw9koGYCY8rGi7wzE8a7wl2+d11kWuAV8baL6bxL/Xxf8q
        pugTx3DarMYydfkWGLFU0d3vcw==
X-Google-Smtp-Source: ABdhPJyQ/VEZImP2sey8PyCscUHWehgMFHJDN9IuQ3kxtIigmhduRyDKYPM4Bvm1IEM1SgOYGjMY+A==
X-Received: by 2002:a1c:2547:: with SMTP id l68mr468593wml.23.1630701527658;
        Fri, 03 Sep 2021 13:38:47 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id w9sm286608wrs.7.2021.09.03.13.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:38:47 -0700 (PDT)
Subject: Re: [PATCH v3 08/30] target/alpha: Restrict has_work() handler to
 sysemu and TCG
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Bin Meng <bin.meng@windriver.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, haxm-team@intel.com,
        Colin Xu <colin.xu@intel.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Stafford Horne <shorne@gmail.com>, Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Paul Durrant <paul@xen.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Claudio Fontana <cfontana@suse.de>,
        Anthony Perard <anthony.perard@citrix.com>,
        xen-devel@lists.xenproject.org,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kurz <groug@kaod.org>, Cameron Esfahani <dirty@apple.com>,
        qemu-s390x@nongnu.org, qemu-arm@nongnu.org,
        Michael Rolnik <mrolnik@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-riscv@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Chris Wulff <crwulff@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-ppc@nongnu.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210902161543.417092-1-f4bug@amsat.org>
 <20210902161543.417092-9-f4bug@amsat.org>
 <3cd48aba-a1a1-cde3-3175-e9c462fcb220@linaro.org>
 <740a2e5c-3dad-fc7d-b54a-0c405faa605e@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <8c70c273-cb11-c6da-a456-c906df86326b@linaro.org>
Date:   Fri, 3 Sep 2021 22:38:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <740a2e5c-3dad-fc7d-b54a-0c405faa605e@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/21 10:34 PM, Philippe Mathieu-Daudé wrote:
>> Drop CONFIG_TCG for alpha; it's always true.
> 
> What is the rational? "Old" architectures (with no active /
> official hw development) are unlikely to add hardware
> acceleration, so TCG is the single one possible? Thus no
> need to clutter the code with obvious #ifdef'ry?

Correct.  Broadly, if git grep CONFIG_TCG is empty in a subdirectory, don't add the first 
instance.


r~
