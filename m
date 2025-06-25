Return-Path: <kvm+bounces-50734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C133EAE8A33
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 18:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D30DA1BC8171
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0CB92D8776;
	Wed, 25 Jun 2025 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="N8kTYq8r"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022092.outbound.protection.outlook.com [40.93.195.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BC42D4B67;
	Wed, 25 Jun 2025 16:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869713; cv=fail; b=P3YRv2Z4txhgqL6tQYJH4hzXaZhCT5cSr925RpdUU24Jj20JXqcK9uAP6PuctXEXz8mPVcYAHEjDD4NAstLW0gspD21Z5u8L38etJ+CFV1Obo03tDICMFY7N+rPk3O747Wdo7VIhUyYnivDw7G55H50BRZNJ2NLF1zPo5OXnw9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869713; c=relaxed/simple;
	bh=GZpx4RRZ7HXtRVwDr2cGp7yCnxYAJjQAkwkHiUmvoug=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fNNe5Ktk81+RaoqU5c83LO7d6Bua6ZU9n/TFG1w5pbzaocI0ixgxmOSKngk2ifCWGF/hCc8TQucagjjQKHm+k9BoaMoOC87VxFhbOQPfnZQ1XYpTOaxZ0BM3JjLg/clmTmgtexQRBibOCDwzBnbXxWYrzzGAmi6oC1Yoz40hLwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=N8kTYq8r; arc=fail smtp.client-ip=40.93.195.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WAh8ZPVuePWkERPliuAKhuhT/iTBulV1Hv9WwK3ocD41IbKi4k+kO6nHNuYJ/HJIWIdyrOPm3SDWt6Jh1a8tdLDhynJwKg51RIuDF5ZnnfEzbkKvafEsf9HofcuT5qgybQtcDO5vy2+CUZew409DBta9eYUCpWDPxo9SkqX+Hb0Yk2HJYCaWZizKbBjvbH6FSV7ONIV4LaHbE9WMyXbx/crRqx1bfe+a4XCXqVXxa4BFa2HUBrgMFpsMOUZCr4tUDt8xbAY8PHbSeKwpwwFHC7VA9u+wYZTCLYC2kp4wOGB+CVLatem+4/zqEYzs13+z9aDEwbtMdMkO1LDi44fKsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOf1HofTIEPN11GIXqK7c7KivJp78qzSsLMWCl3+WBE=;
 b=FNL01sAb4WNULvfgeyo75d80bYe5M+sIZZVkbQzd0AYk7UwxHW1YLsyWUYmtxtS3uSonrdloeNcfR3N1XUTeRvFRfyQ5i6TVRbQ//WLoGDdEyfh01BCW9a68pojoqnDpu2/p8FPBLs6MHUfGeNqGRl96KumiAtcolWVHgIZEw36Nklj7XwEY06d82QIWJ4uGK3/qTA3DZoFc3wYwh5utJX406u96OLyJl0W9PmBMPtcwAuHIxYFJQUqjEHa6RHCcmOaBr4ZTZ4kMxkFemmxgDD6C7v5sH20frkH+kM1ONmVFkbCbAY7JPD9wdyEpKZ5YWb/Kz+Sljmqnlw0SY/XrEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOf1HofTIEPN11GIXqK7c7KivJp78qzSsLMWCl3+WBE=;
 b=N8kTYq8rLWqXgVGkITcXhvrBKLYFpdcSQSj95WLUMy0X46XjNL9QfvYLaCj5p48b30yipihjQzCvtleoejLCjz9/tH+owR5DYSPnzq4ECPOpMxnUIC1DY+xw9RWgL0OFo/pD+FzMcujhfw/zXCGOWy11AllE4bJUhB74ybPcIxQ=
Received: from BL1PR21MB3115.namprd21.prod.outlook.com (2603:10b6:208:393::15)
 by IA4PR21MB5339.namprd21.prod.outlook.com (2603:10b6:208:553::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.5; Wed, 25 Jun
 2025 16:41:49 +0000
Received: from BL1PR21MB3115.namprd21.prod.outlook.com
 ([fe80::7a38:17a2:3054:8d79]) by BL1PR21MB3115.namprd21.prod.outlook.com
 ([fe80::7a38:17a2:3054:8d79%3]) with mapi id 15.20.8901.001; Wed, 25 Jun 2025
 16:41:49 +0000
From: Dexuan Cui <decui@microsoft.com>
To: Stefano Garzarella <sgarzare@redhat.com>
CC: Xuewei Niu <niuxuewei97@gmail.com>, KY Srinivasan <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"mst@redhat.com" <mst@redhat.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "xuanzhuo@linux.alibaba.com"
	<xuanzhuo@linux.alibaba.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "stefanha@redhat.com"
	<stefanha@redhat.com>, "leonardi@redhat.com" <leonardi@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "fupan.lfp@antgroup.com"
	<fupan.lfp@antgroup.com>, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v3 1/3] vsock: Add support for
 SIOCINQ ioctl
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v3 1/3] vsock: Add support for
 SIOCINQ ioctl
