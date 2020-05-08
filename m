Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A781CBA41
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 23:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgEHVzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 17:55:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:19627 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHVzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 17:55:55 -0400
IronPort-SDR: ddxPC0XhQ8ng1SaWPZeAJR2MaYq0BvirMJu5H4phmP6rNmFAV5p+noA+0SXkhV7LwH9vfI+VnB
 fCrnwYRy0k6w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 14:55:55 -0700
IronPort-SDR: faDwe0qsW+1ukx6gtqf2FNdfZID/PdXiS9P2RNbqybxyERk/hVALIpsh97hopEwKN2iPWIbwaE
 Ydz+t3Kon7yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="408247630"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 14:55:54 -0700
Date:   Fri, 8 May 2020 14:55:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, x86@kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com, bigeasy@linutronix.de,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: SVM: Add support for MPK feature on AMD
Message-ID: <20200508215554.GT27052@linux.intel.com>
References: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
 <158897220354.22378.8514752740721214658.stgit@naples-babu.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158897220354.22378.8514752740721214658.stgit@naples-babu.amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 04:10:03PM -0500, Babu Moger wrote:
> The Memory Protection Key (MPK) feature provides a way for applications
> to impose page-based data access protections (read/write, read-only or
> no access), without requiring modification of page tables and subsequent
> TLB invalidations when the application changes protection domains.
> 
> This feature is already available in Intel platforms. Now enable the
> feature on AMD platforms.
> 
> AMD documentation for MPK feature is available at "AMD64 Architecture
> Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34,
> Section 5.6.6 Memory Protection Keys (MPK) Bit". Documentation can be
> obtained at the link below.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2f379bacbb26..37fb41ad9149 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -818,6 +818,10 @@ static __init void svm_set_cpu_caps(void)
>  	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> +
> +	/* PKU is not yet implemented for shadow paging. */
> +	if (npt_enabled && boot_cpu_has(X86_FEATURE_OSPKE))
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);

This can actually be done in common code as well since both VMX and SVM
call kvm_set_cpu_caps() after kvm_configure_mmu(), i.e. key off of
tdp_enabled.

>  }
>  
>  static __init int svm_hardware_setup(void)
> 
