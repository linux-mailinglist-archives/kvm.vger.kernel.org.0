Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B06B3BE01D
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 02:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGGAQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 20:16:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229834AbhGGAQN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 20:16:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625616814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RS/mSIjvQs49m4uQAYOnhtecJzE4qvV103MxMctQ9OQ=;
        b=H7yX6HnlTcP82Sz08i8LhNOAKw23WZoEX+qN3CGkTvLMmOcewhkHlfwQSRU/pnb9lTDtgK
        u9/dUN4GH4dBNlkpsRhYZD9zXxixFD7X6a5iyET7CVHMY1rzOntWdKrUk1Ma11ohI7Ais6
        kWaTKBt9dmPB4pJ+fqOOEJkMzoxdlTY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-lUJWXtLAOFmOskE5FAWsyw-1; Tue, 06 Jul 2021 20:13:33 -0400
X-MC-Unique: lUJWXtLAOFmOskE5FAWsyw-1
Received: by mail-ej1-f71.google.com with SMTP id hg14-20020a1709072cceb02904dcfba77bceso29142ejc.19
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 17:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RS/mSIjvQs49m4uQAYOnhtecJzE4qvV103MxMctQ9OQ=;
        b=YVRc2QlK9WlXWwgCBqF5rswgYzduasXXdaXXIHD6Q+Fgz7MahjwfnosqNuyXB3eV5Q
         W0IHEOTcZgiVUmLDCM2Cx/G/WsP86iHlfjxrFHSn7MQDemCE/dbw8PYfpfyLfNcR7BfI
         qp6lV0N3HcgZZBXqoVEi+dzVjRWSYuyMO1tU3l0Nzgbz6NPUPkAX3MSUZBeomKztqsy1
         a5K/dch4WqN6JOkEspFLL34kbViF4q8VQd7kPLj8cVjLbKSf+mzpDP836bxmKQx0+oMX
         qunTtQD/IhW90EuDd3Lhi8NErbauvofecA6mOM8AZ4zzlicSW6W2pGn4fDXcokFHf8vw
         aKcA==
X-Gm-Message-State: AOAM532A7tlpsa0kjjzBerq36azlXpAGjuLkdZn3+Zgkq2jfhz6mCWD8
        ZTL6Aja4szqry2TE/+tpjOscEzlq8Mu1/Bu23Wig3oXeXokP5Rjtdt1H3LxVpGMKF00NVJ0ICTT
        dzgOER9We+xaZBheRNWkYJoErHwc1RPiM1aJoGoliUMepacc6RmD3NQr483PMq3rc
X-Received: by 2002:aa7:db94:: with SMTP id u20mr26254659edt.381.1625616811745;
        Tue, 06 Jul 2021 17:13:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2dIKrX+iueepdpoCYUq8U74Zf/35Gz/4Bvf5DQrNuv5TP6YM9jUSScXNMif/MsIrkZ5WVMA==
X-Received: by 2002:aa7:db94:: with SMTP id u20mr26254636edt.381.1625616811580;
        Tue, 06 Jul 2021 17:13:31 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id z10sm7837534edd.11.2021.07.06.17.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 17:13:30 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     stsp <stsp2@yandex.ru>, Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <20210628124814.1001507-1-stsp2@yandex.ru>
 <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
 <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
 <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru>
 <71e0308e9e289208b8457306b3cb6d6f23e795f9.camel@redhat.com>
 <20b01f9d-de7a-91a3-e086-ddd4ae27629f@yandex.ru>
 <6c0a0ffe6103272b648dbc3099f0445d5458059b.camel@redhat.com>
 <dc6a64d0-a77e-b85e-6a8e-c5ca3b42dd59@yandex.ru>
 <b1976445-1b88-8a6c-24ee-8a3844db3885@redhat.com>
 <2ab52dfd-d050-48e6-8699-308de3d77588@yandex.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <478b0774-4a2f-07ff-a338-ca6e15064ee1@redhat.com>
Date:   Wed, 7 Jul 2021 02:13:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2ab52dfd-d050-48e6-8699-308de3d77588@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/21 01:51, stsp wrote:
> 07.07.2021 02:45, Paolo Bonzini пишет:
>> On 07/07/21 01:06, stsp wrote:
>>> What I ask is how SHOULD the
>>> KVM_SET_REGS and KVM_SET_SREGS
>>> behave when someone (mistakenly)
>>> calls them with the exception pending.
>>> Should they return an error
>>> instead of canceling exception?
>>
>> In theory, KVM_SET_REGS and KVM_SET_SREGS should do nothing but set 
>> the value of the registers.  They not should clear either 
>> vcpu->arch.exception.pending or vcpu->arch.exception.injected.
> Maybe they should return an
> error, or do something else to
> alert the user? Otherwise the
> 100% wrong usage gets unnoticed.

No, setting the registers means that: setting the registers.  If you set 
RSP, the new value will be used for delivering the exception.

Paolo

