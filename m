Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283BF3BDFE0
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 01:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhGFXyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 19:54:21 -0400
Received: from forward106j.mail.yandex.net ([5.45.198.249]:36662 "EHLO
        forward106j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhGFXyU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 19:54:20 -0400
Received: from myt6-de4b83149afa.qloud-c.yandex.net (myt6-de4b83149afa.qloud-c.yandex.net [IPv6:2a02:6b8:c12:401e:0:640:de4b:8314])
        by forward106j.mail.yandex.net (Yandex) with ESMTP id CDB8311A0736;
        Wed,  7 Jul 2021 02:51:39 +0300 (MSK)
Received: from myt3-07a4bd8655f2.qloud-c.yandex.net (myt3-07a4bd8655f2.qloud-c.yandex.net [2a02:6b8:c12:693:0:640:7a4:bd86])
        by myt6-de4b83149afa.qloud-c.yandex.net (mxback/Yandex) with ESMTP id devFRw7Swh-pdH4FsYi;
        Wed, 07 Jul 2021 02:51:39 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1625615499;
        bh=czALyKBL1d1cArPnUkzQUj++ESfJAU1xLwaqt2jiAWM=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=A3rjZApUAQ1iUkw+1czfuBuKs6sDkAHjtZLxtANiFyi6zelTcd2o0b/cvdLf3ip0q
         O1E9e3cPEcNNgzTsFnvk1E/AKQ8LsMehdALialMTPXx89if2PuN708Yy9v56rzZ3U8
         GQkQCKbPiowEp8ew2ySOfxZ4ut8KPZibZtrCK+8E=
Authentication-Results: myt6-de4b83149afa.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt3-07a4bd8655f2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id keS5jR5WlY-pcP4FYWF;
        Wed, 07 Jul 2021 02:51:38 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
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
From:   stsp <stsp2@yandex.ru>
Message-ID: <2ab52dfd-d050-48e6-8699-308de3d77588@yandex.ru>
Date:   Wed, 7 Jul 2021 02:51:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b1976445-1b88-8a6c-24ee-8a3844db3885@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

07.07.2021 02:45, Paolo Bonzini пишет:
> On 07/07/21 01:06, stsp wrote:
>> What I ask is how SHOULD the
>> KVM_SET_REGS and KVM_SET_SREGS
>> behave when someone (mistakenly)
>> calls them with the exception pending.
>> Should they return an error
>> instead of canceling exception?
>
> In theory, KVM_SET_REGS and KVM_SET_SREGS should do nothing but set 
> the value of the registers.  They not should clear either 
> vcpu->arch.exception.pending or vcpu->arch.exception.injected.
Maybe they should return an
error, or do something else to
alert the user? Otherwise the
100% wrong usage gets unnoticed.
