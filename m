Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EC81D48B3
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 10:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgEOImT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 04:42:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48523 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727790AbgEOImT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 04:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589532137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DMIdxGLOvqxhE935UlZMgBbWMPbbsSeb1jl5FoZ23yY=;
        b=EsEZnzaoAAGQJTlcoYjnYW1oxrOzw1GgmTxxu6J+xJ0sGHFM3TTa7r7DqzD1eLUL4/5zQO
        wcegxtqdoCE8z5mrX1vuNpdUot2pPcLtVYEFNrzjkuTun/2wgrGlMUamaT8XtuVNsxDc3Q
        OVzuqCq/C3/TN1JuNAaz9lK0nLqomMg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-ipTjqrGmOK6owIB2RgQCMQ-1; Fri, 15 May 2020 04:42:15 -0400
X-MC-Unique: ipTjqrGmOK6owIB2RgQCMQ-1
Received: by mail-wr1-f70.google.com with SMTP id d16so817002wrv.18
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 01:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DMIdxGLOvqxhE935UlZMgBbWMPbbsSeb1jl5FoZ23yY=;
        b=SUl9pM4VEMSsH51I8nwF0wRLIWLLt7TITAcWtm84Z8m585WWTxjB7gqdSA2Gc3u8mD
         pczKxZtPTTBrA+xWigbn9XzxePXnleIj0FOUVISE5fuksfak/tYTjhRs0M1DJLCU+joJ
         d/tj/z6zL0Y26OYRby169kwA48t/t78JE+q0Dauo6PyLbJp1z4sORP2Vy99Xg93f4bBq
         mDvQWioYZGYFKX+aRS9VIRc9yZJdQwI5LYhgaEJ4sR2kIIBwged29+rTDEcbReJIIrkI
         HH1h3xKHFmq1dAYEHzD6NEWR1k57GqVYk/VutWU7O8C6g6zaRBAuUQj0vs1YhVYUvA6p
         yW8w==
X-Gm-Message-State: AOAM533hIn8hRh4ZPmW2e6I9I5Zj+KTmi6aSRHI0L9aYG0CUHdEyYH4Y
        l2J3Br5kv9mFQViIIbNT20LYNcmHxJnSV/cNb8LR6H0Hgwu7443NmnvTU8tYnzvv1P/w/oBKkNx
        UJw6ceX843mB5
X-Received: by 2002:a7b:c201:: with SMTP id x1mr2761112wmi.14.1589532133995;
        Fri, 15 May 2020 01:42:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXwzFjPs3XiKuV9op5EMMlZoD4iPCHlEyVN7VtC9ByMmgj8DVBwmpAcO/Ol8/xLi0LrCKwhQ==
X-Received: by 2002:a7b:c201:: with SMTP id x1mr2761095wmi.14.1589532133778;
        Fri, 15 May 2020 01:42:13 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t22sm2441900wmj.37.2020.05.15.01.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 01:42:13 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES memory
In-Reply-To: <20200514233208.GI15847@linux.intel.com>
References: <20200514180540.52407-1-vkuznets@redhat.com> <20200514220516.GC449815@xz-x1> <20200514225623.GF15847@linux.intel.com> <20200514232250.GA479802@xz-x1> <20200514233208.GI15847@linux.intel.com>
Date:   Fri, 15 May 2020 10:42:12 +0200
Message-ID: <87d075wpwb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, May 14, 2020 at 07:22:50PM -0400, Peter Xu wrote:
>> On Thu, May 14, 2020 at 03:56:24PM -0700, Sean Christopherson wrote:
>> > On Thu, May 14, 2020 at 06:05:16PM -0400, Peter Xu wrote:
>> > > E.g., shm_open() with a handle and fill one 0xff page, then remap it to
>> > > anywhere needed in QEMU?
>> > 
>> > Mapping that 4k page over and over is going to get expensive, e.g. each
>> > duplicate will need a VMA and a memslot, plus any PTE overhead.  If the
>> > total sum of the holes is >2mb it'll even overflow the mumber of allowed
>> > memslots.
>> 
>> What's the PTE overhead you mentioned?  We need to fill PTEs one by one on
>> fault even if the page is allocated in the kernel, am I right?
>
> It won't require host PTEs for every page if it's a kernel page.  I doubt
> PTEs are a significant overhead, especially compared to memslots, but it's
> still worth considering.
>
> My thought was to skimp on both host PTEs _and_ KVM SPTEs by always sending
> the PCI hole accesses down the slow MMIO path[*].
>
> [*] https://lkml.kernel.org/r/20200514194624.GB15847@linux.intel.com
>

If we drop 'aggressive' patch from this patchset we can probably get
away with KVM_MEM_READONLY and userspace VMAs but this will only help us
to save some memory, it won't speed things up.

>> 4K is only an example - we can also use more pages as the template.  However I
>> guess the kvm memslot count could be a limit..  Could I ask what's the normal
>> size of this 0xff region, and its distribution?

Julia/Michael, could you please provide some 'normal' configuration for
a Q35 machine and its PCIe config space?

-- 
Vitaly

