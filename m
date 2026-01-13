Return-Path: <kvm+bounces-67977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6402D1B61A
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 22:21:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BBFBB300765E
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 21:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1681632;
	Tue, 13 Jan 2026 21:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b="OXUtZfj5"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012021.outbound.protection.outlook.com [40.107.209.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D9B13D503;
	Tue, 13 Jan 2026 21:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768339291; cv=fail; b=uTL1pZdJcaLoo4WEFZVGEYeZMdN8xGGKZdrGIEL1YJvXQjumkGbJ8bkzjkYZAIQmzPpVc8v9ZOTvFISvQTWWDqZQ7uVTd8uZHc4gookQtz3BvRi4qecz/ZDwpcZ1LFVSUeGMf/DjumIyaRZK8/MXMYrLgrTC35ZjIP3V0enPnRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768339291; c=relaxed/simple;
	bh=1uEj1LZLLG4xgzfofAZBvBcezzn8mBjaIEamnRnGRaY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BntiRUwaa2bQPtjs6p5fBNmS2NbRkc1c24+jBzddE1VKdWiWcTIRYcMAua9n8S5UgdqcPU3mz7YmyZ/I8cndZlzBcdmA9iI+O4Mng3xnIM3gVAZVrxx5/58a6fcboRxE6XUv6cXm+3OpWDypekWsEYSAHBqkeECdspUInlH2FlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com; spf=fail smtp.mailfrom=nokia.com; dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b=OXUtZfj5; arc=fail smtp.client-ip=40.107.209.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gD7mnkcxEd0HEGhbX3wADM5o9yOcNezwc+wL5khord2JWSxIkTXpa00kuYLb+jUNeCDIWfQi08tev03CPKY5yi5tVMZgxfG8VwREB3n6U6oyhVB3xtl0ACiJkyWJnA+E1YK0m9Z6cM1CSZ+drk2zXw3H+1fCmSadt6riK2Rck89UftWIHBUCSw9am/NPF+z3/BcqZSm64AN5ugHheOFAn9mVjRnJ1k5naBAzogcdeBw0B7MaNn/LvNU0E9TmncXH/aZfbdGFXtoITm27HUJkJZaQGbGaN2RclnVY7pbQv3Lru+UxvX/JASQoUh61tgiLbs6GsbSTK7Mra+X9DfNq6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqMLMBdx9xDAaMNCx4wKHaAWXjOKKwWqMHNx4GJV4/Y=;
 b=iT4e1MQh5xftZe8URnp6jXYURqZRhEKqSZ5WbtDFx9uWGNCYfvoSt2EW2naocO7me87PmnhsXC5SFaTOXsk+q6leNjG1Ahvf7Rqa91nATpt57tmHGOnoMJ9TKjkaJ2gxMBuQ3PoVPKiDKMMLD0J6OTJyUJiLIy1FE/efNqe0kzK5lDBHUqW+Rdcna2GQM4Bq/RDmdxhxPNE0bWuJhZEluV6w1luY4+CTw32jXGmNpgN84y/cA8uzuW1Ub0huROK9YlZaIloWbbmCPxnzOmho9y8+9dVJ+tCvijtvAp2Ly63tHaGQQjsVu3LTaRnRzuZBrRzE81g9/r+tgAnKgRTuZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqMLMBdx9xDAaMNCx4wKHaAWXjOKKwWqMHNx4GJV4/Y=;
 b=OXUtZfj5A0sI3APfLo4+iwl7IbMXvL4WNHGpXGEJ5ivRG6YiYTH64RqS/0qgr3eBK5aTctCvuZkaFj5CAlbYrKcpsQc3n0j04FVQaIgfgg7PuPYRk9xt5sqKdyRHdEzzxPoV4l7h8qt1FfbkOFFwzjPXac4wQDt1nQP0K/6RnHpMIDQK/U7UVVoj1aPO+xqU0RPqht0Z5/pXQcWsoR798VjE2p6tbdJYpyufq+gop+ZW26Q95FT/kzyELiVljw0xTWcJLrrmBQKQ2fSHbcBCC0KjkAWsXV+Nd/bMWAlDXg/oHIwc3DgDBqd0HitRPtopznZ4AYKWrfWGMw9w7jI2dw==
Received: from BN0PR08MB6951.namprd08.prod.outlook.com (2603:10b6:408:128::14)
 by DM4PR08MB8603.namprd08.prod.outlook.com (2603:10b6:8:182::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 13 Jan
 2026 21:21:26 +0000
Received: from BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178]) by BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178%3]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 21:21:26 +0000
From: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>
CC: Alex Williamson <alex@shazbot.org>, Nathan Chen <nathanc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH] PCI: Lock upstream bridge for pci_try_reset_function()
Thread-Topic: [PATCH] PCI: Lock upstream bridge for pci_try_reset_function()
Thread-Index: AQHchNHpiTAwtZJ+bUWSAMUt6W3UqA==
Date: Tue, 13 Jan 2026 21:21:25 +0000
Message-ID:
 <BN0PR08MB69514F34E3CA505AE910F2F8838EA@BN0PR08MB6951.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR08MB6951:EE_|DM4PR08MB8603:EE_
