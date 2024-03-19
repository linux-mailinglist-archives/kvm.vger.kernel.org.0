Return-Path: <kvm+bounces-12115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8158F87FA3E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 10:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FCD41F2203E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386B87CF07;
	Tue, 19 Mar 2024 09:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="Q+V2F3gu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BA87C092
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 09:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710838824; cv=none; b=qY4TvyF6Iq01V27EPphHB0/xseVKOsX/zwXTzMEjSDY6wfoQYFcSEsaP+NZSSXtLaCQuEPn/ZoApy0fW7o93wCCR49/6oJJUZOgWEwFQUyMOPzQhpgcFukUZxLuiANEClymL6N2DIjBF3FTBGDKT80KHBkdcXNJGlRB2EFqGY7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710838824; c=relaxed/simple;
	bh=LYZBi+bUQakFekCjRxf78pErckbW983ar7dUR9YXSYU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=RV23Y5ZY+UgM6IQn/BMMuUI68qaffnnMV8SbYLY+SekZBQXpY40CmFZdzkbbWs6T0L7bvemku9/kXs50astZ6j5Q1OfW1/s32ZXHjJ77q1l6mDAVQFLPcAkbjSG4ZXrTYh5jfLcktgN8xlJNhsgKg9KTMllt1bPpHBo8W+syGEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=Q+V2F3gu; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d220e39907so76170791fa.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 02:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1710838819; x=1711443619; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7WRXNz8lUy0QV9/Mo1M3xURlEYVlBAf//6FRdDs8S4U=;
        b=Q+V2F3gu70TALyVuEdiRcmgpZAM/vSHwlhw9d1i83Mx0MGjZo7iT3J57xljEvY6RZA
         TpT9GBUywr+W7WmjCQI6ZA9qJs/q9X9H9dey+rjyOxskRz9AL6jIzzNvf4eyIs64tfWk
         MA5ifEg68aVK0HMxwBsmMHHPYj5MH5LbIgX4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710838819; x=1711443619;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7WRXNz8lUy0QV9/Mo1M3xURlEYVlBAf//6FRdDs8S4U=;
        b=ZKkOi13QaUc6RYwxjdO0ECQrM3ZlpdrsfatauHreMiQrw3dzsy1v4euwSFIYZZHAjd
         k6roCUhpdXsRV90tNNB21gNIS+JzBfFq25exYL3hilRPByWvExUtSGssg2RhD9ayabY8
         HLhSDkKCpCy6VflaHHY18NtZWF5z3loLYzqU3XV6wOjfiMZ6Skbw9+oxoPVeK9b8yVSn
         0h6esW5q5XcCOWZjy/0V6K1AryJEWnI+O/3abg+LupVcfh51iADhJHKW3wsY1fBD9TCO
         KyQA0i2qfIC63632wNZf87ZhsKp9x+DPuf2NNptl1yVnm2NpiWmuJRzbb2+miPQAwEsi
         J/Bw==
X-Gm-Message-State: AOJu0YzTxZC5EDyuYmo+iR8t/N9fcvvx9V7Hdql+k4i1+0Drni2dbsUw
	bhoeG0/LJydKYrDJMXHt0usztyKeROQqKJax43DSw6W+hdr1hL3dEC9IRfUvdSVExMWJTdpEaD8
	Mv1ZyjceGChGYUmgXCYCUbJrNxwty+hDGdgA6JTCOEevLTtXh9A==
X-Google-Smtp-Source: AGHT+IFs5BUm4uuBapI+f/gOF/bcQhLF0wHkL1zPCcd0XaPcTT0m7DPRL82yKadrmbcnu13Unijcju8bKu9rpDCoJds=
X-Received: by 2002:a2e:a30b:0:b0:2d4:72be:e2c6 with SMTP id
 l11-20020a2ea30b000000b002d472bee2c6mr9584001lje.52.1710838819457; Tue, 19
 Mar 2024 02:00:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Igor Raits <igor@gooddata.com>
Date: Tue, 19 Mar 2024 10:00:08 +0100
Message-ID: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
Subject: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org
Cc: Stefano Garzarella <sgarzare@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

