Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3BA328839
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 18:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbhCARfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 12:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238087AbhCARam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 12:30:42 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5673BC061756
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 09:29:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d13-20020a17090abf8db02900c0590648b1so2648062pjs.1
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 09:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dsBZmo7yHiiMQ5Fonyw4uCM2dBJFr4DMbpHeKPUN97w=;
        b=VHmr5H/HHBNEIniUAlXBwTWXqsPNhR4dVZFxuWdraxH3/sVGt/Mk2LJ7gU2J7OhNbk
         NbOtCF2MU+tUkoymahODmgPtSlN22JITLVnra7OdLWuX9irDfljX34IWWSt/8/VttCLR
         DpNTezrcV2vDUhY+qsXGKwWCPCQMm60H1JtBUuPcqzYVkY6hhfF+o+7AARuuLooepwue
         zQGYX4IyEpVFFvFgSkXKGJ5fTHUTiAuMATxrFec12zLski1GrFPa1PWB1zvp0XruULFP
         hsuZeBiONLsCSASL3dJNYZ3G4inRDB4O8ebFsxfAbNxNFvwFq4mnD8ifwA2Gn3pDPP0m
         8a/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dsBZmo7yHiiMQ5Fonyw4uCM2dBJFr4DMbpHeKPUN97w=;
        b=XaE6G9W0f8CnqXkhRhGDDZ0UYAXU9Fk91c5/U94RJvvDQRYcAxYmw74V5nI74gizuq
         A2a9BskVS17pQgMiJxXDhnjUIm9JEqBKSoSXHhoEl1x+aYzuRwuYS50U++ukHEln0ErK
         xRqdTcFvxg434posilRKIBxTD9h3CrxsIay0BkGhlVBMoAQsrGblcY/IqVHgP+f7mcMm
         Qw/jTX0c2B51YEGmOAOUCGVOmSyEwraYo2I14tDVts0HMnN8QlHEo4tBMXj2Mv1qJeTx
         OsF8T5QhPKTHM1BAAByPujeNqeZf2yB6RRbvCEC4CWgM3clT9BQ/eKsyZTxRTKDJR2zx
         1wvA==
X-Gm-Message-State: AOAM532agFQP+4PmLIRra5ULzyrI6XEez4vObz0Jl/Rcj9Ke8uzvNf5r
        qrZmQydD7Lmctsd/SX5ud7MVpA==
X-Google-Smtp-Source: ABdhPJxh/vRQVuNDLKJNR2CEhMj6qkhFIK/a7szLZE7YY41foVpV1i/0wP9iTRQYyLOibfWjazkjrQ==
X-Received: by 2002:a17:90a:67ca:: with SMTP id g10mr18209260pjm.166.1614619794419;
        Mon, 01 Mar 2021 09:29:54 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id s16sm18604412pfs.39.2021.03.01.09.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:29:53 -0800 (PST)
Date:   Mon, 1 Mar 2021 09:29:46 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 03/25] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Message-ID: <YD0kinxqJF1w+BZf@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
 <9c2c83ccc7324390bfb302bd327d9236b890c679.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c2c83ccc7324390bfb302bd327d9236b890c679.1614590788.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021, Kai Huang wrote:
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 7449ef33f081..a7dc86e87a09 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -381,6 +381,26 @@ const struct vm_operations_struct sgx_vm_ops = {
>  	.access = sgx_vma_access,
>  };
>  
> +static void sgx_encl_free_epc_page(struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +
> +	WARN_ON_ONCE(epc_page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> +
> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret)) {

This can be ENCLS_WARN, especially if you're printing a separate error message
about leaking the page.  That being said, I'm not sure a seperate error message
is a good idea.  If other stuff gets dumped to the kernel log between the WARN
and the pr_err_once(), it may not be clear to admins that the two events are
directly connected.  It's even possible the prints could come from two different
CPUs.

Why not dump a short blurb in the WARN itself?  The error message can be thrown
in a define if the line length is too obnoxious (it's ~109 chars if embedded
directly).

#define EREMOVE_ERROR_MESSAGE \
	"EREMOVE returned %d (0x%x).  EPC page leaked, reboot recommended."

	if (WARN_ONCE(ret, EREMOVE_ERROR_MESSAGE, ret, ret))

> +		/*
> +		 * Give a message to remind EPC page is leaked, and requires
> +		 * machine reboot to get leaked pages back. This can be improved
> +		 * in the future by adding stats of leaked pages, etc.
> +		 */
> +		pr_err_once("EPC page is leaked. Require machine reboot to get leaked pages back.\n");
> +		return;
> +	}
> +
> +	sgx_free_epc_page(epc_page);
> +}
> +
>  /**
>   * sgx_encl_release - Destroy an enclave instance
>   * @kref:	address of a kref inside &sgx_encl
