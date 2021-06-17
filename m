Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0523AB7B0
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 17:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhFQPlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 11:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbhFQPlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 11:41:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD165C061574;
        Thu, 17 Jun 2021 08:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G0Lvdln11fuzanH5JBFVlU89DGk/WHJ/h+sQJcOIMZU=; b=m7f6DrxmOSFDPVRUrGpIsGKH8Y
        op5BLM2WKhd7ygxhD3X0aHUzETlJSrlwr7/P/yfoFKMdozL/0d5O397EfTc38tiyV36wDc/GrLItj
        j3y4WNP8y7pzxl8QhhWTs1FFd/sOto1FhIztdYCLZmY8k/sx4Nt6xLZkJ4lBOvf7+1qGKUCqbmQuX
        dQuOIJIfh7+G9FQaqZaDXTJr6uVHbSLpkVBn2xlK6EorB9xvM4kd2oAdIGlb+wlgI4iv2+IzypgQ9
        U5kw22QCb9fbRG8m7MULJK+ojiB/vzmyc3YBVmmSmI7Vym47sFXo/ejWQV9DDb8WLDA2OHf+9U0dR
        C2sscMfw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltu6S-009I32-Dg; Thu, 17 Jun 2021 15:38:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F0A95300252;
        Thu, 17 Jun 2021 17:38:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D9E1C234E5383; Thu, 17 Jun 2021 17:38:46 +0200 (CEST)
Date:   Thu, 17 Jun 2021 17:38:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 1/2] x86/sev: Make sure IRQs are disabled while GHCB
 is active
Message-ID: <YMtshtgEbiQ993Zk@hirez.programming.kicks-ass.net>
References: <20210616184913.13064-1-joro@8bytes.org>
 <20210616184913.13064-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616184913.13064-2-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Wed, Jun 16, 2021 at 08:49:12PM +0200, Joerg Roedel wrote:
> @@ -514,7 +523,7 @@ void noinstr __sev_es_nmi_complete(void)
>  	struct ghcb_state state;
>  	struct ghcb *ghcb;
>  
> -	ghcb = sev_es_get_ghcb(&state);
> +	ghcb = __sev_get_ghcb(&state);
>  
>  	vc_ghcb_invalidate(ghcb);
>  	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_NMI_COMPLETE);
> @@ -524,7 +533,7 @@ void noinstr __sev_es_nmi_complete(void)
>  	sev_es_wr_ghcb_msr(__pa_nodebug(ghcb));
>  	VMGEXIT();
>  
> -	sev_es_put_ghcb(&state);
> +	__sev_put_ghcb(&state);
>  }

I'm getting (with all of v6.1 applied):

vmlinux.o: warning: objtool: __sev_es_nmi_complete()+0x1bf: call to panic() leaves .noinstr.text section

$ ./scripts/faddr2line defconfig-build/vmlinux __sev_es_nmi_complete+0x1bf
__sev_es_nmi_complete+0x1bf/0x1d0:
__sev_get_ghcb at arch/x86/kernel/sev.c:223
(inlined by) __sev_es_nmi_complete at arch/x86/kernel/sev.c:519


