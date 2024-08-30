Return-Path: <kvm+bounces-25468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF0F965926
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F016D28439C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9C315CD4D;
	Fri, 30 Aug 2024 07:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LgbVeMu1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC16158D98;
	Fri, 30 Aug 2024 07:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725004533; cv=fail; b=gzsXTjhwInJrKZXgkcVcyZVoHC9BjnISJIptQ4nSRYdgAWkkWSGx+RXlDNahkZ0bsISTOy3Lz35TUQA0Vg2dJ8zQISNxCDaiT4yFKYjXatMIjpPK2k6nSlKY/8E7YOrQbpadCCpH61OG1ZZzpQu4XXZ0YUWbCUerr144NMAKGoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725004533; c=relaxed/simple;
	bh=cdCKa7WZEhwfPhjBGzwxJjy8K/hMBPeez53XvQmlX9c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YLm95FqkeKZW4C4kqM2jexrgnsB8XIJvo6SKKW4PVvmMWC7GcSavoQvvaJcVDHBoJxkVKJm1magiQJwLV+/QvISWakesb2iSbawlc30wKa3hoqBGeR3x3hs10vsxkmT4EqliJP89oIBPYHrdZsVNcweeXoRCG1WIL7KXobu7z0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LgbVeMu1; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725004531; x=1756540531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cdCKa7WZEhwfPhjBGzwxJjy8K/hMBPeez53XvQmlX9c=;
  b=LgbVeMu1RAcjSV5/e10TIm0bi+Cs3kChrG1ZhteSTSs9XMPc+YplXSwP
   ZLjEOY2duq5DPfkVdOWvv9tjHLGq8MSA4mm7a0xddA1H5HliEztZ4v/XX
   hXRYqS2YIm9jjMnHFE8qJgUktxq6wVA9UxRzlxKs9wKFFXxqe66vAjzTI
   XBEkknWw6A312/O8IXw9DXzdlRAtmA2zjI4sMzBXbpYZwC9FKia82Nle9
   4UnEUq102meiVPKffv3w5LFIOSTlN02ZwIVQ9bBw3O+AzBx5Xa9X9zZGW
   cydBYs/fhog/oHxWFi6mpm26mH1iFNXDrrgOl9WfCfMQOtN4bHcjeWdrH
   g==;
