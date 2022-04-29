Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC96C514C06
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 15:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376996AbiD2N7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 09:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376762AbiD2N5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 09:57:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77193CFBA4;
        Fri, 29 Apr 2022 06:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651240337; x=1682776337;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MNsNGb1KS2Bfdr9wXlInMU/yiClX+gR7Udk3isZ3pC0=;
  b=GIvTE60Um0eexIffT68jOrR/ookVsCABp2hJ6h4k4HKG4WFkiQTiS+To
   tPCb71A9SUEOe5wJ363Wg3mYcKopHaL1XObTlgsJUgbi5NKEvk+vgvWPe
   0W3UGaXVxMXYAESlGGcwTvv6QW+8iqymMTrEDZVRqo3cOFPRGO2SCsDdr
   A4AiiJKL973njv8PGq3jv1/3zrMAfbE1TOGUjRUvmqOXD8TRJx+XUgGyC
   h9TvCjWzsTxRFst/WM0gpAieNcpvlUFEVaiNtwpTss9c/oiUy6bACuaNW
   wAjckclQCQMf6oUySrqPBaOOCesR/yCd+5JhWZfEmUAToftg0pMrbyC+e
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246563217"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="246563217"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 06:52:06 -0700
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582135045"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 06:52:05 -0700
Message-ID: <a651a489-ecc5-2439-61b1-03ff43cff7f6@intel.com>
Date:   Fri, 29 Apr 2022 06:52:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 12/21] x86/virt/tdx: Create TDMRs to cover all system
 RAM
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <6cc984d5c23e06c9c87b4c7342758b29f8c8c022.1649219184.git.kai.huang@intel.com>
 <fa4d15d5-4690-9e63-f0c9-af4b58e4325c@intel.com>
 <695f319e637e7afb33f228a230566f0c671e3a03.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <695f319e637e7afb33f228a230566f0c671e3a03.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 00:24, Kai Huang wrote:
> On Thu, 2022-04-28 at 09:22 -0700, Dave Hansen wrote:
>> On 4/5/22 21:49, Kai Huang wrote:
>>> implies that one TDMR could cover multiple e820 RAM entries.  If a RAM
>>> entry spans the 1GB boundary and the former part is already covered by
>>> the previous TDMR, just create a new TDMR for the latter part.
>>>
>>> TDX only supports a limited number of TDMRs (currently 64).  Abort the
>>> TDMR construction process when the number of TDMRs exceeds this
>>> limitation.
>>
>> ... and what does this *MEAN*?  Is TDX disabled?  Does it throw away the
>> RAM?  Does it eat puppies?
> 
> How about:
> 
> 	TDX only supports a limited number of TDMRs.  Simply return error when
> 	the number of TDMRs exceeds the limitation.  TDX is disabled in this
> 	case.

Better, but two things there that need to be improved.  This is a cover
letter.  Talking at the function level ("return error") is too
low-level.  It's also slipping into passive mode "is disabled".  Fixing
those, it looks like this:

	TDX only supports a limited number of TDMRs.  Disable TDX if all
	TDMRs are consumed but there is more RAM to cover.

