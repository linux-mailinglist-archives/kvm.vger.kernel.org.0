Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028434CA962
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 16:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbiCBPrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 10:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240275AbiCBPq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 10:46:56 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF816CB650;
        Wed,  2 Mar 2022 07:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646235972; x=1677771972;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uDEmAHta6/0fV9EWeWY03MnT0yAmLB5e+vpiDUmduww=;
  b=IfsD9ZSYC9ARSYlKrsSzT47UFFEcPu3/m73ZfFhI1jVc1pc+bea0NI9E
   DKcBs0D70UQvmXxAtgwO2mU+Ba0KMDyuE/SXBzbqOBtO3H//dvgFjCiPo
   7BYEUFbvnhffvWM03Z/7j29Tw12RyW6SqDr6wWeXE8A3i4cxrX6kaUM6d
   FyBoAsd/BLc/rD6EW6jsJnwMZ/KMG/w65dO/NRxUD1jAq7b04VyrNYr9F
   zkMQF45kYZpsaozlpDhXs1JwwO4y5jKy4w3H5Z2xkZOOCFHBWFHk8RQij
   d82Sr+uL5HiJqsdbsTW49lK9SmuuOu4lD4mfWnYLlciRatGz8NBd+Z1CA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="234047279"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="234047279"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:46:12 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="551299872"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:46:08 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nPRAG-00AMkQ-Ql;
        Wed, 02 Mar 2022 17:45:20 +0200
Date:   Wed, 2 Mar 2022 17:45:20 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
Message-ID: <Yh+REPSQd1zX8KlQ@smile.fi.intel.com>
References: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 06:44:20PM +0200, Andy Shevchenko wrote:
> While in this particular case it would not be a (critical) issue,
> the pattern itself is bad and error prone in case somebody blindly
> copies to their code.
> 
> Don't cast parameter to unsigned long pointer in the bit operations.
> Instead copy to a local variable on stack of a proper type and use.

After looking into other similar cases I may conclude they
- need to be fixed
- out of scope of this change

Hence, can this fix be applied?

-- 
With Best Regards,
Andy Shevchenko


