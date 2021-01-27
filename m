Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98EB30519C
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 06:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238508AbhA0EYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:24:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:61361 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317658AbhA0BJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 20:09:24 -0500
IronPort-SDR: Zr+RXqPynr5p++WoGFf0XaP9MV3JOD32NDFmcTheWIYcxmP9JCD3QrXkIzABL6jQsyebUTk//L
 xUYZ9cd63j2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="159172482"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="159172482"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:08:35 -0800
IronPort-SDR: VrbeF8nhmPcRss3gpEFl0Pz43Zcj2p1oWMpFi6kZ1MVqyiGKFmLQnAh3GZNsi2m74qufYeZXhM
 e8J2ES5uRFIw==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="388080934"
Received: from rsperry-desk.amr.corp.intel.com ([10.251.7.187])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:08:31 -0800
Message-ID: <6e859dc6610d317f09663a4ce76b7e13fc0c0f8e.camel@intel.com>
Subject: Re: [RFC PATCH v3 03/27] x86/sgx: Remove a warn from
 sgx_free_epc_page()
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Wed, 27 Jan 2021 14:08:28 +1300
In-Reply-To: <d09b8b34-6e8c-5323-e155-f45da5abb48b@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
         <36e999dce8a1a4efb8ca69c9a6fbe3fa63305e08.1611634586.git.kai.huang@intel.com>
         <d09b8b34-6e8c-5323-e155-f45da5abb48b@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-26 at 07:39 -0800, Dave Hansen wrote:
> On 1/26/21 1:30 AM, Kai Huang wrote:
> > Remove SGX_EPC_PAGE_RECLAIMER_TRACKED check and warning.  This cannot
> > happen, as enclave pages are freed only at the time when encl->refcount
> > triggers, i.e. when both VFS and the page reclaimer have given up on
> > their references.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 8df81a3ed945..f330abdb5bb1 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -605,8 +605,6 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
> >  	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
> >  	int ret;
> >  
> > 
> > -	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> 
> I'm all for cleaning up silly, useless warnings.  But, don't we usually
> put warnings in for things that we don't expect to be able to happen?
> 
> In other words, I'm fine with removing this if it hasn't been a valuable
> warning and we don't expect it to become a valuable warning.  But, the
> changelog doesn't say that.  It also doesn't explain what this patch is
> doing in this series.
> 
> Why is this her?

Hi Jarkko,

I don't have deep understanding of SGX driver. Would you help to answer?

