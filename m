Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF8E43B0AB
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 12:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhJZLBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 07:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbhJZLBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 07:01:06 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD5DC061745
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 03:58:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id m17so883618edc.12
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 03:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=2CwshnLyT7soRqqQ/6NdE8DOazTjQx6z/KLh69YpPFo=;
        b=eXwoOrVumnqD+WS5P54iPInKPs5RUOQ+2JLY+AxfgP/F/Qzw/RZqmFY50/zXknKVwh
         Vv5lu00Ook97eCqyiqJZjufB4O4VWXnkKUTky+De8w2Amkl+Rargpl0Wvsl/3PKEESqV
         Vr6R9glXmTv60eZJWMTT9V9ZeI+OTMLL0nWPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=2CwshnLyT7soRqqQ/6NdE8DOazTjQx6z/KLh69YpPFo=;
        b=ib2qfalY+OOnDfv7C54psfEhYp6kQVisxZpN6HfhBn4Si5DHjuoi6K0VDA4jH7SMaz
         5KuqbAAM0c6LY3S7bOeITnWSWa4USNV8RtBwMBgE17xV6Q0WrU+QbqKykcvTlYZm6z6h
         TBEcN/s+ACFYd0C7eVZGBPsZona4KIChk+OIHLrkUOlOFMxmfGnDHxwI4xVPqsnuRLgr
         oNu5+Le9NUnCyt39sg6TUd7Z0JZXu2zJy/hEB0J6h1SzR4p//lHeX44GjwGOMA7X46xW
         shOw/IQzyKHtwXHfax2/G8d6U1dPrjaAFgnfdVrPx1VeYRzTCqne+/6bw8DK0b6e4/rt
         0chw==
X-Gm-Message-State: AOAM532d84G0gsHqllv8UXWlA6OkLlR4yRIZK9sR0KpMfjN108clQb5l
        CUORH9BA+ajDAXT9Lq1QpMVZBjwoVia3mK7behMGtwgi3UeEq4/k
X-Google-Smtp-Source: ABdhPJykivbmiOJxen6Oupw5c6cTlV7s3VdM5QxICWzCnXr2/yrwFXv+Vi8E9kqoxy6WI+wyykWx1b/tmtHpwY9zlnY=
X-Received: by 2002:a05:6402:270b:: with SMTP id y11mr35844849edd.116.1635245920743;
 Tue, 26 Oct 2021 03:58:40 -0700 (PDT)
MIME-Version: 1.0
From:   Igor Raits <igor@gooddata.com>
Date:   Tue, 26 Oct 2021 12:58:30 +0200
Message-ID: <CA+9S74i+1aY=yf8MZ9MD1osuAfhuL-Vf71vUGs9HmsJULJH8fQ@mail.gmail.com>
Subject: WARNING: stack recursion on stack type 5
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello to everyone on MM + KVM lists,

We've hit some weird issue that causes kernel panic (both on physical
hardware and on KVM with similar symptoms). The all share in common
something like:

=E2=80=A6
WARNING: stack recursion on stack type 5
traps: PANIC: double fault, error_code: 0x0
=E2=80=A6

So far this has happened to us on 5.13.12/5.14.9 kernels on physical
machines whilst VMs have had 5.10.52 one (but it is hard to say if it
was fixed on later versions because we are continuously doing the
upgrades and we don't have any specific reproducer for this issue, it
just happens=E2=80=A6 sometimes=E2=80=A6). Moreover, an interesting fact is=
 that it
has happened multiple times but only on the
VMs/servers-that-were-hosting-VMs with Vertica DB running there - that
one, however, does not have any kernel modules which would mean
userspace is somehow able to crash kernel which is not nice. Sadly we
did not make dumps of the KVM guest when the kernel panic'ed there
because of some reasons so I guess logs from the journal is everything
we got.

I would be very grateful if anybody has any idea whether this bug is
already fixed or in which kernel subsystem it is. Happy to try out
some patches. Stack traces are following=E2=80=A6

The panic on the server looks like this:

