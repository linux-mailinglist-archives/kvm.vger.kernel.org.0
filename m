Return-Path: <kvm+bounces-25808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF0296AEF3
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A3551C23245
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094DA50276;
	Wed,  4 Sep 2024 03:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DT4Ki+II"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5813B4776E;
	Wed,  4 Sep 2024 03:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419672; cv=none; b=ZLUC7/GFuaE9Ak3aUVnTtrbrHSuJLUKy7XDAJQUoYN28JgZ38arYKkF+xFOotdNCJEVEDlWGt0HQGPnEKLDEMstoMug301cFqEFqsWfFKu4lXf4Dg0JCiDsVcQtq9Xk7Sfn+pFlCB4m3DIalhY4RPOXoWv/TqASwzM/rDOjese4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419672; c=relaxed/simple;
	bh=IBcZTEmaFEM5XqtP6UZtRzuXCni/YAvBzMLp3a5Z55Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=DgfgKl4NJtdO2HXzcadja9qjdnvF0BD1G+BQv1I1tRUbbOGrz9NoyOuYo9fEq3NLXqOw5DEjrGdhW4Dfy/ZghEERMS+mobyCWWie8AoaiJWQeJjJcpFVLCE1BegH/jTouux17a2pAGmf7aD29YuPjQ1/uKc+JgtHIt25/O6vwKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DT4Ki+II; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419669; x=1756955669;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IBcZTEmaFEM5XqtP6UZtRzuXCni/YAvBzMLp3a5Z55Y=;
  b=DT4Ki+IINQtwK/2Ykgtg/PnHo4ynUZyWEE3r8ca5nsmv3KBho6GCaqlr
   SrygN9EEpAwv4M2tBPaHw4RVGECRTtK4vU9Z9s4qwHO3taDRJ1zoulLp3
   u9R8e002Bc7AO2+f7y2fSqVA3C8Sw0L84BghZN9DX7cgoKt+biulTYP5k
   +DhXBK/9ix0SvMAjdDs+/YDyXjGdIPn4NGqlJ8SoIB+R7q8aiT1JjSR35
   ZYqb5uhs5QneYeOyHu1dmATI04EhC69Bgz2IsNI8klRoMhK9CK72YnxEI
   7MRPSjPfW3MA3vjjexiQzXK9IiE3h3i0MUGMsY3LIxVw6JllMVD0nl3Uz
   Q==;
X-CSE-ConnectionGUID: wqaKO730QJmXF/UgEd4dFA==
X-CSE-MsgGUID: 0wyFmddxSfWLPAih9RCn5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564618"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564618"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:07:58 -0700
X-CSE-ConnectionGUID: aNxLL5J8RxuAHq3mR2qFIA==
X-CSE-MsgGUID: gRDLCSrJTeGJUTQLDF8nQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106198"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:07:57 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/21] TDX MMU Part 2
Date: Tue,  3 Sep 2024 20:07:30 -0700
Message-Id: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
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

This series picks up where “TDX MMU prep series part 1”[0] left off in 
implementing the parts of TDX support that deal with shared and private 
memory. Part 1 focused on changes to the generic x86 parts of the KVM MMU 
code that will be needed by TDX. This series focuses on the parts of the 
TDX support that will live in the Intel side of KVM. These parts include 
actually manipulating the S-EPT (private memory), and other special 
handling around the Shared EPT. 

There is a larger team working on TDX KVM base enabling. The patches were  
originally authored by Sean Christopherson and Isaku Yamahata, but 
otherwise it especially represents the work of Yan Y Zhao, Isaku and 
myself. 

I think the series is in ok shape at this point, but not quite ready to 
move upstream. However, when it seems to be in generally good shape, we 
might think about whether TDX MMU part 1 is ready for promotion.

Base of this series
===================
The changes required for TDX support are too large to effectively move 
upstream as one series. As a result, it has been broken into a bunch of 
smaller series to be applied sequentially. Based on PUCK discussion we are 
going to be pipelining the review of these series, such that series are 
posted before their pre-reqs land in a maintainer branch. While the first 
breakout series (MMU prep) was able to be applied to kvm-coco-queue 
directly, this one is based some pre-req series that have not landed 
upstream. The order of pre-reqs is:

