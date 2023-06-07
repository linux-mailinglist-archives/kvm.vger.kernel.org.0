Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FED4726285
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 16:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbjFGOQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 10:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240039AbjFGOQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 10:16:00 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD9F1BEA;
        Wed,  7 Jun 2023 07:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686147358; x=1717683358;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iQiCIoJzhIO4mN9Mh3ygJf9p/9Yr66SOAT+qlykhdT8=;
  b=SiGtxUCVRtdRS1liazLn6mNl7F4KB4rwujD347NGYkgxjSQdEElCOTSm
   yW9GavB66chIH48HB9nZOx3SfrBykW+OoRqr/8PlnGCFqDbwMigY4RbS+
   AiZv4ByEIrHMjwn4Xo8nDkGUyCgjRAVq+LaEyBV9Mqpv5/4hEng1nNd8U
   6WyuPoPZ+EDA3XivQhrqLuoxMGN8ZALLgKkaFSSKQR7OX4wDdGfB8n4+Q
   Xt+/eGuaE2zAUzLvMQZ6rvFcKoEHMkOrbF5Q9oHCTTWaSJCBVpgncpE/F
   CIfu09kTao1nHKL1pfOnROOwr6+OdX9AfyRMX3LgoQkVuNDGn4NHKLLUs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="355851828"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="355851828"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 07:15:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="822171650"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="822171650"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 07:15:55 -0700
Message-ID: <bf797bc6-e264-02b0-12ee-c2ebf7c92d22@intel.com>
Date:   Wed, 7 Jun 2023 07:15:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
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
 <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
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
> TDX memory has integrity and confidentiality protections.  Violations of
> this integrity protection are supposed to only affect TDX operations and
> are never supposed to affect the host kernel itself.  In other words,
> the host kernel should never, itself, see machine checks induced by the
> TDX integrity hardware.

At the risk of patting myself on the back by acking a changelog that I
wrote 95% of:

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>

