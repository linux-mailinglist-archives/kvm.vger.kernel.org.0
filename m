Return-Path: <kvm+bounces-64417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 527C7C82097
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 75BF534982E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39FDD316900;
	Mon, 24 Nov 2025 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cZaAfntB"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010038.outbound.protection.outlook.com [40.93.198.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DC8283124;
	Mon, 24 Nov 2025 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764007828; cv=fail; b=dGD/Hwv3kw8meB60S0+W6HD8s9dCPPkI8UYIVWKsWAw9U1ZmKk8/fPZ5i8237JnArP0mCVEekYIQFDjcc2EjcFbgr07RARK3B/4qE/sdBYBlGtpSBPME+A2u9nkH0/ooQw3a4aHCojFhL4h2YVU01luYwrqA5ly8pQZwPF3KLlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764007828; c=relaxed/simple;
	bh=cAaDuARyYWe6zHCIMaNoKJhGOg+wNuaUzSYwd1jep+8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aiifgPQuXPaH4D4WcYxDb7YMpedjxH7X+LW81kJNu2TwpL+w6DVL2X3nTpRA7nrJDGzMTlaI/+sxh7w9JzcynIWpw4UKf+OyBnoPf1OqDaSIJhwdOVQC408O+ceWMvoHBws5X9P3zOnayoWPBMUHdVwICRBx+gWro1gObzOnvL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cZaAfntB; arc=fail smtp.client-ip=40.93.198.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e5q+Nvu8PapgLTZRTvXdqeAmz8BMraZdp/xlDxJfyRlLtuzvln5TtaCfBwfKx/Y0TTYVTaFSrOjMN4NifAJWQHWKzZ31Uyi8bd4HwEu7njVwcP7yolvMpSJIxKu89+yLKWpWd4zkA8hji/bB7ZrDJxmEB/ScCPy5vXIzVXhbibcv344b6DNQo5wYd5mWPcptWxFPomqW8eolT1r5vWlPyrj6G+x8QqsaYFLKQGpExMe4/IxPKcYk0LYQFvEbtfwrxZGEGNZ1SWCafhakoEjJF0o1e30yisFb2KDYYQyivdpyCGmlFkpvsHBLwVGKCi8Ftn0Q2v3mMcr07vqH49BcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAaDuARyYWe6zHCIMaNoKJhGOg+wNuaUzSYwd1jep+8=;
 b=sYlU8ICgWufneGHFH2V1PUXP9dSqD5Gy08pnU26jY8MSCKej4RhtAzHG7S7JiEmNkiRrjEIThC92zRf8ZWI5sU7NriuNmVq0bhS2TDwto2eUE7qHorXgQQJ8PwgMu68LNQPxH53S8GJElAN+IH+7lPuidb+nkiULxj/SFtEytv0N0ltA9NEcfXSuI8E2YkSzlFKqP3GSwATdvU2hLdy6ojy245bxWxgJ3YAG08lSyvAFgmtWhP2WsMm7j4R9QpS+o1C3kwPyf4v/e9phrqw9eHKCTRM5VHiJB4sY6iVctH+Yrc9f/8hf36BvYQYVrK92+3/+P7+qLPxCxwv32pl+IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAaDuARyYWe6zHCIMaNoKJhGOg+wNuaUzSYwd1jep+8=;
 b=cZaAfntBCiW2z/iQKJYLKXVkUL+KOSCM+2PQTMQev1Cs54c41QOR6guClPucqrhjcY1tKr9+D+VGcmeHCCsr9SPkPLSb0EIZ16m6Kx/l0Ofck5e93gnbNA8si3ROvr0470mvW2bh0soEuqcSwcHUCQNtApqrkeFZFMpu/arhTnCEO948MSKOTtQGM3q3RGz13HzgrZPRlMrmSjdvUCpVR+VCe+1tHEuX5mhonlszF20e3mO7UPHpZGALA6UE+Az2vr1PKW8c+6aCT4oB+nF2DuREPs3o44EXEg2/6DTR4ph35PK7Va60dsK7XRMhHPemRuSOU4lqcX1N6Wn1/xgPCQ==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by DM4PR12MB6182.namprd12.prod.outlook.com (2603:10b6:8:a8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 18:10:20 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 18:10:20 +0000
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
Subject: RE: [PATCH v5 4/7] vfio: use vfio_pci_core_setup_barmap to map bar in
 mmap
Thread-Topic: [PATCH v5 4/7] vfio: use vfio_pci_core_setup_barmap to map bar
 in mmap
Thread-Index: AQHcXTnRSYb4y5Q4SU2Q6Tbl4m75bLUCIKAw
Date: Mon, 24 Nov 2025 18:10:20 +0000
Message-ID:
 <CH3PR12MB7548ABE706A49835B5D2B219ABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-5-ankita@nvidia.com>
In-Reply-To: <20251124115926.119027-5-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|DM4PR12MB6182:EE_
x-ms-office365-filtering-correlation-id: 4e0c30eb-759a-415a-6d1c-08de2b84badb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?UIDXQx4BUsRXsxuV0u4lg3H6EPAPNmab3/n2zLfighu6eQZ4psl9SAqXw9xy?=
 =?us-ascii?Q?iRyWFcz2Hcuue+dIjDyC8QSU9VF/pLPWGYZu6EdYq5t0nOwm+bMOZyyyzf6U?=
 =?us-ascii?Q?HlF0HYtHWY2XY+dfRZMGyx6JrpiVvHceCAZEoGfyU/gDIzy3Dlmb0r82ljiC?=
 =?us-ascii?Q?uLl+aA/qredyJl+BN2DYygTL0oKGY2/skkkLp6qapDpmRL1JWl2FEgoXWVsn?=
 =?us-ascii?Q?F+jNhixYgmLQZEuYt2ZWCZjCiao7lBW/ow6aKosBHCm4rbFHXwUXHYV/zBka?=
 =?us-ascii?Q?CYbxqabUBlUnWXWaWNjacWgr10kkXEDWpQMcFlnGi/samcBtTXR5HJWZCmeD?=
 =?us-ascii?Q?gJ+cdMZ19dH1F8ybv3hHCBm1LGXfPaA/c1/p30pwMC5XxAWkIUkfJ5Vq+Orc?=
 =?us-ascii?Q?YWfTuyRhBOQi96d6q1lrKbqaFamPZThDVe/3x3bVVnaljgFf/WiW0nZ/NnsS?=
 =?us-ascii?Q?XmTrKcDtPAQaPIB75mxAA8lGOLnsdLRqnO3HBGcTjp33/H0EBGBAfRtBr2yw?=
 =?us-ascii?Q?5KzZ/FMA3aZgS3FdsE7I1EFr/53smj8T8KPc3xc8edoQ5M8g2dOMps2XIgQO?=
 =?us-ascii?Q?6CkCmlNhrsbePXpC+XPME69bXfmF56dHes3biWnLoqAmI8n/0ISXWAzVMoh3?=
 =?us-ascii?Q?TKxHv5qCbSwnE5gsyv7xIQo15AA48+KwnSo2wApyBQAffGqdo2oZc5hMn55Y?=
 =?us-ascii?Q?1t+p2By5vaHzi8p1T9yJOsLGF0k16sqYePzthW72XU0xoAKwGi23NQelF5wY?=
 =?us-ascii?Q?J7agDES2e65ClADPyA9adXot5xZrRO9PAoIL3zd5tWSSmMMlfhrztj7k95xL?=
 =?us-ascii?Q?ASx9dCO6BExuv6knUgHjWy4fOmBITn1LO847D4shFfFnx8F7GGGQKHVKAstB?=
 =?us-ascii?Q?muAOlq0FyQ3h1SC2NdfkZ1bdUFs4IxVGu83vc0Y7P8xiCdN0dpY9ETu7BTil?=
 =?us-ascii?Q?mk9GoSuzxuR8mElONbhNAnyL4H3GgRAfP+gOkSR6Lg8HmeDImOdN33Cy1JQK?=
 =?us-ascii?Q?QXYL9Pu6U5kW5JPMqrSG/KRyjydCWiJ62OVSXylWKdUGpYMIyp5ni7EdiEaV?=
 =?us-ascii?Q?8a7CT7mNjikzjrC8srAbryf2gDCzTbgVHwcurXTnFTv4uNRa/5SlyhUR6Etx?=
 =?us-ascii?Q?/S/dXxWn/9G0NO7IyM4RZMJTmLTYIM0JtexPkiUn6hoMjdx0cjC3BN2trP9Z?=
 =?us-ascii?Q?TKik6v0QymdSfZBjBS2trWSB0QWkVaAjDnom7XskqgMhZBcqioOHZiA0Ngvb?=
 =?us-ascii?Q?TUmFyFaE9oKVVzy48qz586dzuBmRyTlw2ubWvNusk+S+bdcWn6gRVWOh0eLJ?=
 =?us-ascii?Q?0o24QNaqZav4DQAec3E94eWldTUIvmO6LhNnCCSyEVwXr603Y+aYHcCHMkjQ?=
 =?us-ascii?Q?8apu6I5ftBMAKTHoN6GHxtAPQAeQXveh9AkY58j0EaWIOQjl3X9TyHUXlXle?=
 =?us-ascii?Q?JoneNTAvwmchIDY36SxwwxcVjk+iRT0wt4S2iv6C1sXIg8riGivpE+IYf3md?=
 =?us-ascii?Q?Qwg7L6LcF4Q/J1TQacv1BZfN0wmsH/BgafWZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uefkL3SKFfYIKOrjxJZnrj3AvXfCYhc6RosdaF+meSQOUHNu+Jp9s55BoxU6?=
 =?us-ascii?Q?6AA0P9aW16JkqUZKCOo2mC6F1THbmgkth17A63rEJaV8kmyyzKD3Q6kOulG2?=
 =?us-ascii?Q?CKeJ3dGdxCWjZpugfeb/V+Izc99iQEy6tysDJG7llSF+686h1mYJ4crpQXz4?=
 =?us-ascii?Q?ISuyGb77VIVHPRggIEF2NeOoq/ghqH9BjMEezk7T7mrjJnCaAfVzI9GaKprM?=
 =?us-ascii?Q?q+TYGMrC2IHwBrL8MLz2bj4tXz4kApU6sjmGIMENd2qvbI5UdM0AuND45SLZ?=
 =?us-ascii?Q?SCagY4StArfm7ZobvIap0wpvPf/jxtAqG00c3Pe0A6egmXeUv5rHb7G8nNUB?=
 =?us-ascii?Q?T/K5hjJfNhUUDbf2MG8en/XtBs93EB+4VYVBvkDnxHKqHFIoeQmtJN1I0/1S?=
 =?us-ascii?Q?87ZYNUDEYVl8MN9lEEFge1humFaQR/nIKzOV+QT6H2TuQe9IvU/8CiGZP4V4?=
 =?us-ascii?Q?nY1xjqapsG16VMsZTw85zo65PJWDvxFkJRqb0UHEHBzFA+pGZ/cCDCYYaY5c?=
 =?us-ascii?Q?vt5WpB24QobkdL1HygsN0Ic7OdgfIL965hlOvK2m7ruTlZW87OQPn5XT3ZdD?=
 =?us-ascii?Q?Z0lxRBS/uj8iVydd4Fs07st60L9dc1Rif4IH9dDTNbbOMrwucVmSVAY6cPT+?=
 =?us-ascii?Q?WRCZQ2mjMh/cAYCp1eWWjxRTZPde+vzBU+hS6fSf/jVyOzXRfP6r66goBEu3?=
 =?us-ascii?Q?xhxTYIeFVh/DVxzo54AdYluvDjlMNkDGbutWSCfU/NbR+5j1ierdwPmC5saS?=
 =?us-ascii?Q?zOXoYZ5uk0uYO6a2NL+Dx+0F40dRE8CeXBdSkyeNCY397D1A4HGc12PjZshe?=
 =?us-ascii?Q?Fg9e9vQ81r1ve6tz6qr7Vp2Al3EXI7Mm2FOCPW6NlhASTPXXyjpo3hr3FZZ2?=
 =?us-ascii?Q?N31zC5AR+68JJD1Sue/kYCR5PkNWjqWXykQjMGmYdKMR5LNw+9exi6h7KjJa?=
 =?us-ascii?Q?7QiiX524FBz/8ff42WJY51iHtn60LKfDs1osxxoY2DqKQuPNe9h32usnZsAl?=
 =?us-ascii?Q?ijALrgFsJ7Of+XfEFSFlqmbaViB8CZn/0N5EHPtcrzO8Yy7n8DwmtZVMK8kG?=
 =?us-ascii?Q?k62ok8k955PnwOGGJzruUYwLvjR4MNMwc5BiO3qEQ25sh6JqRbUzOceX/s/K?=
 =?us-ascii?Q?DkJ8Vo/MwsObeGcdHDDKzjkBZiuReykw1hJSfZS9QsbSih2MOtbwuh7R5er4?=
 =?us-ascii?Q?kNDVjbof1c7QFdzx3yITNVPLJcraDQDbixAREaLARC6tOTPg5hMq2QMWcDAk?=
 =?us-ascii?Q?TtqbtXj7Qd8S+nueTd9wSHU8YtE6TPw6hDpNlgF07f3MsWguoQZ21FF67A6Q?=
 =?us-ascii?Q?L3+uTsZqdraZ/uTEr2S77SKQaTFMxs6TTycQ7gipZwOt9xLITd3mD8KonQ18?=
 =?us-ascii?Q?s/aSF0Zb8qZcbvT7xrzlK/gXLNOLGqjw9iteyKez9EfFEnEFmnHSi5YypH7X?=
 =?us-ascii?Q?QZIdgCUswCuDFy5fE6JW/6gA4hHt+3txX66IBLvBVwe3aYhLOJnq13Wbt7bF?=
 =?us-ascii?Q?tbHACCo0zeHRmAAIkK8cgYCVq+BX8Aoi3uXdmdE1pk2QGaHliAgg7DU21auc?=
 =?us-ascii?Q?rSdk5E7jbVySFVRYwAe7/5evBS3QPRzm64qrlnX1?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0c30eb-759a-415a-6d1c-08de2b84badb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 18:10:20.3530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ne5zZ4i1h8SioznYSqIHqQ51nSNg7YsCMysMuaiw41QX87g9mcBBhzgExJu7tjWyQCN2CbcLMZpCseoet/iE7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6182



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
> Subject: [PATCH v5 4/7] vfio: use vfio_pci_core_setup_barmap to map bar i=
n
> mmap
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> Remove code duplication in vfio_pci_core_mmap by calling
> vfio_pci_core_setup_barmap to perform the bar mapping.
>=20
> cc: Donald Dutile <ddutile@redhat.com>
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

LGTM:
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>