1. Commit 909f9d422f59 in kvm-coco-queue
   This commit includes "TDX MMU Prep" series, but not "TDX vCPU/VM 
   creation". The following pre-reqs depend on Sean’s VMX initialization 
   changes[1], which is currently in kvm/queue.
2. Kai’s host metadata series v3 [2]
3. KVM/TDX Module init series [3]
4. Binbin's "Check hypercall's exit to userspace generically" [4]
5. vCPU/VM creation series [5]

This is quite a few pre-reqs at this point. 1-4 are fairly mature so 
hopefully those will fall off soon.

Per offline discussion with Dave Hansen, the current plan is for the 
seamcall export patch to be expanded into a series that implements and 
exports each seamcall needed by KVM in arch/x86 code. Both this series and 
(5) rely on the export of the raw seamcall procedure. So future revisions 
of those two series will include patches to add the needed seamcall 
implementations into arch/x86 code. The current thought is to send them 
through the KVM tree with their respective breakout series, and with ack's 
from x86 maintainers.

Private/shared memory in TDX background 
======================================= 
Confidential computing solutions have concepts of private and shared 
memory. Often the guest accesses either private or shared memory via a bit 
in the guest PTE. Solutions like SEV treat this bit more like a permission 
bit, where solutions like TDX and ARM CCA treat it more like a GPA bit. In 
the latter case, the host maps private memory in one half of the address 
space and shared in another. For TDX these two halves are mapped by 
different EPT roots. The private half (also called Secure EPT in Intel 
documentation) gets managed by the privileged TDX Module. The shared half 
is managed by the untrusted part of the VMM (KVM).

In addition to the separate roots for private and shared, there are 
limitations on what operations can be done on the private side. Like SNP, 
TDX wants to protect against protected memory being reset or otherwise 
scrambled by the host. In order to prevent this, the guest has to take 
specific action to “accept” memory after changes are made by the VMM to 
the private EPT. This prevents the VMM from performing many of the usual 
memory management operations that involve zapping and refaulting memory. 
The private memory also is always RWX and cannot have VMM specified cache 
attribute attributes applied.

TDX memory implementation
=========================
The following describes how TDX memory management is implemented in KVM.

Creating shared EPT 
-------------------- 
Shared EPT handling is relatively simple compared to private memory. It is 
managed from within KVM. The main differences between shared EPT and EPT 
in a normal VM are that the root is set with a TDVMCS field (via 
SEAMCALL), and that a GFN from a memslot perspective needs to be mapped at 
an offset in the EPT. For the former, this series plumbs in the 
load_mmu_pgd() operation to the correct field for the shared EPT. For the 
latter, previous patches have laid the groundwork for roots managed by EPT 
(called direct roots), to be mapped at an offset based on the VM scoped 
gfn_direct_bits field. So this series sets gfn_direct_bits to the proper 
value.

Creating private EPT 
------------------------- 
In previous patches, the concept of “mirrored roots” were introduced. Such 
roots maintain a KVM side “mirror” of the “external” EPT by keeping an 
unmapped EPT tree within the KVM MMU code. When changing these mirror 
EPTs, the KVM MMU code calls out via x86_ops to update the external EPT. 
This series adds implementations for these “external” ops for TDX to 
create and manage “private” memory via TDX module APIs.

Managing S-EPT with the TDX Module 
------------------------------------------------- 
The TDX module allows the TD’s private memory to be managed via SEAMCALLs. 
This management consists of operating on two internal elements:

1. The private EPT, which the TDX module calls the S-EPT. It maps the 
   actual mapped, private half of the GPA space using an EPT tree.

2. The HKID, which represents private encryption keys used for encrypting 
   TD memory. The CPU doesn’t guarantee cache coherency between these
   encryption keys, so memory that is encrypted with one of these keys
   needs to be reclaimed for use on the host in special ways.

This series will primarily focus on the SEAMCALLs for managing the private 
EPT. Consideration of the HKID is needed for when the TD is torn down.

