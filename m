Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615DF6B52A7
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjCJVSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjCJVSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:18:39 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033C61151E9;
        Fri, 10 Mar 2023 13:18:36 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id x11so6958475pln.12;
        Fri, 10 Mar 2023 13:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678483116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bEFx68ojOonn9WPKLLuoIf8ro5nNotU8XXW2u2NT0Kc=;
        b=fRCSYzzc1B1boyDLc3sTM++doUhVrH+KRKklRKnBMJCLMDpRyo/OBstDr1i9xqL7eq
         T4qJjYm17k/oGqSfMj03Aaz8H7u2yY4I69WtbeE/gnegN5QbctJzL5L+f0eInCuuatfY
         Jb/x76dzDQjy9wU1IOU1YU93xnvUncRfAK6vijUUmkohDoOizJ/ZJNhmgRmrWGkr/DMP
         7n5QJclZdw4h3A5eagYAFSKy109L3YA6qRDexWhJwvDIhwWZLIHIi5qxT6kSBxSVlzn0
         uzOOmti9yffdySfpgm53S+zZeEBZo2fjzjSB51Zvhcz563/NExDAKfYByS+FeQEQZPRF
         VEnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678483116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEFx68ojOonn9WPKLLuoIf8ro5nNotU8XXW2u2NT0Kc=;
        b=PKP4/T6XfHZ1g4nNu4Bc2RC27HiJfWR9ouIcjMQN/S7cP8efgRJwp/sZSJC3G/apoU
         ymDkdR67sXfYDzFqb/Ot1cusS18gDNdt2KlFd1It4gspr4Bh48wvT6QMTerhCqZtulxU
         HAc0cfkbtxtmbDmMcnV3SLizySnIaDpGulmqvtuCUe4h3HqJ//Zvk/OByAB8AMW+uG3l
         BoDEtZ/fMgCGanHLVgtEaYoRNaGH6dLkpsMlYuYps9fvHKyro8sxGPSGAoti1mhTz164
         IPlr6Q2h7gNa7QXZo8yhXPlKr72LkoB3DyBi9so+3lozbinMyX9+E9Kvr6xK66fgenT4
         YJiA==
X-Gm-Message-State: AO0yUKUq4ibkl5aipQViCCM+r4mCqeZcSvGTWI7vk4KdUnP1mtzCHQvJ
        +ylQ34r7QGLgGdG11MnuOSg=
X-Google-Smtp-Source: AK7set/jDbcYkXh9aBocDwybievqJSOme71MrldxXyJhFEo9Srxg4dEerbfjSwPSmrXfY9qh94n7VQ==
X-Received: by 2002:a17:903:283:b0:19e:b9f8:1fca with SMTP id j3-20020a170903028300b0019eb9f81fcamr22559486plr.10.1678483115566;
        Fri, 10 Mar 2023 13:18:35 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id lh5-20020a170903290500b001992e74d055sm456054plb.12.2023.03.10.13.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:18:34 -0800 (PST)
Date:   Fri, 10 Mar 2023 13:18:32 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v12 050/106] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Message-ID: <20230310211832.GA3719990@ls.amr.corp.intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
 <93ef8e57cb80e8e0268c91758968a1950de4b5f0.1677484918.git.isaku.yamahata@intel.com>
 <02b38016-f8b3-724a-cf8d-36b343ebb9b6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <02b38016-f8b3-724a-cf8d-36b343ebb9b6@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 09, 2023 at 05:03:13PM +0800,
Chenyi Qiang <chenyi.qiang@intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 8f191177bfe9..f532f5c352f3 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -5,6 +5,7 @@
> >  
> >  #include "capabilities.h"
> >  #include "x86_ops.h"
> > +#include "common.h"
> >  #include "tdx.h"
> >  #include "vmx.h"
> >  #include "x86.h"
> > @@ -345,6 +346,22 @@ int tdx_vm_init(struct kvm *kvm)
> >  	return 0;
> >  }
> >  
> > +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +{
> > +	/* TDX private GPA is always WB. */
> > +	if (kvm_gfn_private(vcpu->kvm, gfn)) {
> 
> kvm_gfn_private() only drops shared bit instead of checking if gfn is
> private of shared. It should be !(gfn & shared mask) as mentioned in
> your v11 series :)

Oops. Will fix it. thanks for catching it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
