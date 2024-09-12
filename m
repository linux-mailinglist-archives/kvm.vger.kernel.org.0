Return-Path: <kvm+bounces-26756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A038977278
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 21:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E5D61C211A4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 19:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906CF1BFDE5;
	Thu, 12 Sep 2024 19:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="mowKfLEx"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2098.outbound.protection.outlook.com [40.92.89.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C41713D530;
	Thu, 12 Sep 2024 19:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.89.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726170777; cv=fail; b=kH5Mwn793xXZDxblVNW2vzKNIsMWmIpBA2pRvMg9vLfFw4LLHkiTqE23gN4MOJdV1pBzhb9+V5CYPX2TjOehAR/Y553fucA+tnexI7A43hXevPkCzZ+MrHRLZAbdemmGhCKXA/U2ImZpfQkOMjjqYCpweYeyF1peTFbLIpZ179g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726170777; c=relaxed/simple;
	bh=88MtX9Bmv4jJqc5W7DTVDtLBDOt99UyTjpg7nq14CRc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W+899iVWcwuSFKOAxl5u2A7mcfzPPdl+HXkgpkjsrmEDGSv38hrl9Gaj5hEiVV0EAM7Q1GA6JB6MjFMDg7w71vbRBj0McBI9mU9/4tvL0ISwWIH5+FcpJK5Vk4sKENnHnKy99RIh0pqrcqC/H226289TKjK8mN10w2bYuXIqz2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=mowKfLEx; arc=fail smtp.client-ip=40.92.89.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pHUuNQglnc/yoEe2gsGEgywn2rdoifLZF7rYsarNW9CoIvEcmzNK+Dojzc72EbxtiQexSlENRoSlCO73GXTkOD4R8fgXbuSx7RmION81M/e011jfhsk6WtvT/GWK6mpXvGObnLQfkYmgQjewIZgbN1TTmZoziLwlTjiAmDskg/H095zyw7w2RPIeKz2W1Tsf4NUUxMJWlSUBsxBe7LjNNv1dgcLru2GTOQ49hWM6FVJjoe3sHXyEg2z5jXAVm2OBunhrQrtidTBANUtgJIwCsDhUeG+PNNQ6S9DO97rcgY2D+5Y7DUvgiofaMnJleZx8Y3+RpsJ9JvY6FYLj0QduqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88MtX9Bmv4jJqc5W7DTVDtLBDOt99UyTjpg7nq14CRc=;
 b=oRHvoknJVuGBtVCdxn5FkPGRf8yhEcc1j//0dgRbNQOLkyMpcT3aXepjy8rkG2+b9/2QF+mq2e9W9z2NFrOSfatZXAT9RD8b8IaMH4uJDl17PTh0otD3gFdqHy+jXHGAbb8yBUuuisZhaPykOIg3u1BXeJQNBgz8xj82tnwZp1t3l5GZ2hT/HvPBrZ8TO01zBsB3VWokmti7YYTlpMPLQtQIqTDjFTXmpS4MLAPloaQzeaQJBvFZE4yTg8OUHfRV4LmcqVqwMy+CyW6pn4FCRRpDmszb7e+z168WQWEyYPEmlLiVKB1j1P2ENauLMXAm4GbAS4bbW3ciZQPFMibtkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88MtX9Bmv4jJqc5W7DTVDtLBDOt99UyTjpg7nq14CRc=;
 b=mowKfLExCYRqoesy/7rTTv0yGrBqvLfkV4giOr9nEw14RqMIiumA/aPm7zC1UuNgH93zARe7wNZYSabilpgg9HdXrDCTRlYl6k6V6JzXA9CAfZGO1EHWBhOKdvukL30xMuXZF8P7HgggyMFSQ6IUJ5dyIBpymZFHsY8E6d7Z3taDTaqRM37QDEnZCn8f3HvB6Y7LvOnjcx1qcm61/PCXqa+Wxhx3BgeCnQJwmQWmvGhsT31ZPBpaZHLcONL2I2r4h8UDs7D1xMmWRU9q4xQCNQcLZaPzM4CawGRJW5PRBjrGGIj2nJ0wBqKZAkXkP1V2TwQiz5HNTcZolUT4mRacIQ==
Received: from VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:1d9::21)
 by AS8PR10MB7375.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:615::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Thu, 12 Sep
 2024 19:52:52 +0000
Received: from VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9061:3480:b7e4:9bf1]) by VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9061:3480:b7e4:9bf1%6]) with mapi id 15.20.7939.017; Thu, 12 Sep 2024
 19:52:51 +0000
