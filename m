Return-Path: <kvm+bounces-19246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD6D69026E1
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 18:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48FEC1F21F76
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169DF14387E;
	Mon, 10 Jun 2024 16:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PbRwzQbF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091E914535A;
	Mon, 10 Jun 2024 16:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037628; cv=fail; b=PaIAAekRH1Pr7Gtfm2REFG499RHjaWF0tV5bfY0QNOyRv+OQkzXwZsNNJygx++vhKIA+sq7ogOwrb+AX4KsYx+fxypWetANTMxQD1hSdkUkwfJPYEJo5Vxcnu2HCEJHT4rrginBnG0wlpXlDsxA1GKNvEK6NWQut8q+NZYdLJsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037628; c=relaxed/simple;
	bh=Am2pBSyPjaXDGSmicdKCq79bYq9jrihS0HpPbnrUp6k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=idELHHJRgaw4Bc2+z+9pbDcnGcWV8Jhx9PE2M8Jn8JDrYDXSxXgFQtsYtFqjecBe7bhvwBJR8ohebszWMcKQ57y2e43gBfSbyyGd7fWqBJ9HkSLUrXMgn2tjb5LduWk91otkLuL2MWNyzWJmI9bvVoS8tXeWffMf3z8UTaX/Y84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PbRwzQbF; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718037626; x=1749573626;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Am2pBSyPjaXDGSmicdKCq79bYq9jrihS0HpPbnrUp6k=;
  b=PbRwzQbFRbpoxdwjCp38edbTdGjxF27TGBVrd+McygEk9Nkvrc+0dpST
   jm81dwNY+GW++TqpcjbLc2/nzqz7sYv10rJAEgRHzlYonNORMg73bqU76
   Plpshr87sickKe5wKHNSexJeLk3kqK/VVrA04H7MpB7/QsFXuEDFKtoG7
   WJgPsDqOCiu/7yKdxsSNEoxpkDdwzwM8ikNRfmMr8AuPB/qGnUPqjGgVG
   gkm5spWJH8IfKfdS5HK24rhh/hSx2yGZop0AiyqktRmt5G5hVvBU0KYXs
   P57KicINewyHATJyhkdwZgtkejX3ULUk+2yNGo7j3Q2i68g/ODn0dsiFX
   g==;
