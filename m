Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E097F5092E8
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382860AbiDTWj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiDTWj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:39:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF68EBC8E;
        Wed, 20 Apr 2022 15:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650494229; x=1682030229;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i9q3aNzZ3vKoblpHcaO08gYbCC2rc/J10N6kSbmsDK8=;
  b=A3l2bYAC87Kih0YuSd09Mde9vijUUlUU4nYWNz8w3RXiah8dN2ljecWs
   0jddChzYKmhN+LgK7L5jx749BDk2cUNhhZ1YG+yqVBNJdG4XJKOP26wDZ
   a6RcLjRKKAM9LBp7/lqYbm0MwmDvQ9aoVKQnRkyp3U5fni5Rc0YG/rKSS
   82N7CCyrAoaDRMK7OliLNlh0dfNRW1sa0nxFCY/i+nJRkmO+boFCUl3vN
   AXwa96CCoTmW42i7WjcpS5JBF6vRq9edwlLaoiVtvsdJKzhgTlzs5wgzk
   wkeyHAhuRPzopv+/GiS4dVwzMOoe7fVG+LoFRFrlI890Et/kzvQM7FEhe
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="264338791"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="264338791"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:37:09 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="727690932"
Received: from ssharm9-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.30.148])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:37:05 -0700
Message-ID: <fc89b2bd1c4b0755b631dae5213feca24e9d3a9d.camel@intel.com>
Subject: Re: [PATCH v3 07/21] x86/virt/tdx: Do TDX module global
 initialization
From:   Kai Huang <kai.huang@intel.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
Date:   Thu, 21 Apr 2022 10:37:03 +1200
In-Reply-To: <1597240f-af03-66c7-a25f-872b2601554e@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <66e6aa1dc1bade544b81120d7976cb0601f0528b.1649219184.git.kai.huang@intel.com>
         <1597240f-af03-66c7-a25f-872b2601554e@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-20 at 15:27 -0700, Sathyanarayanan Kuppuswamy wrote:
> 
> On 4/5/22 9:49 PM, Kai Huang wrote:
> > Do the TDX module global initialization which requires calling
> > TDH.SYS.INIT once on any logical cpu.
> 
> IMO, you could add some more background details to this commit log. Like
> why you are doing it and what it does?. I know that you already 
> explained some background in previous patches. But including brief
> details here will help to review the commit without checking the
> previous commits.
> 

OK I guess I can add "the first step is global initialization", etc.

-- 
Thanks,
-Kai


