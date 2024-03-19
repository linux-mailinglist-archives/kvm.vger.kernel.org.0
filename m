Return-Path: <kvm+bounces-12137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C7187FE6E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:15:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D6911C22AEE
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EE18002F;
	Tue, 19 Mar 2024 13:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GWNHgS5p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EA75A782
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 13:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853941; cv=none; b=r7n/zENIlGjq4oCqWK3IUJtuE3uExA1JCB2nr2X516EnlmMlwmZkUHfRPMmgBYqIbTEgWSDlTn0/yTm6i2W9trLNi30CuX5UwL14BBdW9K2EKpGl93g9Z7DnRUYHIcgZxKweebAxZeMURN/Quds+Eq9FR/HFdVewLFKIIfNQrUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853941; c=relaxed/simple;
	bh=7puSIT6f16dfpmayh86GVtGIL/V4ZE4sL80/KzrqVUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nP3T9NucgEzNDpMus8OLnAINkl8qpB0EAe8uTZXbftSJSgNkJW7COhw3eGBuR24h1OtxviMVW5skIk0SxePzoWUU0FdlmYqh4YsKw2pYSSJONORH854cXjGwjWEy0MWzb0ZvGhh9PgLfa3Gm66tHNfjMwE0yZUlbQ6fMXWtXp+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GWNHgS5p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710853938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GJBdz3U1WunKPN2BCIMkG7enmmurW3BsZHwfVIRnRQw=;
	b=GWNHgS5pXC9yXwyJXa9lIF9SDY2YajzudlRU/IRZcWqcbXGS8wIAsvg5AaFwjHZmUhafUc
	NqGFjfUXMkkHeCzqFynlxwRBjQjKVSeF3uWj3ab+6ngtgxIjgZJIj0Yu0q6iVfRFqHZ1i+
	kJX+2nk4GngIgWkMF9/Tavkxn1QobWs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-oKZfv3-IMOGWuiMdr0EwIg-1; Tue, 19 Mar 2024 09:12:15 -0400
X-MC-Unique: oKZfv3-IMOGWuiMdr0EwIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7EBD879842;
	Tue, 19 Mar 2024 13:12:14 +0000 (UTC)
Received: from localhost (unknown [10.39.195.82])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 933332166B33;
	Tue, 19 Mar 2024 13:12:13 +0000 (UTC)
Date: Tue, 19 Mar 2024 09:12:07 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Igor Raits <igor@gooddata.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
	Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
Message-ID: <20240319131207.GB1096131@fedora>
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+qGrYyZI2nwNrN1Z"
Content-Disposition: inline
In-Reply-To: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6


--+qGrYyZI2nwNrN1Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits wrote:
> Hello,
>=20
> We have started to observe kernel crashes on 6.7.y kernels (atm we
> have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where we
> have nodes of cluster it looks stable. Please see stacktrace below. If
> you need more information please let me know.
>=20
> We do not have a consistent reproducer but when we put some bigger
> network load on a VM, the hypervisor's kernel crashes.
>=20
> Help is much appreciated! We are happy to test any patches.

CCing Michael Tsirkin and Jason Wang for vhost_net.

>=20
> [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
>    E      6.7.10-1.gdc.el9.x86_64 #1

Are there any patches in this kernel?

Can you post the .config for this kernel?

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
>=20
> Thanks in advance!
>=20

--+qGrYyZI2nwNrN1Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmX5jycACgkQnKSrs4Gr
c8jm5Qf+LKc8WMewUy8XG3ttuidFm2E0L3CALVjoqoHrw96434a5frn4keygx3wW
TGlE/aD9ymBHf6mJ9BZHDxbZHrtytfir6AWcsScLgj3IUCAyn/LHZ+tGlaXx6TZ7
x5Y+HKP/cyDsqUWqT03E0V0Oq4uD/AJauXe+9hxLvQ3cNpVIkH9lgyVnSUMzCTXj
LzHkgtzkJv8wzuEtGYKfG+pJn3j0mrg99yzfH0NRCeUdOH8/lDjC7w5C0GpOp7iE
rJGK9P+NdLq6mnPkZSKORDyyu2HZb3vj/tbQxrEVaW8GjLWQA/bL0UsqxEX5n30M
EQLN7AI05cwFvUuO3H9orrVCqxo9cw==
=PZQ9
-----END PGP SIGNATURE-----

--+qGrYyZI2nwNrN1Z--


