Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD27643543
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 21:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiLEUI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 15:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiLEUIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 15:08:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD731EEEF
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 12:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670270850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w4L03zaq4MniaU3GiEE4NcsRzKJm0thD/35+0pTdDu4=;
        b=PPkvwJCAqg2F6c2QSHpmzNVKAcKK/V1n+MDQFf17ocTeddALo0VXAx87IDUHN1RV4qzeAe
        QYQW2giKyS4bABUDj5h7Y0I3P3uVF3F9/i1xcNafkB89Wu7fpAVxaRoinAmU+VKBP3g/2y
        MEX2EZgg55Wyvg1k50vTvRAMFZRm6Xw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-9ssnK8R-Pbq8m7UxGoPK4A-1; Mon, 05 Dec 2022 15:07:29 -0500
X-MC-Unique: 9ssnK8R-Pbq8m7UxGoPK4A-1
Received: by mail-ej1-f70.google.com with SMTP id ga41-20020a1709070c2900b007aef14e8fd7so220128ejc.21
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 12:07:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w4L03zaq4MniaU3GiEE4NcsRzKJm0thD/35+0pTdDu4=;
        b=bE73pNWIGYqLFlPednpz42GCUYWmTT5t88oQuY6/picwRaRvZXySqsdXJV/1/Vui7f
         YIG7zUtQ8Zfzk0m271pNjirUli6KmOiy5p21OPlCWiHB4/wGf9wMxXp9pMriUZGUvBG7
         jV2uo9T+ci5WuQKPgMdAuSE+RUDm/G7Ekk9oqkIZgOgP/UuhOHGJrRiwsmrIKjMpkJ4/
         NFLluPISNa5u2Mu8ZGawAiAFxGXfl/ZGschXkfmJLlkfRspoEXsSCtk1pG59p5E0ulQP
         ZulGaiinC0TVyuzfSONNn+ekxrJzZ7rQrysU/cX6JWPGvvHJ3GlYOvr1WoPcqtzVIqbU
         YePQ==
X-Gm-Message-State: ANoB5pl7CNx7eXzenu2YEaoTy6iWqA+0feAGUNomBdU+ebdQ0j76bS8K
        o/DC3hZ0r40wQjfo95JTgbjxdsMlyjioeJNoPnpI6bKNctALgIsnXi6c3w6MKIOlpdBFo9LqeLx
        iZLdz9NRyk71O
X-Received: by 2002:a17:906:b08b:b0:78d:e608:f064 with SMTP id x11-20020a170906b08b00b0078de608f064mr70727966ejy.34.1670270847329;
        Mon, 05 Dec 2022 12:07:27 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6IivLGuhjVp28IUe6mCw7E0fb62x1/qL0aemNVgmsQ6/Tkl6f3SC4wxuXc1sfrAUM0Ph5ezQ==
X-Received: by 2002:a17:906:b08b:b0:78d:e608:f064 with SMTP id x11-20020a170906b08b00b0078de608f064mr70727950ejy.34.1670270847052;
        Mon, 05 Dec 2022 12:07:27 -0800 (PST)
Received: from [192.168.10.118] ([93.56.171.98])
        by smtp.googlemail.com with ESMTPSA id rr25-20020a170907899900b007c00323cc23sm6548439ejc.27.2022.12.05.12.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 12:07:26 -0800 (PST)
Message-ID: <77053a1d-1bb7-add5-1927-d574f86de8c5@redhat.com>
Date:   Mon, 5 Dec 2022 21:04:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: Nvidia GPU PCI passthrough and kernel commit
 #5f33887a36824f1e906863460535be5d841a4364
Content-Language: en-US
To:     "Ashish Gupta (SJC)" <ashish.gupta1@nutanix.com>
Cc:     Suresh Gumpula <suresh.gumpula@nutanix.com>,
        Felipe Franciosi <felipe@nutanix.com>,
        kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
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
 <d1499221-99ca-0024-3094-81cd1b5787e5@redhat.com>
 <PH0PR02MB842221DE947D855CD1BF8AEFA4179@PH0PR02MB8422.namprd02.prod.outlook.com>
 <CABgObfaacMm0-igSCj5L5Ppc4arT2znpzT1+GqLO9kFgainBZA@mail.gmail.com>
 <PH0PR02MB8422F29708DF1CF961C580D1A4169@PH0PR02MB8422.namprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <PH0PR02MB8422F29708DF1CF961C580D1A4169@PH0PR02MB8422.namprd02.prod.outlook.com>
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