Populating TDX Private memory 
----------------------------- 
TDX allows the EPT mapping the TD’s private memory to be modified in 
limited ways. There are SEAMCALLs for building and tearing down the EPT 
tree, as well as mapping pages into the private EPT.

As for building and tearing down the EPT page tables, it is relatively 
simple. There are SEAMCALLs for installing and removing them. However, the 
current implementation only supports adding private EPT page tables, and 
leaves them installed for the lifetime of the TD. For teardown, the 
details are discussed in a later section.

As for populating and zapping private SPTE, there are SEAMCALLs for this 
as well. The zapping case will be described in detail later. As for the 
populating case, there are two categories: before TD is finalized and 
after TD is finalized. Both of these scenarios go through the TDP MMU map 
path. The changes done previously to introduce “mirror” and “external” 
page tables handle directing SPTE installation operations through the 
set_external_spte() op.

In the “after” case, the TDX set_external_spte() handler simply calls a 
SEAMCALL (TDX.MEM.PAGE.AUG).

For the before case, it is a bit more complicated as it requires both 
setting the private SPTE *and* copying in the initial contents of the page 
at the same time. For TDX this is done via the KVM_TDX_INIT_MEM_REGION 
ioctl, which is effectively the kvm_gmem_populate() operation.

For SNP, the private memory can be pre-populated first, and faulted in 
later like normal. But for TDX these need to both happen both at the same 
time and the setting of the private SPTE needs to happen in a different 
way than the “after” case described above. It needs to use the 
TDH.MEM.SEPT.ADD SEAMCALL which does both the copying in of the data and 
setting the SPTE.

Without extensive modification to the fault path, it’s not possible 
utilize this callback from the set_external_spte() handler because it the 
source page for the data to be copied in is not known deep down in this 
callchain. So instead the post-populate callback does a three step 
process.

1. Pre-fault the memory into the mirror EPT, but have the 
   set_external_spte() not make any SEAMCALLs.

2. Check that the page is still faulted into the mirror EPT under read
   mmu_lock that is held over this and the following step.

3. Call TDH.MEM.SEPT.ADD with the HPA of the page to copy data from, and 
   the private page installed in the mirror EPT to use for the private 
   mapping.

The scheme involves some assumptions about the operations that might 
operate on the mirrored EPT before the VM is finalized. It assumes that no 
other memory will be faulted into the mirror EPT, that is not also added 
via TDH.MEM.SEPT.ADD). If this is violated the KVM MMU may not see private 
memory faulted in there later and so not make the proper external spte 
callbacks. There is also a problem for SNP, and there was discussion for 
enforcing this in a more general way. In this series a counter is used, to 
enforce that the number of pre-faulted pages is the same as the number of 
pages added via KVM_TDX_INIT_MEM_REGION. It is probably worth discussing 
if this serves any additional error handling benefits.

TDX TLB flushing 
----------------
For TDX, TLB flushing needs to happen in different ways depending on 
whether private and/or shared EPT needs to be flushed. Shared EPT can be 
flushed like normal EPT with INVEPT. To avoid reading TD's EPTP out from 
TDX module, this series flushes shared EPT with type 2 INVEPT. Private TLB 
entries can be flushed this way too (via type 2). However, since the TDX 
module needs to enforce some guarantees around which private memory is 
mapped in the TD, it requires these operations to be done in special ways 
for private memory.

For flushing private memory, three methods will be used. First it can be 
flushed directly via a SEAMCALL TDH.VP.FLUSH. This flush is of the INVEPT 
type 1 variety (i.e. mappings associated with the TD). 

The second method is part of a sequence of SEAMCALLs for removing a guest 
page. The sequence looks like:

1. TDH.MEM.RANGE.BLOCK - Remove RWX bits from entry (similar to KVM’s zap). 

2. TDH.MEM.TRACK - Increment the TD TLB epoch, which is a per-TD counter 

3. Kick off all vCPUs - In order to force them to have to re-enter.

4. TDH.MEM.PAGE.REMOVE - Actually remove the page and make it available for
   other use.

