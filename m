Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0202272657A
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 18:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbjFGQIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 12:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241502AbjFGQIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 12:08:52 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522CF1BFE;
        Wed,  7 Jun 2023 09:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686154115; x=1717690115;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=im+3eUPzIUN6Pb8pnWR5VHxFF1tSqQ19oIm6GDJixTg=;
  b=eQVZb+lLJjlXtjYGz29T7pcyb2AsjElup1EXZ74mdDhDIJzcUOTdA+qS
   DN6hjMCYqCiAkCU5BFNiPAXeqkCII6rbZ9VQ/LMZDcQqbnb2G/aX+Tq5f
   9xre8iv5BmUO7qlz2xERCP11kZdbqp1mBKXcTDKCtxW5HBZaf3pfAkews
   EOm4HTZvDm5aWYLnH6QKbDVC6645T7smoBjbpC7tPOMoVCzR8P2C+VBeH
   tL6BUg6kEN6UFmIUi4QkDYjVaMgU703xApw3/Mn37SMT/7VIyjC1Rz8kX
   N7hPfEQBTjZ4pJehy0eJCP2WqcEKi8M/vIDG1uU6YPVpHYcK50lxhdm9+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="355886185"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="355886185"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 09:05:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="799436682"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="799436682"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 09:05:15 -0700
Message-ID: <0600959d-9e10-fb1f-b3a9-862a51b9d8e1@intel.com>
Date:   Wed, 7 Jun 2023 09:05:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/23 07:27, Kai Huang wrote:
> +	/*
> +	 * Loop over TDX memory regions and fill out TDMRs to cover them.
> +	 * To keep it simple, always try to use one TDMR to cover one
> +	 * memory region.
> +	 *
> +	 * In practice TDX1.0 supports 64 TDMRs, which is big enough to
> +	 * cover all memory regions in reality if the admin doesn't use
> +	 * 'memmap' to create a bunch of discrete memory regions.  When
> +	 * there's a real problem, enhancement can be done to merge TDMRs
> +	 * to reduce the final number of TDMRs.
> +	 */

Rather than focus in on one specific command-line parameter, let's just say:

	In practice TDX supports at least 64 TDMRs.  A 2-socket system
	typically only consumes <NUMBER> of those.  This code is dumb
	and simple and may use more TMDRs than is strictly required.

Let's also put a pr_warn() in here if we exceed, say 1/2 or maybe 3/4 of
the 64.  We'll hopefully start to get reports somewhat in advance if
systems get close to the limit.
