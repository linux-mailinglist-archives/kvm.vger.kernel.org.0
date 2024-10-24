Return-Path: <kvm+bounces-29597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C49E49ADE22
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDB771C25F33
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5091AAE02;
	Thu, 24 Oct 2024 07:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QNgnR6nH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97297171E6E;
	Thu, 24 Oct 2024 07:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756089; cv=fail; b=sXsJiuXCoetZF5N2j1deRf0ZpMZm8IEvYZcDPA6jQsiAE4/pk56rmXqR6o0XSGIThPDgrCal8S+CcSx4uq7Sp9oEaoKXYCED9Wlb+NZcgT21I8BKNJiBhgnTWQYB5VDAsTIL8076r+jjFWFX9IiOH8Rnc4k+h0eX+HzcGRhVQNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756089; c=relaxed/simple;
	bh=lLKpo7LDgtwjQxB6mOkwQr6eG2lBGv+aqf/C3CCEJ0g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S0C7PNZYzxE1oUdchfeoTxJXdtDX5IAyUETRnDI+INz6NWuyZr5R9mpKAgbCIOpsHfFBzVbjsgAuA0z+LYDum6y3Tbn2NXe9cIrowRVNMjrhD0eGr6rGWGEECmntr6L0fhYKhEw2mcapPhZmIXLz39E2MhQ6wCRkIJrp2HT3IFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QNgnR6nH; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729756088; x=1761292088;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lLKpo7LDgtwjQxB6mOkwQr6eG2lBGv+aqf/C3CCEJ0g=;
  b=QNgnR6nHixbSUL7rVhv5gjCnCnhsUienUMoWDS4S9FkFB4ikwKJmM59/
   VHZ5T8UJhMXxcoX58OwattNzWQaTG6utQa8zZZwGyV8lv0e9l3Vi0GKJQ
   tAPgWJ9GcljNHdnwQvhxb34mL7G8dxfeSxh0kHwxOtbc/AUf7cfA91jbN
   pxyWRPhAi/efs8LxTaRMX7OF4JThwj/mh7i2MYxaIkLxr6gGAjjWUczDn
   EG3sj6xOQzhgqXAVFtS+xmi3VJID0pPdvAu10UGgQBPMyDQiB2qfj4SFT
   juVJgdS4KImQa0vXiOQJlpOQKXqrqc2B7X1SeVltQztWDDyF1oFriCfOT
   Q==;
