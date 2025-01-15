Return-Path: <kvm+bounces-35513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 619BDA11B9C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 09:11:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69E373A43FE
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 08:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AD9236A65;
	Wed, 15 Jan 2025 08:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UP1a/lUS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A394922FDFB
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 08:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736928676; cv=fail; b=Q8RC3KU/xESYTgoc5ChnbpqYPJ/qyH5ua0detTt0ZOqf2R3Pe713u+K3Q/pKitstji9GzZeBkeq7H7kI4SmgSwzKqIJsh3maqmFInAXugkoyqrVtr2gFmYbqBOaT/lzqdOhI8ot7AJnklpdcvnXw8hYFJpyKXYVG3zm2P0xAdlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736928676; c=relaxed/simple;
	bh=jvkqaXGNyQmCQLmvb5IE4wN5J9mvasJnmGNCF0YNNos=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iwZvvAH8+kaFBLIukk1jREFUtpG5pM4+4Ei1QPuYQFxlohlGbHYJPt2EsqvNYGWoiD5NQnm6BFrzZMINQLsk/qC9cigJ+zwtecEW/9/8W5rZ81lyygbbezfxCdK2cXzQdgPG6sP6zzCV/pMJsEtB7PvM6kUW5hqbGrrRu02s9QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UP1a/lUS; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736928675; x=1768464675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jvkqaXGNyQmCQLmvb5IE4wN5J9mvasJnmGNCF0YNNos=;
  b=UP1a/lUSvTOToPuUcXuDvSZk1TTmf1nLIEzRMhQsl2hiCb4zoNC86IzQ
   DAgrNtMzNz7aZSf4mCTPPpvsGykXWYagHsAqlFatFUubmI1Q9mNyjQgu9
   +9tYzD9HXVdRQeuJ8l08CDGS7zPqUipaQjCnZZYmIYcnymwDYzDELDyYY
   zlwx4nONERRzezLFlcr+qDSx6UxNN7riXJQDZnBL6iuPaGharhsR9x6dp
   d96H2a9Q0i2vm/4MmeptxZ9vhVNdcTd9UGMkWw0XgLcY4TGGg6UJTaECm
   MtJXrKVSZfuWfAjwnkoZjwGg/l7HWn+Q1alUqWvAIn4b5DKVTr24DuZMP
   A==;
