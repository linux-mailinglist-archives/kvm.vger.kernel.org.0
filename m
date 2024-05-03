Return-Path: <kvm+bounces-16542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 034A08BB522
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACDCA282331
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C7141C92;
	Fri,  3 May 2024 21:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y453/9a9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFB42E85E;
	Fri,  3 May 2024 21:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714770009; cv=fail; b=DDe9Q8Q7GG8XaqjQWszqm9vfffW0rsYo+FnZ467etCB4w24NI1L3Ez3Bk7/6DX04fFz6GQIwnpfXbeWQ6dBYujS3kxKcuTV7sx/nfhMcZBAzhvICNHcuP+7Zx0XleeOm0z1VNLp2YOgFAYGaYyrV3Mfj8EpRAl3aGi7URr+lQfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714770009; c=relaxed/simple;
	bh=RBD+YlrtBZUn7zrkwphstY3dD7VM/Drqb91BVP4QMfY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lRv+4j8TH6Xwd65/ItVcTvdnNGURUNtFd/E74j7/kIsWBYEQm99eo+IhhVzF/+oj1E83IAB1o4F974GOxbUYgD3e+pMCqtPdKT7gZJhdFkFWJKc9eLLnXF1TxkA/I7TTRojwdN3ZnySz2QSWPvarBL0WCr1tdcaCcZxYgkfQ5CY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y453/9a9; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714770008; x=1746306008;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RBD+YlrtBZUn7zrkwphstY3dD7VM/Drqb91BVP4QMfY=;
  b=Y453/9a9Q52OEnqWsgmd+IhMzR7GxZ7E5SDjRWS7vPpqMezZHOdRXMel
   YLwnY16n7YB8j/xHyHuoiGHNm+SJ0A3hYLAwU4/P+rDrVh5/qEYcma3w5
   /kE8bS66r2u88VKIOEFFYPtTHz00t2FRNeUts5MX5OK6Hzp8y3BL1PwUK
   jwwplVpqG/U6WMRJDFiBh++ULae/x11TQkhonZ0Bh2glwHanSPpMFtnj9
   3aSpjbKqm98l5GD2hvVh0ltxW4JDu5dC4be4MBWe3k1sMc5StyjsBmfU+
   ILw89BV5eNeXQ8SNs9RN31+0YMDc6Lo92rl8zeJ0Yvki0mBDZGgJ4h6Lg
   Q==;