X-CSE-ConnectionGUID: 9EgxxKDcRA+VUkeBiPW2AA==
X-CSE-MsgGUID: Tta2zTG0RQqgBAWsyLwS2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23819999"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23819999"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:55:31 -0700
X-CSE-ConnectionGUID: lMgltOxsRN2bby5NnzZsyA==
X-CSE-MsgGUID: thqzzZ2XQS6e1GXZwmroPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63820869"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 00:55:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 00:55:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 00:55:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 00:55:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PV4+f2XVeiWdghQ+8li99FJBuuEniFZT9PZezCCdvLjwLjzqbE1BBecUrDOu8hkxbgn99kNJdNQnwZ2ekOTqJeKAcr7CVYLd63qOT9pAGhxcxttCixZuNzdjX7rVNEKhamUFPYr+2lQo2ocrHpeTc8LRcTfcpOyr2P/3cc483fmv6EWY/JoX/fxoDsjNkgS98nfLYiarIVtvRgmgZQEtUBnwwsWIwQxLez9c+v63IvwcraQf7OACEanHv9zYVa1iFVoYU/FCo5NW0whqryXKQsGmcG8UcZgAuWtq4Ndl+Htwgd9Z4PjLpBv9uKrzdYh6iDanb6deI+zOdYO8IrbrVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdCKa7WZEhwfPhjBGzwxJjy8K/hMBPeez53XvQmlX9c=;
 b=mLsBSuNHxVZR2XQYDFdWsUt0pG8B6RsZhH8zY8HCTbfC8QiJNIHaDvKZVFLeqqqRa1Ipd/zCOtl4lN1BlitKQ5OVwINLDNUqVjKnAFQ1hHt8a5hX0cAHq6JQv4h+kzojj84Uri8xHcEsXl6SFSCdFxulQEno7fxlHNfxHEOWn5hlKoIaPkBxP/AxfVBI3lkDtqbRhxrN9w+NgheikpBJlsR7F+4JfhycMBokR2agAof/t/RWSE69p4x9NAaBVpPiXa+A3auyFVt1Bfkyu6mI878+2EnkuM+vicT8FwpZn5ZRuyKjs9wmotjqQFV/GxPv79+wGKwMAGwAujMFjJ6FAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7173.namprd11.prod.outlook.com (2603:10b6:208:41b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.29; Fri, 30 Aug
 2024 07:55:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 07:55:22 +0000
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
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Thread-Topic: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Thread-Index: AQHa+JkUqvzDUOtwR0OZ7EvtFxZMhLI/cmxw
Date: Fri, 30 Aug 2024 07:55:22 +0000
Message-ID: <BN9PR11MB5276FE2E3A4F98987B7E95C28C972@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7173:EE_
x-ms-office365-filtering-correlation-id: f426948d-4132-4e71-a0bc-08dcc8c919a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?us-ascii?Q?qr59tlsJqr+M8R35ReLQRsaj38pXYwIu740ZNvz0AkR4LJKIpywjzhFHk9dR?=
 =?us-ascii?Q?3X17x0pAKp73CRCBL89JZVmFH3UZhDVxAHPc7SrfWJi3PW1eOx2Q8jaRZYaC?=
 =?us-ascii?Q?zbOfewpJEPVh4yFVx4gfU/+gKbbg5VeKmFXFa//90ootLt/XC+UvM2hLskob?=
 =?us-ascii?Q?RF5um6Ilt+u+OOtZQEOjvDtZdA9pP56urpu7wIZZ4gNFlCrvBja6jWqpvm3Q?=
 =?us-ascii?Q?7Rc+i7koVr1bDGuWFJMUIdnk8nPQGEBSLaEfFPRU+n+PKK/mRODIdpGKY0hG?=
 =?us-ascii?Q?sxi+SfPZwjHria5qV0T0vli9CNOxBExKPjxxrGzMB+piRoZ2uFhB3qrruhrW?=
 =?us-ascii?Q?PS2ohaN+lVvdWywsAPetCy1clZa0/NufLS5TO8t987I7KqyboTI3T6/4/+0r?=
 =?us-ascii?Q?upky+tRSQDxZXmSS7DE6IKvTTRhZxjdRbGutZUBZAvVLpWDmqu+CrcAgL8mf?=
 =?us-ascii?Q?jEYMFa1iAFYho8fNLbh5O66YNNklb+r0RuyL+ZpFTUQlJ1rEnbfsIBj1UhlF?=
 =?us-ascii?Q?hCO0LeP5Pte8wzVi+K0u491htprTqwtosEGi/y2NKRKNuEyUdkX8Yg850Xqo?=
 =?us-ascii?Q?691MunVJ4PYoZVkmdC9hwP4moZdSEuvZlPw3tQJWe6FMTRiQ3W1Hug/AyMal?=
 =?us-ascii?Q?VEiNoYJc/uo6xuCUZvcibCc9qBWF05dA1SvpXOOgmbJ9ndcS6go+F8oj6wL7?=
 =?us-ascii?Q?YVPbzWZqMFFVp0n4Xr86ENg1JBzT5i9OimgGQ9COx8OkA0fTwBILFrEOVajw?=
 =?us-ascii?Q?7nWs2m3d2BbINqhPIprjCPolBVkMMlK+wwNi9TSBNnL4G/PC6SsQqxVwLw+4?=
 =?us-ascii?Q?+DQ0qzX/xQhIdxlQ7suFq20KcR+y03WVe+pMp3u1n4teGgLhtRDB4AQFICAb?=
 =?us-ascii?Q?61pxLCkms24prwSl9Dg9qbMqviStAbu/FYHPhyWtgVcWNqXOuSG4ZrWOVEui?=
 =?us-ascii?Q?gzTQ+VfJOSusUOLHeVL1ApQ1ebsYbAieiHEOfq0fAhucGv6SepwkLYIATy+V?=
 =?us-ascii?Q?xiE/WqZK6xlRD5s+hCzG6evEX1nIxwdbDEB89+nhZdky52o4en3CJhw+YoGk?=
 =?us-ascii?Q?o9tp5lvB4hq1ONPlrdKIJGtZ6773hpuXLwfdXswQ/8i3g/m9rbdx/t7FTc2Q?=
 =?us-ascii?Q?ugA3uoyWnsoiVZl8djxz6/CBxkxS3v6qUNnmw1MaO+7rG+zMccTuukvyJzLF?=
 =?us-ascii?Q?feqgszIEdZpCOS/te8j1+HhnFx3hYNWwfX/BBe9Rrx7brOOib7Ab6BaCigXg?=
 =?us-ascii?Q?yKam7QdHTo5vbTYYLn0xkPPr2h09GOZC8m0UwhPk8l7ChdWLUH++iR/+Xoag?=
 =?us-ascii?Q?BI8fTVwiVD9xXIWzctTqtlmwfnv7fp3stiCgRMJd2RCtPQEvD8cYA0JPD47x?=
 =?us-ascii?Q?pEA7yuhcfVENlxaXNDOE/pUR2o89Lr5NcYl5Jbu7zd1jEIK0XtqEi//cfuY/?=
 =?us-ascii?Q?Wl4UmMahceE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4H4a/cUWoVt/vJjwprgBKiPe291ROuH80PTg3e4Nx/RIb2Zdb/0Ka0bSY77z?=
 =?us-ascii?Q?gnV/IXWZmIMsm0kjqlSOSB/AWthszuUh0DM1jifwVMz2Dq9s0au7kem0y0hJ?=
 =?us-ascii?Q?gnThmSZrRumThgd74P0juAvvShKUXmyR69l7LjP97Rj4vhDMiWjEPv+SNy3W?=
 =?us-ascii?Q?ksuqH+Zvsj137G8trjybX2QEC09xsA8y+koLBm+7sdnQ5/jFaevQ7upySmZl?=
 =?us-ascii?Q?+tth4ed/4Jx0DAlRDueHYkEaMzOdlW6lYm8x2TY6y52VAr4asjhWxfnhofHa?=
 =?us-ascii?Q?/Rjnn/EMCjxNtV4/Y5lFYw5KpT6Bkpmua1G0mIbsTEt8pJlMBfWEaB2aA3yI?=
 =?us-ascii?Q?mWwvCQJscY5dC+FcfsQV46i8WDkYyeMMy+hlm6udE48a/5Unr7KmtOjcnQio?=
 =?us-ascii?Q?6gjYUYHsy6tMlpLjWY/mWBPk2dXm2dr32ddHFQT0vqX+fsUcD8zvUmeZPfWe?=
 =?us-ascii?Q?sQ9ue3CYrwxhUVj3QTJ4KuUOMWzD0n+AIIXrna0erFq2dQILTxLGiI1OCIbD?=
 =?us-ascii?Q?EpLFMrRNCVvR//WKs8mYz48+2UvSbwqMgsCJ8QGKx+aogr3a4ixQ1q6ohrhb?=
 =?us-ascii?Q?018OudXCp6dWg4Loy50eUjXpPJr1mJPFqZ0uLafOXJT6DDRjVz9boHc/mNrO?=
 =?us-ascii?Q?sTo9Z5gExCkMwXmq9bbWvytbgvczpC8/UB2CecueUh08JpRlKxrGczW/F/AQ?=
 =?us-ascii?Q?YJP+geKjZX//+ugLqYLK2abk/lDwEyfD6MCIf4i73zqqCVDtKCExqBxgEgO5?=
 =?us-ascii?Q?YFZIlA7LNXui318z/1Iqt0y863ZVUFK3dV12X6CiZMo3phfKHIgu6Qo3+SIW?=
 =?us-ascii?Q?1ywDCkDnL98r3AQJGeM7td/KXTychF5gRrbbe/6hDhV65EYWAeKnh2+dgWUP?=
 =?us-ascii?Q?ORNSeETh/3GY4EqoW8Y68HG9kHd/8lgA2Iq6QOTTdPPDdkPPUsAkHh9TlC/r?=
 =?us-ascii?Q?5mMpZhCsGHXHPp4Ut88q2pDGxpscM4ZvhBkgS6gIK/8RWcso0kI7yrfuepYM?=
 =?us-ascii?Q?DBrnMMaq7ytUNo8i7qd0xVHLMvDq2JHBXh0CG4zijP75dfTpBtEGD2UMhwi0?=
 =?us-ascii?Q?6EowDziK8PuJow4OPgsGtlBEPxlIMRIANL3HMbMlcZcFVRgQcrKWGk4MsKiL?=
 =?us-ascii?Q?rQEcIMkTb51A5KPAPQaIddM7+p2kFeyKUlpSunMf8KU5Ixcbx9rP0FN6iI47?=
 =?us-ascii?Q?ssgj9SChaNsI+EDFR/H/6hRd5YzwEi58/rgY17SXQi+1bkZ5pBWip5DDi76g?=
 =?us-ascii?Q?074+HlxgN4d4MUEt+lLaqBboFpnLEZcLcS+TMG/Hzxiq6mYP9sAaRUFFGPhx?=
 =?us-ascii?Q?BQpSHF06yx9kgD5NLSGmrsPv3YB6qVmx/pre5djvjSfTfZhsFcZEbIkYWLH+?=
 =?us-ascii?Q?6ObDqTx9fuoiMNeoUIEaV/W7SwaPu8eg1GmwQzCFpPhRxeuJ9dBqGsjgsOuP?=
 =?us-ascii?Q?DZJPTAmYkLiFYN/dc99lV2eZ9TPG5jI4+S5bkwMj6EOR5p2zogoMCa3xbjAE?=
 =?us-ascii?Q?wB6tnte6Ej9m1vdArSpKxVg7HshiUP+305xtRshufft3xS5rgT6fGWnbzWxv?=
 =?us-ascii?Q?X0sLYyjCLHGOQ647tTo4bBp+9Np2dZL7OCXKT7of?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f426948d-4132-4e71-a0bc-08dcc8c919a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 07:55:22.3635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K/S0OXZLjgtc0qygdc8j5KngabXU0Nx1ndw0cM04TxgmIwmF2h/0oWe0Lkt4pBeh/RGBJdnhFRS+7MiOq8mxDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7173
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, August 27, 2024 11:52 PM
>=20
> From: Nicolin Chen <nicolinc@nvidia.com>
>=20
> For virtualization cases the IDR/IIDR/AIDR values of the actual SMMU
> instance need to be available to the VMM so it can construct an
> appropriate vSMMUv3 that reflects the correct HW capabilities.
>=20
> For userspace page tables these values are required to constrain the vali=
d
> values within the CD table and the IOPTEs.
>=20
> The kernel does not sanitize these values. If building a VMM then
> userspace is required to only forward bits into a VM that it knows it can
> implement. Some bits will also require a VMM to detect if appropriate
> kernel support is available such as for ATS and BTM.
>=20
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

