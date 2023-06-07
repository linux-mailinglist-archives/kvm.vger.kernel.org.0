Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D12D7269C7
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjFGT15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjFGT1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:27:41 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A40E1FFE;
        Wed,  7 Jun 2023 12:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686166055; x=1717702055;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C5/DBo2//H0j7nbciEl3wuHVykl9Cm9+hIV0EICckm4=;
  b=c+ou6Y+m4dQHE6wONVvAEYsl/qVmsCflUanwhWUcYEIGTzXPR76cFzul
   9zQSydrJf8CNAMrwdM5/WIFH6dLz+O+EdG12SIGChdFo0ecMbC/NGSh3K
   gfCDqUiYARPIAR+a3cOBPvKBIDstdMNxes1mgG4ycT9C9Zi6C/1RXiz6M
   LSLtOwREzG0rtM1FrEn75iCWTlYtbqtl6bI+STU7snxQwu7/p+7cIWIW+
   r+6IKbeXv7WM+pLqF3kEDUvKv3helWfTFZ7ASv2+ObrB3p5B21C4KGda7
   phEUJvcyJpWa+Opot9RLzqw4pA7cjVBhFedZpJidOH9V+mHAOK/QcR8OC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="385419336"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="385419336"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 12:27:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="712801292"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="712801292"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 12:27:33 -0700
Message-ID: <f7ef157e-8f26-8d7b-a9b8-cb8de7f7aa2b@intel.com>
Date:   Wed, 7 Jun 2023 12:27:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
 <20230607185355.GH2244082@ls.amr.corp.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230607185355.GH2244082@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/23 11:53, Isaku Yamahata wrote:
>>> VMX enabling, and KVM is the only user of TDX.  This implementation
>>> chooses to make KVM itself responsible for enabling VMX before using
>>> TDX and let the rest of the kernel stay blissfully unaware of VMX.
>>>
>>> The current TDX_MODULE_CALL macro handles neither #GP nor #UD.  The
>>> kernel would hit Oops if SEAMCALL were mistakenly made w/o enabling VMX
>>> first.  Architecturally, there is no CPU flag to check whether the CPU
>>> is in VMX operation.  Also, if a BIOS were buggy, it could still report
>>> valid TDX private KeyIDs when TDX actually couldn't be enabled.
>> I'm not sure this is a great justification.  If the BIOS is lying to the
>> OS, we _should_ oops.
>>
>> How else can this happen other than silly kernel bugs.  It's OK to oops
>> in the face of silly kernel bugs.
> TDX KVM + reboot can hit #UD.  On reboot, VMX is disabled (VMXOFF) via
> syscore.shutdown callback.  However, guest TD can be still running to issue
> SEAMCALL resulting in #UD.
> 
> Or we can postpone the change and make the TDX KVM patch series carry a patch
> for it.

How does the existing KVM use of VMLAUNCH/VMRESUME avoid that problem?
