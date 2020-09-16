Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB10926CB98
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgIPUaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:30:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:19312 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgIPRVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 13:21:21 -0400
IronPort-SDR: 8ukguTZ4f1SUug5kzNE/8Ka8JAbyG3vB86Y9wbTR26TADdkjR1DOhhQ7NI3w8h6Vrg/JPRKAS9
 0qA5OVik9jcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="244340747"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="244340747"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:02:36 -0700
IronPort-SDR: RvbkOg0yPbL+k8A0PRubgOPsxVaYPCXIBn/0cAgKLZlM/vFjE6hK5kcCxnDDSM6eii/skUQ0Lt
 M+Blt9qb3T7g==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="288402007"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:02:34 -0700
Date:   Wed, 16 Sep 2020 09:02:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 08/35] KVM: SVM: Prevent debugging under SEV-ES
Message-ID: <20200916160210.GA10227@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
 <20200914212601.GA7192@sjchrist-ice>
 <fd790047-4107-b28a-262e-03ed5bc4c421@amd.com>
 <20200915163010.GB8420@sjchrist-ice>
 <aff46d8d-07ff-7d14-3e7f-ffe60f2bd779@amd.com>
 <5e816811-450f-b732-76f7-6130479642e0@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e816811-450f-b732-76f7-6130479642e0@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 10:11:10AM -0500, Tom Lendacky wrote:
> On 9/15/20 3:13 PM, Tom Lendacky wrote:
> > On 9/15/20 11:30 AM, Sean Christopherson wrote:
> >> I don't quite follow the "doesn't mean debugging can't be done in the future".
> >> Does that imply that debugging could be supported for SEV-ES guests, even if
> >> they have an encrypted VMSA?
> > 
> > Almost anything can be done with software. It would require a lot of
> > hypervisor and guest code and changes to the GHCB spec, etc. So given
> > that, probably just the check for arch.guest_state_protected is enough for
> > now. I'll just need to be sure none of the debugging paths can be taken
> > before the VMSA is encrypted.
> 
> So I don't think there's any guarantee that the KVM_SET_GUEST_DEBUG ioctl
> couldn't be called before the VMSA is encrypted, meaning I can't check the
> arch.guest_state_protected bit for that call. So if we really want to get
> rid of the allow_debug() op, I'd need some other way to indicate that this
> is an SEV-ES / protected state guest.

Would anything break if KVM "speculatively" set guest_state_protected before
LAUNCH_UPDATE_VMSA?  E.g. does KVM need to emulate before LAUNCH_UPDATE_VMSA?

> How are you planning on blocking this ioctl for TDX? Would the
> arch.guest_state_protected bit be sit earlier than is done for SEV-ES?

Yep, guest_state_protected is set from time zero (kvm_x86_ops.vm_init) as
guest state is encrypted/inaccessible from the get go.  The flag actually
gets turned off for debuggable TDX guests, but that's also forced to happen
before the KVM_RUN can be invoked (TDX architecture) and is a one-time
configuration, i.e. userspace can flip the switch exactly once, and only at
a very specific point in time.
