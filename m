Return-Path: <kvm+bounces-33551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65AED9EDF15
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 06:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86CC9283F80
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 05:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2158217CA1B;
	Thu, 12 Dec 2024 05:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q/87aCHj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9123F38DE9
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 05:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733982706; cv=fail; b=XSsvstF4hgb4OHdj8ru6pa7yKRZpgylKnVm0WUqRToUgTYztSXoXBIHmprb281K3eVo5IZMWo3sfVKjwpwxWFHPFS72300xt+SBI4XMOuNsmkIdMHk96Tkl8hoVXWX+pKjrO6CbapWONuap11UwLHjLZXw75jvA65bOSL7o0jy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733982706; c=relaxed/simple;
	bh=ykIAyDZgYZP/Z/L3zN+bBaOGSb1rVCxtokiyyGau5io=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OXUMJAHs4cK09olRN2hJeR3Wb1CNR/xbmjPaTgU6+blxTbdAIUZEBQV5pUQo6a+I6hY73S0Q3D7SmsdH+l9+t1YFvsuMcSlqGXp3CV8jsDPUNMEg+Ep8nrItd6H/b3UWyFY+JZBcHX4UFuBFAPpE1pLzKEr4t2VTXbC+Lru02aE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q/87aCHj; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733982704; x=1765518704;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ykIAyDZgYZP/Z/L3zN+bBaOGSb1rVCxtokiyyGau5io=;
  b=Q/87aCHjZXdTrYp7rqDRvy9+k3ydwwvm9J+kFJormKqPaKXgzBfAjcNN
   +8a9cBTwVg4WlD9lUItitsxUnLC9rKa0HPy1n2YmvZHkIjzCJZOGzgZsV
   LUBQxKzCf3jKLTkdINF2gkAfzOvF+yyslcK1qKmZDT7aU+d1kV2vI+TYV
   vPCt0jiJJMqteH+9f2JnTlbA0whNzlKgLKAOJC6jLzbea7Venr8qSCVh+
   /O8Dpd1bqX8uUom9KFQjYX55ed4wd7D2YHsoId+Sd7HnZ3DA7pH+dh2OT
   xgcYxLyu60Gi9vWGn+c9U8VD46tJ4geGUB8fqWIxh5SV32qrumuJdP3w/
   g==;
