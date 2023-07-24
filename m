Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0032A75FFC5
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 21:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjGXT0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 15:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjGXT0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 15:26:10 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A6118E
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 12:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690226769; x=1721762769;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=F4fqfOC2K0DgoX/wdCrljTq72N/F/zwCGwtFM8JR110=;
  b=e6TUuwlGY8CofesXVC8JjzlcmfBgtFOPXZOyGia4AuiYPmt1Dsg+Oiqf
   rTkC/AVUV6QrV3C6JVrQBEaLThahGl4XKLlsZpnlCzujMVroTqFN79ZNn
   MZdx076f8bulCPMKtr2A2SgqnhW5oiBQVCFfxccPHjK1lPwT6VS/i/9Lm
   5V3fcYv5/iPEBLrhLI0EsvtZ1CbyAyWj/J0Vw+6WMPIlawvsOtxCN9qim
   90EQ+Bw377pMaju7jguEJdEUVwkAmqp1rmtuXIkUyP+eyeBghoK4fbdEG
   bZ4EDV1urSfiV3A0Bk1ZlW3zYS9jlXdh3HYt6mCDtQNFLFz/Ma98f3bf5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="398442583"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="398442583"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 12:26:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="729039171"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="729039171"
Received: from krkamatg-mobl1.amr.corp.intel.com (HELO desk) ([10.209.8.115])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 12:26:08 -0700
Date:   Mon, 24 Jul 2023 12:25:40 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
Message-ID: <20230724192540.xp4qulsufqmjwki3@desk>
References: <ZLiUrP9ZFMr/Wf4/@chao-email>
 <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
 <ZLjqVszO4AMx9F7T@chao-email>
 <CALMp9eSw9g0oRh7rT=Nd5aTwiu_zMz21tRrZG5D_QEfTn1h=HQ@mail.gmail.com>
 <ZLn9hgQy77x0hLil@chao-email>
 <20230721190114.xznm7xfnuxciufa3@desk>
 <CALMp9eTNM5VZzpSR6zbkjude6kxgBcOriWDoSkjanMmBtksKYw@mail.gmail.com>
 <20230721205404.kqxj3pspexjl6qai@desk>
 <CALMp9eSqe09RgwTQUe5Qi15E+Q+wm1QhO5P5-ryvF9OzV9gR0w@mail.gmail.com>
 <20230721222904.y3nabprqdk3aa555@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230721222904.y3nabprqdk3aa555@desk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 03:29:04PM -0700, Pawan Gupta wrote:
> On Fri, Jul 21, 2023 at 03:18:12PM -0700, Jim Mattson wrote:
> > On Fri, Jul 21, 2023 at 1:54 PM Pawan Gupta
> > <pawan.kumar.gupta@linux.intel.com> wrote:
> > >
> > > On Fri, Jul 21, 2023 at 12:18:36PM -0700, Jim Mattson wrote:
> > > > > Please note that clearing STIBP bit on one thread does not disable STIBP
> > > > > protection if the sibling has it set:
> > > > >
> > > > >   Setting bit 1 (STIBP) of the IA32_SPEC_CTRL MSR on a logical processor
> > > > >   prevents the predicted targets of indirect branches on any logical
> > > > >   processor of that core from being controlled by software that executes
> > > > >   (or executed previously) on another logical processor of the same core
> > > > >   [1].
> > > >
> > > > I stand corrected. For completeness, then, is it true now and
> > > > forevermore that passing IA32_SPEC_CTRL through to the guest for write
> > > > can in no way compromise code running on the sibling thread?
> > >
> > > As IA32_SPEC_CTRL is a thread-scope MSR, a malicious guest would be able
> > > to turn off the mitigation on its own thread only. Looking at the
> > > current controls in this MSR, I don't see how a malicious guest can
> > > compromise code running on sibling thread.
> > 
> > Does this imply that where core-shared resources are affected (as with
> > STIBP), the mitigation is enabled whenever at least one thread
> > requests it?
> 
> Let me check with CPU architects.

For the controls present in IA32_SPEC_CTRL MSR, if atleast one of the
thread has the mitigation enabled, current CPUs do not disable core-wide
mitigations when core-shared resources are affected.

This will be the guiding principle for future mitigation controls that
may be added to IA32_SPEC_CTRL MSR.
