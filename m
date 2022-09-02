Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AD25AB8E7
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 21:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiIBTfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIBTfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:35:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F5DD51E8
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662147348; x=1693683348;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hZWH/c+7BOnYYOn9UIijMKnvzfGH6y7LXz9UN2s/SLU=;
  b=fPcd4Zfc3sNc8X1ikGImPtQaI5S8qGFJG6Ffvu2y7saMf7nmvvYevGn8
   UM0SdkpzXJbKdKwqXmdZdl1tmzwGDvRFJEDZiXyHhJTjfMZhtYs8y/oCa
   q6AAb9QdFGsOP5cYkQLtHUapkptVE17xD9dVc6nSjAL/C3na+hVSOsx3l
   WEbWty+0qBmTTzTFJGrAis2jVmbcWJy6redqbEtoFoAcN60Yy7LsAiJnK
   gZ+rsRcgsPcESssL3zT0xGwj42MXXGgIyylKgDhzO02k63wzwuuRJ21Ll
   qR2qhFtaEGDvVyQ8rpjrbK4AJTzNpwzCxBOnsacQ3oWCmY14XrzYzPcVf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="294806292"
X-IronPort-AV: E=Sophos;i="5.93,285,1654585200"; 
   d="scan'208";a="294806292"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 12:14:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,285,1654585200"; 
   d="scan'208";a="738968095"
Received: from tjulien-mobl2.amr.corp.intel.com (HELO desk) ([10.212.29.154])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 12:14:42 -0700
Date:   Fri, 2 Sep 2022 12:14:41 -0700
From:   Pawan Gupta <pawan.kumar.gupta@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, chen.zhang@intel.com,
        kvm list <kvm@vger.kernel.org>
Subject: Re: BHB-clearing on VM-exit
Message-ID: <20220902191441.bbjfvniy5cpefg3a@desk>
References: <CALMp9eRp-cH6=trNby3EY6+ynD6F-AWiThBHiSF8_sgL2UWnkA@mail.gmail.com>
 <Yw8aK9O2C+38ShCC@gao-cwp>
 <20220901174606.x2ml5tve266or5ap@desk>
 <CALMp9eRaq_p2PusavHy8a4YEx2fQrxESdpPQ_8bySqrv61ub=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRaq_p2PusavHy8a4YEx2fQrxESdpPQ_8bySqrv61ub=Q@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 11:35:10AM -0700, Jim Mattson wrote:
> On Thu, Sep 1, 2022 at 10:46 AM Pawan Gupta <pawan.kumar.gupta@intel.com> wrote:
> >
> > On Wed, Aug 31, 2022 at 04:22:03PM +0800, Chao Gao wrote:
> > > On Tue, Aug 30, 2022 at 04:42:19PM -0700, Jim Mattson wrote:
> > > >Don't we need a software BHB-clearing sequence on VM-exit for Intel
> > > >parts that don't report IA32_ARCH_CAPABILITIES.BHI_NO? What am I
> > > >missing?
> > >
> > > I think we need the software mitigation on parts that don't support/enable
> > > BHI_DIS_S of IA32_SPEC_CTRL MSR and don't enumerate BHI_NO.
> > >
> > > Pawan, any idea?
> >
> > Intel doesn't recommend any BHI mitigation on VM exit. The guest can't
> > make risky system calls (e.g. unprivileged eBPF) in the host, so the
> > previously proposed attacks aren't viable, and in general the exposed
> > attack surface to a guest is much smaller (with no syscalls). If
> > defense-in-depth paranoia is desired, the BHB-clearing sequence could be
> > an alternative in the absence of BHI_DIS_S/BHI_NO.
> 
> Just for clarity, are you saying that it is not possible for a guest
> to use the shared BHB to mount a successful attack on the host when
> eIBRS is enabled or IBRS is applied after VM-exit?

It may be possible to use shared BHB to influence the choice of indirect
targets, but there are other requirements that needs to be satisfied
such as:
 - Finding a disclosure gadget.
 - Controlling register inputs to the gadget.
 - Injecting the disclosure gadget in the predictors before it can be
   transiently executed.
 - Finding an appropriate indirect-branch site after VM-exit, and before
   BHB is overwritten.

IFAIK, other than gadgets based on unprivileged eBPF (which is disabled
by default), previous research hasn't concluded on the exploitability of
any other gadgets. Also factors stated above makes it hard for a guest
to exploit BHI. If that changes or if defense-in-depth is desired,
BHB-clearing sequence is the appropriate thing to do.

Thanks,
Pawan
