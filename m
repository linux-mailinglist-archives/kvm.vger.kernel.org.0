Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FE4D6C9C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfJOAsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:48:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:23382 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbfJOAsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:48:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 17:48:07 -0700
X-IronPort-AV: E=Sophos;i="5.67,297,1566889200"; 
   d="scan'208";a="185654823"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 14 Oct 2019 17:48:05 -0700
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
 <20191014183723.GE22962@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <5a7aebc9-2d4d-e202-5f89-8f5f2bc462db@intel.com>
Date:   Tue, 15 Oct 2019 08:48:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014183723.GE22962@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/15/2019 2:37 AM, Sean Christopherson wrote:
> On Mon, Oct 14, 2019 at 06:58:49PM +0200, Vitaly Kuznetsov wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>
>>> They are duplicated codes to create vcpu.arch.{user,guest}_fpu in VMX
>>> and SVM. Make them common functions.
>>>
>>> No functional change intended.
>>
>> Would it rather make sense to move this code to
>> kvm_arch_vcpu_create()/kvm_arch_vcpu_destroy() instead?
> 
> Does it make sense?  Yes.  Would it actually work?  No.  Well, not without
> other shenanigans.
> 
> FPU allocation can't be placed after the call to .create_vcpu() becuase
> it's consumed in kvm_arch_vcpu_init().   FPU allocation can't come before
> .create_vcpu() because the vCPU struct itself hasn't been allocated.  The
> latter could be solved by passed the FPU pointer into .create_vcpu(), but
> that's a bit ugly and is not a precedent we want to set.
> 

That's exactly what I found.

> At a glance, FPU allocation can be moved to kvm_arch_vcpu_init(), maybe
> right before the call to fx_init().
> 

Yeah, putting here is better.

I'm wondering the semantic of create, init, setup. There are 
vcpu_{create,init,setup}, and IIUC, vcpu_create is mainly for data 
structure allocation and vcpu_{init,setup} should be for data structure 
initialization/setup (and maybe they could/should merge into one)

But I feel the current codes for vcpu creation a bit messed, especially 
of vmx.
