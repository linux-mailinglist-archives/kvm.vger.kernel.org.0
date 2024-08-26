Return-Path: <kvm+bounces-25033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A3895EC2F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 10:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 686621C2157A
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 08:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57C513C69B;
	Mon, 26 Aug 2024 08:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XksPr7Bx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D722A4A2C;
	Mon, 26 Aug 2024 08:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724661601; cv=fail; b=F6CwzCcBKQ1wCSQGSzjLRiqRrS0DSj7T0g9l6yT/Y+LIkSFqgS+bM+LUZ4LMfXtuJWtLJnzDKQC9laoPB/+6x4Gaa/Yi8SCDyuB8oFpJ0aQms0KMmzlVNG8msLOgcktHnWrgwQDKpQajOC00oW682Wve/BBEuVi8+ENOvBqB9ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724661601; c=relaxed/simple;
	bh=oIu0Bt6ERsfpwrXT+iaAmFEXoVoshZQlFa34yBrQs+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TyL0kDLwoVIaq+oiB79P8fNr9Fqx+YdNbt08nKsILtbtBDAIjVEVwj4oEeCwykKf3YWSDP+T8A7oTm8A4WTATbMkkpa2WvQW0cDJk3Ngkhlk8h00IyAW4zVklN+ldT35p7inn+KAKNtOxW9p3SjFpi1/mnXeEpnkE8nzuffSOJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XksPr7Bx; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724661600; x=1756197600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oIu0Bt6ERsfpwrXT+iaAmFEXoVoshZQlFa34yBrQs+w=;
  b=XksPr7Bxof6lC4s0PeSCoLJ85DnHwTA98LTjadc0mwAhaMyz0LkUJB5N
   6APY6KUlEhyry4OlOUjdcZqBGDs3KRzdcBK478wSZSmZyRc58ch5smgIm
   BSbKtphd8fi6gJSTHR5+Cpq3CETrdYkKGeEySFbd0dRou5l4jAb7ub2Yt
   j5tMj/YL1bK4i9fnnyyPBujFv9skM9kYWTXSPUwxFX2l2MNbTccMeTPh4
   fu0oR1zx9tEcyl4YLTbZ6BurODWMlJimypX72gQbxoVd7O8f2W9OrBePV
   Y86apiPcC4F9dmX7cnjf1fnieh21j64tTVuPDWEA9mVXazHJ9gNIRyEri
   w==;
X-CSE-ConnectionGUID: MD4KEUKNTPmzcVxHIPaMfg==
X-CSE-MsgGUID: E1En8/2dTQKGCqRgkPS38A==
X-IronPort-AV: E=McAfee;i="6700,10204,11175"; a="26864388"
X-IronPort-AV: E=Sophos;i="6.10,177,1719903600"; 
   d="scan'208";a="26864388"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 01:39:40 -0700