x-ms-office365-filtering-correlation-id: 90904902-8905-4fa1-133a-08de52e9b58d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?You1fOrHLP7UPmyGBnWuJE49il7O0ZwogwDSlAEZYUNPOjRDwuhrrtt6W6?=
 =?iso-8859-1?Q?l3nTO093lRE/0zODivULGJKTOn3CejpTcTxinC2KUcKZRqQbNwtIC1Lydo?=
 =?iso-8859-1?Q?2ek1Y+u1G6fy3x397hQEKMwe1J3xXYS235FKy/XooMkn5W2k9wntWldSny?=
 =?iso-8859-1?Q?aSG9q+sveenUNzw5aRFIgswJ/+Zp8xQCLD0XjbOX3JLPH3WPHVYmBSojOu?=
 =?iso-8859-1?Q?ZcGqQaZ8KrvFlKZNJFKYPcsrCfZJHQa/rrU6FDNhsDHJbPvUo+a6pkJ8fA?=
 =?iso-8859-1?Q?sv0caK7G1VbD/4hS5cMIXKMWdNK5LNkwYbzlM50HSlKHz6g+d5HiZTnqXh?=
 =?iso-8859-1?Q?PFGbGdLdvtXxfyt5S7Emfab8iIhpGNDVuWpyIPTIEK0YUYbwKuHqWLyw+X?=
 =?iso-8859-1?Q?dszlypmR+Mz4Qk/4UMYUiAmXwl+FmaxNM8qj3+kFnujEKueOJALRy8JgJp?=
 =?iso-8859-1?Q?WkXeCfsaUlrAarFKANQvz15RBHWEV7NOOY7/YDruuBqDAxqA0oIw9B7qJf?=
 =?iso-8859-1?Q?zVntQHIiTCSL5dJZ9TMTMvO+TXtO+TR2Yt/Ea2g7Z3Yejh21iNk2SVSBmF?=
 =?iso-8859-1?Q?P8VBKfrqJDf4Rhd4Q/CHPr1xeco9afSerC/X6UHQ2TT1fiUH3OZeFxq6bf?=
 =?iso-8859-1?Q?vSimaFTsGJbu5unaaHWcV4EbXfG12GeGbFsu6pT08iPBvdydOghExj8zUd?=
 =?iso-8859-1?Q?23ch/uqGpbKAFVph1znTz9BUw8dDljmXlIZK2xJV5l9WUYNkPXRe2izkLQ?=
 =?iso-8859-1?Q?bOhMGBEHegyRZ+rI390Q0x4N1LgIYsKWUM7r9cHd3pBzmD3I5s01TuCR5i?=
 =?iso-8859-1?Q?DSA0pMoUSUSsGuxGpiu+SfGXBKKJ/AETK9cnB8ckIpXIhh1QjJMwT+S/rH?=
 =?iso-8859-1?Q?vmRzYbYU93MXmnGq44fjX3+y90K216ddqbXjmy82JbbuMOA+JV89NCx9i6?=
 =?iso-8859-1?Q?JgAwaEcp9s5W22UpPLu0vntiT2rx6do8E957YU1SuHST7sRNuRTHTF5Cnr?=
 =?iso-8859-1?Q?6sEPrcmRyDJzwgb1LMQB5nmkU/O2flJcIJ8awPeqTqUwHjneMPxZeGlNV0?=
 =?iso-8859-1?Q?63cRws8eQX6lZLmkRftw8u49ihgNOe0W/M44H59rfhkk0ip8QVTJH1q1cr?=
 =?iso-8859-1?Q?h0CRx1+dfnnbQztZL96n68k7DdSwxKazVhLHhTR/68kWlkPc9tmTmrwJ+I?=
 =?iso-8859-1?Q?jjzfWbiJWWek5z/KDLtIMEloYMfYvlS+KU0OejJsXU6httBzl03DamCmS2?=
 =?iso-8859-1?Q?ILdqDAFWm1WxFgCocQwa/E+mxy8LJF/0ao/HfQKGeyGJm9Sal+ySwdVMpK?=
 =?iso-8859-1?Q?F0ksrrJWYI7C0ZvdzoSIMZj3Rdn3oYe0JMfaEvD+/6JcEnd0ki+H1fgWl0?=
 =?iso-8859-1?Q?HmSG4zHwJs0i7xKdYOHe5y4SXO1twhhtXY38p0GH8gFhsPSBU+Xc7HvjxD?=
 =?iso-8859-1?Q?fDJ50IiPf6B78Efi0SFGPFx4U0ez9AnoS1hhkapX39V7xkEXQVWvH7sVCe?=
 =?iso-8859-1?Q?PfebzQoHDRz4V0Iy6N2PFhRt4iZZfFBEmzcLqWyvx2ktGSIp3KJMXaQyLn?=
 =?iso-8859-1?Q?WR5OZT37D6IREsS10arh2SDsPRwM?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR08MB6951.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ijxDc+rt2BAMrrsj3GF1Mx5YN9yCJP+SEywjaTput39M30U+U+3I/gjKoX?=
 =?iso-8859-1?Q?n2jE8cPfjJEedSWhktvWcwaUhS2k0WLoUBr9GG75yclt+lgrVKczdnrU9e?=
 =?iso-8859-1?Q?NxCzg8mnik14wi7HMBLuWsCucxo3zlT82/yKY5Vm4AJkKWHfm1n/8rQhPK?=
 =?iso-8859-1?Q?qSQBKWUe6IxbvThGS8vqpW5e/xQ2QDH53AV3AclSrtWxoFDCjEvUztSMNN?=
 =?iso-8859-1?Q?aujLut0LNPqX09az5ft0iQYujG9syngT2Q0qTvLjNbVnzVyfmIQAEvSSjm?=
 =?iso-8859-1?Q?2XdtcR5eJC85vV7aQikvOx2xQO075zotm3WXiSTo235U+JbC/t8xky/1bM?=
 =?iso-8859-1?Q?bdfVmRyQF787KCP+vP/186cf+m/M8GZXuYRUuIIS81gl5KI0p61H0KVOiH?=
 =?iso-8859-1?Q?iEspA0YrfL5gz7Z4vOUvj/OEFq84q2Q6WVlJQLvpim5OPayvf1JfS1m3rS?=
 =?iso-8859-1?Q?0lA9nOF/0R5uwMV0qhdDeFeHaSMvkxP3jYg4okgBpw28xe8SfTqrYqvf0f?=
 =?iso-8859-1?Q?STgt8nAFAcuG972LT/9cdHSvwKqR3fyQilqFz0QyhqzWgxRUI9ZrZyTFYr?=
 =?iso-8859-1?Q?b1VLzHUHqGc5drQiq8y+G6g+t37fwIO/tzFNV4xuFtjKgg90cOTO5dn81c?=
 =?iso-8859-1?Q?5X5tB3Xu0ul8FvJFc1BsCiyZyQMDZYiV6bD++JUjJY55bKD1rAkMOgA+Av?=
 =?iso-8859-1?Q?QGNja9m8LYpkTHxYnqUUaU/EaKpLTxT0kc1vvJ0wKyPujk57tMcM9SzRUM?=
 =?iso-8859-1?Q?KGtt9Aw9O8NDRkuvbog0GqY3ivwZ7/6LAe4UNQhErZbL56qgu2bxt1zE7m?=
 =?iso-8859-1?Q?cXZN8znXX5Lf4GsLN05iQAWUJ1UdYC1uzEOCYNaZGNtbeec+BdJPpGLwP8?=
 =?iso-8859-1?Q?9dZxEKpyRIOW+lMy2fn7KW+tiPaGJTx4HIDxwI3EtFDjA7iKaOxF6hl0zE?=
 =?iso-8859-1?Q?GZRofaQX94UmzI5QBYgyGOiPbS91xUJf9U+7692Ro6SV5dp8SZbx0R/Pb2?=
 =?iso-8859-1?Q?ZZ+rFQEw3XSyroFMEJZ1jVo8+3dKUaNo5fRGGwrmPdAtVutaSDyQVwUSjy?=
 =?iso-8859-1?Q?SW4YEy+P5Go3SUS2mRJwA/h+uiySYNVwGqwD/kDX0t+uqDKsxwktu5kWCt?=
 =?iso-8859-1?Q?XjoxOkj3rLNudhasZIsPxoS929WpeIt8UmzX2mtUICbEYBvlkCqrKJt/W5?=
 =?iso-8859-1?Q?GYrqKAcULNFp5cq0itUfrvm4VQQWfZvKhpDf6GbEBYdTeQYjbA9HHpNYQ9?=
 =?iso-8859-1?Q?au5VwyO1V/35/DuQWXl9ksc7e5JHZLvzPk+kNZ8rUsKJNf4QXkEn2Iq2NM?=
 =?iso-8859-1?Q?VzMyOZ1udPed1z08zf5hXvi9vJIF+n2v5R4qXTxdkk82SXfWaV0nrS4pHt?=
 =?iso-8859-1?Q?zUu7tqSYfc9jFbJNwoDEb9uAk9QatusWX2klw/dYVCnTL/0UD8DrIortDu?=
 =?iso-8859-1?Q?W6UW4KKSAJ84KlX0cFUI88lmg+JRi3ecKSCr/y4n1+fNmAIHxiuJSHRSsI?=
 =?iso-8859-1?Q?QId31FDBapxQpO3XpD/xkC+b/ld9dtn+6BWlYiI2O9hXz7J3vnZSAtOcNr?=
 =?iso-8859-1?Q?gT5XicgZ/yZF6LaxYq7ZCNmp6pF9Dc4uJKdCPCoyBeKfbmjzbmaQ93h+2x?=
 =?iso-8859-1?Q?ukj1hHWuS0hz5vgRp3PplY5XfIfvZeuJ1OdPE1kGc4xUHkDmnXwdzGlo6c?=
 =?iso-8859-1?Q?tDbdcQozyJ5Xjz/h6VdkLget0uJPF8AJuVKk46MSj6X4304HTOx3n+G8Sh?=
 =?iso-8859-1?Q?toD5lVU1a4xvExSPfcPdUPQzYi7JvridhmxOaRM2AtXBzpcjL0CxsqWGkC?=
 =?iso-8859-1?Q?qse8xeS1qQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR08MB6951.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90904902-8905-4fa1-133a-08de52e9b58d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2026 21:21:25.9426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ON/5PciCu3SQnR74Kf2ihvoEjfBNajzMpzLJTlZ5D1+6uBkAzLV11NDHVmSliSP2B+/Tb6TmSrtXpcIV88tpiR6gvCvXYohsYikUOoX7c08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR08MB8603

