Return-Path: <kvm+bounces-54409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67727B20908
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 14:41:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E1C53AD4C6
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 12:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1941624C0;
	Mon, 11 Aug 2025 12:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GZcgwdSJ"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4259DF6C;
	Mon, 11 Aug 2025 12:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754916066; cv=none; b=hmgXq/NeYvNyfJ3jTelQ74K3dbbWVQRQZMGRxQUS72X1z5YszH6dWBvPZNmHDA9nyRsv3d0odahitfwzM9XNkf3DAtO1U2U3rF87enTAHsl/nK4uRgHZPDGx4A+1WX2Bu5QgSudLsOH2+6DY2TXT/33eYVFbxTotBJT9n73PnGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754916066; c=relaxed/simple;
	bh=XBoOGTg0b+gJuCJXZbjziXmV/rQ0ggTunxxsaZQAtvI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zg+cShobPaZoUiW+xLy7DovbUX4EABDitSq1BWMR3D2+umQkhYQPXBuS3F6Y0u6oDCSbaoLAIeGa+E3boAkwt9cyoDwEKLsJ1HtJKXSxeCSNuAtIqeCZdHx+iT+ivm/Db3aBPz0LJtBeEtRofOzrWX8UtN0Rlv2DPsLNcOsx9+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GZcgwdSJ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=guP1zPMp0F7kwdYtmDlcuwXqOppOyKVkSiBeM4Ue6yY=; b=GZcgwdSJTP+AW97LdpEgvx3iz7
	5aqGjnjdp16c/dKF4abXJqRPL8mPe3+Szd00xMdnUNLWXxPfWTpa1pbQJO340GFOyTZRpb+FAjMBl
	L8POWesgoidtZ+tFgCQbBQCQO9P/1Ll6fMVUdy1lUfvV0W/qlyNoUdCBc3k6yQFN81Lf2KwX3xaXz
	eVWwu+au/BDGdmTfpvm3gEoAV17ZSm7yZODKkSjVAkljJnU7oeZP7gcCzQmkgg4eRxtvvtmgnwUIK
	k9QQqqa+I5UVcoK/0qWhi+WJnxobpurYCsUuwSWojlumdRopf6CUwN6Cw2LaRmBLnENx2ZcDrTSze
	kP1UZ68g==;
