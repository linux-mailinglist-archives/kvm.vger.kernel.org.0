Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EA6633FFB
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 16:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbiKVPVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 10:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiKVPVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 10:21:01 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEC268691;
        Tue, 22 Nov 2022 07:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669130460; x=1700666460;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7pZC/dz8/S5EuOYF3Mhliy+TJEj50Cth3ybWyWk6W2Q=;
  b=ejhBbwm7kuuF8ARU6nz3rsTzkdBWAJQxbcJjC7sdqG0BoC9Ll/0p4UrQ
   GImpERlD41BLTipUN378L+AqVMUy1D0+KbvvJKRCxBlnHrm/wz86HKGNt
   gF5s/IsXEuIsUt3im7utp062ngvX/nY5mFdzm5KXk5yHquhmW5Sd+A5XL
   3mn9LWSMp8uopmDA6rNk/PstQhXwd0NukCyf7aOWcoXJTvsGGj6cKnFeM
   mugfUAUc5VbCIAdMH3uGX3rVqk46MuVEfbnyk61OStS2AgBXT7fVAxjOR
   tywmHVAdvwoUR8f6mbFFuikXmRgafrood3/l+DqM3iV7OXI7l0U7OZnI3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="313869913"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="313869913"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 07:20:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="783872775"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="783872775"
Received: from lcano-mobl1.amr.corp.intel.com (HELO [10.255.231.75]) ([10.255.231.75])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 07:20:28 -0800
Message-ID: <058a6033-a5e0-771b-3c16-950fdbb8c1e5@intel.com>
Date:   Tue, 22 Nov 2022 07:20:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3yUdcJjrY2LhUWJ@hirez.programming.kicks-ass.net>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y3yUdcJjrY2LhUWJ@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/22 01:20, Peter Zijlstra wrote:
> Either the Changelog is broken or this TDX crud is worse crap than I
> thought possible, because the only way to actually meet that requirement
> as stated is stop_machine().

I think the changelog is broken.  I don't see anything in the TDX module
spec about "the SEMACALL can run concurrently on different CPUs".
Shutdown, as far as I can tell, just requires that the shutdown seamcall
be run once on each CPU.  Concurrency and ordering don't seem to matter
at all.