X-CSE-ConnectionGUID: 7TAtDIVeSRi5eiCcR8aeWA==
X-CSE-MsgGUID: fvhJQu+UTuqGuaIdAo5DVQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="18541115"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="18541115"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 09:40:25 -0700
X-CSE-ConnectionGUID: 5zA8p7zYSZOnN0DFD/HkSQ==
X-CSE-MsgGUID: pS6xzuGORx+py/aj32bf0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="70285675"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 09:40:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 09:40:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 09:40:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 09:40:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 09:40:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKqzr5iF+UCFAZhurR6Edya9y6YvsYtcSCODkEW2B3+D0ekRmqtzW9GX7RhNBBDi/0jKkTyXcfftOaYxKTCLfhW3fYCtKqq5unwe1V27JiIiCeSmUIVTYblZOlEc8oB/Y7YSM4LoX/2cU/YcnX+b77x1m12ni62ENaKqbS852hDmQ4QMycBbG/Wf8H03uZ49BI4vJrkTdZLvep4gXPMUUnvkdNfs5YWhJAviy8skbiiq3LtniDhyJIDPtlScAmzJLsiF4ruhAy86PoB3vPde+LT6WKdd6N2WwQE4kGi2aYGXAABVO3amgRHTn6xDC8AOc73z8bB/P9YhETqbwka7Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Am2pBSyPjaXDGSmicdKCq79bYq9jrihS0HpPbnrUp6k=;
 b=FYJ7xFbv8UptEEnvesImUXXskOUHlw1wWR3I+mWPlyCeh8U0HRTfTPCH+DbUdtaSD3fBd5VC6YCuJeQvNE1NaBAYp+Z/liw+6Q6S7u7yOLUQUlIjSzlvrc+kDnGoxbj+jCfyobfhYEGS7VmLpa30y6Vs2YFBGdMMhldG/VfpCPtxn5uGxFn8iNf9H++1EM/ukMtaEOvCCkeBp7RSmyOPU4NQVx05Inu5+HkCd+ANOgpfbjB890zcOZYY2X5CM7e8VDPZbFII17Trirgr7mpTIkxeIgzaR4ERs9WwEoDkXRcNjUeEtOLo072jnqW4yoFH8IQat82nv1R+mlptbeRjGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB7004.namprd11.prod.outlook.com (2603:10b6:510:20b::6)
 by DM4PR11MB8159.namprd11.prod.outlook.com (2603:10b6:8:17d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 16:40:19 +0000
Received: from PH7PR11MB7004.namprd11.prod.outlook.com
 ([fe80::8c26:2819:d0f9:1984]) by PH7PR11MB7004.namprd11.prod.outlook.com
 ([fe80::8c26:2819:d0f9:1984%3]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 16:40:19 +0000
From: "Zeng, Oak" <oak.zeng@intel.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>, "Robin
 Murphy" <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, "Chaitanya
 Kulkarni" <chaitanyak@nvidia.com>, "Brost, Matthew"
	<matthew.brost@intel.com>, "Hellstrom, Thomas" <thomas.hellstrom@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>, Keith Busch
	<kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas
	<yishaih@nvidia.com>, Shameer Kolothum
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
	<jack@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>, "Bommu, Krishnaiah"
	<krishnaiah.bommu@intel.com>, "Ghimiray, Himal Prasad"
	<himal.prasad.ghimiray@intel.com>
Subject: RE: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Thread-Topic: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
 steps
Thread-Index: AQHanOEtbi0VHTnLn0mNwgftYB7xRbGEmFqggAEftYCAO5ykoIAAFS8AgAAFauA=
Date: Mon, 10 Jun 2024 16:40:19 +0000
Message-ID: <PH7PR11MB7004A071F27B4CF45740B87E92C62@PH7PR11MB7004.namprd11.prod.outlook.com>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
 <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610161826.GA4966@unreal>
In-Reply-To: <20240610161826.GA4966@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7004:EE_|DM4PR11MB8159:EE_
x-ms-office365-filtering-correlation-id: 38376e52-048e-47bb-c16b-08dc896c0417
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?JnugU8J8c+ZudOM/EJv5eK33lPhUMdiL9yghwBRSXNaa59XBjFwBEtVVh9?=
 =?iso-8859-1?Q?zgskyr79TxjIQH7eBCuJ/881eNZ569xGuWixOxcUjWCJpQl/HHvAxs9Bid?=
 =?iso-8859-1?Q?Zf2/orsXfZZk/TDqu4TpDjgEpneNgpdR0ZAQhEhuEJk31msVfHg8VHEt3W?=
 =?iso-8859-1?Q?Ifirt/koDEyhq4iVKfWYktDeF6+rAqex4y/Nemj2Q0zN6NkeaoVNH9GRYM?=
 =?iso-8859-1?Q?j+PNRRTZsHRYyZm3//026WP1myvrQZ7i80m6ucpG92aDaPb92AJSvNwozk?=
 =?iso-8859-1?Q?/lkK9QI1zaTKRk0bcBOKO24iEgeScCfvWgsYh4KtbAq43cQhvhLna1yFio?=
 =?iso-8859-1?Q?e+KDAwAvCHE7tVskeLNjR6oki1kKpXn/MadZiWLu/wmSOR5UkMgJqcMewS?=
 =?iso-8859-1?Q?ehW60Q3aMjLEjKLQ2PKjWyoL/OunPlfQdt6BRb3H9frGkdSXMeb9PuCbwV?=
 =?iso-8859-1?Q?QzpdDUwtnKrg+XAA24ZLVjiuqhQmBJlGtgkXH9SFTlSV2WJ9Jj1RP7iida?=
 =?iso-8859-1?Q?SWSqYlckeUk9p0V7IZAvEyIiwIuM6v8lrBcR3eWFX9huzQEd7GCbiXcsU1?=
 =?iso-8859-1?Q?lhgjPrILL7J3ZCrUNj7MxZAcyKjKDD0DowPAkp1XoToUGxqjZeYt2D1WN8?=
 =?iso-8859-1?Q?ZoYYXTml9eZ8m3U1JhB6SvAc8Wtxc5rq8LBo/ssrLHu3zLa9x/E4D89FU9?=
 =?iso-8859-1?Q?Z1EMUm7pWCSgR14kuJltxVr1Ykly7RnqOMTCjUNzT8BK7ag3DpqjveUyuH?=
 =?iso-8859-1?Q?y8phS5oWEzGVqr54pr6k4vAZ7y84bP5pFo8pMwy9Sl0q9XHGW1j93AC1r5?=
 =?iso-8859-1?Q?IXtrCWhMizXNeR3VjLB8eka14EJVFqveIdyNtSdf065cHdOLt9G7CN7uxZ?=
 =?iso-8859-1?Q?RNfVcNy8kp4TZiIzZJ4sOi45AvSlr5iJ3CT3o34R4fzmhNNsutBbmZBZsO?=
 =?iso-8859-1?Q?D9A5EdLe6TuBIQcUsyPG3wTWYKFTPwwcCnIKwGdcEHpQzBIuUxgYJ6nlJ8?=
 =?iso-8859-1?Q?XKzFcfsccZOyBGqjM4dY0aw0ktCpX15C+8aiLgOyM1/UBYm2qFFSz2BReQ?=
 =?iso-8859-1?Q?PWxeBdvZQFTUfGfq6UTa3DN1nSORJY+A02rqwx6/buL07YnsON60FQRXYM?=
 =?iso-8859-1?Q?QZTHVxQZqB3bSHBgFvaW2aWDgz4QkxzhPauWb0pxatnWmDc2H4LJ/Et6hK?=
 =?iso-8859-1?Q?fQXUlBamyGUL1hu/jGgAFmt9pQFxFQNgy4qe+yA0j/xjnZ2/QuZkA6YOAH?=
 =?iso-8859-1?Q?3Q+p3z/OmPFXUYDv8KhYUiDbyYNNV/r0hvPfAvMC9lIK7BCn0Or8lGvKdp?=
 =?iso-8859-1?Q?n3Z33qfaay4NheRSlfc1Ejt0VtWKeZbrdxMXV0trt607mg7lZc7q7/fWzb?=
 =?iso-8859-1?Q?JMY932MUtb?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7004.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?G/zvuWMRqrPRdrGretmKlmNaSdayUA4/COSS0ONc56FbVGs2tRskrM3nHd?=
 =?iso-8859-1?Q?fxParQLHb72XuMbbaw/nduQl5PzrHq52I4Jo37i3SPhBQ0re0r9M72PC6y?=
 =?iso-8859-1?Q?58rot3dzsjHaHLLhc0B4oOFjVSnIbzazG33fnwLQCWbLQoCI3mBKKpJTGb?=
 =?iso-8859-1?Q?co1hZ6jBEvgW7SGOtCH9Z8O7t4NtPpy6Fc3lu8zE99D0LRTM9LPUYrvGXE?=
 =?iso-8859-1?Q?FmyvR/rlZHIotu2i0H6QLg4xHPV+fKqs1N/6Ks2ioMnqoySfs5cUFKfceJ?=
 =?iso-8859-1?Q?qW4UcT4yu1eiFaZGnY/k4AWoPkHvh/R+biGyZYksumuRpQ+PEvnqFzpZxF?=
 =?iso-8859-1?Q?MhRTCS3bAkJlJudaN4SKHv8/M8X+mFHdcyCVT1gEgTz+Kn7SQhUI46J661?=
 =?iso-8859-1?Q?u5ethACWP/m6F0a4RTuLVVGyBLzN3GxIllSiTXQWNYcyr8O99w+T+EwK0O?=
 =?iso-8859-1?Q?iFmETe8l6C2eo4v/q2xxzBqhvpcuCgPuICG7SjJthur/VaBO2jKllNhBr0?=
 =?iso-8859-1?Q?BlZUiD7n/GC12T/DPWt+Zf1mWD5xdUMmdQQzKELOtOLeYBRSo7wDksqyJW?=
 =?iso-8859-1?Q?kVP2tlWPLOfYo9haP6KvBZNGsGhwUbuKcP58/VRfWwJjRZYJdke/A7MDB0?=
 =?iso-8859-1?Q?VNFIHEDPAc2pMntKPFdX+q8SNLW/9rdZ1DE9u+XgIFdqLzoCzYQy7oQQta?=
 =?iso-8859-1?Q?B8k3uHTWSD4Qye0A+tL30jo0JBHSuyj/Mw1RCgHA7XQTJjXfIj52oL3PeD?=
 =?iso-8859-1?Q?+PYj8THw/FdT2ZyfYCvebQd/kGm9aL3TkVX3dQ8J2Eclpto6/tw0o4vcPG?=
 =?iso-8859-1?Q?XuQU8Kf81++E7cz2gIOZUEIAO1GsNHQR7JD36KXh8AlEO/9YvypkEBufIq?=
 =?iso-8859-1?Q?Px0XP/JBgD8+si+L0EwnLjiOgrUwnziLRenrdrXrt1MTYQmo3fg1D/QoYE?=
 =?iso-8859-1?Q?V3qcD21XMHVCTtQhkyv++SeDLLsHn+76QDYSQbJqjNeBOExSQATp6cVYeg?=
 =?iso-8859-1?Q?OL7nNx8Wddd5APV2VNXeSd64UFZvbovU0DcSmXzg/gyg9TmnPuuxG8Vb3/?=
 =?iso-8859-1?Q?VNiGtNZkcNSvbt0bp8XdgTY4NNozAmsq22NDJO867258HBwi3Y8o5ueHBo?=
 =?iso-8859-1?Q?OHz5SvNdcfgQgApnjP3UvdWW6rwXDsk00XjSSU/L++0srcB/YhmRijjubX?=
 =?iso-8859-1?Q?cgBErOhjIuBNJj0/36Ygfc9oc/UOl+1tnCRn+qOnp3bPYfiWYM+wqsnsux?=
 =?iso-8859-1?Q?fCcEIcWEh6OTOfYXES1uDSffQVEcyQSyZ1ciJr4c/Fs3GEMn0VRqHGLSKo?=
 =?iso-8859-1?Q?e+7CatOOp585gWDVgsVtJCo75gQGbHhtXFgn8zdSVmLDxYHy5VCNEnr/c4?=
 =?iso-8859-1?Q?TKIMVsPDD0MbtJ13KxzxryEtGiTEpS9zydOd9B0h+BSzppqqhoQN608pSr?=
 =?iso-8859-1?Q?m1Vb+u2ti4H+jYUXVDDqQ0yqdTBLfszH/2YpOBp8WpFy5UDGhzjja3fpla?=
 =?iso-8859-1?Q?k98KelzHpQ5Oqoadrt7PaJ0o3mErzDBhZm7OQi2gZABlAxgjakrFgfa3bx?=
 =?iso-8859-1?Q?x1wMjDEibiDRQzU1pgTpMMqowiZAcqEE/d+SNEz3Kg14iXfKn8wXPnGPrz?=
 =?iso-8859-1?Q?WDg4+9iXpBL/A=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7004.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38376e52-048e-47bb-c16b-08dc896c0417
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 16:40:19.7359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l7gsPJnsNHM6Wuxcr27UOd+Puqge5USKlT6zG/AwWIWGJBBNUFhPpn1PZiNbMmXleMbgpnXy4KDBhoQDR24p+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8159
X-OriginatorOrg: intel.com

Thanks Leon and Yanjun for the reply!

Based on the reply, we will continue use the current version for test (as i=
t is tested for vfio and rdma). We will switch to v1 once it is fully teste=
d/reviewed.

Thanks,
Oak

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, June 10, 2024 12:18 PM
> To: Zeng, Oak <oak.zeng@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>; Christoph Hellwig <hch@lst.de>; Robin
> Murphy <robin.murphy@arm.com>; Marek Szyprowski
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
> <dan.j.williams@intel.com>; jack@suse.com; Zhu Yanjun
> <zyjzyj2000@gmail.com>; Bommu, Krishnaiah
> <krishnaiah.bommu@intel.com>; Ghimiray, Himal Prasad
> <himal.prasad.ghimiray@intel.com>
> Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> two steps
>=20
> On Mon, Jun 10, 2024 at 03:12:25PM +0000, Zeng, Oak wrote:
> > Hi Jason, Leon,
> >
> > I come back to this thread to ask a question. Per the discussion in ano=
ther
> thread, I have integrated the new dma-mapping API (the first 6 patches of
> this series) to DRM subsystem. The new API seems fit pretty good to our
> purpose, better than scatter-gather dma-mapping. So we want to continue
> work with you to adopt this new API.
>=20
> Sounds great, thanks for the feedback.
>=20
> >
> > Did you test the new API in RDMA subsystem?
>=20
> This version was tested in our regression tests, but there is a chance
> that you are hitting flows that were not relevant for RDMA case.
>=20
> > Or this RFC series was just some untested codes sending out to get
> people's design feedback?
>=20
> RFC was fully tested in VFIO and RDMA paths, but not NVMe patch.
>=20
> > Do you have refined version for us to try? I ask because we are seeing
> some issues but not sure whether it is caused by the new API. We are
> debugging but it would be good to also ask at the same time.
>=20
> Yes, as an outcome of the feedback in this thread, I implemented a new
> version. Unfortunately, there are some personal matters that are preventi=
ng
> from me to send it right away.
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-
> rdma.git/log/?h=3Ddma-split-v1
>=20
> There are some differences in the API, but the main idea is the same.
> This version is not fully tested yet.
>=20
> Thanks
>=20
> >
> > Cc Himal/Krishna who are also working/testing the new API.
> >
> > Thanks,
> > Oak
> >
> > > -----Original Message-----
> > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > Sent: Friday, May 3, 2024 12:43 PM
> > > To: Zeng, Oak <oak.zeng@intel.com>
> > > Cc: leon@kernel.org; Christoph Hellwig <hch@lst.de>; Robin Murphy
> > > <robin.murphy@arm.com>; Marek Szyprowski
> > > <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> > > Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
> > > Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
> > > <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>;
> Jens
> > > Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
> > > Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
> > > Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian,
> Kevin
> > > <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> > > J=E9r=F4me Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> > > foundation.org>; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org;
> > > linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> > > iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> > > kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> > > <bvanassche@acm.org>; Damien Le Moal
> > > <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> > > <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> > > <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
> > > <dan.j.williams@intel.com>; jack@suse.com; Leon Romanovsky
> > > <leonro@nvidia.com>; Zhu Yanjun <zyjzyj2000@gmail.com>
> > > Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> > > two steps
> > >
> > > On Thu, May 02, 2024 at 11:32:55PM +0000, Zeng, Oak wrote:
> > >
> > > > > Instead of teaching DMA to know these specific datatypes, let's
> separate
> > > > > existing DMA mapping routine to two steps and give an option to
> > > advanced
> > > > > callers (subsystems) perform all calculations internally in advan=
ce and
> > > > > map pages later when it is needed.
> > > >
> > > > I looked into how this scheme can be applied to DRM subsystem and
> GPU
> > > drivers.
> > > >
> > > > I figured RDMA can apply this scheme because RDMA can calculate the
> > > > iova size. Per my limited knowledge of rdma, user can register a
> > > > memory region (the reg_user_mr vfunc) and memory region's sized is
> > > > used to pre-allocate iova space. And in the RDMA use case, it seems
> > > > the user registered region can be very big, e.g., 512MiB or even Gi=
B
> > >
> > > In RDMA the iova would be linked to the SVA granual we discussed
> > > previously.
> > >
> > > > In GPU driver, we have a few use cases where we need dma-mapping.
> Just
> > > name two:
> > > >
> > > > 1) userptr: it is user malloc'ed/mmap'ed memory and registers to gp=
u
> > > > (in Intel's driver it is through a vm_bind api, similar to mmap). A
> > > > userptr can be of any random size, depending on user malloc
> > > > size. Today we use dma-map-sg for this use case. The down side of
> > > > our approach is, during userptr invalidation, even if user only
> > > > munmap partially of an userptr, we invalidate the whole userptr fro=
m
> > > > gpu page table, because there is no way for us to partially
> > > > dma-unmap the whole sg list. I think we can try your new API in thi=
s
> > > > case. The main benefit of the new approach is the partial munmap
> > > > case.
> > >
> > > Yes, this is one of the main things it will improve.
> > >
> > > > We will have to pre-allocate iova for each userptr, and we have man=
y
> > > > userptrs of random size... So we might be not as efficient as RDMA
> > > > case where I assume user register a few big memory regions.
> > >
> > > You are already doing this. dma_map_sg() does exactly the same IOVA
> > > allocation under the covers.
> > >
> > > > 2) system allocator: it is malloc'ed/mmap'ed memory be used for GPU
> > > > program directly, without any other extra driver API call. We call
> > > > this use case system allocator.
> > >
> > > > For system allocator, driver have no knowledge of which virtual
> > > > address range is valid in advance. So when GPU access a
> > > > malloc'ed/mmap'ed address, we have a page fault. We then look up a
> > > > CPU vma which contains the fault address. I guess we can use the CP=
U
> > > > vma size to allocate the iova space of the same size?
> > >
> > > No. You'd follow what we discussed in the other thread.
> > >
> > > If you do a full SVA then you'd split your MM space into granuals and
> > > when a fault hits a granual you'd allocate the IOVA for the whole
> > > granual. RDMA ODP is using a 512M granual currently.
> > >
> > > If you are doing sub ranges then you'd probably allocate the IOVA for
> > > the well defined sub range (assuming the typical use case isn't huge)
> > >
> > > > But there will be a true difficulty to apply your scheme to this us=
e
> > > > case. It is related to the STICKY flag. As I understand it, the
> > > > sticky flag is designed for driver to mark "this page/pfn has been
> > > > populated, no need to re-populate again", roughly...Unlike userptr
> > > > and RDMA use cases where the backing store of a buffer is always in
> > > > system memory, in the system allocator use case, the backing store
> > > > can be changing b/t system memory and GPU's device private
> > > > memory. Even worse, we have to assume the data migration b/t
> system
> > > > and GPU is dynamic. When data is migrated to GPU, we don't need
> > > > dma-map. And when migration happens to a pfn with STICKY flag, we
> > > > still need to repopulate this pfn. So you can see, it is not easy t=
o
> > > > apply this scheme to this use case. At least I can't see an obvious
> > > > way.
> > >
> > > You are already doing this today, you are keeping the sg list around
> > > until you unmap it.
> > >
> > > Instead of keeping the sg list you'd keep a much smaller datastructur=
e
> > > per-granual. The sticky bit is simply a convient way for ODP to manag=
e
> > > the smaller data structure, you don't have to use it.
> > >
> > > But you do need to keep track of what pages in the granual have been
> > > DMA mapped - sg list was doing this before. This could be a simple
> > > bitmap array matching the granual size.
> > >
> > > Looking (far) forward we may be able to have a "replace" API that
> > > allows installing a new page unconditionally regardless of what is
> > > already there.
> > >
> > > Jason

