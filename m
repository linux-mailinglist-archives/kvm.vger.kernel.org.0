Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A9C4ED85A
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 13:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbiCaLZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 07:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiCaLZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 07:25:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF1260F6;
        Thu, 31 Mar 2022 04:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648725821; x=1680261821;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mS6zbhaYlg/QLdlCSwj4lOoyZGKeWBXdfcvpQAxVnVw=;
  b=SgSmocZcMQZ6rCeu1GpDRINs1YjGaNQyRCMtA8Lbq7Y3Nx9aTnADQEIh
   WQRCLzb93DrdKloWWEedDQ3C/AVgEqo9GPrchZC0TuLi0zLFMewJBmg/G
   5PWmRIM6Md1WlMbOuG1W65kwaAu1yyIuxODQOhmtInjdhDczZmIUPEd/+
   t9RiNfD8D9dP13kCLzTgPuFPi5ZJheTqHTrKe532G/BbEMkoSeaFtQ2Ow
   JwGkdLDtKcRa5mXnM7761lf3WaJ420uw7xzk8faz6jiATQSz7sNWQJ8sE
   l+ASlT0Vk7hN98X4EaXDS+oZ1B5axTiZoi8bx5G6uPubM03y5c0gVWsKx
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="258632162"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="258632162"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 04:23:32 -0700
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="640096005"
Received: from fpaolini-mobl2.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.53.114])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 04:23:30 -0700
Message-ID: <55fa888b31bae80bf72cbdbdf6f27401ea4ccc5c.camel@intel.com>
Subject: Re: [RFC PATCH v5 032/104] KVM: x86/mmu: introduce config for
 PRIVATE KVM MMU
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 01 Apr 2022 00:23:28 +1300
In-Reply-To: <770235e7fed04229b81c334e2477374374cea901.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <770235e7fed04229b81c334e2477374374cea901.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> To Keep the case of non TDX intact, introduce a new config option for
> private KVM MMU support.  At the moment, this is synonym for
> CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The new flag make it clear
> that the config is only for x86 KVM MMU.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2b1548da00eb..2db590845927 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -136,4 +136,8 @@ config KVM_MMU_AUDIT
>  config KVM_EXTERNAL_WRITE_TRACKING
>  	bool
>  
> +config KVM_MMU_PRIVATE
> +	def_bool y
> +	depends on INTEL_TDX_HOST && KVM_INTEL
> +
>  endif # VIRTUALIZATION

I am really not sure why need this.  Roughly looking at MMU related patches this
new config option is hardly used.  You have many code changes related to
handling private/shared but they are not under this config option.

-- 
Thanks,
-Kai


