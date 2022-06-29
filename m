Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7860855FD17
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 12:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiF2KYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 06:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiF2KYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 06:24:04 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84E127B0E;
        Wed, 29 Jun 2022 03:24:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 23so14887494pgc.8;
        Wed, 29 Jun 2022 03:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=trw3LNoiFKTtUvjXEV/QGd2ZkU2tmLP2qFOADoks6lE=;
        b=M9OWPVf47nuV8h5P3dcKIGBCbEt/qE7nMTjJlxWZpUbV0XCcziQYxQ3qi2lTLQFM8j
         Jr0rHXzEsFFQqXH19FRNPsYru0tUjypAOKGFWVoH9LMxNiaZNHz3M0dF7EEStnB5TQYl
         5diKfYn8sQGP8iULjg1i36LiLFSWWLhVtn3AlpklLwIRT2APk2oQRbKYoIQht9++c2Wt
         jUeJJCMOc40ZumsfrEVbXq6d9y/E8GpHCkkopzbiqlVPKUZG+FOYUnk4iWL62b+ZR3wg
         6k6L5+NRwx9L3cJ57I0H8B8yXikePaOa45phaGhpCXo4LPPd4KmqikLDoS+KbxCCEvub
         Gg8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=trw3LNoiFKTtUvjXEV/QGd2ZkU2tmLP2qFOADoks6lE=;
        b=1EH+7Ukv3zYkXPRryQUrSRWAqkZ9X8DgQcYWA/Bdzq4dA4mq6HJWo90atfBqsp6069
         nG9SwYuWLG1QWigdGiHAeNBu0AZPwEHfdyYvQSiwh4hg4LsBWaP9cHSnfnVargTGqSdl
         6vwQU3CzTeqbapWWm7FXhiKuyxOMFydbMinnAmQJqYG0qLeZfzBHYIspD7g3Up5GDr1/
         0btK6/pFsYRsoQ+yY+nMegBFFkgrQlwZlO6VJ5FaqKRcO3PbADHTtv5Zg14lJdJ1tHcS
         pjWpxlriMdfmtjKr7j80CzghxcVQRrYRS9yc9osgVsEiu7vFTjtqLHw5+rg+aV16o2ZS
         Ro2A==
X-Gm-Message-State: AJIora/W3QESEfh7L/55Hlbe37ZjJhZRXCMuSARa/GKXFAElCPZTKNrw
        nbVSFKuGc1TRyhkRVJ6LaTXP2O6BDAc=
X-Google-Smtp-Source: AGRyM1tAkwBPmvH8pvdlzCxAnOewXeBxwn3kFhaN7DxdqJVmdMoP2AJ0cPh+1ShRcMbQmh678lLo8Q==
X-Received: by 2002:a63:be41:0:b0:40c:b4a8:dee9 with SMTP id g1-20020a63be41000000b0040cb4a8dee9mr2366496pgo.107.1656498243314;
        Wed, 29 Jun 2022 03:24:03 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id c5-20020a17090abf0500b001ef0fed7046sm1705903pjs.15.2022.06.29.03.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 03:24:02 -0700 (PDT)
Date:   Wed, 29 Jun 2022 03:24:01 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v6 095/104] KVM: TDX: Handle TDX PV rdmsr/wrmsr
 hypercall
Message-ID: <20220629102401.GC882746@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <9a45667060dd2f8634bf1ecba23b89567c7e46e7.1651774251.git.isaku.yamahata@intel.com>
 <CAAhR5DE8FmzACXja1znjdR04HS_kOsJ4awWsU5AHm3__oqOx8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhR5DE8FmzACXja1znjdR04HS_kOsJ4awWsU5AHm3__oqOx8g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 10, 2022 at 02:04:49PM -0700,
Sagi Shahar <sagis@google.com> wrote:

> On Thu, May 5, 2022 at 11:16 AM <isaku.yamahata@intel.com> wrote:
> >
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Wire up TDX PV rdmsr/wrmsr hypercall to the KVM backend function.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 37 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index f46825843a8b..1518a8c310d6 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1169,6 +1169,39 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
> >         return 1;
> >  }
> >
> > +static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
> > +{
> > +       u32 index = tdvmcall_a0_read(vcpu);
> > +       u64 data;
> > +
> > +       if (kvm_get_msr(vcpu, index, &data)) {
> 
> kvm_get_msr and kvm_set_msr used to check the MSR permissions using
> kvm_msr_allowed but that behaviour changed in "KVM: x86: Only do MSR
> filtering when access MSR by rdmsr/wrmsr".
> 
> Now kvm_get_msr and kvm_set_msr skip these checks and will allow
> access regardless of the permissions in the msr_filter.
> 
> These should be changed to kvm_get_msr_with_filter and
> kvm_set_msr_with_filter or something similar that checks permissions
> for MSR access.

Thanks for pointing it out. I fixed it as adding kvm_msr_allowed()
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
