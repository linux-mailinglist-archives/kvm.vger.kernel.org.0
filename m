Return-Path: <kvm+bounces-17743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9898C980B
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 04:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B259BB20FE0
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 02:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C04D27A;
	Mon, 20 May 2024 02:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EVuKwiyn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BB779DC;
	Mon, 20 May 2024 02:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716173568; cv=fail; b=Ke0A+sryNfOe9TRrMJmtTDDb6uJwwvkIX+YOOUCVP5i2shX4GAeZh+kYiujvwQpsYHn4XFBGBo7wY/Wmywxu9RCopg7mEPBPys7qPFb+b3kWF2gqPi/Fyj+AxfPFnNQ7X9tnCzAUQpkHfqYhu3cQ747rKG/7RojLgQdRn52x58A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716173568; c=relaxed/simple;
	bh=RlXX27iax+i/1L4wjXrs4/CWCUhS2gvnQdbeUd4bvVw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KTGBNPe5djTRGqnA8u1603XIcm3asJCqtab6GSDw8dygBR0XHkMkgSHUweJ8LRgQSYnyaHft8DzNVnwgXelFCMpv2rCxn2MGv0Bz3yHIqPPuxSToVoDw4C/wc69/Ce0vCELSc1pHxsOeAjDr4/yVLlishbEpfOjxvwXcYa1WG90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EVuKwiyn; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716173567; x=1747709567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RlXX27iax+i/1L4wjXrs4/CWCUhS2gvnQdbeUd4bvVw=;
  b=EVuKwiynpdrzcryNCgq4ALRsYUIwjIMm3ID6Q2QnWC9OqOqfbcqUx7Sh
   ZG3cPHLwMtvrX0snQ/C0Brf7zrVZ6s+MBFPHSPkId01zB2Bv2DeDKUrx6
   pnkD3OzEQa1WHK8nyBvx11MpGRd+WDDUVRRMT96RqPGphvk/3gQja07rN
   OLYkLCg7CqnBhNgJPSmBI8AqUw88DDq3cq2x39+uw+yXPCKfCCfZZOsL8
   SrAxWDonicEhNFQa507db6vqxowGi2VVQfaV0UDxIJKLnL1aOjhAZjOBy
   qfqUBzq2SgB0NwBt62WqPMAV4ONetKQrBFZjr18/0KsYtmYeLtc9Olh2K
   A==;
