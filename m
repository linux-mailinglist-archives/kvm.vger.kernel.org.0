Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C787370B1
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 17:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbjFTPkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 11:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjFTPkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 11:40:01 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870491A2;
        Tue, 20 Jun 2023 08:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687275600; x=1718811600;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wxOtILeVt+OcJwdm6KRHBAGZ5isFatuQAs5FDwV9Rzk=;
  b=Y7vogSeMZYp7tG0o0bngPzblsfn97+KlQCvaU6G1j6PNJyUEFMrpvfBC
   /tzBPSJ5UOcIfCfc/chdk/MJHA032otYIAl/QhzjqUfJJq2GByJNtFNQM
   89eR8R2eRc3+gAIQzWcg6eVbiqn+lBExWT6DlrwOJksWSs8j4MLX+Wu0E
   IKPC68+QlkBq1hGk3NffRT9g4omWJY+Q60pDz5RK2QnxNdRpkvhgu0e2r
   wvgZRid1fB2rjNf15E8mzES43Soq472zJOI2ynvcLHO7kz6NLKFObg8z0
   QKXgvr4XAyuP6pU0JjnI1c0ZuAqW4GAJW8SToItkajJvx4vGkzXKQSwrt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="359902864"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="359902864"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 08:39:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="827045577"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="827045577"
Received: from rashmigh-mobl.amr.corp.intel.com (HELO [10.255.228.28]) ([10.255.228.28])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 08:39:50 -0700
Message-ID: <f64ee1a5-d96f-d888-14a7-8b4c5e7a9a2f@intel.com>
Date:   Tue, 20 Jun 2023 08:39:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
 <723dd9da-ebd5-edb0-e9e5-2d8c14aaffe2@redhat.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <723dd9da-ebd5-edb0-e9e5-2d8c14aaffe2@redhat.com>
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

On 6/19/23 05:21, David Hildenbrand wrote:
> So, ordinary writes to TD private memory are not a problem? I thought
> one motivation for the unmapped-guest-memory discussion was to prevent
> host (userspace) writes to such memory because it would trigger a MC and
> eventually crash the host.

Those are two different problems.

Problem #1 (this patch): The host encounters poison when going about its
normal business accessing normal memory.  This happens when something in
the host accidentally clobbers some TDX memory and *then* reads it.
Only occurs with partial writes.

Problem #2 (addressed with unmapping): Host *userspace* intentionally
and maliciously clobbers some TDX memory and then the TDX module or a
TDX guest can't run because the memory integrity checks (checksum or TD
bit) fail.  This can also take the system down because #MC's are nasty.

Host userspace unmapping doesn't prevent problem #1 because it's the
kernel who screwed up with the _kernel_ mapping.


