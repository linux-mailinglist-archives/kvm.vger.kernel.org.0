Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D711C7563A6
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 15:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjGQNAA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Jul 2023 09:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjGQM75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 08:59:57 -0400
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419EE1996;
        Mon, 17 Jul 2023 05:59:37 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-98dfd15aae1so92632466b.0;
        Mon, 17 Jul 2023 05:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689598722; x=1690203522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXE6oBBzgX3OAK0eXsIC/eJFCi9A6qIcdL50wwUhys4=;
        b=XSOpJRcrhQh5Y2YFRACUZDJV6eQTynt8SvkAa07fhtIxDjER48KlmSoN6eQt1yX1aY
         0Wk3SUYid7PioOe19qAYNhxa+vzn5aSHGD+b4WdKdjRIYx4cpl5HZ3h+3tFNzxxbPcEn
         RLE+JFc7cSXozuuZZCpdbBOsVxUYlbSKc3TfrJspMDwe6Yt8uizm6ZY90FBBUXWJ0yAY
         1uJGQSFMW6iDIFyxJEeU7WxY6wvYxT/l4uRveMEdbR/fR1YgHiXEMMN2IdvSicQoC9u9
         8YX42ejRanEPAuOXOEljAsov4NRhsdp9WsA1yMstFcnDd53JetcOyk5peA3KOIUUI740
         G93Q==
X-Gm-Message-State: ABy/qLZ6kXGG7dzQjdffxtC111PcB/6pJ1Jn2kMOpXtlFTImZmZb/Wnl
        JPvH2dqhQ11a6X8StBgtDp84mr/iS4y16NCR2YuhuMTG
X-Google-Smtp-Source: APBJJlFOzol0QVRs0gt4sQDScxJ3sCa5i3pNU2tWqV55uQHsZMvfQ4bLJAXLw29qJljudHWB5tOm9oV4zWDF9O01Mew=
X-Received: by 2002:a17:906:73ca:b0:993:d7d2:7f1c with SMTP id
 n10-20020a17090673ca00b00993d7d27f1cmr7976138ejl.5.1689598721855; Mon, 17 Jul
 2023 05:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230605154716.840930-1-arjan@linux.intel.com>
 <20230605154716.840930-4-arjan@linux.intel.com> <5c7de6d5-7706-c4a5-7c41-146db1269aff@intel.com>
In-Reply-To: <5c7de6d5-7706-c4a5-7c41-146db1269aff@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 17 Jul 2023 14:58:26 +0200
Message-ID: <CAJZ5v0gaZHpAri7LRcfpS2TyK_Bsjuxkw9cZUm_uGZAgiub4Jw@mail.gmail.com>
Subject: Re: [PATCH 3/4] intel_idle: Add support for using intel_idle in a VM
 guest using just hlt
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     arjan@linux.intel.com, linux-pm@vger.kernel.org,
        artem.bityutskiy@linux.intel.com, rafael@kernel.org,
        kvm <kvm@vger.kernel.org>, Dan Wu <dan1.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 17, 2023 at 10:34 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> + KVM maillist.
>
> On 6/5/2023 11:47 PM, arjan@linux.intel.com wrote:
> ...
> >
> > +static int __init intel_idle_vminit(const struct x86_cpu_id *id)
> > +{
> > +     int retval;
> > +
> > +     cpuidle_state_table = vmguest_cstates;
> > +
> > +     icpu = (const struct idle_cpu *)id->driver_data;
> > +
> > +     pr_debug("v" INTEL_IDLE_VERSION " model 0x%X\n",
> > +              boot_cpu_data.x86_model);
> > +
> > +     intel_idle_cpuidle_devices = alloc_percpu(struct cpuidle_device);
> > +     if (!intel_idle_cpuidle_devices)
> > +             return -ENOMEM;
> > +
> > +     intel_idle_cpuidle_driver_init(&intel_idle_driver);
> > +
> > +     retval = cpuidle_register_driver(&intel_idle_driver);
> > +     if (retval) {
> > +             struct cpuidle_driver *drv = cpuidle_get_driver();
> > +             printk(KERN_DEBUG pr_fmt("intel_idle yielding to %s\n"),
> > +                    drv ? drv->name : "none");
> > +             goto init_driver_fail;
> > +     }
> > +
> > +     retval = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "idle/intel:online",
> > +                                intel_idle_cpu_online, NULL);
> > +     if (retval < 0)
> > +             goto hp_setup_fail;
> > +
> > +     return 0;
> > +hp_setup_fail:
> > +     intel_idle_cpuidle_devices_uninit();
> > +     cpuidle_unregister_driver(&intel_idle_driver);
> > +init_driver_fail:
> > +     free_percpu(intel_idle_cpuidle_devices);
> > +     return retval;
> > +}
> > +
> >   static int __init intel_idle_init(void)
> >   {
> >       const struct x86_cpu_id *id;
> > @@ -2074,6 +2195,8 @@ static int __init intel_idle_init(void)
> >       id = x86_match_cpu(intel_idle_ids);
> >       if (id) {
> >               if (!boot_cpu_has(X86_FEATURE_MWAIT)) {
> > +                     if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> > +                             return intel_idle_vminit(id);
>
> It leads to below MSR access error on SPR.
>
> [    4.158636] unchecked MSR access error: RDMSR from 0xe2 at rIP:
> 0xffffffffbcaeebed (intel_idle_init_cstates_icpu.constprop.0+0x2dd/0x5a0)
> [    4.174991] Call Trace:
> [    4.179611]  <TASK>
> [    4.183610]  ? ex_handler_msr+0x11e/0x150
> [    4.190624]  ? fixup_exception+0x17e/0x3c0
> [    4.197648]  ? gp_try_fixup_and_notify+0x1d/0xc0
> [    4.205579]  ? exc_general_protection+0x1bb/0x410
> [    4.213620]  ? asm_exc_general_protection+0x26/0x30
> [    4.221624]  ? __pfx_intel_idle_init+0x10/0x10
> [    4.228588]  ? intel_idle_init_cstates_icpu.constprop.0+0x2dd/0x5a0
> [    4.238632]  ? __pfx_intel_idle_init+0x10/0x10
> [    4.246632]  ? __pfx_intel_idle_init+0x10/0x10
> [    4.253616]  intel_idle_vminit.isra.0+0xf5/0x1d0
> [    4.261580]  ? __pfx_intel_idle_init+0x10/0x10
> [    4.269670]  ? __pfx_intel_idle_init+0x10/0x10
> [    4.274605]  do_one_initcall+0x50/0x230
> [    4.279873]  do_initcalls+0xb3/0x130
> [    4.286535]  kernel_init_freeable+0x255/0x310
> [    4.293688]  ? __pfx_kernel_init+0x10/0x10
> [    4.300630]  kernel_init+0x1a/0x1c0
> [    4.305681]  ret_from_fork+0x29/0x50
> [    4.312700]  </TASK>
>
> On Intel SPR, the call site is
>
> intel_idle_vminit()
>    -> intel_idle_cpuidle_driver_init()
>      -> intel_idle_init_cstates_icpu()
>        -> spr_idle_state_table_update()
>          -> rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, msr);
>
> However, current KVM doesn't provide emulation for
> MSR_PKG_CST_CONFIG_CONTROL. It leads to #GP on accessing.
>
> >                       pr_debug("Please enable MWAIT in BIOS SETUP\n");
> >                       return -ENODEV;
> >               }

Well, I'm waiting for a fix from Arjan, thanks!
