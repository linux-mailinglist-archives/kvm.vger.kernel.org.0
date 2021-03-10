Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42359334192
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 16:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhCJPdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 10:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233093AbhCJPc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 10:32:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1517464F98;
        Wed, 10 Mar 2021 15:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615390377;
        bh=mVVLhBBsU5qZlMYB4KOflh2qpOSUHlTOvz5Dlwno1ug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jZkzMnhpI+2gyubsbPr2NOX9QtAZXPK9kgOuMlbNt86zORB4LL6vMzPMQQLvSOh0t
         xPcv3bUWT+fRdcpuL4PRH3cL2CnoEnrUA7OCDI5v/atsX/tzR8TLsw4x3oEUBD6UNc
         /Lj7COY/OJoglSC4NVqtSPt75dHj9TFYwrTsXmXNhe9R8favdVqDbgv2p+pey8v+50
         DzryozBL+VuzUPHYesPMVmiDpv8Dpkn6J9d4XXXbl9MsGiIyPThMvmQ4OQDBv8IuIL
         /4C2LhXVjqXTCH4fA4VoNi1supv4muL1FtVwKiXwDyGTFNjM73c5IpehWAATm6D181
         OSH4jMcmUS9RQ==
Date:   Wed, 10 Mar 2021 17:32:33 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de
Subject: Re: [PATCH 06/25] x86/cpu/intel: Allow SGX virtualization without
 Launch Control support
Message-ID: <YEjmkadk7azp53f4@kernel.org>
References: <cover.1614590788.git.kai.huang@intel.com>
 <12541888ae9ac7f517582aa64d9153feede7aed4.1614590788.git.kai.huang@intel.com>
 <20210305172957.GE2685@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305172957.GE2685@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 05, 2021 at 06:29:57PM +0100, Borislav Petkov wrote:
> On Mon, Mar 01, 2021 at 10:45:02PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > The kernel will currently disable all SGX support if the hardware does
> > not support launch control.  Make it more permissive to allow SGX
> > virtualization on systems without Launch Control support.  This will
> > allow KVM to expose SGX to guests that have less-strict requirements on
> > the availability of flexible launch control.
> > 
> > Improve error message to distinguish between three cases.  There are two
> > cases where SGX support is completely disabled:
> > 1) SGX has been disabled completely by the BIOS
> > 2) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
> >    of LC unavailability.  SGX virtualization is unavailable (because of
> >    Kconfig).
> > One where it is partially available:
> > 3) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
> >    of LC unavailability.  SGX virtualization is supported.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/feat_ctl.c | 57 ++++++++++++++++++++++++++--------
> >  1 file changed, 44 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> > index 27533a6e04fa..96c370284913 100644
> > --- a/arch/x86/kernel/cpu/feat_ctl.c
> > +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
> >  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  {
> >  	bool tboot = tboot_enabled();
> > -	bool enable_sgx;
> > +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
> > +	bool enable_vmx;
> >  	u64 msr;
> 
> The preferred ordering of variable declarations at the beginning of a
> function is reverse fir tree order::
> 
> 	struct long_struct_name *descriptive_name;
> 	unsigned long foo, bar;
> 	unsigned int tmp;
> 	int ret;

IMHO here declaring separate lines would make also sense, given
how long the local variable names are.

 /Jarkko
