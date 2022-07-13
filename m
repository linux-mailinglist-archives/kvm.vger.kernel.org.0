Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26722573138
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 10:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiGMIfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 04:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbiGMIfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 04:35:19 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D40A58CF;
        Wed, 13 Jul 2022 01:35:18 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s27so9805389pga.13;
        Wed, 13 Jul 2022 01:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y/A0MX75zTaXhVdAEkMhemH3gBjt/Nk1zEMUdzVlPtg=;
        b=UHmjjrOXfoP7fxm9CtN+JpxL5X27TGGRa4RYkeDqUWFRwC8cO1PcDYMXSvEfshzH6I
         +6/hNL0DV51m/lzDnsJ2TLPxU0OXa3EEgXL7OMFVijxVOt4nwrVWhpXYaXsdx9BpE5rV
         sKBIhbHqLxT6qj3F55YgSPgdUpVl9VDufh3eOY4K6PslQPnbtLA/dLP+nFKVEiu0MGgU
         +VV4Va4Ul45CK5+mJCJdHO6+jef95Js/K3bRrwzhuyvQ346g0jlL4TA2xlbg9RarfCNC
         msHK3JH2/e/5jq5bmucw3+N6L64YV2WyrGHr/3/t/XKZeYJ9wiY4ixv5gkrfi5/xsWxl
         Bp0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y/A0MX75zTaXhVdAEkMhemH3gBjt/Nk1zEMUdzVlPtg=;
        b=gJVOsiXRmzwLqyz8dWVhjvoizF9HPcGWPrPCPBr8MCDYWUhvb4h95jOjN2nGO1ID4d
         LcFYA9RFCNSyacy/Q/83hHp+4/4/o2eFT91H2bfULV9eBBS8/v3bhhOV4Xn3ojZh6N+5
         iOPH7dfuQKnzfvB+xOelUlev9qit84TAS+n3xZsUgyEMoCL2Tnq5o95fjjXEUMoECABT
         UFZK1CWJRTwtaBbKzrUkCWIELj2qMSRB9xJZdeGMUIFktHVl5xvDs7rJ3CkahnnAWnFg
         65pb+DZDFchppVehfaijT28MfjRVsL9tHiA7qLsN4IYgPtntvM4rIdV66KbKXyZ+/B0s
         SoxA==
X-Gm-Message-State: AJIora+OR76LOde2mIyG3DfTlWgHL4k4/L0RY9K9Nq4yjerrcXk9uo3p
        FWpADqwrgvli7sOtXxJ6ZWaNzcmuU/w=
X-Google-Smtp-Source: AGRyM1uR3dbgTxYj0lU6KDjUpNErZuR9b4kpTGTEfToeEkm3OSJPSdu6wB53ehz3r7hDonHtBCb5sA==
X-Received: by 2002:a62:1cc8:0:b0:52a:ee9e:b735 with SMTP id c191-20020a621cc8000000b0052aee9eb735mr2205555pfc.42.1657701317502;
        Wed, 13 Jul 2022 01:35:17 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id i14-20020a170902c94e00b0016c4331e61csm6244399pla.137.2022.07.13.01.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 01:35:16 -0700 (PDT)
Date:   Wed, 13 Jul 2022 01:35:15 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 035/102] KVM: x86/mmu: Explicitly check for MMIO spte
 in fast page fault
Message-ID: <20220713083515.GQ1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <71e4c19d1dff8135792e6c5a17d3a483bc99875b.1656366338.git.isaku.yamahata@intel.com>
 <cfeb3b8b02646b073d5355495ec8842ac33aeae5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cfeb3b8b02646b073d5355495ec8842ac33aeae5.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 11:37:15PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Explicitly check for an MMIO spte in the fast page fault flow.  TDX will
> > use a not-present entry for MMIO sptes, which can be mistaken for an
> > access-tracked spte since both have SPTE_SPECIAL_MASK set.
> 
> SPTE_SPECIAL_MASK has been removed in latest KVM code.  The changelog needs
> update.

It was renamed to SPTE_TDP_AD_MASK. not removed.


> In fact, if I understand correctly, I don't think this changelog is correct:

> The existing code doesn't check is_mmio_spte() because:
> 
> 1) If MMIO caching is enabled, MMIO fault is always handled in
> handle_mmio_page_fault() before reaching here; 
>
> 2) If MMIO caching is disabled, is_shadow_present_pte() always returns false for
> MMIO spte, and is_mmio_spte() also always return false for MMIO spte, so there's
> no need check here.
> 
> "A non-present entry for MMIO spte" doesn't necessarily mean
> is_shadow_present_pte() will return true for it, and there's no explanation at
> all that for TDX guest a MMIO spte could reach here and is_shadow_present_pte()
> returns true for it.

Although it was needed, I noticed the following commit made this patch
unnecessary.  So I'll drop this patch. Kudos to Sean.

edea7c4fc215c7ee1cc98363b016ad505cbac9f7
"KVM: x86/mmu: Use a dedicated bit to track shadow/MMU-present SPTEs"

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
