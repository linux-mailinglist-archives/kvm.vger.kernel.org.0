Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5381925514D
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 00:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgH0WsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 18:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgH0WsO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 18:48:14 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7A4C061264;
        Thu, 27 Aug 2020 15:48:13 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id p25so7764061qkp.2;
        Thu, 27 Aug 2020 15:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y2apmauJqQxWRpgQvwb+Zmg3D+lXVvnQVjZBHrBv0Go=;
        b=RsiMaFmhnOCD5XVKA2gNSkEsXK540EqNGscrDEBjxtDvkRikQp/qmY1NJ+ybo84OOp
         Eyvfz5G4N10SSYayeFA3jEXXizLZsivTuL8P3vHjoqdhZYH1AAh8+r+yQHvpbvtwBDih
         TunbvS1/nhe7a5QXX7X+7H4UFu0uUwcD8l8R5B+/IRg/H9tPcKGZpW7lZotP6A1vowpC
         cW8o5ARcOqPUoFjGR5IevTyD14DTtEW1k59XzNa2kd7bKjjK4NHTpiHH7kVpjQ4UbvQQ
         RhP+gz9w9wFjZO2cfdU4nYyNQJoBUHuA5zUxu2JtD5tWMLNNKWL8WRkcggs3/PlWfRjN
         OMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Y2apmauJqQxWRpgQvwb+Zmg3D+lXVvnQVjZBHrBv0Go=;
        b=kpSI5DCFkFMKCOMImfdwNz9jhP4tt5NmfG4qB/OPvreQvw4/Kiri5kBgf/xVKMGQuN
         9XFN04DfrNaJx10mcDrfor58HXr/wo4AqnW9Z0tk3v/wlRwGfXyM49PiEtmc4G0aUMAC
         8GyW/phR4hBUF5yNbicqVLHFUgFnhJAwA8Sm2ZulGUYMIHLIbLKWb/Va00gytr0vEUns
         i32ipez3lIN6s/rUhfgLrCFRHhyuuK+eo3cwMYjYmV7NVy7Ad7isUXrmzquqUud+igVN
         vOSI6YS++BDQ1HxlZJkh4G1inGZrdJiWzudOFfe4t48pX1zvP+htHtvtHGzZYNQkf+fE
         qYAg==
X-Gm-Message-State: AOAM533hwM9uiEP2Y+o9KidN2rLsCeCgDisfZJvyUy1xcfalXC8cSCgF
        x+nH9Sg4PTC95wZAqxg+A2g=
X-Google-Smtp-Source: ABdhPJzwDTK91WvNvq8E6g5kUeSK5dWZl7/Bap/DMiLhxt0h5fc0gSs3IYAL5uhBmfvgsemamjTKQg==
X-Received: by 2002:a05:620a:148a:: with SMTP id w10mr14211312qkj.281.1598568492613;
        Thu, 27 Aug 2020 15:48:12 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id a20sm2909161qtw.45.2020.08.27.15.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 15:48:12 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 27 Aug 2020 18:48:10 -0400
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 27/76] x86/sev-es: Add CPUID handling to #VC handler
Message-ID: <20200827224810.GA986963@rani.riverdale.lan>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-28-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-28-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:22AM +0200, Joerg Roedel wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Handle #VC exceptions caused by CPUID instructions. These happen in
> early boot code when the KASLR code checks for RDTSC.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ jroedel@suse.de: Adapt to #VC handling framework ]
> Co-developed-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Link: https://lore.kernel.org/r/20200724160336.5435-27-joro@8bytes.org
> ---
> +
> +static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
> +				      struct es_em_ctxt *ctxt)
> +{
> +	struct pt_regs *regs = ctxt->regs;
> +	u32 cr4 = native_read_cr4();
> +	enum es_result ret;
> +
> +	ghcb_set_rax(ghcb, regs->ax);
> +	ghcb_set_rcx(ghcb, regs->cx);
> +
> +	if (cr4 & X86_CR4_OSXSAVE)

Will this ever happen? trampoline_32bit_src will clear CR4 except for
PAE and possibly LA57, no?

> +		/* Safe to read xcr0 */
> +		ghcb_set_xcr0(ghcb, xgetbv(XCR_XFEATURE_ENABLED_MASK));
> +	else
> +		/* xgetbv will cause #GP - use reset value for xcr0 */
> +		ghcb_set_xcr0(ghcb, 1);
> +
> +	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
> +	if (ret != ES_OK)
> +		return ret;
> +
> +	if (!(ghcb_rax_is_valid(ghcb) &&
> +	      ghcb_rbx_is_valid(ghcb) &&
> +	      ghcb_rcx_is_valid(ghcb) &&
> +	      ghcb_rdx_is_valid(ghcb)))
> +		return ES_VMM_ERROR;
> +
> +	regs->ax = ghcb->save.rax;
> +	regs->bx = ghcb->save.rbx;
> +	regs->cx = ghcb->save.rcx;
> +	regs->dx = ghcb->save.rdx;
> +
> +	return ES_OK;
> +}
> -- 
> 2.28.0
> 
