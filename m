Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742262EC7CB
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 02:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbhAGBmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 20:42:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:22870 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbhAGBmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 20:42:49 -0500
IronPort-SDR: 7Wjz8CleWqrseR+1s17e2nwYeeRXHVH5YonoiY5I7ZzJ014wsorYEwZiuDEOp1eHadvtbjPSK6
 gEZK2KSNChXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="177512667"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="177512667"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 17:42:08 -0800
IronPort-SDR: qJcA4v2w1ChAIv9cXbFdxEUypfALXmUs1lSH6gNxUbfm1BXTridStM5M4Hn9SCaZbWYAxmCPMo
 8gJW0p8yzJnA==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="379509868"
Received: from naljabex-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.117.182])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 17:42:05 -0800
Date:   Thu, 7 Jan 2021 14:42:03 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210107144203.589d4b2a7a2d2b53c4af7560@intel.com>
In-Reply-To: <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
        <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 11:35:41 -0800 Dave Hansen wrote:
> On 1/5/21 5:55 PM, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
> > EPC without an associated enclave.  The intended and only known use case
> > for raw EPC allocation is to expose EPC to a KVM guest, hence the
> > virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.
> > 
> > Modify sgx_init() to always try to initialize virtual EPC driver, even
> > when SGX driver is disabled due to SGX Launch Control is in locked mode,
> > or not present at all, since SGX virtualization allows to expose SGX to
> > guests that support non-LC configurations.
> 
> The grammar here is a bit off.  Here's a rewrite:
> 
> Modify sgx_init() to always try to initialize the virtual EPC driver,
> even if the bare-metal SGX driver is disabled.  The bare-metal driver
> might be disabled if SGX Launch Control is in locked mode, or not
> supported in the hardware at all.  This allows (non-Linux) guests that
> support non-LC configurations to use SGX.

Thanks. I'll use yours, except I want to change "bare-metal driver might be
disabled.." to "bare-metal driver will be disabled..".

I'll also use all your comments mentioned in your reply to this patch.

[...]

> > +
> > +static int sgx_virt_epc_release(struct inode *inode, struct file *file)
> > +{
> > +	struct sgx_virt_epc *epc = file->private_data;
> 
> FWIW, I hate the "struct sgx_virt_epc *epc" name.  "epc" here is really
> an instance
> 

How about "struct sgx_virt_epc *vepc" ?

[...]

> > +static int sgx_virt_epc_open(struct inode *inode, struct file *file)
> > +{
> > +	struct sgx_virt_epc *epc;
> > +
> > +	epc = kzalloc(sizeof(struct sgx_virt_epc), GFP_KERNEL);
> > +	if (!epc)
> > +		return -ENOMEM;
> > +	/*
> > +	 * Keep the current->mm to virtual EPC. It will be checked in
> > +	 * sgx_virt_epc_mmap() to prevent, in case of fork, child being
> > +	 * able to mmap() to the same virtual EPC pages.
> > +	 */
> > +	mmgrab(current->mm);
> > +	epc->mm = current->mm;
> > +	mutex_init(&epc->lock);
> > +	xa_init(&epc->page_array);
> > +
> > +	file->private_data = epc;
> > +
> > +	return 0;
> > +}
> 
> I understand why this made sense for regular enclaves, but I'm having a
> harder time here.  If you mmap(fd, MAP_SHARED), fork(), and then pass
> that mapping through to two different guests, you get to hold the
> pieces, just like if you did the same with normal memory.
> 
> Why does the kernel need to enforce this policy?

Does Sean's reply in another email satisfy you?
