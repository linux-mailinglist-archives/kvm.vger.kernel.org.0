Return-Path: <kvm+bounces-67978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A4D3D1B6B6
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 22:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7AC9D3049293
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 21:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DA332ED30;
	Tue, 13 Jan 2026 21:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b="H6rij9GW"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7AE2D838C;
	Tue, 13 Jan 2026 21:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768340101; cv=fail; b=rGuSUI7sFg3BlXc3KxHt6Jvtu/EIOi885vczRUgwWETwCN/oN523s63DfvtwjS1WqVLpVQ7RMpKlh/6wwFzwmCuJXC1kf4CDK9yh782YKchNstGfoFkLdlyMM6PliBxh3WoYoBlNIS3iQkRpGlyv2E8Y4O9Uvx1eTUg7bJSCuuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768340101; c=relaxed/simple;
	bh=gVzxuHbwk7KMlRK5XWi3z3yjPszoRjaJ4s3FB5RfjVg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OfkSNxPPolQpURwiOELs303RTwfd4HJwy8yGctG+AlFdUn+lO4rQx3OS7T26trB7EWta2EbiPjPE6Cq/BBQIH8mRuQbaQyyz15SVHqcihfQ77XN6klDd+gC1qsYMAGfwEroWU3Naqrg9ynChrCYElyCN9LTaHZTRHyhlXHeUePg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com; spf=fail smtp.mailfrom=nokia.com; dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b=H6rij9GW; arc=fail smtp.client-ip=40.93.198.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qanPSNlGz++gcRt2y1Hr/z/DWnanbs1iMmi0rgO80kMoe7zgax1726+CaXxfymrBn2NgvCvFWuUk8NvhL6mHDvXzIshtXkYSZXk5qTvfFXQXolGVE+02s68jHnWG1sC64l3hTFN6h3GSDcsBcHOuIFirj/0/rO/X5MB0yp422kJG/Q/0RIWfYu+MrtJcYysOnjLvBzfHvFyemtPaXpQ4WzzK9ccJ7p6d87DMZi9gOyeWJZCtKZbM8B5Sl8ywc7ZhICuJ1uY5QLpA230V4FFAT5aZxZ4VvymMZy3EXY07QVcmnsSwJ/VeHl6kzegHfbQzcEMdh8LUWZiYDG7S8tWVsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NShfj/aGTSxy0PgfzoUs6Kt8HGaP2aW4kNrQA0m47Yo=;
 b=JjmEfoVAwLclg59ZsTH+sHe2FEycCJvsmmJpDNC0IVPhiodbtPscaEwrtr+9hoWP5WkaYWe1TLWAMDcCXtJgvB0iE8RSSOhcnTK1b0XTpjqZqGX7o2BpROGDdDIOEKKr8n9wQfMJrcA9rzMxTy0SWgsDw99n6iuSLW5egvqBU/6KGr2YBQTQUd6sjbze/x60AfPar0EVsndCvNpF4iF1dQELUkNaTIhbdX0u8Td4yNKB3a57wliNN4E8mVZZNS2SF9XnOrtVLAihnZXK/qXumXdLQ0kaxZJh+RWfcdsgg5AxKsN4NRXx2zgYsRAkfOqpjbSK1j3QR154DlNtBjcElA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NShfj/aGTSxy0PgfzoUs6Kt8HGaP2aW4kNrQA0m47Yo=;
 b=H6rij9GWzI9PjAgcpDg6wtVdN/PbHGZl9mN4p/NvPSMcXOT48XIrmlsbsUvAiqyx2nVdTegv03i8CA5SKUvPUSaxQYho6up/4r528bI8Uapd63teaLrqEWeOvCcY2Of5AYt6+H4S9MXieRxzlxQVwkyQHEoB+ZRcdnH6L07YnD4dhHlKQeDmg8N96dvd9HTHgRcBfTqP0EVyBGk0SLozsWYRlrP2is45z7DQdcuMtvehAPuW9zMUnVMfyAeQ/7KCQLdiScMzm0CYllJRifVyOrW59NAC09dR7pdIy58AVwtBgKJlfqBJ4ChwCexaed5PJDKUMK1vhe6Pr1tUv2kLPQ==
Received: from BN0PR08MB6951.namprd08.prod.outlook.com (2603:10b6:408:128::14)
 by LV0PR08MB10901.namprd08.prod.outlook.com (2603:10b6:408:33f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Tue, 13 Jan
 2026 21:34:58 +0000
Received: from BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178]) by BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178%3]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 21:34:58 +0000
From: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>
CC: Alex Williamson <alex@shazbot.org>, Nathan Chen <nathanc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH] vfio/pci: Lock upstream bridge for vfio_pci_core_disable()
Thread-Topic: [PATCH] vfio/pci: Lock upstream bridge for
 vfio_pci_core_disable()
