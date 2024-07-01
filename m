Return-Path: <kvm+bounces-20769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61BA291DA48
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 10:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84FA01C2178F
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 08:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5A983A06;
	Mon,  1 Jul 2024 08:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WhS9nFTm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5772B59155;
	Mon,  1 Jul 2024 08:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719823421; cv=fail; b=J3YaWxKBNTBpYtZbxN1P7CFWPJ+BmT6zAW65fGGpxVO60H8B25qHnjs7DALbg9NZzKXB1ptsqD1hbGuCkyIe9AH94fjjbvGxzHuwn5QKmuYj7xSe/SaEGr7ey8E/6A00PG+jU5oZMBwT9WrkHpHnjvejmZfoWtbbEx1U5hvAkjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719823421; c=relaxed/simple;
	bh=7TBo8jvUpgZbaCiq/QPVaLtXVP2tlbp7fKqdePR4ygc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F8s+6FZqe7ElBQ8/NVV2wvcXFB0fpi7Hj8Jssyn+BPnVmfCQB5nHxaoVTWIqqqD6k3Hkxf80+FFvwY5cZo2kakLbjAvUZOgBe622N0u6dhKGRd5IKc4owXGxNTaPObW+dbBP9rKqK4ZmrIBu55U4tfc5k5c5pM1U3YC51U0mrdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WhS9nFTm; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719823420; x=1751359420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7TBo8jvUpgZbaCiq/QPVaLtXVP2tlbp7fKqdePR4ygc=;
  b=WhS9nFTmy17F0aIRtmIM5+YC+IIxLdnHXK0XVbXuWFhuItI8XfhlZQ5O
   IiGce6juGAKTqSfN8Kk/54sUct0tLgFL9OOdqTuGwx9/hTd3gAH2uiFFX
   BIf7mm4uMuVzKDdCLxjo+yD9cZxF2/kx0EpFl7iGK+BnCPCyDDN7dgUOT
   R8rmi1yaLqShzeCgi0PnNT8dcFQ7xUfF5E34JcnnsHUOqPB1I1ytzThyz
   Ljb//tl5Hb/71XRwHKtX7rqFDgIfns0/zUlYEU3qiQzwRCFdAZq1IIsum
   tiRo2pRI9dL3uBfKFgp/NT2YThF78LmpnT7alO499lRNXpCQlHmUIZCI5
   w==;
X-CSE-ConnectionGUID: B/+6ufsSRE6+7KVYkJP6Bw==
X-CSE-MsgGUID: WXPYn7+lT4CsSClQ3BhuaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="17071968"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="17071968"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 01:43:09 -0700
X-CSE-ConnectionGUID: b3iCvvpoTOiTUiZrMnDWPQ==
X-CSE-MsgGUID: IPJ71IPYSSCx/Q3y7E3TFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="49915111"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Jul 2024 01:43:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 01:43:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 01:43:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 01:43:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 01:43:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwNhVfUYHOMwkL3oxl6t4Kfwj6Y5zE5vr3r1pOOmt3GdEcAKi34jHdtZa8yPEj7C4mWnLe5R/e53pnoJLMnVDmCnQJzAVXF1P6mOfVjJ6dufiJe7rKP8ZuJbj2G85OZYroEWVMRTSbRB/LRm5NaVf9pgQ9G2e7XPSRQnx4nvHQPoUPSOM+itEt9vU4m6DZ0KItQGe7xLuApDecgwLsLdc4M0RDYqLa8+ZLHljWbsEjQydgBebYDm96K189z6GQHRvFmGdng3/egvJaDWx6YW/XlzL4y17VS/9OzHYvKcTErDYWE4J+OqGEeq26enJ8LYdmyW0tua+iX1tGAIGGlIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnzkF4cnHhKjDOQ4JDdEhnQ+lAS2EwVpywOmfU2Av4Q=;
 b=O7/6F/sAWJ09uta7VK2J8350R5xLWBIglVvfFqPp70+6VVbE9PW2ZVUmdLYkz4pk99FAZuwtxkIUXnA065Gug0tmowIg3kVEs88gCCKycyQysxVJfx+VLdmp/W9J+YK8T+47ahY8TF36dG+W9KsZBWxf5kPYTjs9TLTicRFePAW5ocBdsuIoz8em6a56L/qMG2eXYdCddzj8OmCflSSIlOAVHdr0cqqMwbLvhVAVwollosIWROO1Q5GgkWyRH/EJYI3iRL+UdMP5LZLWhkF/jP8LtS82eLj8Uzn7q+tv2DEjOobgE+O2PhQeLnMBLY0N91EX0/XtVR57EFSi/QmSEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33; Mon, 1 Jul
 2024 08:43:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7719.029; Mon, 1 Jul 2024
 08:43:04 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH] vfio: Get/put KVM only for the first/last
 vfio_df_open/close in cdev path
