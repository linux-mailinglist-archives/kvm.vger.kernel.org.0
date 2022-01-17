Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A518549057A
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 10:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238330AbiAQJ4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 04:56:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235893AbiAQJz7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 04:55:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642413359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/PNBuUABW17OI1MPUIKGcYQCkX+IJQeexMOvk7DAhBE=;
        b=WWgn0yEm4rKde2YQGKxJ0I1O47hnB6Lxvpn1bBi/medtS/wahhEDrKPJytw1rJ6bg7SPj+
        yB5oeUTfhBQPGkYwsmm445rTBti4XgNBvgx9J807bU9if2b9GS2FEcJlVNzgFD1U0jswsT
        lwpQ+LXQP4fQqi3/IeKXuHkeqKkV7c0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-kzcRxUdkPumLkPWicuuIYQ-1; Mon, 17 Jan 2022 04:55:58 -0500
X-MC-Unique: kzcRxUdkPumLkPWicuuIYQ-1
Received: by mail-ed1-f72.google.com with SMTP id cf15-20020a0564020b8f00b0040284b671c6so2614753edb.22
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 01:55:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/PNBuUABW17OI1MPUIKGcYQCkX+IJQeexMOvk7DAhBE=;
        b=6RScmMh/jKPTpr1+UgzgrqgKtAQIDs6v9vW7/QfhxqUD4nkCWln5Xbv/d9x1urnbNb
         kbN+0mMY0ulJZ/zVPauLgfXJI1gcyHte4E/ApqbupAZTrbjx3GbDPccAe3kuYSwGCHLQ
         51ihlVJDEaBJ205GywqyERcCST5pXNy2atkBA1M/VqsRqMmpmtUBISmqYaZ583mdSLej
         xkoK1pcGpKI75XuDceI6CFZh+c9rkjtG8FH1dvKfWgq4ZrerWkX45fKHxTzMclUNO1Rk
         W0JcGV1iJgwFZp6IWyP5h3zulxrIvo680TCBX5/ZcgkcgMYTB21OodRCoEFNsrZDqmYs
         o/og==
X-Gm-Message-State: AOAM5332teG6pfNF0NwlT4qbaDzMcxkF6EHEk1/1TzR1cYNiKN1ZSaOq
        hfJeeUAIQPUzA7vSDbhDMSwMHUCInx7lie8Y1dmFdhRSXtQGWmh4Djk4WVpD0PELsA7301BAOro
        q3Pxhc3kKNhcq
X-Received: by 2002:a17:906:589:: with SMTP id 9mr16756661ejn.721.1642413356905;
        Mon, 17 Jan 2022 01:55:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVTgCi97l2whIA2wAQKWU0iPnD65d8m1c2MtxiDiZX3r+1FWhb3KL3xNTaAAjlHDFIRq+gBQ==
X-Received: by 2002:a17:906:589:: with SMTP id 9mr16756643ejn.721.1642413356544;
        Mon, 17 Jan 2022 01:55:56 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v26sm2500979edd.41.2022.01.17.01.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 01:55:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <YeGsKslt7hbhQZPk@google.com>
References: <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
 <YeCowpPBEHC6GJ59@google.com> <20220114095535.0f498707@redhat.com>
 <87ilummznd.fsf@redhat.com> <20220114122237.54fa8c91@redhat.com>
 <87ee5amrmh.fsf@redhat.com> <YeGsKslt7hbhQZPk@google.com>
Date:   Mon, 17 Jan 2022 10:55:54 +0100
Message-ID: <8735lmn0t1.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jan 14, 2022, Vitaly Kuznetsov wrote:
>> Igor Mammedov <imammedo@redhat.com> writes:
>> 
>> > On Fri, 14 Jan 2022 10:31:50 +0100
>> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> >
>> >> Igor Mammedov <imammedo@redhat.com> writes:
>> >> 
>> >> 
>> >> > However, a problem of failing KVM_SET_CPUID2 during VCPU re-plug
>> >> > is still there and re-plug will fail if KVM rejects repeated KVM_SET_CPUID2
>> >> > even if ioctl called with exactly the same CPUID leafs as the 1st call.
>> >> >  
>> >> 
>> >> Assuming APIC id change doesn not need to be supported, I can send v2
>> >> here with an empty allowlist.
>> > As you mentioned in another thread black list would be better
>> > to address Sean's concerns or just revert problematic commit.
>> >
>> 
>> Personally, I'm leaning towards the blocklist approach even if just for
>> 'documenting' the fact that KVM doesn't correctly handle the
>> change. Compared to a comment in the code, such approach could help
>> someone save tons of debugging time (if anyone ever decides do something
>> weird, like changing MAXPHYADDR on the fly).
>
> I assume the blocklist approach is let userspace opt into rejecting KVM_SET_CPUID{,2},
> but allow all CPUID leafs and sub-leafs to be modified at will by
> default? 

No, honestly I was thinking about something much simpler: instead of
forbidding KVM_SET_CPUID{,2} after KVM_RUN completely (what we have now
in 5.16), we only forbid to change certain data which we know breaks
some assumptions in MMU, from the comment:
"
         * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
         * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
         * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
         * faults due to reusing SPs/SPTEs.
"
It seems that CPU hotplug path doesn't need to change these so we don't
need an opt-in/opt-out, we can just forbid changing certain things for
the time being. Alternatively, we can silently ignore such changes but I
don't quite like it because it would mask bugs in VMMs.

> I don't dislike the idea, but I wonder if it's unnecessarily fancy.
>
> What if we instead provide an ioctl/capability to let userspace toggle disabling
> of KVM_SET_CPUID{,2}, a la STAC/CLAC to override SMAP?  E.g. QEMU could enable
> protections after initially creating the vCPU, then temporarily
> disable protections only for the hotplug path?
>
> That'd provide solid protections for minimal effort, and if userspace can restrict
> the danger zone to one specific path, then userspace can easily do its own auditing
> for that one path.

Could work but it seems the protection would only "protect" VMM from
shooting itself in the foot and will likely result in killing the guest
anyway so I'm wondering if it's worth it.

-- 
Vitaly

