Return-Path: <kvm+bounces-26467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5284974A72
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61633288FF0
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E944376048;
	Wed, 11 Sep 2024 06:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZRaY/FtN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FC62BAE3
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726036412; cv=fail; b=ImGBLzODGlepnmVp7ygI0A+k/19AfRCzzWMi0R/PIJHik7DSuRkAXwtp41lo59xSxeVMJUDncmwuVElxN289EesGlzB6bZeCCvI93m2nIszI6SCwaAnDScLnf/qJKZoFWqlInlPVM8e7mTbJ/5cMnlBM4tm9GT3n16/1mJ8soSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726036412; c=relaxed/simple;
	bh=Ul4H0mKHxiShPaeobLzPqCd7pTqL6ykfzJqZX5s44ww=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pI+Wd434zfEmYsYwNniY9wlqz0LrsXIRGJGMTdet8B5rsNhOJBJXzfSsjBOWNYKb7ONwJ38oq+GfniBHjUf4iOTolj2M+xXFIo97oqSIAaVAMf6CSXwNb6LX6qD/iNc6YfsdRPqB+4pCBre01zAWWvF/3wAFb1Cynmp0AWtPO9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZRaY/FtN; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726036410; x=1757572410;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ul4H0mKHxiShPaeobLzPqCd7pTqL6ykfzJqZX5s44ww=;
  b=ZRaY/FtNfWt1XHdWJqiOI6hdzn4f9QcWgtki20tyLhkMZkRiZQw2VWdh
   zMN7AzuB+rYq9I72Yxc6mmOYlb32cW/3cqaPQHRpiYqbjXtEEaYBC+Sg8
   pdZFLQSAV4Yuzd9iV5TQrqmAbrVFAUfDjXACJYCarEMy5Zyu5AKOya2nX
   F8pLfEuA5/g1m34aunA84c9YiG57MzNXX6+EL3DuvhH+uLC9W9K45OegR
   sK3ws4068jo7DxConPOnSezaYEp/XZcQW1Gt8VQCf/H1bt1hhr8AYDR70
   KgGm09tBoC1/As1Rv0KVDNSPF6/I2puHeXkE86lnhptVFLkn1KEyx0kaA
   Q==;
X-CSE-ConnectionGUID: xCxwmlEFSCCA4JhMJAjcbw==
X-CSE-MsgGUID: J1nvJjLlQlCQtjXRWnUSDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="24638693"
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="24638693"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 23:33:30 -0700
X-CSE-ConnectionGUID: c1skuWm/RLmSCpC5rmkU0w==
X-CSE-MsgGUID: UXPkYClQR16Uh8O5TEQyTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="67285315"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 23:33:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 23:33:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 23:33:29 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 23:33:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bvikInhBI63CBcVTK8HGWR/zIZQZdfTr7ytQPIYuu3KM4lnmSbzD5aPjDp7quc87A3plHqWjeS3tw/fYcNXFnoWxYG0kcX2q7JrNcdxR+yhdcBroKH72cqa0RjbButxJ+xzuV+v8snmG9SOadrx0pO+s+Tqas4Dt23C7Qvk9T3l1wikVlxZkBaesrjxJcDmyG3A0zFeRPb7slvPwKkaHWUAnUwJEhD2pMyCMcA38n/FzA3sZjBMOjTmITmZni0CvSz2QQFoL3m1rRrE+o3kQzzN1vM4TnybB8fotJCceJRP0Xxb5gXFy3D+wO4/idLrGBveMdqL7brMtxOEg5DndIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ul4H0mKHxiShPaeobLzPqCd7pTqL6ykfzJqZX5s44ww=;
 b=PFsDAqx7KA9TsoWZDjd+Lizh6omFxXXLHGVmQU81+Hn1zZl0xqi2kZHNpnwYR6RsXvVNT9Je5fh6SmRIimZ1n8aC0Un0E3IOfqMu5uzr5/DVHG/1WMatu62m0PFRffV9WtjyZBN6JH6oyldbkDiwt8DSdFZBJWknHh5BQk7Ge0j1AKeLg5Yy9FscJObdGh0/wWstg3NI7785T6/hRkxH7jgtkckzYQdXdgjKnCSXlcruMnORy2+g2Xux9Z3IUfs04Nf+1gFHhmm5Ph1W5DYqzn+vN8RSt17o1OliRapyNn+z25QEnggUAfZuqN4dDegSx7OnO2BwZC45RYqd18RQOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS0PR11MB7559.namprd11.prod.outlook.com (2603:10b6:8:146::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Wed, 11 Sep
 2024 06:33:26 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%2]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 06:33:26 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>
CC: "nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
Subject: RE: [PATCH 1/2] iommufd: Avoid duplicated
 __iommu_group_set_core_domain() call
Thread-Topic: [PATCH 1/2] iommufd: Avoid duplicated
 __iommu_group_set_core_domain() call
Thread-Index: AQHbAeRNALn8ECykxUKg0FuhjuGiyrJSJR3Q
Date: Wed, 11 Sep 2024 06:33:26 +0000
Message-ID: <BL1PR11MB527108AEAD337BD02997D39A8C9B2@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240908114256.979518-1-yi.l.liu@intel.com>
 <20240908114256.979518-2-yi.l.liu@intel.com>
