Return-Path: <kvm+bounces-21626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D73C930F26
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 09:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDDF2281751
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 07:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8851836E7;
	Mon, 15 Jul 2024 07:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W0qMRERh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F3B23A9
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 07:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721030029; cv=fail; b=WMiWj6O15hTWlPxCyCty+YzsrD1Oc7to9YlSJknvLdgRE5PWR21b+Lxp5laegwrFiISMs8+3gm3M+EG2kjMMG+NMnmhpbDEmFKkdvfscYjsTAlT7I/ygr90EEhAFU6ek7pb1pzuOSPcBcYBam1zKppG7NP1jJ8inkOM1BaBZ22Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721030029; c=relaxed/simple;
	bh=YGUznZlgNASatqOgmD0WhFf4g1c2Ml4InyNgFdm0w1w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L1VITHVOa439wjv5VVAwFeyZKfPb3+XMSQuZhK97woHemctp6+IOFEDiaOrtnwlSlqE/fdIMFda8hfPxEDjp00vynmmeslJSr229rHmdvU7YgoI6Tup353C/Cbz3ODjh+N0+rY8jy4jSRYUpw1y9LMqbR11+QQYThKUFKEA2f/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W0qMRERh; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721030027; x=1752566027;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YGUznZlgNASatqOgmD0WhFf4g1c2Ml4InyNgFdm0w1w=;
  b=W0qMRERhXxyvIfOE1iww9io7vcM0BDF2YrlTGEM6vNOw1VuioIzqf545
   U/Z+Qt4ue3Y3ZD8PFntoV6fsHf6nA0KRtC8C1yoHZKRPWfHr3OsbXJghI
   nB3WWmPpaqcAcjXLW95hwuZX5rZk/k4tdlBMIihOg2KrNSblsTz0Uz1jd
   Mwt0uzQ1pLfLmK8iSGR7p6wNZJlmt3qFnqYA+POZkXEUyfVqdw1wp5Xvj
   IpgvLlzVFucRBB1785wG3IFYuRzE5AiMBKtsUpU3i38X1Ux1Zt0s97ToW
   HyypPRR3l/glQyauwiO+mavyV9zY84PAfJIjFzfNdqo27TgLeHdNjT51A
   g==;
