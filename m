Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A87F63FD8F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 02:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiLBBRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 20:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiLBBRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 20:17:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65C3BB007
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 17:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669943793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8raBElocjG+t7Z576KbcBzbA6x08SH2I7LOvae+fW3w=;
        b=DphpiExuxJ3oorRTKWlib1+n/ytnh8dMujIfPRk+P5cF7ymjsP9UKOCi4zCj8GU0EZ5/+r
        YnGu1bbiqoEQFl7RYgv+Bsl1qzFmjCaihuD9786C7Hj5ri9D048DwaK2Xy+b064KWfNG5r
        VnVSIVAXOb12LFysWXgT81arFVMflZU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-132-vMuBks6LO82rTsA1GdQg0w-1; Thu, 01 Dec 2022 20:16:32 -0500
X-MC-Unique: vMuBks6LO82rTsA1GdQg0w-1
Received: by mail-ed1-f71.google.com with SMTP id w4-20020a05640234c400b004631f8923baso1695585edc.5
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 17:16:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8raBElocjG+t7Z576KbcBzbA6x08SH2I7LOvae+fW3w=;
        b=8LlojIhmfhE6An6AV6X0OUb3u5vGT6fkW1/HZE+VUlWMPlJ8xOq+a7l/GmLNvLPKmG
         IZvRLeYiL32Ph4jKEpHYiZ5ZY2enfKbI1/FGNskW+KiXwQpCeVUoNGZiRtjnFvRBfH0O
         Hii2Fv0bGSxBqgUJFVOn9OPnrTF9cldPTcpknhMPUnks8B1kXfvBR2/tS96MKjtb2lYl
         QaZOtbx6YiKNQLr+VHXzG0Z3KSaFtMi6/yw2q7282m7vKz6EPMpzNO6Ja9opFCZchptF
         3lMVzZ/MoxcwlL/8vqHHJAsx+CFN2suAfIOSxeZxczEcFk+0JFX+ONbRGPuFOeV43BbH
         qD3g==
X-Gm-Message-State: ANoB5plSkiBcUtdCWqWmObMZhpwp1mBhiNuNl+vXiwO7D4vigVqr7kNw
        cXjB+ukjXq6F+1zfltqMlkh8Mnwd1hRCsBUEn8wevz3ILx2FyOrhFzAUFUYhGKKyLBjtopedP1x
        q1jypQVB5zI0m
X-Received: by 2002:a17:906:8616:b0:7ac:db70:3ab5 with SMTP id o22-20020a170906861600b007acdb703ab5mr58215752ejx.160.1669943789690;
        Thu, 01 Dec 2022 17:16:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5DD/PVWtDOqetlcstMmsJ7MWcNf9tn4t1t6dCDSsyjo3/YdfehE39IoyjS0zJt1qxjwjKzFg==
X-Received: by 2002:a17:906:8616:b0:7ac:db70:3ab5 with SMTP id o22-20020a170906861600b007acdb703ab5mr58215739ejx.160.1669943789445;
        Thu, 01 Dec 2022 17:16:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id a20-20020a17090680d400b007c081cf2d25sm2379668ejx.204.2022.12.01.17.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 17:16:28 -0800 (PST)
Message-ID: <d1499221-99ca-0024-3094-81cd1b5787e5@redhat.com>
Date:   Fri, 2 Dec 2022 02:16:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     "Ashish Gupta (SJC)" <ashish.gupta1@nutanix.com>,
        Suresh Gumpula <suresh.gumpula@nutanix.com>,
        Felipe Franciosi <felipe@nutanix.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        John Levon <john.levon@nutanix.com>,
        Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>
References: <PH0PR02MB84228844F6176836E8C86B1BA40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
 <df01b973-d56c-7ba9-866f-9ca47dccd123@redhat.com>
 <PH0PR02MB84229CEBB3C7A8DAC626107CA40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
 <PH0PR02MB8422D2C6A7F56200FCD384D8A40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
 <CABgObfa+NKKeV=178L348VfrZkB7sa2kCZ1V1kwU+3pKfUd2jg@mail.gmail.com>
 <PH0PR02MB84221C062510FCFAEE7EE9BAA4109@PH0PR02MB8422.namprd02.prod.outlook.com>
 <0f4b560d-8148-6a1e-6634-6d31168d5032@redhat.com>
 <PH0PR02MB8422C61596331E2B17E476C7A4149@PH0PR02MB8422.namprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Nvidia GPU PCI passthrough and kernel commit
 #5f33887a36824f1e906863460535be5d841a4364
In-Reply-To: <PH0PR02MB8422C61596331E2B17E476C7A4149@PH0PR02MB8422.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/22 01:29, Ashish Gupta (SJC) wrote:
> Hi Paolo,
> 
> While we were accessing code change done by commit : 
> 5f33887a36824f1e906863460535be5d841a4364
> 
> Bijan, noticed following:
> 
>  From the changed code in commit  # 
> 5f33887a36824f1e906863460535be5d841a4364 , we see that the following check
> 
> !kvm_vcpu_apicv_active(vcpu)*/)/*
> 
> has been removed, so in fact the new code is basically assuming that 
> apicv is always active.

Right, instead it checks irqchip_in_kernel(kvm) && enable_apicv.  This 
is documented in the commit message:

     However, these checks do not attempt to synchronize with changes to
     the IRTE.  In particular, there is no path that updates the IRTE
     when APICv is re-activated on vCPU 0; and there is no path to wakeup
     a CPU that has APICv disabled, if the wakeup occurs because of an
     IRTE that points to a posted interrupt.

The full series is at 
https://lore.kernel.org/lkml/20211123004311.2954158-2-pbonzini@redhat.com/T/ 
and has more details:

     Now that APICv can be disabled per-CPU (depending on whether it has
     some setup that is incompatible) we need to deal with guests having
     a mix of vCPUs with enabled/disabled posted interrupts.  For
     assigned devices, their posted interrupt configuration must be the
     same across the whole VM, so handle posted interrupts by hand on
     vCPUs with disabled posted interrupts.

All four patches were marked as stable, but it looks like the first 
three did not apply and therefore are not part of 5.10.

78311a514099932cd8434d5d2194aa94e56ab67c
     KVM: x86: ignore APICv if LAPIC is not enabled
7e1901f6c86c896acff6609e0176f93f756d8b2a
     KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled
37c4dbf337c5c2cdb24365ffae6ed70ac1e74d7a
     KVM: x86: check PIR even for vCPUs with disabled APICv

The three commits do not have any subsequent commit that Fixes them.

> The latest upstream code however seems to disable apicv conditionally 
> depending on if it is actually being used:

Right.

> We found that, once we disable hyperv benightment for Linux vm, 
> everything is working fine (on v5.10.84)
> 
> Further Eiichi noticed, that your change were introduced in 5.16 and 
> backported to 5.10.84.
> 
> On the other hand, Vitaly's patch (commit 
> #0f250a646382e017725001a552624be0c86527bf) was introduced in 5.15 and 
> NOT backported to 5.10.X.
> 
> Should we backport Vitaly's patch to stable 5.10.X? Do you think that 
> will solve issue what we are facing?

As you found out there are a lot of dependent changes to introduce 
__kvm_request_apicv_update so it's not really feasible.

Paolo

