Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44355B4A85
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 11:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfIQJda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 05:33:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfIQJda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 05:33:30 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9893785360
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 09:33:29 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id m14so1078758wru.17
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 02:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=USt1kKGPYmtgyFTYD/y0A1jODqobnZ9DDJDhO5ylVlA=;
        b=o0UYsI/FwmOu5Gov3Ndxj0Ny8fnsZ9K6TDUrZUNDVZJazJT7B5xubBfoeGT/xXFuzr
         mC1UbsHnGYbuZKVVqJUwI9Oq20ehDFZ8NinMw1mzDSDEfLK1iipIJWuLvMm6JeMuSJRO
         0hHIYwS5oKb0OpZCNdI0At9t3g/2239qdLPDVXNvGZPm50iPpji+Ok3AOYDSRbMPtQpj
         z6bTCk1vccRtP85rCULNovz6NsT8mYGZRQlwH7crR55dhqAOB//E/cQs7PdtWUH4voR4
         ARim+uWn0ylXZZg+bOfGvJlsk9/mS/T//Yi2ALIhvD2HddJr7WdtB/k73YMMvZzL+W2+
         dWyQ==
X-Gm-Message-State: APjAAAXZbgXEtUyJckGja/bMFcKJipNhCATYRyEP5D79ihoflevmNabw
        6ugHfsFf66z4KetKD/+6z2Uk2dD1GXW+63amASM4dBe7+oSKo2/jCPaiWnF1SEpTDIH96JFJFai
        W/kIOlO17YXw6
X-Received: by 2002:a05:600c:22da:: with SMTP id 26mr2538074wmg.177.1568712808287;
        Tue, 17 Sep 2019 02:33:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxE0OwLxxEExBqqFmu5jEGpfsU1LN8pNgOQBJRy2TH+nRrjttR1HYteSzAvN5aajblv2RTsXQ==
X-Received: by 2002:a05:600c:22da:: with SMTP id 26mr2538044wmg.177.1568712808057;
        Tue, 17 Sep 2019 02:33:28 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g185sm4109888wme.10.2019.09.17.02.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 02:33:27 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        the arch/x86 maintainers <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH 2/3] KVM: x86: hyper-v: set NoNonArchitecturalCoreSharing CPUID bit when SMT is impossible
In-Reply-To: <CALMp9eRa0-HO+JWGDoAFO1zOtNjrutfT7d4pLxjsxn-XiAJwwQ@mail.gmail.com>
References: <20190916162258.6528-1-vkuznets@redhat.com> <20190916162258.6528-3-vkuznets@redhat.com> <CALMp9eRa0-HO+JWGDoAFO1zOtNjrutfT7d4pLxjsxn-XiAJwwQ@mail.gmail.com>
Date:   Tue, 17 Sep 2019 11:33:26 +0200
Message-ID: <87ef0fb72x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Mon, Sep 16, 2019 at 9:23 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Hyper-V 2019 doesn't expose MD_CLEAR CPUID bit to guests when it cannot
>> guarantee that two virtual processors won't end up running on sibling SMT
>> threads without knowing about it. This is done as an optimization as in
>> this case there is nothing the guest can do to protect itself against MDS
>> and issuing additional flush requests is just pointless. On bare metal the
>> topology is known, however, when Hyper-V is running nested (e.g. on top of
>> KVM) it needs an additional piece of information: a confirmation that the
>> exposed topology (wrt vCPU placement on different SMT threads) is
>> trustworthy.
>>
>> NoNonArchitecturalCoreSharing (CPUID 0x40000004 EAX bit 18) is described in
>> TLFS as follows: "Indicates that a virtual processor will never share a
>> physical core with another virtual processor, except for virtual processors
>> that are reported as sibling SMT threads." From KVM we can give such
>> guarantee in two cases:
>> - SMT is unsupported or forcefully disabled (just 'disabled' doesn't work
>>  as it can become re-enabled during the lifetime of the guest).
>> - vCPUs are properly pinned so the scheduler won't put them on sibling
>> SMT threads (when they're not reported as such).
>
> That's a nice bit of information. Have you considered a mechanism for
> communicating this information to kvm guests in a way that doesn't
> require Hyper-V enlightenments?
>

(I haven't put much thought in this) but can we re-use MD_CLEAR CPUID
bit for that? Like if the hypervisor can't guarantee usefulness
(e.g. when two random vCPUs can be put on sibling SMT threads) of
flushing, is there any reason to still make the guest think the feature
is there?

-- 
Vitaly
