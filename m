Return-Path: <kvm+bounces-25470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA33B965941
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39DBC1F24D6F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E762515FA92;
	Fri, 30 Aug 2024 07:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oC3Q+kyk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623FC152E17;
	Fri, 30 Aug 2024 07:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725004700; cv=fail; b=PpqEyA0yr30ePyUTzcStReEzTFfIt3G+seEEG5Gq6uBsjy8VaNr7XrppgIcbxYeK4YosmUKGcyy2qTjy6aR5sTUQbc0j+cZDx7jYhwOx+XuzLjzJMBAslg4p8pg8JZ5StYlrFtvpu6Av/ThnkdToLYLc+TAcAMvEfEVNjQQ2yHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725004700; c=relaxed/simple;
	bh=B5PMt5oi1hLDPlIiwRV/NBQG1iAeshwQldAOyiVLyhc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aSBxR13Lv19QFKfh8200GF+7lmK1fIaoo+k9o4ahSCdgl+pg7eGRJm4j+YkwCq/kJggbo1f69nvwAX5hj89QGxZa+9BoZbgot4iBQy4sCpmhR7AUVt4ZWKXe5SWdHP/GDxnXGBYUbRMb3Q/iEILphx7H5SkEFwx+jnM98HE47Yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oC3Q+kyk; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725004698; x=1756540698;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B5PMt5oi1hLDPlIiwRV/NBQG1iAeshwQldAOyiVLyhc=;
  b=oC3Q+kykbQ59wKp+y277sSmIGUrC20oyKvCxACd9Y6TrVjz3I2A2uIlj
   se2SVFPlBkWdb/fniTe0NqmgLM/cliPr3/buzGjaidq/KSgXbAut+4CB9
   5vxv31oqkAGUx18GW/N5BT6gsPxIrGTcBv6RRMDkJ481jUhTcEZLeln7E
   YnHunQrff/PiAW5MGD5SCq9NQqwPcx4TMvCMm59TDeA1KOmPTCF7cq5x0
   zjtD6Sk5H2MuGEweBpgzfObm6eRWRPo8AtrOBMF51ULBI93WFmD0xpcLs
   kgdIXThy0J83K2xUKlbHgzELApOO5JZ1VoLPNXwNIA4MYZIDduh85lj6S
   Q==;