X-CSE-ConnectionGUID: ZPYbS3bWRDqqH0EPyNfBZA==
X-CSE-MsgGUID: 79m0dDLpQbezDvDLaCUSLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,177,1719903600"; 
   d="scan'208";a="67340645"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Aug 2024 01:39:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 26 Aug 2024 01:39:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 26 Aug 2024 01:39:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 26 Aug 2024 01:39:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 26 Aug 2024 01:39:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KCy+tZ4UkWw2p2np9CwqI5qsdEoqALXYwhEqmbYSWdOBMjelWGndxwzJGgfW6GXw1h0+lwLD1Zz/ybW8jEm4pZQQYd3bxu3RF9i1tVOdG4UMpEo2NvlwW1X5mcququAEPxN20oHfnCbpZCHhzXPQLvjraTiF2BdZ2enJr0GEMCT3YxDJAAS8y4G1PM8jCnE6vZFUC6EMQgS4MbaMyDW6NMaxDyrIw8e0Rqh4KfqKNK2FcBpDoW2UkgraVxfK1YSbLzhNTSp5woCZRxpWft4Geu3y0U2B24572abYK7sHKx3fVLguLE2S7Ri78MOl9K0bLxSUw7or9n7mCgF9CUruWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIu0Bt6ERsfpwrXT+iaAmFEXoVoshZQlFa34yBrQs+w=;
 b=pRl4vXoEXhnJVpT2KGb5Bk6N65IDYb58WX1/MrUeNp0PsUJmCnMrSso3e+X3rrO5WSynhPuule5PX2LLHgueUvW3SLUPA4GNUTK9TqTC1pzrlQ4Qe5jGoXhN/y3kgglya3C5/iRMbCboIEyK9jlcy5so49LGqZgW8p7NPeRoJJCeIeokwTE93NmsOqkn3Rd0ru0KFozSo/RTmp0C66GEpY8U8mZQ1T/Y1Gc4l8GNSTilKX4uZ+BWbPTl4FmgAv6Qad1EOkjls85qHuHKofXWh2yIHwlInRsXBIDWR4VxdbBp5pzRu5+B7WTxas8+lqZ8WkpugR7oIamyz9OizKO4Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7668.namprd11.prod.outlook.com (2603:10b6:806:341::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Mon, 26 Aug
 2024 08:39:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 08:39:25 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>, "david.kaplan@amd.com"
	<david.kaplan@amd.com>, "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Jason Gunthorpe
	<jgg@nvidia.com>, "david@redhat.com" <david@redhat.com>
Subject: RE: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Topic: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bI5OEgw
Date: Mon, 26 Aug 2024 08:39:25 +0000
Message-ID: <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
In-Reply-To: <20240823132137.336874-13-aik@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7668:EE_
x-ms-office365-filtering-correlation-id: 7ac2514f-9cbb-4dba-9c44-08dcc5aa978c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?3q0POfcmGHCTOGAZzySsNXtXgiPVB7rHjMbNx4NFd+1BPLZQA/Ru34AwgPYR?=
 =?us-ascii?Q?c0AQcr94P5Oc9lNMrlX2TA0GCTPcYHrloYZdZIyN48xnuwl61MEuvJFcvdHk?=
 =?us-ascii?Q?N1NWCFcFsjKz8agbaQ/6oppUaj4luZf16XgMbxOQZ4ehBx3oD0W9sfqVlql5?=
 =?us-ascii?Q?MuCtGzIv1AnfZ/eZBY9xld2xyzHtDVWLbbfT2bU1PNcp8shglvXMDukq6Hvp?=
 =?us-ascii?Q?MIrwJ1H0ddWNA10wJUUi/pe5NAx2Kh9wZOSY6/ke9Oc5P9FUg262zaRHtfyb?=
 =?us-ascii?Q?uvxiF+pRnjAENWFOoo7x+PbL3fGzcgQmNFeMNoD1CvfTHKP0HXDyY10aoH5K?=
 =?us-ascii?Q?hTvDYOP+UgIn1TGcP+wpDXDjZvG79J0bB/w7SwBq1oLBQ3iZunVqWY3ztBIt?=
 =?us-ascii?Q?CuxsXRt/xhysar5xvLmkHIjckeVzLrgt1cq4Wvc51qh24NHrFPBqF1To10By?=
 =?us-ascii?Q?JZNR/N5LNHxqaKcL8yLAma17nEXE0jSn4nZ69ERAaAgkgzhUZNQ4rqMboyzd?=
 =?us-ascii?Q?iJNFSHqVUIgDs8UysVVYjtnkrrVS8jpcglJnftRmAAqdhdO22AQ4n8R6v7Oq?=
 =?us-ascii?Q?5MrY0/z6WJXzISxgKd57aDIm1QduklPDtcNog+sSLwzcHQ0eVnhHPGbi2bUh?=
 =?us-ascii?Q?DrUJyDT8FzOd3woYDF50BAr8yTHgmWCjrrc4wEH8VE3fugZK7pDc1yN0+OId?=
 =?us-ascii?Q?x7fvxscmXZTdGKX4wHaosMxAIi+Zr5pMGA/FGiPMC7XyGrmiKopHjK/BnhZl?=
 =?us-ascii?Q?TN0RArnKXThHhZWLgbmUGJTa048CWoBOtKp+9ZWnIw5APlxRzNLClmQTgfGS?=
 =?us-ascii?Q?nqBF2JpNgI7q2MDINTUg9I2yV+6r9dA5YP6VqbZuNvp1TQBuyYfL19xiwQrj?=
 =?us-ascii?Q?LvCwwl5uteZsKVm09kD3dBV6w+zfQ88Vc5H6TCEi8G2PR1vJR+UYBu+AHOOP?=
 =?us-ascii?Q?RGS1LW5PqbC2hf/x5n9Ac/oLHfF3Cfg7Rh1czyDOjjLZ5UGFuWuBTvXdoYJJ?=
 =?us-ascii?Q?lR38IFyfsVSUkCXVNj5KQLPkOpqY4YReYyiWA9TL6cClzL9r+sFqBK1s/Knj?=
 =?us-ascii?Q?5LJA2qcY/Qo1OaQ0Alywdr574ti1e8MwBZwa8dKiSEpRtxoXoJTJKcE6HLIL?=
 =?us-ascii?Q?JjceIBV61slEftvbIE9Tw+KPIXugzDfoT93ERyAPPxIUzb7PoMPo7Gw7TzVl?=
 =?us-ascii?Q?jhVwfsIJnNO5FNuaL+cwibEBeSkd3PFPWgKxJcZaYVJ/R0T4qs9b2e010fj6?=
 =?us-ascii?Q?H06BXPIwUZ8rwL5Ch8MGoJg8wAEsgLSAFA5haVwuvplDtxRuVWEfStPH2vT2?=
 =?us-ascii?Q?h3K+7c8RQIgVzPcD7H3w7zKj78M40XtqgMfeTlkLS6QHy4dQNgsbw2L8Fa73?=
 =?us-ascii?Q?3SHvEKjKYJlomRxGWqzuZQLNCvVgHkiIR0qbn7eLlPQ0HxiplQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BkY9Sy6BwuR8t6ELxb/8HpkXwX1cCK+mXGZ0Cngl/S34/IBrVGewWWa1+cS+?=
 =?us-ascii?Q?2T1K7w/0vaXVRBzWz2bDouuWQIMrueqqkKz5ZWg4q7Zqm1Qs5fw8vBmnNt99?=
 =?us-ascii?Q?ihMTO+DqrxM9NF79j7Rdl7E6MTB/7m8bvM5Pvxil+EG9yP2yZazA3wji2PlK?=
 =?us-ascii?Q?W66uB77W/rJdPnzHKcvbullAFVCjbTFodaGCd1vXd0uNGnQdb3i7mNFDYL0y?=
 =?us-ascii?Q?ncaQcXJlKfwu/2c3+0ESgFJGCeA+QNnO5gVWKWSME9nPG3VH9rm1JXI5oVEL?=
 =?us-ascii?Q?qSkBJAfMUMZ9G8qcghBSilNcOCPj88nUwI5g8FW397PKxuRHIijpEguwyCLI?=
 =?us-ascii?Q?qy17q9mYBOyyj1/roMm+9OTd6EpewGUkC709S9EvMpOXJn3ZRn85lJ593pDt?=
 =?us-ascii?Q?r1ukMYx2hv5UieqcCTNfRBphxNwQkZXIaa8QpdKuN4+IFc8f/UY9gZnGFcwg?=
 =?us-ascii?Q?5XpBr0v2O9D293cDJ7YPreTIeECfa11vtjqclukPci5j/IlEbiNR1cV5TEFv?=
 =?us-ascii?Q?Zbl5AUGbbj/di0U39xHGddi+QpUqV2fos432uOhs+loIcPTKI/jDB34rIdo3?=
 =?us-ascii?Q?CsmmqTnPRkwtIzTJgZ9+FGIcJZsLDI/K227CmZa49LA2mtlM0nkFPmzrbccM?=
 =?us-ascii?Q?oWkAM5uQmTGTpvJaKpu73WzP/ZJULFbywuGXPJ7laKruVmk0qfbZzL/5smA/?=
 =?us-ascii?Q?CT5Lq9ao384l701et5yJ1mpD7mCLQTOm1YEhd9a+jSQgBP9P383AQ5Cog6nf?=
 =?us-ascii?Q?2q+GNUcX7VgWZBbfPGyfxC86OyGoKYm+OXVZxq0QdMeul/ZBy6MmE2yacZnF?=
 =?us-ascii?Q?gYOsQ7GJz4uVVSai0VYZobaMj6WOtqHH9ykihSzYYC+OCuo9RYcEb+djU8pN?=
 =?us-ascii?Q?fvOh7GnjUE2E240t0KlF9+V6DVGLK7cKb9CeABnZVmJ4g8GA1Dus4sxVIwoX?=
 =?us-ascii?Q?xGdoTYgsBwYo2gHcxrH2rnJIr546UPTDoVyVBrngEk4iJRVBZWmtMBvd55Nt?=
 =?us-ascii?Q?c30nSYBmkSrJsTvy6lF//X+OGbT/E/yEYiI350smxitbstXV0u0wAEldodS6?=
 =?us-ascii?Q?kh3rC3mBPNl1ZxPdIRPvxfTncfXGueoLfO3QJ1c5s6GYBNprpAR6gyA6hAHe?=
 =?us-ascii?Q?i3yCzGYLpY7H5Dl8IWz3QNn8SsqdbmNBKZLiALjzbChJVpNtH/dhoBwlbc+4?=
 =?us-ascii?Q?EoBUMEgkxf4hjm1+WAirmRAFdRrdaejrkmaksUh3c9ljLmD8zLADQ6ck5Bdh?=
 =?us-ascii?Q?G0RZ+j5Dugp6vRJ1RJDgqPD9AjIP5RynM9hMe/GgDTV8Ftwx07++oaLltfBQ?=
 =?us-ascii?Q?4SH2gDx7hp0uycQUfoJo2TXn3BN473YXrKcLJQ/KKNygwW779pnt5ciISMW5?=
 =?us-ascii?Q?MjyJNeJ+Q0PCm8hvFMJOy819ojBEOmgN9ibY5MOpHUqWb1aFo7MsRHAM3yBa?=
 =?us-ascii?Q?AOTJdz5o5efrso/IGFE/QeAiCzEebmHrNAKLaeWHtJXbRy7q03YBKbG/cHp6?=
 =?us-ascii?Q?MJB4+TcxWIMO1IhI7JOfdOr6v1ucceYjxx3rkQ+l7go4kpYmdZBZ9tV9wL4U?=
 =?us-ascii?Q?hsTfYWoXXCznOolV3TfMumpPeaD9I/bA0JDGMclx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac2514f-9cbb-4dba-9c44-08dcc5aa978c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2024 08:39:25.7415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IVeyHXI7UAKUcJM5sPnPsxM/xeDJvrTrfHCeg6a8nvEiyWlEUJptm9AYmmtSjiBomnBI43SZ39o0U/lc58u5DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7668
X-OriginatorOrg: intel.com

+Jason/David

> From: Alexey Kardashevskiy <aik@amd.com>
> Sent: Friday, August 23, 2024 9:21 PM
>=20
> IOMMUFD calls get_user_pages() for every mapping which will allocate
> shared memory instead of using private memory managed by the KVM and
> MEMFD.
>=20
> Add support for IOMMUFD fd to the VFIO KVM device's KVM_DEV_VFIO_FILE
> API
> similar to already existing VFIO device and VFIO group fds.
> This addition registers the KVM in IOMMUFD with a callback to get a pfn
> for guest private memory for mapping it later in the IOMMU.
> No callback for free as it is generic folio_put() for now.
>=20
> The aforementioned callback uses uptr to calculate the offset into
> the KVM memory slot and find private backing pfn, copies
> kvm_gmem_get_pfn() pretty much.
>=20
> This relies on private pages to be pinned beforehand.
>=20

There was a related discussion [1] which leans toward the conclusion
that the IOMMU page table for private memory will be managed by
the secure world i.e. the KVM path.

Obviously the work here confirms that it doesn't hold for SEV-TIO
which still expects the host to manage the IOMMU page table.

btw going down this path it's clearer to extend the MAP_DMA
uAPI to accept {gmemfd, offset} than adding a callback to KVM.

