Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C68E500A
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 17:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440680AbfJYPYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 11:24:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27630 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731226AbfJYPYC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 11:24:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572017041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=GsaOShjp2o71sHb6iijicKIDE12EJfTyyRjzASdVTts=;
        b=EyTz4rND6nGfsQ+TGuNxKPDy3jeMBpIdrJRjeZg6qj9YV/PAzg7Aam3xG0yUWSZ1xRHiBp
        Z38KjzTusWHELZBD2P003I4JB0hw9aFmLR6BrRmPIaHNeKmxr9sa6U6bxFNpx51+O+yM51
        cRBQasuzgPMs4KAijKo4dc27Wcwkv5I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-IEazmVAKMqK6H4jbNIDCmw-1; Fri, 25 Oct 2019 11:23:57 -0400
Received: by mail-wm1-f71.google.com with SMTP id o128so1956004wmo.1
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 08:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z2SbMKG0Ddkn31jNfbVI7js5bL6/hM/kWENverck8tA=;
        b=f9Lk2vw2m+CPF4bJTbMOWizUudx20h0edxl+Rly003p/R01eY8x4msTMVsC62nv4AE
         jzw7UVfTo5ASHj0td5kupZxTv6C1tvt0KQc2ziIoXCs2EFSUwE+xkiv9IQIdtHxJySzM
         ZCoVsuo8mCcSdBwpn7JSAozRW5JBG+aHt9ZW+0GkumFACLiO6yS9bX+xWqnCjG9y9UV6
         3C24o2ome3V1A9C3i20M2/u+wSgEciwJRNqicwrbnXmRNfwtDIByntL6ID7z9CMdx2W6
         0cuXY3CcJzznrXV3BR1es/+8J0QGsyDMpkVgI5UQQ3ivmxhDOz/dh+zGNIUdZAIJDU0M
         RyXg==
X-Gm-Message-State: APjAAAXr8doaP/uNLgzCtF8W6BMlscw4vpZrBihwFTWs5VaWkxWzD2SI
        CTcxT79Zk+Q8pNNpvB5APMjXbmOAEvOTcKc/InMjIWiLnXmIxgtlLoc6gjc7zDtwCu+1SKuklPe
        ujHkoP1lbnoVk
X-Received: by 2002:a05:600c:2253:: with SMTP id a19mr4262550wmm.39.1572017036218;
        Fri, 25 Oct 2019 08:23:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyoA66dKSADIVQF1lbHeMudoOQGederf+qAv92b5MC3sfFeUN8PAapJ7iyEnevXc3tMlo9Jrg==
X-Received: by 2002:a05:600c:2253:: with SMTP id a19mr4262519wmm.39.1572017035903;
        Fri, 25 Oct 2019 08:23:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9c7b:17ec:2a40:d29? ([2001:b07:6468:f312:9c7b:17ec:2a40:d29])
        by smtp.gmail.com with ESMTPSA id b3sm1976072wrv.40.2019.10.25.08.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 08:23:55 -0700 (PDT)
Subject: Re: [PATCH v3 3/3] kvm: call kvm_arch_destroy_vm if vm creation fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20191024230327.140935-1-jmattson@google.com>
 <20191024230327.140935-4-jmattson@google.com>
 <20191024232943.GJ28043@linux.intel.com>
 <48109ee1-f204-b7d4-6c4f-458b59f7c428@redhat.com>
 <20191025144848.GA17290@linux.intel.com>
 <7fa85679-7325-4373-55a1-bb2cd274fec3@redhat.com>
 <20191025152201.GD17290@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <637f0a19-e182-ed58-9fc2-0556a9a37be5@redhat.com>
Date:   Fri, 25 Oct 2019 17:23:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191025152201.GD17290@linux.intel.com>
Content-Language: en-US
X-MC-Unique: IEazmVAKMqK6H4jbNIDCmw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/19 17:22, Sean Christopherson wrote:
> On Fri, Oct 25, 2019 at 04:56:23PM +0200, Paolo Bonzini wrote:
>> On 25/10/19 16:48, Sean Christopherson wrote:
>>>> It seems to me that kvm_get_kvm() in=20
>>>> kvm_arch_init_vm() should be okay as long as it is balanced in=20
>>>> kvm_arch_destroy_vm().  So we can apply patch 2 first, and then:
>>> No, this will effectively leak the VM because you'll end up with a cycl=
ical
>>> reference to kvm_put_kvm(), i.e. users_count will never hit zero.
>>>
>>> void kvm_put_kvm(struct kvm *kvm)
>>> {
>>> =09if (refcount_dec_and_test(&kvm->users_count))
>>> =09=09kvm_destroy_vm(kvm);
>>> =09=09|
>>> =09=09-> kvm_arch_destroy_vm()
>>> =09=09   |
>>> =09=09   -> kvm_put_kvm()
>>> }
>>
>> There's two parts to this:
>>
>> - if kvm_arch_init_vm() calls kvm_get_kvm(), then kvm_arch_destroy_vm()
>> won't be called until the corresponding kvm_put_kvm().
>>
>> - if the error case causes kvm_arch_destroy_vm() to be called early,
>> however, that'd be okay and would not leak memory, as long as
>> kvm_arch_destroy_vm() detects the situation and calls kvm_put_kvm() itse=
lf.
>>
>> One case could be where you have some kind of delayed work, where the
>> callback does kvm_put_kvm.  You'd have to cancel the work item and call
>> kvm_put_kvm in kvm_arch_destroy_vm, and you would go through that path
>> if kvm_create_vm() fails after kvm_arch_init_vm().
>=20
> But do we really want/need to allow handing out references to KVM during
> kvm_arch_init_vm()?  AFAICT, it's not currently required by any arch.

Probably not, but the full code paths are long, so I don't see much
value in outright forbidding it.  There are very few kvm_get_kvm() calls
anyway in arch-dependent code, so it's easy to check that they're not
causing reference cycles.

Paolo

> If an actual use case comes along then we can move refcount_set() back,
> but with the requirement that the arch/user provide a mechanism to
> handle the reference with respect to kvm_arch_destroy_vm().  As opposed
> to the current behavior, which allows an arch to naively do get()/put()
> in init_vm()/destroy_vm() without any hint that what they're doing is
> broken.
>=20

