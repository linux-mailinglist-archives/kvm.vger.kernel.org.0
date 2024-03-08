Return-Path: <kvm+bounces-11363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE7C875EE7
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:56:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C09BF1F23262
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 475774F8A2;
	Fri,  8 Mar 2024 07:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JjleRlaf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D6A22F11;
	Fri,  8 Mar 2024 07:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709884584; cv=fail; b=KVCfhFSVz9umBl/agPAsFn/32zTwooVngx1bbTpLZT05ThHlU4RdXJWggcCN/xgvbRhy1mwFK7XDOePdk0Ovy8idVsuz8WrAN/KfSb5xnxh2/W+Plo7cyD4zxiPx43uUDZc5L6T1I4PwCVgm2rwYkyA3/45zuuuIZsCgKsSc3W8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709884584; c=relaxed/simple;
	bh=MReAVH50D/i7ok3JxbGQS83hwpMRvkbFdJ8Om0K12ns=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fw6A+Sw940uStdcjPSVN65DiCgmVlbvq0t8ygNA6uYeEsNeV7uYuvgSrzven5eyxvCvWIrX6wsQ7FwIHLg3akC/vsme+RC/i/qkLg7SmQTF3I2psqHHOIU4I/LF0s8snQDf+7SNu/kvd9l3IwsYjyWlUQeBR/OOxXxpGVzwmMlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JjleRlaf; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709884583; x=1741420583;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MReAVH50D/i7ok3JxbGQS83hwpMRvkbFdJ8Om0K12ns=;
  b=JjleRlafNqsM20rUd6R5gOWPdEkK+TWvqS/nRPR8p0J5ITZMYZVUfq2Y
   8uYuyTJkGSQh90KFiPfFLLxmWKlN68ltufgjGtXV6UNeH3fArs/gGHQQH
   IpRL10ioGmw0EVWeorYk2pombpuL9DpOWTHmVmCzj3wftTn4GvTP3M1WL
   SxRABOvLjvXjqvIhQBww6XsPGV2rdu+7vkt+mlG4KOw9fl+EwzHpHUOZ6
   vCY/h6eQngiO2Y59KdAmBMWoWlYYvP50W8pVOBlH3KH9zEaIIH1eMBImf
   PlmWArw6hwGK1OUk8FgM5Xr41wEf/pu4/7XxK2VNfW+oMrXIezb4VoinI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="30036645"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="30036645"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:56:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="10938341"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 23:56:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:56:21 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 23:56:21 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 23:56:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WT2F9CTTg4RGgRcXCbnJebiWjfUTv3xE1U9F6Nqp4/hZ1GFsmshnhQTaizUHEy1j7CSldLs3uBlH4elW4XkWX19KhwKHj4pIxUfrM+58wcCGe6d+EnDkbrzaTuhHoHuzNe6aucVCYa0eTeDazZQHCR4jTyoV/8DKiZgOU3gF7wasygAqZUcY4GPJ9u6frUR6JAwrISR7GarZIHQh8oom9yzX+Ig4mE1APT5W/N2OD5TjHm6q3wWSUIujIE9oG+qs5BoG8eoc1b4iMRWLTKPdp9cONMq/r4Xqx8yuF1jvo4OqcLhvvttAYazCPVex9JlVbOjNoDSCYCxHtHl3fmdyJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MReAVH50D/i7ok3JxbGQS83hwpMRvkbFdJ8Om0K12ns=;
 b=MnbnL4bHxKNnJF29peeqI53s9UmiaZadzg1d8Dv8+gMcUM5aQzUvd1HV/MItfcE/16Yo8gkgjVoRga7Qqb8UzXUL0jusyVUzglXNBOLWLVvH3gnTOfLR1YfVnYuiYKDca6RcP7hRZ9mtc9BvzVH6aeG0ZSPGiPcCHxs7oPMVbIr0/NwpJHY56SgT4a+3Q/NIvX+d18r17tPZ2HSK2wBlNMecEUflmKu5YMhYFNc7lzX+G4ZBz9eQggcRQzLsvYrou8hEJI8HsIAaFRP9jgagY/ePjX2ui7udFBIoFEaDSfnSh/p70quydAZLSWWeu+G/JcxWpyEENcsWyZsNbz+enw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 07:56:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 07:56:18 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zeng, Xin" <xin.zeng@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH v5 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH v5 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHab8/CZzEAY4bT50qLepUwBk799LEtfA+Q
