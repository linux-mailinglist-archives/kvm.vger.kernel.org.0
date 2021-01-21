Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB62FED15
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbhAUOjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:39:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731686AbhAUOjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 09:39:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4950D239FC;
        Thu, 21 Jan 2021 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611239903;
        bh=Vzwiik+avSFnh3k8qIxZk4Toqc2fyUI2El9ck+wEblk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WtzLFajqOAk+Jj2lD6lynpJ4J3gcSqcIYo7gfe75p+jxUaJpMOBdCcfhpQJwlC1wh
         JALDzKGS23CthlWolyQ1TeLAhtfFmgkiu4C83LNaaO4/YQctXSbQqkjOGZDJijThsz
         Y3UA6BbP12Ux3foJXxAhQFbPeO3MdOVpxu0kbhvgq1g/Tps2Sun2EQ1Q78Xd22vXnC
         ECLlOfXBpdZ2To/Lgyd6aPSAb8rceYq9oTqiftztYReyb1fQIzZppQwNy1og8emf4Z
         fGrEn3MYLUFhDblj2iqqxlFIfW67RLiRpqfrL9vEK9AwryhlPi7bSdN0emjUTVIRZg
         lpyfqkn5LkQQg==
Date:   Thu, 21 Jan 2021 16:38:21 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 11/26] x86/sgx: Add encls_faulted() helper
Message-ID: <YAmR3Q9m3JmTmtm0@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <e36ac729b227d728e2b0d1a48cfbbeca4523f1a5.1610935432.git.kai.huang@intel.com>
 <YAgb/MhaNLVwBS8K@kernel.org>
 <20210121124359.7fff8c6d6f90182d8d13062f@intel.com>
 <YAjUAldgNUtrx6sE@kernel.org>
 <20210121141221.7dcabf70b8c6726136f231cd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121141221.7dcabf70b8c6726136f231cd@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 02:12:21PM +1300, Kai Huang wrote:
> On Thu, 21 Jan 2021 03:08:18 +0200 Jarkko Sakkinen wrote:
> > On Thu, Jan 21, 2021 at 12:43:59PM +1300, Kai Huang wrote:
> > > On Wed, 20 Jan 2021 14:03:08 +0200 Jarkko Sakkinen wrote:
> > > > On Mon, Jan 18, 2021 at 04:28:04PM +1300, Kai Huang wrote:
> > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > 
> > > > > Add a helper to extract the fault indicator from an encoded ENCLS return
> > > > > value.  SGX virtualization will also need to detect ENCLS faults.
> > > > > 
> > > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > ---
> > > > >  arch/x86/kernel/cpu/sgx/encls.h | 14 +++++++++++++-
> > > > >  arch/x86/kernel/cpu/sgx/ioctl.c |  2 +-
> > > > >  2 files changed, 14 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> > > > > index be5c49689980..55919a2b01b0 100644
> > > > > --- a/arch/x86/kernel/cpu/sgx/encls.h
> > > > > +++ b/arch/x86/kernel/cpu/sgx/encls.h
> > > > > @@ -40,6 +40,18 @@
> > > > >  	} while (0);							  \
> > > > >  }
> > > > >  
> > > > > +/*
> > > > > + * encls_faulted() - Check if an ENCLS leaf faulted given an error code
> > > > > + * @ret		the return value of an ENCLS leaf function call
> > > > > + *
> > > > > + * Return:
> > > > > + *	%true if @ret indicates a fault, %false otherwise
> > > > 
> > > > Follow here the style of commenting as in ioctl.c, for the return value.
> > > > It has optimal readability both as text, and also when converted to HTML.
> > > > See sgx_ioc_enclave_add_pages() for an example.
> > > 
> > > You mean something like below?
> > > 
> > > Return:
> > > - %true:  @ret indicates a fault.
> > > - %false: @ret indicates no fault.
> > 
> > Yeah, with '\t' indentation. I'd remove also '%'. Also '@ret' is redudant.
> > 
> > To put this all together:
> > 
> > * Return:
> > * - true:       ENCLS leaf faulted.
> > * - false:      Otherwise.
> > 
> > I tried various ways and this was the best way to document return values
> > that i've found. It's easy to read as plain text, and also has the benefit
> > that return values get nicely lined up in htmldocs.
> > 
> > I've been even considering a patch for
> > 
> > https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> > 
> > The only advice given ATM is: "Take a look around the source tree for
> > examples."
> 
> OK. Will change to yours. Thanks for the info.
 
There's also two examples of patterns that *do not* work in that
file :-)

I think I'll post a patch for that file.

/Jarkko
