Return-Path: <kvm+bounces-20533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1567B917B12
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 10:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 934481F234BC
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 08:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A78B16193C;
	Wed, 26 Jun 2024 08:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LNGnCRij"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43052144D1D;
	Wed, 26 Jun 2024 08:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719390998; cv=fail; b=d1BUnAKaKRbs/lnDgfCgQfaA3p3vANWt8v1IgEr1aCRJoyVxrI7TXervK8Sa99zE8gLIHqm4JlYqLAloxhfpYlcwfq5fM9pQZQVENcxMkCd4OahFQ5mntYJ2hNlsvBYonqxOaqiN9M/NAztIiGZbaevFVn/Bycc39xgHvgXSwuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719390998; c=relaxed/simple;
	bh=oI3nUeOisUSLzYgGHHxrNSzGV/DbB0j5x3i8dr6M2EQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lZ8LEcCPD6P673z8aEM+8AoraecB/K9/Kvp/ChT70YVb5aE0pZXmtPKGojCPba9JazVgAKlqkj3Ytf4YXOxLboivCEHmjf7Lvw9V9+c+/1zx8MXfSROOM8q67HbSlm0b8Do9W12iVAtpisdyOtq3XQNM6gD3TETmmwQf4jgUi4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LNGnCRij; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719390996; x=1750926996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oI3nUeOisUSLzYgGHHxrNSzGV/DbB0j5x3i8dr6M2EQ=;
  b=LNGnCRijoRhXtL07YwyZCqRZ3MRs5bxKAxXBsse9dlxrTSuYSBetbUL6
   S7H5BS8PqlnsmSApIKlddAbE+876WdMSMMpIVizXadB0ZqGd5hwcGOy6j
   ux5KVo67e8gj8fG5J+EPstb76UdFo/skuCU4kvEe1HQrhREaIA7OnK2hJ
   KfTnRMreS1xY4o1Aq319BwqVhc2leSdyqDRFjF9xGLDv6d1UCyMqU+ugX
   RKrr9rdfw/lnisKxttGMbgoCPYBYggPhOb/8neO0Ym+VfS2sjTq/pxTZV
   /1qH/0dj9Z+WvKvB+nHXE4J4x24vn+BT9kVn9E1SRo7OPMsSFurp6lL6A
   A==;
