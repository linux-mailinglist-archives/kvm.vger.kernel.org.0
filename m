Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB75E2DE03
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 15:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfE2NWs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 29 May 2019 09:22:48 -0400
Received: from 3.mo179.mail-out.ovh.net ([178.33.251.175]:39877 "EHLO
        3.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfE2NWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 09:22:48 -0400
Received: from player157.ha.ovh.net (unknown [10.108.57.14])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id C03E81337B8
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 15:17:28 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player157.ha.ovh.net (Postfix) with ESMTPSA id 5905063CB146;
        Wed, 29 May 2019 13:17:22 +0000 (UTC)
Date:   Wed, 29 May 2019 15:17:21 +0200
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     Paul Mackerras <paulus@samba.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: XIVE: do not clear IRQ data of
 passthrough interrupts
Message-ID: <20190529151721.682b5999@bahia.lab.toulouse-stg.fr.ibm.com>
In-Reply-To: <20190528121716.18419-2-clg@kaod.org>
References: <20190528121716.18419-1-clg@kaod.org>
        <20190528121716.18419-2-clg@kaod.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 9684991002576918923
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgieegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 May 2019 14:17:15 +0200
Cédric Le Goater <clg@kaod.org> wrote:

> The passthrough interrupts are defined at the host level and their IRQ
> data should not be cleared unless specifically deconfigured (shutdown)
> by the host. They differ from the IPI interrupts which are allocated
> by the XIVE KVM device and reserved to the guest usage only.
> 
> This fixes a host crash when destroying a VM in which a PCI adapter
> was passed-through. In this case, the interrupt is cleared and freed
> by the KVM device and then shutdown by vfio at the host level.
> 
> [ 1007.360265] BUG: Kernel NULL pointer dereference at 0x00000d00
> [ 1007.360285] Faulting instruction address: 0xc00000000009da34
> [ 1007.360296] Oops: Kernel access of bad area, sig: 7 [#1]
> [ 1007.360303] LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV
> [ 1007.360314] Modules linked in: vhost_net vhost iptable_mangle ipt_MASQUERADE iptable_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 tun bridge stp llc kvm_hv kvm xt_tcpudp iptable_filter squashfs fuse binfmt_misc vmx_crypto ib_iser rdma_cm iw_cm ib_cm libiscsi scsi_transport_iscsi nfsd ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress lzo_compress raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq multipath mlx5_ib ib_uverbs ib_core crc32c_vpmsum mlx5_core
> [ 1007.360425] CPU: 9 PID: 15576 Comm: CPU 18/KVM Kdump: loaded Not tainted 5.1.0-gad7e7d0ef #4
> [ 1007.360454] NIP:  c00000000009da34 LR: c00000000009e50c CTR: c00000000009e5d0
> [ 1007.360482] REGS: c000007f24ccf330 TRAP: 0300   Not tainted  (5.1.0-gad7e7d0ef)
> [ 1007.360500] MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002484  XER: 00000000
> [ 1007.360532] CFAR: c00000000009da10 DAR: 0000000000000d00 DSISR: 00080000 IRQMASK: 1
> [ 1007.360532] GPR00: c00000000009e62c c000007f24ccf5c0 c000000001510600 c000007fe7f947c0
> [ 1007.360532] GPR04: 0000000000000d00 0000000000000000 0000000000000000 c000005eff02d200
> [ 1007.360532] GPR08: 0000000000400000 0000000000000000 0000000000000000 fffffffffffffffd
> [ 1007.360532] GPR12: c00000000009e5d0 c000007fffff7b00 0000000000000031 000000012c345718
> [ 1007.360532] GPR16: 0000000000000000 0000000000000008 0000000000418004 0000000000040100
> [ 1007.360532] GPR20: 0000000000000000 0000000008430000 00000000003c0000 0000000000000027
> [ 1007.360532] GPR24: 00000000000000ff 0000000000000000 00000000000000ff c000007faa90d98c
> [ 1007.360532] GPR28: c000007faa90da40 00000000000fe040 ffffffffffffffff c000007fe7f947c0
> [ 1007.360689] NIP [c00000000009da34] xive_esb_read+0x34/0x120
> [ 1007.360706] LR [c00000000009e50c] xive_do_source_set_mask.part.0+0x2c/0x50
> [ 1007.360732] Call Trace:
> [ 1007.360738] [c000007f24ccf5c0] [c000000000a6383c] snooze_loop+0x15c/0x270 (unreliable)
> [ 1007.360775] [c000007f24ccf5f0] [c00000000009e62c] xive_irq_shutdown+0x5c/0xe0
> [ 1007.360795] [c000007f24ccf630] [c00000000019e4a0] irq_shutdown+0x60/0xe0
> [ 1007.360813] [c000007f24ccf660] [c000000000198c44] __free_irq+0x3a4/0x420
> [ 1007.360831] [c000007f24ccf700] [c000000000198dc8] free_irq+0x78/0xe0
> [ 1007.360849] [c000007f24ccf730] [c00000000096c5a8] vfio_msi_set_vector_signal+0xa8/0x350
> [ 1007.360878] [c000007f24ccf7f0] [c00000000096c938] vfio_msi_set_block+0xe8/0x1e0
> [ 1007.360899] [c000007f24ccf850] [c00000000096cae0] vfio_msi_disable+0xb0/0x110
> [ 1007.360912] [c000007f24ccf8a0] [c00000000096cd04] vfio_pci_set_msi_trigger+0x1c4/0x3d0
> [ 1007.360922] [c000007f24ccf910] [c00000000096d910] vfio_pci_set_irqs_ioctl+0xa0/0x170
> [ 1007.360941] [c000007f24ccf930] [c00000000096b400] vfio_pci_disable+0x80/0x5e0
> [ 1007.360963] [c000007f24ccfa10] [c00000000096b9bc] vfio_pci_release+0x5c/0x90
> [ 1007.360991] [c000007f24ccfa40] [c000000000963a9c] vfio_device_fops_release+0x3c/0x70
> [ 1007.361012] [c000007f24ccfa70] [c0000000003b5668] __fput+0xc8/0x2b0
> [ 1007.361040] [c000007f24ccfac0] [c0000000001409b0] task_work_run+0x140/0x1b0
> [ 1007.361059] [c000007f24ccfb20] [c000000000118f8c] do_exit+0x3ac/0xd00
> [ 1007.361076] [c000007f24ccfc00] [c0000000001199b0] do_group_exit+0x60/0x100
> [ 1007.361094] [c000007f24ccfc40] [c00000000012b514] get_signal+0x1a4/0x8f0
> [ 1007.361112] [c000007f24ccfd30] [c000000000021cc8] do_notify_resume+0x1a8/0x430
> [ 1007.361141] [c000007f24ccfe20] [c00000000000e444] ret_from_except_lite+0x70/0x74
> [ 1007.361159] Instruction dump:
> [ 1007.361175] 38422c00 e9230000 712a0004 41820010 548a2036 7d442378 78840020 71290020
> [ 1007.361194] 4082004c e9230010 7c892214 7c0004ac <e9240000> 0c090000 4c00012c 792a0022
> 
> Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")

Maybe worth adding:

Cc: stable@vger.kernel.org # v4.12+

> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  arch/powerpc/kvm/book3s_xive.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index 12c8a36dd980..922fd62bcd2a 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -1828,7 +1828,6 @@ static void kvmppc_xive_cleanup_irq(u32 hw_num, struct xive_irq_data *xd)
>  {
>  	xive_vm_esb_load(xd, XIVE_ESB_SET_PQ_01);
>  	xive_native_configure_irq(hw_num, 0, MASKED, 0);
> -	xive_cleanup_irq_data(xd);
>  }
>  
>  void kvmppc_xive_free_sources(struct kvmppc_xive_src_block *sb)
> @@ -1842,9 +1841,10 @@ void kvmppc_xive_free_sources(struct kvmppc_xive_src_block *sb)
>  			continue;
>  
>  		kvmppc_xive_cleanup_irq(state->ipi_number, &state->ipi_data);
> +		xive_cleanup_irq_data(&state->ipi_data);
>  		xive_native_free_irq(state->ipi_number);
>  
> -		/* Pass-through, cleanup too */
> +		/* Pass-through, cleanup too but keep IRQ hw data */
>  		if (state->pt_number)
>  			kvmppc_xive_cleanup_irq(state->pt_number, state->pt_data);
>  

Also, even if this definitely allows to avoid the crash, I'm still not
convinced we should be calling kvmppc_xive_cleanup_irq() for pass-through
at all.

My concern is that kvmppc_xive_clr_mapped() which gets called when VFIO shuts
the interrupt down seems to be doing extra stuff to release the pass-through
interrupt back to the host. But when the KVM device gets released before VFIO
had a chance to do that, kvmppc_xive_clr_mapped() is a nop since both
kvmppc_xive_release() and kvmppc_xive_native_release() set kvm.arch->xive to
NULL. This triggers the following warning in the xics-on-xive case:

[25185.218975] kvmppc_clr_passthru_irq (irq 94, gsi 4870) fails: -19

I'm wondering if we should do this extra stuff from kvmppc_xive_clr_mapped()
as well when closing the KVM device instead of clearing the interrupt as the
we do now.

This needs some more investigation.

Cheers,

--
Greg
