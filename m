Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C6A32A6CE
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351489AbhCBPuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:50:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:14398 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237336AbhCBAdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:33:46 -0500
IronPort-SDR: ScWI6pkReyUNhoJyWYR6q/9QtWREX9efW2ALvT+4Y+eioM3XzDbBHJZlJ/1FUNy7BzP5hwvDn/
 H88d9t/PP7Sw==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="186696233"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="186696233"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:32:55 -0800
IronPort-SDR: EiJGOqml+6tBJd35v1/frztJC7INs4m25setrC6aYGmT6kEVhzvIksElaghir0g1TzO7lS16eL
 RbCBtpz6T+CA==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427144227"
Received: from yueliu2-mobl.amr.corp.intel.com ([10.252.139.111])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:32:51 -0800
Message-ID: <a1f3ab9bdffe78b72b22237d46f706a3c19c2900.camel@intel.com>
Subject: Re: [PATCH 03/25] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Tue, 02 Mar 2021 13:32:49 +1300
In-Reply-To: <YD0kinxqJF1w+BZf@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
         <9c2c83ccc7324390bfb302bd327d9236b890c679.1614590788.git.kai.huang@intel.com>
         <YD0kinxqJF1w+BZf@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-01 at 09:29 -0800, Sean Christopherson wrote:
> On Mon, Mar 01, 2021, Kai Huang wrote:
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index 7449ef33f081..a7dc86e87a09 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -381,6 +381,26 @@ const struct vm_operations_struct sgx_vm_ops = {
> >  	.access = sgx_vma_access,
> >  };
> >  
> > 
> > 
> > 
> > +static void sgx_encl_free_epc_page(struct sgx_epc_page *epc_page)
> > +{
> > +	int ret;
> > +
> > +	WARN_ON_ONCE(epc_page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> > +
> > +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> > +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret)) {
> 
> This can be ENCLS_WARN, especially if you're printing a separate error message
> about leaking the page.  That being said, I'm not sure a seperate error message
> is a good idea.  If other stuff gets dumped to the kernel log between the WARN
> and the pr_err_once(), it may not be clear to admins that the two events are
> directly connected.  It's even possible the prints could come from two different
> CPUs.

Good point. Thanks for educating me :)

> 
> Why not dump a short blurb in the WARN itself?  The error message can be thrown
> in a define if the line length is too obnoxious (it's ~109 chars if embedded
> directly).
> 
> #define EREMOVE_ERROR_MESSAGE \
> 	"EREMOVE returned %d (0x%x).  EPC page leaked, reboot recommended."
> 
> 	if (WARN_ONCE(ret, EREMOVE_ERROR_MESSAGE, ret, ret))

Will do in your way. Thanks!

> 
> > +		/*
> > +		 * Give a message to remind EPC page is leaked, and requires
> > +		 * machine reboot to get leaked pages back. This can be improved
> > +		 * in the future by adding stats of leaked pages, etc.
> > +		 */
> > +		pr_err_once("EPC page is leaked. Require machine reboot to get leaked pages back.\n");
> > +		return;
> > +	}
> > +
> > +	sgx_free_epc_page(epc_page);
> > +}
> > +
> >  /**
> >   * sgx_encl_release - Destroy an enclave instance
> >   * @kref:	address of a kref inside &sgx_encl