[331579.116650] BUG: kernel NULL pointer dereference, address: 000000000000=
0820
[331579.123773] #PF: supervisor read access in kernel mode
[331579.129050] #PF: error_code(0x0000) - not-present page
[331579.134325] PGD 0 P4D 0
[331579.136979] Thread overran stack, or stack corrupted
[331579.142073] Oops: 0000 [#1] SMP NOPTI
[331579.145861] CPU: 10 PID: 191747 Comm: CPU 14/KVM Tainted: G
    E     5.14.9-1.gdc.el8.x86_64 #1
[331579.155414] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
Gen10, BIOS U30 07/08/2021
[331579.164093] RIP: 0010:0xffffffff8a1ababa
[331579.168150] Code: Unable to access opcode bytes at RIP 0xffffffff8a1aba=
90.
[331579.175170] RSP: 0018:fffffe000021ba70 EFLAGS: 00010087
[331579.180533] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffffff8a200fb7
[331579.187814] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
fffffe000021ba98
[331579.195092] RBP: fffffe000021ba98 R08: 0000000000000000 R09:
0000000000000000
[331579.202368] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[331579.209648] R13: 0000000000000000 R14: 0000000000000820 R15:
0000000000000000
[331579.216927] FS:  00007f2b427fc700(0000) GS:ffff97bd3fa80000(0000)
knlGS:0000000000000000
[331579.225168] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[331579.231047] CR2: ffffffff8a1aba90 CR3: 0000005f71e02003 CR4:
00000000007726e0
[331579.238328] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[331579.245610] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[331579.252891] PKRU: 55555554
[331579.255715] Call Trace:
[331579.258279]  <#DF>
[331579.260410]  </#DF>
[331579.262623] WARNING: stack recursion on stack type 5
[331579.262628] Modules linked in: nf_conntrack_netlink(E)
target_core_user(E) uio(E) target_core_pscsi(E) target_core_file(E)
target_core_iblock(E) ebt_arp(E) nft_meta_bridge(E) ip6_tables(E)
xt_CT(E) nft_limit(E) nft_counter(E) xt_LOG(E) nf_log_syslog(E)
xt_limit(E) xt_mac(E) xt_set(E) xt_state(E) xt_conntrack(E)
xt_comment(E) xt_physdev(E) nft_compat(E) ip_set_hash_net(E) ip_set(E)
vhost_net(E) vhost(E) vhost_iotlb(E) tap(E) tun(E) mptcp_diag(E)
xsk_diag(E) raw_diag(E) unix_diag(E) af_packet_diag(E) netlink_diag(E)
tcp_diag(E) udp_diag(E) inet_diag(E) netconsole(E) nf_tables(E)
vxlan(E) ip6_udp_tunnel(E) udp_tunnel(E) nfnetlink(E) binfmt_misc(E)
8021q(E) garp(E) mrp(E) bonding(E) tls(E) vfat(E) fat(E)
dm_service_time(E) dm_multipath(E) rpcrdma(E) sunrpc(E) rdma_ucm(E)
ib_srpt(E) ib_isert(E) iscsi_target_mod(E) target_core_mod(E)
ib_iser(E) rdma_cm(E) iw_cm(E) ib_cm(E) libiscsi(E)
scsi_transport_iscsi(E) intel_rapl_msr(E) qedr(E) ib_uverbs(E)
intel_rapl_common(E) ib_core(E)
[331579.267779]  isst_if_common(E) nfit(E) libnvdimm(E) ipmi_ssif(E)
x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E)
kvm(E) irqbypass(E) acpi_ipmi(E) crct10dif_pclmul(E) crc32_pclmul(E)
ghash_clmulni_intel(E) rapl(E) ses(E) ipmi_si(E) intel_cstate(E)
dm_mod(E) mei_me(E) ipmi_devintf(E) intel_uncore(E) pcspkr(E)
ioatdma(E) enclosure(E) qede(E) tg3(E) mei(E) hpwdt(E) hpilo(E)
lpc_ich(E) intel_pch_thermal(E) dca(E) ipmi_msghandler(E)
acpi_power_meter(E) nf_conntrack(E) nf_defrag_ipv6(E)
nf_defrag_ipv4(E) libcrc32c(E) br_netfilter(E) bridge(E) stp(E) llc(E)
ext4(E) mbcache(E) jbd2(E) sd_mod(E) t10_pi(E) sg(E) qedf(E) qed(E)
crc8(E) libfcoe(E) libfc(E) smartpqi(E) crc32c_intel(E)
scsi_transport_fc(E) scsi_transport_sas(E) wmi(E)
[331579.420574] CR2: 0000000000000820
[331579.424038] ---[ end trace 75260ea1aff57072 ]---
[331579.548582] RIP: 0010:0xffffffff8a1ababa
[331579.552642] Code: Unable to access opcode bytes at RIP 0xffffffff8a1aba=
90.
[331579.559659] RSP: 0018:fffffe000021ba70 EFLAGS: 00010087
[331579.565021] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffffff8a200fb7
[331579.572302] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
fffffe000021ba98
[331579.579590] RBP: fffffe000021ba98 R08: 0000000000000000 R09:
0000000000000000
[331579.586872] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[331579.594149] R13: 0000000000000000 R14: 0000000000000820 R15:
0000000000000000
[331579.601429] FS:  00007f2b427fc700(0000) GS:ffff97bd3fa80000(0000)
knlGS:0000000000000000
[331579.609670] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[331579.615552] CR2: ffffffff8a1aba90 CR3: 0000005f71e02003 CR4:
00000000007726e0
[331579.622832] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[331579.630110] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[331579.637389] PKRU: 55555554
[331579.640213] Kernel panic - not syncing: Fatal exception
[331579.700548] Kernel Offset: 0x34e00000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[331579.815731] ---[ end Kernel panic - not syncing: Fatal exception ]---

