Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F228190CBF
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 12:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgCXLvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 07:51:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:2897 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgCXLvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 07:51:25 -0400
IronPort-SDR: IM2lJRtS7FizZg8tbY0NNQIKsCDxTL6/j5HutJV1zPzm7wMSSJ7gcy3bnSuczrCe/k/Qr4bjhw
 BSFFuWCmidPw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 04:51:25 -0700
IronPort-SDR: 4NeQXEQVZQq9wxOWEzgjsdjrdaWE32X2663rhZruOpKxRR7PERlSHOxJ+3KSFASTMRzbv/GXtK
 0Hq3GY9QNxkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="270356888"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.120]) ([10.255.31.120])
  by fmsmga004.fm.intel.com with ESMTP; 24 Mar 2020 04:51:20 -0700
Subject: Re: [PATCH v5 1/9] x86/split_lock: Rework the initialization flow of
 split lock detection
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
 <20200315050517.127446-2-xiaoyao.li@intel.com>
 <87zhc7ovhj.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <95093fb0-df88-0543-c7eb-32b94ac4f99e@intel.com>
Date:   Tue, 24 Mar 2020 19:51:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87zhc7ovhj.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/2020 1:02 AM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Current initialization flow of split lock detection has following issues:
>> 1. It assumes the initial value of MSR_TEST_CTRL.SPLIT_LOCK_DETECT to be
>>     zero. However, it's possible that BIOS/firmware has set it.
> 
> Ok.
> 
>> 2. X86_FEATURE_SPLIT_LOCK_DETECT flag is unconditionally set even if
>>     there is a virtualization flaw that FMS indicates the existence while
>>     it's actually not supported.
>>
>> 3. Because of #2, KVM cannot rely on X86_FEATURE_SPLIT_LOCK_DETECT flag
>>     to check verify if feature does exist, so cannot expose it to
>>     guest.
> 
> Sorry this does not make anny sense. KVM is the hypervisor, so it better
> can rely on the detect flag. Unless you talk about nested virt and a
> broken L1 hypervisor.
> 

Yeah. It is for the nested virt on a broken L1 hypervisor.

