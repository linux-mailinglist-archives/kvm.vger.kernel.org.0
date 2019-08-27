Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F25B9F46E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 22:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfH0Uns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 16:43:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:31669 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbfH0Uns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 16:43:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 13:43:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="205110747"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 27 Aug 2019 13:43:47 -0700
Date:   Tue, 27 Aug 2019 13:43:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Handle single-step #DB for EMULTYPE_SKIP on
 EPT misconfig
Message-ID: <20190827204347.GK27459@linux.intel.com>
References: <20190823213115.31908-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823213115.31908-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 02:31:15PM -0700, Sean Christopherson wrote:
> VMX's EPT misconfig flow to handle fast-MMIO path falls back to decoding
> the instruction to determine the instruction length when running as a
> guest (Hyper-V doesn't fill VMCS.VM_EXIT_INSTRUCTION_LEN because it's
> technically not defined for EPT misconfigs).  Rather than implement the
> slow skip in VMX's generic skip_emulated_instruction(),
> handle_ept_misconfig() directly calls kvm_emulate_instruction() with
> EMULTYPE_SKIP, which intentionally doesn't do single-step detection, and
> so handle_ept_misconfig() misses a single-step #DB.
> 
> Rework the EPT misconfig fallback case to route it through
> kvm_skip_emulated_instruction() so that single-step #DBs and interrupt
> shadow updates are handled automatically.  I.e. make VMX's slow skip
> logic match SVM's and have the SVM flow not intentionally avoid the
> shadow update.
> 
> Alternatively, the handle_ept_misconfig() could manually handle single-
> step detection, but that results in EMULTYPE_SKIP having split logic for
> the interrupt shadow vs. single-step #DBs, and split emulator logic is
> largely what led to this mess in the first place.
> 
> Modifying SVM to mirror VMX flow isn't really an option as SVM's case
> isn't limited to a specific exit reason, i.e. handling the slow skip in
> skip_emulated_instruction() is mandatory for all intents and purposes.
> 
> Drop VMX's skip_emulated_instruction() wrapper since it can now fail,
> and instead WARN if it fails unexpectedly, e.g. if exit_reason somehow
> becomes corrupted.
> 
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Fixes: d391f12070672 ("x86/kvm/vmx: do not use vm-exit instruction length for fast MMIO when running nested")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> *** LOOK HERE ***
> 
> This patch applies on top my recent emulation cleanup[1][2] as it has
> non-trivial conflicts, dealing with those seemed like a waste of time,
> and this doesn't seem like a candidate for stable.  Let me know if you'd
> prefer it to be respun without the dependency.
> 
> Sadly/ironically, this unwinds some of the logic that was recently
> added by Vitaly at my suggestion.  Hindsight is 20/20 and all that...
> 
> [1] https://lkml.kernel.org/r/20190823010709.24879-1-sean.j.christopherson@intel.com
> [2] https://patchwork.kernel.org/cover/11110331/

Paolo and/or Radim,

Please ignore this patch, I'll fold it into the aforementioned emulation
cleanup since I need to spin v2 of that series.
