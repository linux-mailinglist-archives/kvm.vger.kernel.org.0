Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0AF7A4F4B
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjIRQjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjIRQis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:38:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF1BAD28
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695054854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yqit+L1v57rv4S72epM2gx/7IZWiOioPzhQAQ8pbRdo=;
        b=Ql4dCmsxUjmRiP07sSItS1BMfs9DPpoqeWHVyCUwTAMgpBgDb3yLu84Bdy5/21WICnc6e1
        XcLlVxMkNHTvODb8XV1B5+VuxqfdvcjDX6kzenCr1UGIqrFXgvt2YKz/XIvDtqEeBruJk1
        MVd7Nckg0VUNPyIEwKbg6bSXxHubfh8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-G-VwVTwQMa6BlM0cGXE4hA-1; Mon, 18 Sep 2023 12:34:12 -0400
X-MC-Unique: G-VwVTwQMa6BlM0cGXE4hA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-313c930ee0eso3010734f8f.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695054851; x=1695659651;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yqit+L1v57rv4S72epM2gx/7IZWiOioPzhQAQ8pbRdo=;
        b=NHPt0Z9zeqRAwrhpX8vffrHugKJrfKuJQwn76rOLceZ6xOp37bnuNvGGsh1h5PkNZ0
         D91dxdN1WndHR/EvfQAB1sd29NYz++t6KJuVV+NHh4PSLjsAlbBLGs83umdq9jwEl7Q1
         XUdLGqjFKmNFM/5VtJPc5sx2b/aJavJmkztJtYghEPvyU0Ibcw1AGhFkPHizGLh8DFza
         9Mumf/eAs3VvFEfTxp1y3m43oXFJXPKkJK7S8hBSafSaTt2GuKqgZGEdRVYiW90fhcLZ
         DViOOARdNKlFRIafZb1OlI3E05GjduxxtJikR55Cz3TfI8MUOeLKVY4jE6QOlqdbVk3L
         C1EA==
X-Gm-Message-State: AOJu0YwNLCSQF20MvdwaXZbFR/U1Wn3SU4SmZODf58g/NfwcrZvl8Rbp
        ZTyqxFWSHklOgCKHQC8tDx7Hw2TMIzJWssbdMuDQT8At6QY1mFDqP7106WBUof0i57VduRa9VwB
        zncHHpDcj+hB2
X-Received: by 2002:a5d:5a15:0:b0:31f:f432:b541 with SMTP id bq21-20020a5d5a15000000b0031ff432b541mr11161250wrb.69.1695054851569;
        Mon, 18 Sep 2023 09:34:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHR9is0Sfqkz6XHdnT9nxCW466u2UED+wVodAbdwIojm0Dvd+7wdCEx6LhGqy3I2hauHihUlw==
X-Received: by 2002:a5d:5a15:0:b0:31f:f432:b541 with SMTP id bq21-20020a5d5a15000000b0031ff432b541mr11161214wrb.69.1695054851162;
        Mon, 18 Sep 2023 09:34:11 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:9d00:cf36:8603:a1f5:d07? (p200300cbc7029d00cf368603a1f50d07.dip0.t-ipconnect.de. [2003:cb:c702:9d00:cf36:8603:a1f5:d07])
        by smtp.gmail.com with ESMTPSA id o12-20020adfeacc000000b003176c6e87b1sm4242342wrn.81.2023.09.18.09.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 09:34:10 -0700 (PDT)
Message-ID: <7bc15c25-2147-409b-0cf7-e3f1b56d5283@redhat.com>
Date:   Mon, 18 Sep 2023 18:34:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 18/22] target/s390x: Call s390_cpu_realize_sysemu from
 s390_realize_cpu_model
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Peter Xu <peterx@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Brian Cain <bcain@quicinc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
        Claudio Fontana <cfontana@suse.de>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Alessandro Di Federico <ale@rev.ng>,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Chris Wulff <crwulff@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
        Bin Meng <bin.meng@windriver.com>,
        Stafford Horne <shorne@gmail.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>, qemu-arm@nongnu.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kurz <groug@kaod.org>, Michael Rolnik <mrolnik@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
