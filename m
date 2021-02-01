Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CC730A0EB
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 05:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhBAEqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 23:46:06 -0500
Received: from mga17.intel.com ([192.55.52.151]:4936 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230085AbhBAEpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 23:45:49 -0500
IronPort-SDR: GhjeMNWF1ydSEsI6DdjqeI8AxSptfsqTpU8PlSfA7uVga1U4ULTm4+x+FkIYbhXx3lJHZvGZi+
 e8uKSZ+nLgKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160399947"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160399947"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 20:44:57 -0800
IronPort-SDR: 8QBDI3Q486lOlQSJPu8MLyTgMdAPktH/VbHzh5cqVyT5NeIIOA+0bUa5C+skxPAhP7C6MKZ4xZ
 5Z4FKWHRs2hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="478555672"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.172])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2021 20:44:55 -0800
Date:   Mon, 1 Feb 2021 12:56:48 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        yu.c.zhang@linux.intel.com, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v14 10/13] KVM: x86: Enable CET virtualization for VMX
 and advertise CET to userspace
Message-ID: <20210201045648.GA14975@local-michael-cet-test.sh.intel.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <20201106011637.14289-11-weijiang.yang@intel.com>
 <d7a7a337-c1ca-8221-73c6-7936d1763cae@redhat.com>
 <20210129112437.GA29715@local-michael-cet-test.sh.intel.com>
 <68e288ee-6e09-36f1-a6c9-bed864eb7678@redhat.com>
 <20210129121717.GA30243@local-michael-cet-test.sh.intel.com>
 <1cf7e501-2c69-8b76-9332-42db1348ab08@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1cf7e501-2c69-8b76-9332-42db1348ab08@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 29, 2021 at 03:38:52PM +0100, Paolo Bonzini wrote:
> On 29/01/21 13:17, Yang Weijiang wrote:
> > > > It's specific to VM case, during VM reboot, memory mode reset but VM_ENTRY_LOAD_CET_STATE
> > > > is still set, and VMCS contains stale GUEST_SSP, this hits vm-entry failure
> > > > documented in 10.7 VM Entry at:
> > > > https://software.intel.com/sites/default/files/managed/4d/2a/control-flow-enforcement-technology-preview.pdf
> > > > Since CR4.CET is also reset during VM reboot, to take the change to clear the stale data.
> > > > Maybe I need to find a better place to do the things.
> > > Then you must use a field of struct vmx_vcpu instead of the VMCS to hold
> > > GUEST_SSP (while GUEST_S_CET and GUEST_INTR_SSP_TABLE should not be an
> > > issue).
> > > 
> > Sorry, I don't get your point, can I just clear the GUEST_SSP field in this case?
> > Anyway save/restore GUEST_SSP via VMCS is an efficient way.
> 
> You cannot clear it, because it is preserved when CR4.CET is modified.
> 
> However, I checked the latest SDM and the GUEST_SSP rules are changed to
> just this:
> 
> SSP. The following checks are performed if the “load CET state” VM-entry
> control is 1
> — Bits 1:0 must be 0.
> — If the processor supports the Intel 64 architecture, bits 63:N must be
> identical, where N is the CPU’s maximum linear-address width. (This check
> does not apply if the processor supports 64 linear-address bits.) The guest
> SSP value is not required to be canonical; the value of bit N-1 may differ
> from that of bit N.
> 
> In particular it doesn't mention the "IA-32e mode guest" VM-entry control or
> the CS.L bit anymore, so it should not be necessary anymore to even reset
> SSP to 0, and you can keep GUEST_SSP in the VMCS.
>
The vm-entry failure issue is due to mismatch of MSR_KVM_GUEST_SSP between QEMU and KVM.
The original code is occupied by other usage, so QEMU cannot reset it properly.
Sorry for the noise!

> Paolo
