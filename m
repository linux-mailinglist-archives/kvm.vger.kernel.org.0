Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66A730E6DA
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 00:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhBCXMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 18:12:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:38758 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhBCXLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 18:11:53 -0500
IronPort-SDR: HnWjrkITVVPXofg1I/pds9U23ziJsnvJ4aFqjWXaFJqaVtG+hiE9PR5Hn1IqEv/6cVe9DzhFNr
 VTUEC9XpnXnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="178573697"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="178573697"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:11:12 -0800
IronPort-SDR: jBv23RtswQXmbmaklkEgNsCN/lssnr17GBfN6Bu97a5wr99aBmLcVEMiFWwUPbaYq42DHJCXof
 4hvQ5nvpzOww==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="576071191"
Received: from rvchebia-mobl.amr.corp.intel.com ([10.251.7.104])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:11:08 -0800
Message-ID: <61fd68c4f03881596331c663040b92751bd67832.camel@intel.com>
Subject: Re: [RFC PATCH v3 23/27] KVM: VMX: Add SGX ENCLS[ECREATE] handler
 to enforce CPUID restrictions
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
Date:   Thu, 04 Feb 2021 12:11:05 +1300
In-Reply-To: <YBrYaFxo6S79l0kA@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
         <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
         <f60226157935d2bbc20958e6eae7c3532b72f7a3.camel@intel.com>
         <YBn+DBXJgPmA1iED@google.com>
         <20210203221110.c50ec5cd50a77d269c3656bd@intel.com>
         <YBrYaFxo6S79l0kA@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-02-03 at 09:07 -0800, Sean Christopherson wrote:
> On Wed, Feb 03, 2021, Kai Huang wrote:
> > On Tue, 2 Feb 2021 17:36:12 -0800 Sean Christopherson wrote:
> > > On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> > > > On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > > > > +       /*
> > > > > +        * Verify alignment early.  This conveniently avoids having
> > > > > to worry
> > > > > +        * about page splits on userspace addresses.
> > > > > +        */
> > > > > +       if (!IS_ALIGNED(pageinfo.metadata, 64) ||
> > > > > +           !IS_ALIGNED(pageinfo.contents, 4096)) {
> > > > > +               kvm_inject_gp(vcpu, 0);
> > > > > +               return 1;
> > > > > +       }
> > > > > +
> > > > > +       /*
> > > > > +        * Translate the SECINFO, SOURCE and SECS pointers from GVA
> > > > > to GPA.
> > > > > +        * Resume the guest on failure to inject a #PF.
> > > > > +        */
> > > > > +       if (sgx_gva_to_gpa(vcpu, pageinfo.metadata, false,
> > > > > &metadata_gpa) ||
> > > > > +           sgx_gva_to_gpa(vcpu, pageinfo.contents, false,
> > > > > &contents_gpa) ||
> > > > > +           sgx_gva_to_gpa(vcpu, secs_gva, true, &secs_gpa))
> > > > > +               return 1;
> > > > > +
> > > > 
> > > > Do pageinfo.metadata and pageinfo.contents need cannonical checks here?
> > > 
> > > Bugger, yes.  So much boilerplate needed in this code :-/
> > > 
> > > Maybe add yet another helper to do alignment+canonical checks, up where the
> > > IS_ALIGNED() calls are?
> > 
> > sgx_get_encls_gva() already does canonical check. Couldn't we just use it?
> 
> After rereading the SDM for the bajillionth time, yes, these should indeed use
> sgx_get_encls_gva().  Originally I was thinking they were linear addresses, but
> they are effective addresses that use DS, i.e. not using the helper to avoid the
> DS.base adjustment for 32-bit mode was also wrong.

Agreed.

> 
> > For instance:
> > 
> > 	if (sgx_get_encls_gva(vcpu, pageinfo.metadata, 64, 64 &metadata_gva) ||
> > 	    sgx_get_encls_gva(vcpu, pageinfo.contents, 4096, 4096,
> >                              &contents_gva))
> > 		return 1;