5. TDH.VP.ENTER - On re-entering TDX module will see the epoch is
   incremented and flush the TLB.

The third method, is that during TDX module init, the TDH.SYS.LP.INIT is 
used to online a CPU for TDX usage. It invokes a INVEPT type 2 to flush 
all mappings in the TLB.

TDX TLB flushing in KVM 
----------------------- 
During runtime, for normal (TDP MMU, non-nested) guests, KVM will do a TLB 
flushes in 4 scenarios:

(1) kvm_mmu_load()

    After EPT is loaded, call kvm_x86_flush_tlb_current() to invalidate
    TLBs for current vCPU loaded EPT on current pCPU.

(2) Loading vCPU to a new pCPU

    Send request KVM_REQ_TLB_FLUSH to current vCPU, the request handler 
    will call kvm_x86_flush_tlb_all() to flush all EPTs assocated with the 
    new pCPU.

(3) When EPT mapping has changed (after removing or permission reduction) 
    (e.g. in kvm_flush_remote_tlbs())

    Send request KVM_REQ_TLB_FLUSH to all vCPUs by kicking all them off, 
    the request handler on each vCPU will call kvm_x86_flush_tlb_all() to 
    invalidate TLBs for all EPTs associated with the pCPU. 

(4) When EPT changes only affects current vCPU, e.g. virtual apic mode 
    changed.

    Send request KVM_REQ_TLB_FLUSH_CURRENT, the request handler will call 
    kvm_x86_flush_tlb_current() to invalidate TLBs for current vCPU loaded 
    EPT on current pCPU.

Only the first 3 are relevant to TDX. They are implemented as follows. 

(1) kvm_mmu_load() 

    Only the shared EPT root is loaded in this path. The TDX module does 
    not require any assurances about the operation, so the 
    flush_tlb_current()->ept_sync_global() can be called as normal. 

(2) vCPU load 

    When a vCPU migrates to a new logical processor, it has to be flushed 
    on the old pCPU. This is different than normal VMs, where the INVEPT 
    is executed on the new pCPU. The TDX behavior comes from a requirement 
    that a vCPU can only be associated with one pCPU at at time. This 
    flush happens via the TDH.VP.FLUSH SEAMCALL. It happens in the 
    vcpu_load op callback on the old CPU via IPI.

(3) Removing a private SPTE 

    This is the more complicated flow. It is done in a simple way for now 
    and is especially inefficient during VM teardown. The plan is to get a 
    basic functional version working and optimize some of these flows 
    later.

    When a private page mapping is removed, the core MMU code calls the 
    newly remove_external_spte() op, and flushes the TLB on all vCPUs. But 
    TDX can’t rely on doing that for private memory, so it has it’s own 
    process for making sure the private page is removed. This flow 
    (TDH.MEM.RANGE.BLOCK, TDH.MEM.TRACK, TDH.MEM.PAGE.REMOVE) is done 
    withing the remove_external_spte() implementation as described in the 
    “TDX TLB flushing” section above.

    After that, back in the core MMU code, KVM will call 
    kvm_flush_remote_tlbs*() resulting in an INVEPT. Despite that, when 
    the vCPUs re-enter (TDH.VP.ENTER) the TD, the TDX module will do 
    another INVEPT for its own reassurance.

Private memory teardown 
----------------------- 
Tearing down private memory involves reclaiming three types of resources 
from the TDX module: 

 1. TD’s HKID 

    To reclaim the TD’s HKID, no mappings may be mapped with it. 

 2. Private guest pages (mapped with HKID) 
 3. Private page tables that map private pages (mapped with HKID) 

    From the TDX module’s perspective, to reclaim guest private pages they 
    need to be prevented from be accessed via the HKID (unmapped and TLB 
    flushed), their HKID associated cachelines need to be flushed, and 
    they need to be marked as no longer use by the TD in the TDX modules 
    internal tracking (PAMT) 

During runtime private PTEs can be zapped as part of memslot deletion or 
when memory coverts from shared to private, but private page tables and 
HKIDs are not torn down until the TD is being destructed. The means the 
operation to zap private guest mapped pages needs to do the required cache 
writeback under the assumption that other vCPU’s may be active, but the
PTs do not.

