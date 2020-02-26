Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405DD16FFE1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 14:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgBZN1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 08:27:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31159 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726525AbgBZN1D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 08:27:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582723622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=agGOO/jU/mknJRwClLvBRzRpHoxWY7K+W0hcMMvjirM=;
        b=KDWmIKd3ghtRtl0trEyhrWhrihOiv1qYiLo7vGVzQB5YLmW2bmbB6M6sLtDiFPr+iRhFrn
        WdNoW4B6j3e5aqDEkI74Hzh8bTUH/6+MnKuUaOIY5DB+w8vGnZviPOuExL6EeX5/9HPXDA
        n1z7mdFWzjLIpo8gkT96glA3YtAwv/0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-VvTIx1WlPKOYvZd_Y8q2-A-1; Wed, 26 Feb 2020 08:27:00 -0500
X-MC-Unique: VvTIx1WlPKOYvZd_Y8q2-A-1
Received: by mail-wm1-f72.google.com with SMTP id f9so583616wmb.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 05:27:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=agGOO/jU/mknJRwClLvBRzRpHoxWY7K+W0hcMMvjirM=;
        b=aFb1LvEtP1CN7np3G4mKDBR9YSjPrLyGyJiz9T59lgskryyVzXl7rGmS+yoiv4kimR
         hvNJYlwfUTIzdhe+31AdhxxUOTXw3K9mD5qPP1m50/YWklDCIDJfzrayAO17cZROEjso
         psAA88x0Tue4VxovdMf6JIAUno+DIT/q+Z6OCdbSlWCkzVDjzDLaPBat1fnPdgTPDm6l
         zXaeHjXrnxD2QoyBGIsXF5UhfIPp5axiae1nxXzIASgDamXbspwQpiyYxSs/zKcLqy5B
         DCJHKdonuRFxkkwDDpDqKa5AEDP1kug8LciPQvgc1m642Tmd2X1faFi1l+s/dT/v8v3H
         tqlw==
X-Gm-Message-State: APjAAAUc3EAnsiZd1pXq+4KTommWkqBKLhi6kVpsjKqpQ4V6qOa+Pn1J
        pnxeJY9dihYYtgjMi20xCnM8T1gGqkJqg1G630SJ6mNA/dzec9V2IqQaBQ8iuFGHoda6PI1CHai
        xfeW6cfXkdUKm
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr5634315wmm.98.1582723619303;
        Wed, 26 Feb 2020 05:26:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqzbaVR2/GXYRznvGYxvT6T7M3Mjj6ENzCsNWFgfOyvIICiT5sblVbadki8OFHygUA4d6opyYw==
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr5634238wmm.98.1582723618172;
        Wed, 26 Feb 2020 05:26:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id j20sm3238858wmj.46.2020.02.26.05.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 05:26:57 -0800 (PST)
Subject: Re: [PATCH RESEND v2 2/2] KVM: Pre-allocate 1 cpumask variable per
 cpu for both pv tlb and pv ipis
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>
References: <1581988104-16628-1-git-send-email-wanpengli@tencent.com>
 <1581988104-16628-2-git-send-email-wanpengli@tencent.com>
 <CANRm+CyHmdbsw572x=8=GYEOw-YQCXhz89i9+VEmROBVAu+rvg@mail.gmail.com>
 <CAKwvOd=bDW6K3PC7S5fiG5n_kwgqhbnVsBHUSGgYaPQY-L_YmA@mail.gmail.com>
 <87mu95jxy7.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9506da2d-53fb-c4a3-55b4-fb78e185e9c2@redhat.com>
Date:   Wed, 26 Feb 2020 14:26:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87mu95jxy7.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 14:10, Vitaly Kuznetsov wrote:
> Nick Desaulniers <ndesaulniers@google.com> writes:
> 
>> (putting Paolo in To: field, in case email filters are to blame.
>> Vitaly, maybe you could ping Paolo internally?)
>>
> 
> I could, but the only difference from what I'm doing right now would
> proabbly be the absence of non-@redaht.com emails in To/Cc: fields of
> this email :-)
>
> Do we want this fix for one of the last 5.6 RCs or 5.7 would be fine?
> Personally, I'd say we're not in a great hurry and 5.7 is OK.

I think we can do it for 5.6, but we're not in a great hurry. :)  The
rc4 pull request was already going to be relatively large and I had just
been scolded by Linus so I postponed this, but I am going to include it
this week.

Paolo

