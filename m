Return-Path: <kvm+bounces-25942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0402596D81F
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 14:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACFB428AE97
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 12:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E693019AD9E;
	Thu,  5 Sep 2024 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BVhU4BOC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67671993B2;
	Thu,  5 Sep 2024 12:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725538642; cv=fail; b=AsLgHk5iMrjDkiaHlkQ0My187bOyWt6EVGuONBApXxygV0LW85ficna0kQcerPT7KG1fpb2mOijxBlMbKEpbfNN8pssZOvGIOXHEbTI+rt+Hyh47DebI6Q0yuGhQXjNuXTD2mZ28Ltliu/VrnOoVNTkwlkifux6Dj9RxKb38Dmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725538642; c=relaxed/simple;
	bh=MoXnpFCkDxfP49RobjcmsiDzrk1iY6tr9EzgT/eECxo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SUwc+fGoUEvwFSUOLnD3oy/RI7JpKIlzmmkHE/r5+Sl+vucKn0UTF0eNkhjMvrHGbP6aH1KaUDDvAo0d2NXMrK3UxAeUzQ2qLNOqdEeJY/jgcViHteTlNa5uqSUJgqNjonmZIW5dBSg/FcRL2e6jTrCHdBmiSOYYHdxNW7QODaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BVhU4BOC; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725538640; x=1757074640;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MoXnpFCkDxfP49RobjcmsiDzrk1iY6tr9EzgT/eECxo=;
  b=BVhU4BOCXnmj38MuMIW+NkKWzgSvT6ipO7TpVveTohDnFPn8+A+9OvV8
   NRsf3/O9fRGCF2sG1bu8ZnsuHZMiI0ZKOLwERkWfgCmGL0gnG9Su75Vrp
   gyqr6mNtJjNFuquTBLpxri9EOFn8Y3J6a6MkoOMSmmgiUnQpncaDuJnVz
   1eyuY11+Tulj8vp1Cz3HZ4HMEb/w4Anja4sUd5rHlT8m5ddTcNMJpXccS
   gJOwc69UjbItr535+lnSv6o8AU7evnFWt4kclGdVz/5lywS6m/YeAae5C
   1iGHBr4yjdg/rU2N/7tdIVJRYJV751xUy7+CP/T0s6Dyt/1ZUDjp2k7hu
   Q==;
X-CSE-ConnectionGUID: um3AE8RYQfCY34XM2iCBNw==
X-CSE-MsgGUID: DMEADgiVSnKUP4oiy1J+ug==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24442473"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="24442473"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 05:17:19 -0700
X-CSE-ConnectionGUID: ahhHNve4TCm9LH2gsxNLeA==
X-CSE-MsgGUID: m/HnlXC9Q8SIQIl1/s9liA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="96387804"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 05:17:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 05:17:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 05:17:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 05:17:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EB6/LJqGcGIxTmMO8KlVE2aCiGx9Qs/hCraATYVmKn9Exxj5DOyOAGQVIsBc8UML3YihjGOdU5v42Vjztz+5K1OYrx6SjvDSepZuf4u9NQXv2GkeLMGVLzHFmMmhGk5++7wieuLEAWTcaZ7M7LF+b9qpTTptb32TNE+wou/E4ZeYTUH4VrTI4HtU4MJFGkAJYv5GlemIKNldeyTEsSyuI6dJ+185wsDfkCKPnR45uFpHCgltz6VwRMLvW5a5NZTSyiU2i1wop0yQlCQA7PHz93X5TNZ3tRAMPm3L1vup4YDH9BONotTohO5RxSevuQtc5zRAHibxx92o2ueIQtt20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ZXScwpcYZ9kBalKzotHvnHlQyA8lACJisvk1wCNB6k=;
 b=JzgPmew4D4Wl/EJPkWJZl1yl5UyZGJpA2+A3LmLC0aPgKEztMO5+KDuW1e2GtWFdHJq3Is9D8uMXuuHURolwW6OGQGNN7jgSAV9JE8H1m7SkXNbI36r5pf2vALhpR8YlMLbsXyMWt3N0Xuy2ojUiPzAiWxqVrhrP8Ps9FwqB6Ukbecf1VVFl7jpee40Os+JMabHUwMtFCk+8wdtAJjxf3Bo/nCE4QmS7pD7yyAulXT+Pvtob6Ws6F7RgVy1wSVDJoX1te6HzUTP5TXj+rmZdG507iD/xLRzP8oeLwpg6J4iBalrNZarcssKkdhk3QTMIxumZaEbbdaVNoYOFjniGZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 12:17:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 12:17:14 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, Mostafa Saleh <smostafa@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "pratikrajesh.sampat@amd.com"
	<pratikrajesh.sampat@amd.com>, "michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>, "dhaval.giani@amd.com"
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, "david@redhat.com"
	<david@redhat.com>
