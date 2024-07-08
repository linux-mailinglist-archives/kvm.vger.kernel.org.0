Return-Path: <kvm+bounces-21087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1C1929D09
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7578D1C20D30
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 07:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71467210EC;
	Mon,  8 Jul 2024 07:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qKVZNxA4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22CA19470;
	Mon,  8 Jul 2024 07:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720423666; cv=fail; b=TmYQeIJg6QcIJaIOuJg7/hOHpSFIvcwayfhws1bGkqimZENstzAwCCY+iCUDTBZ0c+5FHPwoDtGZnvjIJ6ju/G/7Hx8UfCxBzxj0tgVayc7k+TXsdfSKx3JaPLFS8EEakPNsWgFO0W0/0S02UevIkYeSJJY3mNXy7e24MWHzWVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720423666; c=relaxed/simple;
	bh=HKALOVCnvnvs/kEl2UMKGEtonG/e7DCUZFDkicOdNRg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VPp2BX33CEk6AzWMNHrAFJ3NNr+wvpkI8PaLYK4k/y9foldOhN2iy9fAlo23tUIfz41glqALWmx1QS80uhw2IiAgO1BJ4m2Ijt5OrZawV3hXVlf0ZRtEtgwJPOGD1Bmznp0+KqQmBvg/4yngY63wAjkBwxBBp4IhU3yUo/Ck9ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qKVZNxA4; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBozxDmq8AUfbvXzYMxKRIgf23K42qApcLoqwe4fBYhBGt2LeiDmBd8uoDKpjG8DiMH4aPTfIn0EuvOyuBgZy2EOAhtexdEpqt8yKlrUZ6W4kIS/xEG+fqeMOMGW+uNh/C9MuASuLVe2it/uxmpIeme20/RRfQM1DyDkkacUy9fFa4C4GMjaXcuD7g7gFacfv/LDrSMRWLChdJoZ7mXQCBfQ/xVOMMzP68tAWk7v3tJwE8wJTzTTu8gj/M/MnAnsvhJpIPD3Sl+hL8PeRN6PajLonGZp8doUH/fWCPT7/efkXp6svjFAdSDqs7mBRQKOV8lIqcnR679+P0ndIjzTWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HKALOVCnvnvs/kEl2UMKGEtonG/e7DCUZFDkicOdNRg=;
 b=dXEZM/IStty4/FUAxUtiXQuTe+SVuCqpKrbkduW0O4GkxVyspYeELW5FH2LJA6l0wliWXjavV5nYm+IOZ+JEs+89+qo1yNAVq1+IBToNHjwIeEiH5w/i3Xy2c3y5CHLD+DooAEUlLU0INYEZ7ERBjT5I3+TaeYc9dSs9WdvC6ilxpTUbuaqZ/uJqUngmzPpoiLiD/kue1oZubQMsIoazD28aHgu26jtXytZeTuJGmA7s6FCbQOBkAqUv80auqxg8jH3EzLhzkzSxuzQ6uNwDc0bIa4NUQDj9gSd8qKVhj9D25dfOgMxMD/Tj/4+/MHVidyvbOZs9xcRgBkhdSMpLzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HKALOVCnvnvs/kEl2UMKGEtonG/e7DCUZFDkicOdNRg=;
 b=qKVZNxA4ZUCrfyPmFQ46O+p6TuSQKR4tZmwi2LG8wYKdwR8JK/v5hoLKD8H7NDcLRzTnqSnmFeURhZH+DmLSDAQ5Pb0Qq4MUNu5Jntr7VqT3XUDZEn/uXhyExubqicTUycAFaEIsK3uK+2TB7n84tAq3h/d8UEtfIwK+QDQl6UZh0yIRGYPQMWakgexT1VwMo+Mt20faEyLvu5m7BYJv5EV6f+ZBzGuQh92zLgfR4u8vQ3kTaVpmro5u7a6fNCYe/iZy8cTJAwJAjb/qY9ysvQJEVDCnPKuRl0nq4xVpNs0lxFLwgsLwX1nIf0uvQ6xqP2ncRXxa65y7rAH1FozNpw==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by PH8PR12MB6841.namprd12.prod.outlook.com (2603:10b6:510:1c8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Mon, 8 Jul
 2024 07:27:41 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::17f8:a49a:ebba:71f1]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::17f8:a49a:ebba:71f1%3]) with mapi id 15.20.7741.033; Mon, 8 Jul 2024
 07:27:41 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Parav Pandit <parav@nvidia.com>, "sgarzare@redhat.com"
	<sgarzare@redhat.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "lulu@redhat.com" <lulu@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "mst@redhat.com"
	<mst@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: Add the support of set mac address
