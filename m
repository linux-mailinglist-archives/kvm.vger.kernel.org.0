Return-Path: <kvm+bounces-12140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D625987FEB4
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46E1A1F245BB
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ACB88004F;
	Tue, 19 Mar 2024 13:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="bkEzRDNl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD4B80025
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 13:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710854565; cv=none; b=oADNCdsQmy/oBu//K2qy2xE5rNKxvVyE1NyKtbH08Pg8YK8apafFnk93EzcOGodZTP0pNsq1WyFw0b5tT2H09DzXc+y+A1j7YZxWSFNf7vLmhBvTtUXRla9zlfZgiSHjc8M4o6nHWkpVB6S4MdEYjD16F6mVX0R14bCD3qJfW2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710854565; c=relaxed/simple;
	bh=ceyUFa+1h2Yidy+EM1QZ0yCy8TdZ3VPzWMPZy8Tcc+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EQemCxPvhTpu1qZ53abnozFn6uJwKlwlUE29ODh/UES61I4RgSGrfvbqOTXoiwJ4pLmOz5QsWhEA1IaIYvqxKXjRSq+HApkhmsSlqO2YoFP1PEK27X2KYYYqoFfFXkWawotiotWjIDwIdUQLCodbnaUxPxIoP5j5OSUHff9sz/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=bkEzRDNl; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d46d729d89so73808671fa.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 06:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1710854561; x=1711459361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mo2rJNvRzcSLBS0OMR24ACous5GRqe0gNI/Yh78X9XM=;
        b=bkEzRDNlByOzNUAmLjsJqEixGnmzAA0gmzgubzW0gkVCAfJLE9BCqenqzSS/opt6jz
         Hhww/iNFol+0arcRgmRKlEvx1Y04EewgtHz3AVHozq+ivi2RARq1TdIWuPn7envGqTF4
         994N4P8+1OucbpbyG//J4qQqS8T4i5AkBo1ao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710854561; x=1711459361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mo2rJNvRzcSLBS0OMR24ACous5GRqe0gNI/Yh78X9XM=;
        b=LbKRyQbjWTZOimOZgKqWK7IhZ2Hra2p+KC+1XDlc5GFhdwMsqUVcZlHpI3otluN2be
         QIibtNPTYQSf/tpbPG4mD0H6/BIQKedIgLCtXEA02W0UYJHuUFNXBDKdteQ/E9jUI5v1
         USrK5KArjmHDWt6I/7izUSe4XB3gSKweI+e7omlG2rIS7wRidE1a7jKJr+G1NivC1LX/
         oDalyzF9t4lqvq2qP85oQ8kB/33JyM3MM7ZItkopR3B/0sZeu0ALG9BbYgYXVkCdGzHR
         Ye9y0QuzgaHbi8LzKLUtk6S8B/WCCZqVYuBN4wY0HVPh27WogsgSE1hU1tO99jNyQIvn
         FW6A==
X-Gm-Message-State: AOJu0YzWO6YzsDk1XkdQwUK7iD9OdutJRwht3CI3XqFlYO4UcTO3UPhd
	kNeUk2RHE8qvcfU+VnIecbsDzTHLtynt5ZEhpfRjatBi8/Vr7Fw2ujxgz5KpQsEXoerJUY7WyFO
	mHYjPGKQIFxgkXrR23ZVmjKiKMW3adKpFl3iT
X-Google-Smtp-Source: AGHT+IEJRFpGVRuilAPbB0KAykXFZONq+dwYfKvbD6SIn4UJNJBMOctoDBcrQ2WQFvjc+45QzIjn9d0p/y5uyTvLW58=
X-Received: by 2002:a05:651c:1986:b0:2d4:a925:d5bc with SMTP id
 bx6-20020a05651c198600b002d4a925d5bcmr4706080ljb.16.1710854561485; Tue, 19
 Mar 2024 06:22:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
 <65f98e5b99604_11543d29415@willemb.c.googlers.com.notmuch>
