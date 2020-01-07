Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513441335B5
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 23:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgAGW2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 17:28:15 -0500
Received: from mga17.intel.com ([192.55.52.151]:42133 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgAGW2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 17:28:15 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 14:28:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,407,1571727600"; 
   d="scan'208";a="211328975"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 07 Jan 2020 14:28:14 -0800
Date:   Tue, 7 Jan 2020 14:28:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
Message-ID: <20200107222813.GB16987@linux.intel.com>
References: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
 <20200106224931.GB12879@linux.intel.com>
 <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
 <20200106233846.GC12879@linux.intel.com>
 <a4fb7657-59b6-2a3f-1765-037a9a9cd03a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4fb7657-59b6-2a3f-1765-037a9a9cd03a@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 07, 2020 at 02:16:37PM -0600, Tom Lendacky wrote:
> On 1/6/20 5:38 PM, Sean Christopherson wrote:
> > On Mon, Jan 06, 2020 at 05:14:04PM -0600, Tom Lendacky wrote:
> >> On 1/6/20 4:49 PM, Sean Christopherson wrote:
> >>> This doesn't handle the case where x86_phys_bits _isn't_ reduced by SME/SEV
> >>> on a future processor, i.e. x86_phys_bits==52.
> >>
> >> Not sure I follow. If MSR_K8_SYSCFG_MEM_ENCRYPT is set then there will
> >> always be a reduction in physical addressing (so I'm told).
> > 
> > Hmm, I'm going off APM Vol 2, which states, or at least strongly implies,
> > that reducing the PA space is optional.  Section 7.10.2 is especially
> > clear on this:
> > 
> >   In implementations where the physical address size of the processor is
> >   reduced when memory encryption features are enabled, software must
> >   ensure it is executing from addresses where these upper physical address
> >   bits are 0 prior to setting SYSCFG[MemEncryptionModEn].
> 
> It's probably not likely, but given what is stated, I can modify my patch
> to check for a x86_phys_bits == 52 and skip the call to set the mask, eg:
> 
> 	if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT &&
> 	    boot_cpu_data.x86_phys_bits < 52) {
> 
> > 
> > But, hopefully the other approach I have in mind actually works, as it's
> > significantly less special-case code and would naturally handle either
> > case, i.e. make this a moot point.
> 
> I'll hold off on the above and wait for your patch.

Sorry for the delay, this is a bigger mess than originally thought.  Or
I'm completely misunderstanding the issue, which is also a distinct
possibility :-)

Due to KVM activating its L1TF mitigation irrespective of whether the CPU
is whitelisted as not being vulnerable to L1TF, simply using 86_phys_bits
to avoid colliding with the C-bit isn't sufficient as the L1TF mitigation
uses those first five reserved PA bits to store the MMIO GFN.  Setting
BIT(x86_phys_bits) for all MMIO sptes would cause it to be interpreted as
a GFN bit when the L1TF mitigation is active and lead to bogus MMIO.

The only sane approach I can think of is to activate the L1TF mitigation
based on whether the CPU is vulnerable to L1TF, as opposed to activating
the mitigation purely based on the max PA of the CPU.  Since all CPUs that
support SME/SEV are whitelisted as NO_L1TF, the L1TF mitigation and C-bit
should never be active at the same time.

Patch should be incoming soon...
