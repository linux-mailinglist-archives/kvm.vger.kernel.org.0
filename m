Return-Path: <kvm+bounces-30854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 896A09BDFA6
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 224D31F247EC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3871D0DE7;
	Wed,  6 Nov 2024 07:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bcM1u9w5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89151CF2A8
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730879090; cv=fail; b=XWLw2ycnIerXp1SfU0yFYrUk4di1fV4R3PfkbYm+k+CB5P/un360+iYoVBrWrjA0VR7OYiv0ygxoixlpPRSiJVvnCWhXKK2f9BRXLdZ9+yptngRHCzzCYx4gkfmsBMIxv0yvs3VyJcglnpO3TpR9zKSW/WYYs+RjN9hcSsmgcJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730879090; c=relaxed/simple;
	bh=qd72lx5xDgVlKrv064bTaWv+xLE/fZ+qdLEhsn0LFZs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ELJzcwHp+pG6yAMd6Ulq1t/kju0z/V4TTh5Ux68PWWpUhnw7ZhTA9hA9i3dp2igkMA2zAJCdobfIUOcjUuTkmjodQiYLMIbHtCAhBP5EmrX1w9hpfBEh+r65bpDWiMsoK2BAlwdGCPV6WJmf2I66mnJSWmVzFMJlxKIbqvtZeJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bcM1u9w5; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730879089; x=1762415089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qd72lx5xDgVlKrv064bTaWv+xLE/fZ+qdLEhsn0LFZs=;
  b=bcM1u9w5bHLc8vlmQueuvSMCLNm5W//i4gJefxecaSJETkYw8krD93KA
   Ves345IcQcST+WFp6U2DsEe0XougV0PHfsal2G+ASTvDUmthGqSuFdPCb
   uFRODt7iQk769AuzzlX80TCszvkcqcVUCFb60U8ECPsuehEPVp4ju48OY
   Ojo0Fc3FDJXkpAtLpxV68oHk2Q+oSWZS5Np1+8SZZ6YSgNuoac+eo1uQu
   ykunZAIp5uL9HAwtalA6JRx34gMPDG58fVPW6ggPS71vIsKkBkFbjluFI
   tNeGZ0YDSSDzvj6QdayY4bHZ0/On9quI1HLGQW7KG+AF6KOsHhrhVezVh
   g==;
X-CSE-ConnectionGUID: 549aELE5Q42OVPjzgU+r6g==
X-CSE-MsgGUID: MkVs4pFZRcCeHFi+qn478A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30432923"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30432923"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:44:48 -0800
X-CSE-ConnectionGUID: x/dHpMdhRbOEdTrd4ZokRA==
X-CSE-MsgGUID: HEc+Us5vR26Prvf7nVp1hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="88887783"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:44:47 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:44:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:44:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:44:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Adi38aJYHdhnSXfEgghUygBOjKXBJEn0HQKQ/iO5LRajbh7EXAWCYb5bQDjfnrm9SKD0XOIR5GK3UCuHdHWGHsZMTtlTFUmEsykdHGzFytfI7J9x9PBGs7ceGvI8Oblg+EavaqCeWGPYJvYEUbjZdHrtFUyh7fDHUPtRO3rYOWXQZ0r1QJTa55VL4aQMpBEjx8Rxx9nXl5Sld39WNXxsVzH9/87EqXs8QcYU3ZW3zMpU188r9G5lqbypcsgDpGNcRSkX8VfgamM/ogABK7MmJqYbIgHJiAemLWjaXXLkSHBkUVxUvZGOunSaBsw1VOYGYS0yhEWpqbq5Jhg0e4nPhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qd72lx5xDgVlKrv064bTaWv+xLE/fZ+qdLEhsn0LFZs=;
 b=oXQ8GgeXyRyAIWc/Fz8s5C8XuVe1vkhnIFSoGofi9fg4o3nemU0BcQqujX8ljUjRbbpdwFLhIFaaBwMSD8E4XZ6T96HC5IFsJgTCZnaqgVaz4QX5d1IwJpQIvy0sA45vfbILl866wSN3R+5V/ZOJUWniW9l7P7j9+GcnebSKaCluE9uxfMSmeotEk9tzmC3i/6kMi6IB2Euyx1IT0+XtwEa0O3sA+AATmsccTYWN7+9muZq59cPLaLK2WIVfnaV0eId+E9uvLWg/m9MhotIYNyEjhh+XHmd5V9cP4fPoWqzxTumK3YLpq2RQ0iuSGBZOU4X4MHCP5Vj8XCbKEweKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4998.namprd11.prod.outlook.com (2603:10b6:510:32::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 07:44:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:44:39 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 07/13] iommu/vt-d: Limit intel_iommu_set_dev_pasid()
 for paging domain
Thread-Topic: [PATCH v4 07/13] iommu/vt-d: Limit intel_iommu_set_dev_pasid()
 for paging domain
