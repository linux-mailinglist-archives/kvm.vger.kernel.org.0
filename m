Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D7B73E66F
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 19:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjFZR3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 13:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjFZR3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 13:29:34 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B2F10EA
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:29:28 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b7e94912daso7590705ad.3
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687800568; x=1690392568;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2ct11vHRwehXFTDCKgPuaspoQemHAghzffDXTsXaHGs=;
        b=4FDi1kdF+q6KGFuA0hPu4KVq2WdtRSrLmQGn3OQFwO7qICMHmTruZZ1WAnMnd5l2G9
         rU1M6zbv0rOxB3bfPVDKU01Q0ke1/bnlwaM5jQB8Hu5Uy3EZezzAiMqa5mcV1h8RJsax
         RfX21ljovOSL0QSULi5EkseeFIBJC7PoFhAx6whRTrraYNqoJs/8CS8dL4tqNQL5h/0s
         wCTMvvBq1oZaoNUKx+Dwny1cdPGLh5X7MmzM3xUg01dHo15PNKueHQIF1tYmWP1AsRqt
         vrkQ7ICwdYjATjaeeLQaHx7pFn6KCI7HcEddkXeiEDJ0QHMRhL/4NKeTjc8kPWiMU/3r
         KKJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687800568; x=1690392568;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ct11vHRwehXFTDCKgPuaspoQemHAghzffDXTsXaHGs=;
        b=Bo1xhUTck5xvNKoSdgZZQqAAfboQZ6Dov51PWLKMpPt9O3HtQqubjiW+nqEMRk9bKL
         M5kGR55DrDBoH7XVRTNIarAEhigS+qIWmoh/mzgV+xqqhM5B70tFTxtPFbZODH20nN9O
         r+R3WbWGS6T/cSmkh2Z8wy40+XYfXxFDPOZTMtyY7CyPJipunJme+K+iS+C8b7tygGlk
         X2mz8PzANYjt10auZB52j9di9HtnDtGljvYi/xHn2l3P6/2/KNbUGJbdeRdutTQ+cotX
         YVsofvmcEkupnB17VNOdEFRjDkYoqVEvAzCnDKsU1GzkzxeaxN15gNoV2QaHy6Kmvd3i
         hPxw==
X-Gm-Message-State: AC+VfDyVbSM+GX2590+xlR0rqa/H1ibdVRf5HEyoVA/Px+IyNPInSeXq
        edi29lGlfu4Qcqd7P+dqzHOrww==
X-Google-Smtp-Source: ACHHUZ7HU7VnHwOEZY6bB6Ogv+qkgxxpVR6z7UekLjVJsVQekjbW6SN0ZfMj2et3qrhWEEFm+oYwIQ==
X-Received: by 2002:a17:902:d2ca:b0:1b6:6bac:d976 with SMTP id n10-20020a170902d2ca00b001b66bacd976mr5097126plc.48.1687800567987;
        Mon, 26 Jun 2023 10:29:27 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id t15-20020a170902b20f00b001b05e96d86bsm4482445plr.162.2023.06.26.10.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 10:29:27 -0700 (PDT)
Date:   Mon, 26 Jun 2023 17:29:23 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "bgardon@google.com" <bgardon@google.com>
Subject: Re: [PATCH 3/6] KVM: Documentation: Add the missing ptep in
 kvm_mmu_page
Message-ID: <ZJnK83RTE/Y/nXcc@google.com>
References: <20230618000856.1714902-1-mizhang@google.com>
 <20230618000856.1714902-4-mizhang@google.com>
 <3daf290f63364d9e5968a3716f1ade5e464de483.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3daf290f63364d9e5968a3716f1ade5e464de483.camel@intel.com>
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

On Thu, Jun 22, 2023, Huang, Kai wrote:
> On Sun, 2023-06-18 at 00:08 +0000, Mingwei Zhang wrote:
> > Add the missing ptep in kvm_mmu_page description. ptep is used when TDP MMU
> > is enabled and it shares the storage with parent_ptes. Update the doc to
> > help readers to get up-to-date info.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  Documentation/virt/kvm/x86/mmu.rst | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > index 149dd3cba48f..36bfe0fe02bb 100644
> > --- a/Documentation/virt/kvm/x86/mmu.rst
> > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > @@ -236,6 +236,10 @@ Shadow pages contain the following information:
> >      parent_ptes points at this single spte, otherwise, there exists multiple
> >      sptes pointing at this page and (parent_ptes & ~0x1) points at a data
> >      structure with a list of parent sptes.
> > +  ptep:
> > +    Pointer to the parent spte when TDP MMU is enabled. 
> > 
> 
> IMHO "parent spte" alone _may_ be confusing.  I think it's better to explicitly
> mention "pointing to this page" similar to the "parent_ptes" above.

Sure. I can change the style to be consistent with the descriptions of
'parent_ptes'.

> 
> Also, I think "when TDP MMU is enabled" isn't strictly true, depending on what
> does "when TDP MMU is enabled mean".  E.g., when tdp_mmu_enabled module
> parameter is true, we can still have a nested EPT shadow page from L2 which
> won't use this either IIUC.
> 
hmm, "when TDP MMU is enabled" should be "when used by TDP MMU". You are
right since when TDP MMU is used for L1, we may still have shadow MMUs
for L2s. I modify the description.

> > In TDP MMU, each
> > +    shadow page will have at most one parent. Note that this field is a
> > +    union with parent_ptes.
> 
> Also, perhaps "have at most one parent" can be more precise: only root page has
> no parent, while other non-root pages always have one parent SPTE pointing to
> each of them.

Will do in next version.
