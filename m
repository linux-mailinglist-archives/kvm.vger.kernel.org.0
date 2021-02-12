Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EBB319E37
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 13:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhBLMSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 07:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231424AbhBLMQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 07:16:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F93064E30;
        Fri, 12 Feb 2021 12:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613132168;
        bh=YM71L3KgJ5vhdkm9aOduu01P6kHDFTIdYnY/AOihbEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m7Z9tstajLLuAG0s2ScxCwKrBPoDPaEE7vbLSolA5jiGHbKrE6METg5vULAkUv2iM
         MXjt51rVvXOjmN1QoI2EX48t1dMSfI/SyD2YL48uVc5FGYkF0PO84BCyMfbKIu/umO
         EwRVLk2ySSnxUpg5LHVnEqYXdeFiWuuHo2Z11qX1kssKkTagRquXIB5e3ZlG7OhkcM
         aQKCc4YVG+3DOtdKMtsXlQXp/Ah0/4C1RiAphDx0RU/Y63wUJzmiupYdCVG8qx//hh
         057v+HXJttnChsGU2K5UdZR7IQAbkFjdb9croCSE/cvt/qbd4tQGROFD1ccG1mqd3v
         YR67aICLNfwcQ==
Date:   Fri, 12 Feb 2021 14:15:59 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YCZxf+B2jtPmS5uk@kernel.org>
References: <cover.1612777752.git.kai.huang@intel.com>
 <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
 <YCL8ErAGKNSnX2Up@kernel.org>
 <YCL8eNNfuo2k5ghO@kernel.org>
 <9aebc8e6-cff5-b2b4-04af-d3968a3586dc@intel.com>
 <ec9604199072e185de4b6b74209e84f30423c5e3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ec9604199072e185de4b6b74209e84f30423c5e3.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 01:20:32PM +1300, Kai Huang wrote:
> On Tue, 2021-02-09 at 13:36 -0800, Dave Hansen wrote:
> > On 2/9/21 1:19 PM, Jarkko Sakkinen wrote:
> > > > Without that clearly documented, it would be unwise to merge this.
> > > E.g.
> > > 
> > > - Have ioctl() to turn opened fd as vEPC.
> > > - If FLC is disabled, you could only use the fd for creating vEPC.
> > > 
> > > Quite easy stuff to implement.
> > 
> > The most important question to me is not how close vEPC is today, but
> > how close it will be in the future.  It's basically the age old question
> > of: do we make one syscall that does two things or two syscalls?
> > 
> > Is there a _compelling_ reason to change direction?  How much code would
> > we save?
> 
> Basically we need to defer 'sgx_encl' related code from open to after mmap(). For
> instance, We need to defer 'sgx_encl' allocation from open to SGX_IOC_ENCLAVE_CREATE.
> And due to this change, we also need to move some members out of 'sgx_encl', and use
> them as common for enclave and vEPC. The 'struct xarray page_array' would be a good
> example.
> 
> The code we can save, from my first glance, is just misc_register("/dev/sgx_vepc")
> related, maybe plus some mmap() related code. The logic to handle both host enclave
> and vEPC still needs to be there.
> 
> To me the major concern is /dev/sgx_enclave, by its name, implies it is associated
> with host enclave. Adding IOCTL to *convert* it to vEPC is just mixing things up, and
> is ugly. If we really want to do this, IMHO we need at least change /dev/sgx_enclave
> to /dev/sgx_epc, for instance, to imply the fd we opened and mmap()'d just represents
> some raw EPC. However this is changing to existing userspace ABI.
> 
> Sean,
> 
> What's your opinion? Did I miss anything?

I think this mostly makes sense to me.

And also, it gives an opportunity to have add some granularity to access
control (worth of mentioning in the commit message).

Thanks.

/Jarkko
