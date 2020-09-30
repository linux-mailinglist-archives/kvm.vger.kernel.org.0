Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B96E27DF98
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 06:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgI3Egj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 00:36:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:5430 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3Egj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 00:36:39 -0400
IronPort-SDR: lUEc7sfSsqONBBlYgiJDxDtY9cW9Q4Gdo8JJOJW1KedwFn0yt1oAKflumiE8VwodNKBclVbh+L
 9fqxKhtuFtlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="142368827"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="142368827"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:36:36 -0700
IronPort-SDR: 6hFfz19yZeyuyxQ59dTSdWl5V8qDl517+Wlh4aW0ckJ1DVz2z1uLxpP2r8oj8F0acT/qKLT0rK
 gbsVMFA3CKSA==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="350541088"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:36:36 -0700
Date:   Tue, 29 Sep 2020 21:36:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 6/7] KVM: X86: Expose PKS to guest and userspace
Message-ID: <20200930043634.GA29319@linux.intel.com>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-7-chenyi.qiang@intel.com>
 <CALMp9eQ=QUZ04_26eXBGHqvQYnsN6JEgiV=ZSSrE395KLX-atA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQ=QUZ04_26eXBGHqvQYnsN6JEgiV=ZSSrE395KLX-atA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 12:04:54PM -0700, Jim Mattson wrote:
> On Fri, Aug 7, 2020 at 1:47 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> >
> > Existence of PKS is enumerated via CPUID.(EAX=7H,ECX=0):ECX[31]. It is
> > enabled by setting CR4.PKS when long mode is active. PKS is only
> > implemented when EPT is enabled and requires the support of VM_{ENTRY,
> > EXIT}_LOAD_IA32_PKRS currently.
> >
> > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> > @@ -967,7 +969,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  {
> >         unsigned long old_cr4 = kvm_read_cr4(vcpu);
> >         unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
> > -                                  X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
> > +                                  X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE |
> > +                                  X86_CR4_PKS;
> 
> This list already seems overly long, but I don't think CR4.PKS belongs
> here. In volume 3 of the SDM, section 4.4.1, it says:
> 
> - If PAE paging would be in use following an execution of MOV to CR0
> or MOV to CR4 (see Section 4.1.1) and the instruction is modifying any
> of CR0.CD, CR0.NW, CR0.PG, CR4.PAE, CR4.PGE, CR4.PSE, or CR4.SMEP;
> then the PDPTEs are loaded from the address in CR3.
> 
> CR4.PKS is not in the list of CR4 bits that result in a PDPTE load.
> Since it has no effect on PAE paging, I would be surprised if it did
> result in a PDPTE load.

It does belong in the mmu_role_bits though ;-)
