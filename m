Return-Path: <kvm+bounces-18256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B0C38D2AC3
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 04:25:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6158282F7E
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 02:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EC415B0E5;
	Wed, 29 May 2024 02:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kW2T20JA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA7F2AEFD;
	Wed, 29 May 2024 02:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716949539; cv=fail; b=ZYxQJ2Rl+qEJKSz2hjsR5dVQJi2K6ZyYUogRDpx4h4phq2rsIfiqjSobL4TSTcC0DKGDMI0FfK4clt1AgjsDRqcVuJNfECrFHeu7h0RJFUogYvx9mxdva7kC87E6JWWoagkIqzL1mNBYUsYg8qq0eyU0jVQ344UbcjV+wnK0ADE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716949539; c=relaxed/simple;
	bh=GyvZj4BOizvOH0Ddx0c5TPbz+syRTe/PkzBERCokuPA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=un39lA1ckb1VYX/FB5TXtWXGoVs3lzIKmMCNUCdDdUsVXy50fvE0nFN9b/r/iCD6SVp+L6ZteLtUmLdfwN4S4OcWYEbE5A5OYs+B5jM6N7s+6dyQtkZW0EOgUo2Vy/nyDEC5fHghwalNacenlRZT/+c63n4KeCUcGMox90kJXag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kW2T20JA; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716949538; x=1748485538;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GyvZj4BOizvOH0Ddx0c5TPbz+syRTe/PkzBERCokuPA=;
  b=kW2T20JArvC8PTz76+abhCHmKcAET3+vxnkQ5kPN0H+/or9QmzOGmkVa
   CtiUHs0pe5YjHVfZFTgXutNYlxcgv9BnpSiDNfnAR26wYi8Jd1kf2UgCG
   GakPxsXLwtfAfsrO3TgpXbt8DbPAX1JrW4rrpTNEzjLa+tX1j9dYYggki
   0XYTmlQyp9jzxCQ1Q0UOL5nHjGvdnkCjuLy2ZfszZiW/JsVOQWoHAjN2d
   BVmJcUWka8syLX3XR8WmkFMkOUee6I60R4z7g/v5oFfzkkbpR+bcWsfQR
   +Ak2nN0I6Xc39xjIoJVq96BUdDavCCV4IBxtVm1cqS8Ojxf7wbeBQTmz5
   w==;
