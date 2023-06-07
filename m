Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B35726503
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 17:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241484AbjFGPsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 11:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241453AbjFGPsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 11:48:07 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9B71BC6;
        Wed,  7 Jun 2023 08:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686152886; x=1717688886;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+3vgVO8tJwqTs7HyPalyqiGJn+qGhs2vMFA3uccMokI=;
  b=YtYrGGW5OpAitLs4GA00RKlwzcyvEc100v8CqZv+x4+zZK44J1FHMtEK
   PKsqheSegfuRRnWulua2lrM578JF4gBnNBCQpdY2iD0iybOjJjmGXVwbK
   KVSvG7BGcyDGc2WanZBtkWLe/OaEE0RoIcpQG9TRT/BSYkrLjCtNYxwOC
   ++T+Ezunv1BJUrNeTANp5AG3t8dDtJW2E1ukg5YDfjDpyzmiQ/wOcsqZv
   WncuuGZBiaftjQT7fuObU11mP9RuEMf7QMXU2l6RBN98LpHwTOpQ+XLm6
   QiMmfkByntBujnfURNQq4G54sVZLUAjA5N2as/Yx3vzVlwom198dq7AqT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="359497523"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="359497523"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:48:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="712712690"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="712712690"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:48:04 -0700
Message-ID: <97b239b4-7d0d-e5e9-43f5-b9c26d6cd846@intel.com>
Date:   Wed, 7 Jun 2023 08:48:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 09/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
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
 <468533166590ff5ed11730350c4af8cdb0b99165.1685887183.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <468533166590ff5ed11730350c4af8cdb0b99165.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/23 07:27, Kai Huang wrote:
> As a step of initializing the TDX module, the kernel needs to tell the
> TDX module which memory regions can be used by the TDX module as TDX
> guest memory.
...
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

This is rather short on reviews from folks who do a lot of memory
hotplug work.  Partly because I don't see any of them cc'd.

Can you wrangle some mm reviews on this, please?

For the x86 side (and <sigh> because this patch probably took two years
to coalesce <double sigh>):

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
