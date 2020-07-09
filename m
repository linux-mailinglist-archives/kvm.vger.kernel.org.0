Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFA021AA66
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 00:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGIWSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 18:18:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56197 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726546AbgGIWSX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 18:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594333102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JhIiSAhu+eKDD4LqE1U44H9+yD3bGyMgOiR/v2Po9pA=;
        b=U8z58mnii8nIescmg7q95Dp0dwuHK7jGLePxZ28NNO94qw3tIu6neToJXVvh5l1SWItdnH
        u04EIfaUS4C+ARPJGKcmX45bUNhWf3qA4UtHiq1yq+7inkt6KcI5aaLckriXh9dV0a6S8Z
        2q/DDf+ZrJTCligJeI8b0lmpCHBZLNI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-NOeY35bLOmukzUrICe2tbw-1; Thu, 09 Jul 2020 18:18:20 -0400
X-MC-Unique: NOeY35bLOmukzUrICe2tbw-1
Received: by mail-wm1-f70.google.com with SMTP id u68so3717183wmu.3
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 15:18:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JhIiSAhu+eKDD4LqE1U44H9+yD3bGyMgOiR/v2Po9pA=;
        b=VYeICQt5AoTnHwlYx6Fw0VPpM+ZO8OwzKbaYPui5J6Hl96Xv5c/RrP/XLXcEnDFyTf
         RBGVkzX8txjGEze+k+ODg4GPG/ijSjaUAuauDcKuSRtiWB7SCSeWZrxMrolsUaEk5JCl
         RloeZgMoNX5FLABfg9+igNmxvYx/8tj7pp3pQP8JrCcecGpEYlDM3wgg92zUsRpYO5o3
         qhK/GRxjSBQADGgO7iHUYs2T5Eh8unQyRhJVAtEI8vHhucmjJAXRdi3roGaA00mvJ/hB
         H+CDSn5qD1YEfC8mal6uBtPYqppx0ERZKtbOBga80rnL7yx7wMiTM/zAXzhit6a2AYf4
         DvrA==
X-Gm-Message-State: AOAM531kfQmPKfna7apUMU6DxtfYsu0vIb8e1ZDrs3/P0iJkh+NatpLq
        rb8r9UJsw0XfmHXEed/z5rseCPt5bVDCo/2xqQWubq3B5mAFt21TFBiqcqONZSfsrgM5LqwKfE1
        hfiy0D93WGRpu
X-Received: by 2002:adf:ed8c:: with SMTP id c12mr31545645wro.359.1594333099432;
        Thu, 09 Jul 2020 15:18:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGDqzx+gzniXiWP2qzH4hqdbNZTAc8mphaCAqFZQ27IjOnlswG36D7Q/CTjmFXJVOhbGtqMg==
X-Received: by 2002:adf:ed8c:: with SMTP id c12mr31545633wro.359.1594333099223;
        Thu, 09 Jul 2020 15:18:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id j4sm7501523wrp.51.2020.07.09.15.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 15:18:18 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
 <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
 <20200709211253.GW24919@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
Date:   Fri, 10 Jul 2020 00:18:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709211253.GW24919@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 23:12, Sean Christopherson wrote:
>> It's bad that we have no clue what's causing the bad behavior, but I
>> don't think it's wise to have a bug that is known to happen when you
>> enable the capability. :/

(Note that this wasn't a NACK, though subtly so).

> I don't necessarily disagree, but at the same time it's entirely possible
> it's a Qemu bug.

No, it cannot be.  QEMU is not doing anything but
KVM_SET_USER_MEMORY_REGION, and it's doing that synchronously with
writes to the PCI configuration space BARs.

> Even if this is a kernel bug, I'm fairly confident at this point that it's
> not a KVM bug.  Or rather, if it's a KVM "bug", then there's a fundamental
> dependency in memslot management that needs to be rooted out and documented.

Heh, here my surmise is that  it cannot be anything but a KVM bug,
because  Memslots are not used by anything outside KVM...  But maybe I'm
missing something.

> And we're kind of in a catch-22; it'll be extremely difficult to narrow down
> exactly who is breaking what without being able to easily test the optimized
> zapping with other VMMs and/or setups.

I agree with this, and we could have a config symbol that depends on
BROKEN and enables it unconditionally.  However a capability is the
wrong tool.

Paolo