In-Reply-To: <65f98e5b99604_11543d29415@willemb.c.googlers.com.notmuch>
From: Igor Raits <igor@gooddata.com>
Date: Tue, 19 Mar 2024 14:22:30 +0100
Message-ID: <CA+9S74gRyDn3_=aAm7XkGKEzTg7KF=pPEHFsvENYpv80kczqZg@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Willem,

On Tue, Mar 19, 2024 at 2:08=E2=80=AFPM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Igor Raits wrote:
> > Hello,
> >
> > We have started to observe kernel crashes on 6.7.y kernels (atm we
> > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where we
> > have nodes of cluster it looks stable. Please see stacktrace below. If
> > you need more information please let me know.
> >
> > We do not have a consistent reproducer but when we put some bigger
> > network load on a VM, the hypervisor's kernel crashes.
> >
> > Help is much appreciated! We are happy to test any patches.
> >
> > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
>
> Did you miss the first part of the Oops?

Actually I copied it as-is from our log system. As it is a physical
server, such logs are sent via netconsole to another server. This is
the first line I see in the log in the time segment.

>
> > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
> >    E      6.7.10-1.gdc.el9.x86_64 #1
> > [62254.183743] Hardware name: Dell Inc. PowerEdge R7525/0H3K7P, BIOS
> > 2.14.1 12/17/2023
> > [62254.192083] RIP: 0010:skb_release_data+0xb8/0x1e0
> > [62254.197357] Code: 48 83 c3 01 39 d8 7e 54 48 89 d8 48 c1 e0 04 41
> > 80 7d 7e 00 49 8b 6c 04 30 79 0f 44 89 f6 48 89 ef e8 4c e4 ff ff 84
> > c0 75 d0 <48> 8b 45 08 a8 01 0f 85 09 01 00 00 e9 d9 00 00 00 0f 1f 44
> > 00 00
> > [62254.217013] RSP: 0018:ffffa975a0247ba8 EFLAGS: 00010206
> > [62254.222692] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000=
000000785
> > [62254.230263] RDX: 0000000000000016 RSI: 0000000000000002 RDI: ffff989=
862b32b00
> > [62254.237878] RBP: 4f2b318c69a8b0f9 R08: 000000000001fe4d R09: 0000000=
00000003a
> > [62254.245417] R10: 0000000000000000 R11: 0000000000001736 R12: ffff988=
0b819aec0
> > [62254.252963] R13: ffff989862b32b00 R14: 0000000000000000 R15: 0000000=
000000002
> > [62254.260591] FS:  00007f6cf388bf80(0000) GS:ffff98b85fbc0000(0000)
> > knlGS:0000000000000000
> > [62254.269061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [62254.275170] CR2: 000000c002236020 CR3: 000000387d37a002 CR4: 0000000=
000770ef0
> > [62254.282733] PKRU: 55555554
> > [62254.285911] Call Trace:
> > [62254.288884]  <TASK>
> > [62254.291549]  ? die+0x33/0x90
> > [62254.294769]  ? do_trap+0xe0/0x110
> > [62254.298405]  ? do_error_trap+0x65/0x80
> > [62254.302471]  ? exc_stack_segment+0x35/0x50
> > [62254.306884]  ? asm_exc_stack_segment+0x22/0x30
> > [62254.311637]  ? skb_release_data+0xb8/0x1e0
> > [62254.316047]  kfree_skb_list_reason+0x6d/0x210
> > [62254.320697]  ? free_unref_page_commit+0x80/0x2f0
> > [62254.325700]  ? free_unref_page+0xe9/0x130
> > [62254.330013]  skb_release_data+0xfc/0x1e0
> > [62254.334261]  consume_skb+0x45/0xd0
> > [62254.338077]  tun_do_read+0x68/0x1f0 [tun]
> > [62254.342414]  tun_recvmsg+0x7e/0x160 [tun]
> > [62254.346696]  handle_rx+0x3ab/0x750 [vhost_net]
> > [62254.351488]  vhost_worker+0x42/0x70 [vhost]
> > [62254.355934]  vhost_task_fn+0x4b/0xb0
>
> Neither tun nor vhost_net saw significant changes between the two
> reported kernels.
>
>     $ git log --oneline v6.6..v6.7 -- drivers/net/tun.c drivers/vhost/net=
.c | wc -l
>     0
>
>     $ git log --oneline linux/v6.6.9..linux/v6.7.5 -- drivers/net/tun.c d=
rivers/vhost/net.c
>     6438382dd9f8 tun: add missing rx stats accounting in tun_xdp_act
>     4efd09da0d49 tun: fix missing dropped counter in tun_xdp_act
>
> So the cause is likely in the code that generated the skb or something
> that modified it along the way.
>
> It could be helpful if it is possible to bisect further. Though odds
> are that the issue is between v6.6 and v6.7, not introduced in the
> stable backports after that. So it is a large target.

Yeah, as I replied later to my original message - we actually also see
the issue on 6.6.9 as well but it looks slightly different.

Actually while writing reply got 6.6.9 crashed too:

[13330.391004] tun: unexpected GSO type: 0x4ec1c942, gso_size 20948,
hdr_len 3072
[13330.398267] tun: 17 03 03 40 11 47 37 88 2c cb 02 ea 2b 5b c1 b0
...@.G7.,...+[..
[13330.405879] tun: f5 b7 2d b6 52 36 66 3e a4 33 f5 97 74 75 e8 31
..-.R6f>.3..tu.1
[13330.413483] tun: 50 69 54 2e f7 d0 30 b6 c9 b4 51 74 b8 32 f2 8d
PiT...0...Qt.2..
[13330.421072] tun: 01 2e ea 80 6c d0 b3 1d 56 ac eb ef da 4c 5a 24
....l...V....LZ$
[13330.428686] ------------[ cut here ]------------
[13330.433317] WARNING: CPU: 59 PID: 9587 at drivers/net/tun.c:2136
tun_put_user.constprop.0+0x356/0x370 [tun]
[13330.443078] Modules linked in: nf_tables(E) mptcp_diag(E)
xsk_diag(E) raw_diag(E) unix_diag(E) af_packet_diag(E) netlink_diag(E)
udp_diag(E) tcp_diag(E) inet_diag(E) rpcsec_gss_krb5(E) auth_rpcgss(E)
nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) fscache(E) netfs(E)
netconsole(E) nf_conntrack_netlink(E) vhost_net(E) vhost(E)
vhost_iotlb(E) tap(E) tun(E) ib_core(E) scsi_transport_iscsi(E)
sch_ingress(E) target_core_user(E) uio(E) target_core_pscsi(E)
target_core_file(E) target_core_iblock(E) iscsi_target_mod(E)
target_core_mod(E) 8021q(E) garp(E) mrp(E) bonding(E) tls(E)
nfnetlink_cttimeout(E) nfnetlink(E) openvswitch(E) nf_conncount(E)
nf_nat(E) binfmt_misc(E) dell_rbu(E) sunrpc(E) vfat(E) fat(E)
dm_service_time(E) dm_multipath(E) btrfs(E) intel_rapl_msr(E)
intel_rapl_common(E) xor(E) zstd_compress(E) ipmi_ssif(E)
amd64_edac(E) edac_mce_amd(E) raid6_pq(E) kvm_amd(E) dell_smbios(E)
kvm(E) acpi_ipmi(E) irqbypass(E) dell_wmi_descriptor(E) dcdbas(E)
wmi_bmof(E) ipmi_si(E) rapl(E) acpi_cpufreq(E) ipmi_devintf(E)
[13330.443122]  ptdma(E) wmi(E) k10temp(E) i2c_piix4(E)
ipmi_msghandler(E) acpi_power_meter(E) fuse(E) drm(E) zram(E) ext4(E)
mbcache(E) jbd2(E) dm_crypt(E) sd_mod(E) t10_pi(E) sg(E)
crct10dif_pclmul(E) ahci(E) crc32_pclmul(E) polyval_clmulni(E)
polyval_generic(E) libahci(E) ice(E) ghash_clmulni_intel(E)
sha512_ssse3(E) libata(E) ccp(E) gnss(E) megaraid_sas(E) sp5100_tco(E)
dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) nf_conntrack(E)
libcrc32c(E) crc32c_intel(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E)
br_netfilter(E) bridge(E) stp(E) llc(E)
[13330.532534] Unloaded tainted modules: fjes(E):2
[13330.584831] CPU: 59 PID: 9587 Comm: vhost-9526 Tainted: G
 E      6.6.9-2.gdc.el9.x86_64 #1
[13330.594063] Hardware name: Dell Inc. PowerEdge R7525/0H3K7P, BIOS
2.14.1 12/17/2023
[13330.601746] RIP: 0010:tun_put_user.constprop.0+0x356/0x370 [tun]
[13330.607783] Code: 00 00 6a 01 0f b7 44 24 18 b9 10 00 00 00 48 c7
c6 08 85 d5 c1 48 c7 c7 0e 85 d5 c1 39 d0 48 0f 4f c2 31 d2 50 e8 1a
54 27 d2 <0f> 0b 49 c7 c4 ea ff ff ff 58 5a e9 3b fe ff ff e8 85 22 89
d2 0f
[13330.626566] RSP: 0018:ffffc90027497c70 EFLAGS: 00010282
[13330.631816] RAX: 0000000000000000 RBX: ffff888865149e00 RCX: 00000000000=
00000
[13330.638970] RDX: 0000000000000000 RSI: ffff88b85fddf700 RDI: ffff88b85fd=
df700
[13330.646119] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000fff=
f7fff
[13330.653266] R10: ffffc90027497a40 R11: ffffffff95be26a8 R12: 00000000000=
02342
[13330.660416] R13: 0000000000000000 R14: ffffc90027497e10 R15: ffff88982b6=
5c980
[13330.667567] FS:  00007fd272854f80(0000) GS:ffff88b85fdc0000(0000)
knlGS:0000000000000000
[13330.675681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13330.681439] CR2: 000000c2bdeae000 CR3: 000000386fcea003 CR4: 00000000007=
70ee0
[13330.688580] PKRU: 55555554
[13330.691301] Call Trace:
[13330.693767]  <TASK>
[13330.695891]  ? __warn+0x80/0x130
[13330.699151]  ? tun_put_user.constprop.0+0x356/0x370 [tun]
[13330.704579]  ? report_bug+0x195/0x1a0
[13330.708265]  ? handle_bug+0x3c/0x70
[13330.711768]  ? exc_invalid_op+0x14/0x70
[13330.715620]  ? asm_exc_invalid_op+0x16/0x20
[13330.719829]  ? tun_put_user.constprop.0+0x356/0x370 [tun]
[13330.725248]  tun_do_read+0x54/0x1f0 [tun]
[13330.729293]  tun_recvmsg+0x7e/0x160 [tun]
[13330.733327]  handle_rx+0x3ab/0x750 [vhost_net]
[13330.737794]  vhost_worker+0x42/0x70 [vhost]
[13330.741995]  vhost_task_fn+0x4b/0xb0
[13330.745589]  ? finish_task_switch.isra.0+0x8f/0x2a0
[13330.750484]  ? __pfx_vhost_task_fn+0x10/0x10
[13330.754774]  ? __pfx_vhost_task_fn+0x10/0x10
[13330.759062]  ret_from_fork+0x2d/0x50
[13330.762656]  ? __pfx_vhost_task_fn+0x10/0x10
[13330.766941]  ret_from_fork_asm+0x1b/0x30
[13330.770888]  </TASK>
[13330.773091] ---[ end trace 0000000000000000 ]---
[13332.560592] usercopy: Kernel memory exposure attempt detected from
page alloc (offset 0, size 16384)!
[13332.569869] ------------[ cut here ]------------
[13332.574499] kernel BUG at mm/usercopy.c:102!
[13332.578790] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[13332.584027] CPU: 49 PID: 9692 Comm: vhost-9660 Tainted: G        W
 E      6.6.9-2.gdc.el9.x86_64 #1
[13332.593249] Hardware name: Dell Inc. PowerEdge R7525/0H3K7P, BIOS
2.14.1 12/17/2023
[13332.600913] RIP: 0010:usercopy_abort+0x6a/0x80
[13332.605372] Code: 61 18 95 50 48 c7 c2 62 61 18 95 57 48 c7 c7 28
df 19 95 48 0f 44 d6 48 c7 c6 88 df 19 95 4c 89 d1 49 0f 44 f3 e8 f6
f1 d5 ff <0f> 0b 49 c7 c1 d0 40 1b 95 4c 89 cf 4d 89 c8 eb a9 0f 1f 44
00 00
[13332.624129] RSP: 0018:ffffc9002773fb60 EFLAGS: 00010246
[13332.629359] RAX: 0000000000000059 RBX: 0000000000000001 RCX: 00000000000=
00000
[13332.636491] RDX: 0000000000000000 RSI: ffff88a85fd5f700 RDI: ffff88a85fd=
5f700
[13332.643627] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000fff=
f7fff
[13332.650767] R10: ffffc9002773fa18 R11: ffffffff95be26a8 R12: 00000000000=
04000
[13332.657901] R13: 0000000000000001 R14: 0000000000000000 R15: ffff8888640=
1ae00
[13332.665041] FS:  00007fcbae82cf80(0000) GS:ffff88a85fd40000(0000)
knlGS:0000000000000000
[13332.673133] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13332.678879] CR2: 00007f60f35721d8 CR3: 000000307edbe006 CR4: 00000000007=
70ee0
[13332.686017] PKRU: 55555554
[13332.688734] Call Trace:
[13332.691187]  <TASK>
[13332.693293]  ? die+0x33/0x90
[13332.696187]  ? do_trap+0xe0/0x110
[13332.699519]  ? usercopy_abort+0x6a/0x80
[13332.703370]  ? do_error_trap+0x65/0x80
[13332.707128]  ? usercopy_abort+0x6a/0x80
[13332.710976]  ? exc_invalid_op+0x4e/0x70
[13332.714823]  ? usercopy_abort+0x6a/0x80
[13332.718671]  ? asm_exc_invalid_op+0x16/0x20
[13332.722867]  ? usercopy_abort+0x6a/0x80
[13332.726714]  check_heap_object+0xea/0x190
[13332.730736]  __check_object_size.part.0+0x5e/0x140
[13332.735534]  simple_copy_to_iter+0x26/0x50
[13332.739643]  __skb_datagram_iter+0x199/0x2e0
[13332.743918]  ? __pfx_simple_copy_to_iter+0x10/0x10
[13332.748717]  skb_copy_datagram_iter+0x33/0x90
[13332.753087]  tun_put_user.constprop.0+0x16b/0x370 [tun]
[13332.758321]  tun_do_read+0x54/0x1f0 [tun]
[13332.762342]  tun_recvmsg+0x7e/0x160 [tun]
[13332.766361]  handle_rx+0x3ab/0x750 [vhost_net]
[13332.770817]  vhost_worker+0x42/0x70 [vhost]
[13332.775011]  vhost_task_fn+0x4b/0xb0
[13332.778599]  ? finish_task_switch.isra.0+0x8f/0x2a0
[13332.783485]  ? __pfx_vhost_task_fn+0x10/0x10
[13332.787758]  ? __pfx_vhost_task_fn+0x10/0x10
[13332.792032]  ret_from_fork+0x2d/0x50
[13332.795621]  ? __pfx_vhost_task_fn+0x10/0x10
[13332.799893]  ret_from_fork_asm+0x1b/0x30
[13332.803827]  </TASK>
[13332.806018] Modules linked in: nf_tables(E) mptcp_diag(E)
xsk_diag(E) raw_diag(E) unix_diag(E) af_packet_diag(E) netlink_diag(E)
udp_diag(E) tcp_diag(E) inet_diag(E) rpcsec_gss_krb5(E) auth_rpcgss(E)
nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) fscache(E) netfs(E)
netconsole(E) nf_conntrack_netlink(E) vhost_net(E) vhost(E)
vhost_iotlb(E) tap(E) tun(E) ib_core(E) scsi_transport_iscsi(E)
sch_ingress(E) target_core_user(E) uio(E) target_core_pscsi(E)
target_core_file(E) target_core_iblock(E) iscsi_target_mod(E)
target_core_mod(E) 8021q(E) garp(E) mrp(E) bonding(E) tls(E)
nfnetlink_cttimeout(E) nfnetlink(E) openvswitch(E) nf_conncount(E)
nf_nat(E) binfmt_misc(E) dell_rbu(E) sunrpc(E) vfat(E) fat(E)
dm_service_time(E) dm_multipath(E) btrfs(E) intel_rapl_msr(E)
intel_rapl_common(E) xor(E) zstd_compress(E) ipmi_ssif(E)
amd64_edac(E) edac_mce_amd(E) raid6_pq(E) kvm_amd(E) dell_smbios(E)
kvm(E) acpi_ipmi(E) irqbypass(E) dell_wmi_descriptor(E) dcdbas(E)
wmi_bmof(E) ipmi_si(E) rapl(E) acpi_cpufreq(E) ipmi_devintf(E)
[13332.806060]  ptdma(E) wmi(E) k10temp(E) i2c_piix4(E)
ipmi_msghandler(E) acpi_power_meter(E) fuse(E) drm(E) zram(E) ext4(E)
mbcache(E) jbd2(E) dm_crypt(E) sd_mod(E) t10_pi(E) sg(E)
crct10dif_pclmul(E) ahci(E) crc32_pclmul(E) polyval_clmulni(E)
polyval_generic(E) libahci(E) ice(E) ghash_clmulni_intel(E)
sha512_ssse3(E) libata(E) ccp(E) gnss(E) megaraid_sas(E) sp5100_tco(E)
dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) nf_conntrack(E)
libcrc32c(E) crc32c_intel(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E)
br_netfilter(E) bridge(E) stp(E) llc(E)
[13332.895399] Unloaded tainted modules: fjes(E):2
[13332.947668] ---[ end trace 0000000000000000 ]---
[13333.036158] pstore: backend (erst) writing error (-22)
[13333.041336] RIP: 0010:usercopy_abort+0x6a/0x80
[13333.045791] Code: 61 18 95 50 48 c7 c2 62 61 18 95 57 48 c7 c7 28
df 19 95 48 0f 44 d6 48 c7 c6 88 df 19 95 4c 89 d1 49 0f 44 f3 e8 f6
f1 d5 ff <0f> 0b 49 c7 c1 d0 40 1b 95 4c 89 cf 4d 89 c8 eb a9 0f 1f 44
00 00
[13333.064553] RSP: 0018:ffffc9002773fb60 EFLAGS: 00010246
[13333.069789] RAX: 0000000000000059 RBX: 0000000000000001 RCX: 00000000000=
00000
[13333.076926] RDX: 0000000000000000 RSI: ffff88a85fd5f700 RDI: ffff88a85fd=
5f700
[13333.084071] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000fff=
f7fff
[13333.091209] R10: ffffc9002773fa18 R11: ffffffff95be26a8 R12: 00000000000=
04000
[13333.098350] R13: 0000000000000001 R14: 0000000000000000 R15: ffff8888640=
1ae00
[13333.105493] FS:  00007fcbae82cf80(0000) GS:ffff88a85fd40000(0000)
knlGS:0000000000000000
[13333.113587] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13333.119341] CR2: 00007f60f35721d8 CR3: 000000307edbe006 CR4: 00000000007=
70ee0
[13333.126482] PKRU: 55555554
[13333.129205] Kernel panic - not syncing: Fatal exception
[13333.338519] Kernel Offset: disabled
[13333.365480] ---[ end Kernel panic - not syncing: Fatal exception ]---


> Getting the exact line in skb_release_data that causes the Oops
> would be helpful too, e.g.,
>
> gdb vmlinux
> list *(skb_release_data+0xb8)

Unfortunately we do not collect kdumps so this is not going to be easy
:( We will investigate the possibility of getting the dump though.

