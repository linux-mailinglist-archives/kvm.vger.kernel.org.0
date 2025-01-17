Return-Path: <kvm+bounces-35848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 007E1A15794
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:52:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A8F6161875
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E34E1AAE08;
	Fri, 17 Jan 2025 18:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B1oXuPr/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047041A9B2C;
	Fri, 17 Jan 2025 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737139737; cv=fail; b=FDBwxmsNKbRHWLNB0XWiVc1aQgWhBJPZBIzWn8mMc5c/u0WqMIsIZoFgv+5Y7D28jbT4HQ9N0hkhrJaOiOUAilYemRKRIx2LPTEc1NSIH4vW6IKLzJx8VUAoDyZ9jrc5XcMYUxH2mzR0wHkxRfUf4tTc/OqF9VgopuWveS7YUXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737139737; c=relaxed/simple;
	bh=c9JZ0p8BXwpt142VkwIY4Ty5Yeahoc+x+Dcr4KplNEY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MIZyJj6wVQkASjI8Bf1YtIh71cPdJDtnwOZhaoTFzFkBLK9+aGLYy/J8B+PlMNgrwa4PTyfmRKLexzI6m2bxH4h/mebSOB2newIIZ1pZKJr6OaMsfMzUPStdTnIISsUtOGKQq8b5bqiPmpt+d6YGWtY7MwbvGPZJauurCeR3xew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B1oXuPr/; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vHahWNoxZk0wST1thK/J7lPfE9U1KvgMS0OSzgPbniRtu7JdtmsLHXQZ13uc6OMu3buEYdpzvU8SwH5wuDVGkthtrOUBCDNBmgPOr8ZNNOCRQ3xqoOZKZjPhIvHJFI0CHBGbUjqCVDwFbCRpKtXr6fxhgjP6Gj00SzZ1PoSzpk9ZLgeggZX3gJWTz75F3AjD+eXzFuYMCRr1h36m40Cr2+wWZWGFM2Up0JKgj8ZLqHZGWPZW9/jlROfzysuwTR6KiuCzeiRsSjf7k9FE8pk5rjf6JZnzhRQ5uQxEVcZMYcvmKr6brAmggOG9NB5d8Bdg0MATBZ9ieMV9aFTuXCxplQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9JZ0p8BXwpt142VkwIY4Ty5Yeahoc+x+Dcr4KplNEY=;
 b=Rf6gad2GLHyzVjoDkw1crcmn2UBJLghk2tWJxRJe53x7jAD77yWUHnA/x0r2srbjGZOhJ87vWv/zi9yPI8I6+sPd86+OyoMvY8jxg+kbo0OCLmcpG1lhuUhvNrzWlFvsvlrUHHrvFJnHHwrGOEjEclNI6QQx3ozjHkXQ92F+2gcbCfMxvDOfSuIWYcP3JAWQqcn9K/kT2OHQ9e8grgnMRbaCjHQXSGnx9Sc5MGJGvVhfHalP9CHaeWpkDFGpifJuSqwgE8mPJrKbVN1BiVM7PJuo2T7WjYfq8ocwu9DZLkGmmRUX9FJGM8H8JIsRQJ55PgWgp6Q/kS97IEwShBAvIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9JZ0p8BXwpt142VkwIY4Ty5Yeahoc+x+Dcr4KplNEY=;
 b=B1oXuPr/LDJ7okySc12ZpKQxjaty6iAwTu4pcmUTYYZVYvnYnCBtb6metv87Y35Jw1julIdZXXxbPwY1AoZletFZffSNWM+K5AU4MROFfpxGrcrA4eQOp/JmL7SN6AeDgNTm4FURFbgb5He6CCwSv6X0C9foOkvrF7C1iRLIhOBN2GQejb2xNYhUbnOH8Demap7PezBmEtOkcxYnCo6XvJ+ZC5s6pbS3vWSvCF3vGcdYTUZmYc+HLVXEHbQh207CeMwtKKYojUxgQJd5hg1+GzabMehgaFyuQi3lMmo5eRd1pR6fXJ0XQ8O5yW7oW8bgzQAbiygS3Msc565k7jpMmw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DM4PR12MB8557.namprd12.prod.outlook.com (2603:10b6:8:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.17; Fri, 17 Jan
 2025 18:48:52 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 18:48:52 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Thread-Topic: [PATCH v3 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Thread-Index: AQHbaPPLWN8TBBsVuEyEPhrLxBLmebMbQyiAgAALKDA=
Date: Fri, 17 Jan 2025 18:48:51 +0000
Message-ID:
 <SA1PR12MB719916B48AD0A9F0FFCCBC3EB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
	<20250117152334.2786-3-ankita@nvidia.com>
 <20250117130629.03648fa9.alex.williamson@redhat.com>
In-Reply-To: <20250117130629.03648fa9.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DM4PR12MB8557:EE_
x-ms-office365-filtering-correlation-id: da7f3d41-61e2-4144-bb85-08dd37279638
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?w7oZip4Lbo8L4ZF2/qqle+NDobGcZRh5U7r3/DWnYOGYAW6rkSYzYzC9I+?=
 =?iso-8859-1?Q?CqSiJVljti9S1+KttAugMG27VfN3TIZSyStNQfOv1WHecGEk1yffkeh99B?=
 =?iso-8859-1?Q?a0SclqwvaBQO6VUO/Rj8Zc2Yw1RAf6oafXWmJEkhbsOVdf/JnTfpgeVfC5?=
 =?iso-8859-1?Q?9JgG/JL/GaZgnRotOx+hhC/cDI33xvmKVITQZ1fd20st2ra3cN+BffzMYb?=
 =?iso-8859-1?Q?o4/rEZgCqliJzcNpdy+N5UgU8EwinJm2Zo8EttwB727CgX1jhF2cS2AjP6?=
 =?iso-8859-1?Q?kLLWDI58KF8GbAi5O1mOPzJ/2hYg1nZcG0wFLN0LlnfLQcusELldXfoWuk?=
 =?iso-8859-1?Q?obdpXugFD+6jG9DsSy8ouIes1TrrtRUCiK7tLZownQzrozlODrRVngWl99?=
 =?iso-8859-1?Q?II7qYvvv5sYf/FTTNJlkdRlUY/uyiAaQyPdqVTOKf4AfhNplgyKhHonIpu?=
 =?iso-8859-1?Q?m0eHFgy7MKtY7/gUwBatH6v0iYl/dnYIsIzNSKBDgyUGf/kxVosL9Lmy1z?=
 =?iso-8859-1?Q?Lp4ZdGhnURuRXizg+xjOg41VL8ADM/9UAawCq+5SxeGnaZiFBPtLaKp5er?=
 =?iso-8859-1?Q?hsds/C6g4w9juALdTGlsCITswmNLexjYfj9Ob4LtpoatzT9nXcjlHe0o+Z?=
 =?iso-8859-1?Q?3IrX24PTFPFZIMWTCMWTFnxuO8ME10hL4/rF9BvMrQWStaAxnL8OLlr1fA?=
 =?iso-8859-1?Q?1tTvopQPLpd8b199jFdOMNK3aMVOe3Q/045fyhPChnRDstJVCXfEKuNlD9?=
 =?iso-8859-1?Q?/ueqoCX4CNd2Y00gDi50/yb8i9IdrNq+y34aw90qRqOFsdnrmg2fEbNHTK?=
 =?iso-8859-1?Q?P/lZklbEuxINFVg1Ys1UwPDqWLwo2IU0xcRsJoO1TWEvN65/K8sjjuhLU0?=
 =?iso-8859-1?Q?kmrp994lXzI/O/tEunZaS0FTz9jzfvyrramAKujBRCZyvefI5JiDayZzC1?=
 =?iso-8859-1?Q?U37bpZorulGxE1u+GC6Tp3W/C9XW1Zn8p/wIRD6yxp5xiMAN1WL2HC/Z1y?=
 =?iso-8859-1?Q?Q3GhFq3ca1iErjeor0qYJcAkZLq3/+sV8QxNSr3STEdsETLAS5lmq7gJwi?=
 =?iso-8859-1?Q?G5hvvL+flXwUaHKk8btvtW1YobOVSTZ+/G3tfHCjFf6HY6SnDNMrg6VFNL?=
 =?iso-8859-1?Q?pjq4u4qHuNrKH/F84pV6A/FFMomq5r3q5hiWMOagkMoGcortr4rbJkF4ZC?=
 =?iso-8859-1?Q?J/yPzipAtnRBKhkHYzzKFhVOJs2Jk3VZKM/OtlOOnakYsjGC7iydKeqDOy?=
 =?iso-8859-1?Q?laMISwCJ7bI4KLS+DeqaQp9kiFLvtI/rjFjcUGqwGPYCAJ/GRKpfTfLVel?=
 =?iso-8859-1?Q?jowQBtbIM3X14LZ5KgwkKvw5sOY3Q5oOHciVm3E7qz8NzinIQ5FzMfC8Th?=
 =?iso-8859-1?Q?wDpHdAbTCCCZ5JSbclQyRm4KNx2bYlvSe9dNm0sqXQ80Knv63j/30wrH9Y?=
 =?iso-8859-1?Q?vBCJLrI2ZbXUAxHOSn2Y6GEJwvvBCo5MICqH4Udcpp9HKtQ2qpArDFMd5W?=
 =?iso-8859-1?Q?w=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?IAVvpq3ZZ5V/vLlrFDNi4Z9Nr/vdBZXKPKcoF2iLbkNvZBoOHw/hX6e755?=
 =?iso-8859-1?Q?4qRYXHG5jfzbfZ4N/eK+YaE8oO/RsIoHz4chfM0RSzSdAVVtpqCFz2wIaS?=
 =?iso-8859-1?Q?t2MZCoavrhE1xr1Athm1cdMC0XrFqLad9uRPXe9DmCV7weC6SfwGyqTArQ?=
 =?iso-8859-1?Q?bXYtQpmGOwfOD5bxoiEfEKS2BNYqWqLuJU+ybNCAuB3/mW1hTcm7Tuj6QT?=
 =?iso-8859-1?Q?h8q8GS7QZnOa9EJ6MamktLVcQbXg/+4KgLjMbur3ryZ/fsyRz1AXZoBfcD?=
 =?iso-8859-1?Q?ct8AOvgnDYnBF/D6VTzV38AWijO0AHVOjr9llwY4Dw4Nj65BTA5Zh7VSOi?=
 =?iso-8859-1?Q?gCOXiL7OdltFsKBg6/XArn7tA5GRUzTwa9HSFwS22VaihMykwUYzEN+gsg?=
 =?iso-8859-1?Q?ujg8Tko128kN2xNFllaozlHvZmYpoY3EVTHTQ/H/J+aCFmB00pgQxjP7g0?=
 =?iso-8859-1?Q?zZt3UnTMHvem73uniL+08llYZpNB54ZsEeyzLdMzAYaHU60lhPQO9DxbhY?=
 =?iso-8859-1?Q?p0M6aIK4TLaT83xrYyPEnwWofu2UFyFRRUE9FNwbKW7wGGUj71+xMMpnBy?=
 =?iso-8859-1?Q?DJvQgCdG+ZCeeICtpLQNgi3xMiEeI4yUJ7aFhHLGc2toevIObX/SB+0AgY?=
 =?iso-8859-1?Q?Zz5VLtFm/zJm7dApKoFXoMkvV9o42QKsP2dWX4fxrR2BAlIU7/8c62uyZg?=
 =?iso-8859-1?Q?xivDH25ZD+/0WyaDIZ1kpwxVc3s5Jfhu2qjDsKGTidEjKkhpPckZ2eSVyb?=
 =?iso-8859-1?Q?EBD8771tQmuUIK7X4cHXw/N3sGowDf9+7hLJ1fWdb4qADaYt67xCXwmoKQ?=
 =?iso-8859-1?Q?vQddxC1fxo+a3TVcWpZQAL+epZ7ZW+ZUtANGnwGjuXZqoEWFXJrI5jEq3e?=
 =?iso-8859-1?Q?/gyt17s60rOxHJWxhYa7a2GM1Vd9JSslE3B6OohqB/znR/hrChtAz5MIWN?=
 =?iso-8859-1?Q?xK6t7V/5W2FdtHKQIGHE4bSk5rHxTzYeAp6RkEzhoLPBxcCybQ95dC+HNv?=
 =?iso-8859-1?Q?+CKgADn+jZ+lv8k4TnHVByJnCuV3EXSx1vn4CZ1jaKDYr6HQNtZe6ZJZTJ?=
 =?iso-8859-1?Q?oXRY7Sl4AxfheJB9AbPgmC9V7Q0mFzlMmVvtpEywdkDlpvEvKogpHOS6vq?=
 =?iso-8859-1?Q?Y8RrYhJRcwDPONCLMGGK31GNk+EMQ7WS17zcIxcqF+72DbhRF+fQLdmu+4?=
 =?iso-8859-1?Q?kmZCTECOPb5ffg0QTsgr2tUjhgruaKivhYpGrrX4aqMAeyjFw0fqtEg2LO?=
 =?iso-8859-1?Q?6KK/ltKrSoluR+/9546KLi/iBddRJZPAq8m70401NQ+0SuB1GH/AUxwT0v?=
 =?iso-8859-1?Q?4GYt7nXVyV9SAO6alV96vtqy1c46lQkGk1/F0rVqFTSKZJzxbeqKBt1b/j?=
 =?iso-8859-1?Q?cj8e02GB91nxlltD4XF81nfVdS6vVPEDRwCHj4Viv9IgGd54iiP1nxVJac?=
 =?iso-8859-1?Q?IvdNbEbb2OFiQqXely/k9Bpeq5MDjcIXhQxQaHrkG667xLBio8HMq/QRSF?=
 =?iso-8859-1?Q?rOjkzxRShXQJo78I8kFYgqdCAaP+Ol8T/eu5gi2RpXrt01RFVy1HiZCfn6?=
 =?iso-8859-1?Q?z125HbtN6Hqy75XXly1ILgyHGZAqiYrxA/wsvZLDO3cTvaqQqB5QRtohXF?=
 =?iso-8859-1?Q?PVbP5D3Ki6DbQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7f3d41-61e2-4144-bb85-08dd37279638
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2025 18:48:51.9542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mik0YXK+AB4RjpgTEL8+kLf40kuQoWNoO2oCcIAQdmBR8LT/XkfOixjhRNDi68qqkv90mXvIQ6hEyF37mJbkJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8557

>> +=A0=A0=A0=A0 if (!nvdev->has_mig_hw_bug_fix) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * If the device memory is split=
 to workaround the MIG bug,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * the USEMEM part of the device=
 memory has to be MEMBLK_SIZE=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * aligned. This is a hardwired =
ABI value between the GPU FW and=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * VFIO driver. The VM device dr=
iver is also aware of it and make=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * use of the value for its calc=
ulation to determine USEMEM size.=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * If the hardware has the fix f=
or MIG, there is no requirement=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * for splitting the device memo=
ry to create RESMEM. The entire=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * device memory is usable and w=
ill be USEMEM.=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->usemem.memlength =3D round_=
down(nvdev->usemem.memlength,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 MEMBLK_SIZE);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (nvdev->usemem.memlength =3D=3D=
 0) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -E=
INVAL;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto done;=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>=0A=
> Why does this operation need to be predicated on the buggy device?=0A=
> Does GB have memory that's not a multiple of 512MB?=A0 I was expecting=0A=
> this would be a no-op on GB and therefore wouldn't need to be=0A=
> conditional.=A0 Thanks,=0A=
> =0A=
> Alex=0A=
=0A=
Thanks Alex, yeah the device memory size is not necessarily 512M aligned.=
=0A=

