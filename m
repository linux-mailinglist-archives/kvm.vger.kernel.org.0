Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6396531ABDE
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 14:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhBMNe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 08:34:58 -0500
Received: from mga17.intel.com ([192.55.52.151]:17971 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhBMNeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 08:34:36 -0500
IronPort-SDR: It20lkjvxD3j3DwI1+RKML2TnZ0gHHtD8kfewsNsdTOSfIsrrdrbBz3sqjpY0/ueK1G0re0Kz+
 FGqs9+UNA45A==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="162282001"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="162282001"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:33:34 -0800
IronPort-SDR: 5Vk33Fe/lRNnABjHMK6cP9CSSXce8/SqJCnFhMxavkPWvQoRAtuXpTABe8Sz6RvGV9cCrV4hIw
 UemUO0Mgx2Mw==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="437910835"
Received: from kshah-mobl1.amr.corp.intel.com ([10.255.230.239])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:33:31 -0800
Message-ID: <c50ffb557166132cf73d0e838d3a5c1f653b28b7.camel@intel.com>
Subject: Re: [RFC PATCH v4 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests'
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Sun, 14 Feb 2021 02:33:29 +1300
In-Reply-To: <YCZx86hQx7n0RRlT@kernel.org>
References: <cover.1612777752.git.kai.huang@intel.com>
         <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
         <YCL8ErAGKNSnX2Up@kernel.org> <YCL8eNNfuo2k5ghO@kernel.org>
         <9aebc8e6-cff5-b2b4-04af-d3968a3586dc@intel.com>
         <ec9604199072e185de4b6b74209e84f30423c5e3.camel@intel.com>
         <YCQPSUNFlWd/s+up@google.com> <YCZx86hQx7n0RRlT@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-02-12 at 14:17 +0200, Jarkko Sakkinen wrote:
> On Wed, Feb 10, 2021 at 08:52:25AM -0800, Sean Christopherson wrote:
> > On Wed, Feb 10, 2021, Kai Huang wrote:
> > > On Tue, 2021-02-09 at 13:36 -0800, Dave Hansen wrote:
> > > > On 2/9/21 1:19 PM, Jarkko Sakkinen wrote:
> > > > > > Without that clearly documented, it would be unwise to merge this.
> > > > > E.g.
> > > > > 
> > > > > - Have ioctl() to turn opened fd as vEPC.
> > > > > - If FLC is disabled, you could only use the fd for creating vEPC.
> > > > > 
> > > > > Quite easy stuff to implement.
> > 
> > ...
> > 
> > > What's your opinion? Did I miss anything?
> > 
> > Frankly, I think trying to smush them together would be a complete trainwreck.
> > 
> > The vast majority of flows would need to go down completely different paths, so
> > you'd end up with code like this:
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> > index f2eac41bb4ff..5128043c7871 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > @@ -46,6 +46,9 @@ static int sgx_release(struct inode *inode, struct file *file)
> >         struct sgx_encl *encl = file->private_data;
> >         struct sgx_encl_mm *encl_mm;
> >  
> > 
> > +       if (encl->not_an_enclave)
> > +               return sgx_virt_epc_release(encl);
> > +
> >         /*
> >          * Drain the remaining mm_list entries. At this point the list contains
> >          * entries for processes, which have closed the enclave file but have
> > @@ -83,6 +86,9 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
> >         struct sgx_encl *encl = file->private_data;
> >         int ret;
> >  
> > 
> > +       if (encl->not_an_enclave)
> > +               return sgx_virt_epc_mmap(encl, vma);
> > +
> >         ret = sgx_encl_may_map(encl, vma->vm_start, vma->vm_end, vma->vm_flags);
> >         if (ret)
> >                 return ret;
> > @@ -104,6 +110,11 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
> >                                            unsigned long pgoff,
> >                                            unsigned long flags)
> >  {
> > +       struct sgx_encl *encl = file->private_data;
> > +
> > +       if (encl->not_an_enclave)
> > +               return sgx_virt_epc_mmap(encl, addr, len, pgoff, flags);
> > +
> >         if ((flags & MAP_TYPE) == MAP_PRIVATE)
> >                 return -EINVAL;
> > 
> > I suspect it would also be tricky to avoid introducing races, since anything that
> > is different for virtual EPC would have a dependency on the ioctl() being called.
> > 
> > This would also prevent making /dev/sgx_enclave root-only while allowing users
> > access to /dev/sgx_vepc.  Forcing admins to use LSMs to do the same is silly.
> > 
> > For the few flows that can share code, just split out the common bits to helpers.
> 
> I'm cool with keeping the device. This is just my opinion that even
> "obvious" should be documented when it comes to uapi. I.e. no matter
> how stupid and simple reasons are to add a new device file, please
> just write it down to commit message.
> 
> /Jarkko

Yes reasonable. I added some description to the commit message. I have already sent
out the v5. Please take a look and see whether it is OK for you. Thanks!

