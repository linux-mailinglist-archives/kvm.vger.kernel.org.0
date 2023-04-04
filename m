Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E9D6D5627
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 03:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjDDBeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 21:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjDDBeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 21:34:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398863AA5
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 18:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680572048; x=1712108048;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pJ4f3+p4ivCsjlcWIVvjWyW4yA5MeOaZjWywsOXIeEo=;
  b=ZcHFkdzygQi80PEDZRLXPftf8IruEFZemqP3BrhvWEkt++Xa9pvtUDBm
   MbAzQJS9vCrqWydav+9Ss4obif2+GhVoIzN3Qp643WODyuKmnVq1fruNL
   D54R6vGLvDrngXfFKmo/zZXXv2tmZPrkR/kk8DIKSXOdmNiuzZv/hHMPo
   i/UKXCH0ad4Ufs7Bx8UfUAN40qns3RuSSHbQ29gfSH0KEh9zvq4xthbfz
   9RDJV7EgzdgQTTUxm4PzriMBLregVyzxEEP9k8Y67uNHtyfAi7c66YRhT
   0A7ku4FPh3+HJ3A925+EpwCu3r1zVFjsBGxSwDhY7vtfOOJYBMBzCNPIB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="342085542"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="342085542"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 18:31:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="663403074"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="663403074"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.140]) ([10.254.215.140])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 18:31:36 -0700
Message-ID: <dafd7f36-0b6c-8390-5818-fe32a9dcba78@linux.intel.com>
Date:   Tue, 4 Apr 2023 09:31:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com> <ZBhTa6QSGDp2ZkGU@gao-cwp>
 <ZBojJgTG/SNFS+3H@google.com>
 <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
 <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
 <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
 <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
 <ZCR2PBx/4lj9X0vD@google.com>
 <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
 <349bd65a-233e-587c-25b2-12b6031b12b6@linux.intel.com>
 <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/3/2023 7:24 PM, Huang, Kai wrote:
>> I checked the code again and find the comment of
>> nested_vmx_check_permission().
>>
>> "/*
>>    * Intel's VMX Instruction Reference specifies a common set of
>> prerequisites
>>    * for running VMX instructions (except VMXON, whose prerequisites are
>>    * slightly different). It also specifies what exception to inject
>> otherwise.
>>    * Note that many of these exceptions have priority over VM exits, so they
>>    * don't have to be checked again here.
>>    */"
>>
>> I think the Note part in the comment has tried to callout why the check
>> for compatibility mode is unnecessary.
>>
>> But I have a question here, nested_vmx_check_permission() checks that
>> the vcpu is vmxon,
>> otherwise it will inject a #UD. Why this #UD is handled in the VMExit
>> handler specifically?
>> Not all #UDs have higher priority than VM exits?
>>
>> According to SDM Section "Relative Priority of Faults and VM Exits":
>> "Certain exceptions have priority over VM exits. These include
>> invalid-opcode exceptions, ..."
>> Seems not further classifications of #UDs.
> This is clarified in the pseudo code of VMX instructions in the SDM.  If you
> look at the pseudo code, all VMX instructions except VMXON (obviously) have
> something like below:
>
> 	IF (not in VMX operation) ...
> 		THEN #UD;
> 	ELSIF in VMX non-root operation
> 		THEN VMexit;
>
> So to me "this particular" #UD has higher priority over VM exits (while other
> #UDs may not).
>
> But IIUC above #UD won't happen when running VMX instruction in the guest,
> because if there's any live guest, the CPU must already have been in VMX
> operation.  So below check in nested_vmx_check_permission():
>
> 	if (!to_vmx(vcpu)->nested.vmxon) {
>                  kvm_queue_exception(vcpu, UD_VECTOR);
>                  return 0;
>          }
>
> is needed to emulate the case that guest runs any other VMX instructions before
> VMXON.
>
Yes, you are right. Get the point now, thanks.


