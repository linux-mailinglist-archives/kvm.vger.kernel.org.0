Return-Path: <kvm+bounces-64650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC1DC898BF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 12:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F03F3A5E21
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 11:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48D5323406;
	Wed, 26 Nov 2025 11:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tKV2A404"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010047.outbound.protection.outlook.com [52.101.193.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B18A248F7C;
	Wed, 26 Nov 2025 11:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764156952; cv=fail; b=Cs/uE0v4R4OQ/Z+nWsHGCLLc36k6/rb83Alo9kIKbivOKaB5fuokg/uAijK/U0rhNlZDYH5+XNnpMwSCILrIOj6jt+B5OOP+i4heOA4lASfjwHy4xKUVm8ZJf5G/XCoVorBxMdZqsXb5RTgtWxqCH/g/R17/UnzFvwbxnfaHKgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764156952; c=relaxed/simple;
	bh=kek7SV7g2tSmrOcRIiqfXJTGDkbpP0v+YsJLIgcHY7Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rpB51ZXCdfjrMo/C9F9l3794r8w+l4lHueFxs/Uc+hfWFCsdWMumliQG5hosh4jTAW+ZvWF011+xNceBQ3J0ht6LohIGTk8IvsL5OumruN0GtshtHj+pbeoxy3xhoAuf8i0pydLgcW7tnEN1IbNfieXXmaW02NyuHuyDrDocilo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tKV2A404; arc=fail smtp.client-ip=52.101.193.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/Ouyzx7hbzrZTYh01jRrzVPTiHFk/3wR05d+aqhP0l0h26osQZg7uZIqqKM+Kcxk4hU/Wqu0qTajglBoEac5FFHFElTzdI2jJQKtQVSw7+SZUyZu5pS7BSrnzzhZYqNrb/v5EFs47EORDRDblMTp+d5qDD/EglNDfixvd2IzoyCqqsXwG6dv/p8yHmeabR46Sk56i8WHTYovyFNxGVXhe9cfjwgiWEigsqZAKddtftkUMxEvVb+zNuLznnq7EX27MUs7VEg+lL4fZpimQ8pi2o4tVsVTgAHgbcafXBOf/iDtOsF2hVIrolHL1us6r05hzjZa7zCCRVq/qCPg1YLuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuFmAgHM7RXGtZanx55HJqlKFsxJaFvISKuV0eRu0QM=;
 b=FIKfZfjAE85zd6zXivlv1WiwwRGTcS/+6l+W4NHvPwd032ry9kVDzyPTOgdeKtLx8j3vuGU8NPeLhHOAxVmyf+TnbqCt7tjIm9tBzp0gUoLNNn1gBHIan/TfuxKU8h1TMiT2THpB1+cWHTswVLBatNevSjs/WwWLSs8rA9RXdCbAIG8AzYo9em50dvcxYLJF2iONHv8mcYaKxK9oT/SBCwD0LSwOI/mTd79KjpRi3VaTURIBjeHE1BbQ0UiVLBqNaxofLozTsZZhktdmC9QKd7LpZpC20D03VbFcDoRm1iCMNqNy100TboR9t7utpRFfvUXusFtc9nv1Rvw0qxoUHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuFmAgHM7RXGtZanx55HJqlKFsxJaFvISKuV0eRu0QM=;
 b=tKV2A404I/C/o7BZxTYoqjN7XuN3q1JzeknRu9b6eWEs0jVTy2UmluHz45StBrmw4XgSqWy/tRY8V8fUEetai90AJEqZCCzZeJZbd/o+eOEsLkyYV5mwcgbNd+ELf0r3UsUjNpHyGZU32C4lcQArm5gocQmSxtucIiwXF+Txx/le6cvWYIgDDH2yYkxI5aBb+ySNX8qYhyj/d5kudJ6uejUWTHH0/SH/usK8pSsvkCscjCHiVK5Ve6YlvCBIMsDxbP/jtHqsOxN0HxPcOZALtwJ+wp8zPG8kSB4OxYEA3rwdWTwbE7ISwf2IZtkFTSY9NGUbwQ4eSeDBNFtJNsEWpA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by IA0PR12MB8302.namprd12.prod.outlook.com (2603:10b6:208:40f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 11:35:47 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 11:35:46 +0000
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
Thread-Index: AQHcXpVDEfjVsugWtkOUqJfHCfefZ7UEqdmAgAAL7Q2AABsGHg==
Date: Wed, 26 Nov 2025 11:35:46 +0000
Message-ID:
 <SA1PR12MB7199E99C9F02C744CFDD2339B0DEA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
 <20251126052627.43335-7-ankita@nvidia.com>
 <CH3PR12MB7548D2FCEE9A3FA1F4210BDEABDEA@CH3PR12MB7548.namprd12.prod.outlook.com>
 <SA1PR12MB7199DBC4470892FAFE797C1BB0DEA@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To:
 <SA1PR12MB7199DBC4470892FAFE797C1BB0DEA@SA1PR12MB7199.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|IA0PR12MB8302:EE_
x-ms-office365-filtering-correlation-id: 3a211837-de79-4e6f-26d5-08de2cdff125
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?05ZNU/l3tKjyp7FVOH6HfMX83dtY1tM4Pf7yoHjLW0UBxdUc6aUimw5kBP?=
 =?iso-8859-1?Q?ssOH1ePaZbG7NW/5IAbCL/y1ut6McN1Ffe7iUuM4m7tLg3JnyFxfT+ZSfR?=
 =?iso-8859-1?Q?e4JhqkguhF8iY1Nhqby7QERdQyk2xXkIR/f2QUIhkxLdOYQeh6XRWP4VwF?=
 =?iso-8859-1?Q?rNlmqzgnEOwYIus1ULFZCyZQXPkkOwtG8CycDOVStQeQtSp9m/sbYdOV6X?=
 =?iso-8859-1?Q?Y5VoWgbp88AUmJh57Z2UzWjl3ymY78dVYLB0tm9q7UZLPAUarEHPgu374j?=
 =?iso-8859-1?Q?SZgBk1a5x9K8ua7a/CcYNJQHT1VDuLXcRn9OkrGQmF5/1AyqBWF1xFGRSn?=
 =?iso-8859-1?Q?kEIuuajPEKy6RahFWCz2/SBqmrKrw1O61rseJwxJQs1qgInMpIKJauxQ5z?=
 =?iso-8859-1?Q?g1W0lIPJJF7BrVWSVtq4iJizci4zfQVJHdm0te9lqjmLALszr/EfiO81iA?=
 =?iso-8859-1?Q?qRYRKVsD6NlKzbgdKR8lpy+mUBcjD0VbS+uybsxlya1bLL0Xew4FDMTj77?=
 =?iso-8859-1?Q?CtMuSRm4uk16CIGThsgthfYuwgc9PQNebYyjsvdpwgBaQOO45xKNecTcBX?=
 =?iso-8859-1?Q?6XGiu9/zvLZ5RXsS82qjhsbcTdR/WkNRzYj87ZndDFPUtNjDEyYAY0ojgR?=
 =?iso-8859-1?Q?M1os4OG66nc0h/YXZFk/xXK9RhU6dr+UxfnKG1USw+alSLC+nWjTATGXJS?=
 =?iso-8859-1?Q?ow3ZnD5eW5z3crbnBxLrfmaBFIRJNGLj520LFjlFCT+9G0vLf9/YMDo5N4?=
 =?iso-8859-1?Q?7XK00ZFuyBvOuIhrRdCzsutQjJ+mjch+TuJ1SSCQt9+hyKFR1MN9iCyOmP?=
 =?iso-8859-1?Q?K98nG+67P0aFZkOBxF0oh6QAJ0z0Z/RyrIylmV/QmrBOY3rxZ5n5Rg10QL?=
 =?iso-8859-1?Q?3j2QH5OhBB8QfFfNefDReV8mu6CNh5FiDNr4XNWBEwouFwe5TozMi492Ts?=
 =?iso-8859-1?Q?tXZ8CssaAZw4bzVfC4AUA9T5fGeN/sqN0J34zxP3oCU6d0tlQbm2HVAFcD?=
 =?iso-8859-1?Q?TjGuH9QEZfZ5JA2Xtkt1yP6SarMyfEtiYApqeQD40HXdfr7t4loKKW4Zh8?=
 =?iso-8859-1?Q?dSZRyzHp+oWfBWBtEC38W6KX09W+0rE7jZQ/UF/E6gPbva1CeJxyHnp7uN?=
 =?iso-8859-1?Q?6htmfmzM9GObhhsdel79ZZXyNwhQ2JRedef0ZpWIzEDzePk3LrXbfJgTcq?=
 =?iso-8859-1?Q?qiQ2IZNH3TOLrHEoKl0LAn5BdReBWEZ+SetzxS6kZLZ0rMQ+5fJw1oA5/J?=
 =?iso-8859-1?Q?q6TNeJX8N9pDSaVWHJ4cQO3nWzXaxA3Jn6xK7DwUcCz48orFWpHPIl+QHE?=
 =?iso-8859-1?Q?mHhUhW6mhO40n6V2BXXaP4yc4Hl0Ue6rFUH76ZheM5KqLQy01E4oYnlwSp?=
 =?iso-8859-1?Q?yvgamB8xrsob4rT+QSwooy8ZfJPEiuJRs2dCz0p6bzhZWuQi3I1TaMPeZC?=
 =?iso-8859-1?Q?5xeDeZ5W5V4fYYnvsCAnWLCFvK5TN3YC3s17QT+xGaGoQyTnb2uZofnkE5?=
 =?iso-8859-1?Q?1hpXnU3iwhjmjdh1Hd7yx88hOp6N9j8xbXM3kkxVAZLryu0lE2nFIDdfZi?=
 =?iso-8859-1?Q?BWYmLSuljt1ss+Kp0bjUzlLkat8U?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?sL0qdRARQ4qh6bdaOHUxIi53Gkpo9dwe0qBp2+2CT6TZ2A7/+IW2Jd9weI?=
 =?iso-8859-1?Q?aMz875ixqg+4X4dqENLne9TqkAcrRKCas2VlQjVMaNx80CAl+ukJHahynW?=
 =?iso-8859-1?Q?ncXEnbTROLQaCGIysMMpKgcGqTI/Eb4A2QKACFB5E1mmshlqf2fMIC2K28?=
 =?iso-8859-1?Q?BvC/AAPdcbDB1DCCLt1tzOqQhq/rkjJN1k3AzYGfP1HwSumcMc8xC7II0R?=
 =?iso-8859-1?Q?abkwWejDqgM8yTCf2nI1xwdGCcFdHYG0EAOBDT2bk388KLDItD+awP+t0E?=
 =?iso-8859-1?Q?P+AaUbOCT7x5Y6BCoqXPQd3UmRz2DLbM7nh9879YV6d08yuxP8xBuhgmkw?=
 =?iso-8859-1?Q?HvfNgpGFixNyl6ED/+JNr2E+RROlRNp/jV3UF9Y0c5aOuUxXAuDshbBrt0?=
 =?iso-8859-1?Q?4pIjanyQXSucQuK/Egml+ejlXq3xJVyEC9/WOH7u2OeGBclaiDEq1xyUV9?=
 =?iso-8859-1?Q?pEx0QO7q+HkFpDJsPkzQpmcQSs0JbQf72SpYi3bXm8Q8jUC8kz3iEmabrf?=
 =?iso-8859-1?Q?u8+O1wipXwQ/EodUTeOyPOwBl6Z+hOyDkOZ1fo3D3qd0TQ4rEzIg5+6iy8?=
 =?iso-8859-1?Q?wE0xjJdaJkJ9UBKdUBFuR7fENjfOOdlzK6v+zPUSTNy3N03owydK3C6F+R?=
 =?iso-8859-1?Q?r512XrAYaI88rdvESLjSiVFN2GYBNNVjj/E5B6znEqfGCuRBg0aNuhd9e5?=
 =?iso-8859-1?Q?UuODHH+NO3UPci528XWRI78I4KgJf4IiKKQ0gcHSEnBxZAvxD+5aFE1izH?=
 =?iso-8859-1?Q?gln85MIjh0qDlIbpDCGBold2ZMvTlsf70WNHcMyzkdlY6ZSi87Eya1TKgn?=
 =?iso-8859-1?Q?Sjr67Wh9/q0rR58L+5GLlr6I3WyUkcAdLk2O5hj5rOlFyjZNM7D8BQhOxj?=
 =?iso-8859-1?Q?OejKtm4+/QEKDm68FI7Aw8qSNl+1JAMf5W5G521EOgbBJI/40H8Ns1JiAR?=
 =?iso-8859-1?Q?7gHOFG9Tu9lijERbk9TS8XPB6v09JbxR6n/nedGLZ+Gd9Dij28fIeSCvk8?=
 =?iso-8859-1?Q?mvZLomPI/cXOGnTAQZl/cl5hMkafdrkD3ynlxDKN8WtWxUy0F9Zh+MIppT?=
 =?iso-8859-1?Q?PBK5cB7npAERcJ2sxQquqATQTlnh7O49d0pVn3bOBZ1pRyRyOtzCeqcJng?=
 =?iso-8859-1?Q?YgVZCwNj3t18kmWKfUaGe16FL/EvsarrZDhYWZbaCsBeRHGdXvrhyJgT7p?=
 =?iso-8859-1?Q?GdqOKn2l6SxBIaoUhRcXwM+PBJccP2katNwrEsAaYoSkNCHaFljOt6MsGw?=
 =?iso-8859-1?Q?K6Wgz+TImhsfIEigSPPRdNwAOk1wpxIJUyJLz2hhYubucFqHMWXICB5wwJ?=
 =?iso-8859-1?Q?GcOIDeUnB0qA4xy3Ydi6se6UGHy4XZ1trFjMmKc0EjVQgkrGUuyLwH0PTI?=
 =?iso-8859-1?Q?xAXoLioWNd8jfSDMEmEHGUbU542sULMDxLDhVdkgXWb2jxyyMjXT/b0UH3?=
 =?iso-8859-1?Q?h/PI+iz0NCK4l/ei9ij6fsRhzQbPM6V8GwqXlaZDmInIFXF6AHLXUlfdh/?=
 =?iso-8859-1?Q?APATCaaiigGOSIQh0LyDehKlSmz6OmWNaftLybT+/78Mf4vqdc/pSHc0rZ?=
 =?iso-8859-1?Q?oSxwVKc8pY3InXjpTh2MLgWUcKxm9X9kDPPH2fJfy4VW4eNyk3rTHXRint?=
 =?iso-8859-1?Q?WV0qWhEnccXok=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a211837-de79-4e6f-26d5-08de2cdff125
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 11:35:46.7560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0HJrdl+T07rUcBXro7yo/76N6KCQ11ITfFKntCiGVnQxht1iTWi+YD6pO2kGpjYCDGrpJ8eIPDkgzka+sAVvyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8302

>> +=A0=A0=A0=A0 ret =3D vfio_pci_core_setup_barmap(vdev, 0);=0A=
>> +=A0=A0=A0=A0 if (ret)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
>=0A=
> Should make sure vfio_pci_core_disable() is called on err path above.=0A=
=0A=
Yes, will have to do the following.=0A=
=0A=
@@ -112,8 +112,10 @@ static int nvgrace_gpu_open_device(struct vfio_device =
*core_vdev)=0A=
         * memory mapping.=0A=
         */=0A=
        ret =3D vfio_pci_core_setup_barmap(vdev, 0);=0A=
-       if (ret)=0A=
+       if (ret) {=0A=
+               vfio_pci_core_disable(vdev);=0A=
                return ret;=0A=
+       }=0A=
=0A=
        vfio_pci_core_finish_enable(vdev);=0A=
=0A=
> With that,=0A=
> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=

