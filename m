Return-Path: <kvm+bounces-27190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C17FF97D057
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 05:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E62651C22F8A
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 03:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD732231C;
	Fri, 20 Sep 2024 03:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJqdxwuf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816D4224F6;
	Fri, 20 Sep 2024 03:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726803696; cv=fail; b=FElb2fs3uQi9/iVCm7oAWSlKmjfkOawHwnb87+gLstL5p0nsk2bU1qQiOvjTUDl5pkrqxPTDjsR+OsiyXOVafVqTMeY9t1Y5APaSW+TLiXLlkxmZU/u3Fqqm7NUR6ApFc15El30JU5eF7VpUkx50ltgf4GJNyfNROEOAE6FKlsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726803696; c=relaxed/simple;
	bh=Qlwjxabb3gtYKwTcmQxKZ5NGPP73+HIgCeGIcLLYNtg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G/+g91xtO8iJe4YUavuFpAbbopg/oWW8yWDh8IeAq/AxDs5XAkDc6gbx2hzodPJMoXhGadwDgCTwrWqfwqRcdrrKdGtoowDDAp9IlMV9Xp+t7qnsTyYHdMNIEnLcKnBWpyxMj02W9+wDzkd5xUQHmrtsLYAmDSq43vPqdwlHg5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJqdxwuf; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726803694; x=1758339694;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qlwjxabb3gtYKwTcmQxKZ5NGPP73+HIgCeGIcLLYNtg=;
  b=gJqdxwufp1BsscyFuYaJG5HSEwx5FkBjbXcEDHnzLK5NO4rV/FL/Q98K
   gixSMcGNiD5osbTtqPoPretQHrLv46OsWPKqoBwYy/BJQ742m9ooqAIaA
   zI9sJ+CYSS4KXnUcNjbA/QZkeUqMyF7+RIJO86VI61MYr7FftfoLrvvm/
   r0lhFHjJjl8wihk3+q8tkoLQYu0Ihqd117jDeAZjP3/LBTAKePQu6Dw/5
   yIoL0w8sUdLdpdMlbxTWat8IZLwtErRaxVVtVMrT/s2oc4ScBRYFXdnBb
   rQv87YRkcbLgs7S9j+8h85rEMCmHpYupFmmgRDhBH3gdrEtj3uCsYQ7sY
   Q==;
X-CSE-ConnectionGUID: GAtC3aRaT4GcLyFWSYD2Bw==
X-CSE-MsgGUID: G53twqamSbenyGeyeMOoLg==
X-IronPort-AV: E=McAfee;i="6700,10204,11200"; a="36367390"
X-IronPort-AV: E=Sophos;i="6.10,243,1719903600"; 
   d="scan'208";a="36367390"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2024 20:41:21 -0700
