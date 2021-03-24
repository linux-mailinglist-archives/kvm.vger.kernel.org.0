Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE18348542
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 00:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhCXXX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 19:23:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:14556 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhCXXXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 19:23:49 -0400
IronPort-SDR: oJ1+qBYzTuvcMfabBLfz1XKfXgCR7WwHVyDG+1LCEaPCq5EyFHaoqErwjlFaKctBUA3tgnOsls
 DzZN0hcXlD6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="188513331"
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="188513331"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 16:23:49 -0700
IronPort-SDR: TjT8mVaAXncq/9NN9IWUcs+CkXPUg8Ns1ipcpKrJlhQfAUrH7oouXJiLlIjuxBVo0KZw16pRaz
 j1/zRlw9s9MQ==
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="415697964"
Received: from prdubey-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.226])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 16:23:45 -0700
Date:   Thu, 25 Mar 2021 12:23:43 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210325122343.008120ef70c1a1b16b5657ca@intel.com>
In-Reply-To: <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
References: <YFjoZQwB7e3oQW8l@google.com>
        <20210322191540.GH6481@zn.tnic>
        <YFjx3vixDURClgcb@google.com>
        <20210322210645.GI6481@zn.tnic>
        <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
        <20210322223726.GJ6481@zn.tnic>
        <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
        <YFoNCvBYS2lIYjjc@google.com>
        <20210323160604.GB4729@zn.tnic>
        <YFoVmxIFjGpqM6Bk@google.com>
        <20210323163258.GC4729@zn.tnic>
        <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
        <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
> > +/* Error message for EREMOVE failure, when kernel is about to leak EPC page */
> > +#define EREMOVE_ERROR_MESSAGE \
> > +       "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become
> > unusuable.  Please refer to Documentation/x86/sgx.rst for more information."
> 
> Rewritten:
> 
> EREMOVE returned %d and an EPC page was leaked; SGX may become unusable.
> This is a kernel bug, refer to Documentation/x86/sgx.rst for more information.
> 
> Also please split it across multiple lines.
> 
> Paolo
> 

Hi Boris/Paolo,

I changed to below (with slight modification on Paolo's):

/* Error message for EREMOVE failure, when kernel is about to leak EPC page */
#define EREMOVE_ERROR_MESSAGE \ 
        "EREMOVE returned %d (0x%x) and an EPC page was leaked.  SGX may become unusuable.  " \
        "This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more information."

I got a checkpatch warning however:

WARNING: It's generally not useful to have the filename in the file
#60: FILE: Documentation/x86/sgx.rst:223:
+This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more

I suppose it is OK? Since the error msg is actually hard-coded in the code,
and in this document, IMHO we should explicitly call out what error message user
is supposed to see, when this bug happens, so that user can absolutely know
he/she is dealing with this particular issue.



