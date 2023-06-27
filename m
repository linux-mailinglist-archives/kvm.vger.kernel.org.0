Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EAB73F906
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 11:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjF0JuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 05:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjF0JuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 05:50:22 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12652691;
        Tue, 27 Jun 2023 02:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687859421; x=1719395421;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S34hN26QAZtQUW6DKc6TE+7IhWnV1UGr4OqGCCuhdv4=;
  b=YW+DmiqLTzrlIRiqMA8Mqbj+BU8GE+3k/ZEnwtkuyikGziYnWE7DvLnw
   Ij3qbKpv36NEgWrY00V/Howd22kuCfbjL2wX2oEqvqZATfzU+MMA+k/jP
   EmCdebElxSNFbRPk1ZOlATia51XAl3qQtgDndVYVfrCjeRJumpQ5lJyEL
   0YOJ/opcvFDDI1pLqxR3OJPwP+bFOVVs+VP2kEAtMXR5F46eb6tSaFB+e
   qTRx8wtv4/MHuTQSAm7+EAe9jUMI8y+hIh4EVJ2FbG73izOFCr3hFKm5R
   nr2IpHiG35MT/XUeQC1UzdC5+sB3rHxAs1WJjkmG1ERJhArwDb7JLUwlm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="447911892"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="447911892"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:50:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="806403097"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="806403097"
Received: from rbhaumik-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.251.217.121])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:50:14 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 24381103732; Tue, 27 Jun 2023 12:50:12 +0300 (+03)
Date:   Tue, 27 Jun 2023 12:50:12 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:37AM +1200, Kai Huang wrote:
> +	/*
> +	 * The TDX module global initialization only needs to be done
> +	 * once on any cpu.
> +	 */
> +	raw_spin_lock_irqsave(&tdx_global_init_lock, flags);

I don't understand how the comment justifies using raw spin lock.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
