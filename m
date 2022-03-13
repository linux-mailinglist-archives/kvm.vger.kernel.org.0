Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A69D4D78AA
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 00:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiCMXDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 19:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbiCMXDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 19:03:41 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD665AEC0;
        Sun, 13 Mar 2022 16:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647212553; x=1678748553;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eiRq5fMbn7RSpvxQx4eYqXcJqsy2r8h7OYF/tgMyEFA=;
  b=nOrJ/nuEidDDDo+s7OcQulHtVm2bg+GI1A8ykO5wBr4Vp8JCu6BRd04w
   ShdQ/NzmsF6eezDSAP1sTpuxwzxhVKslbwv3Ay9mR1C7w8swVDfxToiOj
   6b6nk/suKx+7nRh3HSrZWPKzPafi/kvJoYtkPC8boXYW/imeMXJ+DIxrp
   K35McCiQUUVoJT9HkfdC8T+v+8DX3fOLkIALxHAF5nAi6vYqPqmZW9Q8X
   4LUvtxGFu8CrFTrztamjgXlmV+CQekOst8F2GgA+6Nb73beCJa7wUdb5w
   aho3QfbR0Vl/1HVFeRyTjS+KL10379nT1k/JRtvAyXyx3+g096irT0vi3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="255857660"
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="255857660"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 16:02:33 -0700
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="633999176"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 16:02:31 -0700
Message-ID: <be070e537a3c47269aca8e6793b99f024c124446.camel@intel.com>
Subject: Re: [RFC PATCH v5 007/104] x86/virt/tdx: Add a helper function to
 return system wide info about TDX module
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Mon, 14 Mar 2022 12:02:29 +1300
In-Reply-To: <989deb94-0046-7f13-aa62-eee0c5db79fc@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <0a942626c76824cb225995fcb6499fea51113d43.1646422845.git.isaku.yamahata@intel.com>
         <989deb94-0046-7f13-aa62-eee0c5db79fc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-03-13 at 14:59 +0100, Paolo Bonzini wrote:
> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>
> > ---
> >   arch/x86/include/asm/tdx.h | 55 ++++++++++++++++++++++++++++++++++++++
> >   arch/x86/virt/vmx/tdx.c    | 16 +++++++++--
> >   arch/x86/virt/vmx/tdx.h    | 52 -----------------------------------
> >   3 files changed, 69 insertions(+), 54 deletions(-)
> 
> Patch looks good, but place these definitions in 
> arch/x86/include/asm/tdx.h already in Kai's series if possible.
> 
> Apart from that,
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Paolo

Does it make more sense for me to just include this patch (and couple of other
patches such as exporting information of TDX KeyIDs) to host kernel support
series?

-- 
Thanks,
-Kai
