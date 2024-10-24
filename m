Return-Path: <kvm+bounces-29594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 696AA9ADDDB
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A4F91C23BCF
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755881A76DD;
	Thu, 24 Oct 2024 07:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LNb94p5D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB4418BBA4;
	Thu, 24 Oct 2024 07:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729755545; cv=fail; b=WiGbTHIPsbmX/qGTf+aayl7VXWuvIlX3T6JkTCwI/W+vIXdf49OCQYM/WunHHKfEzY+8ykb5AvtrloEqNxmkDxF9tNyD811L1hTLURtgpeO9rjwzBDwstxbpYP4+TYAYQljW6Mopk5p/tFBmc2AIUhRGWME44y63paIWQ07M7xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729755545; c=relaxed/simple;
	bh=aClTui4EGSZlKYmLQc1I2aYuwkJj6IqILUh9XO0tKfU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Flz0mLXoVkDYCIC58CyvNibRveQd9X3PQwOezVHD+MA8uzGQgh1pDUtva2JPvcY4SPzBU6Z14knBl8X+6m268sOHnh2Nf8bfWs5TEvn16JC1wA/sR4HpbWqrS2YH3iuD+NHqY15gRMrCrKIUr3Qgj28U50naLOy7ekl7CJJQgVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LNb94p5D; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729755543; x=1761291543;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aClTui4EGSZlKYmLQc1I2aYuwkJj6IqILUh9XO0tKfU=;
  b=LNb94p5DEttSfpPHcAfUvA2VIVk80l5dmnsuUNZLPWPF0G9gSGcJp5Z/
   FIbbvMxI6AaziPcJaqUfFAhrlcr+YpoNCHpFchSkKjaqu7Z2n/QJ89fY5
   oQlB7OC3B1gHMt0Ci7a3wvBlkJdNz3b13m57Rf77Li0jzpXn5d3iNTEoV
   i74rGP2jZMJFpkPyKPfXaFsTESoiip+83hJ00wUOCP7bOepypN4HzM6v8
   HzYheFN1JN4ySHGvXBEL4eairmnn/c1viaGiX4WegDalbn+CamkkoQJcz
   49HI9HB0CgD4I8GPYdxNHCIQ0VF1gv2icyPTVue6h+pjxcnH3nLAjnxHu
   g==;