X-CSE-ConnectionGUID: jEr5D63IS++TbzU+cZOTog==
X-CSE-MsgGUID: X4iFgsSZS9a8W2t4vt6wpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="45060447"
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="45060447"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 21:51:42 -0800
X-CSE-ConnectionGUID: VIFmGCGhRVOzWjthfzXgWw==
X-CSE-MsgGUID: rkEJaOk3S9e6E8t/ZBDDgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="96560362"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Dec 2024 21:51:40 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Dec 2024 21:51:40 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 11 Dec 2024 21:51:40 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Dec 2024 21:51:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X7BbGf0tyONS0PXwdx0qEy3HdcuHcO3Rn6PUNfSkAwqMbrgqLIpv0ZG6baWZy+67RoD+XBW2U+stG2PuHhj4ddiqub4tM5yMnnbX5343eth1obb4cKeFKIaSxXZfxMnTjrpUIhzof3kbqsEey5+4c2BXdiDRfPm7VbA7mAO5PHANVKjp/mmgnk8Z7uZmyHy3eTghWiC/aHhMaY0CXMgkAvrxBn/0xa0XSP/vyw/PVag3rzeVyAfe94r0gEUekc4Qz0JV+EzzBgwf8XU9uS4rBcQogqUhdVFHcDTOeB1RNpk0U0cgco0w4JHqosRNtAWv8RgSiahVVjhMoLwGNte8Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykIAyDZgYZP/Z/L3zN+bBaOGSb1rVCxtokiyyGau5io=;
 b=CQEe+BVRkKS1bW9AH9zuODcbalQBA1QioybtrvTo/bFJEjhQ7F8sTORH7rM9zXdNPMBwix6zKSzP/od3xrj8RPPxoYWv1CojaD0jP0CxlZOZebV1VcDxtjfWUbidqVgKqiFsre7Ssl8BNq8Xkx8rMIx5TSuYjGK/c4MEMH4mYBEJ1Zsov3/EFOYIyFP8tvSBOdSyNC2mazy2DOzp52vj0uPL9UDTBM33wOI0spirnOi/xHYpbfrnyOM2B0Rkw/FBG2kFgjJ9cMjhFNMnjqxV3h0Rwv/leoziMWeZ6Vlyi5R82dW76RFAlQ5PKEg9FeaD72bGdWkalodO5XIVBZDfVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB8304.namprd11.prod.outlook.com (2603:10b6:208:48b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.14; Thu, 12 Dec
 2024 05:51:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8251.008; Thu, 12 Dec 2024
 05:51:37 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: RE: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Topic: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Index: AQHbLr0MyG3oX7KdYkCnpIbZw3bHE7LZC5CAgACnwQCAARp4AIADagUAgADOLICAAe0wYIABN4YAgAAqgnA=
Date: Thu, 12 Dec 2024 05:51:37 +0000
Message-ID: <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
In-Reply-To: <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB8304:EE_
x-ms-office365-filtering-correlation-id: 163f905c-d59d-4a09-6c8b-08dd1a710b16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?LytyMEhsa3ZRdi9Oc2NIVFBYRVNjUnFlWTN4VldjbytlcG04Z1N4a0Y2ZURV?=
 =?utf-8?B?K1Z2UXIraWg0VElzZ05qcmdlT1NFc2hxWU44MGRLSzVmV2VsMXkxeVF2QmlS?=
 =?utf-8?B?dllCWEplU3ptQU0ra1BIeUpPUHZDUlBPQUkzMklQNlBhTUc1Tk5JeEFjc0Vt?=
 =?utf-8?B?aU41bUJlaEVwU2hGcWFIbUIrSmxJQVhsdE5TOE5oUUJQSEgwd0F6UEg3dDMy?=
 =?utf-8?B?TG1PdXYyUVRMWDRkTXB1OGZpUFNmN1g5d2ZXUjZCRVpqdmsrckFuc0ZoQTZo?=
 =?utf-8?B?OHdZQm5ZQjA2eVAwK29KcTBkbjZpczRpMzQ5V2E2T1NjSGh3WFJGejdRQmhT?=
 =?utf-8?B?VUszSi96SDdpN0FSZ1VDY0lwYjZBU3FqOCt5OE96M2dSdmJ6UXYxcGoyL09r?=
 =?utf-8?B?Zm1pb1NkTVZNdXRKaXIrak9oYmxLK1dsNFRiaUkwOWFINzJVdmxUVEdnaVBK?=
 =?utf-8?B?R2hkaGZSZ2duejhrY3hHcTh2TVh1dERCWXBHbXVlMzlkR2IxcEErZ00rczZo?=
 =?utf-8?B?MVhSQk5qMDEzZEV1aWxUUHdOUzZNOVl6eTkzT3dHcTA5M0NnNW1yZmpPSUIy?=
 =?utf-8?B?WmlrODJUSzlLNjZSbXNWc0xlRmw5RGdUblE2eFNSS2JEcEdSdVFOOC82VG12?=
 =?utf-8?B?cFVBWEx3U0swQ3plT3ZEUEp4NUkraDR1b2xSWWlEazBBaFBLdzJra3RPSjQw?=
 =?utf-8?B?NDNHRlIrSmIzcnZKODZ1STlKSFhmUWUxbU90UXNLR0Nyd0FOM1VFRmFXSGVI?=
 =?utf-8?B?Y2F3b1IzaUgyanJ4cWRpRURuOUlCL3orR3ROZXVKOUx2T1BwMjNnVWFhNE9l?=
 =?utf-8?B?eml5NjNtREdFUDBHaGc2RmdNR1phZStDMEp0RURwSVFZOURuNnZmK2VlVERr?=
 =?utf-8?B?cktPMHowTmJ4VzJuZTQ0TkZINFdVSmdlcEpLY3pqWDlpN3p1WkRObzZKYnVJ?=
 =?utf-8?B?UTNBSTZaODFyY1JZNUxhc05jSEVxYkNieGZ2aXhTNzNxWDJEa0RPR2VSK2ZH?=
 =?utf-8?B?Y0FWOW5SeHQzeFpRc3MvT2RIZEFmOHNzRkxUUWdVTWNSV2c2YjVZRXV5MnB1?=
 =?utf-8?B?Vlp0YjRsNTI2alRCcGFSVFUyVmRTRnNkTDBPd0x3Rm9yZjhvZGdMbVg2S09q?=
 =?utf-8?B?NkM0UXJJQnF0Zk90ZFAyZitoQktJZ1U1ZGJpVk9WeWpFV1VmOWg0T2NZa0J0?=
 =?utf-8?B?Nmd3UUZXMHlpdmN4UFlTQ3dXaU1DTzRWV2w5MHF4RDRUSkhiVEx3aGEyRlB0?=
 =?utf-8?B?UVNQWmMyVDdsOGRHMXJtQmVoYzdpK1FHVzRUOFFCWldXQkZubGxCempiOXVk?=
 =?utf-8?B?RGh6QzJkeTNTWXJrWDdXL1VzcXpBZS9CYjV2UWo4ZDRpSkU5cmxDaWdDMjhu?=
 =?utf-8?B?SHJ4ZnNNd3AxYkpEVFBNZ0dlZDM3WnQ0LzlLRzhRM1BTRmI4UjhNeEEzSWFB?=
 =?utf-8?B?UWNVa3I2M0xJdmk5YnhoY21WMzB0ZWdRRGNjRjB0UkZ6bE9nQ2h5cHFLMkZz?=
 =?utf-8?B?bFY1TEZtUkNJMkhONFBzTktIa0twSENSVGZXWUFEdmFiNEEzREpwb1M1WWpT?=
 =?utf-8?B?UEd6M2hOS21WaGZZZzVKbVE3Y0tzTzdXeTVlcCtwQjNUcjNjVUUvNHIxU0pU?=
 =?utf-8?B?bmRyU2VkTjZaWEhrL0t5bG9qVW4zVHRneHZsN2FJTkZPMnM4YkhxM0M3bTd5?=
 =?utf-8?B?Mkd2YkR6NGZuNzcxK1ZGRUV3Zm40aHBTdlVKOFR6cU4yZUFDV3ZuYXJSd2p5?=
 =?utf-8?B?OUNCVlVDYWI4LzVqb2VpRzIvRzhVd0tPZWU5VzJCMFp3cTFPWUZaUWlBdEx2?=
 =?utf-8?B?Nm1XS0RPd1pRWU1tZGgybW54cWJtc0E0a2xPcEw1eHFkYVhlVHpFb2JLa3l3?=
 =?utf-8?B?UDZMVUhTWVkvd2hScUxoazQ5ZjJDRitpOFlwSzV5cTZIUVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWU5cXlZaERjL2V6Z2hsZUtmZmF5WHVyTUt0NXpQQ1MyZHZZTFV5N0h4TGhk?=
 =?utf-8?B?UXBOTW5VQkRMM0s3Y0ZnUkp2djExSGwrRlFyQTFVMG5pMHRBU3BLWWtlRW4r?=
 =?utf-8?B?aW1nclVFZVpIOXZmWkR3Sys5TnFIZnFPZ0NxRVRwRnROQXB0ZVNYRTVhRksr?=
 =?utf-8?B?RDMzL1VwNzZHVGorUDdmZ0ZuSzMwbHpVQVlDNnU2ZHhoQUJKcVM4OEh2ejla?=
 =?utf-8?B?UFJSSW96QnA5T3NCK0VOS0ZTSlBJOE9VbDFwZG4vT3JsdENtYUhBTFB4elJi?=
 =?utf-8?B?WmFFQXBTVUpwZ0YramJ6QnV2d0ZiYzB4UTdwcXRkRUhQZjRYeWJ3UHFmbHFj?=
 =?utf-8?B?dFJ6NU9GZjRxV1hQT0tGc0pIcnFVeFpaK3BFS3cvZ3ZuNDNPNUZLVG12OW1l?=
 =?utf-8?B?OS93QTQwQis2MkZEVHlTWjVYS1dwQk9TOTk3RzRLY3hKU1BFSU54N3VPcGVn?=
 =?utf-8?B?dDl6bmVqd3g4R3FOVDVpUy9TMytyeVIrTmdUYXpPd3lJQS9Ua3d4V3MyV2dP?=
 =?utf-8?B?VlEvdE9MRHBwOUVlWE1iT0R6RnphOHo5RmZuMy9McmtOSTF6SndZNDY4SFVl?=
 =?utf-8?B?TS9Fa2wvVnNpWUhjeGRCRUswQ1QrTzExcU80ekJoVk5rNHFCd0ZIZXVFOG1Q?=
 =?utf-8?B?VFBqQmZWeGFtY2dOZ1c3L2xFeTNLUWtsVENGUTQ2WlVpamQ3bWFNRFZOdmty?=
 =?utf-8?B?WFdSRHBSMUV6ODNSN2NwelBEdHZPWSs3VG9YUGx5bW9lT3JFSTZBbHNnM2hI?=
 =?utf-8?B?NjhwOHE0c0tMcU92bklmdU85Vzd1a29jTEVWTk9QSzhjVkcxSmpNTmU2eUJN?=
 =?utf-8?B?UEFnRDB4amhHUFVKeW9yeHl0WHp5Y3lBblE1dHAvZ0JZekVHdjdSdHRlY0d2?=
 =?utf-8?B?NWovelY3cnE2V01PczVKZFM3amVldkdiY1hRVUs1blRGSngvbGNwZ2wyMzFN?=
 =?utf-8?B?OVJ3bmxTNHdadmVWemlJUjUwYXdIWGlBczRoMWI4OExJcmg3Tms0NkVkVEF2?=
 =?utf-8?B?UVRSUUZRd1hjSTZXcnA4Y29yOW1ad1MyV3gvNzJSRGNwVC92T2ZkbGhuNUpx?=
 =?utf-8?B?SStTc1p2eVIxeXNzSml4b0lZVkIrN3BoRFc0MGRoc0hseW5OellhMDFEZW1W?=
 =?utf-8?B?dkJpZjRUeEpRQXlyY0tuT25BaXdHZGo4YnRSSVZ1S09zTmdRaEF0K2kzOVdm?=
 =?utf-8?B?ejJXVHcrT0dUOGh2ZUJrT2VZREppRmxaeDIrOGtSaUdaSGgyWXBobWdtWko4?=
 =?utf-8?B?RkhpaXZnSDlNWTZNWnBSbGNwazVpQ1NWeGR2MDN3akFYWVJ5TWlLV1pVdS9P?=
 =?utf-8?B?Y2cwS1ZGcGRvTVNhRXJ5dHlocFJNVWMweTlaNTZHSDlBbUxBck9IVjJmVFZK?=
 =?utf-8?B?V2VFTGhabjVQQWI1d1RRb0o5VUh4MXhIbkFCcDN4bFR3M21tOFFHSXFDcE1u?=
 =?utf-8?B?bnRZYzhLMURqUWtobDNCUENseGRRWXp6U3VkQ0xpNkhOcnF5NnIxTEhwNVZn?=
 =?utf-8?B?TzkzOHhjR3YzTVZTWjRPMUJ5d2IxejdFUmhsblVZR1Y4d3JNUEVvQ0hPVU1m?=
 =?utf-8?B?QXpWbXJOdmJqZlRlRHBzUko5MS9RRndpek1lVmF3WWlVR0RvTHZPR3M4Tm5h?=
 =?utf-8?B?d1VCYXQybTYzSkdPbjRVSWpXOXMrVUd1WHl6aGFnR2tPRjhmR3gvdy9hRnVD?=
 =?utf-8?B?dGJXNVVhdkVESTltVjY2S3ZLYWpsbUhKNkFYTy84UktwcmxtUFkzdXRjNmNw?=
 =?utf-8?B?UW80NHdoZXRjQkhwRktrUFRKcXRVZTFmbDE5TmZGOGdGZXNzWlU0Y1dEdSs0?=
 =?utf-8?B?Rk1TdFVhU3VsV2ZuemZCVDYvWERudHo2VnVhNDJOZ0ZCRWNSWTI3QUlDQXBS?=
 =?utf-8?B?bHJYbmxoV255ZFBOTm5PWWlCSVd1L3dETFhxU1RGSTUwQ2YxeWhCSlNkbWRn?=
 =?utf-8?B?SnZkc1hSbGd2YjFZbko4V3p0aWNLTFoyLzFnUDdOWlJ6Yk5ta3V1NVprWWtx?=
 =?utf-8?B?c2VSR1c0aDZXS2lDQjZ6aDFDTmZBenptUE1aUkV2OFNmckRUdVhZTDVOZ3pi?=
 =?utf-8?B?WFluTUVSNHBWS1B6NDJnUVdDUFlaUTAyeGlMMXk3MFFZNGJSaXFqeHVqbHhT?=
 =?utf-8?Q?Hkbro1pxxbg1i+D/YqdDfMToh?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 163f905c-d59d-4a09-6c8b-08dd1a710b16
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2024 05:51:37.5604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OTYi6EWaLP9E4FsA13frXO48USH0GdO7ClLyAXCNNjkhFx54AMWDIFVRSq8zIM7evkdwk7utAjmUl/WptBQzkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8304
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXks
IERlY2VtYmVyIDEyLCAyMDI0IDExOjE1IEFNDQo+IA0KPiBPbiAyMDI0LzEyLzExIDE2OjQ2LCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5j
b20+DQo+ID4+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDEwLCAyMDI0IDExOjE1IEFNDQo+ID4+
DQo+ID4+IE9uIDIwMjQvMTIvOSAyMjo1NywgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+Pj4N
Cj4gPj4+IFdlIHdhbnQgc29tZSByZWFzb25hYmxlIGNvbXByb21pc2UgdG8gZW5jb3VyYWdlIGFw
cGxpY2F0aW9ucyB0byB1c2UNCj4gPj4+IElPTU1VX0hXUFRfQUxMT0NfUEFTSUQgcHJvcGVybHks
IGJ1dCBub3QgYnVpbGQgdG9vIG11Y2gNCj4gY29tcGxleGl0eQ0KPiA+PiB0bw0KPiA+Pj4gcmVq
ZWN0IGRyaXZlci1zcGVjaWZpYyBiZWhhdmlvci4NCj4gPj4NCj4gPj4gSSdtIG9rIHRvIGRvIGl0
IGluIGlvbW11ZmQgYXMgbG9uZyBhcyBpdCBpcyBvbmx5IGFwcGxpY2FibGUgdG8gaHdwdF9wYWdp
bmcuDQo+ID4+IE90aGVyd2lzZSwgYXR0YWNoaW5nIG5lc3RlZCBkb21haW4gdG8gcGFzaWQgd291
bGQgYmUgZmFpbGVkIGFjY29yZGluZyB0bw0KPiA+PiB0aGUgYWZvcmVtZW50aW9uZWQgZW5mb3Jj
ZW1lbnQuDQo+ID4+DQo+ID4NCj4gPiBJTUhPIHdlIG1heSB3YW50IHRvIGhhdmUgYSBnZW5lcmFs
IGVuZm9yY2VtZW50IGluIElPTU1VRkQgdGhhdA0KPiA+IGFueSBkb21haW4gKHBhZ2luZyBvciBu
ZXN0ZWQpIG11c3QgaGF2ZSBBTExPQ19QQVNJRCBzZXQgdG8gYmUNCj4gPiB1c2VkIGluIHBhc2lk
LW9yaWVudGVkIG9wZXJhdGlvbnMuDQo+ID4NCj4gPiBkcml2ZXJzIGNhbiBoYXZlIG1vcmUgcmVz
dHJpY3Rpb25zLCBlLmcuIGZvciBhcm0vYW1kIGFsbG9jYXRpbmcgYSBuZXN0ZWQNCj4gPiBkb21h
aW4gd2l0aCB0aGF0IGJpdCBzZXQgd2lsbCBmYWlsIGF0IHRoZSBiZWdpbm5pbmcuDQo+IA0KPiBB
Uk0vQU1EIHNob3VsZCBhbGxvdyBhbGxvY2F0aW5nIG5lc3RlZCBkb21haW4gd2l0aCB0aGlzIGZs
YWcuIE90aGVyd2lzZSwNCj4gaXQgZG9lcyBub3Qgc3VpdCB0aGUgQUxMT0NfUEFTSUQgZGVmaW5p
dGlvbi4gSXQgcmVxdWlyZXMgYm90aCB0aGUgUEFTSUQNCj4gcGF0aCBhbmQgbm9uLVBBU0lEIHBh
dGggdG8gdXNlIHBhc2lkLWNvbXBhdCBkb21haW4uDQoNCmhtbSB0aGUgbWFpbiBwb2ludCB5b3Ug
cmFpc2VkIGF0IHRoZSBiZWdpbm5pbmcgd2FzIHRoYXQgQVJNL0FNRA0KZG9lc24ndCBzdXBwb3J0
IHRoZSBmbGFnIG9uIG5lc3RlZCBkb21haW4sIGdpdmVuIHRoZSBDRC9QQVNJRCB0YWJsZQ0KaXMg
YSBwZXItUklEIHRoaW5nLg0KDQo+IA0KPiBTbyBtYXliZSB3ZSBzaG91bGQgbm90IHN0aWNrIHdp
dGggdGhlIGluaXRpYWwgcHVycG9zZSBvZiBBTExPQ19QQVNJRCBmbGFnLg0KPiBJdCBhY3R1YWxs
eSBtZWFucyBzZWxlY3RpbmcgVjIgcGFnZSB0YWJsZS4gQnV0IHRoZSBkZWZpbml0aW9uIG9mIGl0
IGFsbG93cw0KPiB1cyB0byBjb25zaWRlciB0aGUgbmVzdGVkIGRvbWFpbnMgdG8gYmUgcGFzaWQt
Y29tcGF0IGFzIEludGVsIGFsbG93cyBpdC4NCj4gQW5kLCBhIHNhbmUgdXNlcnNwYWNlIHJ1bm5p
bmcgb24gQVJNL0FNRCB3aWxsIG5ldmVyIGF0dGFjaCBuZXN0ZWQNCj4gZG9tYWluDQo+IHRvIFBB
U0lEcy4gRXZlbiBpdCBkb2VzLCB0aGUgQVJNIFNNTVUgYW5kIEFNRCBpb21tdSBkcml2ZXIgY2Fu
IGZhaWwgc3VjaA0KPiBhdHRlbXB0cy4gSW4gdGhpcyB3YXksIHdlIGNhbiBlbmZvcmNlIHRoZSBB
TExPQ19QQVNJRCBmbGFnIGZvciBhbnkgZG9tYWlucw0KPiB1c2VkIGJ5IFBBU0lELWNhcGFibGUg
ZGV2aWNlcyBpbiBpb21tdWZkLiBUaGlzIHN1aXRzIHRoZSBleGlzdGluZw0KPiBBTExPQ19QQVNJ
RCBkZWZpbml0aW9uIGFzIHdlbGwuDQoNCklzbid0IGl0IHdoYXQgSSB3YXMgc3VnZ2VzdGluZz8g
SU9NTVVGRCBqdXN0IGVuZm9yY2VzIHRoYXQgZmxhZyBtdXN0DQpiZSBzZXQgaWYgYSBkb21haW4g
d2lsbCBiZSBhdHRhY2hlZCB0byBQQVNJRCwgYW5kIGRyaXZlcnMgd2lsbCBkbw0KYWRkaXRpb25h
bCByZXN0cmljdGlvbnMgZS5nLiBBTUQvQVJNIGFsbG93cyB0aGUgZmxhZyBvbmx5IG9uIHBhZ2lu
Zw0KZG9tYWluIHdoaWxlIFZULWQgYWxsb3dzIGl0IGZvciBhbnkgdHlwZS4NCg0KPiANCj4gQEph
c29uLCB5b3VyIG9waW5pb24/IFdpdGggdGhpcyBvcGVuIGNsb3NlZCwgSSBjYW4gdXBkYXRlIHRo
aXMgc2VyaWVzLg0KPiANCj4gUmVnYXJkcywNCj4gWWkgTGl1DQo=

