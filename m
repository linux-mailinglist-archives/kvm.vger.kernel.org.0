Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621F934B067
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 21:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhCZUi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 16:38:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:48097 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhCZUir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 16:38:47 -0400
IronPort-SDR: 1f8q0nkGf/0jM/KXewepdR1PuS1w8Bnf3DCig44IhE72Kf6FIiiwsUhKEDq4ggaiNnOXIrqUo4
 JVhZwdhSLh8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="178761770"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="178761770"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 13:38:46 -0700
IronPort-SDR: O2uja2csHXg7K/DgOUSjgk+XDeXN/2N0WlHLqeuYDNib2gA4sqxHKJxU93COZL074It7ehDhNn
 V/Usgx5flsFQ==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="608990510"
Received: from jainmu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.8.82])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 13:38:42 -0700
Date:   Sat, 27 Mar 2021 09:38:40 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v4 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210327093840.f9e6c2dbfb14f4b2babc4924@intel.com>
In-Reply-To: <YF46ndD3rdotgOpl@kernel.org>
References: <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
        <20210325093057.122834-1-kai.huang@intel.com>
        <YF46ndD3rdotgOpl@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> > index 653af8ca1a25..6b21a165500e 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -13,6 +13,11 @@
> >  #undef pr_fmt
> >  #define pr_fmt(fmt) "sgx: " fmt
> >  
> > +/* Error message for EREMOVE failure, when kernel is about to leak EPC page */
> > +#define EREMOVE_ERROR_MESSAGE \
> > +	"EREMOVE returned %d (0x%x) and an EPC page was leaked.  SGX may become unusuable.  " \
> > +	"This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more information."
> 
> 
> Why this needs to be here and not open coded where it is used?
> 
I want to use it in sgx/virt.c as well. Please see my reply to patch 5.
