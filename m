Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F327C0BE
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgI2JPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:15:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgI2JP3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 05:15:29 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601370928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ypt8LgdMVSyUFDx2ajf/v0PrV4X2XJYzLdUlFmhUgvY=;
        b=KGQ4TjgYlXlAmc6gbTSCuyBQzgKYjD8j5n7GdpZ3Bs23KBn/mv7FJcuUKMoXd8wfQ3EG7O
        w3zE8JPFsvh2Cryb1jL8dr9sbVTBo9OQWMFRGVM2lold8stV2xGj5EvlwMra+cU19q0+2d
        t4MXcciHWWXD1OTYG+kfHVbhiCQJUGs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-Y1j3Dbl9MmeuMK2th3cQcw-1; Tue, 29 Sep 2020 05:15:26 -0400
X-MC-Unique: Y1j3Dbl9MmeuMK2th3cQcw-1
Received: by mail-wm1-f70.google.com with SMTP id x6so1584963wmi.1
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 02:15:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ypt8LgdMVSyUFDx2ajf/v0PrV4X2XJYzLdUlFmhUgvY=;
        b=ri2byFtod6m9A3Y4qOYNg53bsbGcFTdCAjts68jVyayqptwpuGLGM+nyL7nT8e5rF6
         vjEdvT8qIWlhnvBqBSNFZf5jh0MLNPb4We76gdGQ/KB9ASOkW/+admAlNQTBNf6nlpsd
         0Cxo7eWpnCYIE+NkB40M+qI4leyFJ0ZQgAe+cPrhEwvgE94AfMETU/8DTIU2ihdtiHQ0
         EKoHipqfsfakSCIYPH88cqgVI+0f6a32gtGhHwIjxIa+xWXoThJ9rv+5JBo6td3JgysS
         OXRWhyzobzi+VQO8CFmDO7lpVDJBzX6XEHA58y/soAoXXExoFUsRNrwlBFNwUvvkvPTr
         XfEA==
X-Gm-Message-State: AOAM530EfG4WUv/W2rloLUjWQdM759Xam7QziLOz/xIfqhQjHoFU66Q3
        LQvgDbhiBOZIbioH1Rrf3noDVVzoueSDZLWnGK019nK/LG6wfKoUWN49wvlsnuqlr6X+uwkFUS9
        tIlAU+LJsDRr8
X-Received: by 2002:a1c:7912:: with SMTP id l18mr3442463wme.124.1601370922094;
        Tue, 29 Sep 2020 02:15:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxya0bZiu1x+swKFOywBEtJWuTSDjfs6yaSqAv5yo6ryU2YWrILMOly6HzXmYqAMyK+58cTgw==
X-Received: by 2002:a1c:7912:: with SMTP id l18mr3442435wme.124.1601370921899;
        Tue, 29 Sep 2020 02:15:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dbe:2c91:3d1b:58c6? ([2001:b07:6468:f312:9dbe:2c91:3d1b:58c6])
        by smtp.gmail.com with ESMTPSA id o15sm4501936wmh.29.2020.09.29.02.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 02:15:21 -0700 (PDT)
Subject: Re: [RFC PATCH 3/3] KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs
 that are fatal to the VM
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com>
 <20200923224530.17735-4-sean.j.christopherson@intel.com>
 <878scze4l5.fsf@vitty.brq.redhat.com> <20200924181134.GB9649@linux.intel.com>
 <87k0wichht.fsf@vitty.brq.redhat.com>
 <20200925171233.GC31528@linux.intel.com>
 <731dd323-8c66-77ff-cf15-4bbdea34bcf9@redhat.com>
 <20200929035257.GH31514@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c195f6b4-c714-16e3-879f-0196540e1987@redhat.com>
Date:   Tue, 29 Sep 2020 11:15:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200929035257.GH31514@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/20 05:52, Sean Christopherson wrote:
>> I think usage should be limited to dangerous cases, basically WARN_ON
>> level.  However I agree with Vitaly that KVM_GET_* should be allowed.
>
> On the topic of feedback from Vitaly, while dredging through my mailbox I
> rediscovered his suggestion of kvm->kvm_internal_bug (or maybe just
> kvm->internal_bug) instead of kvm->vm_bugged[*].

Also agrees with KVM_EXIT_INTERNAL_ERROR.

>> The other question is whether to return -EIO or KVM_EXIT_INTERNAL_ERROR.
>>  The latter is more likely to be handled already by userspace.
>
> And probably less confusing for unsuspecting users.  E.g. -EIO is most
> likely to be interpreted as "I screwed up", whereas KVM_EXIT_INTERNAL_ERROR
> will correctly be read as "KVM screwed up".

All good points, seems like you have enough review material for the
non-RFC version.

Paolo

