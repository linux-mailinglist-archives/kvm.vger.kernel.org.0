Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0144434B168
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 22:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhCZVkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 17:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhCZVkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 17:40:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6BEB619F9;
        Fri, 26 Mar 2021 21:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616794819;
        bh=Hk+0QRNxqLiTTcBkB3kUhQJWX3hYs7SsGdtpbkzSwME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gNpa3EyZenbH9ZMc0g+n9Ygz72j5zb5Q4rPgdzwdxdP7g2eg4SyKJBI2tZ7eP/2JS
         a0kSOJw8NQRHN7QE9BsST/sYwcAdpM8I5NaK9kqZILxNZErOHeCxxcygisiTK3tGxi
         dgaHDlwiW7glcmOXzAOc9JajniTHMnhoE7M7YvVhkq0a5djWf8RyBOJvQNsi9fRzh6
         +ng0a1Gnx2C9153MueuCKTbD5ewm9O4JTatEazjyUZK/BLp20qgrmFlZyW6BwBpqXu
         A0hGOxUdnC/uTRmuMmp8tnYF3RfnJ/Be9C0S2UTwQ3RC4GAGyEU1rsGYTFShsB785S
         BkMX91CDblMfA==
Date:   Fri, 26 Mar 2021 23:39:49 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v4 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YF5UpceXajA6D7c4@kernel.org>
References: <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210325093057.122834-1-kai.huang@intel.com>
 <YF46ndD3rdotgOpl@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YF46ndD3rdotgOpl@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 26, 2021 at 09:48:48PM +0200, Jarkko Sakkinen wrote:
