Return-Path: <kvm+bounces-29595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9279ADDEA
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59FD1282889
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA4261AB508;
	Thu, 24 Oct 2024 07:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KkNTpk5I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D6017B51A;
	Thu, 24 Oct 2024 07:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729755702; cv=fail; b=Ct5hz3hgrWAz/gerqCn1N36Uwht3LR7EmyUoTVMWM9IllG36y5tss3ye2Xw0lYn/cZiWhI5q1pwAwQg7NLUBDAodDyto5xEflBXPa2BqjaOQGpSQyKVWRE3o3gGnBOBBjtEQLavEmNN6pt5YewG48JgqP6AWzg/zsffjXt6VlZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729755702; c=relaxed/simple;
	bh=4MIwzfkZV8594TcBStfwwTMfaRfPjnbeG6jvRS7w+lw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JZAhAdojzKePMNN8+P8tzN8rLYWdN7ACrZWVP9nAllrOWql5VVYb6xyc7cXTktCygQ6V3MSCt9zwsewAEctlF4So9dodtC4s6ZL/ZqpQrBVGo3b+t+WJ4FbR3VkdAhmy/uP/u2bAN8oWVuQhIl3U5y9N8QSd31XAjsxalSr8iRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KkNTpk5I; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729755699; x=1761291699;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4MIwzfkZV8594TcBStfwwTMfaRfPjnbeG6jvRS7w+lw=;
  b=KkNTpk5IRl0OurV/NIIR/Fk8nrjmdvZjhIzjgIeBJWvy/YUS7p+3Hv4R
   ipB/yDzv69MhW6aqJwwHEnhdEKaM0e0ZETz1YPa++WbvhVsyNPGTuyyfS
   drp1C4iqE6E7w5XqSNLy4H8N50/hNbpTh/x9Xkf7cCcjYtbTaDSRA5Kio
   oyWXnGzyWNA7q8yl/quP71REbGK00YUglX0UZcCmX1yStoVBu3K6J65WU
   5+Ge6N58sQFgCD2Uz7n2BHc/nRN+hqR6X9AKJcHodS3x313Gatv/vTP0P
   X60nxqg0AQtUtNL8jVgxR9Nb8qwp40vrzAatAvL0F/LdOQ8Ns1JBXvu34
   w==;
X-CSE-ConnectionGUID: EvIT/O6uS52m2yfFalR4yQ==
X-CSE-MsgGUID: K9/+bZt/SvGYiC+FmBZtHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39915367"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="39915367"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:41:38 -0700
X-CSE-ConnectionGUID: uW7fn0CaR2+9gT5P/eIwpw==
X-CSE-MsgGUID: yjXfatrfRBCJIrcQ9nUC0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="81333293"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 00:41:38 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 00:41:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 00:41:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 00:41:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OIveGrANSr5d5Q1yY34lmFpPyQ2BXod+Mlm71+uvCHG3i2r7MzD0NEejkJYITWKZ+06RpSMw9jNA3v+wFdVXq/qU5Aeh9J2Sy4++gyMK3gn0K0KqlzzzAcBE43WG78JkKOQUG9Wprw8W3pCOjseV8/4Ed/SkmiFu9aRdoLO1dZMR5pNlndyPytieVo2Lt9+7l8veJtcHyWmQxlCzuXFFvEZj5rFC0OiM/j7AHaxwfxhF06VDlcQeW+LPNN3y05CtVf59da2UDz0jZ89uJ50OpE1O+IMCCzyoPpbyE2hftYzwHenWl0BBuV8mEdr8QHh0V/fn2NqLw94HLW+AcFmRqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4MIwzfkZV8594TcBStfwwTMfaRfPjnbeG6jvRS7w+lw=;
 b=mBn5+UftVgFzlNcpV+wu/DLb9Id+GxTfr9K/FVMdi7pBJzR57dyKeZq/qQK+q6BwmLCbh4cw+M8bCJXY46pgJ9pTbHgKQJwFv9OUxetYhsSJta3vdwC8y9FJjhtQnvuct/pxn+Wyll0yV2pTaj/a0r9kzTYfLUGb4i4Cg+oaq304yNRze02O646e9cUEKkkhVOnRxamqpKSUG+u92VJ3RBTz0+a+b1UTiUcdfnV2qdt7HRmKFlUt2m6XrMUeyMzOFMzvW32rtdYmvCmj6MBIZcxw89H64pBvMg5rwPW3JkuZRcIxXvGjdIoaYr0KOMUS39s+lJanFGSlOBTL/ebsWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CYYPR11MB8432.namprd11.prod.outlook.com (2603:10b6:930:be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Thu, 24 Oct
 2024 07:41:07 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%4]) with mapi id 15.20.8093.018; Thu, 24 Oct 2024
 07:41:07 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown
	<lenb@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, Sudeep
 Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin
 Chen <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Mostafa
 Saleh" <smostafa@google.com>
Subject: RE: [PATCH v3 4/9] iommu/arm-smmu-v3: Report
 IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
Thread-Topic: [PATCH v3 4/9] iommu/arm-smmu-v3: Report
 IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
