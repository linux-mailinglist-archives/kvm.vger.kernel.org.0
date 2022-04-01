Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FD44EFBDF
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 22:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352644AbiDAUzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 16:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352672AbiDAUzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 16:55:17 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5F012AE9
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 13:53:24 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gp15-20020a17090adf0f00b001c7cd11b0b3so6271244pjb.3
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 13:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mHLh8My82O30ijWT2CaqlkU7mxd2+At9ryY0q+QdE1E=;
        b=B762xOIZU8w1otSUFbNgZa11LhxJXQ0WaaMSTXleOWdrxn9gvmtla0RQjvL8i2vAph
         05dEOmTrgqdnXdXmb4/X1eLRb+j3UVksXXBWnwFrSD+azG3dmUJ8HtkR+PF6xYH0wbYh
         ZKzgNGnZn7qmAoSsHUNTVN6J890SI4yH+W52bdgg4iz8C5KdTyDnG5FFfyBUFu03yeFm
         bWFAznFpm9+cNnp9LbaGOuqs4nqkBBeCnvNA+J5WoHmwb/mmsVG70dUNydI9xg0ESfCX
         Fs2i1a3fyyVU5Aq61YQtzTvmctv7NE7VTByO9kaU/ai11XFZyxfpgqgJA5l8pQ3MK96d
         csmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mHLh8My82O30ijWT2CaqlkU7mxd2+At9ryY0q+QdE1E=;
        b=1f6jW4d+PNnZM05ZYdxdmVA0V1nQbUpwQpMuroVdd2x/TdiShNPXpa8A+8YUGdjgX4
         8ZgA745jwuCtNP4agwhMsR49d6Gjs39njGwgVy33Vf17Z25AgHdOwQGfDoUoUckdjhc2
         Pf1t14TSZFNLdWrpDVPJdGhfrz/FxjESckDVlWBXFCXfK7pD/Ye5ertm0T38Iainyz6m
         3Ynd7lApvObmk6YNJk6V3CEUN0EVL/XsQgaqvzRd8UkHn50Zn9LbQ5piOE+54tJb1+TZ
         DHCwnZfQWA6OzMo2NWfDvYvqAYW2WGRSDqDMskyj8chAXc06/ZRck6nXZbV+0XuTmQtA
         gESA==
X-Gm-Message-State: AOAM5324F6LoIEwfu8hvEHexobshZyItfV74j63lRUtOjd6hX99LzZWO
        e0ACZmtLViG/G6T6rR/FrmWudQ==
X-Google-Smtp-Source: ABdhPJxbwfXUbZ2I2sySCUv3f4On2pEXDAIDArTPvZ8iTqJzAysD28T2Sr6cmNOepDZp2fEQ9rbaKg==
X-Received: by 2002:a17:90b:4b02:b0:1c7:1bc3:690b with SMTP id lx2-20020a17090b4b0200b001c71bc3690bmr13920857pjb.174.1648846403298;
        Fri, 01 Apr 2022 13:53:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm4182824pfc.98.2022.04.01.13.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:53:22 -0700 (PDT)
Date:   Fri, 1 Apr 2022 20:53:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 038/104] KVM: x86/mmu: Allow per-VM override of
 the TDP max page level
Message-ID: <YkdmP5BW4d9WF0u3@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <5cc4b1c90d929b7f4f9829a42c0b63b52af0c1ed.1646422845.git.isaku.yamahata@intel.com>
 <c6fb151ced1675d1c93aa18ad8c57c2ffc4e9fcb.camel@intel.com>
 <YkcHZo3i+rki+9lK@google.com>
 <20220401202847.GA560021@private.email.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401202847.GA560021@private.email.ne.jp>
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

On Fri, Apr 01, 2022, Isaku Yamahata wrote:
> On Fri, Apr 01, 2022 at 02:08:38PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Fri, Apr 01, 2022, Kai Huang wrote:
> > > On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > 
> > > > In the existing x86 KVM MMU code, there is already max_level member in
> > > > struct kvm_page_fault with KVM_MAX_HUGEPAGE_LEVEL initial value.  The KVM
> > > > page fault handler denies page size larger than max_level.
> > > > 
> > > > Add per-VM member to indicate the allowed maximum page size with
> > > > KVM_MAX_HUGEPAGE_LEVEL as default value and initialize max_level in struct
> > > > kvm_page_fault with it.
> > > > 
> > > > For the guest TD, the set per-VM value for allows maximum page size to 4K
> > > > page size.  Then only allowed page size is 4K.  It means large page is
> > > > disabled.
> > > 
> > > Do not support large page for TD is the reason that you want this change, but
> > > not the result.  Please refine a little bit.
> > 
> > Not supporting huge pages was fine for the PoC, but I'd prefer not to merge TDX
> > without support for huge pages.  Has any work been put into enabling huge pages?
> > If so, what's the technical blocker?  If not...
> 
> I wanted to get feedback on the approach (always set SPTE to REMOVED_SPTE,
> callback, set the SPTE to the final value instead of relying atomic update SPTE)
> before going further for large page.

Pretty please with a cherry on top, send an email calling out which areas and
patches you'd like "immediate" feedback on.  Putting that information in the cover
letter would have been extremely helpful.  I realize it's hard to balance providing
context for folks who don't know TDX with "instructions" for reviewers, but one of
the most helpful things you can do for reviewers is to make it explicitly clear
what _your_ expectations and wants are, _why_ you posted the series.   Usually that
information is implied, i.e. you want your patches merged, but that's obviously not
the case here.
