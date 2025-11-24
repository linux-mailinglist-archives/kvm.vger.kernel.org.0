Return-Path: <kvm+bounces-64412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB50C81DFD
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 261AB4E48DC
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 17:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7E62550A3;
	Mon, 24 Nov 2025 17:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dh68fJvk"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BCF22424C;
	Mon, 24 Nov 2025 17:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004945; cv=fail; b=tofIw+cJaPuXtoSutE32P0cNgvxanoB3lppvslK7EN/IhMitham4KCnTOQeco3SgqiBokvYxqJtEKy33MvjM2htZ2Pzqj6bDMjjX/cxwVRFDE7pN+yqllPML/dl3CiAIxvlZBL1iF2qDtujZGU+kmJefn0f4+wA4C3ysqNJgZ8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004945; c=relaxed/simple;
	bh=CcBdwfUaj4ZkuIZcg0fdzgEDoAhv4RbNg19cK1i3WEU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i59/P3wI7QtjMZMQxkm29+q+/6PYYv6Az1HchqYxUAIAzNIg/teDRtN1Y1bC1d7IUbKbEfcuWILSoihLutc26IaPJW5TsS3xo716zGzv85XicWr3GEjl/wzyJ+VGagv3IOb6+7WzT2euvLqZQq2i2VCWrpdM77niMnJULynaJgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dh68fJvk; arc=fail smtp.client-ip=40.93.198.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+QmgQ899MHNtmDEfc437WzgXOWXT6MZo1Xmn6pim+C3encrV67n8T5ml4JLDQsnBiC/7CLIgq5MTt3ARWtWp43/GTg2ojq8yV6Cor8FJ5oyg49XlMTsLUaV5iq/OSQ7ElkfgxHYdhNUCxYCJ8S3oaXx6BqNN1J4/jzZcGO0M9aSJ376yDZY4AGxlsVlZHxayZvpNxeleIBLGTQKhyLBdmW2KG913gVmKobn09PewXSoD+1ESIXDuzaJqzC7liZ5RadMoqdEekLl87NsCZ/vZHC/9T2Kiu6+cwxQo3yiDHkHTgey6ggCwOdmZsziFL7cYKqgsBhHpGd6VIclSU6jzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWSIiPFioEstp2flv+ATxYWOOQlaTLitAGF4Em1ukBI=;
 b=y84Jd1o30XMqiN8rw4VJbfIUkXE93u8PfzfwpR3xv/oG0DGDcEk36phXFZiUvP6zPOBlSfo/H/ptodF85yJ1j09/fzHPNuHGKqH2vad5KsuWBzDR2yVAbv6YkOy3EkXPsSyfLyxMNAC0E4Wkecv5B1/V8fLzw2GyhjTwlLedzNK7XHMAVqgPM6Uzr+xFB6DV3bPgWw7zCWLmgeVQUr/lK5nIt18zbRAHBzI+VzEp5xzEB7VMpu0WwitcVtJ2MSwsCP/jdLWjNXCmJZiLodTGsPTLThRxKMLkNGLH5TgUQ7LScTsS0YEv6pkflG/nfzfcD2OSYVEh32reJl3HxojH2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWSIiPFioEstp2flv+ATxYWOOQlaTLitAGF4Em1ukBI=;
 b=Dh68fJvk8xP9NwH8dIy1XGR49n/R3u9G8kfDTAqoSpHQeNpem7f3z6kynkhlavdmy+d+vLi5/qfzwIxeDvbxa9rLqNXBxARutN8Hj8RJAygVPX5b7//5pnl1lxUg3AutYzAHBRKPTUZ6jotOd67pQiQzNP+h6jJvpQJ0mjGL7It27f/+BXLhNxqlsOJegGLGXcNfz9lYRY7axgptCU1EXHNy8SeXfhL6YEy6R2vm+oNvC7T8suHUEwb8m/ytZCSxE2batXQDKCQM1lnCbeCve8Le2SEPgTPDYrxCVydfNcYsd3/Bo6aVmBAvPdgxeELc1H+8mSUJCBw463S1HlCdsA==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by SJ1PR12MB6362.namprd12.prod.outlook.com (2603:10b6:a03:454::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 17:22:20 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 17:22:20 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai
 Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>
CC: "Yunxiang.Li@amd.com" <Yunxiang.Li@amd.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "zhangdongdong@eswincomputing.com"
	<zhangdongdong@eswincomputing.com>, Avihai Horon <avihaih@nvidia.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "pstanner@redhat.com" <pstanner@redhat.com>, Alistair
 Popple <apopple@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>
