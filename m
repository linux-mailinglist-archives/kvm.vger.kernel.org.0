Return-Path: <kvm+bounces-42795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8CDA7D36B
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77864188C7C9
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 05:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB582222A0;
	Mon,  7 Apr 2025 05:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L2Y3nepr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094E08494;
	Mon,  7 Apr 2025 05:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003375; cv=fail; b=hxf2D7HaGY+LoN5/VIXWL5WkbFvycPP8XWvIOw0kj/seD6Bh94xyzP9Or3ei//GKYlQgCuduMFO355L+aNGXuyYXl0UTd4HvFBXNrWHrHjbfq7bM4pfXln76SFzJ+d9w91Ni1RXjPhMoZ0qgtfU/d/GKowKgH+sfybYFX0xM2lM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003375; c=relaxed/simple;
	bh=Bl/AJmltPvRBRPeyzPauFdNQpv2qA9ezD1oG5zT7Uhk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i44ghsYyPSux/ufTPQL5DJbf59qVs6zGFa2En3qiCQhpdS9sy9MgWdGl0KU4BwqxeWoGz22fzmhE66c3FeZKZZ2ASZ6w9HO08M/3RKKppHYuVkbKHPno48u2PSgsmoTRcWj0d5p3JSYp9s5M4DzMDqLwELfeqOR6hWtHePyad3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L2Y3nepr; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744003374; x=1775539374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bl/AJmltPvRBRPeyzPauFdNQpv2qA9ezD1oG5zT7Uhk=;
  b=L2Y3nepr+tI9X4Wv67Qv1hv0GzTQCZbZWl+Ixvwj9nlfrle8Jd7LJO1c
   SYv41mkRlEySF1Skq4j2Ms+OZDP60Pw1jacqU4LxbpUxXOsVTZppXMra5
   QWEAChdCKAHmHCRxkh1SYYQoYu+YiPzVpTJDZ7y3OXQRlxNM7SQfqcHmq
   HwSnbj0aW1KzSMQ2casnKI1vmukfkdx6FVNdDZ/g2R+F/6GUWX1MZFMos
   4uquf2HFJi5dL4hXNLhBm+UIbmUU/UlQQCl9kyj0unuw5OC7nacgAxCVg
   cCQp8hzV0Ew6BblYLbaAt6YsRL3FiMsRbAkkvtfDvfu/o65nt0URxmPuC
   w==;
