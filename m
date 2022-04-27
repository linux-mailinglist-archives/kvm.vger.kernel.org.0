Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751F651248F
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 23:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237533AbiD0Vd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 17:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiD0Vd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 17:33:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A372827152;
        Wed, 27 Apr 2022 14:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651095044; x=1682631044;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9AnR0+i4WyZuMptJB4sGh0+ILBAmTrqUC5l0VYBK5DQ=;
  b=OLVFTDseiEs8H9fUvj40yBhty5zkBeBjcMUOSNhl1W0gPhmb9MTZbD1f
   OMdcrmwDD5XnR7YgrJ0AqK0c9SmSY5cIg/0Q+tTaWOdloNoXekPimZZi/
   3by0OvjfJdfZUhrA1KfOb+7/v0YKYihas94uEd/erZiWGqepC+59pR4tt
   gWCLDpFYRp6cMI0ngTm0rzmQdnl2LB1BiC6nOhbULKyC3sZyigiy3H+vC
   Iy4flTapKyFfpn38d0kjYdxTzbrbpYxg+6dGB7BLbcOlByPxdeBjBC6V7
   wRWNo6/VQT8qX7+sD45PN86w1aIJyKdT7Ulb5fp/d+5ZEv/d29nTzbif9
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="246634544"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="246634544"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 14:30:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="705733567"
Received: from rrnambia-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 14:30:41 -0700
Message-ID: <68484e168226037c3a25b6fb983b052b26ab3ec1.camel@intel.com>
Subject: Re: [PATCH v3 05/21] x86/virt/tdx: Detect P-SEAMLDR and TDX module
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Thu, 28 Apr 2022 09:30:39 +1200
In-Reply-To: <49cc6848-47ae-9c25-f479-c5aed8c892df@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <b9f4d4afd244d685182ce9ab5ffdd0bf245be6e2.1649219184.git.kai.huang@intel.com>
         <104a6959-3bd4-1e75-5e3d-5dc3ef025ed0@intel.com>
         <98af78402861b1982607c5fd14b0c89403c042a6.camel@intel.com>
         <49cc6848-47ae-9c25-f479-c5aed8c892df@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 07:24 -0700, Dave Hansen wrote:
> On 4/26/22 17:01, Kai Huang wrote:
> > On Tue, 2022-04-26 at 13:56 -0700, Dave Hansen wrote:
> > > On 4/5/22 21:49, Kai Huang wrote:
> > > > The P-SEAMLDR (persistent SEAM loader) is the first software module that
> > > > runs in SEAM VMX root, responsible for loading and updating the TDX
> > > > module.  Both the P-SEAMLDR and the TDX module are expected to be loaded
> > > > before host kernel boots.
> > > 
> > > Why bother with the P-SEAMLDR here at all?  The kernel isn't loading the
> > > TDX module in this series.  Why not just call into the TDX module directly?
> > 
> > It's not absolutely needed in this series.  I choose to detect P-SEAMLDR because
> > detecting it can also detect the TDX module, and eventually we will need to
> > support P-SEAMLDR because the TDX module runtime update uses P-SEAMLDR's
> > SEAMCALL to do that.
> > 
> > Also, even for this series, detecting the P-SEAMLDR allows us to provide the P-
> > SEAMLDR information to user at a basic level in dmesg:
> > 
> > [..] tdx: P-SEAMLDR: version 0x0, vendor_id: 0x8086, build_date: 20211209,
> > build_num 160, major 1, minor 0
> > 
> > This may be useful to users, but it's not a hard requirement for this series.
> 
> We've had a lot of problems in general with this code trying to do too
> much at once.  I thought we agreed that this was going to only contain
> the minimum code to make TDX functional.  It seems to be creeping to
> grow bigger and bigger.
> 
> Am I remembering this wrong?

OK. I'll remove the P-SEAMLDR related code.

-- 
Thanks,
-Kai


