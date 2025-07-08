Return-Path: <kvm+bounces-51761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D86A6AFC91F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 13:04:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4FA37A38BA
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 11:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2562C1596;
	Tue,  8 Jul 2025 11:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NqPrDn18"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10A0221561;
	Tue,  8 Jul 2025 11:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751972638; cv=fail; b=E+08rv2dk4tOCsULs2ue54MBTRMs0+FpLLLeniT2Py5z0q4ARdYARriK9A/+R+uhNBWZuUNUGbpxzd4WDZe2upTwaHJxejsmE5t9uv3NQ6tQHLvLQHG2Zec162aU1EcP6Ejfyb3V0Fai1sB+QYZPuLsb1v0SEyqlSJpcJt16K4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751972638; c=relaxed/simple;
	bh=wfRNqoCDECiHZHOxesjJaCEHCorq6DCmffs9o+nKlWQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZePrLrKQqWQNiV/nJkDXsJsnlIOA4KJMN/TS1gE+1QStzgtHr6ueC/MXMPlyeeUU42RX0KDZ3XvHUOTqmQDO5BdOfRSexlIloV/7SMVK2vV5D8RGi9XZ5rJAz04yJuRtoLeGrDM3WS8w6ALVxLTWPRN/bT7wxWAp0/5mMrxBZ6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NqPrDn18; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751972637; x=1783508637;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wfRNqoCDECiHZHOxesjJaCEHCorq6DCmffs9o+nKlWQ=;
  b=NqPrDn18UkZr+dDcZVck2+0J0v1H/I4m9a2zlHpFOib16Lp9hbWroI6k
   o1DV+nJJIk7M6kSBYnPmFa39uO9obEoekUplTi38LQaHJP7P+fmeGrM2Y
   sbyh21oUCAn14akQA5FDl6Y0bYYfDH2lntlqz+UbV1Frcp7RNhzwzhE/X
   UqqYNWOflXTA2T5f+uhRdB+qcT9xkSZF7ovhbL0S2bTICB7AXFyxsS9ng
   cbeM3oIpm0WnPGdDuCLpbjB1XSXH4T+cGiez8U2AOJx4XSN7y9YY9CB7I
   3LQviL6EUBCPQILRPO/93Ql+9qvqxxiPI6XKyfY0pP3rut2jt53T7kbf5
   g==;
X-CSE-ConnectionGUID: kfYeUcgrTFSdTxsajQEbrg==
X-CSE-MsgGUID: rFwh0+8qRfe+ntqclhQb4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="57973458"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="57973458"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 04:03:56 -0700
X-CSE-ConnectionGUID: 4BiS0l3mQWCi3HLL2oo/dQ==
X-CSE-MsgGUID: u0BbrpvVQZqgbWIHudvplQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="155202308"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 04:03:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 04:03:55 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 04:03:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 04:03:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EYc/tDcA2oHFMjo53yovHfzuUDIusj5RKs/DzH/TatXrq+MpKxJEvnM1g7Q32yPran5E1ISZT33dVgdY1YIhUq8PSjAJHBDE3wRaxqyYOwyeeuRuAuChoM7mTZhWGERSU6ZokqJ9xzq7to+SXmNh18zHV/kF577HQPT3O8IOVEoir7+2JBTghrq1sSG14yYpfO3DhE4buCv0iHxHBhbtLWm7ugOVU2FCZNMFWdv27Fzrq3jyVPiCrXzoSvTpJFrn1RWQsn0SJ6wzjykA/FDVjTBAbJzvLzkK4ii+QsGZlkvq1f7Emmf236Wo/otqz8KrKdgvJiIKMSccA/5H7IDHtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfRNqoCDECiHZHOxesjJaCEHCorq6DCmffs9o+nKlWQ=;
 b=jvHb7IctW+PaGlloa9lPJ0UvaSs2+I7F+/fj0eRoGnWuIwG9/bWbT7UrZ2gLzEoXDXncyYgEibwntJjKScaO+xlIRHIjNcc0SfBMl1EvtPrRa5s1GX5wJ5f4cte7dfSfm6ukpOYOqPwKia9Q06486ITaBpvvIrYvAH+NDQNxrT/WckXqSh04qIfGVCujviAK+wzIQeY/rD+qPW9NxIRSeBBpA47ME5/pKeoiRn1K7rrSsQcQODS0rgm2lrt39/OAcsyor/iRNuKgJThQuuZsqdrhfG7G99a82hvd01pDEKod/1f4krzCtoaaJasq5H8NoSLn8sljh6ds2+WP1xm8rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ5PPF8622363CD.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::83c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Tue, 8 Jul
 2025 11:03:43 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 11:03:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
