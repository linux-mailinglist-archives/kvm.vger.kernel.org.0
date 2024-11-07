Return-Path: <kvm+bounces-31076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D299C0145
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB5551F22205
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA50B1E1C34;
	Thu,  7 Nov 2024 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aMwY8sT3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C5318785B
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972241; cv=fail; b=UaobW++4l7Z5z5fv8pMIFB0DfZENSUg+K/GOf+S2/IWNhTJNcso1zlAMA7RgE9Q4lkwZ1qGids0u2RUvYu/ia4usiBzd9BlWYXIcikqep4yVdbeLwtVxC6/05YYwx04JeS5lYCH1dyicWoMkdtUpyEIkIn5lsWc0gl2VOACHsy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972241; c=relaxed/simple;
	bh=Sf5SM2fxyq2784t51eiaodJccN2J3gPxGS30g9jbTWY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XTCu7lGRW6eNBsE804wJn4XrEcOCmphVhd+Wn3o37eA2IOW/xqw+iTHI0O1HDPqyuTIJTTQbPgHiZKsiKzH23ei7CUJdnlEIEh1Jtm8voenTsVfiuRnVIstGxPGORDp5jOsBjXNV8tjZZ+FItbkvt0/+UWWWzBtHnFawGbLF2j8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aMwY8sT3; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730972241; x=1762508241;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sf5SM2fxyq2784t51eiaodJccN2J3gPxGS30g9jbTWY=;
  b=aMwY8sT3CxE8EcqpRyX0SfS6jACtERTSuQW54fL+Yph7T3F0FryCaYAK
   V30FptvI+fCRxZ5YcuAS5nlsg9fEo/DYDNWjvVxTZBaELn0TgIU4AkKvY
   JvDbiIWT5BBKbgUeq/h/wlGoPUZZIRcRoPwIAYHVXveRKr+Ml+lJFZVgb
   7XXpOgZZ6hwFwRLWRDvuZa8JxK8R7ahTk+y2jk1k3f07b9MI3dNUqcieH
   mzj36zTbdwCQQN++f2kPBBeR3fjRxfLO3f0OGdnp6sVeG1Z2ew5wr9gKo
   m3ZpVOSIfb6igC7aKT9mqZcJpQeN8n94R8NqIxOjQDfWa4XNl9u2NNXVT
   Q==;
X-CSE-ConnectionGUID: FSXrTpgjQ8OZ1xTqYu4gSw==
X-CSE-MsgGUID: WEXkXD82SfWJkNEyZ0ZZgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41357843"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41357843"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 01:37:20 -0800
X-CSE-ConnectionGUID: O1SGMthBSDuqZi6N8JiyLg==
X-CSE-MsgGUID: VeMYseQJSsmDtwAfBEacVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="85195031"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 01:37:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 01:37:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 01:37:19 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 01:37:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WA8KMVuUfKxqDhEwo6aD4btVLo72humc16hzPr2/mwZw7n64/KEhBOvM9zjFibY1bEJXfd2joV+pAn5rEF31CAW52lTySR2hthM9R/Ib6SpjzPa4LvmzsxH6lO953k4PYdPdOFFE9sWvPWc6O79nd5AGAqSGe6FFYuigyhEUggtwgajcnaN04SNbDhGcLEO1DUBaTp5bamjf9nUoSprVm/0fN9no6ywPLHbvQyW6BICVTOqLs56FAcIE8QOr7tmYwykMS3XT5mraIYfxCMwkmuRnyCZq82BLw/wM0RIGVpaLcVLU4fUcQXCrurwXv9P+FVJdgQHwu1Zz2hEtuAHT+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sf5SM2fxyq2784t51eiaodJccN2J3gPxGS30g9jbTWY=;
 b=KTWQrelaoGUFAP0vJpwQXBfeKubQrW8B6XmbycbMnPUOPtvZECdRYqE+a3aELJUGdU0AFPIEbWdSa18assxDq4GFOP5FtamE7F5kBXTIobV5HVRcxJbNz04bwqEL42p248Pu1iIiNkz3xGWBKyIzLIGYmyynV6ssUUjANBQOjUZOctqCpyw4CePmAbmofcdoEbOHkGrpjW8uEGO+0qbFdaYYye4oc0E/kUlznRZ//GL7q0KIwY62SegyEWelfOcz+/zp4VifjvnHKkkkNHFqi2Lg0bdB6wfUFXDO7lQRY8plLqnBTPZtCoTf0c4TLcRKFJZ/fZa3bMqgqvacKCCrGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4846.namprd11.prod.outlook.com (2603:10b6:a03:2d8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 09:37:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 09:37:11 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v3 7/7] iommu: Remove the remove_dev_pasid op
