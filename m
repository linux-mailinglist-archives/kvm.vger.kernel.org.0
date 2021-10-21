Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A2A436BC3
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 22:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhJUUKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 16:10:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231443AbhJUUKr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 16:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634846910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mmsmJ/pPdiOUowj1+queJxhgagora/RkFzbUPsH0NgI=;
        b=KF7xLlRfh0+1XiMicQskyfi8lPRjjmX3bc6Yxt71R7IwxpXkSYJR63wz5R3y4hGlS4dz8I
        sKwcK7hPAbb8rj1h1gURqA/Ryd5QGMyzWhOSA6jqMpZug1S66TJHlxC/GX5ZmDxY5Zjt96
        XuhI0Z1jShMVEa6ZsclaR3gxsSzZQz4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-O1qVFk22NWm82Oe95bFTww-1; Thu, 21 Oct 2021 16:08:29 -0400
X-MC-Unique: O1qVFk22NWm82Oe95bFTww-1
Received: by mail-ed1-f71.google.com with SMTP id t28-20020a508d5c000000b003dad7fc5caeso1495657edt.11
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 13:08:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mmsmJ/pPdiOUowj1+queJxhgagora/RkFzbUPsH0NgI=;
        b=gK/IxtunNZ82crvvZM5LM5clEtSXtiLBuXT/r3vNX66nUAAsWEXjwHzBWegKAYIprx
         OIUKvZumD3JZ/HYUdDmv/UR1+AyGm69tDbnLADZpzxdVK6JLjE5sCkT70IWfrp/vaMhZ
         smaU6P1kgKuBkKGe1pLLKiZWzSuVfkhKyEqL2v/PTunbdbIw2Ml+1Y2D0Zg4kIrP2oFV
         S19ryRZk7vdSbovD9mccA9lDo5LcNDyASUKIDo/v7p9LU5tdiIXMHk4rH23S6pO+VKP2
         BnB0/A60aM03cMtRcWI0mwp9+aoGUabS+A0LgCRdANL2Bm64xXyw1Yx5Dqp+BRwbnp53
         fQ1Q==
X-Gm-Message-State: AOAM5338tD1JHjcANOJWSo07D01VUjXPWXVeIW7nXGfFR88R2Db9+Czm
        7Oo5JEEBCZFAjWQUDp7AArpDZt/KZmCWuSx007P8hEcqA7WgmRRzbNsDwzwGgOOSiztA7ffIzsX
        jUJpokJjb9b1C
X-Received: by 2002:a50:d50c:: with SMTP id u12mr10692148edi.118.1634846907808;
        Thu, 21 Oct 2021 13:08:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydAHgKEPzldAxYQV/5QMlR58Wpb8Rnei/FqgARVPGBX6aLZzp3TxpCGsa/Joy8+cm0SIrRxg==
X-Received: by 2002:a50:d50c:: with SMTP id u12mr10692122edi.118.1634846907625;
        Thu, 21 Oct 2021 13:08:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id p3sm2942149ejy.94.2021.10.21.13.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 13:08:27 -0700 (PDT)
Message-ID: <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
Date:   Thu, 21 Oct 2021 22:08:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: There is a null-ptr-deref bug in kvm_dirty_ring_get in
 virt/kvm/dirty_ring.c
Content-Language: en-US
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 19:14, butt3rflyh4ck wrote:
> {
> struct kvm_vcpu *vcpu = kvm_get_running_vcpu();  //-------> invoke
> kvm_get_running_vcpu() to get a vcpu.
> 
> WARN_ON_ONCE(vcpu->kvm != kvm); [1]
> 
> return &vcpu->dirty_ring;
> }
> ```
> but we had not called KVM_CREATE_VCPU ioctl to create a kvm_vcpu so
> vcpu is NULL.

It's not just because there was no call to KVM_CREATE_VCPU; in general 
kvm->dirty_ring_size only works if all writes are associated to a 
specific vCPU, which is not the case for the one of 
kvm_xen_shared_info_init.

David, what do you think?  Making dirty-page ring buffer incompatible 
with Xen is ugly and I'd rather avoid it; taking the mutex for vcpu 0 is 
not an option because, as the reporter said, you might not have even 
created a vCPU yet when you call KVM_XEN_HVM_SET_ATTR.  The remaining 
option would be just "do not mark the page as dirty if the ring buffer 
is active".  This is feasible because userspace itself has passed the 
shared info gfn; but again, it's ugly...

Paolo

