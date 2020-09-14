Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0167A26995C
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 01:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgINW74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 18:59:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:1391 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbgINW7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 18:59:55 -0400
IronPort-SDR: rzU3lg1wfIxWQbmEHhheSUnxls/nP7kcFWWzk+15UPP13yO/O9T6bm0HdJ959juTXGNZPsFTcS
 nIYmect9NxHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="177238134"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="177238134"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:59:54 -0700
IronPort-SDR: PR9eeCTKRz5/PcwRlMba1YjXAM4vWFwG38MB6Uncr64Vujld/yUU1mW3spssTd5ac9NnYVRwmj
 Sfik+urfVgaQ==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482527697"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:59:54 -0700
Date:   Mon, 14 Sep 2020 15:59:52 -0700
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
Message-ID: <20200914225951.GM7192@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:15:14PM -0500, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> This patch series provides support for running SEV-ES guests under KVM.

From the x86/VMX side of things, the GPR hooks are the only changes that I
strongly dislike.

For the vmsa_encrypted flag and related things like allow_debug(), I'd
really like to aim for a common implementation between SEV-ES and TDX[*] from
the get go, within reason obviously.  From a code perspective, I don't think
it will be too onerous as the basic tenets are quite similar, e.g. guest
state is off limits, FPU state is autoswitched, etc..., but I suspect (or
maybe worry?) that there are enough minor differences that we'll want a more
generic way of marking ioctls() as disallowed to avoid having one-off checks
all over the place.

That being said, it may also be that there are some ioctls() that should be
disallowed under SEV-ES, but aren't in this series.  E.g. I assume
kvm_vcpu_ioctl_smi() should be rejected as KVM can't do the necessary
emulation (I assume this applies to vanilla SEV as well?).

One thought to try and reconcile the differences between SEV-ES and TDX would
be expicitly list which ioctls() are and aren't supported and go from there?
E.g. if there is 95% overlap than we probably don't need to get fancy with
generic allow/deny.

Given that we don't yet have publicly available KVM code for TDX, what if I
generate and post a list of ioctls() that are denied by either SEV-ES or TDX,
organized by the denier(s)?  Then for the ioctls() that are denied by one and
not the other, we add a brief explanation of why it's denied?

If that sounds ok, I'll get the list and the TDX side of things posted
tomorrow.

Thanks!


[*] https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
