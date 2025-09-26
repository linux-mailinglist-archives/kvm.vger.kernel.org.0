Return-Path: <kvm+bounces-58840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D05BA2314
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 04:17:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09CEB2A2FD9
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 02:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79012258CE7;
	Fri, 26 Sep 2025 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Yi879SRt"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010023.outbound.protection.outlook.com [52.101.201.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C49043169;
	Fri, 26 Sep 2025 02:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758853023; cv=fail; b=dhA9Nqs+6zFNK5aGFddz3Hnhl/kJ11M2tX10y41IQsaNMFCx94DTRL5tEbkqIZ68/7qqurS/J1ZE9YKWnYsj+e72S0jWVna3O5GWBa+iEvUZE0ZFsQijPGfLy6WGsu2DqDHiFFtMCIB9wNpB1+x53j343CojZ/2ooGaoSxDxYaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758853023; c=relaxed/simple;
	bh=7ay8xvx6idxqckq9WM/QDGAMS5sUmkTg69v8LUU0Tj8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pbcOfO5FW2AftT+X13iwGga7Lb+/eETq1VNjROa/5CV7zgu//cDy43LWsHiQt6a9frLWNyQsUwN5H6Bdu3DSReeAgXfGD6F9EEYcARglxfUrmawZ+cFnvkoSsai1KI5z9l4hM0sPtTSTc73KhTj3sOtRdZ/xnMWLnXmeN5hBpY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Yi879SRt; arc=fail smtp.client-ip=52.101.201.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FuePbZ9cQ9FKngAoxht5cESWIowKtAOQN/mdSNgBr46hZNT7eS8XjxWAJFJChpFQpaaH9PWU6fjS6kc6/X/elCJy3qYAwC+imVa8DNDU2uUDCzLAe8iLONjk3Ex+aUEd3RrZ0kupo9kdyirxxUXSWLnmvqgfmpIkCqpm569kIjpbbfCrRHqrjooLXyVn4KiTeRo1Mm97RyXtO5AnxROocytfpnBJo4OHJdPKZ+6Zug0ZKcxTHIyQ/+SdmaDSldWeUaQ2MFPQIuT2jza2ZponWo/aymKpJHBh/kUz3XHGL1m4W8OwIqXetaTtMO3JBuq/7EFRgdRjs1BTSL/tBJBBmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ay8xvx6idxqckq9WM/QDGAMS5sUmkTg69v8LUU0Tj8=;
 b=D2BU8i2IW7sWPDDVrhjVlytz7Gj6PlNG2evHa6wPqr8EW9UHaXcNyomlbcaRdDIXDFHOQGbJ9MN2BZBlw6xvt8A1vhAGO9yZUCtwsnM21LLM1OS3d/KuP0cRDK97F68E4XfqVWk6MSMaGR4U6weA4XQhbNtzruEgf9akCkksh5NFfGoO7qQs9xs5EtuvTrwtwwAiUtfrG9j4adxj+QE1jiwLKZJjidpJvxHG+++DZp0+SxiKnXNgoGNIn9RwMbBfVP0dd01GGyVRffdenf2RAbcNTk+256BOWbxjqFKAWA7VB3/3L8HQuUTgbJ2AR91/cGvv03DV98g9j0RZSQmiWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ay8xvx6idxqckq9WM/QDGAMS5sUmkTg69v8LUU0Tj8=;
 b=Yi879SRtKTcHKDq+b/IYKNpPTmhb8KOc727R83nURKfHTjFprr0hoIskACfZr/DS6vZQKDUG+FnswzA0z0b8FLJjjcNq5kRHF3Zmt77zvvSVF+/jurPFTdn5+vTVi/7mLAtnhZcnqiwn9IuyP3cHyte/ZGe7+ZooawMMy9Jgg260vbKOuKtG2QgdUDh4skWxC5JoSEs6NQWOD6M8HzQLzhGsNLRTbfzXLH5PxFXZvq5E3F58KS90frebOuV30CgGrphEa/XJGF8EpwZ5chrEoJwC68I75wXzpB+WweA8n6owOAHSiNuy+tnTFYzf4gwY7VnsbYgihX0pHnJhHd85kw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB8145.namprd12.prod.outlook.com (2603:10b6:806:350::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 02:16:59 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 02:16:59 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Tushar Dave <tdave@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai
 Hadas <yishaih@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/nvgrace-gpu: Add GB300 SKU to the devid table
Thread-Topic: [PATCH] vfio/nvgrace-gpu: Add GB300 SKU to the devid table
Thread-Index: AQHcLj83xRZp9VD7/0iXiVedpMVe1bSkub+3
Date: Fri, 26 Sep 2025 02:16:59 +0000
Message-ID:
 <SA1PR12MB71990B7AA492087EB9373F45B01EA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250925170935.121587-1-tdave@nvidia.com>
In-Reply-To: <20250925170935.121587-1-tdave@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB8145:EE_
x-ms-office365-filtering-correlation-id: 41522468-4bbf-4bc9-a89e-08ddfca2c628
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?GlvNGYvERE8pUcHoGhuxkj/wf+vq8UFIxyzKXMTlylE5F/yoEjKphQhDvh?=
 =?iso-8859-1?Q?OfmlvrmraA5B3JeyrOwwV0cPR2CDTLa3T8HNyS87idngmD7qbHXG28Fwn8?=
 =?iso-8859-1?Q?WOo3Hrnqn9ySHcwqgN0mgDZ0L4gH7LMYvCVPJpAPkpkgqSikXedGhGf4DY?=
 =?iso-8859-1?Q?1XP2CfGZ09/0VBKER+Rw/XXwUu0rev79jtiBmKlJl972swM7HdSzsvxPsy?=
 =?iso-8859-1?Q?2BWNUsT2pdA5ZySg6y4oU7+SAWDqmp1Qez2+mVVCXwibFH/CrvVgYOjrrz?=
 =?iso-8859-1?Q?QNcPyr3baVKMda4swSv1YGspDDvPTHhu46gU8K5dnzQTDlpv77sWX6on4H?=
 =?iso-8859-1?Q?5VVq1hOK+mOVnbIbxSxJvRFb0KRJbZVWG3HvkWR1FmyB4W8timoNi8RBHl?=
 =?iso-8859-1?Q?L6DeFKUD3tdL0y/HeluaA6MWEUAjhyWG2XjMLS56YwVdMAya4zA8K8pOf6?=
 =?iso-8859-1?Q?lWExsFwefIJZJlpiAirlOy6Cjlpnc0MjZQXwAKQv6u6Pl2jVHp+M6wBwT2?=
 =?iso-8859-1?Q?hMgmUDdvCipOohZQOQ/TnCDCe6MLJ4hMZNZSlmnzP5wPuzdmWGHEHycxgE?=
 =?iso-8859-1?Q?lQms67CKusUkoG5TqUqoLK06ov3k1bc/ObEcqZ4lRdf1e76gHG48n/ybHx?=
 =?iso-8859-1?Q?dcRO80BKTPmj/TnS8H6b+NIaglgaVgm9k0dANg/vB1czPo5zsPTKTF9PGm?=
 =?iso-8859-1?Q?Udw+/v/z4FdGz5Z1b6bI/2+1eVM4KXQixthVJooYvvoAX8BIsV/eo9jPj7?=
 =?iso-8859-1?Q?dqEWDLFkrS0zGBTMqaV9oWUcK7W43svLUrarjanWIhTlohWDMcGeRC/uB6?=
 =?iso-8859-1?Q?JEKazn8hAPcmX80z0cRwNxPCK41v93pH3fVCflIE4fQMaHkPcc0sAVuFbw?=
 =?iso-8859-1?Q?nt9AtJtdNVq60R+HW7NbhkCETz00CtxSUUO0tct9oz7fyedcyY6KUrBBO3?=
 =?iso-8859-1?Q?BtXQCsF1dtZJTzkYxkndby0SN2mxUvaJi6B0/IY4k79oZ1a+b+LFPB5SW7?=
 =?iso-8859-1?Q?Z4KfGU5qmy2Tlql7XArVY5tBARhc6eiieyfguZw6oPU3fGFD/WdNYhWVyk?=
 =?iso-8859-1?Q?c97y6e9BlvNK0gIeEmn0u8c5oalFA+ki0QevxREzQ01sO6DEsHr0pvoN6c?=
 =?iso-8859-1?Q?6Uk/e0KucaDvMcWanGBpIspS1h2LKnSc8FyDY+wKXU2RDAeL5/WcMm7i+K?=
 =?iso-8859-1?Q?ZLmbSuEh7Yn4kP2oR705jpiUrKyHJ7bML86dLuT20Yxj+O1J2SdrJEaSHl?=
 =?iso-8859-1?Q?s2d8jn13ZFVQ7xI5B2KD7pg36v4f6P35xikFuF1WEtrT45g6aDOhLISbU+?=
 =?iso-8859-1?Q?SHix1C0i9e6tIGCHOWAR8goOqfFUs4PzLjTJxdV/nIqhxzafplfwf71Ugk?=
 =?iso-8859-1?Q?E9EMmZgquLbrR/SdKVcmH86HFueUpM7ap+s3h4X7WDtDk9XGt2IevJVQdU?=
 =?iso-8859-1?Q?kMROjyPFYGMLGA+WCeOlyG0RX178kdV5eGuyTQ2eWjkzD2iJxq6mF9aqlE?=
 =?iso-8859-1?Q?7wAeVyLlEnkaNvrVnR47bBGHaJdlPLFTp2945sElQt+bi3W78VsKjXzmqB?=
 =?iso-8859-1?Q?Oq6cSnM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?/yvka8z1yQ32HRBaseRNzHaUlJDINhD0G0Te3fwS0fOBAcfHUU4gmSGALX?=
 =?iso-8859-1?Q?I79q2sgThTU71BKoFQ6JPLxJm6/DjRkACA3rorzPDOYMGAC0Uav2Y6L0VA?=
 =?iso-8859-1?Q?e1XO3Rrz8KtdY1jAN5fLpAfBM8Ze53pjX52TpRmjoYIsERXDj+7eaPu9xX?=
 =?iso-8859-1?Q?EEVfDiuSxrvIiEjXRBbHpZdZtQKcDf9bw/U4XtjXdk/63nJ9SUwlQLeh1c?=
 =?iso-8859-1?Q?CWnLS7SnxRd0UTz1D2LN2hA8abpCyUwQofqSAMEUwgYlAx70M1k7ts2w54?=
 =?iso-8859-1?Q?a0xhUg6ocY8y2/FoL7HZEO45ql3m5rv4fGYoGFIy7TUIuSU9YQTz4JnW5t?=
 =?iso-8859-1?Q?lbqeYxOwpYSQ7QupTxJZfNxc7R+E2q2vhjKptBUePTmob0vYuxSSBIGx8Z?=
 =?iso-8859-1?Q?ZfhtOHjlm1HryEPA+Vw3NjSF2SJVVlQpL1UDBLIAcXAHxAqph/BLv0UtJt?=
 =?iso-8859-1?Q?WOs4Xzy/KqCafBsVHQkubZVmWmm2rtolAYH0IvUuY4gzOu9KAFTKgFN3aZ?=
 =?iso-8859-1?Q?cFKSYIxNPhjwwQVDXGZ+Y2V6WCvz2DOrWN0BvoJWu9rln7bBuh5rjVX+Nr?=
 =?iso-8859-1?Q?zqN1eh024KtC7Xlf8nr2HEsn8SjXe4+FO5M4d0YHYxDTvVL2MrUEYzRVFr?=
 =?iso-8859-1?Q?+bUQs2/6EEA7Rvwq82FHgQl9D5ifWuEX1p3QiKvphJGtyqBHkGYky0zBy9?=
 =?iso-8859-1?Q?i8Yq/8PnLNBWz+n7D+aYm255DaIrVTzWDdtOORG0JK0C2wXXuHfguuQMro?=
 =?iso-8859-1?Q?+uvel+7khMuudngdGK28KYjU1WJeJHjZUoPqfVLcOM/0sDw65OdS3YM9Mb?=
 =?iso-8859-1?Q?krWAXNa60O6PfUE76cO5nZ5ppcv/RaIcXa+prP7jEz067SZSFsBwxtFGsJ?=
 =?iso-8859-1?Q?JwJ/MTQcMmNqje38pQemQpda4RrsAWSUcSyLPM3vZeJOWdWPsVv/HCCcmS?=
 =?iso-8859-1?Q?VS+q6/8RKFOetNbuhp4/6bpyXzV2gMS08LZOnWXVjp7px3M25RKDoY1ejR?=
 =?iso-8859-1?Q?JyYpAns2w6nmNwfQP73bUn7+m/dNSxTM/karx2PJ/3ykis5IThGf3uVBM1?=
 =?iso-8859-1?Q?HU3U4dKSsmMk/cQrRJeE2zqCAGYITNW++73HAkz3Pdh33rmwVhBj12Bb4m?=
 =?iso-8859-1?Q?LdTh7BghXt31I1Mz8LIz/IcIQMNzSIzoP5iidCop+tmgkLlmZ4hZFDazUn?=
 =?iso-8859-1?Q?pYXkeghVtWorJx2+J1ZyO54va6HzUezUVI3H2+FZX+E+R6wIzH1R21G2OL?=
 =?iso-8859-1?Q?1kuGmdUQhTpqaOELSyrtpoDQjiOefx37GHnSmBDwrFcb51yczqDpC6k48R?=
 =?iso-8859-1?Q?mCPBXx/p29d3oa7XrfUGvoj/tIcXHf/GO6wL7IRiCBuq82p4yWekTLCwfh?=
 =?iso-8859-1?Q?vl3AZKf4DXRE079DrmUOYP41dVc+M60wsEsnEgSVurRF9CI/fw33oQrdxN?=
 =?iso-8859-1?Q?pzvwVNiIINGg1fW7RCxZKbBCPndqyTZdLh6GQ/yQVpq9e9kJBoI6Z834nx?=
 =?iso-8859-1?Q?b26ux13OHxwFM32hccnT97g6NJwN9zdGY5FziVLulHkhDSq7sASrBui+tL?=
 =?iso-8859-1?Q?EB99LIEbSrjoGlbT/6GrN7didUo/4KEGkV63ZhF77qaopBIu0jqDaRGPPK?=
 =?iso-8859-1?Q?ALwAZJiVnsGjk=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 41522468-4bbf-4bc9-a89e-08ddfca2c628
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 02:16:59.5627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8JrOKklLgc4KNQwe4+GdYPOLHn7dZIsigEm4L7qGbaRsP0Nk3VaqmhexOQ9nFVny8FtpB2cEb69tUTqz6fsHWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8145

>=A0=A0=A0=A0=A0=A0=A0=A0 /* GB200 SKU */=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0 { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_N=
VIDIA, 0x2941) },=0A=
>+=A0=A0=A0=A0=A0=A0 /* GB300 SKU */=0A=
>+=A0=A0=A0=A0=A0=A0 { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA=
, 0x31C2) },=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0 {}=0A=
>};=0A=
=0A=
Reviewed-by: Ankit Agrawal <ankita@nvidia.com>=0A=
=0A=
Thanks=