X-CSE-ConnectionGUID: WYWAnS3mTDqbly5wdQHYdQ==
X-CSE-MsgGUID: Y6SmmAmyTQWe4Buj2XBEhw==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="28070835"
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="28070835"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 13:59:55 -0700
X-CSE-ConnectionGUID: T7F5SDVuSnaLlKxx/zdWEQ==
X-CSE-MsgGUID: FekrlNJDSKqCXU7eawDeXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="58466794"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 May 2024 13:59:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 13:59:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 13:59:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 3 May 2024 13:59:53 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 3 May 2024 13:59:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6kPo4ukJrcGWPfUDEGc/luea2Hy6JXfrgMD519+ikBMVeSUCZnL+vnyWaWrohZ3mL5Yp2iisIGyLaulHAwGdl4sxtdt9Hb3lwTMU8VoTc3PWU64fTWAlPD9qluEKPt5RVWwGno2KN2r6i7gjYmXuQ+HkeKcLqbGn5jCeex/+aI8ty7ai57X1WDtMaJeVeNU5SSd+9iPUgzu+dxNHoCvyG1bbpP9sgLifcxjsBT3fZ/BPkX3SiD/N/PZMVOpjF0gP2jhVQUA0mk6wMxuEEjGbq+ULFEwxN3oS7gCatQgs1i/5svzzdaEIAF1yz9yhvonKzP1Lh4Ie3mCb2ptOlxGuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTugDUHPgX9WPlOa9HW/PHiXZ9KNbwHXa3AuVrB2EO8=;
 b=S0FuIp/oIGlvGODFBBRAhf2wnVSxKr6gP1tQ2q4PdA6CPhY6ZjvmNsVU7zGWGVQ8nO/Yc62tbu7gBhyrz8ysVbNHTTfM4OmviweGOLm/+DhlCf/kIUmWswC64nvBtq0pPt7dOYGTjS/wj68rBNVgAf+oYNqZO/NcCF/KHGo6Yd2Yh4JulqXYTWRAocO4hiQzzotA00PIoHYOpZ67GnK611+opULxiEuxWp9vxtOi37eVCPI66zC/hkB43Hr8CF130Y0zOhUiP0dfLdbnkAta+Cgpp6B6crqD0ll38TgE5RUJlJE1/wWFulP8hlXk8boXWN82Tj5RAru2Dgl8iq4yhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6991.namprd11.prod.outlook.com (2603:10b6:806:2b8::21)
 by IA0PR11MB7881.namprd11.prod.outlook.com (2603:10b6:208:40b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.25; Fri, 3 May
 2024 20:59:46 +0000
Received: from SA1PR11MB6991.namprd11.prod.outlook.com
 ([fe80::c06c:bf95:b3f4:198d]) by SA1PR11MB6991.namprd11.prod.outlook.com
 ([fe80::c06c:bf95:b3f4:198d%5]) with mapi id 15.20.7519.021; Fri, 3 May 2024
 20:59:46 +0000
From: "Zeng, Oak" <oak.zeng@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: "leon@kernel.org" <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Robin Murphy" <robin.murphy@arm.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, "Chaitanya Kulkarni" <chaitanyak@nvidia.com>, "Brost,
 Matthew" <matthew.brost@intel.com>, "Hellstrom, Thomas"
	<thomas.hellstrom@intel.com>, Jonathan Corbet <corbet@lwn.net>, Jens Axboe
	<axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg
	<sagi@grimberg.me>, Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Bart Van
 Assche" <bvanassche@acm.org>, Damien Le Moal
	<damien.lemoal@opensource.wdc.com>, Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "jack@suse.com"
	<jack@suse.com>, Leon Romanovsky <leonro@nvidia.com>, Zhu Yanjun
	<zyjzyj2000@gmail.com>
Subject: RE: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Thread-Topic: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
 steps
Thread-Index: AQHanOEtbi0VHTnLn0mNwgftYB7xRbGEmFqggAEftYCAAEFXcA==
Date: Fri, 3 May 2024 20:59:46 +0000
Message-ID: <SA1PR11MB6991A710795ED04C73D01B5F921F2@SA1PR11MB6991.namprd11.prod.outlook.com>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
In-Reply-To: <20240503164239.GB901876@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6991:EE_|IA0PR11MB7881:EE_
x-ms-office365-filtering-correlation-id: 03a2ea51-8a47-4eec-27cf-08dc6bb3f6a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?CWngZ6ANHgyxLimCmXBYFoNZeiJvbM/Bdt4t+no6A36z3SVALepJ4sUpa0?=
 =?iso-8859-1?Q?3VzGba8F5KgBs0gaFWhvNlesKcMiPpBT9jz9I0BOAwd8BTL8Ag8xptHT+4?=
 =?iso-8859-1?Q?IjLNKG7tDmxIWHwFESfexXbrrxWWCe0LRTVy4CCGuJPMBIV4iA+EfBXeto?=
 =?iso-8859-1?Q?nkpGtJr1sXG1Ot8QHwAQmAyKXmu3s6ljVL5w2eK5BhndYzGUjtEekVZfJf?=
 =?iso-8859-1?Q?YZKnKr+B1qg6b/TqE6l8QfIxAyQvTDqWZiXPk4tyLdT4HQumRSRPreYHjB?=
 =?iso-8859-1?Q?pWNuKxKb9xTG+kDcVaiAcDHx2eojrKCTSYP89jW67w3tbBOYNhaiDXu5HZ?=
 =?iso-8859-1?Q?yYwh22TOkt/YOeisw0s4y4UxHL+y5IZ7UJ4JTWrIZctiTyTvu5pR+JyRlg?=
 =?iso-8859-1?Q?sF02bzTNLErrDQbQbZzLPBQRqtdJChQIWs4ZMnMCB/zW572yr+N+yxlNm1?=
 =?iso-8859-1?Q?tTeWgZ1AYwUrWKBBzICK1/iXZRtYoFm5jGAIHuM+g5RoKB2ToTV2H/vvi2?=
 =?iso-8859-1?Q?0a9EwMXBE+XI/meRC12MLHmcUoRWLON5RC09WrgY/LdWXpy/Y2mglabk2n?=
 =?iso-8859-1?Q?SPEvhfAy6EieopRYQ7d0TU3TCs1RRYrIFY0vwIAJQOGI6ue1yF/MZP19zN?=
 =?iso-8859-1?Q?1S6D0/4spz300nTJYMpqYu2sTJlgu3gCZ7wAjs6JA0CKAapJdt1pnf1zOl?=
 =?iso-8859-1?Q?qZgw8i2CkAFtSTzVigtgqeNQDi0hk3nkax0X7NkeGzLeHczm23BEzQ9/t6?=
 =?iso-8859-1?Q?vjmK7jPYZAEzxfPHRe+aNwhl6Ekh8PjWzPT76KbDVvIWYCdip7f9kO4hZ2?=
 =?iso-8859-1?Q?oU6ukwBFJgMWnm02xGVMFsGhrA70epl6Y5+whpiFQUwzuAzxSIZNh3jzH9?=
 =?iso-8859-1?Q?mLlu7LmL9XheR3LPUCi8SIW/pReTnEXchmxKUxNRIZkldpnQ+aumYOWS7i?=
 =?iso-8859-1?Q?nH8UcOZ6DX1ZGYEmFRoe0YfkKgGd9mWs32/XIjl+j6w+41J6CE1PTPefy6?=
 =?iso-8859-1?Q?abYesh4pV4aBetcPecMhzWtz09bFEiUKnLMcAb+SwCBRirFk8iPMr7HhIX?=
 =?iso-8859-1?Q?HTDnbeB1TjtrCNRKbhalso+V7hy21/zyMLI4zqXb034ReQfjFVWsMJ7zww?=
 =?iso-8859-1?Q?zitRuT5LNDm+jlWtsqODxVRjhtbYELoD0vOECF+Dp0rR9XB1LmrNpP8hdO?=
 =?iso-8859-1?Q?wo+QUnMBVkOmJ7LCCmw76kanYK3O4MSL3V2hB4VoJwuO+rnlwFVlfeB1w2?=
 =?iso-8859-1?Q?g0F4h4S/eenddfs2MhwIA4tP3j/iUj8Q7YtbCxmMNB5ROaUJ5RlZAZqlfw?=
 =?iso-8859-1?Q?qryn97RUEHuiWxcfdFTyqYhwXIJqlqueRC2pZar3zyP88Z3gDprQj6wJnP?=
 =?iso-8859-1?Q?w4aQolpXKX9odborOETmFkLLXyyL0DEA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6991.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?FewmDS3gXgBrW1Ij/V37oZHE9hRlID64MXpGgMwnHlpfjO/VWaWFP94f3J?=
 =?iso-8859-1?Q?bRjItLLgPS6rwt3MwvNQlBgIUKYyG25bqvCMhaxg+8R6UETkeB5gD7GF4E?=
 =?iso-8859-1?Q?l0Au2kLVQDcvuNg/BbkjDma6ua1hfThmXKGiWzHB3L8gAyXcZkD89Yo4Ye?=
 =?iso-8859-1?Q?08pmswL9vy45zjMie5AUGps+ifQ/UGae9pcfqezck6DH1FihPMGiK/EbPH?=
 =?iso-8859-1?Q?Oomllc1EC25xGG0xAJW+ZxbuVQHqqfXMz/rPZdw/L0Y+QMM1lAWD/XkeQO?=
 =?iso-8859-1?Q?R2rSJUxlTxIGYciQ3/jWunEhHTTKVSqJaF8cXCOE48BqRDLA1GCj1o7a39?=
 =?iso-8859-1?Q?GKotS1Oh2I6BRg3c6EIfZstpXms/3t62e1IdOs15nIWv4WzQ2xaIV+v6bk?=
 =?iso-8859-1?Q?+Q8cMTEydrwdIc2r2/Ty2pfC8O9BU3sU7A/SqvdJqu4nj/kanNtdGVH/tR?=
 =?iso-8859-1?Q?ZSlyc/dIOeMDkLE8NXCJgJbj3xaMrakx0IRvaVW6njlY176KCQMK0nYy42?=
 =?iso-8859-1?Q?PA2ynSRJpa7mP3/YY9uK2SEkJHZNrR/fGMYWdMMH1TjSo8fFmnps7xUjgJ?=
 =?iso-8859-1?Q?go/1+kjtgwPOkQB2BDTjuLX0j+Wr007A7kycC5PG8XfABnrgF0pQYfuqnl?=
 =?iso-8859-1?Q?jdMeV+Vm1YBNipkEqM/rrgnS7H9ilOaom9wBzX4R5IdL/zUjxKJw7A9lSm?=
 =?iso-8859-1?Q?AM1LbEBdm6ojJT4bSoYnQIqFkGzoqchfw3zaurOjxCpo26PRqvIlPJYrZs?=
 =?iso-8859-1?Q?eniD/dzmc4Wsdip6M7hCTZ/8bu05Ri+UoSwS5eEvBZqH/uSBpBXBc9Mc3P?=
 =?iso-8859-1?Q?DtZDy9FE/R1Xge/QVyqCptGgyGJB4MKO743xv7QYLoR/vRYqYRYE0rT46y?=
 =?iso-8859-1?Q?wgp5nVLKR3nXp6eYOmFNRMSn1SKwGtWJmn1tUw8pxrGHJXBVzfGXJVNQ2Z?=
 =?iso-8859-1?Q?CWMYqXGZA0EhQatUM2YPxPPOh7QAKmzbOUGYCbf+YxbIHD9SgLvaQXEx8V?=
 =?iso-8859-1?Q?BqDx29VuP+1217du+zUL4sEswp64F3UbMieuxKInPzn079VB1TL4KS8OaX?=
 =?iso-8859-1?Q?smgZnDEel0EhnEmpr8zNf/JWmrzpUGUylsKG8Fc/5K3WfJXk/nYKLyUneT?=
 =?iso-8859-1?Q?Qfv7di53pWhIOehS4GUG47XVeIb1zI7j6+Wj/cYIkmDhgveb7mnctVO2ec?=
 =?iso-8859-1?Q?ZHdlyDNYlLVUv+EDsjRP/1/WV91BUdqlHYV+PhR7uJ8nn8InaOHozqS6FM?=
 =?iso-8859-1?Q?h5WAGuclVISeLv9cAK6qgE9l6g3WQ4PBt8etXlYHOpEZZn8WUW88GeUdml?=
 =?iso-8859-1?Q?l+/8awMH9jX6EGYFWhs8G0Ow2UWMKZrIh2Pa1cyN4TNTr/xydJYJgZ7kfE?=
 =?iso-8859-1?Q?qqD7ahmGEyRuVkkD88aSIUz72m5pJf5lc0mhnDYc8ugRDGh7dMPJl+W4S4?=
 =?iso-8859-1?Q?hipuguMxIXjBDWR0fCAYCk07/PngEmDEtd77PZho47YCvvAFgOnrl6DDQX?=
 =?iso-8859-1?Q?gLPbQYFcd/fWigBJbWt3lWtGkR25yMxf/944ZMCClAuutvwNu7f4N0GwQR?=
 =?iso-8859-1?Q?n3YzKDYRyTR64cKB6TTw3bWMWbOER2U6REeVA3oLpzdizaoE1JdYtW0Dsz?=
 =?iso-8859-1?Q?Al6/+VgSerBLk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6991.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a2ea51-8a47-4eec-27cf-08dc6bb3f6a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 20:59:46.0709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fbZP8CB1kBTx6AOAP4vjBF2gGXRN8b4SPZmG/IecYqAbsF7jRhKhOlrPlxJBUtKWKISY0tbH4uDc6/HSwtlksg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7881
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, May 3, 2024 12:43 PM
> To: Zeng, Oak <oak.zeng@intel.com>
> Cc: leon@kernel.org; Christoph Hellwig <hch@lst.de>; Robin Murphy
> <robin.murphy@arm.com>; Marek Szyprowski
> <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
> Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
> <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>; Jens
> Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
> Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian, Kevin
> <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> J=E9r=F4me Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> foundation.org>; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> <bvanassche@acm.org>; Damien Le Moal
> <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
> <dan.j.williams@intel.com>; jack@suse.com; Leon Romanovsky
> <leonro@nvidia.com>; Zhu Yanjun <zyjzyj2000@gmail.com>
> Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> two steps
>=20
> On Thu, May 02, 2024 at 11:32:55PM +0000, Zeng, Oak wrote:
>=20
> > > Instead of teaching DMA to know these specific datatypes, let's separ=
ate
> > > existing DMA mapping routine to two steps and give an option to
> advanced
> > > callers (subsystems) perform all calculations internally in advance a=
nd
> > > map pages later when it is needed.
> >
> > I looked into how this scheme can be applied to DRM subsystem and GPU
> drivers.
> >
> > I figured RDMA can apply this scheme because RDMA can calculate the
> > iova size. Per my limited knowledge of rdma, user can register a
> > memory region (the reg_user_mr vfunc) and memory region's sized is
> > used to pre-allocate iova space. And in the RDMA use case, it seems
> > the user registered region can be very big, e.g., 512MiB or even GiB
>=20
> In RDMA the iova would be linked to the SVA granual we discussed
> previously.

I need to learn more of this scheme.=20

Let's say 512MiB granual... In a 57-bit virtual address machine, the use sp=
ace can address space can be up to 56 bit (e.g.,  half-half split b/t kerne=
l and user)

So you would end up with  134,217, 728 sub-regions (2 to the power of 27), =
which is huge...

Is that RDMA use a much smaller virtual address space?

With 512MiB granual, do you fault-in or map 512MiB virtual address range to=
 RDMA page table? E.g., when page fault happens at address A, do you fault-=
in the whole 512MiB region to RDMA page table? How do you make sure all add=
resses in this 512MiB region are valid virtual address? =20



>=20
> > In GPU driver, we have a few use cases where we need dma-mapping. Just
> name two:
> >
> > 1) userptr: it is user malloc'ed/mmap'ed memory and registers to gpu
> > (in Intel's driver it is through a vm_bind api, similar to mmap). A
> > userptr can be of any random size, depending on user malloc
> > size. Today we use dma-map-sg for this use case. The down side of
> > our approach is, during userptr invalidation, even if user only
> > munmap partially of an userptr, we invalidate the whole userptr from
> > gpu page table, because there is no way for us to partially
> > dma-unmap the whole sg list. I think we can try your new API in this
> > case. The main benefit of the new approach is the partial munmap
> > case.
>=20
> Yes, this is one of the main things it will improve.
>=20
> > We will have to pre-allocate iova for each userptr, and we have many
> > userptrs of random size... So we might be not as efficient as RDMA
> > case where I assume user register a few big memory regions.
>=20
> You are already doing this. dma_map_sg() does exactly the same IOVA
> allocation under the covers.

Sure. Then we can replace our _sg with your new DMA Api once it is merged. =
We will gain a benefit with a little more codes

>=20
> > 2) system allocator: it is malloc'ed/mmap'ed memory be used for GPU
> > program directly, without any other extra driver API call. We call
> > this use case system allocator.
>=20
> > For system allocator, driver have no knowledge of which virtual
> > address range is valid in advance. So when GPU access a
> > malloc'ed/mmap'ed address, we have a page fault. We then look up a
> > CPU vma which contains the fault address. I guess we can use the CPU
> > vma size to allocate the iova space of the same size?
>=20
> No. You'd follow what we discussed in the other thread.
>=20
> If you do a full SVA then you'd split your MM space into granuals and
> when a fault hits a granual you'd allocate the IOVA for the whole
> granual. RDMA ODP is using a 512M granual currently.