Thread-Topic: [PATCH] vfio: Get/put KVM only for the first/last
 vfio_df_open/close in cdev path
Thread-Index: AQHayW6q9Ma1HJkB/EOYHWiKOaLUf7HhiCJA
Date: Mon, 1 Jul 2024 08:43:04 +0000
Message-ID: <BN9PR11MB5276059EAED001D833949DF88CD32@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240628151845.22166-1-yan.y.zhao@intel.com>
In-Reply-To: <20240628151845.22166-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5175:EE_
x-ms-office365-filtering-correlation-id: 57b3fc2f-03cc-4afb-5091-08dc99a9d2df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?uRf5W8xv7pXkXUPwF443J80ic9YdvAnRPhQ2Go8mTYwKRNaHIO6zz+piCRe9?=
 =?us-ascii?Q?pZFqb6vCo5U/CNWPvAYXVdZGdmXNHgSo41aB5PrYR2l1VJzubaDO9GQXbMnX?=
 =?us-ascii?Q?rg6mUfGk/pQfGDB3xm6vXdkPoTUrw5oPhUoLkVTgWtqnN/YG1/FshoiCl8vj?=
 =?us-ascii?Q?shWdaqsAlggyPcxk31DuAcB8xqcP5Ei4sujJvwe0sNeGV++okaBY11KCJ2Q8?=
 =?us-ascii?Q?4u7NsMg3SPawYNIGJfVeURrwbG5moTC8xBqFhHaEATThio81SFNj6hGw0RQg?=
 =?us-ascii?Q?KtROXcP8oJ4oFw8lPrMXaJaTxyAXtbvwxItI+0Dazhnk6MqfgPaZm41Lq/gq?=
 =?us-ascii?Q?IeB7k8VopX+xeS8PQFl7Na4XQf1vJRbhlJUpMq1QY1ysS24ldWFup/E3ei+V?=
 =?us-ascii?Q?AqjWF5WmmdRzg9eurfOeXB0irFkqeWRSEHAhmVlCIH5p8SZw658CfmsOGG2H?=
 =?us-ascii?Q?Q/ni3Gs0sA0O9ctMUDNNwvflLdy+YSAf35atCIFaNSbDIeEl+mNZyS9Wdu7A?=
 =?us-ascii?Q?gD4tErrXgkHRbPXePMFhzrkTjMtHd1UGpQj0MNwyh6E0u3YlzFvaj2K8HaY/?=
 =?us-ascii?Q?BTlSzymOncpvf2c0huuEU4AijZ3IkgsMYqnSycenn4Y27JcfofXnt16rfvD4?=
 =?us-ascii?Q?a8PkbjriLO2HHVXBjflfzeFd4Q+vAT7BhWc2+nLsk+JMiAdAa47KbctCji12?=
 =?us-ascii?Q?NCrPJjwHsJKz3u+cZcFyPFkxesNShZTYhB1mliQ1MqqueIBDN7QRvPlU+IsC?=
 =?us-ascii?Q?JtQ96PraLldpeGYlkoJZtCRpJhMvfGRtlLJRHbrYAu47j8s15W+DSEa0eSis?=
 =?us-ascii?Q?OIafPSfYEV7hpPvwb9RovNmBe83kPjMmIajmW/kRgawoyJnZjRdRLepoO+4m?=
 =?us-ascii?Q?wZe9n8usbtanVhl96a6X8QOH9MNDxgkxmGchnBJ56ThPTXUGigEOwxVRoSZg?=
 =?us-ascii?Q?b7JihUgOqKAekiGZVVut+g55yjDavy5WNNFdwndxUJoC9H+3bAENwJDKfmnZ?=
 =?us-ascii?Q?TeBKOxa5t2OJ+m1FLaNFUDNBNNnE7iDLxAVjObEcwXZLA6qBwUQ/VVPuVonh?=
 =?us-ascii?Q?lWD/JHODqwrAPXmQkodmT0NWC7JOBnBEoPndOW6eG6YdMAsL1/IUZjLfs78C?=
 =?us-ascii?Q?x5dJXf8yIUkpudzuAhR8mLRoEUzBds8BfPsMTH1sYtmNJiRQ7OBqysyRP7qE?=
 =?us-ascii?Q?T+yj17ilgJQANTOo0Sw53MAEJWo0y6MMzpFrdv9a1Tp+JIlyFD309Ih3yxjy?=
 =?us-ascii?Q?s5QZ5qUmI9EFfcPl48txBr89XePmGifF0J13IzMXYfnV2WUvyZTRUFjhOVeA?=
 =?us-ascii?Q?HVXQb6bOkYa0rms9HLwy2jsiT2iAPZPqGCKixNh6FhP4eRZLaFt5j7OXe6ci?=
 =?us-ascii?Q?i+q77l+muxuYujLaWGNUzhTgloRKHX3vxM2jHHkEQBaRVM79nw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GVomcQtNPCvcveqer4ejFZFIsomgSLqVGVaABXictXBmMcwU+XAXmxbB/A8G?=
 =?us-ascii?Q?BpgIxQoeSwvi0MumGm/XNBqqYT05qWYmZG8AZz2v12517OBuXSDxEQTc5A62?=
 =?us-ascii?Q?4ZlRLgoElXmlJAwbNkBzVUThQGh/bLAY2Z75YIDOMVX5uInbK6oWTaAkBc49?=
 =?us-ascii?Q?9WsCir2HMNUB3ql1oR6IdIdVhyjO3+rSDmeUsoiH826Z8HGCKGnKXtSi1Lev?=
 =?us-ascii?Q?kXjzSdB2CKFUE6VSVyVbgWTFlCLK/mkOwxK3IZXyA26qsnDjff2w3sTwaWOM?=
 =?us-ascii?Q?Y9iovOYbeAVwC6nENEYBCII+P5vo5slSwncCuUdjvQg5KLA75yIyA7wkvXaG?=
 =?us-ascii?Q?j/EduC4N0bInXGChKL7pNKACKbdctiNJdMLUe04pgIaknSWVWLmsHze/TMau?=
 =?us-ascii?Q?wuhWIYGwohVd0Fk57wb/VBVaCiAOVnOQCKojG+G7olo/EhxsJWLUhYSocVG/?=
 =?us-ascii?Q?qRHW6GDAfiRcOpTX6jP39zAY7aHEQ0qhh7ZjfcKdsdugvkjBUNImI18aHAO+?=
 =?us-ascii?Q?PPkCeCYfUK/4tojfGgdNBimVKqxop3ZeMeLFicXluG/VnSMou5RhuO5fPglg?=
 =?us-ascii?Q?2ehQ7qr0GdVeY7btW/ynsPtK0StLEByAuXhUwJ3ylprrQOFPXGu+Vp704riL?=
 =?us-ascii?Q?6tyDQrf8aHJ0GUtiH0WSthURozeIaQPCEtNNaNY7wAXtwlDbzy42KDso/Dk3?=
 =?us-ascii?Q?c8Bt03twMMzu+tQb8atzce3ZpozAVXGptsqOtBDXayHOdxHy7tdOMTnw3MI+?=
 =?us-ascii?Q?0nzrfBsoysJmgIzIzw/hoB9r/H4zPwUSwiswZiKOJGAqk06i9wnEP/J9JD61?=
 =?us-ascii?Q?TjrFQDTNNWLnN6gH4ut+KBMJ/vQoGo4JOJ5qSy0eWOtmawwcy2ef2oFvQdwU?=
 =?us-ascii?Q?x201KgKvsnLKRuE8HV0pFvvsp+oQKoULZnSJi4J6pMMpuwHW+D6gBbRsepT8?=
 =?us-ascii?Q?NOGoAEEAi88I0lIO7dLnmsUg30RE+bI/WSwWlN9meQuLuJ5W8Fn/JmL+4qLl?=
 =?us-ascii?Q?PTF5GBf3wxUgczb5Rqm/28UASlpoAfvsaPBhJiGdswy4LElXtjjfrHTg2TVR?=
 =?us-ascii?Q?f8JAq2baUeqThw4lAgdmiN6zgmiWdW4yCANvZR0epvpPaJXE7W/k9VQ4W26M?=
 =?us-ascii?Q?IQuF4gTAmA/aTN/6U4mYHwyVzlPZL4PGUuIXYt45fHwJyyz8j33oX0CpYTv4?=
 =?us-ascii?Q?UF00hfCWJL7jZfdanKTWwzwmBLAhzXh+hjcUQSNCToM3UTC7XaVFADq+4lJp?=
 =?us-ascii?Q?nWHg5B06X14ySMhe59TYRofAcYodWR4OZ9QJ5KTI7PHkWvz+FxvNVgB5vQz2?=
 =?us-ascii?Q?70rZmnP8Jb+aUqpGrQh2OBVcHcipp/IFn2o+VMGGUzR+seBzDJcOf821AKuW?=
 =?us-ascii?Q?2eBk1knDgYsgSSgu+z9lk6wwInZT4fAzxIGdiMQdckq9WBNGnLzKNJ40M029?=
 =?us-ascii?Q?mXejslEFmCBvxozSzLXMmVE5Cq3MRp8eH2GWcSs/cqsQujbSm19sS148cidu?=
 =?us-ascii?Q?EaPM9Ooi9iRCGVYSz4ShSTOVaB1qBXpX844CCFU3vETRlJoA5WqG+9ysu1tf?=
 =?us-ascii?Q?GeI2xOHpZbIEJ6W4VZNV+YfG2+innlxvsgITzugv?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b3fc2f-03cc-4afb-5091-08dc99a9d2df
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2024 08:43:04.6000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zktMvjtmiS+QgzjP3B8zGSMIWLJx2I548OFsyx6Zf6uYRZbNV7mH+MF0qOVkglRb1mZS6o4/tInHvLyy91wAOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5175
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Friday, June 28, 2024 11:19 PM
>=20
> In the device cdev path, adjust the handling of the KVM reference count t=
o
> only increment with the first vfio_df_open() and decrement after the fina=
l
> vfio_df_close(). This change addresses a KVM reference leak that occurs
> when a device cdev file is opened multiple times and attempts to bind to
> iommufd repeatedly.
>=20
> Currently, vfio_df_get_kvm_safe() is invoked prior to each vfio_df_open()
> in the cdev path during iommufd binding. The corresponding
> vfio_device_put_kvm() is executed either when iommufd is unbound or if an
> error occurs during the binding process.
>=20
> However, issues arise when a device binds to iommufd more than once. The
> second vfio_df_open() will fail during iommufd binding, and
> vfio_device_put_kvm() will be triggered, setting device->kvm to NULL.
> Consequently, when iommufd is unbound from the first successfully bound
> device, vfio_device_put_kvm() becomes ineffective, leading to a leak in t=
he
> KVM reference count.

