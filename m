Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD65F30DBBF
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 14:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhBCNtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 08:49:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232308AbhBCNsN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 08:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612360006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAKaUuKW6RzyViwzx4Xg+bK1O40C5bxcjPo5i3OoibA=;
        b=TfRI3ZdRDGeYfJ/mBJ3+L8VcpsJumzV/V+dPBUbC/DBkONQbKeT9u45OJujUEswTpBtoL9
        9e9Dv1uvGjNYLDg78r/xhzrI2iLjb0MJGPSRCAnDb1Pg/9YubEDZVxawWU2R/rk2LTVkZ4
        dsJN3/jErtxcyd3qOLWY5e+qVGnXEQw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-HAFx1laVOGyPNuHUn1FbzA-1; Wed, 03 Feb 2021 08:46:45 -0500
X-MC-Unique: HAFx1laVOGyPNuHUn1FbzA-1
Received: by mail-ej1-f71.google.com with SMTP id h4so12118004eja.12
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 05:46:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wAKaUuKW6RzyViwzx4Xg+bK1O40C5bxcjPo5i3OoibA=;
        b=lLs2tqNnq/zgDuqMxjpxR4Rwb/jEiS5zA78EkNhvJFbwiL1PHE+dfLyyKIqZxQtdSM
         B6FQg4IPk5nHtXULfQnnB6lumD/U5nbVkHjEA/COjLdGDyEZr5y3N2OdEiKmOcMV1HIQ
         1YjNlxCxDOTIALtWCoFZbr/o5k4HDwdfwkGL1du0AVnPTVJzyAokrra+YwlxR+UQtbkK
         JlRxHhLUQUE7O9rglrk00IUtZR115nftvjK/ifBAXM4t2m1M+EAXCq9kUy01CYMi7rwV
         uVe5L8/+jP1tVOG35LqrkGr/Pxu1Mk8RqKCHJgKpiVD+N43874fIZvRrCkyHZzIX+g6T
         EkJg==
X-Gm-Message-State: AOAM531TwWKKQRM4N7IfmAaD6e8nnIcBmRmmVn+57iIDYWP50Z+/tx5R
        sk3WfdU6Iln6QGJyvJccyw7GDFJUr9D5Q0/qrJoD2pv12X1vV5rG6/pSprtG4IZRkmKWuw/sIk3
        YZzHhtavaYbyz
X-Received: by 2002:a50:bc15:: with SMTP id j21mr2979518edh.187.1612360003951;
        Wed, 03 Feb 2021 05:46:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyrMI/vUqEDH4yk4FAlNYFigl+qqWJDgS3ikYYXxZ/cG6rxiZfYpeNd6AJ1QaBQx+4Ul+w4hQ==
X-Received: by 2002:a50:bc15:: with SMTP id j21mr2979490edh.187.1612360003764;
        Wed, 03 Feb 2021 05:46:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u17sm920466edr.0.2021.02.03.05.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 05:46:42 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: Scalable memslots implementation
To:     David Hildenbrand <david@redhat.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
 <4d748e0fd50bac68ece6952129aed319502b6853.1612140117.git.maciej.szmigiero@oracle.com>
 <YBisBkSYPoaOM42F@google.com>
 <9e6ca093-35c3-7cca-443b-9f635df4891d@maciej.szmigiero.name>
 <4bdcb44c-c35d-45b2-c0c1-e857e0fd383e@redhat.com>
 <5efd931f-9d69-2936-89e8-278fe106616d@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <307603f3-52a8-7464-ba98-06cbe4ddd408@redhat.com>
Date:   Wed, 3 Feb 2021 14:46:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <5efd931f-9d69-2936-89e8-278fe106616d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 14:44, David Hildenbrand wrote:
> BTW: what are your thoughts regarding converting the rmap array on 
> x86-64 into some dynamic datastructre (xarray etc)? Has that already 
> been discussed?

Hasn't been discussed---as always, showing the code would be the best 
way to start a discussion. :)

However, note that the TDP MMU does not need an rmap at all.  Since that 
one is getting ready to become the default, the benefits of working on 
the rmap would be quite small and only affect nested virtualization.

Paolo

