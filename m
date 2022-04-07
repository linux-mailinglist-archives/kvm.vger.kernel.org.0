Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699F74F6F6D
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiDGBJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiDGBJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:09:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C2417FD13;
        Wed,  6 Apr 2022 18:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649293671; x=1680829671;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hH9j1C11zEDzX1YDHVkD28XC3kD9po5unUNqNLEfqd0=;
  b=C1RJUatMl69uDGBq7FGEf5vrGYPVhoZMG3Sr2Ph2FH9frSRqrcPH1p2s
   0KEiDEb/tgwco7bQWenMu6TObSavxJMPfT11eHkzI8lXB7eBJNcC1UrC6
   IKHppaucLWbqrCgRA9aFS9NBLJEwc/WTvE5N63fHNajJBK0rtN4CTZwi3
   1ejngg8J4D/hwucFTIZhMbx7WRt05IhXHGS7I1Qbm8zH2Shj3xaUurZom
   mBNKNRsi+uttjt9GcaJc8kspuCS42NPBqspE8k9hO6WbDtpkm56tseSR+
   r3wQu/brYNKz1hue3REgi/r6uDG/+Ys++dLCNaZlBp9K7uEOs80dfeGbK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="261375314"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="261375314"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:07:43 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="588601314"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:07:40 -0700
Message-ID: <bf3e61bcc2096e72a02f56b70524928e6c3cfa3e.camel@intel.com>
Subject: Re: [RFC PATCH v5 026/104] KVM: TDX: x86: Add vm ioctl to get TDX
 systemwide parameters
From:   Kai Huang <kai.huang@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 13:07:38 +1200
In-Reply-To: <17981a2e-03e3-81df-0654-5ccb29f43546@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <5ff08ce32be458581afe59caa05d813d0e4a1ef0.1646422845.git.isaku.yamahata@intel.com>
         <586be87a-4f81-ea43-2078-a6004b4aba08@redhat.com>
         <17981a2e-03e3-81df-0654-5ccb29f43546@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-06 at 09:54 +0800, Xiaoyao Li wrote:
> On 4/5/2022 8:52 PM, Paolo Bonzini wrote:
> > On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > > Implement a VM-scoped subcomment to get system-wide parameters.  Although
> > > this is system-wide parameters not per-VM, this subcomand is VM-scoped
> > > because
> > > - Device model needs TDX system-wide parameters after creating KVM VM.
> > > - This subcommands requires to initialize TDX module.  For lazy
> > >    initialization of the TDX module, vm-scope ioctl is better.
> > 
> > Since there was agreement to install the TDX module on load, please 
> > place this ioctl on the /dev/kvm file descriptor.
> > 
> > At least for SEV, there were cases where the system-wide parameters are 
> > needed outside KVM, so it's better to avoid requiring a VM file descriptor.
> 
> I don't have strong preference on KVM-scope ioctl or VM-scope.
> 
> Initially, we made it KVM-scope and change it to VM-scope in this 
> version. Yes, it returns the info from TDX module, which doesn't vary 
> per VM. However, what if we want to return different capabilities 
> (software controlled capabilities) per VM? 
> 

In this case, you don't return different capabilities, instead, you return the
same capabilities but control the capabilities on per-VM basis.

> Part of the TDX capabilities 
> serves like get_supported_cpuid, making it KVM wide lacks the 
> flexibility to return differentiated capabilities for different TDs.
> 
> 
> > Thanks,
> > 
> > Paolo
> > 
> 

