Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332AB5067E3
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 11:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241724AbiDSJoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 05:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236286AbiDSJn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 05:43:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D8E13CF3;
        Tue, 19 Apr 2022 02:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650361277; x=1681897277;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ldXu//bNi/uebDj2SpRcE647pc3t9XXuRKpgyCAWkbQ=;
  b=HF7Pmy2j2Etkl83ulRy/6wqSno7HfyFWw1pHG6vC16CjwgziCQXRNNhZ
   FqROwajsesP98z+fklPRc+ytnU7IYvWxFfyQwJ000xGA8gZAIeJkU7tfd
   VCsaWWvISzulDLjh52dNtX3W23nMMYLuDNzzMxnYeIIGjRXyWecFA+dqW
   CR2HfT6WX4e8sRwES4bPzz78VI/Mh1bkIlUuzGJc7lYASpb81a6ycCt2F
   +T7KJvXcxGlDPWGCi5nFJ7jR4/jnY/2SQHPnQS4mlT44SxVJkBdeJ8Gpb
   KzI8Fxbv3VzuX5YZau8sj3XzKNUKGkoZrlf23nmaD5tCR2/cVuD83L4Uc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="350173415"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="350173415"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 02:41:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="530098627"
Received: from csambran-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.58.20])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 02:41:13 -0700
Message-ID: <54ea78b66240c308d8a8e2538bdde18e694c2d53.camel@intel.com>
Subject: Re: [PATCH v3 02/21] x86/virt/tdx: Detect TDX private KeyIDs
From:   Kai Huang <kai.huang@intel.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
Date:   Tue, 19 Apr 2022 21:41:11 +1200
In-Reply-To: <9b3fbb8f-47fc-82df-dc1f-e99649b18d85@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <2fb62e93734163d2f367fd44e3335cd8a2bf2995.1649219184.git.kai.huang@intel.com>
         <9b3fbb8f-47fc-82df-dc1f-e99649b18d85@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-04-18 at 22:39 -0700, Sathyanarayanan Kuppuswamy wrote:
> 
> On 4/5/22 9:49 PM, Kai Huang wrote:
> > + * Intel Trusted Domain CPU Architecture Extension spec:
> 
> In TDX guest code, we have been using TDX as "Intel Trust Domain
> Extensions". It also aligns with spec. Maybe you should change
> your patch set to use the same.
> 

Yeah will change to use "Intel Trust Domain ...".  Thanks. 

-- 
Thanks,
-Kai


