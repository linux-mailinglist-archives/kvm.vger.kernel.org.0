Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F113095DA8
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfHTLnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 07:43:39 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:59344 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729611AbfHTLnj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Aug 2019 07:43:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 1651E30644B8;
        Tue, 20 Aug 2019 14:43:37 +0300 (EEST)
Received: from [192.168.1.34] (unknown [146.66.138.137])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 30A373011E05;
        Tue, 20 Aug 2019 14:43:35 +0300 (EEST)
Message-ID: <72df8b3ea66bb5bc7bb9c17e8bf12e12320358e1.camel@bitdefender.com>
Subject: Re: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR
 and KVMI_EVENT_MSR
From:   Mihai =?UTF-8?Q?Don=C8=9Bu?= <mdontu@bitdefender.com>
To:     Nicusor CITU <ncitu@bitdefender.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Adalbert =?UTF-8?Q?Laz=C4=83r?= <alazar@bitdefender.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?ISO-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "Zhang@vger.kernel.org" <Zhang@vger.kernel.org>,
        Yu C <yu.c.zhang@intel.com>
Date:   Tue, 20 Aug 2019 14:43:32 +0300
In-Reply-To: <6854bfcc2bff3ffdaadad8708bd186a071ad682c.camel@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
         <20190809160047.8319-56-alazar@bitdefender.com>
         <20190812210501.GD1437@linux.intel.com>
         <f9e94e9649f072911cc20129c2b633747d5c1df5.camel@bitdefender.com>
         <20190819183643.GB1916@linux.intel.com>
         <6854bfcc2bff3ffdaadad8708bd186a071ad682c.camel@bitdefender.com>
Organization: Bitdefender
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-08-20 at 08:44 +0000, Nicusor CITU wrote:
> > > > > +static void vmx_msr_intercept(struct kvm_vcpu *vcpu, unsigned
> > > > > int
> > > > > msr,
> > > > > +			      bool enable)
> > > > > +{
> > > > > +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > > > +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> > 
> > Is KVMI intended to play nice with nested virtualization? Unconditionally
> > updating vmcs01.msr_bitmap is correct regardless of whether the vCPU
> > is in L1 or L2, but if the vCPU is currently in L2 then the effective
> > bitmap, i.e. vmcs02.msr_bitmap, won't be updated until the next nested VM-
> > Enter.
> 
> Our initial proof of concept was running with success in nested
> virtualization. But most of our tests were done on bare-metal.
> We do however intend to make it fully functioning on nested systems
> too.
> 
> Even thought, from KVMI point of view, the MSR interception
> configuration would be just fine if it gets updated before the vcpu is
> actually entering to nested VM.
> 

I believe Sean is referring here to the case where the guest being
introspected is a hypervisor (eg. Windows 10 with device guard).

Even though we are looking at how to approach this scenario, the
introspection tools we have built will refuse to attach to a
hypervisor.

Regards,

-- 
Mihai Donțu


