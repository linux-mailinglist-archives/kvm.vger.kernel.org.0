Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DA92FA908
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436737AbhARSkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:40:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407564AbhARS22 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 13:28:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610994423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SR1znhrtBE/8TBlcbJN+jUcCvjG/B/RC2d1W3pykhC8=;
        b=ilYS6IlTQID5zULyPJRs3KFfU8VqrcuIfVT+vXZFcScBJRetl71MxVwRz2pJDdUtCuUaty
        73+jAzX6QJkpE7/kszkB0paZaJyK1bNKUdCib3k+S3R8yA052LihLjxjrqDmGm0C0ja+sX
        db7xycqyupGxDzW61a2Xj5ZSIvWTRww=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-gyqQxgcQMEGfXJwQhB0dlQ-1; Mon, 18 Jan 2021 13:27:01 -0500
X-MC-Unique: gyqQxgcQMEGfXJwQhB0dlQ-1
Received: by mail-wr1-f71.google.com with SMTP id u3so8639947wri.19
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 10:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SR1znhrtBE/8TBlcbJN+jUcCvjG/B/RC2d1W3pykhC8=;
        b=bM2++BlypXb3fLtZqVsDZORXeS/SVowZBQe6wRt8M07Q9c/5tLAj8Uga+GVB4uo0tm
         MvolmngRe/pxR97PYTqAPN6C5Dc2b/PT3JiMUs4NiLKnXA/fJF8S+w4ZhY5JKyR467Iz
         nwcsHPdbXbPuC5klRWKWnfsmODYEBy0xNq9Y3YFxPQmy2aYqznw9pwqAPY1FomXCHjnf
         qzH8hfVUfiZNE3iqU8yZNKWn6rhAYYxwM4fLEbTcs9aTtJ4RU5Sc7dlUHNPrQcinn0Xv
         GIe02qrS8dPOacfEQODInaD/lKGQf8TxVVco6VjkgmRU4xcY8IqoZLl0ulr9TMPX+W2K
         TWWg==
X-Gm-Message-State: AOAM531IIa/D7IOeA3b0Ill4Q0V4dbGH16Y+LNBpEn30PsPHFZ2RXwrQ
        ym2+GUWmsY312aGPQvwAzqBIjT1QACLHEH+SbEyIys4VpkskmsiWrg3Qey1A0wKqJKmWceDiiQf
        ebHnYls/8uId+9ZWQpWEKOed2dNE0ScZZ5rpIxFDt/mCc8BuRwmcLyS6vfLJUmtlT
X-Received: by 2002:adf:e590:: with SMTP id l16mr766938wrm.294.1610994420077;
        Mon, 18 Jan 2021 10:27:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhmYapYaKFujvmiwwxElIFxlvpL42SB4ZxG2fojeadfOVzKP7/K7YRdhDUUElrQNd1cKeS4g==
X-Received: by 2002:adf:e590:: with SMTP id l16mr766918wrm.294.1610994419853;
        Mon, 18 Jan 2021 10:26:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c18sm1234571wmk.0.2021.01.18.10.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 10:26:59 -0800 (PST)
Subject: Re: [PATCH] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
To:     Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
References: <1610623624-18697-1-git-send-email-wanpengli@tencent.com>
 <87pn277huh.fsf@vitty.brq.redhat.com>
 <CANRm+Cz01Xva0_OjTpq3Wbyppa=FZzxBwZJCWJNicV3eCrzpdQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <67171a65-f87d-8b60-22c6-449ed727f6e0@redhat.com>
Date:   Mon, 18 Jan 2021 19:26:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cz01Xva0_OjTpq3Wbyppa=FZzxBwZJCWJNicV3eCrzpdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 02:15, Wanpeng Li wrote:
>> The comment above should probably be updated as it is not clear why we
>> check kvm_clock.vdso_clock_mode here. Actually, I would even suggest we
>> introduce a 'kvmclock_tsc_stable' global instead to avoid this indirect
>> check.
> I prefer to update the comment above, assign vsyscall pvclock data
> pointer iff kvmclock vsyscall is enabled.

Are you going to send v2?

Paolo

