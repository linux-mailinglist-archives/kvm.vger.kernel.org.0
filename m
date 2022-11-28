Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5E263B514
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiK1W7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiK1W67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:58:59 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAFF2EF3E;
        Mon, 28 Nov 2022 14:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669676319; x=1701212319;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NqdzenDwRJoM0Q5eOYVe5/eswfY3W7drqgwURMNKSmc=;
  b=hosnQchwuWEFIZOcThO0hYfqDHn5WD6laQKtwR+KbIdFmQASaNIsDyAw
   /AA3+WrjDHzvxK/ELWV9ePIpB20jJW5S+sU+p3dXYFq+7N1pps9lLlW5r
   RlT7sayOWtntAAmr3neqQnVWS7RF1M4RGdO0Tlz46Tyj1AJHzXnWs3UTA
   NehESKAQaZF0PYTwsjaeIy3wEnQWJLKD/E+RgOzZHAApzxQpzJ9svIwF6
   hRLLOs7JZepwyoyd9LYqya/KFfofWw7WsiJqjj2yQcm5F7a6gFHdJrjNR
   UJaIgvyZiZXsagR0WlOGgVfTe3n2U6QPd16BsPjR8PFDVw5lX8i5AJa3H
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="294660275"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="294660275"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:58:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="706974454"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="706974454"
Received: from nroy-mobl1.amr.corp.intel.com (HELO [10.212.209.4]) ([10.212.209.4])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:58:37 -0800
Message-ID: <aa80863f-ab3b-c3d2-917d-b2b7e564a4ff@intel.com>
Date:   Mon, 28 Nov 2022 14:58:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 14/20] x86/virt/tdx: Set up reserved areas for all
 TDMRs
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <5a5644e691134dc72c5e3fb0fc22fa40d4aa0b34.1668988357.git.kai.huang@intel.com>
 <5526fedd-fa54-0ad2-f356-94b167e6e290@intel.com>
 <0ebf26d1ee540b4e082b65c51cabe3327f6d51ac.camel@intel.com>
 <c752d17e-23fd-4452-e1d8-6c82748b6c8a@intel.com>
 <2b3568f3ff472a83c0539aa351cb0c1fec834728.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <2b3568f3ff472a83c0539aa351cb0c1fec834728.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/28/22 14:24, Huang, Kai wrote:
>> I don't know.  I'll look at the naming again once I see it all together.
> Sure. I'll only change the one you mentioned above and keep the others for the
> next version.

The alternative is that you can look at what I suggested, try and learn
something from it, and try to apply that elsewhere in the series before
you post again.
