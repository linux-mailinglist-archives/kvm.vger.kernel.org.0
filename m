Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513DE50EE8E
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 04:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241129AbiDZCPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 22:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbiDZCPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 22:15:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDF338780;
        Mon, 25 Apr 2022 19:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650939129; x=1682475129;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IJj6FwOpcpLQHX+fWpYg9qL+omehrBDi1oT+RhQ57j4=;
  b=E9GNMQo1bppPBkAt/UYmpf8JLbKrxJFYzkJO/C+Gzc8+1ojyF5Myzebt
   kw197Dr5Crrmu+33c+pkHERXY/4uWQ++gDPkWL5gPDrOrXTuAPpP1RX5h
   vKGnnF0hoJL/Mbxwc9/8OWBAjnLJpcd5FhsvfUOlvaxwALCAQFoI0FGGU
   4tIpNASZjRg2dQt8+CBWIJDJqNt+ZKB88h7RKVgO6PTZ+r9nERaEq0poq
   baHflfgyOV8DIiPFHu6bR1jFy/pRXUDzPQX8tbsOX8aJWoPs8IE02m5KC
   jlAFZWPWDSutO1zx8Z4AXWna2tXN6W/tPhYEyPGbbAvjcI84bnHeexZJp
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="265587963"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="265587963"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 19:12:09 -0700
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="616779361"
Received: from kculcasi-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.59.214])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 19:12:06 -0700
Message-ID: <c1e8b972edcb40f9b8ab1404d3b39974c4547f48.camel@intel.com>
Subject: Re: [PATCH v3 06/21] x86/virt/tdx: Shut down TDX module in case of
 error
From:   Kai Huang <kai.huang@intel.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
Date:   Tue, 26 Apr 2022 14:12:04 +1200
In-Reply-To: <c3619404-e1d7-6745-0ecc-a759d57d60bf@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <3f19ac995d184e52107e7117a82376cb7ecb35e7.1649219184.git.kai.huang@intel.com>
         <82d3cb0b-cebc-d1da-abc1-e802cb8f8ff8@linux.intel.com>
         <e14da6ed4520bc2362322434b1b4b336f079f3b7.camel@intel.com>
         <c3619404-e1d7-6745-0ecc-a759d57d60bf@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > 
> > Prevent all SEAMCALLs on other LPs except TDH.SYS.LP.SHUTDOWN.  The spec defnies
> > shutting down the TDX module as running this SEAMCALl on all LPs, so why just
> > run on a single cpu?  What's the benefit?
> 
> If executing it in one LP prevents SEAMCALLs on all other LPs, I am
> trying to understand why spec recommends running it in all LPs?

Please see 3.1.2 Intel TDX Module Shutdown and Update

The "shutdown" case requires "Execute On" on "Each LP".

Also, TDH.SYS.LP.SHUTDOWN describe this is shutdown on *current* LP.
 
> 
> But the following explanation answers my query. I recommend making a
> note about  it in commit log or comments.

Is above enough to address your question?



-- 
Thanks,
-Kai


