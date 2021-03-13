Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9CC33A02B
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 20:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhCMTGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 14:06:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234124AbhCMTF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 14:05:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 658CA64EC6;
        Sat, 13 Mar 2021 19:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615662357;
        bh=4web00tJEwqiwwmbuK8tkU4dxrLVDLg96w+/MeovCrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EdD+gOR5wB+/fVaPM0+2NZGy89/U2dLTDAO9mQfO6zb8M7FQxSetCpyOl7Qxnolnu
         983Jt9q78eaGQSxz87V8c4jqSITGSeJvll6sGX8s5iRc9ufp2V/3vInArcmK2M6HJQ
         n6IRveTj8MttfvY2Ch+xcW6lO1w+gzFsOHw5n+J+McUSeZF260lxxVE+H3BGFMVlfn
         gmc+1kPInQLMjzjqqzlbKmmdKMzAQ6/6zCaTge3G28kDmhrdjTOvxel81ZitranRZe
         aXt0Wp7nJnZ0t9mJQ6w2LrF8OgVRDUHZX5MwqISgVbzfiSDRi5h8nzGjiriZAzZzzj
         DpDs6QakdPiRw==
Date:   Sat, 13 Mar 2021 21:05:33 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YE0M/VoETPw7YZIy@kernel.org>
References: <cover.1615250634.git.kai.huang@intel.com>
 <d2ebcffeb9193d26a1305e08fe1aa1347feb1c62.1615250634.git.kai.huang@intel.com>
 <YEvg2vNfiDYoc9u3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEvg2vNfiDYoc9u3@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 01:44:58PM -0800, Sean Christopherson wrote:
> On Tue, Mar 09, 2021, Kai Huang wrote:
> > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > even if the SGX driver is disabled.  The SGX driver might be disabled
> > if SGX Launch Control is in locked mode, or not supported in the
> > hardware at all.  This allows (non-Linux) guests that support non-LC
> > configurations to use SGX.
> > 
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 44fe91a5bfb3..8c922e68274d 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -712,7 +712,15 @@ static int __init sgx_init(void)
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
> I love this code.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

I'm still wondering why this code let's go through when sgx_drv_init()
succeeds and sgx_vepc_init() fails.

The inline comment explains only the mirrored case (which does make
sense).

/Jarkko
