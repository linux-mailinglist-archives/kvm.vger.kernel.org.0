Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575245017F2
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 18:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245476AbiDNPwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 11:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245645AbiDNPMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 11:12:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FE2B0A78
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 07:52:41 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so9533821pjb.2
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 07:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VCv1DBjrR+kR8Ru17MDGLWUciKdYdv1uzvwnzOqdHPk=;
        b=YmPLuDxX9JQeZXfBU0IrSRbSmP5EHYzXXqteBEfXvYfoTmcfXpqI7aWfAzynwoUKZs
         RzrbbL0w6vlBfc3eK9R/Agv5xDz0ss/H4yJROYWUD18FQz4VjxbMc2/h30OCodc7TIU6
         JWQFC+GRfNgeFGrfsnc4v6jpAei4jKZzOGky1xFSS8fEaCRz4eG8Q5r29AFiAFG0Myad
         X6JwwWuBxra6BrsEIyZqEDbHojwLopPKXkHTSWlBbcTKwqGIChVgQYSImzfUUAPTusOF
         xscF4iZir3RKk1MxmvRmEdx46MbnEXU+mhEPGL5QHQ61gVViN5Sa7eJWoYEYY3felkDR
         2SBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VCv1DBjrR+kR8Ru17MDGLWUciKdYdv1uzvwnzOqdHPk=;
        b=jePhmruRCdYuTK4DhcdxSA/uBVCoLjPEf8EuIqrxE6c4Rxj78A8O7eVMy+sMJiEit0
         wPEWAEklrX9SJCT0D1VdkLSPbGiyTQg9Rz2JLcG5NVP3E9ZUnaE82DiTfRm485yEUm18
         AoZPEYYwah/lkWzvcjHvUEwNVH9IyRwIFj2M4ofqgr/SMMeUdESr3ifROGzK5vgb0Z/N
         OTkACSi7rQRX9kfrLNMCzDw5kzuHZ5Akosbe9F5iuT/UGiwS8Ub6oLWXydWM6FgSlwaw
         dozOkTg2qwd5xRK5HuPgAfPhIfrEtUgthjZRRVgz0lMMSITnx+QMgywO5kMf7mVycDHz
         9nVQ==
X-Gm-Message-State: AOAM531PwWXvqaJ+Sh7Qa9RQZ19OBPMPECOhaSxdpjBmnobiDf9pw6u6
        N8Jit6SXX+3aI8U4VlQpzNp2UQ==
X-Google-Smtp-Source: ABdhPJziYhacBkhotKSQYbGP23a9zbaCkxbZmGj3QOSR1uBcyFUC7gRfTpS1WyPtRILk4lB4cHCmWg==
X-Received: by 2002:a17:90b:3b89:b0:1c6:56a2:1397 with SMTP id pc9-20020a17090b3b8900b001c656a21397mr4113040pjb.239.1649947960320;
        Thu, 14 Apr 2022 07:52:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w14-20020a17090a4f4e00b001cb510021ecsm6116472pjl.49.2022.04.14.07.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 07:52:38 -0700 (PDT)
Date:   Thu, 14 Apr 2022 14:52:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH V3 3/4] KVM: X86: Alloc role.pae_root shadow page
Message-ID: <Ylg1M4Bkl2MsGABZ@google.com>
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
 <20220330132152.4568-4-jiangshanlai@gmail.com>
 <YlXrshJa2Sd1WQ0P@google.com>
 <CAJhGHyD-4YFDhkxk2SQFmKe3ooqw_0wE+9u3+sZ8zOdSUfbnxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyD-4YFDhkxk2SQFmKe3ooqw_0wE+9u3+sZ8zOdSUfbnxw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022, Lai Jiangshan wrote:
> On Wed, Apr 13, 2022 at 5:14 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Mar 30, 2022, Lai Jiangshan wrote:
> > > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > >
> > > Currently pae_root is special root page, this patch adds facility to
> > > allow using kvm_mmu_get_page() to allocate pae_root shadow page.
> >
> > I don't think this will work for shadow paging.  CR3 only has to be 32-byte aligned
> > for PAE paging.  Unless I'm missing something subtle in the code, KVM will incorrectly
> > reuse a pae_root if the guest puts multiple PAE CR3s on a single page because KVM's
> > gfn calculation will drop bits 11:5.
> 
> I forgot about it.
> 
> >
> > Handling this as a one-off is probably easier.  For TDP, only 32-bit KVM with NPT
> > benefits from reusing roots, IMO and shaving a few pages in that case is not worth
> > the complexity.
> >
> 
> I liked the one-off idea yesterday and started trying it.
> 
> But things were not going as smoothly as I thought.  There are too
> many corner cases to cover.  Maybe I don't get what you envisioned.

Hmm, I believe I was thinking that each vCPU could have a pre-allocated pae_root
shadow page, i.e. keep pae_root, but make it

	struct kvm_mmu_page pae_root;

The alloc/free paths would still need special handling, but at least in theory,
all other code that expects root a shadow page will Just Work.
