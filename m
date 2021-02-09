Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A379331561A
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 19:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhBIShi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 13:37:38 -0500
Received: from mga18.intel.com ([134.134.136.126]:5635 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233456AbhBIS24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 13:28:56 -0500
IronPort-SDR: I/vg+B9Sa9BnzcKiTPFxrb+uZ+8sqrXwGfJCU/SX/VkUut2gxJZrJpwoUd4B2V9+HahVhnt90+
 SZkomVtccyrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9890"; a="169614752"
X-IronPort-AV: E=Sophos;i="5.81,166,1610438400"; 
   d="scan'208";a="169614752"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 10:26:29 -0800
IronPort-SDR: RqcIhMC+gEGPRSlEvHEzQ+EOI6cLwBH8wpQJUfKdqIgwk6Csyb9isuB5occafc47FoMom2erGV
 KcotBRqFYiow==
X-IronPort-AV: E=Sophos;i="5.81,166,1610438400"; 
   d="scan'208";a="379208806"
Received: from aellsw1-mobl.amr.corp.intel.com ([10.251.22.237])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 10:26:25 -0800
Message-ID: <c8a87b4980edb5e21a7d14497e84a12827e57648.camel@intel.com>
Subject: Re: [RFC PATCH v4 03/26] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Wed, 10 Feb 2021 07:26:23 +1300
In-Reply-To: <38eb4166-8687-2f0d-0ca3-66c1afdf0a5d@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
         <237b82e13e52191409577acddf9b4b28b16bf1bc.1612777752.git.kai.huang@intel.com>
         <38eb4166-8687-2f0d-0ca3-66c1afdf0a5d@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-02-09 at 08:18 -0800, Dave Hansen wrote:
> On 2/8/21 2:54 AM, Kai Huang wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
> > sgx_reset_epc_page(), which is a static helper function for
> > sgx_encl_release().  It's the only function existing, which deals with
> > initialized pages.
> 
> I didn't really like the changelog the last time around, so I wrote you
> a new one:
> 
> > https://lore.kernel.org/kvm/8250aedb-a623-646d-071a-75ece2c41c09@intel.com/
> 
> The "v4" changelog is pretty hard for me to read.  It doesn't tell me
> why we can "wipe out EREMOVE" or how it is going to get used going forward.

Oh sorry I missed this. I'll use yours in next version. Thanks.

> 
> 
> > +
> > +/*
> > + * Place the page in uninitialized state.  Called by in sgx_encl_release()
> > + * before sgx_free_epc_page(), which requires EPC page is already in clean
> > + * slate.
> > + */
> 
> I really don't like comments like that that refer to callers.  They're
> basically guaranteed to become obsolete.
> 
> /*
>  * Place the page in uninitialized state.  Only usable by callers that
>  * know the page is in a clean state in which EREMOVE will succeed.
>  */

Thanks. Agreed it's not good to mention specific caller name.

> 
> > +static void sgx_reset_epc_page(struct sgx_epc_page *epc_page)
> > +{
> > +	int ret;
> > +
> > +	WARN_ON_ONCE(epc_page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> > +
> > +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> > +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> > +		return;
> > +}
> 
> The uncommented warnings aren't very nice, but I guess they're in the
> existing code.

Yes. Adding comment should be another patch logically, and I don't want to introduce
it in this patch.


