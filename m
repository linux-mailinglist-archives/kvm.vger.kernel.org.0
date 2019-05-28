Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2F02BE82
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 07:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfE1FOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 01:14:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:35832 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfE1FON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 01:14:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 22:14:13 -0700
X-ExtLoop1: 1
Received: from shzintpr02.sh.intel.com (HELO [0.0.0.0]) ([10.239.4.160])
  by orsmga001.jf.intel.com with ESMTP; 27 May 2019 22:14:07 -0700
Subject: Re: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-2-tao3.xu@intel.com>
 <20190527103003.GX2623@hirez.programming.kicks-ass.net>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <43e2a62a-e992-2138-f038-1e4b2fb79ad1@intel.com>
Date:   Tue, 28 May 2019 13:11:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190527103003.GX2623@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 27/05/2019 18:30, Peter Zijlstra wrote:
> On Fri, May 24, 2019 at 03:56:35PM +0800, Tao Xu wrote:
>> This patch adds support for UMONITOR, UMWAIT and TPAUSE instructions
>> in kvm, and by default dont't expose it to kvm and provide a capability
>> to enable it.
> 
> I'm thinking this should be conditional on the guest being a 1:1 guest,
> and I also seem to remember we have bits for that already -- they were
> used to disable paravirt spinlocks for example.
> 

Hi Peter,

I am wondering if "1:1 guest" means different guests in the same host 
should have different settings on user wait instructions?

User wait instructions(UMONITOR, UMWAIT and TPAUSE) can use in guest 
only when the VMCS Secondary Processor-Based VM-Execution Control bit 26 
is 1, otherwise any execution of TPAUSE, UMONITOR, or UMWAIT causes a #UD.

So with a capability to enable it, we use qemu kvm_vm_ioctl_enable_cap() 
to enable it. The qemu link is blew:
https://lists.gnu.org/archive/html/qemu-devel/2019-05/msg05810.html

By using different QEMU parameters, different guests in the same host 
would have different features with or without user wait instructions.

About "disable paravirt spinlocks" case, I am wondering if it uses 
kernel parameters? If it uses kernel parameters, different guests in the 
same host may have same settings on user wait instructions.

Or when we uses kernel parameters to disable user wait instructions, for 
a host chooses to enable user wait instructions, we should do some work 
on QEMU to choose disable or enable user wait instructions?

Thanks

Tao