Thread-Index: AQHchNQzVksa5WLccEyyQVhM+Hz0Dw==
Date: Tue, 13 Jan 2026 21:34:58 +0000
Message-ID:
 <BN0PR08MB695173DD697AB6E404803FEA838EA@BN0PR08MB6951.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR08MB6951:EE_|LV0PR08MB10901:EE_
x-ms-office365-filtering-correlation-id: 7f7b5480-3d6c-4303-899d-08de52eb99ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?1NTws0eiIKrIbtbpLfSv3z35RuIpvxsOH0GUm/zHV8JY1d4lX3DZhsCYJx?=
 =?iso-8859-1?Q?mutoNJU5gzlvLD+pW0qCHQbaQrEAPPPDrmS02s0DBjnq9qReyevfqEV2Xu?=
 =?iso-8859-1?Q?brJ3WYyXnyfbufldVPnT+Cy9hL9to7JgpSAzkpeCVJNzVZ/IKGtkWwDEG/?=
 =?iso-8859-1?Q?pJGA7OJU9VvhZ/m9Gp+StDr0nIxHBCix74UykCzS++6PIXh6v6XqvvV8zE?=
 =?iso-8859-1?Q?DeAzvvUOVx4jBVIWb836Syr2Y36EL096DZCUhX9tsWlXY2aW2iHZbIP+3t?=
 =?iso-8859-1?Q?l9ye4dl6mcdbLXaZEgXud78oM/78sEtpvSgl6AQ0n2vQzo9UuBqLTsuyRG?=
 =?iso-8859-1?Q?HXnJTuW3pZTLCNavB6OlaqDqQ8mqPuCURqkYTcaeU9FDPQC2zjo4n4rg7J?=
 =?iso-8859-1?Q?nBC7tPsVCThyc0ajD7pHOfZKPjjCYE9wK2ziV/nML31leIl7FKNIYgpfc1?=
 =?iso-8859-1?Q?M95iE+WHkW+FAJitoKGy1gDRqkenGzPMjQsD9um5qGzFqzUa7EYNzNkho0?=
 =?iso-8859-1?Q?qYdpr/gb4uCMMjA7mUTLmoezOCfB7eNo470eFWUMlfS9cJvUkpqwpGZP7M?=
 =?iso-8859-1?Q?8RmV0ufGkvmtBR7cWalAtaHKmFb9QlZbfJe2Jk1K4Ll4VXEp/CgXAJofdf?=
 =?iso-8859-1?Q?+RXLYaf4C0WQvn//LQKBpasuf3bnShTWhocxEndDpz7LF7hZfDHWh6CB5F?=
 =?iso-8859-1?Q?0/h0J+XX1X9+sTNdsLPTPubZIln7aOx8BYvUlO6YM8ywjYFIPKQEgvTnGC?=
 =?iso-8859-1?Q?sduTjk/uL8VsMy2/8Vojz+jpR7gFYlifdfaE6J3dKt0iLi+k4dsKrFJHeY?=
 =?iso-8859-1?Q?OaK7yVgLKdjkAct+i9NnbTpr58UYKOPQDa8vgMUibqfC2XuVpbadqJyyvB?=
 =?iso-8859-1?Q?6faU6sVyrx+bDm7BTb2ieU5mPx1p7cl/ZNVcwqGoyUv2tmINigCTmEd7yZ?=
 =?iso-8859-1?Q?8T0UsATcP435DIU37o1DW/KQ6MoNEyDatEiUsI2/MjVruKM2UyCdXdeL2Z?=
 =?iso-8859-1?Q?DnmlhhgROYvmpVjJCawgosbvLzjlOK0t50AZIlsNc4fJVtt1IomEg3Qeof?=
 =?iso-8859-1?Q?Eeu03gLYCgdhxj8J0Ej73uXCzTUWSHhqSZ8C4U+KHIvHYBy0ZXRMdvb++4?=
 =?iso-8859-1?Q?Qs5AGfKaV/Cf0kO6WKuY2/WyUNHeT9FlKi0cLVAsQyj2SJG+MVUjyEdKkN?=
 =?iso-8859-1?Q?w+UEK9N5IKV1d950qH/s+MEgzVfXWTVQRtNwgCOmWnmmomZr61extbOyDz?=
 =?iso-8859-1?Q?rGQL8NllApUtB8ItgvNQmdneVZL7RG0TZi5eVsvOPnn5cAbx7YqfNNVrKz?=
 =?iso-8859-1?Q?bpyBEWb1CaGtYiLhXvbv5bfh5j6NuUl8Kh++qcXOqp5BZ2ihDZklKbPuqk?=
 =?iso-8859-1?Q?3tUD19fCK8DrL1TSt2nHbAZvfUCPnowLxAWpQBq48PqY8rHU3KtGH5jZVw?=
 =?iso-8859-1?Q?pJ6mHxRuvuJhxCvymiD6tuUv5HMJGi/Bd4wnqIFDJ7/zAnAueHG6Vzq05R?=
 =?iso-8859-1?Q?jvY2opb2HfgWPOub62kNWppambf68VUP9/Wyv8JOB0dGKeMgp2mgP6mGL5?=
 =?iso-8859-1?Q?66uv8oEoSkuvN+lCsPzlbPrk9fRa?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR08MB6951.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?HVr3Mz3T3f8Wz0DtC94SG69JSozCTAqc52NfijQ7ilWDN5LSVTnR9kjw/f?=
 =?iso-8859-1?Q?igRsg9W6xgUspN+FMKyYmLsCbkKF0BJ1d4E6zP2xZZwNbalwstUYLO4Cu7?=
 =?iso-8859-1?Q?XBfb+RlMFww4W/3fZfIn4zAeX4xzdWG524l+m+xtpFAxXdgDnhHnZjIw+v?=
 =?iso-8859-1?Q?trZA477by4U2WPOsgGESR0gnZ3p1BhlJDrLDy2Tep274U1MbzvmJgPY5Uh?=
 =?iso-8859-1?Q?OtVRK8EG3RL913+WiMxAzgR8fqIj/O/WxcKh/ia2sw2nRTtNMJfJ6kKw44?=
 =?iso-8859-1?Q?G8ZllKBdVUtu+R4q+Zq0XQDgfXMnOWpK/ktWoLGWKBy3Q6Hw2/KzQ2W8yl?=
 =?iso-8859-1?Q?l6eotgnQAIVorVRFnInDp0y1x41dWq3frRRzCFsZuvhmag8zcDftXof2Tc?=
 =?iso-8859-1?Q?dzIOBouCW178deLcqYDJ4G1o7BX3qNuT3oFDlOxYpLmQPvGeNLz+Uqp81e?=
 =?iso-8859-1?Q?76H2hXGEFG4jSG7L0Dkd/r2Ks+FMPRRhOh3VbZUW2WJv9TD5Bea5nV/eKc?=
 =?iso-8859-1?Q?/xNG8sjFwKb+Sxvtrx6zWRjUH/Tnj0sAcU96jsX0ni8WoEdv2kqqgMQ3UK?=
 =?iso-8859-1?Q?/LQazW6AmsOLFl1DODoprq6dZD3H0pb6QtlSk/OH8M8tichsA8JhqcwrYE?=
 =?iso-8859-1?Q?42vs34k6Rl/Etqju4HlqXm250rclZiEk8YqRSVw66q3Cx/w9uve5qW5JTo?=
 =?iso-8859-1?Q?RxLMMhFgXSbr53CuB4Bsh6c6f9gD4ktQw1CvparlJ1xuBw00uT81sp935X?=
 =?iso-8859-1?Q?zhg+CAPnR63VuDGbYHHzUQbspbcrFLVfKqse52BhgfkXu2urK+Ewit9YNw?=
 =?iso-8859-1?Q?1WkhxAyf+uudq3AbPOLRsLPMRpByzSpIOFQFymNNEf4vYeZkGSnQu0+IE7?=
 =?iso-8859-1?Q?ertWG+Q8RXeRZxXZbr5X+IrP2hsMDvocpbsuZDMzkAX43RGy5VQMgkp7tt?=
 =?iso-8859-1?Q?PHvJAiEaDVIUV60DpsE+4cSEfMSnYuOmYc/ywVDU64xlEvNClHf7CKtD/j?=
 =?iso-8859-1?Q?Extbu2RV5AM4dME92TURDcNsASda/8e1jGNLds0wSnzAom5Okq6Fgz2wBy?=
 =?iso-8859-1?Q?vPnr6MTNVm3lsp7F6cb0cyeCqd1rG7cUie/vI+uQLsAT7XG13LBAvLS7he?=
 =?iso-8859-1?Q?+WQm2A/k44r7j4tffT51L3x2Pj4Mavn52YqfE1UXjxw4ts0k+oiPUTaZ3J?=
 =?iso-8859-1?Q?wGxH6OVx8a+MCVNqD7xe9w953LpXPXlhTzOf8EKX8pRgoaGBh4o2KVQ/KM?=
 =?iso-8859-1?Q?19VAk41de9kzopgYs2lv34kyUZmPrUg9UQGL9f8EPlRegSzW87go35q7Zs?=
 =?iso-8859-1?Q?nDbrW0v5hCsNDSPgax1/isVukotP7jiQE17DCRH3FaZ7yaMG0vkOx+1phM?=
 =?iso-8859-1?Q?QzXaQdIpx5bmlQwxCcVpCWHJePDHRxXHFKGS6hPtHxakfsoU32Wzo8wb8v?=
 =?iso-8859-1?Q?13RDzHu89qkEIduziry55HXFv3NAjfCqFxquwoB1nb6+NM7hIQU62Xwm8/?=
 =?iso-8859-1?Q?1JNvkhrXJBC5X6PUeatmpl8XsPXFhs+HrL39QgmfHbrfD7hB9zQiD/GAjZ?=
 =?iso-8859-1?Q?yl7yoIhlrfCWFfd0wmPeR0NuoZ8LaWCwjQorlSXvlzdaUSTq3PUzNMeAX9?=
 =?iso-8859-1?Q?8bnpkk5XONweNIOe12YawP22Ti6rOfQD64fS7J7lzWv5To8WFowwWYI+JR?=
 =?iso-8859-1?Q?xZSnaCu3t4K9zHpR2xMP+mNkNRuYXwywinxQLXB3Naem62Mpiy4FQn6NeH?=
 =?iso-8859-1?Q?FzOi4s3gX7MlRv2ZysGHLTz4NhBsYgqn7SsYRSmw3EbYVR6PKKu7SW5cwF?=
 =?iso-8859-1?Q?5qZRS2SxhQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7b5480-3d6c-4303-899d-08de52eb99ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2026 21:34:58.4111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H1LwNRPjHrKu6KEd0uNXDQTtKSrVdIeFIvy75hQMBcAzHp4BylLdrzQuA9kG2IMDtGdOZ/AdkPmshBhdtHCRjG6pSBcwKVbiM2k6lmnrmO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR08MB10901

