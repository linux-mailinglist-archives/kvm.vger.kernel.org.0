Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DBA3093D2
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 10:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhA3J6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 04:58:39 -0500
Received: from mga14.intel.com ([192.55.52.115]:50717 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232095AbhA3J6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 04:58:13 -0500
IronPort-SDR: ikcQCoVpMBbr6YBbwJZPvpiehnMuZlPGlFwR4TAZF8m7mFKt2mHykDbPpxRmcgvLfbPrJCoNLZ
 zCfyvY3QCPhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="179737600"
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="179737600"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 22:21:02 -0800
IronPort-SDR: gsIxBNEk1p7y2CN7wGS1EX/q44I3cPbKn1b36U0rYEXwrUsy1YwWfodafXoArJ4YIr2iojhI41
 7WEj4+BhWKnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="365660269"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.172])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jan 2021 22:21:00 -0800
Date:   Sat, 30 Jan 2021 14:32:56 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        yu.c.zhang@linux.intel.com, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v14 10/13] KVM: x86: Enable CET virtualization for VMX
 and advertise CET to userspace
Message-ID: <20210130063256.GA2572@local-michael-cet-test.sh.intel.com>
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
There could be some gaps between the two specs, I tested VM reboot with these patches,
if I don't clear GUEST_SSP field while CR4.CET is changed, then it always encounters the
vm-entry failure issue, the VMCS dump is like below:

[341485.265277] *** Guest State ***
[341485.265280] CR0: actual=0x0000000000000030,
shadow=0x0000000060000010, gh_mask=fffffffffffffff7
[341485.265281] CR4: actual=0x0000000000002040,
shadow=0x0000000000000000, gh_mask=fffffffffffef871
[341485.265282] CR3 = 0x0000000000000000
[341485.265283] RSP = 0x0000000000000000  RIP = 0x000000000000fff0
[341485.265283] RFLAGS=0x00000002         DR7 = 0x0000000000000400
[341485.265284] Sysenter RSP=0000000000000000
CS:RIP=0000:0000000000000000
[341485.265285] CS:   sel=0xf000, attr=0x0009b, limit=0x0000ffff,
base=0x00000000ffff0000
[341485.265286] DS:   sel=0x0000, attr=0x00093, limit=0x0000ffff,
base=0x0000000000000000
[341485.265287] SS:   sel=0x0000, attr=0x00093, limit=0x0000ffff,
base=0x0000000000000000
[341485.265288] ES:   sel=0x0000, attr=0x00093, limit=0x0000ffff,
base=0x0000000000000000
[341485.265288] FS:   sel=0x0000, attr=0x00093, limit=0x0000ffff,
base=0x0000000000000000
[341485.265289] GS:   sel=0x0000, attr=0x00093, limit=0x0000ffff,
base=0x0000000000000000
[341485.265289] GDTR:                           limit=0x0000ffff,
base=0x0000000000000000
[341485.265290] LDTR: sel=0x0000, attr=0x00082, limit=0x0000ffff,
base=0x0000000000000000
[341485.265291] IDTR:                           limit=0x0000ffff,
base=0x0000000000000000
[341485.265291] TR:   sel=0x0000, attr=0x0008b, limit=0x0000ffff,
base=0x0000000000000000
[341485.265292] EFER =     0x0000000000000000  PAT = 0x0007040600070406
[341485.265292] DebugCtl = 0x0000000000000000  DebugExceptions =
0x0000000000000000
[341485.265293] Interruptibility = 00000000  ActivityState = 00000000
[341485.265294] InterruptStatus = 0000
[341485.265294] S_CET = 0x0000000000000000
[341485.265295] SSP = 0x00007fc1727fdfd0
[341485.265295] SSP TABLE = 0x0000000000000000
[341485.265296] *** Host State ***
[341485.265296] RIP = 0xffffffffc1235900  RSP = 0xffffaed7c150bd68
[341485.265297] CS=0010 SS=0018 DS=0000 ES=0000 FS=0000 GS=0000 TR=0040
[341485.265298] FSBase=00007f6851d36700 GSBase=ffff9de2e0980000
TRBase=fffffe0000141000
[341485.265298] GDTBase=fffffe000013f000 IDTBase=fffffe0000000000
[341485.265299] CR0=0000000080050033 CR3=00000001135ae001
CR4=0000000000f72ee0
[341485.265300] Sysenter RSP=fffffe0000141000
CS:RIP=0010:ffffffff8dc015e0
[341485.265301] EFER = 0x0000000000000d01  PAT = 0x0407050600070106
[341485.265301] *** Control State ***
[341485.265302] PinBased=000000ff CPUBased=b5a06dfa
SecondaryExec=021237eb
[341485.265303] EntryControls=0010d1ff ExitControls=102befff
[341485.265303] ExceptionBitmap=00060042 PFECmask=00000000
PFECmatch=00000000
[341485.265304] VMEntry: intr_info=00000000 errcode=00000000
ilen=00000000
[341485.265305] VMExit: intr_info=00000000 errcode=00000000
ilen=00000002
[341485.265306]         reason=80000021 qualification=0000000000000000
[341485.265306] IDTVectoring: info=00000000 errcode=00000000
[341485.265307] TSC Offset = 0xfffd10acb111a2a0
[341485.265307] TSC Multiplier = 0x0001000000000000
[341485.265308] SVI|RVI = 00|00 TPR Threshold = 0x00
[341485.265309] APIC-access addr = 0x0000000499d63000 virt-APIC addr =
0x000000011ade6000
[341485.265310] PostedIntrVec = 0xf2
[341485.265310] EPT pointer = 0x000000011fffc05e
[341485.265310] PLE Gap=00000080 Window=00010000
[341485.265311] Virtual processor ID = 0x0001
[341485.265312] S_CET = 0x0000000000000000
[341485.265312] SSP = 0x0000000000000000
[341485.265312] SSP TABLE = 0x0000000000000000

The alternative way is to clear it in exit_lmode(), it also works.  

> Paolo
