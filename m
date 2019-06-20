Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2E64C9FF
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 10:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbfFTIzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 04:55:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:60921 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731736AbfFTIzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 04:55:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 01:55:09 -0700
X-IronPort-AV: E=Sophos;i="5.63,396,1557212400"; 
   d="scan'208";a="154057431"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 20 Jun 2019 01:55:07 -0700
Subject: Re: [PATCH] KVM: vmx: Fix the broken usage of vmx_xsaves_supported
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>, Tao Xu <tao3.xu@intel.com>
Cc:     Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190620050301.1149-1-tao3.xu@intel.com>
 <CANRm+Cwg7ogTN1w=xNyn+8CfxwofdxRykULFe217pXidzEhh6Q@mail.gmail.com>
 <f358c914-ae58-9889-a8ef-6ea9f3b2650e@linux.intel.com>
 <b3f76acd-cc7e-9cd7-d7f7-404ba756ab87@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
Message-ID: <2032f811-b583-eca1-3ece-d1e95738ff64@linux.intel.com>
Date:   Thu, 20 Jun 2019 16:55:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <b3f76acd-cc7e-9cd7-d7f7-404ba756ab87@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/2019 4:17 PM, Paolo Bonzini wrote:
> On 20/06/19 08:46, Xiaoyao Li wrote:
>>>
>>> It depends on whether or not processors support the 1-setting instead
>>> of “enable XSAVES/XRSTORS” is 1 in VM-exection control field. Anyway,
>>
>> Yes, whether this field exist or not depends on whether processors
>> support the 1-setting.
>>
>> But if "enable XSAVES/XRSTORS" is clear to 0, XSS_EXIT_BITMAP doesn't
>> work. I think in this case, there is no need to set this vmcs field?
> 
> vmx->secondary_exec_control can change; you are making the code more
> complex by relying on the value of the field at the point of vmx_vcpu_setup.
> 
At this point. Agreed. It's harmless to set a default value.

> I do _think_ your version is incorrect, because at this point CPUID has
> not been initialized yet and therefore
> vmx_compute_secondary_exec_control has not set SECONDARY_EXEC_XSAVES.

SECONDARY_EXEC_XSAVES is in the opt when setup_vmcs_config, and 
vmx_compute_secondary_exec_control() is to clear SECONDARY_EXEC_XSAVES 
based on guest cpuid.

> However I may be wrong because I didn't review the code very closely:
> the old code is obvious and so there is no point in changing it.

you mean this part about XSS_EXIT_BITMAP? how about the other part in 
vmx_set/get_msr() in this patch?

> Paolo
> 
