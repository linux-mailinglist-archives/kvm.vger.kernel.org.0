Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E080875105E
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 20:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjGLSPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 14:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjGLSO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 14:14:59 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213FC121;
        Wed, 12 Jul 2023 11:14:58 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4fb87828386so2167802e87.1;
        Wed, 12 Jul 2023 11:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689185696; x=1689790496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5Evk9ENiG1SDXDDuZNxyl9nIkxs8k8T0BFXn0k/GPw=;
        b=KFzcvPhj+xUk0On2B+D8hxj97/proPpUApbFwYl1Hj4NpT+IYUEjS/MoPhDvIfBBSY
         eqvJEwc1KSda9kqz4LmQzpDopZkZXFZoiUMt2J8nrmlhJRickc81o7mrYyNouy5S8NKP
         bOvMTn9iJuq9PnRMC9yhDr9NtD+vc+MS8hxDR4E4xsPvu4S2oR+AMqvOgC4jV+IdT11F
         GbxZUA4eyZZq0ibywlOUshithLSXXSmbL+G1Hc34eQTJTZUl7nr8LE9P3Xt37FH6aSXF
         vXlOBBB3TxXUVi4t291WW7YWfSEiOcgaLoaUGTfpmheisurn+YO6nMpXsFiBpDTMD4tG
         hjeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689185696; x=1689790496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5Evk9ENiG1SDXDDuZNxyl9nIkxs8k8T0BFXn0k/GPw=;
        b=GSd8R5HMLHoc54svxsCmeET39AI9H/+WKaTy7VaP0AxvHFDIQQSFQoNlZdkt8Jdcc9
         5HFGswaN3yeW9dyoNLM+unefHsaUe5P7tvwFTBQJ8JvMSgv0Njii2z2Bm5Z9WqG1qa4y
         gwo9alLe/d/VBP988y6uDnFajrNesj4z0V4N8oHvFeoLxnuHgogOWeXWg5FWAqzt6/lh
         6w6wu3RMDDJVN0ddYgDBmv0yavvyqbF1tAFJMpOrEkSxE/8Qy/w9NIhO/pRjrPCA4ccj
         PxnDmqo2HO0c5V5rR1lNYyVGScIAZoSviBTCDaU4tiNBQKZNUXBW4d+moxIbmMAOSxXt
         oNCA==
X-Gm-Message-State: ABy/qLYzc/qxizLiCkfeKR3NBOuimUGavD/k6eb1XeWNHivQ/uy4AsmH
        PrA1y/yTTS55sdn0MT/Ak8s=
X-Google-Smtp-Source: APBJJlEUWLF9SBfWeZVGjHMr9NYb/VhGT59eIjtUZDVu/qKh39sbMAjb2Qa7H5gkipHxmDMCWAhZCQ==
X-Received: by 2002:a19:f501:0:b0:4fb:8341:43d3 with SMTP id j1-20020a19f501000000b004fb834143d3mr120133lfb.5.1689185695968;
        Wed, 12 Jul 2023 11:14:55 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id x19-20020ac24893000000b004fa039eb84csm804206lfc.198.2023.07.12.11.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 11:14:55 -0700 (PDT)
Date:   Wed, 12 Jul 2023 21:14:53 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Wang Jianchao <jianchwa@outlook.com>
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, arkinjob@outlook.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] KVM: x86: introduce pv feature lazy tscdeadline
Message-ID: <20230712211453.000025f6.zhi.wang.linux@gmail.com>
In-Reply-To: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
References: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Jul 2023 14:17:58 +0800
Wang Jianchao <jianchwa@outlook.com> wrote:

> Hi
> 
> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
> and host side handle it. However, a lot of the vm-exit is unnecessary
> because the timer is often over-written before it expires. 
> 
> v : write to msr of tsc deadline
> | : timer armed by tsc deadline
> 
>          v v v v v        | | | | |
> --------------------------------------->  Time  
> 
> The timer armed by msr write is over-written before expires and the
> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
> 
>          v v v v v        |       |
> --------------------------------------->  Time  
>                           '- arm -'
>

Interesting patch.

I am a little bit confused of the chart above. It seems the write of MSR,
which is said to cause VM exit, is not reduced in the chart of lazy
tscdeadline, only the times of arm are getting less. And the benefit of
lazy tscdeadline is said coming from "less vm exit". Maybe it is better
to imporve the chart a little bit to help people jump into the idea
easily?

> The 1st timer is responsible for arming the next timer. When the armed
> timer is expired, it will check pending and arm a new timer.
> 
> In the netperf test with TCP_RR on loopback, this lazy_tscdeadline can
> reduce vm-exit obviously.
> 
>                          Close               Open
> --------------------------------------------------------
> VM-Exit
>              sum         12617503            5815737
>             intr      0% 37023            0% 33002
>            cpuid      0% 1                0% 0
>             halt     19% 2503932         47% 2780683
>        msr-write     79% 10046340        51% 2966824
>            pause      0% 90               0% 84
>    ept-violation      0% 584              0% 336
>    ept-misconfig      0% 0                0% 2
> preemption-timer      0% 29518            0% 34800
> -------------------------------------------------------
> MSR-Write
>             sum          10046455            2966864
>         apic-icr     25% 2533498         93% 2781235
>     tsc-deadline     74% 7512945          6% 185629
> 
> This patchset is made and tested on 6.4.0, includes 3 patches,
> 
> The 1st one adds necessary data structures for this feature
> The 2nd one adds the specific msr operations between guest and host
> The 3rd one are the one make this feature works.
> 
> Any comment is welcome.
> 
> Thanks
> Jianchao
> 
> Wang Jianchao (3)
> 	KVM: x86: add msr register and data structure for lazy tscdeadline
> 	KVM: x86: exchange info about lazy_tscdeadline with msr
> 	KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
> 
> 
>  arch/x86/include/asm/kvm_host.h      |  10 ++++++++
>  arch/x86/include/uapi/asm/kvm_para.h |   9 +++++++
>  arch/x86/kernel/apic/apic.c          |  47 ++++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/kvm.c                |  13 ++++++++++
>  arch/x86/kvm/cpuid.c                 |   1 +
>  arch/x86/kvm/lapic.c                 | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  arch/x86/kvm/lapic.h                 |   4 +++
>  arch/x86/kvm/x86.c                   |  26 ++++++++++++++++++++
>  8 files changed, 229 insertions(+), 9 deletions(-)

