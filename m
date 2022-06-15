Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E227754C4C7
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 11:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348258AbiFOJhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 05:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344465AbiFOJhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 05:37:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6492396B9
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 02:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655285820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dNw/R51TWM4Lx/vPA0cEiIg3iaOBbrHMuRKSdvNKOs8=;
        b=RbBlG5hPsixoykU2GvRXXfgRDgOjcmtrSE8Z6pA3gzQ/xAOIpHoKjnkIZEcYav4YNY59xa
        6joAOVcqjvTXL7Hq3hUeTwiUgdgD2+9LXfYt8rG/jPDjT4qk45bCOXPubSVl3DRzOnf6pT
        Xif+mvC3cV89h9Xpysyg3X14A0B3btU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-ydvX0SVHNDSsZb50phzGDg-1; Wed, 15 Jun 2022 05:36:59 -0400
X-MC-Unique: ydvX0SVHNDSsZb50phzGDg-1
Received: by mail-wr1-f71.google.com with SMTP id h2-20020adfe982000000b002102da95c71so1677897wrm.23
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 02:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dNw/R51TWM4Lx/vPA0cEiIg3iaOBbrHMuRKSdvNKOs8=;
        b=k4/iZGA9sHCwCxBl/qDrnCF04p9DJf+01u1ifOz1yx3ezbQtP0cXyyVj+esVI+G/0h
         ZG6TX2DoJjgr6RnCiGmTrmHL7nLNVMlAHPWH3ZLweBuIT946sZ1reiAcXIeGmPacuptI
         GfRT3VYGHz/raqc650jq+gVQURAxBnP5ptptNOInqGgpv9QrGIghWVAfkPzDE0Maa1b/
         gJvMHfoYJ404P1Lipelf9SZAC1ncDkkuH6D4qap63Iot0vMe8ZJ1kSxBXHIwZGZv7TvO
         ho+8KJxidOBnGBMlsG2V5M7KJSFHYCsJFycu1hhqDRAsiICx+uoyf/Vg/dLc/dmRpJHk
         2LYA==
X-Gm-Message-State: AJIora/voaRm+z+xMYVILH6WI3dyzp0+hIypSSEGh2QKtAF7f+znXq2k
        Ssxp8jQ3FwZfMBKvadTbqAZA2PWkTKeZrPmQhvXxzG9/gqn+3QOcH0N0UqlFichdQeANxjAa+kf
        miI5dXVDY1OoQ
X-Received: by 2002:a05:6000:156c:b0:218:5f5d:9c61 with SMTP id 12-20020a056000156c00b002185f5d9c61mr9197824wrz.134.1655285818373;
        Wed, 15 Jun 2022 02:36:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ssl/jJYq81qq2KZOEAIQfXCR1k7dMbwfxJo3LlKFMzxbwAQ8XqzUsy+dnHpmNnbov1a/rtAQ==
X-Received: by 2002:a05:6000:156c:b0:218:5f5d:9c61 with SMTP id 12-20020a056000156c00b002185f5d9c61mr9197809wrz.134.1655285818176;
        Wed, 15 Jun 2022 02:36:58 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0a4700b003942a244f51sm1682638wmq.42.2022.06.15.02.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 02:36:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     mail@anirudhrb.com, kumarpraveen@linux.microsoft.com,
        wei.liu@kernel.org, robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
In-Reply-To: <Yqmf5UGbNKyGz3dD@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <87sfo7igis.fsf@redhat.com>
 <eaefdea0-0ca3-93f1-a815-03900055fdcd@redhat.com>
 <Yqmf5UGbNKyGz3dD@anrayabh-desk>
Date:   Wed, 15 Jun 2022 11:36:56 +0200
Message-ID: <87mteei7yf.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:

> On Tue, Jun 14, 2022 at 07:20:34PM +0200, Paolo Bonzini wrote:
>> On 6/14/22 14:19, Vitaly Kuznetsov wrote:
>> > The latest version:
>> > https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_vmx_enlightened_vmcs
>> > 
>> > has it, actually. It was missing before (compare with e.g. 6.0b version
>> > here:
>> > https://github.com/MicrosoftDocs/Virtualization-Documentation/raw/live/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v6.0b.pdf)
>> > 
>> > but AFAIR TSC scaling wasn't advertised by genuine Hyper-V either.
>> > Interestingly enough, eVMCS version didn't change when these fields were
>> > added, it is still '1'.
>> > 
>> > I even have a patch in my stash (attached). I didn't send it out because
>> > it wasn't properly tested with different Hyper-V versions.
>> > 
>> > -- Vitaly
>> 
>> Anirudh, can you check if Vitaly's patches work for you?
>
> I will check it. But I wonder if they fit the criteria for inclusion in
> stable trees...
>
> It is important for the fix to land in the stable trees since this issue
> is a regression that was introduced _after_ 5.13. (I probably should've
> mentioned this in the changelog.)
>

Personally, I see no problem with splitting off TscMultiplier part from
my patch and marking it for stable@ fixing d041b5ea93352. I'm going to
run some tests too.

-- 
Vitaly

