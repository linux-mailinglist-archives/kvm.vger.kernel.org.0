Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B6550ED0C
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 01:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbiDYX7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 19:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbiDYX7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 19:59:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2073617B;
        Mon, 25 Apr 2022 16:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650930962; x=1682466962;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YgyLdwQrVsKHBENgBPm8VoS4B39KEAnWuzWUPVQAhsU=;
  b=CcfA8Ml3F4zB3aY94WC3eHhOPZoAo5/7b4KptPcEYc4grjeyjmOBYCBw
   IfF115dcm0Hvr6EsaW9ojNmQ5oYAPK3QTJPb7BEsgWBShNzl5CNFfAwU0
   sTWDe158AreUoV7N6emAAim0tKoP3oWh6yLNYbFe6pUlA9YJ5Frk5aOIc
   j5Pw4RGn2v1uBTXU2043bbNEcEZvVGmZZkchduv3XWcG9LzsShLTJRZXm
   +sgyGhQMAOV9pCfQuZ99HQryxKVGTvQX5os547Gsnv9eopXhC7nM7/Qxu
   JhqOvQBJ2pvN5kZKhzEomPLHWaJys1t/LH1UYKEf7CH8XC06+yxTGYvaQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="245961211"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="245961211"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 16:56:02 -0700
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="729971766"
Received: from begriffi-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.169])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 16:55:48 -0700
Message-ID: <6097c0afdffd714e4a6aa349dfc7f9a009e2718f.camel@intel.com>
Subject: Re: [PATCH v3 08/21] x86/virt/tdx: Do logical-cpu scope TDX module
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
Date:   Tue, 26 Apr 2022 11:55:46 +1200
In-Reply-To: <4bff50c3-4065-65a3-b698-28f2391bb776@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <35081dba60ef61c313c2d7334815247248b8d1da.1649219184.git.kai.huang@intel.com>
         <4bff50c3-4065-65a3-b698-28f2391bb776@linux.intel.com>
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

On Sat, 2022-04-23 at 18:27 -0700, Sathyanarayanan Kuppuswamy wrote:
> 
> On 4/5/22 9:49 PM, Kai Huang wrote:
> > Logical-cpu scope initialization requires calling TDH.SYS.LP.INIT on all
> > BIOS-enabled cpus, otherwise the TDH.SYS.CONFIG SEAMCALL will fail.
> 
> IIUC, this change handles logical CPU initialization part of TDX module
> initialization. So why talk about TDH.SYS.CONFIG failure here? Are they
> related?

They are a little  bit related but I think I can remove it.  Thanks.

> 
> > TDH.SYS.LP.INIT can be called concurrently on all cpus.
> 
> IMO, if you move the following paragraph to the beginning, it is easier
> to understand "what" and "why" part of this change.

OK.

> > 
> > Following global initialization, do the logical-cpu scope initialization
> > by calling TDH.SYS.LP.INIT on all online cpus.  Whether all BIOS-enabled
> > cpus are online is not checked here for simplicity.  The caller of
> > tdx_init() should guarantee all BIOS-enabled cpus are online.
> 
> Include specification reference for TDX module initialization and
> TDH.SYS.LP.INIT.
> 
> In TDX module spec, section 22.2.35 (TDH.SYS.LP.INIT Leaf), mentions
> some environment requirements. I don't see you checking here for it?
> Is this already met?
> 

Good catch.  I missed it, and I'll look into it.  Thanks.


-- 
Thanks,
-Kai


