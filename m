Return-Path: <kvm+bounces-31072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0441E9C0130
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:33:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 252D91C21244
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 381711E00B0;
	Thu,  7 Nov 2024 09:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="meShoq9u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A4DBA2D
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972023; cv=fail; b=bTQPN+Ak0x2krwzEparlqw46YVjRqfIa0AAv7bGbuC3Y7XxikjqCA2t3QexfE5rrsKcdaMRdKWsRW/xnAQRTN16X6MMKFBtXFUhFmlXRu/D9mPbv/DoNa2w1Q1QEfYQV+c+sf1PD6TvDHO0UTVwmqPqi7TRRy9sUGTlbh6TnVDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972023; c=relaxed/simple;
	bh=A1IdUGvjqKcUCQdckSwJ65bWQtPZ8N8KpaHKSNDJwlM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PPuJx2aB1RneW8TcX01HgWBxtnD16y67EeO8W8Y/wIR8KN+3v3CtcVdeAP7nPnV23vCpcCW/62vgQgJ4y+U8hOL3rMnixF3gFfgZzREa5nGCEbfOAXxcsTxkt+h7nNj0qFtr7FODrsTT0Al6lg5DFvhYhYPDF5cuHo1adtb6Dhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=meShoq9u; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730972021; x=1762508021;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A1IdUGvjqKcUCQdckSwJ65bWQtPZ8N8KpaHKSNDJwlM=;
  b=meShoq9uBQgOp9fEbY06EwidIbxvnHZtoJb73nIzBqsiuqaF7Px1hIMC
   ScbaLOFvcMryd5Ciz7eDtnn9ukZRP6MEf2DPHDfnh6YW86Qox64sS3pUv
   Ala3bE/wjZQeXNeIfHg/3QG6LsFF6OCLWpkbL+M+kI7Nj4A/lrt8npjrs
   cTdW3RH53fXU8cfgTIbxJdtAUdakiKsOsROQ/DtDy+07i/G4ilaytuTKS
   H5/3pLbT8sGnXQDxdfn4H0OSsngNJiWX8Sz41JebL0FK/6kwOduzbBozu
   OyGDA4vT2+vwica6HICGc11DFREcXuO+EXkLm/V8+KClMMq8Op/uF9FvI
   w==;
