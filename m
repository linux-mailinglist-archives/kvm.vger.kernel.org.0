Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71C830ADB0
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhBARYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhBARYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 12:24:05 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20215C061756
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 09:23:26 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e12so1177339pls.4
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 09:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9E0GZTfD0OA02q73XXsHXPjWkg/VrnXV/UimqNs2u/E=;
        b=gD0R+WWEXz93nBxxqPBDVQT6VZbWF3Vv2AWFZvd6W9pd+B1ZaM4BGwle4Pk7bOF8+2
         stK3J3hDPr6/aBUPPT4cl7IM0VwDMrX4upH4rVJHdGqoJC9Tm581hivIMePcLze2jGNM
         6pmxfOCJI1jMM1aniPHomJd6y3IOULNVturxxiEoCE0K9y/iJjanCpS9mNNYi2YvEYuu
         R5b+YA21oFlyGwVmOB5qUN0Ph5WtluSj6+FRGl8ktvIMRv1XJjhtegwT4iTw1jnV/J+A
         QHXrBIjTVTRu5KYBBzK/ELZqLdW1PZRvcC08xOoURS41hoVl0WXAXcpZtB35xax/al2C
         eWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9E0GZTfD0OA02q73XXsHXPjWkg/VrnXV/UimqNs2u/E=;
        b=I2I/qPlTKLLjSlsOh/1QavUSe2O8vGoTLazcHaF8EaseSRRiTFCUEeuITZI7FMJ0NE
         Qp93YcM3G3cLE3H8E4250ukr9T5u6qF9z83fjSLtu3q4PT0gO3pMJRGNNeud2d0aJm9I
         ZXgD9Ynm1jb7a9KYUZeNmRy2dPxu2nv7zvzhVXanmbsy620G2Kh4fTXtnhMkJeUnH6ly
         YB5S+JqZ9KD1kknfTErS4UONfif5utD/ejKyoVYMflUbaT/daL7q7/dXMQeyJA/JSeiv
         P1UJBnNf6g8xj5LZx1ijHLAPohnK2S712dvpBKCEvyPqrqm+euquoOUjHeh/UPNYjcAq
         3HVQ==
X-Gm-Message-State: AOAM533e1qrS/6BXg0JOlWPsMnNhqJ6uo6h5qxFsJoCTjS9dzKXlnOP/
        doEDhhzL67SkUlOc8bjbjTPfeg==
X-Google-Smtp-Source: ABdhPJyG6qMXCDzBhJ1M0vVcr+ePuvV5kkvchzwtbizMAl9r4GNA0R6P5SlGZ7XjJH/oeWz81Md4uA==
X-Received: by 2002:a17:90b:1955:: with SMTP id nk21mr12832220pjb.206.1612200205533;
        Mon, 01 Feb 2021 09:23:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:829:fccd:80d7:796f])
        by smtp.gmail.com with ESMTPSA id m11sm16404799pjz.44.2021.02.01.09.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:23:24 -0800 (PST)
Date:   Mon, 1 Feb 2021 09:23:18 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBg5BradIvA4jNGw@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <dc3bc76e-fd89-011d-513b-fac6c6f5e0f0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc3bc76e-fd89-011d-513b-fac6c6f5e0f0@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021, Dave Hansen wrote:
> On 1/31/21 9:40 PM, Kai Huang wrote:
> >>> -	ret = sgx_drv_init();
> >>> +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> >>> +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> >> If would create more dumb code and just add
> >>
> >> ret = sgx_vepc_init()
> >> if (ret)
> >>         goto err_kthread;
> 
> Jarkko, I'm not sure I understand this suggestion.
> 
> > Do you mean you want below?
> > 
> > 	ret = sgx_drv_init();
> > 	ret = sgx_vepc_init();
> > 	if (ret)
> > 		goto err_kthread;
> > 
> > This was Sean's original code, but Dave didn't like it.

The problem is it's wrong.  That snippet would incorrectly bail if drv_init()
succeeds but vepc_init() fails.

The alternative to the bitwise AND is to snapshot the result in two separate
variables:

	ret = sgx_drv_init();
	ret2 = sgx_vepc_init();
	if (ret && ret2)
		goto err_kthread;

or check the return from drv_init() _after_ vepc_init():

	ret = sgx_drv_init();
	if (sgx_vepc_init() && ret)
		goto err_kthread;


As evidenced by this thread, the behavior is subtle and easy to get wrong.  I
deliberately chose the option that was the weirdest specifically to reduce the
probability of someone incorrectly "cleaning up" the code.

> Are you sure?  I remember the !!&!! abomination being Sean's doing. :)

Yep!  That 100% functionally correct horror is my doing.

> > Sean/Dave,
> > 
> > Please let me know which way you prefer.
> 
> Kai, I don't really know you are saying here.  In the end,
> sgx_vepc_init() has to run regardless of whether sgx_drv_init() is
> successful or not.  Also, we only want to 'goto err_kthraed' if *BOTH*
> fail.  The code you have above will, for instance, 'goto err_kthread' if
> sgx_drv_init() succeeds but sgx_vepc_init() fails.  It entirely
> disregards the sgx_drv_init() error code.

