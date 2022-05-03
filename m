Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C24517C04
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 04:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiECCsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 22:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiECCse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 22:48:34 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65624369FB;
        Mon,  2 May 2022 19:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651545904; x=1683081904;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/bNB+zpgktSurx6RJChgfpna9Tyajeuzw4/vl6QYpPw=;
  b=TG+cNY6+i7y/I06nmNHCGPOefEvbtG/Dap6aT0FrKhvuCFLE+T1ueAL1
   ZljzBvHbDFBOCthr/WPlRBk3ICZTVAKw7XeoLlQSYZIcuJA3N9goWsU+6
   DDgg2ItbmS573ylI+wTXPXrIJt7ENnweIGw9XHN43O9eNCe5oQzFAIhbl
   S3FQSwJoONK63FbVHPBuGhrRZHCh6hUC7WwAGRtrik170E402ckTeXvG8
   THQP39Vtbqm+wXkAfufjhczHM6SJVx10Yn5auWHMxqcatefTh9pqFCuC8
   o2nmMAAQcPz9iNPZ5LuRCEQUsbIcY+7RgZcnMFDVDWAd2rUQ9F6kCjtg+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="292568132"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="292568132"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 19:45:04 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="584008817"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.252.188.134]) ([10.252.188.134])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 19:44:58 -0700
Message-ID: <ad1ede19-3b48-818a-5c6e-bab37e5c5539@intel.com>
Date:   Tue, 3 May 2022 10:44:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v9 9/9] KVM: VMX: enable IPI virtualization
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
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
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20220419154510.11938-1-guang.zeng@intel.com>
 <bcb2a90f-a2ed-94fa-985e-d7b9efe52ae4@redhat.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <bcb2a90f-a2ed-94fa-985e-d7b9efe52ae4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/2022 12:16 AM, Paolo Bonzini wrote:
> On 4/19/22 17:45, Zeng Guang wrote:
>> +static bool vmx_can_use_pi_wakeup(struct kvm_vcpu *vcpu)
>> +{
>> +	/*
>> +	 * If a blocked vCPU can be the target of posted interrupts,
>> +	 * switching notification vector is needed so that kernel can
>> +	 * be informed when an interrupt is posted and get the chance
>> +	 * to wake up the blocked vCPU. For now, using posted interrupt
>> +	 * for vCPU wakeup when IPI virtualization or VT-d PI can be
>> +	 * enabled.
>> +	 */
>> +	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
>> +}
> Slightly more accurate name and comment:
>
> static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
> {
>           /*
>            * The default posted interrupt vector does nothing when
>            * invoked outside guest mode.   Return whether a blocked vCPU
>            * can be the target of posted interrupts, as is the case when
>            * using either IPI virtualization or VT-d PI, so that the
>            * notification vector is switched to the one that calls
>            * back to the pi_wakeup_handler() function.
>            */
>           return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
> }
>
>
> Paolo
Thanks. It's much accurate and better to describe the functionality of 
this API.
I will change it.