Thread-Topic: [PATCH] vdpa/mlx5: Add the support of set mac address
Thread-Index: AQHa0QPsrsBH/Zqdl0SnBl8qTquVfbHsbpgA
Date: Mon, 8 Jul 2024 07:27:41 +0000
Message-ID: <34818d378285d011d0e7d73d497ef8d710861adc.camel@nvidia.com>
References: <20240708065549.89422-1-lulu@redhat.com>
In-Reply-To: <20240708065549.89422-1-lulu@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|PH8PR12MB6841:EE_
x-ms-office365-filtering-correlation-id: 15b52423-f256-4fc7-7a8c-08dc9f1f73a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VkZRdCsrazRaWFVHQ01QMm0wMUhCQU45SENldUkzUVN2eE9YaWoxSjkxSWVo?=
 =?utf-8?B?TElEdy9raHFxL2pFMWM4em9vMlMrdXlXa0FJdDdFNkZLOFErNHA5czZOSHVr?=
 =?utf-8?B?eU4xTlpmTENOLzRpL2dWTCt2VVdYRWdJZXhkcHpZdHZtQkwyZ2J3eGJrYkFp?=
 =?utf-8?B?Z3BCYkFBT3hoanNha2VMd0tSamxiSUw1Z1RoWWwzR1c3TngrNDllTTd2N1cz?=
 =?utf-8?B?TWVaMHFVNUZFbWJOZURBRkJPMnZ6bHhPNUNxZVQrK3EyMkJ2SUh6VXBMaWlK?=
 =?utf-8?B?SlVzWWQvMExuV0grOTRkeHlGUkY3Z0JudVZSMUZYaGNZb1N1QmdFcnpQbVJs?=
 =?utf-8?B?Vkw0YmdoaW1Odm1EdTVXbmo3TDZ1U1Y4amYwTTRpaSs1bnRRVzdzWTVJYVVR?=
 =?utf-8?B?N1d1TXBvRFhUY0FHL0IxM1IxSGVWZG9iMEo3dFZUUHJhKzJIek56S0ZTR3dZ?=
 =?utf-8?B?TUltZG9uUFZWZFE5dHl0MWhJdWlwa0lKWS9XTEx1dUdtbVMvbWJZcXhMZXBu?=
 =?utf-8?B?bmltMXFRd3dlbStHamx3SFJZaXQ3aUtaTStCU24zWHhMT0VaYlJ5b1JtZXpm?=
 =?utf-8?B?cXJob1UyaERSSzR1dEhmWnhaNk1YVzBySkZCa3p3RlJ4SHpyeTJFT1VYMEM5?=
 =?utf-8?B?dkJoRXZ5V3ljZ0IxYUM3bGtyenBoeW51UTVMQ3ptL0xXUE96K2M2OEtkU3BO?=
 =?utf-8?B?dGpnZHJGdTdxVGZuZkF1VzNIVzB2R1k0aHZPeVRpdkxyRlRRMGIyK0pJL1dT?=
 =?utf-8?B?ejMzeHMzSVpRcENIOXJCRnVqU3pSRlJJaWZDZkswRVk2N1hsQ0dXcWdlb0Ew?=
 =?utf-8?B?TkU3VGxDOWo4RVdFWkFKSWUrMmVDU1FyTllNWlZZeGN3eUEycFNKdUova1Zk?=
 =?utf-8?B?U3ZRemxzTEY4NDJxNDVWSkk4K3Nkd3RqMzZndEVURXJYSVNVdnFHTC9hSXo2?=
 =?utf-8?B?dnZ2TDVkeURqL2hwWDd1OG5zMTVtZmlyaE1tdHlqNnc0UHE2dmdidzg1WGJr?=
 =?utf-8?B?a21oUjNZY091STZ6UzNHdEZUTVhDanpHeHNZN1NzRGs2R0hyWDVJMi9ZQkpk?=
 =?utf-8?B?b0NQWTgwVnZLaVNrVWJodHRJakxsZXhnUGx4dnJVU0l5d053S3RMMnlUZGpS?=
 =?utf-8?B?MklNaE1mbHBrMGFlV2pkN3FWRHUxdFRPc1JaRitwVzlNeGZiZ28zVVZNU2d6?=
 =?utf-8?B?OUppWjhHeTdsWUZyQ2EyY2ZCMUdLZ0pTTktzOUUvVWFkUFNmY0pUa3BEeUdU?=
 =?utf-8?B?Qi9IQjNhVlZTYmVSOVlJaGJzYmVRQi9COVBXL0JrUlRCdXNxZHBBV201WUlR?=
 =?utf-8?B?SHZjRWp0UGRaQmtWVW56czh3YUFjenFWK1k0Y282Q3h4MUVmSUo3bjZwak9Q?=
 =?utf-8?B?SHpUQi9UMncwa0hEUVlyU3lwWFBPek1sc2kwK2VxMzltdUZ4THREV1NLaEN4?=
 =?utf-8?B?WTVGbTljTml4VkxiQ0hrZ3ZOOVFCZC9nWUErYkZkWTQ1cVVIS2JnM0oxaEJG?=
 =?utf-8?B?MERMbkRMUkpnT3FKeTRmenExbmFZcUFsSzIyMVlvL3F5encvQ0gwODJyNC9E?=
 =?utf-8?B?RWdhd3VyTGVPaDhzeHlrSVZKSkQ1bEExV0QyMzVheDRZZVNxOFZ5eXVZMzNZ?=
 =?utf-8?B?UVdWK0JxcXJqUnlqMktjZzNRREc5WkYrYW40Z3FMVmtNWUdYSGd3cU1nSDRw?=
 =?utf-8?B?R3VYcU1HVm1NRHlJZVA3RVdtemFXc2pmTjdUakRQME5oUytSV0huSSs1VTQ1?=
 =?utf-8?B?d0V2SmoxcGdOTFAvV2Z0WWoyTzRjcjFSRE5vbmt1N2FkR1hydGJZQlFyY01W?=
 =?utf-8?B?NjltQ1VWZm1vUndDU1VRRW1XaFlDck5uSStYa2UweFE4cklKSXlTeFZmSmtL?=
 =?utf-8?B?eFp1TEFCL1NsSkVjN0xjT0Q3UkZ4b0paaFRITnpscjlUbmc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aHpIVndPd1IyQ0lMbUtmdXBQREpOeEtXeEJaOFRGcjJXdndmandEQ20zOHRi?=
 =?utf-8?B?c3FuQ2NDVTNhVlFURVdxWFpiL3ZGemdhcXM2RkJlQytFVFRwREJ6WEo1UnVm?=
 =?utf-8?B?U25HaEpvNk03UVgvMG1qUGRuaml4TlBBMDlZbWdWRUJsZU8xOExYQ0lJZWRy?=
 =?utf-8?B?Sk50QXJaRWtDaGxaNFpBSHVHb1ZTVXJkYkJjVkxLTDJiSlRpWU04QUlQdWRJ?=
 =?utf-8?B?T2hmN3NJUnlqV09zNVVIODJkc3dWMnEvL3dGOHhlU09ZWjBQdkhPRHdueUFF?=
 =?utf-8?B?dDRCV2s4WjhmVENMN3VZNFdRaVcvY3NkOG12MmVKb1RnQWtOWnkxMnRoNTVV?=
 =?utf-8?B?QmIyUEdpUVhwbUp4cFBra0ViNWY1VFNzR2dZaExpM1RyK0QzTzZ0T3h1NGNz?=
 =?utf-8?B?YmVzakliU0FzSlk2RU9CbHQxa1UxQXRodU8vSURGcWVPYlFNcTBpbW41ZGRQ?=
 =?utf-8?B?Vm44N1ZZVDBGZTNUeDJZOWlSUlgxVG1LbGxJRGNCaG1lbGxLK0g4Tm1HN0N2?=
 =?utf-8?B?Yjk0My9GcW9HRkQ1eUx4TmQ0MlpiSVJCUm9KeDhLeDFXVHE1SENmL05obE1o?=
 =?utf-8?B?bUMyZzJLT2NGVXpoRzdKYmVQSFBqRW40L1A5WFpvb2lEL3ZzdlE4UE5Va1Zi?=
 =?utf-8?B?MzNmcnJBcXhWcHBXNnJlRUo0MkdKZG1FZnR2VUZsWUdXUC93T2d5RC9ZSGhJ?=
 =?utf-8?B?aEg1VFd5b3lpekZYL3NRKzBTZVBqME9ObTdDTWk0K0NPZ2hlQnNnUFJoOFda?=
 =?utf-8?B?TGdzNVp2YTVqSzRoUE9vMWNOMnZSMmZLaUtFUG5XbGZUSlNhVWlranduem9X?=
 =?utf-8?B?ck14OHl0RGIwSmdGai9TZ0dFZGRPZkRLRzY1eXpnMGMzUlIzRTVSSFdzdFpU?=
 =?utf-8?B?dXlWYWhpZ29odHlOY1U0cG9UWVFiSEpLeXdZTFRRd0NjQTBaNEdOVlFxVGFM?=
 =?utf-8?B?UkVpWGMxeEpQRWs0eDFacjNheVVnUmJGRCtOT3pDMjlDWEtoWjdCN1VrdlR4?=
 =?utf-8?B?Znl5aWU3ZXppcWhnUkhvNW9zVGVKTmZweDVVc2V3S2ZWUDFmQkVvQnlrUExu?=
 =?utf-8?B?TU1QcUpUKzE0b09EQ003UXZmazhWbGV3MDYyb0hkaHNLZEp3TnNrUkZjM3li?=
 =?utf-8?B?bWlzOW4yQWw4Zk1nTVY1K2EzWXFnMDBOTnRJb2Y4T1ZrcUJmVEJCRFpPcGlU?=
 =?utf-8?B?YTlzMnJTUHRuQTMvVzd0Q0o4WDJHR0k1dmorOHBPVnU3YjdBZ3RjeXZyRXNi?=
 =?utf-8?B?dmxvajg0aXBFZDBzRnpXd20rODBQNVZLU2RBUndGalE1S0prSVVCeHZKazc3?=
 =?utf-8?B?aFRlMHBQV2c2MUxmOWR1YVQyWEpPcnRraGJoWXlkckMrdnlMeXE3S3dnaFQ1?=
 =?utf-8?B?cU9XNUxURzhKTXZXYXI5emxmazZSWXV4RGpEL0VyYitoTENZY2VJeXVQVVNq?=
 =?utf-8?B?bnU1MFR0cktnYzhmZTdveEp4UkovQ2M4ZVg2U1hXY08wR0JuZjlaY1Z0SDRr?=
 =?utf-8?B?NC9ObFlSbjZHS1pjVG5mdTZBOUlQOG1VcjRVN0F3NGVzb2tralpjUEhkeXM3?=
 =?utf-8?B?dHROWUNWMDBzSFNnczU5OEVkYkNaNDZuOHRVdXZLdGMzSVhpbm95aHU1ZGZx?=
 =?utf-8?B?VFRCaURLN0FrZERESHMzV3MvZzl3ZTdRaDZPaFR4a3lrSXh4YitscGpWTExa?=
 =?utf-8?B?K1h6N2t4OGlzaC9FSi9Cai91eFVXUkFVNmx2dHJvSzNqTkdVZ1hObkNNak1S?=
 =?utf-8?B?Wm85K0YyWHZNMkxkSXdRUlpOMGtxVlJHU0ZFU0pReUlzWmZOV2l3VnFiQStF?=
 =?utf-8?B?Q216RCsyNmlzd2hLZElHcHJxdUcyRkVGRFhGVExVeU5VRFRZa2swbEZjYm4y?=
 =?utf-8?B?OWRPOW5SMzN2cUhFNWVUaklRTk1va253QTI1UHZONDEzemJsdjB2eUF3TW1M?=
 =?utf-8?B?R3IzSnp2Ty9PWlVSSVVZcXN5dDI0N3cxM2o2VG1YZkNnZDFxUFoyZ2FSZGN5?=
 =?utf-8?B?c3U0OUw1Z2dPaHRzdWllUTd4T2xUTWdnRmhPV0VOaVQ1YUNlWnV3d0c5akVl?=
 =?utf-8?B?dFRlQnhwU09yb2h2MGVWRFJLRGFEWHVJbHdJclNKWWxGd3Uwejk0cGVWTzdN?=
 =?utf-8?B?c3VWY29KemtOSW8ybmRZMW9CNnA2dkRhZHh1dGFLb2lZWnNPRjJHejREOVNk?=
 =?utf-8?Q?Hr+MHyGrHmve10ry1E2POKdS/9vwcG7JeRidHE4sH1KU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D22ACF55148EA24397102DBB94348A45@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b52423-f256-4fc7-7a8c-08dc9f1f73a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2024 07:27:41.2288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BxXxFINs70moppBeyiovz2Gx1Nxq2cK3JlDhYFF4yL443iKolsdMf2G/AhzAu9rvi6ZzTilvyLbyMRCh4buP0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6841

