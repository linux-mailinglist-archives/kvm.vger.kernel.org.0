Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370F630D5F8
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 10:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhBCJM5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 3 Feb 2021 04:12:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:30494 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233260AbhBCJL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 04:11:59 -0500
IronPort-SDR: rtFndnB87DhvUK80sO3rfxkL8sUFeQ0dq6X+BtmjZaPMPsx714d34yphOB50o4qqoCT8Xzi3IY
 5s6R8BeogSBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="180236352"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="180236352"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 01:11:16 -0800
IronPort-SDR: lkF3YBeus05rtUyvywU4oGiG33MV3CixKci2kHDF7/M9LlluSc+7IPBU8nzG0PStu/Tvcohv2e
 aFmNXY7TV5pg==
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="392345797"
Received: from jalva12x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.229])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 01:11:13 -0800
Date:   Wed, 3 Feb 2021 22:11:10 +1300
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
Subject: Re: [RFC PATCH v3 23/27] KVM: VMX: Add SGX ENCLS[ECREATE] handler
 to enforce CPUID restrictions
Message-Id: <20210203221110.c50ec5cd50a77d269c3656bd@intel.com>
In-Reply-To: <YBn+DBXJgPmA1iED@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
        <f60226157935d2bbc20958e6eae7c3532b72f7a3.camel@intel.com>
        <YBn+DBXJgPmA1iED@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 17:36:12 -0800 Sean Christopherson wrote:
> On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> > On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > > +static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
> > > +{
> > > +       unsigned long a_hva, m_hva, x_hva, s_hva, secs_hva;
> > > +       struct kvm_cpuid_entry2 *sgx_12_0, *sgx_12_1;
> > > +       gpa_t metadata_gpa, contents_gpa, secs_gpa;
> > > +       struct sgx_pageinfo pageinfo;
> > > +       gva_t pageinfo_gva, secs_gva;
> > > +       u64 attributes, xfrm, size;
> > > +       struct x86_exception ex;
> > > +       u8 max_size_log2;
> > > +       u32 miscselect;
> > > +       int trapnr, r;
> > > +
> > > +       sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
> > > +       sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
> > > +       if (!sgx_12_0 || !sgx_12_1) {
> > > +               kvm_inject_gp(vcpu, 0);
> > > +               return 1;
> > > +       }
> > > +
> > > +       if (sgx_get_encls_gva(vcpu, kvm_rbx_read(vcpu), 32, 32,
> > > &pageinfo_gva) ||
> > > +           sgx_get_encls_gva(vcpu, kvm_rcx_read(vcpu), 4096, 4096,
> > > &secs_gva))
> > > +               return 1;
> > > +
> > > +       /*
> > > +        * Copy the PAGEINFO to local memory, its pointers need to be
> > > +        * translated, i.e. we need to do a deep copy/translate.
> > > +        */
> > > +       r = kvm_read_guest_virt(vcpu, pageinfo_gva, &pageinfo,
> > > +                               sizeof(pageinfo), &ex);
> > > +       if (r == X86EMUL_PROPAGATE_FAULT) {
> > > +               kvm_inject_emulated_page_fault(vcpu, &ex);
> > > +               return 1;
> > > +       } else if (r != X86EMUL_CONTINUE) {
> > > +               sgx_handle_emulation_failure(vcpu, pageinfo_gva,
> > > size);
> > > +               return 0;
> > > +       }
> > > +
> > > +       /*
> > > +        * Verify alignment early.  This conveniently avoids having
> > > to worry
> > > +        * about page splits on userspace addresses.
> > > +        */
> > > +       if (!IS_ALIGNED(pageinfo.metadata, 64) ||
> > > +           !IS_ALIGNED(pageinfo.contents, 4096)) {
> > > +               kvm_inject_gp(vcpu, 0);
> > > +               return 1;
> > > +       }
> > > +
> > > +       /*
> > > +        * Translate the SECINFO, SOURCE and SECS pointers from GVA
> > > to GPA.
> > > +        * Resume the guest on failure to inject a #PF.
> > > +        */
> > > +       if (sgx_gva_to_gpa(vcpu, pageinfo.metadata, false,
> > > &metadata_gpa) ||
> > > +           sgx_gva_to_gpa(vcpu, pageinfo.contents, false,
> > > &contents_gpa) ||
> > > +           sgx_gva_to_gpa(vcpu, secs_gva, true, &secs_gpa))
> > > +               return 1;
> > > +
> > 
> > Do pageinfo.metadata and pageinfo.contents need cannonical checks here?
> 
> Bugger, yes.  So much boilerplate needed in this code :-/
> 
> Maybe add yet another helper to do alignment+canonical checks, up where the
> IS_ALIGNED() calls are?

sgx_get_encls_gva() already does canonical check. Couldn't we just use it?

For instance:

	if (sgx_get_encls_gva(vcpu, pageinfo.metadata, 64, 64 &metadata_gva) ||
	    sgx_get_encls_gva(vcpu, pageinfo.contents, 4096, 4096,
                             &contents_gva))
		return 1;
