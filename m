Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868BD1DAE71
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 11:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgETJOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 05:14:24 -0400
Received: from mail.skyhub.de ([5.9.137.197]:43102 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETJOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 05:14:23 -0400
Received: from zn.tnic (p200300ec2f0bab00d907527c3c1e360d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:ab00:d907:527c:3c1e:360d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 47C811EC032C;
        Wed, 20 May 2020 11:14:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589966062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LiDZJ/nDDOx6HNQyMN6etFUDBDZ4zUzKnqjvmtstft0=;
        b=NAfDGZuYM1NLD2lCZ1oQZIZ7UGOSHsSZ0Zu/lgomzdOS6sf36E9Rj79WbRNcWpl86KpX+L
        zvCKYyoH/HH8DbtCZKcEsv40un5TfHc0NyTxCuLOPjo0ovPggkKuqcLUUbHTcKokbQ/mS0
        o0l9nWvwsPxoFmCz1B3jcXZp80MWqlM=
Date:   Wed, 20 May 2020 11:14:15 +0200
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
Subject: Re: [PATCH v3 40/75] x86/sev-es: Compile early handler code into
 kernel image
Message-ID: <20200520091415.GC1457@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-41-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-41-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:50PM +0200, Joerg Roedel wrote:
> +static inline u64 sev_es_rd_ghcb_msr(void)
> +{
> +	return native_read_msr(MSR_AMD64_SEV_ES_GHCB);
> +}
> +
> +static inline void sev_es_wr_ghcb_msr(u64 val)
> +{
> +	u32 low, high;
> +
> +	low  = (u32)(val);
> +	high = (u32)(val >> 32);
> +
> +	native_write_msr(MSR_AMD64_SEV_ES_GHCB, low, high);
> +}

Instead of duplicating those two, you can lift the ones in the
compressed image into sev-es.h and use them here. I don't care one bit
about the MSR tracepoints in native_*_msr().

> +static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
> +				   char *dst, char *buf, size_t size)
> +{
> +	unsigned long error_code = X86_PF_PROT | X86_PF_WRITE;
> +	char __user *target = (char __user *)dst;
> +	u64 d8;
> +	u32 d4;
> +	u16 d2;
> +	u8  d1;
> +
> +	switch (size) {
> +	case 1:
> +		memcpy(&d1, buf, 1);
> +		if (put_user(d1, target))
> +			goto fault;
> +		break;
> +	case 2:
> +		memcpy(&d2, buf, 2);
> +		if (put_user(d2, target))
> +			goto fault;
> +		break;
> +	case 4:
> +		memcpy(&d4, buf, 4);
> +		if (put_user(d4, target))
> +			goto fault;
> +		break;
> +	case 8:
> +		memcpy(&d8, buf, 8);
> +		if (put_user(d8, target))
> +			goto fault;

Ok, those (and below) memcpys get nicely optimized to MOVs by the
compiler here.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
