Return-Path: <kvm+bounces-35934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7603A165B6
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 04:35:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 105B53A4E34
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 03:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7564414387B;
	Mon, 20 Jan 2025 03:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R9hpAIZO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1A163D;
	Mon, 20 Jan 2025 03:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737344126; cv=fail; b=RRT90Kb3Ikx17wQxAN+n++k6v7CdCJPEOW/SCDSttUOl3FQfUfDsuuC+oYmqdGVH5vEk6g+VzDphE0AMEGWnCfS5aBy/ONKJxCBN+SIjO15636qb8T4KbMUJFgMqfg3dHbj5BToGFulsCxUGJfitZPrSic5sxvTiN/0B8LpAbSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737344126; c=relaxed/simple;
	bh=+Vlu6N9/dK/gk18qwdxyVbxhsfcOtpfzCBtV4LFZDaw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uNXsDtzPxpAy934J2ehjw6yCjX2KJzs8NDTH4gjsdbF/IiRSzBBOv3HySc+MAaeN9nFx9clDnVtIhWxO/Qju//Kry15WmARmrEv4oZYLz1kE6Uz+WgoB2HcIcwDRrBUbwwxACn9AJr1rPYIUhUcCF00u9eDrLeco8zJi9cR4GgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R9hpAIZO; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ElMd9ijn/D8xacXCBnLwCyzC/wD1v9rdOkNez/9bD/wcR615woBOpip9Dv/8rE8VQgJUX2BMhLspaXXWjU0kAjiBZiUHmhYoky9mDXz9xtRY6LgYQoCwQXNCoC2byXqY3+pe8+vszWEjlsigNnekum1kDQ+VSOKeNfPaoLrTOiNQ9fsXmEsBTBHcekiC6n3RRfS/Q7so06l1hxyt3Qen2ZAn8CStPEszoEvpHiuxM7ESgqL9W6KhaWJtP+5czZECLxfJLtJu4aTtKiOZzBtFBO6IjKqy9q0TB2nrvxW5zn1Fhc9UTTYFoY6+ya22w2yM/vnNxHGxjO0QZKc9a33X5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Vlu6N9/dK/gk18qwdxyVbxhsfcOtpfzCBtV4LFZDaw=;
 b=KQ31QXakeCqkE54YC8MKDNLVN5zS/meud4YleN7Eoo8qN24Fkrn8JfY+0DsOsdTva5pKrFmN5v91si4+s/PB2jC0jNtGBIRLj+8dqfsab4lAgpeFmHGdMbwLat3YaDzBeaJqtYO1tetV/aYspYIvfm4bC+qTQDyMiDOVEZPrR8wHjtrnSTmyuDUUgaaXM+vQ3QxN7Rh9uN35m7gN/dUn6OjRsU+ohTsn1dPwP3o9nO3nZnnukBhYka2qi6OMxz2qbWEm6ZebWCZOr9iQIfLTmHtz2vaOeo22oSj0JtBiDn7Bg37IrBRD0A83IpthmTrvtog9gC5QnNF3GvXFX43hHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Vlu6N9/dK/gk18qwdxyVbxhsfcOtpfzCBtV4LFZDaw=;
 b=R9hpAIZOVSNmbnnNSMws5sDQGqgi2zrs45IrJGXDkpZ6qne65PpjAY9s9UgrbM0UwFZ/NOqbVGBIiyJ7O5iGbNRGp1XYXB3LZwEnU9zsCiXlOvkKEoIH67Mysl0ti4/L7zdEDFSXMZdbzaC40Hye8DQWkzU6SfegatXdAmSREotwjrD8CIhZfZMpGhx3UL0sfPAlgusbuZWTW85DGVAr+W+oLbUK0GCf0itJaPmD3FzwFf8YyXPTVIYBjou2PFO9ij3baPhs0ZFZy/r7z5ETNSbtLGZ0GB5wU7LBTn9yyjbzNJmThagMSjA8AR+Fp/5RENSF4ZoaOo41cTFvSel95w==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB8270.namprd12.prod.outlook.com (2603:10b6:8:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Mon, 20 Jan
 2025 03:35:22 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.020; Mon, 20 Jan 2025
 03:35:22 +0000
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
Subject: Re: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Topic: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Index: AQHbaTjDvXSIdfxj4keeAz0umh3JrbMbxNQAgAMrU3eAAA+xAIAAAuMAgAABnX8=
Date: Mon, 20 Jan 2025 03:35:22 +0000
Message-ID:
 <SA1PR12MB7199E9E9C53B987709CCB849B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
	<20250117233704.3374-4-ankita@nvidia.com>
	<20250117205232.37dbabe3.alex.williamson@redhat.com>
	<SA1PR12MB7199DB6748D147F434404629B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
	<20250119201232.04af85b2.alex.williamson@redhat.com>
 <20250119202252.4fcd2c49.alex.williamson@redhat.com>
In-Reply-To: <20250119202252.4fcd2c49.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB8270:EE_
x-ms-office365-filtering-correlation-id: 1e6e278b-d6a0-490a-8625-08dd3903786f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?UKCQppxQsDl9XPTn5QZklGsrNB1Vd2mhDBhsUDv9zb2RDW9Q0SNihUgheA?=
 =?iso-8859-1?Q?4HyPUP3pnu6M0nbJLRUIxgK+DJwSQu0ycZSgqqUMhlcM9M5606rh6+lng+?=
 =?iso-8859-1?Q?6j6jdyZ1P0i+d0DLxF1hVFmMbkpvvGRYKAT7TEUtsVWiW32hrXnF5TCAKW?=
 =?iso-8859-1?Q?U+Q7dEorfmNDRuMwNQ2qyrbeX1xLzQl0uU/EB9T8QKLcO2dPWYe9wFsRO0?=
 =?iso-8859-1?Q?Jvy5EIbXMTrQH3JzMpSzj2jmUv2+3Gds2Z4lfPDvj0w23SKfTtdZOj82bU?=
 =?iso-8859-1?Q?tcflQ8P9O23juj48RvnK9s74JTqj5I0/ACeHiLeVx0zGOZ5fHIRxaEBkfQ?=
 =?iso-8859-1?Q?RnRCjUpxwK9sv4u6vpWKkAVLNAzAAN1mTS6WIezcfdKWzlgUOr5PeF4BMp?=
 =?iso-8859-1?Q?ZZRBRHEd+dxde0Gl+xmmYQ9Nb01BDxIh3ls6ETXxJoBQd/JjuNlnikfd7P?=
 =?iso-8859-1?Q?pAwxnr5iEhr2/jxtOiiOomOyvGR9yh2dhWY65g2rn3dTIHoWy2JLtULnMy?=
 =?iso-8859-1?Q?Rf/soLMZN3wIWrXHlOw5MiNNYc410wErIRbaIOzuFt5oklPLSc8UJp+Wq6?=
 =?iso-8859-1?Q?jVMPsYAfZbgy2D7h6loSJ6UDlcFMH/PMc5+T1IPbr7w5roj1mcna+opEu5?=
 =?iso-8859-1?Q?h9Rvbt0OpJCIIrL2ZoC7Oyzna/5iIsooQGxqqB8Vs4QjKJ6Uc4vmgXo5yr?=
 =?iso-8859-1?Q?YeNxCQcWQNoEXtsWF3asQbrzX7TwrEIoeNe6AvGjfAjFP3V/3wGmrjImcC?=
 =?iso-8859-1?Q?Kl7TfODr54hpTie9qSWKbIy4jURFuGSsgBlNSF58PF2AXsTBYQHqwzFiYK?=
 =?iso-8859-1?Q?SfEMLLQYbvuYXna7g5IqofWb9qbpFd6VFY8F0Ms+aLiQr4SJt1jAcxVjx7?=
 =?iso-8859-1?Q?gRDpoSLMUTqr7doScSrBSEOv09UNS/1LdB19XiSAOFBWGpy+Kl8dy04/MD?=
 =?iso-8859-1?Q?bB0rqVb4VFGl/G4K1QC8MtBrj9b7Ig+yXizyUxsajUTQQ4ea/ncSTilb0G?=
 =?iso-8859-1?Q?yD7HBOVmnLGBrul/p2O7gF9Uhv3o6+yOpQ67VbSJerBNi2ZVXOLon0pkjM?=
 =?iso-8859-1?Q?Ul3Ic2yUGfSY2pNLOS7AOVKsx39QiT2F2rZgbyxOkSDBoY4v2uQSKUNXDS?=
 =?iso-8859-1?Q?H7Fe3tXTdaYFnACWi7XImm5WrCH/hwgDRIygszq7psgc0zA7l/P5dqW5Hn?=
 =?iso-8859-1?Q?Mb0zKIaGqVxcvLckNCRNfOUzcPW3Gs0xU7Ow5C6xUCvaqkf1VzJC1C0sRN?=
 =?iso-8859-1?Q?ruBdebUVhWaTMcr6gGf1+tBYmtXeOv5GEhu03RdZE6Rhs4h4RLD7ntzoEt?=
 =?iso-8859-1?Q?hYFIVA43x4F3iWLjWOz4R4IDIY8IFa85ncAWEP9vF7gFefDRdkOO8vgTDL?=
 =?iso-8859-1?Q?W2Y6m2IDLXGK27rejLA39NEhnXSAW2dsrwL4ME9xtudqBCiX1k7G9TS9FR?=
 =?iso-8859-1?Q?sLZ4A1NyaymcL/3MWEui69MKossV0Kgl43h+AfU7MQWY5R48XGGf10+mhU?=
 =?iso-8859-1?Q?C4GE8Taj6aGiOZEqhaUzu0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Hm6oVhMsizrtxjuobwmBSiL+BJBZ8vG6Hssip2VFEzq/zK36GRoKiJnqjk?=
 =?iso-8859-1?Q?1qWoKTi/OMPju5yxvB4pDRv1lgUa1N1NQj+ykbj057o0fULbN1ga5fJmf9?=
 =?iso-8859-1?Q?UFuD15klPiJgQf2eQdlBOW6WXSMX4FczEsqOuudKh0DzctsB/0xXwMKtWd?=
 =?iso-8859-1?Q?O/n2aC17lCXqKSgws+RM7GiAAkMj3clmNmz0raxcIL1l1+DkljSZg9vIoR?=
 =?iso-8859-1?Q?EXu6Zry9bcHSx0SeJhkM33YS6THpenvHD13O5SmaZHRW33FbnQ7eDGCpbo?=
 =?iso-8859-1?Q?Cl9QcOK1XmFuJhxdGXYDNW74DFjig4BxrU0j0YTWYZK1UMW/cF0bMqdzkI?=
 =?iso-8859-1?Q?DOPBb6YY2Y2QBgcSaKwOOt6Nt+BW6aFihXujbvN/4Tsk62N1wexJmeTHt4?=
 =?iso-8859-1?Q?OnW6Sy9VSpHLEdnyu/JEw4FlAXGKaYRQ7dzCMfK4LTv4NNUQJDgz10Osnt?=
 =?iso-8859-1?Q?b8VGGuGa5zjfXqsmce8EQeZbhD5m13Q4aXCCwYgYPUFGcTxyYQNdiGZUp+?=
 =?iso-8859-1?Q?2Y6pmwnOmSDQtc9QIsXqJcHYJ69Y4Zwb1JR1pw/2FUyus88kDd5uPpVFP+?=
 =?iso-8859-1?Q?WECNAdv6MJAuaI+xeTqXxMmyj9WC9JTI29aW/Afpaj7ZPxZGkTdEQrxbs4?=
 =?iso-8859-1?Q?cnqJGHhQntclgMU5xxgeyfG2H0U0E8fkkPAQsNX9LRntwQWtqPaipDitzF?=
 =?iso-8859-1?Q?1KGsq5PPpEddAPiHGtXCnrBnhIip8kE2bJeT/DUpZULbSc7r4Nx7REdxa8?=
 =?iso-8859-1?Q?UEqan9hMyBOp4LIs6kP+9/j+v2G7H7sDlgwbMYDD6k7R+Z7SVfkQsC3pOR?=
 =?iso-8859-1?Q?JeXTPJiFDxWQfksrbJdmNqWl5bFJD9CHO0aB6FqlQm9cU2OMzeM7XRXdUR?=
 =?iso-8859-1?Q?92uOJSAKR6elIQlwJH5XbMhwlGitwdb0/6c4YkMkUNdH5XR11eg6YC5k9S?=
 =?iso-8859-1?Q?RihXdoIuasPCG+OEk/vH/fgbnXQZcmCbmIwlPE0Duqmznk1OVTXAOQCffc?=
 =?iso-8859-1?Q?jj5lI6A8UEm+HoQ1DZGb+8+y4dVWR6e2pZN1pzjXSW8S2z+4+coQyS1VDo?=
 =?iso-8859-1?Q?AkMIgBWzo9t7u0HVw1xQF0f9rwsx2QwipbpG1Iw68aSQUKQHqBh9XaZ7LN?=
 =?iso-8859-1?Q?NI7NTgsiifGexwOUnkVR5/lVtkUdPay78YMvfGVrmro8lodOAAgqn+Mxv4?=
 =?iso-8859-1?Q?KOrYHC1zs45y8wTRojAuwmLz6XE4EI67LfjYemoDJ0MI9QUAa1TnDOfrqQ?=
 =?iso-8859-1?Q?U9oXz8keZAN98Xzg0PMS3dn/VtNm/XD5VtJy9scw06MquoODBid7vf4TCd?=
 =?iso-8859-1?Q?Xp4iO8xbCJc5fF+iuFN9KrXMvFcOmbp+/DxDqifDLnx0j+iNI4/I4slfZh?=
 =?iso-8859-1?Q?G/JZZB3+fVMm2veejvmhmpdNbbHmHE4b5iEnZ7YX47CCQq/bn8/5mdKPxM?=
 =?iso-8859-1?Q?wAKDYSuyxM8MhVPBSYgrtEvEyfpEQAEvx4UYAIugGPRoa1r+zkyNqvHBLr?=
 =?iso-8859-1?Q?g/niPpBUD8WlAjekU9CPKPXI9yqdISTadze47D0Nlt+w/mDwxDa9T56x6P?=
 =?iso-8859-1?Q?DHeHFVIlpnGB04QEyIHUz+1mjk46Ym9RSGJhTxLJ0nNZ1rKwcFxgmbs+Ip?=
 =?iso-8859-1?Q?0JMcdL427Co88=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6e278b-d6a0-490a-8625-08dd3903786f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2025 03:35:22.4361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: naGLUYZCmie8j0i237nNTNu+2XC44gj3SmW1f8KQM0Wg+xT5/c9d58DfJBrGNnSYQ5d211MiFAa2EQQzpOIqhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8270

> No, this is standard PCI driver stuff, everything you need is already=0A=
> there.=A0 Probably pci_enable_device() and some variant of=0A=
> pci_request_regions().=0A=
=0A=
Ok thanks, I'll take a look at that.=0A=
=0A=
>> > > Does this delay even need to happen in the probe function, or could =
it=0A=
>> > > happen in the open_device callback?=A0 That would still be before us=
er=0A=
>> > > access, but if we expect it to generally work, it would allow the=0A=
>> > > training to happen in the background up until the user tries to open=
=0A=
>> > > the device.=A0 Thanks,=0A=
>> > >=0A=
>> > > Alex=0A=
>> >=0A=
>> > The thought process is that since it is purely bare metal coming to pr=
oper=0A=
>> > state while boot, the nvgrace module should probably wait for the star=
tup=0A=
>> > to complete during probe() instead of delaying until open() time.=0A=
>>=0A=
>> If the driver is statically loaded, that might mean you're willing to=0A=
>> stall boot for up to 30s.=A0 In practice is this ever actually going to=
=0A=
>> fail?=A0 Thanks,=0A=
=0A=
No, I have not seen this getting timeout in my testing. 30s is considered=
=0A=
to be sufficient to be sure that the hardware is not in a bad state.=0A=
=0A=
> On second thought, I guess a vfio-pci variant driver can't=0A=
> automatically bind to a device, whether statically built or not, so=0A=
> maybe this isn't a concern.=A0 I'm not sure if there are other concerns=
=0A=
> with busy waiting for up to 30s at driver probe.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
=0A=

