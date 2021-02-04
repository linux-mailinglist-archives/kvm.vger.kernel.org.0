Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB29B30E85B
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhBDAMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:12:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:32888 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234156AbhBDAMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:12:09 -0500
IronPort-SDR: 5muCWEmxNQmhRgK7eHdjQtDLPQXprOZb2bLSZZLv0rZ+gYtaQ1Fa0/VgT7lO7qYZ0PzL4eujvT
 fJRgNnxGnY9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="180368580"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="180368580"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:11:54 -0800
IronPort-SDR: RPSvQDWeFFnF/S6W7RF3U/0957dqlAcXqvUw21sLMZLePmFmJPFTB4QVpfZ2LJ8s9Gg3vae1XF
 gKHvv2/G/rhw==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="356195736"
Received: from rvchebia-mobl.amr.corp.intel.com ([10.251.7.104])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:11:48 -0800
Message-ID: <ef5186430822cf849fd65a660517730d7ecd60fd.camel@intel.com>
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
Date:   Thu, 04 Feb 2021 13:11:45 +1300
In-Reply-To: <YBs4zeRxudvNem44@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
         <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
         <c235e9ca6fae38ae3a6828218cb1a68f2a0c3912.camel@intel.com>
         <YBr7R0ns79HB74XD@google.com>
         <b8b57360a1b4c0fa4486cd4c3892c7138e972fff.camel@intel.com>
         <YBszcbHsIlo4I8WC@google.com>
         <d5dd889484f6b8c3786ffe75c1505beb944275b3.camel@intel.com>
         <YBs4zeRxudvNem44@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-02-03 at 15:59 -0800, Sean Christopherson wrote:
> On Thu, Feb 04, 2021, Kai Huang wrote:
> > On Wed, 2021-02-03 at 15:36 -0800, Sean Christopherson wrote:
> > > On Thu, Feb 04, 2021, Kai Huang wrote:
> > > > On Wed, 2021-02-03 at 11:36 -0800, Sean Christopherson wrote:
> > > > > On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> > > > > > On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > > > > > Don't you need to deep copy the pageinfo.contents struct as well?
> > > > > > Otherwise the guest could change these after they were checked.
> > > > > > 
> > > > > > But it seems it is checked by the HW and something is caught that would
> > > > > > inject a GP anyway? Can you elaborate on the importance of these
> > > > > > checks?
> > > > > 
> > > > > Argh, yes.  These checks are to allow migration between systems with different
> > > > > SGX capabilities, and more importantly to prevent userspace from doing an end
> > > > > around on the restricted access to PROVISIONKEY.
> > > > > 
> > > > > IIRC, earlier versions did do a deep copy, but then I got clever.  Anyways, yeah,
> > > > > sadly the entire pageinfo.contents page will need to be copied.
> > > > 
> > > > I don't fully understand the problem. Are you worried about contents being updated by
> > > > other vcpus during the trap? 
> > > > 
> > > > And I don't see how copy can avoid this problem. Even you do copy, the content can
> > > > still be modified afterwards, correct? So what's the point of copying?
> > > 
> > > The goal isn't correctness, it's to prevent a TOCTOU bug.  E.g. the guest could
> > > do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and simultaneously set
> > > SGX_ATTR_PROVISIONKEY to bypass the above check.
> > 
> > Oh ok. Agreed.
> > 
> > However, such attack would require precise timing. Not sure whether it is feasible in
> > practice.
> 
> It's very feasible.  XOR the bit in a tight loop, build the enclave on a
> separate thread.  Do that until EINIT succeeds.  Compared to other timing
> attacks, I doubt it'd take all that long to get a successful result.

How does it work? The setting PROVISION bit needs to be set after KVM checks SECS's
attribute, and before KVM actually does ECREATE, right?

> 
> Regardless, the difficulty in exploiting the bug is irrelevant, it's a glaring
> flaw that needs to be fixed.

Sure.


