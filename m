Return-Path: <kvm+bounces-45441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E206AA9B81
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83C737AD116
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A692B26FA5D;
	Mon,  5 May 2025 18:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xBuL/a9j"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7E326F473;
	Mon,  5 May 2025 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746469556; cv=fail; b=qyz0+CGzdyqNKQOeyXl0TKHUOQKvN4O8uW6IedSPEOCjYf4JronQS2UVm+DdvPZhM6PfT5UNaxt0BZsXmk0mdeHW3p27GJMu++4eNcmQrT/8gMyjM9lE640Ok48pes5YGoCJGHxoLmLhVdQXvV9fg3cA1d/6yJZ6A1hU74JlWtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746469556; c=relaxed/simple;
	bh=8/SCi3rxLgO0CXL4jPOR1sR50IPjMSRhDrXNtZEjN3Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s60rHjN8Cr7+yJVX32ZTafR/12K9KgSpuLMBHqfK6aWucpT4y8f7KrhU0K1kQTWJUp3gnWMc2cnvHER5m808/0t6vaURV1VNesrJBWens9hDR2Pzo8Owurvhph5cjpBZx/Yv4bngy4HXqYq11j/xsVAlcNh4OQ8l1GNAfd2a+os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xBuL/a9j; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MF/Ta4kgZMCeGgqw+p9FkXurle43y7sUN1mLzQjP/GE9bWItjbakGJMSud+QTHfpXKvt1xzqwhXpnWyyHSw/CpxAYEV07zUM4pvJKizWmS/dak/vJH7Sf4wBc4dlYlOU8CNCxaxzokyu0XcLQcYz1DARAb5JLs/IIi2Np7RglYOw1SsPvfVHhHgV7SX1IUmBTy1XrdXA6Y5cEBrZDcHA30jKgRnvqVLKidSxhNg1yKdZU+5CITVnAuUCF6T8BLRkMnV45n/liityKm9ej6PkGE4VOKGz48M/8rMvocOisBqkd1CukAA2AteD954sr6fh4Q/sTgtFf25IGHXIXhbCGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KqIs0ODgTHN9eolyCCasPHBeYIfO27J//wzvMYVqSOQ=;
 b=oKuxPIYRJiX5z+Hf2rgPzyEshWDUYdmW9+qAGT2dQRJyUvRU0r4ZbUKsugcmyj2oxtFiNccoqLDcuD8boZaOW7ab7ilET67Roi4GrQRqbkIdbHjxSJyjcZP2cTL2GgEsX+PBAFGgkcoHOkNTWxMMf7toRyMmxRJRRZVmfoUOR8Q4zZ0xjWz6duihEMv5z44wmDEh4isVmo4KYjCzjXCL0+mzmp5tpX8JLhQGmt4vd7ApNX7td/jcAbFqFb+VG2K6rUUww9E2dNzh1EwSZg4nRt4X7ZVQ4o/yBDs1XMvL0LUyAMiqZYCSSPoVf51fHb2V/qyeWZBrOU4Gu36iHMeQFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqIs0ODgTHN9eolyCCasPHBeYIfO27J//wzvMYVqSOQ=;
 b=xBuL/a9j7KUSF1u/3daV2Ml0ZfyKj5Ose92wmwYKteYT8v2ndEfByoQVbF52/JgddQ4MjGUhR1Bh0QsJQcwuboi3ojFZJ4U8Us1M6wOXF7WursaugoGAxMOgOs+RvCgNRRHb+gP0Tv1VCsZjbBSMuImb80Q2aJQw078lBVph6EE=
Received: from LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14)
 by DM6PR12MB4156.namprd12.prod.outlook.com (2603:10b6:5:218::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Mon, 5 May
 2025 18:25:52 +0000
Received: from LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427]) by LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427%3]) with mapi id 15.20.8699.024; Mon, 5 May 2025
 18:25:52 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Borislav Petkov <bp@alien8.de>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Patrick Bellasi <derkling@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>, Michael Larabel
	<Michael@michaellarabel.com>
Subject: RE: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Thread-Topic: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Thread-Index:
 AQHbuQpLRWo4+2NoWUeyEAzbBBOhObO83m2AgACS9QCAAJCSAIAGL9mAgAADC3CAAA79gIAAAeYggAAYUwCAAAXbEA==
Date: Mon, 5 May 2025 18:25:52 +0000
Message-ID:
 <LV3PR12MB92653D1BFFBFF2FA2758A250948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
