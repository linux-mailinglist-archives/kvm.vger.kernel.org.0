Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F0026B090
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 00:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgIOWN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 18:13:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:36764 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbgIOQiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 12:38:54 -0400
IronPort-SDR: 6a2yjuiUcEA9QTSAJMqGvtOw55gSEu5VbyWrbrCyCIGK205wHSfrjHW1LTfQ3PEheZTRTU9Cbt
 S7djqP73aKBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="177366563"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="177366563"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:33:44 -0700
IronPort-SDR: 7k9HOsKnBIpD230s+kK4ULUCDbqylfwCiah/poMJ/8PFsSu0IbQrzbtuIbQzFV8f+C1S7q2b3Y
 66JM4ZgWKqVw==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="288054778"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:33:43 -0700
Date:   Tue, 15 Sep 2020 09:33:42 -0700
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
Subject: Re: [RFC PATCH 25/35] KVM: x86: Update __get_sregs() / __set_sregs()
 to support SEV-ES
Message-ID: <20200915163342.GC8420@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <e08f56496a52a3a974310fbe05bb19100fd6c1d8.1600114548.git.thomas.lendacky@amd.com>
 <20200914213708.GC7192@sjchrist-ice>
 <7fa6b074-6a62-3f8e-f047-c63851ebf7c9@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fa6b074-6a62-3f8e-f047-c63851ebf7c9@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 09:19:46AM -0500, Tom Lendacky wrote:
> On 9/14/20 4:37 PM, Sean Christopherson wrote:
> > On Mon, Sep 14, 2020 at 03:15:39PM -0500, Tom Lendacky wrote:
> >> From: Tom Lendacky <thomas.lendacky@amd.com>
> >>
> >> Since many of the registers used by the SEV-ES are encrypted and cannot
> >> be read or written, adjust the __get_sregs() / __set_sregs() to only get
> >> or set the registers being tracked (efer, cr0, cr4 and cr8) once the VMSA
> >> is encrypted.
> > 
> > Is there an actual use case for writing said registers after the VMSA is
> > encrypted?  Assuming there's a separate "debug mode" and live migration has
> > special logic, can KVM simply reject the ioctl() if guest state is protected?
> 
> Yeah, I originally had it that way but one of the folks looking at live
> migration for SEV-ES thought it would be easier given the way Qemu does
> things. But I think it's easy enough to batch the tracking registers into
> the VMSA state that is being transferred during live migration. Let me
> check that out and likely the SET ioctl() could just skip all the regs.

Hmm, that would be ideal.  How are the tracked registers validated when they're
loaded at the destination?  It seems odd/dangerous that KVM would have full
control over efer/cr0/cr4/cr8.  I.e. why is KVM even responsibile for migrating
that information, e.g. as opposed to migrating an opaque blob that contains
encrypted versions of those registers?
