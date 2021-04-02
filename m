Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864D2352F86
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 21:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhDBTIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 15:08:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:2092 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236301AbhDBTIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 15:08:38 -0400
IronPort-SDR: 6V3AHgnvbbHADYhtMZ6NOE6Fs4NFcSZmbUHFTsgxueruuFBHtldxrLBttNnUoYUiDLZ5HrHGrU
 rsD59j7DJJ+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9942"; a="253854155"
X-IronPort-AV: E=Sophos;i="5.81,300,1610438400"; 
   d="scan'208";a="253854155"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 12:08:36 -0700
IronPort-SDR: QsxsuFpcnsvuimRxOw4HUitLjgOv8nzSOTJwS8XCg3d0mdhA/nj8aeEDhQzNpWTfaa4s/MJBAS
 pGXf9Qhuyg7w==
X-IronPort-AV: E=Sophos;i="5.81,300,1610438400"; 
   d="scan'208";a="446910313"
Received: from hvijayak-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.132.133])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 12:08:26 -0700
Date:   Sat, 3 Apr 2021 08:08:24 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-Id: <20210403080824.d8bdb4c8f3c826c934acc53d@intel.com>
In-Reply-To: <YGc7ezLWEu/ZvUOu@google.com>
References: <cover.1616136307.git.kai.huang@intel.com>
        <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
        <20210402094816.GC28499@zn.tnic>
        <YGc7ezLWEu/ZvUOu@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Apr 2021 15:42:51 +0000 Sean Christopherson wrote:
> On Fri, Apr 02, 2021, Borislav Petkov wrote:
> > On Fri, Mar 19, 2021 at 08:23:02PM +1300, Kai Huang wrote:
> > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > even if the SGX driver is disabled.  The SGX driver might be disabled
> > > if SGX Launch Control is in locked mode, or not supported in the
> > > hardware at all.  This allows (non-Linux) guests that support non-LC
> > > configurations to use SGX.
> > > 
> > > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > index 6a734f484aa7..b73114150ff8 100644
> > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > @@ -743,7 +743,15 @@ static int __init sgx_init(void)
> > >  		goto err_page_cache;
> > >  	}
> > >  
> > > -	ret = sgx_drv_init();
> > > +	/*
> > > +	 * Always try to initialize the native *and* KVM drivers.
> > > +	 * The KVM driver is less picky than the native one and
> > > +	 * can function if the native one is not supported on the
> > > +	 * current system or fails to initialize.
> > > +	 *
> > > +	 * Error out only if both fail to initialize.
> > > +	 */
> > > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > 
> > This is a silly way of writing:
> > 
> >         if (sgx_drv_init() && sgx_vepc_init())
> >                 goto err_kthread;
> > 
> > methinks.
> 
> Nope!  That's wrong, as sgx_epc_init() will not be called if sgx_drv_init()
> succeeds.  And writing it as "if (sgx_drv_init() || sgx_vepc_init())" is also
> wrong since that would kill SGX when one of the drivers is alive and well.

Right. Thanks for pointing out.
