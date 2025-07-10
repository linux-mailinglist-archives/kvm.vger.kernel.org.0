Return-Path: <kvm+bounces-52018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C48AFFC61
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE0941C222C5
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 08:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBFC212B28;
	Thu, 10 Jul 2025 08:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JJkn4VUW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57513233735
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 08:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752136219; cv=fail; b=aPvKVbRWoZ1VnzYy2CxS1ObHkmfQBQyxXIdQfzoa3tlH9oS0jVUsyxh8cvVwdvLOp+qzdjIIhqYpHsy1sBJbr+H6FyL4b3gUywYFwKyMz8bnwfacnDoiHSP4jxf6qD4bg2cviMcZHmoGvK+qcjNxHZCTldyF8Kv0drOpmwpQHkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752136219; c=relaxed/simple;
	bh=vP129UArb0BJ+g5YU8sr1KnpjT1EE0c6Pf2NaKM3Y+Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TEdTAvx/17jQMEmVZqkd1/pIuX0trLeLlhpq9XC38Fgk1ZBleE4cz7o7cHXEbkOVWgGXiaRjJd+25a4wG8OgLteaqOIQWRMbwenWYiz0I3Y9IH1SH+hoThpSkUfAQl+rUjiHNvxzR4a5WIOBMDavXXwxCktOFjcihOoNYQ4SbjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JJkn4VUW; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752136218; x=1783672218;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vP129UArb0BJ+g5YU8sr1KnpjT1EE0c6Pf2NaKM3Y+Y=;
  b=JJkn4VUWemKdDOUkjdWW9qnQJWNOlooz8znn3NY+3fm5XHqw6LOw+XvB
   zFsmUqR5gmkPZQMkDUzEaypvMwr0bRai7fsGFDPd2sjb2/i/YxwvysCmm
   r6xOxvfDKcO0vtl3HlS1PyJlJ8bmjxvUWBgnzt/wQVpOeZFOA9zJ0+k3f
   FcFIRXFd9bjkkDAC2f8fcTDX+BlxEGuc7PyRNak/7tyJTTWLcf7Ce2y2O
   3w0KDZ6Uq+zwcUe+xyvTz+/Ep5knUoAbyimJilvD2Hf8XmxBGSMK0nwjg
   qSmZYryarMlZMwzN0hIaCRNY/Wq3YBIjZ8/9t/ygHUYOea34fcb0DlrD1
   A==;
