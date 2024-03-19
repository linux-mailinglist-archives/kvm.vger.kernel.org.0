Return-Path: <kvm+bounces-12129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A83B87FD8D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE0261F23723
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 12:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA277F7E9;
	Tue, 19 Mar 2024 12:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="b2JW1wDa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186687F7C8
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 12:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710851379; cv=none; b=GONqUWr/lDYh9ESVkXoZ0n+2umfsdXkAwhxEg6OUPtz00sEH3DylmbbNHqyp44n5y0pow5Rn6wS/WKG2rtOXDkwUl2VmquJV+pjFP5Wd9Je7vARZcSMTEr84nqLbw2Ockr3g7czkp+bBc+UMpMmYgoW/3PCUakk+Mm27F7BHXmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710851379; c=relaxed/simple;
	bh=r7LQvPSbTVcUADe+MFtzy5TaJbb3VOdeiXAzNHTbuxk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F24xmwyzfm+C8wdXrI5aPgJlc9Vtc28nqAxPxDD1g/kksqZFsoJh3z+0KLgh5S+IXoD4tOYsAf1/SyfE+Vhp9TCb3iXZr5Kg7TJmUU8X+5KyOHzW5GD8QCUnhwf2r8r7wIHASD2z34+IPHkephsArrzCOM+KAjCPpwNLY+fSimo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=b2JW1wDa; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d23114b19dso66835241fa.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 05:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1710851374; x=1711456174; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9hKCYDSzXyqAgTbSXm0uyTkE4NDjKRN02YkqXSTPPE=;
        b=b2JW1wDayxMikZ/qJszM18V5cui/tecfzu11lbhy2SBXYjzDnbufv/LxdpWbYBoVDz
         r/2EBETBwnJqrSD3iI70xRV3ZPSlqOS673A/PL2BjJgh0SPu5zHjszmEgJQdTo8zZ0y0
         hvUXraNF+pcXf4pPtragmojrfPNU4q6A7ubu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710851374; x=1711456174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S9hKCYDSzXyqAgTbSXm0uyTkE4NDjKRN02YkqXSTPPE=;
        b=WUOCwcYKVsI81qf9UUtnBpUOpoT7RxfqKGntioUC9xbt2+4lvSSiEXpir7Kjz/mB9X
         2nluEfmWGpZn8hwKbgW5XAY7wSR10oQOVALSTgSWZanhvAtjvKfxLY1iZtV3scbfXXs6
         wwJK8yMIS3hcrwTI6SAdWDz39gkjQ9axB1TdFhujTzJzUUmnjZaJYy3vgZEIhN6Hjh4Z
         vrieUX8fctyDddoemw1GMY289v76Cq7uTdwK4rqpZ9MSGOql5nLAmLHdZpImNZEEK9B3
         P4hpwKXkmfTiJIPJOvt3rr4KT8HaD8pvOSuLG/jpSjxZRIxmvFVzDSATjW7IxXJetjbx
         BPAg==
X-Gm-Message-State: AOJu0YxGqEu2WTO4rcZd29hgOXxarimVicqAYR+/e/ER6EX1zyyEuRZB
	CCnyAzSOmqg5Ln7hqxivVJ2rHlTksYyjEPz0mpid+Zk/8NbBhQ3NZbcOaQ4eEUFje9AW8X2VSkq
	FRRX52zojFoz/7Ko6RCAp7Yy1mnI8Afayp6tulxJpGz0U8SMuUFey
X-Google-Smtp-Source: AGHT+IF94iynmBXpU9wTklLZ6UhQkCL1JEqJVFqbFF4TC/0qk21TwJn2uH3hjeOoLJo5WVgYH1M+zF4elaEuDFVnywc=
X-Received: by 2002:a2e:a68d:0:b0:2d4:57c5:886c with SMTP id
 q13-20020a2ea68d000000b002d457c5886cmr8268471lje.13.1710851373851; Tue, 19
 Mar 2024 05:29:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
In-Reply-To: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
From: Igor Raits <igor@gooddata.com>
Date: Tue, 19 Mar 2024 13:29:22 +0100
Message-ID: <CA+9S74izRjDRb1DLOcpeju4kS=6O9zm6bbCksKABtwfu68PPYw@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org
Cc: Stefano Garzarella <sgarzare@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello again,

