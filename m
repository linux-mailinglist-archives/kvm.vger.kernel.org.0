Return-Path: <kvm+bounces-54631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8B5B25894
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 02:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CE385A6E03
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C59136672;
	Thu, 14 Aug 2025 00:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CFH6v2XE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2042.outbound.protection.outlook.com [40.107.101.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA922566;
	Thu, 14 Aug 2025 00:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755132832; cv=fail; b=Qtg33WscRW2NHhJRRP6EyuTBIgRle2Ut+L3UiWqI3993cLJB6lkRp1HCPhYFvgvUsycxZuQlgoSRpj2WMsWRM9/zN+No1tC32F26U3qd9DHLwclczuiEDPkNvBlf//Mri9/YH/kfj3PFJyR+5m2nmoUxBQMSsk33RqleRl1DNco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755132832; c=relaxed/simple;
	bh=qIBqE2OQW21248zfo+VQw4Ntze5nF3fZrDadYH5BCGw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uJt9gQcKYQ67+g1+l++BBIuUClgxJ80vYe6zl8pSdSmykgYxkfWiu9m839jT4VHW2Fp0AxsCB+qE62/hczheZkVmskP01yx04mGbWamvrPUmR4IykXpEeUkKYfcPdCGRexyFFQEyMCsyFTkqijERLdikbTz3vwfqK9fU8ip2i88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CFH6v2XE; arc=fail smtp.client-ip=40.107.101.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o2Gihn/G2ieSKixUQx52UQBRBZh0tb9OhTy3ySWSFNQ3LPZsXVZe9xDNfj8LuPS/N3Iz390WL/zBOHC3DynTfqbP8fdHzrFvPNXU5PZ8YVTnYf2zBNqtg9J/ov6cEKqPAC7QbNlUERF8cWl9lpRPLv6WO8BNJomycOA4NIvcB3AXn6XT8czqDIznkqF/2h9dXU0G14tnm3g9a/xze4bvEGaUjDd5uZe4mp8PxJTgoxVklJzkyR5X/1O69pflBsYnXftFLThR2fc9A+QU8CEea3Gl2ondwcGLWpbFr00muDxdsLw9KChKZd/NAV20/cwxyEg8JU4lNVjnSsyxtrXX8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIBqE2OQW21248zfo+VQw4Ntze5nF3fZrDadYH5BCGw=;
 b=NT9JnSSUjXh8JMDOZdspk4sSuE/VQ5SsqaB2OyxRdgvHp3kmyWy7hOxdEFZCsdSFQEJ301XsaU57ij7VAZYPCITu0PihQfx5EDaJ2udKWfhghHekDgpYzmZPC+HpaI9pwLxYfGYnRh7QFNCiJxLfycQoUajsdWL0/8JdpAtO0SN1RFg5UkXVeZ2JMcXhacWSkRiqwJR9v7+sPGM9roxp0QtEL7aCgly1fappInGqesGc01KQXCwZdt6ldvahgFUVQ2oKNMAH0rveGN9YK1QcCRu1kDJT8KDoeNCSDe5wZ7qpHMdowsVHoDVqO9r2aUL5ZxgyGbfp8g3UfK5DJvIu0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIBqE2OQW21248zfo+VQw4Ntze5nF3fZrDadYH5BCGw=;
 b=CFH6v2XEJ8UTDdKLbXxh/U8X2rEBpiqlMksCxHjA4KORhuSNPTy56Cj3Mm4CfL/TTg+aDTUs1NT9crZm+AEoC72pzJP7CI7E2Zt8NIESKjevrTP/cGnokKNWJkijepoXXiff2IIQeSwpb3Z8EkGRvddboLsI1D431DhEc4uWg7ChIyhLf+dSVgpC/IOwbZkOx1JnIAIgS23SxJQeEUniS2uNmJuFLAjUZXeOYPZ30sBFTQs+axLIay1u0SUjsDDSv6ztrAAnehzZQKzUFpMo/uQtT4iYHG3r0pYbwB3WNK2fZ1Bxyg3RZm2OMGbJTUwCisMVjWdVle9MeXngo5Ppcg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by LV8PR12MB9357.namprd12.prod.outlook.com (2603:10b6:408:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.23; Thu, 14 Aug
 2025 00:53:46 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.9009.018; Thu, 14 Aug 2025
 00:53:46 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Janosch Frank <frankja@linux.ibm.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Documentation: kvm: Fix ordering
Thread-Topic: [PATCH] Documentation: kvm: Fix ordering
Thread-Index: AQHcDELwUBJO//pAfEy2cwOcNCofzrRhUKa4
Date: Thu, 14 Aug 2025 00:53:46 +0000
Message-ID:
 <SA1PR12MB7199639D5F04180454F63D66B035A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250813110937.527033-1-frankja@linux.ibm.com>
In-Reply-To: <20250813110937.527033-1-frankja@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|LV8PR12MB9357:EE_
x-ms-office365-filtering-correlation-id: f67e6123-d57f-4ff7-9c49-08dddacd0657
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ApQKEA8I142bixKFvR+b6fNPSA4KlsSUuWHLs2/lPVEDY8icXQrZY5M8Xv?=
 =?iso-8859-1?Q?h8QfgYSiTDDCcu4iRon5cRYsA5XtjiiNDXWYiZJBiiF2vgQ6KJ/AemLZxw?=
 =?iso-8859-1?Q?Y7+a+MYPATBERR3bZCcWUdCb1SSEbjIU+w4QaAI5ycjizI/kM6EZMLG0oq?=
 =?iso-8859-1?Q?a+kCH4lsWh29feh4nPRgcmSBAoitscJBCBjUpde5hujDeyjU465nWA6ZmC?=
 =?iso-8859-1?Q?kgnj/b5G/E6osWH7hCtLQt3+6hVG+eNAhNxgEKewv1VXfCbTVLeCsrcyGQ?=
 =?iso-8859-1?Q?ZWOOZ2JAVt+bNtopDSqJndQI1apxtmIBTYoArsCl1vslk5EY1cdVbWXqXl?=
 =?iso-8859-1?Q?gthS0GuYIdow51tWv0hiLcVAOL6ChiKiFzpnHn+1Byddtyb+khVU8c416g?=
 =?iso-8859-1?Q?Hhpzb3KjpGJAuyIwBq4Qkf7B2gWNTgQnq+8GsUZi8ylAUsretxgpQbQ9eG?=
 =?iso-8859-1?Q?lQk3edKl4BNZ+5grDg4jqhbTVHxBSjLcUf95ait/gSlp0V2GdkzahowvbU?=
 =?iso-8859-1?Q?SPjcB2tHsN6raXwkkrPmU1zeBA2WN7+ZQyX2fGGobYOXAJmXXPARMY1iSY?=
 =?iso-8859-1?Q?02/8Q70zm/D5tL1ytise9Ceoi0UvZYSLiPanZ2LdBSB/y3GSQFTAkhV879?=
 =?iso-8859-1?Q?gXQVnWzYEAE7wbUtEcv2WSnK6LBLsmGTv98wVk/j3nVRpSfPx1jV3GRoyH?=
 =?iso-8859-1?Q?pRiRjk0yKUv/C0JpFIxJTlj9c2I8TUb1/QPBeVBBqRi8K2k1W0PAopDLTa?=
 =?iso-8859-1?Q?GdRaswLeLcZlwhV9wHK8DVIFlD1lXvmxqqbN93KSjMGNyqbXXBHn1NBitd?=
 =?iso-8859-1?Q?wWu2AnSx5ZtrlrhmpiIUjXNdQZ0OG88EUiFiqWbQ2lBz/kluQqR1BnVNt8?=
 =?iso-8859-1?Q?tDj0Lbnf46AfVrfZ1S2aEKxZVWurWMXaTxUPCtalKqgVQMen8UoSb/iysa?=
 =?iso-8859-1?Q?tyg4Muqp6SUkW7mdYg8mVfsbmCdJHquYFzSRN8mgwHB8vbWp8mS0cpFCfJ?=
 =?iso-8859-1?Q?NF7iYOCiV1mshbYTaUQd94qKdylmvX/ifzO4rSn4dTK+ar0KyG0qetx6wy?=
 =?iso-8859-1?Q?OwVaxVAjcROWV5OO3Z+5rDlHk0iroDCfPhZql25hpHqWtLL69kVCzlTQpM?=
 =?iso-8859-1?Q?PJQwXGVPafQ/LJv7fY8vxzQ02BZy4BEnpu6iwgXhWncIdEqpZYoen/t7va?=
 =?iso-8859-1?Q?hvET26AOBmGd5B5Cy90wzQYJb+w1HNXeZ1tE5/uHCv0tmgw8Sht0+JEB1s?=
 =?iso-8859-1?Q?7bwa/jGEpQXbOFGN68cApbtxcTclmhGIrdpUMeGnDtY4H7Re6nmLVTmgib?=
 =?iso-8859-1?Q?UAmUszWIywo6l/BbNr/+0gpeY2C5A+U/BEFBgka+3RMlKCFRY3owwnWFE3?=
 =?iso-8859-1?Q?mtGw3Ob9EaHkVFDYlYazxrFYjZSMoEZWPLTyJbE7W+KXL5Gq5U4KwA+Mjm?=
 =?iso-8859-1?Q?Q9obnP8huT/CyMYYtNlFaxCJLxyK/3KVJqjd7pLKmDp5BFF40t8ljd+cLD?=
 =?iso-8859-1?Q?vS0EE27gEY4WVi17jx8qQe2S8+ZQg4uopUES9jFAIT9qvY0oNjNeWJiI/V?=
 =?iso-8859-1?Q?q5STuyU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?teAuvfW1dYfd9qogPKC4UATOy61OPm2P8EVveKyL45VhKYK5cRW8joSqMz?=
 =?iso-8859-1?Q?kiTOai/iWYNPLxYP1JL4Z53n2josrT3n2ylFK7A/2hHw6Vxfo2Sq3U5pcW?=
 =?iso-8859-1?Q?Ey6zUMty3fIq/9fYd6NlLi8VZwhv34hk6+VzX4HOJOsUTV4hFJYRtDznHi?=
 =?iso-8859-1?Q?0rieEGcs7t3qU9B1WNP8K85kulUTXBUd/sofyX/VkzqRYMEtXHRfY6yZzC?=
 =?iso-8859-1?Q?S/YgGbiAbGlB3KoS0WTOv0cQVuUQwAcR13srs7lHiSlgAmY2howoQ3/8iP?=
 =?iso-8859-1?Q?0oU6rhPpfdo6XhA9G2o0jNBi4bMgOOq3HxZR0vqCXjCfRVNmy4ctJx8qn7?=
 =?iso-8859-1?Q?M5NxIwTLx7XjQI8emz5r69lKhyiA39m64ASMIlDQ49gvMIooVqa2KkH5Mh?=
 =?iso-8859-1?Q?sqgQ9Migr75o5hTdr6Oo3EzAbVlzGGe1irWn3MYXZVT0uky6A4q3Ij2vWF?=
 =?iso-8859-1?Q?7j/p7vaDQqAh/wkrUdFD6C3BSzkgyWptq1MkImULBawpVPA0xFayPepjpd?=
 =?iso-8859-1?Q?o6xL7w7l2Y2dKq5dr7iyz/XfFMbPfvvem6IATj/00/VYBaepbAJN4nWjs3?=
 =?iso-8859-1?Q?IGlLxVa7UFSVG892OmvsUf1VIUCxB8Mst6G2nZO+ZMftZgIHtU5lUNisY6?=
 =?iso-8859-1?Q?iJ/RHwfb7/4YWSR4SnK3TpStZFw3MCM85rIH7PiDzngjRmYSk1IIfl8LAf?=
 =?iso-8859-1?Q?KVoOpevwvQ7/VpjE2gsfKXNNzBTpx8Yex1usQ1jKTaG7R0bWTvDMmikdFz?=
 =?iso-8859-1?Q?hrAA7KrVehvNFh4acUTmeJmnM7iT05wPIQ18Jhl6Lvp2S2CTBnaT/H3a9/?=
 =?iso-8859-1?Q?hOhdRwHBo9K4vP9YB2RDuGEssM3G/4s3Dl4l3Yj1m97jUu3KYXfHO6Hq9j?=
 =?iso-8859-1?Q?wgoT2GEposVlWvXQl/1kDsUftyHWGCsl6+vuo0H0VUefscTPwAts31T0LZ?=
 =?iso-8859-1?Q?x1eOFaqFb2PYZiq9SedT/QbmZYlm8idhdf9M7o+cTX4AafHHrEyajOv14+?=
 =?iso-8859-1?Q?JNnn8Re6dQ0/xvZeKSG2XJ16p9HxaF4KoOkkkxzob/57t3BoDQeJCSz9KS?=
 =?iso-8859-1?Q?tPp9Z1dgp9uUriAxs9N/T0HURKLRBcBnZd5c3m6Wazc0RvVa13MdPQyS8M?=
 =?iso-8859-1?Q?No8s9+lpH0sWmmdBnbVhjdPd0uiTvYGC0fLr5ipvAWf0tqP7/3RkN2gxu1?=
 =?iso-8859-1?Q?Y4zzWwkgayAW+SUo3V83FhUxJ+Y4aqNfIKqVWhSsw3JVDTkqB+91exUWqa?=
 =?iso-8859-1?Q?S/Eu88zhhe7xBC92HpfZzUsBQ/pxAk0gzerCbmxCO4mu0suEw6pf67HS4G?=
 =?iso-8859-1?Q?O6Kz3VyadZOs1K9TLXhjKYLwbLNISRH29K65GMjH89A7NI91XmoKAxHKS7?=
 =?iso-8859-1?Q?oC/nNdZENuhLwHXHvpzkHsCtWUZp63rFRa3ujtbsnvTGTxSicCazqapZYc?=
 =?iso-8859-1?Q?v/q/s7dzoP+VyRdGrEEn7BiOZegM+PAmmWDqV+3kFK3OuVHaLEaz2FhfW+?=
 =?iso-8859-1?Q?RgxpwYqjYaNC6nCVGTGG919+2xVhmZhDR4lX7io3IwA56dZ/hSyNHeUwd8?=
 =?iso-8859-1?Q?n9GD2DXjENGqWUZ3FVSmWrgE3w0/T7R+oeRCSNUs5RQYGeKXJFKJ973n+N?=
 =?iso-8859-1?Q?afMBazr0Vx1bY=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f67e6123-d57f-4ff7-9c49-08dddacd0657
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 00:53:46.5446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7CMF2C74fcl8UNI9XLQWZspDX2cxfjQTEg9RwKfSAxA1qZ0pJM2jxKqh7Cib2iWT89eW0FiTyQk2r4hetVrumw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9357

Hi Janosch for fixing this.=0A=
=0A=
> 7.43 has been assigned twice, make=0A=
> KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 7.44.=0A=
>=0A=
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>=0A=
>=0A=
> Fixes: f55ce5a6cd33 ("KVM: arm64: Expose new KVM cap for cacheable PFNMAP=
")=0A=
=0A=
Reviewed-by: Ankit Agrawal <ankita@nvidia.com>=0A=
=0A=
Thanks=0A=
Ankit Agrawal=

