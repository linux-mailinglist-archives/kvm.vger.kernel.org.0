Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DFE37A42D
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 12:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhEKKCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 06:02:54 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52568 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231201AbhEKKCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 06:02:49 -0400
Received: from zn.tnic (p200300ec2f0ec70079cd82bef3234244.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:c700:79cd:82be:f323:4244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 37EF31EC0315;
        Tue, 11 May 2021 12:01:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620727302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=uNnvu0wsyy+IBcG9GpyAl66RgNtNpSo1YIkRCPmHqvY=;
        b=eTNhcKZp1C9WOyP/ArvXMKri9FqjsrzCxNR4J9d7j9OixYlSfIIOzm05Yqsag8RLCPACfU
        30V11GMKA3IHUKeZRWPxzLvHYwD3NSDgi4rzGS+Ngp9nQC5o9hfZ9la0Zv8RVlOkX5yl4N
        YiMmD5YWrrD2vFOn4z4M3gQvohP2CF4=
Date:   Tue, 11 May 2021 12:01:37 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 03/20] x86/sev: Add support for hypervisor
 feature VMGEXIT
Message-ID: <YJpWAY+ayATSn6nN@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-4-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-4-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:15:59AM -0500, Brijesh Singh wrote:
> Version 2 of GHCB specification introduced advertisement of a features
> that are supported by the hypervisor. Define the GHCB MSR protocol and NAE
> for the hypervisor feature request and query the feature during the GHCB
> protocol negotitation. See the GHCB specification for more details.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h | 17 +++++++++++++++++
>  arch/x86/include/uapi/asm/svm.h   |  2 ++
>  arch/x86/kernel/sev-shared.c      | 24 ++++++++++++++++++++++++
>  3 files changed, 43 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 9f1b66090a4c..8142e247d8da 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -51,6 +51,22 @@
>  #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
>  #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	0xfffffffffffff
>  
> +/* GHCB Hypervisor Feature Request */
> +#define GHCB_MSR_HV_FEATURES_REQ	0x080
> +#define GHCB_MSR_HV_FEATURES_RESP	0x081
> +#define GHCB_MSR_HV_FEATURES_POS	12
> +#define GHCB_MSR_HV_FEATURES_MASK	0xfffffffffffffUL
> +#define GHCB_MSR_HV_FEATURES_RESP_VAL(v)	\
> +	(((v) >> GHCB_MSR_HV_FEATURES_POS) & GHCB_MSR_HV_FEATURES_MASK)
> +
> +#define GHCB_HV_FEATURES_SNP		BIT_ULL(0)
> +#define GHCB_HV_FEATURES_SNP_AP_CREATION			\
> +		(BIT_ULL(1) | GHCB_HV_FEATURES_SNP)
> +#define GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION		\
> +		(BIT_ULL(2) | GHCB_HV_FEATURES_SNP_AP_CREATION)
> +#define GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION_TIMER		\
> +		(BIT_ULL(3) | GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION)

Please add those in the patches which use them - not in bulk here.

And GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION_TIMER is a mouthfull and
looks like BIOS code to me. But this is still the kernel, remember? :-)

So let's do

GHCB_MSR_HV_FT_*

GHCB_SNP_AP_CREATION
GHCB_SNP_RESTRICTED_INJ
GHCB_SNP_RESTRICTED_INJ_TMR

and so on so that we can all keep our sanity when reading that code.

> +
>  #define GHCB_MSR_TERM_REQ		0x100
>  #define GHCB_MSR_TERM_REASON_SET_POS	12
>  #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
> @@ -62,6 +78,7 @@
>  
>  #define GHCB_SEV_ES_REASON_GENERAL_REQUEST	0
>  #define GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED	1
> +#define GHCB_SEV_ES_REASON_SNP_UNSUPPORTED	2

I remember asking for those to get shortened too

GHCB_SEV_ES_GEN_REQ
GHCB_SEV_ES_PROT_UNSUPPORTED
GHCB_SEV_ES_SNP_UNSUPPORTED

Perhaps in a prepatch?

>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index 554f75fe013c..7fbc311e2de1 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -108,6 +108,7 @@
>  #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
>  #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
>  #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
> +#define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd

SVM_VMGEXIT_HV_FT

you get the idea.

>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>  
>  #define SVM_EXIT_ERR           -1
> @@ -215,6 +216,7 @@
>  	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
>  	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
>  	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
> +	{ SVM_VMGEXIT_HYPERVISOR_FEATURES,	"vmgexit_hypervisor_feature" }, \
>  	{ SVM_EXIT_ERR,         "invalid_guest_state" }
>  
>  
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 48a47540b85f..874f911837db 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -20,6 +20,7 @@
>   * out when the .bss section is later cleared.
>   */
>  static u16 ghcb_version __section(".data") = 0;
> +static u64 hv_features __section(".data") = 0;

ERROR: do not initialise statics to 0
#181: FILE: arch/x86/kernel/sev-shared.c:23:
+static u64 hv_features __section(".data") = 0;

>  static bool __init sev_es_check_cpu_features(void)
>  {
> @@ -49,6 +50,26 @@ static void __noreturn sev_es_terminate(unsigned int reason)
>  		asm volatile("hlt\n" : : : "memory");
>  }
>  
> +static bool ghcb_get_hv_features(void)

Used only once here - no need for the ghcb_ prefix.

> +{
> +	u64 val;
> +
> +	/* The hypervisor features are available from version 2 onward. */
> +	if (ghcb_version < 2)
> +		return true;

		return false;
no?

Also, this should be done differently:

	if (ghcb_version >= 2)
		get_hv_features();

at the call site.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
