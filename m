Return-Path: <kvm+bounces-27292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 895A497E70D
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 10:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC63C1C21177
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 08:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4B05FB95;
	Mon, 23 Sep 2024 08:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LQ7ELclM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B52BE5E;
	Mon, 23 Sep 2024 08:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727078480; cv=fail; b=JV0CX+SjW/u9dxNOgs0z+LZR7uxXYzuxIPTaDLZ53wmu5CEsuwYgYTUbxGS1+g2zkfr02sgLZ8nMmDcl96uuPSFMmc2d+/Gr+LVhwX9HvD9ddeoX67XYXZ3NVdinFvEkLZqqBUox3SjFpLU32Z/oP3gaSPHuxRKdBqqPCTyYpJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727078480; c=relaxed/simple;
	bh=RkI2E6NiN8x1mhlaqXuKSBahrp4gn8PUdx+YXE5VT1E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I18Agmiuff58T80+eum1fhaDP9LksZ2Vz3zKLnemCwE2zYgQRJc+7/RxW1nwTI5Yhff2+KAmXhT0SRo16m6P189En+EBut+o3cYXJ1k6sFCtzNg/tK9HCSRNgxcTCELzmfRUt/2OoOVBkPvZCpgn9OSocUhz+Tz88oIEdSGMqUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LQ7ELclM; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727078479; x=1758614479;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RkI2E6NiN8x1mhlaqXuKSBahrp4gn8PUdx+YXE5VT1E=;
  b=LQ7ELclMMAul/e0dIPOYsRCVjqo/XH1H3L1xPZuqunuPTA98BBWTAD5W
   AAOBBSKWMZa8WmNzy0TUqgfDs+DF2OuegIVpAJ334IkR83stt00RaG9TK
   SXbiIN2/OH8J4t9JXYkLh1EG4NBNX0OWpckjqImVM31V1nzXN9MBPt9bt
   6gtD9KV9dEuVpldBqGELMGtHX9tBA3n59KBL9LeZx/OC1He2NFd0JPOgF
   86YWsuhWrsfkxGLswUw9nNEjgqxJyyX/OXZsy56TaVyEolFaEhsJqsaMZ
   kbkybrn77OHy9SWPDDqyZCA0QczQnP89V2mOMKpW4CGQGd1Ddt3ZDj7Ln
   w==;
X-CSE-ConnectionGUID: WT5nItLxSUWMBZQPwYPUbw==
X-CSE-MsgGUID: W8EdC8hXS3+8pOcWoxmegQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="37148825"
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="37148825"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 01:01:18 -0700
X-CSE-ConnectionGUID: IZnPHe/fTwyuOV7WJSIv1w==
X-CSE-MsgGUID: fM9sZM9HTCy92MHlykAr9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="75936841"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Sep 2024 01:01:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 01:01:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 01:01:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 23 Sep 2024 01:01:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 01:01:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iCtA7ZnCPYa/lXbHJCpopwoPqqMiKHfAxSRImfsDDXH1kV8Aj7/OvuoI81zeBT42BdI4KGp2OQjphP6ybPby6e1fIjHHO1xDYmEsgUlhofT5qn5X3Gr6NsipZ/0ZqTQNZQj+UAx/lmfljprDkUUGZnL4mf8YA6GoO8NbSLmqENtm212hhwSqYUfvAOCDLNYWE7B20R6SBVHtxl9u2T3it3UYZtjOSRNqDqGRoFRpaY/KCLmCMoJ1psYJxcQNdUoZx+HxyzeXiZAlvWrBQCmUBTk4n9WczJD/P44gF6dm3cxsib703L03dOo2J6a7SfOh9v4p1VL/G/KDNnYLr5LYTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/b5mG++pUQ5IpjqjoqCJE5BFpiubV6AsKshSjoCcW4o=;
 b=cL6EZnNxjlUFXpzOWdFTeAnprPnYWGZJbiROYeVbHJHGSSApLICaIdZHM/kcgedkmzs/IazeDMlw+LFLYu85yBZcBAq+FZwk2/NvlEgoWRMXdI2BDZxdAcoNBsJOls/38EkjbH4Me0rkoc3KhpuTolXXKCtyDZz1UKBg2igYwpWBL8bucQAHjNfoz/0sPOxUy9sdyxHRbmRW2CLNIDq+6mPv0gih+uXYwvl0YHL2ma7BHcaFbBztsDREBGFaK5qZGpQuaSrkQF58itYP+cOxsmWqu6Nvr7yb4OkSbxiM8IyxZXDpvOE9JhZdM7fGh4fttJdkVgjK2SaJS03CMICodQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Mon, 23 Sep
 2024 08:01:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 08:01:13 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>, "dave@stgolabs.net"
	<dave@stgolabs.net>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "alucerop@amd.com" <alucerop@amd.com>,
	"Currid, Andy" <acurrid@nvidia.com>, "cjia@nvidia.com" <cjia@nvidia.com>,
	"smitra@nvidia.com" <smitra@nvidia.com>, "ankita@nvidia.com"
	<ankita@nvidia.com>, "aniketa@nvidia.com" <aniketa@nvidia.com>,
	"kwankhede@nvidia.com" <kwankhede@nvidia.com>, "targupta@nvidia.com"
	<targupta@nvidia.com>, "zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: RE: [RFC 01/13] cxl: allow a type-2 device not to have memory device
 registers
