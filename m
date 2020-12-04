Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E362CF31F
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 18:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgLDRav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 12:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgLDRav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 12:30:51 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FD4C0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 09:30:10 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id j13so3545610pjz.3
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 09:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C83LWVZ8wM91AdWAS0iA3r1viy6kVdAOxGG9S1jtaCw=;
        b=iJAUPmwWEnaAhg3wVRqh7oUcyTgWd+UHbESFOsFKDVfqajgfIROKPFQ5GD3OU+xa99
         Jl3jC+WqpIsbkSbHw/wROs7jt7qUdrlmAp5EEseFWwhknRSyQQJrHkiSxJSWBujBv5TZ
         7zhwhuArunV5D0CHnsEzlrVBVopSEiBeOYSKmSK8SJWyif03QcE0FIu0cTxZmcPzBgJm
         Pnc3BsqDFAjAJounHoX0+dImC/5neswOWxsc5tDWdxI9ngeqt1ULE2o+4DlAW6Gkayg1
         +7ieOETFbxJ7E6S7Tb1xRFdv1LS+r9l0jA3+JcuzuFQbbSYKINDifFz1seUopnH18UrJ
         N0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C83LWVZ8wM91AdWAS0iA3r1viy6kVdAOxGG9S1jtaCw=;
        b=O4Cc9HQVEFdI2vGNYJaTs4UMoOc9rHk5rTBBj/zv0KlNHAdViEi2xY1BmOo1v7xKBx
         3cbPk8JKL3UiKk9IFFY3WrsWLQY9cu86YyWRuqF/Z1fQ/FTeb0d1EzD5z8te1xEUqLwY
         j1AvCf85NldOpyGgw67j4ki6n2gy9ZZpLRtjrp84oucrS/FNLgeR5HCPRY3RheqAnMQC
         XQxN0je6ely1n+iYQ+EUeCYc5jZ5K54SEWR77JpfXDBzoiWA2C4KquSXezk1rVHYcO7U
         LeW91oaN2J9BJ28ZtiR++jiSnZS/eiecKS0lLgizB1tbRj67w+h7iG5sHNd6cYINgMSQ
         gz9g==
X-Gm-Message-State: AOAM532ieO+wzn4DgGqThMbrkB9D55OBHLwV4IT5eFKXce/ucC4l0aBd
        5/g08JTO/17kz1Tc2GvBzOzr6Q==
X-Google-Smtp-Source: ABdhPJy8VrWERnAQbr+qZ5xf1WYX5NQ0PtIo4qgWqJih4aRqFD0kiCHgE33P8yE3i2WON8L59+Zg8Q==
X-Received: by 2002:a17:90a:154a:: with SMTP id y10mr5170231pja.6.1607103010205;
        Fri, 04 Dec 2020 09:30:10 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id h11sm5728667pfn.27.2020.12.04.09.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 09:30:09 -0800 (PST)
Date:   Fri, 4 Dec 2020 09:30:02 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 03/39] KVM: x86/xen: register shared_info page
Message-ID: <X8pyGiVDuBGJmazJ@google.com>
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-4-joao.m.martins@oracle.com>
 <b647bed6c75f8743b8afea251a88f00a5feaee29.camel@infradead.org>
 <2d4df59d-f945-32dc-6999-a6f711e972ea@oracle.com>
 <896dc984-fa71-8f2f-d12b-458294f5f706@oracle.com>
 <58db65203b9464f6f225f4ef97c45af3c72cf068.camel@infradead.org>
 <6ea92fe2-4067-d0e0-b716-16d39a7a6065@oracle.com>
 <8c92b2f3a8e8829ec85d22091b2fe84794f12f78.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c92b2f3a8e8829ec85d22091b2fe84794f12f78.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 03, 2020, David Woodhouse wrote:
> On Wed, 2020-12-02 at 12:32 -0800, Ankur Arora wrote:
> > > On IRC, Paolo told me that permanent pinning causes problems for memory
> > > hotplug, and pointed me at the trick we do with an MMU notifier and
> > > kvm_vcpu_reload_apic_access_page().
> > 
> > Okay that answers my question. Thanks for clearing that up.
> > 
> > Not sure of a good place to document this but it would be good to
> > have this written down somewhere. Maybe kvm_map_gfn()?
> 
> Trying not to get too distracted by polishing this part, so I can
> continue with making more things actually work. But I took a quick look
> at the reload_apic_access_page() thing.
> 
> AFAICT it works because the access is only from *within* the vCPU, in
> guest mode.
> 
> So all the notifier has to do is kick all CPUs, which happens when it
> calls kvm_make_all_cpus_request(). Thus we are guaranteed that all CPUs
> are *out* of guest mode by the time...
> 
>     ...er... maybe not by the time the notifier returns, because all 
>     we've done is *send* the IPI and we don't know the other CPUs have 
>     actually stopped running the guest yet? 
> 
>     Maybe there's some explanation of why the actual TLB shootdown 
>     truly *will* occur before the page goes away, and some ordering 
>     rules which mean our reschedule IPI will happen first? Something 
>     like that ideally would have been in a comment in in MMU notifier.

KVM_REQ_APIC_PAGE_RELOAD is tagged with KVM_REQUEST_WAIT, which means that
kvm_kick_many_cpus() and thus smp_call_function_many() will have @wait=true,
i.e. the sender will wait for the SMP function call to finish on the target CPUs.
