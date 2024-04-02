Return-Path: <kvm+bounces-13319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A94568949AF
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 04:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3629D1F22496
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 02:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A3D179AB;
	Tue,  2 Apr 2024 02:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GD/ZjKir"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1487D17756
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 02:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712026576; cv=fail; b=CNrR3JWJrk36TBF36QBgWlDx3861BENZioexS29eLwDeXpPv9ofeVnS4NEITcxXm7e4awGC3nFsPLscAp8tRmBLCCDUjpNoQY77UAXcogvISgdfuAC+yqyj3GNKt70rrYYY6FGFC0luEk/RFPKrm6PsG15+6oP9iNtICvzWQtTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712026576; c=relaxed/simple;
	bh=VIPf8/ekhjH9cQayohOXu7m67jNf3y3bymEH5FPtgjQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DG7qkC6gWTY9uAkhICd+HOI9a3rz8MkrnAhd88uSErZ/dsHDV1j++TqcPxOA7gLprXrpS8UaNfHF1gKFTd8tF1x2E0qUiIz7qGOw/rai8QYH3V5bqWP2nU1E4I8RPDePU2G4U9GCDWqcNBDMCRgb/6/eoWrkTy9K2aYzaSpNolQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GD/ZjKir; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712026575; x=1743562575;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VIPf8/ekhjH9cQayohOXu7m67jNf3y3bymEH5FPtgjQ=;
  b=GD/ZjKirIc90l20GdFTQ7CHwuZXwwgoZtfjkl2u7d5s+EisRywBfb03Z
   ZjuhJ9eQbJFGJAXKHnwAhkf/BPypiFbtL/jqGErPDb4Vazvb/JHdFlTa2
   lxcEUwrmHxq/1BI+5sQrcHgwA7ip0DcCOdkTzEZc66UsOQywAb23H9LZv
   5P7BV8vvg+X4dI7XQrQW+R52XoxUAficFn7W9ncHHHieagXyKUDmKiP7U
   eeHiGmIAxqS1WNsKeywCkCdEIGnEP0VenXetduBDxcBzKz+O2SRtyaeJW
   S+zAm7ry+yoF4WpB9jWfm/qWiVivuZSynus3Eh/msNfj0QWF3PhT3nXpf
   Q==;
X-CSE-ConnectionGUID: JKfQcD5OSIKmKdnxnmP/Fg==
X-CSE-MsgGUID: ID+KRJ6uS2+2tg6r+9uFRA==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="7042074"
X-IronPort-AV: E=Sophos;i="6.07,173,1708416000"; 
   d="scan'208";a="7042074"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 19:56:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,173,1708416000"; 
   d="scan'208";a="17986676"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2024 19:56:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 19:56:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 19:56:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 1 Apr 2024 19:56:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 1 Apr 2024 19:56:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckEiVaVP9jbhLHf+6O2gH/0zkJJc2+7vjCkaxCdUjK8h7G5S7yrqiVmkAPjkxueKDibBJJz6lD/Vw4gdnCF3BsOgJHTvi4kLaHA4L/MjFOyDAPaaPKApNjJCG1KyFZJvF6/Pj+jAd1qDzhwzSv8/cyKEtuCsgON19rtYMHfsvPr/3rXxh13lrhxGBSGL4MiVD9yzrLV70yKPWIrr+6KvUXv7j8OqZ2k86MdtmFTyZwaMGwMElUi2LuBXSShKaGOFW78XGZBKedzY27Vu46XmiG1AYuQVbmWrPIjzLc6aAJRDsD5aGEbcYGL1y+zAbJ8t+zcsYLUHkWfaCWsHDmB4Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIPf8/ekhjH9cQayohOXu7m67jNf3y3bymEH5FPtgjQ=;
 b=XvDq0+ORk01HTVrv+jMwLR05KOV2bW1gzEVbokKfCQHPyou1LBxSFgPWsJO8Jaq7sfhnBIktEhbgF1j4JNm0qhrcPqMJmmAje/iTp/YYz5J5pCtpSroHE6Go1MDACpS6Z+kGNRmIPA+35lCk47esILOL4o7QsceWYuL5c//Q7Jg36DBvrshVAiOESAQX9Ry4e92RiqfHedFagxne/6/7htNOQCk93dLsZQzRJeoZvjMD00DcLrkzVwtuV6m3pBgSFtiFYcs8uz13R1ehgBLTRLV5BvmXEfcxxj8f9fvV46YkweSYoB6bzTX4tuYRrrgvnmH3DdUDV58duQ8mvtpmvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CYYPR11MB8331.namprd11.prod.outlook.com (2603:10b6:930:bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Tue, 2 Apr
 2024 02:56:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7452.019; Tue, 2 Apr 2024
 02:56:10 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: RE: [PATCH 2/2] vfio/pci: Pass eventfd context object through irqfd