Thread-Topic: [RFC 01/13] cxl: allow a type-2 device not to have memory device
 registers
Thread-Index: AQHbC61mU91pMddqR0OwBJhpPXn8uLJlBg7Q
Date: Mon, 23 Sep 2024 08:01:13 +0000
Message-ID: <BN9PR11MB5276991F7009E0F16826DE408C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <20240920223446.1908673-2-zhiw@nvidia.com>
In-Reply-To: <20240920223446.1908673-2-zhiw@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6936:EE_
x-ms-office365-filtering-correlation-id: 67bda651-71e6-4a44-68c3-08dcdba5e4b8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?Iz6xSCBIKhkhOpTxfQjlMGqORcvpqt5Lpv6r8IYykfgRPp6Ze1UZDKiZqaGI?=
 =?us-ascii?Q?H9prxbPkV5SFRuIVZtnI/YCHBbLDc/hGo/lCYEvpMgcU6ushKBz6dZHtmU16?=
 =?us-ascii?Q?2uwsYFpJ8sTH7/7Ymz9jeBVDMIyWdWImVa6eAJW+t3aK+SuDo9Nf/2SFtB4n?=
 =?us-ascii?Q?XZKRgAg5FM/dkSTakLrH/d4ORA33LKf2qD8dDpVVbftrd8aEYgGmgc3ShXZY?=
 =?us-ascii?Q?bLpzm3oz8jVZBz6Ia0nvBKUryP5Q19vm3OE55CidINzkchvDc8m2/Yjcv23+?=
 =?us-ascii?Q?0JWebSodgLUQqtdBV7q+Sh1/zwQ7sG0NNzjXvfLowoN+3b5XOoOkgcxM2Oi4?=
 =?us-ascii?Q?z8hQw2ypjMVU20mYE7WB1G+0uCL8I7aPdC18uQXvWblBsPks6CaQHVh0gvfz?=
 =?us-ascii?Q?1dKWjMeEhHtcwqyGrfojR/6DGnyfDThJH4Sa1WcJ2ammf70KPiXg2a/B236N?=
 =?us-ascii?Q?XOA21G0UVumaCmLX6RN7aAuALEXmbP92Lv8QROePyblbNTRXDAYDqzeTJBRb?=
 =?us-ascii?Q?ILboRveo5V/lVIQyzp6/Y58vI9Cw1hqL+br4l+8yztZ8zwXtNPtlgykkRa/4?=
 =?us-ascii?Q?UwTq0OLZkqvE5JBXO5Wik3kNCqmKobepB4z70w34LVsB/6d95gdcx0aAv0C+?=
 =?us-ascii?Q?cH+fFWy+f4evgByh1osro2zWbdRpKDuCXfEQJ1jQjyV8DcF/BgIh3dJ+UFiG?=
 =?us-ascii?Q?FDuNmsfx85PlG6trTDLdq7w+AWM6UV2fdtLPipRw82W833BsWbvNnAFXQDl5?=
 =?us-ascii?Q?JFa5v/TjUSfvPteFzpKRA2lwU0v7ay4KFu4Wx2O1hcO/168ImxbCHIdLjgt5?=
 =?us-ascii?Q?7nKDbhw/dg4xGVX+aPhH7E78zSW++MmFbTpyxz9+9Q5KZcpRk4ZdxrPkVmXm?=
 =?us-ascii?Q?7iW2FXiAdcW0ZnGUcUXOBFQtt86OlHhr//i/3D7AzPfrA23ISI+rjs3NGN6A?=
 =?us-ascii?Q?XxwyIyzj6y/GdmHQsXd/iToDQ2waYtQGIV12PVFV9i+ZGQwaiVisK9nZrnEM?=
 =?us-ascii?Q?+R+Jw3oDQeL2j+iVGv55It5BaWoUZukr0l+cjvb+ZSYJ0oRrEAWZJVcTDjEw?=
 =?us-ascii?Q?D3Z2fkzF9/dGcW2S+UEj8o4ON6SHDJ/qAhB/B861ZAvW5+sboruebAcFxbnd?=
 =?us-ascii?Q?+liKoLib7CTpG51piJf9TOaMcGyri0aA/svoTd5PamSDCzIJA+idKHb7XNYe?=
 =?us-ascii?Q?KGp2gUA1kW6hUquIu0/vMm/OktGm021tiQ3JEHcR+bSI0YKv5zpDBZ011gLo?=
 =?us-ascii?Q?FcomJeLm1PUCUWf7Oj8PDMgwY4ipvrthQLD1HEdreOWrGVfu8ZCG1G6RwHQH?=
 =?us-ascii?Q?c/Mcosn9hQf0BZRcnrglzDEyw8o4HgX41I9raAhth9UJLQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NsSb+4t1nFc4HjApqY1L9A7h4ES6K2zug5pEsei6EhDs1x9plPRya5SUuUzG?=
 =?us-ascii?Q?dk7gdgia1O6axvk/SYVMFGbYeoDXfEIK3dhpU/yEQL2rXQi2pdPqsbrgPykG?=
 =?us-ascii?Q?o3DFq5briPOoV5SS/coNi1RIOmT0PWFkiAgl606xC1G5v4dI0V5wOm9PIHmT?=
 =?us-ascii?Q?ufQO2i9vm9cbTOC+vE0OyYdUYFmYGkWvmLY2ZImnmWQ09rT14nMO+yiSkXLB?=
 =?us-ascii?Q?kayUAXYk9ELQcjneHtHYd7024Ci6Roh3mtRK6QTAqKpzp+KkeXbgY7tc0MJF?=
 =?us-ascii?Q?nU53P8+wJsB1WdFV4ra1J1o1s24kr8v1rzMiEer/XhLZ2sgTVsg6yTAWgDtq?=
 =?us-ascii?Q?Gx0wRrBT2wL0TocoEcJlATFHqn8WlSHewK7XhBgQWEgXA3o3bNzCcfQ2zQK2?=
 =?us-ascii?Q?a+As5L0Ll7DrbcZeSJEAI87oVkGHcdbm4res3Bf8ALXNEI1YUH9x2GggyDKD?=
 =?us-ascii?Q?1DuSaKBUgwnKgaefsFTQG2Dqs1Cu5n88bQ2i9MHYP2FU4RzebhUqxo6v35LD?=
 =?us-ascii?Q?/tzhDq75CKAM0tLiESWxfP5U3+hI3yhCtIiQqhgjTuK1+mDmEc9sgKlmIE99?=
 =?us-ascii?Q?RJL1ISzWC8sUai9oyzd+aqBcnANjes2p/czOCa7cDI99cIV4J/e8bJgi4pRp?=
 =?us-ascii?Q?qK0RGYY/bmmJ1ccxHWlMpjbR5TIdWQwF88eQ25gYDmXNoCBeZmnb4sPrsINK?=
 =?us-ascii?Q?gPnWUQz9RY8FMd2BZb1xbvgOqmCPHQHX+F0u1p1wVXYRktOVmHZGVEqkmUCN?=
 =?us-ascii?Q?Res/QoRv4n0YdI7z2cOa0rytU1kpfliz5LkqUAlC/j9n5361qRXg+HbseWoF?=
 =?us-ascii?Q?ufkrq9jorI+8fX5Sd7kbP2qP+OUziBweijTJg0xk51yPtnSXZM57EzQknFbf?=
 =?us-ascii?Q?KIDr/+gvnc9D7SCnkCTZIaZRTJd0L8hZGEkFIiAs9XeJ+44kYuRlDYNdsn2d?=
 =?us-ascii?Q?oNwCmVd8E6DZpPQyrkoe6fT5GtZJuCTs6rl6BZ6Anh/xNOhiHubr12laMATN?=
 =?us-ascii?Q?NQclQbH7jvugy4l8uOvVJ2hdJsM8+3iWH65/TVIdjD8v8PU73OX5FoWUKerO?=
 =?us-ascii?Q?o5sVy1opO3DSL/xYk/HxU+YEemW2g6U53xLdtFC1BG0Imp4Ul7vLFkHloT5e?=
 =?us-ascii?Q?hhQ1/BmJ02IlizpybqLeXy+JDmEhT4pDgGj5VXr/oiT/rawdNCDH637MgTrC?=
 =?us-ascii?Q?COnW74Lk0WrKHpSkZcNRhL4RJ2VUZoC+HMbJdfkq2dT/zckbAJMDNPAAQg6z?=
 =?us-ascii?Q?9UpS/x7qcPqBrB2TzfkHerg8iMC5YsUrXeCf+8+57FwlHk5z/BxXheoA5EFQ?=
 =?us-ascii?Q?eEUy9CfZy1keCrHYewLjYWJ2rlkCQg6JrG27EN21RIxEMrk3ImJfUAWyJDDo?=
 =?us-ascii?Q?Tdz4rrxyWirqJT5NPFZIzOtmXMiaP5BN6SHVJJlOAhk2sJe4zze6QZ2W9TJq?=
 =?us-ascii?Q?ioweLK/1it0GcLHvzSe35/wzmN7eTufajUbzr/e82cQj3UQ47HQ7vZlQ3a5o?=
 =?us-ascii?Q?Wp4kpnRbj7W5E7UeK1DEvJ5g2oZugSYc7gsu7XjJNQCG/nZajzD1gMHK/WzV?=
 =?us-ascii?Q?Gbzyr1srMWEE7QbY73mzIKBj9rRd0kbTun0la693?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 67bda651-71e6-4a44-68c3-08dcdba5e4b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 08:01:13.2819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EWnGzuXit40p2I5O1ABzJPo4Y4COt+qAYJ3KfFMiwlaaJ5un5ayfTP6zRT1JMI+IRh2RZEUdPDAAN/4V6xVh0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6936
