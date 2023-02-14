Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D17696B69
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 18:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbjBNR1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 12:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbjBNR1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 12:27:46 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE9D11145;
        Tue, 14 Feb 2023 09:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676395665; x=1707931665;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yZsb661tWCLwnocD20FKd7DOPUGLL0+6VD/zwTue5lo=;
  b=QtuB3s3JgWt2e/uO+McM1uySvtZbHXKDbD3GE6lo/qUax3mR6X8/nc5F
   weGUsk8DQgeFof6CL7Q1HF+G4vPRijG49BJVjZoyeyWsM7vsEXV6apG7l
   A4XKNHwGvh31R4I1ctml1mNudeSy1bvgRxOCee6bvNEsi1UNA3wpaZh88
   pJqjssILIOr4pnL4iyRORyOL6vf7Ikce7NcIG0K1ZqY7w6h0pi85SmRMU
   jeE3Bh12YV3REPYL7A8PHEPRMlVUHxnAzEvyDnrGtklS7qivOKtG4HDy1
   fFol0+/ZnhyWNiuCdMZUBKIe9+UscZvaHW3mnw+xifmvhqFFYN2Osi0Nl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="395829785"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="395829785"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:27:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="701703536"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="701703536"
Received: from jklechel-mobl1.amr.corp.intel.com (HELO [10.212.244.208]) ([10.212.244.208])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:27:44 -0800
Message-ID: <5f29c397-d723-a18e-e0f0-660f9f22d998@intel.com>
Date:   Tue, 14 Feb 2023 09:27:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
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
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
 <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
 <37d5736e-93b1-aed1-c21c-07fe1044f2d0@intel.com>
 <f834ed91cba9fb7b14810fcc8ba0ae68b9b0e2d0.camel@intel.com>
 <16470ac19325d99947bad3d4b16f6982b0facafc.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <16470ac19325d99947bad3d4b16f6982b0facafc.camel@intel.com>
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

On 2/14/23 00:57, Huang, Kai wrote:
> Consider this case:
> 
>         1) KVM does VMXON for all online cpus (a VM created)
>         2) Another kernel component is calling tdx_enable()
>         3) KVM does VMXOFF for all online cpus (last VM is destroyed)

Doctor, it hurts when I...

Then let's just call tdx_enable() from other kernel components.

Kai, I'm worried that this is, again, making things more complicated
than they have to be.
