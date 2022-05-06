Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481AF51D3D4
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 10:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390306AbiEFJAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 05:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiEFJAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 05:00:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5175DD02;
        Fri,  6 May 2022 01:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651827418; x=1683363418;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pzSCX+ORidCZk4+V2sVaV0IkzFQzmKkYiqwgGamCDd8=;
  b=nCNPKcBAS2/SY7Sl4O0Na/GyAVqRUWVlK5933iVhMRsnJbvbK3KiBzmv
   oRU7kUA0r4kUdlkq9XR6/jJk6DzE16SnJHJFMMprzWu9BUx2UtfL6FtWa
   dY15M1ZU/Tnp4IBvaTtrskmQgqZjq0kNrCJPiaamtidRdvVI5HNqJyNcc
   zfxdpWuBPZ+Vn5yuEWlxg7Bdch9PTvMCKrQSt7tLfFhwRJ3ooPGW/R7TH
   w2fv7nkI7xVQ62W1ReVPd2iRVZNSdjsu7+CgyrLaDXn7rKFZQ/Nwxq1vg
   nuAx+xPAOaNX/Ja1VFwA+rbTPs9Irc7sja5Gm2vlPj2IsB0zX4hkmR8H4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="293608062"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="293608062"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 01:56:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="585868905"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.36]) ([10.249.169.36])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 01:56:55 -0700
Message-ID: <16632b27-7a0d-887b-c86e-9e1673840f55@intel.com>
Date:   Fri, 6 May 2022 16:56:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH v6 017/104] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <b4cfd2e1b4daf91899a95ab3e2a4e2ea1d25773c.1651774250.git.isaku.yamahata@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <b4cfd2e1b4daf91899a95ab3e2a4e2ea1d25773c.1651774250.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/2022 2:14 AM, isaku.yamahata@intel.com wrote:
> diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> index 8df7a16f7685..b4fc8182e1cf 100644
> --- a/arch/x86/virt/vmx/tdx/seamcall.S
> +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> @@ -50,3 +50,4 @@ SYM_FUNC_START(__seamcall)
>   	FRAME_END
>   	ret
>   SYM_FUNC_END(__seamcall)
> +EXPORT_SYMBOL_GPL(__seamcall)

It cannot compile, we need

#include <asm/export.h>
