Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A39D695508
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 00:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjBMXwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 18:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjBMXwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 18:52:14 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1645E1632D;
        Mon, 13 Feb 2023 15:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676332333; x=1707868333;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4fzPXXlr+NKT3FMdKI22Byml/iVzpZd9hBiHmFnYHyY=;
  b=Wq1Q3WTeYGlJNoqg9vqUC/WzlY3c8z2l/d2DTQY9SV3NCtH4cJX7xz/1
   7gTwJmAjptj7O5HMQEffc6NPAYJvJIbV98yoyzuULI8BQ6Urri9Q7ZLD+
   rrRYt46xI/cF5acyk1U0hVJjwKQT3O1pzvV8FJYL54CKWwEnBHCpsLWy3
   dM2oX//M5c3/IAhZAteEaMmfoJ1M8qYtoPYIVIiYqLQmxYgZMqzzuM9yy
   Whd2v35tHGjDHI0P75O1HDPGU7nv2bSyBXCpIfsK2B/CHBF+yW0WNtCum
   Pel3v/ck+j848rOqrA6BDuEuzxveN/79Y4XvOLR0okZnxTobElmqMz3UW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="417248470"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="417248470"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 15:52:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="792905130"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="792905130"
Received: from mlswanso-mobl.amr.corp.intel.com (HELO [10.251.26.232]) ([10.251.26.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 15:52:11 -0800
Message-ID: <5803a3f2-72c8-fb1e-9ba3-e52747c990d3@intel.com>
Date:   Mon, 13 Feb 2023 15:52:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
 <2d9172c5-e1e7-bf94-c52b-0e9bc5b5b319@intel.com>
 <BL1PR11MB5978F562548EA22BFFD13970F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
 <2d7141b1-1d76-4e67-60d2-471a524c372e@intel.com>
 <8e9238bbcccedfa00e2dbec87e1d77d370911846.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <8e9238bbcccedfa00e2dbec87e1d77d370911846.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 15:43, Huang, Kai wrote:
> ( My main concern is "Run after the KVM handler" seems a little bit hacky to me.
> Logically, it's more reasonable to have the TDX callback _before_ KVM's but not
> _after_.  If any user (KVM) has done tdx_enable() successfully, the TDX code
> should give the user a "TDX-runnable" cpu before user (KVM)'s own callback is
> involved. Anyway as mentioned above, I'll do above as you suggested.)

I was assuming that the KVM callback is what does VMXON for a given
logical CPU.  If that were the case, you'd need to do the TDX stuff
*AFTER* VMXON.

Am I wrong?


