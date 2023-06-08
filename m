Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060727280F7
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 15:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbjFHNPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 09:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbjFHNPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 09:15:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10AB26B3;
        Thu,  8 Jun 2023 06:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686230134; x=1717766134;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RHNSvXgy1i6qqzbOx4uNw2Wdc/hsK8aF/91zZPsKL3A=;
  b=CenOV2gncCGv4rOBhIfadWlucSXeeMoZkbQ7vvm/aF3lbHNIBsSuhaKc
   Y9tUXuKosveKmwzoqEG4Z0ozkPonyvfhJE3FBhnd/YMveBVcEO48P/FOG
   oGt/Kp03a/qNBRTMQCIt0iygKSynSBfDLh1BAR479D/HVsDFq11CKbp+5
   DKUocFfP6uKi14fVtDkX2nNbcSD3G+SZMEmwa/wTYholeoRBvK98QsqtY
   yPkdjXOmigWu/A0I4SlDMoubIoHd9BIHsiGm3rAyHwQNt3/v5+oI5pHwp
   Td8ICKLok2Tsmo8CYyTk5r8VdO5il10jWWfZNdOpyu83RICY/4F291ECC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="337660974"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="337660974"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 06:13:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="854337488"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="854337488"
Received: from swalker-mobl1.amr.corp.intel.com (HELO [10.209.22.184]) ([10.209.22.184])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 06:13:10 -0700
Message-ID: <c185d685-4a07-6260-57c8-e36b4671beb8@intel.com>
Date:   Thu, 8 Jun 2023 06:13:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Content-Language: en-US
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
 <20230608002725.xc25dantcwdxsuil@box.shutemov.name>
 <19ea7470e9d6fa698f9ad7caff3279873e530a0b.camel@intel.com>
 <20230608114128.vu75wlcojpyjak22@box.shutemov.name>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230608114128.vu75wlcojpyjak22@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/23 04:41, kirill.shutemov@linux.intel.com wrote:
> These structures take 1.5K of memory and the memory will be allocated for
> all machines that boots the kernel with TDX enabled, regardless if the
> machine has TDX or not. It seems very wasteful to me.

Actually, those variables are in .bss.  They're allocated forever for
anyone that runs a kernel that has TDX support.