From: zdravko delineshev <delineshev@outlook.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Bjorn Helgaas <helgaas@kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: nointxmask device
Thread-Topic: nointxmask device
Thread-Index: AQHbA3xRb4NScq4cFUSTGvZPrcImc7JQ/0vrgAAKMgCAAh8CAIABZwMR
Date: Thu, 12 Sep 2024 19:52:51 +0000
Message-ID:
 <VI1PR10MB8207104B3B0C86648DE30452DB642@VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM>
References:
 <VI1PR10MB8207C507DB5420AB4C7281E0DB9A2@VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM>
	<20240910134918.GA579571@bhelgaas>
 <20240911161248.1f05d7da.alex.williamson@redhat.com>
In-Reply-To: <20240911161248.1f05d7da.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [YIFVFj036jVlCPOyoi3PszWRqlWq1r/V]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR10MB8207:EE_|AS8PR10MB7375:EE_
x-ms-office365-filtering-correlation-id: 15a57fb4-d07b-46b7-b701-08dcd3647c88
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799006|15080799006|19110799003|461199028|7092599003|15030799003|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 lGgaPSn8mcJG8xb1Lwc0PJqEj7sqAXEnscISsB4B9JSWwa9PLQoqp9KHJgDA0NVfEAMtVih96CU1IkMKgiFGKAI3Q1XVkcENoozt5k71jrYnG2DSjbT9gy9SC1Vfo7aMmEkdl204vUPDSGooW5htHAvWCnsJ+ZjntH51W93EqRNLnlwhnM/HbHBAxKeIjRd7IEw+0c5AAwnBMACeu1ljWJ8xMFVYgXCS4PfTi14RitS+TlaG8yn/kGnBEt6ee7xYdodfDJ47i1rdCUhJUbGIunkFysT8hpP36w41yfpIwzXqbZqxTYlW2XjYLZbKD5KxbusFrcWAIbafzNvp95i2DKOejkotvzq9MTcb6ogrnrBjXSB0IhCWx/N3kywrUrSvd6r3S3Ej8js6givAiHVufRK57pIO/It7HbmGTXAEbfxhg/shCsgdTSIVgtmoVqarGXQ07jyVipp5gsbDxMbjemRVYx6MMi8nM7Z36RqEgXEKNDUVAdr6s567GU0C8tZv2NcXreCUrQMZ+DXIxfnujvDGa1QCZ1oHJx34XbO5DZjKW7SfQXpXNilXmjzH4aivpIoMaiIAkRZvcPFDIrrHBuqty2IM5HnX8i+1Y1EZAH678hV1vcIoIlTy+oQ6rzvHVxX2dST4ZesBqef7p4RqHUmjqwf2HeltjZTTHH6QpkpMg+fHiOdAEwZ4FYVd+4cOkqM3xD/7V/2rHJC7JWpaiImbNaeBjQZJCqKCvXTurxyz1A8xng7UomALUDGG5Dlm
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+vQJQd1O/DdCadAAYo81yxlDZV8sOKenGSDqTeObrJvp1hPcyp1NE298tt?=
 =?iso-8859-1?Q?jluh8ozKWtXrQSpz5otWAU3XgHM/Lp+/UPOoxwPHDatKP4tR5HtpN/kKtJ?=
 =?iso-8859-1?Q?a5ikH/2wT4ZCFqE0qbyDzQvZiZ501betD9sTUre9AbKDil/06Yk4rwcqs1?=
 =?iso-8859-1?Q?t0DWQ5DYdRv6Vg2tzCjzwABGk7Ra+sTuymO6CNpv3yd8KyfW7sfUrXzPRI?=
 =?iso-8859-1?Q?RhQaUnPzuy3HMWQzLucdur6DWHcbNWyPrFGtUJD1HW9W+zvsSkAnZkBx18?=
 =?iso-8859-1?Q?0uy2VyUQX9lyIsDUdAe1mcjFIP21VvKth46ijmSJ8cqgh+vXQP2FhtHq2m?=
 =?iso-8859-1?Q?Ag2jlfV81tq8YVIw2I1niezujNh+BtNffZx5TTpx35RdBCzC+olyRZGuQm?=
 =?iso-8859-1?Q?caq0++MgOf0gnayNZaRcgdPITY643H00igk0VTRZoxxNMFOaBGXq7ALwqE?=
 =?iso-8859-1?Q?vx+Yu8Gy6zxm7SX5PQ1FVrN37sDzN4F6PK9jDRHBtwM4Mn3YCzX66EzKPT?=
 =?iso-8859-1?Q?SKhyEl9LegBeFlAXxqZRnyRFpwFUippOymy8xNFf0NHmOOR6p1O+cPo1aN?=
 =?iso-8859-1?Q?Il4RFXQsPynz86fAA49groE3TtNuOdcUAXziewml89a4Ia/w3C0t9CePDb?=
 =?iso-8859-1?Q?jQmBZ0lMcN/4/lXInEuAH4Pxund7sWt7vW22myP/TCRMsbjhftm43H1gi0?=
 =?iso-8859-1?Q?JExhEb0x8VyfDzQBjhjkAE5BZrWoFrQdDdBAiSRLvI4kkLQplOE7Th2X8Q?=
 =?iso-8859-1?Q?zhZj4OK6f1CgjdaJje1+Qeypxs+CDvwyizzr18rT3Xoi8hp4sPxX0YveOu?=
 =?iso-8859-1?Q?Lj1+0dByDH6cMgIi+4dI/GEwB97o3QfW9/MxmwoHHLNYt96s7YARVrci+c?=
 =?iso-8859-1?Q?kDO7973K4yi5sKnnXPxvvEJuLahSGnqpsReQQpicngEhVTse9SJqB1yw+e?=
 =?iso-8859-1?Q?4KAlk00BrWtc+6YZGQBLdHr1RYz4ItccjTEs1lod/OTNsBDP9+7cgb4mrg?=
 =?iso-8859-1?Q?spa9kgcpgaVyI37H7cDRHcJg6dE6vct4tCJ409K3YfQkDzJJrWKmD+8w3j?=
 =?iso-8859-1?Q?fkgg78pEu6ByOn/7fyiuIC7ZjHOBlPeu3xJAnpoIqS949hHqGSGJfvM1TF?=
 =?iso-8859-1?Q?MASzxBVQyQqNg5IXUhhDd7J/uK2WAgOvYBKOgteTsF2Gf3oIHslZSyqRzt?=
 =?iso-8859-1?Q?hukd6XBnDXO3AHWPW+a2JcUIpEr3iKfsUL7WNZn6wB/ZQGGuQycPDuPDp1?=
 =?iso-8859-1?Q?O3eDn5dGKNNiVhxkm2Wg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a57fb4-d07b-46b7-b701-08dcd3647c88
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 19:52:51.9274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB7375

