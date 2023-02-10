Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8F7691681
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 03:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjBJCHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 21:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjBJCHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 21:07:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F786E9AC
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 18:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675994866; x=1707530866;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rBzLFptAPqZgfyUJn4A48/Oiw54h6xMdCD4XXgNTFBY=;
  b=OPMpX1E/Fu4Y+OGksOs04r4UBFH+LWhWQ9unY7J2/AOZaLRM1MFGHHVn
   vDLr2hgssB9JcpLkjHrLMoYh0Sxs0EzY6+9j/6um0/FC/CsCoSuzGbgqB
   L3YQoq4KzMKQ41HyviIDA9mOURQTN+GkJg7pjtaZnIO2zSkPNdAX8qxlP
   hthvYp2OKxlDnPrJLUtef0TVtpKy19FYY+Hdtaf5eRSWZKyGEmyEaEvbh
   8WXDa8YpvEphlUMPQatTvMKGM0PBqa9VTciYUSYZXmojJuUy1GgCHcVcA
   CqF4M4dLZFoRlwh6NMEj/xhGoZtfKvGS6yEcGDebSxYfTfWZKiR9PKlFX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="318328664"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="318328664"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 18:07:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="669829342"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="669829342"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 09 Feb 2023 18:07:43 -0800
Message-ID: <abbb29911d4517d87c0694db8d51b7935fd977bd.camel@linux.intel.com>
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        yu.c.zhang@linux.intel.com, yuan.yao@linux.intel.com,
        jingqi.liu@intel.com, weijiang.yang@intel.com,
        isaku.yamahata@intel.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Date:   Fri, 10 Feb 2023 10:07:42 +0800
In-Reply-To: <Y+UtDxPqIEeZ0sYH@google.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <Y+SPjkY87zzFqHLj@gao-cwp>
         <5884e0cb15f7f904728fa31bb571218aec31087c.camel@linux.intel.com>
         <Y+UtDxPqIEeZ0sYH@google.com>
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

On Thu, 2023-02-09 at 17:27 +0000, Sean Christopherson wrote:
> On Thu, Feb 09, 2023, Robert Hoo wrote:
> > On Thu, 2023-02-09 at 14:15 +0800, Chao Gao wrote:
> > > On Thu, Feb 09, 2023 at 10:40:13AM +0800, Robert Hoo wrote:
> > > Please add a kvm-unit-test or kselftest for LAM, particularly for
> > > operations (e.g., canonical check for supervisor pointers, toggle
> > > CR4.LAM_SUP) which aren't covered by the test in Kirill's series.
> > 
> > OK, I can explore for kvm-unit-test in separate patch set.
> 
> Please make tests your top priority.  Without tests, I am not going
> to spend any
> time reviewing this series, or any other hardware enabling
> series[*].  I don't
> expect KVM specific tests for everything, i.e. it's ok to to rely
> things like
> running VMs that utilize LAM and/or running LAM selftests in the
> guest, but I do
> want a reasonably thorough explanation of how all the test pieces fit
> together to
> validate KVM's implementation.

Sure, and ack on unit test is part of development work.

This patch set had always been unit tested before sent out, i.e.
"running LAM selftests in guest" on both ept=Y/N.

CR4.LAM_SUP, as Chao pointed out, could not be covered by kselftest, I
may explore it in kvm-unit-test.
Or, would you mind that separate CR4.LAM_SUP enabling in another patch
set?
> 
> [*] https://lore.kernel.org/all/Y+Uq0JOEmmdI0YwA@google.com

