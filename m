Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C563561AE2
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 09:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbfGHHFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 03:05:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:63267 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbfGHHFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 03:05:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 00:05:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,465,1557212400"; 
   d="scan'208";a="167591766"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.129.57]) ([10.238.129.57])
  by orsmga003.jf.intel.com with ESMTP; 08 Jul 2019 00:05:14 -0700
Subject: Re: [PATCH 1/5] KVM: cpuid: do_cpuid_ent works on a whole CPUID
 function
References: <20190704140715.31181-1-pbonzini@redhat.com>
 <20190704140715.31181-2-pbonzini@redhat.com>
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Message-ID: <50fccadc-ad5c-6548-529d-412f68cab1f5@linux.intel.com>
Date:   Mon, 8 Jul 2019 15:05:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704140715.31181-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 7/4/2019 10:07 PM, Paolo Bonzini wrote:
> Rename it as well as __do_cpuid_ent and __do_cpuid_ent_emulated to have
> "func" in its name, and drop the index parameter which is always 0.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/cpuid.c | 89 +++++++++++++++++++++-----------------------
>   1 file changed, 42 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 004cbd84c351..ddffc56c39b4 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -294,14 +294,19 @@ static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>   {
>   	entry->function = function;
>   	entry->index = index;
> +	entry->flags = 0;
> +

I'm wondering if we need set entry->flags = 0 here?
entry->flags was initialized as zero when vzalloc.

>   	cpuid_count(entry->function, entry->index,
>   		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
> -	entry->flags = 0;
>   }
>   
> -static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
> -				   u32 func, u32 index, int *nent, int maxnent)
> +static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
> +				    u32 func, int *nent, int maxnent)
>   {
> +	entry->function = func;
> +	entry->index = 0;
> +	entry->flags = 0;
> +

The same question for flags and index, because entry is allocated
by vzalloc.

>   	switch (func) {
>   	case 0:
>   		entry->eax = 7;
> @@ -313,21 +318,18 @@ static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
>   		break;
>   	case 7:
>   		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> -		if (index == 0)
> -			entry->ecx = F(RDPID);
> +		entry->eax = 0;
> +		entry->ecx = F(RDPID);
>   		++*nent;
>   	default:
>   		break;
>   	}
>   
> -	entry->function = func;
> -	entry->index = index;
> -
>   	return 0;
>   }
>   


Thanks,
Jing
