Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD3A3050C1
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 05:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhA0EZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:25:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:41669 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392016AbhA0B0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 20:26:25 -0500
IronPort-SDR: 6rYtv1nLU/Dny90nBEMGaXzTzWxKC3wGY3Gp03x2M7vQlkHYmoc7GB+evS/N4bYFOUgSNFv2n0
 x/xc/rUsIPNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="244077584"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="244077584"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:25:43 -0800
IronPort-SDR: dk2QIVToLgno1Pv/LJnv1NSbB6A7qRzBPK6eq9XWz+uIG1O2yG+roS9iw+lt8YjgLBk04eW3o9
 8ZI2abDMrEvQ==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="504724182"
Received: from rsperry-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.187])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:25:40 -0800
Date:   Wed, 27 Jan 2021 14:25:37 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH v3 04/27] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210127142537.9e831f66f925cbf82b9ab45d@intel.com>
In-Reply-To: <8250aedb-a623-646d-071a-75ece2c41c09@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <d93adaec3d4371638f4ea2d9c6efb28e22eafcb3.1611634586.git.kai.huang@intel.com>
        <8250aedb-a623-646d-071a-75ece2c41c09@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jan 2021 08:04:35 -0800 Dave Hansen wrote:
> On 1/26/21 1:30 AM, Kai Huang wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
> > sgx_reset_epc_page(), which is a static helper function for
> > sgx_encl_release().  It's the only function existing, which deals with
> > initialized pages.
> 
> Yikes.  I have no idea what that is saying.  Here's a rewrite:
> 
> EREMOVE takes a pages and removes any association between that page and
> an enclave.  It must be run on a page before it can be added into
> another enclave.  Currently, EREMOVE is run as part of pages being freed
> into the SGX page allocator.  It is not expected to fail.
> 
> KVM does not track how guest pages are used, which means that SGX
> virtualization use of EREMOVE might fail.
> 
> Break out the EREMOVE call from the SGX page allocator.  This will allow
> the SGX virtualization code to use the allocator directly.  (SGX/KVM
> will also introduce a more permissive EREMOVE helper).

Thanks.

Hi Jarkko,

Do you want me to update your patch directly, or do you want to take the
change, and send me the patch again?

> 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index ee50a5010277..a78b71447771 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -389,6 +389,16 @@ const struct vm_operations_struct sgx_vm_ops = {
> >  	.access = sgx_vma_access,
> >  };
> >  
> > +
> > +static void sgx_reset_epc_page(struct sgx_epc_page *epc_page)
> > +{
> > +	int ret;
> > +
> > +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> > +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> > +		return;
> > +}
> > +
> >  /**
> >   * sgx_encl_release - Destroy an enclave instance
> >   * @kref:	address of a kref inside &sgx_encl
> > @@ -412,6 +422,7 @@ void sgx_encl_release(struct kref *ref)
> >  			if (sgx_unmark_page_reclaimable(entry->epc_page))
> >  				continue;
> >  
> > +			sgx_reset_epc_page(entry->epc_page);
> >  			sgx_free_epc_page(entry->epc_page);
> >  			encl->secs_child_cnt--;
> >  			entry->epc_page = NULL;
> > @@ -423,6 +434,7 @@ void sgx_encl_release(struct kref *ref)
> >  	xa_destroy(&encl->page_array);
> >  
> >  	if (!encl->secs_child_cnt && encl->secs.epc_page) {
> > +		sgx_reset_epc_page(encl->secs.epc_page);
> >  		sgx_free_epc_page(encl->secs.epc_page);
> >  		encl->secs.epc_page = NULL;
> >  	}
> > @@ -431,6 +443,7 @@ void sgx_encl_release(struct kref *ref)
> >  		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> >  					   list);
> >  		list_del(&va_page->list);
> > +		sgx_reset_epc_page(va_page->epc_page);
> >  		sgx_free_epc_page(va_page->epc_page);
> >  		kfree(va_page);
> >  	}
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index f330abdb5bb1..21c2ffa13870 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -598,16 +598,14 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
> >   * sgx_free_epc_page() - Free an EPC page
> >   * @page:	an EPC page
> >   *
> > - * Call EREMOVE for an EPC page and insert it back to the list of free pages.
> > + * Put the EPC page back to the list of free pages. It's the callers
> 
> "caller's"
> 
> > + * responsibility to make sure that the page is in uninitialized state In other
> 
> Period after "state", please.
> 
> > + * words, do EREMOVE, EWB or whatever operation is necessary before calling
> > + * this function.
> >   */
> 
> OK, so if you're going to say "the caller must put the page in
> uninitialized state", let's also add a comment to the place that *DO*
> that, like the shiny new sgx_reset_epc_page().

Hi Dave,

Sorry I am a little bit confused here. Do you mean we should add a comment in
sgx_reset_epc_page() to say, for instance: sgx_free_epc_page() requires the EPC
page already been EREMOVE'd?
