Return-Path: <kvm+bounces-20320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC13913231
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 08:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD4EE1C21D7E
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 06:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1805814B06B;
	Sat, 22 Jun 2024 06:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c0eT1+i9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81088F66;
	Sat, 22 Jun 2024 06:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719036467; cv=fail; b=MKrT3DjysS/lcre/usNIC0p+C+95goBMjWp84QkjoLDu3kXDCoKQoMv5KZBQ9lQ0MLI0YNkMfu8xVhTQ0/6JTFk3LTr3ztmy7rW6c/63LD8xmUCvJlUbZ6YoPvtU3f3d4ewTkWolQ3PYbm9koIO1HUEt7WlMjJedpLW5MJWrlj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719036467; c=relaxed/simple;
	bh=xvDu0IERs33YFFpOIqsSC03l24wzHA82W7XARUl+RcA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I2NJ1csqiGvrHIlYQLz4QUGY/1CR4Aq74N3RjQzWP0gKZ8myWfOBYOoyyGgd55To2gpE2MMwkniX0EKUscfPSXUCX/9Lspxi601tNpba1YzKXJmLAtXbeE9pB2gh9/UQswSWRCDgWc88y6zKDmWWZP3uSFcPzf1OKEqYK4UJWBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c0eT1+i9; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719036465; x=1750572465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xvDu0IERs33YFFpOIqsSC03l24wzHA82W7XARUl+RcA=;
  b=c0eT1+i9XC3GNdJM+G1t8WIAdcrlvWGzo6AKKBLQW+LtBrOqlYONsg06
   TirMJD6NYmTHaoGIh06I8E8/6Ezr2IgdCDP3E43y4kJE1cDQeGmiL17A0
   SdE0FUhEFMJ9Rq96r6SSBJPzfvYfYzR9arPaT82gPwu0hIieGOFa//pnt
   /CKswYzRn0tLq5O47EvOmqGHBg7tsMU/i32SO1leICtGMlv2EgKgiX88K
   na5J574Zm0C5XlCJrIrepjoqKutACVWhBKA1sP0qmy10gUO7FtxfAnuZY
   bJ+XERAikeJfGtlG/LnNP/r2Irx88ZhNY312EBiKUFI3x5Sw/tYeDFtfE
   w==;
X-CSE-ConnectionGUID: rJlH39JKTcqc98mq/OMisA==
X-CSE-MsgGUID: TgaOXGRaSSO1Lo3opCLXTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="12190096"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="12190096"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 23:07:44 -0700
X-CSE-ConnectionGUID: DWiZ2G8XRuWXNyVLO+9scg==
X-CSE-MsgGUID: VW4dFkxfTx6axeYnzQNc0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="43230573"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jun 2024 23:07:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 23:07:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 23:07:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 21 Jun 2024 23:07:43 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Jun 2024 23:07:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kx4pKDe5nB8R8XduQujUCIO2U3eHRYlWFmzcGYE41iGP2N2gds1iAQSGVNtgo4cpEDaHjIFiMUas58cGp211lrd80AfXJ7HJe/cq7DBBzR/L8q92p8o/wBVlbXtcmNL2r4WqYcRz28JtjCLRVG4WFlpH0kDahhLLwgT8BA/y5HP2p3YN4Ao8DHUkbfvrLKrwnUqOgE6rLuEGo6OtDKTwYMq0Iy73RhltocaozOWc2zLjfpExUElXVsy95sIyb4vv3v19a4KZa0LD+ZSHGBodTDltefSojmIUfTYeZqXKHEDIRGt+vH4ZWf0cRkECZ4ULBcViyAp6+yo/pT9X7ZZzYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3S93vVE9s7VvxIMidbK21k6nyVsuLzvWA8A2RJx3ne8=;
 b=iw/mRGCU9JUxfiZ0zz4ZsufCN9uo6EeFPWNkbmHgtKg9L9VpZrW5M9ZQRSpy/EFIam/qertbd0H2Zyp+5VOTlr1S8deE0La8CCoYipZn0z5kN5uaFv1+bUXr+71CCvwIKwEMeTfnf6z/7CZ9awq8peZUYy3SZmHS3+Y/2I01dYKS+sBw4P00p16vHKx04V4XH/92qhFcu+L4bCMRtOuhkkNq2lyidC0vP92gFyfgOS3HYJbXeSG+h3A/kJQl6kIaAdthh/2J4Xwf9dkGT/nulYkVGlmqS6fHjgGGQJxPD9YR0RLXkAmqFStYOpACQFMxJ+e3osTH7mI694dGgtwAHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MN6PR11MB8219.namprd11.prod.outlook.com (2603:10b6:208:471::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.22; Sat, 22 Jun 2024 06:07:36 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%4]) with mapi id 15.20.7677.030; Sat, 22 Jun 2024
 06:07:35 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"Richard Weinberger" <richard@nod.at>, Anton Ivanov
	<anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>,
	Hans de Goede <hdegoede@redhat.com>, =?iso-8859-1?Q?Ilpo_J=E4rvinen?=
	<ilpo.jarvinen@linux.intel.com>, Vadim Pasternak <vadimp@nvidia.com>, "Bjorn
 Andersson" <andersson@kernel.org>, Mathieu Poirier
	<mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, Halil Pasic
	<pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Heiko Carstens
	<hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
	<agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
	Jason Wang <jasowang@redhat.com>, "linux-um@lists.infradead.org"
	<linux-um@lists.infradead.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "linux-remoteproc@vger.kernel.org"
	<linux-remoteproc@vger.kernel.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH vhost v9 2/6] virtio: remove support for names array
 entries being null.
