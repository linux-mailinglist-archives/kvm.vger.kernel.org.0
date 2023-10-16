Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD117CADF4
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjJPPoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbjJPPog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:44:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BE983
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697471027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V1DWs7G/YNvwjIkj//GgTeCe+CoKdcgoYTiVkIFc0d0=;
        b=d6bzpnATACGn2pIdhJYqOcf4/+HjorVPKKapODpo7IprWQUoY6zJIuMOLO2r4qbKI63uL9
        qEsy7aR7yTvNZKe9H0DzQSv9lZQaG/6l693ou0/v5XzJ1Iez0xc9SE43Enyo64whlTGEHz
        K4eqWQlZiU4HZQ+3zDuBdwnPqZcpMeE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-JAu6Lv6AOMuoRJsKSTu84A-1; Mon, 16 Oct 2023 11:43:45 -0400
X-MC-Unique: JAu6Lv6AOMuoRJsKSTu84A-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-77578227e4bso578831685a.2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697471025; x=1698075825;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V1DWs7G/YNvwjIkj//GgTeCe+CoKdcgoYTiVkIFc0d0=;
        b=uGXikAb3w8KIdkkzpLk4ij/2cF/tBcvwrtoszruBwoZtgZOpZAUMlt9ueGshKLbLiD
         cufKNkiy0U1mzECJCWMNpgEMBCECT7fEPpvtj7/xq7z95tryYtOmsfHssbQ3NsEtKcIu
         NSfR27SJjTG6Ssgz4og8BaXJUYLPpAXpWcTAxyLWzQvYgDo1Q1a9nkBFPGh2xgCrWVvd
         HIILGbdlvRQiSBxTBtanwtUM8bOw/fjq1lzsOD/avrWOS5k+RUkyJaOChx6AMtMtCqNu
         usXBlMXZKLzVqSw2aFzalEJ/oKc+NMYZ0bClgmvT7sauVbUTElsW/uP3IXlg/JWUgB0A
         G88w==
X-Gm-Message-State: AOJu0YzVOrHBjXD51ycvSrO1NEg3Hf56XIPAUY4cPejxlCpiN/safCMS
        JrG/rWSpQ+fXybaffrpAN/uz8y3Vane10Fiuotc9DEIIFFFl9Am09QXtfpMWgKJDYBgmx87vY2j
        0yr6LoSA2k50R
X-Received: by 2002:a05:620a:1c:b0:774:131c:854d with SMTP id j28-20020a05620a001c00b00774131c854dmr31678699qki.72.1697471025270;
        Mon, 16 Oct 2023 08:43:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0tKGPjNcVT72ABcCfpkfaoq/Ctigl+iVtmHFYtOkaGS1t2ELTeuV5IkevG9HZ1qpH0IOf5A==
X-Received: by 2002:a05:620a:1c:b0:774:131c:854d with SMTP id j28-20020a05620a001c00b00774131c854dmr31678687qki.72.1697471025012;
        Mon, 16 Oct 2023 08:43:45 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id a4-20020a05620a16c400b0076ef0fb5050sm3098399qkn.31.2023.10.16.08.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 08:43:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 07/11] KVM: x86: Make Hyper-V emulation optional
In-Reply-To: <ZS1VGvbcmH93-KyH@google.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
 <20231010160300.1136799-8-vkuznets@redhat.com>
 <708a5bb2dfb0cb085bd9215c2e8e4d0b3db69665.camel@redhat.com>
 <87h6mq91al.fsf@redhat.com> <ZS1VGvbcmH93-KyH@google.com>
Date:   Mon, 16 Oct 2023 17:43:42 +0200
Message-ID: <877cnm8te9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Oct 16, 2023, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> 

...

>> >
>> > "Provides KVM support for emulating Microsoft Hypervisor (Hyper-V).
>
> I don't think we should put Hyper-V in parentheses, I haven't seen any documentation
> that calls it "Microsoft Hypervisor", i.e. Hyper-V is the full and
> proper name.

Ha :-) From
https://lore.kernel.org/linux-hyperv/1696010501-24584-1-git-send-email-nunodasneves@linux.microsoft.com/

"""
This series introduces support for creating and running guest machines
while running on the Microsoft Hypervisor. [0]
...
[0] "Hyper-V" is more well-known, but it really refers to the whole stack
    including the hypervisor and other components that run in Windows
    kernel and userspace.
"""

I'm fine with keeping the staus quo though :-)

>
>> > This makes KVM expose a set of paravirtualized interfaces,
>
> s/makes/allows, since KVM still requires userspace to opt-in to exposing Hyper-V.
>
>> > documented in the HyperV TLFS, 
>
> s/TLFS/spec?  Readers that aren't already familiar with Hyper-V will have no idea
> what TLFS is until they click the link.
>
>> > https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/tlfs,
>> > which consists of a subset of paravirtualized interfaces that HyperV exposes
>
> We can trim this paragraph by stating that KVM only supports a subset of the
> PV interfaces straightaway.
>
>> > to its guests.
>
> E.g.
>
>   Provides KVM support for for emulating Microsoft Hyper-V.  This allows KVM to
>   expose a subset of the paravirtualized interfaces defined in Hyper-V's spec:
>   https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/tlfs.

LGTM, thanks!

>
>> >
>> > This improves performance of modern Windows guests.
>
> Isn't Hyper-V emulation effectively mandatory these days?  IIRC, modern versions
> of Windows will fail to boot if they detect a hypervisor but the core Hyper-V
> interfaces aren't supported.
>

It's rather a rule of thumb: normally, modern Windows and Hyper-V
versions (Win10/11, WS2019/22) boot and pretend to work but without
Hyper-V enlightenment it's not uncommon to see a blue screen of death
because of a watchdog firing. It's hard to say for sure as things keep
changing under the hood so even different builds can behave differently;
pretending we're a genuine Hyper-V was proven to be the most robust
approach.

-- 
Vitaly

