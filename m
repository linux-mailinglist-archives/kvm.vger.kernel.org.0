Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578FA48BD8A
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 04:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349079AbiALDKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 22:10:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347731AbiALDKX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 22:10:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641957023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2NWWAPkJ3M9351vEsOtrcbOXrpawwKQKxdhm7j/RE/c=;
        b=aZn93Gwbm66sCmkVYW1VYP0WS2g7yNS1ST7U2qIzuQtBbGZpV3ie4it9lZV0iWc+vUcxxM
        CPCMnidkR3Mm4geZBMX5Z3eaZavwd9It5Ps+9pKWUIbV2s9VYiY00jSWGP7ExtU04vyr3p
        BENyLikQKcTsqRijqqkrbZH/hEo1iaA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-LXz4nf07PlSiromW11bB0w-1; Tue, 11 Jan 2022 22:10:21 -0500
X-MC-Unique: LXz4nf07PlSiromW11bB0w-1
Received: by mail-pj1-f71.google.com with SMTP id t11-20020a17090a6a0b00b001b3a590dbefso5113090pjj.4
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 19:10:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2NWWAPkJ3M9351vEsOtrcbOXrpawwKQKxdhm7j/RE/c=;
        b=ByqYDfdGedAFkt0tsQQFumN5vyy7ty3hOq/Bo3xKhpDYlAyYuZnZwDdzY3TqjieTWF
         oWH5UAEhbHcnAAqsZPUjrBbtEkYpDG1obYKGep8++9mLpBD3KoF0iWXBTxIek+wD5wW5
         hGI5WiPjgXRSq93OiaYw9H+zjVeY+xFeiOVSdcdXMPnXOKhP69h7qUzbp5ae6TPZP8WE
         Ddkpmm6/8ljsB9iFwCdMM9udlfNKyxXfXxoh7mKgsKC6NqSIKS39ZbqZQV7cdA5bftSb
         BVKWkxyvrI9V+OPAMYVAnbx2+Yph95cbWyQRcp+5EDH4N7IWk18SajrxfDpf79d6XUyx
         BKBw==
X-Gm-Message-State: AOAM531ritAEaiiCdx5fxbi7ZxdwT5y3Sphl8Ifdz9eN+AQaIP6lv2d1
        gXLCJqyTQzaS1qKXUR7vdNzTu2kvl1bvDHlguAfkyIUhqvXf/eOOS/xLsXI5bgOrgVzgAi/hlYr
        lsLsqLS9EVrN8
X-Received: by 2002:a63:6f08:: with SMTP id k8mr6599736pgc.51.1641957020646;
        Tue, 11 Jan 2022 19:10:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHuZtbsMKeduNlpOE6Pxv1xFlQq4seoDfxI3TWalDOBGO8RBTYWzgdSfAt2CmZKvzu/j06nw==
X-Received: by 2002:a63:6f08:: with SMTP id k8mr6599720pgc.51.1641957020383;
        Tue, 11 Jan 2022 19:10:20 -0800 (PST)
Received: from xz-m1.local ([191.101.132.69])
        by smtp.gmail.com with ESMTPSA id p4sm5428123pfo.21.2022.01.11.19.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 19:10:19 -0800 (PST)
Date:   Wed, 12 Jan 2022 11:10:12 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Message-ID: <Yd5GlAKgh0L0ZQir@xz-m1.local>
References: <20211210163625.2886-1-dwmw2@infradead.org>
 <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
 <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
 <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
 <YcTpJ369cRBN4W93@google.com>
 <daeba2e20c50bbede7fbe32c4f3c0aed7091382e.camel@infradead.org>
 <YdjaOIymuiRhXUeT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YdjaOIymuiRhXUeT@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 08, 2022 at 12:26:32AM +0000, Sean Christopherson wrote:
> +Peter
> 
> On Wed, Jan 05, 2022, David Woodhouse wrote:
> > On Thu, 2021-12-23 at 21:24 +0000, Sean Christopherson wrote:
> > > Commit e880c6ea55b9 ("KVM: x86: hyper-v: Prevent using not-yet-updated TSC page
> > > by secondary CPUs") is squarely to blame as it was added after dirty ring, though
> > > in Vitaly's defense, David put it best: "That's a fairly awful bear trap".
> > 
> > Even with the WARN to keep us honest, this is still awful.
> > 
> > We have kvm_vcpu_write_guest()... but the vcpu we pass it is ignored
> > and only vcpu->kvm is used. But you have to be running on a physical
> > CPU which currently owns *a* vCPU of that KVM, or you might crash.
> > 
> > There is also kvm_write_guest() which doesn't take a vCPU as an
> > argument, and looks for all the world like it was designed for you not
> > to need one... but which still needs there to be a vCPU or it might
> > crash.

Right, I agree too those are slightly confusing.

> > 
> > I think I want to kill the latter, make the former use the vCPU it's
> > given, add a spinlock to the dirty ring which will be uncontended
> > anyway in the common case so it shouldn't hurt (?),
> 
> IIRC, Peter did a fair amount of performance testing and analysis that led to
> the current behavior.

Yes that comes out from the discussion when working on dirty ring.  I can't
remember the details too, but IIRC what we figured is 99% cases of guest
dirtying pages are with vcpu context.

The only outlier at that time (at least for x86) was kvm-gt who uses direct kvm
context but then it turns out that's an illegal use of the kvm API and kvm-gt
fixed itself instead.

Then we come to the current kvm_get_running_vcpu() approach because all the
dirty track contexts are within an existing vcpu context.  Dirty ring could be
simplified too because we don't need the default vcpu0 trick, nor do we need an
extra ring just to record no-vcpu contexts (in very early version of dirty ring
we do have N+1 rings, where N is the vcpu number, and the extra is for this).

kvm_get_running_vcpu() also has a slight benefit that it guarantees no spinlock
needed.

> 
> > and then let people use kvm->vcpu[0] when they really need to, with a
> > documented caveat that when there are *no* vCPUs in a KVM, dirty tracking
> > might not work.  Which is fine, as migration of a KVM that hasn't been fully
> > set up yet is silly.
> 
> "when they really need to" can be a slippery slope, using vcpu[0] is also quite
> gross.  Though I 100% agree that always using kvm_get_running_vcpu() is awful.

I agreed none of them looks like an extreme clean approach.

So far I'd hope we can fix the problem with what Sean suggested on postponing
the page update until when we have the vcpu context, so we keep the assumption
still true on "having a vcpu context" at least for x86 and that'll be the
simplest, afaiu.

Or do we have explicit other requirement that needs to dirty guest pages
without vcpu context at all?

Thanks,

-- 
Peter Xu