Thread-Topic: [PATCH vhost v9 2/6] virtio: remove support for names array
 entries being null.
Thread-Index: AQHaligQYdJ7G3/Ep0SOtqEoL6Vt7bHQpCeAgAAKTgCAAAYCAIAC0a8A
Date: Sat, 22 Jun 2024 06:07:35 +0000
Message-ID: <DS0PR11MB6373310FBF95058B8FE8CD95DCCA2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-3-xuanzhuo@linux.alibaba.com>
 <20240620035749-mutt-send-email-mst@kernel.org>
 <1718872778.4831812-1-xuanzhuo@linux.alibaba.com>
 <20240620044839-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240620044839-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MN6PR11MB8219:EE_
x-ms-office365-filtering-correlation-id: d216aa01-a40f-45c0-0616-08dc92819cca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|366013|7416011|376011|38070700015;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?fKDwNw+VGHC0SYJZLY7t4E40jBlGIpQGzu17hMb/EsIfbdc6xyQ+QhuaLh?=
 =?iso-8859-1?Q?8nTXGaaSfDVuUVsOillAglm/1z52/YXzWlGwETQSGVGi9872IuYPcQ9/Ia?=
 =?iso-8859-1?Q?TtyWSZ2jTXA2EbdAD550XPJQtr3GMmkC388wTvQbCKeuUICVKj+1iG3fBw?=
 =?iso-8859-1?Q?neRs0dBDh8dCrGWFWnRtHxRoI/P0l0X2xkl0fdMslAQX45nFBC1cBurR/h?=
 =?iso-8859-1?Q?OisBpf5xqWwjYzQmA0+GrnHwBtHibCCCOxQsoQn6Y0XUCgr3YQSN3Gd0q1?=
 =?iso-8859-1?Q?ZS8814tRgRKOphVLb7DopXRtfOYxij7NUzWoz7KYcVAYP+5Czr1ruXNDbh?=
 =?iso-8859-1?Q?J1tyF9gni6bK/NXv/6S/aq2d5ewN/E2I8HpnZONTUjcRnJY/s8jiGgrl2C?=
 =?iso-8859-1?Q?6QnpabYOiHkmkOot6yQmclsGF5zbrBR1B6Xifsg3fG3G5PKh4JFP38TqiJ?=
 =?iso-8859-1?Q?eJ0si6RXR7r0finlyDuJMeOUXgssiRH9eYLwEuBgVpi1bXPRPO+OC2/9nk?=
 =?iso-8859-1?Q?pXCbup7yohNPFWpTns/xhIQJ3A/WAjN4V8cXjwMtrP8NbTxzG5j/SqNnNQ?=
 =?iso-8859-1?Q?qyXT1yhhhSpgVS00Flj1arf/3Ciiv5dS1vAEc4EgVR+ukEV0s3FuxKiN42?=
 =?iso-8859-1?Q?4OtoWPcriirpGJlRDoqTDfAhX6beKq3x7JxmuZrB2XUIm6qjqMlnb4EP9/?=
 =?iso-8859-1?Q?p0GJrHEN0j68qbVgFVHtzGG7dmsVfhRXG1DNb3L/l2PwlKSKdF51DJnyVE?=
 =?iso-8859-1?Q?vMXpE08t2lhvzGoIU6Liev5aMUpN3OfHvJeChqe3JpcVAlDm51UZu0PSES?=
 =?iso-8859-1?Q?eJKbXW1eYyI5Tqjws0tqez+m6BbeClEMQDXeUatQi8yrEyzeL1OsJQ+XSb?=
 =?iso-8859-1?Q?Bh9Q3JCqjhIuN3l7N6Jg+p8FnsMIXR5r3YEdlhC6Uln7pa9DiLlMlG/k0D?=
 =?iso-8859-1?Q?Sa91sj2T90OxsdPOSNYuMcKDZv/C1zenkzlhx3p1Lb6Zl3g2LS5mr6mqbY?=
 =?iso-8859-1?Q?NbuT3RFytAHIbb+dQ8O/COUy0G/4wLI4k73PpmqpiLROcqyyiO/WYXURqe?=
 =?iso-8859-1?Q?IKBmD3nXLxvnRZFeoqGNKvEi+Lv5EnWNnE48EHt47WjKB91fgzBdyWv8Yv?=
 =?iso-8859-1?Q?/RCg5AH0JD2sOOscgtshkP6vS73sT4wD8kofHxnRRM4MhchBHL9VptylsS?=
 =?iso-8859-1?Q?7qyRFpkU8Zj0Kke+HLdFmlgZvb6Kz4GhiSUIje8TLwlp0jN5o8jg1GT2Yv?=
 =?iso-8859-1?Q?pU6XIufy03SIji3yADto0ibzCaXgA5a6NODMaHyZeOjCuLVifmI7xUwjrQ?=
 =?iso-8859-1?Q?X0pARD4/g0kntFx66KUnOfabPOy6AfuBGfFgi/TjDzSUxCE11VUZjddWb3?=
 =?iso-8859-1?Q?C3JDkicE/prvGYWAACtHgrIWFp3AvmpeWL9uQQdJaroy2Q/By/+w0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(7416011)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jq+Z23GM4aUFwhVYxkThuhBTzlP+rpyv51+Gy/D+ozAlZZB6uSehDi/YDm?=
 =?iso-8859-1?Q?qu0oK0LwNNItb8rT64bui5ZNcYHF86XyO0FBIkjFXIGM1mKChwJodk+baU?=
 =?iso-8859-1?Q?7OFiqrR2Vj08NPY0Pbuz4M9NAfa4S9HIS3d2lxqJKIYvbPWl/+x5+UiOEt?=
 =?iso-8859-1?Q?MXCJRAeqLPeQKIdsm50o+I1vdQhSR0nHaB9VXLFByl/JOygePmDSOJrepe?=
 =?iso-8859-1?Q?c2HSEImuFR/uP4+vvZq6mtBisV9prlEOa4xFOplKoMT+G78lbQylvjdaw5?=
 =?iso-8859-1?Q?t49sIB40I1kYkppdzkI7cXQoxiy7zWEA2MqrelmpmavsEwCzXXsHCvOxta?=
 =?iso-8859-1?Q?OFV+EHhKbM8SrDipvaDbuPyBV+3kpGTeERdIopUnFQF9RuyUPiKVZVES45?=
 =?iso-8859-1?Q?Id3vWdvVKDAsKBrYQaJyan1qd3LyVKLh7T9F1yrEmICwwl2oeTpOpP/ezH?=
 =?iso-8859-1?Q?QOm46cNFYDQDtIVax8n1ktzYLIq0L+7RC3zNMQVKB9AsSMD0Tbmt6iGtg7?=
 =?iso-8859-1?Q?oBThv5hJqj511JVyNe9ST2KRs0+1iSB+rSnhdMNE8BSJtr2NEjdGJIMtDF?=
 =?iso-8859-1?Q?Lf7WlOenSYLmJw9TFckTyrWnIDeM/KgB7APt/WO4+IxeeL+/ZisR8hXQp2?=
 =?iso-8859-1?Q?JHH7FwYfhKb2pFCmMeeAq+rqV1cmAYI2WA8Esga6unpVscBi6OAfE6RgJI?=
 =?iso-8859-1?Q?g8GVU0jZNNTOMoB7xj6lwoY3sPS4KZZCIik1C5KekK864dz2mH50PGY2OK?=
 =?iso-8859-1?Q?3VqnWd3/mFpj0TjgwwmFiio5yCZe26Oba5M4YAZ5x0QQOprdAdOTFgAWFF?=
 =?iso-8859-1?Q?+31BkpPWz8tbpz+oWgLC+vF/xH+4axrYpUg6o9sVhZSv0F5Y4uNphtn5aF?=
 =?iso-8859-1?Q?8EP1L5wMX9TzjgrkNJviLUWsqZd83rOpYGc/v+eXML0+8tHqS8y2O6D6O1?=
 =?iso-8859-1?Q?V4mIku1P6wCS1cGCk857vust75g7VaSAC8sRMyhre9LZH9zcLDRU92Qsn8?=
 =?iso-8859-1?Q?O8NsYEpp4KCptMqWmUdE0bm4PmTeQsFqWKgLNUxsJehQugJzgbAfwT+V26?=
 =?iso-8859-1?Q?JWcXA4QdLz7QTkhHa93UbEOTQ+4HfCRSWyj2GJyoNKPIPsY+QtqqrjICfE?=
 =?iso-8859-1?Q?dOZ+FODMoaHo+x4FHW+UlMPdDCgxHsvlsymMItPlaxoaJRaAh3WPQnz2OI?=
 =?iso-8859-1?Q?qXkTUi2ZwfxT3lAomtXalA7x+rglTJI8bhvMd552zHVcxXAWxLANMJ0jKS?=
 =?iso-8859-1?Q?1543kPZ2y2y90oC9RO33da49TIEn3wgLb6dZVE1SeGrGtC8riJC7LrkIru?=
 =?iso-8859-1?Q?ycxFpxYrW+VxN3oKGFWb8Lt08110A/Mng55Q5Nsb3SYRrAGF3Iqf4jCwun?=
 =?iso-8859-1?Q?Te5vgG30gIQEkMWm7kTbG+QkJ6+I4cfqngFllNdry2Q2SP7+v/6lodHSb2?=
 =?iso-8859-1?Q?5Xqc/hw4GwbfVX000nk8YocCr2qUQ1N/tV8cg98rV2BPyIMdeqYzBk8/sh?=
 =?iso-8859-1?Q?NWdl2YPOZUJaZ+eMWJoPW0sblSyxoX90ldqZGwOCPu2DKnti7zsdut/3UQ?=
 =?iso-8859-1?Q?ZXFbvzSSm8fJZ9eQwDLBbU4tIcEMNWnlAlcMG42eKwURiTPpfTq7VRBN0c?=
 =?iso-8859-1?Q?qCjGXF2yNq2KU/+Pv0S1ifeovgZcn8FPgU?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d216aa01-a40f-45c0-0616-08dc92819cca
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2024 06:07:35.8292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y2s7IXeti5mwsCGKtdPlgXkZYUZrDQMNvyv3NDpWB4vcWcuhQrJf0JosAoqNgyRbupbptm4JmOe5EFAWYeFKZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8219
X-OriginatorOrg: intel.com

