Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32254F01F8
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 15:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355061AbiDBNLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 09:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349663AbiDBNLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 09:11:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8F8135086;
        Sat,  2 Apr 2022 06:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648904997; x=1680440997;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dvbuIXbkI8htF3qS/EzjnonFbCEyeYOQWdm6UwPCfQ0=;
  b=UvlLU/ZpnJn08MqURcbv8x+2URRoFzf4ZzZAe70qEjGpdkFwjUHbbxVi
   b0Fhn3ddq6sJ8+GSCUqrhgOXVQpXvbipS95oE3q0S6bRGb5wqLB5+AAAm
   ltWuCXZjQI5GBQsOBl51zJ/+/L0xhIAigVVJu1QFb11xQ1PNCkfFwruf6
   e+jgURBDrBkGXj6JaIaKTSYd15jCfiE2xYYWU2tUIs+fU9rs1/S3GsRKR
   PXVHxUf1x1KhROOmWhfdyDNieyZ+EHVaeFsi0CMYibdSmy3NcCQAl0p2U
   N64ts5uewojjXMscDhazZ3mG9OobaOfsCnprfAZD1uQp6RbN9QC3JXyN1
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="257882201"
X-IronPort-AV: E=Sophos;i="5.90,230,1643702400"; 
   d="scan'208";a="257882201"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2022 06:09:56 -0700
X-IronPort-AV: E=Sophos;i="5.90,230,1643702400"; 
   d="scan'208";a="548134833"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.254.208.38]) ([10.254.208.38])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2022 06:09:49 -0700
Message-ID: <bce3708e-d709-6f48-e36f-12f5f804905a@intel.com>
Date:   Sat, 2 Apr 2022 21:09:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 4/8] KVM: VMX: dump_vmcs() reports
 tertiary_exec_control field as well
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-5-guang.zeng@intel.com> <YkYvSHcIrhRgU93l@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YkYvSHcIrhRgU93l@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/1/2022 6:46 AM, Sean Christopherson wrote:
> Nit, shortlog is funky, it'd read better as
>
>    KVM: VMX: Report tertiary_exec_control field in dump_vmcs()
>
> On Fri, Mar 04, 2022, Zeng Guang wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> Add tertiary_exec_control field report in dump_vmcs()
> Please call out the shuffling of PinBased and provide a sample dump.  It's not
> mandatory to put that sort of info in the changelog, but it really does help
> reviewers, e.g. I remember discussing the shuffling and seeing the sample output,
> but other reviewers coming into this blind won't have that luxury.

OK. Will give more details.

