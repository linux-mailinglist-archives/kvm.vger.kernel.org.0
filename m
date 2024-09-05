Return-Path: <kvm+bounces-25927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ADD3396D221
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 10:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 308B91F28F59
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 08:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32944194A45;
	Thu,  5 Sep 2024 08:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C2JGsVti"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F04515B541;
	Thu,  5 Sep 2024 08:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725524975; cv=fail; b=k1HDQdqcmHcNx1J+RzJPlqq0nEpurTCCdSahl3jgGD5j95JDYmyCRhRpyR3v6FlQOJWzSghN3yT4KnGII1KzohnnF9tFabZHTuzffCvoVMJbjKLYttUW7z5Z8Fd0CJJOfFiT/qwkYz7we4J0AQnnkIIOr1d3iS8f7d1SBzfGwSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725524975; c=relaxed/simple;
	bh=HQUvh3j+yMpWg/bB+QZaFZU9pnKbG3IeqJjRPGn4L6Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e2UsDr8SVgqXPeJ8RckAGdC5MYCghyP9ubL6Uttw/MEO/JOnxEEJKa9zIZZdVN2/N21dIbfNTI14/9O3qNIGJauOaJO7AjRFnCZPV04anlIqP5i+qQR5IP11kRcPL+BjLQGWs+aSWTTVvgK3vZiy73OJ0gh6YFYW7nw4EO7OgwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C2JGsVti; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725524973; x=1757060973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HQUvh3j+yMpWg/bB+QZaFZU9pnKbG3IeqJjRPGn4L6Q=;
  b=C2JGsVtikTge+ZpFQdUklZZJbmGX05GucOQaeV/uibYu3scJMjOuvxBF
   DnVAaJwn6bDlWwcBU8jvp3hoGhK3MS1uBiVAerrUA1YVyOs3gIP4+Zt9H
   ITPTXDkydFSbw/pJcqkrvP5JVr2DP26oyNZoJ2+A3991HPv+pGPTPIPiB
   fJDdx1NT0PdbZ7/V0xuKrEjdFutrIxtASYu+6Ja1yB9w2lwBa4Pq9Av1K
   QVs+4aToIexew6xrJyxy+7KkSSuX7nclq/qVNifOqYTbS0ogYyNGBQXrl
   uitqyiNmygy7WEiTkE2FkOl7JYVZICG1ZIcnuoCL7IjExdcNv4q19r7aZ
   Q==;
