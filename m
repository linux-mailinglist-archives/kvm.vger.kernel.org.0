Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D880D1E085C
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 10:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgEYICf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 04:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgEYICf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 04:02:35 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62738C061A0E;
        Mon, 25 May 2020 01:02:35 -0700 (PDT)
Received: from zn.tnic (p200300ec2f06f3004418adec9d2f63e2.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:f300:4418:adec:9d2f:63e2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 514AC1EC0116;
        Mon, 25 May 2020 10:02:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590393752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=HbItycmNHopexuynDp8v3E/cG41XLiYYR0XUaufHcT4=;
        b=RmXdg7Qxfd5JvK24kf//ZDbwbxh9yQ5WD9aNGgVJpTGZHMBxdRlxPXD/+P3C9pxjmN05Qr
        5k/sXpwDV7HfYvnPa5HDdxDwTKYlbnKTymFHiUjx9bi13AXJXs4jZcYgeAQv5CG+57bxS3
        17uS9WxUnIQaMuJTnaWakP3wDY6lsTk=
Date:   Mon, 25 May 2020 10:02:26 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 51/75] x86/sev-es: Handle MMIO events
Message-ID: <20200525080226.GB25636@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-52-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-52-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:01PM +0200, Joerg Roedel wrote:
> +static enum es_result vc_do_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
> +				 unsigned int bytes, bool read)
> +{
> +	u64 exit_code, exit_info_1, exit_info_2;
> +	unsigned long ghcb_pa = __pa(ghcb);
> +	void __user *ref;
> +
> +	ref = insn_get_addr_ref(&ctxt->insn, ctxt->regs);
> +	if (ref == (void __user *)-1L)
> +		return ES_UNSUPPORTED;
> +
> +	exit_code = read ? SVM_VMGEXIT_MMIO_READ : SVM_VMGEXIT_MMIO_WRITE;
> +
> +	exit_info_1 = vc_slow_virt_to_phys(ghcb, (unsigned long)ref);
> +	exit_info_2 = bytes;    /* Can never be greater than 8 */

No trailing comments pls - put them over the line.

> +	ghcb->save.sw_scratch = ghcb_pa + offsetof(struct ghcb, shared_buffer);
> +
> +	return sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1, exit_info_2);
> +}
> +
> +static enum es_result vc_handle_mmio_twobyte_ops(struct ghcb *ghcb,
> +						 struct es_em_ctxt *ctxt)
> +{
> +	struct insn *insn = &ctxt->insn;
> +	unsigned int bytes = 0;
> +	enum es_result ret;
> +	int sign_byte;
> +	long *reg_data;
> +
> +	switch (insn->opcode.bytes[1]) {
> +		/* MMIO Read w/ zero-extension */
> +	case 0xb6:
> +		bytes = 1;
> +		/* Fallthrough */

I'm guessing we're supposed to annotate it this way now:

WARNING: Prefer 'fallthrough;' over fallthrough comment
#139: FILE: arch/x86/kernel/sev-es.c:504:
+               /* Fallthrough */


> +	case 0xb7:
> +		if (!bytes)
> +			bytes = 2;
> +
> +		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
> +		if (ret)
> +			break;
> +
> +		/* Zero extend based on operand size */
> +		reg_data = vc_insn_get_reg(ctxt);

That function can return NULL - you need to test reg_data. Ditto for all
its invocations.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
