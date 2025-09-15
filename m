Return-Path: <kvm+bounces-57525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED19B57358
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 10:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1FCC7A3181
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE8042F0693;
	Mon, 15 Sep 2025 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VrdbykHx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FAF275B02;
	Mon, 15 Sep 2025 08:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925951; cv=fail; b=CLqg/wa/IdBHqMUW+pjtwaSqqcQU/aFSoesaVoVQ38cghgWnjnniRByOJMwcI7dlnmQjLYCRMbmF4ApxsNOIId9D4+yImlw3mz8Su5DMOHLs6Q+gk8WIQ9t/iozJirYb1IjNDOcWnFiaq72FU3RqG6lqgv1gX3oRwS72bdkyCn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925951; c=relaxed/simple;
	bh=m1N+ngC4c0gHqHo65s+37YgiaJBWjlmKjCQ05G5PmQU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sC1+Nho20k2JGcu1kOLHOdjG8Ia6M/BQJ4Y1DxlDt1LKq8c1cylWHY1UvtWCdilOX2CkrHO41LoItcncYKfTSiKarkKWWqpJwYhEQhy4SSLus2Wlp+/U0VEMqi83+iDc6aT41FGwNiMchmNNfeS0H0Xz9lz8DDc6K5YxXi4cX4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VrdbykHx; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JvrlfmpMedMGT8FbOZPAyIU/PglBN2oCkR02a4BkYervz8KDnLoc/P1+nvuaE06qO6Z3RSFcyosKYCSLkLfyo3u30PErS0l9uxjEba286XeTUS6WIFVvl7qkbHTrTcRv/vJwiO+ZJNnIKaOkVdUHJqD1UH+gix/3aB9H55ofh7ha4MdDC7r/QbtzbXr+BckMxxURnWwSJc/abBg1zmGvEyGOtBrpqAdBshjMzScx9LJJVtEpDDcCAVn9m0PBD4InNSa9g9bhWrDs2Cviac25/4XUDDaMh0jJnVp7rvYYum66SqJNuTL8u88Ba6Fee2dicH4miU5Xzzd0GnX9+vt78Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lGmbHnvPQ9WksNu8wf/QMliD5wkkXB+P6F/Ah/aMTt0=;
 b=hPg8/DLvMiCNhWP/M4AFHHq72gwNPr4A7e1B2Kkcsw5daTVQg1w6tSqmjmE38gqTA7bnyx+LF25R56RS6B4tvB6Cdo3jers1z3YGvHd4qfmR5qkWnebDrGKxEiS1XgKjD94M51eNPa0hLCZf+QsX501C8UQE1owcQ9DS8nRv4dlSeffDyB3GuDWgkzQQUwusHgLml+DSFLVNGtNeqmIb7ceIDV0hGsSP2k6esKY0to8Z6IMfAGW65HFMi1qyBhHB5uK4kY59TQ6QF6dKP87YfVrX+lNCSqCdPXJ4cJQmm8x8Hbcd1RnqE8G9/JEpSUuKERoZZKfXetgSlAIDLmPH1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGmbHnvPQ9WksNu8wf/QMliD5wkkXB+P6F/Ah/aMTt0=;
 b=VrdbykHxqwnElPtE6f6LhLywKIiKGvaJ9bCgfh/WVPThz4M2S58V+jZ1piWb3wyjQUYtxoW3P6Sexv71s+fBtU3scEpO/hXpNgZCmc8wocroKspNHsMd9s8I9IEopJPljm3OkdcKljc3TR2vj+dyhp2jjcdbsylG4y1wSWJLqc4MeGLpNU1R2n+0rkcZ9ctt7o/WNmksLKftOTiQK8HjuOE3RAFYLUCtrNFd4ML+B/+SCcHpVfg+YgHjn9Xv6TrB8fF0Si8KtdCJz0YL9Rt5bzDhL63IxD83xWc+lvXCATj4/EedtYy5v2bN9NOdD0Dh5lAe8gPxxh+YEym/awFHtQ==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by CH3PR12MB9148.namprd12.prod.outlook.com (2603:10b6:610:19d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 08:45:47 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 08:45:47 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, Zhi Wang <zhiw@nvidia.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<ACurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Krishnakant
 Jaju <kjaju@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC 10/14] vfio/nvgrace-egm: Clear Memory before handing out to
 VM
