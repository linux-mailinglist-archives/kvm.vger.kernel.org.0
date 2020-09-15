Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E5026A9D4
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgIOQbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 12:31:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:63720 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727537AbgIOQaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 12:30:55 -0400
IronPort-SDR: MfjOib9TbUe/tuATOYbbh13vwUL/HHaexPHNLpz3U5mzV0/QXeoI5B1ALoAybTIXrwG20I2myV
 ZFSrc/MAQC0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="138802074"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="138802074"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:30:14 -0700
IronPort-SDR: FjsqJk6wUJ2aGTolsZm+KpI+O4OmPL1HznU8jd0bAMqc+xAHRfulpM5MkI6xQ02maeAfxTlFtC
 x7DRG/Psz2tg==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="288053125"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:30:13 -0700
Date:   Tue, 15 Sep 2020 09:30:10 -0700
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
Message-ID: <20200915163010.GB8420@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
 <20200914212601.GA7192@sjchrist-ice>
 <fd790047-4107-b28a-262e-03ed5bc4c421@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd790047-4107-b28a-262e-03ed5bc4c421@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 08:37:12AM -0500, Tom Lendacky wrote:
> On 9/14/20 4:26 PM, Sean Christopherson wrote:
> > On Mon, Sep 14, 2020 at 03:15:22PM -0500, Tom Lendacky wrote:
> >> From: Tom Lendacky <thomas.lendacky@amd.com>
> >>
> >> Since the guest register state of an SEV-ES guest is encrypted, debugging
> >> is not supported. Update the code to prevent guest debugging when the
> >> guest is an SEV-ES guest. This includes adding a callable function that
> >> is used to determine if the guest supports being debugged.
> >>
> >> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> >> ---
> >>  arch/x86/include/asm/kvm_host.h |  2 ++
> >>  arch/x86/kvm/svm/svm.c          | 16 ++++++++++++++++
> >>  arch/x86/kvm/vmx/vmx.c          |  7 +++++++
> >>  arch/x86/kvm/x86.c              |  3 +++
> >>  4 files changed, 28 insertions(+)
> >>
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index c900992701d6..3e2a3d2a8ba8 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -1234,6 +1234,8 @@ struct kvm_x86_ops {
> >>  	void (*reg_read_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
> >>  	void (*reg_write_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg,
> >>  				   unsigned long val);
> >> +
> >> +	bool (*allow_debug)(struct kvm *kvm);
> > 
> > Why add both allow_debug() and vmsa_encrypted?  I assume there are scenarios
> > where allow_debug() != vmsa_encrypted?  E.g. is there a debug mode for SEV-ES
> > where the VMSA is not encrypted, but KVM (ironically) can't intercept #DBs or
> > something?
> 
> No, once the guest has had LAUNCH_UPDATE_VMSA run against the vCPUs, then
> the vCPU states are all encrypted. But that doesn't mean that debugging
> can't be done in the future.

I don't quite follow the "doesn't mean debugging can't be done in the future".
Does that imply that debugging could be supported for SEV-ES guests, even if
they have an encrypted VMSA?