X-CSE-ConnectionGUID: /q+kj3lERKePwRBkKL9Gdw==
X-CSE-MsgGUID: gsWHJlkHQ2ero6TYbGifrg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="24460172"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="24460172"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 19:25:37 -0700
X-CSE-ConnectionGUID: dKEhkWCTSdGBYQEy+gj/Qg==
X-CSE-MsgGUID: mIQc8YwoSDKVp+0AiiF/wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="58450025"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 19:25:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 19:25:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 19:25:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 19:25:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcJjoZW9QqB1wwQwt+RQZUBc6yyec+RCf2RxwS3xUmf7iLuurFxoCjFo/DToUFO+Ho2sBq/TLFD05VnZ3XfFZ36dVnlJpvxFatZRi08vPiQ8F6kHTLxYlCC0NEvYstpeq4c0WVSty1j6RiYCG3RXLAjghw+shbTm66j7v/7bjN9hssj4dgnFDkqgWlC1XXXzvCdJuwQU70FJUGx+yxlLsoeUMGMpZxNwaoCsroYekjr5LfpO0sK6/CoWSQDRFApZs/RzhsezB8uCbsVZMvWV3J6zDXDF4WY95ObBKqzdSWY81uCenxxl+gWHBbTjJ6/fChnkaZV76VIZBWI/vdhtjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ww/gyKmRTmcL8eENZx0ObaScx60bFF7hcXPN8dZ1LIs=;
 b=hW+jIwwJiwiEjwkU3NDskcyC6HhCbH+dG1PCIGnMQHGzP8W8aUC7nUk49x1vxXt0wZMnfjiAEhpmji7LQOZHy+bGC+1aod7jVP3B86Ga/9eZlKcXi9/mY8L78madzRCQKNTVpLWssLKnpzgplDOi2VNyai1NePKemju7hCQqu9zrxp9Z67ucvJUHsAqB9IzA7e9zarlJcg/xg5VTUzeGc+n77+KyPLWxSo5p/DGy4+Tvm97qYYrZNat0+biKg3ieu7Mr2Br6z15qKXmPr+mzDdS+5qO8jH+GT+g3EalCPhIdjHPEYjR3I6zBeDS7XH6dSMMDBkypyKMVdtyupV8f6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7092.namprd11.prod.outlook.com (2603:10b6:806:29b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Wed, 29 May
 2024 02:25:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 02:25:29 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Arnd Bergmann <arnd@kernel.org>, "Zeng, Xin" <xin.zeng@intel.com>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Cao, Yahui" <yahui.cao@intel.com>
CC: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/qat: add PCI_IOV dependency
Thread-Topic: [PATCH] vfio/qat: add PCI_IOV dependency
Thread-Index: AQHasPdozFJ7uzjsf0GWpzSyP9bM07GteM2g
Date: Wed, 29 May 2024 02:25:29 +0000
Message-ID: <BN9PR11MB5276C0C078CF069F2BBE01018CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240528120501.3382554-1-arnd@kernel.org>
In-Reply-To: <20240528120501.3382554-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7092:EE_
x-ms-office365-filtering-correlation-id: dda5e284-19f1-4030-56ca-08dc7f869b84
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?pjaYEF3Rgb1ZcC2SHUzwNvxWvu4pKYFPONZMPsKCy4yXgQAGvSJHcY0ZEdVB?=
 =?us-ascii?Q?i0dAi8ijL3s30kQ5yA6FG8NRCw5Q7MKWGjfrNcN0eb9XOi/2uVUFx+N1+m66?=
 =?us-ascii?Q?rSSt4mPsW0OXzxHOe1xdQtA7fCn+O5mfoFQqrQQVMNNinRIJjkEs0+JIAubA?=
 =?us-ascii?Q?z/vf/Htfet2uPnIWUs8hHpqsOk15n4mmAsl+uWHstubHfoaOmoB8+H5ABofp?=
 =?us-ascii?Q?iy29jom7norkkGXoc5bksEEORNiw8ATo4nk9qPbF0OUtYvEmVAfIkTCI5Ymi?=
 =?us-ascii?Q?JERVwLQRKwxfKuLiGCTSJ2YuaUrHznAkA3zg0uXRpqTffuglwjqg6NmuzLUP?=
 =?us-ascii?Q?TPMFtkevsa5kBe+y3BCiS1RBZJ4l4X7g6yS75oAD37nk/OIT2SldOl861zdy?=
 =?us-ascii?Q?xxST7Q60JblkweYeDQVDIb1Jtjt91vM+qOpfv9sxRSsfP3M95luBeq4lCDBb?=
 =?us-ascii?Q?ngBXTRgWCHHNH9mvXrMHvtibr9QuLKfxWlDuPRtji8Is1Ttem5NLa64dMp4i?=
 =?us-ascii?Q?2TMTQsggBYGrA5SUP+QSNtYsmDqNyYgd+Jfox6NNX1bXsWczu8MrsYAykq4+?=
 =?us-ascii?Q?4WeSS+BELKTZUf0mIqn0q6auP4xW/FU1o+FsAU/Vnpuo8YWdbjBxh+XCvuzw?=
 =?us-ascii?Q?vrp0qWF+OaixDrtKyaDrqJoU9Cd3xbiMOYNpgKr8iqQeVmpPspeQdRFWjQ8b?=
 =?us-ascii?Q?NpUfxkHV4Km+mCS98kqNzv51v1uitZd3fUUVxWwHkNouK9UmllqmqVYVAGQG?=
 =?us-ascii?Q?RTHHIy1kdsjjL7S8ET1b//bWGNImDl+3onfbIISa4q1MAjY/qLsw6cL9M8dI?=
 =?us-ascii?Q?+JwKflPkyc+uJG7QkZ5nQWHb9/b9kRvIJMDI/YEoA0frr2gC5BfBnwiSgdbo?=
 =?us-ascii?Q?d5bTcGG6iA9N6JYu3zwjp34B4FEYNqvQqZ21Q/Xzi8/bVY3CTjQfO3CbcHMC?=
 =?us-ascii?Q?NPf1rnmBGhkP8WMcw84DrjZxMgcKp3JEXU1OL5aQU6iyDLtuHWvRsSFhEsUu?=
 =?us-ascii?Q?HWeT/3iiR8Bug5GFB4bVTbNkiShyW1thmoUSVYhObpSvPUG1RvTqqHFKa5cF?=
 =?us-ascii?Q?19NpWlAnwRDNM9dtEaB37+s9ddonIcYWvI2bPDojEv2ZHznf5KQNUbZqyz0I?=
 =?us-ascii?Q?QRWjeBqPzZGPXrd+cPAUu0/et+a4MJEJTCcA4cHLJeF6oFebnD/1v12AZo0e?=
 =?us-ascii?Q?04bvCsm4+hT860yUr4HujbG3ZQYntCcKyeC/E1XYyWuEMgjPFwJIkmFM6+Vj?=
 =?us-ascii?Q?HzdELTWwXtMPoneCKrBB2LvzkUVGjlRMi8e6Zpxr3lBYW708KDQfigi36nRM?=
 =?us-ascii?Q?o1MPOYrUqF79IAxaxo9GLm/eGysGIODyDb5rfr2Y7Wa5Ig=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6smgDZupVub64Ps81keQ/P525EMvRf96RV6oGzRz8lO1xcxDdQFrY3+SE2B/?=
 =?us-ascii?Q?wT2BVWe89fu4pFj6glAfxpHWO16r4V7nBHHWl797eC1c0JVPfM1Zcek+Q6Hp?=
 =?us-ascii?Q?HKyqaZeBmbR0JeKPOBWWFmsEi/5LZ1rORteWI5FlHI4RdbnKTEab4g0UExiU?=
 =?us-ascii?Q?Qe0TZlz9SX0Y0CIxjfRHSA64k1+u8ZkfbL9pIUFGUp3S+Y5nI3DbF/LHtACL?=
 =?us-ascii?Q?qVQa5MyZMmw9AyHyZ5tWYQzUSMjlaTk7s2Z+WDrFLpAKGZpIt7NVSUD/zvjF?=
 =?us-ascii?Q?qlMwcyDGY/C5yMom7eBwm/4oVPAKtn+etqm2R/kEVy4Y/WmwzgXRRz/11FK/?=
 =?us-ascii?Q?+vBkJlDljjPSqw1UQ1sb84g1xaVZfSgofd/fXtj1hf8GLY3UoYO5vTIcKu5G?=
 =?us-ascii?Q?WH40lT8u1VHFHvfF4XaUyBF5+lUlDi0bwUr7hvsPKncdGMg8R14JfrQv+1fF?=
 =?us-ascii?Q?IJ7ajceLHLHF34/zXNCiWoVbqFFqoU1FvZnlqsHSgZMgO0J31QqCJI1q2e50?=
 =?us-ascii?Q?KZLnPNfYaV5iP/5fwJyu13kdOopWTOMAOng7CJy7RmiuDqeDQRp370pNRJma?=
 =?us-ascii?Q?aMp2W3RJ/5f4PMAgYRdVEZ0bKy8CR2v1wcMuoL+3jlFs/1l++pzufp8h8naP?=
 =?us-ascii?Q?Pw691V5xmGxJnkhlnmdJcYN6vGkMq0dKmuUjvT+MS8DaQgnP+YvGVuHUl8Iw?=
 =?us-ascii?Q?fBUS+vDgPEjkSf+oMK8In8ENS13Jm2k6iAuQZSpBFNDFK7DkeH3AdHaUGkUj?=
 =?us-ascii?Q?mpSh8ypzBWIgIGDLxp03udy0HJ7ovD2P2nMAktfnzWgATcHtT1V0R8TbO+e8?=
 =?us-ascii?Q?A4JvnezBPP9v7eUq9rSj0lxc60eZwR2+LgcJ/jreiXfGfwuZRRd6941sop1d?=
 =?us-ascii?Q?8TgZEo1q3fj50cJ22p487bAo87IKoyc+To1TrTvAIwcH/3O2kABV8GXsRSmO?=
 =?us-ascii?Q?ZOrby7ypUhTr+KvGZ0W8cFQsnhWE9Xcx/SLssBYHsISd6Piis7EeRfJNEGst?=
 =?us-ascii?Q?FbS/pnXR1ORCawI3RGDpJAcSF5btezT0vfVyAcWP7/o85IwRV6YgVlHnY75L?=
 =?us-ascii?Q?ZPgfPS5xaP3nWZm2lVFhzWnBlbc/9l3K1Bsz+Iub28vgaijmZGKAb4AWwBKe?=
 =?us-ascii?Q?Judvz94oyosqhxTYdfyBfcmVph/LgY+YomzkZgTctXuD/rgLnxkq17qc7+KB?=
 =?us-ascii?Q?0TPAVV8mkd5XXv/8BlniTq4TRQVDFyeOQY3LkYgUs16MqhhkYfrv6fHVChNu?=
 =?us-ascii?Q?QP/P5l7fwhfiuEYntOcf/0AEqWh54L1gT5WGrVjMWgCBTBkRjIae5KJQ7pWv?=
 =?us-ascii?Q?lhwlitsWEei4zDzzzdXwToiDPKGF9Ezcr8vQMfgcNGWp91DlFO7QZcktLXNF?=
 =?us-ascii?Q?BdB14WbJZjCKx4R1pw7d6uVObcT8+U54j+9S/lgF4zTB6Pymm4mMqYDCDIrc?=
 =?us-ascii?Q?cT7Hdr1UZAAGOXzI1MiSA9fBvMaTnSJZKblgHgfqm5+SeqH8FrjoosOQ71ze?=
 =?us-ascii?Q?O2Xtt4lUWtDJPmTaZUK5QaP9mLU2HP0h53DIsYNU0cawiDeOsmmdF00RaSUc?=
 =?us-ascii?Q?XW/xBBwsYQe+AGvYBQJ6hL8iskGyd/U5dFF7+KI5?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dda5e284-19f1-4030-56ca-08dc7f869b84
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 02:25:29.1122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iJozdHQL11zo1KzwbX8Vi0mRsq01uKR2HlEVv/ns7RcMOuERYwPVZKxEZNP46QtAXNtPla59nqNrTrbsjKm+qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7092
X-OriginatorOrg: intel.com

> From: Arnd Bergmann <arnd@kernel.org>
> Sent: Tuesday, May 28, 2024 8:05 PM
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The newly added driver depends on the crypto driver, but it uses exported
> symbols that are only available when IOV is also turned on:
>=20
> x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function
> `qat_vf_pci_open_device':
> main.c:(.text+0xd7): undefined reference to `qat_vfmig_open'
> x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function
> `qat_vf_pci_release_dev':
> main.c:(.text+0x122): undefined reference to `qat_vfmig_cleanup'
> x86_64-linux-ld: main.c:(.text+0x12d): undefined reference to
> `qat_vfmig_destroy'
> x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function
> `qat_vf_resume_write':
> main.c:(.text+0x308): undefined reference to `qat_vfmig_load_setup'
> x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function
> `qat_vf_save_device_data':
> main.c:(.text+0x64c): undefined reference to `qat_vfmig_save_state'
> x86_64-linux-ld: main.c:(.text+0x677): undefined reference to
> `qat_vfmig_save_setup'
> x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function
> `qat_vf_pci_aer_reset_done':
> main.c:(.text+0x82d): undefined reference to `qat_vfmig_reset'
> x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function
> `qat_vf_pci_close_device':
> main.c:(.text+0x862): undefined reference to `qat_vfmig_close'
> x86_64-linux-ld: drivers/vfio/pci/qat/main.o: in function
> `qat_vf_pci_set_device_state':
> main.c:(.text+0x9af): undefined reference to `qat_vfmig_suspend'
> x86_64-linux-ld: main.c:(.text+0xa14): undefined reference to
> `qat_vfmig_save_state'
> x86_64-linux-ld: main.c:(.text+0xb37): undefined reference to
> `qat_vfmig_resume'
> x86_64-linux-ld: main.c:(.text+0xbc7): undefined reference to
> `qat_vfmig_load_state'

at a glance those undefined symbols don't use any symbol under
IOV. They are just wrappers to certain callbacks registered by
by respective qat drivers which support migration.

Probably they'd better be moved out of CONFIG_PCI_IOV in
"drivers/crypto/intel/qat/qat_common/Makefile" to remove
this dependency in vfio variant driver.

>=20
> Add this as a second dependency.
>=20
> Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV =
VF
> devices")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/vfio/pci/qat/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/qat/Kconfig b/drivers/vfio/pci/qat/Kconfig
> index bf52cfa4b595..fae9d6cb8ccb 100644
> --- a/drivers/vfio/pci/qat/Kconfig
> +++ b/drivers/vfio/pci/qat/Kconfig
> @@ -1,8 +1,9 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config QAT_VFIO_PCI
>  	tristate "VFIO support for QAT VF PCI devices"
> -	select VFIO_PCI_CORE
>  	depends on CRYPTO_DEV_QAT_4XXX
> +	depends on PCI_IOV
> +	select VFIO_PCI_CORE
>  	help
>  	  This provides migration support for Intel(R) QAT Virtual Function
>  	  using the VFIO framework.
> --
> 2.39.2


