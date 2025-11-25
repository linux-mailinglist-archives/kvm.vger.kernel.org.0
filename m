Return-Path: <kvm+bounces-64454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5AAC8323D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 03:53:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A172034BD9B
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 02:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C751819F48D;
	Tue, 25 Nov 2025 02:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eepqeJY3"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013029.outbound.protection.outlook.com [40.93.196.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F7118DB2A;
	Tue, 25 Nov 2025 02:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764039196; cv=fail; b=URkC8OkrbICAhRT0f1HzaGE5mbPS3HMmYZgSKufR2E6DpjybaDqh7CBUMVLhAbXr/YpwKqPOhjvHVY20V0N9l9T2pws0j/MjHUZatIPYghFmlUyOdM02XRRDZ+LMQKeLbA1PbVHnZkI9wE/PaJBXEa6z8OVRxd9lhtf4ISIzGb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764039196; c=relaxed/simple;
	bh=ZFJ94miJ3lvUR0lWF8fNGTnUBDqG55ef1o8jkqiB4Gw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jYmRcenpGsGArAT9B+O7U8zzKkn1NN5OnxF3FDMDVJaDT5BzPLSk4iM0ptUvNMresOnlGlOeVuDAKaNaqrQQPwUwEHAbhTsGYKpfKg1mPkuNrulz7W7TVzD9XrDbNaEPeAjjXbDQjcFdHPbLJic2FtB8KZ/a8TkLP/dh42VtSdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eepqeJY3; arc=fail smtp.client-ip=40.93.196.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=npSM7z0ayXgBhOFgDkVrmrEnHTJfRXx2nf22SeLcPpi1izeqYmnhClMQpPbbokpdvf7A1vYSLjhzFay/UQoBYkjTBG43xwiLPmThzQrHlGvDN1SG0U0AujBv+o5ZDalW6ItOzb8AJf+QAQclwTMP+nMfBxxEG1zIeIZFTjicB0uYXsDNtXk5q6NrcYdA3udMxzjDR3igdgcBZGedM09tFUOYJDhWDlpRlCDj9pDLcvPmH9mNscNtMFKjO02cxHvOUYywtHuLA7T85SJiqmZ4PvHuK6KBMVCd1ayczGEEYjZSPjhxuJFgWe0tOdz+2zzzL4vB+MsClpRj/5EhLAjwMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFJ94miJ3lvUR0lWF8fNGTnUBDqG55ef1o8jkqiB4Gw=;
 b=DXnxaVOgB3vzNkaeSsHdc7MBfRpIM2rc4y+Xk7tsEMkAK82pQUWhQnH2DDd5z7/nX4Qud8eje16HQ3baOZ7a8seQHYm2RPl2Di1gQLhHImVK6oGfY4q1UJU1sCT2Rx0MBQeHgCgr03Z1XsRyzlkfLBJlgf51G7x2p5xaOeSQ6Jst6qH8Mv7rVkMU2oarVFwR7Yk+4Re+8xxUNFXwfULSIDmk8UZNyo+JE5SACRQnD6eOBqMJdEREpTtPvtXeYIv6hi1gobPUeqsBaA4SgIQOpWvDyWMECBZvHXNvef5lP9O+TIpSHjZaTDMHFwq9zN3ahvnvRQLYoP94J7z0E3aocQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFJ94miJ3lvUR0lWF8fNGTnUBDqG55ef1o8jkqiB4Gw=;
 b=eepqeJY3iqJkWoexbZI86t2oacg1wsRpW8RcuYsH6lvMi9ab2ODIbjNUnaUKmUs+Ale/jkJSaMgmjrsnPJbf6zfxG6LfsegZIuL2LmDU5XB8vF+KkkNn7+ryQNROaaTkiT7UHi5hd3gBUKwkpyxAIsVNKJOJODFxSctiqbPFderRhZnikdgNCjXI8p/us8gylnC9e6dH3cqTaGx1GTwA/nuomsFCR5PD/9mrw67DUEVVUckccqte5zMY4B7y6OdDxld4nPiMn5q8EiSfy/q3AQuBiwaZ5dKThFiwjJilEA8N8bOmJFbQQhMQnEpNLidyCVQ1ErkcQAMGrfyr5GIjjw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MN2PR12MB4256.namprd12.prod.outlook.com (2603:10b6:208:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 02:53:12 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9343.009; Tue, 25 Nov 2025
 02:53:12 +0000
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
Subject: Re: [PATCH v5 5/7] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Thread-Topic: [PATCH v5 5/7] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Thread-Index: AQHcXTnXSSxQebA9G02TVYJzeLcEIbUCJCAAgACM5wA=
Date: Tue, 25 Nov 2025 02:53:11 +0000
Message-ID:
 <SA1PR12MB71998B6D31AEC03DF7A8E6F6B0D1A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-6-ankita@nvidia.com>
 <CH3PR12MB75483B12E8BFFECDAEB9E3BAABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>
In-Reply-To:
 <CH3PR12MB75483B12E8BFFECDAEB9E3BAABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MN2PR12MB4256:EE_
x-ms-office365-filtering-correlation-id: d64e0b12-95d3-4874-951f-08de2bcdc5d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?E4/2iAGG++AhBcLw+TYTYSnZS05DvfViUAsLmRyLDAID4b44SIBDsehaIu?=
 =?iso-8859-1?Q?0L6++x7r8DgCKVEhw5meYQSZeMZnNXnYhEI1NsftIKSWI3b1Ca4g82CQJO?=
 =?iso-8859-1?Q?RCR/JYntba028p+8NlEVzmLb/ERP39loXZxtVNPRCagD/ibHtTgOErdUYg?=
 =?iso-8859-1?Q?jXLZ5xfdCiO3tswfBiDpJgyzm7cEUPACDpf33A5TfgKIoQ9PrDTw58J87K?=
 =?iso-8859-1?Q?Q/emv1YOeijyqtwSRM1lZJvGJUw0d1hkiESbjOX4JO/eiaS8oSX3LCXc7l?=
 =?iso-8859-1?Q?K41jYRQV/yjfbvu1GSLr2XS3obaBU2D85uFg/fhB8weeS267c/I5K0X28w?=
 =?iso-8859-1?Q?7dbwb76zDhu/PVf2pEFAWXjjlJARgp+uTvSFExoZf7tncwvJ5rYV4eAvWW?=
 =?iso-8859-1?Q?GqcbQ7jpW5QJ9sOwt35XQ6ZbPUU8ij4DtO131WR1F0UgPKSH44MvS/jjW7?=
 =?iso-8859-1?Q?kPvyO+lQ8yr/YmIizufmGpMFb2Gp/GIrSfD+du/e6xyJ1irpfow/lgrdRv?=
 =?iso-8859-1?Q?Hue6r/JTczk98bYl4r6GrQky4NyWR6Bk7Lmdwn06yiozcbhV4+4IfUEaUR?=
 =?iso-8859-1?Q?yBAuq0MDcKBJjO/wslG+izJB/xTcrPwXpl+tEbaKu1UTZvnDFB8ORPXIZ/?=
 =?iso-8859-1?Q?Si/jQ00ynCJ1dPP83uDGCi5Fkg+7O0a+D3qvBzIB7DpFnQId5mE6ECIN08?=
 =?iso-8859-1?Q?feJk+s4r1AAwnp9KsDBu9KKPEOr1aU0N3VT/YbgG1Z2D1KjzHa9PWiFNWF?=
 =?iso-8859-1?Q?OWxdnLXypV0QlwbNCYsoqLpzPTqjNYnqnr7AEkQKaCbCEwKomvow00PDqu?=
 =?iso-8859-1?Q?z1xWiGrs6+XHivFNzuhZZvFjQqTt74xfK6IwFMMFLajYHYOGdx93F2SpTO?=
 =?iso-8859-1?Q?ceuqxIiTLSyBboxgMgtOdo7iYVtxFq2IbdUpgKn56QSK5m/81rxCasRuJH?=
 =?iso-8859-1?Q?gHV0qDKtijiaQRGI+Fr2SxkdigTdLyEc9Jif5HYYRUJ6hZD62kGl6Eh1R+?=
 =?iso-8859-1?Q?Nd+Q/DCbgOLnr6/YRNLb3knPK1a9kmfN97TdLPeOIDl01KH8H0flA0Y1f3?=
 =?iso-8859-1?Q?V7/Px5Xd+EQZCgS1sDaiAI7eVnWyQX56vzUvUTQ8qQLmpaKkxGLy+1NgQY?=
 =?iso-8859-1?Q?MuTBSw4zMntIxu343XDJ8j+ZcqPsiX5idtpeRkmREJm2Yhni4atXWsnKYh?=
 =?iso-8859-1?Q?yDkZdnze5fVN21TGwp40j0EpcCU2PxqkMFWzspPleQDteIktcMuZ7iSUBg?=
 =?iso-8859-1?Q?OyLFpDFF9wYvbtoMdcwx8AyXjz2Ryc8WpYJU9SZNeZM4O/wE3ERt/aa7ks?=
 =?iso-8859-1?Q?CSNjcAdoH5tK+YCLVqnHCPhFyXvCZRyO4pDBedUb0tLGHkZwS3Vwl1C1yp?=
 =?iso-8859-1?Q?3XOPPhb1pegv5Bg8Fc0ikqizRyf2CMqIGepIr369DTQVqgzbZe6J/O8gih?=
 =?iso-8859-1?Q?RmDeOyucxIPYVO+qiaiVaDPVxHx529LV3zZL0XGPlpY9OabQBDCBz3nltA?=
 =?iso-8859-1?Q?vnaGgfVaJyCdWnJFkseaXngVtMvtzWwygwtDUPVDlSQmce2pwhUBiRK13N?=
 =?iso-8859-1?Q?VWngWCotnPJuw9AGDeVNp/4zL+iT?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?KzDV7Xgj+Ph3IkGjzADYzUCz/eYGQhMveiGwYo1IoI5vtSHFmhSWzWHI8J?=
 =?iso-8859-1?Q?UKHzLdInbxU/XsmmmWFquHs1g7puFk06NssVmeX+nRAAo645tHZP5xgyE5?=
 =?iso-8859-1?Q?scIyX8eD10Y/1xSfein6Cl5d5If1U0sDnoQ+cy3W+ITuwJzjVVVeFNvw3L?=
 =?iso-8859-1?Q?d08PORjIhx2+gE1NiDrsoscJ+gshmmDth+QM4dqTLpumdRldhfnE7Vou3u?=
 =?iso-8859-1?Q?Q7oUHyeDS+wws+oeuRNnKM2JkGgqUKmd0iZFMymcI05oYFReUbWFwCzDzc?=
 =?iso-8859-1?Q?xp8t+Hkue/usLtUXNdL4HuWh+k+6jfquMY4aws54+zU9kTE/SKKhUSLzyn?=
 =?iso-8859-1?Q?KapEF9OyWh/3y3WJvzTrefXf04Cb/sFP/YcYC8R61pTM4v0eTk2fdzBW+e?=
 =?iso-8859-1?Q?ctJjMKcJqMv/o6sFFuo3soQ6iDUA8g4V1bwfNZqARsFRhptladgJGy49lh?=
 =?iso-8859-1?Q?xiOAL3PoWOBr8H56sEKrhtJOd93mdmP7N/MuCsgVahWDyGx1JBciiXBu5I?=
 =?iso-8859-1?Q?Muh0CA4q3bJW9hyqIUW8r9hGDXmgtqdzf5eklcnr0WV1Qwe0PxxqI3pBJR?=
 =?iso-8859-1?Q?zMpYrwkIJDYkGTjGulhrVds2osYfOs6Ri1unrvTcV7Kf2TT4odm5R49Yqs?=
 =?iso-8859-1?Q?4wDnVHMrp2n2jZeq84bWh685zKEIymUzk5ayELYWgIye2FK7JT/Fg5UoYd?=
 =?iso-8859-1?Q?4TlvButN5qbIrhFznQPmB7xdRIw1QkVfIHsmOydEC9z/t10TSwm2Soopdo?=
 =?iso-8859-1?Q?9AaM/YBwntlfkCrFdkNLExXgxc5i3YV96N/sYcfVy/LkC/2rNSPANzKSZ9?=
 =?iso-8859-1?Q?rq2GqaRD4rYWqF4+hAfe5Zd5ZBsbXXto5fjPz8QblxRxmmv5x39oXQy1/D?=
 =?iso-8859-1?Q?Tdvzf5mBKKv5z5W5ywEW0EfIvxqoGCwQ367Uf7RCmxfZ/eYpT5Mb63RnMw?=
 =?iso-8859-1?Q?zP7SUICHx9sLNaamGq0GXSYANbseI+KycDw7Y0tWRogtstIcdRvzcpK0KK?=
 =?iso-8859-1?Q?qpkDZXyRSQ8OfUc0B8T50sFiSIg3uPy500iYYm7bSCGmIO2NmqyLdb2Qdo?=
 =?iso-8859-1?Q?Ovg3eMvk/LbhfMshRy0BNfhA2YCommpCRdoLKpUWAVNb+iF79Qro01mc/M?=
 =?iso-8859-1?Q?b/4PoO1G2ZoHjzcxGWB9M2WFCbRWqTeyDUTlBxsyZ2JhxduWjVAVAUcRAe?=
 =?iso-8859-1?Q?EFMHY7jL/YD02q314o4ENNhCSBs32Xoklu/nAFWhEpQsJ5sh89IafMIBu2?=
 =?iso-8859-1?Q?GjOFMuk3oYCYaVmSUOCqdk852KdVvA+M4lp0R3M1vhgqjdvYHszszt/1eU?=
 =?iso-8859-1?Q?JfZQ10pq5tXTd6IpCmedkPBx9tgUhjNktptizdztkP5Vq6DOSc8J++O1Jb?=
 =?iso-8859-1?Q?cYhXf8c7Ivmesjp6XQ1WGsyJ5LtOP37eZfDGre1qGaOy+VjoKH3G5k19yV?=
 =?iso-8859-1?Q?oslOFT3dnCsYVxKVWbzNDzhr9hM/F5yAaB4QwLsdJuiCBpJUkGLWdvUv8i?=
 =?iso-8859-1?Q?m6NLRZYYmLiiUa8ScC7ZtJbRkvQgDtpMVCFj0At90ZeFXpzIGVYBG1tkRu?=
 =?iso-8859-1?Q?MqxOq3ds5z3hYTwOfDDpDq4wNi5noD47dtIa4A4IoPqxHJeS6kwFJwzSWc?=
 =?iso-8859-1?Q?SAHDCAqv8XmCVs6KXaxBBgUteSxq5eyaiB?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d64e0b12-95d3-4874-951f-08de2bcdc5d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 02:53:12.0366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MfsMcM8y4X2tRVKMv++Z2WiVH7wg2OnbAJ8S8JF/j39nP3SPzbcGHTQ27JcD1CpwWvkCYYx8JZ11lO1PzXrK9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4256

Thanks Shameer for the reviewed-by.=0A=
=0A=
>> +=A0=A0=A0=A0 do {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((ioread32(io + C2C_LINK_BAR0_O=
FFSET) =3D=3D=0A=
>> STATUS_READY) &&=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (ioread32(io + HBM_TRA=
INING_BAR0_OFFSET) =3D=3D=0A=
>> STATUS_READY)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D 0;=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto ready=
_check_exit;=0A=
>=0A=
> You could return directly here and avoid that goto.=0A=
=0A=
Yeah, I have a bad habit of overusing goto. I'll update it to return.=

