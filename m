Return-Path: <kvm+bounces-64403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2C2C81658
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 16:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 193D24E419F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 15:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61837313E2A;
	Mon, 24 Nov 2025 15:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fG3tfbSr"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012051.outbound.protection.outlook.com [40.107.200.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8729B3054CE;
	Mon, 24 Nov 2025 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998866; cv=fail; b=EB7gx2WwU661uL3RHqsbP5x+CUZ0zk9pFCEYgdvkZS3HETNnWaTI84F+xB5YU1ryMeGhFQIkfxcIZaXESHVOHS6TKMIaj8+lMxsr/2YSltYG0irn9/T7npyIu0fAUBMTMyw5UhP/kzf7sFLGrKRuM2F/bkui++j3Hy8XAaR4ZW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998866; c=relaxed/simple;
	bh=0uCKJDVygEuNOMyREU17U5Llw3jciOeul5ZExZDhIEc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OTcJczOqPfB7MWPN702lA1//WpWFa0AuGfEaSYLxIdP/uGzvMSiHESHYnkc8xKLRLBZs0KliFH6bh+Tt2Bc/ZYby/GOkwrjqJw+Id1e7RGAD5RjFGUTVZzG0GnCwt299eUGG075dcYy75qMBOY9IuLAbD5wQdTT4L6Ykea0vgVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fG3tfbSr; arc=fail smtp.client-ip=40.107.200.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jRBcrVxep8X6/NLnJE1Ohx8pjNp5rUYj6TR9iCqYZ9c7b72mxr/CltfnD4gxQUIqGUMuQN1U6F6Yi78GR/Yb4iBkfDvs6uu7jdbViZMvlE81a/EL8xHWOXlHuMndzulaeaWkUgahGAP0HO3FTwYTBxPplqnoPDulBImRXgyOt8m/23iB6Kb6WMAMFYpATjTemG3iDaKIZGIlJocGvL3sC/IVz8r9o0y+Q5HPqC+wJnM7LDdXxQq+0DqA7zKP770K6eHfcyFr0WMxURRVZbEZDShXGudbLgsSXxR8uoA/U6ebSxeaqdzx1wJsU37aXzHZOFTt9ea7rxOVMVU6sKwt0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uCKJDVygEuNOMyREU17U5Llw3jciOeul5ZExZDhIEc=;
 b=YXDaof+i6gdOUjzqqHCWr1MDFhYPQBTPLPk61kDO6s17VEfM/d+eA9pE1X4LDvH9HZ/N06na9ltbKh7rVdnSBmusQQQIDJaScJ+H1AnlsBfPSYED1rwjt8YUOub2YOvp7dqVs51ZeWrGrvhTjPqbjctfoq3FLCB/WoIHf3hwDXEsbUio9QDgwa2JvEVOK3o/gcPNKqNjUwMXcLSYArR2P4D9ufqSSk4TTCvkx+7i71SMhf75h8XdJrm1lQLSXXoLN155yLrIOi4rpk8W7toTeBtLXt0jlQRDq8q4zSJ/+qKOVaviD7L+UUxSswr5O4N5h6s/TlFlQLHYbjJTxJhmCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uCKJDVygEuNOMyREU17U5Llw3jciOeul5ZExZDhIEc=;
 b=fG3tfbSr85yJlB3chMoH8c+Rm1JhUlpm1aDPcq+QoKIGUacZPC5UuX5gATzBpU9Eusd/H8c2cFtuVXUUQ5hPyp9K2LVxwgx/Dv/SIg6ofsF25Zwugo7TNmEbKeJax61BfTgBEiO683NRq8Vj3/iXisp7niULxF3YBzI8a+Hm9DsT+GzKeqyEm9RD3TGf5GOAmeS3FUdQsnzNRQBpFHUSwnndT5KMJDYS0Z9cuKreNRRikI9mJgq0XCe3QTOuCoK4C5A1t9JMngTFQWlPtjg4cU8/bxXitj/TnKJzPY7/X6DhJXhebdHoMr1OJiqy1bu43fk4r83UP023R235Rb6CbQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MW3PR12MB4425.namprd12.prod.outlook.com (2603:10b6:303:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Mon, 24 Nov
 2025 15:40:55 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9343.009; Mon, 24 Nov 2025
 15:40:54 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
CC: "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi
	<vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>, "Yunxiang.Li@amd.com"
	<Yunxiang.Li@amd.com>, "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"zhangdongdong@eswincomputing.com" <zhangdongdong@eswincomputing.com>, Avihai
 Horon <avihaih@nvidia.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "pstanner@redhat.com"
	<pstanner@redhat.com>, Alistair Popple <apopple@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi
 Wang <zhiw@nvidia.com>, Dan Williams <danw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>
Subject: Re: [PATCH v5 3/7] vfio/nvgrace-gpu: Add support for huge pfnmap
Thread-Topic: [PATCH v5 3/7] vfio/nvgrace-gpu: Add support for huge pfnmap
Thread-Index: AQHcXTnUQ1LhLbrmxkKBer15R5Xs8bUB9KuAgAAB+qU=
Date: Mon, 24 Nov 2025 15:40:54 +0000
Message-ID:
 <SA1PR12MB7199E4230AE86059E2BFF5DDB0D0A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
	<20251124115926.119027-4-ankita@nvidia.com>
 <20251124083237.26c92d2b.alex@shazbot.org>
In-Reply-To: <20251124083237.26c92d2b.alex@shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MW3PR12MB4425:EE_
x-ms-office365-filtering-correlation-id: 30e19446-2eed-4e1d-c049-08de2b6fdac3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?b+xdrF1t9mq5bxDISVb/voJK7Le41w5y/8tbITdE8AU2FTkxAgQgV7mDmp?=
 =?iso-8859-1?Q?NsM/Ot5jaycJH0vy1ASMECmCaeIBf02D5fSmkMkR0bBMkNjB7FnyH2JnNT?=
 =?iso-8859-1?Q?2YsmZFgqJEnqcb7Sq8pExI9L3KX9jcLG6JPs7iX7NTTqRQjJZw0VnoNh44?=
 =?iso-8859-1?Q?mhWwkeuYEBN2vcCTPPlwjIZxLAuHiW4d4RjxToC1VLvEZxVZEePIS7Cg4C?=
 =?iso-8859-1?Q?+y3ABPgA2FVA5AJvMOKkWmbGyB7DeP/IZe74SXprJa3u5Pph/bMsKas61G?=
 =?iso-8859-1?Q?L9ws3kMQ7P7XID58IcOkKtXvlHlHEosXCvCleG6POOmIUP+4kkXuFNu9Qy?=
 =?iso-8859-1?Q?utk45rD/nCKqYTCMK3iBS0pOmEIfwDGKs91IzOIUYteAJJ2qSS18TJa0vq?=
 =?iso-8859-1?Q?1RBXklMxVqCDgI0RgtwoCWDX9FQ0F6kXNQ5op/MPlWhZywEYJg7P+9EU79?=
 =?iso-8859-1?Q?p2Omw6QbOHI+TcfHTmMDBydTPBF9DgOHsiNFsZvlBTViElPwzIGk9I57hV?=
 =?iso-8859-1?Q?z8nM13S0zvQrzmDjcK629rmL10IqXqb08QMpc3y/RGPDZwtpcUGw8CAbb+?=
 =?iso-8859-1?Q?rIYRcYErR6HiZiQUWF8BUzCQUpD5xMRKhs6iEBu0XnXm1D8uVoJgSY7zl6?=
 =?iso-8859-1?Q?/wkIACEJXagMAr+2oEhSei5j5Xgv8zAbMW1VFePHSaExfPwo80kHNUtG7L?=
 =?iso-8859-1?Q?TThSrionQerHReK/fi0F0WxrCdWhpci5dwa4CAJSeACmACQ4DZMjB3ZnkM?=
 =?iso-8859-1?Q?4K0WadkR/IcQdWJT4t7ezyv/W62k/7A+WAisuGHBZjqNgWmc8yEzHwt3Te?=
 =?iso-8859-1?Q?tWsqlc29/BXyz9xi4zHFyJp5WMkZUV4mLFtDK74MdtIAkx6hpXkxeKAcN6?=
 =?iso-8859-1?Q?n4XfayBPn5z6KAkpRcp6Rig9sLHfvJAUrXsYOjTer1OISlWqs2uclgCq21?=
 =?iso-8859-1?Q?TZjvK9rOKXNfEHlcGdEH9Cjeyk5ntNtaRbKw7n8l5D/wUGve74iIbJD0qw?=
 =?iso-8859-1?Q?TIKJAcdvOdc2yMce9IDpZj1ZeGxn2S6lDSxfjmShFp8jUBoehfRyX7hhLu?=
 =?iso-8859-1?Q?oy5dY0wW/eQMKwkiBx9Rl7DwS6gQJuzcehZDfqdJI/Cm6OfwPfWreXqQP0?=
 =?iso-8859-1?Q?08q2o9EeXn2a987qwcBOlk/wYeDuHoiYLmLUMcCaTtGo5Ut6hU+jbVE0X3?=
 =?iso-8859-1?Q?6IGwHVw3WiYmSpNQvpROSLZK9NyGKggEkrQoeOCaAK871FBOwZ/gJYqORP?=
 =?iso-8859-1?Q?cHaNWanv6UJwh6m5xLsKvMwfc6+pNmm5/+RnZwJ1u+d5dQsNwOuonjj70z?=
 =?iso-8859-1?Q?mtZgVdD6nSAaAintgmo6u81zDY8t3RMlO+tsH14ZKzutLzK0srYZgbijTs?=
 =?iso-8859-1?Q?60HzYEqz2/Erdit+f04z1VTq5O1ZwGnF+5D2zocU3f/EPdaOerD+LrD9sc?=
 =?iso-8859-1?Q?Uxf3Fx6c/BqO3Lja9P+Kk934YZu0u765CT4+eZIIplq/CMp10LxFtMjRNj?=
 =?iso-8859-1?Q?/PJW08GR/1Jd71UK7+rIpiscFkN1iO6RwK4ssSXSzrj+Z0Q9LulYGclaqb?=
 =?iso-8859-1?Q?xapwzX6iHGeS9qayG+geJCoBb+sN?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?wd7mGX2JddSCaZqDZnP5gBTAGMAv8TOvFWzF3nvwmjtrwSe3vSqGaW8oMS?=
 =?iso-8859-1?Q?UdZXVQhoQGPS4LUeBcKYaE/CNaXxMZqoTzzl3h1KBOGJcDcGvWeQCcVHj2?=
 =?iso-8859-1?Q?HlfKmEEzbnWqaW+C8FwACeEMwMHVm2SXHLWBbucp+O/iDk7K7qyjmGHxTc?=
 =?iso-8859-1?Q?alSD/NDvmlPenMrzdp5gHbZEiWWcPcyZI6lu72y2G0+/yw6Hj5Ymjq0UuJ?=
 =?iso-8859-1?Q?PfbbJn91q577h0/SzqGVkEvrNbH1C4kyW4w+rsjvtiKMgsJTwLD7ZTJbs1?=
 =?iso-8859-1?Q?p8WAdFP4VPHAtiQC0EVhVyMNAtL9sGB7REZd0hm5f+qrA59LR3lNxbTFt8?=
 =?iso-8859-1?Q?809COCYzgt7UjcC4zOL/vuoT7fDmp0uYX9YKWr9zrGwT0qeqifBoAlPQ02?=
 =?iso-8859-1?Q?U2mP1sXqt/MQ6qDiolGVQwriRNr3iITKUKJJFTMhwBhOCIJzmFoNF6P2Ez?=
 =?iso-8859-1?Q?NXPdog0swq5vhhb09D50h8GHhzdj4ILLA2JxsDa+oOpFsnYpSuOg7Z7Dre?=
 =?iso-8859-1?Q?tODRVHMkS3xH8FlQyJJQII+eWFZ+bsJfDUTJYKhVaGj9laoYgMuVfhlT1U?=
 =?iso-8859-1?Q?tVrHNH6RQ7Q2yy/7sg/fxAiR3aUkFh5sZWGhy35+3usISBwTQxL6H9+4WI?=
 =?iso-8859-1?Q?gRbZsStQ+OafyazrhlWpmuK4QvI77fiR68FMYq/DxZIpfc3o3XYJivMvrg?=
 =?iso-8859-1?Q?+YNjHYeH0jymECezvcFDkAnc3KLAAhT6aNZdD1MEDbSr3YaqrVl/bilyRs?=
 =?iso-8859-1?Q?NAz0qSEI5BDlcVcYxAIKAMLBxyC8bpu4X5zkL8UVFOl5bzce01hIUMiZ2m?=
 =?iso-8859-1?Q?8J5JEzGFv7sGGC8iEB/bJXNYpNkpBxotaLo6PxgmgzypFz+eZ/jW4uVaNC?=
 =?iso-8859-1?Q?LFD9d9eNF+bKZDAr3LaQ9FApT8BWPCcnNNrj6ba0iews3GHa7vUJkDapLu?=
 =?iso-8859-1?Q?qG5hPAROGWcziNR+QlEIM/rFC5q37d9jCoTyEP19ss1mqOH0Q9L1og8GNK?=
 =?iso-8859-1?Q?EFv57BQWmsj0KKRiR45KnAuNWkZyeZ3aGx0G9k2YOwAYNX8IlmGCz+jSqx?=
 =?iso-8859-1?Q?+4cABJDl1+TL1aVY4cuHnjEgHjsQ3LoIVEpw8gzjye1K1Uk/0MI2p+FcP+?=
 =?iso-8859-1?Q?6h4hdX+Di2SpnwBqLtXdm6BVi0Wbduxc5grgUuCwcqkq+k/3c4R2MpimPj?=
 =?iso-8859-1?Q?YSamjgfYkTq1Zm/t+rblrtQF5rhx7LOfIhTFPmltG8ofemCG6xJN2s5U3y?=
 =?iso-8859-1?Q?hn4bFdPQCF5B0O2LUqgfskw+FS/ABhxnpavYrjJDBx1/wjK+mrqCyhwlm3?=
 =?iso-8859-1?Q?oHKXrN74BoGKMr2oWoZK5RL+Rs/98s7WZMrAFx3R1+fA2TUM1E/GSq+1D5?=
 =?iso-8859-1?Q?E/edPlt/Jh+LiWwSnXkVP33b3gRjXCBLN+iQM91X4S9ySARdBv79lvl9Td?=
 =?iso-8859-1?Q?i46khwyVzjCZMxi5UxLFgHXmYnmgLte0kEydDoMiE1Mc7whmwQGAm5IqL3?=
 =?iso-8859-1?Q?AWtHmYnDMdCSgzD4LH0rUYy8zugHPNZfHpb+/O6yqvZYSyMGGf35uDo2XT?=
 =?iso-8859-1?Q?0PD0offBY1iv06dsBew3uTs/jURpIud7pmzb2o197A5NwuN6X2nLMZc7Jh?=
 =?iso-8859-1?Q?w6Cx114D3CC/o=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e19446-2eed-4e1d-c049-08de2b6fdac3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 15:40:54.4553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PfC6iCxu+FEVzSiHdHw8Xge3JtDpXA/bVlAVzL103LvTFEDEyEtWFzABhEfc6cP/XaDcCpeLNmQT5bYLIZaTLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4425

>>=A0=A0=A0=A0=A0=A0 scoped_guard(rwsem_read, &nvdev->core_device.memory_lo=
ck)=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D vmf_insert_pfn(vmf->vma, v=
mf->address, pfn);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D vfio_pci_vmf_insert_pfn(vm=
f, pfn, order);=0A=
>>=0A=
>>=A0=A0=A0=A0=A0=A0 return ret;=0A=
>>=A0 }=0A=
>=0A=
> It may be worth considering replicating the dev_dbg from=0A=
> vfio_pci_mmap_huge_fault(), it's been very useful in validating that=0A=
> we're getting the huge PFNMAPs we expect.=A0 Thanks,=0A=
=0A=
Sure, will add the log message. Thanks!=0A=
=0A=
>=0A=
> Alex=0A=