X-CSE-ConnectionGUID: LxqJn/TaTXCb6HD6nbBDhw==
X-CSE-MsgGUID: Gq4KuUw8T/Cs8NRy13W51w==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="48084232"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="48084232"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2025 22:22:53 -0700
X-CSE-ConnectionGUID: FjGxo1ggRnGiaojqKlVHag==
X-CSE-MsgGUID: h/Q5Ks9ETFqd4feRLOPXSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128708006"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2025 22:22:53 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Sun, 6 Apr 2025 22:22:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 6 Apr 2025 22:22:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 6 Apr 2025 22:22:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pjB9npWRKWlcnEQVHp7333+Vqa/o3K59QwmZbjIR3cXDuNo04A6l3rMumDtRBji2LUHh/oGQzF2auT+Za+f3TdR1/HNJX0LPrbIEOC660nT2jQLKv7XoYc+abyVnXmjdr836cT5CcaxG/yVuAg+Axt8OqVGhu6SjlWVtOcqUBdlbMpRtilDm2m5KvkkLiwCcamX44S0lTTG/6btcxBSM0f/jGpY3FNgMJv2TSAxyHoDjplFEhKk+eKPAeCN768LWeHTxouoHQ3MAIFvFEcD3m5YezkOdOxv0OC1sRIQEdLpbFiiXzbqR13caUe1wbIv/gfIkxghix/KHKRcgN0sKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bl/AJmltPvRBRPeyzPauFdNQpv2qA9ezD1oG5zT7Uhk=;
 b=UTEJIHJf3RnzRsUX4OuXvCgs4bzEDFmY3gln0Ymfv6yM0E+ggafXscat9d0BSOLNW0TT1JMVvsVjkQaH/jNeyAVBvplcYh+MayXMzIdERoghXFuaDmFwrsFui+7i4tPOK8tDQproYBQsZnOzRC6x2VGS9rB5SX7UTM2/FXLIGGdVFGVTFQMGPEhdQUDl++N2TM0wNnFBKCuEQKPeHTOv/GCtFa/AxeLMqSwZD5maLzRnLD889OAgSa+gGKgTbqx2b4YPSHOHiwcam4hqWa9VOa56e2Dxe12tC3dWz0wvKO+M8S78+I8I8oY5WSwtrhowvDKOY7V5Bb3Duo1hiUOAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5942.namprd11.prod.outlook.com (2603:10b6:510:13e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.32; Mon, 7 Apr
 2025 05:22:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Mon, 7 Apr 2025
 05:22:49 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>, Alex Williamson
	<alex.williamson@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, nd <nd@arm.com>, Philipp Stanner
	<pstanner@redhat.com>, Yunxiang Li <Yunxiang.Li@amd.com>, "Dr. David Alan
 Gilbert" <linux@treblig.org>, Ankit Agrawal <ankita@nvidia.com>, "open
 list:VFIO DRIVER" <kvm@vger.kernel.org>, Dhruv Tripathi
	<Dhruv.Tripathi@arm.com>, "Nagarahalli, Honnappa"
	<Honnappa.Nagarahalli@arm.com>, Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index: AQHbhLKIOMwFCrbJIEmx0MTBFQvwabNjFiyAgACMrACAAC5ngIAAUDEAgAsZQcCAH9vhAIAI2HFw
Date: Mon, 7 Apr 2025 05:22:49 +0000
Message-ID: <BN9PR11MB5276424BAA968DF29C3D4B8F8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
 <20250304141447.GY5011@ziepe.ca>
 <PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <BN9PR11MB5276468F5963137D5E734CB78CD02@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250401141138.GE186258@ziepe.ca>
In-Reply-To: <20250401141138.GE186258@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB5942:EE_
x-ms-office365-filtering-correlation-id: a701779f-25a8-40f6-79d9-08dd75943ce4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?IwOXqUOTo5fRrfstbxFA+1vS6JHtae7TVaQAQ5GRJrU9fHUgJBU3cllD48PB?=
 =?us-ascii?Q?3VZt9+ZdQJUVRwLd3gKvkYrVizA/I3dxaW1aautEAtaoUm1TiXi2PeE+/k2b?=
 =?us-ascii?Q?2Xnhmy06uapNELhjzBdakt25SyqO9JzVJXqGi4y3+qYlBQl1pIFHXwdndEvh?=
 =?us-ascii?Q?FkOK4maeexfKmtAYFCJCkHtLBfp1lU7wluc4ygqJaQWZIH96F/whM03f2pky?=
 =?us-ascii?Q?J8GZOKRK1UJNzJ1SnflKdspE9GrogHuXasIKFrIjSb9nHr9fuuAeQNgsX5jp?=
 =?us-ascii?Q?ATMdJtJaBHRLTkkMx7sOYKS3bFjeGlERHLaMJ/XWi27SF3nxMVO4DWbuk8eB?=
 =?us-ascii?Q?e1fzfKnEq4lAYtUK37YwTewLDuP9nW4xiZa+N7P7uQJLkpTucLMZeb+BtwCo?=
 =?us-ascii?Q?Rb4sEuadUd82rtJhh+sRyeiTIapjx8poE3cD4iFDtM9Uro9m2Qt99x+V1wOa?=
 =?us-ascii?Q?AeBKUuHvQLQUlA89512gukZ55ROiHHuvRodyEBHhMqXAW5ysHJ3b3E37Bxm7?=
 =?us-ascii?Q?+rY/evfdy45gAm5czQ79VFGaQw7/HskISZkU6ocirurUbSRY8gdMfYTGiOXY?=
 =?us-ascii?Q?MJN/uqo2n/WrbDi5okZ9djZKeHPGvkHmLiGiINup5jwTdp2c03hmVNI00Uxn?=
 =?us-ascii?Q?j44DrvZ4OaqVvvt7YtaqYSq1y2JQW2sPgEh7l3e2K87Or9HdjRPdBspNuWp7?=
 =?us-ascii?Q?aBi6LA0GiW22VSRtHq7x2lLgjMmOFKprMOfTTAsX2Wcs5obE/0ByT9EOd+Nb?=
 =?us-ascii?Q?wKxccZpqgkguz0ltjNOlk7waaTJ5RVmqfVyfB/Ar1zn7EgVu7VTyMPIWa8eB?=
 =?us-ascii?Q?FT6AagachXDOrdpESYO4gc83zSfYqr4QOr7dckzqAmAnvL9UQKi3zDUq/HAA?=
 =?us-ascii?Q?Rtoklbc0aKDa/mDzCbJvV7tHuKaItCBg16nce5DnDnmoAhBKsu3QSfPqq5N4?=
 =?us-ascii?Q?LEQ1qMQvcDztsLsyUOpFhlveeynnR6GMPtmcRbkFDUwkV6uzRY1LCuridlok?=
 =?us-ascii?Q?M7+7zc7+grCT/ZRwidObu2AwQYjtfPa8qtiCbdkriE1d4/DyC0FIjCLc5vfn?=
 =?us-ascii?Q?7Vt7Q7bL9bq5xwUXQbJH11HTW7KO/UwkORah0fmTXcKBveaVAUs84Ssi6Wr1?=
 =?us-ascii?Q?hrbffiGGcg8eGz9lcxzCgrqqegFi9Lfm/J5w+0hHB37+fgqoaZad+iy31ejL?=
 =?us-ascii?Q?ljGluVwPjLowL3IzCmbM69fxHYrnnf8O5lRJuvMViqSyVp6J5P6xVVlRRRUP?=
 =?us-ascii?Q?lATC52D6pAEX9lQEkgjzF8ZEveMFvJNSOgbWXDo/wg7NWVUZtjLdKF7ZcVFk?=
 =?us-ascii?Q?CbHEKmWOuckgDDr+yzRjetiLodWo/PiR7sseHN6pNH2qMORSwUtsEUGa0Iqy?=
 =?us-ascii?Q?yoVFIgiRpJ3UYikCYb7mBYT2zfb4y+yS4yzxVBa2mZb+dEUqrdBRn9Y7XFeq?=
 =?us-ascii?Q?M/3RpPfdD7mGh1aeq9D4nAS7z5V7tDUt?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vB41hcRDFJvlmIBfGnNPal3cujY955XighDyjqzyb8eZicftwHFGG7c2W635?=
 =?us-ascii?Q?2JDG7b2Kvd37ZTMGu82crkZHED6rZtQEZKtFLbJBHx0EcV62wYKF5dpuFLy4?=
 =?us-ascii?Q?LFub4cTsk3I8BJMdOTM+NFinRaUnQMbtKXOL2cXRhmJTX63pfat5K7tQOLE2?=
 =?us-ascii?Q?M1tFcsqBMVLJ6rfv7UxahvabKfbTPIltbCLdpTxfxOj4F0BBIea52cAa3toR?=
 =?us-ascii?Q?OPfZ0bsDvt9odtxY1O+lJBxue3uSF1gCiiP4ZS3KpnCzj98BBzrRV/eC2rJ0?=
 =?us-ascii?Q?NO9z1zxH5QdRtfQV4cvoTO6JFKPN78dbb2PDANgwVafifpkd5mkNI7bfVBM9?=
 =?us-ascii?Q?422B5rlhEEe5XLuLMnstpDaea+Of4HMZpoh3OC0qFo/jzD6dcFIpVoKZd6iX?=
 =?us-ascii?Q?5erfvLsVn3RAEgsujrxCHevAHtZih5d03cyrAVF87om/f85aVefCiAII+mrG?=
 =?us-ascii?Q?Q88U//DIden2RFxBDYXbsfm0K599kd1OVa4vsmWK609SoMtJTgXSsc+PwqE+?=
 =?us-ascii?Q?I39g8Va8tLKlKjXyi8bbWtQN6gjubk2BkCCjtFJK0FBbLSpdKlDL6FZmUjBw?=
 =?us-ascii?Q?rwrzo0lQke/BQ/M+arhRaB8OqFliP2Llq4D7YXeCPwlOgu5ENJAiprj374ky?=
 =?us-ascii?Q?md11oL0Qryg/rywf+72poXm1d156KOJE1A1QE5/bZtCxBgEeOrtZKLvVV9zT?=
 =?us-ascii?Q?vmghXq+2pjugP3DN9bvjPG2dC9eH2pG0WKJHIx/RRKOcS0zc4K6PvnbkMgDo?=
 =?us-ascii?Q?RdulOndr16ygJGiea4jFmNtBMATs8xwWmUgT/VvV25zyxLNRy1j8QBypBfr/?=
 =?us-ascii?Q?3AUYIj9mTycvgts6JeMp3dwSmTLqNJqtpyu985bewfB2ZTCju/3QHoOWt/f3?=
 =?us-ascii?Q?nD+QosfSjoKxM65Aj8rGgIdubZZsOtPe6Y4Q2r0cUClw0rUN8fCPodcRvnh6?=
 =?us-ascii?Q?xVTWDhTUzW2qznmbtJDqZmrj9luf+/mds+Tep+VPYAmFQcbnwdGQgNYrdo8b?=
 =?us-ascii?Q?rH1xs2zin9G48V8gNa6jOPHOuklx1zgVPukUz8WWNLgDi8SIKPvLIIXf4Y5s?=
 =?us-ascii?Q?TqFAWcqacR8oEz8qOWyiqDfb9wxVW+nhmkzf7CK/JRvtmNjwTEjly4YSRbkN?=
 =?us-ascii?Q?nKGxw3aDMqNwavZx6VRIpIJEEVU7KI+LfOMVpxNAkcLWnHKLJ5JK3eDtvLfJ?=
 =?us-ascii?Q?zLIL2jpL6lQWK7I5BJRbnUKU4Ohb1EQ8J0tCFhJpOGi6MWaaW478T43OUx9S?=
 =?us-ascii?Q?58VpR+gWLySdl68NQ4N368da2Z5qiHf38uWsfn1by18HaYRzNWpZzEfaGlda?=
 =?us-ascii?Q?Lun0ZcYxtuVuEY1JiE66aBFxxuNdIeToQHjJ+CSrb0evdKTDlDM9CEE6UZvn?=
 =?us-ascii?Q?ET/4N7rGkbeWZgQ+hIhWM/mHpOOjgujKBDcW0t1i5wVOin+mLeL0GXp37Hwv?=
 =?us-ascii?Q?bXC326+7Z92ai6xwI+9EWdWoP3HFb2Ljg5tD5i22z/Soao0B1QkTunbY2Nwp?=
 =?us-ascii?Q?1wsaV2smoKQeqxZWc6y30ASX4fOCZRPeXvTLWFUEhERHPIuN78UN5P8upGj2?=
 =?us-ascii?Q?nG5MIkVhJiV4crYLeUoYsfaEPcHqTbQbxtNSaLMA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a701779f-25a8-40f6-79d9-08dd75943ce4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2025 05:22:49.3529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ojV/V6N/AvOfe9WfDR0XXxrlRr9NGcs9yUWVUKHlPMubrIl28+TW1lo9hcaooXdViGFHOralGqRfPi996/tCqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5942
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, April 1, 2025 10:12 PM
>=20
> On Wed, Mar 12, 2025 at 07:53:17AM +0000, Tian, Kevin wrote:
>=20
> > Probably we should not allow device-specific mode unless the user is
> > capable of CAP_SYS_RAWIO? It allows an user to pollute caches on
> > CPUs which its processes are not affined to, hence could easily break
> > SLAs which CSPs try to achieve...
>=20
> I'm not sure this is within the threat model for VFIO though..
>=20
> qemu or the operator needs to deal with this by not permiting such
> HW to go into a VM.

it could be used by native app e.g. dpdk.

>=20
> Really we can't block device specific mode anyhow because we can't
> even discover it on the kernel side..
>=20

hmm the TPH capability reports which steering modes (no st,
irq vector, or device specific) are supported by a device. and the
mode must be selected explicitly when sw enables the capability.

so policy-wise vfio could advocate/enforce that only the interrupt
vector mode is supported for non-privileged users.

