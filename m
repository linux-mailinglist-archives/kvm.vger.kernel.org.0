Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE5D258A17
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 10:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgIAIK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 04:10:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbgIAIK5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Sep 2020 04:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598947855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ywbzOyojoAfTL6CSiMEtbtQG/UWMpLz/fFs6teic35M=;
        b=Spv+Apd+7Q5ORi7B18oqd6PuD7qQs/Z6xEKUBFp6euxFrM2pOH1PqeKFlU4TNerS61WKgY
        C/Rh3h8Ba+isZeYTRnYpaLdsUJ2G+PHlRmJgBP6gRcn2gt5GVru1rj0fmvF5iShT/8jYDp
        2xcP73p8QJnrkm1GCeP9isjW2USJ+aY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-V1R6EHo6OLW9n_a6V1852A-1; Tue, 01 Sep 2020 04:10:54 -0400
X-MC-Unique: V1R6EHo6OLW9n_a6V1852A-1
Received: by mail-wm1-f70.google.com with SMTP id d5so122592wmb.2
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 01:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ywbzOyojoAfTL6CSiMEtbtQG/UWMpLz/fFs6teic35M=;
        b=cjKsTS7eWX+FrbBfWY7zL3vBOaHfFA7Ze6fnxNMLoeOfoeJm/Zy2lkbKHGeJhJGooE
         XO1vmNp5ZSU/wvtxoabm9Btuefsfq9Q+6dH2RrXUxH44JV7XW5qwLm0OBfFGEojWqsRc
         65Q91PB3Nn2MMgvGewZh+F6YispfHySqs8d3587+KQlVIbqHSjjNRuCxBmHJOlwXcxZ/
         eKvr4DLahUnCWQaEXTybh2VjA+CHux6CYYAeoJy90CxIZwB+TR2xEQ6nuay2/KrSnj6U
         wvBiwEr+jbT71a/xIRrBr1dx0Zfd3M+W8OLBU14NSYqRj/GpSyykZEoX/hRj/ZG6aOkj
         tHhw==
X-Gm-Message-State: AOAM5333LST+hf/eVIZ3e0PHFSbxNZvrLmZScRIIw/lr5ibmFR92LtjY
        iIjR0BmWbb06AN44C+b5E5azDzuj6osAejwsNrBE1FwLf9fEWljT8a/IzJHIlfZW8HT+jtd1X+B
        pEguiNJxjtGCC
X-Received: by 2002:a5d:420b:: with SMTP id n11mr526476wrq.11.1598947852915;
        Tue, 01 Sep 2020 01:10:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJys7NT738indZhV+2AmYFWU6qfb0ENn9iwBCkNPPMVDsNV8FR86m8VpWUAMS1aZrJF0pLZkcQ==
X-Received: by 2002:a5d:420b:: with SMTP id n11mr526450wrq.11.1598947852620;
        Tue, 01 Sep 2020 01:10:52 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n21sm705241wmi.21.2020.09.01.01.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 01:10:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
In-Reply-To: <CAJhGHyCLF4+5LV8Zwu5kczL48imKPDHJKizVd+VZwVha0U8BaQ@mail.gmail.com>
References: <20200824101825.4106-1-jiangshanlai@gmail.com> <CAJhGHyC1Ykq5V_2nFPLRz9JmtAiQu6aw4fCKo1LO7Qwzjvfg2g@mail.gmail.com> <875z8zx8qs.fsf@vitty.brq.redhat.com> <CAJhGHyCLF4+5LV8Zwu5kczL48imKPDHJKizVd+VZwVha0U8BaQ@mail.gmail.com>
Date:   Tue, 01 Sep 2020 10:10:50 +0200
Message-ID: <87y2ltx6gl.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lai Jiangshan <jiangshanlai@gmail.com> writes:

> On Mon, Aug 31, 2020 at 9:09 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Lai Jiangshan <jiangshanlai@gmail.com> writes:
>>
>> > Ping @Sean Christopherson
>> >
>>
>> Let's try 'Beetlejuice' instead :-)
>>
>> > On Mon, Aug 24, 2020 at 5:18 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>> >>
>> >> From: Lai Jiangshan <laijs@linux.alibaba.com>
>> >>
>> >> 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
>> >> changed it without giving any reason in the changelog.
>> >>
>> >> In theory, the syncing is needed, and need to be fixed by reverting
>> >> this part of change.
>>
>> Even if the original commit is not wordy enough this is hardly
>> better.
>
> Hello,
> Thank you for reviewing it.
>
> I'm sorry that when I said "reverting this part of change",
> I meant "reverting this line of code". This line of code itself
> is quite clear that it is not related to the original commit
> according to its changelog.
>
>> Are you seeing a particular scenario when a change in current
>> vCPU's MMU requires flushing TLB entries for *other* contexts, ... (see
>> below)
>
> So I don't think the patch needs to explain this because the patch
> does not change/revert anything about it.
>
> Anyway, using a "revert" in the changelog is misleading, when it
> is not really reverting the whole targeted commit. I would
> remove this wording.
>
> For the change in my patch, when kvm_mmu_get_page() gets a
> page with unsync children, the host side pagetable is
> unsynchronized with the guest side pagedtable, and the
> guest might not issue a "flush" operation on it. It is
> all about the host's emulation of the pagetable. So the host
> has the responsibility to synchronize the pagetables.
>

Ah, I see now, so it seems Sean's commit has a stray change in it: the
intention was to change KVM_REQ_TLB_FLUSH -> KVM_REQ_TLB_FLUSH_CURRENT
so we don't unneedlesly flush other contexts but one of the hunks
changed KVM_REQ_MMU_SYNC instead. Syncronizing MMU roots can't be
replaced with a TLB flush, we need to revert back the change. This
sounds reasonable to me, please send out v2 with the updated
description. Thanks!

-- 
Vitaly

