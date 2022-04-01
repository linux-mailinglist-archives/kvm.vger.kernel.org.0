Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F444EE5EF
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 04:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243981AbiDACPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 22:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243955AbiDACPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 22:15:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4863BA67;
        Thu, 31 Mar 2022 19:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648779212; x=1680315212;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cbc+NbdBXMFjQ6S0uqFsxm3h2/TeIJaRHelS0Ywburs=;
  b=f/lzI4IIAuU7nRSBAEDlmh45+1i5tbMG94sdY0/7cBQLHrwjwu56BUKW
   CZDUtPpnX/b4GOX7llAi3TLW8nGWu+EyF0ZDNBOR9+LF4uUxiTuIY7eXS
   IRDrKdc4vHCtj/UJj4IsqVh3rotWksHyrt/TpJM2SqaCbXnltJ0+tnaj0
   28OKId1ivAqc0l9vo87zDAUsFMn/+xTRH6gDnpaMmzizL7C7QOstGJA8F
   18QAXtEIJ2hG1jVCVxkK5AqJr9qGkX4+sHv1gZZX5mlY09NgE+YW4J7ZM
   5EjgJRUMeqcVV6QHuDH8/YSSy5wLD7QbsfKzBRwfrUhBADwiQqxqH0OtK
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="257602917"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="257602917"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 19:13:31 -0700
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="521026646"
Received: from tswork-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.39])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 19:13:29 -0700
Message-ID: <9e01bc014df60e215ba17432c06b6854f6dae3f8.camel@intel.com>
Subject: Re: [RFC PATCH v5 032/104] KVM: x86/mmu: introduce config for
 PRIVATE KVM MMU
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 01 Apr 2022 15:13:27 +1300
In-Reply-To: <20220401015130.GE2084469@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <770235e7fed04229b81c334e2477374374cea901.1646422845.git.isaku.yamahata@intel.com>
         <55fa888b31bae80bf72cbdbdf6f27401ea4ccc5c.camel@intel.com>
         <20220401015130.GE2084469@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-31 at 18:51 -0700, Isaku Yamahata wrote:
> On Fri, Apr 01, 2022 at 12:23:28AM +1300,
> Kai Huang <kai.huang@intel.com> wrote:
> 
> > On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > To Keep the case of non TDX intact, introduce a new config option for
> > > private KVM MMU support.  At the moment, this is synonym for
> > > CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The new flag make it clear
> > > that the config is only for x86 KVM MMU.
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/kvm/Kconfig | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > > index 2b1548da00eb..2db590845927 100644
> > > --- a/arch/x86/kvm/Kconfig
> > > +++ b/arch/x86/kvm/Kconfig
> > > @@ -136,4 +136,8 @@ config KVM_MMU_AUDIT
> > >  config KVM_EXTERNAL_WRITE_TRACKING
> > >  	bool
> > >  
> > > +config KVM_MMU_PRIVATE
> > > +	def_bool y
> > > +	depends on INTEL_TDX_HOST && KVM_INTEL
> > > +
> > >  endif # VIRTUALIZATION
> > 
> > I am really not sure why need this.  Roughly looking at MMU related patches this
> > new config option is hardly used.  You have many code changes related to
> > handling private/shared but they are not under this config option.
> 
> I don't want to use CONFIG_INTEL_TDX_HOST in KVM MMU code.  I think the change
> to KVM MMU should be a sort of independent from TDX.  But it seems failed based
> on your feedback.

Why do you need to use any config?  As I said majority of your changes to MMU
are not under any config.  But I'll leave this to maintainer/reviewers. 

-- 
Thanks,
-Kai


