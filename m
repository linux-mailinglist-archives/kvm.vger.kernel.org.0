Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFF7506857
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 12:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350482AbiDSKK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 06:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346687AbiDSKKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 06:10:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E357F24581;
        Tue, 19 Apr 2022 03:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650362862; x=1681898862;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1xlYLRIAydMzH+PRkiOVUFsK9522fDATHmtKjfUXfLA=;
  b=YcDGlzRtIAeH8yB8LqXMP04hStLSI+0n6zLEuilP2YUx0G+qN/KRmjNX
   cQJl/Hd78Tyu7RTB3wOVsqeaabrGFMpSrOGbbcREduNiGU04adSXPIvyP
   YB2QAAeryZxshdRBqrxHUyceB94HPN5f+xdo4ySJktmmJBqSoI4sAHr3L
   MnDIR5K30WgEiJi7FhoFiQUja0POARWqReVQ03tx1By4v5JaG0o6+s9sC
   lJfO+0tnlmDICaIsAIYcz5+Kjv+uSZ6d0u2xgDL8sztpMAdRmyNDRsJd0
   Ckjvsww9yEuPE/f9E/afjyHNjqJ9O/x8qxAMo+zU7rgmjYOG4rqWGaii7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="262588110"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="262588110"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 03:07:42 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="561663681"
Received: from csambran-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.58.20])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 03:07:39 -0700
Message-ID: <19ef56ed7852a2097125a588b124e4598ab26e91.camel@intel.com>
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
Date:   Tue, 19 Apr 2022 22:07:37 +1200
In-Reply-To: <abfb95df-4f34-1663-42e8-b9d06bab3b58@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <2fb62e93734163d2f367fd44e3335cd8a2bf2995.1649219184.git.kai.huang@intel.com>
         <abfb95df-4f34-1663-42e8-b9d06bab3b58@linux.intel.com>
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

On Mon, 2022-04-18 at 22:42 -0700, Sathyanarayanan Kuppuswamy wrote:
> 
> On 4/5/22 9:49 PM, Kai Huang wrote:
> >   	detect_seam(c);
> > +	detect_tdx_keyids(c);
> 
> Do you want to add some return value to detect_seam() and not
> proceed if it fails?

I don't think this function should return.  However it may make sense to stop
detecting TDX KeyIDs when on some cpu SEAMRR is detected as not enabled (i.e. on
BSP when SEAMRR is not enabled by BIOS, or on any AP when there's BIOS bug that
BIOS doesn't configure SEAMRR consistently on all cpus).  The reason is TDX
KeyIDs can only be accessed by software runs in SEAM mode.  So if SEAMRR
configuration is broken, TDX KeyID configuration probably is broken too.

However detect_tdx_keyids() essentially only uses rdmsr_safe() to read some MSR,
so if there's any problem, rdmsr_safe() will catch it.  And SEAMRR is always
checked before doing any TDX related staff later, therefore in practice there
will be no problem.  But anyway I guess there's no harm to add additional SEAMRR
check in detect_tdx_keyids().  I'll think more on this.  Thanks.

> 
> In case if this function is going to be extended by future
> patch set, maybe do the same for detect_tdx_keyids()?
> 

I'd prefer to leaving this in current way until there's a real need.

-- 
Thanks,
-Kai


