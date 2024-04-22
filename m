Return-Path: <kvm+bounces-15515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFCD8ACF62
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 16:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 928FF283D7A
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 846CA1514C8;
	Mon, 22 Apr 2024 14:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X/UL/sWl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E115122625;
	Mon, 22 Apr 2024 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713796155; cv=fail; b=Q/Sv1im36NDQDypTumhfRubTHhjYYQAC6u+735l2+0fOTTJIF6YyT6kIYGk5X5xJZvrDzQquKZyrEI2TkIR/U3yLYa6f+6q8vAnYwRwOGKH1ByHM0RgCvf8MKzGYQ9P9t5a0bKHOKDO4xSyPL6gnXaHfg8fOkdWku+2A312Uin0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713796155; c=relaxed/simple;
	bh=xnEZg8IQmV9yvJdGddbEkgHjt5YS3GrKwgYGA1swLIM=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IZIZ07fZhPTD7u1RScYZfMUm+q7fJv5TzEq9IHjVSlNZm8txb9FYvTt2MCAX/6Bb0wXKKiZ686I1EhluiU7V4mPQyANH9sI7uZgLpXMHiS3LSTR7HeJzGbXRn7Ul2lJdwJrIvbD7nTG402fOaBBLUeEzY6zH5irPiIuMfgsPk1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X/UL/sWl; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713796153; x=1745332153;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=xnEZg8IQmV9yvJdGddbEkgHjt5YS3GrKwgYGA1swLIM=;
  b=X/UL/sWlm1NBSiBjxDYBv6ngsBpicZYAyGboWXNtlG3U6nRxQWrHcDog
   gLPzna/PhCvDOU7cnEZft9WoQu+PjH3GXEVV5TEGeUgu27i49djPOlws0
   XgwX1mK9J1uHyqJqaIi9xmXYVOR/I0IqSOKyYDNWQig8wqtc3z42R9XmO
   PBt5226ujNg0JpU49pptS/CZcoBWe47DdGyYDhLaJgiZAOmCVrLvpBtRD
   b2QxADbJjiHtv0yy/fVYanMQkAs1Gggc2zLbjAcY+PXsxVaeWP+2Ugt9M
   T+e3arpqqiIO096zPcvAR3Q0xPmK6i5t5Z8XE9O4286rSpzx/jyR9k14u
   A==;
X-CSE-ConnectionGUID: nH+vUbVzTV6+HklZhzHBIQ==
X-CSE-MsgGUID: 2dIGeOFYQjCVzbVVDB6cXA==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="13117126"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="13117126"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 07:26:43 -0700
X-CSE-ConnectionGUID: VE3SPw0LRP6hUDFwlnEKVQ==
X-CSE-MsgGUID: o2Q+vhWMRI6ykMu1mvoh7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="28543973"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 07:26:42 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 07:26:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 07:26:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 07:26:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 07:26:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c27RkUZutEb/o2JFxxMJMJape7kxUL0Jj4fh9Dq2u2TGnjYzmZl6y6SPRMlcZxOAdaRinzlZW98O1vFuTdsAOjMORvCJlovRUQxl5Qi1O6hUrR+TYx9qhBWQFxIogPjrPWTiED5hdJ1lndh7Ok49M3DTLDU2xrEhBQM74jPZ+vJ8XjfEPVZps2wQdGFGlcUgDfdm8BQadUpM9IBkV0gcyyOn5+Ojh4a36QVqnHsD1CMisfwSDsi/jiA8HWjNW46sORqggeazxMQAE39oPqTcAb0wBLD6MvTnVHP9jujYu7objw0E4XBTZBxd4/aAUMheV1q7WCAMCSxfhg+snyK04g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Nu4W9Y1XlMKyhTxu5Hwf+DExfYws3whP6olsxmB+FE=;
 b=T8nN35yW52SbOIC4Z2OW9FbNvrW75pJ7pi9M/V729QjQQ4N0mOoyRACjDrttwfmxm9QATfzroU23qbkeXKLtGL6N951alLRerkNOeN+qY/sm4plHimSRDG/5e3rsY0GQ0FgSeodWPUfIWgyFdLA2YiAa8BiPhs3ckfOmU5AcMC1a2b9OytpziXNEzyLeVGds+2AIcwTg5IwhUmIiY9aM3fL9w1SeCpRG9tYvs6B8uz0NyNpo6F5ZGFC41PXcwsvpzbT6trr8sWjuRfVpqBvp29Tc5NGU5RSsaR4wM9F/Uta1pwEjMp+u2+0enQl5LnfCmOFQlBq1ycl6zRemkHI2Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW4PR11MB6982.namprd11.prod.outlook.com (2603:10b6:303:228::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Mon, 22 Apr
 2024 14:26:38 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e%3]) with mapi id 15.20.7519.020; Mon, 22 Apr 2024
 14:26:38 +0000