Fix the following on VFIO detach:=0A=
[  242.271584] pcieport 0000:00:00.0: unlocked secondary bus reset via:=0A=
               pci_reset_bus_function+0x188/0x1b8=0A=
=0A=
Commit 920f6468924f ("Warn on missing cfg_access_lock during secondary=0A=
bus reset") added a warning if the PCI configuration space was not=0A=
locked during a secondary bus reset request. That was in response to=0A=
commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")=0A=
such that remaining paths would be made more visible.=0A=
=0A=
Address the vfio_pci_core_disable() path.=0A=
=0A=
Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>=0A=
---=0A=
 drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++----=0A=
 1 file changed, 13 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c=0A=
index 3a11e6f450f7..aa2c21020ea8 100644=0A=
--- a/drivers/vfio/pci/vfio_pci_core.c=0A=
+++ b/drivers/vfio/pci/vfio_pci_core.c=0A=
@@ -588,6 +588,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_enable);=0A=
 =0A=
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)=0A=
 {=0A=
+	struct pci_dev *bridge;=0A=
 	struct pci_dev *pdev =3D vdev->pdev;=0A=
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;=0A=
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;=0A=
@@ -694,12 +695,20 @@ void vfio_pci_core_disable(struct vfio_pci_core_devic=
e *vdev)=0A=
 	 * We can not use the "try" reset interface here, which will=0A=
 	 * overwrite the previously restored configuration information.=0A=
 	 */=0A=
-	if (vdev->reset_works && pci_dev_trylock(pdev)) {=0A=
-		if (!__pci_reset_function_locked(pdev))=0A=
-			vdev->needs_reset =3D false;=0A=
-		pci_dev_unlock(pdev);=0A=
+	if (vdev->reset_works) {=0A=
+		bridge =3D pci_upstream_bridge(pdev);=0A=
+		if (bridge && !pci_dev_trylock(bridge))=0A=
+				goto out_restore_state;=0A=
+		if (pci_dev_trylock(pdev)) {=0A=
+			if (!__pci_reset_function_locked(pdev))=0A=
+				vdev->needs_reset =3D false;=0A=
+			pci_dev_unlock(pdev);=0A=
+		}=0A=
+		if (bridge)=0A=
+			pci_dev_unlock(bridge);=0A=
 	}=0A=
 =0A=
+out_restore_state:=0A=
 	pci_restore_state(pdev);=0A=
 out:=0A=
 	pci_disable_device(pdev);=0A=
-- =0A=
2.43.0=0A=

