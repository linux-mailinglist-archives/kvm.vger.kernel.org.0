Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566E34873DE
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 09:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbiAGIF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 03:05:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:37599 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235551AbiAGIF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 03:05:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641542757; x=1673078757;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OL4Ca5sxaqttlyUaMRczDGcqztUS045ixqCnOLN6DU4=;
  b=hhoDRjbrjjIRcB1SW5Na+T2gU0XymxY/EQ0rvnPen+qbeAtkAeutyFTw
   4Ur6Lbp5U2fsCY2vm3RHqd7wHKqqPaxY6Pp1EPj7Qal0mAfseuqIWFRh9
   RzU41rHzJloFyCBNC88fyJtYDtfMNq45Mb5LJuglUiG48eOvN9dTVtjRa
   gc/+RnljCHPsmy5PDLxyX2jg4Wk7LchQdNvmVoXTzo1YxztxglO330Duo
   rbM3WF020WoouzBQGt88rWdILqzA7BPgJDeTAAftrZtIhYWzxOFBpY1iD
   fvWZvERrfj9jFXbROETsfjfIz7fu9nBuUMzoZrYhCm9AIHex9ULdAQqJu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="267123695"
X-IronPort-AV: E=Sophos;i="5.88,269,1635231600"; 
   d="scan'208";a="267123695"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 00:05:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,269,1635231600"; 
   d="scan'208";a="763777486"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.209.114]) ([10.254.209.114])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 00:05:36 -0800
Message-ID: <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
Date:   Fri, 7 Jan 2022 16:05:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when APIC
 ID is changed
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-8-guang.zeng@intel.com>
 <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
 <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
 <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/2022 10:06 PM, Tom Lendacky wrote:
> On 1/5/22 7:44 PM, Zeng Guang wrote:
>> On 1/6/2022 3:13 AM, Tom Lendacky wrote:
>>> On 12/31/21 8:28 AM, Zeng Guang wrote:
>>> Won't this blow up on AMD since there is no corresponding SVM op?
>>>
>>> Thanks,
>>> Tom
>> Right, need check ops validness to avoid ruining AMD system. Same
>> consideration on ops "update_ipiv_pid_table" in patch8.
> Not necessarily for patch8. That is "protected" by the
> kvm_check_request(KVM_REQ_PID_TABLE_UPDATE, vcpu) test, but it couldn't hurt.

OK, make sense. Thanks.

> Thanks,
> Tom
>
>> I will revise in next version. Thanks.
>>>> +        } else
>>>>                 ret = 1;
>>>>             break;
>>>>
