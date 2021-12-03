Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B7A4671C0
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 06:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378542AbhLCF54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 00:57:56 -0500
Received: from mga04.intel.com ([192.55.52.120]:65461 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231182AbhLCF5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 00:57:55 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="235652704"
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="235652704"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 21:54:32 -0800
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="610276120"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.128]) ([10.255.31.128])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 21:54:30 -0800
Message-ID: <4fc2aa84-1748-397d-d468-ff8e48c65e47@intel.com>
Date:   Fri, 3 Dec 2021 13:54:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [kvm-unit-tests PATCH] x86: Remove invalid clwb test code
Content-Language: en-US
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     chao.gao@intel.com, yuan.yao@intel.com
References: <20211201092619.60298-1-zhenzhong.duan@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20211201092619.60298-1-zhenzhong.duan@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ Paolo explicitly

On 12/1/2021 5:26 PM, Zhenzhong Duan wrote:
> When X86_FEATURE_WAITPKG(CPUID.7.0:ECX.WAITPKG[bit 5]) supported,
> ".byte 0x66, 0x0f, 0xae, 0xf0" sequence no longer represents clwb
> instruction with invalid operand but tpause instruction with %eax
> as input register.
> 
> Execute tpause with invalid input triggers #GP with below customed
> qemu command line:
> 
> qemu -kernel x86/memory.flat -overcommit cpu-pm=on ...
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>   x86/memory.c | 7 -------
>   1 file changed, 7 deletions(-)
> 
> diff --git a/x86/memory.c b/x86/memory.c
> index 8f61020..351e7c0 100644
> --- a/x86/memory.c
> +++ b/x86/memory.c
> @@ -67,13 +67,6 @@ int main(int ac, char **av)
>   	asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
>   	report(ud == expected, "clwb (%s)", expected ? "ABSENT" : "present");
>   
> -	ud = 0;
> -	/* clwb requires a memory operand, the following is NOT a valid
> -	 * CLWB instruction (modrm == 0xF0).
> -	 */
> -	asm volatile(".byte 0x66, 0x0f, 0xae, 0xf0");
> -	report(ud, "invalid clwb");
> -
>   	expected = !this_cpu_has(X86_FEATURE_PCOMMIT); /* PCOMMIT */
>   	ud = 0;
>   	/* pcommit: */
> 