X-CSE-ConnectionGUID: coXcnaUaRcWeqM20t7RJOA==
X-CSE-MsgGUID: AeDHQHnfQPyvhHIFBVDkdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11234"; a="29269221"
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="29269221"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:39:02 -0700
X-CSE-ConnectionGUID: TtDO955wS3OL6vHSVABaBw==
X-CSE-MsgGUID: 800Umr/LT92kamgri/JWfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="80932864"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 00:39:02 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 00:39:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 00:39:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 00:39:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eI0DLgTr1ejZdtrg1rE/qsfjNTUu5/8bm7QL9CuFco9zRk7zC1J/tGu7uJ/45hSgZsVTbtPyH+osYOgn9hVX5zCzYvyZU7hmK2+fi2F7xtXLJtIhz6GSw/tUsjfe5PmAdNg9FjJBMr2LCOOD1GrZO5Ti3W3XGXd+Lbb4Tm+ow7qvR3rOmuop8ZvX/d+dfjn+xWZpyIBOiew2DYwG1F9ANIhjFjuUA/2XabOIZ1ob9endNpi07rZrAP7V6kAyy6kF1bk8kG5R3FxFVxz4p2tCY0ynXdbHftlqzHiNOqgLVnjva1LJAlcizg3SqPbCmYjoOySHDDTDSngTRILdxNMptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ou7KGphOjyHAq59zYJIZUS5S+0c7omAohfvOVzfzX/s=;
 b=esBcXm/ZVERY6ileVqZfIrmsPOYIYyIuj6fqXS9wfZFkcVKZJs3lVzKtg10ko7rhRfnsB7PD0TQcAv2+zj+0Hi1NE5JaMCaAyu94NzqGXWQRJ1vobJTnINALPd/D6OB6cD/rOcl3yzE87vGqxKY08FLSoGleinay8CpEyCKdcKFTUWxCMY44vHnh0TTnEJDe67B1egsjWSeetODqKbX851o5h9O05FpBnUOMChzdYbG0dJPLBcIl8mM8bZnMrxAYFlpcQtMDIb7UpVHq/5A+k8sh+MCP5J9/pcpaA+lzowRrvSKZ7HvMEqiw+46lH5mzNCIqvCr74m6VP+JQ3p1kgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CYYPR11MB8432.namprd11.prod.outlook.com (2603:10b6:930:be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Thu, 24 Oct
 2024 07:38:58 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%4]) with mapi id 15.20.8093.018; Thu, 24 Oct 2024
 07:38:58 +0000
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
Subject: RE: [PATCH v3 3/9] ACPI/IORT: Support CANWBS memory access flag
Thread-Topic: [PATCH v3 3/9] ACPI/IORT: Support CANWBS memory access flag
Thread-Index: AQHbGmecKdcSloUlVE2OnXwI2UG+E7KVmqzA
Date: Thu, 24 Oct 2024 07:38:58 +0000
Message-ID: <BL1PR11MB527184D76065566A13A21DCB8C4E2@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <3-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <3-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CYYPR11MB8432:EE_
x-ms-office365-filtering-correlation-id: c527f564-17b0-4549-d25e-08dcf3feebf5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?+BYBB7uId/JGXdCaPpcr59+3OFH4H/7P4nJRNNReXvagQcR8Gsc0spUnpCCA?=
 =?us-ascii?Q?C8KGYYqZGEQHKHuhHkIdgJFR2/4xePoAJ0r/VJ4Qe+8IkoDVI7YirFn+VCu1?=
 =?us-ascii?Q?K4xX2Im55WAoL2h+EsaTKOQ51FuiHwJb4eZy5FC4ORDtW3dUNV72KC/JKWud?=
 =?us-ascii?Q?nI0bGMGGEG3UpuJ7wl3+Ef0X/LKvcPAaHd1y4GDUZJWtKuOO0xmjYr7OwctR?=
 =?us-ascii?Q?RqoBiy91a+eOB9n9im8ixNWRM6PRdFal46loccJWAgGYy1E9cSwFiol/14yf?=
 =?us-ascii?Q?KBS5sO3RZUzwquHl25tBHHVh78Y8InnfnKv+EOjAuNEjTW+ZkTcH9dis4DHG?=
 =?us-ascii?Q?iWrWDM4WKfTP8lNSQDECMFMeu2XmUO7lqJH1XRitkbl9kgJ7dFFHfCGlSSU1?=
 =?us-ascii?Q?Srw1iSN+BGefhr5hn4WB2CNzRSN+xCggrDQPxAhxULmT8bEkscbCEdwv/LKv?=
 =?us-ascii?Q?07Gq+QWDBRwHb7j4YhrI7oS77ARW4NfmJjnX9TdUoM0/omOprEMGarjx6D5u?=
 =?us-ascii?Q?4V1imfFWr1ujYzZc9cq78Ih/0g+AlmSw0iNlhgkqE9OJBwnI6cGUUO1eqPuY?=
 =?us-ascii?Q?c+3Kg4V+oU3uNO2orz423/aARSdW00nwD5lrQZ/YhbzjK89GmxvlvmbEGtln?=
 =?us-ascii?Q?Wmz4+TfEeMwEc745EFZvraGHqt1OR/ZddHcuuSNho2LW6vevO6Dyy4APpY85?=
 =?us-ascii?Q?6jl1/Ktwbd2zjg9W6PyOctafww5+wf9E2hNbJiUG5UiDceXHZJBmFFl0fHjx?=
 =?us-ascii?Q?YNCUyvXF4zw4KxV3pLP5Cg1gBxOZ6ptBgnHv2sUbmKfa4fhb/ljf+HylBmVt?=
 =?us-ascii?Q?VmA4pGcNaypoBr1nI54IRuVZae7U8XlGsc32/wVvsoFvrSPiDFrvrPJmZGaP?=
 =?us-ascii?Q?9VGKlHQhT/DtZfrQSJpXHmAftFW7J423rq+BU5jY5te7F6n6nckvkZKHethd?=
 =?us-ascii?Q?t2wCkaPIa9SnsmJf5PHFr1r5hKCtczcSuRJpdwysZSGlsszSw3unPVjedN7p?=
 =?us-ascii?Q?ytNJpKr8g/bIDJxRQyiUoV8PzLN+1DdPHq60UUA65iTsN+Q2Wh4qsQyRgWzM?=
 =?us-ascii?Q?VGKTscVA3SO99M+eEoOr+KU4OpKaqTMF+q4sMD+iEuWDF8qvcwCIE4HAolzq?=
 =?us-ascii?Q?+a7HQU3OGTw3u/X5oAQ2s+aqOrKkGRRvjpjKHrNG4AJxk8K0gMZHOg4BZb+c?=
 =?us-ascii?Q?JRE4FJMCblSyAyI3M1hy11vET9BDORVjNM7xJD8YK0ysD63amjBnLtERv5Pp?=
 =?us-ascii?Q?Es08Eqw0HnvC/xHsxwsijpapwVEg+WxkLyBm9DESHEcT9NW11k1s32ZVjGEc?=
 =?us-ascii?Q?/IFch6TyjfpkLNlii8/mztnTEJutTpOVoPus3xh7sTc5QHYCPvEY1peghaEK?=
 =?us-ascii?Q?Y4L+P64ACr+pGgQAWkhe9wG841dS?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Em5kkaBga1+hPHPJc6DRpfsbpTh/U+VJoB0m+HLgc/EcDIZHSk7wK8epgneT?=
 =?us-ascii?Q?Eu4X0zWf0DV4Twkcni6cNK/tIfi12LMhm82JYEcvDprJomn3TjYY7ljc8qmy?=
 =?us-ascii?Q?5z7y7LB3uhNQoYP7bCS+0HieZ5DTAe1NcJsXxxvHn1PC9QOuoCSAsN1jBBjc?=
 =?us-ascii?Q?dtac344gfvWLtJyDajRDZ0rHHh1EpU6BAcVrv6Thinsu/9QjLAfbPi7kBwzU?=
 =?us-ascii?Q?B6OjBSELcuqviMe2u4K4r1XG04lVx5QBLb3XhgQg1wevUTXnWZZWNdIdjUS3?=
 =?us-ascii?Q?3hC+NVJ57FkVi/eq5Wh95Ripc50FXTsH1ioa6VwGMpVWQWSo9xZ/M6Z9whWg?=
 =?us-ascii?Q?YA5u1MJ55C9Uzvhr4d3sXYBvFffbYvHNq95FgC+uZoLHI65GXaNYn4zELaav?=
 =?us-ascii?Q?PtH6qlefrdxp7xtXpYlpQubnGY5sW7JxuAzy7P/wxP+lNkwLBoOdXSTBoq/l?=
 =?us-ascii?Q?rFDjLKflwXozFBGLUYPC827grNdifOH5lYF+YYj/NtQeG0XyoUib8gEWMUAI?=
 =?us-ascii?Q?sY4jgmurMz4V3NCK6bVpRdaikGrvstESH8OvzhXUrP/a4PmIXsC/soIf1cS5?=
 =?us-ascii?Q?f8nwZjwP8c8BCO7wNj23u2mWWa7SrRA/ltHFXyIAwaRJJovPVRY49kZikqoP?=
 =?us-ascii?Q?j0NK3eb3sqWj0Cfg9F115kaOJ8w8+dikUbTbaK4MZFmQ7XIRpc0yggXumnRm?=
 =?us-ascii?Q?1WYyTxQfPAFnRJAqKJ0Y5CN+zRfRRh10HnLwBRttVOVBI+VxJ1B5b0rIK0VC?=
 =?us-ascii?Q?MVQepC3W6zBK0HNhiZl4PsbYEF9myC+K1sVtod4/2MtmTrzqWkz7yNgKM/UA?=
 =?us-ascii?Q?eLwTHSu7qXfYKtsE35rCkz8QMbHT4CVT6b3+My7WFNXT43nWOdrcKJ4YuHhN?=
 =?us-ascii?Q?5lv5QRZ4rGnLhr4gyFCjKEfOkVxznlAX1BAtqO0jJ8Qcprev34FxeQowsGNa?=
 =?us-ascii?Q?Kp8qyuc7ALjuNp3wjP1RvmfKIQNFqwEp3kJ5rZmHE9TWETMefFvpKn8HYash?=
 =?us-ascii?Q?7Bd5m0uOjMoyb94PKrsemqgw/XqejZPXs1IcMtRnkkfu5niVjy3DW25T3ij2?=
 =?us-ascii?Q?MDxWJ2y2IIzj3nXsmEh0mn2Ca4Om+g3mBcy69gW3sr4L1X7njhPspVlj/V4+?=
 =?us-ascii?Q?HN5JDEOAGLaCi8SysFt/7v8OkKC+B2r9K57cmc3iB3zNwbJ1WQDsIoVCgJNA?=
 =?us-ascii?Q?73ARuwiskW14vz3eShgFNRdkN+4qlFj2heiCCDHEIjZ/YD0As/s4iluDS3wV?=
 =?us-ascii?Q?pQy7G8OP6j+sw7FZ8n+wiKYCPzQRemFi5TBotJxUVew+fRk6LKpxXce8UwfX?=
 =?us-ascii?Q?1L8rJ0DcP7ay12Oe2sqUIQOwua1DR/tdATWlVWbZqsvJ2D6uz+OYrOsrQUKL?=
 =?us-ascii?Q?PIV6ytAG+4D2j1U/NzGqPL2ic2O1PcPMVeo27ixe7gJNuVvZmODhEGefstFZ?=
 =?us-ascii?Q?8Xv2rscKb9tUFsiwWSv9borXfDZecvvF1+spXZJ2rqrzXVTTSkjrK9oOKCOZ?=
 =?us-ascii?Q?M5YT4OekPRGc3k3qVSl99MUopVJTBw4aeSRaBnYPCSzjbdqymS26G5kHbFex?=
 =?us-ascii?Q?ainA1wWQG6EkrLweNh+mELNUOTPskn3Shxo7/6HJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c527f564-17b0-4549-d25e-08dcf3feebf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2024 07:38:58.5200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+Gm1BD63mSGQ7nGq0Q87bbQ/wT1+PhiyTsxBpMdexHKTXCPKwv9udKc+HVr87rJPAj9QlC+eQHtpsHgtFMYpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8432
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 10, 2024 12:23 AM
>=20
> From: Nicolin Chen <nicolinc@nvidia.com>
>=20
> The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memor=
y
> Access Flag field in the Memory Access Properties table, mainly for a PCI
> Root Complex.
>=20
> This CANWBS defines the coherency of memory accesses to be not marked
> IOWB
> cacheable/shareable. Its value further implies the coherency impact from =
a
> pair of mismatched memory attributes (e.g. in a nested translation case):
>   0x0: Use of mismatched memory attributes for accesses made by this
>        device may lead to a loss of coherency.
>   0x1: Coherency of accesses made by this device to locations in
>        Conventional memory are ensured as follows, even if the memory
>        attributes for the accesses presented by the device or provided by
>        the SMMU are different from Inner and Outer Write-back cacheable,
>        Shareable.
>=20
> Note that the loss of coherency on a CANWBS-unsupported HW typically
> could
> occur to an SMMU that doesn't implement the S2FWB feature where
> additional
> cache flush operations would be required to prevent that from happening.
>=20
> Add a new ACPI_IORT_MF_CANWBS flag and set
> IOMMU_FWSPEC_PCI_RC_CANWBS upon
> the presence of this new flag.
>=20
> CANWBS and S2FWB are similar features, in that they both guarantee the VM
> can not violate coherency, however S2FWB can be bypassed by PCI No Snoop
> TLPs, while CANWBS cannot. Thus CANWBS meets the requirements to set
> IOMMU_CAP_ENFORCE_CACHE_COHERENCY.
>=20
> Architecturally ARM has expected that VFIO would disable No Snoop through
> PCI Config space, if this is done then the two would have the same
> protections.
>=20
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

