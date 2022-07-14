Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2838057405A
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 02:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiGNAI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 20:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiGNAIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 20:08:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472C76582
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 17:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657757328; x=1689293328;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=ki5PHlrKM6Gnd2/TStMDBDm9MkweGzuZuSr79Ae4FIU=;
  b=P5oKeqEf7z1NqXelzmaMJC1tyRkQIPI68gdp4nkVrIGPrEXBDn6yW3tP
   Rpk8sRSIWkk9eqaqm3K3CPrJDXyauXYCRF/ctCYTDOFFV7TMNpRf23IVi
   DV2846fPg+8bqCyTCndTCh8kWzHW/OpjajZ9v4+s+monKhq5r/xvK5qTB
   KhD7Sfp6TqBrmqVdk6lNRczZgyeyURZsEB9dHKIGw2oPK2VZ3Y17cu/T9
   pZFFDIhWaJi/vkeRPdmBVNPLw+eQ/pz4gLG43NHkf0HttD628E4kBw9v9
   kPia9ptU7IJXlyV40FgfshOVQM/9CoYYQQhM8oFqOL0kw88onCObTlz/i
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="347057285"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="347057285"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 17:08:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="593179728"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.192.101])
  by orsmga007.jf.intel.com with ESMTP; 13 Jul 2022 17:08:47 -0700
Date:   Thu, 14 Jul 2022 08:05:29 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Cc:     kvm@vger.kernel.org
Subject: Re: Regarding TSC scaling in a KVM environment
Message-ID: <20220714000529.GC2881285@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <CAJGDS+Fwy1b1+qm+XFUe9BnGZb1Ga2Q6QQ8XfNp4G=jJuWTRUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJGDS+Fwy1b1+qm+XFUe9BnGZb1Ga2Q6QQ8XfNp4G=jJuWTRUg@mail.gmail.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022 at 11:43:20AM +0530, Arnabjyoti Kalita wrote:
> Dear all,
> 
> How do I know if TSC scaling is being done when a VM is running in KVM
> mode? If TSC scaling is being done, how do I calculate the multiplier
> that needs to be added to host TSC to get guest TSC?

You can check vmx_write_tsc_offset/vmx_write_tsc_multiplier, and then
follow Intel SDM to calculate guest TSC:

(Guest) RDTSC first computes the product of the value of the (Host)
IA32_TIME_STAMP_COUNTER MSR and the value of the TSC multiplier. It
then shifts the value of the product right 48 bits and loads EAX:EDX
with the sum of that shifted value and the value of the TSC offset.

> 
> For more context, I am running IntelPT and collecting Intel PT traces
> when a VM Is running in KVM mode and I see that the TSC values differ
> by a multiplier when the VM is running in root mode (between a vmexit
> and next vmentry) vs non-root mode (between a vmentry and next
> vmexit). I use QEMU - 5.2.0 to run a guest and I use an Intel
> Kaby-Lake microarchitecture.
> 
> For e.g. The first TSC packet that I get from Intel PT when guest is
> in root mode is 0xb24d498c651
> while the first TSC packet that I get from Intel PT when guest is in
> non-root mode is 0x4b41048e77.

TSC value in Intel PT packet in non-root mode follows the same
calculation above.

Chao
> 
> Best Regards,
> Arnabjyoti Kalita
