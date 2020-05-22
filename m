Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B861DE1ED
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 10:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbgEVIdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 04:33:35 -0400
Received: from mail.skyhub.de ([5.9.137.197]:38344 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729382AbgEVIdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 04:33:33 -0400
Received: from zn.tnic (p200300ec2f0d4900b115cc0add6835a7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:4900:b115:cc0a:dd68:35a7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AA2481EC02B3;
        Fri, 22 May 2020 10:33:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590136411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=MWGiXlMNmCUQrdL2VMbcT6Bsa2l19TPcZCK5SYOHTQo=;
        b=O9AFrS5SFc4FVW5LZq+2OvQsE8crvfBABJ6KpFEy5z3reuvsHKsaxuPdeTSNV1SR9Tpc8K
        8JMk0rMt3O+4UuTn07lpAK8mVm4KNWW57XrXVQNzFsFoxwcCmjNHfhZCOrBpkQWXNqQWHb
        DOaEnO50y9eDEQvBB3+TP2+26IxN5AM=
Date:   Fri, 22 May 2020 10:33:21 +0200
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
Subject: Re: [PATCH v3 43/75] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
Message-ID: <20200522083321.GA28750@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-44-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-44-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:53PM +0200, Joerg Roedel wrote:
> @@ -198,6 +210,48 @@ static bool __init sev_es_setup_ghcb(void)
>  	return true;
>  }
>  
> +static void __init sev_es_alloc_runtime_data(int cpu)
> +{
> +	struct sev_es_runtime_data *data;
> +
> +	data = memblock_alloc(sizeof(*data), PAGE_SIZE);
> +	if (!data)
> +		panic("Can't allocate SEV-ES runtime data");
> +
> +	per_cpu(runtime_data, cpu) = data;
> +}
> +
> +static void __init sev_es_init_ghcb(int cpu)

Since those are static functions, I'd drop the "sev_es_" prefix from the
name for better readability. Because otherwise the whole file is a sea
of "sev_es_"-prefixed identifiers which you need to read until the end
to know what they are.

> +{
> +	struct sev_es_runtime_data *data;
> +	int err;
> +
> +	data = per_cpu(runtime_data, cpu);
> +
> +	err = early_set_memory_decrypted((unsigned long)&data->ghcb_page,
> +					 sizeof(data->ghcb_page));
> +	if (err)
> +		panic("Can not map GHCBs unencrypted");

			"Error mapping ..."

> +
> +	memset(&data->ghcb_page, 0, sizeof(data->ghcb_page));
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
