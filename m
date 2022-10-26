Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54ABB60EC8D
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiJZX1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiJZX1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:27:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B02B6036;
        Wed, 26 Oct 2022 16:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826769; x=1698362769;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZnB+REIEGobzyRPEMvBPB0voq0mMNqVo12kGbEKb9c8=;
  b=Xcz10NPVHmMKyRDIpK7UzWrL7VhkolryUNgyuS8cP3G7sbZUOc5fAk8w
   5/Kql6lCqHs/zYokvsNzscc/jduSyRDZr34fagJ2iIAC9p7cd09oo+J7q
   GfQgG+c2YqimX1QaAFHDeZdS4oQakJYr7QMgMJGais56dGAQ+H2bcTqJI
   Vb+p0ddD0VthYEurgVQnzWamyS8fG6rC+eTfHmnxzxl04wEgsAX9GNwqN
   HcZc1l2UrJI0M1Vh8bnLjCRPDJ1C+B0riQODuu6lHd+p/OdtNhQEg2rgV
   0iVHBU+i0Ys0FpqnMqIh+0JY6/jf0O3cpPA9bIP+7KzlN8tHobncYC+2i
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="295493292"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="295493292"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:26:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="701125168"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="701125168"
Received: from smaringa-mobl1.amr.corp.intel.com (HELO [10.209.95.99]) ([10.209.95.99])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:26:07 -0700
Message-ID: <fb2d1c23-df8b-4f7f-ce3f-25ba9076e5fb@intel.com>
Date:   Wed, 26 Oct 2022 16:26:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v6 00/21] TDX host kernel support
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/22 16:15, Kai Huang wrote:
> To keep things simple, this series doesn't handle memory hotplug at all,
> but depends on the machine owner to not do any memory hotplug operation.
> For exmaple, the machine owner should not plug any NVDIMM and CXL memory
> into the machine, or use kmem driver to plug NVDIMM or CXL memory to the
> core-mm.
> 
> This will be enhanced in the future after first submission.  We are also
> looking into options on how to handle:

This is also known as the "hopes and prayers" approach to software
enabling.  "Let's just hope and pray that nobody does these things which
we know are broken."

In the spirit of moving this submission forward, I'm willing to continue
to _review_ this series.  But, I don't think it can go upstream until it
contains at least _some_ way to handle memory hotplug.


