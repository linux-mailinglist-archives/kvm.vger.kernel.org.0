Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44715535D88
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 11:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350657AbiE0JmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 05:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiE0JmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 05:42:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13CA3E5EE;
        Fri, 27 May 2022 02:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653644529; x=1685180529;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dbtnMI3UHVoIrRQqCtwR7FgwcIVnGGpefctdsCFMNWY=;
  b=iaa+qDmZgWlPfunctFq2ZrO6skAC979t2Twv+qQSGsoGAgEu3noRlPM+
   7nEsoKzr+j8/KhuNmFBQz6W5OvBx261aUT4YU3/rXJJlx0JTpOujR7IkL
   LMSB4Lvjb1PR+DfChMAcA0ayGQN9LKrYvuHVJd59+0pBqyBCU0g5eZj/O
   tPQCOd/f7zU1lX89xlaZcnGNqr40zCAhx8/kali6sDpHdILdeqdvj0k90
   v9Q1/P1rEMK8tQnBSQr2LWbX0NcMeeNriVlbGg6oIEXAfvZI7IwJ6nXk4
   z5yGeM2xiKm4zc2jcLH0YtwYfHY9GtjnDsUY7+iKyRdsRgXcL2El6dtbV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="360822039"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="360822039"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:42:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="705045135"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.211.236]) ([10.254.211.236])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:42:06 -0700
Message-ID: <e751ff56-5e0d-e842-78ed-b9c7e9069a26@intel.com>
Date:   Fri, 27 May 2022 17:42:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH v7 7/8] KVM: VMX: Expose PKS to guest
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-8-lei4.wang@intel.com> <Yo1rfrnV5nObIHJK@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <Yo1rfrnV5nObIHJK@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/2022 7:34 AM, Sean Christopherson wrote:
> On Sun, Apr 24, 2022, Lei Wang wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 9d0588e85410..cbcb0d7b47a4 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -3250,7 +3250,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>   		}
>>   
>>   		/*
>> -		 * SMEP/SMAP/PKU is disabled if CPU is in non-paging mode in
>> +		 * SMEP/SMAP/PKU/PKS is disabled if CPU is in non-paging mode in
>>   		 * hardware.  To emulate this behavior, SMEP/SMAP/PKU needs
> Heh, missed one ;-)  Let's reduce future pain and reword this whole comment:
>
> 		/*
> 		 * SMEP/SMAP/PKU/PKS are effectively disabled if the CPU is in
> 		 * non-paging mode in hardware.  To emulate this behavior,
> 		 * clear them in the hardware CR4 when the guest switches to
> 		 * non-paging mode and unrestricted guest is disabled, as KVM
> 		 * must run the guest with hardware CR0.PG=1.
> 		 */
>
Nice catch, will fix it ;-)
