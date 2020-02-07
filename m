Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920D2155B93
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 17:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgBGQQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 11:16:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25222 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726951AbgBGQQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 11:16:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581092159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8UGF+us/QjNLtxAbCjqUfORhSYgR+W+cBk4g3xSP3Ts=;
        b=jGOORzy8U4/xPrrc6LdstGx/f9gJL2ud8OOJ2B7roU34jlm9f1TA3Njjgtixr/Odm5PjWq
        /okn/XtZgKM6dQ82NsvwWonrtlvDin80sDM1955/0MgKMnEyfkmC3J1qioDPpeYegdxyQt
        WN7U08sqQke1LTQDp0arU9h4XuRlkWM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-ojRfb5p0NXS0sB1beZAOpw-1; Fri, 07 Feb 2020 11:15:52 -0500
X-MC-Unique: ojRfb5p0NXS0sB1beZAOpw-1
Received: by mail-wr1-f72.google.com with SMTP id x15so1486683wrl.15
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 08:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8UGF+us/QjNLtxAbCjqUfORhSYgR+W+cBk4g3xSP3Ts=;
        b=BRZciBi4NxBYCpXU7PNW5dXLDn4bNfRnmMbzqJkyuUNQQj2dMp8HPUrVoghMcrLxYq
         hPu/hFCWGcFWlOwmRXKvFR08SDdmUFdujV9BbMOVV6yb1gD75Ktz9Ah0SjS0qIQ1u7Mf
         gGApElBvPr7KlBeX0ejBTud0H0OT53H4cZ+W3DCB/C3Tk8NHpUN789czrqVWyvqk/onf
         MRMcf+8+VGGQF2t2cAXzBKH+Gjf4I5uHPgBrJNBqS7nSlzHpAbBqBR8QbA9dsLvXR9J7
         74tv/aSYDgO3cLh1cG5MXjgmjzlqSzVxlVw1PyiYA783Bz0IPCJl+HnhqcpXgJCNXX0P
         atBA==
X-Gm-Message-State: APjAAAW9vCwtTt4H3uDKXGHT3keDLF2Z5lcYyJd3De4rmqE/0uh5udN9
        XBRDXRCNdTqLKpHHmXVlrgCHfNdWHxlmqc1dAqnEdWRhqtJU7IFp8FXllcSXXnds07iBC6s5D7r
        +ZPxyMDlyl6rU
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr5747588wru.220.1581092150864;
        Fri, 07 Feb 2020 08:15:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqzuMrUSlAHFFtOdliasJ2FbsSMODN3UyfYDYi/Y+DGrbA18SO09VGYXIKn9XxznvVzUjfgG7A==
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr5747573wru.220.1581092150650;
        Fri, 07 Feb 2020 08:15:50 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i4sm3820758wmd.23.2020.02.07.08.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 08:15:50 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Avoid retpoline on ->page_fault() with TDP
In-Reply-To: <20200207155539.GC2401@linux.intel.com>
References: <20200206221434.23790-1-sean.j.christopherson@intel.com> <878sleg2z7.fsf@vitty.brq.redhat.com> <20200207155539.GC2401@linux.intel.com>
Date:   Fri, 07 Feb 2020 17:15:49 +0100
Message-ID: <8736bmqsp6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Fri, Feb 07, 2020 at 10:29:16AM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> > Wrap calls to ->page_fault() with a small shim to directly invoke the
>> > TDP fault handler when the kernel is using retpolines and TDP is being
>> > used.  Denote the TDP fault handler by nullifying mmu->page_fault, and
>> > annotate the TDP path as likely to coerce the compiler into preferring
>> > the TDP path.
>> >
>> > Rename tdp_page_fault() to kvm_tdp_page_fault() as it's exposed outside
>> > of mmu.c to allow inlining the shim.
>> >
>> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> > ---
>> 
>> Out of pure curiosity, if we do something like
>> 
>> if (vcpu->arch.mmu->page_fault == tdp_page_fault)
>>     tdp_page_fault(...)
>> else if (vcpu->arch.mmu->page_fault == nonpaging_page_fault)
>>    nonpaging_page_fault(...)
>> ...
>> 
>> we also defeat the retpoline, right?
>
> Yep.
>
>> Should we use this technique ... everywhere? :-)
>
> It becomes a matter of weighing the maintenance cost and robustness against
> the performance benefits.  For the TDP case, amost no one (that cares about
> performance) uses shadow paging, the change is very explicit, tiny and
> isolated, and TDP page fault are a hot path, e.g. when booting the VM.
> I.e. low maintenance overhead, still robust, and IMO worth the shenanigans.
>
> The changes to VMX's VM-Exit handlers follow similar thinking: snipe off
> the exit handlers that are performance critical, but use a low maintenance
> implementation for the majority of handlers.
>
> There have been multiple attempts to add infrastructure to solve the
> maintenance and robustness problems[*], but AFAIK none of them have made
> their way upstream.
>
> [*] https://lwn.net/Articles/774743/
>

Oh I see, missed some of these discussion.

And I actualy forgot to say:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

as the patch itself looks good to me, I was just wondering about the
approach in general.

-- 
Vitaly