X-CSE-ConnectionGUID: UN2ARAtrTueF/yXrw7NbFg==
X-CSE-MsgGUID: QxzzvRRzRmGyh+Xyw1tRCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16277674"
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="16277674"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 01:36:35 -0700
X-CSE-ConnectionGUID: N8g12G4ASfC+pqBBUefbSQ==
X-CSE-MsgGUID: 6DGTJEN/SdqSlfilibbc8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="75140741"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jun 2024 01:36:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 01:36:34 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 01:36:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 26 Jun 2024 01:36:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Jun 2024 01:36:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apf2JR3kOHiM98/YGvgVXnm4jk0PXuh8v3NTT1zNxnTKbH6FE+5afkFd4ugEGMIS9iS5IwFadEVR6RB3spZ6sk4QOezIxaAqjJ4rJwNbbHXwkvPmbdB1vfUQLTyx4I97b5pofIQAtIi8Fr0cdLzAj+iuEoSh8qeXnVZaEWHnXP0NUS0bcTk1oU1/qSC9AwFwfndMnHRbTK3Vz2xdWxACAeN0jK0UInOt7STIxU73hPYRH3MsXzFsm0Y1VJrStnLVv3bQzhqiC/NNhxSdI41Qa30IYhbdiZB1/NvNdGZgBkiiE1QGPMsWRMn9uKBoH3HH4VgU+dRjPpIceI2tc26BjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7QTbiOjUlXc3Wu3HSN0Wahn356/h4DoGhw2kZHYM+U=;
 b=XoGluPha2oUNGVDn+ngZTl78TBSkmrgr8I706nPRyQ+KVA/lLyIhpswpd2PZuF/jFE2k6Yw6qhzGeWCPorhV6UNA3kqvjbhWAuVMAe57E+bPosMV+vWjKROrOzXdQwmzYuTtX4HxT/RvKtOlauwn2xykTaXsGAXL6V58cFijeaofS58saf8Pmt/scQvSJMVgHX06Og20gC4YEA7Li6L4DMgeEkP6mAv1pIvVfopWQTz6VApqCvL4UVc1mzk684m+9LuIssTlUVV2FMBjXnFz8MlwGLvIJFB1JvEEPTjRZpXrvRIGkORe6C9g8H7ER9A7PJrOs5uQ1HMCyROEpCALKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7671.namprd11.prod.outlook.com (2603:10b6:a03:4c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 08:36:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7698.032; Wed, 26 Jun 2024
 08:36:26 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: RE: [PATCH] vfio: Reuse file f_inode as vfio device inode
Thread-Topic: [PATCH] vfio: Reuse file f_inode as vfio device inode
Thread-Index: AQHawJxm3I/CN7lO/0SZyxULdM6QfbHQdBwAgAlRPtA=
Date: Wed, 26 Jun 2024 08:36:26 +0000
Message-ID: <BN9PR11MB527603C378C5D0DA1294ED268CD62@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <ZnQBEmjEFoO39rRO@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZnQBEmjEFoO39rRO@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7671:EE_
x-ms-office365-filtering-correlation-id: b05a520a-3048-42d7-f869-08dc95bb117f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230038|366014|376012|1800799022|38070700016;
x-microsoft-antispam-message-info: =?us-ascii?Q?kAWBRbbcmfBYYmvGb1KT/OxjPcMxVPM3RRuJYWa4lnoJ/EYk9JkHW0GVCvMS?=
 =?us-ascii?Q?Kw9S99BagYQqqjwTHCiLkflhcTTrDZgVFjRqY/Z3vKig0EhQWJKf4dA1jd4u?=
 =?us-ascii?Q?N03FB82xddrVhtMmpPFzaQEZCx3CRRPHDSG2FSaRNLNSA0WZhEGIWD0KQSUB?=
 =?us-ascii?Q?ICCRANntk+qCcQG080Fk/ZSGEY4EuTE2PY9Q3WRF+qwZRPgjDgclwlXodkZN?=
 =?us-ascii?Q?7gXoeNu0A0pa0ElP6QM7Gotp/7Spg+aisZPS7qaqJGClbAlndTQRSrBOQyKL?=
 =?us-ascii?Q?F++hdgSUa8LqVyJSmNvWZLVj9yaHs0ep5Z9deprKJVJUGROsnmp9ioZnheE9?=
 =?us-ascii?Q?7DbPD9OIo53biAU5xGwY4F+bycZArJC8WIiNEgI8KRbxm4y66CLACuV7UFPr?=
 =?us-ascii?Q?7uUp14ce/nUK5PrLBe+9S3VaLF03+Y5HrXaUS75Fn7z+Q8uXXxS/V0/oTPvX?=
 =?us-ascii?Q?Z3PbPK00xHOu/ArEhgwFTL5B+F5wTQFAa5cz+z/2bpsCMpXzHibDtzr2qY9D?=
 =?us-ascii?Q?arJCASghHagrpMMi7MZWpdC882YESyruUun/q7lDn9YasHAa5SZD7Uw/sBfj?=
 =?us-ascii?Q?TBYt0IF3TezbQSoaup4C+J3B3rRBQ43gUpUU4e2aR0774Ty8uNBpLvz96Imo?=
 =?us-ascii?Q?J5S1GyZ+fFiyfigPGzUKsTdvAGq76FL4RygEUnLVtchG9obSf16stI7LPN1S?=
 =?us-ascii?Q?K1bV0yIms0rl9kGItg1W0ybeGGZvFgWPWjMjAdB/RQqg7KjC1zcoXzbKBPUP?=
 =?us-ascii?Q?3pq+o/gSlXcr+IfQjsuOEQwrQhywHiqsbRUCRQzSGEwyQYe0Aspg0EWmVLgQ?=
 =?us-ascii?Q?3tAoT7O/73khho1cWL57cD8kQh0U9bOvZGbB3r28L73a+GG0Z6jWibEAS8s9?=
 =?us-ascii?Q?1NO82qRzzOYJXukxuJ1vuJ1KjNy9T0H+6H4PszQNhdiI+VxrwQDkiI4P6gtp?=
 =?us-ascii?Q?JkZZDZTYc0GPOJi8qC+l5duX9F+O0B0Dsz1uFR0gP2bTb4aO/GftTskh82c8?=
 =?us-ascii?Q?HIxJccSOY6h26iU115EODDC/FIFCeJHGImGNfV/VHVOXU077s7niYswnPp0H?=
 =?us-ascii?Q?ej3KORm9arI7CNGl16zweXH9C+fkvuiBEQuC+FtIjqB7N/XrW3HHwcpVbGk2?=
 =?us-ascii?Q?8CDyx8t7U3Ln8hHYyAh18BX0KFRY+bjXaGr87JcSCPPefyCpvsSMlL/PkxH9?=
 =?us-ascii?Q?PnC2TmwnOhezbnjuLIwST0f0dt+gJd02xzYIAXXaXyl8XQxPk+vZQwmDR+9E?=
 =?us-ascii?Q?1oiuZ3kiE6Adf72wgA2Uh0wbj6ZgY5joas8wkf3Y6D5COrUq/QR7vaWGT/rI?=
 =?us-ascii?Q?x0RKgV6WSRL9MHmPOsClbMq74IQ6pSedcWTzpjp38ShNdharTGFeN4zH7nlf?=
 =?us-ascii?Q?0dfoKYWpOnexUEbmXHmHPKDbVYZKqJrF1PpQAxxlyVApk6X7oQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aEUQjV2ffZRz1ZR8/9vqR2Wsq0Q3fSkDTypV1XbUh624xfbOlaCWQ1nsWrJe?=
 =?us-ascii?Q?7Rt8cfq/9IDBXNygaGhZk5zmQlUC1SOPGhN5kvCmc4qujozeqFoUnrwEkjQu?=
 =?us-ascii?Q?KUEgflYpbO5Y2OFFasWJD7hs5JpKfNUFOU4RAEsC3sj2RegjV8m/H14kdfJg?=
 =?us-ascii?Q?O3T0cjyygLBZGgci8Z/U3Y7q1AOMulyJFyUyMJh6XXOJ7RJ5iEBwvFnHNOzk?=
 =?us-ascii?Q?JRO6RB6tNJjyTCWvQNMTBwVR/iVvUYwORFvTMqUD/XhIXEg7Q8Y75xQHvEkN?=
 =?us-ascii?Q?3cXjdpCpl7bkcbajRqlsDzcfvrM3qeGxxome047raT0Zw4VOPSTz01eftpKg?=
 =?us-ascii?Q?WR9AgphkK6rBiVdjnzm3aQrNbfXmo5gNkk8++xp6Y1sr+1egJscNpHW9jRmJ?=
 =?us-ascii?Q?oTCauH/PBQVecyILMTtJO2kpnaMqwdowIe1uk7/5NZxajCh1oz1GHFZ3FdTs?=
 =?us-ascii?Q?YMotWW0JPwHjTE5Kd5202hhS8OcLuD61FoUkd2Jip91PeM0a99S9vyJQFTB6?=
 =?us-ascii?Q?mVP05YvwdUNez2aoAEJihqdkY4FPxSo9t5jwRJxxsjlUYJlcRhmOXDDOIbrx?=
 =?us-ascii?Q?k+EG8wjjnHa/Ya23JmsR4rwv60rTiSCxKAQBJeCRavrRKqx+op/u6b134QeK?=
 =?us-ascii?Q?IjnNibTefuo9c5swDKGPkeMS2HNNqeaS1K6wKALcgbcjGqWxQyl38kP8+vYL?=
 =?us-ascii?Q?1NyXQjTlVHhnnlUjUdhb8qFf7PbRRnhnZi7wRgReT2URRt0gyMVYTn/lt8da?=
 =?us-ascii?Q?BeY8QuvQJePoaXZg2DgfqMIoCIvqkXskiKMQKX1yBstBbXXbg2WEL/lXvN/P?=
 =?us-ascii?Q?QEX/3eRALOTQF0s+R494juSuu1HOivdZ0cJpn/f2bmFqApFN4CdzVzQdNzDy?=
 =?us-ascii?Q?hpw1zyKJlymq638LVoQKVZ5a/+bz/6fkGK9dIRtRairZosx66L7rqzvwDKph?=
 =?us-ascii?Q?tbTu5iis31tbYsDQgoSo1FrI0kmUO4NazUo5l2LvOV1/RuQHhw/Eu98+Cqab?=
 =?us-ascii?Q?bNPCRwc7iG5kbqkdvDlEH/8pmyg+qW7fQsWRll0jK49oCV1kE9803i9/Un6w?=
 =?us-ascii?Q?CXu5TrRYmmBkquMtUVWRuXqz4VjN6nQ+ANxPnoBOoZKEuKu7XjFtOszQfC2E?=
 =?us-ascii?Q?MO8Le+aFLWqu4bFh1G6IzHFU8eLEdwgGM6iPSR+/OrTuuKm/KqcL1dIQYmQd?=
 =?us-ascii?Q?EewcZeOkhKPb+6f7pZmzkjwc/c3QYFhZPKMXB83asE/DvSZjMxDlCFWVoeQy?=
 =?us-ascii?Q?CsHu8yN/CYELDtZ/6b97vpbuowdYpR3DxB+lif780Pyj5kO2aXUE7aAo6iZD?=
 =?us-ascii?Q?tSvvMfULwtI4QmVntFTm+s9ON9nz5Lyp4uuS8afgR9xBB1EQi2hD8ob5sQc+?=
 =?us-ascii?Q?Cvkc8iIPxR3avQ5qT/s0Sy7LyobaLdVSRxohd+2hq6W/4PttWHdLLKLNS6dm?=
 =?us-ascii?Q?Bs/i3C6g55oCmWYWsBeJHViG+W4O/HdlaOmM7LJO9mdnhixk8dENVAyn27eB?=
 =?us-ascii?Q?/qQKv15B45bGQ2hrDeMNxk5gbzh2zF4zRVAxZH5tfRQOI1ToqKoznop3K00P?=
 =?us-ascii?Q?l7av7BuwsEBgRFGk8ZESpZtAIdz3mYrF6Qd2i37I?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b05a520a-3048-42d7-f869-08dc95bb117f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2024 08:36:26.4496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EQ6D/ACLWCsgkfvlR5LzB9NT9gyPg+UEOLzXScn2ivYJglPqOj15eM4O2EIZLUPCCEHgJ/haEESRVM9ldmIiJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7671
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Thursday, June 20, 2024 6:15 PM
>=20
> On Mon, Jun 17, 2024 at 05:53:32PM +0800, Yan Zhao wrote:
> ...
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index ded364588d29..aaef188003b6 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -268,31 +268,14 @@ static struct file *vfio_device_open_file(struct
> vfio_device *device)
> >  	if (ret)
> >  		goto err_free;
> >
> > -	/*
> > -	 * We can't use anon_inode_getfd() because we need to modify
> > -	 * the f_mode flags directly to allow more than just ioctls
> > -	 */
> > -	filep =3D anon_inode_getfile("[vfio-device]", &vfio_device_fops,
> > -				   df, O_RDWR);
> > +	filep =3D vfio_device_get_pseudo_file(device);
> If getting an inode from vfio_fs_type is not a must, maybe we could use
> anon_inode_create_getfile() here?
> Then changes to group.c and vfio_main.c can be simplified as below:

not familiar with file system, but at a glance the anon_inodefs is similar
to vfio's own pseudo fs so it might work. anyway what is required here
is to have an unique inode per vfio device to hold an unique address space
and anon_inode_create_getfile() appears to achieve it.

>=20
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index ded364588d29..7f2f7871403f 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -269,29 +269,22 @@ static struct file *vfio_device_open_file(struct
> vfio_device *device)
>                 goto err_free;
>=20
>         /*
> -        * We can't use anon_inode_getfd() because we need to modify
> -        * the f_mode flags directly to allow more than just ioctls
> +        * Get a unique inode from anon_inodefs
>          */
> -       filep =3D anon_inode_getfile("[vfio-device]", &vfio_device_fops,
> -                                  df, O_RDWR);
> +       filep =3D anon_inode_create_getfile("[vfio-device]", &vfio_device=
_fops, df,
> +                                         O_RDWR, NULL);
>         if (IS_ERR(filep)) {
>                 ret =3D PTR_ERR(filep);
>                 goto err_close_device;
>         }
> -
> -       /*
> -        * TODO: add an anon_inode interface to do this.
> -        * Appears to be missing by lack of need rather than
> -        * explicitly prevented.  Now there's need.
> -        */

why removing this comment?

>         filep->f_mode |=3D (FMODE_PREAD | FMODE_PWRITE);
>=20
>         /*
> -        * Use the pseudo fs inode on the device to link all mmaps
> -        * to the same address space, allowing us to unmap all vmas
> -        * associated to this device using unmap_mapping_range().
> +        * mmaps are linked to the address space of the filep->f_inode.
> +        * Save the inode in device->inode to allow unmap_mapping_range()=
 to
> +        * unmap all vmas.
>          */
> -       filep->f_mapping =3D device->inode->i_mapping;
> +       device->inode =3D filep->f_inode;
>=20
>         if (device->group->type =3D=3D VFIO_NO_IOMMU)
>                 dev_warn(device->dev, "vfio-noiommu device opened by user=
 "
>=20
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index a5a62d9d963f..c9dac788411b 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -192,8 +192,6 @@ static void vfio_device_release(struct device *dev)
>         if (device->ops->release)
>                 device->ops->release(device);
>=20
> -       iput(device->inode);
> -       simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
>         kvfree(device);
>  }
>=20
> @@ -248,22 +246,6 @@ static struct file_system_type vfio_fs_type =3D {
>         .kill_sb =3D kill_anon_super,
>  };

then vfio_fs_type can be removed too.

>=20
> -static struct inode *vfio_fs_inode_new(void)
> -{
> -       struct inode *inode;
> -       int ret;
> -
> -       ret =3D simple_pin_fs(&vfio_fs_type, &vfio.vfs_mount, &vfio.fs_co=
unt);
> -       if (ret)
> -               return ERR_PTR(ret);
> -
> -       inode =3D alloc_anon_inode(vfio.vfs_mount->mnt_sb);
> -       if (IS_ERR(inode))
> -               simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> -
> -       return inode;
> -}
> -
>  /*
>   * Initialize a vfio_device so it can be registered to vfio core.
>   */
> @@ -282,11 +264,6 @@ static int vfio_init_device(struct vfio_device *devi=
ce,
> struct device *dev,
>         init_completion(&device->comp);
>         device->dev =3D dev;
>         device->ops =3D ops;
> -       device->inode =3D vfio_fs_inode_new();
> -       if (IS_ERR(device->inode)) {
> -               ret =3D PTR_ERR(device->inode);
> -               goto out_inode;
> -       }
>=20
>         if (ops->init) {
>                 ret =3D ops->init(device);
> @@ -301,9 +278,6 @@ static int vfio_init_device(struct vfio_device *devic=
e,
> struct device *dev,
>         return 0;
>=20
>  out_uninit:
> -       iput(device->inode);
> -       simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> -out_inode:
>         vfio_release_device_set(device);
>         ida_free(&vfio.device_ida, device->index);
>         return ret;
>=20
>=20
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 50128da18bca..1f8915f79fbb 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -35,6 +35,7 @@ struct vfio_device_file *
> >  vfio_allocate_device_file(struct vfio_device *device);
> >
> >  extern const struct file_operations vfio_device_fops;
> > +struct file *vfio_device_get_pseudo_file(struct vfio_device *device);
> >
> >  #ifdef CONFIG_VFIO_NOIOMMU
> >  extern bool vfio_noiommu __read_mostly;
> > @@ -420,6 +421,7 @@ static inline void vfio_cdev_cleanup(void)
> >  {
> >  }
> >  #endif /* CONFIG_VFIO_DEVICE_CDEV */
> > +struct file *vfio_device_get_pseduo_file(struct vfio_device *device);
> Sorry, this line was included by mistake.

