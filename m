Return-Path: <kvm+bounces-45413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7FAAA917F
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 13:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 104713A93A1
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 11:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F86201116;
	Mon,  5 May 2025 11:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YlgeUd5U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F26619D88F;
	Mon,  5 May 2025 11:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746443120; cv=fail; b=o7fgKaUJsiYizvDUiIZHRbEwraHi0x862Ir6oOdZHwRbEJft3vOIqMEAkC/AAieWlgiL8+xnvoq0y0hPdTX4A0+Gv38WuN+FvOuoRMIeoNxmHaMud/1/LWz9FiL82YgnakfLGEkOFWdd3VDjpUiMCxVDZffvQtioOG8lnlp8504=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746443120; c=relaxed/simple;
	bh=VO7Uq9vduADwA1tZZvl7W6qaoI3IgHcrXpu3YdZQ72Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XWTTNxS2/zM3nCSg1CA6sTrEHcJ7mf7C7u6s5SiQTOJNKy5MoN6cqDf7IypXBHgX7u4TQQg08Evvh53Ta/wOQc3FAalzv3l7/TYWM6UThyUZWAN+DIkpYQjTGNdP05lZNLYFqiBnJ0ck4HqicNZP/8a2hcnytTBSiRD7QlCs7qM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YlgeUd5U; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746443118; x=1777979118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VO7Uq9vduADwA1tZZvl7W6qaoI3IgHcrXpu3YdZQ72Y=;
  b=YlgeUd5UY5UDz9Zqi4Mu6K2twg1iXTRT9ld7UaSYpanNwkgMRfOuM9W7
   VxTaSokdusIMPI+ley3fRNq/g7JobSKZylQ4bGQWbmvHUq4xZwyNxJgb4
   mY/lRTbK2iMLOKKaHcmlV/ROzVpHz4wRAig0uNDWla8e2TFR0AHiG5af3
   5QF9L0/2V0sRST6WQyTe6+X/bczb5ACo9UUdZJ4v0OuXL7ofJwTFNrf3Q
   kYq4dAKxt7v65Y4VleBRbEN7EWeEl2CA2wJr1HoDvf99WIAOKiFzjwXyR
   uIdsQEt5dhr15w3GhNoyxZH32RXO0ObOMzejX7QZvFYVKPfoRYGC7bH78
   w==;
X-CSE-ConnectionGUID: Ux5lFKqPQ/6f3MNORzf+4A==
X-CSE-MsgGUID: sAXurFeWS0STGrj8H0B3Gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11423"; a="58675044"
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="58675044"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 04:05:16 -0700
X-CSE-ConnectionGUID: egSy+brnQRusd2HEgZfr0w==
X-CSE-MsgGUID: qGvFQN39Qt2jJYRJsLXxIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="139242936"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 04:05:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 04:05:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 04:05:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 04:05:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wj2BChvUCmqrpA/E69sjfxByoRZylZBYf3BElH8jExWuQodoJ2dbUwfHJtdTEB3YjK9oeJ4HIz6pg2vb8V0rWLF4kIPHUGR9uJWZCEp9cM+bpCsrTTnSINHvy/us2iMSEMynYazHhRPgJZd0zlxVry7qxPIlfR/jopW2plTIYs47HuYHg/17tECXhXFWEThMFI7FRJ8/Bt+l6u+Q3BWiGkpAspoYiOfRmtltQguaXSUM+40owE5YZ7D8Axf9kN2lYvTDZvC49rzua3090LVCJnSZ2Km1UTOoPZ1cGaUSjIOV2p4mPPmo62iQL7EsDBzRr/RMjgx3x21bA7e8RjDgQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VO7Uq9vduADwA1tZZvl7W6qaoI3IgHcrXpu3YdZQ72Y=;
 b=uS+NCEHtrJShvx0tvNrhK885p3qzuGfUpUUFnr3yOIlvR7RT+cUp/IzObhTZA8vqav8DLFm0yLa70/s2kNuliPFnyW2iC7JGhTb1fr/kpo9YL+BPwojSaD2N0sDxwETvCiB6eZbdqUGsmidoBcUAt9zPnijxmfCgBLQ7cmfBsoDVxfgGPLoX8d51NWfkmJiJcEPdqnolN2Vs4XGfK4aGSL4UMvJGISxyJcnWYaGL/L8b+4Q+QoQQAH1SPjmivoAsaKRYRoDfCO6jA56Q7ci/EKvbsEQrHkpjH/20Vy1aQKbf5t8mJQscO09/GMpsPiHQL1LrE7wtCSbOTqOF1EdRHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4442.namprd11.prod.outlook.com (2603:10b6:5:1d9::23)
 by IA0PR11MB7911.namprd11.prod.outlook.com (2603:10b6:208:40e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Mon, 5 May
 2025 11:05:12 +0000
Received: from DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9]) by DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9%4]) with mapi id 15.20.8699.022; Mon, 5 May 2025
 11:05:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Topic: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Index: AQHbu2NcKKP5MHJtMUaG74su/aJ+/7PD5FsA
