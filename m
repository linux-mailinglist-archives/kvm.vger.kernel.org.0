Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23433876D9
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 12:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243964AbhERKqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 06:46:55 -0400
Received: from mail.skyhub.de ([5.9.137.197]:56200 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348624AbhERKqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 06:46:49 -0400
Received: from zn.tnic (p200300ec2f0ae20067192df7af4aebb0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:e200:6719:2df7:af4a:ebb0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 624A51EC01A8;
        Tue, 18 May 2021 12:45:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621334724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rdxWhvramxY856CMW4AScLuyJ9Po7Sk21r5YjR+qMxQ=;
        b=eceG3+gGdIIDxssqhT97mwkGW+VZpYrBShWX4iKkX/kBpt+2B/wylevpzAZ0LKyqMwk9In
        P0CLgp2r+7B4PkEf5Gmc9aWXjzXf0tX+dlgn9XrjKgHf78KOA5ylXlTWKg7XFq1NtsDvX2
        K06zbBXDp7VOJPhHNlJXKA2cnVD9Lgs=
Date:   Tue, 18 May 2021 12:45:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 06/20] x86/sev: Define SNP guest request NAE
 events
Message-ID: <YKOaxBBAB/BJZmbY@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-7-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-7-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:02AM -0500, Brijesh Singh wrote:
> Version 2 of the GHCB specification added the support for SNP guest
> request NAE events. The SEV-SNP guests will use this event to request
> the attestation report. See the GHCB specification for more details.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/uapi/asm/svm.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index f7bf12cad58c..7a45aa284530 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -109,6 +109,8 @@
>  #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
>  #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
>  #define SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE	0x80000010
> +#define SVM_VMGEXIT_SNP_GUEST_REQUEST		0x80000011
> +#define SVM_VMGEXIT_SNP_EXT_GUEST_REQUEST	0x80000012

Why does this need the "VMGEXIT" *and* "SNP" prefixes?

Why not simply:

SVM_VMGEXIT_GUEST_REQ
SVM_VMGEXIT_EXT_GUEST_REQ

like the rest of the VMGEXIT defines in there?


>  #define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>  
> @@ -218,6 +220,8 @@
>  	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
>  	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
>  	{ SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE,	"vmgexit_page_state_change" }, \
> +	{ SVM_VMGEXIT_SNP_GUEST_REQUEST,	"vmgexit_snp_guest_request" }, \
> +	{ SVM_VMGEXIT_SNP_EXT_GUEST_REQUEST,	"vmgexit_snp_extended_guest_request" }, \
>  	{ SVM_VMGEXIT_HYPERVISOR_FEATURES,	"vmgexit_hypervisor_feature" }, \
>  	{ SVM_EXIT_ERR,         "invalid_guest_state" }

Ditto.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