> On Thu, Mar 25, 2021 at 10:30:57PM +1300, Kai Huang wrote:
> > EREMOVE takes a page and removes any association between that page and
> > an enclave.  It must be run on a page before it can be added into
> > another enclave.  Currently, EREMOVE is run as part of pages being freed
> > into the SGX page allocator.  It is not expected to fail, as it would
> > indicate a use-after-free of EPC.  Rather than add the page back to the
> > pool of available EPC, the kernel intentionally leaks the page to avoid
> > additional errors in the future.
> > 
> > However, KVM does not track how guest pages are used, which means that
> > SGX virtualization use of EREMOVE might fail.  Specifically, it is
> > legitimate that EREMOVE returns SGX_CHILD_PRESENT for EPC assigned to
> > KVM guest, because KVM/kernel doesn't track SECS pages.
> > 
> > To allow SGX/KVM to introduce a more permissive EREMOVE helper and to
> > let the SGX virtualization code use the allocator directly, break out
> > the EREMOVE call from the SGX page allocator.  Rename the original
> > sgx_free_epc_page() to sgx_encl_free_epc_page(), indicating that it is
> > used to free EPC page assigned host enclave. Replace sgx_free_epc_page()
> > with sgx_encl_free_epc_page() in all call sites so there's no functional
> > change.
> > 
> > At the same time improve error message when EREMOVE fails, and add
> > documentation to explain to user what is the bug and suggest user what
> > to do when this bug happens, although extremely unlikely.
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  Documentation/x86/sgx.rst       | 27 +++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/encl.c  | 32 +++++++++++++++++++++++++++-----
> >  arch/x86/kernel/cpu/sgx/encl.h  |  1 +
> >  arch/x86/kernel/cpu/sgx/ioctl.c |  6 +++---
> >  arch/x86/kernel/cpu/sgx/main.c  | 14 +++++---------
> >  arch/x86/kernel/cpu/sgx/sgx.h   |  5 +++++
> >  6 files changed, 68 insertions(+), 17 deletions(-)
> > 
> > diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> > index eaee1368b4fd..5ec7d17e65e0 100644
> > --- a/Documentation/x86/sgx.rst
> > +++ b/Documentation/x86/sgx.rst
> > @@ -209,3 +209,30 @@ An application may be loaded into a container enclave which is specially
> >  configured with a library OS and run-time which permits the application to run.
> >  The enclave run-time and library OS work together to execute the application
> >  when a thread enters the enclave.
> > +
> > +Impact of Potential Kernel SGX Bugs
> > +===================================
> > +
> > +EPC leaks
> > +---------
> > +
> > +EPC leaks can happen if kernel SGX bug happens, when a WARNING with below
> > +message is shown in dmesg:
> > +
> > +"...EREMOVE returned ... and an EPC page was leaked.  SGX may become unusuable.
> > +This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more
> > +information."
> > +
> > +This is effectively a kernel use-after-free of EPC, and due to the way SGX
> > +works, the bug is detected at freeing. Rather than add the page back to the pool
> > +of available EPC, the kernel intentionally leaks the page to avoid additional
> > +errors in the future.
> > +
> > +When this happens, kernel will likely soon leak majority of EPC pages, and SGX
> > +will likely become unusable. However while this may be fatal to SGX, other
> > +kernel functionalities are unlikely to be impacted, and should continue to work.
> > +
> > +As a result, when this happpens, user should stop running any new SGX workloads,
> > +(or just any new workloads), and migrate all valuable workloads. Although a
> > +machine reboot can recover all EPC, the bug should be reported to Linux
> > +developers.
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index 7449ef33f081..26c0987153de 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -78,7 +78,7 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  
> >  	ret = __sgx_encl_eldu(encl_page, epc_page, secs_page);
> >  	if (ret) {
> > -		sgx_free_epc_page(epc_page);
> > +		sgx_encl_free_epc_page(epc_page);
> >  		return ERR_PTR(ret);
> >  	}
> >  
> > @@ -404,7 +404,7 @@ void sgx_encl_release(struct kref *ref)
> >  			if (sgx_unmark_page_reclaimable(entry->epc_page))
> >  				continue;
> >  
> > -			sgx_free_epc_page(entry->epc_page);
> > +			sgx_encl_free_epc_page(entry->epc_page);
> >  			encl->secs_child_cnt--;
> >  			entry->epc_page = NULL;
> >  		}
> > @@ -415,7 +415,7 @@ void sgx_encl_release(struct kref *ref)
> >  	xa_destroy(&encl->page_array);
> >  
> >  	if (!encl->secs_child_cnt && encl->secs.epc_page) {
> > -		sgx_free_epc_page(encl->secs.epc_page);
> > +		sgx_encl_free_epc_page(encl->secs.epc_page);
> >  		encl->secs.epc_page = NULL;
> >  	}
> >  
> > @@ -423,7 +423,7 @@ void sgx_encl_release(struct kref *ref)
> >  		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> >  					   list);
> >  		list_del(&va_page->list);
> > -		sgx_free_epc_page(va_page->epc_page);
> > +		sgx_encl_free_epc_page(va_page->epc_page);
> >  		kfree(va_page);
> >  	}
> >  
> > @@ -686,7 +686,7 @@ struct sgx_epc_page *sgx_alloc_va_page(void)
> >  	ret = __epa(sgx_get_epc_virt_addr(epc_page));
> >  	if (ret) {
> >  		WARN_ONCE(1, "EPA returned %d (0x%x)", ret, ret);
> > -		sgx_free_epc_page(epc_page);
> > +		sgx_encl_free_epc_page(epc_page);
> >  		return ERR_PTR(-EFAULT);
> >  	}
> >  
> > @@ -735,3 +735,25 @@ bool sgx_va_page_full(struct sgx_va_page *va_page)
> >  
> >  	return slot == SGX_VA_SLOT_COUNT;
> >  }
> > +
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
> > +	ret = __eremove(sgx_get_epc_virt_addr(page));
> > +	if (WARN_ONCE(ret, EREMOVE_ERROR_MESSAGE, ret, ret))
> > +		return;
> > +
> > +	sgx_free_epc_page(page);
> > +}
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> > index d8d30ccbef4c..6e74f85b6264 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.h
> > +++ b/arch/x86/kernel/cpu/sgx/encl.h
> > @@ -115,5 +115,6 @@ struct sgx_epc_page *sgx_alloc_va_page(void);
> >  unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
> >  void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
> >  bool sgx_va_page_full(struct sgx_va_page *va_page);
> > +void sgx_encl_free_epc_page(struct sgx_epc_page *page);
> >  
> >  #endif /* _X86_ENCL_H */
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index 90a5caf76939..772b9c648cf1 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -47,7 +47,7 @@ static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
> >  	encl->page_cnt--;
> >  
> >  	if (va_page) {
> > -		sgx_free_epc_page(va_page->epc_page);
> > +		sgx_encl_free_epc_page(va_page->epc_page);
> >  		list_del(&va_page->list);
> >  		kfree(va_page);
> >  	}
> > @@ -117,7 +117,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> >  	return 0;
> >  
> >  err_out:
> > -	sgx_free_epc_page(encl->secs.epc_page);
> > +	sgx_encl_free_epc_page(encl->secs.epc_page);
> >  	encl->secs.epc_page = NULL;
> >  
> >  err_out_backing:
> > @@ -365,7 +365,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> >  	mmap_read_unlock(current->mm);
> >  
> >  err_out_free:
> > -	sgx_free_epc_page(epc_page);
> > +	sgx_encl_free_epc_page(epc_page);
> >  	kfree(encl_page);
> >  
> >  	return ret;
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 13a7599ce7d4..b227629b1e9c 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -294,7 +294,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
> >  
> >  		sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
> >  
> > -		sgx_free_epc_page(encl->secs.epc_page);
> > +		sgx_encl_free_epc_page(encl->secs.epc_page);
> >  		encl->secs.epc_page = NULL;
> >  
> >  		sgx_encl_put_backing(&secs_backing, true);
> > @@ -609,19 +609,15 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
> >   * sgx_free_epc_page() - Free an EPC page
> >   * @page:	an EPC page
> >   *
> > - * Call EREMOVE for an EPC page and insert it back to the list of free pages.
> > + * Put the EPC page back to the list of free pages. It's the caller's
> > + * responsibility to make sure that the page is in uninitialized state. In other
> > + * words, do EREMOVE, EWB or whatever operation is necessary before calling
> > + * this function.
> >   */
> >  void sgx_free_epc_page(struct sgx_epc_page *page)
> >  {
> >  	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
> >  	struct sgx_numa_node *node = section->node;
> > -	int ret;
> > -
> > -	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> > -
> > -	ret = __eremove(sgx_get_epc_virt_addr(page));
> > -	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> > -		return;
> >  
> >  	spin_lock(&node->lock);
> >  
> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> > index 653af8ca1a25..6b21a165500e 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -13,6 +13,11 @@
> >  #undef pr_fmt
> >  #define pr_fmt(fmt) "sgx: " fmt
> >  
> > +/* Error message for EREMOVE failure, when kernel is about to leak EPC page */
> > +#define EREMOVE_ERROR_MESSAGE \
> > +	"EREMOVE returned %d (0x%x) and an EPC page was leaked.  SGX may become unusuable.  " \
> > +	"This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more information."
> 
> 
> Why this needs to be here and not open coded where it is used?
> 
> > +
> >  #define SGX_MAX_EPC_SECTIONS		8
> >  #define SGX_EEXTEND_BLOCK_SIZE		256
> >  #define SGX_NR_TO_SCAN			16
> > -- 
> > 2.30.2
> > 
> > 

Anyway,

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
