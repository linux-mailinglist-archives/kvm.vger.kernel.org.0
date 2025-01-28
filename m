Return-Path: <kvm+bounces-36743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6D1A203E4
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:11:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F4A23A6CA8
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A5616D9DF;
	Tue, 28 Jan 2025 05:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lLC1JgbC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3080C3D6D;
	Tue, 28 Jan 2025 05:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738041105; cv=fail; b=eXy8WbIyN54rI6tHJdMmcvRWvsnj16vKCQO1ucIGu0cXS/mZDkDV1aHdon5uA1++YPzVcRn7gLdZ447gcrgNqe56vW13kTS85+oh+tYUYI3mQrO9rQMfE2wkIIP8HA+b7rXm5smNXUHCuDliHbDXv1KUDqusjjFKK+YO7uOddxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738041105; c=relaxed/simple;
	bh=v0k80cf6tot479J9cdH+3nzQbbB8lHCfv6hutQw63xk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q2dHbimNtNwo6/POxacqoqCvtqWVUXaW/W08HJzuOrCHTtOVrWy4/dw8AqpX3JmCTuaefEYTzqfIUe4lgEIe4R+g0b3eQyUCfx2w31mlvXCocBkqrsRvMvb/9ng+hzsVwYlWdQz6GBnths+QSeIQbVEJ9dQK2dGnwmL6gVnZmks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lLC1JgbC; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+jb0sBO8xPXLxA8PyshJFvSGWkDWIsm97R6LOEQ4rrnZH2VoZ1pi54iufB3KpTVKJ4vq4n4fR0/nwPCgJfJWvJftd09sKysOdjKvqoNIXpTIuqEquKudztuttYCBRjv6gt9K9QSlGMijLQ5atfI5JUm1NM1Gr9Ul7+EB0vJLLQijJrzI35DBcYgCIU8r6xR/J4ecCwV3bw1x2UA+VvVPw1cATLPigUDRaW0UF43wFB7EibezK82LDU2nUHMo6lJl4Kvvjulai1KsSG4w8LpzcnqiAgg8k66VvdRGkFXbyKk/DB2m6YuA6JjS4wq6u6Hk5qBvH5YbiduDXNgjGpdBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0k80cf6tot479J9cdH+3nzQbbB8lHCfv6hutQw63xk=;
 b=dyYWUa1+CSHlH6ioRy2i+9e3lL8a5o+oAri22cZADToNybc2K0m9cfEeQ4r4tE08Z4ZH1sHUugH9Q9OZ/wxyHxOmfSscvutd0Q0aQ0XByoe6IJpIzvQfYoleQC7y4NVRC1Ma0kCU7PHxboKfuzlXk/5KEZZm7UL7dPrHS9gQcoR1aSEXhKHBdGhDvkyP9liRrvBOdPaFmaVcgq03HGWijU3h6lKjQKsBWcR9BvEmLgYuQw4IDSv66D3zZhphkGDtAzh4Ry/0s3w/uaf4/KbNQclLY6qF6AxwA4GQAICKURsjVCE0fxbwyZIoHNxBv3pcHhY7LSdwOnFxpsikl0YeJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0k80cf6tot479J9cdH+3nzQbbB8lHCfv6hutQw63xk=;
 b=lLC1JgbCNbgAfAZ4ydEI3HYHmIIJ3CljhBYu1TGv2cFM8AAQTY/U9A41ObZwXTnpiEY18XTMTu/I/kqbckldgXGAaLy8ByYOKnkJ0R+h2HJGlJ/QYxjkYkqP0Ns3zWyvM4NX3WHD3Bn5t28v5U54Vr7zC4dVc5RCO+c3RzXsxdj7AD2kEF75JiGXvag1rNnmu78MOpLa/ZZ2zZ/Z7PlvnVmnUKkB1dM7rVBPKlIoT7cXc36nG9DmeY+3xbAwdlGne/J/bTHm/JxWgfindjIXLkND/SaR/6FJ5MIPsT64YSwRLynVnaE4TZOp70pw/f9uROOXMs/xpjrx/mcEL0afhQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CY8PR12MB7489.namprd12.prod.outlook.com (2603:10b6:930:90::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Tue, 28 Jan
 2025 05:11:41 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8377.021; Tue, 28 Jan 2025
 05:11:41 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Matt Ochs <mochs@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>, Yishai Hadas <yishaih@nvidia.com>, Shameerali
 Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Nandini De
	<nandinid@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Topic: [PATCH v6 0/4] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Index: AQHbbo41cWLD0OKF3Ee4eDlCHNik2bMrdJEAgAA0Q7M=
Date: Tue, 28 Jan 2025 05:11:40 +0000
Message-ID:
 <SA1PR12MB719929B8ACA6D39B1D2AC8C1B0EF2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250124183102.3976-1-ankita@nvidia.com>
 <2AF42909-144F-4864-BC87-64905AA0FA04@nvidia.com>
In-Reply-To: <2AF42909-144F-4864-BC87-64905AA0FA04@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CY8PR12MB7489:EE_
x-ms-office365-filtering-correlation-id: 58ac7e86-8da9-43ef-ee0c-08dd3f5a4000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?WnDSbizksrridPZUj1WziYLKYGKDv1xFVtIhIZKc9Ujc/cNwRyjEVO/ALk?=
 =?iso-8859-1?Q?dtqZh5fGnebkbwKVcO+SJ4q2xDNE4Xg05Z0KNCFDeyGjshAM1Rb4vZVqpm?=
 =?iso-8859-1?Q?LmBEnNFBj1puXIzgdvmOqdZFlKpoGF0NI8q5rU2s+Z6untH61hUQHGTbbM?=
 =?iso-8859-1?Q?5ca66t4xhqTV4WL5kB0jewefICZPxN1lbf41KEKdOqkgO4SoyxU6zae5fE?=
 =?iso-8859-1?Q?1mhDU5Sw8ugkglAOWLHrt0yYsaOC5pvxQUQG+bCnp2qjs51zOoVey9MmAG?=
 =?iso-8859-1?Q?I9BJAO0GsN0qzhazy4euzAZK83a9e01e8u/iuI0Tzc1hAU3wEn0mO35xdP?=
 =?iso-8859-1?Q?HMYn00nZa5/qaIoOK6rjwqTDPFqtVvCTzpT8SWGvjVVrQ0zRAMA4o+qFuY?=
 =?iso-8859-1?Q?kdf0ii9vGph63XbWF9KQb0aaDqTubnRTdWhUsOwwaxqZFnrOQVdhjUJRiJ?=
 =?iso-8859-1?Q?ekWWHHi4ga9jh2NVfQ6+rIuf05xsyd0QjdQBUQsLv3QUpEcWelJ3ceqJvV?=
 =?iso-8859-1?Q?pl+tEFv1uZSWEyl3hEoLuaErgAJ7A2iUtsttd7/p08xFOZY3/Q9zFpBGB9?=
 =?iso-8859-1?Q?YGBgCIeawJ5cOwwCvN+erROJMwuh15KQ66vBA/abAkGYnpDWKmmNJg1BU+?=
 =?iso-8859-1?Q?csF+gGNIJg415909ewCIZwCcP/thFVH+sCQcknZBlJs2DcPaqPzwgxofBb?=
 =?iso-8859-1?Q?EtkHpZM9jKB/cvzV7qWV9vlLXdRKm9d5owGMi9XWcOdrXzBJfO7RjR8Zej?=
 =?iso-8859-1?Q?TSzXqV4cVna7xtaP5SvLcCYyqjYdrtRFLjgup8/ZC5iO035mTp6m3Hh4IN?=
 =?iso-8859-1?Q?hdsAku9fxiDL8uI0KbCJclWvBj5Wax1aRoa3dH78VVEAL761O62x9broME?=
 =?iso-8859-1?Q?SW9BScwD7uh23w114H6IJRW/5KbToIEIDQGKYT84adzDBr7+62j3DHPuLW?=
 =?iso-8859-1?Q?b7ixnnaj/KzwtZfW13VLra7Um92hjOkP8HbpsubJVkNx0nbH55pAziOksf?=
 =?iso-8859-1?Q?2zRUrHv5BmcDTAg6ckj9cx+DQJEaop//3tYxI3yAfvIwKLJl0d4KWObDQi?=
 =?iso-8859-1?Q?/2RPhjqLb7wZOGq1nrJb66Yi3BPfzwiHdhWIH+Ahb7Wn0Jof7H02hS5cy9?=
 =?iso-8859-1?Q?NMYrAF8pUJrL1QR2K8VuNjpDpaPcJ88aZrWz3TKRf8APdPDqgO4b9x8zJc?=
 =?iso-8859-1?Q?T7kD/xr34LereoaPHlKsa7ZcgQTgMce82n12q/HrH2bt7LJJqLqLpB+ilA?=
 =?iso-8859-1?Q?UxLhVpyUBpF8yGEk9SzD4QUszDp386MhMshALC6T3c6sA5Fwpac5MRqz1s?=
 =?iso-8859-1?Q?wgPj0v9vntN+JOfNCnD9e/3KxRVHfSzS5w1g+iIOppLKVgbQFCkpt0Rz/C?=
 =?iso-8859-1?Q?B6c+Q9q6SY74NSwY7aunm9X1/KA43zEQHjkkaXJDMS7vL0dAQyMqC5dBxK?=
 =?iso-8859-1?Q?njAB83+IWUyNqjIq9oT0YUsyp4Pril3EBx1k1QNAE0j9IS57xfWreF0fqI?=
 =?iso-8859-1?Q?c299QAp8ou1ZZv7od/Ovdw?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?J3bCK9B0sewF8s8yC9CxKT/sGJwTPjVFZgg14vZTYhJiusQ3w8L1WYAwjQ?=
 =?iso-8859-1?Q?R0YSStT8GheCEpsihwJA2yClJQ1+NqwA2US/FUVtIbX1nT5/O5jQdFcl3s?=
 =?iso-8859-1?Q?+PzMe9bVwmdC2wiHTDjTuaKHFVSrSicQAHEwDkXDdCvNF9enYZ/c3Bw15x?=
 =?iso-8859-1?Q?HwfhM5ct3Hrf8E88ekpxzQFn4Ti/Tid+QStQzSVvO1T1uzQ2Jqej2q2aLS?=
 =?iso-8859-1?Q?W8iV7aFZjCxMUK5emeuM5zv3SLxMCfQBEB/UbkYPcamK0AsPYa9oGp2F2K?=
 =?iso-8859-1?Q?TL0U0tAM12LUl2oN8IKP6hwvs3bk3RiIrRaZwhM8Oea6VdzvNhE3Uwtx1P?=
 =?iso-8859-1?Q?pQ0FjT8bjFBoAi3kKKZKliayB3OexO8zRm5OuT+lLSSckhfBsRf3gdXSQ2?=
 =?iso-8859-1?Q?D/68GS2J+UEkI/6MXovq8QYGeg0bNdJS1lqMIQfLvU9v+SfJvy3sty7ocl?=
 =?iso-8859-1?Q?sM4MUzTOF27KMgMT4qNXmQ9L4SzoAx2FkK7NKmU8k0tWXDTh++Jc3dwQRL?=
 =?iso-8859-1?Q?kB4lQxtSDykejxt7v8jbp585JAF6LLHqTTUnQIaTyZ92FBdWmv+B70mXf9?=
 =?iso-8859-1?Q?gkwBoPKWV0XZq1Cp+QcCvhmk76m6Wf/c2sfF9ojnqAcUkbvwaODXkCrwKj?=
 =?iso-8859-1?Q?PY/WU0wroXPWxrOypI1/wLmfvCX5ClZ5bfOav6wBU0VRe1J1Mhnjz5/SU7?=
 =?iso-8859-1?Q?LR1fqQUx+k/l/9RvMN+3MFMhqcnclS5RtXwqFdtVVcxjEjt/VO9JXlb5Lz?=
 =?iso-8859-1?Q?nUK4cXt6qYJ139pcPaCDDf9eIlKkNOtNFXOS3GAo7NP9xn1qxzl0Ti6Ut5?=
 =?iso-8859-1?Q?vCGjxy7f9dS9dAfLR4Tguq1LQb/SsIgXNwyni4mHUpuRQ+CxpmH/XOj+AK?=
 =?iso-8859-1?Q?INtjwDsVUrlGDz6bsLdgEqyqKYPvVzAUmASz0R6DqdghsCPfm6/N5v7OV8?=
 =?iso-8859-1?Q?Fy6OHCbqBEJYdpYqSQuS0nxt3okvdNdK/ToD2o/6MAs5nP9pfyRMO0Gq2X?=
 =?iso-8859-1?Q?YyjghBvCjMBzJh6KXG0rwn9Ir34Xn/yb0j39TsE5dbRa67dTXO3yDOZGm+?=
 =?iso-8859-1?Q?knSByqOR1uT02w3DXzmDsivPR0copY3QwgO4CeqlU9dKJlWv0BY+Nvciac?=
 =?iso-8859-1?Q?x6QVY+ux1nDFN8a51Iht1uJwkh9KI/J9nDpN5xyPa7talJRpjeX0GjX6jU?=
 =?iso-8859-1?Q?xjS+0bbVR41tHrCJKn2+cuqQWI5E7jKLpqA1gV/pk/4NfTIdUZb6JIHeLH?=
 =?iso-8859-1?Q?dIT52z2rKsXLya92Q5DjizTiYlaAINQFs/LLGedILhk+1pl2qDqYQJkSXH?=
 =?iso-8859-1?Q?ABlvmC8m+REYYvryv2bsMd3tezi6Qd1p7s4zN6nghUgERvVj614Ej7K2Bm?=
 =?iso-8859-1?Q?u7kU1Uha14XReFQKvf/OG9c6kBfgOjgwg1xWC2eBB7apv+lyirQIiAUOyN?=
 =?iso-8859-1?Q?iHMWOt5NViMncgNEeLUy0Tdc+3NfP+LoOi6XLIrYLMTBv3hA157GHMD4Vi?=
 =?iso-8859-1?Q?funaHTzevZ2cUB6bgnzqF70qUoWkQ3oLqwnkkGdTMF4crNN67LFP/jEc7y?=
 =?iso-8859-1?Q?grCUDrPtka4HMk4qAo76C6Uiq3sygE6qAlCNB8qCm+KB7kb9BEpcap6l0p?=
 =?iso-8859-1?Q?p57Eq4bTBjpxY=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ac7e86-8da9-43ef-ee0c-08dd3f5a4000
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2025 05:11:40.9825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6cDSkh5UbeWaTIjbnnLjfcMEU4KC3v0AJe4xJ7x3xp6LTFrNa9Vl7OWcCEHecBMhKo8lXBJ9pYC3ZKz6ANchKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7489

>> v5 -> v6=0A=
>> * Updated the code based on Alex Williamson's suggestion to move the=0A=
>>=A0 device id enablement to a new patch and using KBUILD_MODNAME=0A=
>>=A0 in place of "vfio-pci"=0A=
>>=0A=
>> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>=0A=
>>=0A=
>=0A=
> Tested series with Grace-Blackwell and Grace-Hopper.=0A=
> =0A=
> Tested-by: Matthew R. Ochs <mochs@nvidia.com>=0A=
=0A=
Thank you so much, Matt!=

