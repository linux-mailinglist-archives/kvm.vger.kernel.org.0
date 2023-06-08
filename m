Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95500728C06
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbjFHXyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237573AbjFHXyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:54:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07E02738;
        Thu,  8 Jun 2023 16:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686268445; x=1717804445;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FR3CJyjeIQ8jPwCBjuJP9efs0Wq+kfk5E5wSAuTzgxA=;
  b=mN0SmKuNwpyumoRfjuvm6S35x55GwWPcbl7cOWlDoozGPOJ/rDSD8Igq
   ad6ZBNj2YRywkmbtkQejwDWz7ygXalMrTFqfMmAs8BSiepKh+zWSFa1gq
   4ZM3vNX6eGJWWM7krE75VS7dn4va+ju6NPD92Ta2WCRGI5KSo+oTProYg
   Ia1ambOzcm6QW05Cl8EDAYUx64/3rD3dyLG6xwHgxU7Pfw3pSx6fFM7yJ
   6awlBrdMnJn6A7u8dKl8QxD+KF9CnMsObNBImUk+f4AENOTm4Tb2N1DBA
   Br7rngmIj0FKmg+K+wDGrFe88083gJ1M4ze6oiV+R8pCpKFUK5hFQMM8x
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="357471094"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="357471094"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:54:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="956928208"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="956928208"
Received: from fgorter-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.59.89])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:53:56 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 2B23E104C0F; Fri,  9 Jun 2023 02:53:54 +0300 (+03)
Date:   Fri, 9 Jun 2023 02:53:54 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v11 15/20] x86/virt/tdx: Configure global KeyID on all
 packages
Message-ID: <20230608235354.aqgsuuhkryhsrls7@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <30358db4eff961c69783bbd4d9f3e50932a9a759.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30358db4eff961c69783bbd4d9f3e50932a9a759.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:28AM +1200, Kai Huang wrote:
> After the list of TDMRs and the global KeyID are configured to the TDX
> module, the kernel needs to configure the key of the global KeyID on all
> packages using TDH.SYS.KEY.CONFIG.
> 
> This SEAMCALL cannot run parallel on different cpus.  Loop all online
> cpus and use smp_call_on_cpu() to call this SEAMCALL on the first cpu of
> each package.
> 
> To keep things simple, this implementation takes no affirmative steps to
> online cpus to make sure there's at least one cpu for each package.  The
> callers (aka. KVM) can ensure success by ensuring that.
> 
> Intel hardware doesn't guarantee cache coherency across different
> KeyIDs.  The PAMTs are transitioning from being used by the kernel
> mapping (KeyId 0) to the TDX module's "global KeyID" mapping.
> 
> This means that the kernel must flush any dirty KeyID-0 PAMT cachelines
> before the TDX module uses the global KeyID to access the PAMTs.
> Otherwise, if those dirty cachelines were written back, they would
> corrupt the TDX module's metadata.  Aside: This corruption would be
> detected by the memory integrity hardware on the next read of the memory
> with the global KeyID.  The result would likely be fatal to the system
> but would not impact TDX security.
> 
> Following the TDX module specification, flush cache before configuring
> the global KeyID on all packages.  Given the PAMT size can be large
> (~1/256th of system RAM), just use WBINVD on all CPUs to flush.
> 
> If TDH.SYS.KEY.CONFIG fails, the TDX module may already have used the
> global KeyID to write the PAMTs.  Therefore, use WBINVD to flush cache
> before returning the PAMTs back to the kernel.  Also convert all PAMTs
> back to normal by using MOVDIR64B as suggested by the TDX module spec,
> although on the platform without the "partial write machine check"
> erratum it's OK to leave PAMTs as is.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
