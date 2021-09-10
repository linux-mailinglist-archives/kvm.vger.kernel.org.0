Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838AC40732E
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 00:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbhIJWFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 18:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbhIJWFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 18:05:04 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE8EC061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 15:03:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d5so2287274pjx.2
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 15:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kMcSN7EDR5pkPvVWu02zCDgJ8As0247Z64kS+l1KD5M=;
        b=Arop9WPr0Ceoz84Ze+YMFVIDNRDnLtzMNDpy4BUZF70ia5fRzvIq7RlZMLZjyGEaXQ
         DbIC/qFNDlwy7ysOoDuaQFsdcTnJLjNVYxMrf1bIKn3pC+1TexFcFAfTWJoIFKZaeLl3
         k7SE89JKTy4RdDQ355MjI51vV5m4wlDFzqyNTxgRq+vhJDNntyqoiR3avhdcQ+8H8Mxm
         rAzIOUMvH1Ux4hfkDZi7Aem/r5nBm0rK+xiPuwHLFLVj4lXa4ArHXayJuApLQwHh+9So
         LiPcD5dnrsI1GcOqOoDOVVUI/m/K30gMO57E+Iz0kMxdwwys8gkh7JKzyKWsfh+qfkbX
         MXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kMcSN7EDR5pkPvVWu02zCDgJ8As0247Z64kS+l1KD5M=;
        b=iMfDY/JReKAw7ZazZf9sT3rZ9F1UCHsjIoy2SVJv0TUSjfkF/w/5oe2W9dgDNQQQzm
         4Y+a7MGzGfeRtU+TBeVnC5RsTfuy0DOd1dFDXCVfwXHD2MkVNbsaNRMRuKV9dHuLt8C+
         /U8bzeV+UrhH72qlWa1F5kiDK1bMtv90YXeEiKlZn3ucdtXFsqgsHCUhP1lAuP10kPzN
         5R+x/WQdNylnlr2I4tR8w27OJCw7GR1ILps/rlqgLc9xQMyHcNjGjRW+7kIZ1zWHv8B0
         z94cfAJlGdyyK6+KhRwFHmHTwqeG4vTRTuHimNplzLI3mRWwcMp5Ern0kkWmjEI2OSJD
         hodg==
X-Gm-Message-State: AOAM5325aLdLlxCL2CL12uKb3R9hIys238z4M5q6Q0xNAsph7ZpZcLM7
        kKhtpu/swHjbGQ7sSM6V3nrYEQ==
X-Google-Smtp-Source: ABdhPJxkI335EQRG2FWMLzTQnx7fbpqCA4w8gWJYpX14ZbmuPVZ6TAYwi90vMQonCxqCoDq1/d/RXQ==
X-Received: by 2002:a17:902:bd8d:b0:13a:8c8:a2b2 with SMTP id q13-20020a170902bd8d00b0013a08c8a2b2mr9450872pls.89.1631311431938;
        Fri, 10 Sep 2021 15:03:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l1sm5614461pju.15.2021.09.10.15.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 15:03:51 -0700 (PDT)
Date:   Fri, 10 Sep 2021 22:03:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 V7] KVM, SEV: Add support for SEV intra host migration
Message-ID: <YTvWQ0jKqzFsxQd8@google.com>
References: <20210902181751.252227-1-pgonda@google.com>
 <20210902181751.252227-2-pgonda@google.com>
 <YTqirwnu0rOcfDCq@google.com>
 <CAMkAt6pa2aLZYa3N_jPXdx3zwAMiAUW4m2DRc4rXFC7N1EQcYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6pa2aLZYa3N_jPXdx3zwAMiAUW4m2DRc4rXFC7N1EQcYA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021, Peter Gonda wrote:
> > Do we really want to bury this under KVM_CAP?  Even KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
> > is a bit of a stretch, but at least that's a one-way "enabling", whereas this
> > migration routine should be able to handle multiple migrations, e.g. migrate A->B
> > and B->A.  Peeking at your selftest, it should be fairly easy to add in this edge
> > case.
> >
> > This is probably a Paolo question, I've no idea if there's a desire to expand
> > KVM_CAP versus adding a new ioctl().
> 
> Thanks for the review Sean. I put this under KVM_CAP as you suggested
> following the idea of svm_vm_copy_asid_from. Paolo or anyone else have
> thoughts here? It doesn't really matter to me.

Ah, sorry :-/  I obviously don't have a strong preference either.

> > > +Architectures: x86 SEV enabled
> > > +Type: vm
> > > +Parameters: args[0] is the fd of the source vm
> > > +Returns: 0 on success
> >
> > It'd be helpful to provide a brief description of the error cases.  Looks like
> > -EINVAL is the only possible error?
> >
> > > +This capability enables userspace to migrate the encryption context
> >
> > I would prefer to scope this beyond "encryption context".  Even for SEV, it
> > copies more than just the "context", which was an abstraction of SEV's ASID,
> > e.g. this also hands off the set of encrypted memory regions.  Looking toward
> > the future, if TDX wants to support this it's going to need to hand over a ton
> > of stuff, e.g. S-EPT tables.
> >
> > Not sure on a name, maybe MIGRATE_PROTECTED_VM_FROM?
> 
> Protected VM sounds reasonable. I was using 'context' here to mean all
> metadata related to a CoCo VM as with the
> KVM_CAP_VM_COPY_ENC_CONTEXT_FROM. Is it worth diverging naming here?

Yes, as they are two similar but slightly different things, IMO we want to diverge
so that it's obvious they operate on different data.
