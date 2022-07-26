Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A55581126
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 12:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238622AbiGZK1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 06:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiGZK1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 06:27:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0E73DF17
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 03:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658831231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4qHufDszC3S/UXoGPmLgr+LT8K7L0fqHbq2F1Jr6Ad0=;
        b=B45PJAqyZfXnoPGS1Tk5G2bXF65PHD+IzbMw8SjEd+/1K0gKzyy3pMLL291czoR5PxfIh3
        pN/OJEJKJVe/Tl+D3qD2drd7vsQR46lzePwiuk5jGi3tPCGRkrnhoHmNmF9RuKC6LLzP6O
        9jDUl4r0L/gjQkKZreGPGV0+ySsrCbA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-2uGm0VeyNYat42mNKomYqw-1; Tue, 26 Jul 2022 06:27:10 -0400
X-MC-Unique: 2uGm0VeyNYat42mNKomYqw-1
Received: by mail-ej1-f72.google.com with SMTP id sg42-20020a170907a42a00b0072e3fc6cdd1so4060269ejc.13
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 03:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=4qHufDszC3S/UXoGPmLgr+LT8K7L0fqHbq2F1Jr6Ad0=;
        b=o+SCLDOFG6BcpxlrLy9ShNw6rDu1DSTdYmQT/AC6NvjBDUkVD2q9Cwb3TnNkPOVVOs
         RqapN7C16C8BPUO+pW0isfYVYzEKSFAM9W9onW+I8DagiLqSZJjCsoLwDeanSms4R7nA
         aY4MQeyrVJ7OiXffJ942/oVOC86ULnP74S9IGjgGYXkXw/kPs8QUkh++nTj4ad31U1mo
         JTyjyXu7I+S7Ux2lS9RAo+2OWkbyen85216wTLE/MWF3nh1trcG6Xcqup6lT54OkLudG
         H1IWL3rpe9J4m/kzvpQ5Cicr9fIgZ2G0ci+aEg/eLuzZENh/CtH9uBIlFW+12iop4Gts
         hC6w==
X-Gm-Message-State: AJIora+gVW3fgiPtoBuelCkOMOn7nM2LpyhKx7/SSj4dOR2786qKk+HP
        lQorAvMDuXLou+F3SFf0QXHdHcZwBzE3vNcFfzIQB6ReJ7vDOKlNafCZhmtnGP5aEjnmJZRntXp
        rHOi2pzfBONJQ
X-Received: by 2002:a17:907:9810:b0:72f:36e5:266c with SMTP id ji16-20020a170907981000b0072f36e5266cmr13370131ejc.105.1658831228078;
        Tue, 26 Jul 2022 03:27:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tzvJx2BmA9Y9WJYMRkHNQKE5WwuhnG2bCIf5i89vcfA4dJvmoC55LLUzurv8om5eij1GIqIg==
X-Received: by 2002:a17:907:9810:b0:72f:36e5:266c with SMTP id ji16-20020a170907981000b0072f36e5266cmr13370102ejc.105.1658831227663;
        Tue, 26 Jul 2022 03:27:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id dk20-20020a0564021d9400b0043a71775903sm8368247edb.39.2022.07.26.03.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 03:27:06 -0700 (PDT)
Message-ID: <69b45487-ce0e-d643-6c48-03c5943ce2e6@redhat.com>
Date:   Tue, 26 Jul 2022 12:27:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Andrei Vagin <avagin@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20220722230241.1944655-1-avagin@google.com>
 <Yts1tUfPxdPH5XGs@google.com>
 <CAEWA0a4hrRb5HYLqa1Q47=guY6TLsWSJ_zxNjOXXV2jCjUekUA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
In-Reply-To: <CAEWA0a4hrRb5HYLqa1Q47=guY6TLsWSJ_zxNjOXXV2jCjUekUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/22 10:33, Andrei Vagin wrote:
> We can think about restricting the list of system calls that this hypercall can
> execute. In the user-space changes for gVisor, we have a list of system calls
> that are not executed via this hypercall. For example, sigprocmask is never
> executed by this hypercall, because the kvm vcpu has its signal mask.  Another
> example is the ioctl syscall, because it can be one of kvm ioctl-s.

The main issue I have is that the system call addresses are not translated.

On one hand, I understand why it's done like this; it's pretty much 
impossible to do it without duplicating half of the sentry in the host 
kernel.  And the KVM API you're adding is certainly sensible.

On the other hand this makes the hypercall even more specialized, as it 
depends on the guest's memslot layout, and not self-sufficient, in the 
sense that the sandbox isn't secure without prior copying and validation 
of arguments in guest ring0.

> == Host Ring3/Guest ring0 mixed mode ==
> 
> This is how the gVisor KVM platform works right now. We don’t have a separate
> hypervisor, and the Sentry does its functions. The Sentry creates a KVM virtual
> machine instance, sets it up, and handles VMEXITs. As a result, the Sentry runs
> in the host ring3 and the guest ring0 and can transparently switch between
> these two contexts.  In this scheme, the sentry syscall time is 3600ns.
> This is for the case when a system call is called from gr0.
> 
> The benefit of this way is that only a first system call triggers vmexit and
> all subsequent syscalls are executed on the host natively.
> 
> But it has downsides:
> * Each sentry system call trigger the full exit to hr3.
> * Each vmenter/vmexit requires to trigger a signal but it is expensive.
> * It doesn't allow to support Confidential Computing (SEV-ES/SGX). The Sentry
>    has to be fully enclosed in a VM to be able to support these technologies.
> 
> == Execute system calls from a user-space VMM ==
> 
> In this case, the Sentry is always running in VM, and a syscall handler in GR0
> triggers vmexit to transfer control to VMM (user process that is running in
> hr3), VMM executes a required system call, and transfers control back to the
> Sentry. We can say that it implements the suggested hypercall in the
> user-space.
> 
> The sentry syscall time is 2100ns in this case.
> 
> The new hypercall does the same but without switching to the host ring 3. It
> reduces the sentry syscall time to 1000ns.

Yeah, ~3000 clock cycles is what I would expect.

What does it translate to in terms of benchmarks?  For example a simple 
netperf/UDP_RR benchmark.

Paolo

