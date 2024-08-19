Return-Path: <kvm+bounces-24481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5417295613A
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 04:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BC001C210A6
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 02:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E5A2B9A9;
	Mon, 19 Aug 2024 02:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QGefb5EU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DDA22064
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 02:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724035877; cv=fail; b=eLJsRgDq3Av3AdmDLi4OqVB+PTZmZkUJ5bqmKG4jBnENmuzvO5Tb4NJ9AzQn0+9f7wWX4oxTR3g4Ffgr3yp0mN/mgQ+bWuRun7QXTL1iUjrx+7ocIw9e4ob6U8nLuiIUx+4XoVCeLR+BB/FTVGGYkaiiCoXIhcNjJ27OMwHeyAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724035877; c=relaxed/simple;
	bh=V+BXnKljP1NB3IR8wFbNvZ3SUDtQxaOPy2Xgps142nM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZFdsS//ZUcz4PV/pCqxEqLu/9nCHwdogu3lHTkn0lskG+Libhu0r0KO1qtcYElZ8soMvfRtP0AdNo54RRyv17C1xh3wKYjvwlHvaDrGyzL2scd0FiE0Gvq32JR5nIY08cy1NmWS9+m33ctpt4seS49sVqKo0u307f8HjIwPSxRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QGefb5EU; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724035876; x=1755571876;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V+BXnKljP1NB3IR8wFbNvZ3SUDtQxaOPy2Xgps142nM=;
  b=QGefb5EUKl4sCfELRKYy+1CjTvJgMXbcWSOG/RYDnygIlsoCywrlzl5x
   qFUbSqyuSdqK9TJHJR8BAmE4z4zkjoFdglFRoX18DO6/v3GzvFBPtbM5s
   ytxEp8olRH2rvZxY7EjIdWY+MhpJvw9B9devXdNNRNw5Z+R0tex0nLwoG
   3sMt6CpjNz9t3+DdNxcBUv0SRMLKFjw0M/zsxIPP1xCdZOzpPpBbyshd1
   FFwhuXKuDaTCgApSH6QVCXl1MUI6stnnnzf74Icoe+h0C3gS2sc+gdkmq
   tqnTs2ociwbbY4lgNwqZvN0h2+gkvFw/5PNzSyyOd559Hbb7snuJTnSh2
   A==;
X-CSE-ConnectionGUID: lfzcKsLTRBuwFbLUNIS2CQ==
X-CSE-MsgGUID: W5xgoqIwQz6aLTn8L5Y3Mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="33409245"
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="33409245"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 19:51:15 -0700
X-CSE-ConnectionGUID: Einebwb1Q1quvwA9Vhpl8g==
X-CSE-MsgGUID: VcbwiJAzRDucLTLkCMEMaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="64615552"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Aug 2024 19:51:14 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 18 Aug 2024 19:51:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 18 Aug 2024 19:51:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 18 Aug 2024 19:51:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxRkixvX0jf7VOjt/0Tvac7Ef24jE90XqxCs0xQ1kLLVG7HuIibrNiZskc1u49YBmv+kLA2EJzyl6ua8AuoygdX8cPDFTFDqpthj/bVBRWKrh6e0cuw8hsVJRsFhuq2KvVAjat0b84XrwJD144y/kkNrCkraqZ+I+YF3uyhkqMAgCHI+04idU36Z+p4g50HwCrf4/ojxx7DQRUUiFQ12BSMOLMw6WOrhaQoYDK5jCpTbyUXv5zWK+NENgQfMbeVxt4b9duHb9UGyDXt4kGzgkTQo4mdhX543TqdwmJWlfyD+mlS41QgYAqqdjAL/RUJAArFUstaPWqfWuaeldqCiPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayJoyhaaiZ+QUFFqHyKCFhyRILGL1TiBHPDwNlf0XW8=;
 b=cuvMSB4n4ltkLyJLy2/Hw1FtLZMKc8SR4SUoTKDj4c3TTDUY5sJEpu74PJBnThABzebPPqWviN7atcZgkPV2qZHmt9KdFvr8nfkMLmTxXuAxkap5Q0ID2pTXVcws6tMHfVTCb3k/XGDV1UfbJUprySSTM8ZMvtsoEPWs6EWyRFb7xJeWeNpAFLL6Lbsv3ylN+rlW3npr08pVrSSw0YAli+pgCY4fMznpD/4O/3EkDge7tmKd88FnAuuGCG1MFMIdJF7MQhr/5niGM07j7PMKnavOLiTwlqn4cGfes95JwsnqXcc+0HWSq/2vlL6dw6slP374Ck3Ju/rMxx0Hx4yZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14)
 by PH0PR11MB7585.namprd11.prod.outlook.com (2603:10b6:510:28f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 19 Aug
 2024 02:51:11 +0000
Received: from MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::7b5e:97d2:8c1d:9daf]) by MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::7b5e:97d2:8c1d:9daf%5]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 02:51:11 +0000
From: "Zhang, Tina" <tina.zhang@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, David Hildenbrand <david@redhat.com>, "Christoph
 Hellwig" <hch@lst.de>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Joao
 Martins" <joao.m.martins@oracle.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, Peter Xu
	<peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson
	<seanjc@google.com>
