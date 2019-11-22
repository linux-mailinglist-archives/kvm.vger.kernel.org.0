Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCE7107A7D
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfKVWT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:19:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:15223 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbfKVWT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:19:57 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:19:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409025722"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:19:55 -0800
Date:   Fri, 22 Nov 2019 14:19:55 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Marios Pomonis <pomonis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH] KVM: x86: Extend Spectre-v1 mitigation
Message-ID: <20191122221955.GI31235@linux.intel.com>
References: <20191122184039.7189-1-pomonis@google.com>
 <1ADDE0A8-40F1-4642-B8CC-8DE38609DC10@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ADDE0A8-40F1-4642-B8CC-8DE38609DC10@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 23, 2019 at 12:03:27AM +0200, Liran Alon wrote:
> 
> > On 22 Nov 2019, at 20:40, Marios Pomonis <pomonis@google.com> wrote:
> > @@ -5828,6 +5836,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> > {
> > 	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > 	u32 exit_reason = vmx->exit_reason;
> > +	u32 bounded_exit_reason = array_index_nospec(exit_reason,
> > +						kvm_vmx_max_exit_handlers);
> 
> Unlike the rest of this patch changes, exit_reason is not attacker-controllable.
> Therefore, I don’t think we need this change to vmx_handle_exit().

I waffled on this one too.  Theoretically, if an attacker finds a way to
trigger a VM-Exit that isn't yet known to KVM, and coordinates across
userspace and guest to keep rerunning the attack in the guest instead of
killing the VM (on the unexpected VM-Exit), then exit_reason is sort of
under attacker control.

Of course the above scenario would require a bug in KVM, e.g. enable an
unknown enabling/exiting control, or in a CPU, e.g. generate a new VM-Exit
without software opt-in or generate a completely bogus VM-Exit.  The
whole thing is pretty far fetched...