Hello,=0A=
=0A=
Here is the dmesg output BEFORE enabling the flag:=0A=
=0A=
2024-09-01T01:32:02.885775+03:00 proxmox kernel: [ =A0843.996111] irq 409: =
nobody cared (try booting with the "irqpoll" option)=0A=
2024-09-01T01:32:02.885792+03:00 proxmox kernel: [ =A0843.996682] CPU: 46 P=
ID: 7672 Comm: kvm Tainted: P =A0 =A0 =A0 =A0 =A0 O =A0 =A0 =A0 6.8.12-1-pv=
e #1=0A=
2024-09-01T01:32:02.885793+03:00 proxmox kernel: [ =A0843.997142] Hardware =
name: Supermicro Super Server/X11DPX-T, BIOS 4.2 12/15/2023=0A=
2024-09-01T01:32:02.885794+03:00 proxmox kernel: [ =A0843.997566] Call Trac=
e:=0A=
2024-09-01T01:32:02.885795+03:00 proxmox kernel: [ =A0843.997973] =A0<TASK>=
=0A=
2024-09-01T01:32:02.885796+03:00 proxmox kernel: [ =A0843.998370] =A0dump_s=
tack_lvl+0x76/0xa0=0A=
2024-09-01T01:32:02.885797+03:00 proxmox kernel: [ =A0843.998766] =A0dump_s=
tack+0x10/0x20=0A=
2024-09-01T01:32:02.885798+03:00 proxmox kernel: [ =A0843.999153] =A0__repo=
rt_bad_irq+0x30/0xd0=0A=
2024-09-01T01:32:02.885799+03:00 proxmox kernel: [ =A0843.999539] =A0note_i=
nterrupt+0x2e1/0x320=0A=
2024-09-01T01:32:02.885800+03:00 proxmox kernel: [ =A0843.999917] =A0handle=
_irq_event+0x79/0x80=0A=
2024-09-01T01:32:02.885802+03:00 proxmox kernel: [ =A0844.000296] =A0handle=
_fasteoi_irq+0x7d/0x200=0A=
2024-09-01T01:32:02.885803+03:00 proxmox kernel: [ =A0844.000677] =A0__comm=
on_interrupt+0x3e/0xb0=0A=
2024-09-01T01:32:02.885804+03:00 proxmox kernel: [ =A0844.001057] =A0common=
_interrupt+0x44/0xb0=0A=
2024-09-01T01:32:02.885815+03:00 proxmox kernel: [ =A0844.001435] =A0asm_co=
mmon_interrupt+0x27/0x40=0A=
2024-09-01T01:32:02.885816+03:00 proxmox kernel: [ =A0844.001812] RIP: 0033=
:0x5c4d6fb518be=0A=
2024-09-01T01:32:02.885817+03:00 proxmox kernel: [ =A0844.002209] Code: ff =
48 69 04 24 00 ca 9a 3b 48 03 44 24 08 eb d4 e8 c7 f2 d9 ff 0f 1f 80 00 00 =
00 00 53 0f 1f 80 00 00 00 00 8b 1d 72 a3 2a 01 <e8> 3d ff ff ff 83 e3 fe 8=
b 15=0A=
64 a3 2a 01 39 da 75 e8 5b 31 d2 c3=0A=
2024-09-01T01:32:02.885819+03:00 proxmox kernel: [ =A0844.002618] RSP: 002b=
:00007ffdea5752f0 EFLAGS: 00000246=0A=
2024-09-01T01:32:02.885820+03:00 proxmox kernel: [ =A0844.003027] RAX: 0000=
000000000000 RBX: 0000000000000002 RCX: 0000000000000000=0A=
2024-09-01T01:32:02.885821+03:00 proxmox kernel: [ =A0844.003436] RDX: 0000=
000000000000 RSI: 0000000000000000 RDI: 0000000000000001=0A=
2024-09-01T01:32:02.885822+03:00 proxmox kernel: [ =A0844.003844] RBP: 0000=
5c4d72c4fe70 R08: 0000000000000000 R09: 0000000000000000=0A=
2024-09-01T01:32:02.885823+03:00 proxmox kernel: [ =A0844.004247] R10: 0000=
000000000000 R11: 0000000000000000 R12: 00005c4d70e13860=0A=
2024-09-01T01:32:02.885824+03:00 proxmox kernel: [ =A0844.004649] R13: 0000=
5c4d70dfc7f8 R14: 00005c4d70e137c8 R15: 00007ffdea575360=0A=
2024-09-01T01:32:02.885825+03:00 proxmox kernel: [ =A0844.005054] =A0</TASK=
>=0A=
2024-09-01T01:32:02.885826+03:00 proxmox kernel: [ =A0844.005455] handlers:=
=0A=
2024-09-01T01:32:02.885827+03:00 proxmox kernel: [ =A0844.005851] [<0000000=
0eac396f2>] vfio_intx_handler [vfio_pci_core]=0A=
2024-09-01T01:32:02.885828+03:00 proxmox kernel: [ =A0844.006265] Disabling=
 IRQ #409=0A=
