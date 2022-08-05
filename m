Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A509A58AEB5
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 19:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbiHEROi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 13:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiHEROg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 13:14:36 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCA6193CA
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 10:14:35 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s206so3196950pgs.3
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 10:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ayC5Aj5ZEIbBe3heCJHiAuulFotI2NDsTl7tbcxRnjg=;
        b=AXUFX/HYWc/q9iPMEulV5W5UM3XASF/4uUQg5+JdN8ThT9AhCCNoaudUqCyXnM7NrQ
         O9kKMAYxssIfMZtqwXcQVBDFZ7phGoGIbTEu+HLQMAVmHtAm9q9dPvBb18H11vo+3Vzs
         ZCl3rYKfLfEaWfceuYiKRPOXiPqjUUfwSy2T87st4tnVrWThL/egDGC2F2jlfe9G3GP0
         jTeFJ0rzfyCyC4iLiGQHj9VXwyMZrgas4DXZlAmq1LzFgN3UoB/gHoLZ4KCrV+P+4nKz
         iHXm4R1nUUciQs3PXif2YVCjHEwvHAOu5yfSGVhrLaXLGd8bgv+d+1YeYJDFKMj/q/OS
         sLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ayC5Aj5ZEIbBe3heCJHiAuulFotI2NDsTl7tbcxRnjg=;
        b=soojNkvEFRd4WKzhtlu4/ICsceuNyghx0y81nklbwa8YRXK4cfugfnTUB54UGWJGH8
         A6OqaScPjmb8WKtj7hwTanIvH6AENXpeZDtnJ3wmiArk8B+NIwVkH4cL+Nquw9B5xxd3
         +M4MXC0mbi+atrKpC1CLsdyFwm5kTTMMiu7lBuG/GFa61SyUD8GhZ8Ev+fdFEblmp5RL
         Otbo5i2mftvFqft/UTud2ADy2/9wPPP3OOWVSV3Sua5rKqZIJI9t067H8mlT2VfsOfFG
         Jgu87Z9FBhVMJ0JKUKsmUfP7/w/pwbm6nU2dSsM97/AVAI/aG+/WsQzOWgGj2MtRXERM
         woeg==
X-Gm-Message-State: ACgBeo0HX0T2Rt5fYOm3SCEkmrbDok11JQ3CK0Sg5pKAWSzvjQxmL7k9
        aJw4OLIyOsEQk8Yik9yrc8m44Q==
X-Google-Smtp-Source: AA6agR70M1AiPuoW7FwbU16RmnzmiAIFZvG8SoG/g0WiOd69NTm7gezh28oqzu5akKUnSpMByzhrnQ==
X-Received: by 2002:a05:6a00:892:b0:52b:c986:c781 with SMTP id q18-20020a056a00089200b0052bc986c781mr7916668pfj.64.1659719675216;
        Fri, 05 Aug 2022 10:14:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h14-20020a17090a130e00b001f22647cb56sm5812707pja.27.2022.08.05.10.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 10:14:34 -0700 (PDT)
Date:   Fri, 5 Aug 2022 17:14:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Shahar, Sagi" <sagis@google.com>
Subject: Re: [RFC PATCH v6 037/104] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Message-ID: <Yu1P9jH6pDOeBWQN@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <bfa4f7415a1d059bd3a4c6d14105f2baf2d03ba6.1651774250.git.isaku.yamahata@intel.com>
 <YuxOHPpkhKnnstqw@google.com>
 <CALzav=cf_2dz8vMD+D_Xo1zBJZndJmtMBxbnYpQKP_mci1np=A@mail.gmail.com>
 <BL1PR11MB5978DB988E482B8329339881F79E9@BL1PR11MB5978.namprd11.prod.outlook.com>
 <CALzav=cJ_Bp2Vg1n=aHv4ewH0U-rDGG5Nni=0CdizG-64GtpLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cJ_Bp2Vg1n=aHv4ewH0U-rDGG5Nni=0CdizG-64GtpLA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022, David Matlack wrote:
> On Thu, Aug 4, 2022 at 5:04 PM Huang, Kai <kai.huang@intel.com> wrote:
> >
> > > > In addition to the suggestions above, I'd suggest breaking this patch
> > > > up, since it is doing multiple things:
> > > >
> > > > 1. Patch initialize shadow page tables to EMPTY_SPTE (0) and
> > > >    replace TDP MMU hard-coded 0 with EMPTY_SPTE.
> > > > 2. Patch to change FNAME(sync_page) to not assume EMPTY_SPTE is 0.
> > > > 3. Patch to set bit 63 in EMPTY_SPTE.
> > > > 4. Patch to set bit 63 in REMOVED_SPTE.
> >
> > I think 1/2 can be separate patches, but 3/4 should be done together.
> >
> > Patch 3 alone is broken as when TDP MMU zaps SPTE and replaces it with
> > REMOVED_SPTE, it loses bit 63.  This is not what we want.  We always want
> > bit 63 set if it is supposed to be  set to a non-present SPTE.
> 
> How is patch 3 alone be broken? The TDX support that depends on bit 63
> does not exist at this point in the series, i.e. setting bit 63 is
> entirely optional and only done in preparation for future patches.

Hmm, I agree with Kai on this specific point.  Will it cause functional problems?
No.  Is KVM technically broken?  IMO, yes, because the intent of the code is to
ensure bit 63 is set for all SPTEs that are not-present (and not misconfigured)
in hardware.

I 100% agree on patches doing too much, but in this particular case it's easy to
capture the above semantics in a shortlog:

  KVM: x86/mmu: Set bit 63 (EPT's SUPPRESS_VE) in all not-present SPTEs
