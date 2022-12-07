Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1208664507E
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 01:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiLGAim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 19:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLGAil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 19:38:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE57DA9
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 16:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670373460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WhcOmraBn/ipi0vzEbMup/7gBsLFBKTP05KUuVvghdw=;
        b=L/M8js0P6a61m/2qzjiVM25DCnzujLd7rkZ2ALJmPgOf7SzaHSyokh4JSy9fRFtXGhfdst
        1wA9y25lEH8nlNx0uJQOp50hgHwAMZG68cQTOvghB99DFvkbmkzaceXnYuvY4gdoHS4z7s
        R2DiNuCwk/nyXT5qIM2uhjSUNEaf6ck=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-3SX7B52JMBOkx86JMcO2TA-1; Tue, 06 Dec 2022 19:37:38 -0500
X-MC-Unique: 3SX7B52JMBOkx86JMcO2TA-1
Received: by mail-ej1-f71.google.com with SMTP id qb2-20020a1709077e8200b007bf01e43797so2421721ejc.13
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 16:37:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WhcOmraBn/ipi0vzEbMup/7gBsLFBKTP05KUuVvghdw=;
        b=SrYK2InzvLwErmeEiHB030K0ZdWqDdoExaDjkwb//B2BEjSsDgIoCG7+hI7zQ/dcwk
         atPNDmFGi2GN+mKjv5QC2mp4LydXrmNMpQNpx3rg4Qvw2wduvKyejH4hOhjsGvhhXFsk
         FES3RNXBE9+nGy5XI+M1VFqzA9nJl+AZ1dyYNf+NWvuNBASHRx4NTQln52ah2oVg8XGT
         z/2s4ALihybbcM7VvEsSmrA6g1o0jD6kL0YHxJV4b/uT/IEpGuNPMeyU2mtN4vckDH9B
         4eBtV4IDac5GTPxbbnCWj9N2FAkSI1Ofilyc7MgApBGFbpfFyM1bzrQOroRu2lLvd/ed
         JQuQ==
X-Gm-Message-State: ANoB5pmiNKKYzJKShJGGTY/PS06G5+ffBantaoLSLpW/Eat4C+k3tkfj
        EnntyY6oqLu6edr4A15FaIAB66Sg7ltUg0qRM29J27WkpcaQJNa6wSsQaZAUi6jHbMmlKsoyhf2
        G5aG4p8qfBVy96uy4C8XWNfXjf01VmxSpDtAiFN9PewWlw9aPmpFHMugB5QwZAhUn
X-Received: by 2002:aa7:d808:0:b0:46b:9715:1630 with SMTP id v8-20020aa7d808000000b0046b97151630mr29599592edq.213.1670373457253;
        Tue, 06 Dec 2022 16:37:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf70qdvyC792Vyu8oNXNjzy5popB/qQXO4+wz1mhdGN2rHpNOIru/AwLS2lOBOGRfR92wn7qlg==
X-Received: by 2002:aa7:d808:0:b0:46b:9715:1630 with SMTP id v8-20020aa7d808000000b0046b97151630mr29599576edq.213.1670373456894;
        Tue, 06 Dec 2022 16:37:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id d17-20020aa7d691000000b0046bb7503d9asm1554808edr.24.2022.12.06.16.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 16:37:36 -0800 (PST)
Message-ID: <2958eabb-f388-a935-fada-03c501258f6b@redhat.com>
Date:   Wed, 7 Dec 2022 01:37:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: KVM 6.2 state
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     KVM list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <89e2e3f9-ad89-3581-4460-f87f552d08a5@redhat.com>
In-Reply-To: <89e2e3f9-ad89-3581-4460-f87f552d08a5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/22 19:16, Paolo Bonzini wrote:
> 
> These are the patches that are still on my list:
> 
> * https://patchew.org/linux/20221105045704.2315186-1-vipinsh@google.com/
> [PATCH 0/6] Add Hyper-v extended hypercall support in KVM

Last version is at 
https://patchew.org/linux/20221205191430.2455108-1-vipinsh@google.com/ - 
lots of it is selftests so there's time, but please review!

> * https://patchew.org/linux/20221012181702.3663607-1-seanjc@google.com/
> [PATCH v4 00/11] KVM: x86/mmu: Make tdp_mmu a read-only parameter

Here I think I preferred David's plan, but Sean's additional changes 
were useful anyway, only the introduction of static_key had to be dropped.

Paolo

> * https://patchew.org/linux/20221001005915.2041642-1-seanjc@google.com/
> [PATCH v4 00/32] KVM: x86: AVIC and local APIC fixes+cleanups
> 
> 
> Of which only the last one *might* be delayed to 6.3.
> 
> Sean, if you have anything else feel free to collect them yourself and 
> send a pull request.
> 
> Paolo
> 

