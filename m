Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E22E511904
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbiD0OX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 10:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237618AbiD0OX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 10:23:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F15E22DF90;
        Wed, 27 Apr 2022 07:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651069244; x=1682605244;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FF9dZMsdhcirHLT0yX4WRrKdmuQYa58gNDfW0zo81+Q=;
  b=eUOPG2lZk3Lu1Kt0pX3CbEA6EB1X9P3JPzw0R7bDNcYNx6Zw1sxCgmfG
   Dq1Z8Q4/mnLTrJP9Ve1qpGw9NyMNHmDx3uxYC+JfV4gsrBz9LiZtf2CMd
   ASURZUGu69iZnaDzU4J9mY3zBX84KTaubYCqxCl9rDlZQs3lFX3kVvvRE
   o0rIo9+akUYgyj3x3QNDmWWBn1Ypn3Q8IfT0BqI0BJzaKH0T/ZBjrr9Zz
   LlpC7ebd+lWsNWQ6J3zYwu47kwNYQxWw1q5VYbm4q03VyGxLSvYiBXyJL
   p+qGgxlCoatJAiwdqygsY86OAt/bKvKt2fXTWTGsdTS583mLk6egYpUbR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="265752153"
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="265752153"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 07:20:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="533227804"
Received: from pcurcohe-mobl.amr.corp.intel.com (HELO [10.212.68.237]) ([10.212.68.237])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 07:20:42 -0700
Message-ID: <49cc6848-47ae-9c25-f479-c5aed8c892df@intel.com>
Date:   Wed, 27 Apr 2022 07:24:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 05/21] x86/virt/tdx: Detect P-SEAMLDR and TDX module
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <b9f4d4afd244d685182ce9ab5ffdd0bf245be6e2.1649219184.git.kai.huang@intel.com>
 <104a6959-3bd4-1e75-5e3d-5dc3ef025ed0@intel.com>
 <98af78402861b1982607c5fd14b0c89403c042a6.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <98af78402861b1982607c5fd14b0c89403c042a6.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 17:01, Kai Huang wrote:
> On Tue, 2022-04-26 at 13:56 -0700, Dave Hansen wrote:
>> On 4/5/22 21:49, Kai Huang wrote:
>>> The P-SEAMLDR (persistent SEAM loader) is the first software module that
>>> runs in SEAM VMX root, responsible for loading and updating the TDX
>>> module.  Both the P-SEAMLDR and the TDX module are expected to be loaded
>>> before host kernel boots.
>>
>> Why bother with the P-SEAMLDR here at all?  The kernel isn't loading the
>> TDX module in this series.  Why not just call into the TDX module directly?
> 
> It's not absolutely needed in this series.  I choose to detect P-SEAMLDR because
> detecting it can also detect the TDX module, and eventually we will need to
> support P-SEAMLDR because the TDX module runtime update uses P-SEAMLDR's
> SEAMCALL to do that.
> 
> Also, even for this series, detecting the P-SEAMLDR allows us to provide the P-
> SEAMLDR information to user at a basic level in dmesg:
> 
> [..] tdx: P-SEAMLDR: version 0x0, vendor_id: 0x8086, build_date: 20211209,
> build_num 160, major 1, minor 0
> 
> This may be useful to users, but it's not a hard requirement for this series.

We've had a lot of problems in general with this code trying to do too
much at once.  I thought we agreed that this was going to only contain
the minimum code to make TDX functional.  It seems to be creeping to
grow bigger and bigger.

Am I remembering this wrong?