X-CSE-ConnectionGUID: pyVLTiKHRWq+tvSct/z9Hw==
X-CSE-MsgGUID: 7n1Iy0hGR5m7wafwM+mAJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="34501785"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="34501785"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 01:33:41 -0800
X-CSE-ConnectionGUID: mtziS22bTNaOmRXt+X43RQ==
X-CSE-MsgGUID: rpNDWxZhTSK8sPUAA2GqhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="85127833"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 01:33:40 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 01:33:39 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 01:33:39 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 01:33:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=erVIIA6pa68tpiirxZhJpR8t5PQp6CiK6fnFMqHCeYES17oXW0Uj3tBMOc2BEPl4EAsm0Mm0XGtY/nlyAAP3Q1Zi2JYdTqgTJ2yQVH9HjEQQe9XLyd+IVNWnBkqUkQyYFebkqpmEl88Pjcvh3CxxCcgpIxP5XYIc2NV3Td/xc5MZfIKN85Nv2Cfc9BFi6PcPxZAieI3MSHLOccWzZSPMYqRUUNncSXK4YDZqVwF91RZXlToXYnEhZFvD0wsrZGRdSQ2727U6eKzVPoXIkbcnFJ9vaNBcUmGfkP8RZkIZP6fFRqAQsDG58SUpw6vDVFnK4Ru20/eUP/8MTMYUlD1ZSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNphqa87zkKTZ3vMLFDvJEZAQU1DCD5EAY8p73BLeoY=;
 b=CtbYfibm3ZiQyc7NC0sQtFc5RaxG1179BkElqkfW0SUa6A89NDCAmgm2Lib3RFusAmIP3efaRMM6JgAP9/4pkX/1d34iOHpl1amRJYalvUobfgxgKZow7P9tKuVFTwpJ7YhN0TccnHZm0A0Fw5bZZUP5ZaLMQ8LArBzmCEWpQh+NfLZRKcj7z6O+fG3xnLKueOQSu4UwR8r1cvD1tPh78lL5hHhqRD/mjw5JM7f57XPN1yXgVXGZVe30TYQd684P78IdPveFyPIpIYEOmSy98I4LtLbO8sXsECy8ZQcTG1SsJssSqaPjyOmhZc94+3X4Wbsb73TlsIF+gNlEieQn4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4846.namprd11.prod.outlook.com (2603:10b6:a03:2d8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 09:33:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 09:33:37 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>, "will@kernel.org"
	<will@kernel.org>
Subject: RE: [PATCH v3 1/7] iommu: Prevent pasid attach if no
 ops->remove_dev_pasid
Thread-Topic: [PATCH v3 1/7] iommu: Prevent pasid attach if no
 ops->remove_dev_pasid
Thread-Index: AQHbLrxhpEucFvdSo0K3CuKSLprsT7Ko1QgAgAK8ZMA=
Date: Thu, 7 Nov 2024 09:33:36 +0000
Message-ID: <BN9PR11MB527668F5E61584E5EBEB21B58C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-2-yi.l.liu@intel.com>
 <20241105154200.GF458827@nvidia.com>
In-Reply-To: <20241105154200.GF458827@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4846:EE_
x-ms-office365-filtering-correlation-id: d824d02a-3681-4ad2-2e3f-08dcff0f4195
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?jCcR0kel5Gqr7c59CFgNBX8nkaHuHw+4lX41jXCztXx+bsQMxUoNbUEDdiKO?=
 =?us-ascii?Q?cdvUO/8VTy6N/Q2H0U/WoOmFp2cLpXD13a9gWStoOlPTSeAWvVzYxaDRznxX?=
 =?us-ascii?Q?lCACNqBXqrraQfk4IB4iWrOFEeeqWyaRBi6zMD1FDvSgOpMfMIhSgnlFFZS5?=
 =?us-ascii?Q?RvdbhkQX8j/PLD1TN9QfDTk7yg29yCMpJafBGfjvW+8p5dcF6pVo/CVV2X4A?=
 =?us-ascii?Q?O3r2h1rVDqQgsldsdxPEt5D9xbnzwdd0xJXoYHDfR5xkgQhwKMBqQ+YO5Hds?=
 =?us-ascii?Q?6mRl9ZqJz0kzvtvB9PW1YVHFZcB8DcNJU9zT5ZQM9+FA5oUUKHPA6c66G22w?=
 =?us-ascii?Q?8zjfcpVTUSbECpkpuD6XSvcffXyfwM040G6pF/xr0/+pcgk9YyHlu6346YKG?=
 =?us-ascii?Q?9pjGB5bTNw7+v8G8cPIHpU8XnOd2OCy41CLHTj9ZXgW32+jqh36uL/DrGwDT?=
 =?us-ascii?Q?0fyyUSJhiO/4b3mC9eOYzDx9PCdf75/b5hV5fhG1ZiKufcdXu/NsFTE2X2IQ?=
 =?us-ascii?Q?uzpJE3suCZUpHxQIhORc1Mce9nT5SxNNznHlL5ffRJ6XUFkHBZF29ar+Djdf?=
 =?us-ascii?Q?OH3R2Tt0uAWn5fKCLxWRL0If855A/9dyZ9yID9hPCfeaJcSsS6DlXGMMlG5s?=
 =?us-ascii?Q?htbQmgnM8aOCf735KktW+i/bPF5tytSgO4EPqv9MjklSZIq1XzjQMjCVQ28F?=
 =?us-ascii?Q?nV0yZl9cOFps5r0ie/vw6pwdFSAKo/nZEtoWEsrKc8e+TAumotznn7/mb5XD?=
 =?us-ascii?Q?7A5AmEj2UAMW0dYAsToDujNpHdMzUcSi72nj14oLn0MSTxjkDG4L1XGyIGk0?=
 =?us-ascii?Q?6NXZq7lYCWSuER165vlEu/I7O8MDhQuZqq+i7oLJ4tKiJZI+XyaIixYarRml?=
 =?us-ascii?Q?g20yk6bzkAVFXn60yANfUqfTJJOkt3BX+ZfmvRMZLY0RYuEsqloQ9xWWkHLK?=
 =?us-ascii?Q?DVvIGeukE8OR83HMSpI7GSj+PSSElic+jtjdGatudbIuhsMvBP5jq7jp7bNE?=
 =?us-ascii?Q?/D9ZyjeOba78F7EsCE8OoQ4I2SjEd8c0QxfLSSDkR8/ffr4xwsiJxyCvAK9Z?=
 =?us-ascii?Q?S1QyisCyHJVnev7GFDwg7MPf6V5m0K6QehnCS3EmlI2mUwS4qX5/f+72dzNu?=
 =?us-ascii?Q?wkHlR+UM/2f4bJeU06FlODuTJJCGYWV0YgDaBXIL4zuV28Kofj1ZO5Z8Lzvv?=
 =?us-ascii?Q?78Rh4tFpuqT/P5ZpzHjvG3G5VxnUL1c+zuRfalRKmVi0NOuaZvt+SthvwBHs?=
 =?us-ascii?Q?tyKoeVT5dQIKfHk98GI6UiUc/wundjpGYuek4IcjXDG3Kon9hIZboSP5XzSr?=
 =?us-ascii?Q?9Y4UndM+06JUWY8Xnq5yOy+Vm/wIk2K+ZXWkzPs5yhfs3ydWu/4B7TM7G+ib?=
 =?us-ascii?Q?siqRau8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VWmXE1AoQJVYrkQFG3dKn+4XFYBR6tYOm1yhoKcWZ59CfFF/cfMcxiG5a6Bl?=
 =?us-ascii?Q?aXKN7QVZ219/PKw1MyPepCzpUl/Hvpxx2P+2OeumsOy9lYBD2HW97jN9COY+?=
 =?us-ascii?Q?cZWsy24/EJtftAeSYVRv1NMafK2ckqqVTrSPQRrDTVO04rYQSxOL0ChljRJ8?=
 =?us-ascii?Q?FmC7Jrf//1JVsxDb0KkRGSxwGrKhjq9lEHbPhYBRsZtSBuGpIAvg+nlgZ0YC?=
 =?us-ascii?Q?37xl4OLx+VnFYktyfPhAZtFdk7xsc57tRshuq1ADJvrCFJhI+o85FLn1frZq?=
 =?us-ascii?Q?hK32fnZT7HhUdCOksRW9mfBX2H9hFkLcR1KkUJUgeY5fDjkmFSlySlBtpNQp?=
 =?us-ascii?Q?gLIg2C6lJbkU1zrrBH+Q6kRJ+631ss0DGVT+LBW/I/lrntIR8gmTi6nSHugU?=
 =?us-ascii?Q?F9iQLO79w57EH4FJyQwd0fum4GtV4vwWPZ9AxRBHMz8Py+v7yr1kFJ5ULPO1?=
 =?us-ascii?Q?VqzVg1ZfqJQlEhwKzkMCJs5oyV494DX50d1DbMMrdz0a7iLHeRdp8wAEP6Bz?=
 =?us-ascii?Q?rvDkNYb7byV1qPUBnG1ig9FpEE7+Gn3TlMMohjUgOeDTqTKOOmDlgiIWv2rn?=
 =?us-ascii?Q?yZjrmD10r/e8oaHxAIjDSGs8jQrOTPlakEs2Kw6hDIF3lmVR2b2xQT2SiwZM?=
 =?us-ascii?Q?0UPaQb/WxSoCInLJ5exlQoc8fkbkBMd42sS1uSS+G4TIzq6htOqoChMmzf4t?=
 =?us-ascii?Q?zQrXKYLall5+1xgw1UzAOG1c0Y+yKm3Zx2EvHOwnHuZtlk0ajdl/2KyyHmK1?=
 =?us-ascii?Q?5vLYWdonGpoH4fo7SLCWq8/bc23LFEPt7gYuGX07w+2q0/Qa2WQeLVu5+b2o?=
 =?us-ascii?Q?wHa2VDv18eBisdJc0G8FpB/PuupLu0KXyo3Sh379QWerOLfIpbI2zNLu4V40?=
 =?us-ascii?Q?qyVvVxHuQ5Xfae0myKOaYTYXcMeivbNHuWBkh20H7UzG4y0sZUuxDw7b+eWq?=
 =?us-ascii?Q?jfv8KhBTkqMEzv82Cy6eeGoIjPWuptgtgJ9B6h6JALgbyheR7kBefIinZLCk?=
 =?us-ascii?Q?s0ZkRIOacpWy4QSQGM5to5IgAm8ikufJjtxk94FMo2asKCRALEOu2pdB2f8R?=
 =?us-ascii?Q?UWLenmYoeMzB/YxFvXYKN7DFGKLnH2Ql62w3KP/9UnVbCKPSnTU/FT4SGBSY?=
 =?us-ascii?Q?QVNst5z6ptYdNMRVR4WE2d1Lh4rRfs3ziViveV90tIYUFdleHdXBx8A9cm8l?=
 =?us-ascii?Q?W7K5tDsBW4YTBAs68gYz05voZuIM0/vc0IYZrg+ESsLuuxJdbI7LYTr4m+rB?=
 =?us-ascii?Q?CpBmIATF9HYYih/dF7U1ksSrdOWDAGE1QYP7E2oTcSjrucEqH7NZGz6SAcXj?=
 =?us-ascii?Q?ImtTllRPY5mePM4bY7+yUQJYMrG7Tp+JWsG0kAc2HFO7RHv2CmTnr5CEVeLZ?=
 =?us-ascii?Q?Sf+GM/9VGE5JWVtSDmKJSclnUwr5qJdqU/AMLFS0fVjkxx0eUg1ww8UklIwf?=
 =?us-ascii?Q?Dj9sgG+P5JYnBnmbTYGbotyeIYAz8BLmt9bOna2SmmhIoF+ckJ1ic37jEVK3?=
 =?us-ascii?Q?Uk+zwPa6/C/3NYQWKb2rCi9sIaakUjEpi6prkSUb98YXJzp6R9zywxLTYbpF?=
 =?us-ascii?Q?M2HJjB5lA0dUtVuvTgdUiBrITiF+JSKqcqiD7J/Y?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d824d02a-3681-4ad2-2e3f-08dcff0f4195
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 09:33:36.9077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SHGJA6z12fSWbv47yW1yGSSbqwRZpSFeMPOJfsC1B1/mvdvy4BydxEDGxc7xMQpBJnpofOln9NGks7Y5eDyMPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4846
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, November 5, 2024 11:42 PM
>=20
> On Mon, Nov 04, 2024 at 05:20:27AM -0800, Yi Liu wrote:
> > driver should implement both set_dev_pasid and remove_dev_pasid op,
> otherwise
> > it is a problem how to detach pasid. In reality, it is impossible that =
an
> > iommu driver implements set_dev_pasid() but no remove_dev_pasid() op.
> However,
> > it is better to check it.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommu.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> I was wondering if we really needed this, but it does make the patches
> a bit easier to understand
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>=20

me too. btw when Vasant's series introduces the PASID flag to
domain above checks can be moved to the domain alloc time
then here just needs to check whether the domain allows=20
pasid attach.

for now,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

and a nit - there is another reference to dev_iommu_ops in this
function:

	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) !=3D domain->owner ||

could be replaced with ops too.

