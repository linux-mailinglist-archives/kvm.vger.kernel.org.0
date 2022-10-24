Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243C160B585
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 20:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiJXSav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 14:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiJXSaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 14:30:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B5EEACAC
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 10:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666631448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CuC35aE9FfHuspeUd2kBk1u2OekO/kcB+ox/G4yPZC4=;
        b=GPbUG5BIMPkgfkczDvXcvF1XSQN/vYj2TRgwbXO2fbaG7CCfAPPoFYwwFkAOIxNqjD5pvZ
        2Q3OKj7UFj0xJ9Qu43tLPdX+PdYYsBW+899Dcdq9x7NY0X+uu14DhAwOJYXdXiZtMTBI03
        dKf9QIUxelyU4p9iDamg4BySJqNVsuc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-PPk2SqgGPgS-dzEJoKrKrA-1; Mon, 24 Oct 2022 08:46:12 -0400
X-MC-Unique: PPk2SqgGPgS-dzEJoKrKrA-1
Received: by mail-qt1-f199.google.com with SMTP id e24-20020ac84918000000b0039878b3c676so6938312qtq.6
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CuC35aE9FfHuspeUd2kBk1u2OekO/kcB+ox/G4yPZC4=;
        b=NtzJH8qq5hQWmrVauE2C3aboUn6K9kybnsG+HyyplYorhnqaeOG6EewOPxzwtpvmIW
         QIfrg3RHLi2q4XCmr8/oPzKSu85t7YE9H/ct9ylXY4vrFVuuzBt1lRy4vwKTYrs4+LEe
         WuveNzleeeARZCuLYJeGAstqZNgXRNfOkl9K8bpPU083Z0/RQspyWr98fvkZMshx5O+f
         Q/BIcr7YjesN6TDdYFw0WASZz+ZAY19VC11TTH02GTivVaSlbeiF+5+w3abYhmhINwhr
         voDg35ksmiJloooP2Z/OSqaBZYceTJWt1aK0MDd0RNdaHgC7M6u/F/cLfRwZdvF4NyE0
         6yzw==
X-Gm-Message-State: ACrzQf3Egr1kt98+0sJ3WrVRPf+iAoPSusGxayMYb9ra1hIPlJKr0cKp
        xLio0cqRC4izoNmNiPfFENWnvIXeJL7f2V9deaeG9IFnHkmq0ypgEQKbscS4HbCHD18Jpz4ke4u
        zl/TPvBPEtnb4
X-Received: by 2002:a37:557:0:b0:6ee:790e:d1d1 with SMTP id 84-20020a370557000000b006ee790ed1d1mr22848855qkf.118.1666615571237;
        Mon, 24 Oct 2022 05:46:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7pATUhIw9SoYTZh1di4Z72eDS/tKeQ/FCcNxUbvaSM+L7lqktPpJsR7Dg5UbrDBCyIeJkZpQ==
X-Received: by 2002:a37:557:0:b0:6ee:790e:d1d1 with SMTP id 84-20020a370557000000b006ee790ed1d1mr22848841qkf.118.1666615571002;
        Mon, 24 Oct 2022 05:46:11 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id r8-20020a05620a298800b006be8713f742sm15466019qkp.38.2022.10.24.05.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:46:10 -0700 (PDT)
Message-ID: <56dd4f6794339700551bbbd5fbcd3491cba1eeeb.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 15/16] svm: introduce svm_vcpu
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Oct 2022 15:46:08 +0300
In-Reply-To: <Y1GbQbJxEAGqIP93@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-16-mlevitsk@redhat.com>
         <Y1GbQbJxEAGqIP93@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 19:02 +0000, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > This adds minimum amout of code to support tests that
> > run SVM on more that one vCPU.
> 
> s/that/than
> 
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  lib/x86/svm_lib.c |   9 +
> >  lib/x86/svm_lib.h |  10 +
> >  x86/svm.c         |  37 ++-
> >  x86/svm.h         |   5 +-
> >  x86/svm_npt.c     |  44 ++--
> >  x86/svm_tests.c   | 615 +++++++++++++++++++++++-----------------------
> >  6 files changed, 362 insertions(+), 358 deletions(-)
> > 
> > diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
> > index 2b067c65..1152c497 100644
> > --- a/lib/x86/svm_lib.c
> > +++ b/lib/x86/svm_lib.c
> > @@ -157,3 +157,12 @@ void vmcb_ident(struct vmcb *vmcb)
> >                 ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
> >         }
> >  }
> > +
> > +void svm_vcpu_init(struct svm_vcpu *vcpu)
> > +{
> > +       vcpu->vmcb = alloc_page();
> > +       vmcb_ident(vcpu->vmcb);
> > +       memset(&vcpu->regs, 0, sizeof(vcpu->regs));
> > +       vcpu->stack = alloc_pages(4) + (PAGE_SIZE << 4);
> > +       vcpu->vmcb->save.rsp = (ulong)(vcpu->stack);
> > +}
> > diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> > index 59db26de..c6957dba 100644
> > --- a/lib/x86/svm_lib.h
> > +++ b/lib/x86/svm_lib.h
> > @@ -89,6 +89,16 @@ struct svm_extra_regs
> >      u64 r15;
> >  };
> >  
> > +
> > +struct svm_vcpu
> > +{
> > +       struct vmcb *vmcb;
> > +       struct svm_extra_regs regs;
> > +       void *stack;
> > +};
> > +
> > +void svm_vcpu_init(struct svm_vcpu *vcpu);
> > +
> >  #define SWAP_GPRS(reg) \
> >                 "xchg %%rcx, 0x08(%%" reg ")\n\t"       \
> >                 "xchg %%rdx, 0x10(%%" reg ")\n\t"       \
> > diff --git a/x86/svm.c b/x86/svm.c
> > index 9484a6d1..7aa3ebd2 100644
> > --- a/x86/svm.c
> > +++ b/x86/svm.c
> > @@ -16,7 +16,7 @@
> >  #include "apic.h"
> >  #include "svm_lib.h"
> >  
> > -struct vmcb *vmcb;
> > +struct svm_vcpu vcpu0;
> 
> It's not strictly vCPU0, e.g. svm_init_intercept_test() deliberately runs on
> vCPU2, presumably to avoid running on the BSP?
> 
> Since this is churning a lot of code anyways, why not clean this all up and have
> run_svm_tests() dynamically allocate state instead of relying on global data?

Makes sense.

Best regards,
	Maxim Levitsky

> 