X-CSE-ConnectionGUID: iuqDpJ62QIag66KDxMH02g==
X-CSE-MsgGUID: Gx62mEVzRUOEyk+naxYw+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="41115858"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="41115858"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:58:18 -0700
X-CSE-ConnectionGUID: I1gGAiz8Tn+fPDDDMbnPyQ==
X-CSE-MsgGUID: fBHpfckfSCqscVcmP670kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="64179862"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 00:58:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 00:58:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 00:58:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 00:58:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 00:58:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnH0bh5WYT1A2e/FH53Ap7Qv0K6+QRwP2uiwnWZirmW/Db/qXVWYZZhpBQQfQnUvZaQHbWOFWe2o2/CuMk7JrELc9ed5sMvp9kQ1EC7s/j3mi19yyhDp5U3/2n4oQvaD6fRWz5fe8b6ELEde36NJNXmA+i6t3EpCieDoG8goW6x3gIAouiW09ZWF7JrR69WGltEywgXyiThD8YTNhvJTHko+4/o6NU1zdBfZXpuIEDYJGwvt0m3aAptL/lLM+sjj+odPlRLwbXdWp/EzbBkwECV5DONCAoOS4ynUJkPUW1Kqba5hL7/V0Cu+dVYiBEQZASVBoLOEbVwqrRVGdafkkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGMOx3UjtS4MVxi/78cp05LTTwTNmBs6Ll3IoZIFUog=;
 b=QW/ZhbN1p1biaKok2F86TcojZj7lufhoSsukzz5QEapx/X5JeKGTVt1jA8g7JJHYbs0e2pyHXVRxL39g/AWEJv6L8cGlPM2OB7kbqo5vlKwmY8MTsbhiQLBar+FpCwVRmsaff+HMLHv12SJTqewel+ooFH19bK6rXrZTf07EInAOURTNaivhplRL5RehQDrCFkcCdfV385GNYc7LKEI+3QwqBDKyT3c3zEsSIKbqAZhKkEzJoajOmSOpIyiyj7tjOotc0bPsU7efw2P5rwuLAHuFCRJZJLsYalf4emK/68N3ON/WGk+Y3fiCDFcUYVm5XxmC2y6I60ymHX5Xl9ZzbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7173.namprd11.prod.outlook.com (2603:10b6:208:41b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.29; Fri, 30 Aug
 2024 07:58:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 07:58:09 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown
	<lenb@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
	"Sudeep Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"Nicolin Chen" <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v2 7/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Thread-Topic: [PATCH v2 7/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Thread-Index: AQHa+JkOA9P1nYT9XUiw0pRu9nQVu7I/cvsg
Date: Fri, 30 Aug 2024 07:58:09 +0000
Message-ID: <BN9PR11MB5276FA0C2A0F8734C2F506BB8C972@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7173:EE_
x-ms-office365-filtering-correlation-id: cd7e185d-2c27-4877-76be-08dcc8c97d5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?us-ascii?Q?Ug5LWcSTNm64UPsHxCEM+exgiO+m9tZ3BVI+YKavqnNAuMfet9Lbl7ooL0xu?=
 =?us-ascii?Q?t7uuijAFRREYXzVlTELGbNS7p37znritgyA7uh67HjN0jzAvoG1WFwK+jGLB?=
 =?us-ascii?Q?/TOLcjaKHyDLZQkp2urlgBG8p7vcDaPmFo/nIeJrDWu93QssnKe8WVoZeKbD?=
 =?us-ascii?Q?D+CTtGqnWabp142uHykciAmHPgSRFEVjc9MJNcYTKgqE+NJwlpKhKKTWqMlR?=
 =?us-ascii?Q?eotOpEOmvj2oymSlkNlwyJTn5QuoW4aRxqDowovrGykjuQZgywF11AZN/k45?=
 =?us-ascii?Q?m5BdlKrUIY8ADpprts3hPSD4CB69gzT/rHHa4NzAHZqfHlH2hCRIkREwhFmm?=
 =?us-ascii?Q?YxNd/NRy2Evw7ngK8Uvez8XfnnkcG0qcrH4MQxV47SiO9AW+CY+er1NwQX9+?=
 =?us-ascii?Q?uKFVmWNRnvzMwTsE4Hi599TVUldic1qbYuRzlUQ2jSYniP+TvpjNBlx4hiWM?=
 =?us-ascii?Q?ME6D5i43VugS2KLC1hFz+FbbqK77OvIdpvche626X9GA3jrhOXZMM5Poz1OT?=
 =?us-ascii?Q?gyQ9zefWM5FoHph5T5+i44Dlx5VZHV3UZIFVWptZKzMr4RekYtK9d+nU/Xyr?=
 =?us-ascii?Q?N+nR88X4xXN71PBxbn/TUzdx0ASFDlN8n1RdoHWeAYuDI3W9tz59uvxPn5Fu?=
 =?us-ascii?Q?ivNZg5PtSA8Y1aYhHQTgn56J8BXokFdb9tmC4aYQbG4f+dmDFiqit3nI5Jkk?=
 =?us-ascii?Q?FVOdZzi+cInm+NVCx751EPTY1hZTM1PK3bimkIYPsNXiKR6XAALtGT8OWxCk?=
 =?us-ascii?Q?Se2E3DQSZjFaW//gs2pZbDRb3UZnFG9ErYiQJ15SGFa4KE++lq/L3WW90uEd?=
 =?us-ascii?Q?WfI4nM8YcMbr2wi0r2IdCW7a3CS/T2aXhcxvuzWq4hD5c2ECV4+UOgPIrZ8k?=
 =?us-ascii?Q?lETylHG12jF85zxYCxkGxYNvLLRFF7cbiY+X3A0y+jenfEkm8H48Ou7zaFt6?=
 =?us-ascii?Q?PwQobty5J81P5+oShWlr5Wm6AkoC3Y3ZyX1wPis3QE0KmHmCXkQt+dLqx1S5?=
 =?us-ascii?Q?zsXkux+EHNIVX94YtbbZE5P+wfxjq5MbGT8mfTBGDxjSrd372qQzxBPaXL7/?=
 =?us-ascii?Q?TfgmYHx2vYY4+rZQ0vpwc1wxnMNYALGVbGHSSn7OqVOQE4UGztPmEOwOmFy1?=
 =?us-ascii?Q?mmYWi3/VmZm4uvYUWVsLrcCJ6dPcb1gWi1VSKlwgo2KjfarjFgfhIUH5yaeZ?=
 =?us-ascii?Q?DafhjZ9sGO3yBh5iiHeDGipHEQwbeQIxHuC3bEMfjUONpV2R8doSFhspNmDo?=
 =?us-ascii?Q?GBHzfVoAqvjEZOOxrcUXnF7QLDv30z2qxNX7QOAYxkG2emewdpuTPnS+MIsf?=
 =?us-ascii?Q?6HQu2anV2YRmCl0N3+Ve7Jylfn+7/4Z1LOnhQPPuUev4sp3es/mMg1xY7e/v?=
 =?us-ascii?Q?UrmGTrJZPDC/FmveTNgD6c1gQHTa+yhF6z5Fqy3M+rseQGZyIg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?blQG5kYWDzy/JHoFrI3IZ/ydmcj7pLfsALwLC1jBRP20kcm4FpYRc06BSZeR?=
 =?us-ascii?Q?Hsu2WmFZvjFqWWPRC75aAhDgfOlla4xvS1wicARVl1ahfXlmBMe2zBI7PCZO?=
 =?us-ascii?Q?u4qrQl0OHC9mFjYUmT/o1a8WQvkhh9TWxzHfnMSFYzW+QZz4L52gj7Mb3eDw?=
 =?us-ascii?Q?lvjfVPA18tHiENjojgWAxdyoVJAIm0uQVP4czPbah9Kt6Cg8lfRkCfjj+7q/?=
 =?us-ascii?Q?Em0qO59CsCPlD//FvCtfYJ+/9HhkEfmwWl4/YDju0Lwy2B26gpRC2dIpj7iB?=
 =?us-ascii?Q?RuoRDPKfIRC9Es+gYhmljQg3fN+jlVb5YbVhvfx5bpK66QQoOUk1latWgVCx?=
 =?us-ascii?Q?Sm8zreGZdCqDcdZ4kWBKWqFV9V44VMj3elaE9ISAV/xSMbF+/lNQvI0s62Vv?=
 =?us-ascii?Q?vqZWz2nw6F1XHXXCMt7hFgiLFeWVT3gHaNVu42OUqOXBLj/KISYGDK512rkR?=
 =?us-ascii?Q?ToULdohWiDxv2PjpKDbU9ZUAYJKTZqhjbWuZmeOjhIKgz4faFQaEswYQlj1+?=
 =?us-ascii?Q?Wh8m9PfYSIMHsU2yeNvxQMeye7NPl9hZT6lQGc44SOm78vaPqUpv0S82HLJX?=
 =?us-ascii?Q?j/FzFZZzfTSpD2GPAZwvYfIMi9I6y564SBDEKe/bHbS1QGIe7XBbwKM32Fri?=
 =?us-ascii?Q?TuRHQhi3aOUeZyzHE/0Yj4JnUzfK3tOdp6aGoEcJdWuAhfeU0nonnRzpHcsF?=
 =?us-ascii?Q?/MQNvNdpeTnOkx71nwZeziIIxrf3XOhH7IO1ptSM9nC4gKSpKCocWXnO2r4L?=
 =?us-ascii?Q?A37k6o+pKtPAJx0zf79dClXfhF8Zs1IBB0Z43n2/SADY7rhnZUGtcIjcP/JW?=
 =?us-ascii?Q?8FlngiSRtm8W2pc1NWsyP3g6WyGCmXmIFFjR5nYZaJsTmWi3fGoQDvVMDv9Y?=
 =?us-ascii?Q?ZS+7+pmGhALwT4wT1eb5Fxz5IG9TfmFApeG1dLp+jWzLIvWpz0Etpps5piE4?=
 =?us-ascii?Q?d5DR/G8XaQz23k9qkTI1/iNNLbEezpeqfNoBX/A1yZvg//sZkYjQz3yX308L?=
 =?us-ascii?Q?sECHO6stjm8PhVfIBPrQSBwAKY0ijieVpvvulVpicWVK9uT1JJ4vvevxyBb2?=
 =?us-ascii?Q?3lr4z7OA9RKSPktv9LSnPv+KWpNftFTtXcMvjZqnomCRIMhvAUbjymMBiO3w?=
 =?us-ascii?Q?qNleTtEgdn4Et0Wwhf61qEzxe/05bXFJoW1FkOZ1TrRFsWcfODoSL2OzaD9O?=
 =?us-ascii?Q?SCXPMo2Cz85l9tzWNeY6/j07R8iBPtCLkrQN/FsARz7hTYM/g6SZHchHzOPj?=
 =?us-ascii?Q?C701ICvIRZz3MH1WFmm+xJKrcjiDiNda3SJ+nOSB07NndG+HnED7j54I7vuA?=
 =?us-ascii?Q?4jP/SMY19QsJjjLA0nC2W/IMcoaGt5+NroynyGw8ueCVFkw+Y076u3muDhG4?=
 =?us-ascii?Q?iLFm7Uo9v4nkhrBHREpIu3+YZ0dXeB9tCGy9BfCrzHSr12FXAuYi/V+y/iZi?=
 =?us-ascii?Q?suf2i+5YID+xNpjUAVCYxnCPEHlB80rOyi71oeIRGYHPkRQPKFXdHd4UK08A?=
 =?us-ascii?Q?ABjep9faTZ8iGaN6xAH0LTblOymEx2Th1R7geIex0/kleR5CND8yVkN1s9vz?=
 =?us-ascii?Q?kJtFi60KFIP158burw/hdyH3jjMVVj3caUO02mbv?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7e185d-2c27-4877-76be-08dcc8c97d5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 07:58:09.6332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iSEHJyhF5eGUfZqYT0gxKHjDQIo3ApNjCO7g91VyaWJjURcMia/18eaYiB6l+MxIrB4M7WBwsc8WaR8msv+Wdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7173
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, August 27, 2024 11:52 PM
>=20
> For SMMUv3 the parent must be a S2 domain, which can be composed
> into a IOMMU_DOMAIN_NESTED.
>=20
> In future the S2 parent will also need a VMID linked to the VIOMMU and
> even to KVM.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with a nit:

> @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev,
> u32 flags,
>  			   const struct iommu_user_data *user_data)
>  {
>  	struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> -	const u32 PAGING_FLAGS =3D IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> +	const u32 PAGING_FLAGS =3D IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> +				 IOMMU_HWPT_ALLOC_NEST_PARENT;

lowercase for variable name.

