Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E69A97E6C
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 17:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbfHUPSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 11:18:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:14540 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727683AbfHUPSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 11:18:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 08:18:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="169443350"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 21 Aug 2019 08:18:46 -0700
Date:   Wed, 21 Aug 2019 08:18:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Cc:     Nicusor CITU <ncitu@bitdefender.com>,
        Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "Zhang@vger.kernel.org" <Zhang@vger.kernel.org>,
        Yu C <yu.c.zhang@intel.com>
Subject: Re: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR
 and KVMI_EVENT_MSR
Message-ID: <20190821151846.GD29345@linux.intel.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-56-alazar@bitdefender.com>
 <20190812210501.GD1437@linux.intel.com>
 <f9e94e9649f072911cc20129c2b633747d5c1df5.camel@bitdefender.com>
 <20190819183643.GB1916@linux.intel.com>
 <6854bfcc2bff3ffdaadad8708bd186a071ad682c.camel@bitdefender.com>
 <72df8b3ea66bb5bc7bb9c17e8bf12e12320358e1.camel@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72df8b3ea66bb5bc7bb9c17e8bf12e12320358e1.camel@bitdefender.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 02:43:32PM +0300, Mihai Donțu wrote:
> On Tue, 2019-08-20 at 08:44 +0000, Nicusor CITU wrote:
> > > > > > +static void vmx_msr_intercept(struct kvm_vcpu *vcpu, unsigned
> > > > > > int
> > > > > > msr,
> > > > > > +			      bool enable)
> > > > > > +{
> > > > > > +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > > > > +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> > > 
> > > Is KVMI intended to play nice with nested virtualization? Unconditionally
> > > updating vmcs01.msr_bitmap is correct regardless of whether the vCPU
> > > is in L1 or L2, but if the vCPU is currently in L2 then the effective
> > > bitmap, i.e. vmcs02.msr_bitmap, won't be updated until the next nested VM-
> > > Enter.
> > 
> > Our initial proof of concept was running with success in nested
> > virtualization. But most of our tests were done on bare-metal.
> > We do however intend to make it fully functioning on nested systems
> > too.
> > 
> > Even thought, from KVMI point of view, the MSR interception
> > configuration would be just fine if it gets updated before the vcpu is
> > actually entering to nested VM.
> > 
> 
> I believe Sean is referring here to the case where the guest being
> introspected is a hypervisor (eg. Windows 10 with device guard).

Yep.

> Even though we are looking at how to approach this scenario, the
> introspection tools we have built will refuse to attach to a
> hypervisor.

In that case, it's probably a good idea to make KVMI mutually exclusive
with nested virtualization.  Doing so should, in theory, simplify the
implementation and expedite upstreaming, e.g. reviewers don't have to
nitpick edge cases related to nested virt.  My only hesitation in
disabling KVMI when nested virt is enabled is that it could make it much
more difficult to (re)enable the combination in the future.
