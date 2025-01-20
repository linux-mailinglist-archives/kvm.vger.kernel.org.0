Return-Path: <kvm+bounces-35949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A680EA166E7
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 08:09:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34DFD1888329
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436B718BB8E;
	Mon, 20 Jan 2025 07:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TSX0Yl2p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C41335968;
	Mon, 20 Jan 2025 07:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737356953; cv=fail; b=pbS1Pl4JkYg+xTHBepgqKyKAL9vNnwEtTZrWE32omwbXLN4oZfVsadHRnh58cwECQgKirWSE9QzoBqE6dlhJeNv0mZUCxvKNcna3mgF9JgdHKmTvbbTPXphYiQg+eitd2joI4RiSC4MWGVTAXhxqr8bwjSGKyy/u7nORZYhvJMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737356953; c=relaxed/simple;
	bh=gtOwd2kgSdFctj0xKnngg56JRezkZuxqUgnLlWS5cfI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JLWAOGya0Droj7RbJBs2+WGfj8ObFOCzWhy45MMHO3x5Phwn8hve1KfR2xmRHb4Sop7Xd9YJ/aWCqukajuBBIuKAgfiLC98JB+mfEmc24Cf5///5Be+6lOvuaF606jU+dcy7vEvB6KHvM04YMfRgmuNIIZ0TDYq6G4Yb/PZtajM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TSX0Yl2p; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737356951; x=1768892951;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gtOwd2kgSdFctj0xKnngg56JRezkZuxqUgnLlWS5cfI=;
  b=TSX0Yl2pvQ/mEMi14zRhqpTVzUqyq4cGpN2/FK0CVpuSaLW0G91QVeAE
   48mp8peayjfV2US2DfSUXqt8dr08/t4zVupotE7FMZx7gmP+XXv3izDhE
   J0kQIOcuAMh0OhJrUVp7qG3a1flVdqgDLY7N2DyYz3kLr6ENiew7WPjLt
   qMceqBMBvMNArghDYbnbGIV5G5x0TOa0jvHeIjCaVXoohVneLS8NQtWpT
   f5JGCGkap+idbNO+8mdKc11iT3Tyi+xpVg7/n3J3pTdmi90AZMAcpbX6f
   LbfACjlfid3kok5q2GDG379DNCfdn1+eA2aOk2BRZvx0piMUZap4J4FR+
   A==;
X-CSE-ConnectionGUID: NlIUy1vBQWWGOSuIobwkig==
X-CSE-MsgGUID: iVfTSQNETLef6vvZbZo+ag==
X-IronPort-AV: E=McAfee;i="6700,10204,11320"; a="49116205"
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="49116205"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2025 23:09:07 -0800
X-CSE-ConnectionGUID: NbzeKkyOSqOCzQBa++QEYA==
X-CSE-MsgGUID: 8X5uBYDNTE+F+ahUy83ecQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="106942224"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2025 23:09:07 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 19 Jan 2025 23:09:06 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 19 Jan 2025 23:09:06 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 19 Jan 2025 23:09:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L8PygMDDadUeWj/PCMCxtaDxYdXMXLB1raowuhkkvx4ey5NVXneV4t2ppPe7J+2c/UUdcT8iHO4OEbZymUSjdwI7JIEFxQZsZJ5Cn9EGyyFWhUQOXPs28n9CXOpzjSRxh4QEkZqZ2QD/uiwnMq3RCKc4EcrnVkmMQJGZhsZplCuT9QNI5edXxnEl/Iy27nZTG3ANojLJSCPjV3cqmpSWRWZ+yqjsBdtnqHkzq20kn0cg2tDpJG7Ppv3UUY+WlbltGD4VbbeXemdOeyUeXIuHCAY0r5T4iu1hSQ5+xSJvhCowtIIh6JH7TE6oyUMFmBKAMBlg+V+BMC6Y62pylcRX5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhoR2a0iYObUFzfOPICxsM4AX9Qk9yFi8VZdIgrpNxM=;
 b=KHgp1lmFAEi1o2ZkeQmCxkD9pVpmPZYicImmFGWaxLQoHcQsYLiu1sccaLtmI7NRgV/7idRLax/+RCdJg9FIziBbJ7SjPvwupix7kQ+JaA28D5q0yfV+kws6sZUyrnurOS/ax1ouwfuNWrHXm4y444ZtxCl4dYF2qVdcLQC6maWN8ikfCVSFOYV1xhmVVQHy3d69XLFWDa9qaKD7Gfd+GpuCEhyUgb0BSXwRvvvmiOJaZh9VhSekko4/L6c+TtgV0dNhekA+qo+zUuSJdk7QtpUTSgE3h6IH4jFH7OKekO+Wqh6mQ2Y7a/5+N/r6T91sBbjlg1YTLnCQXNJlA2HNmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6471.namprd11.prod.outlook.com (2603:10b6:8:c1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 07:09:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.020; Mon, 20 Jan 2025
 07:09:03 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "ankita@nvidia.com" <ankita@nvidia.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "zhiw@nvidia.com" <zhiw@nvidia.com>
CC: "aniketa@nvidia.com" <aniketa@nvidia.com>, "cjia@nvidia.com"
	<cjia@nvidia.com>, "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>, "Sethi, Vikram"
	<vsethi@nvidia.com>, "Currid, Andy" <acurrid@nvidia.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "danw@nvidia.com" <danw@nvidia.com>,
	"anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>, "mochs@nvidia.com"
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/3] vfio/nvgrace-gpu: Read dvsec register to determine
 need for uncached resmem
