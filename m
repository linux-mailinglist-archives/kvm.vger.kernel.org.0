Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5D52FE310
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 07:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbhAUGkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 01:40:46 -0500
Received: from mga14.intel.com ([192.55.52.115]:32076 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732416AbhATXop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 18:44:45 -0500
IronPort-SDR: qWG5qIWpk2XY37Wy3HsYzOn/beIivXRTC0DYHusjTGUhTlNCS8DRxyCvD5ph/Ut1+05X6ivIC6
 Rp/1md5obRiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="178414238"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="178414238"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:44:04 -0800
IronPort-SDR: WnpQK+ri1k9zBZVblwFl3QMkcNgGiQFWplNCQ0D9LEcL4Fa24dkr6GfUyQKoLiB6nyvRUr4qEF
 jzcvc4vYCqSg==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="570548176"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:44:01 -0800
Date:   Thu, 21 Jan 2021 12:43:59 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 11/26] x86/sgx: Add encls_faulted() helper
Message-Id: <20210121124359.7fff8c6d6f90182d8d13062f@intel.com>
In-Reply-To: <YAgb/MhaNLVwBS8K@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
        <e36ac729b227d728e2b0d1a48cfbbeca4523f1a5.1610935432.git.kai.huang@intel.com>
        <YAgb/MhaNLVwBS8K@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 14:03:08 +0200 Jarkko Sakkinen wrote:
> On Mon, Jan 18, 2021 at 04:28:04PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add a helper to extract the fault indicator from an encoded ENCLS return
> > value.  SGX virtualization will also need to detect ENCLS faults.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encls.h | 14 +++++++++++++-
> >  arch/x86/kernel/cpu/sgx/ioctl.c |  2 +-
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> > index be5c49689980..55919a2b01b0 100644
> > --- a/arch/x86/kernel/cpu/sgx/encls.h
> > +++ b/arch/x86/kernel/cpu/sgx/encls.h
> > @@ -40,6 +40,18 @@
> >  	} while (0);							  \
> >  }
> >  
> > +/*
> > + * encls_faulted() - Check if an ENCLS leaf faulted given an error code
> > + * @ret		the return value of an ENCLS leaf function call
> > + *
> > + * Return:
> > + *	%true if @ret indicates a fault, %false otherwise
> 
> Follow here the style of commenting as in ioctl.c, for the return value.
> It has optimal readability both as text, and also when converted to HTML.
> See sgx_ioc_enclave_add_pages() for an example.

You mean something like below?

Return:
- %true:  @ret indicates a fault.
- %false: @ret indicates no fault.
