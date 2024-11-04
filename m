Return-Path: <kvm+bounces-30430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A36539BAA8A
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 02:48:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 298F01F22AD4
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 01:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7681916131A;
	Mon,  4 Nov 2024 01:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OszLKjBm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B5E3214;
	Mon,  4 Nov 2024 01:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730684873; cv=fail; b=Lpk2S2LHBwtEjgyw8fLXeMyW7KLRjSo6TRUiPqSuNaw2L2pR5PVaS/tARg46kCC+taDm6B3lOdb9Jdvv3T8ODyRsmS9K46Hbn41zbDG8OrCGxSiZXbmg03GG3wZWdqb4RfyvF6ZyiIM/Qzg6WY+uQpQrog9/vjofjfvd6R5Tt+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730684873; c=relaxed/simple;
	bh=vzf91Npl0WcwJwUz1ldflZhcxKnEG4DBc6KiCQHCMVM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RJ2TsfPOn074RpBtoMpIxmMi4ypmhP9kgO9PdSn2WwJjyO/omz7tXbaNOucBy6VBze0CcfHA54GIhssS14CqFtUrtu4IQAU/ZpgkmXzgU4/aP8NCu8VQuqvefGtbnx6KkALKLN/j7AVb2bYqqZVbFC0brqfH76WrAB2nBFmHR3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OszLKjBm; arc=fail smtp.client-ip=40.107.220.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g8yFkAqHaRCP3ZRzJR6y0KnnROllXq3jkEPMF2YCIQnFxrA3UeW1A5opT20Y+MJeaCIYRF4mOuNBwIBiiWNZMPl6qbZZSojWiRlL8uHW2lPQVksCdXTT9pJGmW7iiUmgIm1TzQphZZnaAjp51Sm/m0ZRXlShR6t6/Wmf823PfxnMvkZ6tFDY3bWU9Ev3FfWJRFcdvELSnPxw0u9Oogb1qYbFVtoCf5Gl5naR0HyNq+1PLGSFlecz634f+bk1urgNesPum2OAP/NDLqmzeSPQuoCnJE5RIyCQmxlcTRWmbBSddMeJg7+4Verno1K/KW+nNYcloezM6z0Gb5DD1lR6PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzf91Npl0WcwJwUz1ldflZhcxKnEG4DBc6KiCQHCMVM=;
 b=qQg0Fx2bpTkwS41o9EXwrd/k7rA3tXwgg23koeC0xSJYhBt5MLyno3BGyTPhtHPvtaP+7WXW3A1bT4tkdr8X9Xiqh3xpX5k1SumSjtMtYiS30IWOxcSz+2zw3EG3eLAkAsdqt4xhOKUFqfwaJ6RwHbpyodLyhMuplDCbZarI4Nz0WEiNuKNx0kmcrzYiah/kZB6UKoFWgPlxBrUhCQZs4bPG4Ahw0fr66rdkd7XxLc5JvRA40bAfMpE749ePxA6Bw80J8GM63naiBgQUg86lF1jFxHt9wf08d3qawlo5gozC13DpOwOYnaByy2Uu4mehQ/K48zotPbpruf/5PoZ/qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzf91Npl0WcwJwUz1ldflZhcxKnEG4DBc6KiCQHCMVM=;
 b=OszLKjBmeoNDz5Jq8NWqVR57lw9SRArfatE2p1g6ODuwQ4LfHzqM3Yp8M3eSuZk6evpRqsyeYpLsq0dH6TPliXejVG4YCs91gB4rzmcdY5KckvpKuDIDp7qhTPWeO7SQSnfCNIqvMJygZ5mLiy69spIrMdc/JDq1sPNbydZT8sG2cGp8QhJOFbHEnd+jvz3Xvpxj30qMo8ADPLyK+3hKmiAJnMml9y0ytw4LNhgr6Jy+XNBgACBS4sa3Kgr7WxvsifDhRAE6i/0fofxl0Ov79s/DetgBJ9uuvJHcbcz0kpopECnv7AdwVw7ATMSOO7a77/bjV+Lm/cZua3KZnlWrDg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB8576.namprd12.prod.outlook.com (2603:10b6:8:165::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 4 Nov
 2024 01:47:49 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 01:47:48 +0000
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
Subject: Re: [PATCH v1 1/1] vfio/nvgrace-gpu: Add a new GH200 SKU to the devid
 table
Thread-Topic: [PATCH v1 1/1] vfio/nvgrace-gpu: Add a new GH200 SKU to the
 devid table
Thread-Index: AQHbHUTh04Jnu5m3FUexnBlnqUOesLKinMaAgAPecTU=
Date: Mon, 4 Nov 2024 01:47:48 +0000
Message-ID:
 <SA1PR12MB71991655150B193CCBD15BAEB0512@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241013075216.19229-1-ankita@nvidia.com>
 <20241101083803.3418d15b.alex.williamson@redhat.com>
In-Reply-To: <20241101083803.3418d15b.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB8576:EE_
x-ms-office365-filtering-correlation-id: ae5ecdc4-ccea-4625-962f-08dcfc72afe3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?bt8pU53YtOHcUFyP6x2RmMFV6Umw4ni8IxomTMz3ijpJ2vJDqPWzAuwTSy?=
 =?iso-8859-1?Q?1wyvmeGHJ+5pNvmGZvN6Pu18P1vo5TfgaxWPQ0UuOSn3fBOdyGMPnWmgos?=
 =?iso-8859-1?Q?TRJykUsr6LAlROkkljlAmtPsfuE9ZFg+xu0PC84WV8MJzWPKck8kfcYrkG?=
 =?iso-8859-1?Q?QwJtBI4VR8oO4SUVsK51M0RpG1bogvqzM6bOhghOC2FjuQs6U/wGrDRDZO?=
 =?iso-8859-1?Q?jXk+S6yssKKF6VSMJ1UwufNcAAHvZmK/KYCtkMNYhCUT1Eh8LXViSeOeBB?=
 =?iso-8859-1?Q?41KqRpZPbBM5UsDcT/etRXUuR6VwgCznkxU1bJh8CATrn9+zpnEUDO6Jb0?=
 =?iso-8859-1?Q?k4cKCBbrbH+B24Eq3YqM+X1lbvbytAYJxmO0/9WnZ5VfXrPeKJjpkdOxB3?=
 =?iso-8859-1?Q?HaZhZ4LqoqgwdaHmMr0k3WK1pVMCzeWmv7547pwNY2B1huic683Rcf3iXY?=
 =?iso-8859-1?Q?cn41y9C5qk4iBv8FI07Bakgo7RnaX3IBYk6e5sIAxI3zfSBLoFn9vob+QX?=
 =?iso-8859-1?Q?o5a0O0WWch+uo/uTSFpA/bXxT7JGd1uN5JDiwDhdnPLICOaUn5ValyVa2b?=
 =?iso-8859-1?Q?vzUTzxjP5kK/kz3v8S5qdJWpgSMVzFM5wqDUkOWLLDN3uF0H0uQPzZWxpv?=
 =?iso-8859-1?Q?satCXIYgAyFPdt6m/mg4/hhuyKBJO0sYfCCSs+GERxkmYPdm6JRYwEE87v?=
 =?iso-8859-1?Q?B6vi0OB8o6o6uLwpm5hMMpF1YUpbJk/YeQKlfwPCB8A8JIbBJy+zvm986Z?=
 =?iso-8859-1?Q?WC0egHTmNtbWzI0y7W5S2UirGhQ7wvpV0tI2abj/0s+xPzsnNUEYExVO6u?=
 =?iso-8859-1?Q?FvfFwgLm14fLaT5yjQQo9uMygFuV5wpH3aeTr1a/8alSC7bi+lGigKTmQf?=
 =?iso-8859-1?Q?gdfItqkpXuDQeMhLwaEWHPyLskK/Hz5xsFHLLkZ/7LC0SXCQqEjJOafedm?=
 =?iso-8859-1?Q?5tuQxl8SEBnViEfMXezx3gLn2Z5ZCirOUOGqBD5AV/bVO2x7FMeRJ0XxMN?=
 =?iso-8859-1?Q?N30pw8wCSlFNBEg9Jq+ADMAqbpvZMmkD9RPF45nQqBhbKerq25DOA0TrvY?=
 =?iso-8859-1?Q?1BCICJwYt+jZi4X9ZRWk4HQmxLQF4rBsLXlcKtTot57vb6dvia0TIVrbBI?=
 =?iso-8859-1?Q?5P7kb9k/SklRgQhe+OY997kaoSGhC9bp3jm9iCt67EkLdorhhbvmWppATl?=
 =?iso-8859-1?Q?htYsgjTl3AxSGr3e9sJRbSeAdoLuNUIvbtlgavp/O2lt62J39vZCt2iMEv?=
 =?iso-8859-1?Q?zBVCfBNo4jcLEEt+rFX0Q1gLWhU1mWiN3hy89hdGZuvZe3bOdGQSsVSGgc?=
 =?iso-8859-1?Q?3soPtryoHxkTATsPQwCShalWwTfuJDM/d/TFe1JdJwY/yv0FP0wKmxG5tR?=
 =?iso-8859-1?Q?uTCd7VITko4Z150zfRCszPnznLbtzt3HfrWSFbWFeIfwB+8R4vRzE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?FoXaHLMjIYs3SKTe4nObLUCNZ9mqmCQtjXxIOEb6RALO7apl0+cZKx/+J7?=
 =?iso-8859-1?Q?V7/pWyzYNm7FYI/Kf/tgdATCHQFpo0BNS7RVA1py257eCeWisdomhLRcYY?=
 =?iso-8859-1?Q?penzrewL5Bo6jSBq3cM+meMVjefTnYGT01AXuSJIQkb2HatwLnFjd0btP9?=
 =?iso-8859-1?Q?NvGffByYs1CX1ZeiA4fJ2Cq1FREf9bk+FhUEkB4sXds3yCKOvvkYjmg2fl?=
 =?iso-8859-1?Q?iAz9784Cxdf0IzCsrBDi7oXeWKVmTBjoGAid5/Otx/L+j1wYZSkF/raHdD?=
 =?iso-8859-1?Q?Xnt9iqWILU1ABodZudtWBwY42/oIvLwcwE2wyVYXwRn7sLohG9CAGUZ+RM?=
 =?iso-8859-1?Q?TP3jvOW4lDUqcPNlbmMGTHdGCRh6s9sY4yvkyMr/zp58CzGkGzeRI3MqeM?=
 =?iso-8859-1?Q?BoqLcbU2jYB9DDQL92N5TeN93gTu+7PhWl0fRb54BBwh9tx9SJzvXeENNQ?=
 =?iso-8859-1?Q?pVctadztkn7QE9uPC/RHlwOSSzrK3i2skRZaX6akgVU/xwi7U5Cibq9QNz?=
 =?iso-8859-1?Q?sxIodHPB42CL/RbjUzwxjvIKQzP3XXjmXVmvc4Ta8wSsozbibMpJHcqV1W?=
 =?iso-8859-1?Q?0xSEuzdoi1gzDh2iFddJOFb4daoGODY/aVvaDCaFY3fow789e7N3diAOVD?=
 =?iso-8859-1?Q?fwrts4F5a2vKoMdVaeKTMYDwBcAPYrpgA+SEeeNfVxv6YFOlD1WZI3hxtc?=
 =?iso-8859-1?Q?dqp99l9N0E0HGzXUb2SGqMd4oBeif7/Q4uwkYuqZJksINRDyMX7b6TdVH2?=
 =?iso-8859-1?Q?sVIG35ayBOm3+wbOFVc3JCHcZRbGE9SnRM68b3Z2dKHMz0Q8x1e8XRj70O?=
 =?iso-8859-1?Q?O45m2nRMFS57REAcxYL65/3t8q+fozQfk/qRjp0PgJzqA3dcLxkJ8NYF3D?=
 =?iso-8859-1?Q?eGK+ASxX3tNfFay0gm5seqP2bs4kITdVJ6TtndtCzW7qRfJCbQI4BC3pI/?=
 =?iso-8859-1?Q?y3gLRflDNcFTz/UaAHp0aEsh4TqgXcil1bm6bp90Dx9bFac9wLur/omW/2?=
 =?iso-8859-1?Q?A4AAugT+b7SaxiBYRKtDE4nt5QmZyhHsxKEzzxIiDtNGsZfmeIjYISDfb6?=
 =?iso-8859-1?Q?D/PQFSyRv5cpkeKWiLyri5RenC1gUO+G1SEpQOouRdHa/yxHDZ9qT1Nw4z?=
 =?iso-8859-1?Q?nKxUxVTI6Ye0g+5EcS4vBWwJ8VSj4ybJXQ3LdWcoeFUJUvtZ37SfcnPi+z?=
 =?iso-8859-1?Q?cJrXDM+B2iQR81g2hTWTErbd41G3Qyacp6yBY/p7SehhFcTdQI1fsDybe/?=
 =?iso-8859-1?Q?fW2K4aIkIhzpa9Al50IF6FoMHzrZMYf8NJPq7KnHPr4dhQZeEBpgr08LH3?=
 =?iso-8859-1?Q?BIheaXCj2H0KpVOgiePeJJcKksYR2vPJ4MWhaSrY5j9HQI/qluPL3ShfHJ?=
 =?iso-8859-1?Q?+0LasF0zIl3oXkpp5XuZj4rfF2S5Qvi0hv68lWq6L5FEgNhikCpeLNPFYa?=
 =?iso-8859-1?Q?g0HULxOwDWVgihBrFIGMniZ28VlJpIuvfolB6LRjuPwaCyl9Jmu+fclpVi?=
 =?iso-8859-1?Q?Pq41g4zfOy2ZwFx1QkJyiQWaEdgTmB9q7YxcO7FWsmsMmj+Ig3O9cq1u9l?=
 =?iso-8859-1?Q?fHmHwCyJjJQbC5Dj+2rCNtCAyxFS+LXXrB8wh3gmL1F5xrj+geGrcF85Cq?=
 =?iso-8859-1?Q?s59vDwonzS1zU=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5ecdc4-ccea-4625-962f-08dcfc72afe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 01:47:48.6565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X3j8Wn8O/qMQe9afpLcR4oMGi4q/l8Yx01SpENgAn1RgLmjTqfz0Q1KkFZ40qMwPR1t3TdDh3IPoRSkN0DoKdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8576

>> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgr=
ace-gpu/main.c=0A=
>> index a7fd018aa548..a467085038f0 100644=0A=
>> --- a/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
>> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
>> @@ -866,6 +866,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_p=
ci_table[] =3D {=0A=
>>=A0=A0=A0=A0=A0=A0 { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA=
, 0x2342) },=0A=
>>=A0=A0=A0=A0=A0=A0 /* GH200 480GB */=0A=
>>=A0=A0=A0=A0=A0=A0 { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA=
, 0x2345) },=0A=
>> +=A0=A0=A0=A0 /* GH200 SKU */=0A=
>> +=A0=A0=A0=A0 { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x=
2348) },=0A=
>>=A0=A0=A0=A0=A0=A0 {}=0A=
>>=A0 };=0A=
>>=0A=
>=0A=
> Applied to vfio next branch for v6.13.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Thank you, Alex!=

