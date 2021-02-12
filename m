Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DD2319E3C
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 13:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhBLMUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 07:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231320AbhBLMSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 07:18:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4868964E2A;
        Fri, 12 Feb 2021 12:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613132284;
        bh=3O/V/9GTkhsPD+yZbY/KWvEd4RnoN3j5RPUMVcgvQ5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Glw3rbyAzkojSTN8j0lNL8Cl1gASzLeG6fO+35lr6hAvQESx94+uTKmlyF6uxYU9e
         OfOFjbHY8nGPlXHTZfvHCqAXIyP4zhIPAFFwIEGu3A/HE2CdXjhEoJOgC+jaNqVx6C
         7KiCK5broPjvyoJKwrchYg7VB7h1n5nhIhqIJDJ7vKugot6dkgO1wxIHldVVOnsSRV
         7E05PeQe4hWCOwk8qjwfNNR0XHsEPPNTf0y2nGah+JXqKsCHU84iFsRX0mBu/Gilqh
         d032tPk40FmhrysfGcBYF5RPUxMb1cdO3OSQxPruPzqyVc3YsnS9vhkzF1jFp34qCd
         Agh+e+k2MXb7g==
Date:   Fri, 12 Feb 2021 14:17:55 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests'
Message-ID: <YCZx86hQx7n0RRlT@kernel.org>
References: <cover.1612777752.git.kai.huang@intel.com>
 <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
 <YCL8ErAGKNSnX2Up@kernel.org>
 <YCL8eNNfuo2k5ghO@kernel.org>
 <9aebc8e6-cff5-b2b4-04af-d3968a3586dc@intel.com>
 <ec9604199072e185de4b6b74209e84f30423c5e3.camel@intel.com>
 <YCQPSUNFlWd/s+up@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCQPSUNFlWd/s+up@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 08:52:25AM -0800, Sean Christopherson wrote:
> On Wed, Feb 10, 2021, Kai Huang wrote:
> > On Tue, 2021-02-09 at 13:36 -0800, Dave Hansen wrote:
> > > On 2/9/21 1:19 PM, Jarkko Sakkinen wrote:
> > > > > Without that clearly documented, it would be unwise to merge this.
> > > > E.g.
> > > > 
> > > > - Have ioctl() to turn opened fd as vEPC.
> > > > - If FLC is disabled, you could only use the fd for creating vEPC.
> > > > 
> > > > Quite easy stuff to implement.
> 
> ...
> 
> > What's your opinion? Did I miss anything?
> 
> Frankly, I think trying to smush them together would be a complete trainwreck.
> 
> The vast majority of flows would need to go down completely different paths, so
> you'd end up with code like this:
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index f2eac41bb4ff..5128043c7871 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -46,6 +46,9 @@ static int sgx_release(struct inode *inode, struct file *file)
>         struct sgx_encl *encl = file->private_data;
>         struct sgx_encl_mm *encl_mm;
>  
> +       if (encl->not_an_enclave)
> +               return sgx_virt_epc_release(encl);
> +
>         /*
>          * Drain the remaining mm_list entries. At this point the list contains
>          * entries for processes, which have closed the enclave file but have
> @@ -83,6 +86,9 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
>         struct sgx_encl *encl = file->private_data;
>         int ret;
>  
> +       if (encl->not_an_enclave)
> +               return sgx_virt_epc_mmap(encl, vma);
> +
>         ret = sgx_encl_may_map(encl, vma->vm_start, vma->vm_end, vma->vm_flags);
>         if (ret)
>                 return ret;
> @@ -104,6 +110,11 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
>                                            unsigned long pgoff,
>                                            unsigned long flags)
>  {
> +       struct sgx_encl *encl = file->private_data;
> +
> +       if (encl->not_an_enclave)
> +               return sgx_virt_epc_mmap(encl, addr, len, pgoff, flags);
> +
>         if ((flags & MAP_TYPE) == MAP_PRIVATE)
>                 return -EINVAL;
> 
> I suspect it would also be tricky to avoid introducing races, since anything that
> is different for virtual EPC would have a dependency on the ioctl() being called.
> 
> This would also prevent making /dev/sgx_enclave root-only while allowing users
> access to /dev/sgx_vepc.  Forcing admins to use LSMs to do the same is silly.
> 
> For the few flows that can share code, just split out the common bits to helpers.

I'm cool with keeping the device. This is just my opinion that even
"obvious" should be documented when it comes to uapi. I.e. no matter
how stupid and simple reasons are to add a new device file, please
just write it down to commit message.

/Jarkko
