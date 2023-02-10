Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BA66917D5
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 06:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjBJFCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 00:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjBJFCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 00:02:23 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3AE55E43
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 21:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676005342; x=1707541342;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vzE0ZuVztaxyAIxtKmeMS+CwsWyT4OG2Bgp71IDXRAE=;
  b=URMziO3NMnQBnvhdI4cARh3jM0SQlI92bA3bOabV09shxglsYSYRnkJY
   y9wqHj9elpyyE1KC7vmDKPu+w0DYsMFi7i1LGegEmd2VvTTFEB4FhkETH
   lvnA7ctF980WtbC3WIwCEfsyUTvn0dNe+kV1KQCgkhN3aiL1YqBI0agCT
   lecc2Rv3FIN0I7+np+sn+9T49EYRIiYDTL2ywy1ZHAWXcpfkhXWFlA9mM
   hCR0V4xYMP1KFz8e0nm/NWFKNSUjg7sTrYJ6fxs1DRxnZSLjA+XB+vgKj
   +iMsT/HhSO/ZVZFWTBo3RXeciNdeYwt4IQvWP6ykD4TixhFpztNbCFxTo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="394945065"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="394945065"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 21:02:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="667930895"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="667930895"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 09 Feb 2023 21:02:18 -0800
Message-ID: <8b7155472fa91cca2eaec354a40eaba7de8d13f1.camel@linux.intel.com>
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Date:   Fri, 10 Feb 2023 13:02:17 +0800
In-Reply-To: <63c23749-f0c1-28b8-975e-a5b01d070b54@intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-2-robert.hu@linux.intel.com>
         <63c23749-f0c1-28b8-975e-a5b01d070b54@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-10 at 11:29 +0800, Yang, Weijiang wrote:
> On 2/9/2023 10:40 AM, Robert Hoo wrote:
> > Remove CR4.LAM_SUP (bit 28) from default CR4_RESERVED_BITS, while
> > reserve
> > it in __cr4_reserved_bits() by feature testing.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> 
> As Sean pointed out in[*], this Reviewed-by is for other purpose,
> please 
> remove all of
> 
> them in this series.

No. Sean meant another thing.
This reviewed-by is from Jingqi as usual.

But for this patch specific, I think I can drop Jingqi's reviewed-by,
as this patch changed fundamentally from last version.
> 
> [*] Re: [PATCH 7/7] x86/kvm: Expose LASS feature to VM guest - Sean 
> Christopherson (kernel.org) 
> <
> https://lore.kernel.org/all/Y+Uq0JOEmmdI0YwA@google.com/><https://lore.kernel.org/all/Y+Uq0JOEmmdI0YwA@google.com/
> >
> 
> [...]
> 