Subject: RE: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Topic: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bI5OEgwgABEaACABIX0AIAALPiAgAEeNQCAAHoIAIAGzr6AgAA6GYCAAA/8AIACSweAgAADRwA=
Date: Thu, 5 Sep 2024 12:17:14 +0000
Message-ID: <BN9PR11MB527612F4EF22B4B564E1DEDA8C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
 <20240905120041.GB1358970@nvidia.com>
In-Reply-To: <20240905120041.GB1358970@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7570:EE_
x-ms-office365-filtering-correlation-id: e5514018-47f8-4876-f02b-08dccda4ad3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?Fmxzygfyesorn4263Fw6b1zPmVKfNckYuP9NWPNTLA4F40nuQuS7QEFSxj3C?=
 =?us-ascii?Q?//DIKDHGRwyRiFA3CJuWQVlTsTQLQ28EwAmd9FGhDvY5Bd+qR6nRYrQRHk5Z?=
 =?us-ascii?Q?sQwWKKhl5WHmE+DsTIAfQXVFlVqycqBVvXbrdR8JPBSeSdrRoOVJG5kUt+Ao?=
 =?us-ascii?Q?lJeWJU9KnUI+608zwin6DznYQFbGSCqkjOHX8oIEWQquLIpbyjdBM6ntsz5E?=
 =?us-ascii?Q?qxuJGP0riwA0d0z2KZmCRMzVQkQGwHxFN43niqtwKgMZITlPvJ5e4O24XaUb?=
 =?us-ascii?Q?4OKtZ2FeetI80ek6qx8ZLm3lvDBsGGqhnuKXUWgCfcaywU5+yCLyvOPwMjqH?=
 =?us-ascii?Q?LDY5vCPW9kYCq3g3u4s6zbL74IQ4Qix1VeWqTiAVYxxulkVh9WoTE4vFCMBY?=
 =?us-ascii?Q?+oGnV2FSn6qOcjmreMA6SplzXknH7kaQOryZ9Dq/vM/thgBglmBwzNG9Dh4Y?=
 =?us-ascii?Q?ENCGHCg/W86GCCn0V7VJB8MqHGdGRti8qpeQa+miWCkqlwzQ6GC4NGgI8RX2?=
 =?us-ascii?Q?ktXHcqmkVa4vN/+jgYdIWVDadZioTkO9O0tGWGPEPK3MzgREnrmKYwCE+TTT?=
 =?us-ascii?Q?mBfH3tS7PoAhEdM4keKyuFiLyz18DsapzwVyFNrTMkCtLrmJ27T+wfux4aGy?=
 =?us-ascii?Q?89B8xtwZaxa6DCXxsYW6JlDgSGqg8XtvP8iEqyFCklHtyQe8L0EIHfgTs4wP?=
 =?us-ascii?Q?9VFStsdPAKHQMd2dXyZQIjJHCj5ywHIHHAALsM9PaPjVQB+vvC/fRT5A8t52?=
 =?us-ascii?Q?8rrfo7XNkbzQGHq3NsBL5csLLid4ZeBjSUQvppmN8F9MxwbzDaNijbmCKlGM?=
 =?us-ascii?Q?biDcvcgH7p747dZDiWuLKdsMSZPqKt5rcayYresVh6HQenRxNUs2AV37vHgd?=
 =?us-ascii?Q?aJc/e1LidJ0Mwj9HdVmN+Gu0+b2apGl13XUH6uxaG4F5qCOwG96NsMgHiA77?=
 =?us-ascii?Q?JZ4SLZFEysWnKvRjZbORFn5EtHXFvylx+nPEElp+v2d5TkbqZzLDxAn8KYCX?=
 =?us-ascii?Q?/LbrKTANI/DcsSjDjMWnDUdA+nXilHdBg1woil8zql5fFBRYE9swyQENmFAq?=
 =?us-ascii?Q?zBWYERuBwB5rmFTWQhkyhtwpTzJk5LqLowsHW1Hzt8IdZQraqSWnYj3Mqdfi?=
 =?us-ascii?Q?NTBA1EZrUqCa+pwSSyZh5wDvl6/wjdCDDbGUMLrpnzwkDp+gS3D5XQph1PQc?=
 =?us-ascii?Q?DjlTXjk+e5aE9VDJZ+9w3qmXqqDnmjmWEJOFrAqG8D+dLyiBG6g2dLjH6aPd?=
 =?us-ascii?Q?fbThR+ZwXwiEXz2e4g+Oq/kayQW6ZOAvbNTBdbSFLSPFc8RIwBK9icJFyhQS?=
 =?us-ascii?Q?paTPzYPoK6fjbX6USh5mm8oSOsdM+KAS6cfayb6kwykyLiZ1ZxVnHW84s+LC?=
 =?us-ascii?Q?Vamh/qC3ngQpmN+g4mFFeEN/vySucCDTFGv4MPZ3MF5Y7ql5Bg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KhPwSvFPL6ER2U9kw5qxIJeJJ5gJGivrbIa4I9FMDH6RE//DuVraSQHRzFeu?=
 =?us-ascii?Q?mlxxpM6eNACPPyCAweTzNHIEplRjGhGfXhhsMmh6MzVvipJfZw2Z4aDFS4DF?=
 =?us-ascii?Q?1QWxWvHu5ysvbLnpLwVHjUYLQl0Msgm4+U68jWtIYbUkVgfdULV4zpJwfxay?=
 =?us-ascii?Q?zILJNo3q227u4/RRvlqDX/Ymtm8r0XoSqpQZ1xjBkzHY+tXu4kag/QsnkZFV?=
 =?us-ascii?Q?KNkIphOyCPm7ewmkDhYTy9CqV4UNlrXy9I4SeNXo66wMdSfae0KMYCGKwjVk?=
 =?us-ascii?Q?c4X+fjy46W7rHKUQ4RiTlYnrHiqt6chjFppJSCKf3dzXurzA3nyM7ZMblwxB?=
 =?us-ascii?Q?D7gfPyk7OFMDoJ+aWv7vKUpK/Dvmq9ZAhACRNV5Y4l/qaZyocUotd5WVZn+W?=
 =?us-ascii?Q?lEM7D5aMSH4/Luexl0TPJaXGQmulQ5ZzPs59bFSl4P5s1U+PFpj+FtredHso?=
 =?us-ascii?Q?GYxUb6iBLBecxwe0m6karWgkBldhD65xjPKbl7T55APjpM+2Y49jy5o9gmjf?=
 =?us-ascii?Q?nAy4zOAVU0e/zAMAdZSa2PqmrfT9xIC3OHJgdMPlS/L431cDmGWCO4bMrx2c?=
 =?us-ascii?Q?crFdvvhk7iryuc3oxYx0P8TNAum01p5+hnaBKgwm05fckIM3XH3UDcH2o8vl?=
 =?us-ascii?Q?lLUf4ydeAeZ6pjEYYqaaKWlpzGKUAjogPjqhaAVcvwDzZFelEn47nRBzHY8v?=
 =?us-ascii?Q?+Ez48b7xuQmeA9MN83MDZmYsId2GyPTf5Q9UFsOx6qYhIIMab6K8lNjkiEa7?=
 =?us-ascii?Q?FxN4Fiu/x3NGCPOMgzpBBd/JkyFewrw9z5UYD7yuHZs1GF0+Z3BlNJkfmt5+?=
 =?us-ascii?Q?QJ1uDCd3oS4179E4tjMwNxNrFuxOJNfQQKQ7L2vBD2u8PyCgBMpdrHnahGCB?=
 =?us-ascii?Q?1wQm/WYAGhv/vf9Eka5+SGVgw51ee9HP4WnVIaDVywCW/WrlsZPG02NM5S7L?=
 =?us-ascii?Q?ljx51Beffavx9f0em2Tjw1wOlejdTS6XbWwJocOXAxmGzIUG68TItSdRdIrs?=
 =?us-ascii?Q?OOufEKwAmynO+Em7D7IDiEwJ6XTYQDaGl2PHK8G+gM5xpA7CmqdZA2SKd3+1?=
 =?us-ascii?Q?xRqqFIAtxArq7KSFRv/FJDLHcib2SPXJKPACSGKS7KrasDUr8wtUqGgZ/Ama?=
 =?us-ascii?Q?s/BpmV5O5b214wPzKQXsuPJjTJ2WYYWc8AAHWBK7ljgMvIiFsLyGLgFLmhTo?=
 =?us-ascii?Q?SePEN/j3EMOJbFK6SlMazY/qC9mEbYdIVMrSiuTEdWufnkYP0mtXASI2moGl?=
 =?us-ascii?Q?a6BD2o0YzYSKRsVeY88yIJkpGEqAVjTEwF6CeHxTynfJpIYelRkYiTyw5DYN?=
 =?us-ascii?Q?QRAU6wYnc0KR1EHCF9Pxji+JiJ1SYMVk671nEi0VY/1ahAzJ9zWSEaangd63?=
 =?us-ascii?Q?8YLt/2Vf0+vmTa29bCyktJDQygRoGVzF2jbSKENzhHG+FD9Xkk+8Mg/4KczT?=
 =?us-ascii?Q?sZUXvxhyvTeO8zvcfvn5hEgsIwym1MP8vOQTW++ugZjW/oU9Z8/y4/RoClJK?=
 =?us-ascii?Q?jF97N5iXcQh3TP/Q0TgcA8vQ4ae+MEyrj/2HEz0zv6C+pNgIyj/zw0KCAsyB?=
 =?us-ascii?Q?IMhN82NG8N9AWFzcN7dQSIacximmXvoXmtY9Y+st?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e5514018-47f8-4876-f02b-08dccda4ad3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2024 12:17:14.4622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gUeVGB9nSSrHusuS263boKQ3vXxk07LjlyKEModnao/xlNgZimVC/qa6fO0CCW3NKTBBV/7fsZzaQLGFWXzMfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7570
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, September 5, 2024 8:01 PM
>=20
> On Tue, Sep 03, 2024 at 05:59:38PM -0700, Dan Williams wrote:
> > Jason Gunthorpe wrote:
> > > It would be a good starting point for other platforms to pick at. Try
> > > iommufd first (I'm guessing this is correct) and if it doesn't work
> > > explain why.
> >
> > Yes, makes sense. Will take a look at that also to prevent more
> > disconnects on what this PCI device-security community is actually
> > building.
>=20
> We are already adding a VIOMMU object and that is going to be the
> linkage to the KVM side
>=20
> So we could have new actions:
>  - Create a CC VIOMMU with XYZ parameters
>  - Create a CC vPCI function on the vIOMMU with XYZ parameters
>  - Query stuff?
>  - ???
>  - Destroy a vPCI function
>=20

I'll look at the vIOMMU series soon. Just double confirm here.

the so-called vIOMMU object here is the uAPI between iommufd
and userspace. Not exactly suggesting a vIOMMU visible to guest.
otherwise this solution will be tied to implementations supporting
trusted vIOMMU.

Then you expect to build CC/vPCI stuff around the vIOMMU
object given it already connects to KVM?

