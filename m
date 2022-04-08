Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738E24FA025
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 01:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiDHXgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 19:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiDHXgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 19:36:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E093301;
        Fri,  8 Apr 2022 16:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649460882; x=1680996882;
  h=message-id:subject:from:to:cc:in-reply-to:references:
   mime-version:date:content-transfer-encoding;
  bh=smHiKtl9bXw+2mywjMN3ZlVei8DjqZmWYos0ESvFbe8=;
  b=lMvq0jKM6eQ8+fYkBZEZ5lY0/9j620mtsaqQoJylQr65Fma28j9yn6ic
   o0l5MgsROFPSE/0IYTUIGG+IPGMFs4SBzYH9menYppFrw4GjQdCl1JGpZ
   hzajvCj0bMtlxdzR/cHJnikvJA71cZvoy9X/0zkxO3TZ+A5ncRvygED8s
   vNrT33bKbKO1+tGtMTVUBGiFH3vgc2GnAfGdXc+PIWcbdW6CcD+sWU6vQ
   NO8qhjbiGZ7TPt98OnC7h0aKCe72eTL9vcZYc/1TWO/31UKK/XwVdJNDD
   L+F9h7NanZWfSHt6kobP3fUMPGbSvuIHgm7ILIdZLCotBsdPqA6IryHt6
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="348160263"
X-IronPort-AV: E=Sophos;i="5.90,246,1643702400"; 
   d="scan'208";a="348160263"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 16:34:41 -0700
X-IronPort-AV: E=Sophos;i="5.90,246,1643702400"; 
   d="scan'208";a="852289395"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.54.250])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 16:34:39 -0700
Message-ID: <7db9977ef1ec3f67ea2da1599f168825d7173111.camel@intel.com>
Subject: Re: [RFC PATCH v5 042/104] KVM: x86/mmu: Track shadow MMIO
 value/mask on a per-VM basis
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
In-Reply-To: <20220408191239.GD857847@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
         <1c7710a87eed650e4423935012e27747fb8c9dd8.camel@intel.com>
         <20220408191239.GD857847@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Sat, 09 Apr 2022 11:34:07 +1200
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-08 at 12:12 -0700, Isaku Yamahata wrote:
> > > -	shadow_present_mask	= has_exec_only ? 0ull :
> > > VMX_EPT_READABLE_MASK;
> > > +	shadow_present_mask	=
> > > +		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) |
> > > init_value;
> > 
> > This change doesn't seem make any sense.  Why should "Suppress #VE" bit be
> > set
> > for a present PTE?
> 
> Because W or NX violation also needs #VE.  Although the name uses present,
> it's
> actually readable.

Yeah I forgot this.  Thanks!

-- 
Thanks,
-Kai


