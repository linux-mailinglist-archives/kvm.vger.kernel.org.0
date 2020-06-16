Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959BE1FABA4
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 10:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgFPIvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 04:51:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:35732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727795AbgFPIvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 04:51:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 089C8AFA8;
        Tue, 16 Jun 2020 08:51:03 +0000 (UTC)
Date:   Tue, 16 Jun 2020 10:50:52 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: vfio: refcount_t: underflow; use-after-free.
Message-ID: <20200616085052.sahrunsesjyjeyf2@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm getting the warning below when starting a KVM the second time with an
Emulex PCI card 'passthroughed' into a KVM. I'm terminating the session
via 'ctrl-a x', not sure if this is relevant.

This is with 5.8-rc1. IIRC, older version didn't have this problem.

 modprobe -r lpfc
 modprobe vfio-pci ids=10df:f400
 qemu-system-x86_64 ... \
      -device vfio-pci,host=04:00.0 \
      -device vfio-pci,host=04:00.1 \
      -device vfio-pci,host=c1:00.0 \
      -device vfio-pci,host=c1:00.1 \
      ...


 vfio-pci 0000:04:00.0: vfio_ecap_init: hiding ecap 0x19@0x20c
 vfio-pci 0000:04:00.0: vfio_ecap_init: hiding ecap 0x26@0x238
 vfio-pci 0000:04:00.0: vfio_ecap_init: hiding ecap 0x27@0x278
 ------------[ cut here ]------------
 refcount_t: underflow; use-after-free.
 WARNING: CPU: 14 PID: 59978 at lib/refcount.c:28 refcount_warn_saturate+0x8d/0xf0
 Modules linked in: rpcsec_gss_krb5(E) auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) vfio_pci(E) vfio_virqfd(E) vfio_iommu_type1(E) vfio(E) af_packet(E) xt_tcpudp(E) ip6t_rpfilter(E) ip6t_REJECT(E) ipt_REJECT(E) xt_conntrack(E) ip_set(E) nfnetlink(E) ebtable_nat(E) ebtable_broute(E) ip6table_nat(E) ip6table_mangle(E) ip6table_raw(E) ip6table_security(E) iptable_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) iptable_mangle(E) iptable_raw(E) iptable_security(E) ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) iscsi_ibft(E) x_tables(E) iscsi_boot_sysfs(E) bpfilter(E) rfkill(E) nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) intel_rapl_msr(E) intel_rapl_common(E) sb_edac(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) iTCO_wdt(E) kvm_intel(E) iTCO_vendor_support(E) kvm(E) irqbypass(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) crypto_simd(E) cryptd(E)
  glue_helper(E) pcspkr(E) ipmi_ssif(E) bnx2x(E) lpc_ich(E) mfd_core(E) hpwdt(E) mdio(E) acpi_ipmi(E) ioatdma(E) hpilo(E) dca(E) ipmi_si(E) tg3(E) ipmi_devintf(E) libphy(E) ipmi_msghandler(E) acpi_tad(E) button(E) btrfs(E) libcrc32c(E) xor(E) raid6_pq(E) dm_service_time(E) sd_mod(E) mgag200(E) drm_vram_helper(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) qla2xxx(E) cec(E) configfs(E) drm_ttm_helper(E) uhci_hcd(E) ehci_pci(E) nvme_fc(E) ehci_hcd(E) nvme_fabrics(E) ttm(E) nvme_core(E) drm(E) t10_pi(E) i2c_algo_bit(E) usbcore(E) crc32c_intel(E) scsi_transport_fc(E) hpsa(E) scsi_transport_sas(E) wmi(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) efivarfs(E) [last unloaded: nvmet]
 CPU: 14 PID: 59978 Comm: qemu-system-x86 Kdump: loaded Tainted: G            E     5.8.0-rc1-default #28
 Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 07/21/2019
 RIP: 0010:refcount_warn_saturate+0x8d/0xf0
 Code: 05 2c 11 17 01 01 e8 b2 1b c1 ff 0f 0b c3 80 3d 1f 11 17 01 00 75 ad 48 c7 c7 b8 aa 56 a0 c6 05 0f 11 17 01 01 e8 93 1b c1 ff <0f> 0b c3 80 3d 03 11 17 01 00 75 8e 48 c7 c7 60 aa 56 a0 c6 05 f3
 RSP: 0018:ffffa10929087df0 EFLAGS: 00010282
 RAX: 0000000000000000 RBX: ffff958bdb474b80 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: ffff958bdf91ac90 RDI: ffff958bdf91ac90
 RBP: ffff958393e3e0f0 R08: 0000000000000000 R09: 000000000000000e
 R10: 000000000000003b R11: ffffa10929087c88 R12: 00005617ef8baa70
 R13: ffff958405be2650 R14: 0000000000000038 R15: ffff958393e3e060
 FS:  00007fbeb6c86600(0000) GS:ffff958bdf900000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005617edfbe108 CR3: 0000000f7f5e2004 CR4: 00000000001626e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  vfio_pci_set_ctx_trigger_single+0x69/0xc0 [vfio_pci]
  vfio_pci_ioctl+0x2ea/0xe80 [vfio_pci]
  ? _copy_from_user+0x2c/0x60
  ? ksys_ioctl+0x92/0xb0
  ? vfio_pci_memory_lock_and_enable+0x80/0x80 [vfio_pci]
  ksys_ioctl+0x92/0xb0
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x4d/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fbeb0ca2ac7
 Code: Bad RIP value.
 RSP: 002b:00007ffec9254908 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00005617ef8baa70 RCX: 00007fbeb0ca2ac7
 RDX: 00005617ef8baa70 RSI: 0000000000003b6e RDI: 0000000000000038
 RBP: 00005617ef722a30 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000006
 R13: 00005617ef722730 R14: 0000000000000005 R15: 00005617ef721e50
 ---[ end trace fbd9c0c3c859d391 ]---
 irq 17: Affinity broken due to vector space exhaustion.
 vfio-pci 0000:c1:00.0: vfio_ecap_init: hiding ecap 0x19@0x20c
 vfio-pci 0000:c1:00.0: vfio_ecap_init: hiding ecap 0x26@0x238
 vfio-pci 0000:c1:00.0: vfio_ecap_init: hiding ecap 0x27@0x278
 vfio-pci 0000:04:00.0: vfio_bar_restore: reset recovery - restoring BARs
 vfio-pci 0000:04:00.1: vfio_bar_restore: reset recovery - restoring BARs
 vfio-pci 0000:c1:00.0: vfio_bar_restore: reset recovery - restoring BARs
 vfio-pci 0000:c1:00.1: vfio_bar_restore: reset recovery - restoring BARs
 vfio-pci 0000:04:00.0: vfio_bar_restore: reset recovery - restoring BARs
 vfio-pci 0000:04:00.1: vfio_bar_restore: reset recovery - restoring BARs
 vfio-pci 0000:c1:00.0: vfio_bar_restore: reset recovery - restoring BARs
 vfio-pci 0000:c1:00.1: vfio_bar_restore: reset recovery - restoring BARs
 kvm [59978]: vcpu0, guest rIP: 0xffffffff85c75208 disabled perfctr wrmsr: 0xc2 data 0xffff

Thanks,
Daniel