X-OriginatorOrg: intel.com

> From: Zhi Wang <zhiw@nvidia.com>
> Sent: Saturday, September 21, 2024 6:35 AM
>=20
> CXL memory device registers provide additional information about device
> memory and advanced control interface for type-3 device.
>=20
> However, it is not mandatory for a type-2 device. A type-2 device can
> have HDMs but not CXL memory device registers.
>=20
> Allow a type-2 device not to hanve memory device register when probing
> CXL registers.

this is nothing vfio specific.

>=20
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  drivers/cxl/pci.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index e00ce7f4d0f9..3fbee31995f1 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -529,13 +529,13 @@ int cxl_pci_accel_setup_regs(struct pci_dev *pdev,
> struct cxl_dev_state *cxlds)
>  	int rc;
>=20
>  	rc =3D cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_MEMDEV, &map,
> -				cxlds->capabilities);
> -	if (rc)
> -		return rc;
> -
> -	rc =3D cxl_map_device_regs(&map, &cxlds->regs.device_regs);
> -	if (rc)
> -		return rc;
> +			cxlds->capabilities);
> +	if (!rc) {
> +		rc =3D cxl_map_device_regs(&map, &cxlds->regs.device_regs);
> +		if (rc)
> +			dev_dbg(&pdev->dev,
> +				"Failed to map device registers.\n");
> +	}
>=20
>  	rc =3D cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_COMPONENT,
>  				&cxlds->reg_map, cxlds->capabilities);
> --
> 2.34.1


