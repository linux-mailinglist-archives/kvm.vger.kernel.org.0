Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8072F37D0E1
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 19:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhELRnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 13:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242724AbhELRfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 13:35:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7DBC06134D
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 10:31:08 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gq14-20020a17090b104eb029015be008ab0fso171434pjb.1
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 10:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jQ1izlrVGOhPAXdn9/aplXdHdgbZMkL/hHrij75+k+Q=;
        b=a4DNmUDUNPSavKGBm5teXTf27JxGyXaVA19FtMli56IbhkY9lFuV+rJqzokIoTEuwj
         F49XgNCm3V3M5/9KmyOKYrZZYrD8M0sxKPi5CWvV+66QLiQRD1dTK6hnpF6oOnX3KdYl
         KuYf/BxHq4xPZ5ZcOpdXGVy7p+OIZAgc99rCcjvCYvgDQxe5GvZg2Mt/NNQY/q+08vQ0
         Hl+rCDHoUA2rv75AAhQoZLZWwV1kC9ZJJDMDoQ/lYVk1QpsvMjeAuI4uQV90enBsC69c
         FUK56tmkLe8UkPGpZbmL7IVKUmI0tUBnEDrhm26gFC5GF7vWR9q72Rtv/k6SpUDPgwUW
         EuZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jQ1izlrVGOhPAXdn9/aplXdHdgbZMkL/hHrij75+k+Q=;
        b=GZcZ8b0OyHS3BHGzkU/f/eWEnqmpSRFljHNKQ+9j1EieR6EtSFebAP6N3DQFwWQBmN
         Jpo6ztLS/9e4qTeukRsoS4l7XgwuZRTqYlKxHQRd2iPNnU4MY3OMBLObIxtYO1gL3ddW
         wY0eKP0LTimP0Wxhya/g0HiaJs/kPx7Z+Xteo325IZTw9vSBKsf4BWoldH7tf3IV/Ntk
         uFS37BOpjc2uwQqS7pE7FkiNKUDKsdgay2FUOQ7X4naqnw5Vxtf9lSo5dLjHWL13vZi5
         CYxN5pdAb887TMf48aJoEFaZgYHs81yM1Zwp43VBAcv5/C7mSUsohtdmcsMRSrOg0bNl
         f0qw==
X-Gm-Message-State: AOAM5315V5Kl43YiTM+Ua4WE22m319vw5QjYzszNIgyshUt1AG7NPfEJ
        vq/+2vn3wQHE0nYAkv3jCk2rNA==
X-Google-Smtp-Source: ABdhPJz/4rNTvkI1wMpdg6OUFlsFjzwopUXYcEfBvzxbgvGH5sNB0scPThabFLbqW1Veig+/7/0g+A==
X-Received: by 2002:a17:90a:5207:: with SMTP id v7mr11942175pjh.87.1620840667721;
        Wed, 12 May 2021 10:31:07 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t15sm369192pgh.33.2021.05.12.10.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 10:31:07 -0700 (PDT)
Date:   Wed, 12 May 2021 17:31:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/6] x86/sev-es: Forward page-faults which happen during
 emulation
Message-ID: <YJwQ1xsiDtv3LkBe@google.com>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-3-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512075445.18935-3-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When emulating guest instructions for MMIO or IOIO accesses the #VC
> handler might get a page-fault and will not be able to complete. Forward
> the page-fault in this case to the correct handler instead of killing
> the machine.
> 
> Fixes: 0786138c78e7 ("x86/sev-es: Add a Runtime #VC Exception Handler")
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index c49270c7669e..6530a844eb61 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -1265,6 +1265,10 @@ static __always_inline void vc_forward_exception(struct es_em_ctxt *ctxt)
>  	case X86_TRAP_UD:
>  		exc_invalid_op(ctxt->regs);
>  		break;
> +	case X86_TRAP_PF:
> +		write_cr2(ctxt->fi.cr2);
> +		exc_page_fault(ctxt->regs, error_code);
> +		break;

This got me looking at the flows that "inject" #PF, and I'm pretty sure there
are bugs in __vc_decode_user_insn() + insn_get_effective_ip().

Problem #1: __vc_decode_user_insn() assumes a #PF if insn_fetch_from_user_inatomic()
fails, but the majority of failure cases in insn_get_seg_base() are #GPs, not #PF.

	res = insn_fetch_from_user_inatomic(ctxt->regs, buffer);
	if (!res) {
		ctxt->fi.vector     = X86_TRAP_PF;
		ctxt->fi.error_code = X86_PF_INSTR | X86_PF_USER;
		ctxt->fi.cr2        = ctxt->regs->ip;
		return ES_EXCEPTION;
	}

Problem #2: Using '0' as an error code means a legitimate effective IP of '0'
will be misinterpreted as a failure.  Practically speaking, I highly doubt anyone
will ever actually run code at address 0, but it's technically possible.  The
most robust approach would be to pass a pointer to @ip and return an actual error
code.  Using a non-canonical magic value might also work, but that could run afoul
of future shenanigans like LAM.

	ip = insn_get_effective_ip(regs);
	if (!ip)
		return 0;
