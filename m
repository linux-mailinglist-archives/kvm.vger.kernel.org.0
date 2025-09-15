Return-Path: <kvm+bounces-57520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F41B571DA
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFB3616BB0C
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 07:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9120C2DF3FD;
	Mon, 15 Sep 2025 07:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="exfTZE/L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C945523D288;
	Mon, 15 Sep 2025 07:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757922426; cv=fail; b=YTundjkP0bBVQ161AKTNZRsJUw0tJs9CKJNsaH5xaRJ8s3Axv9U4PMAsVxOmzcAox0hclkP/pbs2Ei5SQBMsv0FCJC9eRJCu9FVLK1T6bAmgDDyv94tEnu6cnsZG0svqQlmKsdOyJvNjxOuEUmc6H1ucBYuefn6W6d6oFdt8LRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757922426; c=relaxed/simple;
	bh=Xtv1XtzZypYTVKKDXR4Tv1K69FiLNn9TgodwaUIjQxg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hb5vZcYdg9pJcB/HJ4x6QHcPYT6XHg1q7sc8QGkngmPRyb/qN6m/mpWMGkQ+d3vOszK0E8icxIxFnIlHF6yvH5W6INWkSCXXSr2YnxVOJE5b6uZb/IFeqIk4NmuGO2JDsikDQ6VcJ6I9xkIZHZA22TPwyZ7QGhr55LCYThfNl0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=exfTZE/L; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OpU87hTjZ3nxiMqbZdntRzxaQIpQjI36/yjNiNCxj44WBT53FnZRNri1b7wr0y8HdF2tXp1wsQeye41TWu4hUZJok/WfBH/m1rmqrxpmnoIvg3bUQl3NA+oJr942AuMSLVLoL7zYgyKvBFP4uCY7PKP/3sJzKv+wgf9cijZFMgYUh3m90nLw8ZXXBSjRQJ6ZnPSjKluoLuQ56YmsFeqN2wBjoMJN7zKyJ6ynOk4X7mWkjk16Ta9BXUhrGW4uiLA+E1YMdxxSx56hdN/MliYh7gTHwH2ag2+WU7w6RKzVbSccP7BZW0FBGhszrvBgdYvPmddQ+baYQ9+USvJ26mYL4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EgeCRtKiAQ8FqA6YkzWFr1jTTgFzxWR1lkxeAhFKXpc=;
 b=G72yUTR5weDbpFpNoN5IJeLmmC8sM0TWugNsnfpU4tw5Gks5O/QE3gmKr/gkd5fJEKjoyMTk4aH+sOLZfPK2rQfMmNlzp6Jvrrgi2ciKYp9De8zSILxpuEkQC2sX1zw+jAGeg5FMqJ9xRAyh9dIEy84EwG9Rus+xuapQRR81KhLxCmhNNEgyC7oVMWswMF+lrxZvw/GZFw/GCkpO6IjseihunDYVJ+xZhznfvZIiKZlBwct0CxIHYY5Dc2hEn+RV5XTRJjc3q6s+CeERNd6YnlzYj3+3uIF8hNQhErbFdc4TyNnKxUjBawvClVzCvgItXOXTwR7oj+XcEDHotgK1fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgeCRtKiAQ8FqA6YkzWFr1jTTgFzxWR1lkxeAhFKXpc=;
 b=exfTZE/LN03jJcnp/jNRPlmrgbnEHCQmhW0ms0dTJ20AcZ4p0uL+fKWTu6nehVboq9Gy6TLw9mXtLyXCsf0uIO0dEIsDyUokzEK0k/yF9Q5Y3PkK89TyF/qEOtdCi9FMQXaE6VcqOgmq2LfQlTG5Ycy7y/33JGM6hRxC+3Yz2vI++AxPZ4G82Uvub8hA4YcNjlBA5Q5MYJ13ohdBX8UqLcsqKcz5coSmHHvOqd55Otisd3FsrxkRVFy33zJJ83c8Q3sTtzFoN4Lbgk+JzNYpskDpF6MVSAJKLGQpBwYvBOvdV6DKomcN1NoKdIS71xvAFztc9csSM4+plxDGq3BLcw==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by DM4PR12MB6495.namprd12.prod.outlook.com (2603:10b6:8:bc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 07:47:01 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 07:47:01 +0000
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
Subject: RE: [RFC 05/14] vfio/nvgrace-egm: Introduce module to manage EGM
Thread-Topic: [RFC 05/14] vfio/nvgrace-egm: Introduce module to manage EGM
Thread-Index: AQHcHVGZfFKZA5qQyUmLVsp92upWhbST7vuw
Date: Mon, 15 Sep 2025 07:47:01 +0000
Message-ID:
 <CH3PR12MB7548DB1A20EA2D32AB923CBCAB15A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-6-ankita@nvidia.com>
In-Reply-To: <20250904040828.319452-6-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|DM4PR12MB6495:EE_
x-ms-office365-filtering-correlation-id: ea240784-5d25-4ac8-f115-08ddf42c0e63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?6o4y3wryt+uON0GOBYeKu8njpTaPOjRAocVYPGcvirAbRyWWLubhYy+507WL?=
 =?us-ascii?Q?p6NTax/6BFn1WU/QQ+Ob/BeCYbDmVKK26zm2M7kd0LpUmPbNvEPmADZA1N+R?=
 =?us-ascii?Q?Cmf6FE0sXxk196/lMCioeeJFPeWFZgn5AhrYCkWP32Q9W7tS8rT5UXtl4Bp2?=
 =?us-ascii?Q?tldAriQPm8mE2edvj7CBmMGB4LpUAKjOT7oIhsevdEfduze+WKJGNI2sM7T1?=
 =?us-ascii?Q?mnRmPqv/NiSsIIxUAoZv8ns0Sp+9rCYj/iThwAorR6KsySaokrbchYjE1cfz?=
 =?us-ascii?Q?W5pZVYbkOqTGxGgqR/M3YGMCzgx/6BspX9H5mZnKAPsLDArmZw13HDj825Ov?=
 =?us-ascii?Q?MqPzxAFkiMSYfD7L4Uy4yfDKU+JM6Pm+cPqOA+OTtRsooMTsgli8Dm0WPUTK?=
 =?us-ascii?Q?PLESNXxhXFflcJ95s9h7GV/oY4CmFb3hCbskqlzrrSD2yrJSYEIHrlo/oIjg?=
 =?us-ascii?Q?z4Iwth6qc4J1l+nsY1XtsbXz88dp0CN+pzrRunIUl1FNMaSE769uEDiXAyPA?=
 =?us-ascii?Q?QHrp6dhizpIPsGbMHtCol3ykvgom+XOidpSpI32KwQHFhICSS2CO5fsxaYES?=
 =?us-ascii?Q?Pp/APhYjA3e2NTmYflx0WPK/is6Wue362Md6QRakwnu7KXqs+ImgE158Hiqr?=
 =?us-ascii?Q?PyMN986fhfUsYEBpTdqq6vx8CkAiVphnVqEJGldjCcFGfWXB5wYTZtYdExwM?=
 =?us-ascii?Q?wF5TUSGZMMySrm/fMGuHjv3ZSPUEsMOwXRGErc9MUQrGs2xW//UVrXwC6f5h?=
 =?us-ascii?Q?fEOHeVLM1YcHSA+l8kt4aKoP3uECFvjhKxB/LdZ7I6akM6Y5fk484jceiWNX?=
 =?us-ascii?Q?h6Fa7G9YXre1jjshoqGO/6KPIAUV3qOlOlDcv2DHshtJaJ1/5yffA05u+xhi?=
 =?us-ascii?Q?tXIIqpgWA1bapEhkBeIfbRcbZ3IPJNCrftxKoBMe70A4m941mWTDwl2WrNwv?=
 =?us-ascii?Q?3kuDu5aZKbySNfIuXy0JcuUv8l23Jt2bMS/xh9JBEI6AC2R4LNrxxVcEmPr/?=
 =?us-ascii?Q?N9xK02XuFwN3AFQ/EU1FVPjQK70I+obKanWQKLets/gprHTctn/wtMYvkDkk?=
 =?us-ascii?Q?ykf7pIqeD+8NIqLe85INkBh7gmKXRgIMhgvNK00feacKslmfuonBlpW4SCzg?=
 =?us-ascii?Q?yzQ8TK6TXdYtyBsSyHyQi5DQfK7lugq49l/2h9z5t4M00R5HZuHerV3j0AQg?=
 =?us-ascii?Q?oHX0pD7xJ4H7RueV1BwarynyrWsRm1wS5Zc0wMi2jWcTP998UbR6hzRhJQt5?=
 =?us-ascii?Q?vEc9+8F8Qi/3Mc24q1ENT+VdWo71eDHB2E6OREED7CCsp26k1pZyRXMKB+5a?=
 =?us-ascii?Q?+bBWsSH1Xf2+TYBpxJHgCV8+ECnpNWMwT3ulb7n05/oQjd7/p8LUWEdNxEqd?=
 =?us-ascii?Q?Ly6Qa0EMDoRCc0Csl7Z8cNLw/fOJp2kpRaFv2bRnVO0qpXASbxn0H+7VU4/N?=
 =?us-ascii?Q?zlhNHopkfC2ASuKTavDnCtD81SOdUxs897WNtJJiAXUUCtmgHWDeWanRWdHM?=
 =?us-ascii?Q?r9U13rAtNe2X3ao=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?5JgdKljkrttpTSKbSUQS05MwfHwEJymdmQQjebw8jxP45gZFcHh9YzD12Xcc?=
 =?us-ascii?Q?K6lHPORh5J/oJl+/k0idRjxJ9fmcc1rgnm8PzbLjdCiT1A3U5eMjpf/Wvf8b?=
 =?us-ascii?Q?zCN3eU6RZ7hcoJvh9kQHy55J4/nhb7pal/5X4XhrDzajXsC9qdCdPDcrsh21?=
 =?us-ascii?Q?e0EWsYL0MY3BQpRrnPgU8hUu0e2/PGI+KTdJ8uINrxgUC7mBgP+/4mE88DqU?=
 =?us-ascii?Q?rQZ32GHpOon0YILrdyfWXvlowTQmCEVYkHjEd8C74R9ZKzsFq4tVeh5foHCk?=
 =?us-ascii?Q?D4C/dcI2e9tah26AiAj0IariX9K/YY/5MAaqXJstTYJlR9S8V3g+K8BiqhkK?=
 =?us-ascii?Q?k2UujV/y15rZbaqtr4p/Z9b0MrgYoRPEkYp9uYslLco7l+IaRtxMhru3xxKe?=
 =?us-ascii?Q?r5nLxjWnOBgd1IHCTfrHJhBPA+Lj+vNJhlpDHko7rwnDrib38GbBlJ3xWuVH?=
 =?us-ascii?Q?bMtbFLULFwdcb+kPdzFFNV0/hdydPh3jihuKAfMdnJa7+I9HJDi4RIF1sYKI?=
 =?us-ascii?Q?sgws7f2R8EskeWUTMPooUMhcOKc/j5LAR2pF57N9ME8v2u6BywWZWY13NW6U?=
 =?us-ascii?Q?CTsn/xhep/GsM4kZfzNtJycQK5Y9SYd1cEqJPZkOAlrehcgAzXW3JViAj1d9?=
 =?us-ascii?Q?jYCnvQuziQCPlW9YP3EvA1anRDGJ+XSEH5Cs5aP0dNtIDauYnCohlDcsILnK?=
 =?us-ascii?Q?dhPyAh6mRKTSqxdFI9M8M+PIrSuy35RMEkiCUH1JVbxP1vdBiKoIcZHSmiKV?=
 =?us-ascii?Q?bQgNB7ZPbskqPIoHWEMQMgsIbLHH7/huKlvNewSDG+UNZLmykuGHLDwAecOm?=
 =?us-ascii?Q?Xiski7H9bBx1CTBIV3yeTGuAQxMoGs3zfFAw8Sb3Z1RAJQf5TicPo3S/l0rr?=
 =?us-ascii?Q?0OEHnRvWXJLn+hdH0wxOjUwpkrzswen7XouNFyI87mVqfRLw4IW3tt3YeRNs?=
 =?us-ascii?Q?kdhSYacczityejudrtcgyC/qDVgWbCDOup9PwSQZ58NEVS7+gnBuop4NV9MN?=
 =?us-ascii?Q?bp4Ob1B6liwx5iJveu9sqRUW5LUkTKWowLkIRi+AlY7e6hJ62Odhu6uR+7ZJ?=
 =?us-ascii?Q?WIKY+TFUbKCuSdtRgJcHhkYzU/jkbzH01UUxylrQce0qvYWAOLf8/9lWhAKb?=
 =?us-ascii?Q?zUqbAhEMz5VGWztPz797HrwWYr1YWvGN02qV40c3rwsnVhtVHKMSz8gvGQ8W?=
 =?us-ascii?Q?PGKaMIEhPsW45BxB3EmzGHkty12k5W0tEDPGiU0eTGxfa0JPZ2f14PF0e3/1?=
 =?us-ascii?Q?UF9qzpvb9ZzM7tMdEH62ch9uezcuqd/giXg0oAevsekV+QNcCZvSiiyuwuxY?=
 =?us-ascii?Q?pFzyUc0caohDskH9DpO7iMuKpcgFMZ7ognPMrBM960+a2LbbY8UFelXQp0Di?=
 =?us-ascii?Q?776R2pubVe8tw6Pa8HEXTw4tvQFtvb7I1zvVyFZnyV5OOaYKZVp+mg424lNb?=
 =?us-ascii?Q?0l9nOQd5D8CORNtZ7Y+9dGfjLOWpqTuoaeiMEaVZgmAAUYCKuZGnHF/uNvdF?=
 =?us-ascii?Q?00JEPqJSDTDDicrZFnrq6V29PPjWz/RCjaIEmx99ei1uv52h7umcwR8FWrRP?=
 =?us-ascii?Q?Z4z1Oknqgk9LL4kRvOCnZSrLJkCapLUuyh7sdvP0?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ea240784-5d25-4ac8-f115-08ddf42c0e63
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2025 07:47:01.3505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uL/+NLGx4LjEhXIfMr2LsvkeoO/IbVMBrNNF87wwEgxvsQ2DXOilMMTtociJHc+O7T6P6XTL/wLZxoZyUnnTFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6495



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
> Subject: [RFC 05/14] vfio/nvgrace-egm: Introduce module to manage EGM
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> The Extended GPU Memory (EGM) feature that enables the GPU to access
> the system memory allocations within and across nodes through high
> bandwidth path on Grace Based systems. The GPU can utilize the
> system memory located on the same socket or from a different socket
> or even on a different node in a multi-node system [1].
>=20
> When the EGM mode is enabled through SBIOS, the host system memory is
> partitioned into 2 parts: One partition for the Host OS usage
> called Hypervisor region, and a second Hypervisor-Invisible (HI) region
> for the VM. Only the hypervisor region is part of the host EFI map
> and is thus visible to the host OS on bootup. Since the entire VM
> sysmem is eligible for EGM allocations within the VM, the HI partition
> is interchangeably called as EGM region in the series. This HI/EGM region
> range base SPA and size is exposed through the ACPI DSDT properties.
>=20
> Whilst the EGM region is accessible on the host, it is not added to
> the kernel. The HI region is assigned to a VM by mapping the QEMU VMA
> to the SPA using remap_pfn_range().
>=20
> The following figure shows the memory map in the virtualization
> environment.
>=20
> |---- Sysmem ----|                  |--- GPU mem ---|  VM Memory
> |                |                  |               |
> |IPA <-> SPA map |                  |IPA <-> SPA map|
> |                |                  |               |
> |--- HI / EGM ---|-- Host Mem --|   |--- GPU mem ---|  Host Memory
>=20
> Introduce a new nvgrace-egm auxiliary driver module to manage and
> map the HI/EGM region in the Grace Blackwell systems. This binds to
> the auxiliary device created by the parent nvgrace-gpu (in-tree
> module for device assignment) / nvidia-vgpu-vfio (out-of-tree open
> source module for SRIOV vGPU) to manage the EGM region for the VM.
> Note that there is a unique EGM region per socket and the auxiliary
> device gets created for every region. The parent module fetches the
> EGM region information from the ACPI tables and populate to the data
> structures shared with the auxiliary nvgrace-egm module.
>=20
> nvgrace-egm module handles the following:
> 1. Fetch the EGM memory properties (base HPA, length, proximity domain)
> from the parent device shared EGM region structure.
> 2. Create a char device that can be used as memory-backend-file by Qemu
> for the VM and implement file operations. The char device is /dev/egmX,
> where X is the PXM node ID of the EGM being mapped fetched in 1.
> 3. Zero the EGM memory on first device open().
> 4. Map the QEMU VMA to the EGM region using remap_pfn_range.
> 5. Cleaning up state and destroying the chardev on device unbind.
> 6. Handle presence of retired ECC pages on the EGM region.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                           |  6 ++++++
>  drivers/vfio/pci/nvgrace-gpu/Kconfig  | 11 +++++++++++
>  drivers/vfio/pci/nvgrace-gpu/Makefile |  3 +++
>  drivers/vfio/pci/nvgrace-gpu/egm.c    | 22 ++++++++++++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/main.c   |  1 +
>  5 files changed, 43 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dd7df834b70b..ec6bc10f346d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26476,6 +26476,12 @@ F:	drivers/vfio/pci/nvgrace-
> gpu/egm_dev.h
>  F:	drivers/vfio/pci/nvgrace-gpu/main.c
>  F:	include/linux/nvgrace-egm.h
>=20
> +VFIO NVIDIA GRACE EGM DRIVER
> +M:	Ankit Agrawal <ankita@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Supported
> +F:	drivers/vfio/pci/nvgrace-gpu/egm.c
> +
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
>  R:	Yishai Hadas <yishaih@nvidia.com>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgr=
ace-
> gpu/Kconfig
> index a7f624b37e41..d5773bbd22f5 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/Kconfig
> +++ b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> @@ -1,8 +1,19 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +config NVGRACE_EGM
> +	tristate "EGM driver for NVIDIA Grace Hopper and Blackwell
> Superchip"
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)