And on the VM (they don't panic at once, just either KVM guest OR server):

[1192381.360099] WARNING: stack recursion on stack type 5
[1192381.360134] traps: PANIC: double fault, error_code: 0x0
[1192381.360135] double fault: 0000 [#1] SMP NOPTI
[1192381.360136] CPU: 12 PID: 264465 Comm: vertica Tainted: G
  E     5.10.52-1.el7.gdc.x86_64 #1
[1192381.360136] Hardware name: RDO OpenStack Compute/RHEL-AV, BIOS
1.14.0-1.el8s 04/01/2014
[1192381.360137] RIP: 0010:error_entry+0x11/0xe0
[1192381.360138] Code: ff ff 0f 01 f8 e9 ff fd ff ff 66 66 2e 0f 1f 84
00 00 00 00 00 0f 1f 40 00 fc 56 48 8b 74 24 08 48 89 7c 24 08 52 51
50 41 50 <41> 51 41 52 41 53 53 55 41 54 41 55 41 56 41 57 56 31 d2 31
c9 45
[1192381.360139] RSP: 0000:fffffe0000285000 EFLAGS: 00010093
[1192381.360140] RAX: 00000000ad600fb7 RBX: 0000000000000000 RCX:
ffffffffad600fb7
[1192381.360141] RDX: 0000000000000000 RSI: ffffffffad600ab8 RDI:
fffffe0000285088
[1192381.360141] RBP: fffffe0000285088 R08: 0000000000000000 R09:
0000000000000000
[1192381.360142] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[1192381.360142] R13: 0000000000000000 R14: ffff9ed6ffb16f40 R15:
0000000000000000
[1192381.360143] FS:  00007f2ea5bfb700(0000) GS:ffff8ba9a7900000(0000)
knlGS:0000000000000000
[1192381.360143] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1192381.360144] CR2: fffffe0000284ff8 CR3: 0000000104208006 CR4:
0000000000770ee0
[1192381.360144] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[1192381.360145] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[1192381.360145] PKRU: 55555554
[1192381.360146] Call Trace:
[1192381.360146]  <#DF>
[1192381.360146]  ? native_iret+0x7/0x7
[1192381.360147]  ? exc_page_fault+0x11/0x110
[1192381.360147]  ? asm_exc_page_fault+0x1e/0x30
[1192381.360148]  ? native_iret+0x7/0x7
[1192381.360148]  ? exc_page_fault+0x11/0x110
[1192381.360148]  ? asm_exc_page_fault+0x1e/0x30
[1192381.360149]  ? native_iret+0x7/0x7
[1192381.360149]  ? exc_page_fault+0x11/0x110
[1192381.360150]  ? asm_exc_page_fault+0x1e/0x30
[1192381.360150]  ? native_iret+0x7/0x7
[1192381.360151]  ? exc_page_fault+0x11/0x110
[1192381.360151]  ? asm_exc_page_fault+0x1e/0x30
[1192381.360151]  ? native_iret+0x7/0x7
[1192381.360152]  ? exc_page_fault+0x11/0x110
[1192381.360152]  ? asm_exc_page_fault+0x1e/0x30
[1192381.360152]  ? native_iret+0x7/0x7
[1192381.360153]  ? exc_page_fault+0x11/0x110
[1192381.360153]  ? asm_exc_page_fault+0x1e/0x30
[1192381.360153]  ? native_iret+0x7/0x7
[1192381.360154]  ? exc_page_fault+0x11/0x110
[1192381.360154]  ? asm_exc_page_fault+0x1e/0x30
[1192381.360155]  ? native_iret+0x7/0x7
[1192381.360155]  ? exc_page_fault+0x11/0x110
[1192381.360155]  ? asm_exc_page_fault+0x1e/0x30
[1192381.360156]  ? vsnprintf+0x368/0x4f0
[1192381.360156]  ? sprintf+0x56/0x70
[1192381.360157]  ? kallsyms_lookup+0x91/0x100
[1192381.360157]  ? __sprint_symbol+0xd4/0x100
[1192381.360157]  ? symbol_string+0x57/0x90
[1192381.360158]  ? symbol_string+0x57/0x90
[1192381.360158]  ? vsnprintf+0x3aa/0x4f0
[1192381.360158]  ? vsnprintf+0x3aa/0x4f0
[1192381.360159]  ? irq_work_queue+0xa/0x20
[1192381.360159]  ? printk_safe_log_store+0xc6/0xe0
[1192381.360159]  ? printk+0x58/0x6f
[1192381.360160]  ? __module_text_address+0xe/0x60
[1192381.360160]  ? kernel_text_address+0xe9/0xf0
[1192381.360161]  ? __kernel_text_address+0xe/0x30
[1192381.360161]  ? show_trace_log_lvl+0x1b4/0x315
[1192381.360161]  ? show_trace_log_lvl+0x1b4/0x315
[1192381.360161]  ? __die_body+0x1b/0x60
[1192381.360162]  ? die+0x2b/0x50
[1192381.360162]  ? exc_double_fault+0x119/0x130
[1192381.360162]  ? asm_exc_double_fault+0x1e/0x30
[1192381.360163]  ? native_iret+0x7/0x7
[1192381.360163]  ? asm_exc_page_fault+0x8/0x30
[1192381.360163]  ? error_entry+0x11/0xe0
[1192381.360164]  </#DF>
[1192381.360164] Modules linked in: raw_diag(E) unix_diag(E)
af_packet_diag(E) netlink_diag(E) ip6table_filter(E) ip6_tables(E)
iptable_filter(E) udp_diag(E) tcp_diag(E) inet_diag(E)
nfs_layout_nfsv41_files(E) rpcsec_gss_krb5(E) auth_rpcgss(E) nfsv4(E)
dns_resolver(E) nfs(E) lockd(E) grace(E) nfs_ssc(E) fscache(E)
binfmt_misc(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E)
libcrc32c(E) intel_rapl_msr(E) intel_rapl_common(E) nls_utf8(E)
isst_if_common(E) isofs(E) nfit(E) libnvdimm(E) kvm_intel(E) kvm(E)
irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E)
ghash_clmulni_intel(E) rapl(E) cirrus(E) iTCO_wdt(E)
iTCO_vendor_support(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E)
sysimgblt(E) fb_sys_fops(E) i2c_i801(E) pcspkr(E) sg(E) drm(E)
lpc_ich(E) i2c_smbus(E) virtio_balloon(E) ip_tables(E) ext4(E)
mbcache(E) jbd2(E) sr_mod(E) cdrom(E) ahci(E) libahci(E) libata(E)
crc32c_intel(E) serio_raw(E) virtio_net(E) net_failover(E)
virtio_blk(E) failover(E) sunrpc(E)
[1192381.454392] ---[ end trace f00a949c91d9714d ]---
[1192381.454393] RIP: 0010:error_entry+0x11/0xe0
[1192381.454394] Code: ff ff 0f 01 f8 e9 ff fd ff ff 66 66 2e 0f 1f 84
00 00 00 00 00 0f 1f 40 00 fc 56 48 8b 74 24 08 48 89 7c 24 08 52 51
50 41 50 <41> 51 41 52 41 53 53 55 41 54 41 55 41 56 41 57 56 31 d2 31
c9 45
[1192381.454394] RSP: 0000:fffffe0000285000 EFLAGS: 00010093
[1192381.454396] RAX: 00000000ad600fb7 RBX: 0000000000000000 RCX:
ffffffffad600fb7
[1192381.454396] RDX: 0000000000000000 RSI: ffffffffad600ab8 RDI:
fffffe0000285088
[1192381.454397] RBP: fffffe0000285088 R08: 0000000000000000 R09:
0000000000000000
[1192381.454398] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[1192381.454398] R13: 0000000000000000 R14: ffff9ed6ffb16f40 R15:
0000000000000000
[1192381.454399] FS:  00007f2ea5bfb700(0000) GS:ffff8ba9a7900000(0000)
knlGS:0000000000000000
[1192381.454400] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1192381.454400] CR2: fffffe0000284ff8 CR3: 0000000104208006 CR4:
0000000000770ee0
[1192381.454401] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[1192381.454402] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[1192381.454402] PKRU: 55555554
[1192381.454403] Kernel panic - not syncing: Fatal exception in interrupt
[1192381.454559] Kernel Offset: 0x2bc00000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Thanks in advance,
Igor.
