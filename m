Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8014A33AC10
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 08:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhCOHMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 03:12:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:44005 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229742AbhCOHMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 03:12:45 -0400
IronPort-SDR: Fkm8yRu0NqpSJT5XOu3E1vQT/OFES5HKdKzvBC1JUBNxPTVUoAU1QGGAdSVBiLa1yUGcG1Awlq
 qHU/+LbNqzBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="250412051"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="250412051"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:12:43 -0700
IronPort-SDR: wmmKrUp01QfEm37nbP7Fnmn3SPZZPjpbOddpGqS18vjjleOpRRiR2Tix7BL1UMGF/3bsFqKxFi
 eG698GUGE5UA==
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="388012988"
Received: from avaldezb-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.198])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:12:39 -0700
Date:   Mon, 15 Mar 2021 20:12:36 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210315201236.de3cd9389f853a418ec53e86@intel.com>
In-Reply-To: <YEyX4V7BcS3MZNzp@kernel.org>
References: <e1ca4131bc9f98cf50a1200efcf46080d6512fe7.1615250634.git.kai.huang@intel.com>
        <20210311020142.125722-1-kai.huang@intel.com>
        <YEvbcrTZyiUAxZAu@google.com>
        <YEyX4V7BcS3MZNzp@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 13 Mar 2021 12:45:53 +0200 Jarkko Sakkinen wrote:
> On Fri, Mar 12, 2021 at 01:21:54PM -0800, Sean Christopherson wrote:
> > On Thu, Mar 11, 2021, Kai Huang wrote:
> > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > 
> > > EREMOVE takes a page and removes any association between that page and
> > > an enclave.  It must be run on a page before it can be added into
> > > another enclave.  Currently, EREMOVE is run as part of pages being freed
> > > into the SGX page allocator.  It is not expected to fail.
> > > 
> > > KVM does not track how guest pages are used, which means that SGX
> > > virtualization use of EREMOVE might fail.
> > > 
> > > Break out the EREMOVE call from the SGX page allocator.  This will allow
> > > the SGX virtualization code to use the allocator directly.  (SGX/KVM
> > > will also introduce a more permissive EREMOVE helper).
> > > 
> > > Implement original sgx_free_epc_page() as sgx_encl_free_epc_page() to be
> > > more specific that it is used to free EPC page assigned to one enclave.
> > > Print an error message when EREMOVE fails to explicitly call out EPC
> > > page is leaked, and requires machine reboot to get leaked pages back.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > > Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > > v2->v3:
> > > 
> > >  - Fixed bug during copy/paste which results in SECS page and va pages are not
> > >    correctly freed in sgx_encl_release() (sorry for the mistake).
> > >  - Added Jarkko's Acked-by.
> > 
> > That Acked-by should either be dropped or moved above Co-developed-by to make
> > checkpatch happy.
> > 
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> Oops, my bad. Yup, ack should be removed.
> 
> /Jarkko

Hi Jarkko,

Your reply of your concern of this patch to the cover-letter

https://lore.kernel.org/lkml/YEkJXu262YDa8ZaK@kernel.org/

reminds me to do more sanity check of whether removing EREMOVE in
sgx_free_epc_page() will impact other code path or not, and I think
sgx_encl_release() is not the only place should be changed:

- sgx_encl_shrink() needs to call sgx_encl_free_epc_page(), since when this is
called, the VA page can be already valid -- there are other failures can
trigger sgx_encl_shrink().

- sgx_encl_add_page() should call sgx_encl_free_epc_page() in "err_out_free:"
label, since the EPC page can be already valid when error happened, i.e. when
EEXTEND fails.

Other places should be OK per my check, but I'd prefer to just replacing all
sgx_free_epc_page() call sites in driver with sgx_encl_free_epc_page(), with
one exception: sgx_alloc_va_page(), which calls sgx_free_epc_page() when EPA
fails, in which case EREMOVE is not required for sure.

Your idea, please?

Btw, introducing a driver wrapper of sgx_free_epc_page() does make sense to me,
because virtualization has a counterpart in sgx/virt.c too.
