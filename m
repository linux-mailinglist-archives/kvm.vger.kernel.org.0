Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB62352CB0
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhDBPnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbhDBPm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:42:58 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4A3C0613E6
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 08:42:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e14so2689621plj.2
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 08:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=948hixTMO4Bse84quoCDDTDU0D12jquiYBG/MaisshI=;
        b=rOfzGVulAMSSNZLnXpdUSnMz9qp59WaXkf1bCdPbisSUQcE4FmyzPoa+HvgeMbj93l
         //LpXDGPZI8qPxMgCAS6emI3JB6MgLd+ue+Goct+Ff5JnWOJ/IGdVtXmD0e4/Cc63KKG
         t4yGRDQLmbduzsmnr5fiZ4St2SqOfotviZn9dnz2VJvtVIMUpcxdWoyKu3+VV18pB5wl
         CX8dkPraIbgDYjb8M5mAPt5amM2hKhn76EoylG44tkrLJiAIVmlSNRwEThBmZKoE8JsK
         54Ku+GKrgI+qkfOWbbS+65murE5mtumEh1yNijnkqVPO0ipQhRCl5n1kcSfY6MC+HWCc
         A20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=948hixTMO4Bse84quoCDDTDU0D12jquiYBG/MaisshI=;
        b=Yebz449SM+fEiszzFY/ZCOdgZ2B8xyl4Fi+W/Q5l9SmEiyu9rgpLMzDx/SHFnJxBlR
         gY1Im1iqpvOZw6gAFKzK+IrPedx0aV4r5pA1uaQrQanzoN+1ZZT25zzeUdKt+1ku/HFw
         YsQWJ9urZUybadG+/VOI3Lg0mvhTs2kFnfZioz5CliQNs2uMyaBtMRQ5YhhBp6eMtqh8
         bugRhlUNpPZGMRNsdEnfGTlsqnelYlVe1oqjlETWWH0tm/aMKuxNfT00zPTKK2jnr+tY
         +YG5Vu1qzkABIc8fgNFOedEfv1vVxB485CrwqDWw358Fe7vERI5buths9KjZVZhKTQfj
         Vvqw==
X-Gm-Message-State: AOAM531TUaC3sbeUUzRUl/3bDwysgXONrknz56y64LQYP6RgbaDIS8s1
        liemEPqIAR4E0yce4svjxGaBzQ==
X-Google-Smtp-Source: ABdhPJzEm9zD9QFj85ocvRmTmxRm0r8hRGMzuCeiZsQ/utPofnN/IZWYdnpG9T/w7AaWUS60aALNuA==
X-Received: by 2002:a17:90b:201:: with SMTP id fy1mr14122204pjb.108.1617378175466;
        Fri, 02 Apr 2021 08:42:55 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v9sm9211979pfc.108.2021.04.02.08.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:42:54 -0700 (PDT)
Date:   Fri, 2 Apr 2021 15:42:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YGc7ezLWEu/ZvUOu@google.com>
References: <cover.1616136307.git.kai.huang@intel.com>
 <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
 <20210402094816.GC28499@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402094816.GC28499@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 02, 2021, Borislav Petkov wrote:
> On Fri, Mar 19, 2021 at 08:23:02PM +1300, Kai Huang wrote:
> > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > even if the SGX driver is disabled.  The SGX driver might be disabled
> > if SGX Launch Control is in locked mode, or not supported in the
> > hardware at all.  This allows (non-Linux) guests that support non-LC
> > configurations to use SGX.
> > 
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 6a734f484aa7..b73114150ff8 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -743,7 +743,15 @@ static int __init sgx_init(void)
> >  		goto err_page_cache;
> >  	}
> >  
> > -	ret = sgx_drv_init();
> > +	/*
> > +	 * Always try to initialize the native *and* KVM drivers.
> > +	 * The KVM driver is less picky than the native one and
> > +	 * can function if the native one is not supported on the
> > +	 * current system or fails to initialize.
> > +	 *
> > +	 * Error out only if both fail to initialize.
> > +	 */
> > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> 
> This is a silly way of writing:
> 
>         if (sgx_drv_init() && sgx_vepc_init())
>                 goto err_kthread;
> 
> methinks.

Nope!  That's wrong, as sgx_epc_init() will not be called if sgx_drv_init()
succeeds.  And writing it as "if (sgx_drv_init() || sgx_vepc_init())" is also
wrong since that would kill SGX when one of the drivers is alive and well.
