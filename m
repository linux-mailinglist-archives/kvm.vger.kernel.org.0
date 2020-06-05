Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D98C1EEF85
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 04:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgFECc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 22:32:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:49832 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgFECc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 22:32:28 -0400
IronPort-SDR: Zz5tm6WpH3scY/quHL0PfDsaB+xCA05FidCGxV6F9KXU9PxUPL7OkKb1pwLX6/+3xqk5igBhQw
 sODVQzNf6tUg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 19:32:21 -0700
IronPort-SDR: WobUmolIS7EeRo2skFMP8m8/Y/sJgss61yNsN0YN3mOJiaqoP7yByWQlnWM56W0XUNdVW4ZBB6
 58yNl/qI4A3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,474,1583222400"; 
   d="scan'208";a="294542056"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by fmsmga004.fm.intel.com with ESMTP; 04 Jun 2020 19:32:18 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH][v6] KVM: X86: support APERF/MPERF registers
To:     Li RongQing <lirongqing@baidu.com>
References: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        jmattson@google.com, wanpengli@tencent.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, wei.huang2@amd.com
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <be39b88c-bfb7-0634-c53b-f00d8fde643c@intel.com>
Date:   Fri, 5 Jun 2020 10:32:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi RongQing,

On 2020/6/5 9:44, Li RongQing wrote:
> Guest kernel reports a fixed cpu frequency in /proc/cpuinfo,
> this is confused to user when turbo is enable, and aperf/mperf
> can be used to show current cpu frequency after 7d5905dc14a
> "(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
> so guest should support aperf/mperf capability
>
> This patch implements aperf/mperf by three mode: none, software
> emulation, and pass-through
>
> None: default mode, guest does not support aperf/mperf
s/None/Note
>
> Software emulation: the period of aperf/mperf in guest mode are
> accumulated as emulated value
>
> Pass-though: it is only suitable for KVM_HINTS_REALTIME, Because
> that hint guarantees we have a 1:1 vCPU:CPU binding and guaranteed
> no over-commit.
The flag "KVM_HINTS_REALTIME 0" (in the Documentation/virt/kvm/cpuid.rst)
is claimed as "guest checks this feature bit to determine that vCPUs are never
preempted for an unlimited time allowing optimizations".

I couldn't see its relationship with "1:1 vCPU: pCPU binding".
The patch doesn't check this flag as well for your pass-through purpose.

Thanks,
Like Xu
>
> And a per-VM capability is added to configure aperfmperf mode
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Chai Wen <chaiwen@baidu.com>
> Signed-off-by: Jia Lina <jialina01@baidu.com>
> ---
> diff v5:
> return error if guest is configured with mperf/aperf, but host cpu has not
>
> diff v4:
> fix maybe-uninitialized warning
>
> diff v3:
> fix interception of MSR_IA32_MPERF/APERF in svm
>
> diff v2:
> support aperfmperf pass though
> move common codes to kvm_get_msr_common
>
> diff v1:
> 1. support AMD, but not test
> 2. support per-vm capability to enable
>
>
>   Documentation/virt/kvm/api.rst  | 10 ++++++++++
>   arch/x86/include/asm/kvm_host.h | 11 +++++++++++
>   arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
>   arch/x86/kvm/svm/svm.c          |  8 ++++++++
>   arch/x86/kvm/vmx/vmx.c          |  6 ++++++
>   arch/x86/kvm/x86.c              | 42 +++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.h              | 15 +++++++++++++++
>   include/uapi/linux/kvm.h        |  1 +
>   8 files changed, 107 insertions(+), 1 deletion(-)