2024-09-01T01:32:03.377945+03:00 proxmox kernel: [ =A0844.484106] irq 16: n=
obody cared (try booting with the "irqpoll" option)=0A=
2024-09-01T01:32:03.377963+03:00 proxmox kernel: [ =A0844.484635] CPU: 8 PI=
D: 0 Comm: swapper/8 Tainted: P =A0 =A0 =A0 =A0 =A0 O =A0 =A0 =A0 6.8.12-1-=
pve #1=0A=
2024-09-01T01:32:03.377964+03:00 proxmox kernel: [ =A0844.485087] Hardware =
name: Supermicro Super Server/X11DPX-T, BIOS 4.2 12/15/2023=0A=
2024-09-01T01:32:03.377965+03:00 proxmox kernel: [ =A0844.485494] Call Trac=
e:=0A=
2024-09-01T01:32:03.377966+03:00 proxmox kernel: [ =A0844.485901] =A0<IRQ>=
=0A=
2024-09-01T01:32:03.377967+03:00 proxmox kernel: [ =A0844.486299] =A0dump_s=
tack_lvl+0x76/0xa0=0A=
2024-09-01T01:32:03.377968+03:00 proxmox kernel: [ =A0844.486707] =A0dump_s=
tack+0x10/0x20=0A=
2024-09-01T01:32:03.377969+03:00 proxmox kernel: [ =A0844.487104] =A0__repo=
rt_bad_irq+0x30/0xd0=0A=
2024-09-01T01:32:03.377971+03:00 proxmox kernel: [ =A0844.487507] =A0note_i=
nterrupt+0x2e1/0x320=0A=
2024-09-01T01:32:03.377972+03:00 proxmox kernel: [ =A0844.487908] =A0handle=
_irq_event+0x79/0x80=0A=
2024-09-01T01:32:03.377973+03:00 proxmox kernel: [ =A0844.488308] =A0handle=
_fasteoi_irq+0x7d/0x200=0A=
2024-09-01T01:32:03.377974+03:00 proxmox kernel: [ =A0844.488706] =A0__comm=
on_interrupt+0x3e/0xb0=0A=
2024-09-01T01:32:03.377975+03:00 proxmox kernel: [ =A0844.489112] =A0common=
_interrupt+0x9f/0xb0=0A=
2024-09-01T01:32:03.377986+03:00 proxmox kernel: [ =A0844.489511] =A0</IRQ>=
=0A=
2024-09-01T01:32:03.377987+03:00 proxmox kernel: [ =A0844.489900] =A0<TASK>=
=0A=
2024-09-01T01:32:03.377988+03:00 proxmox kernel: [ =A0844.490287] =A0asm_co=
mmon_interrupt+0x27/0x40=0A=
2024-09-01T01:32:03.377989+03:00 proxmox kernel: [ =A0844.490681] RIP: 0010=
:pv_native_safe_halt+0xb/0x10=0A=
2024-09-01T01:32:03.377990+03:00 proxmox kernel: [ =A0844.491075] Code: 22 =
d7 31 ff c3 cc cc cc cc 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 =
90 90 90 90 90 66 90 0f 00 2d 29 58 37 00 fb f4 <c3> cc cc cc cc 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 83=0A=
2024-09-01T01:32:03.377991+03:00 proxmox kernel: [ =A0844.491497] RSP: 0018=
:ffffb4c54029fea0 EFLAGS: 00000246=0A=
2024-09-01T01:32:03.377992+03:00 proxmox kernel: [ =A0844.491923] RAX: 0000=
000000000000 RBX: 0000000000000008 RCX: 0000000000000000=0A=
2024-09-01T01:32:03.377993+03:00 proxmox kernel: [ =A0844.492354] RDX: 0000=
000000000000 RSI: 0000000000000000 RDI: 0000000000000000=0A=
2024-09-01T01:32:03.377994+03:00 proxmox kernel: [ =A0844.492781] RBP: ffff=
b4c54029fea8 R08: 0000000000000000 R09: 0000000000000000=0A=
2024-09-01T01:32:03.377995+03:00 proxmox kernel: [ =A0844.493207] R10: 0000=
000000000000 R11: 0000000000000000 R12: ffff9bd807f68000=0A=
2024-09-01T01:32:03.377996+03:00 proxmox kernel: [ =A0844.493634] R13: 0000=
000000000000 R14: 0000000000000000 R15: ffff9bd807f68000=0A=
2024-09-01T01:32:03.377997+03:00 proxmox kernel: [ =A0844.494064] =A0? defa=
ult_idle+0x9/0x30=0A=
2024-09-01T01:32:03.377998+03:00 proxmox kernel: [ =A0844.494496] =A0arch_c=
pu_idle+0x9/0x10=0A=
2024-09-01T01:32:03.377999+03:00 proxmox kernel: [ =A0844.494930] =A0defaul=
t_idle_call+0x2c/0xf0=0A=
2024-09-01T01:32:03.377999+03:00 proxmox kernel: [ =A0844.495361] =A0do_idl=
e+0x216/0x260=0A=
2024-09-01T01:32:03.378000+03:00 proxmox kernel: [ =A0844.495793] =A0cpu_st=
artup_entry+0x2a/0x30=0A=
2024-09-01T01:32:03.378001+03:00 proxmox kernel: [ =A0844.496225] =A0start_=
secondary+0x119/0x140=0A=
2024-09-01T01:32:03.378002+03:00 proxmox kernel: [ =A0844.496655] =A0second=
ary_startup_64_no_verify+0x184/0x18b=0A=
2024-09-01T01:32:03.378004+03:00 proxmox kernel: [ =A0844.497090] =A0</TASK=
>=0A=
2024-09-01T01:32:03.378005+03:00 proxmox kernel: [ =A0844.497519] handlers:=
=0A=
2024-09-01T01:32:03.378006+03:00 proxmox kernel: [ =A0844.497944] [<0000000=
067e8c516>] i801_isr [i2c_i801]=0A=
2024-09-01T01:32:03.378007+03:00 proxmox kernel: [ =A0844.498383] Disabling=
 IRQ #16=0A=
