Return-Path: <kvm+bounces-23894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4D594F9D1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3A621C22199
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53C819AA43;
	Mon, 12 Aug 2024 22:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BrXDDi42"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAD9194AE6;
	Mon, 12 Aug 2024 22:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502910; cv=none; b=MN1rGTyKxvZu+H9fL5c5VxCy1100a+1+qmX+DeMibP412iPETy9OdhT4H+QUOqLXUWgUiNxoEmtY62Z/Oi9iJP/+gnLE+K5UoEdt82S7enBUWTghqs31ALhNtylh3Rqo/rwO52tEv9rR1JD/FlR1QvESKoWWwZedReN2MWSGP3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502910; c=relaxed/simple;
	bh=8T1B6z+eCzyDzuLrMlaHIwBz/g8ZCRk+IScbBU6+QZY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Y+Py1CG15Xlkt5hJDebBxAwhhLrTWMzU40a8TIzZfXQmB9X71WI5GhLkgULlhgnNgnZVhgqB7skzJ1bEcCKoeFVMlqEP39jV6cHzD8P55rYTpONruAtA0AGcE4VDCZMKlKPyWeqRfxmIDjEx37w59M5XlNepYBAQrOKawCWc4qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BrXDDi42; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502908; x=1755038908;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8T1B6z+eCzyDzuLrMlaHIwBz/g8ZCRk+IScbBU6+QZY=;
  b=BrXDDi42nE8VxiShbRVbRYjUDVrY1AcOi8GTfPUUxhx0Au7Wxv3balcT
   BvKjgRjfTziWOQ53exDBE7knl4sF8pQ3c2t4cHRtfWv4XfyjNPXaG6cXw
   xE3RjPvuRpHC6EHuudLXzhX5VVzMObIL4OjVVKKoXM/3H4D6A7i0KKemH
   awYmjjYq3dV2/fSIRNsX+5LP3bBmWIoV8vVjvTx2cqyIyvS9cCjSo0b7l
   1fOfhfjRw6XATXbxNsxuNodKMt/UFZpEpeZvsS0OKcpUy9yX/qDFUcknv
   Kp1SCgVbcUjIpFDF6fyKCyYRmHaPOMw0HiWGOcn+cdHhJN0NEPvypA9b9
   Q==;
X-CSE-ConnectionGUID: 0GvfbcJ2SrmIs0l6GjyJeg==
X-CSE-MsgGUID: ZniKbxR9TiaZVwRzTjayiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041319"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041319"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:26 -0700
X-CSE-ConnectionGUID: k/NiZVuQReyVwYw9yDqNWQ==
X-CSE-MsgGUID: usjbcY+AQBmkW1WNhV1qhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008329"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:25 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com
Subject: [PATCH 00/25] TDX vCPU/VM creation
Date: Mon, 12 Aug 2024 15:47:55 -0700
Message-Id: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This series kicks off the actual interaction of KVM with the TDX module.
It focuses on creating a TD VM and vCPUs. The patches are currently not in
an upstreamable state. It needs more discussion on how the KVM API around
these operations should adapt to the TDX module’s model of CPU feature
enabling. I was originally hoping to present to the community some kind of
fully formed solution that could be recommended, but unfortunately we are
not there yet. Meanwhile, Paolo suggested to post what we had, to continue
the discussion externally. So what follows is a history of the discussion
and thinking up until this point. Please feel free to wait for future
revisions to spend time trying to correct smaller code issues. But I would
greatly appreciate discussion on the overall design and how we are weighing
the tradeoffs for the uAPI.

Since v19, it has gone through several internal revisions focusing on TD 
CPU feature configuration. It should incorporate all public feedback that 
still made sense, with the exception of the discussion around 
KVM_CAP_MAX_VCPUS. That update depends on an edk2 fix, and some late doubts
prompted need for further evaluation. Otherwise, several new patches are
added as part of the new API for VM and vCPU creation.

There is a larger team working on TDX KVM base enabling. Most patches were
originally authored by Sean Christopherson and Isaku Yamahata, with recent
work by Xiaoyao Li, Tony Lindgren and myself.

TDX Module
==========
The TDX Module is a software component that runs in a special CPU mode
called SEAM (Secure Arbitration Mode). Loading it is mostly handled
outside of KVM by the core kernel. Once it’s loaded  KVM can interact with
the TDX Module via a new instruction called SEAMCALL to virtualize a TD
guests. This instruction can be used to make various types of seamcalls,
with names organized into a hierarchy. The format is TDH.[AREA].[ACTION],
where “TDH” stands for “Trust Domain Host”, and differentiates from
another set of calls that can be done by the guest “TDG”. The KVM relevant
areas of SEAMCALLs for this series are:
   SYS    – TDX module management, static metadata reading.
   MNG    – TD management. VM scoped things that operate on a TDX module
            controlled structure called the TDCS.
   VP     – vCPU management. vCPU scoped things that operate on TDX module
            controlled structures called the TDVPS.
   PHYMEM - Operations related to physical memory management (page
            reclaiming, cache operations, etc).

