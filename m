Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0494EA411
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 02:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiC2AGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 20:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiC2AGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 20:06:36 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8BE286EF;
        Mon, 28 Mar 2022 17:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648512292; x=1680048292;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=juvWbMsYnrH6myWOknKMBFZebQXalGrID0LpNJMhQT0=;
  b=ZshH2fPGNu2gnPbjtPzuXWHQxZi4dls7iE6X7/GSCT/X6IftuuHy7FMo
   sP47F48u3uDfkrmU1DHg1QXmyTOTNXwrkIn/jSiHpjGqarO6n2BcCrp/7
   PT7j3cInR+zX/CZrh/BRDDgb+ElaltIu2V3KigTeIN8dbfohPAi0Cjidx
   XHPaACjNu4gxrWmXy2as3o7RqHU/BgsC/o40MJbTxhLhOMItdW0ITS5HB
   L1+hj6l1Sp8bnoEuSD0P1pxkI0TbQ4O+zGI3L38dpdmNGmApnXHZDII57
   h0oJsP+khgUC88AQDQdfPMsoj64vvM+CfdzfCB4RWPh31tO0J3BadvrQw
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="322314150"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="322314150"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 17:04:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="585377933"
Received: from nhawacha-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.27.18])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 17:04:48 -0700
Message-ID: <3921284602d9a9ed36df7fe651ca25b29a3de0de.camel@intel.com>
Subject: Re: [PATCH v2 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com
Date:   Tue, 29 Mar 2022 13:04:46 +1300
In-Reply-To: <f0b7ecb0-a0f1-95f3-4594-bc19eab4d2f2@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <98c1010509aa412e7f05b12187cacf40451d5246.1647167475.git.kai.huang@intel.com>
         <20220324174301.GA1212881@ls.amr.corp.intel.com>
         <f211441a6d23321e22517684159e2c28c8492b86.camel@intel.com>
         <20220328202225.GA1525925@ls.amr.corp.intel.com>
         <60bf1aa7-b004-0ea7-7efc-37b4a1ea2461@intel.com>
         <9d8d20f62f82e052893fa32368d6a228a2140728.camel@intel.com>
         <f0b7ecb0-a0f1-95f3-4594-bc19eab4d2f2@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-28 at 16:44 -0700, Dave Hansen wrote:
> On 3/28/22 16:40, Kai Huang wrote:
> > Btw if you have time, could you help to review this series? Or could you take a
> > look at whether the overall design is OK, for instance, the design limitations
> > described in the cover letter?
> 
> Kai, it's on my list, but it's a long list.
> 
> If you want to help, there are at least two other *big* TDX patch sets
> out there that need eyeballs:
> 
> > https://lore.kernel.org/all/20220318153048.51177-1-kirill.shutemov@linux.intel.com/
> 
> and
> 
> > https://lore.kernel.org/all/20220310140911.50924-1-chao.p.peng@linux.intel.com/
> 

Yes I am aware of them.  I'll comment if I think that can help to speed up. 
Thanks for the info!

-- 
Thanks,
-Kai


