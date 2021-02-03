Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E095830E7C9
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 00:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhBCXqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 18:46:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:22083 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhBCXq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 18:46:29 -0500
IronPort-SDR: uJlE3O+J2P5WqmwZehxz+4mHQHNVGJe/ZIDxsOGv1kf8Fb02cfk8I4QAQiPVwuY5Mbyb+5/X7c
 i79wb1nflMyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="181280703"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="181280703"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:45:43 -0800
IronPort-SDR: yE6xGgJSCqIzKBLtqWisJrZaAzfH3JnZvrLFJkPMBnP5SgTBvsNqKW7F2QSjCXCGLoZHcRGjl9
 tywWW1g9xCXQ==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="433668893"
Received: from rvchebia-mobl.amr.corp.intel.com ([10.251.7.104])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:45:38 -0800
Message-ID: <d5dd889484f6b8c3786ffe75c1505beb944275b3.camel@intel.com>
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
Date:   Thu, 04 Feb 2021 12:45:34 +1300
In-Reply-To: <YBszcbHsIlo4I8WC@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
         <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
         <c235e9ca6fae38ae3a6828218cb1a68f2a0c3912.camel@intel.com>
         <YBr7R0ns79HB74XD@google.com>
         <b8b57360a1b4c0fa4486cd4c3892c7138e972fff.camel@intel.com>
         <YBszcbHsIlo4I8WC@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-02-03 at 15:36 -0800, Sean Christopherson wrote:
> On Thu, Feb 04, 2021, Kai Huang wrote:
> > On Wed, 2021-02-03 at 11:36 -0800, Sean Christopherson wrote:
> > > On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> > > > On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > > > > +       /* Exit to userspace if copying from a host userspace address
> > > > > fails. */
> > > > > +       if (sgx_read_hva(vcpu, m_hva, &miscselect,
> > > > > sizeof(miscselect)) ||
> > > > > +           sgx_read_hva(vcpu, a_hva, &attributes,
> > > > > sizeof(attributes)) ||
> > > > > +           sgx_read_hva(vcpu, x_hva, &xfrm, sizeof(xfrm)) ||
> > > > > +           sgx_read_hva(vcpu, s_hva, &size, sizeof(size)))
> > > > > +               return 0;
> > > > > +
> > > > > +       /* Enforce restriction of access to the PROVISIONKEY. */
> > > > > +       if (!vcpu->kvm->arch.sgx_provisioning_allowed &&
> > > > > +           (attributes & SGX_ATTR_PROVISIONKEY)) {
> > > > > +               if (sgx_12_1->eax & SGX_ATTR_PROVISIONKEY)
> > > > > +                       pr_warn_once("KVM: SGX PROVISIONKEY
> > > > > advertised but not allowed\n");
> > > > > +               kvm_inject_gp(vcpu, 0);
> > > > > +               return 1;
> > > > > +       }
> > > > > +
> > > > > +       /* Enforce CPUID restrictions on MISCSELECT, ATTRIBUTES and
> > > > > XFRM. */
> > > > > +       if ((u32)miscselect & ~sgx_12_0->ebx ||
> > > > > +           (u32)attributes & ~sgx_12_1->eax ||
> > > > > +           (u32)(attributes >> 32) & ~sgx_12_1->ebx ||
> > > > > +           (u32)xfrm & ~sgx_12_1->ecx ||
> > > > > +           (u32)(xfrm >> 32) & ~sgx_12_1->edx) {
> > > > > +               kvm_inject_gp(vcpu, 0);
> > > > > +               return 1;
> > > > > +       }
> > > > 
> > > > Don't you need to deep copy the pageinfo.contents struct as well?
> > > > Otherwise the guest could change these after they were checked.
> > > > 
> > > > But it seems it is checked by the HW and something is caught that would
> > > > inject a GP anyway? Can you elaborate on the importance of these
> > > > checks?
> > > 
> > > Argh, yes.  These checks are to allow migration between systems with different
> > > SGX capabilities, and more importantly to prevent userspace from doing an end
> > > around on the restricted access to PROVISIONKEY.
> > > 
> > > IIRC, earlier versions did do a deep copy, but then I got clever.  Anyways, yeah,
> > > sadly the entire pageinfo.contents page will need to be copied.
> > 
> > I don't fully understand the problem. Are you worried about contents being updated by
> > other vcpus during the trap? 
> > 
> > And I don't see how copy can avoid this problem. Even you do copy, the content can
> > still be modified afterwards, correct? So what's the point of copying?
> 
> The goal isn't correctness, it's to prevent a TOCTOU bug.  E.g. the guest could
> do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and simultaneously set
> SGX_ATTR_PROVISIONKEY to bypass the above check.

Oh ok. Agreed.

However, such attack would require precise timing. Not sure whether it is feasible in
practice.

> 
> > Looks a better solution is to kick all vcpus and put them into block state
> > while KVM is doing ENCLS for guest.
> 
> No.  (a) it won't work, as the memory is writable from host userspace.  (b) that
> does not scale, at all.

Good point. Agreed.