The mentioned structures need to be allocated by KVM and provided to the
TDX module for use, per-TD.

Scope of this series
====================
This series encompasses the basic setup for using the TDX module from KVM,
and the creation of TD VMs and vCPUs. To do this, it introduces some TDX
specific KVM APIs. It stops short of fully “finalizing” the creation of a
TD VM. The part of initializing a guest where initial private memory is
loaded is left to a future MMU related series.

Base of this series
===================
The changes required for TDX support are too large to effectively move
upstream as one series. As a result is has been broken into a bunch of
smaller series to be applied sequentially. Based on PUCK discussion we are
going to be pipelining the review of these series, such that series are
posted before their pre-reqs land in a maintainer branch. While the first
breakout series (MMU prep) was able to be applied to kvm-coco-queue directly,
this one is based some pre-req series that have not landed yet:
1. kvm-coco-queue
2. Kai’s host metadata series [0]
2. Sean’s VMX initialization changes [1]
3. KVM/TDX Module init series [2]
4. Seamcall export patch (batched in with TDVMCALL/SEAMCALL overhaul work)

The plan would be for those pre-reqs to land in something like that order.

CPU feature configuration in TDX
================================
For normal VMs, userspace can provide whatever CPUID configuration that
they want to expose to the guest. They can check what vCPU features
supported by KVM via  KVM_GET_SUPPORTED_CPUID. QEMU and KVM can easily have
a consistent view of CPUID leafs. However, CoCo guests (SNP and TDX) have a
few more restrictions and complications.

Both TDX and SNP change configure CPUID bits on a per-VM basis, instead of
per-vCPU. They also have some CPUID leafs reflect an exception to the CoCo
guest, which can then make a hypercall to retrieve register values from the
VMM. So the TDX implementation will naturally be similar to SNP in that
respect.

Where the differences start to crop up is how the CPUID leafs that don’t 
cause guest exceptions are configured to the features. For SNP the 
VM-scoped CPUID bits are provided by userspace to the firmware which 
either rejects them or accepts them. Then KVM’s view of the CPUID bits is 
configured like normal via KVM_SET_CPUID2.

However, TDX ended up with a different design. Instead only a subset of
supported guest CPUID bits can be directly provided to the TDX module.
Such bits are enumerable by the TDX module. The others are assigned to one
of 18 categories and determined based on that and occasionally other
additional logic. For example, features that require special
virtualization support (CET, PKS, etc), they are configured via separate
dedicated fields (XFAM, ATTRIBUTES, etc). When a TD is initialized with
those features it will light up the respective CPUID bits.

The main SEAMCALL for configuring the guest CPU features is TDH.MNG.INIT,
which accepts a bunch of properties including:
   XFAM – Some CPU features associated with xfeatures
   ATTRIBUTES – Other CPU features, and TDX module behaviors
   CPUID_VALUES – The directly configurable CPUID values

A more difficult to fit category of bits is “Fixed”, which are bits that 
are fixed to a certain value (can 0 or 1) for any TD configuration. The 
values of such bits cannot be determined ahead of time, but the result of 
specific CPUID leafs of a created TD can be queried before booting it. So 
the values of these bits can be determined eventually, but don’t fit 
easily into a GET_SUPPORTED_CPUID type model.

Some CPU features are also enumerated via MSR (i.e. 
IA32_ARCH_CAPABILITIES). TDX has some limited support for configuring this 
MSR, however the TDX series has historically not made use of it and used 
the TDX module's default treatment of this MSR (based on the host value). 
More details are in the "IA32_ARCH_CAPABILITIES MSR" section of the 
"Intel® Trust Domain Extensions (Intel® TDX) Module Base Architecture 
Specification" [4]

For specifics on which CPUID bits are in which category, please refer to 
"Intel TDX Module v1.5 ABI Definitions"[5]. The zip file contains a
"cpuid_virtualization.json" with structured data in a JSON format.

It’s worth noting that the TDX module is expected to add new bits into
various categories and also to change the category of existing bits. For
example, turning a previously fixed bit configurable, or adding bits for
future CPU features. The TDX documentation “Intel TDX Module
Incompatibilities between v1.0 and v1.5” attempts to draw some boundaries
around whose fault it should be if changes in the category of these bits
cause a breakage on TDX module upgrade. More recently there has been
discussion on walking back those assertions. The exact plan for how to
evolve the TDX module supported CPU features remains undecided. As for
what that means for KVM, more on that later.

