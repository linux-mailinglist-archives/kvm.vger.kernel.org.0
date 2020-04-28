Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0454A1BC43E
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgD1P6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:58:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35821 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727775AbgD1P6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:58:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588089486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=3m7LUXxQd4giAB0Ojpdf+J1Nb1SjvOA/Jj3s+EytLDg=;
        b=eBsCEq8JpFWnVmdsiRtie/KYXR+epdLyxNViZET1cy9BcHx6nzzoZkBpkzkNdhYw1qpoJD
        4n5gpDLkThW7n3RWb+lNA2eqMdwuDnp8fOu8wJNl8UYb1o+S/f9YFaYmq04FD0a5+UqVU+
        SDoVNc9g3XT1BweNwHjZzey1d+dWbvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-4-lBzhpwMRmPnKmxoMCAPA-1; Tue, 28 Apr 2020 11:58:04 -0400
X-MC-Unique: 4-lBzhpwMRmPnKmxoMCAPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E050D835B44;
        Tue, 28 Apr 2020 15:58:02 +0000 (UTC)
Received: from [10.36.113.167] (ovpn-113-167.ams2.redhat.com [10.36.113.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAB1C605DC;
        Tue, 28 Apr 2020 15:58:00 +0000 (UTC)
Subject: Re: [PATCH 4/4] KVM: PPC: Book3S HV: Flush guest mappings when
 turning dirty tracking on/off
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20181212041430.GA22265@blackberry>
 <20181212041717.GE22265@blackberry>
From:   Laurent Vivier <lvivier@redhat.com>
Autocrypt: addr=lvivier@redhat.com; prefer-encrypt=mutual; keydata=
 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
 D+Ofp0T3KOr1RUHvCZoLURfFhSQ=
Message-ID: <58247760-00de-203d-a779-7fda3a739248@redhat.com>
Date:   Tue, 28 Apr 2020 17:57:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20181212041717.GE22265@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/2018 05:17, Paul Mackerras wrote:
> This adds code to flush the partition-scoped page tables for a radix
> guest when dirty tracking is turned on or off for a memslot.  Only the
> guest real addresses covered by the memslot are flushed.  The reason
> for this is to get rid of any 2M PTEs in the partition-scoped page
> tables that correspond to host transparent huge pages, so that page
> dirtiness is tracked at a system page (4k or 64k) granularity rather
> than a 2M granularity.  The page tables are also flushed when turning
> dirty tracking off so that the memslot's address space can be
> repopulated with THPs if possible.
> 
> To do this, we add a new function kvmppc_radix_flush_memslot().  Since
> this does what's needed for kvmppc_core_flush_memslot_hv() on a radix
> guest, we now make kvmppc_core_flush_memslot_hv() call the new
> kvmppc_radix_flush_memslot() rather than calling kvm_unmap_radix()
> for each page in the memslot.  This has the effect of fixing a bug in
> that kvmppc_core_flush_memslot_hv() was previously calling
> kvm_unmap_radix() without holding the kvm->mmu_lock spinlock, which
> is required to be held.
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> Reviewed-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  arch/powerpc/include/asm/kvm_book3s.h  |  2 ++
>  arch/powerpc/kvm/book3s_64_mmu_hv.c    |  9 +++++----
>  arch/powerpc/kvm/book3s_64_mmu_radix.c | 20 ++++++++++++++++++++
>  arch/powerpc/kvm/book3s_hv.c           | 17 +++++++++++++++++
>  4 files changed, 44 insertions(+), 4 deletions(-)
> 
...
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index f4fbb7b5..074ff5b 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4384,6 +4384,23 @@ static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
>  	 */
>  	if (npages)
>  		atomic64_inc(&kvm->arch.mmio_update);
> +
> +	/*
> +	 * For change == KVM_MR_MOVE or KVM_MR_DELETE, higher levels
> +	 * have already called kvm_arch_flush_shadow_memslot() to
> +	 * flush shadow mappings.  For KVM_MR_CREATE we have no
> +	 * previous mappings.  So the only case to handle is
> +	 * KVM_MR_FLAGS_ONLY when the KVM_MEM_LOG_DIRTY_PAGES bit
> +	 * has been changed.
> +	 * For radix guests, we flush on setting KVM_MEM_LOG_DIRTY_PAGES
> +	 * to get rid of any THP PTEs in the partition-scoped page tables
> +	 * so we can track dirtiness at the page level; we flush when
> +	 * clearing KVM_MEM_LOG_DIRTY_PAGES so that we can go back to
> +	 * using THP PTEs.
> +	 */
> +	if (change == KVM_MR_FLAGS_ONLY && kvm_is_radix(kvm) &&
> +	    ((new->flags ^ old->flags) & KVM_MEM_LOG_DIRTY_PAGES))
> +		kvmppc_radix_flush_memslot(kvm, old);
>  }

Hi,

this part introduces a regression in QEMU test suite.

We have the following warning in the host kernel log:

[   96.631336] ------------[ cut here ]------------
[   96.631372] WARNING: CPU: 32 PID: 4095 at
arch/powerpc/kvm/book3s_64_mmu_radix.c:436
kvmppc_unmap_free_pte+0x84/0x150 [kvm_hv]
[   96.631394] Modules linked in: xt_CHECKSUM nft_chain_nat
xt_MASQUERADE nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 nft_counter nft_compat
nf_tables nfnetlink tun bridge stp llc rpcsec_gss_krb5 auth_rpcgss nfsv4
dns_resolver nfs lockd grace fscache rfkill kvm_hv kvm i2c_dev sunrpc
ext4 mbcache jbd2 xts ofpart ses enclosure vmx_crypto scsi_transport_sas
at24 ipmi_powernv powernv_flash ipmi_devintf opal_prd mtd
ipmi_msghandler uio_pdrv_genirq uio ibmpowernv ip_tables xfs libcrc32c
ast i2c_algo_bit drm_vram_helper drm_ttm_helper ttm drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm sd_mod i40e t10_pi
sg aacraid drm_panel_orientation_quirks dm_mirror dm_region_hash dm_log
dm_mod
[   96.631553] CPU: 32 PID: 4095 Comm: CPU 0/KVM Not tainted 5.7.0-rc3 #24
[   96.631571] NIP:  c008000007745d1c LR: c008000007746c20 CTR:
c000000000098aa0
[   96.631598] REGS: c0000003b842f440 TRAP: 0700   Not tainted  (5.7.0-rc3)
[   96.631615] MSR:  900000010282b033
<SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 24222448  XER: 20040000
[   96.631648] CFAR: c008000007746c1c IRQMASK: 0
[   96.631648] GPR00: c008000007746c20 c0000003b842f6d0 c00800000775b300
c000000008a60000
[   96.631648] GPR04: c00000039b835200 c0000003aae00387 0000000000000001
000000009b835205
[   96.631648] GPR08: 0552839b03000080 0000000000000020 0000000000000005
c00800000774dd88
[   96.631648] GPR12: c000000000098aa0 c0000007fffdb000 0000000000000000
0000000000000000
[   96.631648] GPR16: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[   96.631648] GPR20: 0000000000000000 0000000000000001 8703e0aa030000c0
c00000000183d9d8
[   96.631648] GPR24: c00000000183d9e0 c00000039b835200 0000000000000001
c000000008a60000
[   96.631648] GPR28: 0000000000000001 c00000000183d9e8 0000000000000000
c00000039b835200
[   96.631784] NIP [c008000007745d1c] kvmppc_unmap_free_pte+0x84/0x150
[kvm_hv]
[   96.631813] LR [c008000007746c20] kvmppc_create_pte+0x948/0xa90 [kvm_hv]
[   96.631830] Call Trace:
[   96.631845] [c0000003b842f6d0] [00007fff60740000] 0x7fff60740000
(unreliable)
[   96.631866] [c0000003b842f730] [c008000007746c20]
kvmppc_create_pte+0x948/0xa90 [kvm_hv]
[   96.631886] [c0000003b842f7d0] [c0080000077470f8]
kvmppc_book3s_instantiate_page+0x270/0x5c0 [kvm_hv]
[   96.631920] [c0000003b842f8c0] [c008000007747618]
kvmppc_book3s_radix_page_fault+0x1d0/0x300 [kvm_hv]
[   96.631951] [c0000003b842f970] [c008000007741f7c]
kvmppc_book3s_hv_page_fault+0x1f4/0xd50 [kvm_hv]
[   96.631981] [c0000003b842fa60] [c00800000773da34]
kvmppc_vcpu_run_hv+0x9bc/0xba0 [kvm_hv]
[   96.632006] [c0000003b842fb30] [c008000007c6aabc]
kvmppc_vcpu_run+0x34/0x48 [kvm]
[   96.632030] [c0000003b842fb50] [c008000007c6686c]
kvm_arch_vcpu_ioctl_run+0x2f4/0x400 [kvm]
[   96.632061] [c0000003b842fbe0] [c008000007c57fb8]
kvm_vcpu_ioctl+0x340/0x7d0 [kvm]
[   96.632082] [c0000003b842fd50] [c0000000004c9598] ksys_ioctl+0xf8/0x150
[   96.632100] [c0000003b842fda0] [c0000000004c9618] sys_ioctl+0x28/0x80
[   96.632118] [c0000003b842fdc0] [c000000000034b34]
system_call_exception+0x104/0x1d0
[   96.632146] [c0000003b842fe20] [c00000000000c970]
system_call_common+0xf0/0x278
[   96.632165] Instruction dump:
[   96.632181] 7cda3378 7c9f2378 3bc00000 3b800001 e95d0000 7d295030
2f890000 419e0054
[   96.632211] 60000000 7ca0fc28 2fa50000 419e0028 <0fe00000> 78a55924
7f48d378 7fe4fb78
[   96.632241] ---[ end trace 4f8aa0280f1215fb ]---

The problem is detected with the "migration-test" test program in qemu,
on a POWER9 host in radix mode with THP. It happens only the first time
the test program is run after loading kvm_hv. The warning is an explicit
detection [1] of a problem:

arch/powerpc/kvm/book3s_64_mmu_radix.c:
 414 /*
 415  * kvmppc_free_p?d are used to free existing page tables, and
recursively
 416  * descend and clear and free children.
 417  * Callers are responsible for flushing the PWC.
 418  *
 419  * When page tables are being unmapped/freed as part of page fault path
 420  * (full == false), ptes are not expected. There is code to unmap them
 421  * and emit a warning if encountered, but there may already be data
 422  * corruption due to the unexpected mappings.
 423  */
 424 static void kvmppc_unmap_free_pte(struct kvm *kvm, pte_t *pte, bool
full,
 425                                   unsigned int lpid)
 426 {
 427         if (full) {
 428                 memset(pte, 0, sizeof(long) << RADIX_PTE_INDEX_SIZE);
 429         } else {
 430                 pte_t *p = pte;
 431                 unsigned long it;
 432
 433                 for (it = 0; it < PTRS_PER_PTE; ++it, ++p) {
 434                         if (pte_val(*p) == 0)
 435                                 continue;
 436                         WARN_ON_ONCE(1);
 437                         kvmppc_unmap_pte(kvm, p,
 438                                          pte_pfn(*p) << PAGE_SHIFT,
 439                                          PAGE_SHIFT, NULL, lpid);
 440                 }
 441         }
 442
 443         kvmppc_pte_free(pte);
 444 }


I reproduce the problem in QEMU 4.2 build directory with :

 sudo rmmod kvm_hv
 sudo modprobe kvm_hv
 make check-qtest-ppc64

or once the test binary is built with

 sudo rmmod kvm_hv
 sudo modprobe kvm_hv
 export QTEST_QEMU_BINARY=ppc64-softmmu/qemu-system-ppc64
 tests/qtest/migration-test

The sub-test is "/migration/validate_uuid_error" that generates some
memory stress with a SLOF program in the source guest and fails because
of a mismatch with the destination guest. So the source guest continues
to execute the stress program while the migration is aborted.

Another way to reproduce the problem is:

Source guest:

sudo rmmod kvm-hv
sudo modprobe kvm-hv
qemu-system-ppc64 -display none -accel kvm -name source -m 256M \
                  -nodefaults -prom-env use-nvramrc?=true \
                  -prom-env 'nvramrc=hex ." _" begin 6400000 100000 \
                  do i c@ 1 + i c! 1000 +loop ." B" 0 until' -monitor \
                  stdio

Destination guest (on the same host):

qemu-system-ppc64 -display none -accel kvm -name source -m 512M \
                  -nodefaults -monitor stdio -incoming tcp:0:4444

Then in source guest monitor:

(qemu) migrate tcp:localhost:4444

The migration intentionally fails because of a memory size mismatch and
the warning is generated in the host kernel log.

It was not detected earlier because the problem is only detected with a
test added in qemu-4.2.0 [2] with THP enabled that starts a migration
and fails, so the memory stress program continues to run in the source
guest while the dirty log bitmap is released. The problem cannot be
shown with qemu-5.0 because a change in the migration speed has been
added [3]

The problem seems to happen because QEMU modifies the memory map while a
vCPU is running:

   (qemu) migrate tcp:localhost:4444

   108264@1578573121.242431:kvm_run_exit cpu_index 0, reason 19
   108264@1578573121.242454:kvm_vcpu_ioctl cpu_index 0, type 0x2000ae80,
arg (nil)
   108264@1578573121.248110:kvm_run_exit cpu_index 0, reason 19

   108281@1578573121.248710:kvm_set_user_memory Slot#0 flags=0x1 gpa=0x0
size=0x10000000 ua=0x7fff8fe00000 ret=0

-> 108264@1578573121.249335:kvm_vcpu_ioctl cpu_index 0, type 0x2000ae80,
arg (nil)
-> 108259@1578573121.253111:kvm_set_user_memory Slot#0 flags=0x0 gpa=0x0
size=0x10000000 ua=0x7fff8fe00000 ret=0
-> 108264@1578573121.256593:kvm_run_exit cpu_index 0, reason 19

This is part of the cleanup function after the migration has failed:

migration_iteration_finish
  migrate_fd_cleanup_schedule()
    migrate_fd_cleanup_bh
...
migrate_fd_cleanup
  qemu_savevm_state_cleanup
    ram_save_cleanup
      memory_global_dirty_log_stop
        memory_global_dirty_log_do_stop
          ..

If I pause the VM in qemu_savevm_state_cleanup() while save_cleanup()
functions are called (ram_save_cleanup()), the warning disappears.

Any idea?

Thanks,
Laurent

[1] warning introduced by
    a5704e83aa3d KVM: PPC: Book3S HV: Recursively unmap all page table
                 entries when unmapping
[2] 3af31a3469 "tests/migration: Add a test for validate-uuid capability"
[3] 97e1e06780 "migration: Rate limit inside host pages"