=0A=
=0A=
=0A=
This is a message AFTER enabling the flag, but device continued to operate.=
 it has appeared only ONCE, and since this timestamp there are no other iss=
ues observed:=0A=
=0A=
2024-09-06T16:02:31.196668+03:00 proxmox kernel: [ =A0754.479693] Hardware =
name: Supermicro Super Server/X11DPX-T, BIOS 4.2 12/15/2023=0A=
2024-09-06T16:02:31.196669+03:00 proxmox kernel: [ =A0754.480098] Call Trac=
e:=0A=
2024-09-06T16:02:31.196671+03:00 proxmox kernel: [ =A0754.480488] =A0<IRQ>=
=0A=
2024-09-06T16:02:31.196672+03:00 proxmox kernel: [ =A0754.480878] =A0dump_s=
tack_lvl+0x76/0xa0=0A=
2024-09-06T16:02:31.196673+03:00 proxmox kernel: [ =A0754.481274] =A0dump_s=
tack+0x10/0x20=0A=
2024-09-06T16:02:31.196674+03:00 proxmox kernel: [ =A0754.481661] =A0__repo=
rt_bad_irq+0x30/0xd0=0A=
2024-09-06T16:02:31.196675+03:00 proxmox kernel: [ =A0754.482043] =A0note_i=
nterrupt+0x2e1/0x320=0A=
2024-09-06T16:02:31.196677+03:00 proxmox kernel: [ =A0754.482423] =A0handle=
_irq_event+0x79/0x80=0A=
2024-09-06T16:02:31.196685+03:00 proxmox kernel: [ =A0754.482802] =A0handle=
_fasteoi_irq+0x7d/0x200=0A=
2024-09-06T16:02:31.196686+03:00 proxmox kernel: [ =A0754.483179] =A0__comm=
on_interrupt+0x3e/0xb0=0A=
2024-09-06T16:02:31.196688+03:00 proxmox kernel: [ =A0754.483556] =A0common=
_interrupt+0x9f/0xb0=0A=
2024-09-06T16:02:31.196689+03:00 proxmox kernel: [ =A0754.483931] =A0</IRQ>=
=0A=
2024-09-06T16:02:31.196690+03:00 proxmox kernel: [ =A0754.484297] =A0<TASK>=
=0A=
2024-09-06T16:02:31.196691+03:00 proxmox kernel: [ =A0754.484663] =A0asm_co=
mmon_interrupt+0x27/0x40=0A=
2024-09-06T16:02:31.196692+03:00 proxmox kernel: [ =A0754.485032] RIP: 0010=
:pv_native_safe_halt+0xb/0x10=0A=
2024-09-06T16:02:31.196693+03:00 proxmox kernel: [ =A0754.485403] Code: 22 =
d7 31 ff c3 cc cc cc cc 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 =
90 90 90 90 90 66 90 0f 00 2d 29 58 37 00 fb f4 <c3> cc cc cc cc 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 83=0A=
2024-09-06T16:02:31.196702+03:00 proxmox kernel: [ =A0754.485806] RSP: 0018=
:ffffb501c029fea0 EFLAGS: 00000246=0A=
2024-09-06T16:02:31.196703+03:00 proxmox kernel: [ =A0754.486210] RAX: 0000=
000000000000 RBX: 0000000000000008 RCX: 0000000000000000=0A=
2024-09-06T16:02:31.196704+03:00 proxmox kernel: [ =A0754.486617] RDX: 0000=
000000000000 RSI: 0000000000000000 RDI: 0000000000000000=0A=
2024-09-06T16:02:31.196705+03:00 proxmox kernel: [ =A0754.487022] RBP: ffff=
b501c029fea8 R08: 0000000000000000 R09: 0000000000000000=0A=
2024-09-06T16:02:31.196706+03:00 proxmox kernel: [ =A0754.487427] R10: 0000=
000000000000 R11: 0000000000000000 R12: ffffa0a207fa0000=0A=
2024-09-06T16:02:31.196707+03:00 proxmox kernel: [ =A0754.487833] R13: 0000=
000000000000 R14: 0000000000000000 R15: ffffa0a207fa0000=0A=
2024-09-06T16:02:31.196708+03:00 proxmox kernel: [ =A0754.488241] =A0? defa=
ult_idle+0x9/0x30=0A=
2024-09-06T16:02:31.196709+03:00 proxmox kernel: [ =A0754.488645] =A0arch_c=
pu_idle+0x9/0x10=0A=
2024-09-06T16:02:31.196710+03:00 proxmox kernel: [ =A0754.489047] =A0defaul=
t_idle_call+0x2c/0xf0=0A=
2024-09-06T16:02:31.196711+03:00 proxmox kernel: [ =A0754.489449] =A0do_idl=
e+0x216/0x260=0A=
2024-09-06T16:02:31.196712+03:00 proxmox kernel: [ =A0754.489852] =A0cpu_st=
artup_entry+0x2a/0x30=0A=
2024-09-06T16:02:31.196712+03:00 proxmox kernel: [ =A0754.490252] =A0start_=
secondary+0x119/0x140=0A=
2024-09-06T16:02:31.196713+03:00 proxmox kernel: [ =A0754.490653] =A0second=
ary_startup_64_no_verify+0x184/0x18b=0A=
2024-09-06T16:02:31.196714+03:00 proxmox kernel: [ =A0754.491059] =A0</TASK=
>=0A=
2024-09-06T16:02:31.196715+03:00 proxmox kernel: [ =A0754.491453] handlers:=
=0A=
2024-09-06T16:02:31.196716+03:00 proxmox kernel: [ =A0754.491846] [<0000000=
09e36e508>] i801_isr [i2c_i801]=0A=
2024-09-06T16:02:31.196717+03:00 proxmox kernel: [ =A0754.492249] Disabling=
 IRQ #16=0A=