History of KVM TDX CPU feature configuration
============================================
This has been a problematic area, and has gone through several iterations.
Before we get into the current design and problems, it is probably worth
summarizing how we got here:

Pre-v19
-------
For earlier versions, a KVM_TDX_INIT_VM ioctl took an array of CPUID leafs.
It passed the subset of leafs that were directly configurable to the
TDH.MNG.INIT, and tried to deduce what XFAM and ATTRIBUTES bits to set
from the passed CPUID leafs. The passed CPUID leafs that the TDX Module
doesn’t define as directly configurable were accepted as input to the
kernel and just ignored. Then later it was userspace’s job to set
KVM_SET_CPUID correctly.

This approach had a few problems. One was that there was no way for
userspace or KVM to find out about the “Fixed” bit values. It also put KVM
in the job of tweaking the CPUID configuration to fit the TDX module. For
example, in the case of CET it tried to decide whether to set the CET USER
and CET SUPERVISOR XFAM bits based on the presence of SHSTK and IBT CPUID
bits. But the presence of one but not the other was essentially not
possible to configure for a TD. The code chose to set extra bits in the TD
(configure CET if any related CPUID bit was found). To handle it more
correctly within the same general flow, it would have had to reject
unsupported CPUID combinations. That would putting KVM in the job of
deciding what CPUID combinations were valid.

Another problem was that since KVM_TDX_INIT_VM masked off any bits that
weren’t directly configurable, it meant userspace could happily pass in
garbage input now that would later actually grow behavior. Either the TDX
module could update to make bits unknown to KVM directly configurable, or
future KVM could want to take other actions of those bits.

V19
----
After discussion on a non-TDX thread[3], some comments from Sean prompted
an attempt to enforce unification between the bits passed into
KVM_TDX_INIT_VM ioctl that feeds TDH.MNG.INIT and the ones passed later
into KVM_SET_CPUID2. Sean's comment:
  It's been a long while since I looked at TDX's CPUID management, but IIRC
  ignoring SET_CPUID2 is not an option because the TDH.MNG.INIT only allows
  leafs that are known to the TDX Module, e.g. KVM's paravirt CPUID leafs
  can't be communicated via TDH.MNG.INIT.  KVM's uAPI for initiating
  TDH.MNG.INIT could obviously filter out unsupported leafs, but doing so
  would lead to potential ABI breaks, e.g. if a leaf that KVM filters out
  becomes known to the TDX Module, then upgrading the TDX Module could
  result in previously allowed input becoming invalid.

  Even if that weren't the case, ignoring KVM_SET_CPUID{2} would be a bad
  option because it doesn't allow KVM to open behavior in the future, i.e.
  ignoring the leaf would effectively make _everything_ valid input. If KVM
  were to rely solely on TDH.MNG.INIT, then KVM would want to completely
  disallow KVM_SET_CPUID{2}.

  Back to Zhi's question, the best thing to do for TDX and SNP is likely to
  require that overlap between KVM_SET_CPUID{2} and the "trusted" CPUID be
  consistent.  The key difference is that KVM would be enforcing
  consistency, not sanity.  I.e. KVM isn't making arbitrary decisions on
  what is/isn't sane, KVM is simply requiring that userspace provide a
  CPUID  model that's consistent with what userspace provided earlier.

So how v19 worked was to keep the leafs values passed into KVM_TDX_INIT_VM,
and verify any overlap with leafs later passed into KVM_SET_CPUID matches.

The problems with this approach were that it didn’t fix all of the
problems in the pre-v19 solution. The original suggestion seemed to be
based on the expectation that most CPUID bits were directly configurable,
and only a few such at the PV leaf bits were needed to be additionally
passed to KVM_SET_CPUID. So there wasn't assurance on consistency for a lot
of the leafs between the TDX module and userspace/KVM.

Internal POC 1
--------------
After some discussion[6] delved into the complexities of the TDX CPUID
configuration including fixed bits and the way those values can be queried
from the TDX module, we decided to try to address the issues with the v19
solution.

The goals were to:
 1. Have KVM, QEMU and the TDX Module have a consistent view of the CPUID
    of the TD
 2. Prevent TDX Module updates from enabling features ahead of KVM support.
    This is to prevent KVM from getting boxed into some behavior before it
    had a chance to decide on what the behavior of a new bit should be.