On 12/3/22 18:27, Ashish Gupta (SJC) wrote:
> As I have ready setup to test this out, I can patch these missing 3 
> missing patches and test.
> 
> I would like to understand if there are any other patches (from other 
> author) which you think would be needed as well.

There shouldn't be any others, on the other hand they probably do not 
apply right away otherwise Greg would have included them.  I'm not sure 
if the backport will be simpler if more patches are added, or if the 
required changes are trivial.

Paolo

> Please let me know.
> 
> I will start with your patches first.
> 
> Regards,
> 
> --Ashish Gupta
> 
> *From: *Paolo Bonzini <pbonzini@redhat.com>
> *Date: *Friday, December 2, 2022 at 1:39 PM
> *To: *Ashish Gupta (SJC) <ashish.gupta1@nutanix.com>
> *Cc: *Suresh Gumpula <suresh.gumpula@nutanix.com>, Felipe Franciosi 
> <felipe@nutanix.com>, kvm <kvm@vger.kernel.org>, Sean Christopherson 
> <seanjc@google.com>, John Levon <john.levon@nutanix.com>, Bijan 
> Mottahedeh <bijan.mottahedeh@nutanix.com>, Eiichi Tsukata 
> <eiichi.tsukata@nutanix.com>
> *Subject: *Re: Nvidia GPU PCI passthrough and kernel commit 
> #5f33887a36824f1e906863460535be5d841a4364
> 
> Yes, I think so. Are you going to test a backport of the three missing 
> patches or would you like me to prepare it?
> 
> Thanks for the report and the tests!
> 
> Paolo
> 
> Il ven 2 dic 2022, 20:59 Ashish Gupta (SJC) <ashish.gupta1@nutanix.com 
> <mailto:ashish.gupta1@nutanix.com>> ha scritto:
> 
>     Thanks Paolo,
> 
>     > All four patches were marked as stable, but it looks like the first
>     > three did not apply and therefore are not part of 5.10.
> 
>     Sounds like subset of changes are committed (backported) to 5.10.x
>     kernel and some are not.
> 
>     Wouldn’t that make 5.10.x kernel unstable for this kind of issue?
> 
>     Do you think, we should backport all those relevant changes in
>     stable branch like 5.10.x including patches from other authors also
>     around this area?
> 
>     Regards,
> 
>     --Ashish Gupta
> 
>     *From: *Paolo Bonzini <pbonzini@redhat.com <mailto:pbonzini@redhat.com>>
>     *Date: *Thursday, December 1, 2022 at 5:16 PM
>     *To: *Ashish Gupta (SJC) <ashish.gupta1@nutanix.com
>     <mailto:ashish.gupta1@nutanix.com>>, Suresh Gumpula
>     <suresh.gumpula@nutanix.com <mailto:suresh.gumpula@nutanix.com>>,
>     Felipe Franciosi <felipe@nutanix.com <mailto:felipe@nutanix.com>>
>     *Cc: *kvm@vger.kernel.org <mailto:kvm@vger.kernel.org>
>     <kvm@vger.kernel.org <mailto:kvm@vger.kernel.org>>,
>     seanjc@google.com <mailto:seanjc@google.com> <seanjc@google.com
>     <mailto:seanjc@google.com>>, John Levon <john.levon@nutanix.com
>     <mailto:john.levon@nutanix.com>>, Bijan Mottahedeh
>     <bijan.mottahedeh@nutanix.com
>     <mailto:bijan.mottahedeh@nutanix.com>>, Eiichi Tsukata
>     <eiichi.tsukata@nutanix.com <mailto:eiichi.tsukata@nutanix.com>>
>     *Subject: *Re: Nvidia GPU PCI passthrough and kernel commit
>     #5f33887a36824f1e906863460535be5d841a4364
> 
>     On 12/2/22 01:29, Ashish Gupta (SJC) wrote:
>     > Hi Paolo,
>     > 
>     > While we were accessing code change done by commit : 
>     > 5f33887a36824f1e906863460535be5d841a4364
>     > 
>     > Bijan, noticed following:
>     > 
>     >  From the changed code in commit  # 
>     > 5f33887a36824f1e906863460535be5d841a4364 , we see that the following check
>     > 
>     > !kvm_vcpu_apicv_active(vcpu)*/)/*
>     > 
>     > has been removed, so in fact the new code is basically assuming that 
>     > apicv is always active.
> 
>     Right, instead it checks irqchip_in_kernel(kvm) && enable_apicv.  This
>     is documented in the commit message:
> 
>           However, these checks do not attempt to synchronize with
>     changes to
>           the IRTE.  In particular, there is no path that updates the IRTE
>           when APICv is re-activated on vCPU 0; and there is no path to
>     wakeup
>           a CPU that has APICv disabled, if the wakeup occurs because of an
>           IRTE that points to a posted interrupt.
> 
>     The full series is at
>     https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_lkml_20211123004311.2954158-2D2-2Dpbonzini-40redhat.com_T_&d=DwIDaQ&c=s883GpUCOChKOHiocYtGcg&r=NSViKyfbZLLlRE5iJBGkhRVXJKqWdgMN8wGfv1tfc2E&m=iEB57vPMXHVPBeayAOwoHp32BcSlX-J5ig4nd4bnfDs1XqL3ykppJ1b1qVu9cuz_&s=nlSZ4vVygCrPKCaCRjJWrVFphM6Pym_iVYc-fBbjrc4&e= <https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_lkml_20211123004311.2954158-2D2-2Dpbonzini-40redhat.com_T_&d=DwIDaQ&c=s883GpUCOChKOHiocYtGcg&r=NSViKyfbZLLlRE5iJBGkhRVXJKqWdgMN8wGfv1tfc2E&m=iEB57vPMXHVPBeayAOwoHp32BcSlX-J5ig4nd4bnfDs1XqL3ykppJ1b1qVu9cuz_&s=nlSZ4vVygCrPKCaCRjJWrVFphM6Pym_iVYc-fBbjrc4&e=>
>     and has more details:
> 
>           Now that APICv can be disabled per-CPU (depending on whether
>     it has
>           some setup that is incompatible) we need to deal with guests
>     having
>           a mix of vCPUs with enabled/disabled posted interrupts.  For
>           assigned devices, their posted interrupt configuration must be the
>           same across the whole VM, so handle posted interrupts by hand on
>           vCPUs with disabled posted interrupts.
> 
>     All four patches were marked as stable, but it looks like the first
>     three did not apply and therefore are not part of 5.10.
> 
>     78311a514099932cd8434d5d2194aa94e56ab67c
>           KVM: x86: ignore APICv if LAPIC is not enabled
>     7e1901f6c86c896acff6609e0176f93f756d8b2a
>           KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled
>     37c4dbf337c5c2cdb24365ffae6ed70ac1e74d7a
>           KVM: x86: check PIR even for vCPUs with disabled APICv
> 
>     The three commits do not have any subsequent commit that Fixes them.
> 
>     > The latest upstream code however seems to disable apicv conditionally 
>     > depending on if it is actually being used:
> 
>     Right.
> 
>     > We found that, once we disable hyperv benightment for Linux vm, 
>     > everything is working fine (on v5.10.84)
>     > 
>     > Further Eiichi noticed, that your change were introduced in 5.16 and 
>     > backported to 5.10.84.
>     > 
>     > On the other hand, Vitaly's patch (commit 
>     > #0f250a646382e017725001a552624be0c86527bf) was introduced in 5.15 and 
>     > NOT backported to 5.10.X.
>     > 
>     > Should we backport Vitaly's patch to stable 5.10.X? Do you think that 
>     > will solve issue what we are facing?
> 
>     As you found out there are a lot of dependent changes to introduce
>     __kvm_request_apicv_update so it's not really feasible.
> 
>     Paolo
> 