On Thursday, June 20, 2024 5:01 PM, Michael S. Tsirkin wrote:
> On Thu, Jun 20, 2024 at 04:39:38PM +0800, Xuan Zhuo wrote:
> > On Thu, 20 Jun 2024 04:02:45 -0400, "Michael S. Tsirkin" <mst@redhat.co=
m>
> wrote:
> > > On Wed, Apr 24, 2024 at 05:15:29PM +0800, Xuan Zhuo wrote:
> > > > commit 6457f126c888 ("virtio: support reserved vqs") introduced
> > > > this support. Multiqueue virtio-net use 2N as ctrl vq finally, so
> > > > the logic doesn't apply. And not one uses this.
> > > >
> > > > On the other side, that makes some trouble for us to refactor the
> > > > find_vqs() params.
> > > >
> > > > So I remove this support.
> > > >
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > Acked-by: Eric Farman <farman@linux.ibm.com> # s390
> > > > Acked-by: Halil Pasic <pasic@linux.ibm.com>
> > >
> > >
> > > I don't mind, but this patchset is too big already.
> > > Why do we need to make this part of this patchset?
> >
> >
> > If some the pointers of the names is NULL, then in the virtio ring, we
> > will have a trouble to index from the arrays(names, callbacks...).
> > Becasue that the idx of the vq is not the index of these arrays.
> >
> > If the names is [NULL, "rx", "tx"], the first vq is the "rx", but
> > index of the vq is zero, but the index of the info of this vq inside th=
e arrays is
> 1.
>=20
>=20
> Ah. So actually, it used to work.
>=20
> What this should refer to is
>=20
> commit ddbeac07a39a81d82331a312d0578fab94fccbf1
> Author: Wei Wang <wei.w.wang@intel.com>
> Date:   Fri Dec 28 10:26:25 2018 +0800
>=20
>     virtio_pci: use queue idx instead of array idx to set up the vq
>=20
>     When find_vqs, there will be no vq[i] allocation if its corresponding
>     names[i] is NULL. For example, the caller may pass in names[i] (i=3D4=
)
>     with names[2] being NULL because the related feature bit is turned of=
f,
>     so technically there are 3 queues on the device, and name[4] should
>     correspond to the 3rd queue on the device.
>=20
>     So we use queue_idx as the queue index, which is increased only when =
the
>     queue exists.
>=20
>     Signed-off-by: Wei Wang <wei.w.wang@intel.com>
>     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>=20

The approach was taken to prevent the creation (by the device) of unnecessa=
ry
queues that would remain unused when the feature bit is turned off. Otherwi=
se,
the device is required to create all conditional queues regardless of their=
 necessity.

>=20
> Which made it so setting names NULL actually does not reserve a vq.

If there is a need for an explicit queue reservation, it might be feasible =
to assign
a specific name to the queue(e.g. "reserved")?
This will require the device to have the reserved queue added.

>=20
> But I worry about non pci transports - there's a chance they used a diffe=
rent
> index with the balloon. Did you test some of these?
>=20
> --
> MST
>=20


