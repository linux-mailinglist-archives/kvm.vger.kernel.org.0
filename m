Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA7A494AC4
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359532AbiATJbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:31:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:42202 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbiATJbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 04:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642671066; x=1674207066;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xsLxbcvug6yuYBnZbk4YIkMK+aPFfKOo/QWL7Rz1Tog=;
  b=Lu4k1qPmeZNwLkWR0SojCSwHn9+IB50XpimZOUiTke6xbEn7pIKYHXPh
   FFnBzCOoYnrqX5tXFcmdN25A85PMW6xvjYmU1Crj51Y7hO4hQlaiWABXX
   mM/DOy0/dXBb2Uw9VH8cQqC5PBQADZRMt6+brl4BILCzDw36phGZUgzrd
   G+OuDppSzzP737Rszzv1Cps8+Wolx7hJxDjektX56uKtVIQKs5afXKbjv
   b5wJVNfRbEKfFwCGKiED33lFhdcPfMs1pXkT2o8452wGR1Lf1QD+VmPY6
   /VUSUg728+1vXe9PTPkYHpnXDlaVVx2MqnVp0gm1MqdueuJr5nEM7Nta0
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="269709792"
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="269709792"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 01:31:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="626229514"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.51]) ([10.255.29.51])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 01:31:03 -0800
Message-ID: <d0855fb0-4e98-1090-a230-132b08864ed3@intel.com>
Date:   Thu, 20 Jan 2022 17:31:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [DROP][PATCH] KVM: x86: Fix the #GP(0) and #UD conditions for
 XSETBV emulation
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Jun Nakajima <jun.nakajima@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117072456.71155-1-likexu@tencent.com>
 <a133d6e2-34de-8a41-475e-3858fc2902bf@redhat.com>
 <9c655b21-640f-6ce8-61b4-c6444995091e@gmail.com>
 <0d7ed850-8791-42b4-ef9a-bbaa8c52279e@redhat.com>
 <92b16faf-c9a7-4be3-43f7-3450259346e9@gmail.com>
 <19c4168f-c65b-fc9a-fe4c-152284e18d30@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <19c4168f-c65b-fc9a-fe4c-152284e18d30@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/2022 5:17 PM, Paolo Bonzini wrote:
> On 1/20/22 08:48, Like Xu wrote:
>>
>> In the testcase "executing XSETBV with CR4.XSAVE=0",
>>
>> - on the VMX, #UD delivery does not require vm-exit;
> 
> Not your fault, it would be nicer if the Intel manual told the truth;
> it says: "The following instructions cause VM exits when they are
> executed in VMX non-root operation: CPUID, GETSEC[1], INVD, and XSETBV."
> 
> Footnote [1] says "An execution of GETSEC causes an invalid-opcode
> exception (#UD) if CR4.SMXE[Bit 14] = 0", and there is no such footnote
> for XSETBV.  Nevertheless, when tracing xsave.flat, I see that there's
> a #UD vmexit and not an XSETBV vmexit:
> 
>          qemu-kvm-1637698 [019] 758186.750321: kvm_entry:            
> vcpu 0, rip 0x4028b7
>          qemu-kvm-1637698 [019] 758186.750322: kvm_exit:             
> vcpu 0 reason EXCEPTION_NMI rip 0x40048d info1 0x0000000000000000 info2 
> 0x0000000000000000 intr_info 0x80000306 error_code 0x00000000
>          qemu-kvm-1637698 [019] 758186.750324: kvm_emulate_insn:     
> 0:40048d:0f 01 d1 (prot64)
>          qemu-kvm-1637698 [019] 758186.750325: kvm_inj_exception:    #UD 
> (0x0)
> 
> So while my gut feeling that #UD would not cause a vmexit was correct,
> technically I was reading the SDM incorrectly.

SDM also states

   Certain exceptions have priority over VM exits. These include
   invalid-opcode exception, faults based on privilege level,
   and general-protection exceptions that are based on checking
   I/O permission bits in the task-state segment(TSS)

in "Relative Priority of Faults and VM Exits"

So my understanding is that the architectural check always takes the 
higher priority than VM exit.

> Jun, can you have this fixed?
> 
> Paolo
> 
>> - on the SVM, #UD is trapped but goes to the ud_interception() path;
> 