X-CSE-ConnectionGUID: kcTqHSvDTeKhUzK8Q5yDeQ==
X-CSE-MsgGUID: cjDFXYH3Su+uA0QeBAe1VA==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24090356"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="24090356"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 01:29:27 -0700
X-CSE-ConnectionGUID: /PcG6o1cRdC68aN1M5ujDA==
X-CSE-MsgGUID: f8DBwcP8QzO/GfAOMxVS5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="65866711"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 01:29:27 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 01:29:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 01:29:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 01:29:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 01:29:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G+3gAO1hEVYeKjq67SbrnyJoqkXOLPqjJu+OKUdp1vjf+rEXxh6fpbLz2akY6b6yUcPKixM2vNOSL2JqZMq0Q+HNc9CREYaBDlvIY1gbRvqAz22nXzKlmToKiNdMz2/lexZ4CvOozI31E1elPAufpZzwDHybu1q1Z4ncem0pu+rWDUDUyxXsuO8jHMp8SLme/cm5RgW+xJX0KGwwSjhsAh09Dv6XaWboTtxxpVeSGtG3+k3qCZ811fKXAN/FHJwcNkZUOYFdafp6T5hyB2bob9PgjfLo6bW01YKLgW+j6dwFf/IsPl7bc8LEcOmMxI+Z5FOYaRaE4DATh53hFSFxyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQUvh3j+yMpWg/bB+QZaFZU9pnKbG3IeqJjRPGn4L6Q=;
 b=sniy5Lm4ALSIAUMYfCJH1fMoSsktSWfnIe7C/3HPG7MyEUy06dRUHMlV1inCPgFQAvFgy95rfmtjkL++o/DnDqZ8HehXNWYwMaUiVw+b9xI3dfwjpYpU+XWmV0zjydWd1CMLT4TWCiTSo3HPzoxj1Xh2BFnB+VTIGgtwmcloFdYhCFfW3PHyQYWazJKlbar0fDWyBF7trZdwZyq8cAaWo3Cg6ztrMh4USFKEQo+1aHonhaC9SxEjXUhh+JF+a00c8jqLK2o2gnXYs4EtmuazxlV1wcvtRbw3Ycs3x9Qilzzcl6KWPoTYOjKxPIOjeqXedXONEY2k2Lr2GZ/tERvbKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6268.namprd11.prod.outlook.com (2603:10b6:208:3e4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 08:29:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 08:29:16 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, Jason Gunthorpe
	<jgg@nvidia.com>
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
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bI5OEgwgABEaACABIX0AIAALPiAgAEeNQCAAHoIAIAGzr6AgAA6GYCAAA/8AIACDdpw
Date: Thu, 5 Sep 2024 08:29:16 +0000
Message-ID: <BN9PR11MB527657276D8F5EF06745B7208C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6268:EE_
x-ms-office365-filtering-correlation-id: 177b292d-9096-456a-3dde-08dccd84d4c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?p/PYxV8G3swpqLn0yXZkEwEzw7sxbBJgxQeBLhp5rcN51O1MmJP1DeCe67IQ?=
 =?us-ascii?Q?UXi+MXmdJLD/wYSGggNXTYHpYxED7oHQDW+HxcHI0JVrKCY4aF6v4lsqYi8r?=
 =?us-ascii?Q?G/f35cTMKT84dlaKhSOIUpfoYsAFrjy/yotP8a4dK9F3qLWhZtTB8UfEJm4I?=
 =?us-ascii?Q?TEDvGTZAQuVbEaJGCZ79grwmsvX1cMSOFkrevdZHhDS6o0RUdhMpBC9gtKvq?=
 =?us-ascii?Q?b9G/S2XXjxTaA5IlybtsOifN70fbpfwtjrIL2g8pxWW3RWeAVGo6bgam9+is?=
 =?us-ascii?Q?WOZA5iohrON5bvzOZiKmMnwwMYRyBultDFTCXh6Dq2Dc9ns+GJkspGbatJcj?=
 =?us-ascii?Q?P51cm7j/wGZAy2BfkFEQO2lfcFya6/RIAK0B2Di9mtzAux6ioNy8S7iAa/5h?=
 =?us-ascii?Q?3sfbB1VO6ZJFShaW53MMVCb0HJCIK58R2i/h33IrwX7wzwGU5YiyVXmJ8k/J?=
 =?us-ascii?Q?4dYffetUepgevdn9UcGFI4zbboCXgRGb+HmTjw279EgByJGWahDfAf8AQvl3?=
 =?us-ascii?Q?LK4Pm+PYLye3RqV+kp0YMCGTBoWqw7+563O05DpN4oMa3oUjB1OGNMw28olv?=
 =?us-ascii?Q?rP/7VHfRztPtj5nEXlXK+/S/sdvG4vbLECsYVZLO/AO13mfUwulIjWG/aZ8+?=
 =?us-ascii?Q?NDwkgrCCmigntjYsDhwAHBHbaK1ZxnjeEkMSGCZbYiOPFIeP0xIcIHxG5+fU?=
 =?us-ascii?Q?BVtY3fj4ZKn1tfjNl4+j4bcEueKUEc6sX6PoqetsxBNmG5wnNXVRNdoGf6Lo?=
 =?us-ascii?Q?Rv7tO+/FIyuNgNUs1WyJu2Fux2xDPo4oyfgblQOucE8b+OtiMnsdVSqpz5vS?=
 =?us-ascii?Q?jblHOHNSvYncqBBwp0RdmGQ03n05CGTQVGnQN/7N2g9WidwQuQ6ub2uwADil?=
 =?us-ascii?Q?qJpT2dGKG4eL5xg/+Hy0xHbs0xXB8otY2FvZIYo58Dsm2uh+uJdkOd6QpmWD?=
 =?us-ascii?Q?iU7sDOR5XmGSQFpHc7pjKAyTvDvg8ps076djy9FwsDVFdEz22uFhE/tM5Byj?=
 =?us-ascii?Q?yHceF75bfk1xR04+ozLsXwZiE8sRZV7Rvsl6EpLYTq+CxaohYl9O13YN8Ig4?=
 =?us-ascii?Q?agUXie5Ggp3qZ6FpATMhq4MyJVD0ym9R8odgCd8dwTaHkrvX0fVOn2HWmh+j?=
 =?us-ascii?Q?YuvZNQLThmdNChJMoodJ8UA2PvuZneqUJ3A/1436aRacgviK/q1sgKWLwK8Y?=
 =?us-ascii?Q?sMZyBybsic0y+mKxqTywJ4El6eMzK262j9D34WZ0FQfOG/DPELHlTy/vplgX?=
 =?us-ascii?Q?4RGajClOh9Y7HGR7A2VHnuCzRO2qApA1XQQHT5SFaLPJ8ET4YSV+x+aCDdA7?=
 =?us-ascii?Q?LKhVvPPrN5czlLVfysW/MN1ST6yzzxXh6Xn39Zq3OqxXyP96ud+Y3YSzVVLV?=
 =?us-ascii?Q?jweA7nAjLNHCRrr8NtIRVOs/8p9Mo4Sa/D8/i7PO65e/rwDyUw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c0/Vb4Qe6qezE5CKBH2HcaMxZrYxVRJMIB8cH9G8SNexfxnjZwl7LPFLNx/f?=
 =?us-ascii?Q?Q5sgU1qcXy0DM0s6qwBeBwTAnb8QbNAN+hg4S0JhLCI3d/0p/iqopH3BgzpM?=
 =?us-ascii?Q?JHH5VbEkTMFdIaqJKzL7TbPAN/xn3P0/JcH8IQw8wSOQMUGJMXp4zRipETQ3?=
 =?us-ascii?Q?kZR9//DEzQdqDQN73OKWzz+iRRtFAbBLCTBEYN3Ty8iHD96k1Cu72v8nkY6E?=
 =?us-ascii?Q?6u3Wwz9CmTWwohtickZLcSsPmEmBK2sEbQBklHpkuJY1CmqmhG0V+5wOM3c4?=
 =?us-ascii?Q?EMHw9Rm8swPENexGK0+WaB4+A/T+ZprX9lpzUD7GIP3pL6s82P7vxnnnRXbz?=
 =?us-ascii?Q?I6xOCo2mk7xvd7Sas8M2OSE4Kydy26x3qkj46EfnpAAkh9PN23s3XLAcyt7X?=
 =?us-ascii?Q?MFJz4XrGM10rrvYhzXAc+XjUV6BiWh+bMUfHq7kRDceX/+C8vLSoYoDITXuy?=
 =?us-ascii?Q?hxtD7ZJr/4ShsxXoQUJhjrN4BmTeyMMrYFPw82uFOhyymfdtvSqyKDqnTN5t?=
 =?us-ascii?Q?J32AAoQ5wtlNZZHp45LvzcEbNDbffpLlDrI+7hPS8d5/CdcocSTcHYqUjBKw?=
 =?us-ascii?Q?qjNqc1ETITv1VegVjB2MBqgEbTYn+b4rAaQzO9hD/jUHSaaO7f2gJW07/HOr?=
 =?us-ascii?Q?sgrVZB6DosoFI12pifl4hDtYZa7JxgzNaGsy7mgWfA4dUbP5gLHdLV56UY1Z?=
 =?us-ascii?Q?Koson+7H1Z6ibuGkbZyFFDatV0Gujjd5qvkGbkxSHAHHJf7XsoAA6DgBY1EB?=
 =?us-ascii?Q?qFU+PmZXH3qRl6WYeohwmaOv5IX4Hs2jlpf21i9BCct/0n5Lw72a1Y5Q4pq4?=
 =?us-ascii?Q?B0tp0oxDwaH5JRnhgL8DSnSpwbPQ4sybecpsV8EZ33R5xYVz0GhSiH5u2JVv?=
 =?us-ascii?Q?1VqSlkbs/shK5JfneDwEaROwwS+kcKjwiHOBmA/6sZjY6KsxIbuMQ98YiXLJ?=
 =?us-ascii?Q?4lzSbb4VwoiF6c7oP2j3OWxTdjNetTiw2QQWin8YzQ/CZR4kxTU3VA6RMqGS?=
 =?us-ascii?Q?XXqK8rmTT4D7AmUCkKSvsBW7RZd4Ztq73G1hSNNdhqGx2C6gel6zYtPoURZo?=
 =?us-ascii?Q?sU0nBQoKG3UkimTOHzFckYvL7rcmZK6BKlJDgBE4K1ez5qG6MqAdzU5APAyz?=
 =?us-ascii?Q?40hhLdGARDpCftRry8BL8Jk9f7y8G426UqqxW0dtsMl8gVdYqvQhiz5HaIJl?=
 =?us-ascii?Q?GuHvILlKFbedPbnrtPJF1z/d4xswHmbLExZ0MCfprQ4BY9I13Cr7tlVxBucs?=
 =?us-ascii?Q?Dy3zn/fmz4lS563ucUuHiJWpr3TbYM/szejb5z+nvc1gHaX1EeZvbRv2PABr?=
 =?us-ascii?Q?5CrldzplK7ZD5Sr+klXOyjV05lnpmqG8VJT4w7o4rZh7f+dnV/d5Veda3U6U?=
 =?us-ascii?Q?5YrSEbJQQ6ICyvuEJQwfFjNebVdUAnG9UojvZrjYT+7n+voANhG8MSeWJWIN?=
 =?us-ascii?Q?aRW4eeZ2a3a+QW6aV6Mtj8rGO+C3HgpTAZWWOvJV275aG2VwZn+kxy8l3V5i?=
 =?us-ascii?Q?BROoc/LSENnmvWdNAbEOn2yGXPUR++XUWgG+G2QR9cWbCsHyQw7XOCVrDWPw?=
 =?us-ascii?Q?LSSwYYDN315JW9qGEFZk5u9REOaCuOCUpZh8HZKN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 177b292d-9096-456a-3dde-08dccd84d4c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2024 08:29:16.8792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shpzVBVQxdjY55eHofO0OLOJA+bhhoJwtWMjaSB1cwge3RkxSIfv0BA29872QiRA26AJzke2bsvK1kwllLJc4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6268
X-OriginatorOrg: intel.com

> From: Williams, Dan J <dan.j.williams@intel.com>
> Sent: Wednesday, September 4, 2024 9:00 AM
>=20
> Jason Gunthorpe wrote:
> > On Tue, Sep 03, 2024 at 01:34:29PM -0700, Dan Williams wrote:
> > > Jason Gunthorpe wrote:
> > > > On Fri, Aug 30, 2024 at 01:20:12PM +0800, Xu Yilun wrote:
> > > >
> > > > > > If that is true for the confidential compute, I don't know.
> > > > >
> > > > > For Intel TDX TEE-IO, there may be a different story.
> > > > >
> > > > > Architechturely the secure IOMMU page table has to share with KVM
> secure
> > > > > stage 2 (SEPT). The SEPT is managed by firmware (TDX Module), TDX
> Module
> > > > > ensures the SEPT operations good for secure IOMMU, so there is no
> much
> > > > > trick to play for SEPT.
> > > >
> > > > Yes, I think ARM will do the same as well.
> > > >
> > > > From a uAPI perspective we need some way to create a secure vPCI
> > > > function linked to a KVM and some IOMMUs will implicitly get a
> > > > translation from the secure world and some IOMMUs will need to
> manage
> > > > it in untrusted hypervisor memory.
> > >
> > > Yes. This matches the line of though I had for the PCI TSM core
> > > interface.
> >
> > Okay, but I don't think you should ever be binding any PCI stuff to
> > KVM without involving VFIO in some way.
> >
> > VFIO is the security proof that userspace is even permitted to touch
> > that PCI Device at all.
>=20
> Right, I think VFIO grows a uAPI to make a vPCI device "bind capable"
> which ties together the PCI/TSM security context, the assignable device
> context and the KVM context.
>=20

Could you elaborate why the new uAPI is for making vPCI "bind capable"
instead of doing the actual binding to KVM?=20