Should it depend on NVGRACE_GPU_VFIO_PCI as well?

Thanks,
Shameer

> +	help
> +	  Extended GPU Memory (EGM) support for the GPU in the NVIDIA
> Grace
> +	  based chips required to avail the CPU memory as additional
> +	  cross-node/cross-socket memory for GPU using KVM/qemu.
> +
> +	  If you don't know what to do here, say N.
> +
>  config NVGRACE_GPU_VFIO_PCI
>  	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper
> Superchip"
>  	depends on ARM64 || (COMPILE_TEST && 64BIT)
>  	select VFIO_PCI_CORE
> +	select NVGRACE_EGM
>  	help
>  	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
>  	  required to assign the GPU device to userspace using
> KVM/qemu/etc.
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvg=
race-
> gpu/Makefile
> index e72cc6739ef8..d0d191be56b9 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/Makefile
> +++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
> @@ -1,3 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) +=3D nvgrace-gpu-vfio-pci.o
>  nvgrace-gpu-vfio-pci-y :=3D main.o egm_dev.o
> +
> +obj-$(CONFIG_NVGRACE_EGM) +=3D nvgrace-egm.o
> +nvgrace-egm-y :=3D egm.o
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrac=
e-
> gpu/egm.c
> new file mode 100644
> index 000000000000..999808807019
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights
> reserved
> + */
> +
> +#include <linux/vfio_pci_core.h>
> +
> +static int __init nvgrace_egm_init(void)
> +{
> +	return 0;
> +}
> +
> +static void __exit nvgrace_egm_cleanup(void)
> +{
> +}
> +
> +module_init(nvgrace_egm_init);
> +module_exit(nvgrace_egm_cleanup);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> +MODULE_DESCRIPTION("NVGRACE EGM - Module to support Extended GPU
> Memory on NVIDIA Grace Based systems");
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index 7486a1b49275..b1ccd1ac2e0a 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -1125,3 +1125,4 @@ MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
>  MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
>  MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for
> NVIDIA devices with CPU coherently accessible device memory");
> +MODULE_SOFTDEP("pre: nvgrace-egm");
> --
> 2.34.1


