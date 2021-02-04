Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3E430E83F
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhBDAFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:05:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:26783 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233522AbhBDAFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:05:25 -0500
IronPort-SDR: xulitVS0hXwzHhoHxJqeIvqjuAO3v1NI+Q6U5ssbHeAnq0iKtvakDvQHJYkrTvSeClff+urS1x
 MCz3dxPA0qUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="200111745"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="200111745"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:04:37 -0800
IronPort-SDR: 60masuulLU2E4MO1NE4WRaDQlhutp9bbEQ0NQ38rgWMEnTuQo+C6dxHgPPd1sJ7gW8XI73LQxN
 iQKBRQDF4i8g==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="356193753"
Received: from rvchebia-mobl.amr.corp.intel.com ([10.251.7.104])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:04:31 -0800
Message-ID: <44b5a747aaf1d42fb8ef388bd28f49614d42cd50.camel@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Date:   Thu, 04 Feb 2021 13:04:29 +1300
In-Reply-To: <b6e0a32f-0070-f97e-5d94-d12f7972d474@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
         <4b4b9ed1d7756e8bccf548fc41d05c7dd8367b33.camel@intel.com>
         <YBnTPmbPCAUS6XNl@google.com>
         <99135352-8e10-fe81-f0dc-8d552d73e3d3@intel.com>
         <YBnmow4e8WUkRl2H@google.com>
         <f50ac476-71f2-60d4-5008-672365f4d554@intel.com>
         <YBrfF0XQvzQf9PhR@google.com>
         <475c5f8b-efb7-629d-b8d2-2916ee150e4f@redhat.com>
         <c827fed1-d7af-a94a-b69e-114d4a2ec988@intel.com>
         <d044ccde68171dc319d77917c8ab9f83e9a98645.camel@intel.com>
         <YBsyqLHPtYOpqeW4@google.com>
         <b6e0a32f-0070-f97e-5d94-d12f7972d474@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-02-03 at 15:37 -0800, Dave Hansen wrote:
> On 2/3/21 3:32 PM, Sean Christopherson wrote:
> > > > > Yeah, special casing KVM is almost always the wrong thing to do.
> > > > > Anything that KVM can do, other subsystems will do as well.
> > > > Agreed.  Thwarting ioremap itself seems like the right way to go.
> > > This sounds irrelevant to KVM SGX, thus I won't include it to KVM SGX series.
> > I would say it's relevant, but a pre-existing bug.  Same net effect on what's
> > needed for this series..
> > 
> > I say it's a pre-existing bug, because I'm pretty sure KVM can be coerced into
> > accessing the EPC by handing KVM a memslot that's backed by an enclave that was
> > created by host userspace (via /dev/sgx_enclave).
> 
> Dang, you beat me to it.  I was composing another email that said the
> exact same thing.
> 
> I guess we need to take a closer look at the KVM fallout from this.
> It's a few spots where it KVM knew it might be consuming garbage.  It
> just get extra weird stinky garbage now.

I don't quite understand how KVM will need to access EPC memslot. It is *guest*, but
not KVM, who can read EPC from non-enclave. And if I understand correctly, there will
be no place for KVM to use kernel address of EPC to access it. To KVM, there's no
difference, whether EPC backend is from /dev/sgx_enclave, or /dev/sgx_vepc. And we
really cannot prevent guest from doing anything. 

So how memremap() of EPC section is related to KVM SGX? For instance, the
implementation of this series needs to be modified due to this?

