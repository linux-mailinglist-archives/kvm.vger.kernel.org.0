Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858654F825C
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344396AbiDGPEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344388AbiDGPEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:04:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B02FD2
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:02:31 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so6486692pjy.5
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 08:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xEawbGCu7y1vIILENYYhWZ3wFJRgV8eFUGqPfSyynR8=;
        b=kT7UcNQE86YbVV1ncLaMb3kTbBan1KlOCH/D3jXUD7/D0gtfwONcVekSrOn56tAvwY
         NzoNtHDIcwJnSaSR8hcCkG5et9Ikuwekgq65+M8l4hNJMUFb2v3lQn8N9GvVvg3GOnXO
         EqBKpyWvDn10RTyGuD5hl/4pmjBSIq3jsij3qiing91l9We7zb4r+3ig2ekGsiU9yee9
         A80NB+vH+JkfN4VObloBwtVrPR47ap2pWplyKBdaDrs8r9vmjqXjJtNc7hco+YBo7X4H
         oKFqFqF7WudSWyFQr/7gIFKufOD6vG479hHGkt1RsKpm18fQQ24ahiQ3t36iSf9Kh4VR
         itiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xEawbGCu7y1vIILENYYhWZ3wFJRgV8eFUGqPfSyynR8=;
        b=XHctq/oiP4qTh1FToGQhY3DP0qOBPobvPg6lxUDbpN67BWGyUdzFn4VOWE3T5Mqwad
         WuyqGjxuPBMBg57i5qpywK/79EWiezFKqStCUE72IjTKMVVEy2/fJ1rraNWsRJzisc11
         5UBV0UnNxRDLg/waUYEyh+XkDWrkviTT/YAHHC4bQHBS/7EeJv2IiEiHUJSMc4lRL2jw
         RX5W/5evYPjl3jECJ1mMy9axD+FNpOZLNWPQ1REe7UGTHE1bDkIdElvuEMJm3QMO2i7s
         dszBo4qwuZVWe4XFJ+3UnLOAsrhB4U2cEY9oAyMBId7FPHYNSaWqYZr6s2S2sBWLc584
         K7gA==
X-Gm-Message-State: AOAM5315iLNeu2+GdlV57eFWVsW20bK10fXTKmK5g4wn1WXIkiujBrxi
        47H/Ly9xnYImbuPK5QN8lyxGmA==
X-Google-Smtp-Source: ABdhPJzJZHFRpw8bMz2zn7BwPC+I8W1kHd9t1Rfoz7b07w+qNdKYe2LnPWVa/5+7vDGC/sUg3lSRnA==
X-Received: by 2002:a17:90b:250f:b0:1ca:b9fa:efcd with SMTP id ns15-20020a17090b250f00b001cab9faefcdmr16486299pjb.123.1649343750979;
        Thu, 07 Apr 2022 08:02:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090a6c9000b001c993d935e7sm9487387pjj.56.2022.04.07.08.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 08:02:30 -0700 (PDT)
Date:   Thu, 7 Apr 2022 15:02:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 092/104] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <Yk79A4EdiZoVQMsV@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
 <282d4cd1-d1f7-663c-a965-af587f77ee5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282d4cd1-d1f7-663c-a965-af587f77ee5a@redhat.com>
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

On Thu, Apr 07, 2022, Paolo Bonzini wrote:
> On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> > +	bool interrupt_disabled = tdvmcall_p1_read(vcpu);
> 
> Where is R12 documented for TDG.VP.VMCALL<Instruction.HLT>?
> 
> > +		 * Virtual interrupt can arrive after TDG.VM.VMCALL<HLT> during
> > +		 * the TDX module executing.  On the other hand, KVM doesn't
> > +		 * know if vcpu was executing in the guest TD or the TDX module.
> 
> I don't understand this; why isn't it enough to check PI.ON or something
> like that as part of HLT emulation?

Ooh, I think I remember what this is.  This is for the case where the virtual
interrupt is recognized, i.e. set in vmcs.RVI, between the STI and "HLT".  KVM
doesn't have access to RVI and the interrupt is no longer in the PID (because it
was "recognized".  It doesn't get delivered in the guest because the TDCALL
completes before interrupts are enabled.

I lobbied to get this fixed in the TDX module by immediately resuming the guest
in this case, but obviously that was unsuccessful.
 
> > +		details.full = td_state_non_arch_read64(
> > +			to_tdx(vcpu), TD_VCPU_STATE_DETAILS_NON_ARCH);
> 
> TDX documentation says "the meaning of the field may change with Intel TDX
> module version", where is this field documented?  I cannot find any "other
> guest state" fields in the TDX documentation.

IMO we should put a stake in the ground and refuse to accept code that consumes
"non-architectural" state.  It's all software, having non-architectural APIs is
completely ridiculous.
