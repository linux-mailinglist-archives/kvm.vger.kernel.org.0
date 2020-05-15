Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270B71D480E
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 10:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgEOIYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 04:24:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39162 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgEOIYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 04:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589531091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0DQftDX0379nFESU6WazrW1lD4fM3GC98zH3yfUsrwE=;
        b=fW+S6noMl/RN6E5cblpWWIBnzXq49fKzCitKKW7l3n8kxactOAc1dcEOwafbuE8EfIwWH/
        YkP40ext3c9e0HnIQumsAtjq4CE42I5tyZmJJeYi06bXk8CfKoWn/j/Tc0nkD7qU01NrNP
        Etn5Q6FGSoxZMmgOt/KfHzatDd3+Fmw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-4xc6qsUNMNGZltHENYneHA-1; Fri, 15 May 2020 04:24:49 -0400
X-MC-Unique: 4xc6qsUNMNGZltHENYneHA-1
Received: by mail-wr1-f72.google.com with SMTP id y4so795527wrw.20
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 01:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0DQftDX0379nFESU6WazrW1lD4fM3GC98zH3yfUsrwE=;
        b=Iaw/R5zU8wm3Ihm3F2dxTvyzx9Btn2uQuEUwDofaM9uNl7i++pF2ZajpN3DAOh40NI
         ZWRhJxJAl0p+GohBvyxMlHGPuE7CUgbP2lI569ZlXFF6pJpPiZp8LLL15ZdA1dp96XZI
         U4Iq+OFoQxeoK5gATJYwRXdRLr13Uh6n2lFQKf+aIgkvk8fV6MD/1ctozmYPbCvejiwM
         l5QYCvTUIWq0v5ppx0ggKY98loh+p+VXHGzDcA4ePVA4iBPKKsAIa8+BkMFJR4LFgQFS
         fVXKQfxBVIqL7NZGAim/0z8qI3Wi4hGPB6k9wVWz/dCF8NDJeN7Ty1eOVErkiRBaljY9
         WVtw==
X-Gm-Message-State: AOAM530PH2b6UNiUuoQ5b4aq8oV5gzQl341ZzB6w34A8SnnAvSoDYyP3
        AZCiNjexhPVsyaXzl+SPXk8KZ8tl8XODyd3DeMJYWEA+524I3VA6ZcT8jNJBgfu7bSeBMNUtUcg
        ymyc5AQbtytzC
X-Received: by 2002:a5d:62c7:: with SMTP id o7mr2914723wrv.212.1589531087918;
        Fri, 15 May 2020 01:24:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWc8/zKYnO5ihSmyMO25yKM3a8VD+LjoaKKI+gb3ocgg3J9JGwXdm6ilapNMfvQgQoDQ4XVw==
X-Received: by 2002:a5d:62c7:: with SMTP id o7mr2914689wrv.212.1589531087638;
        Fri, 15 May 2020 01:24:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r11sm2419027wrv.14.2020.05.15.01.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 01:24:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 2/5] KVM: x86: introduce KVM_MEM_ALLONES memory
In-Reply-To: <20200514191823.GA15847@linux.intel.com>
References: <20200514180540.52407-1-vkuznets@redhat.com> <20200514180540.52407-3-vkuznets@redhat.com> <20200514191823.GA15847@linux.intel.com>
Date:   Fri, 15 May 2020 10:24:45 +0200
Message-ID: <87imgxwqpe.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, May 14, 2020 at 08:05:37PM +0200, Vitaly Kuznetsov wrote:
>> PCIe config space can (depending on the configuration) be quite big but
>> usually is sparsely populated. Guest may scan it by accessing individual
>> device's page which, when device is missing, is supposed to have 'pci
>> holes' semantics: reads return '0xff' and writes get discarded. Currently,
>> userspace has to allocate real memory for these holes and fill them with
>> '0xff'. Moreover, different VMs usually require different memory.
>> 
>> The idea behind the feature introduced by this patch is: let's have a
>> single read-only page filled with '0xff' in KVM and map it to all such
>> PCI holes in all VMs. This will free userspace of obligation to allocate
>> real memory. Later, this will also allow us to speed up access to these
>> holes as we can aggressively map the whole slot upon first fault.
>> 
>> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  Documentation/virt/kvm/api.rst  | 22 ++++++---
>>  arch/x86/include/uapi/asm/kvm.h |  1 +
>>  arch/x86/kvm/x86.c              |  9 ++--
>>  include/linux/kvm_host.h        | 15 ++++++-
>>  include/uapi/linux/kvm.h        |  2 +
>>  virt/kvm/kvm_main.c             | 79 +++++++++++++++++++++++++++++++--
>>  6 files changed, 113 insertions(+), 15 deletions(-)
>> 
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index d871dacb984e..2b87d588a7e0 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -1236,7 +1236,8 @@ yet and must be cleared on entry.
>>  
>>    /* for kvm_memory_region::flags */
>>    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>> -  #define KVM_MEM_READONLY	(1UL << 1)
>> +  #define KVM_MEM_READONLY		(1UL << 1)
>> +  #define KVM_MEM_ALLONES		(1UL << 2)
>
> Why not call this KVM_MEM_PCI_HOLE or something else that better conveys
> that this is memslot is intended to emulate PCI master abort semantics?
>

Becuase there's always hope this can be usefult for something else but
PCI? :-) Actually, I was thinking about generalizing this a little bit
to something like KVM_MEM_CONSTANT with a way to set the pattern but I'm
failing to see any need for anything but all-ones or all-zeroes. Maybe
other-than-x86 architectures have some needs?

I'm definitely fine with renaming this to KVM_MEM_PCI_HOLE.

-- 
Vitaly

