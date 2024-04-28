Return-Path: <kvm+bounces-16123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AC3F8B4A5B
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 09:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 265C0B213AF
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 07:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E775026A;
	Sun, 28 Apr 2024 07:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HgSc5B7X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30A14F889
	for <kvm@vger.kernel.org>; Sun, 28 Apr 2024 07:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714288418; cv=fail; b=XOf+kt+oLTMcDCVmqV6fcaGi1vxpb949w5FRy/yvZN9de2LyjE94dFUGVNG4F9vRf3RKC2XdmeXbqJuymhXa/L8O8zRIUDcfMdCaNyC9RpQKX0LmWtEHa33VziUkfgMe134x3in4cmYV3xLq0dAA+x8RUbt0hWFpOAEQ2E56vso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714288418; c=relaxed/simple;
	bh=iw+LRrPf4S9rn1OrxE0TIMPHKXoBg3Xl+/CSQT9v9Oc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=szU3cF/AcbeKKflsYqAK9/jy4Jzrm4ByZLBmgDJmJt2EEKG29A5K084WnaW0i2N/A92s8T26dO1fnPBKPan8V6kryT6pIJhMiPKd1MYE0Qhlwl/vMxdWqHlNH1nOe9kq0DdsOizWfVQfMkALonG/lGMI+UhzCDBR2FT+QUKB/2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HgSc5B7X; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714288417; x=1745824417;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iw+LRrPf4S9rn1OrxE0TIMPHKXoBg3Xl+/CSQT9v9Oc=;
  b=HgSc5B7X584q3s+bZ2VbkqYtiJRh9N1AvQThpBJCIHyJNMv/yC6JAQJf
   dIZFrHXwTqhp02wy+9+fXNpv/ZxNPYezHJmaBXFSZHWGmuny+ZWzHcn8O
   6AS8uBgOW33ApvzHHxgvr9Y0CiJDMOLEaiqzIAjSTUS+uU9+i+OBGe5Jm
   WTDsN48qS33APtMu4l028ZDo+yaGpR7WfIPg1xbRy+lFUk3AVupEamGH/
   HZUAjBjYzuS4Xi/Is94XKDadvr1bd49HFJHEn/NqZaf7a+cBCLTDelmhr
   kNuJHmtlgjff88t5WdPGOYsRIr6xbofLAic5XCk9XT+rvZRbmIqHh6kTj
   A==;
X-CSE-ConnectionGUID: Os2+Wj2gS3KEUwPXKCToFA==
X-CSE-MsgGUID: csrOvFSiTSaVLewWRD/5nA==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="21388977"
X-IronPort-AV: E=Sophos;i="6.07,237,1708416000"; 
   d="scan'208";a="21388977"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 00:13:36 -0700