Received: from [54.239.6.186] (helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulRpb-00000005VoA-0rVz;
	Mon, 11 Aug 2025 12:40:52 +0000
Message-ID: <dde0042c0a08460a280d5cd410096944ef6ed56c.camel@infradead.org>
Subject: Re: [PATCH v4 5/5] KVM: arm64: vgic-its: Clear ITE when DISCARD
 frees an ITE
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>, David Sauerwein <dssauerw@amazon.de>
Cc: jingzhangos@google.com, andre.przywara@arm.com, coltonlewis@google.com, 
 eauger@redhat.com, jiangkunkun@huawei.com, joey.gouly@arm.com,
 kvm@vger.kernel.org,  kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org,  lishusen2@huawei.com,
 oupton@google.com, pbonzini@redhat.com, rananta@google.com, 
 suzuki.poulose@arm.com, yuzenghui@huawei.com, graf@amazon.com, 
 nh-open-source@amazon.com
Date: Mon, 11 Aug 2025 14:40:49 +0200
In-Reply-To: <86ecwog9x5.wl-maz@kernel.org>
References: <20241107214137.428439-6-jingzhangos@google.com>
	 <20250512140909.3464-1-dssauerw@amazon.de> <86ecwog9x5.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-oamW+IZPv6HPEwi4Gk13"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-oamW+IZPv6HPEwi4Gk13
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2025-05-16 at 10:52 +0100, Marc Zyngier wrote:
> On Mon, 12 May 2025 15:09:09 +0100,
> David Sauerwein <dssauerw@amazon.de> wrote:
> >=20
> > Hi Jing,
> >=20
> > After pulling this patch in via the v6.6.64 and v5.10.226 LTS releases,=
 I see
> > NULL pointer dereferences in some guests. The dereference happens in di=
fferent
> > parts of the kernel outside of the GIC driver (file systems, NVMe drive=
r,
> > etc.). The issue only appears once every few hundred DISCARDs / guest b=
oots.
> > Reverting the commit does fix the problem. I have seen multiple differe=
nt guest
> > kernel versions (4.14, 5.15) and distributions exhibit this issue.
>=20
> Where is the guest stack trace?

[  157.126835] Unable to handle kernel NULL pointer dereference at virtual =
address 000002e8
[  157.128248] Mem abort info:
[  157.128745]   Exception class =3D DABT (current EL), IL =3D 32 bits
[  157.129736]   SET =3D 0, FnV =3D 0
[  157.130266]   EA =3D 0, S1PTW =3D 0
[  157.130794] Data abort info:
[  157.131273]   ISV =3D 0, ISS =3D 0x00000004
[  157.131933]   CM =3D 0, WnR =3D 0
[  157.132451] user pgtable: 4k pages, 48-bit VAs, pgd =3D ffff8003f5d4d000
[  157.133556] [00000000000002e8] *pgd=3D0000000000000000
[  157.134414] Internal error: Oops: 96000004 [#1] SMP
[  157.135238] Modules linked in: sunrpc vfat fat dm_mirror dm_region_hash =
dm_log dm_mod crc32_ce ghash_ce sha2_ce sha256_arm64 sha1_ce ena ptp pps_co=
re
[  157.137452] Process kworker/0:1 (pid: 28, stack limit =3D 0xffff000009dd=
8000)
[  157.138741] CPU: 0 PID: 28 Comm: kworker/0:1 Not tainted 4.14.336-253.55=
4.amzn2.aarch64 #1
[  157.140276] Hardware name: Amazon EC2 c7g.medium/, BIOS 1.0 11/1/2018
[  157.141502] Workqueue: xfs-reclaim/nvme0n1p1 xfs_reclaim_worker
[  157.142629] task: ffff8003f91de600 task.stack: ffff000009dd8000
[  157.143757] pc : xfs_perag_clear_reclaim_tag+0x4c/0x120
[  157.144747] lr : 0x0
[  157.145188] sp : ffff000009ddbb50 pstate : 80c00145
[  157.146118] x29: ffff000009ddbb50 x28: ffff8003f8052e00=20
[  157.147126] x27: 0000000000000000 x26: 000000000007bc78=20
[  157.148165] x25: ffff000008d36000 x24: ffff8003f8052e00=20
[  157.149151] x23: ffff000009ddbb80 x22: 0000000000000000=20
[  157.150139] x21: ffff00000843bd5c x20: 0000000000000000=20
[  157.151135] x19: ffff8003f8052e00 x18: 0000000000000038=20
[  157.152146] x17: 0000ffff8b577980 x16: ffff0000083255c8=20
[  157.153132] x15: 0000000000000000 x14: ffff8003f8052e70=20
[  157.154137] x13: ffff8003f8f85b60 x12: ffff8003f8f85d49=20
[  157.155144] x11: ffff8003f8f85b88 x10: 0000000000000000=20
[  157.156158] x9 : 0000000000000039 x8 : 0000000000000007=20
[  157.157180] x7 : 000000000000003e x6 : 0000000000000038=20
[  157.158199] x5 : 0000000000000000 x4 : 0000000000000000=20
[  157.159205] x3 : 00000000000002e8 x2 : 0000000000000001=20
[  157.160211] x1 : 0000000000000000 x0 : 00000000000002e8=20
[  157.161209] Call trace:
[  157.161709]  xfs_perag_clear_reclaim_tag+0x4c/0x120
[  157.162644]  xfs_reclaim_inode+0x314/0x49c
[  157.163432]  xfs_reclaim_inodes_ag+0x1ac/0x2fc
[  157.164290]  xfs_reclaim_worker+0x4c/0x80
[  157.165065]  process_one_work+0x198/0x3e0
[  157.165841]  worker_thread+0x4c/0x458
[  157.166544]  kthread+0x138/0x13c
[  157.167172]  ret_from_fork+0x10/0x2c
[  157.167858] Code: d2800001 52800022 aa0303e0 2a0103fe (88fe7c62)=20
[  157.169013] ---[ end trace 0a6955946156d7d5 ]---
[  157.169905] Kernel panic - not syncing: Fatal exception
[  157.170894] Kernel Offset: disabled
[  157.171583] CPU features: 0x2,28002238
[  157.172300] Memory Limit: none
[  157.172893] Rebooting in 30 seconds..

Hypervisor debug logs show a DISCARD command with a gpa which might
match x28/x24 in the above?

vgic_its_cmd_handle_discard gpa=3D438052e00 ite=3D00000000facc1299
event_id=3D0 device_id=3D32 ite_esz=3D8 vgic_its_base=3D10080000
vgic_its_check_event_id()=3D1

David, did we ever establish whether Ilias's patch from
https://lore.kernel.org/all/20250414111244.153528-1-ilstam@amazon.com/
makes the problem go away? It serializes the GIC state to userspace
like KVM does for most other devices, instead of doing the dubious
thing that the GIC specification *permits* and scribbling it to guest
memory.

If we look at the GIC specification, it says that behaviour is
UNPREDICTABLE in various cases where software writes to tables that the
GIC owns, or if those tables aren't zeroed when given to the GIC. It
would perhaps be useful to add a mode to QEMU which *enforces* that,
taking the affected pages out of the guest's memory map (and emulating
writes to parts of those pages which the guest *is* still allowed to
touch, etc.).

If this is indeed a guest bug, as I suspect, it should show up fairly
quickly in such a setup. Would be useful for catching other guest bugs
caused by this GIC feature too, like
https://lore.kernel.org/all/c69938cffd4002a93a95a396affaa945e0f69206.camel@=
infradead.org/

> > The issue looks like some kind of race. I think the guest re-uses the m=
emory
> > allocated for the ITT before the hypervisor is actually done with the D=
ISCARD
> > command, i.e. before it zeros the ITE. From what I can tell, the guest =
should
> > wait for the command to finish via its_wait_for_range_completion(). I t=
ried
> > locking reads to its->cwriter in vgic_mmio_read_its_cwriter() and its->=
creadr
> > in vgic_mmio_read_its_creadr() with its->cmd_lock in the hypervisor ker=
nel, but
> > that did not help. I also instrumented the guest kernel both via printk=
() and
> > trace events. In both cases the issue disappears once the instrumentati=
on is in
> > place, so I'm not able to fully observe what is happening on the guest =
side.
> >=20
> > Do you have an idea of what might cause the issue?
>=20
> I'm a bit sceptical of this analysis, because KVM makes no use of the
> guest's owned memory outside of a save/restore event, and otherwise
> shadows everything.

Hypervisor live updates or live migration could trigger precisely that
save/restore event at any time, surely?


--=-oamW+IZPv6HPEwi4Gk13
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDgxMTEyNDA0
OVowLwYJKoZIhvcNAQkEMSIEICrY76WeFUFVy89C/zoEAjbZ5sfNw9IxfsGrFzTNQqujMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAyeJWB2pl3p31
LPAL2tAlWJnC7nGaTIn5wasUcVb7I0PYd4IQczXvz6agZU0wEIy1skEil2JJRUvfhwHL7LFwQIfr
dnSX5VC8BFh+xmZ2NkZCUJHYzNBqkIjSbJOQoqix691ONF1c0hl/1WVRA55n3fgBaSX8dakaftCO
grCWGugX02YhcniWrJe6DNy69FqZn3leMkX2A22ipaJit8Q+hnQzF//dDKLB8q9dh1z6Q8nj9/sz
BlGt1htKMCurCXt4v8Y54MedeSLCWPlYvUKZlqu5CCDfoUDfjr8Yn9Zrk2cLh/s7h9a2RfgIG+z5
1K21ArWbi4H1JZYXBDhfPRLVSGGuYcyDmI+dorzejh394RB+GVF878bW3cdGIWYozncUJuug/bzq
YUsvEVxrLyG17oracKTb0isQ83EeTVm2qLG4Own2nqgyadJxetRr3kvfT43Poe+G6MhRQHxIIn3w
kSP9Bu9NGY4Axd7YpElDjSNfv+b9zFK4OhRA1MNSw7TcAzxrMKikrzirYENIweCv32iAqVHW9jka
HO7c7dLyPUrexGw7mHfzqgAwuKojAeD/KN9IG09YSqnPW6NgUclqOb/WAbkaL9pZM1AGPh3oyXV+
0NaLrlmp9/MvA4mChQnr+Vz2nLZSKKSNLPqbtsnCsuEdAMLGna1B++4BVwIdBM0AAAAAAAA=


--=-oamW+IZPv6HPEwi4Gk13--

