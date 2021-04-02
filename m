Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD633352A0E
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 13:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhDBLIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 07:08:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:39097 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhDBLIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 07:08:17 -0400
IronPort-SDR: 3+Kdk1xmCRa5pSL/q/bOu+2xwf0kw/4H3ysUpSRamcTuLCNxnenk9vCERZmbBQFQOq/bV7DGBv
 VIDnBV1jNiJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="192555966"
X-IronPort-AV: E=Sophos;i="5.81,299,1610438400"; 
   d="scan'208";a="192555966"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 04:08:15 -0700
IronPort-SDR: NwU8M5JlLTfotf2r12z+He4NyM1mN4GZsxhIruZUmM/XBhStJ4ig7gvf/Rn31aUDDdDFpZh/AB
 4Yf+aDfxVN5g==
X-IronPort-AV: E=Sophos;i="5.81,299,1610438400"; 
   d="scan'208";a="456395777"
Received: from nnafsin-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.231.190])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 04:08:12 -0700
Date:   Sat, 3 Apr 2021 00:08:10 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-Id: <20210403000810.93638fb4b468ab28faaf11fd@intel.com>
In-Reply-To: <20210402094816.GC28499@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
        <20210402094816.GC28499@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Apr 2021 11:48:16 +0200 Borislav Petkov wrote:
> On Fri, Mar 19, 2021 at 08:23:02PM +1300, Kai Huang wrote:
> > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > even if the SGX driver is disabled.  The SGX driver might be disabled
> > if SGX Launch Control is in locked mode, or not supported in the
> > hardware at all.  This allows (non-Linux) guests that support non-LC
> > configurations to use SGX.
> > 
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 6a734f484aa7..b73114150ff8 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -743,7 +743,15 @@ static int __init sgx_init(void)
> >  		goto err_page_cache;
> >  	}
> >  
> > -	ret = sgx_drv_init();
> > +	/*
> > +	 * Always try to initialize the native *and* KVM drivers.
> > +	 * The KVM driver is less picky than the native one and
> > +	 * can function if the native one is not supported on the
> > +	 * current system or fails to initialize.
> > +	 *
> > +	 * Error out only if both fail to initialize.
> > +	 */
> > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> 
> This is a silly way of writing:
> 
>         if (sgx_drv_init() && sgx_vepc_init())
>                 goto err_kthread;
> 
> methinks.

Works for me. Thanks.

Do you want me to send updated patch?