Thread-Topic: [PATCH v4 1/3] vfio/nvgrace-gpu: Read dvsec register to
 determine need for uncached resmem
Thread-Index: AQHbaTjJi7unwSTjxEiLWqb82xzZLrMfQPiQ
Date: Mon, 20 Jan 2025 07:09:03 +0000
Message-ID: <BN9PR11MB5276B46605C1C15EF39808098CE72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
 <20250117233704.3374-2-ankita@nvidia.com>
In-Reply-To: <20250117233704.3374-2-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6471:EE_
x-ms-office365-filtering-correlation-id: d36aeb40-f4dd-4b87-fe9a-08dd3921528e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?YZBc3/Tek/GWa7YUP//KL8wB26z02MCGvmN2cvYuHpx3IOglo+OYVWXJPOqu?=
 =?us-ascii?Q?2LRXrvEFvJZqpJ7++MHkCJVQhSalgukD4u1PcHNEelUwfsBKGP6Ppetz8RuI?=
 =?us-ascii?Q?1gQ++SsmCVnCg0qPifsewiDg2jD17y/MbPUqsYiOltg86hsXjs0bUaM1BP0p?=
 =?us-ascii?Q?pbRX5s2RTzxbJ4p96tDhDoaITsQi3OmV4bW0xQYH3xL4tYCV5izcNB2YycIe?=
 =?us-ascii?Q?aLeo7kHjPv6b/H3UDBMDXG9tin/78rZ1qX6FhQ0sm8ThisS1td91NOORyyBS?=
 =?us-ascii?Q?xH2iado3BOKgGrGSMlxptMSRy53KPBgCxqLOqSHnewblcqOzBSCO6ihzN+kt?=
 =?us-ascii?Q?PowDJlJdvL9eXeCHgqReT/Ma6Kt8RnLcebMZDkj5OtH8XTzAO8SjAWDmd9TH?=
 =?us-ascii?Q?TWodxR5MgnUDRH1M5WMCe0GiQDdb0WsiQMehNUsR5x0vNF2Ih8NdLevQ0/bj?=
 =?us-ascii?Q?+LtojAeh4gkwiz2XozhkZFweYl4cJnNVb60VbJFz7t2ggFlz8LvK1xThxRko?=
 =?us-ascii?Q?Kad6CJEn9w0zgcJllLn8MazXkdGBpcrZXpENy8dVmxcVY9ynfzOdJdPGRrE+?=
 =?us-ascii?Q?KpZ0d0LKR2Wyx23h5R8AbCMlVCzoeXXgY2Nke45dfJmwtEXdwoo+nV3dMxmO?=
 =?us-ascii?Q?/lwUFLKZs3EUGRDrcUFlMVMNz2ASe3sUkY6BlBdqe+kB7lDuYdcvrtQvXVk+?=
 =?us-ascii?Q?KDHvOzIAjku/3zlDlNM8jOospTgIBblkgiZn6/5grb9bsX3lRLBKi0PVMf3j?=
 =?us-ascii?Q?n7jdpiHy6CarI1Md0UO0axpLHoWCytjXGXU6CxqZGFYsOWMw10N3KICXQQOZ?=
 =?us-ascii?Q?OAbYYzL6iwAyh3hopuTA3AoDWocHaSze+F3RoENWAP0ugCIIwn5gZSbElgXc?=
 =?us-ascii?Q?nLh6q7yWdGZM59gDzKwO8288p7tnLDkJgJms543kexhIhfknJ62YEh0V90zq?=
 =?us-ascii?Q?dqU3tBV20F+xi7hnh3TyeD1RpgWcvlwfFxbkBuN/kw0p4z2CxgoIDIhZkeT4?=
 =?us-ascii?Q?6B61x9c9FL7PdDnqQzbOVXdyaJvvwF21994fTbjXT5RhMSbRi2RqUx2rzlFF?=
 =?us-ascii?Q?ygOwaLWsVRyAf09iqFo1m62s7ktEVNUzPBkEy7orGOo9hLX4/gdUTj7L/5qs?=
 =?us-ascii?Q?FyGDTk65uaqXFM2Qn0ssiUEzMAdYGDm7kSIr77T0C0TCwFqkUrnqs3YFKkfB?=
 =?us-ascii?Q?ddTaJfP7yfN4ZGTkPiR6NEIxwnfVXQdrtmrtVubjD09oXVo9Nr329LzzThoi?=
 =?us-ascii?Q?4ivP7M2Pp2X2PAop3YaVvp1xpkpbgtOZNXQ4Q/tp0CUuClmMXZ9J68GASB0v?=
 =?us-ascii?Q?oXT7Sv7iadU7poK4pMKKWkFT/duuNyBFKI9WcZQ6ogDq6czUz2hCoyQ+o8Gk?=
 =?us-ascii?Q?0rA7W+xtC3ru3f71Wcbxl2HFRRHKl2cr9dluQIVWkHJqFOs5g7+86wsebupL?=
 =?us-ascii?Q?t6MprY7SjxbUMhwtcst+8i4cJJQSOSgZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N5HN98whQWRFWrMAvcXOE6CB9heNBi81TGHOMQhsJotZ0DTOu0PW8oNFfijz?=
 =?us-ascii?Q?s5dtE5iBVOBj06sT5C8dG/x4r3nUcGuFeIv1tgeNFdQKnphLhZuT+FMxtMtv?=
 =?us-ascii?Q?mGDWsnNnp5lAJBppUtwN+xykH0alHtatNsD3dL4xdo1gciTF3t0Lf8wnkh9o?=
 =?us-ascii?Q?1lJtKoybW/1Kc/mbMekwWXZLN0/HKNJkZLoUwcwioMGhzHf0aGE4SxFfj9Sj?=
 =?us-ascii?Q?Uobz270HY+pUYRs38wCFpeDXy2yjwZaOatVZDWrEZ90MHKd2Q9ThW0efHkiZ?=
 =?us-ascii?Q?mKNvKpEmtCpH5eGi592sFt5mwkhN9QMwPyQHKVvx9oiKT5nutmiwMgMdDemU?=
 =?us-ascii?Q?YtxWW1mTM1PAcGUOnl6OMTAqIgPCV23t7f5CmvopOfGmG0D760Iug+fP6y8/?=
 =?us-ascii?Q?AQnO9bKlEloNQXww3FUFwMHm7SNBFhnOjLRKXx2JwvSr4i8ldEGentDFKr4b?=
 =?us-ascii?Q?GwluxLYTLzhFuYUdj6AVdLEqBQOEJjlMtI3XE3sym0RuGwfE7gIClRnSruK9?=
 =?us-ascii?Q?5cM8V0mBzBlAWJWj9X0wBa/IfRbQzOsxaza7KsFegLbfdoXSeybO13fGLHmj?=
 =?us-ascii?Q?bJgjDQLQz3bUy/i1ZCp7UKt2MwkbpLJRy7LwTLfKUHvXy1mSDDcjJjIdF7Rb?=
 =?us-ascii?Q?3Cbmger1yhSWl/zELpNHaddujSpi/NlylyfVdtJJALfGcYSthp5ChKuCzorr?=
 =?us-ascii?Q?A+C7raJ/B47c8KhABdPm+vFvENjuD9AxgJ1q/hiypHnAjrimD/Majy5KEFmy?=
 =?us-ascii?Q?YhdWHd9n6Erlqwe2DUSicAsOaIwKQkNkortaeMD15Si9qLvmV4DOvZal+S9g?=
 =?us-ascii?Q?K9Z54iqPh8Tef8aMpwnv+JOsO/WH6ho3W8MIP5pVgySzQd2nULCtPbc8bM6S?=
 =?us-ascii?Q?yOWF1qG29rckk6LIJUInK/uCmA1ehhig+ibTvsVzd42aMoe4zoaa8hlDiYq5?=
 =?us-ascii?Q?jwfMCBBjPNGiR5Vo0B+YEPmXqu+RKwOjEz4rPZH0JxQ9n0XmL9BP+xGBmD/z?=
 =?us-ascii?Q?95q5wsR41v0/gv6lPajwIj1fTcCkxrgVehbrKyjWIXgOp16TLaXZ2ucPlTiV?=
 =?us-ascii?Q?azJNYID0QFdIlARfMSEG4cq4ApOMc1v2S2zUOcvIJRs5nM/MlT5o/JCkfkD7?=
 =?us-ascii?Q?PIHRTTgk1J21PKb/vAFr/Ihk8ePK8v6nt3eMkFAN+/bFLExKIRTHk4yiuxcY?=
 =?us-ascii?Q?rzy2VZ23ujGx2asRH9eZVDcttMfm/5A4PjWfdfIFgt48TU7sDZyhcDWXxNsy?=
 =?us-ascii?Q?v+sJu/fxDa/mmArotWajDFIXlKokJj9Wz6LUKaxEfz5qtjdjofusL/hy50nz?=
 =?us-ascii?Q?GU2EYAS3JYsHwj/nBDUshqNK76ot8M54TlFDjxB9gVPOb3/D4D1PasxEwEJU?=
 =?us-ascii?Q?mtbOzxZYkL3W6o0gZbHSSoAFJSUd76GIWYaD3TFCNaAnMQhmGKWMgwn4UQF+?=
 =?us-ascii?Q?o1zu21qzOyniD/uQ9vqKAh+sn80crusDzzkuqRN47IF9RKxH7EBBnqyW9X0O?=
 =?us-ascii?Q?s0uE1rZ+CGfVHuVkuca2vt9w4ixIOVK7eNMD3m5iKPSXSJxNk6cXXwzDEZX0?=
 =?us-ascii?Q?gfQ4id6JwvsVKGv27VAvbIDfMKKmdGfm6muG/uel?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d36aeb40-f4dd-4b87-fe9a-08dd3921528e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2025 07:09:03.7834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7FXSDStjKvTygAOcXpAbTz0I6H4v4ZgwmdrCEIZmAp3ITZBlH7ppmNDYIaT0KkeuGtc/XQLFq/6RHLhe5IPlIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6471
X-OriginatorOrg: intel.com

> From: ankita@nvidia.com <ankita@nvidia.com>
> Sent: Saturday, January 18, 2025 7:37 AM
>=20
> @@ -46,6 +51,7 @@ struct nvgrace_gpu_pci_core_device {
>  	struct mem_region resmem;
>  	/* Lock to control device memory kernel mapping */
>  	struct mutex remap_lock;
> +	bool has_mig_hw_bug_fix;

Is 'has_mig_hw_bug" clearer given GB+ hardware should all inherit
the fix anyway?

>=20
>  	if (ops =3D=3D &nvgrace_gpu_pci_ops) {
> +		nvdev->has_mig_hw_bug_fix =3D
> nvgrace_gpu_has_mig_hw_bug_fix(pdev);
> +

Move it into nvgrace_gpu_init_nvdev_struct() which has plenty
of information to help understand that line.

