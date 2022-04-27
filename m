Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BAB510CF9
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 02:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356286AbiD0AEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 20:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiD0AEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 20:04:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCFE177731;
        Tue, 26 Apr 2022 17:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651017690; x=1682553690;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yJVAQLGQpmSEwTIQy0c+wdcVPv3sKrYh2NRxvL5xBC0=;
  b=lph9hf2Nld+3oexIUm65IbGXk8OTlYnnQ8k05vx6lB5wQEEZvtaYdCIZ
   YbVYTJ6Cp/Kx2MhWbyT25BNZYE7XRpVQVVHuhzUbuXsn4QfM8QDFScnXb
   ocpyz5OLP6O7sH9RUZBtji255taXEz6UCt2VyAHQzm4f+Z/EKCQE3li5C
   hwgVnlzUi4o15LqQ75ys9RJXTYMFpBXShCX7ZS3Xb10rq04kZxcQpK6fF
   4vh/ae8aSFmPS9IUbqear23i/+UJC/bzJ+Ww1g8ga3vvJ795S4sGvCLNx
   wwQQe8wydB796eZ8LAEDa7WrREbwi832bZO1ROpKNStmYmhIgTdUQBqDA
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="265283244"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="265283244"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:01:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="564824694"
Received: from ssaride-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.221])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:01:27 -0700
Message-ID: <98af78402861b1982607c5fd14b0c89403c042a6.camel@intel.com>
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
Date:   Wed, 27 Apr 2022 12:01:25 +1200
In-Reply-To: <104a6959-3bd4-1e75-5e3d-5dc3ef025ed0@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <b9f4d4afd244d685182ce9ab5ffdd0bf245be6e2.1649219184.git.kai.huang@intel.com>
         <104a6959-3bd4-1e75-5e3d-5dc3ef025ed0@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 13:56 -0700, Dave Hansen wrote:
> On 4/5/22 21:49, Kai Huang wrote:
> > The P-SEAMLDR (persistent SEAM loader) is the first software module that
> > runs in SEAM VMX root, responsible for loading and updating the TDX
> > module.  Both the P-SEAMLDR and the TDX module are expected to be loaded
> > before host kernel boots.
> 
> Why bother with the P-SEAMLDR here at all?  The kernel isn't loading the
> TDX module in this series.  Why not just call into the TDX module directly?

It's not absolutely needed in this series.  I choose to detect P-SEAMLDR because
detecting it can also detect the TDX module, and eventually we will need to
support P-SEAMLDR because the TDX module runtime update uses P-SEAMLDR's
SEAMCALL to do that.

Also, even for this series, detecting the P-SEAMLDR allows us to provide the P-
SEAMLDR information to user at a basic level in dmesg:

[..] tdx: P-SEAMLDR: version 0x0, vendor_id: 0x8086, build_date: 20211209,
build_num 160, major 1, minor 0

This may be useful to users, but it's not a hard requirement for this series.


-- 
Thanks,
-Kai