In-Reply-To: <20240908114256.979518-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS0PR11MB7559:EE_
x-ms-office365-filtering-correlation-id: 1d634695-473a-4ce2-d24e-08dcd22ba44b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?10Ho1zyF02iDyD8Ylwt9qtB5EIlBLoMflNKq2lp1FFES5Gp6dvPZES/AAZ9x?=
 =?us-ascii?Q?kjOM3ptanCDJ/0eNN/y2HEEnqpNJ5UtHnWV/Lfsr/M8ZkzPDF0wE2ACLvBkS?=
 =?us-ascii?Q?5yMrb6bUJtee/L3But6apuN//LNBuH0IlXpTQ8LiySKMZAvoXHzV6RlxIuUo?=
 =?us-ascii?Q?JVR9evGSqACIyiYdRpV84qdgDdG9KTNoQ+q/f1tT2iyzsFamx6jtMQ5gUKRG?=
 =?us-ascii?Q?Qdyf2ym4ZMwVL8Vn9NFGJgJhJr2scPH6MoehxoDuSrUgvi5BmaBYGY9KXBlt?=
 =?us-ascii?Q?JGZD9ZzSTgYkxxKsRUHprZYt/WCq04bXZABmXMWuPSTXGPSHKcBlYSiI9rEr?=
 =?us-ascii?Q?RvP95COKtKmt6nOJlYIPiBsxNOdfWUC7dWAsmfJSqXflt2Q2Rzq8l9Di1Icp?=
 =?us-ascii?Q?8xkl8kEI5EE2pyeZpuHmxUPGWKFgVJg/HgV9kTmABSITWjqNMidEXk36i2aW?=
 =?us-ascii?Q?GE6r1+nqc4p9F5cs13RVj9T/AcaKNUFSBeOBDP044bHpEDo/IUiDYx7OMzlN?=
 =?us-ascii?Q?nGURUJqmBstwm4seyL/Q1RKw75IAisrA9FeMCOdVJ/hXGW7whojxT0A3+i7x?=
 =?us-ascii?Q?BxbyHKy55u+eSjRysUn9QKLplD22tm4MfHt05dJGI3C0OaOwDvYug7CGuANt?=
 =?us-ascii?Q?gj6z6dpfRe/c4QmLU3RBlAFXriJGG2V0/7NGtJTRMaL9gD+vkcSLRfi7nUc0?=
 =?us-ascii?Q?wzDX3eWTHd9oP/XMNl2n2J75dpq43g8Ss0jhrXgKUTREuKUQQWVj5DLYt7XV?=
 =?us-ascii?Q?SGo2rtgx4kUyd7XiStIIMmrPPwfa3D0X1H5alNSJkmJgFc7nBEXLrJc/QY+8?=
 =?us-ascii?Q?CA52/kSBlXAMtqmG2LpRTvl/zObeEeMX8kTwma4z8VNbzg3Lc7jLUW86z9TE?=
 =?us-ascii?Q?ltg8Ray5I5tqtfR3WtF3g+ek6aV8jZougnLF4upq3cQKqrUQ/REBf+SRgiIK?=
 =?us-ascii?Q?sLGyzTHSukjtJxGUaJwOFv9qYGYF/1oYbWuQ/PlQYFIvJTtnMS9PzrqobrIg?=
 =?us-ascii?Q?9yj3oZdnoDm89OFSmpa9F+091MzFzPqoAS9LS72lBbV3h/uf40KO9vqafnOn?=
 =?us-ascii?Q?At3mXpzfkrV6rtg8YtWOGEZvwJ7nkxHH/vfjpaHc5RuxRV+MrqtCwsyjWpbs?=
 =?us-ascii?Q?4gFr4Dd1dMg1G6zaWb2zhvpKxUw9akR1pumUppNVcPrVUjfkY8netpDwaUdx?=
 =?us-ascii?Q?7xa/XLf3EJIBa7CqA3c3Z5X1/ltif7pQnU/xMQugKl9+3kI2gDP2tydcOYq6?=
 =?us-ascii?Q?hJ1aPTaBDFM1Ot7NVNcS/U05GgqOo4TWhwT42Bn0emGn/DBOrJ33c4wFldcl?=
 =?us-ascii?Q?0VaG2FGFb+VHTfruflEM1bBZYBVB/9m2B7oJVdEeKXpMh5wMF8Zzz8ne4UFW?=
 =?us-ascii?Q?tAjV4IrTC4uMMG8VlWh6KiPy8gVIofF1K5eUYqWbdf9afkNwAg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5MYSuJY1D03o5HNEE4zM1Anq6Dd32YPJ/LnVIPWbaJ2S1j6eI2xc5CPI0n4i?=
 =?us-ascii?Q?1AXH/JGIVLccXb7YRdsnabaX82nB6N+EWXpcVmrZZQB7Pfi7wofFj8/5T00Q?=
 =?us-ascii?Q?yeH4GxZs/2v595IQ4Z1IjH25mnQwEfytNc2fO3EY+1M4x1IcWIGlXbCmgMFM?=
 =?us-ascii?Q?U5CFbCaKAPUmSbXeH/lWl0E4dukUP389Q+Vci/P5rV0Qvzlwunc3XH/we+Od?=
 =?us-ascii?Q?iHlVk65l2vRqJz1FNBhB86IxT0FkdrNMVkps5qC0qaGEuzNkDYduA03Ri1Mh?=
 =?us-ascii?Q?NmMZG3PWRWvgr7tqWsQfctaryly5H+H7u25uPcEpFEqO42PyIFzOkhE1uliu?=
 =?us-ascii?Q?7qssVXavtYYNd1MpiU4jt2ynH453gYx5hphVILLX1tLcEvcohI63lEw7HkdL?=
 =?us-ascii?Q?6m4vMd0LQw9XtDgD2B5ntNL7nMQUpy7AmTtbOozvejGingzBH5HXH2ppkxaY?=
 =?us-ascii?Q?xoUIaWx3pAJqn+vQEyRGtYGOnbCvLLW0GkMRTSIX0kmQ3ABLT0MJ3LMi5Itd?=
 =?us-ascii?Q?vTeSVX/jAg+qVyWW2UnkAbdH+PIlChtXrG9VQ+OHgxKVrXfcezntgIX+HXW8?=
 =?us-ascii?Q?sysis44b61VQiwiU6O0aHl1L0a5Lx5ARnqHmjtrz5EL5q5pL9+OHR1bnfnwS?=
 =?us-ascii?Q?4JVGFGAkD42M1PkxZM5EVdZ+Jprac0Dd6eJw1dVSkJvzSgikH5czcJnsUcob?=
 =?us-ascii?Q?QCGq3By6cOD6QG1guGfVm9sdGJJv+C6/zmBIWylJg49iG1p2ofMjqGBfdHLl?=
 =?us-ascii?Q?i1FSkPGDPK0+0/XY5u9mbiDH5bUzNIWKAMU84ivWoTih09A9+cSFmVhIDvVP?=
 =?us-ascii?Q?9VS5vvfpiNf0QivOsheeBweFvScFXke+H/KGEWmuI3PibZqihdaOCYeKbv58?=
 =?us-ascii?Q?+VcAU6X7ciOP8cAa3XP4jUPtgnmq6JFDIBcokfVxjdXCDvem+nGg6QyE+FVT?=
 =?us-ascii?Q?pF72W7H1vtDMqkmst2pX06mgmHLQmOkP5kpAfTQrhNT5rFTWJzOc4iPRi0oH?=
 =?us-ascii?Q?J3oTvIoP4QbYuZYgEudIgKsNSD09pHrC9OWl46y3sN63qSE2HXXpkTvyk1F+?=
 =?us-ascii?Q?XzLiN31CE9125rpVXM6QcQ7s3HQ939QISsgy+dWuNToU+4tyVvJqzQC0+b+i?=
 =?us-ascii?Q?FMbpj7SNWclMiPuKQCKlKo4PuMnX4UfzLPVipgIY5EK5J6BCUmL1LYOwynjy?=
 =?us-ascii?Q?WO7s1i5aZ4jlUWBkOEnLRk82FT+qEQUVfwHbaTW3fEptLugSqV9IbRojdULI?=
 =?us-ascii?Q?SEHafSMWDZtfkIBYXcPvuHxnHKjLPq7vO6//HfgKxKEarrWGrnrK+OulzoX/?=
 =?us-ascii?Q?X6Pe3kho/pTyv/aEJBTw1iAXxYOrOXv5v+UB+W7gxClSYE963H9mEqYamtP+?=
 =?us-ascii?Q?kvMPAyd6kF6Vw+m/m8BrQKS5TsfhDR3F5Ii4sUQmilkxBdNh2zo31rP/+P4W?=
 =?us-ascii?Q?IzqYo5g9LBj6QxBv2L+pKjnUfjnG7lOId/XFEEAJJVlZqluXI10c14JadAiw?=
 =?us-ascii?Q?PD80dhIPQprcv3D3bpjE3n4dI+V6+1Q/URFp+7cUMriZ3RRnLm+oNKNcRUs3?=
 =?us-ascii?Q?9OI2ZDlaLeJ5iN7XfV6lPavuGcY8pr6vqcXGWDxm?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d634695-473a-4ce2-d24e-08dcd22ba44b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 06:33:26.1530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BV0N81gMaULjwqggU4/34t0CsPmx0UYerVfXds+zqWivVsfDDJgHNz+WnQ8TqO1okshoS6yeBW6QfS8jL/h6wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7559
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Sunday, September 8, 2024 7:43 PM
>=20
> For the fault-capable hwpts, the iommufd_hwpt_detach_device() calls both
> iommufd_fault_domain_detach_dev() and iommu_detach_group(). This
> would have
> duplicated __iommu_group_set_core_domain() call since both functions call
> it in the end. This looks no harm as the __iommu_group_set_core_domain()
> returns if the new domain equals to the existing one. But it makes sense =
to
> avoid such duplicated calls in caller side.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

