Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67F54006AF
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbhICUff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236839AbhICUff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:35:35 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DCDC061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:34:34 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id i6so382570wrv.2
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LFeEcrxPmiQ0y9mkjFms4J4GrCvxgbbAZyrEPk3foT8=;
        b=blhwVscSGxsnvMX9mpwF1WKnN0xyca3wo+jPJrvx7iJfDyuaVBJ0KE2ZZYoLwyB4Qb
         4ovLs/5Mxxmi9wMRp2vY8kz61AoNMdOvCCJQ1ezWt/9nx9cQ0hjn+MeBnxsE8IfF+HWm
         MRXjSCyRODB4tHb2j9tg9SRHAw9DJhbv0/cKEArMyfVM1qOCRF3s4YzT2Dln7MMoqaZq
         y6iKsF7H+hxlB36Mu4fKWpUJ5EAdcOvfMVCI3XguqcRlT/JRvp5sK6I5Rgfg+ycwLNfj
         b/WnJWkRX3vTttRdmBA7xpv8BARViFg/xzi1CERUqrSWq87BIGBc2CT5TLVm4/NdQPul
         vUWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LFeEcrxPmiQ0y9mkjFms4J4GrCvxgbbAZyrEPk3foT8=;
        b=SSg0Vu6+EGwJooA6fCWMouQr9B0nK7uafPxhDWsLUcexcOwef7Y66R/Z53E68NEKec
         nWG8PKkHiNU8c6vNOxm7u5gZpvPoxJ0j5hNbCOnhgOqBvQG6nKSuB4zoUAmnEpKm6XQI
         B90ifGWJD7GNmDcTJG+U5a3ev4XVZ8RPAtThY9kbJgXfN8KRd1M8JcapmhTDHoWUMhdo
         DvlvKRCnmHBvbTrU+Pkl8mUtBGEzHJ8P6SysuXjIpkNbsKm5fzVDRDXNjilRj3i0VWPi
         nWNSSWtS69b/N1k1g+S0g6kTXwiW2hrBVQ0yGZy/v/26XKBxCuChTGIpfCBSzm9k2FHM
         CeTA==
X-Gm-Message-State: AOAM5335D0xPQ4X1kqmg7EA1hOQ1qyBahYnj8pHF9gKi0aI55LWF9PHx
        YX9ftzi6+HuPN33lgl2MwO0=
X-Google-Smtp-Source: ABdhPJzlEMbpTMPYknNobW93n1KQ+VYIJEKgvJhtzWFM57YHy480w/4A7Y7tiGaFvSIUZksLBnn7iw==
X-Received: by 2002:adf:804a:: with SMTP id 68mr886849wrk.236.1630701273190;
        Fri, 03 Sep 2021 13:34:33 -0700 (PDT)
Received: from [192.168.1.36] (21.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.21])
        by smtp.gmail.com with ESMTPSA id d7sm258631wrs.39.2021.09.03.13.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:34:32 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v3 08/30] target/alpha: Restrict has_work() handler to
 sysemu and TCG
To:     Richard Henderson <richard.henderson@linaro.org>,
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
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <740a2e5c-3dad-fc7d-b54a-0c405faa605e@amsat.org>
Date:   Fri, 3 Sep 2021 22:34:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3cd48aba-a1a1-cde3-3175-e9c462fcb220@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/21 10:18 PM, Richard Henderson wrote:
> On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
>> Restrict has_work() to TCG sysemu.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>>   target/alpha/cpu.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/alpha/cpu.c b/target/alpha/cpu.c
>> index 93e16a2ffb4..32cf5a2ea9f 100644
>> --- a/target/alpha/cpu.c
>> +++ b/target/alpha/cpu.c
>> @@ -33,6 +33,7 @@ static void alpha_cpu_set_pc(CPUState *cs, vaddr value)
>>       cpu->env.pc = value;
>>   }
>>   +#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
>>   static bool alpha_cpu_has_work(CPUState *cs)
> 
> Drop CONFIG_TCG for alpha; it's always true.

What is the rational? "Old" architectures (with no active /
official hw development) are unlikely to add hardware
acceleration, so TCG is the single one possible? Thus no
need to clutter the code with obvious #ifdef'ry?

> Otherwise,
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> r~
> 
