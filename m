Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB573D6C60
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 05:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbhG0Cbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 22:31:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:36608 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234422AbhG0Cbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 22:31:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10057"; a="210467668"
X-IronPort-AV: E=Sophos;i="5.84,272,1620716400"; 
   d="scan'208";a="210467668"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2021 20:12:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,272,1620716400"; 
   d="scan'208";a="662385851"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jul 2021 20:12:02 -0700
Message-ID: <488727679c7e8b8cc76656b49309e633cf377d9c.camel@linux.intel.com>
Subject: Re: [kvm-unit-tests PATCH] x86: vmx_tests: pml: Skip PML test if
 it's not enabled in underlying
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, bsd@redhat.com
Date:   Tue, 27 Jul 2021 11:12:02 +0800
In-Reply-To: <YP9RPhWwI1At3fLX@google.com>
References: <1627179854-1878-1-git-send-email-robert.hu@linux.intel.com>
         <YP9RPhWwI1At3fLX@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-07-27 at 00:20 +0000, Sean Christopherson wrote:
> On Sun, Jul 25, 2021, Robert Hoo wrote:
> > PML in VM depends on "enable PML" in VM-execution control, check
> > this
> > before vmwrite to PMLADDR, because this field doesn't exist if PML
> > is
> > disabled in VM-execution control.
> 
> No, the field doesn't exist if the CPU doesn't support PML.  Whether
> or not PML
> is enabled in the execution controls is irrelevant.  
Right, Thanks Sean.
> pml_init() checks for both
> secondary execution controls and PML support (with bad indentation).
> 
> 	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
> 		!(ctrl_cpu_rev[1].clr & CPU_PML)) {
> 		printf("\tPML is not supported");
> 		return VMX_TEST_EXIT;
> 	}
> 
> 	pml_log = alloc_page();
> 	vmcs_write(PMLADDR, (u64)pml_log);
> 	vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
> 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > ---
> >  x86/vmx_tests.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > index 4f712eb..8663112 100644
> > --- a/x86/vmx_tests.c
> > +++ b/x86/vmx_tests.c
> > @@ -1502,13 +1502,16 @@ static int pml_init(struct vmcs *vmcs)
> >  		return VMX_TEST_EXIT;
> >  	}
> >  
> > +	ctrl_cpu = vmcs_read(CPU_EXEC_CTRL1) & CPU_PML;
> > +	if (!ctrl_cpu) {
> > +		printf("\tPML is not enabled\n");
> > +		return VMX_TEST_EXIT;
> > +	}
> > +
> >  	pml_log = alloc_page();
> >  	vmcs_write(PMLADDR, (u64)pml_log);
> >  	vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
> >  
> > -	ctrl_cpu = vmcs_read(CPU_EXEC_CTRL1) | CPU_PML;
> > -	vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu);
> > -
> >  	return VMX_TEST_START;
> >  }
> >  
> > -- 
> > 1.8.3.1
> > 

