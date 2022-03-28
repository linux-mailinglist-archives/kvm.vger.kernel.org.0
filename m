Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DB44E8B7C
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 03:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbiC1BS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 21:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiC1BSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 21:18:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA194EF78;
        Sun, 27 Mar 2022 18:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648430206; x=1679966206;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xidA2y8NjDEx3Ibl8t+vOISEY3MuUuhbC36nv/l+7VU=;
  b=EbltWSu9D9qNNVIEO2FuLRPSTLKUZ0uJJSo50Pgg2PcjKQuU8+AWa1Ku
   IG0Y/q8XmE6LWuBoZQIClsqyiI+CbskUj70tc0CIhptEVhYkTl9LTrRDq
   dhzfP32LmZqwFwC6oAbXHQDD7M9qwK07qGquUt4DcpMAnqsMhXAH1PltG
   0ZMBQN5+JOfwqC7C35z14kkgZMOY8FiX7ElLnSZtAsdo3mS0g0rpGDTAP
   iEHt3jRvYHn1EXhoNlZQPuFD6x2Q4mY1eCoLOHD6yDWBm95fLjcm96kON
   CT2M2nicFH864QZkKvgMGC9OF67jF5YwchH4sTZ2JhrAjWYTy4afIqpl7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="241041411"
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="241041411"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:16:45 -0700
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="651388422"
Received: from stung2-mobl.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.94.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:16:42 -0700
Message-ID: <83ccfde2f88b9be9eed40784ac22617dd0d69a33.camel@intel.com>
Subject: Re: [PATCH v2 13/21] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com
Date:   Mon, 28 Mar 2022 14:16:40 +1300
In-Reply-To: <20220324180648.GB1212881@ls.amr.corp.intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <bb38ed2511163fbd2026680e23e9b27223a99ab8.1647167475.git.kai.huang@intel.com>
         <20220324180648.GB1212881@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-24 at 11:06 -0700, Isaku Yamahata wrote:
> On Sun, Mar 13, 2022 at 11:49:53PM +1300,
> Kai Huang <kai.huang@intel.com> wrote:
> 
> > diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
> > index 1939b64d23e8..c58c99b94c72 100644
> > --- a/arch/x86/virt/vmx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx.c
> > @@ -21,6 +21,7 @@
> >  #include <asm/cpufeatures.h>
> >  #include <asm/virtext.h>
> >  #include <asm/e820/api.h>
> > +#include <asm/pgtable.h>
> >  #include <asm/tdx.h>
> >  #include "tdx.h"
> >  
> > @@ -66,6 +67,16 @@
> >  #define TDMR_START(_tdmr)	((_tdmr)->base)
> >  #define TDMR_END(_tdmr)		((_tdmr)->base + (_tdmr)->size)
> >  
> > +/* Page sizes supported by TDX */
> > +enum tdx_page_sz {
> > +	TDX_PG_4K = 0,
> > +	TDX_PG_2M,
> > +	TDX_PG_1G,
> > +	TDX_PG_MAX,
> > +};
> > +
> > +#define TDX_HPAGE_SHIFT	9
> > +
> >  /*
> >   * TDX module status during initialization
> >   */
> > @@ -893,7 +904,7 @@ static int create_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
> >  	 * them.  To keep it simple, always try to use one TDMR to cover
> >  	 * one RAM entry.
> >  	 */
> > -	e820_for_each_mem(e820_table, i, start, end) {
> > +	e820_for_each_mem(i, start, end) {
> 
> This patch doesn't change e820_for_each_mem.  This hunk should go into the
> previous patch?
> 
> thansk,
> 

Exactly.  My mistake.  Thanks for catching. 

-- 
Thanks,
-Kai