=0A=
=0A=
________________________________________=0A=
From:=A0Alex Williamson <alex.williamson@redhat.com>=0A=
Sent:=A0Thursday, September 12, 2024 1:12 AM=0A=
To:=A0zdravko delineshev <delineshev@outlook.com>=0A=
Cc:=A0Bjorn Helgaas <helgaas@kernel.org>; linux-pci@vger.kernel.org <linux-=
pci@vger.kernel.org>; kvm@vger.kernel.org <kvm@vger.kernel.org>=0A=
Subject:=A0Re: nointxmask device=0A=
=A0=0A=
On Tue, 10 Sep 2024 08:49:18 -0500=0A=
Bjorn Helgaas <helgaas@kernel.org> wrote:=0A=
=0A=
> [+cc Alex, kvm]=0A=
>=0A=
> On Tue, Sep 10, 2024 at 01:13:41PM +0000, zdravko delineshev wrote:=0A=
> >=0A=
> > Hello,=0A=
> >=0A=
> > i found a note in the vfio-pci parameters to email devices fixed by the=
 nointxmask parameter.=0A=
> >=0A=
> > Here is the one i have and i am trying to pass trough. it is currently =
working fine, with nointxmask=3D1 .=0A=
=0A=
What are the symptoms without using nointxmask=3D1?=A0 Please provide any=
=0A=
dmesg snippets in the host related to using this device.=0A=
=0A=
> > 81:00.0 Audio device: Creative Labs EMU20k2 [Sound Blaster X-Fi Titaniu=
m Series] (rev 03)=0A=
> > =A0 =A0 =A0 =A0 Subsystem: Creative Labs EMU20k2 [Sound Blaster X-Fi Ti=
tanium Series]=0A=
> > =A0 =A0 =A0 =A0 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASn=
oop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-=0A=
> > =A0 =A0 =A0 =A0 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast=
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
> > =A0 =A0 =A0 =A0 Latency: 0, Cache Line Size: 32 bytes=0A=
> > =A0 =A0 =A0 =A0 Interrupt: pin A routed to IRQ 409=0A=
> > =A0 =A0 =A0 =A0 NUMA node: 1=0A=
> > =A0 =A0 =A0 =A0 IOMMU group: 23=0A=
> > =A0 =A0 =A0 =A0 Region 0: Memory at d3200000 (64-bit, non-prefetchable)=
 [size=3D64K]=0A=
