Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C9C50CE37
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 03:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbiDXBaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Apr 2022 21:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiDXBap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Apr 2022 21:30:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D247760AB2;
        Sat, 23 Apr 2022 18:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650763666; x=1682299666;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IA1Lmj4ocO6/xXKqNHTWqrt9z5lmz4IZWJmRXxw1fbk=;
  b=cOC+J7B5gLiZDso6hMbROPhzRNuHxAL7gvSWHZ+1c22tFB8Nnci2pfKn
   gUbKQ9F9bwjF9P9wXLeINcas19aaiHz4bpqwQZpw9KXJ8G3xfHVBHp4bh
   V0Q67YQUGt4wk2JCqxZg/dNL5TnWZ1dp0smjZPySqGF8n1IMikwypm5hl
   swZ2ksRQHSWPtM7UFWSQgdDSW39TiT8yxwEopD5j0zG/qxem9uvYuDrXl
   WoB6Gp2ZMz7PT93zj0k2Sy/aQdKA8SmiBPA9Mr20q+nSryCFvwhZpaaXh
   /5r0eWQ8hZ2o07Z5olOhFcnrJ+7CDaj7FiyNnZFRbw/5uNesT3qyfW6Nf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="265144118"
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="265144118"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 18:27:46 -0700
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="729114400"
Received: from mhammack-mobl1.amr.corp.intel.com (HELO [10.212.213.135]) ([10.212.213.135])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 18:27:44 -0700
Message-ID: <4bff50c3-4065-65a3-b698-28f2391bb776@linux.intel.com>
Date:   Sat, 23 Apr 2022 18:27:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 08/21] x86/virt/tdx: Do logical-cpu scope TDX module
 initialization
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <35081dba60ef61c313c2d7334815247248b8d1da.1649219184.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <35081dba60ef61c313c2d7334815247248b8d1da.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/22 9:49 PM, Kai Huang wrote:
> Logical-cpu scope initialization requires calling TDH.SYS.LP.INIT on all
> BIOS-enabled cpus, otherwise the TDH.SYS.CONFIG SEAMCALL will fail.

IIUC, this change handles logical CPU initialization part of TDX module
initialization. So why talk about TDH.SYS.CONFIG failure here? Are they
related?

> TDH.SYS.LP.INIT can be called concurrently on all cpus.

IMO, if you move the following paragraph to the beginning, it is easier
to understand "what" and "why" part of this change.
> 
> Following global initialization, do the logical-cpu scope initialization
> by calling TDH.SYS.LP.INIT on all online cpus.  Whether all BIOS-enabled
> cpus are online is not checked here for simplicity.  The caller of
> tdx_init() should guarantee all BIOS-enabled cpus are online.

Include specification reference for TDX module initialization and
TDH.SYS.LP.INIT.

In TDX module spec, section 22.2.35 (TDH.SYS.LP.INIT Leaf), mentions
some environment requirements. I don't see you checking here for it?
Is this already met?



-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