Date: Mon, 22 Apr 2024 22:26:23 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Ilpo
 =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, Jason Wang
	<jasowang@redhat.com>, <virtualization@lists.linux.dev>, Richard Weinberger
	<richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, "Johannes
 Berg" <johannes@sipsolutions.net>, Hans de Goede <hdegoede@redhat.com>, Vadim
 Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck
	<cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, "Eric Farman"
	<farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, "Vasily Gorbik"
	<gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, "David Hildenbrand"
	<david@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	<linux-um@lists.infradead.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-remoteproc@vger.kernel.org>, <linux-s390@vger.kernel.org>,
	<kvm@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [PATCH vhost v8 6/6] virtio_ring: simplify the parameters of the
 funcs related to vring_create/new_virtqueue()
Message-ID: <202404221626.b938f1d6-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240411023528.10914-7-xuanzhuo@linux.alibaba.com>
X-ClientProxiedBy: SG2PR06CA0191.apcprd06.prod.outlook.com (2603:1096:4:1::23)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW4PR11MB6982:EE_
X-MS-Office365-Filtering-Correlation-Id: 96f8bd01-2ca9-4232-928a-08dc62d838ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0FS4VgIPuycHJAZn3EAsvA8ucw8RiN14lih0IfUd/DNzFxuB9iyjtzq69q7c?=
 =?us-ascii?Q?9TlwBlOFLbyhSH/kvDC3PsfXqpyTB376IS49aNdoyA7j/WKZfBhKU0ABnzV1?=
 =?us-ascii?Q?YfQLyYiCC3HtKukRMcDCC19NggcPynq6UnGiG0QK6dk/oAzmotw+NsC6RmBF?=
 =?us-ascii?Q?cXmPQju92egmq1aysgOzo3qdy/YFFcyx5Hbv3jFmX0o08LmqXMlj624L9OYE?=
 =?us-ascii?Q?Tv52KK2JGka9pfTCFjUsZCINgG8Yzh1I+iP8qetHmECpGOGBJXR9V8DwsQoU?=
 =?us-ascii?Q?pxTrhQgB4omDvgeyw/CRT5NKSNUDNFDOiza/w5nbMrr/U55ohWiUomYtTZLd?=
 =?us-ascii?Q?oI+yJKZ9t8VQcruK59ugIm/E7VsIyaYdseWxvfCKks4rP59rEX6nJF/h7vjj?=
 =?us-ascii?Q?0mmxl3m/IH9odo9VJ7dm/JIKQFCbhkvJdnMhB1OHKPIGWjNH3gzsvuXLiIoC?=
 =?us-ascii?Q?2d7DHvOrql1kTgYhCpthXd0xyy3Ymx/h3jMxF5fB+HD8pkeHJJMh+z4ypCMW?=
 =?us-ascii?Q?i9ywJpzBp1e5pZqjzO7RJFLHsnBgnHvM2LfoD0X1WrWaY3doCeXSE1+pBTp2?=
 =?us-ascii?Q?JtMeIY6cSyCCXG8Ht8MANYunh9Q0itzkfh+1pFXh+7vouXj32i1MzQ1WEIen?=
 =?us-ascii?Q?Z4EiaI4HsdcyMIzvmt4YSDMbfHRmHe4CVZd3ZIvVeTc6khoy4u4pC3PkhPlF?=
 =?us-ascii?Q?nQB2nrr0hAzxWIPrw60IYQT4OZsmP1z0fBktZrHoXpFTbXqGdy/K5bZTnrCU?=
 =?us-ascii?Q?tws+z/qVUGm7akAkjHveWxFrmelzhTy+dKKUc6TLsNZtHNP9ilkRpFMLB3lD?=
 =?us-ascii?Q?K2RUZyYaKcj/rjRNHjORk9Z2CdFH6o3h5n6tsh0H3AHBimDm2d71QNmGvbjO?=
 =?us-ascii?Q?NxkD7saxi1+04uiTRUCihf+rwI+Km6ymZ4S/l9V919E9KEJbwzeqlYghN6wM?=
 =?us-ascii?Q?FeIOXfLy65NrdsNIyk1a23Z4mocZhz+h7LHXYITARw6RU3Zycw8I926VFUWp?=
 =?us-ascii?Q?dnG9fKzV2OQR92CI7Gg4vpdLlCxcWyYIhDRZS1MT9kakcHoM2nGOA4sGZXFq?=
 =?us-ascii?Q?8MjMWN6zkq4zKOwYxJ0uWVA/6ebf65wtSxiDAwT1MpUJ7fAV4fPPbsM0bcQy?=
 =?us-ascii?Q?ILq+T4z/MiM1O3eY2x8uekq23IjvJAEsWplzQXmQzwwMWj0D22Nqc2b3FzgS?=
 =?us-ascii?Q?jXHswVz8gpoXzzS4zDF/ofbKkQVhBGzEiWv29VsRc9YsU8Y4yDD6XwMXxHU?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xCDVpyZ9sAWJ9qfEQ9BdpkoaMyk3T3gC5BZudpEHHUIr77BhUBPKZO4vLzU3?=
 =?us-ascii?Q?TfnKw22RAiKywJLEkZDsBFuQMCedAAf1S6Uq/dawTyTp4J3jIvVnsnufDpUg?=
 =?us-ascii?Q?mvasxj+Ym4sul5OEeY2dOjqC9fs2dFXx0ndTU0W3ohZWQGQrclYs0bpAZfjM?=
 =?us-ascii?Q?JV2ey+MiwmzkDwz7Rh0A48wUqwOdCZhqHiJEmNdiA+OUwpcJwAhNQchHMEBf?=
 =?us-ascii?Q?RrA4jK8sxhZ8tOv49aph21v5z50nci74ABGBdCBx0TWzA0ld4PaUosxVZ0sh?=
 =?us-ascii?Q?gP1ZK88V7wNKyTag24Y+cpFOx5sRULy323JxomvPW5aZ01AjVWm995uhwcvG?=
 =?us-ascii?Q?pL3YusZrXsaIvhpj/1Ci2/qNM1oS6FQirP+kr/DcEg+I/lOXU9xymi5f6yBo?=
 =?us-ascii?Q?D2nlFPfJhVJr1N0kr4mbRzdNIafLiD+ogIqrPaL5sZIaNyJMvIUq5EkZ5fL0?=
 =?us-ascii?Q?DYCpq3JDDMp1zgYtD5NJeEbFMIp5MtMuyDnC13sWSuHBGW2BtBhCRmZG8srx?=
 =?us-ascii?Q?zBr7GuwcZhuWVv+GEDB3iC4QSHLJ2iKVOrlgSGd1cdLpJW0MRl+hB86g/WHb?=
 =?us-ascii?Q?6LDisEKpPYwTuMICSltK7Imv2jH/0k2yDsJM0qQMG7HzU61/7eUi+w/yArtu?=
 =?us-ascii?Q?LLCdDHhT9exkJGOCNa+Z+9yKng04COsl2yCveTbBh11PLtRzYGln+u2STCSG?=
 =?us-ascii?Q?86eAcuEx1/9aDDoYbl6rjJQV+4F6UB4SdHTqxw+wu++yiOH74mwa4jzN+y+x?=
 =?us-ascii?Q?qgzUaXLA6plr8ZDkPVcxnYI9aNH4iqcnIb+BENyugHPGAs3sbjHiQ0meN7+X?=
 =?us-ascii?Q?Avm0H8GE/4XaM3woCesozkpdL9bSqNNhwg4GrIqDitLHvK/DdbU+IZm1SDeB?=
 =?us-ascii?Q?Ht2jvEmazxvjgrAGUyN8OtomfFFLRrUleSO0JqczCbCHXjUs7b9F7X80E7J+?=
 =?us-ascii?Q?Ro9VuTBdLSA3z+TGRGknO1TGDdt8roLrsHu4PRA2C9kT2jBL3WVbuSY5aGiq?=
 =?us-ascii?Q?0rP/C7n5qyIoYejaYoKG0XntPxZ2dYVwkT+KxiTL2L5SYLgQbvpIGcLx6g+U?=
 =?us-ascii?Q?w2L0XzmCkleqHQKa1DZnTRF3yufIgZr41s0ZLAyeL4jNeUsEZajl48dVT75n?=
 =?us-ascii?Q?kEHp8ad/EUO+45tEH4W1q5Xjfm9YjQjgMPpTO6kDZb60cGZ+ERlRhBFaaHrl?=
 =?us-ascii?Q?h/4pF0d2f3rosdokpiomKu1akOsxM8PNb3sHkNpWOj0VabHrXApKFXHAL3V5?=
 =?us-ascii?Q?EKBmg+qJ0/Xxjk6YL8Ec5hpDGeZK9btIkIIbih0qXkemmq3GjVZaiYw6Sufd?=
 =?us-ascii?Q?xqEsl06pq+vY9p1hAjDzxQQUaOIJkQskULHle4C0kvhehyXStG/LolljLddz?=
 =?us-ascii?Q?9ZHtPFXmpUkOcOEgIF5128JVV3THalKmHIpiEbXkpWPjYXBC2f53MDn0hv7A?=
 =?us-ascii?Q?94lejup1hMBr8Q0xz1u3Uosmr47lEDZr9z1GeDvkc8PRwJCQU47GTJnW3LSR?=
 =?us-ascii?Q?SJRCyUVbopZDMStlwO/3YFTINhwwaBKZjKYVWK+nDd9CsgGu/HUy+hDxAdN0?=
 =?us-ascii?Q?YuX5KWE4/pGuGlmxS4VkT8k8AzI+7MSlLwi9tRnbmGAojDsw+Y/qvmjlq0O1?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f8bd01-2ca9-4232-928a-08dc62d838ce
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 14:26:38.7493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fLpi/a1Ky0Ot1NcZyA6kZIDsKj/3CDm7iwCowna2okq7p1S8PP2v/wcZA6Pp4xdaioYuP/XbA+OhgdvwwSjZOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6982
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "BUG:kernel_reboot-without-warning_in_boot_stage"=
 on:

