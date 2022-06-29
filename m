Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58ABF55FCEA
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 12:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiF2KOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 06:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiF2KOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 06:14:01 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB7027CC8;
        Wed, 29 Jun 2022 03:14:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id r1so13652506plo.10;
        Wed, 29 Jun 2022 03:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6ssz5ul1QxHBEW/Ftglcn8GTDr/5c5SXlVf5jD8qbcI=;
        b=ZYguFwcPfSq5u/hXIoSPbB1Ol/IScrgaK3FjTkLwDq0acReFAxkJeMo4JrHaifPiGj
         Bz3WuHNNoLatTdI71hec5BhL6ZgnvCef1xDf9rTVAVeI6fcDl7cdbt6uAjyl8wudTaVu
         EmYHL6lL9+Z9oRupRrVQ59IB3HOwY3NpgMymkj06yj9LhCbF0smqNs0XEI9LfCxBdYwJ
         ycjbCm1MB8/pqVoHouPsn0f1SzBjG6a+PJhnkABM8WQ2JZx7+KU0v3uevO+pNWLYQoN6
         Q2tZYIDSIjb0uGE1naGei0Wkxz51EDgHeaqJWfnW86eQAnUzfxyufa2G5PDXK+IA7zaC
         qH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6ssz5ul1QxHBEW/Ftglcn8GTDr/5c5SXlVf5jD8qbcI=;
        b=ILtyQoWE2bprn071/hYxDWN2K6lBQI30Y8pMsnljVcWuyxrLvQ9bbuoo8iAyaDG8/z
         MDeD2QAF7rFHHNrzeP0hpSS+UgDM+rf4trg/TcMFEEJF2btu8pSdOBMNquakgoEWBZcO
         iLvNse5us4k5IQc4WsqmPsy4FpWAgIdDW/BZ7enA4Z4wlo9ekZ6uvj4hLN2XDH+XZaFX
         jgPw+ssEl0hBEwoBhwsgS+LKaYGmnnweGcGOieFfmvsvaW2Ia1Px+CHFyESnLQkv9hyB
         1y7BEteAIvsjKv/6Bz+cB3xbSouP0bRPPnYY4c5GCjBrcIy3NaI/DyVfQG/I69jw4Juu
         S3+Q==
X-Gm-Message-State: AJIora9/fb0o05t/yMQHIdrS94UsCwMAlupBoDCDHKoXDQKRx3QPBbmr
        t1yn/5+NRd93EIDaBUprdv0=
X-Google-Smtp-Source: AGRyM1uOV3bmitBLA+3fOBVJSOzewdGKIGu4RWQco3/TjeOfMdPvDvjvcLUFquhpOBzcbmUVghMSrQ==
X-Received: by 2002:a17:903:2cb:b0:14f:4fb6:2fb0 with SMTP id s11-20020a17090302cb00b0014f4fb62fb0mr9698257plk.172.1656497639008;
        Wed, 29 Jun 2022 03:13:59 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id h24-20020a635318000000b0040dffa7e3d7sm5460901pgb.16.2022.06.29.03.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 03:13:57 -0700 (PDT)
Date:   Wed, 29 Jun 2022 03:13:56 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v6 090/104] KVM: TDX: Handle TDX PV CPUID hypercall
Message-ID: <20220629101356.GA882746@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <98939c0ec83a109c8f49045e82096d6cdd5dafa3.1651774251.git.isaku.yamahata@intel.com>
 <CAAhR5DHPk2no0PVFX6P1NnZdwtVccjmdn4RLg4wKSmfpjD6Qkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhR5DHPk2no0PVFX6P1NnZdwtVccjmdn4RLg4wKSmfpjD6Qkg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 11:15:00AM -0700,
Sagi Shahar <sagis@google.com> wrote:

> On Thu, May 5, 2022 at 11:16 AM <isaku.yamahata@intel.com> wrote:
> >
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Wire up TDX PV CPUID hypercall to the KVM backend function.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 9c712f661a7c..c7cdfee397ec 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -946,12 +946,34 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
> >         return 1;
> >  }
> >
> > +static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
> > +{
> > +       u32 eax, ebx, ecx, edx;
> > +
> > +       /* EAX and ECX for cpuid is stored in R12 and R13. */
> > +       eax = tdvmcall_a0_read(vcpu);
> > +       ecx = tdvmcall_a1_read(vcpu);
> > +
> > +       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
> 
> According to the GHCI spec section 3.6
> (TDG.VP.VMCALL<Instruction.CPUID>) we should return
> VMCALL_INVALID_OPERAND if an invalid CPUID is requested.
> 
> kvm_cpuid already returns false in this case so we should use that
> return value to set the tdvmcall return code in case of invalid leaf.

Based on CPUID instruction, cpuid results in #UD when lock prefix is used or
earlier CPU that doesn't support cpuid instruction.
So I'm not sure what CPUID input result in INVALID_OPERAND error.
Does the following make sense for you?

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1347,7 +1347,7 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
        eax = tdvmcall_a0_read(vcpu);
        ecx = tdvmcall_a1_read(vcpu);

-       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
+       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);

        tdvmcall_a0_write(vcpu, eax);
        tdvmcall_a1_write(vcpu, ebx);

thanks,

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