TD teardown resource reclamation
--------------------------------
The code that does the TD teardown is organized such that when an HKID is 
reclaimed:
1. vCPUs will no longer enter the TD
2. The TLB is flushed on all CPUs
3. The HKID associated cachelines have been flushed.

So at that point most of the steps needed to reclaim TD private pages and 
page tables have already been done and the reclaim operation only needs to 
update the TDX module’s tracking of page ownership. For simplicity each 
operation only supports one scenario: before or after HKID reclaim. Since 
zapping and reclaiming private pages has to function during runtime for 
memslot deletion and converting from shared to private, the TD teardown is 
arranged so this happens before HKID reclaim. Since private page tables 
are never torn down during TD runtime, they can happen in a simpler and 
more efficient way after HKID reclaim. The private page reclaim is 
initiated from the kvm fd release. The callchain looks like this:

do_exit 
  |->exit_mm --> tdx_mmu_release_hkid() was called here previously in v19 
  |->exit_files
      |->1.release vcpu fd
      |->2.kvm_gmem_release
      |     |->kvm_gmem_invalidate_begin --> unmap all leaf entries, causing 
      |                                      zapping of private guest pages
      |->3.release kvmfd
            |->kvm_destroy_vm
                |->kvm_arch_destroy_vm
                    |->kvm_unload_vcpu_mmus
                    |  kvm_x86_call(vm_destroy)(kvm) -->tdx_mmu_release_hkid()
                    |  kvm_destroy_vcpus(kvm)
                    |   |->kvm_arch_vcpu_destroy
                    |   |->kvm_x86_call(vcpu_free)(vcpu)
                    |   |  kvm_mmu_destroy(vcpu) -->unref mirror root
                    |  kvm_mmu_uninit_vm(kvm) --> mirror root ref is 1 here, 
                    |                             zap private page tables
                    | static_call_cond(kvm_x86_vm_free)(kvm);

Notable changes since v19
=========================
As usual there are a smattering of small changes across the patches. A few 
more structural changes are highlighted below.

Removal of TDX flush_remote_tlbs() and flush_remote_tlbs_range() hooks
----------------------------------------------------------------------
Since only the remove_external_spte() callback needs to flush remote TLBs 
for private memory, it is ok to let these have the default behavior of 
flushing with a plain INVEPT. This change also resulted in all callers 
doing the TDH.MEM.TRACK flow being inside an MMU write lock, leading to 
the next removal.

Removal of tdh_mem_track counter
--------------------------------
One change of note to this area since the v19 series is how 
synchronization works between the incrementing of the TD epoch, and the 
kicking of all the vCPUs. Previously a counter was used to synchronize 
these. The raw counter instead of more common synchronization primitives 
made it a bit hard to follow, and a new lock was considered. After the 
separation of private and shared flushing, it was realized all the callers 
of tdx_track() held an MMU write lock. So this revision relies on that for 
this synchronization.

Change of pre-populate flow
---------------------------
Previously the part of the pre-populate flow required userspace to 
pre-fault the private pages into the mirror EPT explicitly with a call to 
KVM_PRE_FAULT_MEMORY before KVM_TDX_INIT_MEM_REGION. After discussion [6], 
it was changed to the current design.

Moving of tdx_mmu_release_hkid()
--------------------------------
Yan pointed out [7] some oddities related to private memory being 
reclaimed from an MMU notified callback. This was weird on the face of it, 
and it turned out Sean had already NAKed the approach. In fixing this, 
HKID reclaim was moved to after calls that could zapping/reclaim private 
pages. The fix however meant that the zap/reclaim of the private pages is 
slower. Previously, Kai had suggested [8] to start with something simpler 
and optimize it later (which is aligned with what we are trying to do in 
general for TDX support). So several insights were all leading us in this 
direction. After the move about ~80 lines of architecturally thorny logic 
that branched off of whether the HKID was assigned was able to be dropped.

Split "KVM: TDX: TDP MMU TDX support"
-------------------------------------
This patch was a big monolith that did a bunch of changes at once. It was
split apart for easier reviewing.

