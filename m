Return-Path: <kvm+bounces-58114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45B56B88139
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C246B46171F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48402C324C;
	Fri, 19 Sep 2025 07:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="haJZMArK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB5425B31B;
	Fri, 19 Sep 2025 07:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758265221; cv=fail; b=AllIc+aoy6tu340/WJ4HtpSpmb+mqL3nFNlmUn0nJIBFPE/IXUj2C2au8xHguuw7iyYaiPmfnYgxfpfSpIisvtU17EFmChalMlaFdOl6QybDqEtPM9E4eIGvdmt5YqVawqXic75eben6SNOQWD0qHU9iKfnoXH2SVi+L2FwAw2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758265221; c=relaxed/simple;
	bh=MIz40eGXTDDOSZwPOKyE+BSprwcGztDg8DX9ovnkdUM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kNXK9+ysq+6c4Jjf8U4la/w9B/+BZeSfa9+D00lufKzMSb829dOpLVdRWOxRnp4QM9r8vPLFdVNmCF71X21JTWWBcaq2MUvxylc2Iu/KZ5oKtjobrccJxh7/l0Cs29IYfhIyAJENXiNNa8RlVU3SOZL6Y/0KFwv7idgZAfewlNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=haJZMArK; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758265219; x=1789801219;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MIz40eGXTDDOSZwPOKyE+BSprwcGztDg8DX9ovnkdUM=;
  b=haJZMArKqXcvWkjP1tr6BLXnxLO8UwDMmtAWZMEGq0ejd/VOp5e9Lelx
   vyhfbZK/5N/SxO9vxoriybqQ1lN5RisLFa3pMNc9Q+V6Ql0JrSFp1zw/b
   c2iNbI65tsvAYclm61Rm2FxJmicO///orezPFCq085TyWrb9h24CVkWQi
   oKa1ZzhDxNYHcqxviMs2Wto8zTDTKE56lSXxqcs12ZBYRHuUlxoN4qBpa
   Ua1PWYV5iFNZxrtzq5Wwwo8//g3P7rBrMCRb6XJCPCW7Aw3AcKpFtGDzL
   DWVbvm9o+4wqV9VVdOGc1+TGJQfdDYp3tFg02dONYhZPx8ZO/NCVQ3N4x
   A==;
