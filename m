Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E331CE50E
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 22:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbgEKUHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 16:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729215AbgEKUHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 16:07:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A64C061A0C;
        Mon, 11 May 2020 13:07:16 -0700 (PDT)
Received: from zn.tnic (p200300EC2F05F100A8DEEC94B2257A59.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:f100:a8de:ec94:b225:7a59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D318C1EC0181;
        Mon, 11 May 2020 22:07:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589227635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=6V0UglHmaPSn0pB7O5vwdd6aAFUZM3fIGTypXgEARCU=;
        b=BMJCAA/UBiKZxAw/nUA7M3/0bJYk5/UYgZ3bdMYa+unPvnqZd8t1p+785fVTys2QvCbQFs
        lCJitOtnkhOhGi4I00ZpvyqaIsWnkNWYeHeUpIYoko6aQucsWFbcs7U1XmBA+Kh5Gie/1X
        j7jJxWHctWYX79YCC0gI55on7Ud9r7s=
Date:   Mon, 11 May 2020 22:07:09 +0200
From:   Borislav Petkov <bp@alien8.de>
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
Subject: Re: [PATCH v3 23/75] x86/boot/compressed/64: Setup GHCB Based VC
 Exception handler
Message-ID: <20200511200709.GE25861@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-24-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-24-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:33PM +0200, Joerg Roedel wrote:
> @@ -63,3 +175,45 @@ void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
>  	while (true)
>  		asm volatile("hlt\n");
>  }
> +
> +static enum es_result vc_insn_string_read(struct es_em_ctxt *ctxt,
> +					  void *src, char *buf,
> +					  unsigned int data_size,
> +					  unsigned int count,
> +					  bool backwards)
> +{
> +	int i, b = backwards ? -1 : 1;
> +	enum es_result ret = ES_OK;
> +
> +	for (i = 0; i < count; i++) {
> +		void *s = src + (i * data_size * b);
> +		char *d = buf + (i * data_size);

From a previous review:

Where are we checking whether that count is not exceeding @buf or
similar discrepancies?

Ditto below.

> +
> +		ret = vc_read_mem(ctxt, s, d, data_size);
> +		if (ret != ES_OK)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +static enum es_result vc_insn_string_write(struct es_em_ctxt *ctxt,
> +					   void *dst, char *buf,
> +					   unsigned int data_size,
> +					   unsigned int count,
> +					   bool backwards)
> +{
> +	int i, s = backwards ? -1 : 1;
> +	enum es_result ret = ES_OK;
> +
> +	for (i = 0; i < count; i++) {
> +		void *d = dst + (i * data_size * s);
> +		char *b = buf + (i * data_size);
> +
> +		ret = vc_write_mem(ctxt, d, b, data_size);
> +		if (ret != ES_OK)
> +			break;
> +	}
> +
> +	return ret;
> +}
> -- 
> 2.17.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