X-CSE-ConnectionGUID: vid8gn4NTkum8ntyOfNlZQ==
X-CSE-MsgGUID: OFyyWE4gT62q/c6TaDQ6xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,237,1708416000"; 
   d="scan'208";a="25806768"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Apr 2024 00:13:36 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 28 Apr 2024 00:13:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 28 Apr 2024 00:13:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 28 Apr 2024 00:13:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 28 Apr 2024 00:13:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LW1GAtQ82momRoiYRBrF31KtTXU6UZZG4QP2p+u5XfDxjdt//+a+Q2HI5BzMzgrMtetsUvuI2ZwvWnrOIt42clu2/HAxKOye0m+a4R+taQa3WcXyw1l7stW2zvMRytDf/BHGfCJuQ3lFIERIaYS5FFAmoj8ytZE1Mm2jlINhaDJvxKLvck+hKvIHnnbOkOQFynulFcTFPnKh4BcWPGmlDbSf3CaRSbdVF3fVJK+93kMyT3KOb9hrG8erRTx8dzgwrj0Y9ndBLnoejUqSg8hnQfJQPYcDoXowfOk3Kmveg0oPHwy2j8j9jrKoGEm7sY8ccUfvaV7dXgCoZT/oOQ6mng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iw+LRrPf4S9rn1OrxE0TIMPHKXoBg3Xl+/CSQT9v9Oc=;
 b=Y8JQaHQMg+0hGrogz3ws68Q8m8K3fP2FzY1V0fXAYc4ah7TvYwnFyTHae3bEyCUogeppjisXERBqhO2KvGxd0PWDZF3Xbxb+Z9egr7+SKBEspUhiDYXendqoSvKLGkqw0dqpDoOMEm+QdKEW1l/G3KFBMvpMBQ2Auq55nQerFVbOp3V1g77PsMYcgJLD54M6T+c1Pc1R4I1ziZLFrsbZPte3fufTo3tNV/JSSWtTSFiIJghPO75H1G4AnubVrRPRusTgceGroGmGgnF2FRN+rHtlXCCaLtcPcRfBAzwKcHwrKMPAjBJm1lNg6SaUHN8XvtPv5gxd+ynkjfujdOnPkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5072.namprd11.prod.outlook.com (2603:10b6:a03:2db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.32; Sun, 28 Apr
 2024 07:13:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.7519.031; Sun, 28 Apr 2024
 07:13:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Dawid Osuchowski <linux@osuchow.ski>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [PATCH] vfio: Use anon_inode_getfile_fmode() in
 vfio_device_open_file()
Thread-Topic: [PATCH] vfio: Use anon_inode_getfile_fmode() in
 vfio_device_open_file()
Thread-Index: AQHalqHsTD+dqFVzdEW0L5w3dBbpS7F9ScyQ
Date: Sun, 28 Apr 2024 07:13:32 +0000
Message-ID: <BN9PR11MB527689991F9106756C085E4D8C142@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240424234147.7840-1-linux@osuchow.ski>
In-Reply-To: <20240424234147.7840-1-linux@osuchow.ski>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5072:EE_
x-ms-office365-filtering-correlation-id: 7b572dbd-3a76-4e71-3964-08dc6752b6b7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?sb+gYuwh9xXNrKzIh/daPqrRMPrU1LkKeCTIl6i4eCTADZu3rqjbWGBr3OVV?=
 =?us-ascii?Q?Jc7GvlmPVledUV+pKfqghQbe0e2+x3gDYs1ggNAmOTkOX2EGj8g7hUAzsOMe?=
 =?us-ascii?Q?ipswX4OaGIfHemvCqtdfuBl2hOZUlLnhVFDZ0UttL1aiwrlBtV0RIuDmomcQ?=
 =?us-ascii?Q?pWNMmfFTFua7cizapX81u9T79lTIfddkw/MkFaRfW2r8upOIZwM5gjrL2V9t?=
 =?us-ascii?Q?XiyHDVGQRHeAKQbANbm6hpPcJYfyjVLnB2XNadrCnNvJnhtX3yIyVn8ZLGoX?=
 =?us-ascii?Q?DzKnXektudbOG41v+89faSkcR1MSQmAbEY7OTK5LC7X4q44lAW9wffid5VKO?=
 =?us-ascii?Q?9Ecrynon+Fisj7Wxg8MAGoTNxDugyF2uy/vWhCZc3vTxVsWobQsJPQVGprms?=
 =?us-ascii?Q?UMrCgTaHkhYIQvPXQAGkLUVSBSYzF03Jt8Y7oOrr1ruQxkt+ITpe2Zlr2G5A?=
 =?us-ascii?Q?q25xrwCig5DQ2xftfRhB22MrmYa0LPj9pEXRS/XiCzDfQWi9vALN1WGdomUQ?=
 =?us-ascii?Q?lL4s3NSE2Ev5CkbL/5zjhKA6ShPHG+QUkqqSOOHrRaLL8n2Laq99IAmDBael?=
 =?us-ascii?Q?kLzE50IHTvopRwZnvsrY3NfvJMwPU+rh3VBC94M1h7CPBbRUhT1LTiLu1aei?=
 =?us-ascii?Q?xF7oR2dMSb++Hy9B/VQsemxEmA9DUncSQZXxdx6dDgygTGEG9Cog9v1iUUGw?=
 =?us-ascii?Q?MnmW8GrrwShkvTrx51QgTNNfP2mikFTYFI5gqC/rvJZoQB/WTMZk2koQ5lY3?=
 =?us-ascii?Q?Hlhme44aWtJ58bC0L7WuUyaEyQgiQSqpPm3/F5512srDebfr1QTeKn43//T0?=
 =?us-ascii?Q?KmX40XjNyHPy68oq/svgtKAixNMXxxhzAJv0/24mDIzakFsAWuSoCz1HGf6Z?=
 =?us-ascii?Q?3MJLrRtergsS3/S1JW3hSBqnHCVWKahP/r2Vz0bAWrtw9TI6bOOSQNzF/zIj?=
 =?us-ascii?Q?lG31dLpldi8S/cXpE96irjClI3Oi5rVdtDcBhmOg2pRnsV6RTF3SFGEjXdTx?=
 =?us-ascii?Q?l8m9LYigTB7yQcxUOGaZlHdg8KIXJFRyQYCQMvtCVObuiQWajs+tE+vH7qgq?=
 =?us-ascii?Q?85KCP23C4UZMnoYEPBcNvInlzCP7ej3s3efvr2FVXfe6F+/JILUCz1MG/KVt?=
 =?us-ascii?Q?OSQwdA4F0Qslva32jKagRfkx19c5SDluTY7+kU6jmrO9bAQPN+wbjQ6+WCDP?=
 =?us-ascii?Q?wei8FtOvMtaX48aFH/jPsBVhRxF4TMZ7nX1sa4NP+fz6QTP8Q58hfj15TIbc?=
 =?us-ascii?Q?JL6hBDh8IXie8drFemdRz6ppRIc/X4XCD3ROQhPx9MrRMAYmAaulEdglj6Vc?=
 =?us-ascii?Q?K0sItPHk2lTym9z64eBi2kNmsVJC1N1fmb/GQ2du0zP/lA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OlqTp05u8LYZxlnF1z0dRkqA8tXjV0j1/JsskldEAMV3sTDDjUFXmQ74iy83?=
 =?us-ascii?Q?U7zbp7tdx3pPGknqgOfkG/TpaKmmqb/3qxamyivFPSFA0Ajf+K9RYuedUDd5?=
 =?us-ascii?Q?12EHczvy8JKaf5JjKStpduzOy7WDHaPyuDsJJgg/auRCsiFO6fzk1di7pjmb?=
 =?us-ascii?Q?6rUvHsBeslTrAitpYA104ICmwHpiB5xDNfM8UtQqCIntwlhsuZOhk/deFICE?=
 =?us-ascii?Q?k7IYnOul19kOzWZkOUZG/fqqmDfurkqNhnNQqVrPkp80QaXdB9W7+9DNAs01?=
 =?us-ascii?Q?HMmuuDboe8HN+PAX3TJ+5sM685rbO6XtXG9NjGqBCUiErolHgwHEiQj44/Fc?=
 =?us-ascii?Q?lMktCPzYtMeVJAC+ANBvxnGUVlD2s/K1kVAzkE0/jfYy9GIwGN7yNKnUQr0T?=
 =?us-ascii?Q?XZ2UmgjHtXfKnlauAjfkZE3JeCa/bEW40im5aKHFdbNWIVOZJ8ALI3QXKZLo?=
 =?us-ascii?Q?OSkuELpjK41wTAYN4uvYSCZ208/cCvIuIswICtuMAVOX8PA1XUKXmfFyjv0i?=
 =?us-ascii?Q?LZqwXXzoH7BQN4y6czBA3q5Yc0QiA4bkW2CRSilAGyU3EqiID1u/dexehINo?=
 =?us-ascii?Q?HeqVw2bjHimCGSYCVyBmyEJjX0LbKBvIti/Kgu+wIKwTL2L1UYY2z6ZCk0O5?=
 =?us-ascii?Q?Uq52/J9mXZkDlh5j6zPJjLkycaU1rEcESxA97Qnv13smQOE7cfs5Sw06La2N?=
 =?us-ascii?Q?nrXsJkAs2Ohjs8By4ujAXACLy+AwIySPSEkmAxDoHpk1wYuxnE6bYVy5+GE4?=
 =?us-ascii?Q?mU+YoHelkncsBgkQL5Hb8bIQc5qALMbDVA2vDyo8tqiFiPEE9z7fQiv37qnO?=
 =?us-ascii?Q?xg9WGmKshJo8Wic1NHlI8CEdgPVPTWENUE5SYmIkDKWSGNPboM5bVd+ehl+y?=
 =?us-ascii?Q?eZGBgZOg66vAaOhuZeswVhFqBq1Q8nHCC+IDN5kDvDgf4H2i30YkYVzRahKI?=
 =?us-ascii?Q?1eqXn5EGZhocGcHwnn9GT4S33/fkH37uc3OCsro0EBp1dlx85Lfz/iD1tsZ9?=
 =?us-ascii?Q?9UOct4mBaXeGunFhDC8vm4qg+Idr1RLqE2ekj5O48YxmUbtifqO7RSU/kKgy?=
 =?us-ascii?Q?ItoQxAbwSSmzp8PRE5/0hTmbtzBBKdVDbErque6tgHKNyys7giS5l74LDXuI?=
 =?us-ascii?Q?/KpGUPGuALaibiwp5ujkRCjs6ddCgPcHnO8XPZoBPOKGLfPPYOYc4wxQyuZV?=
 =?us-ascii?Q?4U2glP0pP3dRPIrVpZ9N46F5RhO5uccd59DbjnYCNr6BDJqoYundnPDZrwpK?=
 =?us-ascii?Q?WTXU7XbjgansMGYlQg9DrLZZfeW8KXU14eD9Fht09IOl7BRMMBsS+z+emnRj?=
 =?us-ascii?Q?pARm1QRB7wVjUvzWtevXk0NCwyY9kkmYfYPR+6Z+s78Q69GMbCrL7mF9Arya?=
 =?us-ascii?Q?oDXAQaYuDUI5G41lZ6By+6IeG3B8IH8GAllGCvllalqcgaR+Q3SsdolXwwRY?=
 =?us-ascii?Q?afg3nDwTPfefy0vD8GjvVKqU9qok6r6MxyYTo5Qyr0BeBQ0h3BT4ClcOIEwp?=
 =?us-ascii?Q?ji2Gr8lO4Usn0Q93Deh0RuGShEjiTM7DcBOc9Kdok4a6LoXIvvQj+UBQsow1?=
 =?us-ascii?Q?/lKidfhaA2sP106AENB/ouzfa2mcgK8asl8mrXJY?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b572dbd-3a76-4e71-3964-08dc6752b6b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2024 07:13:32.9989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oNwXHwlB1txoLEXI3VGE6eyhJt9c9fJmb8pg0/KP++yegLAiOEUntcDACa1Rx+AhUGglxVBjs3vp/E+7d/oqMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5072
X-OriginatorOrg: intel.com

> From: Dawid Osuchowski <linux@osuchow.ski>
> Sent: Thursday, April 25, 2024 7:42 AM
>=20
> Remove TODO by using the anon_inode_getfile_fmode() instead of setting
> the fmode directly in vfio_device_open_file().
>=20
> Signed-off-by: Dawid Osuchowski <linux@osuchow.ski>
> ---
> Depends on [1]
>=20
> [1] https://lore.kernel.org/linux-fsdevel/20240424233859.7640-1-
> linux@osuchow.ski/T/#u

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

