Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1503162F08
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 19:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgBRSvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 13:51:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60237 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726478AbgBRSvu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 13:51:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582051909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aRk89fcGpSqd1HZwvbbTzIVysSoWwLOggMDD0CvkgR0=;
        b=BzHK19esP4ZJQ2GHB6xZ3qf1u/m/EYGmpX9tHotrsHsoqgKoZtAQNFZQWFRcZvUbPG35P0
        o7Tbu+TZPZ12knwE3iNNQlNBOaN7YxzM6SGO8RpwfCbP+OrJVdQH81o9juIqnsO7PCCz81
        A2ee1hbs6W1qhol9iMz7a/Wd1sgiyRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-DTLSgxV5Pkq_8_FKH3lTLg-1; Tue, 18 Feb 2020 13:51:39 -0500
X-MC-Unique: DTLSgxV5Pkq_8_FKH3lTLg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54B69107B7D5;
        Tue, 18 Feb 2020 18:51:37 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3698A60BE1;
        Tue, 18 Feb 2020 18:51:36 +0000 (UTC)
Date:   Tue, 18 Feb 2020 11:51:35 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, vkuznets@redhat.com,
        rkagan@virtuozzo.com, graf@amazon.com, jschoenh@amazon.de,
        karahmed@amazon.de, rimasluk@amazon.com, jon.grimm@amd.com
Subject: Re: [PATCH v5 14/18] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Message-ID: <20200218115135.4e09ffca@w520.home>
In-Reply-To: <1573762520-80328-15-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1573762520-80328-15-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 14:15:16 -0600
Suravee Suthikulpanit <suravee.suthikulpanit@amd.com> wrote:

> AMD SVM AVIC accelerates EOI write and does not trap. This causes
> in-kernel PIT re-injection mode to fail since it relies on irq-ack
> notifier mechanism. So, APICv is activated only when in-kernel PIT
> is in discard mode e.g. w/ qemu option:
> 
>   -global kvm-pit.lost_tick_policy=discard
> 
> Also, introduce APICV_INHIBIT_REASON_PIT_REINJ bit to be used for this
> reason.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---

Hi,

I've bisected https://bugzilla.kernel.org/show_bug.cgi?id=206579 (a
kernel NULL pointer deref when using device assigned on AMD platforms)
to this commit, e2ed4078a6ef3ddf4063329298852e24c36d46c8.  My VM is a
very basic libvirt managed domain with an assigned NIC, I don't even
have an OS installed:

/usr/bin/qemu-system-x86_64 \
-name guest=fedora31,debug-threads=on \
-S \
-object
secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-1-fedora31/master-key.aes
\ -machine pc-q35-3.1,accel=kvm,usb=off,vmport=off,dump-guest-core=off
\ -cpu
EPYC-IBPB,x2apic=on,tsc-deadline=on,hypervisor=on,tsc_adjust=on,xsaves=on,cmp_legacy=on,perfctr_core=on,virt-ssbd=on,monitor=off
\ -m 8192 \ -realtime mlock=off \ -smp 8,sockets=8,cores=1,threads=1 \
-uuid a9639aa6-b3c1-4b45-b07b-80e0ad6d7df2 \
-no-user-config \
-nodefaults \
-chardev socket,id=charmonitor,fd=30,server,nowait \
-mon chardev=charmonitor,id=monitor,mode=control \
-rtc base=utc,driftfix=slew \
-global kvm-pit.lost_tick_policy=delay \
-no-hpet \
-no-shutdown \
-global ICH9-LPC.disable_s3=1 \
-global ICH9-LPC.disable_s4=1 \
-boot strict=on \
-device
pcie-root-port,port=0x10,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x2
\ -device
pcie-root-port,port=0x11,chassis=2,id=pci.2,bus=pcie.0,addr=0x2.0x1 \
-device
pcie-root-port,port=0x12,chassis=3,id=pci.3,bus=pcie.0,addr=0x2.0x2 \
-device
pcie-root-port,port=0x13,chassis=4,id=pci.4,bus=pcie.0,addr=0x2.0x3 \
-device
pcie-root-port,port=0x14,chassis=5,id=pci.5,bus=pcie.0,addr=0x2.0x4 \
-device
pcie-root-port,port=0x15,chassis=6,id=pci.6,bus=pcie.0,addr=0x2.0x5 \
-device
pcie-root-port,port=0x16,chassis=7,id=pci.7,bus=pcie.0,addr=0x2.0x6 \
-device qemu-xhci,p2=15,p3=15,id=usb,bus=pci.2,addr=0x0 \ -drive
file=/var/lib/libvirt/images/fedora31.qcow2,format=qcow2,if=none,id=drive-virtio-disk0
\ -device
virtio-blk-pci,scsi=off,bus=pci.3,addr=0x0,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1
\ -netdev tap,fd=32,id=hostnet0,vhost=on,vhostfd=33 \ -device
virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:c4:c4:fb,bus=pci.1,addr=0x0
\ -vnc 127.0.0.1:0 \ -device
VGA,id=video0,vgamem_mb=16,bus=pcie.0,addr=0x1 \ -device
vfio-pci,host=01:00.0,id=hostdev0,bus=pci.4,addr=0x0 \ -device
virtio-balloon-pci,id=balloon0,bus=pci.5,addr=0x0 \ -object
rng-random,id=objrng0,filename=/dev/urandom \ -device
virtio-rng-pci,rng=objrng0,id=rng0,bus=pci.6,addr=0x0 \ -sandbox
on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
\ -msg timestamp=on

