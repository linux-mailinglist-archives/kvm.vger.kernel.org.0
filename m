Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8260F1DAAB0
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 08:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgETGiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 02:38:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:53816 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgETGiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 02:38:46 -0400
IronPort-SDR: GV12MgCQyzMEjvj7TK91LXISLzCiVK/XVNt3U5WQZJObfmbVwb1U5DXJZeIoDqulbEYubERhGZ
 6UsLJK7gyz5w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 23:38:46 -0700
IronPort-SDR: wzPYeZPBSZy/xujHLb2StAkI30oFzPyTb+qF7FyiJtIynpT25wbT2tres16z32jhJOuwo6HdwR
 rqHnm0xF6hwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="343397466"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 19 May 2020 23:38:46 -0700
Date:   Tue, 19 May 2020 23:38:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 59/75] x86/sev-es: Handle MONITOR/MONITORX Events
Message-ID: <20200520063845.GC17090@linux.intel.com>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-60-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-60-joro@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:09PM +0200, Joerg Roedel wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Implement a handler for #VC exceptions caused by MONITOR and MONITORX
> instructions.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ jroedel@suse.de: Adapt to #VC handling infrastructure ]
> Co-developed-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev-es.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 601554e6360f..1a961714cd1b 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -824,6 +824,22 @@ static enum es_result vc_handle_rdpmc(struct ghcb *ghcb, struct es_em_ctxt *ctxt
>  	return ES_OK;
>  }
>  
> +static enum es_result vc_handle_monitor(struct ghcb *ghcb,
> +					struct es_em_ctxt *ctxt)
> +{
> +	phys_addr_t monitor_pa;
> +	pgd_t *pgd;
> +
> +	pgd = __va(read_cr3_pa());
> +	monitor_pa = vc_slow_virt_to_phys(ghcb, ctxt->regs->ax);
> +
> +	ghcb_set_rax(ghcb, monitor_pa);
> +	ghcb_set_rcx(ghcb, ctxt->regs->cx);
> +	ghcb_set_rdx(ghcb, ctxt->regs->dx);
> +
> +	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MONITOR, 0, 0);

Why?  If SVM has the same behavior as VMX, the MONITOR will be disarmed on
VM-Enter, i.e. the VMM can't do anything useful for MONITOR/MWAIT.  I
assume that's the case given that KVM emulates MONITOR/MWAIT as NOPs on
SVM.

> +}
> +
>  static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>  					 struct ghcb *ghcb,
>  					 unsigned long exit_code)
> @@ -860,6 +876,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>  	case SVM_EXIT_WBINVD:
>  		result = vc_handle_wbinvd(ghcb, ctxt);
>  		break;
> +	case SVM_EXIT_MONITOR:
> +		result = vc_handle_monitor(ghcb, ctxt);
> +		break;
>  	case SVM_EXIT_NPF:
>  		result = vc_handle_mmio(ghcb, ctxt);
>  		break;
> -- 
> 2.17.1
> 
