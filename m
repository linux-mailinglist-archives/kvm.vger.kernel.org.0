Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA6E1BB2F8
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 02:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgD1AdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 20:33:18 -0400
Received: from mga05.intel.com ([192.55.52.43]:41331 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgD1AdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 20:33:18 -0400
IronPort-SDR: bJPqrIgYsP/8gUvWXDNFgWasencwxvuOXDd/dXczGGfEe/70e140c0EKNoKbW7+vfTlkuWFYUn
 X2LsuURMGjng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 17:33:17 -0700
IronPort-SDR: 9KpS+xelx3QsJwLoqXzGT5Rmn2Xu98is1rERQcf+WvISeXIKF/KRSRAqW3NMmMp3m8S0sWUpry
 4ZbvqplHqZhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="246333189"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 27 Apr 2020 17:33:17 -0700
Date:   Mon, 27 Apr 2020 17:33:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        everdox@gmail.com
Subject: Re: [PATCH] KVM: x86: handle wrap around 32-bit address space
Message-ID: <20200428003317.GC14870@linux.intel.com>
References: <20200427165917.31799-1-pbonzini@redhat.com>
 <CALMp9eTBs=deSYu1=CMLwZcO8HTpGM2JsgDxvFR1Y220tdUQ3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTBs=deSYu1=CMLwZcO8HTpGM2JsgDxvFR1Y220tdUQ3w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 05:28:54PM -0700, Jim Mattson wrote:
> On Mon, Apr 27, 2020 at 9:59 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > @@ -1568,8 +1568,17 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
> >          */
> >         if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
> >             to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
> > -               rip = kvm_rip_read(vcpu);
> > -               rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
> > +               orig_rip = kvm_rip_read(vcpu);
> > +               rip = orig_rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
> > +#ifdef CONFIG_X86_64
> > +               /*
> > +                * We need to mask out the high 32 bits of RIP if not in 64-bit
> > +                * mode, but just finding out that we are in 64-bit mode is
> > +                * quite expensive.  Only do it if there was a carry.
> > +                */
> > +               if (unlikely(((rip ^ orig_rip) >> 31) == 3) && !is_64_bit_mode(vcpu))
> 
> Is it actually possible to wrap around 0 without getting a segment
> limit violation, or is it only possible to wrap *to* 0 (i.e. rip==1ull
> << 32)?

Arbitrary wrap is possible.  Limit checks are disabled for flat segs, it's
a legacy bug^W feature.