Date: Mon, 5 May 2025 11:05:12 +0000
Message-ID: <1e939e994d4f1f36d0a15a18dd66c5fe9864f2e2.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4442:EE_|IA0PR11MB7911:EE_
x-ms-office365-filtering-correlation-id: b2a45866-3434-4091-c208-08dd8bc4b553
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?STM3aENSVXZTemFYRFhOYm1mYVhkUmVqeitBak5RbTllQS83bnphY213aFdY?=
 =?utf-8?B?VU9wNHArcVpITEdmdkt5ZXgvOXhDb2ZjcU03UCtJbXNKZXhWdXphM3QvbVdE?=
 =?utf-8?B?bUo3K1dWU2VPanV6UktvTk9EOGt4d1BHelNCNGYzRURZS3hqRyt3SWtKazdL?=
 =?utf-8?B?MlBtQ240ZUhLb2NwUkVzV1dGK29jRURYR2dydk5HT1lxNEVpNDVUbWJ3NjZw?=
 =?utf-8?B?T0wrUUJaQ2RvOTcxbTRUMmtVcU1yNk01VkxWOG5pTUFrK0RmeGJ1TzdTM3h0?=
 =?utf-8?B?QndXRWZTejFNWlFhNnM1eTgvd08yYWxiY1l0U0RBV0RLMm03Z1NJOG8yZnFN?=
 =?utf-8?B?WmFXQkpuVFlINWlsalNiM2hVeDlxU3VYZlFzem00dzR2Z1pkdXAreTBTcnRh?=
 =?utf-8?B?UGM0L3IyT2l6MlRXZXJQWjJrbFhpT2EweDhMc1dURi9BUmlQa0NJRXVxMGpq?=
 =?utf-8?B?Z0NhUFhXd0w0S0d5T0draWRlaXZkcm5vN1A5d1hsL2hMSU5JYjRadU9vZWZ0?=
 =?utf-8?B?QTUvd3NKNWxCcUtORkg4aXFvZDVTZmVuejJ0dmhQZ3N5c25WbnZQRmFDaTlP?=
 =?utf-8?B?ZnVjdmRTN2dvUmZTSjdMRmZkRVRVN1JHd2pzWHd0cFlSbllVMFgxa0tnTFRR?=
 =?utf-8?B?VFNYYkQzWXM3L0E4dEIzclpoUDVjZCt6bG9XbVhQMU4vUGpSSnA0ZnZBZWxi?=
 =?utf-8?B?cTZIek1ucWg5dEw0aXFzelRiMUZGaWdRbjRUVVBDSEpRZUpBL2RsSjRyVHUx?=
 =?utf-8?B?ZzJBbUhvTzMxc1NKNGE3SE9GVWN3T3Q2K1VTN3BkZFNwL3ExQWdBa1VQUzZG?=
 =?utf-8?B?YVpwU2dXU3ExUUMyR2I0TFZUV0tVQnZGeUpBbjlsMUYwMXFpWXdRZFVwb2Zn?=
 =?utf-8?B?YXBPclVQMjZxOERUU2hJNmxrZTNHMklQcFUxNGNFVlFoV0hvdVVBbk5pWVRj?=
 =?utf-8?B?S3pRWHc1bDNHODRoTlcrT1BvdWZGOWVVVU9CZ1MrVW9sMkdGRmJnZzdSUG9h?=
 =?utf-8?B?R2c2SEVtVTVaM05odW1BYTFVem5JR211N1RyTFc1cis0RXNsb3RPa1ZVbndw?=
 =?utf-8?B?N0QxTVk3dis4WHE1c0o0UnA3L2Q0MHNpanBMYjliZnJlc3JxMFRSVXFWQlIw?=
 =?utf-8?B?cm9GcFExWUpLT1h4RVYvRXNiT25BeXBDU082cTN1bW1GQkdHdGlpVkVmK21i?=
 =?utf-8?B?TjhINzdDZEFjc0JSZGE0bm1RcGJWMzNwQVppZG4rcmNyN0JOemwwakZDY0Uw?=
 =?utf-8?B?T2Q5VGN1NTV4K2tnVFBYMmRXRUgrYzVaWEZkYnpheUF1RXRsQWExRW84Y2ps?=
 =?utf-8?B?bDBNd2g3c0pIRk9qazRoSE5uNFp1cWVuZjFLbXdZSHFXRTVqSG11SVhhMDZT?=
 =?utf-8?B?WTFJc2dRaG9NdjZRanRPNWtOQmJmeDYySllSMVZoclpwMGZUM3g0VWxjc2Vi?=
 =?utf-8?B?YjJWNnlrTFdyZlg2bzY2V3ZVVEFPWStoRWFxTjFDQmR6L2o0RjNOMzBXS3lC?=
 =?utf-8?B?VXUzaG0vMXdtak15cUdhUVp4MWtCaWQ5bzZsUEM2WHRmaUk4NzBjSjZNZCs3?=
 =?utf-8?B?QlBtK3p3bFVTS2ZqOWc3K01OVG05U0RPU3ZjdVgyc28xK0c2MXh3eEg1QTh5?=
 =?utf-8?B?NG5mVTVneUwxbVlTYzdBbmlOdXQ5N1JZcGRYZ2hEcUFZWWNKZWdkU1laRlBm?=
 =?utf-8?B?aWx1MHZ4SGUrcll4VXFSaHlGbE1LVmVmaGtBdS8zVnUyY3pFUDBtUUU0L05E?=
 =?utf-8?B?UHh4RVN0T0NHL1ZQRG12NllFV2NCMlNCWDhmbTVlcW5XNHBkQ1NVREVadFpn?=
 =?utf-8?B?aGNHQlNKSnk5cUt1RnB0YWtaZU5yYno1Z0JQVTFJYVBTM3JRcTNMZ0RKRWdQ?=
 =?utf-8?B?Y2QxR0tJcFNob25VRkZEak9mcGUxcENFelN6NGw4VVhjUElSMmZhMmVTSzQx?=
 =?utf-8?B?Q3FGS2ZmdVExNU9QNVFqcUxkYURDcm9KQ3lXZTlrVTZ4UWdmdUJXdTc2eTBh?=
 =?utf-8?Q?2fLKEYoTOfUxF5k95zeUg1nchgGFqY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4442.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2RDd2NZM1M2M0RETHRUS1k4VHY4RkdxLzAxYjhuOXp4SEhLejFzZkNIRm5L?=
 =?utf-8?B?L0xkUXd1cDBRb2x6UXlyaGtnZmJ6N0QzQzhyc1lVTnJLNUdROXBQaTk2bVdw?=
 =?utf-8?B?Ny9KdXIrR0lqSDJ0eTlYdS9UYWtwUkp3c21kTGtYc3N4VFdxYWxYSGI1dWg3?=
 =?utf-8?B?ZnFqR2s0dS9EdG1CdTBDTFJZWDBmNTlRVFkwWm5YdC8yZjltR2tPRndhaGFZ?=
 =?utf-8?B?N2xKTmt2d2NjUG5CZmEyMHd6NWE2bkdJZ2NZUUNLZ1dtcDFUNU5YK2RrNDZs?=
 =?utf-8?B?bitqNWJ2MTlEMWJFemRad0FZaTBKK0FDc01mSmJNbHpSdEtodVY5cm5jcFRl?=
 =?utf-8?B?UTJnM0pTYXdqWU5GSlNpU2tXeE1sajhPMGRlZkpGWmxmVzJ4djB0d0Z1Z1Fx?=
 =?utf-8?B?UzNnWElXTzVzYUxDdlo5TWswVFRuVXBzcm5Wb1RtdFlKVWRCS1E2YXNvMDR6?=
 =?utf-8?B?MzEvUXRvVG1YMzlETDVINytKN1dTeEVocERmNXByNDlDYVpMZkk0cmM0dmxU?=
 =?utf-8?B?eXJSRnpndnlVdUZxNktXOHljUURvR25BKzk4Q2FVOGNKRW1aY1Y0Y3ovU1ll?=
 =?utf-8?B?bUs2MHZaaktSeUg0aHdXK2R0VnRmbWJCejlTWmhaMkYrTndzd0cvR2FKTlZu?=
 =?utf-8?B?ZGRSR1pITmVMQWZyS1lZbnphb2N1WWdsZVBBYUQwbTJyS0J6V3Q4cE1rYkFQ?=
 =?utf-8?B?NkZIQmN0OXNHN2JOcTYwUWJlWG5VbW1MRWY4Zm9BUmZkdHBhNkltU21MeUhv?=
 =?utf-8?B?NHh3NUY5dm04Wkh0dERuNWt6SWpESHk2UXFBcG11a3lybHJOT3Q3NGVpc2cw?=
 =?utf-8?B?UjFjK0hJa1k3TUFiU1RyaTQ1T1JSYUIvRWphYnVrNCsvUGVGVUFMcHZKNEda?=
 =?utf-8?B?Zmk3N2M0RWtUWkdiYUJ4LzdUcWFaNkk4Y1M0N0ttN0F3cWpMMmdZMUFMNGtl?=
 =?utf-8?B?OUsxVVphQWZCLzUxM3RLTC9GVy9yeGcxbnFvbmwzdnlBRkZpRjhoUHlRSzRh?=
 =?utf-8?B?U003RzRmajJUaFo5QjE1YW5GcDBoYUlDNlFuRy9jcisrMlU3Y0ltbTNZUzd3?=
 =?utf-8?B?Q2ZIQ01qeE9VWm1LVStKc3A3SkE1K3JFQk5kZ2pMcEFQTXIxdlo5cUNmUjhL?=
 =?utf-8?B?cUxxbmtjeXdFdElHMVIvdENWK1FPeGppMmpIU0ZpYmpvRkdVOExKV3crTlFz?=
 =?utf-8?B?TmM1dnBWREZvWkdoRXdBTEZIcmVpZVhmV05weDZybzZaZU40dnlzcE5tOEwy?=
 =?utf-8?B?YXUvRkgrNEIwOWMrL1dObjNXdHA3enFPL3BYaFdhRDJzemFOaUYvSTNaellY?=
 =?utf-8?B?amp2ZGhSWE4zWXlQWWpMZTdESGZ5Rk5HNXRFQWlVLzZ2ajRXdUVYUlkxWWJG?=
 =?utf-8?B?Sy9CMkVnc1o4K3dmWmZOaVRDbm9KNkk1dFMrdG0zRU85bHFEVTB4YWU0ZW9o?=
 =?utf-8?B?dGZjWTRPVVBabnlSYVZJdStFWHQ5SittMEZ0S2NFY3V1UnlyOGw0aFVxTWRl?=
 =?utf-8?B?L21mRFZDZUpnRG1TcGtmT3UvdVFFdWcyYU1XZ0d4K2lsYkE1TkRsZDFDV0Jq?=
 =?utf-8?B?SXU1c3VnQzF6VlZ5VGg2YzdCRlhSQkF1dSs4TWVDWHZTTm9zSjN5REJoL3N3?=
 =?utf-8?B?VWJVa0NlUHcweTh0TTUrTmFMNk96SzB2dExpeGoyOG42SVZaNmdDR284TnI2?=
 =?utf-8?B?elhSOEFqOEFZR1NMUVloSGQ3MWVwNkhaN2tYZEEzSG5TZ2ZsT1VWRWt5Wm5T?=
 =?utf-8?B?Ni9vbFhKR2hUMUtxNThqZC9wT1FuZXJCSXE4L2U0Wml2aWFXbEwvY3Z6aWk4?=
 =?utf-8?B?M3dwY01nWjQwNmN2QWkzcHQwSmkrUDMvbTBLS1NZV0RVODBvMTNvUmRPOGhQ?=
 =?utf-8?B?R2g5UDdqVVRweS8zVWo3L0M5SCtBdDE4T3VqN29GL1JBci9BdVNxOWhFRkty?=
 =?utf-8?B?czQyeFAyWFdVVjBIWjdFbXlKK1FqYnhXWnJGMGl3SXcrSlorU2J1UjhIYzI5?=
 =?utf-8?B?UTFnMTk1WGxnakp0cENhbHRNZi9LN29nc2ZUTEhiN1RwR3ZwUUtrMXZYek1u?=
 =?utf-8?B?a1kvTGJtL3pXWDZkRnZHSklSVE5UaHd4em5mRStGWGo0UHRUS0o3SHFFa25a?=
 =?utf-8?Q?7g1wb+VYeP0oGyhgKm70t6FqH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B301FC3EAEAE14583E99BC3CD537B32@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4442.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a45866-3434-4091-c208-08dd8bc4b553
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2025 11:05:12.8076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xA01UEJpxrl9IoQh+sh3S8xfHv1qORHT3sZCfGdGpJ7nHgIh8eFAbi05zLredpjzd+PsuMcWx6VcwUzyqSwqtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7911
X-OriginatorOrg: intel.com

