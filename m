Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540CB3050BC
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 05:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbhA0EYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:24:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:41156 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404030AbhA0ASD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 19:18:03 -0500
IronPort-SDR: nxCLUWDeUM8q7FFwlBpsUDtzEeGSAoV38a4gXjg2qkvgyZq1q5Fwka/69a05mt1NMRFSfNFqGp
 ke0TzElTKXwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="176483941"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="176483941"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:17:01 -0800
IronPort-SDR: 3ETKUXA/Qw/MxCCNNA+k0nbEJTQx2K3XQSnhGxlxUwXm/mAWCNC91iVHb7kVQvwaUXImkfoNpK
 xN1yQPH/WM7Q==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="410338128"
Received: from rsperry-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.187])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:16:57 -0800
Date:   Wed, 27 Jan 2021 13:16:55 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH v3 06/27] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-Id: <20210127131655.d560b6be8b897471d770f54c@intel.com>
In-Reply-To: <c9da1c45-d4be-e0af-2b67-5408217deb34@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <8492ee41e947aa8151007e5ecbd9ef8914dd8827.1611634586.git.kai.huang@intel.com>
        <c9da1c45-d4be-e0af-2b67-5408217deb34@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jan 2021 08:19:25 -0800 Dave Hansen wrote:
> I'd also like to see some comments about code sharing between this and
> the main driver.  For instance, this *could* try to share 99% of the
> ->fault function.  Why doesn't it?  I'm sure there's a good reason.
> 
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> > new file mode 100644
> > index 000000000000..e1ad7856d878
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -0,0 +1,254 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*  Copyright(c) 2016-20 Intel Corporation. */
> > +
> > +#define pr_fmt(fmt)	"SGX virtual EPC: " fmt
> 
> Does this actually get used anywhere?  Also, isn't this a bit long?  Maybe:
> 
> #define pr_fmt(fmt)	"sgx/virt: " fmt

It is not used. My bad. I'll remove it.

And yes "sgx/virt: " is better. 

> 
> Also, a one-line summary about what's in here would be nice next to the
> copyright (which needs to be updated).
> 
> /*
>  * Device driver to expose SGX enclave memory to KVM guests.
>  *
>  * Copyright(c) 2016-20 Intel Corporation.
>  */

Will do. However the year should not be 2016-20, but should be 2021, right?

I think it has been ignored since the day Sean wrote the file.

> 
> 
> > +#include <linux/miscdevice.h>
> > +#include <linux/mm.h>
> > +#include <linux/mman.h>
> > +#include <linux/sched/mm.h>
> > +#include <linux/sched/signal.h>
> > +#include <linux/slab.h>
> > +#include <linux/xarray.h>
> > +#include <asm/sgx.h>
> > +#include <uapi/asm/sgx.h>
> > +
> > +#include "encls.h"
> > +#include "sgx.h"
> > +#include "virt.h"
> > +
> > +struct sgx_vepc {
> > +	struct xarray page_array;
> > +	struct mutex lock;
> > +};
> > +
> > +static struct mutex zombie_secs_pages_lock;
> > +static struct list_head zombie_secs_pages;
> 
> Comments would be nice for this random lock and list.
> 
> The main core functions (fault, etc...) are looking OK to me.

Thanks. How about below comment?

/*
 * List to temporarily hold SECS pages that cannot be EREMOVE'd due to
 * having child in other virtual EPC instances, and the lock to protect it.
 */

> 
> ...
> > +int __init sgx_vepc_init(void)
> > +{
> > +	/* SGX virtualization requires KVM to work */
> > +	if (!boot_cpu_has(X86_FEATURE_VMX) || !IS_ENABLED(CONFIG_KVM_INTEL))
> > +		return -ENODEV;
> 
> Can this even be built without IS_ENABLED(CONFIG_KVM_INTEL)?

I think no. Thanks. I'll remove IS_ENABLED(CONFIG_KVM_INTEL).

> 
> > +	INIT_LIST_HEAD(&zombie_secs_pages);
> > +	mutex_init(&zombie_secs_pages_lock);
> > +
> > +	return misc_register(&sgx_vepc_dev);
> > +}
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.h b/arch/x86/kernel/cpu/sgx/virt.h
> > new file mode 100644
> > index 000000000000..44d872380ca1
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/sgx/virt.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> > +#ifndef _ASM_X86_SGX_VIRT_H
> > +#define _ASM_X86_SGX_VIRT_H
> > +
> > +#ifdef CONFIG_X86_SGX_KVM
> > +int __init sgx_vepc_init(void);
> > +#else
> > +static inline int __init sgx_vepc_init(void)
> > +{
> > +	return -ENODEV;
> > +}
> > +#endif
> > +
> > +#endif /* _ASM_X86_SGX_VIRT_H */
> 
> Is more going to go in this header?  It's a little sparse as-is.

No there's no more. The sgx_vepc_init() function declaration needs to be here
since sgx/main.c needs to use it.

May I know your suggestion?

