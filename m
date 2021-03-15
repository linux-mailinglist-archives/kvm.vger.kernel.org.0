Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2EA33AA0B
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 04:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhCODhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 23:37:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:57989 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhCODhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 23:37:10 -0400
IronPort-SDR: e1r5JljvBOPGx4ajwvWAGHSN4QFUUiPzsOOpjvJ4s2FDYiBwDaPJWSHQ3FsMoxJJ+pfJqpOtbW
 TjGK9HhpZgOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="208925243"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="208925243"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 20:37:04 -0700
IronPort-SDR: Ua5HwDV6UApRMkS6GpJy7024IbgwWZvc1n8Z/1mrpqRZNPs1sKhl2ZRqge/8Z4VBlDlGrBCv8O
 T3kDvZ9X2FlQ==
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="371499675"
Received: from avaldezb-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.198])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 20:36:59 -0700
Date:   Mon, 15 Mar 2021 16:36:56 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 08/25] x86/sgx: Expose SGX architectural definitions
 to the kernel
Message-Id: <20210315163656.df89c4f52573724e492cc11d@intel.com>
In-Reply-To: <YEvkEJkM0D7oZWE3@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
        <b60e1d665c17ed6430166d659bd0f547a53aea0f.1615250634.git.kai.huang@intel.com>
        <YEvkEJkM0D7oZWE3@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 13:58:40 -0800 Sean Christopherson wrote:
> On Tue, Mar 09, 2021, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Expose SGX architectural structures, as KVM will use many of the
> > architectural constants and structs to virtualize SGX.
> > 
> > Name the new header file as asm/sgx.h, rather than asm/sgx_arch.h, to
> > have single header to provide SGX facilities to share with other kernel
> > componments.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> 
> Same checkpatch warning.  Probably doesn't matter.

Will change order to make checkpatch happy for this whole series.

Thanks for pointing out.

> 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  .../cpu/sgx/arch.h => include/asm/sgx.h}      | 20 ++++++++++++++-----
> >  arch/x86/kernel/cpu/sgx/encl.c                |  2 +-
> >  arch/x86/kernel/cpu/sgx/sgx.h                 |  2 +-
> >  tools/testing/selftests/sgx/defines.h         |  2 +-
> >  4 files changed, 18 insertions(+), 8 deletions(-)
> >  rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx.h} (95%)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/include/asm/sgx.h
> > similarity index 95%
> > rename from arch/x86/kernel/cpu/sgx/arch.h
> > rename to arch/x86/include/asm/sgx.h
> > index abf99bb71fdc..d4ad35f6319a 100644
> > --- a/arch/x86/kernel/cpu/sgx/arch.h
> > +++ b/arch/x86/include/asm/sgx.h
> > @@ -2,15 +2,20 @@
> >  /**
> >   * Copyright(c) 2016-20 Intel Corporation.
> >   *
> > - * Contains data structures defined by the SGX architecture.  Data structures
> > - * defined by the Linux software stack should not be placed here.
> > + * Intel Software Guard Extensions (SGX) support.
> >   */
> > -#ifndef _ASM_X86_SGX_ARCH_H
> > -#define _ASM_X86_SGX_ARCH_H
> > +#ifndef _ASM_X86_SGX_H
> > +#define _ASM_X86_SGX_H
> >  
> >  #include <linux/bits.h>
> >  #include <linux/types.h>
> >  
> > +/*
> > + * This file contains both data structures defined by SGX architecture and Linux
> > + * defined software data structures and functions.  The two should not be mixed
> > + * together for better readibility.  The architectural definitions come first.
> > + */
> > +
> >  /* The SGX specific CPUID function. */
> >  #define SGX_CPUID		0x12
> >  /* EPC enumeration. */
> > @@ -337,4 +342,9 @@ struct sgx_sigstruct {
> >  
> >  #define SGX_LAUNCH_TOKEN_SIZE 304
> >  
> > -#endif /* _ASM_X86_SGX_ARCH_H */
> > +/*
> > + * Do not put any hardware-defined SGX structure representations below this
> > + * line!
> 
> Heh, which line?  Yep, it's Friday afternoon...

Hmm.. I will change to below this comment. :)