This results in:

BUG: kernel NULL pointer dereference, address: 0000000000000010
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0 
Oops: 0000 [#1] SMP NOPTI
CPU: 54 PID: 31469 Comm: CPU 0/KVM Not tainted 5.5.0+ #24
Hardware name: AMD Corporation Diesel/Diesel, BIOS RDL100BB 11/14/2018
RIP: 0010:svm_refresh_apicv_exec_ctrl+0xe4/0x110 [kvm_amd]
Code: 8b 83 b8 39 00 00 48 39 c5 74 31 48 8b 9b b8 39 00 00 48 39 dd 75
13 eb 23 e8 c8 0d 97 d6 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 1e 0d 97 d6 85 c0 74 e6 5b 4c 89 ee RSP:
0018:ffff99ae87923d70 EFLAGS: 00010086 RAX: 0000000000000000 RBX:
0000000000000000 RCX: ffff8d2323b0a000 RDX: 0000000000000001 RSI:
ffff8d232e76c600 RDI: ffff8d232c9bf398 RBP: ffff8d232c9bf388 R08:
0000000000000000 R09: ffff8d232e76c600 R10: 0000000000000000 R11:
0000000000000000 R12: 0000000000000000 R13: 0000000000000202 R14:
ffff8d232c9bf398 R15: ffff99ae86e361a0 FS:  00007f2aa3d7d700(0000)
GS:ffff8d232fd80000(0000) knlGS:0000000000000000 CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033 CR2: 0000000000000010 CR3: 000000046c716000
CR4: 00000000003406e0 Call Trace: kvm_arch_vcpu_ioctl_run+0x335/0x1a90
[kvm] ? do_futex+0x86b/0xca0
 ? __seccomp_filter+0x7b/0x670
 kvm_vcpu_ioctl+0x218/0x5c0 [kvm]
 ksys_ioctl+0x87/0xc0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x5b/0x1b0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f2aaa9c6fcb
Code: 0f 1e fa 48 8b 05 bd ce 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 8d ce 0c 00 f7 d8 64 89 01 48 RSP:
002b:00007f2aa3d7c688 EFLAGS: 00000246 ORIG_RAX: 0000000000000010 RAX:
ffffffffffffffda RBX: 00005623b5362220 RCX: 00007f2aaa9c6fcb RDX:
0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000f RBP:
00007f2aabc65000 R08: 00005623b4316f30 R09: 0000000000000000 R10:
00005623b52f2280 R11: 0000000000000246 R12: 00005623b5382e70 R13:
00005623b5362220 R14: 00005623b478a7c0 R15: 00007f2aa3d7c880 Modules
linked in: kvm_amd ccp kvm vhost_net vhost macvtap macvlan tap vfio_pci
vfio_virqfd vfio_iommu_type1 vfio irqbypass xt_CHECKSUM xt_MASQUERADE
xt_conntrack tun bridge stp llc ip6table_mangle ip6table_nat
iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 libcrc32c ebtable_filter ebtables ip6table_filter
ip6_tables rfkill rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi
scsi_transport_iscsi ib_srpt target_core_mod sunrpc ib_srp
scsi_transport_srp ib_ipoib rdma_ucm ib_umad vfat fat rdma_cm ib_cm
iw_cm amd64_edac_mod edac_mce_amd i40iw ipmi_ssif ib_uverbs
crct10dif_pclmul crc32_pclmul ib_core ghash_clmulni_intel pcspkr joydev
sp5100_tco ipmi_si k10temp i2c_piix4 ipmi_devintf ipmi_msghandler
acpi_cpufreq nouveau ast video drm_vram_helper mxm_wmi wmi
drm_ttm_helper i2c_algo_bit drm_kms_helper cec ttm drm i40e e1000e
crc32c_intel nvme nvme_core pinctrl_amd [last unloaded: ccp] CR2:
0000000000000010 ---[ end trace 5d826c21656a44f3 ]--- RIP:
0010:svm_refresh_apicv_exec_ctrl+0xe4/0x110 [kvm_amd] Code: 8b 83 b8 39
00 00 48 39 c5 74 31 48 8b 9b b8 39 00 00 48 39 dd 75 13 eb 23 e8 c8 0d
97 d6 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b 10 45 85 e4 75 e6
e8 1e 0d 97 d6 85 c0 74 e6 5b 4c 89 ee RSP: 0018:ffff99ae87923d70
EFLAGS: 00010086 RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffff8d2323b0a000 RDX: 0000000000000001 RSI: ffff8d232e76c600 RDI:
ffff8d232c9bf398 RBP: ffff8d232c9bf388 R08: 0000000000000000 R09:
ffff8d232e76c600 R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000 R13: 0000000000000202 R14: ffff8d232c9bf398 R15:
ffff99ae86e361a0 FS:  00007f2aa3d7d700(0000) GS:ffff8d232fd80000(0000)
knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033 CR2: 0000000000000010 CR3: 000000046c716000 CR4:
00000000003406e0

Please fix.  Thanks,

Alex

>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/i8254.c            | 12 ++++++++++++
>  arch/x86/kvm/svm.c              | 11 +++++++++--
>  3 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4b51222..9cb2d2e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -853,6 +853,7 @@ enum kvm_irqchip_mode {
>  #define APICV_INHIBIT_REASON_HYPERV     1
>  #define APICV_INHIBIT_REASON_NESTED     2
>  #define APICV_INHIBIT_REASON_IRQWIN     3
> +#define APICV_INHIBIT_REASON_PIT_REINJ  4
>  
>  struct kvm_arch {
>  	unsigned long n_used_mmu_pages;
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 4a6dc54..b24c606 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -295,12 +295,24 @@ void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
>  	if (atomic_read(&ps->reinject) == reinject)
>  		return;
>  
> +	/*
> +	 * AMD SVM AVIC accelerates EOI write and does not trap.
> +	 * This cause in-kernel PIT re-inject mode to fail
> +	 * since it checks ps->irq_ack before kvm_set_irq()
> +	 * and relies on the ack notifier to timely queue
> +	 * the pt->worker work iterm and reinject the missed tick.
> +	 * So, deactivate APICv when PIT is in reinject mode.
> +	 */
>  	if (reinject) {
> +		kvm_request_apicv_update(kvm, false,
> +					 APICV_INHIBIT_REASON_PIT_REINJ);
>  		/* The initial state is preserved while ps->reinject == 0. */
>  		kvm_pit_reset_reinject(pit);
>  		kvm_register_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
>  		kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
>  	} else {
> +		kvm_request_apicv_update(kvm, true,
> +					 APICV_INHIBIT_REASON_PIT_REINJ);
>  		kvm_unregister_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
>  		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
>  	}
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b7883b3..2dfdd7c 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1684,7 +1684,13 @@ static int avic_update_access_page(struct kvm *kvm, bool activate)
>  	int ret = 0;
>  
>  	mutex_lock(&kvm->slots_lock);
> -	if (kvm->arch.apic_access_page_done == activate)
> +	/*
> +	 * During kvm_destroy_vm(), kvm_pit_set_reinject() could trigger
> +	 * APICv mode change, which update APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
> +	 * memory region. So, we need to ensure that kvm->mm == current->mm.
> +	 */
> +	if ((kvm->arch.apic_access_page_done == activate) ||
> +	    (kvm->mm != current->mm))
>  		goto out;
>  
>  	ret = __x86_set_memory_region(kvm,
> @@ -7281,7 +7287,8 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
>  	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
>  			  BIT(APICV_INHIBIT_REASON_HYPERV) |
>  			  BIT(APICV_INHIBIT_REASON_NESTED) |
> -			  BIT(APICV_INHIBIT_REASON_IRQWIN);
> +			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
> +			  BIT(APICV_INHIBIT_REASON_PIT_REINJ);
>  
>  	return supported & BIT(bit);
>  }