DQo+ICtzdGF0aWMgYXRvbWljX3QgKnBhbXRfcmVmY291bnRzOw0KPiArDQo+ICBzdGF0aWMgZW51
bSB0ZHhfbW9kdWxlX3N0YXR1c190IHRkeF9tb2R1bGVfc3RhdHVzOw0KPiAgc3RhdGljIERFRklO
RV9NVVRFWCh0ZHhfbW9kdWxlX2xvY2spOw0KPiAgDQo+IEBAIC0xMDM1LDkgKzEwMzgsMTA4IEBA
IHN0YXRpYyBpbnQgY29uZmlnX2dsb2JhbF9rZXlpZCh2b2lkKQ0KPiAgCXJldHVybiByZXQ7DQo+
ICB9DQo+ICANCj4gK2F0b21pY190ICp0ZHhfZ2V0X3BhbXRfcmVmY291bnQodW5zaWduZWQgbG9u
ZyBocGEpDQo+ICt7DQo+ICsJcmV0dXJuICZwYW10X3JlZmNvdW50c1tocGEgLyBQTURfU0laRV07
DQo+ICt9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfZ2V0X3BhbXRfcmVmY291bnQpOw0KDQpJ
dCdzIG5vdCBxdWl0ZSBjbGVhciB3aHkgdGhpcyBmdW5jdGlvbiBuZWVkcyB0byBiZSBleHBvcnRl
ZCBpbiB0aGlzIHBhdGNoLiAgSU1PDQppdCdzIGJldHRlciB0byBtb3ZlIHRoZSBleHBvcnQgdG8g
dGhlIHBhdGNoIHdoaWNoIGFjdHVhbGx5IG5lZWRzIGl0Lg0KDQpMb29raW5nIGF0IHBhdGNoIDUs
IHRkeF9wYW10X2dldCgpL3B1dCgpIHVzZSBpdCwgYW5kIHRoZXkgYXJlIGluIEtWTSBjb2RlLiAg
QnV0DQpJIHRoaW5rIHdlIHNob3VsZCBqdXN0IHB1dCB0aGVtIGhlcmUgaW4gdGhpcyBmaWxlLiAg
dGR4X2FsbG9jX3BhZ2UoKSBhbmQNCnRkeF9mcmVlX3BhZ2UoKSBzaG91bGQgYmUgaW4gdGhpcyBm
aWxlIHRvby4NCg0KQW5kIGluc3RlYWQgb2YgZXhwb3J0aW5nIHRkeF9nZXRfcGFtdF9yZWZjb3Vu
dCgpLCB0aGUgVERYIGNvcmUgY29kZSBoZXJlIGNhbg0KZXhwb3J0IHRkeF9hbGxvY19wYWdlKCkg
YW5kIHRkeF9mcmVlX3BhZ2UoKSwgcHJvdmlkaW5nIHR3byBoaWdoIGxldmVsIGhlbHBlcnMgdG8N
CmFsbG93IHRoZSBURFggdXNlcnMgKGUuZy4sIEtWTSkgdG8gYWxsb2NhdGUvZnJlZSBURFggcHJp
dmF0ZSBwYWdlcy4gIEhvdyBQQU1UDQpwYWdlcyBhcmUgYWxsb2NhdGVkIGlzIHRoZW4gaGlkZGVu
IGluIHRoZSBjb3JlIFREWCBjb2RlLg0KDQo+ICsNCj4gK3N0YXRpYyBpbnQgcGFtdF9yZWZjb3Vu
dF9wb3B1bGF0ZShwdGVfdCAqcHRlLCB1bnNpZ25lZCBsb25nIGFkZHIsIHZvaWQgKmRhdGEpDQo+
ICt7DQo+ICsJdW5zaWduZWQgbG9uZyB2YWRkcjsNCj4gKwlwdGVfdCBlbnRyeTsNCj4gKw0KPiAr
CWlmICghcHRlX25vbmUocHRlcF9nZXQocHRlKSkpDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJ
dmFkZHIgPSBfX2dldF9mcmVlX3BhZ2UoR0ZQX0tFUk5FTCB8IF9fR0ZQX1pFUk8pOw0KPiArCWlm
ICghdmFkZHIpDQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiArDQo+ICsJZW50cnkgPSBwZm5fcHRl
KFBGTl9ET1dOKF9fcGEodmFkZHIpKSwgUEFHRV9LRVJORUwpOw0KPiArDQo+ICsJc3Bpbl9sb2Nr
KCZpbml0X21tLnBhZ2VfdGFibGVfbG9jayk7DQo+ICsJaWYgKHB0ZV9ub25lKHB0ZXBfZ2V0KHB0
ZSkpKQ0KPiArCQlzZXRfcHRlX2F0KCZpbml0X21tLCBhZGRyLCBwdGUsIGVudHJ5KTsNCj4gKwll
bHNlDQo+ICsJCWZyZWVfcGFnZSh2YWRkcik7DQo+ICsJc3Bpbl91bmxvY2soJmluaXRfbW0ucGFn
ZV90YWJsZV9sb2NrKTsNCj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMg
aW50IHBhbXRfcmVmY291bnRfZGVwb3B1bGF0ZShwdGVfdCAqcHRlLCB1bnNpZ25lZCBsb25nIGFk
ZHIsDQo+ICsJCQkJICAgIHZvaWQgKmRhdGEpDQo+ICt7DQo+ICsJdW5zaWduZWQgbG9uZyB2YWRk
cjsNCj4gKw0KPiArCXZhZGRyID0gKHVuc2lnbmVkIGxvbmcpX192YShQRk5fUEhZUyhwdGVfcGZu
KHB0ZXBfZ2V0KHB0ZSkpKSk7DQo+ICsNCj4gKwlzcGluX2xvY2soJmluaXRfbW0ucGFnZV90YWJs
ZV9sb2NrKTsNCj4gKwlpZiAoIXB0ZV9ub25lKHB0ZXBfZ2V0KHB0ZSkpKSB7DQo+ICsJCXB0ZV9j
bGVhcigmaW5pdF9tbSwgYWRkciwgcHRlKTsNCj4gKwkJZnJlZV9wYWdlKHZhZGRyKTsNCj4gKwl9
DQo+ICsJc3Bpbl91bmxvY2soJmluaXRfbW0ucGFnZV90YWJsZV9sb2NrKTsNCj4gKw0KPiArCXJl
dHVybiAwOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IGFsbG9jX3RkbXJfcGFtdF9yZWZjb3Vu
dChzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yKQ0KPiArew0KPiArCXVuc2lnbmVkIGxvbmcgc3RhcnQs
IGVuZDsNCj4gKw0KPiArCXN0YXJ0ID0gKHVuc2lnbmVkIGxvbmcpdGR4X2dldF9wYW10X3JlZmNv
dW50KHRkbXItPmJhc2UpOw0KPiArCWVuZCA9ICh1bnNpZ25lZCBsb25nKXRkeF9nZXRfcGFtdF9y
ZWZjb3VudCh0ZG1yLT5iYXNlICsgdGRtci0+c2l6ZSk7DQo+ICsJc3RhcnQgPSByb3VuZF9kb3du
KHN0YXJ0LCBQQUdFX1NJWkUpOw0KPiArCWVuZCA9IHJvdW5kX3VwKGVuZCwgUEFHRV9TSVpFKTsN
Cj4gKw0KPiArCXJldHVybiBhcHBseV90b19wYWdlX3JhbmdlKCZpbml0X21tLCBzdGFydCwgZW5k
IC0gc3RhcnQsDQo+ICsJCQkJICAgcGFtdF9yZWZjb3VudF9wb3B1bGF0ZSwgTlVMTCk7DQo+ICt9
DQoNCklJVUMsIHBvcHVsYXRpbmcgcmVmY291bnQgYmFzZWQgb24gVERNUiB3aWxsIHNsaWdodGx5
IHdhc3RlIG1lbW9yeS4gIFRoZSByZWFzb24NCmlzIElJVUMgd2UgZG9uJ3QgbmVlZCB0byBwb3B1
bGF0ZSB0aGUgcmVmY291bnQgZm9yIGEgMk0gcmFuZ2UgaWYgdGhlIHJhbmdlIGlzDQpjb21wbGV0
ZWx5IG1hcmtlZCBhcyByZXNlcnZlZCBpbiBURE1SLCBiZWNhdXNlIGl0J3Mgbm90IHBvc3NpYmxl
IGZvciB0aGUga2VybmVsDQp0byB1c2Ugc3VjaCByYW5nZSBmb3IgVERYLg0KDQpQb3B1bGF0aW5n
IGJhc2VkIG9uIHRoZSBsaXN0IG9mIFREWCBtZW1vcnkgYmxvY2tzIHNob3VsZCBiZSBiZXR0ZXIu
ICBJbg0KcHJhY3RpY2UsIHRoZSBkaWZmZXJlbmNlIHNob3VsZCBiZSB1bm5vdGljZWFibGUsIGJ1
dCBjb25jZXB0dWFsbHksIHVzaW5nIFREWA0KbWVtb3J5IGJsb2NrcyBpcyBiZXR0ZXIuDQoNCj4g
Kw0KPiArc3RhdGljIGludCBpbml0X3BhbXRfbWV0YWRhdGEodm9pZCkNCj4gK3sNCj4gKwlzaXpl
X3Qgc2l6ZSA9IG1heF9wZm4gLyBQVFJTX1BFUl9QVEUgKiBzaXplb2YoKnBhbXRfcmVmY291bnRz
KTsNCj4gKwlzdHJ1Y3Qgdm1fc3RydWN0ICphcmVhOw0KPiArDQo+ICsJaWYgKCF0ZHhfc3VwcG9y
dHNfZHluYW1pY19wYW10KCZ0ZHhfc3lzaW5mbykpDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJ
LyoNCj4gKwkgKiBSZXNlcnZlIHZtYWxsb2MgcmFuZ2UgZm9yIFBBTVQgcmVmZXJlbmNlIGNvdW50
ZXJzLiBJdCBjb3ZlcnMgYWxsDQo+ICsJICogcGh5c2ljYWwgYWRkcmVzcyBzcGFjZSB1cCB0byBt
YXhfcGZuLiBJdCBpcyBnb2luZyB0byBiZSBwb3B1bGF0ZWQNCj4gKwkgKiBmcm9tIGluaXRfdGRt
cigpIG9ubHkgZm9yIHByZXNlbnQgbWVtb3J5IHRoYXQgYXZhaWxhYmxlIGZvciBURFggdXNlLg0K
PiArCSAqLw0KPiArCWFyZWEgPSBnZXRfdm1fYXJlYShzaXplLCBWTV9JT1JFTUFQKTsNCj4gKwlp
ZiAoIWFyZWEpDQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiArDQo+ICsJcGFtdF9yZWZjb3VudHMg
PSBhcmVhLT5hZGRyOw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBm
cmVlX3BhbXRfbWV0YWRhdGEodm9pZCkNCj4gK3sNCj4gKwlzaXplX3Qgc2l6ZSA9IG1heF9wZm4g
LyBQVFJTX1BFUl9QVEUgKiBzaXplb2YoKnBhbXRfcmVmY291bnRzKTsNCj4gKw0KPiArCXNpemUg
PSByb3VuZF91cChzaXplLCBQQUdFX1NJWkUpOw0KPiArCWFwcGx5X3RvX2V4aXN0aW5nX3BhZ2Vf
cmFuZ2UoJmluaXRfbW0sDQo+ICsJCQkJICAgICAodW5zaWduZWQgbG9uZylwYW10X3JlZmNvdW50
cywNCj4gKwkJCQkgICAgIHNpemUsIHBhbXRfcmVmY291bnRfZGVwb3B1bGF0ZSwNCj4gKwkJCQkg
ICAgIE5VTEwpOw0KPiArCXZmcmVlKHBhbXRfcmVmY291bnRzKTsNCj4gKwlwYW10X3JlZmNvdW50
cyA9IE5VTEw7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBpbnQgaW5pdF90ZG1yKHN0cnVjdCB0ZG1y
X2luZm8gKnRkbXIpDQo+ICB7DQo+ICAJdTY0IG5leHQ7DQo+ICsJaW50IHJldDsNCj4gKw0KPiAr
CXJldCA9IGFsbG9jX3RkbXJfcGFtdF9yZWZjb3VudCh0ZG1yKTsNCj4gKwlpZiAocmV0KQ0KPiAr
CQlyZXR1cm4gcmV0Ow0KPiAgDQo+ICAJLyoNCj4gIAkgKiBJbml0aWFsaXppbmcgYSBURE1SIGNh
biBiZSB0aW1lIGNvbnN1bWluZy4gIFRvIGF2b2lkIGxvbmcNCj4gQEAgLTEwNDgsNyArMTE1MCw2
IEBAIHN0YXRpYyBpbnQgaW5pdF90ZG1yKHN0cnVjdCB0ZG1yX2luZm8gKnRkbXIpDQo+ICAJCXN0
cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgYXJncyA9IHsNCj4gIAkJCS5yY3ggPSB0ZG1yLT5iYXNlLA0K
PiAgCQl9Ow0KPiAtCQlpbnQgcmV0Ow0KPiAgDQo+ICAJCXJldCA9IHNlYW1jYWxsX3ByZXJyX3Jl
dChUREhfU1lTX1RETVJfSU5JVCwgJmFyZ3MpOw0KPiAgCQlpZiAocmV0KQ0KPiBAQCAtMTEzNCwx
MCArMTIzNSwxNSBAQCBzdGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiAgCWlmIChy
ZXQpDQo+ICAJCWdvdG8gZXJyX3Jlc2V0X3BhbXRzOw0KPiAgDQo+ICsJLyogUmVzZXJ2ZSB2bWFs
bG9jIHJhbmdlIGZvciBQQU1UIHJlZmVyZW5jZSBjb3VudGVycyAqLw0KPiArCXJldCA9IGluaXRf
cGFtdF9tZXRhZGF0YSgpOw0KPiArCWlmIChyZXQpDQo+ICsJCWdvdG8gZXJyX3Jlc2V0X3BhbXRz
Ow0KPiArDQo+ICAJLyogSW5pdGlhbGl6ZSBURE1ScyB0byBjb21wbGV0ZSB0aGUgVERYIG1vZHVs
ZSBpbml0aWFsaXphdGlvbiAqLw0KPiAgCXJldCA9IGluaXRfdGRtcnMoJnRkeF90ZG1yX2xpc3Qp
Ow0KPiAgCWlmIChyZXQpDQo+IC0JCWdvdG8gZXJyX3Jlc2V0X3BhbXRzOw0KPiArCQlnb3RvIGVy
cl9mcmVlX3BhbXRfbWV0YWRhdGE7DQo+ICANCj4gIAlwcl9pbmZvKCIlbHUgS0IgYWxsb2NhdGVk
IGZvciBQQU1UXG4iLCB0ZG1yc19jb3VudF9wYW10X2tiKCZ0ZHhfdGRtcl9saXN0KSk7DQo+ICAN
Cj4gQEAgLTExNDksNiArMTI1NSw5IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQp
DQo+ICAJcHV0X29ubGluZV9tZW1zKCk7DQo+ICAJcmV0dXJuIHJldDsNCj4gIA0KPiArZXJyX2Zy
ZWVfcGFtdF9tZXRhZGF0YToNCj4gKwlmcmVlX3BhbXRfbWV0YWRhdGEoKTsNCj4gKw0KPiAgZXJy
X3Jlc2V0X3BhbXRzOg0KPiAgCS8qDQo+ICAJICogUGFydCBvZiBQQU1UcyBtYXkgYWxyZWFkeSBo
YXZlIGJlZW4gaW5pdGlhbGl6ZWQgYnkgdGhlDQoNCg==

