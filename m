Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A068D60D7A6
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 01:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiJYXHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 19:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiJYXHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 19:07:16 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF61E987D
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 16:07:15 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b29so9049144pfp.13
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 16:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A7kKcrW8+Rtrlgds+v4H23IM/wohgMjvlalkGtkGE48=;
        b=i9+bLN5FonRCnXyaeAZ/jEHxOllBLcuLRG6g7djDO2ymq1eoILB4dhajH6DdkL9Ypw
         dWBExwNgYe7L3rF6XlQLTuNRvlRhUlKYjHp/L1iVjmBzSGExzuACU05FIwWhOkZaZxhW
         SlFEj6y2aedc8tdZPGfzSyQiWabdMrxN8vyn13231CbpBxAP9sT5+IQhyoFu0+oYUWQp
         PhX+L5oqnTXUtVtqktZxw/YivgWoFURGH7AMjlXoM6O1hKn1gn0MTGBodUdfBHCYYrk0
         knLwhuacFx5zJW48cTVCrNO9wqrHItHkkxk/aDLvtlYfLl6DtxNw1JoLy41IaidlmKLW
         zOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7kKcrW8+Rtrlgds+v4H23IM/wohgMjvlalkGtkGE48=;
        b=KacmsAgBqFmzEp+sQ9nEN8PYvuMvbIq7z5ybaSQbPwW4hx8Fz5WgmvDdt58nJv26K4
         LO3Fiajs+T6vX7H4NzWy93IyfavaqTo+wxnvjxTQmgIV7A3dU79wf/2SwwK29hXC3E1/
         oVj0ERxBrky295fm9OChWo3r1CtXFTOiqitldeBhC2qdgUPmt6Z4iFg4m6CikApyv4dL
         dQipj8yH76O0ZPFnlIUzB7CnOHoq0IUzzEMcSYk7HABaODKpVx9V7DASMDF53fUQCjAz
         zVQMV/zbaenjZVH5FgUlJORZLxg6Qu7VyE42A+Fd+ErEoyP7gug0KrPBttT9UBw0XR5P
         ibag==
X-Gm-Message-State: ACrzQf0KWvVS/xC8+khOKvBC3hIiBw2QhaFsKbnSmrfW6lw0cJv9SDD2
        8v6iVzIqc4UKWsmrr0KA7QNUaJHaYqUkZw==
X-Google-Smtp-Source: AMsMyM6XTCEyWvCDFpHQ+LBlReUY4pzPnEC3X0btKX861SIHcsajyGNCB7SZ3Rkpde+LhaSv6L5iPg==
X-Received: by 2002:a63:85c6:0:b0:46e:ffdb:2e77 with SMTP id u189-20020a6385c6000000b0046effdb2e77mr11866913pgd.439.1666739234843;
        Tue, 25 Oct 2022 16:07:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x1-20020aa79a41000000b0056c32be99dcsm1164090pfj.117.2022.10.25.16.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 16:07:14 -0700 (PDT)
Date:   Tue, 25 Oct 2022 23:07:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: API to block and resume all running vcpus in a
 vm
Message-ID: <Y1hsHjPuZfrREulV@google.com>
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <a2e16531-5522-a334-40a1-2b0e17663800@linux.ibm.com>
 <2701ce67-bfff-8c0c-4450-7c4a281419de@redhat.com>
 <384b2622-8d7f-ce02-1452-84a86e3a5697@linux.ibm.com>
 <Y1cVfECAAfmp5XqA@google.com>
 <5a26c107-9ab5-60ee-0e9c-a9955dfe313d@redhat.com>
 <Y1gG/W/q/VIydpMu@google.com>
 <02c910bb-3ea0-fa84-7a1c-92fb9e8b03de@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02c910bb-3ea0-fa84-7a1c-92fb9e8b03de@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 25, 2022, Paolo Bonzini wrote:
> On 10/25/22 17:55, Sean Christopherson wrote:
> > On Tue, Oct 25, 2022, Paolo Bonzini wrote:
> >    - to prevent _all_ ioctls() because it's not just KVM_RUN that consumes memslots
> 
> This is perhaps an occasion to solve another disagreement: I still think
> that accessing memory outside KVM_RUN (for example KVM_SET_NESTED_STATE
> loading the APICv pages from VMCS12) is a bug, on the other hand we
> disagreed on that and you wanted to kill KVM_REQ_GET_NESTED_STATE_PAGES.

I don't think it's realistic to make accesses outside of KVM_RUN go away, e.g.
see the ARM ITS discussion in the dirty ring thread.  kvm_xen_set_evtchn() also
explicitly depends on writing guest memory without going through KVM_RUN (and
apparently can be invoked from a kernel thread?!?).

In theory, I do actually like the idea of restricting memory access to KVM_RUN,
but in reality I just think that forcing everything into KVM_RUN creates far more
problems than it solves.  E.g. my complaint with KVM_REQ_GET_NESTED_STATE_PAGES
is that instead of syncrhonously telling userspace it has a problem, KVM chugs
along as if everything is fine and only fails at later point in time.  I doubt
userspace would actually do anything differently, i.e. the VM is likely hosed no
matter what, but deferring work adds complexity in KVM and makes it more difficult
to debug problems when they occur.

> >    - to stop anything else in the system that consumes KVM memslots, e.g. KVM GT
> 
> Is this true if you only look at the KVM_GET_DIRTY_LOG case and consider it
> a guest bug to access the memory (i.e. ignore the strange read-only changes
> which only happen at boot, and which I agree are QEMU-specific)?

Yes?  I don't know exactly what "the KVM_GET_DIRTY_LOG case" is. 
 
> >    - to signal vCPU tasks so that the system doesn't livelock if a vCPU is stuck
> >      outside of KVM, e.g. in get_user_pages_unlocked() (Peter Xu's series)
> 
> This is the more important one but why would it livelock?

Livelock may not be the right word.  Peter's series is addressing a scenario where
a vCPU gets stuck faulting in a page because the page never arrives over the
network.  The solution is to recognize non-fatal signals while trying to fault in
the page.

KVM_KICK_ALL_RUNNING_VCPUS doesn't handle that case because it's obviously not
realistic to check for pending KVM requests while buried deep in mm/ code.  I.e.
userspace also needs to send SIGUSR1 or whatever to ensure all vCPUs get kicked
out of non-KVM code.

That's not the end of the world, and they probably end up being orthogonal things
in userspace code, but it yields a weird API because KVM_KICK_ALL_RUNNING_VCPUS
ends up with the caveat of "oh, by the way, userspace also needs to signal all
vCPU tasks too, otherwise KVM_KICK_ALL_RUNNING_VCPUS might hang".

> > And because of the nature of KVM, to support this API on all architectures, KVM
> > needs to make change on all architectures, whereas userspace should be able to
> > implement a generic solution.
> 
> Yes, I agree that this is essentially just a more efficient kill().
> Emanuele, perhaps you can put together a patch to x86/vmexit.c in
> kvm-unit-tests, where CPU0 keeps changing memslots and the other CPUs are in
> a for(;;) busy wait, to measure the various ways to do it?

I'm a bit confused.  Is the goal of this to simplify QEMU, dedup VMM code, provide
a more performant solution, something else entirely?  I.e. why measure the
performance of x86/vmexit.c?  I have a hard time believing the overhead of pausing
vCPUs is going to be the long pole when it comes to memslot changes.  I assume
rebuilding KVM's page tables because of the "zap all" behavior seems like would
completely dwarf any overhead from pausing vCPUs.
