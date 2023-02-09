Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB991690941
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 13:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjBIMsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 07:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBIMsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 07:48:51 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B50F5DC25
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 04:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675946930; x=1707482930;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8zVNOzBK640tDChMoMruhOebq1AzymWpEVD7KuvPLAs=;
  b=UgjjXE5pQ2yFQlbN07SxdFIT6hEZWknjqdCLesV4bC9Ctkn/iGzaTbWS
   DaJrsRudr1HekIpyCcJriP28BOYiQYEf8b+1oqVgfyBIZMMngNs2MWpZm
   lQbPaeLH6QiqKhhyiYGS5C5JJQGUja3rrQq6iiD34JvF0RvfxiC5XW0zC
   GvPCiULcB/H0zVfkMFNXUMEKypPqRbBOcAI0aaHjaGRcKqJ86y3JURgX9
   qdUdGkorkQPbMeeVEGA7j7sda1Vl3Hsk09QmzMgLM1DdGm9nIYxs7vA8x
   bVkZnt7Pp3sMc31xiO2Rzpr1mPvWDN2vKDY/gU+eyFvVBBat8M0hKiKlz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="313731564"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="313731564"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 04:48:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="996535713"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="996535713"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 09 Feb 2023 04:48:47 -0800
Message-ID: <766d87b11fea2e7dbb2801d2e7c8a815b5c54299.camel@linux.intel.com>
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Thu, 09 Feb 2023 20:48:46 +0800
In-Reply-To: <Y+S7ErkCpUADAn1x@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-2-robert.hu@linux.intel.com>
         <Y+S7ErkCpUADAn1x@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-02-09 at 17:21 +0800, Chao Gao wrote:
> The subject doesn't match what the patch does; intercepting 
> CR4.LAM_SUP isn't done by this patch. How about:
> 
> 	Virtualize CR4.LAM_SUP

All right, although I think this patch is all about intercepting
CR4.LAM_SUP. Additional handling on CR4 bits intercepting in
kvm/vmx_set_cr4() isn't always necessary.

> 
> and in the changelog, 

Do you mean in cover letter? or in this patch's description here?

> explain a bit why CR4.LAM_SUP isn't
> pass-thru'd and why no change to kvm/vmx_set_cr4() is needed.

OK.

Existing kvm/vmx_set_cr4() can handle CR4.LAM_SUP well, no additional
code need to be added.
If we take a look at kvm/vmx_set_cr4() body, besides the ultimate goal
of 
	vmcs_writel(CR4_READ_SHADOW, cr4);
	vmcs_writel(GUEST_CR4, hw_cr4);

other hunks are about constructing/adjust cr4/hw_cr4. Those are for the
CR4 bits that has dependency on other features/system status (e.g.
paging), while CR4.LAM_SUP doesn't.

> 
> On Thu, Feb 09, 2023 at 10:40:14AM +0800, Robert Hoo wrote:
> > Remove CR4.LAM_SUP (bit 28) from default CR4_RESERVED_BITS, while
> > reserve
> 
> s/(bit 28)//
> 
> > it in __cr4_reserved_bits() by feature testing.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>