When you consider the “fixed” bits, it is not completely possible to meet
both of these. More on this later, but KVM can still prevent getting boxed
into some behavior by hiding from userspace that a feature has been turned
on in the TD. In doing so, it erodes goal 1 though.

So the flow we tried was was:
1. KVM_TDX_CAPABILITIES - Userspace retrieves directly configurable bits
                          that are also known to KVM (via
                          KVM_GET_SUPPORTED_CPUID internal data). Also
                          retrieves supported XFAM and ATTRIBUTES. So the
                          way the TDX module configures guest CPU features
                          is basically exposed to userspace.
2. KVM_TDX_INIT_VM - Takes directly configurable CPUID bits, XFAM and
                     ATTRIBUTES, rejects CPUID bits not supported by KVM.
3. KVM_TDX_INIT_VCPU - Take a list of CPUID bits to query from the TDX
                       module for the vCPU. Return these bits to userspace
                       and set KVM’s copy in vcpu->arch.cpuid_entries.

KVM_SET_CPUID was blocked for TD VMs.

The problem with this approach is that there is no way to configure CPUID
bits that are to be handled by hypercall (i.e. KVM para bits). Adding them
into the bits accepted by KVM_TDX_INIT_VM, and then stashing those bits to
be reconciled with the valued fetched by KVM_TDX_INIT_VCPU worked. However,
it was overly complex on KVM side. It had to marshal and filter specific
bits across the calls.

This series (Internal POC 2)
----------------------------
The most recent POC, presented in these patches, changed KVM_TDX_INIT_VCPU
to not fetch CPUID bits from the TD, and instead added a KVM_TDX_GET_CPUID,
which userspace could use to fetch the the TD’s CPUIDs. Then instead of the
kernel, userspace is responsible for adding in any CPUID leafs meant to be
handled via hypercall and setting them on each vCPU via KVM_SET_CPUID. The
directly configurable bits returned by KVM_TDX_CAPABILITIES, and the CPUID
bit values returned by KVM_TDX_GET_CPUID are filtered by KVMs supported
CPUID leafs.

The problem with this solution is that using, effectively
KVM_GET_SUPPORTED_CPUID internally, is not an effective way to filter the
CPUID bits. In practice, the spots where TDX support does the filtering
needed some adjustments. See the log of “Add CPUID bits missing from
KVM_GET_SUPPORTED_CPUID” for more information.

Next steps
----------
We were discussing a couple of directions for the future:
1. Whether we really need to filter TDX CPUID bits by KVM supported CPUID
   bits? Is the cost worth the protection.
2. Whether we should punt the whole problem to userspace by having:
	1. KVM_TDX_INIT_VM behave like it currently does and take directly
	   configurable bits.
	2. Have KVM_TDX_INIT_VCPU take a full list of CPUID bits to have
	   set in vcpu->arch.cpuid_entries. Have it read the TDs version of
	   each CPUID leaf passed and reject the call if it misses.

This would require maintaining a list of leafs in KVM that are allowed to
be different (KVM PV leaf, etc). It also doesn’t give userspace the option
to run unless they can deduce the CPUID bit end state in the TD, where as
the current solution could allow userspace to ignore differences and
proceed. So QEMU would have to have an evolving knowledge of the TDX
Module’s treatment of CPUID bits. It makes KVM’s role in the stack simple
though. It also wouldn't necessarily catch any new fixed 1 bits on unknown
leafs.

One nice thing would be that this would be more consistent with how SNP
does things (provide bits, and get rejected or not). But TDX could
potentially have something that is a bit more flexible and allows for
userspace to adapt to bits that are not what it originally requested. It
would not be super aligned with the QEMU way of doing things, but
hypothetically a userspace VMM might be able to take advantage of more
flexibility.

TDX Module and KVM backwards compatibility
------------------------------------------
This has all got us wondering about requiring some guarantees about on how
the configurability of these bits might change in the future. In the
“Intel TDX Module Incompatibilities between v1.0 and v1.5”, there were
some attempts to plan for currently “fixed” bits to turn configurable:
  The host VMM should always consult the list of directly configurable
  CPUID leaves and sub-leaves, as enumerated by TDH.SYS.RD/RDALL or
  TDH.SYS.INFO.

  If a CPUID bit is enumerated as configurable, and the VMM was not
  designed to configure that bit, the VMM should set the configuration for
  that bit to 1. If the host VMM neglects to configure CPUID bits that are
  configurable, their virtual value (as seen by guest TDs) will be 0.

For fixed1 bits that turn configurable, it could maintain the same CPUID
state with the previous TDX module, but it would also mean any new,
previously undefined feature would get turned on by default.