Repos
=====
The series is extracted from this KVM tree:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-09-03

The KVM tree has some workaround patches removed to resemble more closely 
what will eventually make it upstream. It requires:

    EDK2: 9389b9a208 ("MdePkg/Tdx.h: Fix the order of NumVcpus and MaxVcpus") 

    TDX Module: 1.5.06.00.744

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-wip-2024-08-27
 
Testing 
======= 
As mentioned earlier, this series is not ready for upstream. All the same, 
it has been tested as part of the development branch for the TDX base
series. The testing consisted of TDX kvm-unit-tests and booting a Linux
TD, and TDX enhanced KVM selftests.

There is a recently discovered bug in the TDX MMU part 1 patches. We will 
be posting a fix soon. This fix would allow allow for a small amount of 
code to be removed from this series, but otherwise wouldn't interfere.

[0] https://lore.kernel.org/kvm/20240718211230.1492011-1-rick.p.edgecombe@intel.com/ 
[1] https://lore.kernel.org/kvm/20240608000639.3295768-1-seanjc@google.com/#t  
[2] https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/  
[3] https://github.com/intel/tdx/commits/kvm-tdxinit/  
[4] https://lore.kernel.org/kvm/20240826022255.361406-1-binbin.wu@linux.intel.com/
[5] https://lore.kernel.org/kvm/20240812224820.34826-1-rick.p.edgecombe@intel.com/  
[6] https://lore.kernel.org/kvm/73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com/ 
[7] https://lore.kernel.org/kvm/ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com/ 
[8] https://lore.kernel.org/lkml/65a1a35e0a3b9a6f0a123e50ec9ddb755f70da52.camel@intel.com/ 

Isaku Yamahata (14):
  KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
  KVM: TDX: Add accessors VMX VMCS helpers
  KVM: TDX: Set gfn_direct_bits to shared bit
  KVM: TDX: Require TDP MMU and mmio caching for TDX
  KVM: x86/mmu: Add setter for shadow_mmio_value
  KVM: TDX: Set per-VM shadow_mmio_value to 0
  KVM: TDX: Handle TLB tracking for TDX
  KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page
    table
  KVM: TDX: Implement hook to get max mapping level of private pages
  KVM: TDX: Premap initial guest memory
  KVM: TDX: MTRR: implement get_mt_mask() for TDX
  KVM: TDX: Add an ioctl to create initial guest memory
  KVM: TDX: Finalize VM initialization
  KVM: TDX: Handle vCPU dissociation

Rick Edgecombe (3):
  KVM: x86/mmu: Implement memslot deletion for TDX
  KVM: VMX: Teach EPT violation helper about private mem
  KVM: x86/mmu: Export kvm_tdp_map_page()

Sean Christopherson (2):
  KVM: VMX: Split out guts of EPT violation to common/exposed function
  KVM: TDX: Add load_mmu_pgd method for TDX

Yan Zhao (1):
  KVM: x86/mmu: Do not enable page track for TD guest

Yuan Yao (1):
  KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT

 arch/x86/include/asm/vmx.h      |   1 +
 arch/x86/include/uapi/asm/kvm.h |  10 +
 arch/x86/kvm/mmu.h              |   4 +
 arch/x86/kvm/mmu/mmu.c          |   7 +-
 arch/x86/kvm/mmu/page_track.c   |   3 +
 arch/x86/kvm/mmu/spte.c         |   8 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  37 +-
 arch/x86/kvm/vmx/common.h       |  47 +++
 arch/x86/kvm/vmx/main.c         | 122 +++++-
 arch/x86/kvm/vmx/tdx.c          | 674 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h          |  91 ++++-
 arch/x86/kvm/vmx/tdx_arch.h     |  23 ++
 arch/x86/kvm/vmx/tdx_ops.h      |  54 ++-
 arch/x86/kvm/vmx/vmx.c          |  25 +-
 arch/x86/kvm/vmx/x86_ops.h      |  51 +++
 virt/kvm/kvm_main.c             |   1 +
 16 files changed, 1097 insertions(+), 61 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/common.h

-- 
2.34.1


