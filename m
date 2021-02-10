Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27D5317426
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhBJXP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:15:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:59962 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234366AbhBJXNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:13:07 -0500
IronPort-SDR: ose5+5MLuk1UhGX86n0jV4riMQ5sx4imqVPq4cgqumwdL13cQxrioYQLmmvFF2MfO2GOntrDXv
 qjNbbXIxp7UA==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="161312464"
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="161312464"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 15:12:22 -0800
IronPort-SDR: 2Nmz5lwLG+yiGinCih9E8NYBbCP534jpDXDyZJwKG6K0zPob5ypBU4Ph1vsV2wyhGF7WDTuDJX
 AOz7XvnWjmwA==
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="489344248"
Received: from gadalarx-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.135.39])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 15:12:18 -0800
Date:   Thu, 11 Feb 2021 12:12:16 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-Id: <20210211121216.bb9a9430eee1f2fd43702e93@intel.com>
In-Reply-To: <YCQPSUNFlWd/s+up@google.com>
References: <cover.1612777752.git.kai.huang@intel.com>
        <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
        <YCL8ErAGKNSnX2Up@kernel.org>
        <YCL8eNNfuo2k5ghO@kernel.org>
        <9aebc8e6-cff5-b2b4-04af-d3968a3586dc@intel.com>
        <ec9604199072e185de4b6b74209e84f30423c5e3.camel@intel.com>
        <YCQPSUNFlWd/s+up@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Feb 2021 08:52:25 -0800 Sean Christopherson wrote:
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

Agreed. This is really a good point. Two different device nodes allows
different permission control. Thanks.

> 
> For the few flows that can share code, just split out the common bits to helpers.