> > =A0 =A0 =A0 =A0 Region 2: Memory at d3000000 (64-bit, non-prefetchable)=
 [size=3D2M]=0A=
> > =A0 =A0 =A0 =A0 Region 4: Memory at d2000000 (64-bit, non-prefetchable)=
 [size=3D16M]=0A=
> > =A0 =A0 =A0 =A0 Capabilities: [40] Power Management version 3=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Flags: PMEClk- DSI- D1- D2- AuxCurrent=
=3D0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Status: D0 NoSoftRst- PME-Enable- DSel=
=3D0 DScale=3D0 PME-=0A=
> > =A0 =A0 =A0 =A0 Capabilities: [48] MSI: Enable- Count=3D1/1 Maskable- 6=
4bit+=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Address: 0000000000000000 =A0Data: 0000=
=0A=
=0A=
The device supports MSI, but the snd-ctxfs driver we have in the Linux=0A=
kernel has no support for it, therefore reporting zero for the INTx pin=0A=
is not an option.=0A=
=0A=
Are you able to verify a kernel patch?=0A=
=0A=
Adding it to the existing broken INTx quirk should simply be:=0A=
=0A=
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c=0A=
index a2ce4e08edf5..c7596e9aabb0 100644=0A=
--- a/drivers/pci/quirks.c=0A=
+++ b/drivers/pci/quirks.c=0A=
@@ -3608,6 +3608,8 @@ DECLARE_PCI_FIXUP_FINAL(0x1814, 0x0601, /* Ralink RT2=
800 802.11n PCI */=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 qu=
irk_broken_intx_masking);=0A=
=A0DECLARE_PCI_FIXUP_FINAL(0x1b7c, 0x0004, /* Ceton InfiniTV4 */=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 qu=
irk_broken_intx_masking);=0A=
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_20K=
2,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 quirk_b=
roken_intx_masking);=0A=
=A0=0A=
=A0/*=0A=
=A0 * Realtek RTL8169 PCI Gigabit Ethernet Controller (rev 10)=0A=
=0A=
=0A=
Thanks,=0A=
Alex=0A=
=0A=
> > =A0 =A0 =A0 =A0 Capabilities: [58] Express (v2) Endpoint, MSI 00=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DevCap: MaxPayload 128 bytes, PhantFunc=
 0, Latency L0s <64ns, L1 <1us=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ExtTag- AttnBtn- AttnIn=
d- PwrInd- RBE+ FLReset- SlotPowerLimit 0W=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DevCtl: CorrErr- NonFatalErr- FatalErr+=
 UnsupReq-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 RlxdOrd+ ExtTag- PhantF=
unc- AuxPwr+ NoSnoop+=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MaxPayload 128 bytes, M=
axReadReq 512 bytes=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DevSta: CorrErr- NonFatalErr- FatalErr-=
 UnsupReq- AuxPwr- TransPend-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 LnkCap: Port #0, Speed 2.5GT/s, Width x=
1, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ClockPM- Surprise- LLAc=
tRep- BwNot- ASPMOptComp-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 LnkCtl: ASPM Disabled; RCB 64 bytes, Di=
sabled- CommClk-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ExtSynch- ClockPM- AutW=
idDis- BWInt- AutBWInt-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 LnkSta: Speed 2.5GT/s, Width x1=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 TrErr- Train- SlotClk- =
DLActive- BWMgmt- ABWMgmt-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DevCap2: Completion Timeout: Range ABCD=
, TimeoutDis- NROPrPrP- LTR-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A010BitTagComp- 10BitT=
agReq- OBFF Not Supported, ExtFmt- EETLPPrefix-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EmergencyPowerReduct=
ion Not Supported, EmergencyPowerReductionInit-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FRS- TPHComp- ExtTPH=
Comp-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0AtomicOpsCap: 32bit-=
 64bit- 128bitCAS-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DevCtl2: Completion Timeout: 50us to 50=
ms, TimeoutDis- LTR- 10BitTagReq- OBFF Disabled,=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0AtomicOpsCtl: ReqEn-=
=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 LnkCtl2: Target Link Speed: 2.5GT/s, En=
terCompliance- SpeedDis-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Transmit Margin: Nor=
mal Operating Range, EnterModifiedCompliance- ComplianceSOS-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Compliance Preset/De=
-emphasis: -6dB de-emphasis, 0dB preshoot=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 LnkSta2: Current De-emphasis Level: -6d=
B, EqualizationComplete- EqualizationPhase1-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EqualizationPhase2- =
EqualizationPhase3- LinkEqualizationRequest-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Retimer- 2Retimers- =
CrosslinkRes: unsupported=0A=
> > =A0 =A0 =A0 =A0 Capabilities: [100 v1] Device Serial Number ff-ff-ff-ff=
-ff-ff-ff-ff=0A=
> > =A0 =A0 =A0 =A0 Capabilities: [300 v1] Advanced Error Reporting=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UESta: =A0DLP- SDES- TLP- FCP- CmpltTO-=
 CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UEMsk: =A0DLP- SDES+ TLP- FCP- CmpltTO-=
 CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- C=
mpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CESta: =A0RxErr- BadTLP- BadDLLP- Rollo=
ver- Timeout- AdvNonFatalErr+=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CEMsk: =A0RxErr- BadTLP- BadDLLP- Rollo=
ver- Timeout- AdvNonFatalErr+=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 AERCap: First Error Pointer: 00, ECRCGe=
nCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MultHdrRecCap- MultHdrR=
ecEn- TLPPfxPres- HdrLogCap-=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 HeaderLog: 00000000 00000000 00000000 0=
0000000=0A=
> > =A0 =A0 =A0 =A0 Kernel driver in use: vfio-pci=0A=
> > =A0 =A0 =A0 =A0 Kernel modules: snd_ctxfi=0A=
> > 00: 02 11 0b 00 46 01 10 00 03 00 03 04 08 00 00 00=0A=
> > 10: 04 00 20 d3 00 00 00 00 04 00 00 d3 00 00 00 00=0A=
> > 20: 04 00 00 d2 00 00 00 00 00 00 00 00 02 11 44 00=0A=
> > 30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00=0A=
> > 40: 01 48 03 00 00 00 00 00 05 58 80 00 00 00 00 00=0A=
> > 50: 00 00 00 00 00 00 00 00 10 00 02 00 00 80 00 00=0A=
> > 60: 14 2c 20 00 11 0c 00 00 00 00 11 00 00 00 00 00=0A=
> > 70: 00 00 00 00 00 00 00 00 00 00 00 00 0f 00 00 00=0A=
> > 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A=
> > 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A=
> > a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A=
> > b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A=
> > c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A=
> > d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A=
> > e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=0A=
> > f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0=0A=
>=0A=