X-CSE-ConnectionGUID: gIryV2NNQIWPMw+5Dv4opA==
X-CSE-MsgGUID: XL70SAewRgKGIqV7y3WgNg==
X-IronPort-AV: E=McAfee;i="6600,9927,11077"; a="16071696"
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="16071696"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2024 19:52:47 -0700
X-CSE-ConnectionGUID: ZSahLhg3QTmNCxm22vANvw==
X-CSE-MsgGUID: wMOtWUXIQJeyUDqEAeRQ9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="32405036"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 May 2024 19:52:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 19 May 2024 19:52:45 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 19 May 2024 19:52:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 19 May 2024 19:52:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 19 May 2024 19:52:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2Hp5jXWRLiN5FpPUW7CUglbxEr67wbRuWQlzHBOqeOdrsE8h58zI46CT02msRSuGgH312DqixzQzzoNDlk5LXJ+KBOLFeoggDu9EeEt8nmF8OX83bxhwlFmvXnRy192Gervq2Grw4f1INenYpFxTXvPiQ6IwTKaCJJ6YgbEsLrMCztS09gLnFJ9jNY4xUqWV0mX4nLHu57D0NOFcUF5C3NMw2/cMT55CO0oCMKk/fserEsRCDDfWYlyh8xJwFWPETUsbS+jcqe/I281Hn2mJsUDIcUzgKrG5SCLHv6/czVYQyoUwnq5NvBzGIIjDO5bczBbbaqnZx95RuSfb2DOAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpkFK1MS/0YsNVdi3XGXb3c8WChNXmAqwteEpgqrKyE=;
 b=hCTzwFH2EMbZ6vgJ+11r5hswB1hyycBTeRg2qbgxknx2ehTikKF1TiGwihdGqI4rzuex7H+FTtIWG/2w+6ztB/GZLUru4gMPfu5ijU6iGEElQjba+3nwvLIt64mpx2cKXdVdAJaKI87wh45Xwsd2z07T039n5G/kSCTfRDaXnB3Fqc8eKotGKJ65QskS7RQFm0V7MTIurWEH1Sol1Adu4D+nQb5RQjlzUiq03pfF2NZXfmOnhCzzCGOTa4SqzfSYvBGO396e9hbKI7MQc6QlTZySSqGPe+ZBWwLgrLibnYNY2YPCqgXSVIthnzEv/va0+wbu5o7k9qBH4cwRvr66Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB8149.namprd11.prod.outlook.com (2603:10b6:208:447::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.34; Mon, 20 May
 2024 02:52:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 02:52:43 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Vetter, Daniel" <daniel.vetter@intel.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Topic: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Index: AQHaoEb1yTw+2+R5T02uRFeJZuQMNbGPN+OAgAER64CAAGvrAIAEE0QAgATCszCAANP1gIABWkKAgAPDRsA=
Date: Mon, 20 May 2024 02:52:43 +0000
Message-ID: <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062138.20465-1-yan.y.zhao@intel.com>
 <20240509121049.58238a6f.alex.williamson@redhat.com>
 <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
 <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
In-Reply-To: <20240517171117.GB20229@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB8149:EE_
x-ms-office365-filtering-correlation-id: 643aeebf-e460-4baf-abb8-08dc7877ec03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|7416005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?B+D/IRrIb8froNfuPYD8kZGJONpJTFDmjXxdi0hqzc6ANvWa8ZcSEn53rx2u?=
 =?us-ascii?Q?R1QW/2p+TTCYnoI7eFKmaOKaU5ES34QI8Zl2q+d1Jdci05zU1Vdwd8ez4Wpz?=
 =?us-ascii?Q?GkvIS4CM2F/BE9/ox97bQ80BXP+UZH2yG3osd/JCaQngdIG8Mq0EWBOjsYr3?=
 =?us-ascii?Q?wOrsxFTZNpLTTguKheOKCO9iEOFKUdLwTk/jAZex+YlF1Ox5BBjyrA9K9Zt+?=
 =?us-ascii?Q?6DnNdgQp9Gyyz+uWk7Qs+v0uR2HRVu8AtmrLRH0iEl8tYe6JHvDuKNx2VkWI?=
 =?us-ascii?Q?Q/7u4P2vpeM6exhyKN5rE+XvJjzidDgOYR9hhn6rG417+3wgksfj3SXxsiQw?=
 =?us-ascii?Q?bnURQNvDxj+10tdmytfKhJAbeh+MRRnghWc2bswE3Lw0L/RvLLj7oBV5rPj3?=
 =?us-ascii?Q?GKO/a45+mLLr6P8f+om4gtKpkzZb+tQ8Vpw3Bkpo+ZPuGR+Owh+P0ttwsIky?=
 =?us-ascii?Q?3f5St1iHOnNx/agKl2pC/K/jW5+osgbPBaHaa4NhkwoXBFyx691B2rSVxK/U?=
 =?us-ascii?Q?GTNJSkpTbtua8LTbbfJgElMTXqRzKk1knqt8NTvH6uJ1/7USF14tLUfL2vsF?=
 =?us-ascii?Q?BHI6FmbV+ehXAuCu2kAVJHoX+dX4U4+enRmuhDUqZtT9ha0o4O6pRVr1Sajy?=
 =?us-ascii?Q?Y9K+C5IkD2no7w+InaNPSWNlQp1/I7GEh/NvLleJ10RYsGdMEpyd0SEP7DIj?=
 =?us-ascii?Q?5Ih67WMMVc7HR3kgtTmHDZCscIVjTIUqkT6pOXzNAAe9/JFEaVN3a7pKmY05?=
 =?us-ascii?Q?b0T9PnY0Wfh1+akz1laTyTmy84p+QPoKF/Qz6z0KuuQa5m7eyWL3l+iCTeOO?=
 =?us-ascii?Q?cmM58EaDBocQRXT5E4w7O9/p2P1o06nIm8UrzLyevYizBE3G9Ij4RCrhm5E5?=
 =?us-ascii?Q?rZ4i0Fwciba1XDMkPLM9KRq6a9pK3kDvjNo9DJTek8Ulc9AmoTl6dSB7BONy?=
 =?us-ascii?Q?qq52ouUn5NCb898Jn/+AqEwspJSPNa446NNmZte0GOQK3xBZ+MH3lP92pChU?=
 =?us-ascii?Q?MkJG/ixDapIdYgZ9rVJGKPcCfvL21JeswaIOUIw1LwThwEiQaPkJdNYkOyU1?=
 =?us-ascii?Q?sUEWbDiYGlU0zNi2pJO7lxAQszi7WrKdz7p4UvDp1YyYQFKT8NIRF0rUbCG6?=
 =?us-ascii?Q?xiqKCjd3M1lWyb8DjCqSC5lxeowOZFRbe9GC/7QhbAv+R+USywbE2ZEXtzEJ?=
 =?us-ascii?Q?j/CHzXoeaNJTHSi3lGI8DvXMfBJYPavHmQTubxpfEsNdAte92mkOIgD2iJ//?=
 =?us-ascii?Q?O2kfgSD5c8TWLNvL1qUl+hVmc5o+KDDXzh0lLg5JcazLVO2S3zAOsz+cfJs4?=
 =?us-ascii?Q?eznzsDkTum1+F2bw2IslHiWC346pKVDEnLmQs+ZCtRc/4g=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l+3D+aaZxnYH8bak+DpOunf6rl12hQ+XzbEUflMmuzgysFDU0Fj2Q7CfNL/t?=
 =?us-ascii?Q?MDimM9UvL4l01u8MstImU7ZrH434LdIpnwXyBu2njLtd/uZMXzl57wDO8YLg?=
 =?us-ascii?Q?xNJV/KBRJUDKKAcuNw0AWscDsMiVLTMKwUHZhgF8Yyzjbk9cXv+fKsKZfkkm?=
 =?us-ascii?Q?Ix5rU8PS25dWQvhTcZilaEGMU8eWoI0MrQkQ5vZ4FQAKH8x7OZHz7GPZ/znD?=
 =?us-ascii?Q?lZHnhSriTH6OCS6oJ6drvyRpqxz1N3ceJifu3wIz1NadoQq9aeV8wWXSc7zM?=
 =?us-ascii?Q?iv1+WViX4a7yCu4/lqpqli46QZq0pVUU9hU6ZQUy6xF0yoYH20ffCmZiDXpO?=
 =?us-ascii?Q?uG376/Vb/6ZtQtZTwWmYbe6kLzYMVhMZqco0u/q2B9tqLIyM2v1/hxrPxy49?=
 =?us-ascii?Q?54dXKRWdNADuTa8R1LiRH9lPL7iDFb+jzOX27HIvtg+VKWYqDnrei/Kcamli?=
 =?us-ascii?Q?qaOaSpNoCvSgwyuDqPlf+p7KSQQeVXCM0XKsmx2gWa2MHea0+mc4OtEQQFNG?=
 =?us-ascii?Q?Cyctx3HeT0r9eITweZdqa10Tm7enQixr6sEv7uYGlS6NF5FbFCgvtznilTD8?=
 =?us-ascii?Q?xx56Jrbsrit5PwVpLmP/hAjPQnKEZ0upvNHzEl9iPKTIrGdOr4XozVpzFp2m?=
 =?us-ascii?Q?95yb+rdGW0hNJOxdE2NaA39uIunoV0Ym1GNU8u2cVq8FoAjDON053I8NCTMa?=
 =?us-ascii?Q?066CbvEretkJaX37aBVIIcLU4TJe5XZHKA+af31h60mgDTBGDXXAS9BjHhp3?=
 =?us-ascii?Q?q6oRb8TfhjSzb8e+3reTSO8EGe5gCAq+hIu6H+0NvoAmz/mKERDbw6jAcO7e?=
 =?us-ascii?Q?T+PLxCVvoqdsLmb49EgyCVSgVYUey+3H+oH3vGWFyHnwHzf0oenOXtNMIe19?=
 =?us-ascii?Q?eGEa2kBTOJdEroSUBvy3mIWKLEeE0NVeXBrCERi9ULdiSF/sN/YuomCo4YhC?=
 =?us-ascii?Q?9so7qmVtNWspAnvWi51Z2ayoQUISs2ahRH3eN1Pd440+KNrkkCHESEqTrsOD?=
 =?us-ascii?Q?a9rKBWcdIpvPCNsSmi33sGe0UQipVpogD2kZkzTy/xnz4pHRb2WcTa2HtJuL?=
 =?us-ascii?Q?DwvGEYDe4+oOpFjJHnTPxSKMe7ZV29+1yUVsUt3Q3VTTENikpFgEg65uck8L?=
 =?us-ascii?Q?CZPOdBTMXKdwUTPVLvtn3ZrKeBGp12ueig9AJM+73BZjLrdRORkTWueCmmGy?=
 =?us-ascii?Q?drAmtgUy8dGf+GkqJqThM3KPnATZL3JX27QlhznuNBeMj+obWQTnvTOO+WXY?=
 =?us-ascii?Q?w2hbMMQ4vfMQkXc9MIOdrMiF318OQIFXt4fc3mXtK3KMygaqvT38WPGa6Pwv?=
 =?us-ascii?Q?gaWFU6XcEO/tiBFFR9V/Hy0/0/HWGwLB8dTxt+ww0y3Ywook1BAHfsTOh5FP?=
 =?us-ascii?Q?J8JQlh2ucHkDlLBLxunbVEC9W430J5m032Er0UaAvQyyTCxTxrU+SdDa4LnA?=
 =?us-ascii?Q?6Y5Xk4mvcUn71IxRYqT85ErmUCvMY0XfwtZYdDCDMNvyqwXjXJBGNHF2YhQ5?=
 =?us-ascii?Q?1/1v13lhW/oiGbI4agjYJkuM2uCdqV1y5atAJ/G8T32OttvQ1pUrMgpdACbm?=
 =?us-ascii?Q?Kz9DSh8R7RNYHT1UyAZdQx2VnSsfBNY4syXUjzZu?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 643aeebf-e460-4baf-abb8-08dc7877ec03
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 02:52:43.5729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E2nGHaBvyHdRF0ya/1EiyYxIDIT2BX5hlqZQ+4/6PSmDNmuxf5qFqMDCJ8oWG++DqVaHzou/R8YpWwpsADcHag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8149
X-OriginatorOrg: intel.com

+Daniel

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, May 18, 2024 1:11 AM
>=20
> On Thu, May 16, 2024 at 02:31:59PM -0600, Alex Williamson wrote:
>=20
> > Yes, exactly.  Zero'ing the page would obviously reestablish the
> > coherency, but the page could be reallocated without being zero'd and a=
s
> > you describe the owner of that page could then get inconsistent
> > results.
>=20
> I think if we care about the performance of this stuff enough to try
> and remove flushes we'd be better off figuring out how to disable no
> snoop in PCI config space and trust the device not to use it and avoid
> these flushes.
>=20
> iommu enforcement is nice, but at least ARM has been assuming that the
> PCI config space bit is sufficient.
>=20
> Intel/AMD are probably fine here as they will only flush for weird GPU
> cases, but I expect ARM is going to be unhappy.
>=20

My impression was that Intel GPU is not usable w/o non-coherent DMA,
but I don't remember whether it's unusable being a functional breakage
or a user experience breakage. e.g. I vaguely recalled that the display
engine cannot afford high resolution/high refresh rate using the snoop
way so the IOMMU dedicated for the GPU doesn't implement the force
snoop capability.

Daniel, can you help explain the behavior of Intel GPU in case nosnoop
is disabled in the PCI config space?

Overall it sounds that we are talking about different requirements. For
Intel GPU nosnoop is a must but it is not currently done securely so we
need add proper flush to fix it, while for ARM looks you don't have a
case which relies on nosnoop so finding a way to disable it is more
straightforward?

