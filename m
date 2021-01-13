Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08AC2F50A0
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 18:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbhAMRG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 12:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbhAMRG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 12:06:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A848F23120;
        Wed, 13 Jan 2021 17:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610557547;
        bh=MUd7S7rtCsqUrMn87R8c6uIReg2ioYigpK0BF2vWWoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CZbKdp40hlLoK0OhpFJsVTGu9Ql7WX3ZCgSzKbd4+18tGtrpoqH2e4IVttRcOjZw4
         UAPu3iA+BEPBxhTpoyQTIxW0vWGOAuZIXDzX+akO2+4hPbZAcd7SOKLRvayHqPCRYe
         U0pj02hjwOiqeDQDKLham0ZjDjxHeMKvcSae/WyLUW8Js97ZN86AFuzgH+QwtTVwuR
         6iZROd0GHkHOYr6+nD4eUZyoNRbrOUQgsxgnay2ZwAjuf03FYUQZNxYlvjkQiyJ2JI
         ZASxtxQy7zIAbx0shn6c67Sj7+4ngKJOnd64hmQJzqhCemT9n/xQPENAJkhO6+AZJl
         06qTAPsXUVoMA==
Date:   Wed, 13 Jan 2021 19:05:40 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 01/23] x86/sgx: Split out adding EPC page to free
 list to separate helper
Message-ID: <X/8oZKCStrqF7DxQ@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
 <3d50c2614ff8a46b44062a398fd8644bcda92132.1609890536.git.kai.huang@intel.com>
 <31681b840aac59a8d8dcb05f2356d25cf09e1f11.camel@kernel.org>
 <20210112131944.9d69bb30cf4b94b6f6f25e7b@intel.com>
 <X/4YdCN9LwZGompH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X/4YdCN9LwZGompH@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 01:45:24PM -0800, Sean Christopherson wrote:
> On Tue, Jan 12, 2021, Kai Huang wrote:
> > On Tue, 12 Jan 2021 00:38:40 +0200 Jarkko Sakkinen wrote:
> > > On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > 
> > > > SGX virtualization requires to allocate "raw" EPC and use it as virtual
> > > > EPC for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> > > > track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> > > > so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> > > > knowledge of which pages are SECS with non-zero child counts.
> > > > 
> > > > Split sgx_free_page() into two parts so that the "add to free list"
> > > > part can be used by virtual EPC without having to modify the EREMOVE
> > > > logic in sgx_free_page().
> > > > 
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > 
> > > I have a better idea with the same outcome for KVM.
> > > 
> > > https://lore.kernel.org/linux-sgx/20210111223610.62261-1-jarkko@kernel.org/T/#t
> > 
> > I agree with your patch this one can be replaced. I'll include your patch in
> > next version, and once it is upstreamed, it can be removed in my series.
> > 
> > Sean, please let me know if you have objection.
> 
> 6 of one, half dozen of the other.  I liked not having to modify the existing
> call sites, but it's your code.

Only the call sites contained sgx_encl_release() require a call to
sgx_reset_epc_page(). That's three in total.

> Though on that topic, this snippet is wrong:
> 
> @@ -431,7 +443,8 @@ void sgx_encl_release(struct kref *ref)
>  		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
>  					   list);
>  		list_del(&va_page->list);
> -		sgx_free_epc_page(va_page->epc_page);
> +		sgx_reset_epc_page(entry->epc_page);
> +		sgx_free_epc_page(entry->epc_page);

Thanks for the remark.

I checked why I did not see this when running test_sgx. I had not specified
local tree for BuildRoot (LINUX_OVERRIDE_SRCDIR) when building test image.

> s/entry/va_page in the new code.
> 
> P.S. I apparently hadn't been subscribed linux-sgx and so didn't see those
>      patches.  I'm now subscribed and can chime-in as needed.

OK, great, I can also CC directly to the next version.

/Jarkko
