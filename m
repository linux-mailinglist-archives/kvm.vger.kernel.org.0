Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E549E4E3933
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 07:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237201AbiCVGw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 02:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbiCVGwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 02:52:53 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7579BF54
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 23:51:24 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id k25so19132748iok.8
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 23:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IwRVisvolBhvIbGMmgKZiBoC8eUBgxbTS282wHCffvU=;
        b=OiY+oWVkFFeaf8NEOpAHS22bD1pOceEqp217C0LFOsTMrvm9y1+jTGStCvCTRHFz9z
         tUoAYyybC3oFNsg06YuwzbuO9Jm1vCKDueBB9TtZsDm5Kls7pW9Hkl6lxT9vOgrM3Veo
         vJ4q5V6CVlVbP7lN5LACckqOYs2irm5x/gGfoXuU7Oqu9ujWjJ6d+cHoj0Sif1WMSFuT
         V2zaZFQMo+azTlct+4GySePdZ3pBKpUG38kjbt71owNqCert/u1AFAnrGLakb4pHKIT8
         REyH9j7ljCeYiix8A8nPTYiPo5gYT9d0wY2PFNQq9KmbbnHh1I+eLaOMybu2N2TNaWuZ
         Txag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IwRVisvolBhvIbGMmgKZiBoC8eUBgxbTS282wHCffvU=;
        b=6C2ZEKTsfmabdCWGeJo0g4Idaj8YjKIYBfR8JtxvNlFAjr9uOoarHkxj1mJ89x4QA3
         V0ByUHv2YG7K4rshza51595T8rOkCqnhMKiwi3tAFYEf83B0eCIcvDxrMTxWwW38SQ9k
         ZClyyrnvfhbpcWbqruEJtkokr0zZvkUwLySXSDmfyiML7F1mGlRy+DhXzgIAM5TOaWXi
         ybsa4UwzPqjODUVejUaLrkF+IAfdZYE25yf7HOJXRiSdMe7mgAXwB5DwBylrVse3nKDC
         sxYry6WrJVAK4XoTyfsE5JSFMgiklLWx3dqspE+5d9ZZNGBchIQ14yG/M5nidG9M/fOT
         m90A==
X-Gm-Message-State: AOAM533b9sQZ33EYhHyAksSUe0U1ZABuBjwbsy8fbbzB4XGeXIhPeFku
        kpI0a8nC/lPUVqCMEy2Fx5MvbWXz+UxzmJZb
X-Google-Smtp-Source: ABdhPJyn5hCzHHM/nFQuU+z/DGtpGQ2QKykFc47CuExLWcMmrrNiey8EjICe7dHXffOWlIDypbL6vQ==
X-Received: by 2002:a02:3949:0:b0:321:4529:a74e with SMTP id w9-20020a023949000000b003214529a74emr3461979jae.243.1647931883915;
        Mon, 21 Mar 2022 23:51:23 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id h12-20020a056e021b8c00b002c8196f2751sm4552515ili.52.2022.03.21.23.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 23:51:23 -0700 (PDT)
Date:   Tue, 22 Mar 2022 06:51:20 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v4 08/15] KVM: arm64: Return a value from
 check_vcpu_requests()
Message-ID: <Yjlx6JKTRbzwAE7o@google.com>
References: <20220311174001.605719-1-oupton@google.com>
 <20220311174001.605719-9-oupton@google.com>
 <CAAeT=FwmU1Ej8zc4wB15TRRH6dH9xK7621gO12ib2QjHW11=NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FwmU1Ej8zc4wB15TRRH6dH9xK7621gO12ib2QjHW11=NA@mail.gmail.com>
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

On Mon, Mar 21, 2022 at 11:21:15PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Fri, Mar 11, 2022 at 9:41 AM Oliver Upton <oupton@google.com> wrote:
> >
> > A subsequent change to KVM will introduce a vCPU request that could
> > result in an exit to userspace. Change check_vcpu_requests() to return a
> > value and document the function. Unconditionally return 1 for now.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/arm.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 7c297ddc8177..8eed0556ccaa 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -648,7 +648,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
> >         preempt_enable();
> >  }
> >
> > -static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> > +/**
> > + * check_vcpu_requests - check and handle pending vCPU requests
> > + * @vcpu:      the VCPU pointer
> > + *
> > + * Return: 1 if we should enter the guest
> > + *        0 if we should exit to userspace
> > + *        <= 0 if we should exit to userspace, where the return value indicates
> > + *        an error
> 
> Nit: Shouldn't "<= 0" be "< 0" ?

It definitely should. I'll fold this in to the next spin.

--
Thanks,
Oliver