X-CSE-ConnectionGUID: DCXpdF6ZSjq3feImxxtMUw==
X-CSE-MsgGUID: M718dp32SQimRc4CcrkneQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11234"; a="33281485"
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="33281485"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:48:02 -0700
X-CSE-ConnectionGUID: OC+O/YNoSmy6wAODD0N3EA==
X-CSE-MsgGUID: BNUw/MrIROuTX+fHY2JCXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="85307279"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 00:48:01 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 00:48:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 00:48:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 00:48:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HyzSqvDs3XRi4HTmXo4dl6oq4tTO2QGFMjPQM7e6opJNvS5beLberFK260tMBTu0pixAwqx/xJgn7reQ2wh2mxXXl/o98PJsNVn3QBMjc629rntQdtGBM8f7+m6ImSijPmKi4ruw97UgGjpudQLrj+mklLdRFGxv2Coooso8aqaHsI/YnFl7lQxIwAqoqmCJLBhgVsmrJWnqDY24A2MI+IXlI5x8qh/J8Tl6gwRsjSZv1+aXmEvTC/qOQdANtXYhwFhZl3nDp6ZK9cLiY/QXgknvh8rPFhB64wdqn0Ah0NzWlXwneD7ozjXN7d++fmBJOhKJGvqjsWd29gD7lVjpiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLKpo7LDgtwjQxB6mOkwQr6eG2lBGv+aqf/C3CCEJ0g=;
 b=UXERaEmyXCfjbAgxLAfQfQAdqPoVNmgyjBHS7kOtgs4ICWh26sBKLgux+gR7EpE9vmAkve13sxSbuR7Jp8rF17OC5G2uDE4tJqQc8NhOV+7Vl0WIDFCoqiA6q1lNUq0y6T45jBqkTIoXjCumVBskY+9A+r8cuEf4p4+4vOkZ6OFQy2cfgrZLrxDyxGGAzUH5rzIPv68Ek+XTnVFhQfPvAzzE70Q7YMX2oK2lzD6RTqNt2fO99PP4PJAnTFtylSLNT9C12bISzGau34XCEt9QvJpE2ITdA00E2nGyrox9esH/qunqsGgpxKq4lQ5T77QyAxWpX/J0Mw9aPGiEUYt6oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8056.namprd11.prod.outlook.com (2603:10b6:a03:533::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Thu, 24 Oct
 2024 07:47:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8093.018; Thu, 24 Oct 2024
 07:47:57 +0000
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
Subject: RE: [PATCH v3 7/9] iommu/arm-smmu-v3: Expose the arm_smmu_attach
 interface
Thread-Topic: [PATCH v3 7/9] iommu/arm-smmu-v3: Expose the arm_smmu_attach
 interface
Thread-Index: AQHbGmef9JTaZAamMkmt3t9YNIve3bKVnRxQ
Date: Thu, 24 Oct 2024 07:47:56 +0000
Message-ID: <BN9PR11MB527692C17F406FCA9D7F42D68C4E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <7-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <7-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8056:EE_
x-ms-office365-filtering-correlation-id: 5d7eeea6-cf3c-47d1-d739-08dcf4002cbc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?NEabOSJxe3c06V4OYaBuofwFfJSwHKqfKGPUYvL7IDiHvmBRww+/T/meB/Ae?=
 =?us-ascii?Q?0Pvw4ABJaoVzEUNrzhsn+1NKkHwX3TiCz9i/ZKoGmCUFcPme/4wEOcvHIrLo?=
 =?us-ascii?Q?jjM/FKzOiQ0++8N5/sx1KvOaYv9V69sIL7KNbvB3sTTstlroSWBvs1E4K4GB?=
 =?us-ascii?Q?VbwPImkM8TOOXzSHPn7fnos8s3lbVtDJmviiZAJvXUs3tGtQqJDuHwvaSR+G?=
 =?us-ascii?Q?dRP4mtb8kJo7Wa23JgzEVtE+QYyJhTeGmq9BgCw4hCnNhpZUHIzNuy0+81kb?=
 =?us-ascii?Q?pyzbDdLrZr3+Rc1tSaw0X+1gyu5oOIbFgV8aGljTFvvnQmLNCM3VPWkkp3Wf?=
 =?us-ascii?Q?U77EPzMOk837FkT2D/WH1YHwVm2IzuiB/uEVpWLL9DdDfrP/8bLlFEpOjfxj?=
 =?us-ascii?Q?AP8KjxIRuOQSwtGkKFJPyduQQLjH8vYDK7zYIHh+/pOr08ScPkbbYTGYAeQc?=
 =?us-ascii?Q?aMlYVyRbBYkOSOQTMcc9kAm8KhKG9t11sK3pbWx2A+fRzILb0fX9kZtOtFR4?=
 =?us-ascii?Q?9WYl+ksqP69Hynjpq47CRYcNQIQoK273rudT+JlRQ8j+ItsXYLFGdpRK58uc?=
 =?us-ascii?Q?Z02Nr4Ai4/hDIxG/JCWSNroTN3lkozyIJq+ywNm/9jxNfMui9dDrDOKecJZe?=
 =?us-ascii?Q?ynGlqOk8GDT34Yc4ii58Z+2daaU73NOCdENa0JETlAkyoNB7xD/8DQGmBqGt?=
 =?us-ascii?Q?o4T4uIEv87OaldbEaYh8WRCfevnhnpx+xYmvb7pJL9T/eg9jyu1PDv7Z2krW?=
 =?us-ascii?Q?qPtO558hIB7VFlw5ly/HFZwzOMVlZXXH+WnJLmvRk3LeOEdAP0ocljtjHDhK?=
 =?us-ascii?Q?7PRrSJ9Kcasja2vCS9v48vmVq5QAEfzS76D724CVOnMmc2WZ04/oeK4weBCs?=
 =?us-ascii?Q?g+yBL+8SbsHmfmBiIKciv4uBjvc2n2+0pHwZEYUVWAZ+AgaFxrrB+vHfpiN/?=
 =?us-ascii?Q?tUzgJiz4khvIgVD8A21wz5fFmG3SR4ylA7sXxBRFvypuxc9z06sIKa/Ssjby?=
 =?us-ascii?Q?PhU5GtXbuLBjTmyrCwyBp95BP2WHgeJtgMGrrUBu/EZM/eZX9BWJwZglPIpn?=
 =?us-ascii?Q?KdPJa6kmhIArdQ1PDfyIV7QYqCu9M3dbFA8vKHy5S2qd5bIlmRQTWkqydzSQ?=
 =?us-ascii?Q?Ox3YYfFcecSuCdrMLEw9UNFebV/SgoURs206GZ39nY07eN7y+BhoZktoU3JJ?=
 =?us-ascii?Q?GdjnwmVSEbqkT11DbGlTglbh/11pt094BtWznj1R+Hqit85pSbW/uMdNVVRu?=
 =?us-ascii?Q?5mRC33C5mxn4pKCmcEr6per5nainxgK5IdJaFyHJ75Vl+10+7ihhNvspa6nX?=
 =?us-ascii?Q?cFDOdzJmHse5eFnjskOfe5wEG88p3ucveDrSquscZ+mJHzS+CRK9oEd3i2BX?=
 =?us-ascii?Q?epvGocLgQs16ws4D4dSnqUJxvpMN?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B5pMNt3X7orTxma8Yw6I24vrnhaQerTXycOhTaF8Uy312lfLFvvh2pCU/Y9C?=
 =?us-ascii?Q?e39xqlPJARwthgVXPigAR/dPGjSsrS0CEH+iaTXUZ6E7pyjL11/1/1k4rG6B?=
 =?us-ascii?Q?oe9MUruBH6bBcooD5E4LlXSs9RB2DBdqgedhWwMwWAgxjLG/4J7ntMkqDlTU?=
 =?us-ascii?Q?mfmI4RW9QGR6cAALbSJIj+4TJ9yCdbJc8fbhFaGY0khjWt+7QVF/v+FUm+OK?=
 =?us-ascii?Q?r/TU5/w0ay5vBNjeE/iOhh9bx0QQ6u/DV0cywDmCh58L4K5f3tuiS5qKnPj3?=
 =?us-ascii?Q?Ci/zn0Lv/DydGtLqxmW09xFsPWQwQTcfJw9cK4wtEOTncPeZUP5Nt5tTkyWX?=
 =?us-ascii?Q?wvTRysV7okBmSRTXXe6Q7fAsdjcpN+CkqelsOTBuLaq0j4pGl2rlaPJVGRsB?=
 =?us-ascii?Q?wvJ+6iVATbb9Ih0JN2ePgHhxJETDlodju2lL3rEIV6lmW5cjQDS7I8U0D+Ft?=
 =?us-ascii?Q?NAH56hSX1nkHgnqaAqcRqv7uP9gQwIsmpyqAMnvFUsvMA6vBc9HCnCM8ZyUB?=
 =?us-ascii?Q?t5QZ9lZTFOdWRzVNkAdAjtcJkSBWpHG/GSD3QEYOMQLZuGwBffy3bLrpFhzx?=
 =?us-ascii?Q?/YpWnszH3v3Da0jtRGi8KaNtXUrAjosIdcUyYIwC/3n2HRJPTT8Shxbw1DEs?=
 =?us-ascii?Q?uRnrStbK0D3S04CGKazmDMGw4tPtlC0TbtABwWUwjhdQDC6WBiXuPz0Hy168?=
 =?us-ascii?Q?gxkQBEUNjWBj+tiRUPC5EhPFznr2mDSJ9WgsTq6MhA96IZwiNaniH5KJ+6mx?=
 =?us-ascii?Q?XOAu3x3JF5SYVXgCZJrpbn2R1JRF1tFmoKnNAxyvTDIxgOHpL2fq60tLLl0O?=
 =?us-ascii?Q?olx7UCocdskaXsudIfqGrtPLte4rU3EtjZNdA/8c85hqGgupiAONxIfnocMU?=
 =?us-ascii?Q?+FVZe3Wnz7NtjppdpyRffUCfZ0CXT9MpgiHFwwK8s4S025DgvYVLdLaQGN2g?=
 =?us-ascii?Q?SKDeBEBCwzT/cDK7rGtLvVTmXA1xBHNHN9xBCw3ouNw3GvYhUqBU+qN5YG2X?=
 =?us-ascii?Q?Sttm+Nc4UkvpckJG7W410Hvn2SQllYEhqgC8EuY6w9Hl2xOPFr0e7wp6yell?=
 =?us-ascii?Q?OmHeRuq8gma9bgA9DJC1WaAA1t8dv5D6RTiNC6tgdejDginMsbv9c/jugO6c?=
 =?us-ascii?Q?v18VJE1CH1kbqznZY8v+EojPKx7UUmlXDQr+CME+igcKD9ZtM84RKI6kmApJ?=
 =?us-ascii?Q?poa9zyf/bSvVYhKp9uVdpUjCCMWe9X50vIvRl+GT7I/3fzdMTbi+qT4NEkzY?=
 =?us-ascii?Q?DdYJo2X8NhJ3llGUXl0LhgtVNhnjjl+S+6+53uL5wf6i779B7KEidyJ6iL7A?=
 =?us-ascii?Q?pPC7+voSASJfCGm4d3MHpMvdHN+LtlhEo87ORD4ljDPS7fgDf4v5HFauVH6F?=
 =?us-ascii?Q?tMWaHmJHmLwnq4+WC4ebmatQ5x8V9Kjd41PLTvRGHYOs864m0fDQZK8gmPOr?=
 =?us-ascii?Q?Z5zJBLpct000IxQfTMS6LFEqWbGWsx47dXhgOkdrYyi0n+7VmynkWTSIpHHS?=
 =?us-ascii?Q?BiM8jGDF+3M/0MaHlNU9xVdJp8eUqWXLDRugXRwwiWS1hCeW8uZHHSVQdqac?=
 =?us-ascii?Q?fjVUuFtqhAzWy/FTJ0wJKg8b/BxM4ZijzU7Sf4tZ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7eeea6-cf3c-47d1-d739-08dcf4002cbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2024 07:47:56.7282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DrttaUB0V4l+wKmegRknIy33KYsK1oHFVR4ZqtAhXm5R/wwoKKpuuoTmgyiGlp0RAmPa8K8YhXDCMqbHuLi7fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8056
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 10, 2024 12:23 AM
>=20
> The arm-smmuv3-iommufd.c file will need to call these functions too.
> Remove statics and put them in the header file. Remove the kunit
> visibility protections from arm_smmu_make_abort_ste() and
> arm_smmu_make_s2_domain_ste().
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