T24gTW9uLCAyMDI0LTA3LTA4IGF0IDE0OjU1ICswODAwLCBDaW5keSBMdSB3cm90ZToNCj4gQWRk
IHRoZSBmdW5jdGlvbiB0byBzdXBwb3J0IHNldHRpbmcgdGhlIE1BQyBhZGRyZXNzLg0KPiBGb3Ig
dmRwYS9tbHg1LCB0aGUgZnVuY3Rpb24gd2lsbCB1c2UgbWx4NV9tcGZzX2FkZF9tYWMNCj4gdG8g
c2V0IHRoZSBtYWMgYWRkcmVzcw0KPiANCj4gVGVzdGVkIGluIENvbm5lY3RYLTYgRHggZGV2aWNl
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaW5keSBMdSA8bHVsdUByZWRoYXQuY29tPg0KPiAtLS0N
Cj4gIGRyaXZlcnMvdmRwYS9tbHg1L25ldC9tbHg1X3ZuZXQuYyB8IDIzICsrKysrKysrKysrKysr
KysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvdmRwYS9tbHg1L25ldC9tbHg1X3ZuZXQuYyBiL2RyaXZlcnMvdmRw
YS9tbHg1L25ldC9tbHg1X3ZuZXQuYw0KPiBpbmRleCAyNmJhN2RhNmI0MTAuLmY3ODcwMTM4NjY5
MCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy92ZHBhL21seDUvbmV0L21seDVfdm5ldC5jDQo+ICsr
KyBiL2RyaXZlcnMvdmRwYS9tbHg1L25ldC9tbHg1X3ZuZXQuYw0KPiBAQCAtMzYxNiwxMCArMzYx
NiwzMyBAQCBzdGF0aWMgdm9pZCBtbHg1X3ZkcGFfZGV2X2RlbChzdHJ1Y3QgdmRwYV9tZ210X2Rl
diAqdl9tZGV2LCBzdHJ1Y3QgdmRwYV9kZXZpY2UgKg0KPiAgCWRlc3Ryb3lfd29ya3F1ZXVlKHdx
KTsNCj4gIAltZ3RkZXYtPm5kZXYgPSBOVUxMOw0KPiAgfQ0KPiArc3RhdGljIGludCBtbHg1X3Zk
cGFfc2V0X2F0dHJfbWFjKHN0cnVjdCB2ZHBhX21nbXRfZGV2ICp2X21kZXYsDQo+ICsJCQkJICBz
dHJ1Y3QgdmRwYV9kZXZpY2UgKmRldiwNCj4gKwkJCQkgIGNvbnN0IHN0cnVjdCB2ZHBhX2Rldl9z
ZXRfY29uZmlnICphZGRfY29uZmlnKQ0KPiArew0KPiArCXN0cnVjdCBtbHg1X3ZkcGFfZGV2ICpt
dmRldiA9IHRvX212ZGV2KGRldik7DQo+ICsJc3RydWN0IG1seDVfdmRwYV9uZXQgKm5kZXYgPSB0
b19tbHg1X3ZkcGFfbmRldihtdmRldik7DQo+ICsJc3RydWN0IG1seDVfY29yZV9kZXYgKm1kZXYg
PSBtdmRldi0+bWRldjsNCj4gKwlzdHJ1Y3QgdmlydGlvX25ldF9jb25maWcgKmNvbmZpZyA9ICZu
ZGV2LT5jb25maWc7DQo+ICsJaW50IGVycjsNCj4gKwlzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqcGZt
ZGV2Ow0KPiArDQpZb3UgbmVlZCB0byB0YWtlIHRoZSBuZGV2LT5yZXNsb2NrLg0KDQo+ICsJaWYg
KGFkZF9jb25maWctPm1hc2sgJiAoMSA8PCBWRFBBX0FUVFJfREVWX05FVF9DRkdfTUFDQUREUikp
IHsNCj4gKwkJaWYgKCFpc196ZXJvX2V0aGVyX2FkZHIoYWRkX2NvbmZpZy0+bmV0Lm1hYykpIHsN
Cj4gKwkJCW1lbWNweShjb25maWctPm1hYywgYWRkX2NvbmZpZy0+bmV0Lm1hYywgRVRIX0FMRU4p
Ow0KSSB3b3VsZCBkbyB0aGUgbWVtY3B5IGFmdGVyIG1seDVfbXBmc19hZGRfbWFjKCkgd2FzIGNh
bGxlZCBzdWNjZXNzZnVsbHkuIFRoaXMNCndheSB0aGUgY29uZmlnIGdldHMgY2hhbmdlZCBvbmx5
IG9uIHN1Y2Nlc3MuDQoNCj4gKwkJCXBmbWRldiA9IHBjaV9nZXRfZHJ2ZGF0YShwY2lfcGh5c2Zu
KG1kZXYtPnBkZXYpKTsNCj4gKwkJCWVyciA9IG1seDVfbXBmc19hZGRfbWFjKHBmbWRldiwgY29u
ZmlnLT5tYWMpOw0KPiArCQkJaWYgKGVycikNCj4gKwkJCQlyZXR1cm4gLTE7DQo+ICsJCX0NCj4g
Kwl9DQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICANCj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdmRw
YV9tZ210ZGV2X29wcyBtZGV2X29wcyA9IHsNCj4gIAkuZGV2X2FkZCA9IG1seDVfdmRwYV9kZXZf
YWRkLA0KPiAgCS5kZXZfZGVsID0gbWx4NV92ZHBhX2Rldl9kZWwsDQo+ICsJLmRldl9zZXRfYXR0
ciA9IG1seDVfdmRwYV9zZXRfYXR0cl9tYWMsDQo+ICB9Ow0KPiAgDQo+ICBzdGF0aWMgc3RydWN0
IHZpcnRpb19kZXZpY2VfaWQgaWRfdGFibGVbXSA9IHsNCg0KVGhhbmtzLA0KRHJhZ29zDQoNCg==

