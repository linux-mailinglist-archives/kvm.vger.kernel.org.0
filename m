Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9845734F1CA
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 21:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhC3Tt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 15:49:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233135AbhC3Tsz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 15:48:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617133735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzWHBGLRQSImyi4e0nOZKdQoWKxewGVgAE+CFb4wwPc=;
        b=iSlCGRs6VCjQoCeBwC0vXZ0lDdqTqqW3cQT5ZJy9e9xTJ2Hp9tMYBi+gH4uaHVycwz2wQC
        0SgkHVHjJFNnhaWQLAgOU++Cdhi5uNX/riq3rBL00yFO37amxwAzIu5uEiDhZPEtebPK0U
        7KAq4R3SdvXRzm85kUAmme1vH0pLPyM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-hrsUdjTVOeW-8IkfVzmTLQ-1; Tue, 30 Mar 2021 15:48:53 -0400
X-MC-Unique: hrsUdjTVOeW-8IkfVzmTLQ-1
Received: by mail-wr1-f72.google.com with SMTP id z17so10804752wrv.23
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 12:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OzWHBGLRQSImyi4e0nOZKdQoWKxewGVgAE+CFb4wwPc=;
        b=m/sbKC1EItd4VG2A55MjDZwAOaOQNMD8Ht767yXkRu83MBvVaWHBa/Q5IOEWXgynQj
         m6F1jYDBNuB1RBcch66cREpXHdgDltAEyOI3sghslds8Fcrrgq4yZYx8O1fbZwGYZ0MQ
         8VWIi43OaNjXRLj4GoU46wQVVuisjmWYxNeHezGzYiBFQm0bysv0PyINt3pmYPlScgdJ
         X2K39JETbQ/3h7f8W1GlUcAleQvw5UMV/3/cjzyxOmh+3SVzdk/IXT1Z+pbiIZC1tF9D
         nwyCpMRtmjUv3onUbkO4C9vhgQTNjD46dDQfw41LikA+ERXFwIY66O1jqp3VuE2qc2bN
         3mXQ==
X-Gm-Message-State: AOAM533GTyJgV6sqIX66sevtn2ndIWNyJyn6YajmWpHH+UR8DnicSmaK
        LzIp1NQkyLEHFONP1aeNXBYW7b5GpPQMa5Dje5YvZPDTnq/f6N+NabCUMTRmeTNXxWsYMW07BLq
        FFE4aSwPmspgZ
X-Received: by 2002:a7b:c0c3:: with SMTP id s3mr5514402wmh.11.1617133732279;
        Tue, 30 Mar 2021 12:48:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrWDuYw2HfRbOt7weQUpuJCXUwrbqFmeFadK3gLejd+/RrcU8+0Fo4iU0Fj3iEAf2A+hbNXA==
X-Received: by 2002:a7b:c0c3:: with SMTP id s3mr5514373wmh.11.1617133732072;
        Tue, 30 Mar 2021 12:48:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w11sm37459472wrv.88.2021.03.30.12.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 12:48:50 -0700 (PDT)
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        kvm-ppc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20210326021957.1424875-1-seanjc@google.com>
 <CANgfPd_gpWsa4F3VdcpoBYqPR4dSBWNYCW1YdeOnu1wQdUz+0A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3a1dd877-7421-7628-4214-30483c4de10f@redhat.com>
Date:   Tue, 30 Mar 2021 21:48:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_gpWsa4F3VdcpoBYqPR4dSBWNYCW1YdeOnu1wQdUz+0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/03/21 20:32, Ben Gardon wrote:
>> Patches 1-7 are x86 specific prep patches to play nice with moving
>> the hva->gfn memslot lookups into common code.  There ended up being waaay
>> more of these than I expected/wanted, but I had a hell of a time getting
>> the flushing logic right when shuffling the memslot and address space
>> loops.  In the end, I was more confident I got things correct by batching
>> the flushes.
>>
>> Patch 8 moves the existing API prototypes into common code.  It could
>> technically be dropped since the old APIs are gone in the end, but I
>> thought the switch to the new APIs would suck a bit less this way.
> Patches 1-8 look good to me. Feel free to add my Reviewed-by tag to those.
> I appreciate the care you took to make all those changes tiny and reviewable.
> 

Just finished reviewing that part too, they were very nice and I've 
queued them.  I'll continue tomorrow with the rest.

Paolo