commit: fce2775b7bb39424d5ed656612a1d83fd265b670 ("[PATCH vhost v8 6/6] vir=
tio_ring: simplify the parameters of the funcs related to vring_create/new_=
virtqueue()")
url: https://github.com/intel-lab-lkp/linux/commits/Xuan-Zhuo/virtio_balloo=
n-remove-the-dependence-where-names-is-null/20240411-103822
base: git://git.kernel.org/cgit/linux/kernel/git/remoteproc/linux.git rproc=
-next
patch link: https://lore.kernel.org/all/20240411023528.10914-7-xuanzhuo@lin=
ux.alibaba.com/
patch subject: [PATCH vhost v8 6/6] virtio_ring: simplify the parameters of=
 the funcs related to vring_create/new_virtqueue()

in testcase: boot

compiler: gcc-13
test machine: qemu-system-riscv64 -machine virt -device virtio-net-device,n=
etdev=3Dnet0 -netdev user,id=3Dnet0 -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+-------------------------------------------------+------------+-----------=
-+
|                                                 | 3235a471eb | fce2775b7b=
 |
+-------------------------------------------------+------------+-----------=
-+
| boot_successes                                  | 30         | 2         =
 |
| boot_failures                                   | 0          | 28        =
 |
| BUG:kernel_reboot-without-warning_in_boot_stage | 0          | 28        =
 |
+-------------------------------------------------+------------+-----------=
-+


If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202404221626.b938f1d6-oliver.sang@=
intel.com


Boot HART PMP Granularity : 4
Boot HART PMP Address Bits: 54
Boot HART MHPM Count      : 16
Boot HART MIDELEG         : 0x0000000000001666
Boot HART MEDELEG         : 0x0000000000f0b509
BUG: kernel reboot-without-warning in boot stage
Linux version  #
Command line: ip=3D::::vm-meta-11::dhcp root=3D/dev/ram0 RESULT_ROOT=3D/res=
ult/boot/1/vm-snb-riscv64/debian-13-riscv64-20240310.cgz/riscv-defconfig/gc=
c-13/fce2775b7bb39424d5ed656612a1d83fd265b670/6 BOOT_IMAGE=3D/pkg/linux/ris=
cv-defconfig/gcc-13/fce2775b7bb39424d5ed656612a1d83fd265b670/vmlinuz-6.9.0-=
rc1-00009-gfce2775b7bb3 branch=3Dlinux-review/Xuan-Zhuo/virtio_balloon-remo=
ve-the-dependence-where-names-is-null/20240411-103822 job=3D/lkp/jobs/sched=
uled/vm-meta-11/boot-1-debian-13-riscv64-20240310.cgz-fce2775b7bb3-20240417=
-37917-x2hsv1-16.yaml user=3Dlkp ARCH=3Driscv kconfig=3Driscv-defconfig com=
mit=3Dfce2775b7bb39424d5ed656612a1d83fd265b670 nmi_watchdog=3D0 intremap=3D=
posted_msi vmalloc=3D256M initramfs_async=3D0 page_owner=3Don max_uptime=3D=
600 LKP_SERVER=3Dinternal-lkp-server selinux=3D0 debug apic=3Ddebug sysrq_a=
lways_enabled rcupdate.rcu_cpu_stall_timeout=3D100 net.ifnames=3D0 printk.d=
evkmsg=3Don panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpan=
ic load_ramdisk=3D2 prompt_ramdisk=3D0 drbd.minor_count=3D8 systemd.log_lev=
el=3Derr ignore_loglevel console=3Dtty0 earlyprintk=3DttyS0,115200 console=
=3DttyS0,115200 vga=3Dnormal rw rcuperf.shutdown=3D0 watchdog_thresh=3D240 =
audit=3D0



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240422/202404221626.b938f1d6-oliv=
er.sang@intel.com



--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


