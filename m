Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E88727392
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 02:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjFHAIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 20:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjFHAIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 20:08:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BE726A0;
        Wed,  7 Jun 2023 17:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686182919; x=1717718919;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1hzioKQ/N8dq4Quaj9gu8PIF2snj8PPWSmrQicnFLUo=;
  b=bg0JYVnNIVlOjb2/l8g6Fq6I2nYd52qdfbLRyav2LncfjaZgahvdtRIG
   et5T6uUEEyxHxZX9nZz62OlgpK7/aTMugTgVMQvUIJgfIrsJidtfwW067
   0E8mVR1M9LowT5kEhoiTXzQuJd5OhgvDBIhGJwdz8/yfMuaArFFgHekne
   gyLHD4kW0aN5TNMzkllBf48E0SV40FPm3JO+kSyFcVN8QL4GoV6bUIEzB
   pbPeAYG1tvoXlEihByWFHhdQX7magvkUkDqTVVPfgskfClQb2N9vJSCdd
   K2Lv0RGQVvGzmEGNiYN4zZKRdkS0LgfiGoXhbyCx0uetxPUz1pgYPqS9H
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="385482386"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="385482386"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 17:08:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="854106798"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="854106798"
Received: from zhanzhiw-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.42.209])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 17:08:34 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id B412A10F0E0; Thu,  8 Jun 2023 03:08:31 +0300 (+03)
Date:   Thu, 8 Jun 2023 03:08:31 +0300
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
Subject: Re: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Message-ID: <20230608000831.2rjrhdaf7qs6bjnv@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:19AM +1200, Kai Huang wrote:
> Certain SEAMCALL leaf functions may return error due to running out of
> entropy, in which case the SEAMCALL should be retried as suggested by
> the TDX spec.
> 
> Handle this case in SEAMCALL common function.  Mimic the existing
> rdrand_long() to retry RDRAND_RETRY_LOOPS times.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
