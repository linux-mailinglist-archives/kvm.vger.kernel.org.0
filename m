Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BD33876C4
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 12:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhERKmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 06:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241846AbhERKmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 06:42:35 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A501C061573;
        Tue, 18 May 2021 03:41:16 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ae20067192df7af4aebb0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:e200:6719:2df7:af4a:ebb0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 77BDA1EC01A8;
        Tue, 18 May 2021 12:41:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621334473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xlr/uzZET5SC6tWIXfC0JaKWVerD4FBRe0TKPQe0cAs=;
        b=CfvNJWf2X4MQciwvFn/dsWNEJrvYRgH6TCaJddIuK84feyP1X2ceIrnN7DL9fCEoxRehvE
        qHYvcg/6bRg6qvjZaKs2mUleQMdPVzarCSVEceIPxxTQkp/i52HTj3dWCf/ZItK5qDdHH8
        N9NdakToCH2A/eATZzYBHwdzkj4Nxd0=
Date:   Tue, 18 May 2021 12:41:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 05/20] x86/sev: Define SNP Page State Change
 VMGEXIT structure
Message-ID: <YKOZxMusqBLL1nP6@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-6-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-6-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:01AM -0500, Brijesh Singh wrote:
> An SNP-active guest will use the page state change NAE VMGEXIT defined in
> the GHCB specification to ask the hypervisor to make the guest page
> private or shared in the RMP table. In addition to the private/shared,
> the guest can also ask the hypervisor to split or combine multiple 4K
> validated pages as a single 2M page or vice versa.
> 
> See GHCB specification section Page State Change for additional
> information.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h | 46 +++++++++++++++++++++++++++++++
>  arch/x86/include/uapi/asm/svm.h   |  2 ++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 8142e247d8da..07b8612bf182 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -67,6 +67,52 @@
>  #define GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION_TIMER		\
>  		(BIT_ULL(3) | GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION)
>  
> +/* SNP Page State Change */
> +#define GHCB_MSR_PSC_REQ		0x014
> +#define SNP_PAGE_STATE_PRIVATE		1
> +#define SNP_PAGE_STATE_SHARED		2
> +#define SNP_PAGE_STATE_PSMASH		3
> +#define SNP_PAGE_STATE_UNSMASH		4
> +#define GHCB_MSR_PSC_GFN_POS		12
> +#define GHCB_MSR_PSC_GFN_MASK		0xffffffffffULL

Why don't you use GENMASK_ULL() as I suggested? All those "f"s are
harder to count than seeing the start and end of a mask.

> +#define GHCB_MSR_PSC_OP_POS		52

Also, having defines for 12 and 52 doesn't make it more readable,
frankly.

When I see GENMASK_ULL(51, 12) it is kinda clear what it is. With the
defines, I have to go chase every define and replace it with the number
mentally.

> +#define GHCB_MSR_PSC_OP_MASK		0xf
> +#define GHCB_MSR_PSC_REQ_GFN(gfn, op) 	\
> +	(((unsigned long)((op) & GHCB_MSR_PSC_OP_MASK) << GHCB_MSR_PSC_OP_POS) | \
> +	(((gfn) << GHCB_MSR_PSC_GFN_POS) & GHCB_MSR_PSC_GFN_MASK) | GHCB_MSR_PSC_REQ)
> +
> +#define GHCB_MSR_PSC_RESP		0x015
> +#define GHCB_MSR_PSC_ERROR_POS		32
> +#define GHCB_MSR_PSC_ERROR_MASK		0xffffffffULL
> +#define GHCB_MSR_PSC_RSVD_POS		12
> +#define GHCB_MSR_PSC_RSVD_MASK		0xfffffULL
> +#define GHCB_MSR_PSC_RESP_VAL(val)	((val) >> GHCB_MSR_PSC_ERROR_POS)
> +
> +/* SNP Page State Change NAE event */
> +#define VMGEXIT_PSC_MAX_ENTRY		253
> +#define VMGEXIT_PSC_INVALID_HEADER	0x100000001
> +#define VMGEXIT_PSC_INVALID_ENTRY	0x100000002
> +#define VMGEXIT_PSC_FIRMWARE_ERROR(x)	((x & 0xffffffffULL) | 0x200000000)
> +
> +struct __packed snp_page_state_header {
> +	u16 cur_entry;
> +	u16 end_entry;
> +	u32 reserved;
> +};
> +
> +struct __packed snp_page_state_entry {
> +	u64 cur_page:12;
> +	u64 gfn:40;
> +	u64 operation:4;
> +	u64 pagesize:1;
> +	u64 reserved:7;

Please write it like this:

	u64 cur_page 	: 12,
	    gfn		: 40,
	    ...

to show that all those fields are part of the same u64.

struct perf_event_attr in include/uapi/linux/perf_event.h is a good
example.

> +};
> +
> +struct __packed snp_page_state_change {
> +	struct snp_page_state_header header;
> +	struct snp_page_state_entry entry[VMGEXIT_PSC_MAX_ENTRY];
> +};
> +
>  #define GHCB_MSR_TERM_REQ		0x100
>  #define GHCB_MSR_TERM_REASON_SET_POS	12
>  #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index 7fbc311e2de1..f7bf12cad58c 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -108,6 +108,7 @@
>  #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
>  #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
>  #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
> +#define SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE	0x80000010

SVM_VMGEXIT_SNP_PSC

>  #define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>  
> @@ -216,6 +217,7 @@
>  	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
>  	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
>  	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
> +	{ SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE,	"vmgexit_page_state_change" }, \

Ditto.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