Date: Fri, 8 Mar 2024 07:56:18 +0000
Message-ID: <BN9PR11MB52765A3A24BA7767EBFBCDFC8C272@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
 <20240306135855.4123535-11-xin.zeng@intel.com>
In-Reply-To: <20240306135855.4123535-11-xin.zeng@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5896:EE_
x-ms-office365-filtering-correlation-id: a58f67c6-57a5-4f3e-7d0c-08dc3f453c9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e5+AF930d051Xbt20JK4s242RNLF5rZ+j0XG4mWQvCJEi5o8oDqjmTmDh3mx01S11onm/KKbxNU8OHd3++9zNEVQLgTEN4EeL0P8aDiBehm9ilDbAfXovomMRstB5OPdbWnHLnh1qZD/K1R21Wpe3lYE1+L0pgDixURoBaFkom5R9ak3LOcrg+qiBwcJ6mJkXiDRWLh159Ft1IkDAC7TxtU9wVxc1q4w9k77OvjReXygvWkFy5IXz0EzuYxT3/dGxfIgkYhsg8FJ7wy2tRWNesHI8tXlshIuxJ4Qq84/ywyHUB+H5fxIXdK08fYWJ5vVPpBnf9LQBKS5iK+RcrtE1+mk7/dSrRWUY6WOrUk4ZW/npsNs8BrDSrMcWQ6if1GsYrxFson3lDgi2wIMLri0Nr/BjGo2ukUBSQuC4buov0JHhUguYn93Nr94KL95Z+NhPM61EJKppnsga3jpyzwEn1veXEWq8aSsN3YaTh8CNjS3HRUDe7TZIDwl633NUZiVR+FVRcMNOwaZvZLNbbOdZRLmtLzaOYc2Nt/P0CTFHdZxrXR7KM7blDXwyNAd2OQE8E5YTdrXNc6mEBz0gnM1/0uX69BE1Uv7p2saFDELKwgAgzKCHQZ0qjV3Cw5XtZrsBATZnJGPRyqxjr8AxdGOInUw29VXzWPhGe08gr9hqU3apbwcfjj7Rk817zCH18codY68EJszs2oAV2ghH5i52w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qq85aTbmzTzlVRLAJZUdIgv6tYcNgPCv6LusHO1OSRBYEcwx+DBPAkhE6AW9?=
 =?us-ascii?Q?4Ut5L5ZZcVg6Xb09DU5JGnROLUsURXnr0n41eYHJMLCxlDsecNbq9cHLE4mP?=
 =?us-ascii?Q?NtWJ3SEb7zzbu9VRqOA0myPTrcq3V7HjDa51ppHyrJp98roMNfjSbWJ1PU1s?=
 =?us-ascii?Q?XaIBm//NJDVl5UQyJwSfmZYZoqyH9Moa/sZpM9/kXOBqy+FVmLqYdZumrd3R?=
 =?us-ascii?Q?CXq+rKlQGnjRkMknjGE2V5Re3xqfLePKjNUQkjxpTm2pWO3h/U4/krq2n8vC?=
 =?us-ascii?Q?z0vV5eJvMFg+JB2HoW62t7cqEP4bATDqHRzGL5+T3T6ZJIv4rCtWytpnpYgp?=
 =?us-ascii?Q?zd2FNgAG2kpk9vn1HuRB/3tS5G6zoXf5tmc54kh6+uChxPSocE/hpGZ789sE?=
 =?us-ascii?Q?JWvBebCXcwXs2JqN9BYqPli10Mp00En7c7eyPJrCQTeu2TM4pCRuaaclFe0z?=
 =?us-ascii?Q?EJFA9eCmtr6e2hJCuZBYuk03jD/IJz9pFDGVvrasogyieShQp/X5ZjRg3CtN?=
 =?us-ascii?Q?yOe4a95D1Vlm7jEb8WkmGNqy21y9aKxDOvA9WVbBhUOHxCjW07Lp4jnEtSmM?=
 =?us-ascii?Q?ycLaKuB/1+AprjVrQx7LH5IewGuVLcxqwycW7EuyNi9znsLlD3p1ebr4yUET?=
 =?us-ascii?Q?RI60Bu7aDL8q2CbNdGVzIXlDnhVA5AfxvD6mf/wbJhegv3e9o2wpFrtoikCB?=
 =?us-ascii?Q?VoI6d6PZv1oiiAj6j8zYr2p9DV3p66xH4ECdOjvQIp+7qMQFP37A+efHnIop?=
 =?us-ascii?Q?gkOH3ZaZD+5O75M3m2nt2mmA01uKeAeFFxjqebfkeYcTldg2cfkU3trCbNTt?=
 =?us-ascii?Q?iUn5FKhTXW1+YtDDRFhRzWXamtrS3nPvq764Wc9g416ShRTQE/AVYay6K0k9?=
 =?us-ascii?Q?1fIvhfEpi2MMbKUZ377RNmuvffXk7WhAsmgLACp+VAeyB+mSgBIkWyck1wOt?=
 =?us-ascii?Q?b+gtDONjGT7VdnsZvkhFW7YMuhQkUT1Pj030YomZOQbgcbB8RPhvefNy/A2Z?=
 =?us-ascii?Q?hiwaCfGJQMw+Q8LS48gqoHY/33+RQr02E0UmDggXe4m/eNVwn2Ja+ECPBtL8?=
 =?us-ascii?Q?1m4VgRb6RX695SVtMAt2oBw+KvC+BO14SiAdUfCPI2GqtKB8KsocOr3f6izy?=
 =?us-ascii?Q?BAFd796/aAhFI8Fw3KTOX8zEd2nmIB/oXUI8Q12Lh5jsceT9Pd8VVCpzDQE0?=
 =?us-ascii?Q?jjkBxSoJi4L/JzmB+B+ovX95HaOIbaqQFlALth39W/PQQd4u79MnTq7Abiwx?=
 =?us-ascii?Q?sfJHoIOlHtl5mcB7pDzEu1ECVFIAjCW9zNXWghIw8T511JK6Ie2AyRlbMbPe?=
 =?us-ascii?Q?Ka+hLkTxdOiNuq3j9+lV7YQcILFrvqofqwnfAw9uZQnDuJQUDC9yMY/ShNTZ?=
 =?us-ascii?Q?dkcwIuuzWoklEbIPQDcvvuJcChJoKwzPg3kypr12LagpGOAlqFBJBBotMlz7?=
 =?us-ascii?Q?UaiLc2RydptMoSgvcd1nxe4FOwMkfJMxYvEMn1ITwbO+2T+T2l7ZcZFLRvWW?=
 =?us-ascii?Q?itUgey5TQu4YrIEFNdbECvJDEr7GC5Y2DObic6tBg0mFmocD9ZicT+7dgj4U?=
 =?us-ascii?Q?3pikivM5AI8QbEggzPTqEvdrDwZwEm4OroxlkSoB?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a58f67c6-57a5-4f3e-7d0c-08dc3f453c9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 07:56:18.1536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1f3tw1ph6ABUkQksaIxrMEPSPblGBpJ9J5x+c1lRFPxqH5CI6cVZ3sH45uuJb8XADBqGhjMaTYcBt8N+hhBrmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5896
X-OriginatorOrg: intel.com

> From: Zeng, Xin <xin.zeng@intel.com>
> Sent: Wednesday, March 6, 2024 9:59 PM
>=20
> Add vfio pci driver for Intel QAT VF devices.
>=20
> This driver uses vfio_pci_core to register to the VFIO subsystem. It
> acts as a vfio agent and interacts with the QAT PF driver to implement
> VF live migration.
>=20
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

If Alex doesn't require closing the ID matching open before merging
this:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

