Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0771629868B
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 06:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768792AbgJZFbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 01:31:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:20356 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1768759AbgJZFbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 01:31:31 -0400
IronPort-SDR: o9OC74CbH9MdownG5zJsjvi/ywkZcOj7sTgoyI89c/s0saeBNCGjesthziTiyV597j3SyjNFX/
 ZEfNGOK6PYBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9785"; a="229513258"
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="229513258"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2020 22:31:27 -0700
IronPort-SDR: 4azQy4ttURtpUTFedYK+Vd55ONGatSITkNcYg8JSoLWcH1N0wti4GrvqD7aToobM2WNcfaS2n4
 zIuSPOkXgKTg==
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="535232981"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.0.131]) ([10.238.0.131])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2020 22:31:24 -0700
Subject: Re: [RESEND v4 1/2] KVM: VMX: Convert vcpu_vmx.exit_reason to a union
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201012033542.4696-1-chenyi.qiang@intel.com>
 <20201012033542.4696-2-chenyi.qiang@intel.com>
 <20201020220158.GA9031@linux.intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <d547ba33-668e-dce5-9c9b-b24c78ebf9e4@intel.com>
Date:   Mon, 26 Oct 2020 13:31:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201020220158.GA9031@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/21/2020 6:01 AM, Sean Christopherson wrote:
> On Mon, Oct 12, 2020 at 11:35:41AM +0800, Chenyi Qiang wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
>> full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
>> bits 15:0, and single-bit modifiers in bits 31:16.
>>
>> Historically, KVM has only had to worry about handling the "failed
>> VM-Entry" modifier, which could only be set in very specific flows and
>> required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
>> bit was a somewhat viable approach.  But even with only a single bit to
>> worry about, KVM has had several bugs related to comparing a basic exit
>> reason against the full exit reason store in vcpu_vmx.
>>
>> Upcoming Intel features, e.g. SGX, will add new modifier bits that can
>> be set on more or less any VM-Exit, as opposed to the significantly more
>> restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
>> flows isn't scalable.  Tracking exit reason in a union forces code to
>> explicitly choose between consuming the full exit reason and the basic
>> exit, and is a convenient way to document and access the modifiers.
>>
>> No functional change intended.
>>
>> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> This needs your SOB since you are involved in the handling of the patch.
Sorry for the late response, my mailbox encountered some issues...

Will add the SOB here.

> 