X-CSE-ConnectionGUID: f55vjvDrQuuRCMCDfpP1ww==
X-CSE-MsgGUID: pf/R1TjfS4WK1Ay7kA/6lQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="18508716"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="18508716"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 00:53:18 -0700
X-CSE-ConnectionGUID: +v7ARkupS324kvlu4kffpQ==
X-CSE-MsgGUID: 4A+png2bQk69cdpnSr5Qyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="50174147"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 00:53:18 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 00:53:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 00:53:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 00:53:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gjiB2buYT132s+G5xwTfZMlpmYi5bI25vfX6LK5eh4RTHakSbVsG89HhJt75PC0xi8IurzJKYPSLrL1zp2mVjDfb4zXGzFC9H+ifwU7lz7XDDzlZmIm8OucbtOkOr4M3eD64CHUTRNPBIK3ZAlc+8t/EkYO1K1kFU1gMQDVb13RkMw2QR/gupAomEMbQ4nBlyrfUwJEyRhldj8e5HJK9VcmPMNRm0HYlfeCrvhu9oDem34HFZfx9PndbRk3inDWed8M9+uprz44Ah1jn4xW3hQo4g1WjwulRyavbnOLN1zXuU8Ca/IVrz1ZZmEE0UnU0uct7lrXU5KJwsUY8rszsjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QoUP2SM5KSxwI3xBAC1hLrQxU1fXJkiLpZVp/FzVwc=;
 b=VbkzreBVIkCl7b1Y9weqw1r6Y9xkyMy62e5yXPGa1MIZCiRoHNjwuczjEIv3h7TYizvl6Oop39hdenjobc9+T6lDv4bVsNVbISlAkMklFzQLL09OCLkEHRrss4ea/LRJt/oESZeDu3jsv/Agjzy5fwn3MMPhapNlnXc/NaZLXQocAG0li8XKhJSI8mRqlCNMoirKItqoxhsJYsPbYVhjHRrSiARvS1I4aHuApR5vSaWL1gbjUHEt9/DqxNk2kvoBq5w5ASMSzyjUXvRdSL1Z8HKynmFr+Lp95yXnc+84S42Jqtfcl/4AvpacOt5G+aCyw2FPLgx3EWx3ZDG26vdLfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB5209.namprd11.prod.outlook.com (2603:10b6:806:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 07:53:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 07:53:08 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
Subject: RE: [PATCH 3/6] iommu/vt-d: Make helpers support modifying present
 pasid entry
Thread-Topic: [PATCH 3/6] iommu/vt-d: Make helpers support modifying present
 pasid entry
Thread-Index: AQHayTkBxV2CDElK10KiduKobapMPbH3hAZA
Date: Mon, 15 Jul 2024 07:53:08 +0000
Message-ID: <BN9PR11MB52765AC4F822E3E99FB55DD88CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-4-yi.l.liu@intel.com>
In-Reply-To: <20240628085538.47049-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB5209:EE_
x-ms-office365-filtering-correlation-id: ea935e88-0f09-4ad9-b964-08dca4a32ad9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?6m4DomIY8Qo2hoj1pG+zFMYriAZTgH/SGD+OZqjVbwbbhHlJ2ebrrX0CQXTb?=
 =?us-ascii?Q?dt0fQfUGfHh8gtB3/sV2csI6g8eP/GKt57yXPRouxdK2ZxHZMr1jaSbaOybJ?=
 =?us-ascii?Q?08V7TZf/L3788s6a1ZI5z0lpNwr/JKi+FtEir3Fa+1KowBahbYECgJr0xGVj?=
 =?us-ascii?Q?wD1V4O8AJ112NlQ0rqGflVXyWQmsCq5E1PgJqhtzDiXOwjt69sgTThKc69SA?=
 =?us-ascii?Q?lFVngXfTLL53k0nfndU+7DbRAZ0i4xST9wVuQYZ0Bzi4xkuGZEwmP9quKVnp?=
 =?us-ascii?Q?BloHboi4AKdyDu7jj6hV/qrHl1jLJw2uFPQxPrE5j+kRnrfNj/qXNF8MJH/7?=
 =?us-ascii?Q?zqUu+sLQz3kbpEhUMIXrwhdFYiyJZenTUSFdfPfPJ1uwEfIM2iDop2W8WqYi?=
 =?us-ascii?Q?ZJcrfsnrylIlSZdHHsES1c3SC0hcls/FG9crYh0QX6ouieYS6wjs3/tl2RnU?=
 =?us-ascii?Q?9EZabO8bONJHlWrcQxnpNBMSrQwm5jCs49hxoMGtVr92ft1+GthaJtdyd1IF?=
 =?us-ascii?Q?jqdf8VAM56r8D4wWZMlzL/z46W98R5I/bqnEId28ABBsk5mkz17+d5u7wBjH?=
 =?us-ascii?Q?Kt/MBKBahc7Bs9immDtagdaBPWiJ2w3wHY1v/dCnOp8o3odFEiBj9Muk9CRq?=
 =?us-ascii?Q?VKPFTYWLttIQyRQZ+caGhq5F7H6+EBPpxwPlPcXmXcO8H5HITHWzZQ06nQLU?=
 =?us-ascii?Q?ONE7XWqygWcbMT4EeTaiO3cxlmEAC+QOwXtLPmwuJ8uKNaUMbfsGQpdnZiKZ?=
 =?us-ascii?Q?++0HHvc3XajVlEfnYWlxglcx41vOvHye9I0M00AG6v4YT8+kbCHNRLDpAOrz?=
 =?us-ascii?Q?EZq5ZXw/KAq97XP9rYqbtv5LZQQK2Yo3YyQTRDpcNU002cFxbKjJlRgyMkta?=
 =?us-ascii?Q?HvCcsfItjVfp3KcUtdEBI4EgZlVuHUtIccDJgckaAHhXURFghNx+i6bxpCuP?=
 =?us-ascii?Q?Z+C167v0L16f2qRW7pYIaCphcFdkviGoqG6/qtii7iEjfiWWZwUg65osDYfL?=
 =?us-ascii?Q?63bVA76Zv6xKJxtsqTGDlnK9hLOuFygSGcjMTBxFQx1pVhcf9v5eiFOMxwVs?=
 =?us-ascii?Q?6K6jhWKErMt7MisRBFtCVKqEOaqamHPBsgs68lCy6R5S7d9l5FYp0+YqgIlQ?=
 =?us-ascii?Q?gTmOYqzX4neAgtadc5s5bScMgRUq2qv7Gf7Q+ti3W670YaAyFgXyaoWwr3nb?=
 =?us-ascii?Q?uuq47E1N1OTkNFVDgMZ5EAFF2VHB958n9zGa4HBmvQJnjN7gGuQ4xUr0SfW0?=
 =?us-ascii?Q?Ep3wQ9iSOlxCbZ8+OBbKxkh7oMWqlMmy3EuwsvQ4VjAiW64s9KKOblMDcQ/P?=
 =?us-ascii?Q?5UrYxz/yHJVHDPDx4RqVGULwUGMPKT59xJJE4bsx2unIww82O1uSBspUaiPB?=
 =?us-ascii?Q?KH9B5U8hsmuSjN3ylNv05/D7ChCcvJlDUC28e396akxQWmyo6g=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YnDgIwaYtrvrcO7afZjfrlpubufGrtCLITmkPfGu6ao5jKRf6Kbzi+DRbTef?=
 =?us-ascii?Q?yK7GyR0Rled93/VLjQAVXewJK6tszNWB7sRFFsexHQa37W0JBjExwBTyggG8?=
 =?us-ascii?Q?gFJE6EnAWEM9f8cW+TgsbBau4crS3I9NSDnGFrBGGgatqC8+bVRFOJDJDm7X?=
 =?us-ascii?Q?MditrRJQEplAtzi8PWaDI8887TF4B47F1AgDgRkoHCoyFgI0a3cxtiNEHQwZ?=
 =?us-ascii?Q?O4FEEDGUnK5/+CE9dZWfcvMJMFC7k7jjOeTRDXQPfsX/+9silgzabBwZpXRL?=
 =?us-ascii?Q?Z55ti3mSfmQwRbH+FwbwAApj/pso7WI0zfv1FyO2+JVZ+H7LwmLHSdSSfKQH?=
 =?us-ascii?Q?4xQCBggaACV1cB3liPz25PbWnvIiYAIm7uSZ0XBh5nW3XY8eGfz7L1rksH7/?=
 =?us-ascii?Q?ihWIU+UgJP4Nkh+tt9lPUxl4QaR/vhJja26d4Qd+B97wPZr04WsMjTC9PqhA?=
 =?us-ascii?Q?aD+0u4naEhDEdWgBFimKwnFrDoaIvXQkfMh5G2Q3Ou36DWIXIMd2bGybvtrp?=
 =?us-ascii?Q?1+HU23Cn2KuQHpCA3r+YKBVdGRlIije0l7fi0CUpRLO8ENhbjVSSorYg4FOx?=
 =?us-ascii?Q?Nr9bDzciLbil5CS23ltdfNwx84lkRkQuCA9O2PuZBVl96l/vUnYMJRmCf2D4?=
 =?us-ascii?Q?/gdoB5s7lgHTuPwlBLprzu2VSBqkb5qfqCPXwidFltt2W1fRC1rmv4lyy0G7?=
 =?us-ascii?Q?Glv0+pIRxMUhSWd8RQCVncjLRdObQr2yMlW0xv3sb/++s3hmDfj7/Kf4qDRT?=
 =?us-ascii?Q?lUGC8xHmOMbgzBaBgJ1BPBB5V1a9p1zgzrA5MZhmR8JGGC78XRrIleoiNKPn?=
 =?us-ascii?Q?b69ZwiVyABQUlEg+Yef7vzC05qreW5S0P1W8gIeayM2LQLfuMR6toqYSheqt?=
 =?us-ascii?Q?PsK/JRDwaZ/4tdI9M5fRPaC5aWbVYZ1rbd+472uGyCJkwBn6+2jP7opt//Zu?=
 =?us-ascii?Q?4Ii5jDV1Pu7yK03Ct5nLw0okYgBZ7Qc2KgzHmT31X8feudTgBSvLxzDRh/vW?=
 =?us-ascii?Q?IYZvSC9Fh4CZ8A1xDB/905N+KDJK4HcVbOWQdW8UYDufO/E26ZziXyYU6N0j?=
 =?us-ascii?Q?pR73lnf5biXgl+XULVnPHz/AZa5IKuaitZsr1jgvGX6W8iPQY9omMGfGNHbX?=
 =?us-ascii?Q?gZGU4/YaEFuwhV7ZcBLHf6oEuvkNqHNdR+zWMdjBoEEdxi6FeCwUs4EmCJgn?=
 =?us-ascii?Q?0U0iOiqnpwUBtujTaK0e8sMqtj9ZxMkb8BG1VKqu7pbIKkMp5pIRPzqCjZoH?=
 =?us-ascii?Q?gzzEkameifNF1XtfOeF595jt0f1t0mSV7grMUj4Ukhgmo0Fl0L5uAj0UnwBl?=
 =?us-ascii?Q?YGCU1XhmXnefZjY9YquTh5ARFZt8JyhDTtzK3c/kUOSsV+WyjpC/KFNY1A/s?=
 =?us-ascii?Q?ANDa7ow6Ru35EvmFoWJF6wegrM00wrJklsfYwonGTsfg/sbUTXGM/wjZ7bXP?=
 =?us-ascii?Q?4yEhbwi9tlxCpatn6nVa6z/IYwFFcffLEif2kTCFUXP7ahtdClRmjjsCXKim?=
 =?us-ascii?Q?gbNN1dE9PqFDdtclmnbw4uG3NYl5vkisqPsYEpj0+uhREXiYdLXxU4YAftBX?=
 =?us-ascii?Q?QLmGHWcUhdXc3BPvgXIXDCArzM8bnFzVd3hdHnaO?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ea935e88-0f09-4ad9-b964-08dca4a32ad9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 07:53:08.4737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /03Mjcu9JljIejUzb5UQvV+IoAjWhPr/u10Ye3hrjMAfOKG/ScgJwimR6Rb9tnfKMREFWcpH9pNILgm6KiXy5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5209
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, June 28, 2024 4:56 PM
>=20
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index b18eebb479de..5d3a12b081a2 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -314,6 +314,9 @@ int intel_pasid_setup_first_level(struct intel_iommu
> *iommu,
>  		return -EINVAL;
>  	}
>=20
> +	/* Clear the old configuration if it already exists */
> +	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
> +
>  	spin_lock(&iommu->lock);
>  	pte =3D intel_pasid_get_entry(dev, pasid);
>  	if (!pte) {

with this change there will be two invocations on
intel_pasid_tear_down_entry() in the call stack of RID attach:

  intel_iommu_attach_device()
    device_block_translation()
      intel_pasid_tear_down_entry()
    dmar_domain_attach_device()
      domain_setup_first_level()
        intel_pasid_tear_down_entry()

it's not being a real problem as intel_pasid_tear_down_entry()
exits early if the pasid entry is non-present, but it will likely cause
confusion when reading the code.

What about moving it into intel_iommu_set_dev_pasid() to
better show the purpose?


