Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104903DE35A
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 02:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbhHCAD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 20:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhHCAD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 20:03:29 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16603C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 17:03:19 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u16so13059693ple.2
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 17:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gNQxWs6ae3YcVZWqxF22UaX2JDNNXbpKD5ncaIixamI=;
        b=ICVkHfMst9Z81UIrA8uJEfXOrWBUSYEUJWxBHe9CJmt5AVnECYMdrq1Hd1SDXzhshf
         wpt/B4YueOBryw8Va3zhA/k9U5jACf1FqeOus5vu7i0w8ahZLyUL0dQdEVHtBcZHmVu2
         rCu9kwUiUqFYn+Ubbu7fz9p7RPemw+F6wgOkgzi4RGTB1FVo5Slb5WXRXxi4BEzsEgBN
         +l5mu7EIXoNkyiNr65Aat+mrjKxqzYotQa1euoT7gjAJcf2yS0nMVAWtdPF2MVgxKKoq
         +GNuopkA3tc+48C5P0T8/EVyxawIqs/Af7HPmiBdnR4b7Ay7ZC1gyY/DLKCXx0z3pMbH
         cWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gNQxWs6ae3YcVZWqxF22UaX2JDNNXbpKD5ncaIixamI=;
        b=XJbgwauD+4N7Q3PJEn63n39YKf+CM9AcNrudOf/+6hsLDXuqk9wQsxg+RFD6xHH8ZR
         +iQN8dZjYVzRBiR0cmZofepwzYG4zkC7ZlLn8z9tw4QaFC913CkqaA+G3OuDCM69k2+R
         pHjYEu3KL+O6qkrz4vp9omaNVIbwVni/H27ND1ylFAFbPtgs5jZF/fdGJUvgLzQ4eRhf
         qWwB9lkiLMXoTW34lpB/FzkH/8mG56LgFMP4q9Fg1B+rn9F0zt6zKioz4sukQ3vgizzh
         F/Jcjs/IoAzjXUgU7SrGkK9mAhOrbA8mHa6Pd7Mmv7xvEVANryQ82xWve+7K/n8TP/PG
         sjwA==
X-Gm-Message-State: AOAM530Ro5szdl1oMtFyHej9UMQJpyJvxWd7WAQpE6U70tDA27YWEBNg
        hA52OBP4TE+J5kW9GujVYvTqzQ==
X-Google-Smtp-Source: ABdhPJzM8mlDpJKWNVW20oZP2wcKsO88pRU6iGfhWQZEO6kTcNfh2YAGdk/LolW7auoHUpJnmjo9NQ==
X-Received: by 2002:a62:ce44:0:b029:3aa:37f6:6fd6 with SMTP id y65-20020a62ce440000b02903aa37f66fd6mr18988828pfg.59.1627948998390;
        Mon, 02 Aug 2021 17:03:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f19sm11572193pjj.22.2021.08.02.17.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 17:03:17 -0700 (PDT)
Date:   Tue, 3 Aug 2021 00:03:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit}
 tracepoints
Message-ID: <YQiHwtkEhx2AoQtT@google.com>
References: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
 <20210621204345.124480-2-krish.sadhukhan@oracle.com>
 <ac5d0cb7-9955-0482-33ee-cf06bb55db7a@redhat.com>
 <YQgeoOpaHGBDW49Z@google.com>
 <68082174-4137-db39-362c-975931688453@redhat.com>
 <c0f5ae5d-da93-8877-ce00-ee87b0b3650c@oracle.com>
 <CALMp9eQvEA8DDq03ny-EZpr0zjSMBmdiXCEdeaYe8qbvUknbGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQvEA8DDq03ny-EZpr0zjSMBmdiXCEdeaYe8qbvUknbGA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021, Jim Mattson wrote:
> On Mon, Aug 2, 2021 at 3:21 PM Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
> >
> >
> > On 8/2/21 9:39 AM, Paolo Bonzini wrote:
> > > On 02/08/21 18:34, Sean Christopherson wrote:
> > >> On Mon, Aug 02, 2021, Paolo Bonzini wrote:
> > >>> On 21/06/21 22:43, Krish Sadhukhan wrote:
> > >>>> With this patch KVM entry and exit tracepoints will
> > >>>> show "guest_mode = 0" if it is a guest and "guest_mode = 1" if it is a
> > >>>> nested guest.
> > >>>
> > >>> What about adding a "(nested)" suffix for L2, and nothing for L1?
> > >>
> > >> That'd work too, though it would be nice to get vmcx12 printed as well
> > >> so that it would be possible to determine which L2 is running without
> > >> having to cross-reference other tracepoints.
> > >
> > > Yes, it would be nice but it would also clutter the output a bit.

But with my gross hack, it'd only clutter nested entries/exits.

> > > It's like what we have already in kvm_inj_exception:
> > >
> > >         TP_printk("%s (0x%x)",
> > >                   __print_symbolic(__entry->exception, kvm_trace_sym_exc),
> > >                   /* FIXME: don't print error_code if not present */
> > >                   __entry->has_error ? __entry->error_code : 0)
> > >
> > > It could be done with a trace-cmd plugin, but that creates other issues
> > > since it essentially forces the tracepoints to have a stable API.
> >
> > Also, the vmcs/vmcb address is vCPU-specific, so if L2 runs on 10 vCPUs,
> > traces will show 10 different addresses for the same L2 and it's not
> > convenient on a cloud host where hundreds of L1s and L2s run.
> 
> The vmcx02 address is vCPU-specific. However, Sean asked for the
> vmcx12 address, which is a GPA that is common across all vCPUs.

Ya.  Obviously it doesn't help identifying L2 vCPU relationships, e.g. if an L2 VM
runs 10 vCPUs of its own, but in most cases the sequence of what was run for a
given L1 vCPU is what's interesting and relevant, whereas knowing which L2 vCPUs
belong to which L2 VM isn't often critical information for debug/triage.
