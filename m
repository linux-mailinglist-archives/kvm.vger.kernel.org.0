Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B139556B3E1
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 09:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbiGHHz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 03:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237317AbiGHHzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 03:55:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B47367E00B
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 00:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657266949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HAAKsCoSYhF/bkc1lBCytOqkp21Aily9JDFQCiAKZoo=;
        b=EF2gUvM+OfAnuQa7AleYtnVIkHzL61D7CMp4mnNSkVdMbfV4t6nPpWtdQvOnCCDyuvbPyu
        eLp9hsKm51EuWC/B0+ErAV8UBWl6m5wM85RL6FFYeeeslX+WWbTd9Ps2qnyHHFOx+Ld/CW
        OtFli1xxerM6dZgiZT3McNo0LHQW9M4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-1L6vxng_PgGB4qRDCaBiAA-1; Fri, 08 Jul 2022 03:55:48 -0400
X-MC-Unique: 1L6vxng_PgGB4qRDCaBiAA-1
Received: by mail-ed1-f69.google.com with SMTP id y6-20020a056402270600b00433940d207eso12154689edd.1
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 00:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HAAKsCoSYhF/bkc1lBCytOqkp21Aily9JDFQCiAKZoo=;
        b=lTpokMTsfD0oelsgtsCowu5eDnBSLlGQ5mC+2u/MfnJ+/NODVMeIeiqDaEuhU3pNsN
         SfEAilvUapncdLLfhTFjRKyCQZmIxBFvbrT8f1xYFU3RNKe0lFMVLjYX26S2OVv9BqGX
         PzmzIYA2dUSBGBNuekIoOn3b3CcGzvKCv2nEDbW4UNC7FFu/JpWYbEIiVD+aRdYjmG8j
         cfmks4cJUn1RatD2DcmIbNQpwhOLj8gYO7HT4ZMTtphunb6eoUsVqjIWwf3HsF2EPA74
         grPuRJ7HLmZEBfIHCFmuTawUd12in8xirSLyNaXc2fQxzm+iBeH2pbKYI62uM3M2OoE+
         kG3A==
X-Gm-Message-State: AJIora/AeGYtrK13SgIa9DYYoM+R/h1k2UT6dAgh1LwUpNsjHisjJiYW
        /vDZKSGuOMDUR1FtElII8j3/G23PpZ1sVkyhytCMbeOjsLZvzRw9gfYnKI80dHAgTAu+ZSNgZMV
        cpKpJgmcM52YJ
X-Received: by 2002:a17:906:9bde:b0:72b:2e5:deb5 with SMTP id de30-20020a1709069bde00b0072b02e5deb5mr2313704ejc.21.1657266947327;
        Fri, 08 Jul 2022 00:55:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1spvCJWZP6FKE/wq/QU7UVcLahUIL6ee/g2jmNHTxTrCbpxOQC9KoxkC1SeyW5GOmLz61H/Yw==
X-Received: by 2002:a17:906:9bde:b0:72b:2e5:deb5 with SMTP id de30-20020a1709069bde00b0072b02e5deb5mr2313692ejc.21.1657266947080;
        Fri, 08 Jul 2022 00:55:47 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f3-20020a170906138300b0072124df085bsm20087328ejc.15.2022.07.08.00.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 00:55:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 22/28] KVM: VMX: Clear controls obsoleted by EPT at
 runtime, not setup
In-Reply-To: <YsdSfP7xmMcLv8i9@google.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-23-vkuznets@redhat.com>
 <CALMp9eRA0v6BK6KG81ZE_iLKF6VNXxemN=E4gAE4AM-V4gkdHQ@mail.gmail.com>
 <87wncpotqv.fsf@redhat.com> <Ysc0TZaKxweEaelb@google.com>
 <CALMp9eTrtFd-pcEeWvyAs7eYe1R1FPvGr0pjQNP8o8F0YHhg8A@mail.gmail.com>
 <YsdSfP7xmMcLv8i9@google.com>
Date:   Fri, 08 Jul 2022 09:55:45 +0200
Message-ID: <87tu7sox6m.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jul 07, 2022, Jim Mattson wrote:
>> On Thu, Jul 7, 2022 at 12:30 PM Sean Christopherson <seanjc@google.com> wrote:
>> >
>> > On Thu, Jul 07, 2022, Vitaly Kuznetsov wrote:
>> > > Jim Mattson <jmattson@google.com> writes:
>> > >
>> > > > On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> > > >>
>> > > >> From: Sean Christopherson <seanjc@google.com>
>> > > >>
>> > > >> Clear the CR3 and INVLPG interception controls at runtime based on
>> > > >> whether or not EPT is being _used_, as opposed to clearing the bits at
>> > > >> setup if EPT is _supported_ in hardware, and then restoring them when EPT
>> > > >> is not used.  Not mucking with the base config will allow using the base
>> > > >> config as the starting point for emulating the VMX capability MSRs.
>> > > >>
>> > > >> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> > > >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> > > > Nit: These controls aren't "obsoleted" by EPT; they're just no longer
>> > > > required.
>
> Actually, they're still required if unrestricted guest isn't supported.
>
>> > Isn't that the definition of "obsolete"?  They're "no longer in use" when KVM
>> > enables EPT.
>> 
>> There are still reasons to use them aside from shadow page table
>> maintenance. For example, malware analysis may be interested in
>> intercepting CR3 changes to track process context (and to
>> enable/disable costly monitoring). EPT doesn't render these events
>> "obsolete," because you can't intercept these events using EPT.
>
> Fair enough, I was using "EPT" in the "KVM is using EPT" sense.  But even that's
> wrong as KVM intercepts CR3 accesses when EPT is enabled, but unrestricted guest
> is disabled and the guest disables paging.
>
> Vitaly, since the CR3 fields are still technically "needed", maybe just be
> explicit?
>
>   KVM: VMX: Adjust CR3/INVPLG interception for EPT=y at runtime, not setup
>

Sounds good, adjusted!

-- 
Vitaly