On Tue, Mar 19, 2024 at 10:00=E2=80=AFAM Igor Raits <igor@gooddata.com> wro=
te:
>
> Hello,
>
> We have started to observe kernel crashes on 6.7.y kernels (atm we
> have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where we
> have nodes of cluster it looks stable. Please see stacktrace below. If
> you need more information please let me know.

We have tried to downgrade to 6.6.y (6.6.9 in this case) and it looks
like we get a slightly different crash but maybe in a similar
direction.

[  906.338157] usercopy: Kernel memory exposure attempt detected from
SLUB object 'skbuff_head_cache' (offset 2, size 3006)!
[  906.349149] ------------[ cut here ]------------
[  906.353785] kernel BUG at mm/usercopy.c:102!
[  906.358081] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[  906.363314] CPU: 62 PID: 9143 Comm: vhost-9119 Tainted: G
 E      6.6.9-2.gdc.el9.x86_64 #1
[  906.372541] Hardware name: Dell Inc. PowerEdge R7525/0H3K7P, BIOS
2.14.1 12/17/2023
[  906.380209] RIP: 0010:usercopy_abort+0x6a/0x80
[  906.384665] Code: 61 78 af 50 48 c7 c2 62 61 78 af 57 48 c7 c7 28
df 79 af 48 0f 44 d6 48 c7 c6 88 df 79 af 4c 89 d1 49 0f 44 f3 e8 f6
f1 d5 ff <0f> 0b 49 c7 c1 d0 40 7b af 4c 89 cf 4d 89 c8 eb a9 0f 1f 44
00 00
[  906.403419] RSP: 0018:ffffc9000fdb3b58 EFLAGS: 00010246
[  906.408662] RAX: 000000000000006d RBX: 0000000000000002 RCX: 00000000000=
00000
[  906.415802] RDX: 0000000000000000 RSI: ffff88c05fb9f700 RDI: ffff88c05fb=
9f700
[  906.422941] RBP: 0000000000000bbe R08: 0000000000000000 R09: 00000000fff=
f7fff
[  906.430077] R10: ffffc9000fdb3a10 R11: ffffffffb01e26a8 R12: ffff889881b=
6bd40
[  906.437214] R13: 0000000000000001 R14: 0000000000000002 R15: ffff889069f=
adee0
[  906.444348] FS:  00007f4552ca3f80(0000) GS:ffff88c05fb80000(0000)
knlGS:0000000000000000
[  906.452523] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  906.458276] CR2: 00007f7bc42f3000 CR3: 0000003878eb6006 CR4: 00000000007=
70ee0
[  906.465408] PKRU: 55555554
[  906.468118] Call Trace:
[  906.470570]  <TASK>
[  906.472680]  ? die+0x33/0x90
[  906.475572]  ? do_trap+0xe0/0x110
[  906.478892]  ? usercopy_abort+0x6a/0x80
[  906.482733]  ? do_error_trap+0x65/0x80
[  906.486484]  ? usercopy_abort+0x6a/0x80
[  906.490323]  ? exc_invalid_op+0x4e/0x70
[  906.494163]  ? usercopy_abort+0x6a/0x80
[  906.498003]  ? asm_exc_invalid_op+0x16/0x20
[  906.502188]  ? usercopy_abort+0x6a/0x80
[  906.506026]  ? usercopy_abort+0x6a/0x80
[  906.509866]  __check_heap_object+0xd5/0x110
[  906.514056]  __check_object_size.part.0+0x5e/0x140
[  906.518853]  simple_copy_to_iter+0x26/0x50
[  906.522958]  __skb_datagram_iter+0x199/0x2e0
[  906.527235]  ? __pfx_simple_copy_to_iter+0x10/0x10
[  906.532028]  skb_copy_datagram_iter+0x33/0x90
[  906.536389]  tun_put_user.constprop.0+0x16b/0x370 [tun]
[  906.541624]  tun_do_read+0x54/0x1f0 [tun]
[  906.545646]  tun_recvmsg+0x7e/0x160 [tun]
[  906.549667]  handle_rx+0x3ab/0x750 [vhost_net]
[  906.554123]  vhost_worker+0x42/0x70 [vhost]
[  906.558314]  vhost_task_fn+0x4b/0xb0
[  906.561903]  ? finish_task_switch.isra.0+0x8f/0x2a0
[  906.566788]  ? __pfx_vhost_task_fn+0x10/0x10
[  906.571073]  ? __pfx_vhost_task_fn+0x10/0x10
[  906.575351]  ret_from_fork+0x2d/0x50
[  906.578937]  ? __pfx_vhost_task_fn+0x10/0x10
[  906.583219]  ret_from_fork_asm+0x1b/0x30
[  906.587152]  </TASK>
[  906.589340] Modules linked in: nf_conntrack_netlink(E) vhost_net(E)
vhost(E) vhost_iotlb(E) tap(E) tun(E) rpcsec_gss_krb5(E)
auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E)
fscache(E) netfs(E) netconsole(E) ib_core(E) scsi_transport_iscsi(E)
sch_ingress(E) target_core_user(E) uio(E) target_core_pscsi(E)
target_core_file(E) target_core_iblock(E) iscsi_target_mod(E)
target_core_mod(E) 8021q(E) garp(E) mrp(E) bonding(E) tls(E)
nfnetlink_cttimeout(E) nfnetlink(E) openvswitch(E) nf_conncount(E)
nf_nat(E) binfmt_misc(E) dell_rbu(E) sunrpc(E) vfat(E) fat(E)
dm_service_time(E) dm_multipath(E) btrfs(E) intel_rapl_msr(E)
intel_rapl_common(E) xor(E) zstd_compress(E) ipmi_ssif(E) raid6_pq(E)
amd64_edac(E) edac_mce_amd(E) kvm_amd(E) kvm(E) dell_smbios(E)
irqbypass(E) acpi_ipmi(E) dcdbas(E) dell_wmi_descriptor(E) wmi_bmof(E)
ipmi_si(E) acpi_cpufreq(E) rapl(E) ipmi_devintf(E) ptdma(E) wmi(E)
i2c_piix4(E) k10temp(E) ipmi_msghandler(E) acpi_power_meter(E) fuse(E)
drm(E) zram(E) ext4(E) mbcache(E) jbd2(E) dm_crypt(E)
[  906.589385]  sd_mod(E) t10_pi(E) sg(E) crct10dif_pclmul(E)
crc32_pclmul(E) polyval_clmulni(E) ahci(E) polyval_generic(E)
ghash_clmulni_intel(E) libahci(E) ice(E) sha512_ssse3(E) libata(E)
ccp(E) megaraid_sas(E) gnss(E) sp5100_tco(E) dm_mirror(E)
dm_region_hash(E) dm_log(E) dm_mod(E) nf_conntrack(E) libcrc32c(E)
crc32c_intel(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) br_netfilter(E)
bridge(E) stp(E) llc(E)
[  906.679233] Unloaded tainted modules: fjes(E):2
[  906.719287] ---[ end trace 0000000000000000 ]---