Thread-Topic: [PATCH 1/2] x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
Thread-Index: AQHb79/jBz5ebYXJmUuZSQVZ2lK2prQoECqA
Date: Tue, 8 Jul 2025 11:03:43 +0000
Message-ID: <8aefaad0204fd89a113a8069217911faaee1517f.camel@intel.com>
References: <20250708080314.43081-1-xiaoyao.li@intel.com>
	 <20250708080314.43081-2-xiaoyao.li@intel.com>
In-Reply-To: <20250708080314.43081-2-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ5PPF8622363CD:EE_
x-ms-office365-filtering-correlation-id: 12fbbec9-3e2b-45d8-4b74-08ddbe0f1a43
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VWlBVnE5ZE5MMGZld3BoVWJIVU56aFB1c0lNTU80OFllZkRLZlc4Z0NUandl?=
 =?utf-8?B?SmtIYUVBeFF2Sk5BSlozQXo3MTllcmQ4bS9QeVMzZU51RUtuTXMyS3VVT0ZI?=
 =?utf-8?B?cktBVmVzanl1SWxSTWdyQ25HanVxekthcU5JMGVXS1dFOUJRbnBEZXJVOWNI?=
 =?utf-8?B?UVhQYVRZKzlHa3QyZWJ0ckwyNUYxMUdZdXhkQU0xczZVU0wweXhxN0hBWU1I?=
 =?utf-8?B?dDlSdFdkNWljOEtwNTRocmt5UWhRWUlrK0RiNmxmc2d1emlyc24wZUNLTk5U?=
 =?utf-8?B?eGRLNGFUWEs0VmdGRmN3Y29qakhaRkNqQmZpbVN0ZkJXdGxaaEhrOXN0dTB2?=
 =?utf-8?B?ZjZhUEJkSHFxZUNUNmhGRjNIRnoyZU4yMVFSWVpMVk9kbUhZdUN5Um80Z3BZ?=
 =?utf-8?B?S0doaW11UWVkNFJSUUM3NFpSRTJsZmJyU2NiY0I5SVBmd0NJMFE0S05XZUQz?=
 =?utf-8?B?T0NOS2kvLzZ6STJQRE94cHBHemQyRlhQOXR3anNibnhTNC9mNHpObWFkLzQz?=
 =?utf-8?B?ak1rdDZyRDVNbDRBT25EazhWSEpQVEVzbWJUUTN6RFg0Q2FISlV3dUdRelJH?=
 =?utf-8?B?cE02d2NiRDk1RlNKS25vaDh3OHg0eVhYak5EYjJFam9zOTlPQndWOTd6V01o?=
 =?utf-8?B?WDV3VGRQa2RzQWZTNHgvUjBDODFEUDIzeVIrUC8rK3BacGM1S1hvb0VHazB1?=
 =?utf-8?B?WTJQUE1JdVV3RklPTGJKKzhKREJqZ3ViVGJzTTVScTdmaU0rSUVUV3p2QldL?=
 =?utf-8?B?YU8yVnNnS0tyYmdJUU9pRTMzV2lXMUo1V0JLM1o1Z01lVDNNZHVDcGZwN0F4?=
 =?utf-8?B?WUFpVWI4ejVFVHZWYWRoQzNENGwwY3ZCamhlUHdvU1BzU3NQQmtZYnUvOEpo?=
 =?utf-8?B?cU9rMEVrK0JUWnVUVmxuMmx3WHdEL3BUU0szdDNZVWI0OHFMdjVVOFpFSG40?=
 =?utf-8?B?YVFXR2lBbVdtcUd4Rlk4MkNPVTRaVWVRRUlMVnNoK3owdEg1MnJGMUdmenR6?=
 =?utf-8?B?WW5uSWJkV3NaTUtxTWpZb0xpRkFXYmgxRDEyL3JiRGtJNEU2akVUK3JpbE14?=
 =?utf-8?B?VDZZNWlrcUdGSk9sZFpMeDFjdHdJWFZXN05jQ2loMDk5UmtJc2JXSlJSZkxW?=
 =?utf-8?B?QVJYVmlTcU1zL09VWVlNTlpvTXcxMFNJZjA1OEltZWp5TFJYT2VPUGtETFZm?=
 =?utf-8?B?NXVNUUdiSUtQaGNMZXFaWmsxbTdkZWVwLzFWZHMxNnZ4WHJWNXNXZXRqNHRJ?=
 =?utf-8?B?MnkzU3JGakk1dGs4THFTaUpQMXAyVHZsNlhjSmlFRmdidnFzdmt4SjJOV1dt?=
 =?utf-8?B?VE9KZ1N0dHNBWStGV045Z0RQL3FqVXJIdkJOazNLNHU5SUlPUFc4S0RySUJO?=
 =?utf-8?B?aFVYWFhoQU5OR0NiT3ZaTHNpenpoZ3kxU0FqRmFDVXRDcmlDSkRmVDNhakRx?=
 =?utf-8?B?ZUduU0NFakhZSjIxWnpqUmhmOUowNDhrck04VkphVVlYcXdaSnpsenc5Vlpr?=
 =?utf-8?B?WWdNTUVIV0wzNG43WmFmNTFYaUNJOG9rOEZMSUw5c3BNWlVVcm5KaTE4aStz?=
 =?utf-8?B?YzdwWmsxV1pDQktvbVU4L2JpMHRkNUdwS0RkTi9FL01qQlBKZ1NRcU9FblZ4?=
 =?utf-8?B?QzZyd3NwcTJSM3ZCVXVZKytlQ0xpT2NWRzQ5Y00yZ2pWeXFJK25tUk9SOU9E?=
 =?utf-8?B?bmxOMytjcE1Wa2hmNzlObTU0UXlURmdKMEhwZ3BtRmFBSzVaOXdyTjlUWHNx?=
 =?utf-8?B?LzNOb0tDK29DcmpTeVFXUEdVRGhYZmMySHZzdUlZbEJlYmRaZkJpSHEvNmo4?=
 =?utf-8?B?a1BxNlhNdVZ0Z1JkeHVEWWRKUStWbVd6V2pUR2tqdEJDY0VuSGphRDV4UVVy?=
 =?utf-8?B?bVNOblFIdm5qdGZlWldMNVhreHpzTnd1Wm5sZE9MbjJTOHJLUzFuTmNFUlFD?=
 =?utf-8?B?d0ZXOFpwaGQzM0FxQVQ3TmlXTlNoNi9zdG9DV1had3MyRjVvbEhTbGZIRVBE?=
 =?utf-8?B?OW5hUW9rSUxRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWh1TUlsbWVDM2Q5Z2g0bHJxUVdEcXY1MGpTdHBBeUcrTU9wNElhZ0Foam5r?=
 =?utf-8?B?R1ozK0YvOEprZFhGRWZJV2Q4UTBtWUZYdXoya3VCTVBINldpa2M3NFc1K29p?=
 =?utf-8?B?VTc4aXJXMjQwZXVqdXBmVCtPQ3VJSXIvbjdMcjRuZXVwR2VMYXV4WXppTWl6?=
 =?utf-8?B?RFNmUnVYTjhhbjNJUml4THNsZEVUN1pPaGl0ZTI4eU9VbUF3bVVOazRXMDRz?=
 =?utf-8?B?QXFLbzV2b1VzYlgvem10MnJkODV6RnIvdCtCeFVlS0FST09oc0ZRcGFhWllO?=
 =?utf-8?B?V2NjY1BWZzlHbGRQa2F2VFpjNHk5bkJXUlRnRGc3NFNwQ1pCcnVPYVJPeWhS?=
 =?utf-8?B?TG9TZG9JUkhXTlh3eGRXeExTcyt3YVIvaWVPNW9GclpxR0hvTmxNSVNtMmR3?=
 =?utf-8?B?NFJna3RPQjVGeTZ2Y1VzcitnRkt4amcwOE1zZWpEMGpxeDVRMWNvKzRZMFZp?=
 =?utf-8?B?RjFBTzFzckZzMENaNThSMjdmR1VXWDlrWTFwemdsWlJYKys0diszakFQT0sr?=
 =?utf-8?B?blVaOU1PODdKK1ZJSUkzeERyTlpyRFFFQ3dDRFhwSnV0emQrbXBMM0Q4dkpM?=
 =?utf-8?B?SEtSVmFYUzNVeVdZZkQzczdvbmdvOTJ5aTNoV2RPa1Rod2JFT1RQcFp2a1ZS?=
 =?utf-8?B?cXBhUEphVEcwcEhJQnN4NHBRN01DRUg2ZzkrQURpWGtEQW5FbWZEZ1JVeno2?=
 =?utf-8?B?VVU4UWVOaUptYXBNeEpCNHlZVTVURkd4RUJScURFQ0U3TXM4MjYweTFkd1Z4?=
 =?utf-8?B?UFo0c09TUG5jUzNvZlNNeTdoR1UxKzgrcXE2OFFsYWxNajErZXV1Nm1pYUww?=
 =?utf-8?B?U2lxbGUzbVh1d3NmRTlpaDR2K2dKK0VUVUdKYlNjZVZLckJFZWxWZVB0cVpU?=
 =?utf-8?B?bEZGNkdyVHNvcXFSUVloWEJIREprcjZFalRMbnNaQ2xSK1FlNFFYd1RZajM5?=
 =?utf-8?B?OTZoRitCZWlrT2w5d3VQUzJXVFEzbUN0MjZxK04vajZ3T0Rvd21IUS9SOTZp?=
 =?utf-8?B?ZWFUdmZMRHJMZHJMTWpxTW1VdC9Ea3dGUGlZZnQvVWF4K2J0amlPMlJFOWdw?=
 =?utf-8?B?S1EyN3lKVnZGK3RJL25YVkJyYjVUekdWMmRJeFQwVU1Tb1lKYzNuMVk5NFMw?=
 =?utf-8?B?empJT0hXb3ZlQ1c3NGxvUmd1dERyQ0U2akdvb1hVa1M5SVdGcFNhbkR5VC9G?=
 =?utf-8?B?OHpNY2FDZUQyYkd4YzlDalhxQlBLdjAySzh6Y0R6aFZZY3FWVDQwMWd0aWtV?=
 =?utf-8?B?YldnTGlReXdHcGVPamVxS0crQXZoTzFWcGI1ZktEOXhWRzJHalJhZi8zT0hk?=
 =?utf-8?B?MTB5TFJHcTFMVUxYMVZhVkJuVWFybTU3R1hZUkUvWDlnaUpvT0V4UlczTkh3?=
 =?utf-8?B?N0lCNE04dHEzSzM1VDNaWWtDVFlEUHRPWmNwUW91TFEyNkYySFBMRVA3c0px?=
 =?utf-8?B?M0xYclNBOENnRkZUaTlEK25RSlBBMVErSzEwbS9KcDgyZUsvbEJna2JhaFpV?=
 =?utf-8?B?VG9pRTY4MmtiSE9CaWJmNitKYVdUbEs1TS8wZXBmZ2JpQkxvSjF0dlNPUWs3?=
 =?utf-8?B?bEdIVjN0bXBVeTFLZ3VPUk1zSFowRjM4cVErZlJDUnpOZkZGTXhZY0c1bGd2?=
 =?utf-8?B?YkgwUUVYNWU5NS9PdC9VbXZCVVJDSy93Sms0ZnVVZkRKaHJXdzg1SGh0N2xy?=
 =?utf-8?B?SGxQTWNGL1FJTDMwSkk2enNjOVIrUFNHdERVWm1YMDJxdVE0YWdaY2g0YkFx?=
 =?utf-8?B?ZjUxWGtMWUpWQURhNkZJRWZQcWNQYmRRTS9XdHpjaCtGbDl5UlgxYnFXbXp0?=
 =?utf-8?B?Rmo5Tnk2OFZwQ3dPNGt0T091amUwYUpkR3NUV3IrampoNlZQQW5qalZoSXMr?=
 =?utf-8?B?ZmJvREdwZTdQOTA2Wm1IankzZ3hMUVlHbmo5a3l0bU00emJ6Si9kOXd1QVNt?=
 =?utf-8?B?MUlUQXJvMVZXemdYV1pieG1uWWUwVEwwVVQvZnd6WU9yR0poVFlObHVxSHFj?=
 =?utf-8?B?ckZmVDFPVTdCQnZiUElkWHJiZmJDc3JBRnh5Mk80VzNiV3hqa0lQV0RCZDRw?=
 =?utf-8?B?dlF4aWR4SytyWVhvMXZ1ZlZsQWlXaHFQVGNVQmxWdFIrZEkyczlKbk92K3Zj?=
 =?utf-8?B?UXdYMjBMeEh4Uzl2TkJNNncxaEZVUGpxaXovZFJRRkt4N3JRcFg2dFJpR04v?=
 =?utf-8?B?cHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A574275831F54347B3B87CCF9A0BECF3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12fbbec9-3e2b-45d8-4b74-08ddbe0f1a43
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 11:03:43.0651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kaKdJ8Ec7uZ13WEYWmRmQb0UXuEz+gotSwdYa+ky48wSqd3vD+ipoybPKRNRkTnnknf5cExj4m295K2otWMubA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8622363CD
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDE2OjAzICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBG
aXggdGhlIHR5cG8gb2YgVERYX0FUVFJfTUlHUlRBQkxFIHRvIFREWF9BVFRSX01JR1JBVEFCTEUu
DQo+IA0KPiBSZXZpZXdlZC1ieTogS2lyaWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZA
bGludXguaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxp
QGludGVsLmNvbT4NCj4gDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQo=

