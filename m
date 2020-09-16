Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F51926CD38
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgIPU4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:56:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:51996 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgIPQww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 12:52:52 -0400
IronPort-SDR: gWixcFHN3jAoJ6gFiDZSr7Ro9EuMOUod1GmMM5zhwcoPNfmbrpWhFohWWYwAfD/cOy/eOKS7sE
 FRNdkuXsirmQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="139024811"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="139024811"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:49:25 -0700
IronPort-SDR: 9XPDFBcq2CYfeTnmvu0XQg2wz09WgX6OsPOZPKgeySGJ/G5i9vFKH+uih3kTRLcOlE6xtadwXz
 BKL5zDVguypQ==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="307109500"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:49:24 -0700
Date:   Wed, 16 Sep 2020 09:49:23 -0700
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
Message-ID: <20200916164923.GC10227@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
 <20200914212601.GA7192@sjchrist-ice>
 <fd790047-4107-b28a-262e-03ed5bc4c421@amd.com>
 <20200915163010.GB8420@sjchrist-ice>
 <aff46d8d-07ff-7d14-3e7f-ffe60f2bd779@amd.com>
 <5e816811-450f-b732-76f7-6130479642e0@amd.com>
 <20200916160210.GA10227@sjchrist-ice>
 <b62e055a-000e-ff7b-00e4-41b5b39b55d5@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b62e055a-000e-ff7b-00e4-41b5b39b55d5@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 11:38:38AM -0500, Tom Lendacky wrote:
> 
> 
> On 9/16/20 11:02 AM, Sean Christopherson wrote:
> > On Wed, Sep 16, 2020 at 10:11:10AM -0500, Tom Lendacky wrote:
> >> On 9/15/20 3:13 PM, Tom Lendacky wrote:
> >>> On 9/15/20 11:30 AM, Sean Christopherson wrote:
> >>>> I don't quite follow the "doesn't mean debugging can't be done in the future".
> >>>> Does that imply that debugging could be supported for SEV-ES guests, even if
> >>>> they have an encrypted VMSA?
> >>>
> >>> Almost anything can be done with software. It would require a lot of
> >>> hypervisor and guest code and changes to the GHCB spec, etc. So given
> >>> that, probably just the check for arch.guest_state_protected is enough for
> >>> now. I'll just need to be sure none of the debugging paths can be taken
> >>> before the VMSA is encrypted.
> >>
> >> So I don't think there's any guarantee that the KVM_SET_GUEST_DEBUG ioctl
> >> couldn't be called before the VMSA is encrypted, meaning I can't check the
> >> arch.guest_state_protected bit for that call. So if we really want to get
> >> rid of the allow_debug() op, I'd need some other way to indicate that this
> >> is an SEV-ES / protected state guest.
> > 
> > Would anything break if KVM "speculatively" set guest_state_protected before
> > LAUNCH_UPDATE_VMSA?  E.g. does KVM need to emulate before LAUNCH_UPDATE_VMSA?
> 
> Yes, the way the code is set up, the guest state (VMSA) is initialized in
> the same way it is today (mostly) and that state is encrypted by the
> LAUNCH_UPDATE_VMSA call. I check the guest_state_protected bit to decide
> on whether to direct the updates to the real VMSA (before it's encrypted)
> or the GHCB (that's the get_vmsa() function from patch #5).

Ah, gotcha.  Would it work to set guest_state_protected[*] from time zero,
and move vmsa_encrypted to struct vcpu_svm?  I.e. keep vmsa_encrypted, but
use it only for guiding get_vmsa() and related behavior.