References: <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
 <aBKzPyqNTwogNLln@google.com>
 <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local>
 <aBOnzNCngyS_pQIW@google.com>
 <20250505152533.GHaBjYbcQCKqxh-Hzt@fat_crate.local>
 <LV3PR12MB9265E790428699931E58BE8D948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
 <aBjnjaK0wqnQBz8M@google.com>
 <LV3PR12MB9265029582484A4BC7B6FA7B948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
 <aBj9jKhvqB9ZNoP6@google.com>
In-Reply-To: <aBj9jKhvqB9ZNoP6@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=a013d0fb-2571-41b2-8d32-d7fe7a744ed1;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-05-05T18:24:53Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9265:EE_|DM6PR12MB4156:EE_
x-ms-office365-filtering-correlation-id: f7eada16-89f7-43d2-89ef-08dd8c024457
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?4GcxIf6fTdvs4BvEmrXjm72+dnscAhzieJFC1BEYkqDxfNkVBDpIG6Kd+2YL?=
 =?us-ascii?Q?1T/KGLvWiD9LMRTaZFpPmN0QdGi7FPek8uDL51TSnL4fB8uxzq0q/4I2Ges3?=
 =?us-ascii?Q?6Qw3LfuBg5AeOEvAf+wdaXB51RGIHcadmzLU613HOuwumjWJxvflIwR4toKW?=
 =?us-ascii?Q?/JR/WhGaCODsZ6HlFA1kcx3sFnB3IXC+lDOLVL9doflDksjkPbTGKl5ooqpu?=
 =?us-ascii?Q?zQpgtjFDAXjaSx4XxlPVK1qRiMUtDKaqj4Mcb37qKY9C01CjGNqMP8lTdroL?=
 =?us-ascii?Q?/b5VQcnd1cmzU7HEzJahHPyJ2KyQZ1p12J25ejtAeH8MC+sMZa3BKuzlAhCB?=
 =?us-ascii?Q?RfYiyB0bWdOnzbF8IwViVktH3SckmyIudlg4JJE3/6qrdknq8Wb8sFwaRkmd?=
 =?us-ascii?Q?oDa8KXgKviSpbaUGJFwI7VvMnzVZz91kd0oncRBuxyZKqS4kBhvvEVr8YQDw?=
 =?us-ascii?Q?6q8S4gDii3g/vSrLzKfZ+6OnLfTzzA2+GLdutqONXRkFnWfp8CXOnxhZZbxg?=
 =?us-ascii?Q?gWllem3OifuhuY8WN+PKbApV29BL/T0hh4eKKvtL7+j1vnAgXtBfIZ2aQgPJ?=
 =?us-ascii?Q?yfvehDlN7wr63mO5z6yBt4aZDs6Hxk6WJ4q1JVcDmJV6XOfR6k9i0lLFM9RT?=
 =?us-ascii?Q?kJHutRQYwocSA8w15/KqArLtrWVCwo8jEEnVw5HIAOxvxcIxJg9Gxq0mNvCL?=
 =?us-ascii?Q?TCQQVPhJxBhNO7UEGaaTemk4yVnr+sKlqFIF1qgWZb0q7GltUqR6klnthEtu?=
 =?us-ascii?Q?ant2nqcwcNDRiziFTENSLuElHOfjLldBgyVf3DLCTv+aModFVP5h+mzqlJH9?=
 =?us-ascii?Q?w2uDSm41jT5IzuzzKlhPsBfBSJWo+5Bm0R8+OpRcxAs8gYq29OTEbVk09cGu?=
 =?us-ascii?Q?/w6uDQkfbwMuT0TN1+Zw9iSwvLmci+SFwozxlDQKfAw7uc39qt4/zsi29NrI?=
 =?us-ascii?Q?tZAXOtG1fs+Ye/TPqJXIhStv3pIu4wj8WWbmn763bRVnj+IfZ/iNoSQcoZfH?=
 =?us-ascii?Q?OIHE8nn7fADykgtRDvbUb9D2hc7btLYkEMs2bRxOLzjC1y8j41Dewv8+1MaQ?=
 =?us-ascii?Q?XJQgO2NBEpzKcrzTdJboFQpA/XCVOV+dtbrZWT0x5kqKWfMcvfBSNAns+ptB?=
 =?us-ascii?Q?7CE5/CX/81Z99ThymSnuu8wVuXihsh8K2YDofbRMaHrSmP5cwhCNMnz6zHgt?=
 =?us-ascii?Q?JYYiX3QSN7jAH6p4H+ylmR9UpuceTfN5LnFUQR3+lQjHW7EnFS7KkQHfBVFZ?=
 =?us-ascii?Q?rdGq06NO+83sISrauVSqoh51M7wz+YQGlBIZeHsmzuoOSHA4xJn2WVW3HVD6?=
 =?us-ascii?Q?tCxapVckQ4ZpqB2Irn2cuqvc49qYah60zv+A1re17EPESvxrQSJjyyNOeaHk?=
 =?us-ascii?Q?16QM4fZQgcM4C9byEvwsmWfSuElJZvP3/ZrJRNATcvVvs0iQ0RiRahNsmyXT?=
 =?us-ascii?Q?AnbucE34hMnLbi/MGM6df/Smu7wJgimH4FCeQwwR+lLIw51pT6jEsshnywEy?=
 =?us-ascii?Q?dl0gNVfMULdj35E=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?meF8Rc+aTyzt6dq5fun8gWi+lFx7oL4BZ5mgBr61CEVZrgP+kw/u0YiU0ODU?=
 =?us-ascii?Q?476x3I75IYmN/OTdRdLvyTwzhfZS4zEZz63YlzakQMr4ZaDb2+aTeVbdFiWT?=
 =?us-ascii?Q?dohidQQxIeSW8N0yQMYLeZDZ74i3xLgmtgp8735mSzALjNTt01ip/uLI3fUn?=
 =?us-ascii?Q?6fVCF5g8QhKP86F2529gMMCMqK8dSpAjLo2Kh/EWTXR22QpuUtmAeDeyXzv7?=
 =?us-ascii?Q?t8y/m48zWY8E/3MFrk2erqK5nNvH1Iu48392n0/C5jkUX1gxfgJpjCunbPi5?=
 =?us-ascii?Q?2bjx+G1UbTyi8YgDKivwLObl2zXltWxiocMLj5wT8KV2eoHvSAGomsKwf057?=
 =?us-ascii?Q?u3nreVFo8qe03JjNpHRL6Qsxk0y2Kl+m59NfnkBEQl1u2Q+vLjFLYuH+92sg?=
 =?us-ascii?Q?2VdDezoQeBjyLGqP1UanpHj/2Aw0tm8OFZyRH8tpIMGmylLC8CBNCWujhfSN?=
 =?us-ascii?Q?87Fee74vg9B/Juyhy4n0eYuS1ye5FhCJgfFa0jn7naXlDZRtvify3wW6xd05?=
 =?us-ascii?Q?ek3d5dXGJdP1vEWswX8/yvud+1y40sOHgcFeuKiPLZRRnSLksJzUiLQqBQHw?=
 =?us-ascii?Q?BGt15tAGGislQxFURcTgBwNsXFz4w9RwqnEABz4f3k487+/DqmnxfboW3pHA?=
 =?us-ascii?Q?+uBvvzL9MKhI2RvunEBL7fKG7dAryLtclOWzAcPOaGca+aXvuzp9iLVTnjjC?=
 =?us-ascii?Q?z10TaKkyYwH34Fd+ERQ2qVCV84MzztJ+HlTCwWw569+izAlpVy9DRZDU/e5Q?=
 =?us-ascii?Q?XncfPhJeLdwJRB3qGGp/6twFuAGehCI2t38wb+fTf81PIp1cUN45rY3qjJxz?=
 =?us-ascii?Q?Ufkhmdrj104MvMsWMcgZzKf+AHFKt9sAwx+1XupZEqy3iA2nIRv4OjOc3hKg?=
 =?us-ascii?Q?HRYSbIoCyPWoHY2SsWDv1Pjbms4b6I8XJ0sLlpH9avieL+eNnxmbg+oTezJb?=
 =?us-ascii?Q?23yAYvk1bHseoCXuIWmWvTmlnCjmr9Vsh9+tqYzMvX99EST4ICaI9JRCfKVm?=
 =?us-ascii?Q?48i2nLCi3pLuRg2FFGVA4YTJX9tEWCjkGRJ2UbtuERvCAhrFK/9ft6OLMSwk?=
 =?us-ascii?Q?su7IYqfIUdSIhx68kJjShXbxrM4y0tufKCh/w4a805yX4pV4wMzb+MhkezsA?=
 =?us-ascii?Q?wDGrW3LCKg1boM6EyMUoaDgWeqiO90pi+PoHWcjVSdVwJFb2+wJEPfvYLkJp?=
 =?us-ascii?Q?j+8s3tH4BkcBj3EdoOOEBXkcfxp8jhqAtGY3nWUch0L9V6MLeTBdES5gpjJ+?=
 =?us-ascii?Q?Jk3RbDudIb6PsMb3WxKXUrxsfUt9Ekxng6Q+AtOjBzeOV3td8PNRoRtXLRF2?=
 =?us-ascii?Q?K5wUZt9y+iXPk/uQR419Nj8BZoHjsWBZLrloypCaPSIcJwkSpA09g/CRmjaK?=
 =?us-ascii?Q?s5HneDWP6woF1kZQ93/qrHUtNT4wtlSeYgOwXCdXauQ65Jnx2UWg3U0zf/Rn?=
 =?us-ascii?Q?dm2LTc6CoFgjVctRmOBYXYiGJAXUER7HvB012I6nOwh2HZGhg5SNKB1TpqrY?=
 =?us-ascii?Q?zF7or67BQtfXH0OIyNu+iA5lSPe9CXEwQyJSHPvrkyjjBqp0RFmqjyCKVfkd?=
 =?us-ascii?Q?+b2PuKkcth1luf0Ny00=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7eada16-89f7-43d2-89ef-08dd8c024457
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2025 18:25:52.0774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bf2pA1tGubOS5epgob1aEndc5+XG/PsaiY4H2wNEys1duYYEYBJCNzxw2a0GqKzV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4156

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Monday, May 5, 2025 1:04 PM
> To: Kaplan, David <David.Kaplan@amd.com>
> Cc: Borislav Petkov <bp@alien8.de>; Yosry Ahmed <yosry.ahmed@linux.dev>;
> Patrick Bellasi <derkling@google.com>; Paolo Bonzini <pbonzini@redhat.com=
>;
> Josh Poimboeuf <jpoimboe@redhat.com>; Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com>; x86@kernel.org; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; Patrick Bellasi <derkling@matbug.net>; Bren=
dan
> Jackman <jackmanb@google.com>; Michael Larabel
> <Michael@michaellarabel.com>
> Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
>
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>
>
> On Mon, May 05, 2025, David Kaplan wrote:
> > > > Almost.  My thought was that kvm_run could do something like:
> > > >
> > > > If (!this_cpu_read(bp_spec_reduce_is_set)) {
> > > >    wrmsrl to set BP_SEC_REDUCE
> > > >    this_cpu_write(bp_spec_reduce_is_set, 1) }
> > > >
> > > > That ensures the bit is set for your core before VMRUN.  And as
> > > > noted below, you can clear the bit when the count drops to 0 but
> > > > that one is safe from race conditions.
> > >
> > > /facepalm
> > >
> > > I keep inverting the scenario in my head.  I'm so used to KVM
> > > needing to ensure it doesn't run with guest state that I keep
> > > forgetting that running with
> > > BP_SPEC_REDUCE=3D1 is fine, just a bit slower.
> > >
> > > With that in mind, the best blend of simplicity and performance is
> > > likely to hook
> > > svm_prepare_switch_to_guest() and svm_prepare_host_switch().
> > > switch_to_guest() is called when KVM is about to do VMRUN, and
> > > host_switch() is called when the vCPU is put, i.e. when the task is
> > > scheduled out or when KVM_RUN exits to userspace.
> > >
> > > The existing svm->guest_state_loaded guard avoids toggling the bit
> > > when KVM handles a VM-Exit and re-enters the guest.  The kernel may
> > > run a non-trivial amount of code with BP_SPEC_REDUCE, e.g. if #NPF
> > > triggers swap-in, an IRQ arrives while handling the exit, etc., but t=
hat's all fine
> from a security perspective.
> > >
> > > IIUC, per Boris[*] an IBPB is needed when toggling BP_SPEC_REDUCE
> > > on-
> > > demand:
> > >
> > >  : You want to IBPB before clearing the MSR as otherwise host kernel
> > > will be
> > >  : running with the mistrained gunk from the guest.
> > >
> > > [*]
> > > https://lore.kernel.org/all/20250217160728.GFZ7NewJHpMaWdiX2M@fat_cr
> > > ate.loc
> > > al
> > >
> > > Assuming that's the case...
> > >
> > > Compile-tested only.  If this looks/sounds sane, I'll test the
> > > mechanics and write a changelog.
> >
> > I'm having trouble following the patch...where do you clear the MSR bit=
?
>
> Gah, the rdmsrl() in svm_prepare_host_switch() should be a wrmsrl().
>
> > I thought a per-cpu "cache" of the MSR bit might be good to avoid
> > having to issue slow RDMSRs, if these paths are 'hot'.  I don't know
> > if that's the case or not.
>
> Oh, you were only proposing deferring setting BP_SPEC_REDUCE.  I like it.=
  That
> avoids setting BP_SPEC_REDUCE on CPUs that aren't running VMs, e.g.
> housekeeping CPUs, and makes it a heck of a lot easier to elide the lock =
on 1<=3D>N
> transitions.
>
> I posted v2 using that approach (when lore catches up):
>
> https://lore.kernel.org/all/20250505180300.973137-1-seanjc@google.com
>

LGTM.

Thanks --David Kaplan