Subject: RE: [PATCH v5 2/7] vfio: export function to map the VMA
Thread-Topic: [PATCH v5 2/7] vfio: export function to map the VMA
Thread-Index: AQHcXTnU3rC6YWJg6EmFrja7cVopKLUCEmJw
Date: Mon, 24 Nov 2025 17:22:20 +0000
Message-ID:
 <CH3PR12MB7548B4BC5D096DB3206A3F05ABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-3-ankita@nvidia.com>
In-Reply-To: <20251124115926.119027-3-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|SJ1PR12MB6362:EE_
x-ms-office365-filtering-correlation-id: 7f47184d-b9b5-4627-727f-08de2b7e0658
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0SVlb37+PFymXyb1q/INnQVhreRXsibeK19/zaeCIR7p5UXPHOkShnKspXsI?=
 =?us-ascii?Q?LL0LTKCrKEq73j4QphqSsrW2QCwp+KQypCDFtF66+8ILSbbOzNTJfyjCnnSe?=
 =?us-ascii?Q?r2NvvDS7y4hbAQZM/zDOxIpIq/1dl2gWORw9ZleIIWUyE6JS2FP/w7KiFe7k?=
 =?us-ascii?Q?htc2vFSREAPg3MYxjPXatTVw54//4S0TtoJbHR9jmJffkxWQxR4haBpxISad?=
 =?us-ascii?Q?WASD6I+zaZa9Ir1fl4RNvX8Btwxht3148HhMn+ynEKG3AsToWYmdI0Mq5rp2?=
 =?us-ascii?Q?0lZGoYDEmcZdd4xL1D2GHcsmhb18O2ERE68qEJSJdZZtURbBdzif4uBHTbWS?=
 =?us-ascii?Q?pdlhFNf5lMhONhC2zYpsVtDAKlsgURCYEhFFQgRuGwNM6co2EJyflYX6yEqR?=
 =?us-ascii?Q?xdBnUc4gQc3w/4WMt8sROu1aqVMze8mD/Gy1mH7WzX8p4MTB6j6RB7VKfKuF?=
 =?us-ascii?Q?jyNGsXWQE9df767097xa8HaoadB1IpmvehVc8I/giudVUWoCD1nsFpyPH/Hz?=
 =?us-ascii?Q?h69z7aYmxz6j3obnP5L1wgpTPdnENcma/0GRCWr4vbKW770FO57bZaDbVISe?=
 =?us-ascii?Q?Q4zG4ghkl3ty7VbPXiCHK4w2WC7O3D9Lh/t1GjXOKx5OJTO/CvCbmlfVlo/c?=
 =?us-ascii?Q?ajfSxyW3OsDoPf5lhH8vmufotqsEf75t/agwmABfXsPBoRGBll2foq2HUd3t?=
 =?us-ascii?Q?hQh/nGaXfWeH5r1olhQMva6DpEkWAc3YGLr3Efig9V8q6IwKNGTFXCJZePYc?=
 =?us-ascii?Q?ab4Eq0XFI1JtxSCDcXA5TPXdGGLaHElEvFfHZatIwAyeAwhyvLuVgeFkfVQT?=
 =?us-ascii?Q?irq9P0SId7bWXUbiu3UWUJkyQhBZ1myabY9kMxC2gQnm7hyrg0rQeJrVFRPW?=
 =?us-ascii?Q?LVQCZExTmnBfe9FzYgJfDqW74qerfvGi0FfCJ3chEbjz2eUzkhcnZnazXZCr?=
 =?us-ascii?Q?ehZwJD477cBfeTeu8+WSMANVkM0zCwI7kN0keI8oYTrTTOLDK5e+HXJlU7qd?=
 =?us-ascii?Q?vv9/AFBHn+En5rmGAMFOwCORaDZteeg98asWQmGy3ZHBdoU2tRsP9p1D6TEc?=
 =?us-ascii?Q?KrDElGiXyulQbXyYhSgxMrzRLcF5eBrAlxBr90TI3fU6DURdKzOyL7dIfIvs?=
 =?us-ascii?Q?dvmFW2U00c/JpQ9G00m28gc5vuW+TxCXryN3LiGr0fBSnli/2mSDme8umX8/?=
 =?us-ascii?Q?5A/odoV9Jun4JqyATQhcOV9g1xmF+ze2DgPaSLbi1iPFzv+8my73Zk3PEj4W?=
 =?us-ascii?Q?+JZOp0TioVGf9qrzbD5BpW5zjw5txPyaKq5fvXzDSXZG+vmmRGFDvWS7JcQh?=
 =?us-ascii?Q?AuGg2znzuTk9PPjBhcYl0wHxyEvHu/beOj27mQ4OD6GkGEVswF5dAOYkRbaj?=
 =?us-ascii?Q?umn1/ezYSzAzS4hOYmKIXwq5Lr7f/lvsVYu6biXLaPLfOe+ZIvUgeogDZ0ji?=
 =?us-ascii?Q?nptn86ZwnO9ODKgfWAlOiijzOpiM82BOu28xscww4ccpC5tLtoMSb33Uk6eD?=
 =?us-ascii?Q?GjeGKaK5OZohfSoodlICEgHV/vlR67LpilRM?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?4qXHSl9qeVoNHcLpUveJEQcF7fR55HC9jiqS3skvuCQ3zHWcjv7PRPQ10xsr?=
 =?us-ascii?Q?R/zn78AITWGvfImmuo92G3+HFI2Ta8NfW5+uKztBHSLYl3KFKHEYy3ifAkED?=
 =?us-ascii?Q?gMHel8VAigmWqE6S3YxBvjfKbyyBWBJbh3FcaKLvb5bx+aBfnwQICicgjx9T?=
 =?us-ascii?Q?X2Z8odUFkWTMi3KrLeMBKKdQ7O4jZvn1alEbWmv/oThub5w6cIpw2sAByo7m?=
 =?us-ascii?Q?G13rO5+FyGFsNfF2cPOPxk44TGwZvLI3btS6RfxGPB8Z+eBVbECp30pr1QpS?=
 =?us-ascii?Q?iBzrKYIypltKALghLFbrGgPlpuEz2wVy776iE2LrCEE2BPeZx8fZuo7LKuEh?=
 =?us-ascii?Q?sg0dpM/x+o293N4RNnZbbwmRpRt+y8geSLqSA+7b/KkAAbm1qxForWvVSfDI?=
 =?us-ascii?Q?nysU/+rQlyYZCWf2ymdQ7oDBXvSrT7JQtRk4XE26QJ0yHuTRxddQC3krOKfu?=
 =?us-ascii?Q?5Z4SnMamks+t6jQXcDDnJs+UQb9EmOTyHtIZV1ugApo/gY1LutcVx7ODK8NH?=
 =?us-ascii?Q?NzMJE/9tG31dZbsz/CRtli0jpWJtUjGF2L7abfxLDtQ/kha//54d/sVad9ZH?=
 =?us-ascii?Q?h+7p6FVmvHEdFJB0RonzFGLCQBiHJkPLUsfRe/aj1ps3RgPG09rTAE6upMiX?=
 =?us-ascii?Q?JvbJZKnPEMuBg4z6AzKKGKsl7coAeUqkL5GllFvPcPRyQ93+CKCqoc5wagta?=
 =?us-ascii?Q?o+TH9P9tEMmZeAgupNIu/OcLyHP+KpyCtRuTA1VpqE4Yey2Izy0MiVPliPs6?=
 =?us-ascii?Q?JcWhXiGmMuOqjYw47NUWKVihMBQI4232zpj6sqUvJOPUV3ady2jE+ePOuNhQ?=
 =?us-ascii?Q?QwWlPWWWcZlQ4aM8K/xg+m8z+t7Awhn/gz8IZoU6Ltk1v6Ggkywfdp/EK/YN?=
 =?us-ascii?Q?B7KiZmJOCSEK9au0i5A/zbnuvWsr2/IqIEph9+lhW4SW+Eg1ga2njGCAnu6j?=
 =?us-ascii?Q?qLS50j3GLATIDAx9LsI678JYPfWqg46W8dshDgOl4DR0aeWpjotmEb+JYNXa?=
 =?us-ascii?Q?LxXf4GHRPJy9ePNNo8S8tU+na9NYMCl6rBiSl4WmgA7++hoaOV/6tts9GPkp?=
 =?us-ascii?Q?cZLr88NmvgfGhn6M196XOLzYJSgDbJVdvgr0x9+YSexJeY0GwCcSAbJhkt/G?=
 =?us-ascii?Q?MmtktP5mLyg/MFfPQty7fk7VJQleqNRHKOUtsqT1CiurYODhI9PHd57Wk5fj?=
 =?us-ascii?Q?7cVNK+A5G3pcpW/s6+fJE0dYfyqbjQITCym64TduKiJ7jbiGNdguUnnvijdi?=
 =?us-ascii?Q?l9ryXp8vxorR2k9SNZN5C+SlnIaibRAcLyfHXso3hJR12Nn6oS5jXtfU7qb6?=
 =?us-ascii?Q?gHyxoOyr/P4rgJfweuOu93zennR+4Zs8+gJ9aILKpzJuQj1iVy1J5SDofTDq?=
 =?us-ascii?Q?qAOoSzbda+g3lBPty2RVNTdq0N551I5poKrSWZ7AOrR82ZD5Df+wz2H94y2S?=
 =?us-ascii?Q?HOIyUKb1LeylZrXQIecFfiPt36sZ7qpeDMkjSeeNLTEdpM0O//dF4tIRRTYA?=
 =?us-ascii?Q?Arp3OuoKWZrbtpctwR04w92RHlCh7kBCY4QlV7sMXqzJ/evF2KuQuqPLFl+k?=
 =?us-ascii?Q?AWfxub2z7l1OlV1df20uLuroDURJj3Yx/tago4BT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f47184d-b9b5-4627-727f-08de2b7e0658
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 17:22:20.4964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RLnP9nwdo9xCh/gkVqiTvq9PoRty2ZvtFgHN5GyNbXEl7yBBfc4Ii1XCnKKUl+atI9zH34fao+Eu4VP9uSI9NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6362



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 24 November 2025 11:59
> To: Ankit Agrawal <ankita@nvidia.com>; jgg@ziepe.ca; Yishai Hadas
> <yishaih@nvidia.com>; Shameer Kolothum <skolothumtho@nvidia.com>;
> kevin.tian@intel.com; alex@shazbot.org; Aniket Agashe
> <aniketa@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>; Matt Ochs
> <mochs@nvidia.com>
> Cc: Yunxiang.Li@amd.com; yi.l.liu@intel.com;
> zhangdongdong@eswincomputing.com; Avihai Horon <avihaih@nvidia.com>;
> bhelgaas@google.com; peterx@redhat.com; pstanner@redhat.com; Alistair
> Popple <apopple@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Neo Jia <cjia@nvidia.com>; Kirti Wankhede
> <kwankhede@nvidia.com>; Tarun Gupta (SW-GPU) <targupta@nvidia.com>;
> Zhi Wang <zhiw@nvidia.com>; Dan Williams <danw@nvidia.com>; Dheeraj
> Nigam <dnigam@nvidia.com>; Krishnakant Jaju <kjaju@nvidia.com>
> Subject: [PATCH v5 2/7] vfio: export function to map the VMA
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> Take out the implementation to map the VMA to the PTE/PMD/PUD
> as a separate function.
>=20
> Export the function to be used by nvgrace-gpu module.
>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 46 ++++++++++++++++++++------------
>  include/linux/vfio_pci_core.h    |  2 ++
>  2 files changed, 31 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index 7dcf5439dedc..ede410e0ae1c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1640,6 +1640,34 @@ static unsigned long vma_to_pfn(struct
> vm_area_struct *vma)
>  	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) +
> pgoff;
>  }
> +vm_fault_t vfio_pci_vmf_insert_pfn(struct vm_fault *vmf,
> +				   unsigned long pfn,
> +				   unsigned int order)