Thread-Topic: [PATCH v3 7/7] iommu: Remove the remove_dev_pasid op
Thread-Index: AQHbLrxhX9i/no/H5kG6zwR9mr1TXrKrk68w
Date: Thu, 7 Nov 2024 09:37:11 +0000
Message-ID: <BN9PR11MB5276A7E93B9B76D1BB09DE098C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-8-yi.l.liu@intel.com>
In-Reply-To: <20241104132033.14027-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4846:EE_
x-ms-office365-filtering-correlation-id: 4baac07d-b710-4e4f-9211-08dcff0fc173
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?MLKnFSYoOEWWLElQr6VUdcNm6ONtQ1pSDgrlBbfWcewgbOfKYrb613oEd4NP?=
 =?us-ascii?Q?0+EFFfbmJe0oaT+KOT+R5L8jUWsHAqyCE+xPi0FtGVnsAWnkL0c7aQ/Yr2/h?=
 =?us-ascii?Q?xJd0fyGZCnmo7wsS6/vtmcIt6Aqy8n5P+js7P6GK10RV17baXlLl2nRY9IEN?=
 =?us-ascii?Q?PolTxVXGa+1ghXxU9KDAIJdDIlE3PMNHlxnE71ARsVB0kiYbuvYXRfsVjghl?=
 =?us-ascii?Q?kOSCxOqiDH4z157JjkaZCqW3lDUwO+L5pXFjfQe0jihbkqBzwexlC2HlMFcZ?=
 =?us-ascii?Q?qB5EH1brLOgSCaT9ave7kH1lmzTkJ6WXwa3sAbUPBdWIodB0dkntkh8q66wf?=
 =?us-ascii?Q?3XrbxFSC5A0shB15KVPdh8wijQLLCGC9AQzmiZ25MYy7olEFapF4RBkGx5iA?=
 =?us-ascii?Q?uFfHRlN2gYGKVXwxC8IBNlcYP2aLUFmxHI4Yip9/7sRiSXYYOJiG61guRi8s?=
 =?us-ascii?Q?tZRiNOOr8lLazbSi67yr1URBuBIL52QbmWQD3kslwdDR+SvWhaemhGRkhAIr?=
 =?us-ascii?Q?56fnGJCyJRj2GJgx8fBpwK/5+RP9ru4MFW2DAVHNgFffeIC0tSq4AAtal6pf?=
 =?us-ascii?Q?Qq+uIxhhbSo/IbKE+7pVO9Lz/VVi17C93L4BA6n2NjO672NAXpqA6zte99Ww?=
 =?us-ascii?Q?j4CuVBfjG8/l0RYT3h3tyUz8truyva3aYR6oS201AOq0EVnrni9EYr3s7ROE?=
 =?us-ascii?Q?VeEOgyi0+myKyHRSWqfXFgZoEdfOvmutRFcOk51LAW0mHDaGUu7eQUJ7cMQc?=
 =?us-ascii?Q?6WnI15QdhESPWgWO7TVXEzoJeY3MYO68B5we4uZBg+m4ALAwyGdogYm8ob59?=
 =?us-ascii?Q?3iIkh08/gZIrS/DXQxnYIX7NZIxPPXdR/MtN+1fCut3WK1uUj9mPLsu0tRTA?=
 =?us-ascii?Q?hsaTgEQA9PPVYli3WNToEZ8GrXKtYIodq6/YwamUGuFLayNni/qZ1ZzN/INY?=
 =?us-ascii?Q?yHzyq+vAc0gDj3WhlAnsj1cV0VbJr2QJwsLGwkBnGJwTKpPSTQ7XHJ4aEaaY?=
 =?us-ascii?Q?9PI2P8+jDKPhb5ICleHHMzOs48+8iXrxZfUyF8J8cPYeLUsqn4MaHw5rX5DZ?=
 =?us-ascii?Q?2eli2BAhxngTe7vLyFt0udoFX/x2xaXjzXosyNSO6tyhQkXTWC0V52bQmaRF?=
 =?us-ascii?Q?yIZjpLOFRwcmrNZEfgfXTL535JJH3JvXrTOwxRLBRlzKbWI/qotqvyoWC3Oa?=
 =?us-ascii?Q?wmVB9hGNzvWVI2DGqM14TojXZUEREOKn+US5PSx/I4w9TC5MOvBx6hyc1w15?=
 =?us-ascii?Q?7i0MPKyMunEvC/uDnww3CmwgXdLjwQpYxo6NE17IW6xGXfW1xsdS1aeu6P8F?=
 =?us-ascii?Q?pUSgXsKRq9wia+Uih9/ipruBvWkO2qjFWiFO2l55evVRcgg0UF4JICjgAiV2?=
 =?us-ascii?Q?cRZVK5Y=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cn+dgXPhKEtSoHbyiJLXA2KoPRiOCTu/zj9AKwXrWA19qhvo/uh/mUpOvNfK?=
 =?us-ascii?Q?IxDpw77f30lUYzdrI60/ZVNUofyGGf7C8YJnJ3Jw2rM2JiPkLJC+bwP8uyiM?=
 =?us-ascii?Q?+Jq0Nj+tLumkpktwdjm17xy7BL/G5rmEpfh2bLmfmKBJPOB1V0wgbw6Epmlf?=
 =?us-ascii?Q?eiDogzFiCEi8VPRIZj8GecDjDOJDG+3OeFzByPT5mImSgxXcN2sL2J0Zf2TB?=
 =?us-ascii?Q?gP8PDlz+BMEwjqNzs+J0o6hC032+E5alC456WGiRDnLJaTAw1zyVOvFgON5Y?=
 =?us-ascii?Q?ICPeYMSN20IbFXqjpDhjFBM0UaykrAQMZ+jtFX9kPtSAHNRmYN5aEWV/ilcH?=
 =?us-ascii?Q?AVg02omHwbCbPv6TDYK04fVlFHeUtnVJ7eJM8tQV9A3gRqWiG3JcSFA+vAj8?=
 =?us-ascii?Q?pN8aUCr21H1rdrBimfUAPNSd8DoOI8FMxJ1WBPJUGml4Cky5abEHcUoLdyx8?=
 =?us-ascii?Q?A5g15IXkzBDOGYCJ4fYYW5Rh54uUJnjHh/oHl50qZ2FYeU8P/+pewaGzj15f?=
 =?us-ascii?Q?PuouJK/zvvnQVEwtxs6qSLC19X4YDZnHHC4AQnswojOTq7zqVw30mSJmHsoc?=
 =?us-ascii?Q?nHWs+F4GhM+IIwp8XF+3pFTeuniOb5XnsZBR6pUFLE/GHzOmEIJqclRVb7qn?=
 =?us-ascii?Q?q6eAQZKdHxksGGHGS5fRzSb/UUJmfs8wZp+gIuRShUYxBEQDfFSn6+GehvvR?=
 =?us-ascii?Q?6dW/YQHx+je/nLcg6/YhqOthk3OwFD02PVVMlzYMvm4jPaR/ugkWUpHD4ICg?=
 =?us-ascii?Q?W7qlAw9ds3jL5HUaK9DKBsEjDwiWb0hInwnrlyUXNG84VCe7cSQU85kvUfX6?=
 =?us-ascii?Q?ZRTIlIqPf8IKBivANK7uJvtr9h3u86hm6AqWqGGyBX9IlO42KtY/g2vswKT9?=
 =?us-ascii?Q?1+fZc33fQDi/om6h9CxIPlkQ1/QcjvM4JnWUsE7e1/eoroISrDC8XSeHTNVi?=
 =?us-ascii?Q?cWHgpdbhypkEwmC0dUKGRPm8ipbN1vG5FvnLI9vYQRxSK+YdVu1Sq8uQZyuL?=
 =?us-ascii?Q?0IJOn0J91mcfL8DWFIbxl0FhYj4HixttHcglDUV6iM0TOQyQ6Bgn7bxSQz1q?=
 =?us-ascii?Q?9AP/cFm6VXJndVgEQTGu3zXgumMaPRyyVxfg9afgOVmXRPddtpIoNabmLmTS?=
 =?us-ascii?Q?vpq8IZxsisICVFD+GP+LgyLPNU9oimSLfSsl/JyJyrEI2hgI5AZJ9hIETHAW?=
 =?us-ascii?Q?pvWDzMBlPds+4XU6+0Ygy07tSRJeR+2U7VgjOiQBOglpU7TtCGESq1pe9P7k?=
 =?us-ascii?Q?9oJFSCKSVvAQQb7vABUQL/Sz8zOcf1tlP8LWNHjB68s/Fd23aaxpB1bA98qa?=
 =?us-ascii?Q?jjr2vVDQt+NfvwtjKU1kZcbdG59aG1UD8aunwtM3bQ6Vds0ccsY20+uxNeIi?=
 =?us-ascii?Q?huWLpl/bcKtzY8aicvVbZZ3RJorPO4vn1mW7F4vgAvak+wtMXTr4lb/anMNo?=
 =?us-ascii?Q?S4FyJ0hJ685oLIEbM2c9HysYhxh/TYN4hjkanJlc5UYfrWsnzceMpcPs9NAJ?=
 =?us-ascii?Q?8ObegHSaDcMR5dsr/RxImHBwtRt1/GMiE7SXGXsDFYu6DcIZjcfolbg4W7ay?=
 =?us-ascii?Q?j4fcuJm3TC/fSr6zeV126MXvwoYBSPl5u7naqrbM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4baac07d-b710-4e4f-9211-08dcff0fc173
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 09:37:11.4681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L2dQ+W8O5VHV9q7kyJErYi48XFe1ao2bFlA9UEMCYKo7+7C7asvRBNQZaM1wiS44w3ZqiOwg5NVnQ9kP3ZlPhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4846
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:21 PM
>=20
> The iommu drivers that supports PASID have supported attaching pasid to
> the
> blocked_domain, hence remove the remove_dev_pasid op from the
> iommu_ops.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

