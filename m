Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B208E3071EA
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 09:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhA1Ira (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 03:47:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231791AbhA1Iqo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 03:46:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611823561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mVOlWn6fClC1aj9sXl6eMnMf2fKSPMW6jC1fk0abkpo=;
        b=VPsgdUi/PJcUHP4v8K7yB5w21eeB+ZhwaRhcA3yp9PnRU+Hb+OhBvMBGt7KiZ0cBUZ2xQF
        zaBj0FEpVE7wfFr8vebqFrdVqK/eg7+dCriVkPGxBvBWH9Ax9SO8c8O1JWv0jNY4qStXaW
        zTwp4833OCghvXrcnJxi+ocvguMHL4w=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-RkU2M2-AOZGAzTs1aJItfw-1; Thu, 28 Jan 2021 03:45:58 -0500
X-MC-Unique: RkU2M2-AOZGAzTs1aJItfw-1
Received: by mail-ed1-f70.google.com with SMTP id u26so1935405edv.18
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 00:45:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mVOlWn6fClC1aj9sXl6eMnMf2fKSPMW6jC1fk0abkpo=;
        b=FUNyqq/M5y1Lef3XAmmPotxrwMyJ4qiAHo7dDx1j56uZ4F0DkNFLMTnRF3LZkOH8aB
         amTjGEOrKiBT4pdWp2Q0/qBu2ZdQ72ZmhbwgKf0k1nF3jsW4aeVbS7+MPM+RALgKKkRf
         KZhh+UnYve8znHI1/c/TACqTfBDDs1GYzDePLeHvj9jWHLdEGu0T0sWemW2aW2HtHUwj
         WPBNJUYkLaw+39gZNwbdr/XBpIBKsz5X7bETsZygWwjMpFnFsuKwga3OXvnsNhCFGKR2
         z1fwo7XUNWgZiSPC8s1+6bujFw94hR0oocnER+5fw+0UE54463tEW24Gwca13mpJZLVi
         /9fA==
X-Gm-Message-State: AOAM531tiezREwkP3BnvW0HS0jMld+vt5pufkyEmJjCucRFp4Uq1iOkZ
        LS+RA1qTeGTd5w5WR9HhS4lALthDTILOM+F22ixE9D4AsdUKuYQpQoVDoldFdHlmC+45J1K/EJj
        DGc8HgR/rFRSv
X-Received: by 2002:aa7:cfda:: with SMTP id r26mr12651347edy.142.1611823557706;
        Thu, 28 Jan 2021 00:45:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy98B9YKIO7aw02SBaD4kYo9R1+fGvcQpoYEHbdm+QWcvhleOKyETk5hkri52Is6Tq/LWqs4Q==
X-Received: by 2002:aa7:cfda:: with SMTP id r26mr12651334edy.142.1611823557548;
        Thu, 28 Jan 2021 00:45:57 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s22sm1932990ejd.106.2021.01.28.00.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 00:45:56 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH 1/5] KVM: Make the maximum number of user memslots a
 per-VM thing
In-Reply-To: <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
 <20210127175731.2020089-2-vkuznets@redhat.com>
 <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
Date:   Thu, 28 Jan 2021 09:45:56 +0100
Message-ID: <877dnx30vv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com> writes:

> On 27.01.2021 18:57, Vitaly Kuznetsov wrote:
>> Limiting the maximum number of user memslots globally can be undesirable as
>> different VMs may have different needs. Generally, a relatively small
>> number should suffice and a VMM may want to enforce the limitation so a VM
>> won't accidentally eat too much memory. On the other hand, the number of
>> required memslots can depend on the number of assigned vCPUs, e.g. each
>> Hyper-V SynIC may require up to two additional slots per vCPU.
>> 
>> Prepare to limit the maximum number of user memslots per-VM. No real
>> functional change in this patch as the limit is still hard-coded to
>> KVM_USER_MEM_SLOTS.
>> 
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>
> Perhaps I didn't understand the idea clearly but I thought it was
> to protect the kernel from a rogue userspace VMM allocating many
> memslots and so consuming a lot of memory in kernel?
>
> But then what's the difference between allocating 32k memslots for
> one VM and allocating 509 slots for 64 VMs?
>

It was Sean's idea :-) Initially, I had the exact same thoughts but now
I agree with

"I see it as an easy way to mitigate the damage.  E.g. if a containers use case
is spinning up hundreds of VMs and something goes awry in the config, it would
be the difference between consuming tens of MBs and hundreds of MBs.  Cgroup
limits should also be in play, but defense in depth and all that. "

https://lore.kernel.org/kvm/YAcU6swvNkpPffE7@google.com/

That said it is not really a security feature, VMM still stays in
control. 

> A guest can't add a memslot on its own, only the host software
> (like QEMU) can, right?
>

VMMs (especially big ones like QEMU) are complex and e.g. each driver
can cause memory regions (-> memslots in KVM) to change. With this
feature it becomes possible to set a limit upfront (based on VM
configuration) so it'll be more obvious when it's hit.

-- 
Vitaly

