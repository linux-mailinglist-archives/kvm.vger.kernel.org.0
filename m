Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75082305409
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 08:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhA0HJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 02:09:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:43466 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317743AbhA0AuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 19:50:11 -0500
IronPort-SDR: wI+x8TFUgBXewX/uxpFnfrsd0OVP9qmmSCQLnXQLghEnmzYFdN4HMvUS9MIJXyZ1/rA3CV9kww
 XW2a7sjX07mw==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="176487591"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="176487591"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:48:56 -0800
IronPort-SDR: NBtVWvD6wXL8GFBwdlevbU66Ym0PxM/VP6cLEoBewPoLw6E8Am1QTmiiMwRUz0406df4WiDvOv
 aN6f/yGj0cCw==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="504714302"
Received: from rsperry-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.187])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:48:53 -0800
Date:   Wed, 27 Jan 2021 13:48:51 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH v3 06/27] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-Id: <20210127134851.b8d7830989f080c475f1447c@intel.com>
In-Reply-To: <7fbdb7f9-c7b0-d4f1-6e36-d99c6a116b82@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <8492ee41e947aa8151007e5ecbd9ef8914dd8827.1611634586.git.kai.huang@intel.com>
        <c9da1c45-d4be-e0af-2b67-5408217deb34@intel.com>
        <20210127131655.d560b6be8b897471d770f54c@intel.com>
        <7fbdb7f9-c7b0-d4f1-6e36-d99c6a116b82@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jan 2021 16:27:25 -0800 Dave Hansen wrote:
> On 1/26/21 4:16 PM, Kai Huang wrote:
> > On Tue, 26 Jan 2021 08:19:25 -0800 Dave Hansen wrote:
> >> Also, a one-line summary about what's in here would be nice next to the
> >> copyright (which needs to be updated).
> >>
> >> /*
> >>  * Device driver to expose SGX enclave memory to KVM guests.
> >>  *
> >>  * Copyright(c) 2016-20 Intel Corporation.
> >>  */
> > 
> > Will do. However the year should not be 2016-20, but should be 2021, right?
> > 
> > I think it has been ignored since the day Sean wrote the file.
> 
> Yes, should be 2021.  Also, there shouldn't be *ANY* parts of these
> files which you, the submitter and newly-minted effective maintainer,
> have ignored.

Yes agreed.

> 
> It sounds like you owe us some homework to give every line of these a
> once-over.

I'll also check other files. Thanks.

> 
> ...
> >>> +struct sgx_vepc {
> >>> +	struct xarray page_array;
> >>> +	struct mutex lock;
> >>> +};
> >>> +
> >>> +static struct mutex zombie_secs_pages_lock;
> >>> +static struct list_head zombie_secs_pages;
> >>
> >> Comments would be nice for this random lock and list.
> >>
> >> The main core functions (fault, etc...) are looking OK to me.
> > 
> > Thanks. How about below comment?
> > 
> > /*
> >  * List to temporarily hold SECS pages that cannot be EREMOVE'd due to
> >  * having child in other virtual EPC instances, and the lock to protect it.
> >  */
> 
> Fine.  It's just a bit silly to say that it's a list.  It's also not so
> temporary.  Pages can live on here forever.

I'll remove the 'List':

/* SECS pages that cannot be EREMOVE'd due to... */

The list should be empty after VM's all virtual EPC instances have been
released. If one page lives in list forever, the WARN_ONCE() in
sgx_vepc_free_page() will catch it, and there's bug here.

> 
> >>> +	INIT_LIST_HEAD(&zombie_secs_pages);
> >>> +	mutex_init(&zombie_secs_pages_lock);
> >>> +
> >>> +	return misc_register(&sgx_vepc_dev);
> >>> +}
> >>> diff --git a/arch/x86/kernel/cpu/sgx/virt.h b/arch/x86/kernel/cpu/sgx/virt.h
> >>> new file mode 100644
> >>> index 000000000000..44d872380ca1
> >>> --- /dev/null
> >>> +++ b/arch/x86/kernel/cpu/sgx/virt.h
> >>> @@ -0,0 +1,14 @@
> >>> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> >>> +#ifndef _ASM_X86_SGX_VIRT_H
> >>> +#define _ASM_X86_SGX_VIRT_H
> >>> +
> >>> +#ifdef CONFIG_X86_SGX_KVM
> >>> +int __init sgx_vepc_init(void);
> >>> +#else
> >>> +static inline int __init sgx_vepc_init(void)
> >>> +{
> >>> +	return -ENODEV;
> >>> +}
> >>> +#endif
> >>> +
> >>> +#endif /* _ASM_X86_SGX_VIRT_H */
> >>
> >> Is more going to go in this header?  It's a little sparse as-is.
> > 
> > No there's no more. The sgx_vepc_init() function declaration needs to be here
> > since sgx/main.c needs to use it.
> > 
> > May I know your suggestion?
> 
> I'd toss it in some other existing header that has more meat in it.  I'm
> lazy.
> 

I can put it into arch/x86/kernel/cpu/sgx/sgx.h, if it is good to you.
