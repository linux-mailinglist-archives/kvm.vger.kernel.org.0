Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C91339DA9
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 11:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhCMKqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 05:46:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233761AbhCMKqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 05:46:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88D6464F1C;
        Sat, 13 Mar 2021 10:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615632379;
        bh=qAaJYRNOuNIk1PDV0g7I91KX2FFogaJhE/pcVuFhjKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOean60Xw4PRLx+aSGJgUzFjL/7NZKisHmr5TiQ7H07Y3VmAINhrFg9yWpEkaMkwD
         ymCqO1ZtITZqtjKrtB4Ro/EoeVf3Mw5g6UGKncF5FKI3Nw/vQYQPKutm/0H7EMFMs2
         Ul6ncBkdQ57FuFmkVfpXs7FmRR7nJO2w4kmWBuz1SNMNt3HMvzzNjeAH95ayD5BPLA
         wNQFCGJ653edFu7YYKnVZtpp4SxlT2liIx14kTNUgohQSkWgflPpaqyMdBZm0wXg8o
         92OR9b/J2kUaKEmGGAxQ67dsxuVGbVSMwEU5zFyH045EV9pQaLFTq/KQgB6PkjIjZ0
         qM8ucwdbXCsQA==
Date:   Sat, 13 Mar 2021 12:45:53 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YEyX4V7BcS3MZNzp@kernel.org>
References: <e1ca4131bc9f98cf50a1200efcf46080d6512fe7.1615250634.git.kai.huang@intel.com>
 <20210311020142.125722-1-kai.huang@intel.com>
 <YEvbcrTZyiUAxZAu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEvbcrTZyiUAxZAu@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 01:21:54PM -0800, Sean Christopherson wrote:
> On Thu, Mar 11, 2021, Kai Huang wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > EREMOVE takes a page and removes any association between that page and
> > an enclave.  It must be run on a page before it can be added into
> > another enclave.  Currently, EREMOVE is run as part of pages being freed
> > into the SGX page allocator.  It is not expected to fail.
> > 
> > KVM does not track how guest pages are used, which means that SGX
> > virtualization use of EREMOVE might fail.
> > 
> > Break out the EREMOVE call from the SGX page allocator.  This will allow
> > the SGX virtualization code to use the allocator directly.  (SGX/KVM
> > will also introduce a more permissive EREMOVE helper).
> > 
> > Implement original sgx_free_epc_page() as sgx_encl_free_epc_page() to be
> > more specific that it is used to free EPC page assigned to one enclave.
> > Print an error message when EREMOVE fails to explicitly call out EPC
> > page is leaked, and requires machine reboot to get leaked pages back.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> > v2->v3:
> > 
> >  - Fixed bug during copy/paste which results in SECS page and va pages are not
> >    correctly freed in sgx_encl_release() (sorry for the mistake).
> >  - Added Jarkko's Acked-by.
> 
> That Acked-by should either be dropped or moved above Co-developed-by to make
> checkpatch happy.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Oops, my bad. Yup, ack should be removed.

/Jarkko