Thread-Topic: [RFC 10/14] vfio/nvgrace-egm: Clear Memory before handing out to
 VM
Thread-Index: AQHcHVGcRg7gqsZ9+0qfRt7cDEPeR7ST/v5w
Date: Mon, 15 Sep 2025 08:45:47 +0000
Message-ID:
 <CH3PR12MB754873BDB6510A889170A0B3AB15A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-11-ankita@nvidia.com>
In-Reply-To: <20250904040828.319452-11-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|CH3PR12MB9148:EE_
x-ms-office365-filtering-correlation-id: 91d99df0-6d35-4658-8a41-08ddf43443f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?kWPvbvnG4zv2XXuY/WCD+6ZXzAL1aRe/yXx8t3vlX3cROd8wzz9P4gkCz6U4?=
 =?us-ascii?Q?aNJ9UpjFW+/hYoRfjP0maYw+ZqAZOWcLKcdgbK/cbeFkGG9qZ0DWonN2/5w1?=
 =?us-ascii?Q?MZeJlmqyiOiX4IxdA8CBrNssy5W7fIKkpfWCgB8bNo02BLqeylvwv/UK455V?=
 =?us-ascii?Q?acEEhVdufOyMyt2FFgaXsVgdM6UgeAhu4OisctGdYI0F+2+ntPYPKQ1C0MSx?=
 =?us-ascii?Q?DeKXtfy4ftMmlSk94LVCLP6uOawz7jB9X8KwFv7ttKKYLjuXOUkruYHIchNo?=
 =?us-ascii?Q?/o6FiqUa7MHwzrPcpTPiGVKvszpNoqwEQs4l8/WqDFNALiprcO9SGArHwwSE?=
 =?us-ascii?Q?73Y0eUpZip93Ie8xfiEHufieBXsQU+GtWrnErarRXBrtGQZRrkxunI0vIsGB?=
 =?us-ascii?Q?41KNRngUl2alCUd7IUWLxZ3493vNyKQc19Nf26nCnCgHoPXU1KW/F3A5ecLO?=
 =?us-ascii?Q?4F6rtYBT3Ru0yyOIjWXw7JwjbBXWENVWfnLYf3/4CzzRuPu3Ga52wAeJDLwn?=
 =?us-ascii?Q?QjkuTddNywqPFdb12CWS/BNf4aM42KUjLAHd+37O8UhGtXYd2b5l0rZgmk/R?=
 =?us-ascii?Q?hsetmdn1MOcL5v0mjzb/fO6fKH1m+sIVN21FgTS+xT2s+WP/oVSuzx2N558t?=
 =?us-ascii?Q?X8ARhoZB3cLBkeRZlybav80+W3XsliFRUcPjOvSO92jougDH3Dmrhp7l3N54?=
 =?us-ascii?Q?umkXL6X3Jv2p87Q08UjAb1Gt8Mo20jeekG3lJifX0EQl35f3maLFcWJHvCou?=
 =?us-ascii?Q?/WOTmPtFtwvNxXkNPAOtZgp59DLrkpw+7gEBS+k1URMTZu0V8Z+11qvGgTaZ?=
 =?us-ascii?Q?OUDVI0quhz0f8X1HLYg/bY5obd8d/biTfiZR5b3J6knaMxMqrzoklwGiLwyE?=
 =?us-ascii?Q?GTMJZ7lZhxiQv/Y7a5USE97aaMfrkllD39oWjmJbKbf/Ov7CanZw3beSiHfT?=
 =?us-ascii?Q?DABJ4tcQYHxAC4PBWXKMo/IVXu3dfeRzCPnfcJzO7ryzL0Rx0Wv2HGY/tCrZ?=
 =?us-ascii?Q?YGidaUVPcxxLiBEI6780VmgHY/h7oCMG7THPPZbf1NqpRwC9krBXeEMphcP4?=
 =?us-ascii?Q?9eIZWWYd+AMmXlaHuN2DfPkI/7OalPlb7jM7ICTm2osQ127OJVDG1lALA8fz?=
 =?us-ascii?Q?9iVa+kN7S+kb+CLUU6bm6/+Mn4D7ojPj5hTkE9211Bxtz7RcYi1FDRlHzNG3?=
 =?us-ascii?Q?UDVqNgL8Ldsi+WrD4C8z5kCrTLGzRDXq1rC4x2kCXRav+wFGXipQ7u3yCy7U?=
 =?us-ascii?Q?J7ZM3rUUxQ+kg0t6ZdCj5WMh47SSd3QTXdITJBN6uaP1VuNhcDzWtmL7GW+U?=
 =?us-ascii?Q?PHh9TlmLXtKTGS3slUjpMT2NtYhhM+NH0YjjqqmggRu8VFRYRepuLGuzr4HW?=
 =?us-ascii?Q?wzUqIaPgHg63GQFKA5I4SbJrYB08rI0YWH6EUY4RCb72pwV4C5xG32J71jcD?=
 =?us-ascii?Q?AsBM+B9GnDzLzv3duHPyXUq8fF2H81Tjm7x6puaCqZrHYhKbUd9WSY9EAqq2?=
 =?us-ascii?Q?9t6m8hUgL+oMntE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?hluirvMP6RdQi7xFK0Ty7B1+8Wjdfkftm9a+5+GjUvCBrp5ABKFxcb+2HVr2?=
 =?us-ascii?Q?z8c7ej07ePESvrSvtTz4jQxEO+ZA8OTbJIHGH56PBkDyHupJoF10PlrTyqJZ?=
 =?us-ascii?Q?kirTwzGQ7fQIisBeSVOaAcurRxN9NoX1WH6J3TbB9/Edjamo9XPZJbeLrdXx?=
 =?us-ascii?Q?LZHcr0hw3Za4+ypYs9wNpNAWnHrZDYfgE+rqj9flIZdNYe+0AYyswTtMEdxD?=
 =?us-ascii?Q?mQHljRNx9R7+R77WtuCXHAMpxwghqZZ6RngaXoo6MlWG0BQX2A4TO1weY/rn?=
 =?us-ascii?Q?I/c+ztv4lcvJSGdViU4Y+ZsCNyaSivZLAciLrdJlWPSnBlMIY+xFO5yMzZ//?=
 =?us-ascii?Q?4CE9YSLwq8QYpRsJSE063JVMXV6HB7dku9HiEGyzKNLMDb7Cw0wT3WFNYP53?=
 =?us-ascii?Q?SC0bswu3Jgu6xTmmLlL/Ulx1/4likzbCIXWyH26Q5DMaHo/eylZxIy0CfqNo?=
 =?us-ascii?Q?NBbKXfSHBJhQPrD2q9gaCDXQDWnbA+lHvOIjnytiXy7C3VydHbNeENYXsfOg?=
 =?us-ascii?Q?MMvMFHr5ZJhsyMnaR8lPTaf/dOP0cwPTPDcMwqxnYDTKH5QPfn/+ioCXeL7i?=
 =?us-ascii?Q?ud81M40oXp9WXpLAVp+qHQGacTJOa5MNbZNXw3OjPiNfllH1XmvZvGkd0XkJ?=
 =?us-ascii?Q?h86GqCtRiISHlJr6jNEhHRbNHQpCALPu3bGARh40zAxh9dHjxVCo+Y3nZkvE?=
 =?us-ascii?Q?73g1FvVsCamEBt/JAa6cDlXd2dRYNY5PWVms3X0O70YizQXj0k0OnpYPApUa?=
 =?us-ascii?Q?Szn/rOUUYbe0RePkFFXuFovTPJ9ToiqxXCzx3tK+73bBcC+3ftZqoNJ9zEtv?=
 =?us-ascii?Q?xz9/5LOP2nUt6Yi/tIAyI7omLZQgYPK+Vhm8VxTQ5OdNAfEGGCM3O6ij3Y+R?=
 =?us-ascii?Q?dlhHKi0CBd3lTo1xvejpuoF+MYwijWmd1V3U2cpx//N8y+wPbgd90ZvU82cz?=
 =?us-ascii?Q?D7fqUui+4qH8/hA73RliULBCD38ilLgK2AzWbcvfhF3dK8TXehN0bAVCvL1I?=
 =?us-ascii?Q?QKWpIQy5p2E5rkT0Kyphe/F8f1aFrWD5a+OTZcsnFg/s/0V2xrr+y+q4o2UK?=
 =?us-ascii?Q?7VhKH3UxMmH+5RCYfaZbo4ZjBczupjUvYEnBuv5by29Aa9qcTNTol0ok6Fl1?=
 =?us-ascii?Q?BiOauA7sW8Cp7iZADTqE8dMeQcheYdby2F2AjgouicsA1XPDVtdyZxZd3sR4?=
 =?us-ascii?Q?SXN6RxzV2x8EsK3kX0WW7actwIjbHtuJ2+8Koy41ROzJGVr0kTxw8FQnJ6AR?=
 =?us-ascii?Q?CeP2tVPmh1XgvcPR4Q59MgkKi6Skw3Z6U29Ebz6JV0q0C3rxgvI3OZAW1dtn?=
 =?us-ascii?Q?JwhE0tY+qallswsbjHXG5T6n+Rg/6GUdXGiNzhrzK8Uew/Cj/I4n+Ogk0d45?=
 =?us-ascii?Q?y6Z/Pz6TPLFbBqdhID1e84SWOGpusA/5ApvjJyca23wsuckeE2E8Dvaf+WqE?=
 =?us-ascii?Q?axOggZyHuA/A6jnd3Z196692+/mgjljDJPVS88UTv95qHLJ5fdD4FePA2cDI?=
 =?us-ascii?Q?czkjx8L69tDIb7O7JI/jEduSNIOWHGa5WSod9sz5kX8ig3FqSvEs64lgQ1TF?=
 =?us-ascii?Q?ElUDpCytnReN2SniOMx6+ZPeob+rlas30Y4SxM8u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d99df0-6d35-4658-8a41-08ddf43443f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2025 08:45:47.1427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yfHrbjZfMdkI8CmEaFpanGhaHgwXJejW0CVIdvCkohPtJoI0P+ZFVxA2s1ITlVozRDrbn7GCwAORdb5aQoLmbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9148



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 04 September 2025 05:08
> To: Ankit Agrawal <ankita@nvidia.com>; Jason Gunthorpe <jgg@nvidia.com>;
> alex.williamson@redhat.com; Yishai Hadas <yishaih@nvidia.com>; Shameer
> Kolothum <skolothumtho@nvidia.com>; kevin.tian@intel.com;
> yi.l.liu@intel.com; Zhi Wang <zhiw@nvidia.com>
> Cc: Aniket Agashe <aniketa@nvidia.com>; Neo Jia <cjia@nvidia.com>; Kirti
> Wankhede <kwankhede@nvidia.com>; Tarun Gupta (SW-GPU)
> <targupta@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>; Andy Currid
> <acurrid@nvidia.com>; Alistair Popple <apopple@nvidia.com>; John Hubbard
> <jhubbard@nvidia.com>; Dan Williams <danw@nvidia.com>; Anuj Aggarwal
> (SW-GPU) <anuaggarwal@nvidia.com>; Matt Ochs <mochs@nvidia.com>;
> Krishnakant Jaju <kjaju@nvidia.com>; Dheeraj Nigam <dnigam@nvidia.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [RFC 10/14] vfio/nvgrace-egm: Clear Memory before handing out to
> VM
>=20

[...]

>  static struct nvgrace_egm_dev *
> @@ -30,6 +31,26 @@ static int nvgrace_egm_open(struct inode *inode,
> struct file *file)
>  {
>  	struct chardev *egm_chardev =3D
>  		container_of(inode->i_cdev, struct chardev, cdev);
> +	struct nvgrace_egm_dev *egm_dev =3D
> +		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
> +	void *memaddr;
> +
> +	if (atomic_inc_return(&egm_chardev->open_count) > 1)
> +		return 0;
> +
> +	/*
> +	 * nvgrace-egm module is responsible to manage the EGM memory as
> +	 * the host kernel has no knowledge of it. Clear the region before
> +	 * handing over to userspace.
> +	 */
> +	memaddr =3D memremap(egm_dev->egmphys, egm_dev->egmlength,
> MEMREMAP_WB);
> +	if (!memaddr) {
> +		atomic_dec(&egm_chardev->open_count);
> +		return -EINVAL;

Nit: may be better to ret -ENOMEM here.

Thanks,
Shameer

