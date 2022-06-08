Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AE454240C
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiFHDXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 23:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiFHDWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 23:22:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB90237E9;
        Tue,  7 Jun 2022 17:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654648671; x=1686184671;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JI+L3y7RpEl5WkntEiwNcbIF+GDbW86kFBkyksKVoZg=;
  b=F/k8C79gmc3DA4kekQhROOdt8Z1ggHHEcj1Y2fnGEQAkJ8sgkfx7+0gm
   vWgnYptLpfhQ1RECdOzQz/dKRtJlaan3eeZ0qh9CFMpYvlvyESRJ43VD4
   BjN4MxXd/8SIgayyvzFZrvMqyYALiEqUO0Vyc4KutlAreBX5jf7O+59T4
   kOcpL65sFkUDzmegy66n2Jf8JOeJeSCsHKlx59IoKaBDFj3e3DxTkaKx0
   Y7HPe5C8IwPYLWA3CXtmNOICEO6Bp8Ax3BVqgXl/jct3xUcYG+0DgyVRa
   LXURaig/tX84T0EB6W24x1uYXBHP+bP/2Zk4DL45pTzObzScWFV90pXNj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="275541287"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="275541287"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 17:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="584493132"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jun 2022 17:37:48 -0700
Date:   Wed, 8 Jun 2022 08:37:48 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yuan Yao <yuan.yao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 1/1] KVM: MMU: Fix VM entry failure and OOPS for shdaow
 page table
Message-ID: <20220608003747.zge6mfe75cnk4n57@yy-desk-7060>
References: <20220607074034.7109-1-yuan.yao@intel.com>
 <Yp9nsbNzoIEyJeDv@google.com>
 <20220607233045.a3sz7v2u6cdeg3sb@yy-desk-7060>
 <Yp/hiOxrOhEuIWj6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp/hiOxrOhEuIWj6@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 07, 2022 at 11:38:48PM +0000, Sean Christopherson wrote:
> On Wed, Jun 08, 2022, Yuan Yao wrote:
> > On Tue, Jun 07, 2022 at 02:58:57PM +0000, Sean Christopherson wrote:
> > > Everything below here can be dropped as it's not relevant to the original bug.
> > >
> > > E.g. the entire trace can be trimmed to:
> >
> > Ah, I thought that the original trace carries most information
> > which maybe useful to other people. Let me trim them as you
> > suggested in V2, thanks.
>
> For bug reports, it's helpful to have the raw trace as the context is useful for
> debug.  But for changelogs, the goal is only to document the failure signature,
> e.g. so that reviewers understand what broke, users that encounter a similar splat
> can find a possible fix, etc...

I got it, I will send a new v1 patch with new subject for this:
KVM: x86/mmu: Set memory encryption "value", not "mask", in shadow PDPTRs
