Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD80344E32
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 19:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhCVSRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 14:17:02 -0400
Received: from mail.skyhub.de ([5.9.137.197]:34438 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhCVSQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 14:16:50 -0400
Received: from zn.tnic (p200300ec2f066700d1873920611831f8.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:6700:d187:3920:6118:31f8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 59C821EC030E;
        Mon, 22 Mar 2021 19:16:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616437008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3sq6YdCU8BJZWUhxdT9joEhe9PvoQnzQQ2RK2v1z+H8=;
        b=MoGcW+JDPtktaezfhT++xmj2lP8G5368TPMntW8qBgd6Sg5cnyKC89vcO88q8oR947Fq77
        TJn8olrWVfII8AgT1V6ZcEWU7V9+iXkS/qd+Ljh5T8ks4vu1ybVGvmEXHSNCOKkOcDjLcd
        dSOB057xAfY8CmwzZ/y9v7i4Je+5gTY=
Date:   Mon, 22 Mar 2021 19:16:46 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <20210322181646.GG6481@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 08:22:19PM +1300, Kai Huang wrote:
> +/**
> + * sgx_encl_free_epc_page - free EPC page assigned to an enclave
> + * @page:	EPC page to be freed
> + *
> + * Free EPC page assigned to an enclave.  It does EREMOVE for the page, and
> + * only upon success, it puts the page back to free page list.  Otherwise, it
> + * gives a WARNING to indicate page is leaked, and require reboot to retrieve
> + * leaked pages.
> + */
> +void sgx_encl_free_epc_page(struct sgx_epc_page *page)
> +{
> +	int ret;
> +
> +	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> +
> +	/*
> +	 * Give a message to remind EPC page is leaked when EREMOVE fails,
> +	 * and requires machine reboot to get leaked pages back. This can
> +	 * be improved in future by adding stats of leaked pages, etc.
> +	 */
> +#define EREMOVE_ERROR_MESSAGE \
> +	"EREMOVE returned %d (0x%x).  EPC page leaked.  Reboot required to retrieve leaked pages."

A reboot? Seriously? Why?

How are you going to explain to cloud people that they need to reboot
their fat server? The same cloud people who want to make sure Intel
supports late microcode loading no matter the effort just so to avoid
rebooting the machine.

But now all of a sudden, if they wanna have SGX enclaves in guests, they
need to get prepared for potential rebooting.

I sure hope I'm missing something...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
