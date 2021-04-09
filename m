Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D2535969A
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 09:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhDIHm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 03:42:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231895AbhDIHm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 03:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617954166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YNRAYvZEYzpqoys7GviK7KCuwJyenrXNkiKbNxZPfpU=;
        b=CqLLGpxrvPXKVQIoSPkhXXt3ZPN2tup3m1CkbHHzk9BvotQSpOd9G5M1dE65Rs3xB8xipT
        04WSd+DvGQiucJZByRNhJJgA9VmYMmgydINIOVl+AEVLr1/3E4qcNEGm1rk/vDDNZC7gqH
        3J5DVZrx5+D7V7cKYKV5ujmeFBbedU0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-4o4w7KXQM3elLtQ9dbkulA-1; Fri, 09 Apr 2021 03:42:44 -0400
X-MC-Unique: 4o4w7KXQM3elLtQ9dbkulA-1
Received: by mail-ed1-f71.google.com with SMTP id l22so2274695edt.8
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 00:42:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YNRAYvZEYzpqoys7GviK7KCuwJyenrXNkiKbNxZPfpU=;
        b=TZ726yxtkEKjQdU6Foacz3Nzm4GHNj3mK2eEmw/Y0PoMkAq1bZtxSa2tUtPh/iSB3b
         JMEga/QId4foTLgnJAUNnoe5vfejDtqQUYl8XkGZFuq+RUNfMrdgHgVd0hy26ZLXKRHP
         n+DLmuoa8ynKzONZ+5Gpb7NWe2/laJ29eo/3Yol557LpcBAUPqdzXqAHVEcg0p7mFnHM
         62nInayMqgU7nn74/Zm7vIMZUwfMwkTgwRfIQKDV/gN15EkGSzybBpg5luhES9Oon6hK
         ZPTwxhHcJ7GGpXYaAV7jHLTn1edbRR6kQbzA/K2jAlS2oNUuSDv5M1YVfzJjhqO6//V5
         DlCA==
X-Gm-Message-State: AOAM532u9TzTosDpAoagqYh7i9SWKImqWKkHpuh+G1bBIurCuHYm1YUQ
        5I6LUzgVXFkpG6EYdxxVQsk81Aw71axa3ncETrVOpkhn8XsXsXXhwUw8hMB1uddv0VAzZTd1Tq1
        xKnOeXc7hh8cT
X-Received: by 2002:a50:f29a:: with SMTP id f26mr16170636edm.13.1617954163350;
        Fri, 09 Apr 2021 00:42:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9X6LUCm/VlbxytiCCUWpZztthGe5jHm4meEp8gBOoBrkZhZ7mUGCrZnvizxVfncZD29wCmQ==
X-Received: by 2002:a50:f29a:: with SMTP id f26mr16170612edm.13.1617954163221;
        Fri, 09 Apr 2021 00:42:43 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ju23sm819785ejc.17.2021.04.09.00.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 00:42:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, graf@amazon.com, eyakovl@amazon.de,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH 0/4] Add support for XMM fast hypercalls
In-Reply-To: <20210408174521.GF32315@u366d62d47e3651.ant.amazon.com>
References: <20210407212926.3016-1-sidcha@amazon.de>
 <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
 <033e7d77-d640-2c12-4918-da6b5b7f4e21@redhat.com>
 <20210408154006.GA32315@u366d62d47e3651.ant.amazon.com>
 <53200f24-bd57-1509-aee2-0723aa8a3f6f@redhat.com>
 <20210408155442.GC32315@u366d62d47e3651.ant.amazon.com>
 <20210408163018.mlr23jd2r4st54jc@liuwe-devbox-debian-v2>
 <20210408174521.GF32315@u366d62d47e3651.ant.amazon.com>
Date:   Fri, 09 Apr 2021 09:42:41 +0200
Message-ID: <87wntb7vke.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Siddharth Chandrasekaran <sidcha@amazon.de> writes:

> On Thu, Apr 08, 2021 at 04:30:18PM +0000, Wei Liu wrote:
>> On Thu, Apr 08, 2021 at 05:54:43PM +0200, Siddharth Chandrasekaran wrote:
>> > On Thu, Apr 08, 2021 at 05:48:19PM +0200, Paolo Bonzini wrote:
>> > > On 08/04/21 17:40, Siddharth Chandrasekaran wrote:
>> > > > > > > Although the Hyper-v TLFS mentions that a guest cannot use this feature
>> > > > > > > unless the hypervisor advertises support for it, some hypercalls which
>> > > > > > > we plan on upstreaming in future uses them anyway.
>> > > > > > No, please don't do this. Check the feature bit(s) before you issue
>> > > > > > hypercalls which rely on the extended interface.
>> > > > > Perhaps Siddharth should clarify this, but I read it as Hyper-V being
>> > > > > buggy and using XMM arguments unconditionally.
>> > > > The guest is at fault here as it expects Hyper-V to consume arguments
>> > > > from XMM registers for certain hypercalls (that we are working) even if
>> > > > we didn't expose the feature via CPUID bits.
>> > >
>> > > What guest is that?
>> >
>> > It is a Windows Server 2016.
>> 
>> Can you be more specific? Are you implementing some hypercalls from
>> TLFS? If so, which ones?
>
> Yes all of them are from TLFS. We are implementing VSM and there are a
> bunch of hypercalls that we have implemented to manage VTL switches,
> memory protection and virtual interrupts.

Wow, sounds awesome! Do you plan to upstream this work?

> The following 3 hypercalls that use the XMM fast hypercalls are relevant
> to this patch set:
>
> HvCallModifyVtlProtectionMask
> HvGetVpRegisters 
> HvSetVpRegisters 

It seems AccessVSM and AccessVpRegisters privilges have implicit
dependency on XMM input/output. This will need to be enforced in KVM
userspace.

-- 
Vitaly

