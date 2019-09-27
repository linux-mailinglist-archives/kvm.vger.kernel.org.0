Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA70C0736
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 16:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfI0OW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 10:22:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:28113 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfI0OW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 10:22:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 07:22:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="389979087"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 27 Sep 2019 07:22:58 -0700
Date:   Fri, 27 Sep 2019 07:22:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Reto Buerki <reet@codelabs.ch>
Subject: Re: [PATCH 1/2] KVM: nVMX: Always write vmcs02.GUEST_CR3 during
 nested VM-Enter
Message-ID: <20190927142258.GA24889@linux.intel.com>
References: <20190926214302.21990-1-sean.j.christopherson@intel.com>
 <20190926214302.21990-2-sean.j.christopherson@intel.com>
 <CALMp9eQVSg31uPy+RKAnsEZixtwix55CijC1DKKbmH-iNiJw9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQVSg31uPy+RKAnsEZixtwix55CijC1DKKbmH-iNiJw9g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:39:28PM -0700, Jim Mattson wrote:
> On Thu, Sep 26, 2019 at 2:43 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > -       vmcs_writel(GUEST_CR3, guest_cr3);
> > +       if (!skip_cr3)
> > +               vmcs_writel(GUEST_CR3, guest_cr3);
> 
> Is this part of the change necessary, or is it just an optimization to
> save a redundant VMWRITE?

Save the redundant VMWRITE.  I also wanted to convey the idea that the
nested code is responsible for setting GUEST_CR3 to the correct value.
I'd be happy to add a comment to make the latter point explicit.

> >  }
> >
> >  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> > --
> > 2.22.0
> >
