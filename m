Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D0F660F21
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 14:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjAGNdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Jan 2023 08:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbjAGNdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Jan 2023 08:33:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3F45F918
        for <kvm@vger.kernel.org>; Sat,  7 Jan 2023 05:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673098373; x=1704634373;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rL+llN07I2w/F6T6RfqdINXTMk0ndz0blG3NgqxTBb0=;
  b=Radv4KWdjxajA45erOAcinrFl/4jyEzwrSPXFg403BtbipuBTKzkKm9O
   LqMnrECTNzvyRQiNF/CY84U5jW4gQts9qigA6UAu3fLgVjbhZH4rmhh6y
   9+ZPqPE81BzTvSkV3/1iZJm1l+uPL5WUguWFcgXPwxgyeldy30iTexX+I
   YJMyPtgly9nwvK3XIkoLFLOSRB6HiW3w8R57PLjyutF07+KTjYjngO4Jw
   2Ns1pDftbfOCl9Qs/fZ9uw+E4pYI4azVa8TgLdPqUzTc1PzKyvI38cqom
   0UMmMFMFfEhhnYLfaqYUMRARfl4J9AFJf7bLUlOLfrXlGfpMH9yWIfCo5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="310429940"
X-IronPort-AV: E=Sophos;i="5.96,308,1665471600"; 
   d="scan'208";a="310429940"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2023 05:32:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="688575939"
X-IronPort-AV: E=Sophos;i="5.96,308,1665471600"; 
   d="scan'208";a="688575939"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2023 05:32:51 -0800
Message-ID: <5f2f0a44fbb1a2eab36183dfc2fcaf53e1109793.camel@linux.intel.com>
Subject: Re: [PATCH v3 2/9] KVM: x86: Add CR4.LAM_SUP in guest owned bits
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Date:   Sat, 07 Jan 2023 21:32:50 +0800
In-Reply-To: <Y7i+/3KbqUto76AR@google.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-3-robert.hu@linux.intel.com>
         <Y7i+/3KbqUto76AR@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-07 at 00:38 +0000, Sean Christopherson wrote:
> On Fri, Dec 09, 2022, Robert Hoo wrote:
> > If LAM enabled, CR4.LAM_SUP is owned by guest; otherwise, reserved.
> 
> Why is it passed through to the guest?

I think no need to intercept guest's control over CR4.LAM_SUP, which
controls LAM appliance to supervisor mode address.

Same pass-through happens to CR3.LAM_U{48, 57} when EPT is effective.

