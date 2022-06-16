Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD1754E832
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 18:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347011AbiFPQ64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 12:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245545AbiFPQ6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 12:58:49 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E33A3B546
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:58:48 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so2023313pjz.1
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HkRFW1GGd6YJgj7k4YXRx8XgplKWeZJssnU2XuONF8E=;
        b=JxOawYuxnEp1lVH2zMnCnOnzoXQ3zBXpBSx0HszaFeb7++ONRrY8GSdIMhrFtE1tg6
         htH3DcxaqK8RyztquHWf0Gh8DbuNx221cGGIohVf/d36qGcfUqo+t3afK7r9aw5ytTAl
         Vga42wQ9mnabuyQoyxEeWUdEv6vF/YDae5dH+CtPUidWhu3tKYcFe/PVs0yT1kQyZoPm
         ES63Zm3mit+/4d+SrZHGYFhuq7jjqTinjf0Rw9E24VVjcniu4lwFfr/0WkHPyzZ+NRRH
         SrYTAjdwoJd/bQ8Az+NlE6IrFwo/vgpCAhD2YtC0673KQ74Ty+Ob8rPMVlRZpdQG2rEW
         VXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HkRFW1GGd6YJgj7k4YXRx8XgplKWeZJssnU2XuONF8E=;
        b=h+HWscY+49+NDAu5/kxZcVbVjKWtk+qKfh1S6UQ+XtZ1ALxUisoPnljqpx8TlK3eHL
         V4YdgZg2CxuoahEiQYh0c20g0BJauAzXKi59xmN0ujm3jWcX47lmrcYZ18ikOXornBkK
         vnxqSJkQsS3gioG0Fh4S4CGQMff3odclGHjxGuN5KBvGOBjYUuDx8WE/LlcRbhLqwy/S
         V1YGZQzgARF9tfMmzxxoUZvLCyVoUZgLabinq9ak/ySCO9TXcZ1HxVzdj8rP/H8nfi3X
         Nki5GElnMNXq5WKQdZDm3YZok4/Q1QD95N3rjCb9IOsrlU6cA4sI2aSlf8I7snNpVznP
         psPg==
X-Gm-Message-State: AJIora8NXY0UV2KaRezKAEtd1k8aUpkTY2s6TG6gPyf0j3INAwrJY3pp
        rklnI9wlZpn6xhaRlU4mtVSLmw==
X-Google-Smtp-Source: AGRyM1sL3yEIY2VF4/AgJkEvHa4atGOyUeL/Gd2fVuqrsthtk1SS4PZ6pVeB/stvC36s3zOWY+9DLQ==
X-Received: by 2002:a17:903:284:b0:168:4d1a:3ccc with SMTP id j4-20020a170903028400b001684d1a3cccmr5657902plr.78.1655398727588;
        Thu, 16 Jun 2022 09:58:47 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id g136-20020a62528e000000b0051bba89c2bcsm2031219pfb.58.2022.06.16.09.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:58:47 -0700 (PDT)
Date:   Thu, 16 Jun 2022 16:58:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Kyle Meyer <kyle.meyer@hpe.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, russ.anderson@hpe.com,
        payton@hpe.com, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 2048
Message-ID: <YqthQ6QmK43ZPfkM@google.com>
References: <20220613145022.183105-1-kyle.meyer@hpe.com>
 <CALzav=eWPiii4_zmYifdi_pSS6nUvMEchwQcvD+W2CfOR+-s8Q@mail.gmail.com>
 <8735g7k5u2.fsf@redhat.com>
 <CALzav=fjvO0csAV5onsdXijDnvYJNMccoNHKPiraU6tHhCURuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=fjvO0csAV5onsdXijDnvYJNMccoNHKPiraU6tHhCURuQ@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022, David Matlack wrote:
> On Tue, Jun 14, 2022 at 1:28 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > David Matlack <dmatlack@google.com> writes:
> >
> > > On Mon, Jun 13, 2022 at 11:35 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
> > >>
> > >> Increase KVM_MAX_VCPUS to 2048 so we can run larger virtual machines.
> > >
> > > Does the host machine have 2048 CPUs (or more) as well in your usecase?
> > >
> > > I'm wondering if it makes sense to start configuring KVM_MAX_VCPUS
> > > based on NR_CPUS. That way KVM can scale up on large machines without
> > > using more memory on small machines.
> > >
> > > e.g.
> > >
> > > /* Provide backwards compatibility. */
> > > #if NR_CPUS < 1024
> > >   #define KVM_MAX_VCPUS 1024
> > > #else
> > >   #define KVM_MAX_VCPUS NR_CPUS
> > > #endif
> > >
> > > The only downside I can see for this approach is if you are trying to
> > > kick the tires a new large VM on a smaller host because the new "large
> > > host" hardware hasn't landed yet.
> 
> Heh. My point here doesn't make sense. The actual number of CPUs in
> the host machine wouldn't matter, just the host kernel's NR_CPUS.
> 
> >
> > FWIW, while I don't think there's anything wrong with such approach, it
> > won't help much distro kernels which are not recompiled to meet the
> > needs of a particular host.
> 
> But is there a use-case for running a VM with more vCPUs than the
> kernel's NR_CPUS?

With custom configs yes, e.g. my host kernel config for my anemic old system has
CONFIG_NR_CPUS=12 and I occasionally run VMs with >12 vCPUs for testing purposes.

But that obviously doesn't apply if KVM_MAX_VCPUS has a lower bound of 1024, so
I agree that making KVM_MAX_VCPUS=max(1024, NR_CPUS) should do just fine.
