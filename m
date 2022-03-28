Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DFF4EA3E1
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 01:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiC1Xqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 19:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiC1Xqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 19:46:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1551B79F;
        Mon, 28 Mar 2022 16:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648511091; x=1680047091;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=3jk71mGBq4jweO0Vzo+J+A884TrUY4CUV/3JBmqa96o=;
  b=XA9wbtBBT3JoTkCdk04xzKLLQdSUrwxqzeBBqV950rsbrlzQN7l8n6Ka
   DKzVi4fhaovr3TLF6IiyrO2sbg+DVfvm7MWvszQC29finEPyb8ZkNeRmh
   lwSgbKKoe6ozM4oZuGOWV37MzyN9Xdw8eP8D1+r5tZkdJyF6a7tXsw+bN
   7S4coHE4Adxr/lGC6+hSckUcwqq3YqgyDd0iSxdMhUO9yGH7WtQyV2cQX
   5A2V1rJsgJuhp0iwwO5uR3O4iPBeUg+MDow+EJsV89Mno0JCdBTExJo+D
   5jnwwCUqJyoY5SIgO5jP/Dx+eRLGEol9okx7hM/L3MzTRolvNYp8Sj7kJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="246613670"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="246613670"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 16:44:50 -0700
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="832670327"
Received: from weiweihx-mobl.amr.corp.intel.com (HELO [10.255.229.113]) ([10.255.229.113])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 16:44:49 -0700
Message-ID: <f0b7ecb0-a0f1-95f3-4594-bc19eab4d2f2@intel.com>
Date:   Mon, 28 Mar 2022 16:44:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com
References: <cover.1647167475.git.kai.huang@intel.com>
 <98c1010509aa412e7f05b12187cacf40451d5246.1647167475.git.kai.huang@intel.com>
 <20220324174301.GA1212881@ls.amr.corp.intel.com>
 <f211441a6d23321e22517684159e2c28c8492b86.camel@intel.com>
 <20220328202225.GA1525925@ls.amr.corp.intel.com>
 <60bf1aa7-b004-0ea7-7efc-37b4a1ea2461@intel.com>
 <9d8d20f62f82e052893fa32368d6a228a2140728.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v2 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
In-Reply-To: <9d8d20f62f82e052893fa32368d6a228a2140728.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/28/22 16:40, Kai Huang wrote:
> Btw if you have time, could you help to review this series? Or could you take a
> look at whether the overall design is OK, for instance, the design limitations
> described in the cover letter?

Kai, it's on my list, but it's a long list.

If you want to help, there are at least two other *big* TDX patch sets
out there that need eyeballs:

> https://lore.kernel.org/all/20220318153048.51177-1-kirill.shutemov@linux.intel.com/

and

> https://lore.kernel.org/all/20220310140911.50924-1-chao.p.peng@linux.intel.com/