Thread-Index: AQHbLrwgWYrdNrYH9UunP9tjFrkWs7Kp4eow
Date: Wed, 6 Nov 2024 07:44:39 +0000
Message-ID: <BN9PR11MB5276738DBC0D490F78ADA24F8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-8-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4998:EE_
x-ms-office365-filtering-correlation-id: ec713ecf-c1a1-4121-59b1-08dcfe36debe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?nHW7DIQ+OV8R9/z6TQQjn+EKLavMPBzkyfYBnZ8bVvxdt3ZhZi0hFvu2+6fh?=
 =?us-ascii?Q?kI+pIghxJYGLKCmauAhY/h1HpSC6tC83Ly5tfRDJHGiGP1qNNGfMYErIPV/l?=
 =?us-ascii?Q?09ZqW8mRsxi6dN010SPv+sBUxMQlAy+oxJci6VSTT3AZLF1hN6f7DCeQTnjy?=
 =?us-ascii?Q?Vy+NsaWc/T8dI/zRe9dlP21/ktErzpti88BXqGgu/K2aufop8TNZmtoH2wM4?=
 =?us-ascii?Q?Xw9GdKpg+NgzDHfn72V0hqHvUdWjA9W77uOehQOv6qSigS00M588Sy0oJL2h?=
 =?us-ascii?Q?s18wmDTfAIyRHNNIxvpf3pvXdKP4DTxl6ri+UYBCim6PgQ97/0VcLpaAdnh1?=
 =?us-ascii?Q?5mbocwliKMKuFoycN7t1GkiQHKqk/gtH27FAn0rdytNtm1xbKt94oWJbCwOm?=
 =?us-ascii?Q?R9beTomOATZU0B9toEbjM/QvJ0X52yxQaIvldtYEOOCom3sP7luX+0Sofkz9?=
 =?us-ascii?Q?7pxNSuIrcGPJ5T20DgMfBHF+8o70d0QzZEIoRet9piXtYML+AyRWgi8B1eiU?=
 =?us-ascii?Q?JeueEo9iQCPQwo/V6zIVH1LcALXN+QxBGrDsVAFypPe9+gEds2BHRwwPd3h+?=
 =?us-ascii?Q?ZySONwjA7tei2cflSMnMvLMezB4sibPWW2iCzDn9io5Ry+pPg0T4KCbH0sbM?=
 =?us-ascii?Q?uqj8dZ11LAziOQyFsbsCeJmdjl3YivaZlkCYB1uTI7i+g8XXelAsO1CPhsEk?=
 =?us-ascii?Q?LRjgocvHG9Q7ir7BT/LiBfdWI5osfXeX8MlxI1c90r8Bv6PL6CSYZOasE4i7?=
 =?us-ascii?Q?Qs5VxVDsC+cVAlpHUBEch3/yPSrTZWXOQjxRmz/hu4XxTMctaCzbNqJJdLHt?=
 =?us-ascii?Q?M3rNtlMbQddY6ER8YcS+XzK56Y4JNyULeQaKeRcmbTKHVofixbf3DQ7pWgXG?=
 =?us-ascii?Q?bHILUV56+c7cdvLtDJMMu1OIJ1NC3YiKAn31xTrPSq3E47/4BrXxINot7q/U?=
 =?us-ascii?Q?Qz/95BwCC1GAsMs+iQTy9m6wws6JX4OC3rK2wADEF5W0lxvJv5g+2bijXXg4?=
 =?us-ascii?Q?8ixBd9ygZqgtDp7NyfJx4vbENZQM816a3q28AbIv1GRY92WU84/d8sB9XnAQ?=
 =?us-ascii?Q?0UA9y/anzZQ/Fnbh3SABIzKg64FwRjo20egy9+G9cm4Ru/htCKJpPy0d4voB?=
 =?us-ascii?Q?xtoJRj4KPQk9yIieb9UwpGkc4aT5TeWdzhfS0FluepkblcXm6FocetMi7foI?=
 =?us-ascii?Q?2VIb10JoS7YHSuFdvGfvzWvdN1SohypHaYdJ1UsPNEeJwTX0JegpmQ2GUTJV?=
 =?us-ascii?Q?NkWpYi9ExJUZJejRsEZ1vAq8H+RiOKacDAhc3WuK38L+Sb7XFjSgnagfqe+r?=
 =?us-ascii?Q?peMNR/KjmVvYsMeKk6rPQjBc4wsrI567yJTPjGJ1LiRsPi64J/mrIklnsq/n?=
 =?us-ascii?Q?erDsuQo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PddzUDxwmWMJOTR8daA7LJPKnn8Xl27vO8B6ecY18rSrWe2EvK5xtmf+qpWH?=
 =?us-ascii?Q?f2XEdK4XdNPBrpo51BPipK0rL2IU47Z5mwHvY1hgITckW5z7DyXeeCTLM+G4?=
 =?us-ascii?Q?dVQtS606g6AUtgVQjTOrzkfKyMjEbAjxhOEtvFJm8BYjvkvAp8ywItoQ0Uek?=
 =?us-ascii?Q?ElRWRw8gDcQ4Qf1kLMxsF7ij7T0RcRAxHdniSNZLRl5IBToGmDXXfBeqGSEd?=
 =?us-ascii?Q?qvz2IIp8unNZVZyXx6rRGCFw2iKczZxhhuHf4nRWwQxo0sUwY7rVfvDO0aY6?=
 =?us-ascii?Q?1XPXbwhV3QWAsVnTJewfd4d0Q8q8yrgeisSzNRN4ki+jN8qXaJyB/eHQNxHD?=
 =?us-ascii?Q?Nd4NwW6OegkOGcbE05SXVCdR7ce86yHc3I4mtAQlZgpLrRiXHS5kwoKxjvf2?=
 =?us-ascii?Q?6nZuwbnxwwAO4r05DMCVng3fsQsyTvi7a/fq35D5WiZx0QDY7RJR7NxRwGAl?=
 =?us-ascii?Q?FdQyXVvlBXBYFd2ivUNC620un1P/FMSrkraSJYNf9tj8oAmyi2KwxP2z/08u?=
 =?us-ascii?Q?WB9DqarOEwAL7PXZE4CwhO1eAHPIiTFJlS1t1TLgy8h4YM+giHqQ5ja0yRkt?=
 =?us-ascii?Q?TUOKqVjpoFtCRgn35QqVDMdX5DSC5oI5WQVhX2OVyVJcjAnfW/V1lp5DL5jf?=
 =?us-ascii?Q?awD8DU+VGknooJhwBzetVCwv7aiNnNIld+h6vMCN9W/7bI6F5zqBCG94EPhm?=
 =?us-ascii?Q?WF9kILROw1xRm8nGoG5a+0/hC9ueXLKFmwpt7lYJg7QYsKR6YMmc9ZqWCk4G?=
 =?us-ascii?Q?OJ4+1Vrz3qv4aPMgRtDtOE5+hfIrJ/W/C+0O+ztQqpL84qn5bfdv0SdXgQ12?=
 =?us-ascii?Q?gqIibrdpK4ptCSHTdF5i2F56HNbcscr6qk09Rna8jaVPBizHyddGva9w75fA?=
 =?us-ascii?Q?Cy/lbxyRc93QByOvv2VR4jeN8tQ5EiPFyobdBlQkUMA8sWwlW/984Td2lo+f?=
 =?us-ascii?Q?RWRuQj7NDef0dWrsGuAiSsv7pT5QCC9oHidGn6ERdHlnDkH2W4+GvmM1l5mC?=
 =?us-ascii?Q?OwHHwAdk3HxLT25yOixYPTpS1zq+z/T+VT4qrGon33TipCCAZVP9OuTTnk2d?=
 =?us-ascii?Q?ThxTzZ8TeE5KaNJON4tits26/+gbGCU6q3hEzYaA+tOPEOAbmElm1zu7YzvG?=
 =?us-ascii?Q?VJbEs2Ztrc8aJl/TBAPSoUoq7hjmky2tMUGTPSaFvB2JgvhYIvujAuwBM9lJ?=
 =?us-ascii?Q?nZ5A+DaMiN5a/ATH2vVggirCrSosTFlHiyVa4d7NiRFmPFv/EZNS2rOMQSfS?=
 =?us-ascii?Q?CV61UN8gJPtBEzfeodmKeeUPWfT6sMBSPl2YMcZ30RoSDnhH3Lm2DFiU6hEf?=
 =?us-ascii?Q?LBxz71UCSvfz40l4hZUnOfQCSRL/4zjVn8yDdy9q92YAmJseM1D1SDPUHYfN?=
 =?us-ascii?Q?wnrnc6CU8cJ9tEqzRJFzW6Y4OmhDCOM/E8c9u7SSwO1eKZbYjIwp0xUOguCc?=
 =?us-ascii?Q?Smt5PqqaAGbX3TmWDUffmIL1OccSM78udmlcXITGhUib6FS19CGuHxmH9Jo9?=
 =?us-ascii?Q?kUoJ3zl1VVQ/wo5IToGEJNLGJmjDePIvTkg0Pvdu8uslqA6fbPHBK+V3xLnx?=
 =?us-ascii?Q?sZ76togjaH4KgXA3qelQxmddaN8sAbEhsP3rpv0R?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ec713ecf-c1a1-4121-59b1-08dcfe36debe
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:44:39.8426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SFQ5TXiq/HD52HVs8344dSOw7t5tWApiNfuwirna3w6uCWoItVXv0qDkpjcixCkGlyipuAkhER3bd/XUoqeA5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4998
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:19 PM
>=20
> intel_iommu_set_dev_pasid() is only supposed to be used by paging domain,
> so limit it.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

