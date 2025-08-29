Return-Path: <kvm+bounces-56363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8BBB3C382
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 21:59:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF2E8A645CE
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 19:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FBE24635E;
	Fri, 29 Aug 2025 19:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lKP1LRmY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B209624503F;
	Fri, 29 Aug 2025 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756497564; cv=fail; b=QQWx30TJ5HfPfTDLZQs1eBYYGU7jHBknynmjh3QxdprJ+0n6h8e7mda6aksLNc6TWAt1jtE/OS4jfyGdWK2Uar2y3vPhPE+n51PRq+t2TkZRrbModJl2lD/y7WvQIoneo+R5Fp1Nr/p0t8/lrQ0OlrH4/frnvHdzdfYvR+In8BU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756497564; c=relaxed/simple;
	bh=yx9eyKGJKwWEB6howttAgl42YP6MEPYeve1AkbytwGA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=siE2DuYd1lIntdtA6yaD7EEgH23PYbE4WUP1NxfUQPCnX3PsjhBEDyc1opjWMdshIS2p09s9EogPv//DV5qfpFOSZnoSJNVDc1sgNXRK1lCYtyaksRo6W7uDE/HZWQZEZ+rvIlTGOmYswQ7P2EGZWjB0CkvRx+DUMN6I8lDPIiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lKP1LRmY; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756497563; x=1788033563;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yx9eyKGJKwWEB6howttAgl42YP6MEPYeve1AkbytwGA=;
  b=lKP1LRmYnaBUTNV0mtcozqPedehgVp/WPs/037eJeRL2D7LrnK1UlZ+v
   ovAuOrzPG+BUR4RbCItygGGXo8AJh3i9fkdsgQ1lLbSgn9jFdBeFESGlg
   tJbSRonaFnAotPs8bPz+xZPwxYz8fQgesTB9e7bvtIfPsBYew6UH8Ydzc
   qohVA0D2lbxjXa9/3EzfD0vvc61W3YF0KdC1lTyKiTJh4RB9f9eGzTxqT
   orohdROzVstRh6CmVh9oBG1Ms3YmthNa0CDQR/X08rW1Z/W9V6z0dJJod
   HiHI0bU7Ohgu1kFooz+B50mO8oy50CBgt959DFma887lPCh45FZSY4B7/
   g==;
X-CSE-ConnectionGUID: N2o7mKWERIe57uUk3f7RDA==
X-CSE-MsgGUID: xlbmO5OTTM6+Kx7IQH3twA==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="69894746"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="69894746"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:59:20 -0700
X-CSE-ConnectionGUID: cbJyzSHnTw69npvsncgzYQ==
X-CSE-MsgGUID: yi8mSvQZQsGkPEUgBkuTng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174632074"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:59:19 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 12:59:19 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 12:59:19 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.86) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 12:59:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AYX16GE24qpQMH5NklHx0E1DIGPmvzncMQyuRZ/2r6kwxf+kwItdGlQsnqMZ3W/AR494KbmqCojnogX9chLa55iVK2N7XJV+1AIq8wQioGzUB6XK0ixc3fn++Xj0PXUpWAyU2CTRiTMYOgjk/DweqtsWoG3TWHw4hVMcxtRbV0JTSTAoepFFFzJUKWbbT3Ixk1HxgjqcaNisndwGZMWVKR/fud17FecH4aw7Zr+H26shI3DcGaYfFvxIdR3AERuPFqQn5P2usmiluL49MF6rsUpTQnw1SOsCf5LFz1lD3rdVzO7HC1fCyAxO5nYIXbr2Ow0Dme2oYc6SpdBbw0as3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yx9eyKGJKwWEB6howttAgl42YP6MEPYeve1AkbytwGA=;
 b=UPxwW3KiyuUmujcYWSSC1Qv3g6L/YgQiB/59kyFAmjPH8aQLdmm0cLZiIs3bv54KxH1OHEJFH0u9pjL5GXp3oJpL53WSsMLJkM/TkMBhfZj6dm6Lt1oeR9IGRMj9nTxnEgTBYCpKcdXAxZMNsP7zdUstmOdriiapCkwfkuzCrEFF9MwG3MddV6PPGLE9jrgzBBZ9qTWoVNFCbrIm619W+Ej47+q9DUStEn+vlNf0QcyqGMUI7wqJ0yptopV1Jet0VQxBEUgPvklGXgJ6sJRuwUqqLB2thaF4XUPBXk56XmGCpGc+OxNFfiEBi1XlFCQXfDSdnhTHBPNGR/BT5760eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4982.namprd11.prod.outlook.com (2603:10b6:510:37::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.25; Fri, 29 Aug
 2025 19:59:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 19:59:12 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 06/18] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Thread-Topic: [RFC PATCH v2 06/18] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Thread-Index: AQHcGHjNhfJJlgwYj0aZQlUx50UdxLR6DdAA
