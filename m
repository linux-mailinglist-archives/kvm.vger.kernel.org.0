Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C68934AD26
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCZRM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:12:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229986AbhCZRL7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 13:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616778718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Apq3QGY5HZXG/uM2pLcZnDEDEALJq2/nq3GVPp6oDqE=;
        b=KmQHWJBwN0gdhOe3KRZU9EXKXXKZ7Zv04xwzxjSE+6SN9igwVsBHSgaxE3cIhuz5q+d8CK
        iWOMOIiqpKT+7rBp45xo2wRSlrg5vLCSo2yi4uObFLx8yu7Hc+wMouhXDQvvg2uqJ4SZ1L
        xcCYfmFKtWfERm3SqcX4UFF9rSM8AX4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-C1hYaeRbOYKDk6F_hIQZYQ-1; Fri, 26 Mar 2021 13:11:56 -0400
X-MC-Unique: C1hYaeRbOYKDk6F_hIQZYQ-1
Received: by mail-ej1-f72.google.com with SMTP id t21so4353594ejf.14
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 10:11:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Apq3QGY5HZXG/uM2pLcZnDEDEALJq2/nq3GVPp6oDqE=;
        b=N0MtGiV8PBRcsdR7WX0j79T/EaEv3YZ8jSrepfhJoh5LmOFYh0oPBSybFQS2UnMttC
         hfMFe7WBVS8xjYtijjHImVU6DcviTR/PsYCPu60OE1v5a5Y7r+kDdpBFhv7D8ulWH0EV
         Vp164G15uvHgW4bPdk9zaxI6gQ9Qesjh6DCDBykvEMZfkLfQksSJCI4L8O0Obv6HVKsj
         dwo1wXvOAut4bs81Jwdbb9JDNOHUqf43GzTy1Ta1lKec/BBjG/c9Rqfu/WLdqPmxiNuA
         uPlOLnGGpCizkH8jxudxUmF/Ma3lbRDzBWDz/3cnOsF+sxJ232wJ/RDfnqu5laERDDe8
         MkLg==
X-Gm-Message-State: AOAM533oziXDdKdpnTKA1yzgmdWxutqCH2U0a0LP3m8weZ+7NgSNbyD+
        SQP0UJRA130fgcBrNuBnwRJMeS0pGebSmX5daTgbFQwgb0FoSTe3L3WyeSZEXyiKhSV2imy54Ob
        wfH5S6bwNSDU9
X-Received: by 2002:a05:6402:4245:: with SMTP id g5mr16509404edb.306.1616778715292;
        Fri, 26 Mar 2021 10:11:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFYf3Dz9wMDvYlxGB2u4oUf+cmO9eCmIEDXpZ/pkWQRGINsOfvV9EyNJr1l7VWJoEGKUoj3g==
X-Received: by 2002:a05:6402:4245:: with SMTP id g5mr16509393edb.306.1616778715165;
        Fri, 26 Mar 2021 10:11:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h8sm4478188ede.25.2021.03.26.10.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:11:54 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Don't allow TDP MMU to yield when
 recovering NX pages
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210325200119.1359384-1-seanjc@google.com>
 <20210325200119.1359384-4-seanjc@google.com>
 <CANgfPd8N1+oxPWyO+Ob=hSs4nkdedusde6RQ5TXTX8hi48mvOw@mail.gmail.com>
 <YF0N5/qsmsNHQeVy@google.com>
 <CANgfPd98XttnW0VTN3nSyd=ZWO8sQR53C2oygC6OH+DecMnioA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3a7a4040-91ad-354e-25a6-10471163a3ce@redhat.com>
Date:   Fri, 26 Mar 2021 18:11:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd98XttnW0VTN3nSyd=ZWO8sQR53C2oygC6OH+DecMnioA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/21 23:45, Ben Gardon wrote:
> I think in an earlier version of the TDP that I sent out, NX reclaim
> was a seperate thread for the two MMUs, sidestepping the balance
> issue.
> I think the TDP MMU also had a seperate NX reclaim list.
> That would also make it easier to do something under the read lock.

Yes that was my suggestion actually, I preferred to keep things simple 
because most of the time there would be only TDP MMU pages.

Paolo

