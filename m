Return-Path: <kvm+bounces-64640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D5546C891B1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:51:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9DA774E4740
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02EE331E11F;
	Wed, 26 Nov 2025 09:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WlDfESIA"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010051.outbound.protection.outlook.com [52.101.85.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EE9271476;
	Wed, 26 Nov 2025 09:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764150594; cv=fail; b=PpgZ/ZOEibe0Es/+1t5UH0e5fmn4JDGKMgbq3dxKBDHAl/NE3gXGTHgyUOHiBKaqciTBtHNFv5W6UD0r/a+EMKUnYrZOICg2J8VedEW56TsBwtGMMwHshW32zXQk11j4x/jXzoxseoOjsLncysh+mlxS4qyE2b5uUPvObPsXaLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764150594; c=relaxed/simple;
	bh=s4HJoF1XGTvhOX8/x5ufQjUE7uf0gwW+ohDn4CeXFcw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LLTxNvlNHz7f/5mwOzJpKSoJFyvAwUg14eXP5+vfWL4/41maYMx8K4yajgXpKFAMgqrWXHAgLHzQaxjLcbd7ylnYYaxhRWvs8t1Q2D3M+S+aQTNGu5GpDDoxHobvPCF3pWdpe9ywkaIJ3db3oVw23tDPVZx8pWujcvD89Dn0a0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WlDfESIA; arc=fail smtp.client-ip=52.101.85.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D4xkv90jWMuXgVOwHCCZAqtYEMMtpLO5w/y57HwL9dg5SmGAKG0238N1zm/Asg4D1DUkHbAj0qshneq62lDZ6Xx78vnCTgXgllhbiblAGxA0Ex9NoZ/4NLLwN9Q4GkXbE//cJZb8aBPhqVmVS0oV8gE1SkLjFSLsJ725G9UGlUjuW0oKM8yKa05/gZoCPX2pyQcGOH8fzZ8njS++h9zpwZfgD8Ccfh7D19soi7lvwAN07Qdl5/YkV+F9+OaBKpZ8ACSo22Ivzo175uM+wc4cbcz14af5rIcYFW2q59tcHj2THuZjezH8gkS8hti2DomhK20W1qvhKluxMSzpJ7mo/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s4HJoF1XGTvhOX8/x5ufQjUE7uf0gwW+ohDn4CeXFcw=;
 b=IA2kxh0txR79ephKu9Zg92+zoLuiSs5l3XUkIhoanIAAX5E5u0EH+sC06mh2c5+mvVTMRSwtuIfezZq9T0hOefOMWmcr7XsT2mEdU2mP8yJTwEguPu02SfO0v3OV4zH9GdhwLI+Psaw0U/Xlu/JkoAPaUNMdihSvVL+nHl/HDmmMxzBW30bIIcZ7CDHjFa2+QfwCAG6OJalzNDiutbt0vTwy6mWkiv+9AYR7r2GCvRBGpJRK11H9yxyYzbwM30K0r8ygrnBJ2PTqJf0jWQBUnGJ+6puS7jqWEvesxNoSUdnz6lKGJ5igHyQ9zQ6goL9eIjcofN6RwMgqZPO21z/3Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4HJoF1XGTvhOX8/x5ufQjUE7uf0gwW+ohDn4CeXFcw=;
 b=WlDfESIAJmikND63mEahRcfF4rfWiyTphyu+FoUCvv6ET/GH7n/0LuHvnuBHxEtPCcHYttJCEAC8v+VAQbFMEMqhr7MHrQinVcUDhvaCxVkvXDSzn7nc+DWhERJWkWFVMPNh+f9kAs057FdJK7NBXKVTAJ2x063fyvCRESzt8R/AozSYiun3hvTfX3jKLxM8Bo8Brlf7jF00u2s715nboMhoJE5j8l2vc1G+0B4BUh6hi8cVNHym8hpYJbD7NosfW4wM8h2kWzhbC1L4VB2rN+2/aFTbf0i5q9r0NcDX7/XE+LrQ4LDmoYiRr3dbH9HF3zY3Tw1nX5mgb09A+/OuUw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MW4PR12MB7262.namprd12.prod.outlook.com (2603:10b6:303:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Wed, 26 Nov
 2025 09:49:50 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 09:49:49 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Shameer Kolothum <skolothumtho@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>, Aniket Agashe
	<aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>
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
Subject: Re: [PATCH v7 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Thread-Topic: [PATCH v7 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be
 ready
Thread-Index: AQHcXpVDEfjVsugWtkOUqJfHCfefZ7UEqdmAgAAL7Q0=
Date: Wed, 26 Nov 2025 09:49:49 +0000
Message-ID:
 <SA1PR12MB7199DBC4470892FAFE797C1BB0DEA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
 <20251126052627.43335-7-ankita@nvidia.com>
 <CH3PR12MB7548D2FCEE9A3FA1F4210BDEABDEA@CH3PR12MB7548.namprd12.prod.outlook.com>
In-Reply-To:
 <CH3PR12MB7548D2FCEE9A3FA1F4210BDEABDEA@CH3PR12MB7548.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MW4PR12MB7262:EE_
x-ms-office365-filtering-correlation-id: e68cd8cb-7df2-4605-407d-08de2cd123ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?W+r4ZVP1dcEmuwuSEZu9ecPZIik7+/TkZVgjYVAq3WTdoIQALba+MMteDo?=
 =?iso-8859-1?Q?VoaOzlQ725mBkg6emqwRgYpG+R4wdZz0kBY02YEt8r0MkU1TYSc3iSqbwa?=
 =?iso-8859-1?Q?NjWqlYk35enZBHeOAcyoIAgCPSo4+Lu/Po96iY6ids9hkUVPWqnNIFrvj5?=
 =?iso-8859-1?Q?aDyXPwtrLf9r1aGMC97qHxYHj78lWhz6EOQuwYu97xS+iXzNJUfPwfc6At?=
 =?iso-8859-1?Q?L67UImiKT15zhn+xmYod/ABh4q8Yl1VLATTkFSlwB4A5V3uADvU5z0K9Mp?=
 =?iso-8859-1?Q?uTy/MlqRk1n7+faH+PO4gHo3Sra22+SWcxranpNs6Acz8nm0MOlrXx3Rni?=
 =?iso-8859-1?Q?YTNBMkQHIvwho5abOFVD4TaeCu4XRiXuB1bu6c4/XfqykhOT3Gt8LPvYqw?=
 =?iso-8859-1?Q?tRVWXPulUjscWEdrf6G3Hg891V5BL46G5HvbOpHgxgYi/PQBZYgG2xqD4B?=
 =?iso-8859-1?Q?7wjBF/hcyfEyuwweKOJgmh5y/zIIb47bFGeWPROEhgAtqEjwoFKawP97IH?=
 =?iso-8859-1?Q?hVCtYn4ojhhQGx/l8jABf5vGlGyQrtLwKhphAAwQOO9aWJdzzlBp2yjVeN?=
 =?iso-8859-1?Q?sKgc3t76G+vHoclArhsKQuxU57PhD6wALuCmCM6Txxg1FS4W1j/S5pkaKY?=
 =?iso-8859-1?Q?GDgMalpoeRbBFiB6pHhtQm8yrH2/mMOx5bazHXKYd90AlrmpSyzAWFBSHw?=
 =?iso-8859-1?Q?q0OhN/nT3p0w0x615pK9z48Z5SaaSPF6zrz99VKbDCLLC5J4UdfO2hbyWC?=
 =?iso-8859-1?Q?8FODli8uDn3o4ur7RBisUie4DCaQeARqz2KzaGKlsggt3Br5jOmp7cUMF/?=
 =?iso-8859-1?Q?IyOIBZ0ZEhuvToC3xjHtBJ0dqrsMJcd6tRo8jfU8rblY4EWRB/lt0wGFpa?=
 =?iso-8859-1?Q?dTBSdlQH6YOLNLXUlsLe/GB1npD+v0j1kYaI2/6OOn7n6Q6RRR8hDm/S/o?=
 =?iso-8859-1?Q?42ohqwYsNz9YaUFzXOUqO6XC+j3XBJthE0NEzICGvrkKmROxhRdzAzFLi5?=
 =?iso-8859-1?Q?2l+/tLBtPCaFM4IwnTQvvab5y8bMJ0FRN/0+FUSzg3h0bZ+eXcfHr0It4O?=
 =?iso-8859-1?Q?4LVCR1owtvryNJFpQJ6CsTgOC9PMW10g6Um9qH3amlyHBWkGNxzkkwzOIN?=
 =?iso-8859-1?Q?6EJKS1EQMSI5hH7W3NvgCgdXp8ZYIEkk4HXQoyuvvPoguwtBead2kgaVf3?=
 =?iso-8859-1?Q?hrwampuKibrK/qXemaHWTH5nOEePCh0Lypr8n9pqYM7hJnOYhcRXmAnJ8Y?=
 =?iso-8859-1?Q?hv0u0WkdgxwTclzjdaNq/d4AodJnDwUF2Z3WkJHphY1jPDotqNcV3jjevl?=
 =?iso-8859-1?Q?NqvY04YWA1Td3GyaZmDDULko5HPnAFSr603dDpI0K6kJ2D5eFcGy4ajSKy?=
 =?iso-8859-1?Q?y5YEZMv4Ysp/n+Pzmh8tCp5734FiXRLyIElrjbBLKNFHBt2ppyllJYiQJV?=
 =?iso-8859-1?Q?YVsHUXqB0DVvc6SXyCoJPMUZi46MuZtg7WBeI2U2YuHlPQhWDAyEDwKEM/?=
 =?iso-8859-1?Q?KPh9G6C4h0rdNXGUzhhNvjOcgaCBVinN7nQd4nxjee1ByKxn0dHMINLk8i?=
 =?iso-8859-1?Q?E2x/nQoeUJKC8A4C6ai1dHlATQji?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?xshzHBghQoVzOoNc6OTOf/M/KmET1wogNHoRT0sWLTTxhp/GgFbcemOam1?=
 =?iso-8859-1?Q?xL/7rFqTuwDeO/vTyos+/RRaea/c8CT0Y3uax0pTnmqOJUKYs8OLWl7LSB?=
 =?iso-8859-1?Q?BgEexKMdorcjjxcmvVGqfSp/uTqS1mkA7WaAaXz2Cj9T6aXvBTK6vJtoMC?=
 =?iso-8859-1?Q?dsLxCj7XWb0j3wLxtEtbXYTaVfSZYIpWizLV7At4vypP2HODqwmo9DWe1k?=
 =?iso-8859-1?Q?OZ8iD0q/+4OLE797smeMuNJTHEdBf8XofCxwVwQoyX4oLp1mIOGxMhtMuU?=
 =?iso-8859-1?Q?T8b4+Xau3jNFkAK4fcRbd31lU8clZ7l9m5KdxCSkS3L5YEJsqfbwiUk5+m?=
 =?iso-8859-1?Q?F2RzbVptfzlkGSMhh9HpXI/N747nHNLiKPTF7cnU88wI5Pstd3sfmMU1Bl?=
 =?iso-8859-1?Q?MkvRL7tS63xa5izjsRm964VwFZSqhBAQSOnW8EIhIO2CiMveM28ifbwapS?=
 =?iso-8859-1?Q?pASeuTkfy9AB0b1WZhaEQnRPrfWiFQPXt4ndvqXUulwMcJbSXwajS2aaJ/?=
 =?iso-8859-1?Q?k4JZwePU8UFx1ZGO6vpxrP8fK7fSy82z5UHykOSQbq3dyuncYxbwp/mzoN?=
 =?iso-8859-1?Q?8iF5GbCejH2lqOE/xz7phW8ug8+WNTIf9+tTDTTWPzOPGQjVuRVCD9IvXh?=
 =?iso-8859-1?Q?WSLg7iU6cB2cSuQoBF3MOBbxjF4Vu8QSEUD/5YtKevvF9S9yvpfggYY0LG?=
 =?iso-8859-1?Q?Sf5wtAgIVhUWpq1Yqv5UJnKHNgy2WMIsmaJNK9w6TP/Ltatz5RQuH+Y2Xp?=
 =?iso-8859-1?Q?+ReE4DgZ7LRhKw7VTaeMjgnFfSpjpW6OklzzylRLflmv1rlzcMtp9E4N97?=
 =?iso-8859-1?Q?V8AY+YOyfpkK4AyPHv9RlBLgaLzhY9nFaF4XWXMPwQpW8qCQXzBILMtC4i?=
 =?iso-8859-1?Q?6wrSSe0+UXsNY/YHSr5cZjbCLCAFf+PR6ZFonigUovx1vpG+nZ0bdiirHN?=
 =?iso-8859-1?Q?mCTKzEq/mb6ZQxPlUjpIxqaV3w7Ld53QiwKPhQQwQ1N6MEYn755vL0r/5y?=
 =?iso-8859-1?Q?gizCqElBo1eNI+DIUv9MMc+uBNVPhH+RW6shgwtTBRPQnEW1Y2YgAJw+vn?=
 =?iso-8859-1?Q?feH1ELruITMJXFVj0hqss/1ryerUlsWiSLYWrg/dJlrik1mELs1Xjt2ly/?=
 =?iso-8859-1?Q?drKc7mtvhoBxRu4R4G9vv7PqAsJPDpEmEdypjz0WavglcSkggbOc8DNA+D?=
 =?iso-8859-1?Q?wHWjSIZGUyB6G7wST4haHhA3e9okRPc36RIRHMl2AoP9evnEhJQltPnvHj?=
 =?iso-8859-1?Q?Q8nJsdblUDmrP+ETFGmm0oXj3kDTvIsN/ZK+Y3j9DeNjTVEVXf8XwW1Y5C?=
 =?iso-8859-1?Q?hsXiHD71ogcwIsU7KVUaW5PhlgnDwlv2TTxF+O0UcXwsr2wK6hV/g/ZX6t?=
 =?iso-8859-1?Q?k1gwgwmERs161YuiGbC2hqv77tiexo1MBQ6f2o+piyWi4zCn8vSypXbGt4?=
 =?iso-8859-1?Q?pEU1i7oRcgmqK05tmn/B/u6Wr3fmkN/2GS0fBok0vnNjJZ7IISqU3i8Vow?=
 =?iso-8859-1?Q?kXqH99dsPM8gvTZp3VF/0ejS8SpM0c3BISyP0FLB8PbXyV/M/pCj+EEeJa?=
 =?iso-8859-1?Q?bhuHv9Fg8uxb94/Q+YsMSuTTjEIW/UsYvQ9QXmYCYsgymD5gphLgBP+BSi?=
 =?iso-8859-1?Q?2GThGPMCGd22s=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e68cd8cb-7df2-4605-407d-08de2cd123ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 09:49:49.5341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MHwmFITE62c0OtzoZldmEU8QtmbgpOeIeuJscs9TFiol9WVT/ANZVBdfy3YupftHKgI7ZRS2I2WVhAXMkqno3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7262

>> +=A0=A0=A0=A0 ret =3D vfio_pci_core_setup_barmap(vdev, 0);=0A=
>> +=A0=A0=A0=A0 if (ret)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
>=0A=
> Should make sure vfio_pci_core_disable() is called on err path above.=0A=
=0A=
Thanks Shameer for the review! Yeah, we should not have that if (ret)=0A=
check and let the flow fall to the vfio_pci_core_disable().=0A=
=0A=
> With that,=0A=
> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>=0A=
=0A=
=0A=
=0A=
=0A=
=0A=