Date: Fri, 29 Aug 2025 19:59:12 +0000
Message-ID: <75529f85ad8c9a4806bc6349fae1fd918e6c76fe.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-7-seanjc@google.com>
In-Reply-To: <20250829000618.351013-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4982:EE_
x-ms-office365-filtering-correlation-id: e7f44db1-6180-4630-2b76-08dde736861c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RU4yQlZCRFBOOHBNTTlUMXMySXhKeVYxaXhETytXMVUrV01PQkhEYXNOcmEw?=
 =?utf-8?B?WTZVdDl2QVZjcHFXcDVuVjQvUkxpWEFlTXZBeVNKcjF0VkVMTE5ldG1qS05s?=
 =?utf-8?B?aEVyd1h5L0VYaXZzZmVtQWNieUE2dnE5UG5LRG9RTlN2L1BuTnh2WUtYUm9u?=
 =?utf-8?B?SzY4c3ZkYk9aRWh5M3ZzU0UwUDRFM3dtSmlKS0duMjl6SVNDUzBvTForZkxF?=
 =?utf-8?B?ZnZmK3FCanJBUFB2dHJMWEl5WnByNWFEMHcrM09ZT1poVEVrWURDNFVhbUpq?=
 =?utf-8?B?cmNsZ1hiTTdKcjNScmljYUlnSm5BQktTYkRaUXEvdU15QVNGVGxUczMrVGQz?=
 =?utf-8?B?S3dGd05Bemx5SEF2UDIxUDdUWkdnN0xNaUFmbG9zWmhZRFFTUTRqSUk2WjNS?=
 =?utf-8?B?aEpOWXE0Ukt5S2Vld3R3c1ZkVkQvdHZRTTJuaFFTYk44T0o0a1EyYlVHRXBx?=
 =?utf-8?B?K3pVa2FQMy9kVkhuM1J1czQ2YkxubFZSbFlqMTZWTXRQR3BBaDVuN3oyWldi?=
 =?utf-8?B?bVNoMHR6ODhsOUVQbHpOd1gzZFBYcFVQZ2h2MG1hUkQ2TUFYVDFKOTlKVmNr?=
 =?utf-8?B?bnhJdEpWYnNPM3doZWVQMThzNW1ONnBMdEpOTUFJcWhGT3pNRG5rWkdMdWFZ?=
 =?utf-8?B?dGJJUTNZU09xRWRNK0tSLzJVMnpvaUJNT1kwTzQzM1VhajJ3VStRUkNIMUU0?=
 =?utf-8?B?dUlxOG9BN0xRTjFKaVNLK0ltUmswL2dyRDlCQlBzU0tkSWxidzhVK2J2SEVi?=
 =?utf-8?B?RWVZdW1KWDkzSkgwZ1JDMmM2S0J0WlIzeFJVQUlPRDBPaHc2SzN1bUtqSm02?=
 =?utf-8?B?S1NWeTFySGlIN09lYUQxaFlVWmJtaVlzS1RodFpZM1VtMVBKaHM2bDNyRzZJ?=
 =?utf-8?B?WEJPK1BoRkVPaTNYeFQ4V3pvRzNuVzJMZFQ2YzY3NXFOUnB2c3lGeUF1WU9l?=
 =?utf-8?B?d1FLMTM2bURmOExoU0J2NkdaZHBRTHcveWU4Ti9ERGQ2UURYWmxOR2tlWHZN?=
 =?utf-8?B?TnBDL2tDbHNEQXBZcm4vWmFDcDRaZVV3M01aWkFQWEdycm5PZGNaamhNYjJu?=
 =?utf-8?B?cVR4N3FubDdtYWgzcHM5RTZxcnlGSSthWDBuNnl6YmpRQTdyMjZnbUIvdXRt?=
 =?utf-8?B?M3R1L3ZaVkJXTWM0Y0NTazhPdVdoY21IRkRJWitzS3VMb2lNTGRaZWxseE52?=
 =?utf-8?B?UDYvY2FRSjBJUGcyV3ZEY2ZCN3hHSTBmY2FtaE9iMUx3QjlKcWRmaWR0cjJ3?=
 =?utf-8?B?d3pTU0swdlU2MmRsLzdvem8wUzdiZ0psdlY2SnFUSHFKYUc3Y2pYMXZWb2kw?=
 =?utf-8?B?T2FVM056RThRUlNNZTFQVlJ5UklTOU5GekNNbml6N2hISWZoYTBOT1Nja1ZZ?=
 =?utf-8?B?aGdVMmZkajROS0poQndKSEFoTC9BMHR5aDRlR0RKTmJ2dysyOGNRQmRlZnhp?=
 =?utf-8?B?RFNkWDhxN29QaU8zaThhYzN0c0kxaHlvV1dLZVo1ZE9JZWM5UDJabHh2TUFX?=
 =?utf-8?B?S2xxQkxxa0RuRDlNRVJSR3ZwaFQ4enZFeDR6anl1VTVGZjJ5RkJkY2tkVTgw?=
 =?utf-8?B?NEVTbnU3bnYxdXZkVUZBTmxsanY1NEh5TkJ4bllwN3djRkxOUnpDZWcxNURj?=
 =?utf-8?B?OEJrUjNGaVdlOEV6SDROUE9SaURDQ0p1R0dyemV0WWgvUWhpWjdwajE3OElX?=
 =?utf-8?B?ZnQvY0MzWVdBVDYzNkRRdHdic0RVVVc2RlRKQnFvUTUrajRNaWZ4b3o4aDVx?=
 =?utf-8?B?SU93QjJsZDNyQTJ4NzdDZnBHczM2dlFwQlFMUEZGWVh2Y0JIK2x2KzZRQXRT?=
 =?utf-8?B?STZ4YXIwVjNYYlU1WjhYc01ORTlFM3Y2UVNJV0VWL0hYcU5vT0c3Nk52WmxS?=
 =?utf-8?B?VXRqZDZWazZkWXhqWUdGeG8yeXUvVWE5YWdKcVYwQXh0NXRGelVHalFRTldR?=
 =?utf-8?B?cC9mNzZWcU9xb1RqLzNmcUxRdzVka1BlR2hWNW1LdDVFNnRhdEtOUjRTT3ZY?=
 =?utf-8?B?cTBkcCtMRDRBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0crVTBSQWhWZk1BWm0rdzRmRk1hNHFvaWUyL3ZPM21kMHlQa3Q4OWZSZnN1?=
 =?utf-8?B?OUw3ODhvaWJoVW8wcytNL296L3JmaUxZd2VKbHV5aXRsOFlRVE5xWHlNN0JT?=
 =?utf-8?B?UkY4NnVxUzcrbFhRanVsbllrTGlhTkQwa3QybnhnUCtGR2JOb3pwNndjNkZM?=
 =?utf-8?B?NHFJRlFTS3Z2Z0ZPWWlGWFRFNndKRnpCZ2kvV1p1YUhDa1F2NHN3RmtKRCs3?=
 =?utf-8?B?ZEVMUldNdm04NFJpczVNUkZiL2NjaEVJT2tYakoxaytaZDE5M3BWMlMva0tU?=
 =?utf-8?B?amErdUIvcWp4eTg4eWhzdHFtTTZrMDlrRUlYZ2QrRjYvY0t4MTRYdC9JN2hB?=
 =?utf-8?B?djFPOEtQZmpzU3FrVUFidENxUmRrRE5UUUlmUHJvaHVmZFBZSGt6NmVXZXB3?=
 =?utf-8?B?SFZ4KzMycUdpM21yTFpmOWNkcjFDRWYrZnBDdVJhSUJFdHFFSUhNTWtHeEhO?=
 =?utf-8?B?L0s1M3BGVlBZaGs5Wll6ZXpsWkI1ejdCVGV1R213NW1tMS8vRkNVbWFQWFBM?=
 =?utf-8?B?M3crT1Qya1VsSDFqMVhPYnh1WDBzd1lvaStVOXJqdTBSem1SbEM1N2pJWWRw?=
 =?utf-8?B?MjZqcUloMlBsODlmQWpUQXFuY2RiUG1vSzA2MWNmUVN2USs3aU9GT1haL1pI?=
 =?utf-8?B?U2ZyR1ZlbThtVUE0SjBBb3RLUWlZUXBaeURrWmRJZmtnZGtYa3A5VXpQcEdh?=
 =?utf-8?B?VDBZbDk4QXA2YUZCYU9HdjZFN3FaMzdRZFRSWUZHOHZWV1V2WE1YVnZIU3ZK?=
 =?utf-8?B?VVhUNGhGY3ZYODNMYi9jRTIxdDdrYlYxU1BKdDcvS2xFaUVKU2lUMDRMOUxL?=
 =?utf-8?B?TFJHQmlFQUNxVGl1TndHa0FwRHlHQTZQdUI2UTlYNjl1TFhBbUtMNzlJZDRG?=
 =?utf-8?B?VzhodS9qMEFPL241OXZ6MG9zaVJaQVpGeCtORjl1UE5acm9sbmlSTm1VNjZK?=
 =?utf-8?B?UXVWcG9nRTZpU0ZmUEcyalJHa05TNDVDdm9oUHlPNEJmb3AvK3BINk82T0ZI?=
 =?utf-8?B?OG12M1ErbDNtZGliTDVjOUg3K0ZHajEreGNpd2xXUUZSTUUvNERMUTRLYUFr?=
 =?utf-8?B?T1JQdU5EcU41QUdaRjF3aWdEc0VncUxsd0VpbjY0U0RIcTdTaWJXbWs1YlFj?=
 =?utf-8?B?U05URVFlSytxbjlSbkl0N1ZuSk10TUFRV1RQbVMrZUYxS1pBdlNzaGRwNEJM?=
 =?utf-8?B?VDl0UTN3NGY3cE5yQWNScnFpYmhmems5MkJTR3hxV0dMTDhuUmtvMzZwZFhZ?=
 =?utf-8?B?N3pnbnNkd3lsbC9ERC9oTldkMXhJbU9OaGNsTEdMemgrUzZxNGw5ek9VZFFt?=
 =?utf-8?B?ZzF2Q05vc1VIUjZWc3cyRUp4dStra3ZVOEhEOGRtSDQxWEpGWDlVVzRJVjkv?=
 =?utf-8?B?ZWVtdnl0Q3c5endSeVlWbVJBUmVWUDk1U0NtY2pzb2tYNU83NjJ5REwvMmhT?=
 =?utf-8?B?VGpFaXBvWndRM3VkQlRJamZVMDY2TjFWN2pNekFpZGZlWnJQQ3ZVc1hUZGkr?=
 =?utf-8?B?bFQwNFltL3U1bENkbkdEQ015TE9paHlKdmt5QnpRdlZhOXRjVE5FUVE4NWlN?=
 =?utf-8?B?akFMOWVEWUQwSTl3YVFISytqZmhtYjIxekpERHZMeW93V2FmdC9vWFkwZnBx?=
 =?utf-8?B?Y3l1T0k4NExGeHdSOUlJd3J3M0ZWMTFqL2NnalNzU3BkSGFhNUxDUGUyNUxx?=
 =?utf-8?B?L1Y1Mk1BZ0Q3dXUyeGUrclNzenhnMjM1amZVaWswOGt6MG9UOFdkRDgvZ3hY?=
 =?utf-8?B?ZnVRL3Y2TDBJczY4ZzNZSnhuWXRnQ0FNcGJ4bDRmNDlPWXprUmlXaUhrZWZq?=
 =?utf-8?B?ZXpRd3dzeXpXZmd4c1hUWC8zV2Vxamc4OUJ0cHJKNG9Fc2QzSzBHbTUyV1dW?=
 =?utf-8?B?dmlDaHd1TU94KzJEL1VjeklON3psTFVRUzRrbFdaU0NwK3lLNFRVcHBabU8r?=
 =?utf-8?B?d0orclppSlJ4ZVhNeEpqV29VTHFYbk93QnFNdjFNTFcvdFpweGdXb3dlMWND?=
 =?utf-8?B?NFpKQ01XNnE5eFNyeUNzVnBVRjlhSmg2ekVlUStLZnV0aS96OXc3bFRGdkt0?=
 =?utf-8?B?cERGSloxY0dmLzZGaTM0TmJ5UXlCL3JHUkRDVE1qUG52S3NiSWg3dWJ2SXMz?=
 =?utf-8?B?Sk5BRkNjNnBwdklVMjNyS2ZQSkFVZDJmK2J0N2E1RGkvTzE1bVc0T3hUSXBh?=
 =?utf-8?B?cXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4681EB809ADE7D41BBA0AC08DBAA7C5B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f44db1-6180-4630-2b76-08dde736861c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 19:59:12.0211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haDPMD4S9zqCMqwde8PWl/3XlIlzsNexoRxQWEmNNrjZbUEtUbv74jR8FwVsi46sA3wGAVkG1CQbvsItsl9svfAqrZIJhkZWrddXqXNsSOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4982
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZXR1cm4gLUVJTyB3aGVuIGEgS1ZNX0JVR19PTigpIGlzIHRyaXBwZWQsIGFzIEtW
TSdzIEFCSSBpcyB0byByZXR1cm4gLUVJTw0KPiB3aGVuIGEgVk0gaGFzIGJlZW4ga2lsbGVkIGR1
ZSB0byBhIEtWTSBidWcsIG5vdCAtRUlOVkFMLsKgIE5vdGUsIG1hbnkgKGFsbD8pDQo+IG9mIHRo
ZSBhZmZlY3RlZCBwYXRocyBuZXZlciBwcm9wYWdhdGUgdGhlIGVycm9yIGNvZGUgdG8gdXNlcnNw
YWNlLCBpLmUuDQo+IHRoaXMgaXMgYWJvdXQgaW50ZXJuYWwgY29uc2lzdGVuY3kgbW9yZSB0aGFu
IGFueXRoaW5nIGVsc2UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21i
ZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo=

