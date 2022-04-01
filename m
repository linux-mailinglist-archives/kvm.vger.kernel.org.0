Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A764EFB9C
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 22:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352386AbiDAUaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 16:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352619AbiDAUaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 16:30:39 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D133F7E;
        Fri,  1 Apr 2022 13:28:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id jx9so3366668pjb.5;
        Fri, 01 Apr 2022 13:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dExYZrdHPlls47MxXxfZSIjzNDru/M5ang2+PAimp/w=;
        b=jjyYnOTLvbIBA2cJ7gM0y6sox/naZnvK5wxDc2Q2NnEVL1+DwFgIVIPTR9tzh3WEro
         AOQX/EKCiqoAk3hdlF4cImjUk+L3HRfGMlaD1BWcODiJcNDzT2QPuN7tlTqvj+TeiYI2
         oaYsn2XHAuFTDcpwROBF7ikHSL+OMwFg9VzEiWu+ryT3Xm1DuPsSHIe+2ub8FWVrp9nB
         UnHILleqr+4zwJUEw2DcJyFGqQrUgDDgyiM7I6mSZt3kaTCNqK5b6dBFEtNfk071f8X/
         mLNNL5rBDDgQm3mxV4MXf6ZAFCFqe4jnn2SkpPYicuIp291s7iUBixnyzynu1P25A9s7
         6fMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dExYZrdHPlls47MxXxfZSIjzNDru/M5ang2+PAimp/w=;
        b=JdB7jkimJsA8m4F7vE63vvZkFTp1FSsmgn5PEz531oTpLoFKVjfjOvtOWWF4ZUvNW7
         f81pGk3y1w9mqERswWAIIuhl+qj829zSf7Dxqt8zKxspwojdNY9KzXucMsxQa8wGVcsT
         LmOtyNoIdlUyJ98XqSTCzamaA/aSln2gl2LcUWUePATOVX5xApEtudysmfl1w48FeCHz
         6guUE3cURzNYGGll1OG220FsGW8Wr0Y3TeewlnmpsdEgDszCauuAFDG6jZ7e3lCuiFSx
         Sg3/1Xf93eDgysHCB0ZmFPmWTjRbsuVaQtlC/+hWr28wYJb+AA4Gg6VV/bMpU8K1F3NR
         dVSQ==
X-Gm-Message-State: AOAM530uvCRM3Qt1k8pk5XTZIUDtNzh4AWQ0awA2fuOnGtRAhpiAWzwu
        HnuCA/XnmwnCdFgVQCpiKXM=
X-Google-Smtp-Source: ABdhPJxTyGe79Ncev5YyMB/T95ery9qtEGhFLSlh3CHmnD+rL/A3lJqQuANxRUEHywC81l4bDT1ppw==
X-Received: by 2002:a17:903:3091:b0:153:9dcf:de71 with SMTP id u17-20020a170903309100b001539dcfde71mr11885918plc.7.1648844928926;
        Fri, 01 Apr 2022 13:28:48 -0700 (PDT)
Received: from localhost (c-107-3-154-88.hsd1.ca.comcast.net. [107.3.154.88])
        by smtp.gmail.com with ESMTPSA id ip1-20020a17090b314100b001c7b10fe359sm14732424pjb.5.2022.04.01.13.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:28:48 -0700 (PDT)
Date:   Fri, 1 Apr 2022 13:28:47 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 038/104] KVM: x86/mmu: Allow per-VM override of
 the TDP max page level
Message-ID: <20220401202847.GA560021@private.email.ne.jp>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <5cc4b1c90d929b7f4f9829a42c0b63b52af0c1ed.1646422845.git.isaku.yamahata@intel.com>
 <c6fb151ced1675d1c93aa18ad8c57c2ffc4e9fcb.camel@intel.com>
 <YkcHZo3i+rki+9lK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkcHZo3i+rki+9lK@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022 at 02:08:38PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Apr 01, 2022, Kai Huang wrote:
> > On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > In the existing x86 KVM MMU code, there is already max_level member in
> > > struct kvm_page_fault with KVM_MAX_HUGEPAGE_LEVEL initial value.  The KVM
> > > page fault handler denies page size larger than max_level.
> > > 
> > > Add per-VM member to indicate the allowed maximum page size with
> > > KVM_MAX_HUGEPAGE_LEVEL as default value and initialize max_level in struct
> > > kvm_page_fault with it.
> > > 
> > > For the guest TD, the set per-VM value for allows maximum page size to 4K
> > > page size.  Then only allowed page size is 4K.  It means large page is
> > > disabled.
> > 
> > Do not support large page for TD is the reason that you want this change, but
> > not the result.  Please refine a little bit.
> 
> Not supporting huge pages was fine for the PoC, but I'd prefer not to merge TDX
> without support for huge pages.  Has any work been put into enabling huge pages?
> If so, what's the technical blocker?  If not...

I wanted to get feedback on the approach (always set SPTE to REMOVED_SPTE,
callback, set the SPTE to the final value instead of relying atomic update SPTE)
before going further for large page.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
