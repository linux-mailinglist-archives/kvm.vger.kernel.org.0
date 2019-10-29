Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41578E8B63
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 16:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389753AbfJ2PDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 11:03:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41228 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJ2PDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 11:03:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yPYBOVbzLkddXxQyoPdM/cinJsJOnw5vh/XAFVlfDHM=; b=L9o/9d7ljXJbX9mcF5Ru9ZBZG
        g1r7VSnXDcAzdDvKHTB52IikrHsdoE/BddnxtMhK3toC53ejzx2xN3NG+fh6u3i3FcZ2DANbUw43y
        QYFFEPqehro/BHuF3J0K9kkb5H5qDGqER81BxxXJe33XHIpcOpNaGHCayDIAmxSVr9jAYbo/BNMuU
        emAvJakMUB+zqjrv1volXvTz3iDeYBD8nWocPZ0poGWUHhNFeO74ZMXU2L3u1xjP36Cw5NW627TSN
        IUVGywLVQJC5uL85TI9/7bzjymznmI46x6v1Sz2DAGIuQ7YDS3sBsvkyU2xMRQLblEKc4K67gxxS8
        s6j+HBRvg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPT1B-00052p-K7; Tue, 29 Oct 2019 15:02:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 54DE4300E4D;
        Tue, 29 Oct 2019 16:01:42 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1C7AE2B43836D; Tue, 29 Oct 2019 16:02:43 +0100 (CET)
Date:   Tue, 29 Oct 2019 16:02:43 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org
Subject: Re: [PATCH v1 2/8] KVM: x86: PEBS output to Intel PT MSRs emulation
Message-ID: <20191029150243.GM4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-3-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572217877-26484-3-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 27, 2019 at 07:11:11PM -0400, Luwei Kang wrote:
> Intel new hardware introduces a mechanism to direct PEBS records
> output into the Intel PT buffer that can be used for enabling PEBS
> in KVM guest. This patch implements the registers read and write
> emulation when PEBS is supported in KVM guest.
> 
> KMM needs to reprogram the counters when the value of these MSRs
> be changed that to make sure it can take effect in hardware.
> 
> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h  |  4 +++
>  arch/x86/include/asm/msr-index.h |  6 ++++
>  arch/x86/kvm/vmx/capabilities.h  | 15 ++++++++++
>  arch/x86/kvm/vmx/pmu_intel.c     | 63 ++++++++++++++++++++++++++++++++++++++--
>  4 files changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 20ce682..d22f8d9 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -131,9 +131,13 @@
>  #define LBR_INFO_ABORT			BIT_ULL(61)
>  #define LBR_INFO_CYCLES			0xffff
>  
> +#define MSR_IA32_PEBS_PMI_AFTER_REC	BIT_ULL(60)
> +#define MSR_IA32_PEBS_OUTPUT_PT		BIT_ULL(61)
> +#define MSR_IA32_PEBS_OUTPUT_MASK	(3ULL << 61)
>  #define MSR_IA32_PEBS_ENABLE		0x000003f1
>  #define MSR_PEBS_DATA_CFG		0x000003f2
>  #define MSR_IA32_DS_AREA		0x00000600
> +#define MSR_IA32_PERF_CAP_PEBS_OUTPUT_PT	BIT_ULL(16)
>  #define MSR_IA32_PERF_CAPABILITIES	0x00000345
>  #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
>  
> @@ -665,6 +669,8 @@
>  #define MSR_IA32_MISC_ENABLE_FERR			(1ULL << MSR_IA32_MISC_ENABLE_FERR_BIT)
>  #define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT		10
>  #define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX		(1ULL << MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT)
> +#define MSR_IA32_MISC_ENABLE_PEBS_BIT			12
> +#define MSR_IA32_MISC_ENABLE_PEBS			(1ULL << MSR_IA32_MISC_ENABLE_PEBS_BIT)
>  #define MSR_IA32_MISC_ENABLE_TM2_BIT			13
>  #define MSR_IA32_MISC_ENABLE_TM2			(1ULL << MSR_IA32_MISC_ENABLE_TM2_BIT)
>  #define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE_BIT	19

Some of these already exist but are local to perf. Don't blindly
introduce more without unifying.