X-CSE-ConnectionGUID: Nl/JdYCBR9SOJJaaySmDFA==
X-CSE-MsgGUID: SyUOQW1AQTeQ/Tldc+//lA==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60495364"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="60495364"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 00:00:16 -0700
X-CSE-ConnectionGUID: THto66YHQzCAXK3r1VBm1g==
X-CSE-MsgGUID: HMVEE82ET52yFBpNqF/Xzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180180127"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 00:00:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 00:00:14 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 00:00:14 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.7) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 00:00:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S4odbWIDjZCMt/UosMBakX5Na43hlNIGQY8a0iof4rQOnp0pWr4hMGpXkhjuDylCzH2tAc1CFeRjx5NIsmsKp8Ix5uDqwcJCVZj5S2ZpZ3JsU0h3y9uQorxBrRJUnibia63AC9Np7mnoPDrxhj+lwYdh6pHiLm600z4BV4vlDGEQ+UadNFwsBnB/Apmdmsh/9VDWikHUYPk7mM653c1bdDAW8SAKliPmkDSBuoa0DhDcOizUVURs4NhQiLp/yvhIin1YA+7qephJ6O8xT2dRDnQBhk5D3Um7piBqZOdyA/6lWyG9G3QPmMxQPb4cNrPCO5rDs8uhXAC0FoUC8ggZYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIz40eGXTDDOSZwPOKyE+BSprwcGztDg8DX9ovnkdUM=;
 b=iewPvQuQaw/CAgyHoYBLMzRkx5ZNnKy16vAH+FU/0MRq+q2hisCP1rP2RcR3+bIgEJy8E5+bSZM1B1mySm4Hnr2PEbib5W1Hsqj+BmTlDbt6i4fIDObWhl4Gw/oPGghhrfOn8sWy5iszpWcNAcEFBKf0Wvc3RyC1TFoJ8/JeGXNcH5FnItamXvtYWF90OswKU6YTHoCEf2/oMYySUg9X8ZrKRacvp70bspPoLf8gTI/hh1QQ5Gl/xzv+7vI9m/ljHDOnWDM3pwDezPDtgi7oXTGglwRcZMtJ/mbxZObr/x8OYNk8VQQlctHUslaw5KAO1LCxlaboTTmXs3JoYYSqGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6096.namprd11.prod.outlook.com (2603:10b6:8:af::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 07:00:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 07:00:04 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Mastro <amastro@fb.com>, Alex Williamson
	<alex.williamson@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, "David
 Reiss" <dreiss@meta.com>, Joerg Roedel <joro@8bytes.org>, Leon Romanovsky
	<leon@kernel.org>, Li Zhe <lizhe.67@bytedance.com>, Mahmoud Adam
	<mngyadam@amazon.de>, Philipp Stanner <pstanner@redhat.com>, Robin Murphy
	<robin.murphy@arm.com>, "Kasireddy, Vivek" <vivek.kasireddy@intel.com>, "Will
 Deacon" <will@kernel.org>, Yunxiang Li <Yunxiang.Li@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: RE: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend
 more granular access to client processes
Thread-Topic: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend
 more granular access to client processes
Thread-Index: AQHcKOWYfQYJuTVYiE2w7MaL4DnIT7SZjXiAgAAHnQCAAHvD0A==
Date: Fri, 19 Sep 2025 07:00:04 +0000
Message-ID: <BN9PR11MB5276D7D2BF13374EEA2C788F8C11A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250918214425.2677057-1-amastro@fb.com>
 <20250918225739.GS1326709@ziepe.ca> <aMyUxqSEBHeHAPIn@kbusch-mbp>
In-Reply-To: <aMyUxqSEBHeHAPIn@kbusch-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6096:EE_
x-ms-office365-filtering-correlation-id: 552b88e8-c445-4e13-7756-08ddf74a2951
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?LlchE9FsW7+tAYpYYYj6KrPmQdE1M2ISQ/boz73XuUZUejIMpJGYutz781Ru?=
 =?us-ascii?Q?MCwjhOabDEVhYdcYJjrgaKTSg7fF3MrY6ouTZMlG9e3zgV8879c6Ogyu2Amc?=
 =?us-ascii?Q?AUpGvKag/mVF0Lmt6Bpxs8bEeM1wN9fIeohrSEQSUnIVAZfQX8RPDUb/flWE?=
 =?us-ascii?Q?PaKcuI3VMzrCN/S16fjkZIRamnKXynyFDO5cv0KLlICOoXab2qaloVPM2se9?=
 =?us-ascii?Q?yd82z3OKPlShlNukSer3+HZDXr2GbmGZf708Wx5phLdoY786qnisfUHjYE4h?=
 =?us-ascii?Q?IZITaV2vLU9uI6Ojce1PJXyUX60Q8iwwSDELeDTeP7h5WdY76pr0S2viDwYO?=
 =?us-ascii?Q?Ey4touIAYst7+vbk1006rLvUZFfWndsAwU9HeUTd/wJGuf5pABvcGX//ws2R?=
 =?us-ascii?Q?gEjl2KMkTxZ4QAEEup6liabceGWuzxDVBQHIxiJy+iAEJ3rF7xlaP0uqpFZJ?=
 =?us-ascii?Q?wooRQoxu2L2YT28vL9mygoOsd0mJvkHdnrLFAXTsH87FCkZx/Khkol/6MMp+?=
 =?us-ascii?Q?aNAqB5IpPWtUX83FKHjHgc/dVu69COAswOOmUZsUkmwPw4Xq1UkRijZfwp15?=
 =?us-ascii?Q?dnlHbOxWojExJ2DavWh3p7vKjh4WSy6GrI2+twRDB+tFXpUdLwqupmOuRTab?=
 =?us-ascii?Q?LRFhqIMTprGs5NsT9PobMpZCfwy+nWIivAXbOgiePhvHuBTqgHCWAJZ+MCpm?=
 =?us-ascii?Q?S9+rcM7umoXXAFxKYFShK2rLWZy7hocSV+xxeVd1yVa4Ti6gb4uigEu/YEQI?=
 =?us-ascii?Q?6jFliBQemkTYUehD9kBsT9rwaFzYrVa7VGD/HAyxB3z4AzS5VXoNRZCfEjLe?=
 =?us-ascii?Q?5pTnOyFh1bIRNBGI/OOmZtpeusg4pLa653cP/Y9cII8ttTQay23icx2zQtLF?=
 =?us-ascii?Q?0e46uWpiQ8avbAr/jUy3V5Ixpzr4Ec0UOq3PRexwxiFq460qPlSGSxT/1OyV?=
 =?us-ascii?Q?kxWG22Fjv6HVbOTnuEkBfTVuVfk0gTO34UlLXBtVGrcC9dmYj8gVz16C1JWg?=
 =?us-ascii?Q?FBrr7O54exKZXLRFoTrQCy/yoPsNeNDkP+jv04S6yB/PF39ZWnwrWOX6Qtob?=
 =?us-ascii?Q?GRV1VzeDZ7WL4I2i4aKNyzVEUWqDSTprPM24x9FqGzfRZI1cAY6fuVS4LVUI?=
 =?us-ascii?Q?oY2On5s44hYAVFwZED56qMl/mRyiHfepZQY3aMCirpzjRGhkZ0C/E2YJppPb?=
 =?us-ascii?Q?w4wV170qG7tENgfDNIP5fyQaDjcuKFNlKqp6yKX/slhVuSxspSAZc7Sbb483?=
 =?us-ascii?Q?DNsUH0OPndNCUiID+wFgl6ubxwuMQDqu5JYUTfL89xWQ5fFtnQKDI70ijFLe?=
 =?us-ascii?Q?eQfKKwgB2piXHODEGeVfqaP+6D7CuK0AeuP/8Oj7bYp3ImFT/5ezd62DeUzG?=
 =?us-ascii?Q?Lv4rCrjAldhegOJtal3ZMqBfc5givcizYf0Ez/7WoI9CcMBFCWyXajM5KPHB?=
 =?us-ascii?Q?u4YyVKaWPZFHXPvkQJWqDX53aaH4tmrl5Ermfn9+XllXXwzZWoImPQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sAufTxy9a2eDv3iI1OWFGtpXIr9IEin3yyPdEJdECegwfOgmJl0VmAzROCeL?=
 =?us-ascii?Q?sAaHsfTtggqvp8HXePuqzsmUhe01K7lg/f8v6wtBRJMQ+3dSCaT284tttviH?=
 =?us-ascii?Q?dkU1PJpISyLnvs0pHJAl1YdOJQZYK0R+AOhgILyEhFXzkHntqbOAIYKmtwpB?=
 =?us-ascii?Q?r5/a3v1SYFBNEOCe/XWBgWtInhmqm7P2hg8ORcxSCJM9uOnDK+t2VictB02O?=
 =?us-ascii?Q?HsNgGqXlRDmaks1UTYKcQb5aqqn4sy89YisP892eAZ6OV/I+sgn1HNe1AFze?=
 =?us-ascii?Q?I5eo4CLblFKasMvcAkVYssPh/Ud5OGBoZFu4hsRRluuliqrkE5HJ0r2cOB4E?=
 =?us-ascii?Q?3BZ64oGrc+YfhqvJ9mj/lWcGrnGRdcQfVEx0t03lxnaqwQrt1pR7dOmELPco?=
 =?us-ascii?Q?vBkFvC68WYswzp80cNNDAz1gFKtVULrOu2/X/9tUUKdoIzFxcDRnwVmyGBVX?=
 =?us-ascii?Q?/8f8dG1oL4/ZW3sy7xB8Gl5JV+gvmFhmIv7kC2dHNv/pkEpPznmAHrJnxQAZ?=
 =?us-ascii?Q?0O73Vof3l7UnsBtgnEka1dU9fjYc1xo8dWxwikpiCDUA8QAa4bC36r85u9Il?=
 =?us-ascii?Q?vRKjvSk8hG6xZCTcHmtV48uFbMkXjvXLl4xWsJ2JA76LknK1WJpNs7od77V1?=
 =?us-ascii?Q?66wlgHqvXtjbQS1cxQePPi3vZe2lQMREkP9DerHYuo+QHxlgL+dDPLhz9g04?=
 =?us-ascii?Q?ogw9ywQ3BQwOxS+VpXoLBcqhc/d/5blYq6K6Ae2RRB4aGXEBSqr5dqW8Lcpc?=
 =?us-ascii?Q?1cyjsKRaJk94RL0ctZH7oBaw6hzsgHITD3f3mtpET3hycauvUUld75Ih4L1O?=
 =?us-ascii?Q?GoaaB95chKHsySqLZLe44ezf8q0F1Xe1B02+JTR4dAWpKxdBXykgBJEf2Rx1?=
 =?us-ascii?Q?Tmzr+SX11kihyqa8CHfBRWHY0cv0IWJT9KqGioNLYukXTdEiWYqitrCQk7Lv?=
 =?us-ascii?Q?3ALlttr8kmnre5lB3uRYdK3lsNpR/actnvR8uy18hMEojFc/mq06BGxJbw8n?=
 =?us-ascii?Q?HYUQiEajArRLzQYRofGJ44Zz8DZ3om3Df6fX70bTIjBAzMgqxjwiBIN1SkhC?=
 =?us-ascii?Q?3FE/yNHxnO1acvXkcmDrNENVL7l3nT5HBeywCRsZQmWV+BinlvfX6LGCbSOb?=
 =?us-ascii?Q?oMGcT4YwlaKr84zu1ljHvIvtqXJgEQ1cHuiqxn4CRVpFTn9G+cO+49JF/1ND?=
 =?us-ascii?Q?93kP2LmzBx13YGYpvUrlelmgNxy2RJc+o6+6dmob7pnD5xqrUM39f/nGPp5A?=
 =?us-ascii?Q?S48N/jtR8xonUbK2yktJOaPuDgAeqMOTjZIbkgWnKaMowRifKBATcyoD0GD4?=
 =?us-ascii?Q?MK+HPMWCHd7NBI9xDYOu1khPR9Eos7nauqeym70+mFVIRXXvUVqoEOt4e/N4?=
 =?us-ascii?Q?kajr/Tiao5hYpqbkLPMBLPB9laV7fCV1PGvSJVgv+/plKMCy10oDwJA5DPyd?=
 =?us-ascii?Q?hYNW4Q6FSNBrlPWwmgkoj6y3ddRBncv60+GwNTmvPHCLUu60XXPcqXxuUlfG?=
 =?us-ascii?Q?8iOltaGrq3+gjicKF3v2VVDay4B1vAdKUJRdJFfu/uHJwpF9yHLUoiVESvcu?=
 =?us-ascii?Q?VZq/VmAN2gFHsnw7Ld+LiAFWxRSmwddxiXLVSbv4?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 552b88e8-c445-4e13-7756-08ddf74a2951
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 07:00:04.8845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ODSqbX3ZIjDjO7dqn2dAwcqAgag73YV3f+DbGUperRyrSWlH1D/mBToVWibPrRqg4jnDWsVxYtfdc4xOxaSgPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6096
X-OriginatorOrg: intel.com

> From: Keith Busch <kbusch@kernel.org>
> Sent: Friday, September 19, 2025 7:25 AM
>=20
> On Thu, Sep 18, 2025 at 07:57:39PM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 18, 2025 at 02:44:07PM -0700, Alex Mastro wrote:
> >
> > > We anticipate a growing need to provide more granular access to devic=
e
> resources
> > > beyond what the kernel currently affords to user space drivers simila=
r to
> our
> > > model.
> >
> > I'm having a somewhat hard time wrapping my head around the security
> > model that says your trust your related processes not use DMA in a way
> > that is hostile their peers, but you don't trust them not to issue
> > hostile ioctls..
>=20
> I read this as more about having the granularity to automatically
> release resources associated with a client process when it dies (as
> mentioned below) rather than relying on the bootstrapping process to
> manage it all. Not really about hostile ioctls, but that an ungraceful
> ending of some client workload doesn't even send them.
>=20

the proposal includes two parts: BAR access and IOMMU mapping. For
the latter looks the intention is more around releasing resource. But
the former sounds more like a security enhancement - instead of
granting the client full access to the entire device it aims to expose
only a region of BAR resource necessary into guest. Then as Jason
questioned what is the value of doing so when one client can program
arbitrary DMA address into the exposed BAR region to attack mapped
memory of other clients and the USD... there is no hw isolation=20
within a partitioned IOAS unless the device supports PASID then=20
each client can be associated to its own IOAS space.