References: <20230918160257.30127-1-philmd@linaro.org>
 <20230918160257.30127-19-philmd@linaro.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230918160257.30127-19-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.09.23 18:02, Philippe Mathieu-Daudé wrote:
> s390_cpu_realize_sysemu() runs some checks for the TCG accelerator,
> previous to creating the vCPU. s390_realize_cpu_model() also does
> run some checks for KVM.
> Move the sysemu call to s390_realize_cpu_model(). Having a single
> call before cpu_exec_realizefn() will allow us to factor a
> verify_accel_features() handler out in a pair of commits.
> 
> Directly pass a S390CPU* to s390_cpu_realize_sysemu() to simplify.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/s390x/s390x-internal.h | 2 +-
>   target/s390x/cpu-sysemu.c     | 3 +--
>   target/s390x/cpu.c            | 6 ------
>   target/s390x/cpu_models.c     | 4 ++++
>   4 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/target/s390x/s390x-internal.h b/target/s390x/s390x-internal.h
> index 825252d728..781ac08458 100644
> --- a/target/s390x/s390x-internal.h
> +++ b/target/s390x/s390x-internal.h
> @@ -241,7 +241,7 @@ uint32_t calc_cc(CPUS390XState *env, uint32_t cc_op, uint64_t src, uint64_t dst,
>   unsigned int s390_cpu_halt(S390CPU *cpu);
>   void s390_cpu_unhalt(S390CPU *cpu);
>   void s390_cpu_init_sysemu(Object *obj);
> -bool s390_cpu_realize_sysemu(DeviceState *dev, Error **errp);
> +bool s390_cpu_realize_sysemu(S390CPU *cpu, Error **errp);
>   void s390_cpu_finalize(Object *obj);
>   void s390_cpu_class_init_sysemu(CPUClass *cc);
>   void s390_cpu_machine_reset_cb(void *opaque);
> diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
> index 8112561e5e..5178736c46 100644
> --- a/target/s390x/cpu-sysemu.c
> +++ b/target/s390x/cpu-sysemu.c
> @@ -122,9 +122,8 @@ void s390_cpu_init_sysemu(Object *obj)
>       s390_cpu_set_state(S390_CPU_STATE_STOPPED, cpu);
>   }
>   
> -bool s390_cpu_realize_sysemu(DeviceState *dev, Error **errp)
> +bool s390_cpu_realize_sysemu(S390CPU *cpu, Error **errp)
>   {
> -    S390CPU *cpu = S390_CPU(dev);
>       MachineState *ms = MACHINE(qdev_get_machine());
>       unsigned int max_cpus = ms->smp.max_cpus;
>   
> diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
> index 416ac6c4e0..7257d4bc19 100644
> --- a/target/s390x/cpu.c
> +++ b/target/s390x/cpu.c
> @@ -237,12 +237,6 @@ static void s390_cpu_realizefn(DeviceState *dev, Error **errp)
>           goto out;
>       }
>   
> -#if !defined(CONFIG_USER_ONLY)
> -    if (!s390_cpu_realize_sysemu(dev, &err)) {
> -        goto out;
> -    }
> -#endif
> -
>       cpu_exec_realizefn(cs, &err);
>       if (err != NULL) {
>           goto out;
> diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
> index 98f14c09c2..f030be0d55 100644
> --- a/target/s390x/cpu_models.c
> +++ b/target/s390x/cpu_models.c
> @@ -612,6 +612,10 @@ void s390_realize_cpu_model(CPUState *cs, Error **errp)
>           cpu->env.cpuid = deposit64(cpu->env.cpuid, CPU_PHYS_ADDR_SHIFT,
>                                      CPU_PHYS_ADDR_BITS, cpu->env.core_id);
>       }
> +
> +    if (!s390_cpu_realize_sysemu(cpu, &err)) {
> +        return;
> +    }
>   #endif
>   }
>   

That has nothing to do with CPU models and is, therefore, completely 
misplaced ... :/

Or what am I missing?

-- 
Cheers,

David / dhildenb

