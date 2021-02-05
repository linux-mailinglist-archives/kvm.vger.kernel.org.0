Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E78310B23
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 13:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbhBEMgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 07:36:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:46470 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232148AbhBEMdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 07:33:42 -0500
IronPort-SDR: mSiTMEPLWrL85gMbWrnX3fTz5ghv0GFNiUkNqwanWs6tmH1L4m677nXefYqJXAQ5bOJ2RZO5tl
 TveCGvnZknHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="181490635"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="181490635"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 04:33:00 -0800
IronPort-SDR: /RP21vhYieDly6c3NcARWjOrNa+aVTRf6m5/uYOoNbjVkzUbnRJWQgHssxtWMsp8HMs32Mx1eX
 PywILmtIIRFQ==
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="508523273"
Received: from nadams-mobl1.amr.corp.intel.com ([10.254.96.120])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 04:32:56 -0800
Message-ID: <35808048da366b7e531f291c3611c1172f988d6a.camel@intel.com>
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
Date:   Sat, 06 Feb 2021 01:32:53 +1300
In-Reply-To: <635e339e-e3f5-c437-0265-b9d44c180858@intel.com>
References: <f50ac476-71f2-60d4-5008-672365f4d554@intel.com>
         <YBrfF0XQvzQf9PhR@google.com>
         <475c5f8b-efb7-629d-b8d2-2916ee150e4f@redhat.com>
         <c827fed1-d7af-a94a-b69e-114d4a2ec988@intel.com>
         <d044ccde68171dc319d77917c8ab9f83e9a98645.camel@intel.com>
         <YBsyqLHPtYOpqeW4@google.com>
         <b6e0a32f-0070-f97e-5d94-d12f7972d474@intel.com>
         <44b5a747aaf1d42fb8ef388bd28f49614d42cd50.camel@intel.com>
         <YBs/vveIBg00Im0U@google.com>
         <5bd3231e05911bc64f5c51e1eddc3ed1f6bfe6c4.camel@intel.com>
         <YBwgw0vVCjlhFvqP@google.com>
         <635e339e-e3f5-c437-0265-b9d44c180858@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-02-04 at 08:48 -0800, Dave Hansen wrote:
> On 2/4/21 8:28 AM, Sean Christopherson wrote:
> > > Do we see any security risk here?
> > Not with current CPUs, which drop writes and read all ones.  If future CPUs take
> > creatives liberties with the SDM, then we could have a problem, but that's why
> > Dave is trying to get stronger guarantees into the SDM.
> 
> I really don't like the idea of the abort page being used by code that
> doesn't know what it's dealing with.  It just seems like trouble (aka.
> security risk) waiting to happen.

Hi Dave,

Just to confirm, you want this (disallow ioremap() for EPC) fixed in upstream kernel
before KVM SGX can be merged, correct?

If so, and since it seems you also agreed that better solution is to modify ioremap()
to refuse to map EPC, what do you think of the sample code Sean put in his previous
reply?

https://www.spinics.net/lists/kvm/msg234754.html

IMHO adding 'bool sgx_epc' to ioremap_desc seems not ideal, since it's not generic.
Instead, we may define some new flag here, and ioremap_desc->flag can just cope with
it.

Btw as Sean already pointed out, SGX code uses memremap() to initialize EPC section,
and we could choose to still allow this to avoid code change to SGX driver. But it
seems it is a little hack here. What's your opinion? 

Hi Sean,

If we all agree the fix is needed here, do you want to work on the patch (since you
already provided your thought), or do you want me to do it, with Suggested-by you?

