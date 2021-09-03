Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87C5400692
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350526AbhICU0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350304AbhICU0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:26:37 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0994C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:25:36 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t15so333930wrg.7
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W7k4RtqOZy7ya1WayabP+HxNcp5Fq3Mk2ZbTc+R+8wk=;
        b=Y7PtSwX3LA3cO29hKgEQ0rkI844j3EG/DnwVbuMutIDQuUE90Uvns4x6mk4yf7B+cm
         Z6Ehutu4130di1yQJkVCvyamcRHY9V7H8+/nW9cFA4cQP7R4+86sspF6SjVkmgr6mnbK
         taRoXaEV9tG9Hfk01UC455nNMEqk+FHQaJULcihgVHUwNroTfGeteSjAaIcGVZ3lfe7k
         vWQNvEvJXomiaKpwJ4tHqL+1JgHxOaDk5BcG2O5Ba51DpymToNVYzbCqx9P90GXzyM8j
         2b3ZUyaRty9XmOwlTzWm7qEP3nm+1Lkh4CwG0qqunwT4jbB+PrEQJvI5TjsNGJMxJsoD
         DntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W7k4RtqOZy7ya1WayabP+HxNcp5Fq3Mk2ZbTc+R+8wk=;
        b=r63ssU7Q58TKI13tLm2iSq5SXgySVuVbd+OVoA/K30YR5StC0yfKu0tLrOBPH1rNoX
         Rg+Liyvz+Oiok+fIJQXuta6Qe7/jZqS2AFF86P8Jf4374LFRRo+Be5j7dMbMD8ofoJB1
         yL5JNjBLJqYbd5HZ6uPh9YBsiP+AmmfPu96Srp0P0ec9KUXadt1t/9VG2A7M8jgGcNjO
         usUW7zcEyntQLX8JzQ7sFumdTAR3rF/1y32BJNTcsx0E3VXN4dnnv68sd04x/0TbT78S
         oFvGjbv1V4dh1CmMOxKXTd4brG4SE+yHdKYQk3EB0IhmNNrSKiiRNotLCTFcuOW5EqCW
         9Mtw==
X-Gm-Message-State: AOAM53316t8gVeHEeK0FB132NbNEPaHrwed9gAU1JniaLwuN8OgRadVS
        1pWNw3S7C73CZwMsJiEq8FZuaxZ1TQ1SgE41hsU=
X-Google-Smtp-Source: ABdhPJy/o6kXb1fKJrZGJ7NA/+HnxHPvtkph89J5ZY0ajIZpI/IL3HlrDNTpZbKsJbsJhN5+OKI2UQ==
X-Received: by 2002:adf:d239:: with SMTP id k25mr830865wrh.314.1630700735383;
        Fri, 03 Sep 2021 13:25:35 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id q13sm324320wmj.46.2021.09.03.13.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:25:35 -0700 (PDT)
Subject: Re: [PATCH v3 16/30] target/microblaze: Restrict has_work() handler
 to sysemu and TCG
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
 <20210902161543.417092-17-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <acaab338-bc0c-3c06-37ea-dee2ba753900@linaro.org>
Date:   Fri, 3 Sep 2021 22:25:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-17-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> Restrict has_work() to TCG sysemu.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>   target/microblaze/cpu.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/target/microblaze/cpu.c b/target/microblaze/cpu.c
> index 15db277925f..74fbb5d201a 100644
> --- a/target/microblaze/cpu.c
> +++ b/target/microblaze/cpu.c
> @@ -92,12 +92,15 @@ static void mb_cpu_synchronize_from_tb(CPUState *cs,
>       cpu->env.iflags = tb->flags & IFLAGS_TB_MASK;
>   }
>   
> +#ifndef CONFIG_USER_ONLY
> +
> +#ifdef CONFIG_TCG
>   static bool mb_cpu_has_work(CPUState *cs)

No CONFIG_TCG, otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