To be accurate this happens only when two binds are issued via different=20
fds otherwise below check will happen earlier when two binds are in a
same fd:

	/* one device cannot be bound twice */
	if (df->access_granted) {
		ret =3D -EINVAL;
		goto out_unlock;
	}

>=20
> Below is the calltrace that will be produced in this scenario when the KV=
M
> module is unloaded afterwards, reporting "BUG kvm_vcpu (Tainted: G S):
> Objects remaining in kvm_vcpu on __kmem_cache_shutdown()".
>=20
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x80/0xc0
>  slab_err+0xb0/0xf0
>  ? __kmem_cache_shutdown+0xc1/0x4e0
>  ? rcu_is_watching+0x11/0x50
>  ? lock_acquired+0x144/0x3c0
>  __kmem_cache_shutdown+0x1b7/0x4e0
>  kmem_cache_destroy+0xa6/0x260
>  kvm_exit+0x80/0xc0 [kvm]
>  vmx_exit+0xe/0x20 [kvm_intel]
>  __x64_sys_delete_module+0x143/0x250
>  ? ktime_get_coarse_real_ts64+0xd3/0xe0
>  ? syscall_trace_enter+0x143/0x210
>  do_syscall_64+0x6f/0x140
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>=20
> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index bb1817bd4ff3..3b85d01d1b27 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -65,6 +65,7 @@ long vfio_df_ioctl_bind_iommufd(struct
> vfio_device_file *df,
>  {
>  	struct vfio_device *device =3D df->device;
>  	struct vfio_device_bind_iommufd bind;
> +	bool put_kvm =3D false;
>  	unsigned long minsz;
>  	int ret;
>=20
> @@ -101,12 +102,15 @@ long vfio_df_ioctl_bind_iommufd(struct
> vfio_device_file *df,
>  	}
>=20
>  	/*
> -	 * Before the device open, get the KVM pointer currently
> +	 * Before the device's first open, get the KVM pointer currently
>  	 * associated with the device file (if there is) and obtain
> -	 * a reference.  This reference is held until device closed.
> +	 * a reference.  This reference is held until device's last closed.
>  	 * Save the pointer in the device for use by drivers.
>  	 */
> -	vfio_df_get_kvm_safe(df);
> +	if (device->open_count =3D=3D 0) {
> +		vfio_df_get_kvm_safe(df);
> +		put_kvm =3D true;
> +	}
>=20
>  	ret =3D vfio_df_open(df);
>  	if (ret)
> @@ -129,7 +133,8 @@ long vfio_df_ioctl_bind_iommufd(struct
> vfio_device_file *df,
>  out_close_device:
>  	vfio_df_close(df);
>  out_put_kvm:
> -	vfio_device_put_kvm(device);
> +	if (put_kvm)
> +		vfio_device_put_kvm(device);
>  	iommufd_ctx_put(df->iommufd);
>  	df->iommufd =3D NULL;
>  out_unlock:
>=20

what about extending vfio_df_open() to unify the get/put_kvm()
and open_count trick in one place?

int vfio_df_open(struct vfio_device_file *df, struct kvm *kvm,
	spinlock_t *kvm_ref_lock)
{
	struct vfio_device *device =3D df->device;
	int ret =3D 0;
=09
	lockdep_assert_held(&device->dev_set->lock);

	if (device->open_count =3D=3D 0) {
		spin_lock(kvm_ref_lock);
		vfio_device_get_kvm_safe(device, kvm);
		spin_unlock(kvm_ref_lock);
	}

	/*
	 * Only the group path allows the device to be opened multiple
	 * times.  The device cdev path doesn't have a secure way for it.
	 */
	if (device->open_count !=3D 0 && !df->group)
		return -EINVAL;

	device->open_count++;
	if (device->open_count =3D=3D 1) {
		ret =3D vfio_df_device_first_open(df);
		if (ret)
			device->open_count--;
	}

	if (ret)
		vfio_device_put_kvm(device);
	return ret;
}

void vfio_df_close(struct vfio_device_file *df)
{
 	struct vfio_device *device =3D df->device;

	lockdep_assert_held(&device->dev_set->lock);

	vfio_assert_device_open(device);
	if (device->open_count =3D=3D 1) {
		vfio_df_device_last_close(df);
		vfio_device_put_kvm(device);
	}
	device->open_count--;
}

