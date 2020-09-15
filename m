Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02D526AC6A
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 20:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgIOSow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 14:44:52 -0400
Received: from mga05.intel.com ([192.55.52.43]:16833 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727591AbgIORcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 13:32:05 -0400
IronPort-SDR: j945rw/tZiMtIyu6Z9xqc+7CBpVgbn1BVFWf3+1ywxljSlC/7qIZ9eXDKYpFtckHzlizZxN6Zy
 DnKA9XSfe9qw==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="244143766"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="244143766"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 10:32:04 -0700
IronPort-SDR: LkpV4y0gFkMjvYwMOvoxzfhIAthofs96RLIv/8OgJIa19pS4IFZdHKr7mNwuANYbIpTyHHf1W+
 kohW3ssHGbcg==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="451509688"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 10:32:04 -0700
Date:   Tue, 15 Sep 2020 10:32:02 -0700
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
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
Message-ID: <20200915173202.GF8420@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 12:22:05PM -0500, Tom Lendacky wrote:
> On 9/14/20 5:59 PM, Sean Christopherson wrote:
> > On Mon, Sep 14, 2020 at 03:15:14PM -0500, Tom Lendacky wrote:
> >> From: Tom Lendacky <thomas.lendacky@amd.com>
> >>
> >> This patch series provides support for running SEV-ES guests under KVM.
> > 
> > From the x86/VMX side of things, the GPR hooks are the only changes that I
> > strongly dislike.
> > 
> > For the vmsa_encrypted flag and related things like allow_debug(), I'd
> > really like to aim for a common implementation between SEV-ES and TDX[*] from
> > the get go, within reason obviously.  From a code perspective, I don't think
> > it will be too onerous as the basic tenets are quite similar, e.g. guest
> > state is off limits, FPU state is autoswitched, etc..., but I suspect (or
> > maybe worry?) that there are enough minor differences that we'll want a more
> > generic way of marking ioctls() as disallowed to avoid having one-off checks
> > all over the place.
> > 
> > That being said, it may also be that there are some ioctls() that should be
> > disallowed under SEV-ES, but aren't in this series.  E.g. I assume
> > kvm_vcpu_ioctl_smi() should be rejected as KVM can't do the necessary
> > emulation (I assume this applies to vanilla SEV as well?).
> 
> Right, SMM isn't currently supported under SEV-ES. SEV does support SMM,
> though, since the register state can be altered to change over to the SMM
> register state. So the SMI ioctl() is ok for SEV.

But isn't guest memory inaccessible for SEV?  E.g. how does KVM emulate the
save/restore to/from SMRAM?