X-CSE-ConnectionGUID: 59U7ZMWSRWy2v+i+xkUSzw==
X-CSE-MsgGUID: QgNgrdf2Qferep3jMIXPFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="53521600"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="53521600"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 01:30:18 -0700
X-CSE-ConnectionGUID: OuPznLLTSyOvv9R5ib1a8A==
X-CSE-MsgGUID: 03/b3+guQFiHYLveJb51Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="156564101"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 01:30:17 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 01:30:16 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 01:30:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 01:30:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UmSB0dbitdm2Ruvpyxutl9UlS4bsBScFLM9COOrQjX/7ivnfxeWIfIpANUB8CYiI+owqb6oKuubg2OuSq9dDKkQVfw3MqvZjp07/kSj9PYSpdfH9Tvnw6ATo0xbPkJM52eMnrlNqRsFm5oY1wYHvVHQeLR/Le3uVTtOsTW1svEFx6oPQWWG+kJ22Y0hIsoyB1Kk3nZkNLrOLHtZMy+hkIv6pePxo59oWgV7IuUjhBZnWy7UVin7ZEJJmArv/Sx2nhREuu/cprbBNhFEnvjIJTrBa6WIGAhxitxUQiXsfCMDW+G560GfhWJb1N9gR4jqSEImBhupgb6ozKZbecQmJ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BcQ2AxEmLyfM5tsVlJszOT1MXAkDzYA37nqK5sNnig=;
 b=dmYc2XkPz60AkaOa42DQurLfpHJiv/KmupvHuTQnfLntt2CspGcAl20Jftb/KY5EY52mw038yoLfTH0Hnoj5BziU97LLEhyaaC4RZ5auInErtojFLnfOUVjLaVNFFkIdio4Yx3q/QbHVU1evcXjkLqf8ZzTg0TzL1bezE1XzmF92cmbPmTlfjNTEZZNmTxF41myXHNy/6SILOkpmU2E56FIFJjok9aqavH7eGwqWsESw19UoEAH6VVlIacxqYhBmZN5+t980H0PDOS082aqdFAV6wDzu0IfJndwSQYftScLHLopIdjjvI/DMKSVBdqVk1oppBMo7g0Eq8nXhJriS+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8005.namprd11.prod.outlook.com (2603:10b6:a03:523::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Thu, 10 Jul
 2025 08:29:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8901.024; Thu, 10 Jul 2025
 08:29:59 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Ankit Agrawal <ankita@nvidia.com>, Brett Creeley <brett.creeley@amd.com>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Longfang Liu <liulongfang@huawei.com>, qat-linux
	<qat-linux@intel.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "Zeng, Xin" <xin.zeng@intel.com>, "Yishai
 Hadas" <yishaih@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "Xu, Terrence"
	<terrence.xu@intel.com>, "Jiang, Yanting" <yanting.jiang@intel.com>, "Liu, Yi
 L" <yi.l.liu@intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH] vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHb5Ta1f4N3tNOt70+6wANikunSFrQf/pyAgAB3MgCACqlK0A==
Date: Thu, 10 Jul 2025 08:29:59 +0000
Message-ID: <BN9PR11MB5276F298FC5FF30D1D0FFC6C8C48A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com>
 <BN9PR11MB5276CD6181F932C70CBC800E8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250703134102.GD1209783@nvidia.com>
In-Reply-To: <20250703134102.GD1209783@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8005:EE_
x-ms-office365-filtering-correlation-id: 3f597495-ce4a-43e6-9f4d-08ddbf8bf546
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?YS2MmTaFGAXaIsflAO3k+g2HRSDlQ1YkbBHQn6kszI+7AAtUjVvghhuSf10t?=
 =?us-ascii?Q?H2jp+vktv7ohqVBrvTmhyFmmNxqhxBvMMcB6mxnCc4N7v+nZvnP1eVEMwzBD?=
 =?us-ascii?Q?5avZ5UjqBeBmruw+kbiw/qFRCZvEAHTXuqDinG+8M6WO1a42PVNHMBxXZqeg?=
 =?us-ascii?Q?970e7i6uweQeZWSVqrmSKj19kj/KqZvLRdUIE63srfyaiBPd+wOePJ2YSpMI?=
 =?us-ascii?Q?3tOKapf9cKuidKF3byaDm8tqz6+45mkwBqOZ7vaywkQvBDN1l5ylocI88hNd?=
 =?us-ascii?Q?8c/S5gAych3+0p8OWKJRUjHe6cxX7nYKuFMHuo46znFCYFw7r0aF306kGitI?=
 =?us-ascii?Q?94xrGTNVS3jKcNFAYiXw0jcjk1Pur89Py8Od3YhE+K994Q2w4iZM9TdDiOnD?=
 =?us-ascii?Q?Bgh1+ZLbA8PJ2VYaTMwF00eNMMpdxh4FR8zyNnm7D8mCaFlx6lnMPfD+qZCn?=
 =?us-ascii?Q?eQQQRZKXFn4dFdxY/PbLYS4NUUIi6HMKTkOLRYIi2272mkEV8w7i8gWQE4Wd?=
 =?us-ascii?Q?h8Ru9n/kIkRsFJ6Y/yrc+CLFmoM09NYWFHD4yDTmM7ABXvYYo8DEDuYMKSbx?=
 =?us-ascii?Q?HxQX8wSG4FTRaPJYXj/t5gXpBDsCbFo/fgZgchtOmxObdrPfxcxduRuK/JSE?=
 =?us-ascii?Q?FHyzHJqsXF8e+9RVsuovbNIHTEMncjnLzG3F5IqWu5GPsjAgiZefuwAS0CRQ?=
 =?us-ascii?Q?B3bzwK0g5LPjI5JFRrQy38z3XhxwHOX4yTLqOieM3rhtqm+EwGcvkOmjIggK?=
 =?us-ascii?Q?zyI64yjK43hyok8kmy6Uq21kCLtQ3jr2WnrCyT75GgTP5Ymzz3re9ovBA3EH?=
 =?us-ascii?Q?HHXEw3BJtQz/r97MV+SeeXT69gZEAtS2/HNUKdd2fioM3RbPT9edofJ+bE2I?=
 =?us-ascii?Q?0KIXwsrEC1SYIkWk+yUimwDC4PM5ezGKh6mQvwE5+l2s7QQx7rHOCVQskNKF?=
 =?us-ascii?Q?iKbvtuhDml89uDC/31KeuYeMVlTKqVT3VvdCeJNxy5b8IxjeAymagtr0vBaa?=
 =?us-ascii?Q?GKgvCuisinsIUyNZjNBw4Nniq9+VXsDQsRKaaDo9aOzyKco6vuK/GAdcySyN?=
 =?us-ascii?Q?voiattZqsAn/CUv6N2pETkd6izws3Juq1/N9RovD3jKH2grcbSLXE0eQxukV?=
 =?us-ascii?Q?fYkENotur3hPpboFpQYgQU0T9/sysRKjReteteZFrUEY3kCs5q/42OXYzdM6?=
 =?us-ascii?Q?8EyaZJE5ITSdwo8O6sqceyES5rlPEYQfYSezZ4xwS85V2JWR0r8AWmdwXOlz?=
 =?us-ascii?Q?rTZvME8teXc3Q5sqbwJ5LBnXhJUV3hfxEVHwiZDdbanpIXq0ube7EfdQ++hR?=
 =?us-ascii?Q?8tQgER4cjZYni0Za5CVCzwXeUmu7eXuh3zSCg9oApN50m9sCrgtWpBPhxZZw?=
 =?us-ascii?Q?zh1/hfCQ7qw5rhaZKwPegc67lUeFeI+8bVMRnDZYfD6h3CgE9tc00lxFc3kt?=
 =?us-ascii?Q?f0srJtYMmCPPlsxKmZj5ZwFfYmnXkC6XGxpPFPJSMMcXkSn+Rs0d3w=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fx8mec7KY0c5jboF/Y/SA4qAZ6MsEfvnI3f4a1KJO6WYk3eAGQN48gFxbw53?=
 =?us-ascii?Q?FmFxB1cWCC7hZJcEJknsqVxtGlH+/3mvn72/fkJj3wEJLvnjl+XdndxZkvay?=
 =?us-ascii?Q?YgxGgEWBSr2QNSPYlwzoj2D5TRWeJvKh7UIhVRmyxtgWzkE+IGzNx7ipvsgN?=
 =?us-ascii?Q?a15VGnUOrH+PVHoogu50Yb9Wo41PlZPpslXiQb6l3PX4vmljiXh3P5yTdf06?=
 =?us-ascii?Q?7070WjEWh9KxmDthGC/UMHrp3R0XX22EFCe4fXsTjo36guRuGQb69JOO9NkA?=
 =?us-ascii?Q?8RVfh8UD88JTsZnqdIyntmyHWoLCFHJGIeb2szgL3AETKijg355yxzoXJSBW?=
 =?us-ascii?Q?AlHbfXfCQadUj3gwD35hDRXSCqnz853j1hJVSNZjZ5NtJ7nd5k+0aI3a86BA?=
 =?us-ascii?Q?+7MNKh1XZ/pTP0vRQzVvxxSmYlwWw84JnMBU0/xfEAQPYVW+Qcg2xY8o4dPv?=
 =?us-ascii?Q?gvEugdKFHgtiuCuzjUeErVcD/09eNno4tTXpFkzXBKfjbfCSQI+TXWjnUxoT?=
 =?us-ascii?Q?+m7aIMp0R4zuykw1HRwQawOpuUhWMHqXpF1nvjuJQpd/1r9NekC5RMTwjlZp?=
 =?us-ascii?Q?NA2Yhq8Qbkxa9HDuIKoBves01peqxVjH+JnykwdoitN3oeO4SBC4GpT+sZyC?=
 =?us-ascii?Q?L0QCXkYNN5AygwsII3EybmGtKoxuOJFRJwISREAk6qvt8PVPp7q6A9MGSqgS?=
 =?us-ascii?Q?O3fR6krRFL4dpQ1YVTv0HIdxsR0ztxhXYtBeHHgrFRifpkevwMJi3R4ifoFJ?=
 =?us-ascii?Q?TDZsZBdiojn0KI8wofCHdw5XTXzX78FAGqwfLnHJlSl1B7YSWSPleFod54Kp?=
 =?us-ascii?Q?hvHlKv4e3JHsu/8GjunPXRJBTTKyNB2JUvnv0WSbT7uCFPnPCWxSmkoFlUjn?=
 =?us-ascii?Q?pJ8ecbKK0DHCRxvwX/4cGN7UTQV8lcm+E3asd65Y72Uu1IfxzVELmoSFOMyZ?=
 =?us-ascii?Q?DNUwYbiLr8s0+Ctgx7ZbZT9i43VqTC7hTRFW0ehHbCZ+gMvjAP8HDrF1xQ8X?=
 =?us-ascii?Q?/9c9pBXZz6CyL6UwhTny64pgyGVKuWhQ1MEtCrzPqWV7ijUCajpPGXTXlZ3J?=
 =?us-ascii?Q?NuYQltOxIfBAvKrPamUKG6HdRiKfBPTidC6uitBLU9VxhZOrFtmgukfiljTf?=
 =?us-ascii?Q?pJNBTlm1d0aNgJDIF86fGVepriOjaBaD8rnavYk9E6EF6p+rZvUjUGeXpg47?=
 =?us-ascii?Q?yBOOC0hDItNfNWbOt4IRIER8HajYG4Wy2K3NZcBW0t6IphSeNt3NwrFgkhU9?=
 =?us-ascii?Q?YsPosVdAGSr6OhtlDndCMpa2dj+O4GpE6JSxwy/tOU357KVOicqvY6eKwkpL?=
 =?us-ascii?Q?tzI2iIXRX+IKjt/QP9AUFdxjUFyLNZrHtMmq76yHmA65mamcnTcVD3L5xhus?=
 =?us-ascii?Q?XTR3ozjS6/Rw8n2QRx9WWtXoUe1MvNDN+KdGAuzC3tflTEjGrv47zkjVI2+V?=
 =?us-ascii?Q?8825m5MLCMfJskc73RyUgKUR8fGb+BiT7AqF5E2hsbFa0VinOQho9jEI4wfN?=
 =?us-ascii?Q?tWTc0n3mVeZTz/hsxdT5OmPUFNlPvsUgS7bXGH4d97NAWveLHvEdAjOqDpbL?=
 =?us-ascii?Q?cCGUiBFf5auqn+/pmBFI8FfY889FEGeZC+j+7vPC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f597495-ce4a-43e6-9f4d-08ddbf8bf546
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2025 08:29:59.2401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CbDRKFOmrgH7q5C6P5ViMJvETpdSNusA/Bn1UTMwMcdbwG2QM4WiXAZDTB1roVae0qwxmyg+T0C80OdpJqSuCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8005
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 3, 2025 9:41 PM
>=20
> On Thu, Jul 03, 2025 at 06:40:48AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, June 25, 2025 2:35 AM
> > >
> > > @@ -1583,6 +1583,7 @@ static const struct vfio_device_ops
> > > hisi_acc_vfio_pci_ops =3D {
> > >  	.mmap =3D vfio_pci_core_mmap,
> > >  	.request =3D vfio_pci_core_request,
> > >  	.match =3D vfio_pci_core_match,
> > > +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
> >
> > this matters only when the driver supports SR-IOV. currently only
> > vfio-pci does.
>=20
> Hmm, sriov_pf_core_dev requires sriov_config, but the normal vf_token
> happens for all vfs and there is a little debugging related to it:
>=20
> 			pci_info_ratelimited(vdev->pdev,
> 				"VF token incorrectly provided, PF not bound
> to vfio-pci\n");
>=20
> So maybe we want to keep it. Otherwise it sounds like you are
> proposing to remove match from most of the drivers since they don't
> support sriov_configure? Which ever direction I think match and
> match_token_uuid should be together.
>=20

Okay that makes sense.

