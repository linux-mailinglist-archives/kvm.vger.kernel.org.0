Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE1B40733D
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 00:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhIJWJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 18:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbhIJWJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 18:09:10 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E782FC061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 15:07:57 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id k13so6925935lfv.2
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 15:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9FSHaiKmU7r6eoknlZw4Tmerh8r1h9JIhLnGLeFKRfg=;
        b=G/P3vZlt/dEQxiZPFdpGAUmPZFfpKBRNSi6J7BHvbh7Wpf29XFdgEE7pYRwYZxHm/+
         ej+ISKZAvYhKlABn3wz0dL2AT955Fn2yW8XhaToLWPJH5RJAEe/HblVaKwd0zGTxesoP
         7Kc1mxMO5PjX9Le0u5y5GR4QqWr+SHRUfqtSdoKQefOGy+OnCT1yORE4H1p1zkPkWKCq
         C4ivajCwzljDJsLjxR8A3/no8bYwkdsQU5PHiRxb+XozbKqGvc7A78WyIQ7t19oeQChQ
         X/ZYmNE4qc64ilpe1dovx67R34maYKVCri60eMrC4aBBKOxMj1vrRByA51A14J+DBPCA
         UM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9FSHaiKmU7r6eoknlZw4Tmerh8r1h9JIhLnGLeFKRfg=;
        b=xjyvzbDrF0DJu25+GLGl9YUguwrryKBOJCvBxkI/Gn8b5a3y6Ft+SeimaIMykkEMfk
         QnoEt/SmtAc/Wm6OA0u3PHwNvcyhYGJR3PN/JHJOzQC0b9VP5OstFdQlOL1jLoLpuiZr
         Tlo89T6mwOsjbsz+w0JYJVNujKjQFDyG0BmjgOaWbo3XQqPbfJeIfMjQbNgjp6MsO45l
         ZiNDEQU7c1xByeQspe8LZSDTtpr3R0YHxSxlcFVcBo+YexvXCWrp7X4UowyArt8Ne7Ur
         9r6d8ETbQcmSazSLVL2itNWGyqhuC6MKlqzM9obgrNe4YicTQunnjqWb0ePyVj4/YKvb
         lEUQ==
X-Gm-Message-State: AOAM530mFBOX3cTeOsqmqOCQX1M2js+ybtKyLDBUvnq3uOKpzGx7j5hl
        POzmoSBB4R2modHbu8WsT5hnm9qj71ub+Oq2RPDa76Aq3x0=
X-Google-Smtp-Source: ABdhPJzSS4obJp8anc1AEKS/GILaJPVjjiT0Ovzqz96afJodgS2JYkvKtSUm3yy6jqG93KBLyvFo7Mml4eP6Hfd5Buo=
X-Received: by 2002:a05:6512:22cc:: with SMTP id g12mr5564550lfu.456.1631311676036;
 Fri, 10 Sep 2021 15:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210902181751.252227-1-pgonda@google.com> <20210902181751.252227-2-pgonda@google.com>
 <YTqirwnu0rOcfDCq@google.com> <CAMkAt6pa2aLZYa3N_jPXdx3zwAMiAUW4m2DRc4rXFC7N1EQcYA@mail.gmail.com>
 <YTvWQ0jKqzFsxQd8@google.com>
In-Reply-To: <YTvWQ0jKqzFsxQd8@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 10 Sep 2021 16:07:44 -0600
Message-ID: <CAMkAt6qQkPcTz=PZfVYtx2EmoLFvpDaq6eNDx9cx6o3ZGyLCaw@mail.gmail.com>
Subject: Re: [PATCH 1/3 V7] KVM, SEV: Add support for SEV intra host migration
To:     Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021 at 4:03 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Sep 10, 2021, Peter Gonda wrote:
> > > Do we really want to bury this under KVM_CAP?  Even KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
> > > is a bit of a stretch, but at least that's a one-way "enabling", whereas this
> > > migration routine should be able to handle multiple migrations, e.g. migrate A->B
> > > and B->A.  Peeking at your selftest, it should be fairly easy to add in this edge
> > > case.
> > >
> > > This is probably a Paolo question, I've no idea if there's a desire to expand
> > > KVM_CAP versus adding a new ioctl().
> >
> > Thanks for the review Sean. I put this under KVM_CAP as you suggested
> > following the idea of svm_vm_copy_asid_from. Paolo or anyone else have
> > thoughts here? It doesn't really matter to me.
>
> Ah, sorry :-/  I obviously don't have a strong preference either.

I am going to suggest leaving it under KVM_CAP for this reason. I
don't see a great use case for A->B then B->A migrations. And if we
are going to move to dst must be not SEV or SEV-ES enabled, which I
think makes sense. Then your VM can only ever have migrated from 1
other VM since once it has it will be SEV/SEV-ES enabled. Does that
seem reasonable?

>
> > > > +Architectures: x86 SEV enabled
> > > > +Type: vm
> > > > +Parameters: args[0] is the fd of the source vm
> > > > +Returns: 0 on success
> > >
> > > It'd be helpful to provide a brief description of the error cases.  Looks like
> > > -EINVAL is the only possible error?
> > >
> > > > +This capability enables userspace to migrate the encryption context
> > >
> > > I would prefer to scope this beyond "encryption context".  Even for SEV, it
> > > copies more than just the "context", which was an abstraction of SEV's ASID,
> > > e.g. this also hands off the set of encrypted memory regions.  Looking toward
> > > the future, if TDX wants to support this it's going to need to hand over a ton
> > > of stuff, e.g. S-EPT tables.
> > >
> > > Not sure on a name, maybe MIGRATE_PROTECTED_VM_FROM?
> >
> > Protected VM sounds reasonable. I was using 'context' here to mean all
> > metadata related to a CoCo VM as with the
> > KVM_CAP_VM_COPY_ENC_CONTEXT_FROM. Is it worth diverging naming here?
>
> Yes, as they are two similar but slightly different things, IMO we want to diverge
> so that it's obvious they operate on different data.

Sounds good I'll rename.
