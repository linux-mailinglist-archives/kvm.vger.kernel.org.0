Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF263513A9
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 12:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhDAKc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 06:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbhDAKcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 06:32:10 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFD9C061788;
        Thu,  1 Apr 2021 03:32:10 -0700 (PDT)
Received: from zn.tnic (p200300ec2f088700f80405624ee7667c.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:8700:f804:562:4ee7:667c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C0A5B1EC026D;
        Thu,  1 Apr 2021 12:32:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617273128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WiMljJvd1azKBbqtGB/1+/4VHq+5lF5xSbnFQGYS58k=;
        b=m9clS+6Wv/pBosROUpasjui17oUVvfZ7KCMRCYs9a/YODdMNCNrbDQBpyGcmPmqGm0dqyJ
        igkzV6AYfSZ+H0juuLaaWtiNPZBquOfQ0r8V3sww0XtAFmu9lwfRuHsU3Izy6BUnWvdK4X
        Ch6FGeYUTqFqBqKNe8+wwcSs6YzWZ6c=
Date:   Thu, 1 Apr 2021 12:32:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 04/13] x86/sev-snp: define page state change
 VMGEXIT structure
Message-ID: <20210401103208.GA28954@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-5-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210324164424.28124-5-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 11:44:15AM -0500, Brijesh Singh wrote:
> An SNP-active guest will use the page state change VNAE MGEXIT defined in

I guess this was supposed to mean "NAE VMGEXIT" but pls write "NAE" out
at least once so that reader can find its way around the spec.

> the GHCB specification section 4.1.6 to ask the hypervisor to make the
> guest page private or shared in the RMP table. In addition to the
> private/shared, the guest can also ask the hypervisor to split or
> combine multiple 4K validated pages as a single 2M page or vice versa.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev-snp.h  | 34 +++++++++++++++++++++++++++++++++
>  arch/x86/include/uapi/asm/svm.h |  1 +
>  2 files changed, 35 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
> index 5a6d1367cab7..f514dad276f2 100644
> --- a/arch/x86/include/asm/sev-snp.h
> +++ b/arch/x86/include/asm/sev-snp.h
> @@ -22,6 +22,40 @@
>  #define RMP_PG_SIZE_2M			1
>  #define RMP_PG_SIZE_4K			0
>  
> +/* Page State Change MSR Protocol */
> +#define GHCB_SNP_PAGE_STATE_CHANGE_REQ	0x0014
> +#define		GHCB_SNP_PAGE_STATE_REQ_GFN(v, o)	(GHCB_SNP_PAGE_STATE_CHANGE_REQ | \
> +							 ((unsigned long)((o) & 0xf) << 52) | \
> +							 (((v) << 12) & 0xffffffffffffff))

This macro needs to be more readable and I'm not sure the masking is
correct. IOW, something like this perhaps:

#define GHCB_SNP_PAGE_STATE_REQ_GFN(va, operation)	\
	((((operation) & 0xf) << 52) | ((va) & GENMASK_ULL(51, 12)) | GHCB_SNP_PAGE_STATE_CHANGE_REQ)

where you have each GHCBData element at the proper place, msb to lsb.
Now, GHCB spec says:

	"GHCBData[51:12] – Guest physical frame number"

and I'm not clear as to what this macro takes: a virtual address or a
pfn. If it is a pfn, then you need to do:

	(((pfn) << 12) & GENMASK_ULL(51, 0))

but if it is a virtual address you need to do what I have above. Since
you do "<< 12" then it must be a pfn already but then you should call
the argument "pfn" so that it is clear what it takes.

Your mask above covers [55:0] but [55:52] is the page operation so the
high bit in that mask needs to be 51.

AFAICT, ofc.

> +#define	SNP_PAGE_STATE_PRIVATE		1
> +#define	SNP_PAGE_STATE_SHARED		2
> +#define	SNP_PAGE_STATE_PSMASH		3
> +#define	SNP_PAGE_STATE_UNSMASH		4
> +
> +#define GHCB_SNP_PAGE_STATE_CHANGE_RESP	0x0015
> +#define		GHCB_SNP_PAGE_STATE_RESP_VAL(val)	((val) >> 32)
	  ^^^^^^^^^^^^

Some stray tabs here and above, pls pay attention to vertical alignment too.

> +
> +/* Page State Change NAE event */
> +#define SNP_PAGE_STATE_CHANGE_MAX_ENTRY		253
> +struct __packed snp_page_state_header {
> +	uint16_t cur_entry;
> +	uint16_t end_entry;
> +	uint32_t reserved;
> +};
> +
> +struct __packed snp_page_state_entry {
> +	uint64_t cur_page:12;
> +	uint64_t gfn:40;
> +	uint64_t operation:4;
> +	uint64_t pagesize:1;
> +	uint64_t reserved:7;
> +};

Any particular reason for the uint<width>_t types or can you use our
shorter u<width> types?

> +
> +struct __packed snp_page_state_change {
> +	struct snp_page_state_header header;
> +	struct snp_page_state_entry entry[SNP_PAGE_STATE_CHANGE_MAX_ENTRY];

Also, looking further into the patchset, I wonder if it would make sense
to do:

s/PAGE_STATE_CHANGE/PSC/g

to avoid breaking lines of huge statements:

+	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SNP_PAGE_STATE_CHANGE_RESP) ||
+	    (GHCB_SNP_PAGE_STATE_RESP_VAL(val) != 0))
+		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);

and turn them into something more readable

+	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SNP_PSC_RESP) ||
+	    (GHCB_SNP_PSC_RESP_VAL(val)))
+		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);

Also, you have GHCB_SEV and GHCB_SNP prefixes and I wonder whether we
even need them and have everything be prefixed simply GHCB_ because that
is the protocol, after all.

Which will then turn the above into:

+	if ((GHCB_RESP_CODE(val) != GHCB_PSC_RESP) || (GHCB_PSC_RESP_VAL(val)))
+		sev_es_terminate(GHCB_REASON_GENERAL_REQUEST);

Oh yeah baby! :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