All in all, we have been discussing that we probably want to have some
guarantees like:
 - No previously fixed1 bits turning configurable without another opt-in.
   (i.e. no need for rules like the above quote).
 - No new default on or fixed 1 bits. This may be ok, if QEMU/userspace is
   ok getting bits hidden from it. If we don’t filter reporting bits by
   what KVM supports, then this would allow for features to get turned on
   without KVM’s knowledge. It would simplify things if we just didn’t have
   this come up.
  
Repos
=====
The KVM tree this is extracted from is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-08-12

And a matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-wip-2024-08-12.2

Testing
=======
As mentioned earlier, this series is not ready for upstream. All the same,
it has been tested as part of a development branch for the TDX base series.
The testing consisted of TDX kvm-unit-tests and booting a Linux TD, and
TDX enhanced KVM selftests.

[0] https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/
[1] https://lore.kernel.org/kvm/20240608000639.3295768-1-seanjc@google.com/#t
[2] https://github.com/intel/tdx/commits/kvm-tdxinit/
[3] https://cdrdv2.intel.com/v1/dl/getContent/795381
[4] https://cdrdv2.intel.com/v1/dl/getContent/733575
[5] https://lore.kernel.org/lkml/ZDbMuZKhAUbrkrc7@google.com/
[6] https://lore.kernel.org/kvm/20240415210421.GR3039520@ls.amr.corp.intel.com/


Isaku Yamahata (14):
  KVM: TDX: Add placeholders for TDX VM/vCPU structures
  KVM: TDX: Define TDX architectural definitions
  KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
  KVM: TDX: Add helper functions to print TDX SEAMCALL error
  KVM: TDX: Add helper functions to allocate/free TDX private host key
    id
  KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
  KVM: TDX: Get system-wide info about TDX module on initialization
  KVM: TDX: Allow userspace to configure maximum vCPUs for TDX guests
  KVM: TDX: create/destroy VM structure
  KVM: TDX: initialize VM with TDX specific parameters
  KVM: TDX: Make pmu_intel.c ignore guest TD case
  KVM: TDX: Don't offline the last cpu of one package when there's TDX
    guest
  KVM: TDX: create/free TDX vcpu structure
  KVM: TDX: Do TDX specific vcpu initialization

Kai Huang (1):
  x86/virt/tdx: Export TDX KeyID information

Rick Edgecombe (3):
  KVM: X86: Introduce tdx_get_kvm_supported_cpuid()
  KVM: x86: Filter directly configurable TDX CPUID bits
  KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID

Sean Christopherson (1):
  KVM: TDX: Add TDX "architectural" error codes

Xiaoyao Li (6):
  KVM: TDX: Initialize KVM supported capabilities when module setup
  KVM: TDX: Report kvm_tdx_caps in KVM_TDX_CAPABILITIES
  KVM: X86: Introduce kvm_get_supported_cpuid_internal()
  KVM: x86: Introduce KVM_TDX_GET_CPUID
  KVM: TDX: Use guest physical address to configure EPT level and GPAW
  KVM: x86/mmu: Taking guest pa into consideration when calculate tdp
    level

 arch/x86/include/asm/kvm-x86-ops.h |    5 +-
 arch/x86/include/asm/kvm_host.h    |    3 +
 arch/x86/include/asm/shared/tdx.h  |    6 +
 arch/x86/include/asm/tdx.h         |    4 +
 arch/x86/include/uapi/asm/kvm.h    |   70 ++
 arch/x86/kvm/Kconfig               |    2 +
 arch/x86/kvm/cpuid.c               |   46 +
 arch/x86/kvm/cpuid.h               |    5 +
 arch/x86/kvm/mmu/mmu.c             |   10 +-
 arch/x86/kvm/vmx/main.c            |  153 ++-
 arch/x86/kvm/vmx/pmu_intel.c       |   45 +-
 arch/x86/kvm/vmx/pmu_intel.h       |   28 +
 arch/x86/kvm/vmx/tdx.c             | 1446 +++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h             |   88 ++
 arch/x86/kvm/vmx/tdx_arch.h        |  165 ++++
 arch/x86/kvm/vmx/tdx_errno.h       |   37 +
 arch/x86/kvm/vmx/tdx_ops.h         |  414 ++++++++
 arch/x86/kvm/vmx/vmx.h             |   34 +-
 arch/x86/kvm/vmx/x86_ops.h         |   31 +
 arch/x86/kvm/x86.c                 |   17 +-
 arch/x86/virt/vmx/tdx/tdx.c        |   11 +-
 21 files changed, 2566 insertions(+), 54 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h

-- 
2.34.1