X-CSE-ConnectionGUID: hBpbX9YzTjGDCUNIT3OMcQ==
X-CSE-MsgGUID: vVTGbDi5SMS5P/2rbA45PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,243,1719903600"; 
   d="scan'208";a="70172529"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Sep 2024 20:41:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 19 Sep 2024 20:41:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 19 Sep 2024 20:41:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 19 Sep 2024 20:41:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Sep 2024 20:41:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qxhqY3oJZmEltYLjKv0+rYGhs7bBk1I6v2J3oCChaYnuCp2rMReuJ7evS/znkpQAryfeDgfWbG2tKs7oAYiU1ltzbscJFWHG6URfKrilUQhLTNe6sgg1Zis4GtiCC/Cqt+gr7gKZxaiGK4WM9f4am7AueW7kP+wMcWaehhW2PMjT9SMSlmPf5bqK4udIMbPnsicMO7X4V7WaVqvAVHe0Uh7xDmg8v/p5L20aH4NQRYR7ohJtvJwSbjeVJRv/ptLXg9OvCSTjXIJuqiV+EIlG1R6MvU2vILie6dqb2/1aRIi6icvR8yRBw0blXh9tyZkH9sYbO3sxCUc3ST33vbQdaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qlwjxabb3gtYKwTcmQxKZ5NGPP73+HIgCeGIcLLYNtg=;
 b=UJGHDXd4TAuDZ9XSi2kX++RkcRT6LgKOL9RSrRbydNDKQmWYfm2+hlTJD02g7KB7Zt0irEbr6rOjwiA+Wk4iYfOT2rGJWECrc3nmpQvdP6bAMRK2enBAm3A3RvgDhvuPdOU4XbpkNIacVG74w+hLig7soiUYfjzZvWALP/6Q2aKQvRvODNqhFCmTVi+LoBpTgBIaP1z42fIgNXQH2u9neeaMTuaydEcUSW4lGNsUWb3Tod7dD2F9LfqIOqQY3a+1l0gBA4KtxWLDDbM2dy5JqYXb7baw1X756pBo2eJ+nHcSr582n5ndoDvorrsBF0NFmXBjLiPPiGpRmZLLXIUhHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7945.namprd11.prod.outlook.com (2603:10b6:930:7b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.17; Fri, 20 Sep
 2024 03:41:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.7982.018; Fri, 20 Sep 2024
 03:41:11 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>, Zhi Wang <zhiw@nvidia.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, Zhi Wang
	<zhiwang@kernel.org>, Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "pratikrajesh.sampat@amd.com"
	<pratikrajesh.sampat@amd.com>, "michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>, "dhaval.giani@amd.com"
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: RE: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Thread-Topic: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Thread-Index: AQHa9WDNQ67YRCpYD0iE+VoTl/u3uLJV3PKAgACLXYCAAENmsIAANPYAgAakQgCAAq2YYA==
Date: Fri, 20 Sep 2024 03:41:11 +0000
Message-ID: <BN9PR11MB52768E32C124EE5876DE3E098C6C2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-12-aik@amd.com>
 <20240913165011.000028f4.zhiwang@kernel.org>
 <66e4b7fabf8df_ae21294c7@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <BN9PR11MB527607712924E6574159C4908C662@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240914081946.000079ae.zhiw@nvidia.com>
 <ZuqvOt1WEn/Pa/wQ@yilunxu-OptiPlex-7050>
In-Reply-To: <ZuqvOt1WEn/Pa/wQ@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7945:EE_
x-ms-office365-filtering-correlation-id: 09045bec-efb1-4481-5f6a-08dcd9261224
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?QhmKbAwPHuqlZeyEiN/IYjT1kwuxfFMLjon4s/V4xXtg8mb2/zs9dQoJ3uwn?=
 =?us-ascii?Q?FjivEOzNyoBHpS/mOg8PxQ6nX4vRMA2UUvDlxQz4TuD6iyCON19dhg+cWLOb?=
 =?us-ascii?Q?b9RLaVqm/2VYsFVaI7eA5O8Scm9C4kspHaX08+sRjOLOgnJqvQvdamXMZ/oq?=
 =?us-ascii?Q?nag3nKI+bnylL1ruij7D8GkjfyCMGrn946sFPYCBtTRiBCHcMl0R2k9RiNp/?=
 =?us-ascii?Q?MHNQTkhxut0aPCpPg3ffk6ybhUmcDiwpM6v3DkIe+5a7XAX33sIj25T/uWQz?=
 =?us-ascii?Q?e3rYT2M+ErW9si3kPM7eMjU4B4wnHe1QXB4dR9IprxQMwXRbbs2DO/RlAHtq?=
 =?us-ascii?Q?zmdm+b89oSUCrt84D8NHR1HE4i15YOWLDVN/pV69wE7ljCkWJTd69lRQGjW8?=
 =?us-ascii?Q?ZcTXNWZKmHDuwEizm1pHSKc0Rkap66ya2z5hOw8C0wIwtjNV6zJ9ufA3ZUwj?=
 =?us-ascii?Q?aIcKHQ+6/TaZ3UQWFPlGlfgNwsoBJhgG9171SIORaqjHnfWefUuAeDBFkN79?=
 =?us-ascii?Q?gNKVG5x+OHfTQIci6wS0DC0CPkhjBd4efwvFR1/Ccj2YYwMdP/Kue+zrrcdQ?=
 =?us-ascii?Q?L5gvH3eVB3CVG7ggbS45e0ZChdSW+hmD6C63P4nv8hmHagelM1y1Jvmjlg0L?=
 =?us-ascii?Q?YlQX1CqvXCHvX2k/aQDvOYacrLuIpVJadyUUPhPiT7jyKsVl/MWoJZXF7oLm?=
 =?us-ascii?Q?YaqFiCp+aZByW/YfeUW/9FcrC73cotQDFMwFpUfwSJFd/vBAt0Cwi0Ml1FMy?=
 =?us-ascii?Q?eeD95gNcbEOgkAjTNzzLYLL4u8Yzvlpk485U9viMj3aW0wwyt8r4m43NxTT1?=
 =?us-ascii?Q?M94banjqGXnm8W7GrZNFvejGxoq4TuO5W4XqjStDcQWNTCIxzxU/64vdz42u?=
 =?us-ascii?Q?W5lzpLMYVNr+ZbYCoAwJ40DAb2syrsju5kon3N6YPzqQ7ytYnJjTdv3XiuC5?=
 =?us-ascii?Q?KXSmLRiqaaUnypsB30qolRqIi0Rp/hf0Fg1wHEmDXDkwomXuP4wh4pDpd4Uz?=
 =?us-ascii?Q?CYsi1g4Sd6XcOBFMEfRoZEtoTz3R1xJCG9r/Hf5WfTtQYcvxYx34wcv9k7Js?=
 =?us-ascii?Q?HmOah8E/LbcoYQ1GpUA5SJ2clauFRc3NAxA8Z09LgYnRWbuUAWPE1RMRCSGf?=
 =?us-ascii?Q?hov6TMFJF+PoyLqmuuxZNzlLwmJqS83xq369O22vz/MPhY9v75L3UgBNutC7?=
 =?us-ascii?Q?09HvZhvtZFSHR/WKemJnjf39vmDtJoFWWValnblo8CiBZ+EjCuR8UjRUZoqJ?=
 =?us-ascii?Q?oRFDncOV+HGULeazaWMVpar2wKnfhTuCea5u+Loqic/7StYC5a2w5IU14xsb?=
 =?us-ascii?Q?k5vjM8ehFgRcVqkfGuNf8fHUu8xNxB0BtL5Jpb3+01yrOmqISne1PowM8PNa?=
 =?us-ascii?Q?JG+Jz5F5eUQ3hmey6yRkLxFTv5yE5tmPclBvCAzQf4H86wZQGg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kXv1RbRScXroWls9nzvp1CMcor967UtpT0EXNUgjMv5s0q6PuFb/YU9Uln0u?=
 =?us-ascii?Q?HqyO+HEgTS3lWn8AYnNzWYK5e+sxOj7+M2sPXgAkuJhKAvG0GjAFeJWGRPPn?=
 =?us-ascii?Q?vSwbjLfYbvc0+N2GGTQQzym7OADM5SXuNOzmFRod5rjDGDdEzdNWbX3vQiEK?=
 =?us-ascii?Q?9zxHaq4rR0Q9tytmdY+MoBsJxlF1HI6mP0OT5eVigytu8EEzqUYipVQJXhLq?=
 =?us-ascii?Q?S8rjJFNWfJMRh1zHhw8uuEMweNvsgOYZ53T7Nm1bpDY9k7kMpDMyGzCluX95?=
 =?us-ascii?Q?EV2oZQvzzFtddST2ZlBPpUTfXnWtQ3kzhCZL9doRg63gOnTu7QF/zTHBXaRL?=
 =?us-ascii?Q?hNAyKhsPYEqnrDLsSTL5Y6T4WUtsjW7MiHUn6f5baVRoRoApDCzcLTD8isyZ?=
 =?us-ascii?Q?2v5PIatcS2hyXuWYB5hzn9KjZWzSdpT6rp7+NyslFd1+H+2YEkIQjddpO9IW?=
 =?us-ascii?Q?IDW4xhyuD6rrntxTYW+aj080NczcPmFpp+9XHU7+2xuwWATk7XBIk1Q1pvQr?=
 =?us-ascii?Q?guUSUr7ccdC5lRkitR1Jy3FGla6wZcOA5vUSAlg4jnj9Uutw7Kxj6fptMh99?=
 =?us-ascii?Q?ACNn2b2JvquR6AKMXfBAo6rIXsUFMAt9DCHixebRcWM/NzHN5VsTKsyvb70X?=
 =?us-ascii?Q?lAUkdRGAd4vBnBVeQdm4Yk6WWyaTozohWKsHb/RGp+5/ayRbyXjtPlShIgWK?=
 =?us-ascii?Q?fPpmU9iwPlDeevwzkRcTZ+leVLJEW+NBM4a8d+qpiZKVRRj6ptzt0UxuKejo?=
 =?us-ascii?Q?Ui4YkZfmSxIvrTSo2NdMtDZbuc8QxrZW3sppqsWMT0KvQt948/ERTDb8OIXK?=
 =?us-ascii?Q?zAtuFdY/5MDECP37pvmaBVitx18+NLT4X695hMVOWFKL+j881nKc2t3hXngz?=
 =?us-ascii?Q?4WlSxmAEEjQISL1HzTOsc4chhSpa5WQhsnd5iRXE2nMjixKrjdwFFqHqkLZJ?=
 =?us-ascii?Q?cKBG2dDD9zW96ncljBabqfCit3YpNyc03hWz+Nbz3RpPYXcKuJMSW93ZAypq?=
 =?us-ascii?Q?Qp2/H2jlfa+haqPO7jXDIu0eRbu7AQs3R3iTEvtJW/EyKQUD3AFDGFGRkAvd?=
 =?us-ascii?Q?+YMBxdGxCroyVFhHk3Dr0q4/m4iR7Uz8ATMIwojqhHqn3fxesxOVb7xsRsaX?=
 =?us-ascii?Q?3eL+9ZxnR42v+9v56oOZg1TUShTvqQZFp+fi8Fv/oT7Z6bguT85WouH5Z1xj?=
 =?us-ascii?Q?ETdlqfKfKQLPc2A1Rrf9Mt6JhUVswjeAUyP9ho5LLbhiNjXuvjcmbn4DvUOm?=
 =?us-ascii?Q?3kUa53rzujW9W6lh2fGpXnXc5Pwind0vwTBxU2gkZ6PvJsrfsxmBubDEeSQk?=
 =?us-ascii?Q?H4L+rr10esfn5rtguMTiO/vdTBlUzFvUNdYlCSvEVm+zAj0fmS4N8vFb4iBh?=
 =?us-ascii?Q?DkH0vNS50BSL+rXQkZrIMr8mtkVR49fDo5pRCFk+vXQjYRjDgIIN/AyxXNRN?=
 =?us-ascii?Q?1j4TGUkt5VLEDvvzJgCjNUc7iBUSmTTMXRMS3AD9yoeqQPqbDZ2y9Cjrs8VQ?=
 =?us-ascii?Q?7u5xa2e1IPj6yij/iFdeefECmltWqZTSrHo23yMewbRntAjad9Bm6pFabkPV?=
 =?us-ascii?Q?gkVz1Eo+8s758cvnJk3JPOKUbTsExI3X8XAWInWi?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 09045bec-efb1-4481-5f6a-08dcd9261224
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2024 03:41:11.5589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b14AQKGksW3J22jWVruBNiOLhFFPtb+A4kwVm+C3NxDCzEkw7V8t4fquDBXC4Q7pema4s7Xqgzb5pdCKtSAbRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7945
X-OriginatorOrg: intel.com

> From: Xu Yilun <yilun.xu@linux.intel.com>
> Sent: Wednesday, September 18, 2024 6:45 PM
>=20
> On Sat, Sep 14, 2024 at 08:19:46AM +0300, Zhi Wang wrote:
> > On Sat, 14 Sep 2024 02:47:27 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > >
> > > The general practice in VFIO is to design things around userspace
> > > driver control over the device w/o assuming the existence of KVM.
> > > When VMM comes to the picture the interaction with KVM is minimized
> > > unless for functional or perf reasons.
> > >
> > > e.g. KVM needs to know whether an assigned device allows non-coherent
> > > DMA for proper cache control, or mdev/new vIOMMU object needs
> > > a reference to struct kvm, etc.
> > >
> > > sometimes frequent trap-emulates is too costly then KVM/VFIO may
> > > enable in-kernel acceleration to skip Qemu via eventfd, but in
> > > this case the slow-path via Qemu has been firstly implemented.
> > >
> > > Ideally BIND/UNBIND is not a frequent operation, so falling back to
> > > Qemu in a longer path is not a real problem. If no specific
> > > functionality or security reason for doing it in-kernel, I'm inclined
> > > to agree with Zhi here (though not about complexity).
>=20
> I agree GHCx BIND/UNBIND been routed to QEMU, cause there are host side
> cross module managements for BIND/UNBIND. E.g. IOMMUFD page table
> switching, VFIO side settings that builds host side TDI context & LOCK
> TDI.
>=20
> But I do support other GHCx calls between BIND/UNBIND been directly
> route to TSM low-level. E.g. get device interface report, get device
> certification/measurement, TDISP RUN. It is because these communications
> are purely for CoCo-VM, firmware and TDI. Host is totally out of its
> business and worth nothing to pass these requirements to QEMU/VFIO and
> still back into TSM low-level.
>=20

sure. If VFIO is conceptually irrelevant to an operation it's certainly
right to skip it.

