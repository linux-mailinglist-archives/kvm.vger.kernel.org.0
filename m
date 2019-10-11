Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58645D3A49
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 09:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfJKHtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 03:49:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:19516 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbfJKHtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 03:49:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 00:49:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,283,1566889200"; 
   d="scan'208";a="193458532"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.168]) ([10.239.196.168])
  by fmsmga008.fm.intel.com with ESMTP; 11 Oct 2019 00:49:44 -0700
Subject: Re: [PATCH RESEND v6 1/2] x86/cpu: Add support for
 UMONITOR/UMWAIT/TPAUSE
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Jingqi" <jingqi.liu@intel.com>
References: <20191011074103.30393-1-tao3.xu@intel.com>
 <20191011074103.30393-2-tao3.xu@intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <1731d87f-f07a-916f-90a7-346b593d821e@intel.com>
Date:   Fri, 11 Oct 2019 15:49:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011074103.30393-2-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/2019 3:41 PM, Xu, Tao3 wrote:
[...]
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 11b9c854b5..a465c893b5 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -401,6 +401,12 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>           if (host_tsx_blacklisted()) {
>               ret &= ~(CPUID_7_0_EBX_RTM | CPUID_7_0_EBX_HLE);
>           }
> +    } else if (function == 7 && index == 0 && reg == R_ECX) {
> +        if (enable_cpu_pm) {
> +            ret |= CPUID_7_0_ECX_WAITPKG;
> +        } else {
> +            ret &= ~CPUID_7_0_ECX_WAITPKG;
> +        }

Hi Paolo,

I am sorry because I realize in KVM side, I keep cpuid mask WAITPKG as 0:

F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;

Therefore in QEMU side, we need to add CPUID_7_0_ECX_WAITPKG when 
enable_cpu_pm is on. Otherwise, QEMU can't get this CPUID.

Could you review this part again? Thank you very much!

Tao