Does this need to be called with vdev->memory_lock  held?
Please add a comment if so.

> +{
> +	vm_fault_t ret;
> +
> +	switch (order) {
> +	case 0:
> +		ret =3D vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> +		break;
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +	case PMD_ORDER:
> +		ret =3D vmf_insert_pfn_pmd(vmf, pfn, false);
> +		break;
> +#endif
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +	case PUD_ORDER:
> +		ret =3D vmf_insert_pfn_pud(vmf, pfn, false);
> +		break;
> +#endif
> +	default:
> +		ret =3D VM_FAULT_FALLBACK;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
> +
>  static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
>  					   unsigned int order)
>  {
> @@ -1662,23 +1690,7 @@ static vm_fault_t
> vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
>  	if (vdev->pm_runtime_engaged ||
> !__vfio_pci_memory_enabled(vdev))
>  		goto out_unlock;

Is the above check not required for the common helper?

>=20
> -	switch (order) {
> -	case 0:
> -		ret =3D vmf_insert_pfn(vma, vmf->address, pfn);
> -		break;
> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> -	case PMD_ORDER:
> -		ret =3D vmf_insert_pfn_pmd(vmf, pfn, false);
> -		break;
> -#endif
> -#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> -	case PUD_ORDER:
> -		ret =3D vmf_insert_pfn_pud(vmf, pfn, false);
> -		break;
> -#endif
> -	default:
> -		ret =3D VM_FAULT_FALLBACK;
> -	}
> +	ret =3D vfio_pci_vmf_insert_pfn(vmf, pfn, order);
>=20
>  out_unlock:
>  	up_read(&vdev->memory_lock);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.=
h
> index f541044e42a2..970b3775505e 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -119,6 +119,8 @@ ssize_t vfio_pci_core_read(struct vfio_device
> *core_vdev, char __user *buf,
>  		size_t count, loff_t *ppos);
>  ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __=
user
> *buf,
>  		size_t count, loff_t *ppos);
> +vm_fault_t vfio_pci_vmf_insert_pfn(struct vm_fault *vmf, unsigned long p=
fn,
> +				   unsigned int order);
>  int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_str=
uct
> *vma);
>  void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int
> count);
>  int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);

Otherwise LGTM:
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>