Thread-Topic: [PATCH 2/2] vfio/pci: Pass eventfd context object through irqfd
Thread-Index: AQHahG5sgS2WdeZI/EWCl6SEyW1IT7FUSa+w
Date: Tue, 2 Apr 2024 02:56:10 +0000
Message-ID: <BN9PR11MB52763AE0B08EE53128187F068C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240401195406.3720453-1-alex.williamson@redhat.com>
 <20240401195406.3720453-3-alex.williamson@redhat.com>
In-Reply-To: <20240401195406.3720453-3-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CYYPR11MB8331:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bR329pa7WBl6BSGWA1dvGVvHN9Xqdc0Rqc2+JQRqV8XxhxdscwCcUO51DRLfBS2o2navi7YRQa+7+CihgDyuQIQPqV1EpBrofB5ppjMCLX/r1738/3kEETTZw7T1WAIaWtR/InAzf4Z+aOhi6kU+vNqUVkTyp9TSb33flVMYhlYwNncOsRjrM1Y7RafnvyXvCqARYW8kWQO0Qy0nXybXgTiGHk4gwAhjE4qqHcvq5yOSdKkgXAwGvQEzzZHdpuRa8nscFHtaY6kyEHSs+MDUjfA/J/Q0Y7/VzVVQYHfliTrX3NyMJkT1KX6EnaZCdsHB40ewMXZxq+zVQU5U48Lc/7Ejlts5C7m5EOzsDYpEid3Qi0hYi3rwIv747Fk/VkxekAzjh336Mok0mMyTGcZ0jhw8H43IxYg/4y5UV0HRHC8n1PCQ81osW0nFejYYPeLJNrzbRezc5HvXCgEflzNZM1JfIMh9QsmbFFCCOjQxnnPf5T9iM+dDJDWfsSLSrtYQ1b1WgiFW+bjetVXEg4H9E6Qi4il96hB4LX0OEy/lhSWgzDahgBQSnp5RYsSJdPbcretpMzX1MfH7XLnrCvWMnNcaY0N1k7keHK+hQZORlyr1LU6s0qDw3wvNzhtIdYVHQXujlN1vmnGTRdTxrEx+pDltwwHU/vBesIssIwDMpWY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GZfs1FQnsw/IPPVB7WwjcEQ8RtjQtmPg2azdSKYtZfeISoIJPcWgx3qlwedc?=
 =?us-ascii?Q?3YPvMB8SZaIj0yywruDlwnGBeaYuvbM+Eplw7vFOjJS7IVpUOsaIb2K+bPjY?=
 =?us-ascii?Q?CVss9S7D+psvc9ThwMfxOalMiPtuQlWQnaBAIKKohrDAY8e9rZTV2dWNNjrt?=
 =?us-ascii?Q?A1gCyCEbChwbCzPtbYxUe6Rgz7oJNBvavgqxviUfQItWcpQH5pF0D3KGisCe?=
 =?us-ascii?Q?8/plixzcH8Uk3+lK3CbMPZf6O8iC6k8MBTPUclRVdg+cTLQnoep6pAuA6SPl?=
 =?us-ascii?Q?yqyAGR/W7SdMLQNnZfrsZg4g4fl0ukbYwv6ebgmiAEYHRwKMwtEeEa+8H+XA?=
 =?us-ascii?Q?3wZwLpMnlmNI7y0TgltkM2hHyqX5Sr00gVaJLZVUbYZZU6E/jIw1KxsIJRW9?=
 =?us-ascii?Q?751/TG0ajmP5l1z+UCmQjw5NvydYbrj71fVLIr6ia5s6OMioMjOSSdgTI6bc?=
 =?us-ascii?Q?snPxU83gVs66NdRfTvwVr2f+MkiDCNRhlfpIhmdPv2gs1zlr1G1f+uKATgYJ?=
 =?us-ascii?Q?98TmIZXr6FNrU6/1v+z40Gn33E/65pHIS6roP3fcNoTZfydUp6n33bDJu0A5?=
 =?us-ascii?Q?RwDJv24duS7KXpAyc8zry11G99t2uUDuhh4CrRGKU8zaZs0XGAaSg1TbbeQa?=
 =?us-ascii?Q?ZS6ujTOI2nP2thVQRQpcayasonqoNciwbhL4YkbpGZ4iehdpMfqNE7bliSIP?=
 =?us-ascii?Q?uWNxHjQvYz2YZaqXC0gDJQiVoCSNfFxTQVBjaBZwsSFpDP5t7Btgsv7WYcZq?=
 =?us-ascii?Q?waa5GZ6WFCeqqMg82CNd/pQS09eMURv3457sDVxleP8teUmNQ12O+eV9rinm?=
 =?us-ascii?Q?169+e7YTRva09iMLK3NnNhdmtpuiGMbLN2m5hUMO30OAyJptZMys4Vp+B/m/?=
 =?us-ascii?Q?iZuWk7Po6wg5e93r3AcavcB/FJwJny2KeQY26ZU2Ep8PFrQgKnXBxXWuqDX/?=
 =?us-ascii?Q?NGqZTkXFsUedZX41CZ/4D2Gmo6sU+6WNDcRkyY5DWQ8zlUbntLPLVgs4PL4b?=
 =?us-ascii?Q?CjsGLExPYIQf+My+2Y5siJrl8Ar9fG5tDi2aphvo/c/WbPjp+MHu9t/IY9Q/?=
 =?us-ascii?Q?UExdgBU5neFJyjbGpYsjO21ZF8MsAKF1Z5UuDxejKkAKfTsdMd9HeadY379X?=
 =?us-ascii?Q?20XPB1mPStPq6GPD7yq6jYc8/PqW4GKecNx8d0ta2ZfJC6zqUH1ITri//Vf5?=
 =?us-ascii?Q?uJwS+Sr/MEiW1ELotOo43Vbjdsi4Oj8daUoe/iyw4NU7ci+q9toDCsMeBTJB?=
 =?us-ascii?Q?Dkw/y2+2Fg31h1bFAQCA3ou/qBf2ZsECsSiJ0Q1syXtcKutJeKXqsLCZAAJB?=
 =?us-ascii?Q?0ySSBdKHPSgyhhXgtcS55tNt5vIaUWVEW6GDrktqD7wiyyKLXZZPP2msvgp7?=
 =?us-ascii?Q?sK4GbfatB9oJP5Zau07t4gYZHYuILWRqAGSFcVUJbVt49OHLN6Xf3ZEwGaRl?=
 =?us-ascii?Q?VJVLWbq3JBQOV7K7qzDV9LZ97Opih54yXhL3C9xeWX/KdL1y/rVfga1UamHZ?=
 =?us-ascii?Q?68ZhHQfESFbfWiGLt68b4pPriyo1mAcMv5iX/leB2RCzwI5IF5a5/RuWYeY0?=
 =?us-ascii?Q?DWnfcmTmxdEUtxqWy6AxmEAcj+F/0ISGWpNDwE8r?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: eab03ee6-e640-49e6-4065-08dc52c073a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2024 02:56:10.7015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fNamnTmMMniTGXmz3lG6zr235hMD5A7HbqP7JntHVCOYjmlwPNmqF7R0+XUUofYUjRJjchpMUoE28bCmcXGwWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8331
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, April 2, 2024 3:54 AM
>=20
> Further avoid lookup of the context object by passing it through the
> irqfd data field.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