Per system allocator requirement, we have to do full SVA (which means ANY v=
alid CPU virtual address is a valid GPU virtual address).=20

Per my above calculation, with 512M granual, we will end up a huge number o=
f sub-regions....

>=20
> If you are doing sub ranges then you'd probably allocate the IOVA for
> the well defined sub range (assuming the typical use case isn't huge)

Can you explain what is sub ranges? Is that device only mirror partially of=
 the CPU virtual address space?

How do we decide which part to mirror?


>=20
> > But there will be a true difficulty to apply your scheme to this use
> > case. It is related to the STICKY flag. As I understand it, the
> > sticky flag is designed for driver to mark "this page/pfn has been
> > populated, no need to re-populate again", roughly...Unlike userptr
> > and RDMA use cases where the backing store of a buffer is always in
> > system memory, in the system allocator use case, the backing store
> > can be changing b/t system memory and GPU's device private
> > memory. Even worse, we have to assume the data migration b/t system
> > and GPU is dynamic. When data is migrated to GPU, we don't need
> > dma-map. And when migration happens to a pfn with STICKY flag, we
> > still need to repopulate this pfn. So you can see, it is not easy to
> > apply this scheme to this use case. At least I can't see an obvious
> > way.
>=20
> You are already doing this today, you are keeping the sg list around
> until you unmap it.
>=20
> Instead of keeping the sg list you'd keep a much smaller datastructure
> per-granual. The sticky bit is simply a convient way for ODP to manage
> the smaller data structure, you don't have to use it.
>=20
> But you do need to keep track of what pages in the granual have been
> DMA mapped - sg list was doing this before. This could be a simple
> bitmap array matching the granual size.

Make sense. We can try once your API is ready.=20

I still don't figure out the granular scheme. Please help with above questi=
ons.

Thanks,
Oak


>=20
> Looking (far) forward we may be able to have a "replace" API that
> allows installing a new page unconditionally regardless of what is
> already there.
>=20
> Jason