Address this issue:=0A=
[  125.942583] pcieport 0000:00:00.0: unlocked secondary bus reset via:=0A=
               pci_reset_bus_function+0x188/0x1b8=0A=
=0A=
which flows from a VFIO_GROUP_GET_DEVICE_FD ioctl when a PCI device is=0A=
being added to a VFIO group.=0A=
=0A=
Commit 920f6468924f ("Warn on missing cfg_access_lock during secondary=0A=
bus reset") added a warning if the PCI configuration space was not=0A=
locked during a secondary bus reset request. That was in response to=0A=
commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")=0A=
such that remaining paths would be made more visible.=0A=
=0A=
Address the pci_try_reset_function() path.=0A=
=0A=
Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>=0A=
---=0A=
 drivers/pci/pci.c | 17 ++++++++++++++++-=0A=
 1 file changed, 16 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c=0A=
index 13dbb405dc31..ff3f2df7e9c8 100644=0A=
--- a/drivers/pci/pci.c=0A=
+++ b/drivers/pci/pci.c=0A=
@@ -5196,19 +5196,34 @@ EXPORT_SYMBOL_GPL(pci_reset_function_locked);=0A=
  */=0A=
 int pci_try_reset_function(struct pci_dev *dev)=0A=
 {=0A=
+	struct pci_dev *bridge;=0A=
 	int rc;=0A=
 =0A=
 	if (!pci_reset_supported(dev))=0A=
 		return -ENOTTY;=0A=
 =0A=
-	if (!pci_dev_trylock(dev))=0A=
+	/*=0A=
+	 * If there's no upstream bridge, no locking is needed since there is=0A=
+	 * no upstream bridge configuration to hold consistent.=0A=
+	 */=0A=
+	bridge =3D pci_upstream_bridge(dev);=0A=
+	if (bridge && !pci_dev_trylock(bridge))=0A=
 		return -EAGAIN;=0A=
 =0A=
+	if (!pci_dev_trylock(dev)) {=0A=
+		rc =3D -EAGAIN;=0A=
+		goto out_unlock_bridge;=0A=
+	}=0A=
+=0A=
 	pci_dev_save_and_disable(dev);=0A=
 	rc =3D __pci_reset_function_locked(dev);=0A=
 	pci_dev_restore(dev);=0A=
 	pci_dev_unlock(dev);=0A=
 =0A=
+out_unlock_bridge:=0A=
+	if (bridge)=0A=
+		pci_dev_unlock(bridge);=0A=
+=0A=
 	return rc;=0A=
 }=0A=
 EXPORT_SYMBOL_GPL(pci_try_reset_function);=0A=
-- =0A=
2.43.0=0A=