Thread-Index: AQHb35WpeVM5DgeyJkaZiqfinVY+c7QTd1ewgAB0kICAADRWgA==
Date: Wed, 25 Jun 2025 16:41:48 +0000
Message-ID:
 <BL1PR21MB3115F69C544B0FAA145FA4EABF7BA@BL1PR21MB3115.namprd21.prod.outlook.com>
References: <20250617045347.1233128-1-niuxuewei.nxw@antgroup.com>
 <20250617045347.1233128-2-niuxuewei.nxw@antgroup.com>
 <y465uw5phymt3gbgdxsxlopeyhcbbherjri6b6etl64qhsc4ud@vc2c45mo5zxw>
 <BL1PR21MB31158AE6980AF18E769A4E65BF7BA@BL1PR21MB3115.namprd21.prod.outlook.com>
 <wgyxcpcsnpsta65q4n7pekw2hbedrbzqgtevkzqaqkjrqfjlyo@6jod5pw75lyf>
In-Reply-To: <wgyxcpcsnpsta65q4n7pekw2hbedrbzqgtevkzqaqkjrqfjlyo@6jod5pw75lyf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bc873e8a-0bde-4277-b90e-541c0b15b69e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2025-06-25T16:39:22Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR21MB3115:EE_|IA4PR21MB5339:EE_
x-ms-office365-filtering-correlation-id: 49b7832d-1ea8-4b40-216c-08ddb4072e31
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?l7rsz8rTKtI2ZmkJ+8Q86CxZioglYugyLMKr5xEj7rsjjGkTwJlTkR6+5cUf?=
 =?us-ascii?Q?2bW+9V7vVYmMuqsQkDcbtff8DcFXXZt8eEqrpenHZiLtf+Py493yC1EjjLq+?=
 =?us-ascii?Q?eMHmDQFsqhu0pfparqyjq2uUsJjsVef7EJNNzMKJdJm5oVYFP20Sq1elmkFq?=
 =?us-ascii?Q?WX+i4naRbCR3H2Yb1msZTJ+Z6c0bXmes/n/VE1Gy+43QW7I8G6giGhFopzj0?=
 =?us-ascii?Q?g9N/a0GNJxUUo0GgAJjYc/iK+7P+ZcJokgI53RuKfEiwShoqWCGMjMKLUb/r?=
 =?us-ascii?Q?pLwLE3p3GCbUvtjagz9E+YnAiw4PHnTRRI9KJgYop28XNrDceLpSAhVPH89y?=
 =?us-ascii?Q?F2S4p6vh88j/FcS6bDZeQdlv3nq2/g+V7VMtYl9XDUqHAlKnM/nIadYAf9Ui?=
 =?us-ascii?Q?r0VBAgWDT7D+PgbeIxRts+pK7co8au0y+LEzqjt8OgH5OkrdzDzbeCqEure3?=
 =?us-ascii?Q?I3LsmqrTTC1KQRaklQeEz/O+hMdWOopFRX5L9aMRTJgF2rvVVlWQNvjoi/so?=
 =?us-ascii?Q?RHdpNUxVJPjNWRTgaUls5NCt+SNDejKuJpVNC1m0DlFy9a/3bf10BSyLwr84?=
 =?us-ascii?Q?G9CwJIXFm3RUyfkB8fz3tcKI1/QsDx8QOe4GFUmUaKnkf59pgSnpdrLFbpk7?=
 =?us-ascii?Q?GnByrSCapCY4wCtg+BmnCPG2wPXT5Kh60fcp6F/Hn0/GkUNIYh5LkdXccyDB?=
 =?us-ascii?Q?hsnbjwvh22N/iSjqtief8Qe84tAWXILJW+5yml/dGZab1hNwxltc5D3S4U9i?=
 =?us-ascii?Q?cjQ7tcZL2R8D9+v6x5zWY2ytpOT5NPJ8lOKgvBPnp2T02km2ZSOm2ZbZl1AA?=
 =?us-ascii?Q?8Fbi+rPcwq683N0uJLWKEvFYn2RHgbVjOLhKF/nNsvxQrEwzzJSKfyIxKVHB?=
 =?us-ascii?Q?F8pQrErxRZ8wRbsdEL7/akPbsU67DgZ1Z9PQ8AV1D0avZasilWE+QQzJRZzR?=
 =?us-ascii?Q?HjL8yEwN9D34hdUx9b4EILE8ClHlAEhU8A6vsrXiYUcxuGJ8RutxzDuto/9F?=
 =?us-ascii?Q?ocDRwbUX+fdYukmbwl0iLdsW9LN65MlAWnN2W7VkrfOqTyviy01i4bqLlnD7?=
 =?us-ascii?Q?xb7iSzw++rMlTlSw/bN6fSzL2JzwL81vXk7NoATjAquDFu1txbTKVKKuWcbQ?=
 =?us-ascii?Q?oTRQim/zHrTKlakJ+fiV+jgDR/4Vx+H+u4zYgmWDB7Zv9XNkPySdXaCDYaX4?=
 =?us-ascii?Q?rRVPBnExsnQjJljWLZ6Oi+2MHIS5JwtVztDJolAyjAutdHd7yrlsXJRdMrFN?=
 =?us-ascii?Q?eyVnWg0za4B6NDRUQQcbVzZbXTwa2JHRB7O04SEgbHImgZIUk6sJYiIv1cbs?=
 =?us-ascii?Q?JuUrYNU0xcVdLVdL1VQDBoVH+6oxa5VGmqATKqk01POdblsvahn8yM9UWXh4?=
 =?us-ascii?Q?21bn/aXZtsMW8BoE4C5IewoMpQR3WHKu0JIOMN+3ut8iyM4FubDneC1uRRYk?=
 =?us-ascii?Q?H1kPNaYr+FEjNUoMIFeqnQL7qccc0JqHpj2Y++KrIzzazOxhoqdUBg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3115.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?lzh10LQloBXxRdLjavMhHvYhNIEbjrUDjbdP4eyYbTKeEGNyPcrciVUQvgk/?=
 =?us-ascii?Q?+F5d5vJ2H97O0K5dDjCWCALTN/2H0tctJOuqPgetBgU+tZSWVSWNzRL/tSmj?=
 =?us-ascii?Q?z+1YdakbXKt3U2I3GNblRIytQE7Tc0kX1Ly9YsG+zSqMuVF/JWP9xnaYG6Uf?=
 =?us-ascii?Q?l+RW6yEKcYyPdK3ed6ehNF0OiBf0LrrlEdTYsCXJienhBHqBu0j4XtO1OZQo?=
 =?us-ascii?Q?lVmGUO9aAHbLTtV4WrVFLCxRHCbm2AnYE52ofnqL5xvm+6mUzJNMDdWCjl2K?=
 =?us-ascii?Q?CxvRPl/OGZ/d0kmRfTNJGuxftp66G+NDRqKITCILZHKYA0X3k6HbqBZMx6Pf?=
 =?us-ascii?Q?Dc6aPMVv+nw7T2NgyxGf1THWO5UVuuKBtwM8u2c0RBHhmjdL84VJ19J2EfRD?=
 =?us-ascii?Q?2M0xgCIzbKoAmwqZQX3Ez+b3fCc9o17GBUaOuDnhlco0rxdytAwTbgGg1fb2?=
 =?us-ascii?Q?z24kIyky2ISQ1Ca3Dz5ny+QNKWvoYWkVdUQPFMXR9mbnbAB4Pj3ABCfzHXIG?=
 =?us-ascii?Q?8BMDjeV8C8n7XofD/2mOmiGszFcLrMJsaNf6ADgfOCkGyP7qqeQ2VDD7uh8h?=
 =?us-ascii?Q?LLVI7jCaKQ8+8f2v4lDykwuARnGGEC9kX9Zh6jlNgwMtVqD5tXCjlPWJEi3v?=
 =?us-ascii?Q?+IdUu21U+F12ydSlWAoO9RugPk8UIj53hBt4qQF64ioJ8P2LF4z5lVn+fNOq?=
 =?us-ascii?Q?u1wPJep8NIxQjsE7nfcuBgRM4rYnRvpHi4LUxM4tH4SGlorBorpBYTlJAbkJ?=
 =?us-ascii?Q?qlpnmLNGV48RNnl0HrIV2EziRBf0DZSIRJ4o7fa2Cy4luymdMsVBBPbYBCPD?=
 =?us-ascii?Q?m0iRVctxu/MVLb37G/+7wR7EorbE7EA+FLCagPVWvkYFvS+l6FSYdfrbwlDC?=
 =?us-ascii?Q?uf7An9zat6uVGAJUch00D2VHuY/ah46/GIFzGb0N5T1ie13HNR5JypXGAKO1?=
 =?us-ascii?Q?1Wa08hPKEX6tY5rJy5dHgzgPgi/p12eWB32TrR1dlDKqRjFdsKMswaqB2hrz?=
 =?us-ascii?Q?HZ4dmR9Voqs+oHihHf+bGWrb9DGUAg0Xit5iWmQyNq6g9AF1MTQoUz+rRzMO?=
 =?us-ascii?Q?L91CQh+qPIWnumofJpr8IGkfCWl2vWAwjh238rOkxG3HcJNd1/clwTdKA3tW?=
 =?us-ascii?Q?X7vuNMkIC/Axjl5aUwHglPaUrj27FhjPmxzE2wZ+9gDie28k2qImTMbiScvF?=
 =?us-ascii?Q?5oQct8XJ76jhrWdlWHnxhcZlP0CVR4T8l9U5enultcB1QOThVXP77gT7g9cN?=
 =?us-ascii?Q?7H9GUajA/eEcz74/2aguKY0Vd0DEV4Z3ZLYWoEKR/qtiHedezKhWjlMDG3CB?=
 =?us-ascii?Q?pcXZSA7j9zOdwbUN+DBPdzELls5UaYCBRjly1w6lEsCQVzpGHHAUuEhJYSFV?=
 =?us-ascii?Q?auCBuDOJGk5053OzSav3A60wyjLC+bYPA13xWrH9GOjArOpkm5UsurypVYpR?=
 =?us-ascii?Q?B5QNJFRYK2S30z7DqjdEczCRztd+yABTGgNzmP0sqL0gC2dKSJRUCZz7+OJd?=
 =?us-ascii?Q?47+Wx5FUpPYLdDrfG9rK9rc2a3e53oQFZ/LIesyre8Y3ZpN2Q9YgyoTPfKL5?=
 =?us-ascii?Q?Dr9n+owl9eERZfE8CV2zIHwcNZXWkDcEmlpj+bDRGLyswHyi/jauMcOZASUX?=
 =?us-ascii?Q?r56qsC01/JgUkupeRuelB01LiRDjmpCtF9oPWWtETAwa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3115.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b7832d-1ea8-4b40-216c-08ddb4072e31
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 16:41:48.8656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PQBxzHHPr5WUogguJnjsgpgkka5Q92UbTyn8ylN3/a7oVSr4bZgtDlqb4EdpJljXHVzlCPvK2cwPHOUKLZ6Pfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR21MB5339

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Wednesday, June 25, 2025 6:32 AM
> ...
> >I can post the patch below (not tested yet) to fix hvs_stream_has_data()=
 by
> >returning the payload length of the next single "packet".  Does it look =
good
> >to you?
>=20
> Yep, LGTM! Can be a best effort IMO.
Thanks! I'll test and post it later today.
=20
> Maybe when you have it tested, post it here as proper patch, and Xuewei
> can include it in the next version of this series (of course with you as
> author, etc.). In this way will be easy to test/merge, since they are
> related.
>=20
> @Xuewei @Dexuan Is it okay for you?
>=20
> Thanks,
> Stefano

This is a good idea to me. I'll post a patch later today.

Thanks,
Dexuan

