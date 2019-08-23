Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C469B262
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 16:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395403AbfHWOoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 10:44:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:63244 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393066AbfHWOoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 10:44:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 07:44:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="186886059"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Aug 2019 07:44:23 -0700
Date:   Fri, 23 Aug 2019 07:44:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 07/13] KVM: x86: Add explicit flag for forced
 emulation on #UD
Message-ID: <20190823144423.GB6713@linux.intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-8-sean.j.christopherson@intel.com>
 <9E01A06E-FD3E-4D43-9FFE-6FFE3BAC269A@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9E01A06E-FD3E-4D43-9FFE-6FFE3BAC269A@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 04:47:14PM +0300, Liran Alon wrote:
> 
> 
> > On 23 Aug 2019, at 4:07, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > Add an explicit emulation type for forced #UD emulation and use it to
> > detect that KVM should unconditionally inject a #UD instead of falling
> > into its standard emulation failure handling.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> The name "forced emulation on #UD" is not clear to me.
> 
> If I understand correctly, EMULTYPE_TRAP_UD is currently used to indicate
> that in case the x86 emulator fails to decode instruction, the caller would
> like the x86 emulator to fail early such that it can handle this condition
> properly.  Thus, I would rename it EMULTYPE_TRAP_DECODE_FAILURE.

EMULTYPE_TRAP_UD is used when KVM intercepts a #UD from hardware.  KVM
only emulates select instructions in this case in order to minmize the
emulator attack surface, e.g.:

	if (unlikely(ctxt->ud) && likely(!(ctxt->d & EmulateOnUD)))
		return EMULATION_FAILED;

To enable testing of the emulator, KVM recognizes a special "opcode" that
triggers full emulation on #UD, e.g. ctxt->ud is false when the #UD was
triggered with the magic prefix.  The prefix is only recognized when the
module param force_emulation_prefix is toggled on, hence the name
EMULTYPE_TRAP_UD_FORCED.

> But this new flag seems to do the same. So I’m left confused.  I’m probably
> missing something trivial here.
