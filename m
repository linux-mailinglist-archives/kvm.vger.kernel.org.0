Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF98A3AB6CF
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhFQPEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 11:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbhFQPEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 11:04:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB8CC061574;
        Thu, 17 Jun 2021 08:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V9go7Y/UucnNrXIa1S8r+WI1e5UGRrj5UmJdJeNO/dA=; b=DH3TBb6PTIQLbsLVSV75pzrQdw
        YOvlaQGhwgDxkO+n6YHcCAQcekOch3TTkgmTSQyJSG+PTfbr9rhv8w+vKtjZcSboPUa0yed3OM6Xv
        O2jUrIlTuYUi1y9vgYNACiS7Lc+7ouOb55q+Nq6PJsitEvRbdvdo2XiQhbmMvNFacge2ptH3eu7lm
        kSPZJfLJpFpr7d6jZ/bbyyUf75MzrK66LY/+Mz9z5jfs6Fexynhfz7Qqc0uisvf4WVdV/gybL68W9
        5mQy5IpZrCBaK6A9Zus6JuMao0B8Fy0DFPW3ThfNH2q2ELD5/gn0XQHA7VNHkqqrlpUPYOsjOVAqp
        ixUOZqwg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lttVj-009Fr5-UE; Thu, 17 Jun 2021 15:00:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 48ADC300252;
        Thu, 17 Jun 2021 17:00:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 31A2A2BD52F2F; Thu, 17 Jun 2021 17:00:48 +0200 (CEST)
Date:   Thu, 17 Jun 2021 17:00:48 +0200
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
Message-ID: <YMtjoLLQpKyveVlS@hirez.programming.kicks-ass.net>
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

>  static void sev_es_ap_hlt_loop(void)
>  {
>  	struct ghcb_state state;
> +	unsigned long flags;
>  	struct ghcb *ghcb;
>  
> -	ghcb = sev_es_get_ghcb(&state);
> +	local_irq_save(flags);
> +
> +	ghcb = __sev_get_ghcb(&state);
>  
>  	while (true) {
>  		vc_ghcb_invalidate(ghcb);
> @@ -692,7 +704,9 @@ static void sev_es_ap_hlt_loop(void)
>  			break;
>  	}
>  
> -	sev_es_put_ghcb(&state);
> +	__sev_put_ghcb(&state);
> +
> +	local_irq_restore(flags);
>  }

I think this is broken, at this point RCU is quite dead on this CPU and
local_irq_save/restore include tracing and all sorts.

Also, shouldn't IRQs already be disabled by the time we get here?