> We do not have a consistent reproducer but when we put some bigger
> network load on a VM, the hypervisor's kernel crashes.
>
> Help is much appreciated! We are happy to test any patches.
>
> [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
>    E      6.7.10-1.gdc.el9.x86_64 #1
> [62254.183743] Hardware name: Dell Inc. PowerEdge R7525/0H3K7P, BIOS
> 2.14.1 12/17/2023
> [62254.192083] RIP: 0010:skb_release_data+0xb8/0x1e0
> [62254.197357] Code: 48 83 c3 01 39 d8 7e 54 48 89 d8 48 c1 e0 04 41
> 80 7d 7e 00 49 8b 6c 04 30 79 0f 44 89 f6 48 89 ef e8 4c e4 ff ff 84
> c0 75 d0 <48> 8b 45 08 a8 01 0f 85 09 01 00 00 e9 d9 00 00 00 0f 1f 44
> 00 00
> [62254.217013] RSP: 0018:ffffa975a0247ba8 EFLAGS: 00010206
> [62254.222692] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000=
0000785
> [62254.230263] RDX: 0000000000000016 RSI: 0000000000000002 RDI: ffff98986=
2b32b00
> [62254.237878] RBP: 4f2b318c69a8b0f9 R08: 000000000001fe4d R09: 000000000=
000003a
> [62254.245417] R10: 0000000000000000 R11: 0000000000001736 R12: ffff9880b=
819aec0
> [62254.252963] R13: ffff989862b32b00 R14: 0000000000000000 R15: 000000000=
0000002
> [62254.260591] FS:  00007f6cf388bf80(0000) GS:ffff98b85fbc0000(0000)
> knlGS:0000000000000000
> [62254.269061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [62254.275170] CR2: 000000c002236020 CR3: 000000387d37a002 CR4: 000000000=
0770ef0
> [62254.282733] PKRU: 55555554
> [62254.285911] Call Trace:
> [62254.288884]  <TASK>
> [62254.291549]  ? die+0x33/0x90
> [62254.294769]  ? do_trap+0xe0/0x110
> [62254.298405]  ? do_error_trap+0x65/0x80
> [62254.302471]  ? exc_stack_segment+0x35/0x50
> [62254.306884]  ? asm_exc_stack_segment+0x22/0x30
> [62254.311637]  ? skb_release_data+0xb8/0x1e0
> [62254.316047]  kfree_skb_list_reason+0x6d/0x210
> [62254.320697]  ? free_unref_page_commit+0x80/0x2f0
> [62254.325700]  ? free_unref_page+0xe9/0x130
> [62254.330013]  skb_release_data+0xfc/0x1e0
> [62254.334261]  consume_skb+0x45/0xd0
> [62254.338077]  tun_do_read+0x68/0x1f0 [tun]
> [62254.342414]  tun_recvmsg+0x7e/0x160 [tun]
> [62254.346696]  handle_rx+0x3ab/0x750 [vhost_net]
> [62254.351488]  vhost_worker+0x42/0x70 [vhost]
> [62254.355934]  vhost_task_fn+0x4b/0xb0
> [62254.359758]  ? finish_task_switch.isra.0+0x8f/0x2a0
> [62254.364882]  ? __pfx_vhost_task_fn+0x10/0x10
> [62254.369390]  ? __pfx_vhost_task_fn+0x10/0x10
> [62254.373888]  ret_from_fork+0x2d/0x50
> [62254.377687]  ? __pfx_vhost_task_fn+0x10/0x10
> [62254.382169]  ret_from_fork_asm+0x1b/0x30
> [62254.386310]  </TASK>
> [62254.388705] Modules linked in: nf_tables(E) nf_conntrack_netlink(E)
> vhost_net(E) vhost(E) vhost_iotlb(E) tap(E) tun(E) mptcp_diag(E)
> xsk_diag(E) udp_diag(E) raw_diag(E) unix_diag(E) af_packet_diag(E)
> netlink_diag(E) tcp_diag(E) inet_diag(E) rpcsec_gss_krb5(E)
> auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E)
> fscache(E) netfs(E) netconsole(E) ib_core(E) scsi_transport_iscsi(E)
> sch_ingress(E) target_core_user(E) uio(E) target_core_pscsi(E)
> target_core_file(E) target_core_iblock(E) iscsi_target_mod(E)
> target_core_mod(E) 8021q(E) garp(E) mrp(E) bonding(E) tls(E)
> nfnetlink_cttimeout(E) nfnetlink(E) openvswitch(E) nf_conncount(E)
> nf_nat(E) binfmt_misc(E) dell_rbu(E) sunrpc(E) vfat(E) fat(E)
> dm_service_time(E) dm_multipath(E) btrfs(E) xor(E) zstd_compress(E)
> raid6_pq(E) ipmi_ssif(E) intel_rapl_msr(E) intel_rapl_common(E)
> amd64_edac(E) edac_mce_amd(E) kvm_amd(E) kvm(E) irqbypass(E)
> dell_smbios(E) acpi_ipmi(E) dcdbas(E) dell_wmi_descriptor(E)
> wmi_bmof(E) rapl(E) ipmi_si(E) acp
> Mar 19 09:40:16 10.12.17.70 i_cpufreq(E) ipmi_devintf(E)
> [62254.388751]  mgag200(E) i2c_algo_bit(E) ptdma(E) wmi(E)
> i2c_piix4(E) k10temp(E) ipmi_msghandler(E) acpi_power_meter(E) fuse(E)
> zram(E) ext4(E) mbcache(E) jbd2(E) dm_crypt(E) sd_mod(E) t10_pi(E)
> sg(E) ice(E) crct10dif_pclmul(E) crc32_pclmul(E) polyval_clmulni(E)
> polyval_generic(E) ahci(E) libahci(E) ghash_clmulni_intel(E)
> sha512_ssse3(E) libata(E) megaraid_sas(E) ccp(E) gnss(E) sp5100_tco(E)
> dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) nf_conntrack(E)
> libcrc32c(E) crc32c_intel(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E)
> br_netfilter(E) bridge(E) stp(E) llc(E)
> [62254.480070] Unloaded tainted modules: fjes(E):2 padlock_aes(E):3
> [62254.537711] ---[ end trace 0000000000000000 ]---
>
> Thanks in advance!

