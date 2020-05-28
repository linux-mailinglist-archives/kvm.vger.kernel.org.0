Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5B21E5B16
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 10:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgE1Imr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 04:42:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49801 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727088AbgE1Imq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 04:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590655364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fvx+64wD7VVw0aAEs3VYwAWqeGVZ/eQWc2QHhJjKSZs=;
        b=WJeqb3VnoLXd5qJVHs5bLNqWPPAKb+CNf5rW5r1a2FYC1a6Dp5bjK2cIk6kYOI6xs56yuQ
        Zjmqgz4udLHIgWe7viH1RCayXHVn50OM/hiTcaJ0npRuVL3n/ms0baHzu4WGfj3swajpHn
        0vnMqnF6ELrxrSSH1NzCUATLpz5AYPw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-TqK5uXvKNMG9sxJEWnq8Kg-1; Thu, 28 May 2020 04:42:43 -0400
X-MC-Unique: TqK5uXvKNMG9sxJEWnq8Kg-1
Received: by mail-ed1-f72.google.com with SMTP id w23so18424edt.18
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 01:42:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Fvx+64wD7VVw0aAEs3VYwAWqeGVZ/eQWc2QHhJjKSZs=;
        b=Fg4HUoxNYnoH1sQ9TkX+P/wOwssf3co59zKGeA4kdgVEPOiBmIsbCNMROGhmKrJ20g
         CTFnPVH8BApjpphpa6s7nWmE1ABguYI9/AFjqiW6yrP6C4Xby0H1V3P1hC11wYQBqoSW
         Kupp4rrSEGU5/3b3QTru7O2x1jI6dfbr4VgW8WRQT6lunXaxovvp5OKPJlyBkuS9jdu+
         mP/zQKDTNJ+LeCXJTXUQckXlB7Y/N9XHF0UXevxak5wM96xyyLW+npFx0lGttPyDDBB8
         xnfjFPeIaZThT4UgyIWsDH2XG5sxi6AQM6ebM8PeRFBqPVYdnUUsYEMsi/h0ZEL/Z93O
         fCzw==
X-Gm-Message-State: AOAM5330TTOshm4HokE4kgDQ47IQsga8c3BYwESAlEshRpg8RWTebbYL
        nWrZhEV+5kR7vu8DnVJHkzr6IhfH+QZkKU7Cmg3lddzhRcDJgkb3Dz9IuFDddYv0PBedjQqNJNP
        n/3oRU9xy8vDP
X-Received: by 2002:a05:6402:1434:: with SMTP id c20mr1863667edx.27.1590655360782;
        Thu, 28 May 2020 01:42:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmwuFe03uOkyVF7/OHMQGe1m9vs1yVv9lSdGU5anfJ+bfgT3LjEFTVBq0ghQke7oQvGAigYg==
X-Received: by 2002:a05:6402:1434:: with SMTP id c20mr1863652edx.27.1590655360464;
        Thu, 28 May 2020 01:42:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b14sm394893ejq.105.2020.05.28.01.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 01:42:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
In-Reply-To: <20200526182745.GA114395@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com> <20200525144125.143875-3-vkuznets@redhat.com> <20200526182745.GA114395@redhat.com>
Date:   Thu, 28 May 2020 10:42:38 +0200
Message-ID: <875zcg4fi9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, May 25, 2020 at 04:41:17PM +0200, Vitaly Kuznetsov wrote:
>> 
>
> [..]
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 0a6b35353fc7..c195f63c1086 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -767,7 +767,7 @@ struct kvm_vcpu_arch {
>>  		u64 msr_val;
>>  		u32 id;
>>  		bool send_user_only;
>> -		u32 host_apf_reason;
>> +		u32 host_apf_flags;
>
> Hi Vitaly,
>
> What is host_apf_reason used for. Looks like it is somehow used in
> context of nested guests. I hope by now you have been able to figure
> it out.
>
> Is it somehow the case of that L2 guest takes a page fault exit
> and then L0 injects this event in L1 using exception. I have been
> trying to read this code but can't wrap my head around it.
>
> I am still concerned about the case of nested kvm. We have discussed
> apf mechanism but never touched nested part of it. Given we are
> touching code in nested kvm part, want to make sure it is not broken
> in new design.
>

Sorry I missed this.

I think we've touched nested topic a bit already:
https://lore.kernel.org/kvm/87lfluwfi0.fsf@vitty.brq.redhat.com/

But let me try to explain the whole thing and maybe someone will point
out what I'm missing.

The problem being solved: L2 guest is running and it is hitting a page
which is not present *in L0* and instead of pausing *L1* vCPU completely
we want to let L1 know about the problem so it can run something else
(e.g. another guest or just another application).

What's different between this and 'normal' APF case. When L2 guest is
running, the CPU (physical) is in 'guest' mode so we can't inject #PF
there. Actually, we can but L2 may get confused and we're not even sure
it's L2's fault, that L2 supported APF and so on. We want to make L1
deal with the issue.

How does it work then. We inject #PF and L1 sees it as #PF VMEXIT. It
needs to know about APF (thus KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT) but
the handling is exactly the same as do_pagefault(): L1's
kvm_handle_page_fault() checkes APF area (shared between L0 and L1) and
either pauses a task or resumes a previously paused one. This can be a
L2 guest or something else.

What is 'host_apf_reason'. It is a copy of 'reason' field from 'struct
kvm_vcpu_pv_apf_data' which we read upon #PF VMEXIT. It indicates that
the #PF VMEXIT is synthetic.

How does it work with the patchset: 'page not present' case remains the
same. 'page ready' case now goes through interrupts so it may not get
handled immediately. External interrupts will be handled by L0 in host
mode (when L2 is not running). For the 'page ready' case L1 hypervisor
doesn't need any special handling, kvm_async_pf_intr() irq handler will
work correctly.

I've smoke tested this with VMX and nothing immediately blew up.

-- 
Vitaly