Subject: RE: [PATCH 16/16] iommupt: Add the Intel VT-D second stage page table
 format
Thread-Topic: [PATCH 16/16] iommupt: Add the Intel VT-D second stage page
 table format
Thread-Index: AQHa7yWAEq9GclpS2Uy/elLFKDgX07It3d1w
Date: Mon, 19 Aug 2024 02:51:11 +0000
Message-ID: <MW5PR11MB588168AE58B215896793E83C898C2@MW5PR11MB5881.namprd11.prod.outlook.com>
References: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
 <16-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <16-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5881:EE_|PH0PR11MB7585:EE_
x-ms-office365-filtering-correlation-id: ec2253b4-4c11-429f-4dc4-08dcbff9c884
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?Xmslr0sGyHHJGMVIxdT+FPz1iJ3o3YhJIv7TtrXyfQf5nquTOOdnnIsCw+FZ?=
 =?us-ascii?Q?TaTq/YQlXO2Ltm120HDkVE3nSVpEjKoQui6z6p2W7ZWlKuELUTiSC53bWzrF?=
 =?us-ascii?Q?9kcDKCHJ6Q1rA27/9u/XAJvq6skeiJX6YapxEiK4btHpiNIBY8vSvn1nMZxd?=
 =?us-ascii?Q?QBLXpXupLVOd4T63/DyRJzHzQJFlFoEpsS8tccddaUprCs0zXdBYU3EueQgk?=
 =?us-ascii?Q?l/hHjZ/IhStdh5i40UWeOxWzBIKYlzWHiG0Wf54I01n8/J97x+4mOvCwREri?=
 =?us-ascii?Q?WP9A8xm5C999v9zemd/fgi+5xqD9EaorCO35i1RM9AcrV2eKRlIVwDAVXct4?=
 =?us-ascii?Q?h38TprFb5KYT5ln5buT424VALyKY4LQWY1t7Pd+iBI1otLHCCyP0Inz1AtFW?=
 =?us-ascii?Q?lCRv/R2mTASku3I9AaAUoF+xElLn2Jrx1UBZzhXPrdyAwaJK5E2U8NetLIrR?=
 =?us-ascii?Q?827+0hYSrXX/n2piQllKud/sMV32bQKa+iyh7vdaY/HPQ4CYvtiLnrkpFKWI?=
 =?us-ascii?Q?kR2O87m4AFv65gj/HbIf62JAq7ks8lQWGcdvpHKKXY5yTeavB/sOT4o70RHt?=
 =?us-ascii?Q?IOuaagXbuOYRZkjHPZIAtL6nbiRmUvm2fFLgHMQfE/QfpatGijp3vbi/a8HM?=
 =?us-ascii?Q?3+/ZIwfswkrQKMna7l+8qeN2fmi0ymM7jg2Ps2N8EavoBiyJ2asbWYdsV74G?=
 =?us-ascii?Q?tOUgFqU5PbkmEkhMkRVZT8VHMYmOF6qQzUhrxfIVNh5Fi0sORVU16Eu4FciP?=
 =?us-ascii?Q?aVGwnJ0+maSdLQYfKT9T1H22WqSmvATAOCJ/Sjdk770IvAqPk6sonQVVwOjX?=
 =?us-ascii?Q?Hsxe6hrsZgYbaGMKLxorM2YYRPLyNVGRiCuGK5pCwIdtwlErm4GpHYc1JoGf?=
 =?us-ascii?Q?4Xj5H0O0vjflyXV9dGdWPfAQr+yOZHvCjp9sbWNzwll2qFz9gHywLHIpEQ43?=
 =?us-ascii?Q?Y8SwCfP7Uh3usAPfmnXyDWWV4kRpu+u81OvkfGZUmg1rffg8p1RrTjnsd3j8?=
 =?us-ascii?Q?Y2zS6JF6skX7424ImoCRiL8isBq/tc+ehcFduRoJKrYdlwRSbClXZgHg5xW5?=
 =?us-ascii?Q?CLt5YqQl++pGyPAzis6croScwRY1Q9kYJUHB3hKWCCmpIoaj7GeiGr/3kCNs?=
 =?us-ascii?Q?hZ+OEr86QHy8SaQp9+41um2o/+PBzXonD5OAp9OavvCwg+sf/1sjS6SkFKMu?=
 =?us-ascii?Q?jy8wB7ov/rfBDqeRf2r+MOi28DMpbQKYYFKeY/TWr4blf64oQBqbtablJ/+h?=
 =?us-ascii?Q?9t4jcDpK2Cl4RyTqmEJGySNXjQfgzldoqFckhpTeRkPdk4AelLg3kPxTKXeN?=
 =?us-ascii?Q?SqJYlN9TpzMVdiidaCbFFU9x1I16h3QtRh10imkS6x2lYQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5881.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jPx+pItZma/JbVfFKqGkdq8YBx/RA7cj9kpqc26drzcrqXOjsT8Ji2UWeDSK?=
 =?us-ascii?Q?vGEzxfg7E6KwC+C7licJTBtWAfn73G/os4hmZlCwZAHKVvEBKnbBFWo1+Zvy?=
 =?us-ascii?Q?AVlNUmkTlRz+Tw7H0lwDv43S64PYXN0WWY/AeLDUfS0xJ3YdUhxO2W6tbwFx?=
 =?us-ascii?Q?cJbKLVcgieSktYCyrxOwegG3CoIOKfqV5i9sa6DyqhKTNvXyp+g9LbSZMIyi?=
 =?us-ascii?Q?ipFuEDm6EN0B9utwLi23XXgIt5W8sRFQnXPOn4oa3Cmlq30MpAlioXdpnKaw?=
 =?us-ascii?Q?e/4hf/Ut7bmLk1+u+gJNe1+BcUniWfqVMNTJqDYo0eto+jEYwFN7iQn7SuQD?=
 =?us-ascii?Q?7nOWYNh/GJrdJnAmdVXqD7RpmuARWI68QHkQDM2keGc+whyIwcQgEkpg5Mj7?=
 =?us-ascii?Q?wElFzBxY0hp7exrj7xVOI2N8pVRfXAyhYOtP5U833aL8rMLXez7PD0l/7iyI?=
 =?us-ascii?Q?kAUb2ou2vv2S2d+upXiGhbFKdEYWDhbXBcNDJ9lwJyFK8k44/QgKwln4dAOA?=
 =?us-ascii?Q?4Y8J+SAKs0uKMzcyNt1hZI4OYyPHU/3sBzch3yQGWHKtPVAKN2xO1DWXYBz/?=
 =?us-ascii?Q?kvOc0s9YLN9xO+E2SLpFNFe9YvlD4MAdEeWFPCwvRcFpB47WEMSMrZDFUCEO?=
 =?us-ascii?Q?09FNd5h5F6pRRtgewBTuOHeMVvNyOTdaZbrKcNpIkZ8/FaKp1wYqkmRCkb8o?=
 =?us-ascii?Q?dkUeN/UVMYASithX4bKWfh9867/JIQw/mvkmNihBlUZDPSYX58i916epeGVl?=
 =?us-ascii?Q?Tnrr/bvDRjBvgUhIMIeGGPjuGOJ2eUdz3+mYGNaw8caVFFvjgqdlo1HcU+IJ?=
 =?us-ascii?Q?7csPsn9VEPtqXk8vftK2BAdM0jbreKF7c3okYvC7fZxetnmtsv+PoT44jUYE?=
 =?us-ascii?Q?j5KvLOo+mozK1nwtU5nu5VJneaRk+YslHEWLIwSbNzAqBB0Zuaasi5ebsNcg?=
 =?us-ascii?Q?y5nLy0fIML/oQ+WkjKWU/p/lm6PmVxV/cYQCxJPflHhVIgAI+hJfW/j6JCDG?=
 =?us-ascii?Q?oS9iKBGhd8apAT7kGkxM576TU1pmXvNYnN6wO+0K/wM/CobX0+rW4ihepN2S?=
 =?us-ascii?Q?8NLc7uLS+5BQwGYSdjEjd8/aAPwInt2+p6atgY4zMDFSXMaxbVl09VLTH4W7?=
 =?us-ascii?Q?O4gA6fT4ubFzxnfBrlNkS7QIE0daU+Jo8Ic71mKMgpP/LfAVAQtTKnYIRIck?=
 =?us-ascii?Q?LEIqOiYjlv+BTtATFLWYmDa8WgujkmrITdxHeSvVNgqJElg35Xpz85gsz41m?=
 =?us-ascii?Q?w11l1f/WZBuEf8azL0ny/fhUwva63ZCxk9T9TWOA2HwSAy9ilgdSEWlFZo/k?=
 =?us-ascii?Q?Lrsfb4swM2TXtH7o+bPRINQe4KsUGNEWyPFCrcqH5uuG3Pia8wQHopxEI6yD?=
 =?us-ascii?Q?YplXPFYURZ2kxgbUz51kwlnrh+l5ww5001aFXwcsR9gxdTuYVfXCeReFnrrX?=
 =?us-ascii?Q?SPmN/E/iMsVN0bJCDyMcCa9Zkrk4LayidIVwLdNaiNQbP4ehmRgJFS6wrlAD?=
 =?us-ascii?Q?bPsFRBaslSq/MiAERtqrYAUlgHTTF8I3KtWBjgBJpw8B14j2MSZp0eAWflaJ?=
 =?us-ascii?Q?V0I/i1QfLMOYHkXa6hrkj0EnUtHB13BLhS6QArcT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5881.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2253b4-4c11-429f-4dc4-08dcbff9c884
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2024 02:51:11.1039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qO/pML/0/Zz9WBufZVw+a+N3bRu4qXa3xaDjNQjWAM7pcOp+WX6TUfsCwcoADuTR7fQOYsHWIsq4RNCH4HL+7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7585
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 15, 2024 11:12 PM
> Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>; Lu Baolu
> <baolu.lu@linux.intel.com>; David Hildenbrand <david@redhat.com>;
> Christoph Hellwig <hch@lst.de>; iommu@lists.linux.dev; Joao Martins
> <joao.m.martins@oracle.com>; Tian, Kevin <kevin.tian@intel.com>;
> kvm@vger.kernel.org; linux-mm@kvack.org; Pasha Tatashin
> <pasha.tatashin@soleen.com>; Peter Xu <peterx@redhat.com>; Ryan
> Roberts <ryan.roberts@arm.com>; Sean Christopherson
> <seanjc@google.com>; Zhang, Tina <tina.zhang@intel.com>
> Subject: [PATCH 16/16] iommupt: Add the Intel VT-D second stage page tabl=
e
> format
>=20
> The VT-D second stage format is almost the same as the x86 PAE format,
> except the bit encodings in the PTE are different and a few new PTE featu=
res,
> like force coherency are present.
>=20
> Among all the formats it is unique in not having a designated present bit=
.
>=20
> Cc: Tina Zhang <tina.zhang@intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/Kconfig           |   6 +
>  drivers/iommu/generic_pt/fmt/Makefile      |   2 +
>  drivers/iommu/generic_pt/fmt/defs_vtdss.h  |  21 ++
>  drivers/iommu/generic_pt/fmt/iommu_vtdss.c |   8 +
>  drivers/iommu/generic_pt/fmt/vtdss.h       | 276 +++++++++++++++++++++
>  include/linux/generic_pt/common.h          |   4 +
>  include/linux/generic_pt/iommu.h           |  12 +
>  7 files changed, 329 insertions(+)
>  create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
>  create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
>  create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h
>=20
> diff --git a/drivers/iommu/generic_pt/Kconfig
> b/drivers/iommu/generic_pt/Kconfig
> index 2d08b58e953e4d..c17e09e2d03025 100644
> --- a/drivers/iommu/generic_pt/Kconfig
> +++ b/drivers/iommu/generic_pt/Kconfig
> @@ -90,6 +90,11 @@ config IOMMU_PT_DART
>=20
>  	  If unsure, say N here.
>=20
> +config IOMMU_PT_VTDSS
> +       tristate "IOMMU page table for Intel VT-D IOMMU Second Stage"
> +	depends on !GENERIC_ATOMIC64 # for cmpxchg64
> +	default n
> +
>  config IOMMU_PT_X86PAE
>         tristate "IOMMU page table for x86 PAE"
>  	depends on !GENERIC_ATOMIC64 # for cmpxchg64 @@ -105,6
> +110,7 @@ config IOMMUT_PT_KUNIT_TEST
>  	depends on IOMMU_PT_ARMV8_16K || !IOMMU_PT_ARMV8_16K
>  	depends on IOMMU_PT_ARMV8_64K || !IOMMU_PT_ARMV8_64K
>  	depends on IOMMU_PT_DART || !IOMMU_PT_DART
> +	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
>  	depends on IOMMU_PT_X86PAE || !IOMMU_PT_X86PAE
>  	default KUNIT_ALL_TESTS
>  endif
> diff --git a/drivers/iommu/generic_pt/fmt/Makefile
> b/drivers/iommu/generic_pt/fmt/Makefile
> index 1e10be24758fef..5a77c64d432534 100644
> --- a/drivers/iommu/generic_pt/fmt/Makefile
> +++ b/drivers/iommu/generic_pt/fmt/Makefile
> @@ -10,6 +10,8 @@ iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_64K)
> +=3D armv8_64k
>=20
>  iommu_pt_fmt-$(CONFIG_IOMMU_PT_DART) +=3D dart
>=20
> +iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) +=3D vtdss
> +
>  iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86PAE) +=3D x86pae
>=20
>  IOMMU_PT_KUNIT_TEST :=3D
> diff --git a/drivers/iommu/generic_pt/fmt/defs_vtdss.h
> b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
> new file mode 100644
> index 00000000000000..4a239bcaae2a90
> --- /dev/null
> +++ b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
> + *
> + */
> +#ifndef __GENERIC_PT_FMT_DEFS_VTDSS_H
> +#define __GENERIC_PT_FMT_DEFS_VTDSS_H
> +
> +#include <linux/generic_pt/common.h>
> +#include <linux/types.h>
> +
> +typedef u64 pt_vaddr_t;
> +typedef u64 pt_oaddr_t;
> +
> +struct vtdss_pt_write_attrs {
> +	u64 descriptor_bits;
> +	gfp_t gfp;
> +};
> +#define pt_write_attrs vtdss_pt_write_attrs
> +
> +#endif
> diff --git a/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
> b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
> new file mode 100644
> index 00000000000000..12e7829815047b
> --- /dev/null
> +++ b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
> @@ -0,0 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES  */ #define
> +PT_FMT vtdss #define PT_SUPPORTED_FEATURES 0
> +
> +#include "iommu_template.h"
> diff --git a/drivers/iommu/generic_pt/fmt/vtdss.h
> b/drivers/iommu/generic_pt/fmt/vtdss.h
> new file mode 100644
> index 00000000000000..233731365ac62d
> --- /dev/null
> +++ b/drivers/iommu/generic_pt/fmt/vtdss.h
> @@ -0,0 +1,276 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
> + *
> + * Intel VT-D Second Stange 5/4 level page table
> + *
> + * This is described in
> + *   Section "3.7 Second-Stage Translation"
> + *   Section "9.8 Second-Stage Paging Entries"
> + *
> + * Of the "Intel Virtualization Technology for Directed I/O
> +Architecture
> + * Specification".
> + *
> + * The named levels in the spec map to the pts->level as:
> + *   Table/SS-PTE - 0
> + *   Directory/SS-PDE - 1
> + *   Directory Ptr/SS-PDPTE - 2
> + *   PML4/SS-PML4E - 3
> + *   PML5/SS-PML5E - 4
> + * FIXME:
> + *  force_snooping
> + *  1g optional
> + *  forbid read-only
> + *  Use of direct clflush instead of DMA API  */ #ifndef
> +__GENERIC_PT_FMT_VTDSS_H #define __GENERIC_PT_FMT_VTDSS_H
> +
> +#include "defs_vtdss.h"
> +#include "../pt_defs.h"
> +
> +#include <linux/bitfield.h>
> +#include <linux/container_of.h>
> +#include <linux/log2.h>
> +
> +enum {
> +	PT_MAX_OUTPUT_ADDRESS_LG2 =3D 52,
> +	PT_MAX_VA_ADDRESS_LG2 =3D 57,
> +	PT_ENTRY_WORD_SIZE =3D sizeof(u64),
> +	PT_MAX_TOP_LEVEL =3D 4,
> +	PT_GRANUAL_LG2SZ =3D 12,
> +	PT_TABLEMEM_LG2SZ =3D 12,
> +};
> +
> +/* Shared descriptor bits */
> +enum {
> +	VTDSS_FMT_R =3D BIT(0),
> +	VTDSS_FMT_W =3D BIT(1),
> +	VTDSS_FMT_X =3D BIT(2),

VT-d Spec doesn't have this BIT(2) defined.

> +/*
> + * Requires Tina's series:
> + *
> +https://patch.msgid.link/r/20231106071226.9656-3-tina.zhang@intel.com
> + * See my github for an integrated version  */ #if
> +defined(GENERIC_PT_KUNIT) &&
> +IS_ENABLED(CONFIG_CONFIG_IOMMU_IO_PGTABLE_VTD)
> +#include <linux/io-pgtable.h>
> +
> +static struct io_pgtable_ops *
> +vtdss_pt_iommu_alloc_io_pgtable(struct pt_iommu_vtdss_cfg *cfg,
> +				struct device *iommu_dev,
> +				struct io_pgtable_cfg **unused_pgtbl_cfg) {
> +	struct io_pgtable_cfg pgtbl_cfg =3D {};
> +
> +	pgtbl_cfg.ias =3D 48;
> +	pgtbl_cfg.oas =3D 52;

Since the alloca_io_pgtable_ops() is used for PT allocation, the pgtbl_cfg.=
ias and pgtbl_cfg.oas can be provided with the theoretical max address size=
s or simply leave them unassigned here. Otherwise, it may seem confusing be=
cause the proper values may need to consult on VT-d cap registers.

The VT-d driver will assign valid values to those fields anyway when alloc_=
io_pgtable_ops() is being invoked.

Regards,
-Tina


