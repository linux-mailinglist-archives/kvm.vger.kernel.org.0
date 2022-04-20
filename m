Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFEC50861F
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 12:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352255AbiDTKmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 06:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377772AbiDTKmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 06:42:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8A31FA;
        Wed, 20 Apr 2022 03:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650451189; x=1681987189;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/odPNgCAaCg5QNiot/1kNrCZbKD+V4EXjIoAtAZI7rM=;
  b=OOzV6l4Ka5kCWOrrh0LdGCZNEWzyjzEL0O4+8z7ZQH/HV4WqsTWOlcYK
   p8OkWLvn6v8B1pCCqSwYHTk1+1cDw6MClzF8h04vX+WVg6alE59y+qdxX
   0zqnBaDaaCEz2tRPa2BQwJqlOhR8EfkX2A6xDcLekDo6p7kkTzpL9sxoj
   yQXukc+p0cUR7shqoXbkcGXicdD7DAKhVNbtSauJjiK57y9BShAkJ5cAr
   Y0+xQqPCCjB+4TsyomoPw6tgjo9+FPgaINHPGFDiNUIl6nR6UQG9Nc7ao
   Hat/xwj+/YcwouVp1C5HVZ1S3jfGTMRtNcOPi/cz4a0GOirUVi1q7bRVN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="262853510"
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="262853510"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 03:39:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="529699217"
Received: from rnmatson-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.31.26])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 03:39:45 -0700
Message-ID: <2521bf42605a16847df239c0d7405d3c1b233340.camel@intel.com>
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
Date:   Wed, 20 Apr 2022 22:39:43 +1200
In-Reply-To: <faf366f9-a0cb-4121-e5bf-c63e6d0b14aa@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <1c3f555934c73301a9cbf10232500f3d15efe3cc.1649219184.git.kai.huang@intel.com>
         <dd9d6f7d-5cec-e6b7-2fa0-5bf1fdcb79b5@linux.intel.com>
         <d1b88a6e08feee137df9acd2cdf37f7685171f4b.camel@intel.com>
         <faf366f9-a0cb-4121-e5bf-c63e6d0b14aa@linux.intel.com>
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

On Wed, 2022-04-20 at 00:29 -0700, Sathyanarayanan Kuppuswamy wrote:
> 
> On 4/19/22 9:16 PM, Kai Huang wrote:
> > On Tue, 2022-04-19 at 07:07 -0700, Sathyanarayanan Kuppuswamy wrote:
> > > 
> > > On 4/5/22 9:49 PM, Kai Huang wrote:
> > > > SEAMCALL leaf functions use an ABI different from the x86-64 system-v
> > > > ABI.  Instead, they share the same ABI with the TDCALL leaf functions.
> > > 
> > > TDCALL is a new term for this patch set. Maybe add some detail about
> > > it in ()?.
> > > 
> > > > 
> > 
> > TDCALL implementation is already in tip/tdx.  This series will be rebased to it.
> > I don't think we need to explain more about something that is already in the tip
> > tree?
> 
> Since you have already expanded terms like TD,TDX and SEAM in this patch
> set, I thought you wanted to explain TDX terms to make it easy for new 
> readers. So to keep it uniform, I have suggested adding some brief 
> details about the TDCALL.
> 
> 

All right.  I can add one sentence to explain it.

-- 
Thanks,
-Kai


