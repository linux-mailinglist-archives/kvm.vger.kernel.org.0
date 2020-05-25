Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92041E0C56
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 12:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389932AbgEYK7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 06:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389484AbgEYK7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 06:59:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B765C061A0E;
        Mon, 25 May 2020 03:59:43 -0700 (PDT)
Received: from zn.tnic (p200300ec2f06f3002884bb6a9703d441.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:f300:2884:bb6a:9703:d441])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BF2A61EC01E0;
        Mon, 25 May 2020 12:59:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590404381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=BjuXSESQj06++1FVczfy6FPyMVhHDlsVpK90rZ0EYqU=;
        b=HJA9f4y3T8PN5nUEk1pZ8uRkMTTM3Rf089DcwCcMSLgS8ImdyeWEAv8P0TP8gZdv80RS1x
        8riSP7CGgsZfc4RE1b8xT2EYlmG7e7GD1zMM4O44byf2wekd9uH1EIzWMxI6C8VG61nAM2
        OAbaJ3Se1DYjOQ30eg1u9Dd/MxWs0Kg=
Date:   Mon, 25 May 2020 12:59:35 +0200
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
Subject: Re: [PATCH v3 54/75] x86/sev-es: Handle DR7 read/write events
Message-ID: <20200525105935.GH25636@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-55-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-55-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:04PM +0200, Joerg Roedel wrote:
> +static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
> +					  struct es_em_ctxt *ctxt)
> +{
> +	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
> +	long val, *reg = vc_insn_get_rm(ctxt);
> +	enum es_result ret;
> +
> +	if (!reg)
> +		return ES_DECODE_FAILED;
> +
> +	val = *reg;
> +
> +	/* Upper 32 bits must be written as zeroes */
> +	if (val >> 32) {
> +		ctxt->fi.vector = X86_TRAP_GP;
> +		ctxt->fi.error_code = 0;
> +		return ES_EXCEPTION;
> +	}
> +
> +	/* Clear out other reservered bits and set bit 10 */

"reserved"

> +	val = (val & 0xffff23ffL) | BIT(10);
> +
> +	/* Early non-zero writes to DR7 are not supported */
> +	if (!data && (val & ~DR7_RESET_VALUE))
> +		return ES_UNSUPPORTED;
> +
> +	/* Using a value of 0 for ExitInfo1 means RAX holds the value */
> +	ghcb_set_rax(ghcb, val);
> +	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WRITE_DR7, 0, 0);
> +	if (ret != ES_OK)
> +		return ret;
> +
> +	if (data)
> +		data->dr7 = val;

Are we still returning ES_OK if !data?

> +
> +	return ES_OK;
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
