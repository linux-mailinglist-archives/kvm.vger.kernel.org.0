Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA9C21F258
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 15:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgGNNVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 09:21:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:58115 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgGNNVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 09:21:22 -0400
IronPort-SDR: 0T6wLqTnzwnsgG/OSWQbH/xJUzulFP0jkuWIpBcUiA7inxMvJ/ewff1+PFOHoOVXXQGOFVvdND
 YL0r3BCD/5WQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="128966758"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="128966758"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 06:21:21 -0700
IronPort-SDR: kCiMPCl1Qydi60siPoOuJ+7wnu0UGhdD7QYRimAzQ0KV/49J86+Om3E/LrVmec4ZbULeGc3v3S
 mtFiKLDx4fuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="281747816"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 14 Jul 2020 06:21:21 -0700
Date:   Tue, 14 Jul 2020 06:21:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Don't attempt to load PDPTRs when 64-bit mode
 is enabled
Message-ID: <20200714132120.GA14404@linux.intel.com>
References: <20200714015732.32426-1-sean.j.christopherson@intel.com>
 <87wo36s3wb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo36s3wb.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:00:04PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 95ef629228691..5f526d94c33f3 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -819,22 +819,22 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> >  	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
> >  		return 1;
> >  
> > -	if (cr0 & X86_CR0_PG) {
> >  #ifdef CONFIG_X86_64
> > -		if (!is_paging(vcpu) && (vcpu->arch.efer & EFER_LME)) {
> > -			int cs_db, cs_l;
> > +	if ((vcpu->arch.efer & EFER_LME) && !is_paging(vcpu) &&
> > +	    (cr0 & X86_CR0_PG)) {
> 
> it seems we have more than one occurance of "if (vcpu->arch.efer &
> EFER_LME)" under "#ifdef CONFIG_X86_64" and we alredy have 
> 
> static inline int is_long_mode(struct kvm_vcpu *vcpu)
> {
> #ifdef CONFIG_X86_64
>      return vcpu->arch.efer & EFER_LMA;
> #else
>      return 0;
> #endif
> }
> 
> so if we use this instead, the compilers will just throw away the
> non-reachable blocks when !(#ifdef CONFIG_X86_64), right?

EFER.LME vs. EFER.LMA.  The kvm_set_cr0() check is specifically looking at
the case where EFER.LME=1, EFER.LMA=0, and CR0.PG is being toggled on, i.e.
long mode is being enabled.  EFER_LMA won't be set until vmx_set_cr0() does
enter_lmode().