Thread-Index: AQHbGmel2TEKN5TpTk61hqDn7h0GMbKVm0Tw
Date: Thu, 24 Oct 2024 07:41:07 +0000
Message-ID: <BL1PR11MB52715692DC138EE3D8D4A5AB8C4E2@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <4-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <4-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CYYPR11MB8432:EE_
x-ms-office365-filtering-correlation-id: 0f34ec2e-0173-489b-7c0e-08dcf3ff38c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?yAu/ofKd7ZUE9JCg8obscIkGVf9Pe5os8PuJe6946vXKvBLN0cdOpkJVMjJ0?=
 =?us-ascii?Q?IrlIyF6NmI1lswxchGmik/D53j41sKGv0RXm/foZaOSWhvAszaq8M2F7hzYg?=
 =?us-ascii?Q?zHODmZEzXNLRdrHy1VHMl4beB1BNiUrOlEFydgj07w8rr9Zri4DYIIwwSiYZ?=
 =?us-ascii?Q?73MBM7Nde7dU/J7HpWTREihclUfEWOILPF7enzs0hmSMSwx33mQKVUcP4efK?=
 =?us-ascii?Q?d+QdEtcu2okU8HcLAKVoe+Crj2Qo7+3snC9KEFpAQHoD+wnocDWXDKuYa6Kg?=
 =?us-ascii?Q?2B8zZy0MYiw1JWj5krEUxS4u0nvli76NaIFhpzDuv7tRiMgQIrKrUc+6NWv9?=
 =?us-ascii?Q?vxysWfk16oTP3Tvny8Lej4iyzp1yJkTNkxMufjkrV5Uv+DA1c2DPiJNpvLj6?=
 =?us-ascii?Q?5kB47LH6Ri4y5lJnA0IUzwXpjK20yhbtWD89brxWHFZXmrdn217KtYRjqs4a?=
 =?us-ascii?Q?GXD6e3nkHrcQ9JYIcXSJmJbO49GgbohZsBrh2I0zbbDGJdpeqERRh4cQ6UW7?=
 =?us-ascii?Q?KqKsLUeyR5ENsSIvL+i+BTo+o63VrwjXwbu6vHqeEEDbzNjEqfGcezNJ+RU+?=
 =?us-ascii?Q?L/Gv/4g/vrrSN3ipKt0psjgbzmEmkpg5uyOCiRjsuiw9DV7JdQMb6hVyGIwT?=
 =?us-ascii?Q?3AuFflKYkkzhqaGt/auZHG1cSIMiy9y+S5rHDTCN6fJ19q5e93EhDIP+xT0q?=
 =?us-ascii?Q?QEs9qk62R4MMU6TfC73P7ZHv7uYziU4g4Jd5JLQfoRxsVioAoR+h/KsQGYX9?=
 =?us-ascii?Q?wk/FTh4FBMyCq2woGN8INmaUcDFznQW0oVM1rNWuIGejMDEjINhP03Q072qz?=
 =?us-ascii?Q?FvONZMd9zrZZz/oH3zCH0hdWehyt0azxHS6ClAgLeRqVYL5lqdaKFRHQVgCj?=
 =?us-ascii?Q?v0SDMb7Da7cMYz1FuGjmZpppBZ7wFDFrUYYKafd91IIKDF/iRvRLssCyPOVE?=
 =?us-ascii?Q?s6V2CUPZGzdS80+rg0epse8cL3lAjnz1o2AcAf3QvTDOt1a2k7ehXjZJEPfx?=
 =?us-ascii?Q?/0zVy8au5JGC51SA6WUsLxpZ9vwkjUIjSqEXbWUHqD9THicEG9bRwYhF+j7+?=
 =?us-ascii?Q?JQwj8UJZhFxeVqW/9XG7yvi8zQQShLI3xDDRRS+Bjal4tGAt985V1may2nrq?=
 =?us-ascii?Q?TyHOFV+N6TeUFbg50Crd5Bn01/WluL0Mg7bXflx8NrJG8h9Xbpzks4iQBJFg?=
 =?us-ascii?Q?Fvs1frZPdNjYAKh+iKyp07NlqDP9UjpaPIWtttLIoDG+9RC7biICVK+BWmsM?=
 =?us-ascii?Q?NQw9GzQ5U9NcbNprQrYha6AVN6PsmzOKicw3Exp9bq7ARCpmzd8A59bJz8A4?=
 =?us-ascii?Q?PsTY1g7Kph2CO17mBO0JVK6hEsqa25lN3o2Xkp1pSBXova4NOcLndY9sfB77?=
 =?us-ascii?Q?v5ou7UG4+547+8DTClJ0YVLP9Ywv?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EE4a7cXkzSYnZUFhZDfV7bVQVVFuM8slreFZ+sgIVRiFFMb7TjJov0jUMzoK?=
 =?us-ascii?Q?X/zQxeq+6FIaqO+LREysAudlwpOBkopieg0MZvv6y/Q7HfDbvwjRMe7bj+k/?=
 =?us-ascii?Q?7AB4yhgNYjzF/wV1QV1ry1QXKac/eyEOhfvJuAmkvkwETn2lml75ouC7NKD2?=
 =?us-ascii?Q?YqjMI3nyPobt2T0QIg/aVDH5wrrZUqFP2MPegdZPl9cQGxcaRKMTk0png2MJ?=
 =?us-ascii?Q?c8hEwarwYSXZVL6IVUZ5oC+THGr54e1aAdJnmp9Gnf54uoDLCWvgFW7nkjGW?=
 =?us-ascii?Q?fTIWV+DUDy6IOCd4jBGog9tYfONw9jIXiNTh6ZuMbScwxSpg+tSfk15vigXA?=
 =?us-ascii?Q?M45tjOEuumcAKP8sHu05GDWy/e1jAezj9G0bkxz4/Nwj/q8KuOUK3J+h4lnJ?=
 =?us-ascii?Q?+2jboS2CSwP/w+HkHua2HV1fE0OjQdt0WAy0ocrPOS899erdKpdwCdZAaK7+?=
 =?us-ascii?Q?TIudqv5Cx60Wk6scrMeIXb4O0awoOM4aJcqOKnHDoTMqRvMnVQeL2Ns327uE?=
 =?us-ascii?Q?g8XVPOmwGcUrzTLrvnqzgqotB3+mUEyEr4rFokofQWNuYgbSbrR82g71BM46?=
 =?us-ascii?Q?drzTsoahbA0JJ9bJDc3s38We57SryHPdxv5xPqLZx02XActB9f/9cgyBAHqB?=
 =?us-ascii?Q?ZeICkylyjHZh8rsY0r9fmXXy3w3cGRrdWhg2mU8McYh5adkujkqSe/ncUWwz?=
 =?us-ascii?Q?CVpYffmnOPtRKBeuaGPGnCSWiV36bRrCFz/nux4VaIfdK2niNi/qKy8xnF+G?=
 =?us-ascii?Q?Rd5YS9xU0spn4hB9yP3e5KrHfNFat9Eba5RUVa6QJmIkuHNNti3m3sk1L/Au?=
 =?us-ascii?Q?pKBir55xMPDUSRpUR8vB7RY5roEPqJ7/4wn6c3ip1gGLDcBEs5QD0us5p5bp?=
 =?us-ascii?Q?yMG0tperIjAjFMS1BIYi2fa9G2KcfPg6xUXX15dmB9zOgcKvAPa485SGoAPe?=
 =?us-ascii?Q?PFnHJm+aa7BvS+/xuS7DdQmsyo7tD8X0rdbTMsros+Ju1EhzEFPZ3pGepGT7?=
 =?us-ascii?Q?ddYaNBd5WUQC75Qn8RdpuCQU8cRy/AHksQcIIQiQMXggbYTUZWkdKNorUkoi?=
 =?us-ascii?Q?4hiXoW7PJ9KsqOGmiWjJ1H8FPPCC1Ecy5lh9r6Mty/NC/xKktSvNfKFmq7eT?=
 =?us-ascii?Q?QTHfMAyAQWtaFAnHaPc8R1W1KliLNNfwhyD20Bbo+tWqeEAjbJPBMDffGwCS?=
 =?us-ascii?Q?nsL+7MC1Ggj5pQWdrn2+K54sgMzVtz0MWlZZzJynqexRWN3z3kZEbRrrRkiD?=
 =?us-ascii?Q?XQLtL4UAoBs1cebnkIlgUl2g9Z7os9UNX4kuWD6syKYXbIVaBfkukwtZ1e0U?=
 =?us-ascii?Q?AP0znawxCtdvO9NrzdgtWAVhxbgnLYt56NsdeKcmeZucyR0YTP459Yl6C5ST?=
 =?us-ascii?Q?YkG+GuyRx4Ts4mvOPRFZRQ2IOs4tvnZTpSWVVvt/qxPI0NODr36KM+HF7vBu?=
 =?us-ascii?Q?MJRH9a31xDPGSjO3V/ts2RIGWlN6D9v8798twELOY9VtuW/TTwcHKvEWXRW4?=
 =?us-ascii?Q?ODCrKc2BfAGzAO8oqrQguYp4ykRbOBpSEg0g7U54GLOl7Ho4XPKiW5DcC+YN?=
 =?us-ascii?Q?a0kF7XlQEQV5iKFJ4kdkBlxY6szHzZy2VcDc7HeA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f34ec2e-0173-489b-7c0e-08dcf3ff38c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2024 07:41:07.4036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gDwDCPApK99CAc98SGIziJ3mKZJ2c5skNDg7aQzcxeRXHBtDpFqFqeTEARMnQHtn0tcc9gP8BoxqV1NmPnm3XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8432
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 10, 2024 12:23 AM
>=20
> HW with CANWBS is always cache coherent and ignores PCI No Snoop
> requests
> as well. This meets the requirement for
> IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
> so let's return it.
>=20
> Implement the enforce_cache_coherency() op to reject attaching devices
> that don't have CANWBS.
>=20
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