X-CSE-ConnectionGUID: CjvpT+bDTo+462YazTH71g==
X-CSE-MsgGUID: LiXc8+d7R3yYYRcfWmCu4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37166776"
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="37166776"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 00:11:14 -0800
X-CSE-ConnectionGUID: z4hj9lf5STaSlFfvxk+D2w==
X-CSE-MsgGUID: Zn3JCQE5Qv6DtDd/fK7JPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="104896249"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 00:11:13 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 00:11:13 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 00:11:13 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 00:11:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=donpB2WHq9jqw/O2cG0URe9dTQsLAJAhIJWacrez4mCI5HpVD0Fb5d42uidmS+6MnwosdnEPe2JMO4XkLAng3rql2LMSDpa88X3D5u+vE9QKfAIVPr/JZ0MPmXgj8szPlqbgicZFvDihGovBoc/7sSDYyv2VgjNnV8IEMc6DqFT2mvxiyD5GRPjma3aNi6gSHTm+hh3iu1xbcyS4XEV2rVNm45ar+WN5ql80mZSQX40U1vzkWd1Rr4vyQO8D3Z7qD3QpgxQo+mpO4T6i8AAxq1/0kaHlmp2rFp7fRfWJXXQSmdePwrPkUUJ9w7nhPlC7pLL7DI377U2+36eEti0JDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0UJwaqw6CT/PAAxarajJYttshJJyAZK1Fp9fBteoeQ=;
 b=f+4A70VBXH1XAj0VqrgaYmbqJnSc8/JnXplC/7BaRYz6FTfM3hp3KSSRQIirihM8klkauxhyghHe6htKY645liCSgq9Ff1DBOtqM/UVwPDbW4yGrejewV9eQBVpOTXWPd2Wdh0uZJps6k54+rCoX4OfPs0Jxs9uADYOVnlmU+lyLL4IRQKLjwYQnVI+T9vOEx25cWTIsjHU3kh4N5BnghLI0yvc3BH2c0WLtIWyGGB+ME0GbkZZuxgH/fGNif8afvOPIiXPnvRqx21fCyjGB7gdAimqEHw87XIEJrfx3r0lCqIMpvI/GQfvjMqkxrKD51QIhphTnmFccwr850dOKPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5062.namprd11.prod.outlook.com (2603:10b6:510:3e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 08:11:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 08:11:11 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"willy@infradead.org" <willy@infradead.org>, "zhangfei.gao@linaro.org"
	<zhangfei.gao@linaro.org>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: RE: [PATCH v6 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Thread-Topic: [PATCH v6 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Thread-Index: AQHbUhrqJ/Dm+j2e80GNrVcgu6s3kLMXpI+w
Date: Wed, 15 Jan 2025 08:11:10 +0000
Message-ID: <BN9PR11MB52762121B40BC72A2EAAAC638C192@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
 <20241219133534.16422-5-yi.l.liu@intel.com>
In-Reply-To: <20241219133534.16422-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5062:EE_
x-ms-office365-filtering-correlation-id: d8f930d5-2f68-4fbf-8b83-08dd353c2c0f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?/6LZJV5Nod2gqPLSi1DyZI1/FmZJq/BI1G/T0cfAIDe90LqaXrX5R3bDXBLh?=
 =?us-ascii?Q?2/hbft8q7pqW4IsMoYK0w5k58knlmXees7/O5k4EtSWLxB4c4UY15XEQRHKi?=
 =?us-ascii?Q?jDWzqk1e4Ycf51TFaXqkyaErxdQ7IYteSgg3u3Kz5yN2rW2cBCIWCdlKpQg7?=
 =?us-ascii?Q?Z4iuwvJYcabP4nK5XQDRtsnooBe1k/j+7XLrfNGkK2+A2VfWAKJ09mM9M4h1?=
 =?us-ascii?Q?lQaKUVAqovoWAXMVg8AkEdAI1T7ZrJUO+MjLXM4nXeWrMVY5urKLkA5+9S3k?=
 =?us-ascii?Q?Z9BXdee/JYXhkMFnIxiTsxsOrLOGdVwToiLQ0PC1RE9am1NW8KTNWwNmwyIv?=
 =?us-ascii?Q?iKilS9pS+EXOefwoYsjhsIZPf/pPraSv7GV3HhRoeE38em1VYZ3YaMAnwLTk?=
 =?us-ascii?Q?y6OudRg9VGlNGXINn+FpFaVEl4vTYR5k4xljOKS/j/30/26ch3pFBKNddXJ4?=
 =?us-ascii?Q?WK/AITzVuBnQXTsuudvxJ7tmU/tlUFtFei3K//SGvcx1pefbWPeybafSDq+e?=
 =?us-ascii?Q?Gg8xnilsslaFFVlHVa4g+yQJEFYdjdAhURKYU2ElzPoPg05RjRktKbzJ72Rp?=
 =?us-ascii?Q?rx7q3dJGCdSMPp0UmRQ0oeYKvZVdYFzSTCBDEtcOw+HF0tya5H90UgOz43WF?=
 =?us-ascii?Q?nvE9pTUoAcsHRc4OJr6Zg1WO56PRICBb+ubgZ4x/gmCOW1ntcaMo5E6hcBOh?=
 =?us-ascii?Q?QyRWgjfCzlzxoR/v4Dm4Gdk2KqphUxcSdehaINUdrN3EXdVHCmNNJdVQqw9u?=
 =?us-ascii?Q?RyqWCfQ/pXrBikJQUBMOb0X7XX1AZKzbVBkNcWT2GJ+XVbJvTx5fgyZIi9Hi?=
 =?us-ascii?Q?YHw3iihggLlfVlT2opiml6NyiRhZKl1gMuaT1/CIBY6KzhvbKO0sFA9yjvCn?=
 =?us-ascii?Q?WpsIO+7En1Rb92cv7iglihcTCrHsbWf0v+nMbgBHrl7HrB4fMXDKc8ftv3+f?=
 =?us-ascii?Q?V/a4VvXtKH9e0o7Z5s4nCDQb/P4VV+UVzdgHuNbuD31zN2SUHJm3aDv8WbE+?=
 =?us-ascii?Q?u2sIr2lF8jJcqpNrDV7EnkAtFepUMvRbOtYOEW7lemVfIlDTKP0fJPA5AA7K?=
 =?us-ascii?Q?B30qPkdxwrrLcJPYq0heTnVTwi/85O5Rsr3V+cL0kb2AsK4QGXRSDV6xGpcV?=
 =?us-ascii?Q?UFVsZ5CQcoPUJLJJAc3pqpr2GQ/XtSjuzlkkdfWkcMURmyLkJhB7LX+Itjov?=
 =?us-ascii?Q?TSC/L28I0DtLLmzZzNeWMybO/vP+HzimcwQOy1uIzuTlcn2XJOMr+62HXrQa?=
 =?us-ascii?Q?t/8zBbYhhKu+xxo3qXzeHv02BDYBrogwhn7tIyd/J4le8DtHswy5h7nN3KU+?=
 =?us-ascii?Q?Ze6PA8R/rch1pxME4ld1F/g965Xtnl0HVblf3L11gMzcl5scsjqxRMFd9hvY?=
 =?us-ascii?Q?csgGzPspmjZaM0XG6AAmRPqgME6kYvCio1e4qjQQaztIUboYKLXcu+A6BLGo?=
 =?us-ascii?Q?X8Yf3Zmm6SXSGVELTs8s4yXGYZaWcXSZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RxKTaDRU9x2W1w9WwM4iBE410SHju0VzDWGXI2fRn5ls+NX2Xe4fH0JS3sJ5?=
 =?us-ascii?Q?W4ac6nFpUqbLqWZdO02gQXqVsr2Ui4JUA4xxQLlKVju3asn1lst5ElGm5SVw?=
 =?us-ascii?Q?gWCozcTcvfmbK3M/umDc05o2oqF5sKQq6qPavVcF7RcfezHykitWKUopOHw2?=
 =?us-ascii?Q?vBnaR1/fEEvtt1sw0ePaaMDqRv06RyPJtBUwZvxN4b5LG7fqLmlg1g21Saxd?=
 =?us-ascii?Q?5rkd93H3XEe1rtuB6Y7NVuKbensseOK3KPTsUjzk5ydmN12W+VFlwCThVAHs?=
 =?us-ascii?Q?C0uqeCQ+bJOpXLU826Su8IlqV3Z393xkqYiJ3vcCAh/7lOnhpC/P4K/RBO4v?=
 =?us-ascii?Q?6N6dbR8phycyJ2MNOCSTSvMYxr1wDZC2KYDzQywjwvLGknbz2WNh9/3FlNW+?=
 =?us-ascii?Q?5wC0/VH/Vl3wOMia7arZ3qhcT3hjFyyv9Yn3Y9InasGuUdGzS48NU4Z3v6Ox?=
 =?us-ascii?Q?uuR5tfbveycFicb4iM3pjbXQVYmniLxCtgW1o4fyum6ar7yvtwpg42R7zXPw?=
 =?us-ascii?Q?E/nXKvYRP49S728SjsnToIdKvWW3NCPFxvKqQfDihRHyxzblKQZzNwLEpZ9D?=
 =?us-ascii?Q?0Fw62wJJXvo6fOYERUqIAKPoIn+SDB0bRkJsLi/Y8Tc1bYs0XkPmh3v5aCPM?=
 =?us-ascii?Q?hciHssglzl0FBXDsbsNAIf+E4FJ8SGLAIbhnd2RrWsG4XJzW2sdgkcDbSNdp?=
 =?us-ascii?Q?wRIxx5j8z+RuvZBAU3aklf4c716cTd+xdq2n28GL+VSLT8lDQaOYaV51i4KQ?=
 =?us-ascii?Q?jnHvDNUkc3E0wirSfIPqdowOzxffKRQk8eplcIc8gCo4ya2b9SZ2186bR6JS?=
 =?us-ascii?Q?HHtgX0lXf0voBbpA9o8X4KfLrco3dMJPaD5aKY7Xsp7OpyVcHbC5erPHN2L+?=
 =?us-ascii?Q?iyQ4XGAeikcszgl4x9wRf9ZWVlpdb0tX9JdD8S2ioAOTVbD9C2dGJup8Aygm?=
 =?us-ascii?Q?veXvpAouldlVY+4rdqU4G+bBGh1nGahHRPzq5v3zKWdcUZqFfIslaEWhKSZs?=
 =?us-ascii?Q?b8ck3dg6PMo4ax008yWR+ZBgQA0j069InTD5UgNNZzVte67vndVSV0hxx9JC?=
 =?us-ascii?Q?GKxBrnsTNVFAu5NGvrXINPXmm9ndqSdpy2eh0kAWemHJ61th4w9+J6BcVacb?=
 =?us-ascii?Q?uTJfZK5XbnzLVNHSiJoZHzhqGbJaCqP6Mo7JF9cLOd7z/laYuvGA+xiQQFEO?=
 =?us-ascii?Q?/l2rGLojmXkeAxS8NrJ+ksyGDDV9YYurseZvk0i1f0lj1DVlN91KB50qmFVQ?=
 =?us-ascii?Q?P0GXwdOuLinwxbTpqfkkjE66QziyZG6W7n0m5rXjMIbFMwTsqcXs0sCP1rGz?=
 =?us-ascii?Q?rrHwE1HUPMtBwLqgKbwzF0GXD8wvFE71bVV1HinsAHwhNFxmmFqmuh2z0CB3?=
 =?us-ascii?Q?k2WKPXl3Dhifw0biBdJTpvHEOW+9DDTW2GY/hVSWOnWkTS86Q68X+mQdtuBH?=
 =?us-ascii?Q?LGU+DwbfYXEteHtjczcIcGn116zZnly0CCo1h1PA1EbGSIWPQIAKVVVp/URa?=
 =?us-ascii?Q?Y22GBFyzrmYp7VL7NtxVFJ4BYpc6geUDJlNpbpaRd0oOz+I+Tj6dJbEFVZC1?=
 =?us-ascii?Q?2IW2xNXN3aBpdU0jn7f0tACMO+dCdAGufg3SZd0i?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d8f930d5-2f68-4fbf-8b83-08dd353c2c0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 08:11:10.9904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qf9WZXc2OAyCNh0aN8nP+a0fkaglzd50561oKkx77RK88DfC1V/ennRZgJoipklzhDVVm3UfWLvGwrIs2+t6Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5062
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, December 19, 2024 9:36 PM
>=20
> @@ -1317,6 +1320,34 @@ int iommufd_get_hw_info(struct iommufd_ucmd
> *ucmd)
>  	if (device_iommu_capable(idev->dev,
> IOMMU_CAP_DIRTY_TRACKING))
>  		cmd->out_capabilities |=3D
> IOMMU_HW_CAP_DIRTY_TRACKING;
>=20
> +	/*
> +	 * Currently, major iommu drivers enable PASID in the probe_device()

s/major/all/? otherwise it's not correct to make such assumption even if
there is just one exception.

> +	 * op if iommu and device supports it. So the max_pasids stored in
> +	 * dev->iommu indicates both PASID support and enable status. A
> +	 * non-zero dev->iommu->max_pasids means PASID is supported
> and
> +	 * enabled, The iommufd only reports PASID capability to userspace

s/, The/./

> +	 * if it's enabled.
> +	 */
> +	if (idev->dev->iommu->max_pasids) {
> +		cmd->out_max_pasid_log2 =3D ilog2(idev->dev->iommu-
> >max_pasids);
> +
> +		if (dev_is_pci(idev->dev)) {
> +			struct pci_dev *pdev =3D to_pci_dev(idev->dev);
> +			int ctrl;
> +
> +			ctrl =3D pci_pasid_ctrl_status(pdev);
> +
> +			WARN_ON_ONCE(!(ctrl & PCI_PASID_CTRL_ENABLE));

If not enabled then also clear cmd->out_max_pasid_log2?

btw pci_pasid_ctrl_status() could return a errno but the check above=20
treat it as an unsigned value.

> +
> +/**
> + * pci_pasid_ctrl_status - Check the PASID status
> + * @pdev: PCI device structure
> + *
> + * Returns a negative value when no PASID capability is present.
> + * Otherwise the value of the control register is returned.
> + * Status reported are:
> + *
> + * PCI_PASID_CTRL_ENABLE - PASID enabled
> + * PCI_PASID_CTRL_EXEC - Execute permission enabled
> + * PCI_PASID_CTRL_PRIV - Privileged mode enabled
> + */
> +int pci_pasid_ctrl_status(struct pci_dev *pdev)

while this value is read from the ctrl register, it's not necessary to
make it explicit in the function name. The caller just cares about
the status so calling it pci_pasid_status() is clearer.

