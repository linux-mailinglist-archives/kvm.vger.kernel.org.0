Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F21E344F56
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 19:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhCVS5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 14:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhCVS4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 14:56:46 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A18C061762
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 11:56:45 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 11so11650491pfn.9
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 11:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=meEW8j4RJB41y0aX/BJ31GvzjYBgkYNc3Bk1g56lS4c=;
        b=FYmy8/b9CYLzWuaCW800x0BLr+B35vF+M0Wn/b6s6DoGAhFqP0wmC9sMN8clixXNOo
         YpnnM9O8JHfSQ0O1sMRNIoLwYxkeS3xqyrQgefQwaxgn5zEuQio774WS6/rbxTgrISB3
         Y7GHo0MzN1lhWqMvBYZ/z5/T5rscgDFOd11Qo7RHaAbBLSopLzxjGyQY/oPBaBROzAAF
         qWhhDFkTwvcemMmgYzkbd3bzIEjb8jvdhFenNfjD8bSRm34h8h/0w9h/6js8wPV7A/R/
         T/mYAY/yNGNgBvwJ98yIWbJEqxZgw3nhMit2cxBc28EmvynZSe02lZATQ/4uUENcQG05
         Mcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=meEW8j4RJB41y0aX/BJ31GvzjYBgkYNc3Bk1g56lS4c=;
        b=CTaesLDNJtv5Hq5VvpAYLriBqvg92aYrEKPpdb6+5aVWuGxAxaDOYYnbgG35nGdBWW
         f1EtwNXjK3vWFwlyQZhK8E8ie3yPvj2AV80M3wIirGoWJ1vrxVFR8krHiPd5h09ETGDT
         C/gM1sQxBPQa5fXw9wqf9IOKXggrKOLUWTQP0h3TpoeTtbU6viwF14Md77rCUCSmCB9W
         wdQiaf1ca+KdJaIriejU1xui3D40Huj6N4xDXFB7sUuE4u85lGLi94k+P4CCXBJxRUeO
         SthC9W2OQ9HpT4FDN7W6RibyVTCOXUcACHAlLAXGIzXHDW9Gnk66zrc8MZLHOhQN3Y1n
         pSEA==
X-Gm-Message-State: AOAM530GTzGNuMtdIuKQ/T6wx2widohrEpketnkNI8jS/5LXThizlSh5
        BkT1UI22tL2QoKA7SyjzqXqmXw==
X-Google-Smtp-Source: ABdhPJzlx7ODCtnwxOp81NiIrkrB0U3rG9st5XhGj7tk9HWPo8fcJAB/pG4keSmRYjCwKoAN0krdHg==
X-Received: by 2002:a17:902:7407:b029:e4:9645:fdf6 with SMTP id g7-20020a1709027407b02900e49645fdf6mr1085992pll.19.1616439405020;
        Mon, 22 Mar 2021 11:56:45 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:f8cd:ad3d:e69f:e006])
        by smtp.gmail.com with ESMTPSA id a30sm14514984pfr.66.2021.03.22.11.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:56:44 -0700 (PDT)
Date:   Mon, 22 Mar 2021 11:56:37 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YFjoZQwB7e3oQW8l@google.com>
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322181646.GG6481@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021, Borislav Petkov wrote:
> On Fri, Mar 19, 2021 at 08:22:19PM +1300, Kai Huang wrote:
> > +/**
> > + * sgx_encl_free_epc_page - free EPC page assigned to an enclave
> > + * @page:	EPC page to be freed
> > + *
> > + * Free EPC page assigned to an enclave.  It does EREMOVE for the page, and
> > + * only upon success, it puts the page back to free page list.  Otherwise, it
> > + * gives a WARNING to indicate page is leaked, and require reboot to retrieve
> > + * leaked pages.
> > + */
> > +void sgx_encl_free_epc_page(struct sgx_epc_page *page)
> > +{
> > +	int ret;
> > +
> > +	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> > +
> > +	/*
> > +	 * Give a message to remind EPC page is leaked when EREMOVE fails,
> > +	 * and requires machine reboot to get leaked pages back. This can
> > +	 * be improved in future by adding stats of leaked pages, etc.
> > +	 */
> > +#define EREMOVE_ERROR_MESSAGE \
> > +	"EREMOVE returned %d (0x%x).  EPC page leaked.  Reboot required to retrieve leaked pages."
> 
> A reboot? Seriously? Why?
> 
> How are you going to explain to cloud people that they need to reboot
> their fat server? The same cloud people who want to make sure Intel
> supports late microcode loading no matter the effort just so to avoid
> rebooting the machine.
> 
> But now all of a sudden, if they wanna have SGX enclaves in guests, they
> need to get prepared for potential rebooting.

Not necessarily.  This can only trigger in the host, and thus require a host
reboot, if the host is also running enclaves.  If the CSP is not running
enclaves, or is running its enclaves in a separate VM, then this path cannot be
reached.

> I sure hope I'm missing something...

EREMOVE can only fail if there's a kernel or hardware bug (or a VMM bug if
running as a guest).  IME, nearly every kernel/KVM bug that I introduced that
led to EREMOVE failure was also quite fatal to SGX, i.e. this is just the canary
in the coal mine.

It's certainly possible to add more sophisticated error handling, e.g. through
the pages onto a list and periodically try to recover them.  But, since the vast
majority of bugs that cause EREMOVE failure are fatal to SGX, implementing
sophisticated handling is quite low on the list of priorities.

Dave wanted the "page leaked" error message so that it's abundantly clear that
the kernel is leaking pages on EREMOVE failure and that the WARN isn't "benign".
