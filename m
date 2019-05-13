Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265331AF20
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 05:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfEMDbk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 12 May 2019 23:31:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:56972 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfEMDbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 May 2019 23:31:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 May 2019 20:31:39 -0700
X-ExtLoop1: 1
Received: from pgsmsx105.gar.corp.intel.com ([10.221.44.96])
  by orsmga002.jf.intel.com with ESMTP; 12 May 2019 20:31:37 -0700
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.40]) by
 PGSMSX105.gar.corp.intel.com ([169.254.4.8]) with mapi id 14.03.0415.000;
 Mon, 13 May 2019 11:31:35 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Kai Huang <kai.huang@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "junaids@google.com" <junaids@google.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH] kvm: x86: Fix L1TF mitigation for shadow MMU
Thread-Topic: [PATCH] kvm: x86: Fix L1TF mitigation for shadow MMU
Thread-Index: AQHVAYvtFSKB7z3SMUSGq8P45jsnbqZodUBA
Date:   Mon, 13 May 2019 03:31:35 +0000
Message-ID: <105F7BF4D0229846AF094488D65A098935788A6B@PGSMSX112.gar.corp.intel.com>
References: <20190503084025.24549-1-kai.huang@linux.intel.com>
In-Reply-To: <20190503084025.24549-1-kai.huang@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjgxNWQyYzktYTUxYi00ODVlLWE1N2MtZDUxMDEyMDhlOGQ3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicVwvTE1JRjZjdFwvQ2JCdVwvYkJ4QWRlNGUzOUFydkl4bjVFbzhSTTNvMmR6NE5NYWh0NnMwQW8rK01hWXVyTEVFMCJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo/Radim,

Would you take a look?

Thanks,
-Kai


> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> Behalf Of Kai Huang
> Sent: Friday, May 3, 2019 8:40 PM
> To: kvm@vger.kernel.org; pbonzini@redhat.com; rkrcmar@redhat.com
> Cc: Christopherson, Sean J <sean.j.christopherson@intel.com>;
> junaids@google.com; thomas.lendacky@amd.com; brijesh.singh@amd.com;
> tglx@linutronix.de; bp@alien8.de; hpa@zytor.com; Huang, Kai
> <kai.huang@intel.com>; Kai Huang <kai.huang@linux.intel.com>
> Subject: [PATCH] kvm: x86: Fix L1TF mitigation for shadow MMU
> 
> Currently KVM sets 5 most significant bits of physical address bits reported
> by CPUID (boot_cpu_data.x86_phys_bits) for nonpresent or reserved bits
> SPTE to mitigate L1TF attack from guest when using shadow MMU. However
> for some particular Intel CPUs the physical address bits of internal cache is
> greater than physical address bits reported by CPUID.
> 
> Use the kernel's existing boot_cpu_data.x86_cache_bits to determine the
> five most significant bits. Doing so improves KVM's L1TF mitigation in the
> unlikely scenario that system RAM overlaps the high order bits of the "real"
> physical address space as reported by CPUID. This aligns with the kernel's
> warnings regarding L1TF mitigation, e.g. in the above scenario the kernel
> won't warn the user about lack of L1TF mitigation if x86_cache_bits is greater
> than x86_phys_bits.
> 
> Also initialize shadow_nonpresent_or_rsvd_mask explicitly to make it
> consistent with other 'shadow_{xxx}_mask', and opportunistically add a
> WARN once if KVM's L1TF mitigation cannot be applied on a system that is
> marked as being susceptible to L1TF.
> 
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> ---
> 
> This patch was splitted from old patch I sent out around 2 weeks ago:
> 
> kvm: x86: Fix several SPTE mask calculation errors caused by MKTME
> 
> After reviewing with Sean Christopherson it's better to split this out, since
> the logic in this patch is independent. And maybe this patch should also be
> into stable.
> 
> ---
>  arch/x86/kvm/mmu.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c index
> b0899f175db9..1b2380e0060f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -511,16 +511,24 @@ static void kvm_mmu_reset_all_pte_masks(void)
>  	 * If the CPU has 46 or less physical address bits, then set an
>  	 * appropriate mask to guard against L1TF attacks. Otherwise, it is
>  	 * assumed that the CPU is not vulnerable to L1TF.
> +	 *
> +	 * Some Intel CPUs address the L1 cache using more PA bits than are
> +	 * reported by CPUID. Use the PA width of the L1 cache when
> possible
> +	 * to achieve more effective mitigation, e.g. if system RAM overlaps
> +	 * the most significant bits of legal physical address space.
>  	 */
> -	low_phys_bits = boot_cpu_data.x86_phys_bits;
> -	if (boot_cpu_data.x86_phys_bits <
> +	shadow_nonpresent_or_rsvd_mask = 0;
> +	low_phys_bits = boot_cpu_data.x86_cache_bits;
> +	if (boot_cpu_data.x86_cache_bits <
>  	    52 - shadow_nonpresent_or_rsvd_mask_len) {
>  		shadow_nonpresent_or_rsvd_mask =
> -			rsvd_bits(boot_cpu_data.x86_phys_bits -
> +			rsvd_bits(boot_cpu_data.x86_cache_bits -
>  				  shadow_nonpresent_or_rsvd_mask_len,
> -				  boot_cpu_data.x86_phys_bits - 1);
> +				  boot_cpu_data.x86_cache_bits - 1);
>  		low_phys_bits -= shadow_nonpresent_or_rsvd_mask_len;
> -	}
> +	} else
> +		WARN_ON_ONCE(boot_cpu_has_bug(X86_BUG_L1TF));
> +
>  	shadow_nonpresent_or_rsvd_lower_gfn_mask =
>  		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);  }
> --
> 2.13.6

