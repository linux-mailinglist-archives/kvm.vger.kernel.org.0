Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D75174D54
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 13:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCAMZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 07:25:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:38695 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCAMZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 07:25:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2020 04:25:34 -0800
X-IronPort-AV: E=Sophos;i="5.70,503,1574150400"; 
   d="scan'208";a="232782628"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.67]) ([10.255.30.67])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Mar 2020 04:25:32 -0800
Subject: Re: [PATCH] kvm: x86: Make traced and returned value of kvm_cpuid
 consistent again
To:     Jan Kiszka <jan.kiszka@web.de>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>
References: <dd33df29-2c17-2dc8-cb8f-56686cd583ad@web.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <b9244d91-93a6-e663-6497-e91c1dca49ef@intel.com>
Date:   Sun, 1 Mar 2020 20:25:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <dd33df29-2c17-2dc8-cb8f-56686cd583ad@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/2020 6:47 PM, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> After 43561123ab37, found is not set correctly in case of leaves 0BH,
> 1FH, or anything out-of-range. This is currently harmless for the return
> value because the only caller evaluating it passes leaf 0x80000008.

Nice catch!

> However, the trace entry is now misleading due to this inaccuracy. It is
> furthermore misleading because it reports the effective function, not
> the originally passed one. Fix that as well.

BTW, the trace lacks subleaf(ECX) info, it's meaning for the the leaf 
does have a subleaf, maybe we'd better add it?

> Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>   arch/x86/kvm/cpuid.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..79a738f313f8 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1000,13 +1000,12 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
>   bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>   	       u32 *ecx, u32 *edx, bool check_limit)
>   {
> -	u32 function = *eax, index = *ecx;
> +	u32 orig_function = *eax, function = *eax, index = *ecx;
>   	struct kvm_cpuid_entry2 *entry;
>   	struct kvm_cpuid_entry2 *max;
>   	bool found;
> 
>   	entry = kvm_find_cpuid_entry(vcpu, function, index);
> -	found = entry;
>   	/*
>   	 * Intel CPUID semantics treats any query for an out-of-range
>   	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
> @@ -1049,7 +1048,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>   			}
>   		}
>   	}
> -	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
> +	found = entry;
> +	trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *edx, found);
>   	return found;
>   }
>   EXPORT_SYMBOL_GPL(kvm_cpuid);
> --
> 2.16.4
> 