We have started to observe kernel crashes on 6.7.y kernels (atm we
have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where we
have nodes of cluster it looks stable. Please see stacktrace below. If
you need more information please let me know.

We do not have a consistent reproducer but when we put some bigger
network load on a VM, the hypervisor's kernel crashes.

Help is much appreciated! We are happy to test any patches.

[62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
[62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
   E      6.7.10-1.gdc.el9.x86_64 #1
[62254.183743] Hardware name: Dell Inc. PowerEdge R7525/0H3K7P, BIOS
2.14.1 12/17/2023
[62254.192083] RIP: 0010:skb_release_data+0xb8/0x1e0
[62254.197357] Code: 48 83 c3 01 39 d8 7e 54 48 89 d8 48 c1 e0 04 41
80 7d 7e 00 49 8b 6c 04 30 79 0f 44 89 f6 48 89 ef e8 4c e4 ff ff 84
c0 75 d0 <48> 8b 45 08 a8 01 0f 85 09 01 00 00 e9 d9 00 00 00 0f 1f 44
00 00
[62254.217013] RSP: 0018:ffffa975a0247ba8 EFLAGS: 00010206
[62254.222692] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000785
[62254.230263] RDX: 0000000000000016 RSI: 0000000000000002 RDI: ffff989862b32b00
[62254.237878] RBP: 4f2b318c69a8b0f9 R08: 000000000001fe4d R09: 000000000000003a
[62254.245417] R10: 0000000000000000 R11: 0000000000001736 R12: ffff9880b819aec0
[62254.252963] R13: ffff989862b32b00 R14: 0000000000000000 R15: 0000000000000002
[62254.260591] FS:  00007f6cf388bf80(0000) GS:ffff98b85fbc0000(0000)
knlGS:0000000000000000
[62254.269061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[62254.275170] CR2: 000000c002236020 CR3: 000000387d37a002 CR4: 0000000000770ef0
[62254.282733] PKRU: 55555554
[62254.285911] Call Trace:
[62254.288884]  <TASK>
[62254.291549]  ? die+0x33/0x90
[62254.294769]  ? do_trap+0xe0/0x110
[62254.298405]  ? do_error_trap+0x65/0x80
[62254.302471]  ? exc_stack_segment+0x35/0x50
[62254.306884]  ? asm_exc_stack_segment+0x22/0x30
[62254.311637]  ? skb_release_data+0xb8/0x1e0
[62254.316047]  kfree_skb_list_reason+0x6d/0x210
[62254.320697]  ? free_unref_page_commit+0x80/0x2f0
[62254.325700]  ? free_unref_page+0xe9/0x130
[62254.330013]  skb_release_data+0xfc/0x1e0
[62254.334261]  consume_skb+0x45/0xd0
[62254.338077]  tun_do_read+0x68/0x1f0 [tun]
[62254.342414]  tun_recvmsg+0x7e/0x160 [tun]
[62254.346696]  handle_rx+0x3ab/0x750 [vhost_net]
[62254.351488]  vhost_worker+0x42/0x70 [vhost]
[62254.355934]  vhost_task_fn+0x4b/0xb0
[62254.359758]  ? finish_task_switch.isra.0+0x8f/0x2a0
[62254.364882]  ? __pfx_vhost_task_fn+0x10/0x10
[62254.369390]  ? __pfx_vhost_task_fn+0x10/0x10
[62254.373888]  ret_from_fork+0x2d/0x50
[62254.377687]  ? __pfx_vhost_task_fn+0x10/0x10
[62254.382169]  ret_from_fork_asm+0x1b/0x30
[62254.386310]  </TASK>
[62254.388705] Modules linked in: nf_tables(E) nf_conntrack_netlink(E)
vhost_net(E) vhost(E) vhost_iotlb(E) tap(E) tun(E) mptcp_diag(E)
xsk_diag(E) udp_diag(E) raw_diag(E) unix_diag(E) af_packet_diag(E)
netlink_diag(E) tcp_diag(E) inet_diag(E) rpcsec_gss_krb5(E)
auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E)
fscache(E) netfs(E) netconsole(E) ib_core(E) scsi_transport_iscsi(E)
sch_ingress(E) target_core_user(E) uio(E) target_core_pscsi(E)
target_core_file(E) target_core_iblock(E) iscsi_target_mod(E)
target_core_mod(E) 8021q(E) garp(E) mrp(E) bonding(E) tls(E)
nfnetlink_cttimeout(E) nfnetlink(E) openvswitch(E) nf_conncount(E)
nf_nat(E) binfmt_misc(E) dell_rbu(E) sunrpc(E) vfat(E) fat(E)
dm_service_time(E) dm_multipath(E) btrfs(E) xor(E) zstd_compress(E)
raid6_pq(E) ipmi_ssif(E) intel_rapl_msr(E) intel_rapl_common(E)
amd64_edac(E) edac_mce_amd(E) kvm_amd(E) kvm(E) irqbypass(E)
dell_smbios(E) acpi_ipmi(E) dcdbas(E) dell_wmi_descriptor(E)
wmi_bmof(E) rapl(E) ipmi_si(E) acp
Mar 19 09:40:16 10.12.17.70 i_cpufreq(E) ipmi_devintf(E)
[62254.388751]  mgag200(E) i2c_algo_bit(E) ptdma(E) wmi(E)
i2c_piix4(E) k10temp(E) ipmi_msghandler(E) acpi_power_meter(E) fuse(E)
zram(E) ext4(E) mbcache(E) jbd2(E) dm_crypt(E) sd_mod(E) t10_pi(E)
sg(E) ice(E) crct10dif_pclmul(E) crc32_pclmul(E) polyval_clmulni(E)
polyval_generic(E) ahci(E) libahci(E) ghash_clmulni_intel(E)
sha512_ssse3(E) libata(E) megaraid_sas(E) ccp(E) gnss(E) sp5100_tco(E)
dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) nf_conntrack(E)
libcrc32c(E) crc32c_intel(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E)
br_netfilter(E) bridge(E) stp(E) llc(E)
[62254.480070] Unloaded tainted modules: fjes(E):2 padlock_aes(E):3
[62254.537711] ---[ end trace 0000000000000000 ]---

Thanks in advance!

