Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7A507FCC
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 06:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349293AbiDTETS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 00:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiDTETR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 00:19:17 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7C335854;
        Tue, 19 Apr 2022 21:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650428191; x=1681964191;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u81sku0Dv0pejA3/j4OL8kvO+Wy+SJum2+dmhEsJwaA=;
  b=lw/GkZoJ1AE6I62GnnPGtCzfW/aHjP2gHpPi67rjCra38EWlqD1gCQ80
   dUmngWfsUUIkB9hRo9DsEweQBMs1H5ASIJ7UYxFmpDfjMHV+NArP5t4nB
   FfGIBdfkn/7iu1r5/SlJHiR3NCISlq25unlW3Adkmhz1ordvBN9jcsNaa
   qzJI82VOFvpe0rRFLfPa/px7VTCGdycD3+6semqNoTV9C4wniCfoOLpmd
   lffVkiBHgvACWw4xv+SOVIdrEG/rl4AP2jyOLrHtY6z8fK6EntJC2+Z88
   YqJDyO7idb98Zc1Ci0NG/ig1jQL5TfAApIcUb46iLrxU9n+cib5iiJStK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="263397432"
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="263397432"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 21:16:31 -0700
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="667683964"
Received: from asaini1-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.58.15])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 21:16:27 -0700
Message-ID: <d1b88a6e08feee137df9acd2cdf37f7685171f4b.camel@intel.com>
Subject: Re: [PATCH v3 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
From:   Kai Huang <kai.huang@intel.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
Date:   Wed, 20 Apr 2022 16:16:25 +1200
In-Reply-To: <dd9d6f7d-5cec-e6b7-2fa0-5bf1fdcb79b5@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <1c3f555934c73301a9cbf10232500f3d15efe3cc.1649219184.git.kai.huang@intel.com>
         <dd9d6f7d-5cec-e6b7-2fa0-5bf1fdcb79b5@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-19 at 07:07 -0700, Sathyanarayanan Kuppuswamy wrote:
> 
> On 4/5/22 9:49 PM, Kai Huang wrote:
> > SEAMCALL leaf functions use an ABI different from the x86-64 system-v
> > ABI.  Instead, they share the same ABI with the TDCALL leaf functions.
> 
> TDCALL is a new term for this patch set. Maybe add some detail about
> it in ()?.
> 
> > 

TDCALL implementation is already in tip/tdx.  This series will be rebased to it.
I don't think we need to explain more about something that is already in the tip
tree?


-- 
Thanks,
-Kai


