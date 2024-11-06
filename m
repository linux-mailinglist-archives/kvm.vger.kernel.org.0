Return-Path: <kvm+bounces-30859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 572919BDFD8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B72E1C21185
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05CE31D1E62;
	Wed,  6 Nov 2024 07:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fmF799fg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E801CC8A3
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730879930; cv=fail; b=Wa6zmcQ9pGChLf1VFQKIzleSLSKEnxurOZjal7t9ixOCTZcdSwFAyQJ1Ypii1tFY2zT1m0KPCQ7CpzJHTytWZ0yA2IPFpC9BXNIiaxmdv9TRy9ap7CWeAYHWhqZXTsUwM/t0jy7FzBRSirv5tcAPsezUQO6pUn6ezPO6WUNfihU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730879930; c=relaxed/simple;
	bh=uwFkITUm2GYanLaVA+8/vOnyvOHpg65zPydL007nHoo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nkzBH5YgHqkVfQ17XLTlttW/jXKV+nSuf66QnAp0/hJJMIdoHEymYxodJq+6Xv0SkRez+IrRv+rLEWp2MzEMU3YcP84FRV1K2PHtNe0g+HOwtealuYojx8a+zlLqVAJP4yguAZlsXdV+1bycL0+rYJ5Exe09Y4jzc8EobprmfxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fmF799fg; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730879929; x=1762415929;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uwFkITUm2GYanLaVA+8/vOnyvOHpg65zPydL007nHoo=;
  b=fmF799fgaQz3MOb1Cmc9jvZHz4lYxk6GVJCLWnXU3c0LgvkVkLfNL1wZ
   4jNGww2F79tRwov6w+W6UJRN6cQqxEHqiwzAQ9OlIRaTH23+4qGnkcPzO
   gShXN9zubOYft2PNUgr35ua2FQExyA2BoGyN1BdsIYrUKuCMT7FrGDCb3
   2Z1e7IQROIskzfnilzLxV92ZNGiTNcTDFQYHPupzG/XrNDqukiMa5DD4a
   FoYnRk6+D4lEtGWwa6kvfxnHL3AVexBRu5HadD3qtVnae0DgOnTCcw1no
   tJy+70s+Hil9Uiuw2zwZ8ZuuuLquyD73lSoRO2JUMTQQ4wacwrN4INBZc
   w==;
X-CSE-ConnectionGUID: gcKd4QpuQG+GkN6iAIW8iQ==
X-CSE-MsgGUID: qvvLHhCASBexh5l5sGHh4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="42062310"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="42062310"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:58:45 -0800
X-CSE-ConnectionGUID: Qfi0JZz9S+K29isoBj04CA==
X-CSE-MsgGUID: il6bSjEESvqLXFAQZD4PQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="89530217"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:58:45 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:58:44 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:58:44 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:58:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cMtDqH0qySL1EEclh+lQsz/jLxD8MiwiteX+VWHz5DQ3S5y+72EEBngaIA54JFjXs/Zu2k6rqjWHmTWx+8rgPLVea8wJYkaqXFBAmfMgx7sQsy8gAjiTTm+AIAHveIYVRkPpKb0dbgLVM3FptpIkhVUAt8lSIcv1I357FtSTzkAgKOpSGuKs7sWDdimUqh1WiGkn6EcnuUb1JmR0obNjooNgL2LrIe0yZ+8Nd52KwwJYB88y3WUi4KaYERPe5ZXDSd9fQKutGgp13GFGxrxsz4UJ4gAzx79m/VnHKMn14KYi60N0noYdz9nMugZz3TOpHERcWCGpl7DaBiI8vn4egA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwFkITUm2GYanLaVA+8/vOnyvOHpg65zPydL007nHoo=;
 b=E60RdpDYh+3E8VvoryZvuK2pNWWcW2lVw/HC3VnAyRv6L3K4Eg7Cq2YWMP1UekiH/RR8gOKo+QnfsKhUgPZ3oEL1lRQtWRTMnoKg0M8LL5XNNzYTJwj+VwK6/N+oOGkEhZ5i4HVCwTYUGCIxgjLafkpZAwJaY9/TVBZ1i0wbf1Mf0gs8RYnKzWuhVojjVbk4G0vg6TfyXhntmSL2g4M58EZ+WWhNb+t+R8Qij+aP7CdLRY4fSDN1aB/NKFnvb656dqe6Wp0S8aT0i85H0asEYV35pbI09vJ9ytbGJrTe4dvngoVvKrGfZKMjgCGxUu+Ft0kTnFECeL2K1IWB2gGLtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4948.namprd11.prod.outlook.com (2603:10b6:303:9b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 07:58:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:58:41 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Baolu Lu <baolu.lu@linux.intel.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 10/13] iommu/vt-d: Fail SVA domain replacement
Thread-Topic: [PATCH v4 10/13] iommu/vt-d: Fail SVA domain replacement
Thread-Index: AQHbLrwic5UIV3jG90a2FvtbC2PFz7KoCKKAgAC8GYCAASEhYA==
Date: Wed, 6 Nov 2024 07:58:41 +0000
Message-ID: <BN9PR11MB527636541464EDC2DB4EFDA08C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-11-yi.l.liu@intel.com>
 <0781f329-49a5-4652-ae94-d0bbefa8dbb0@linux.intel.com>
 <20241105144339.GB458827@nvidia.com>
In-Reply-To: <20241105144339.GB458827@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4948:EE_
x-ms-office365-filtering-correlation-id: 69deb186-6fb7-441f-8809-08dcfe38d47d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?FKAXZkfrDczbcAkOvG52cVbuuAANQBEeBwsHDeevz6ewSWTXs5IBeHv2g/uV?=
 =?us-ascii?Q?y/RUCbfn52ZfbjF5x1BygnUUrXu056hGIyrZyn+Ni3UJyw5Bh72L0pdRaQ7U?=
 =?us-ascii?Q?iF9umh3E0l9EHd6YYqyznJzW1m8XX0yw21TaaBtjyq5Mnsw/ArBX+Wb0fJF2?=
 =?us-ascii?Q?6lgPKZyruTvOKLPiPtdCEPd7NnHqiDvD1RXKZctOi4/KZwdRrNQF7jPoeOij?=
 =?us-ascii?Q?kOAWgQpb//MVrFFU2RbNfn4PU2C8gl7pI2dm8ZqshgH8r++4EQ6JtcefFDhN?=
 =?us-ascii?Q?m2kh3jvFTk6Ld60sdUifpxMqAV1ST4w7Mz1kbt7f1AqLHiMESQfeiwgqym1P?=
 =?us-ascii?Q?Y+gtL3pzPg+U4fM3jnqf8mhjNCYE7yFID3Rim3boppDsbGajAtmWfjULDlw8?=
 =?us-ascii?Q?b3BmeHJflYJc2svxmokwgDFA6rJBtlJ/MV39sXsrPGIczYhup22wcwBRQLTi?=
 =?us-ascii?Q?Fg38xytDDpJdo5MOhFsZAGakreeJBLGIylI6JwzP295w1MPKXxPXFowJUD9S?=
 =?us-ascii?Q?FVbGB9Xzv8bMBMG5Q+36LIeh1V92k45e6BIrDQ6UIUGaHdv9pGgvJS3+WDIF?=
 =?us-ascii?Q?TWbej0YL4ywTk7QGu3971dTdaBEh13IaMe9MNWPhvqvJiEZWyKoOBsJOSaXP?=
 =?us-ascii?Q?J+t8MuVLP4hj5p5t6dJO3cMyXN+9bs4rmB5GyH6lOB9WTPGH9Gv2MIHtDrhw?=
 =?us-ascii?Q?ZnwgisxrHEltRHqZv14A2cE0NLCuVALB/VwwzUamsJx2sf94Ju5fBsU8SuIe?=
 =?us-ascii?Q?0g21VKWHzQc2jd/nt5ffm8AP70WH6Lj+nUQPTaH/DjxgT4OvWjcMJ9nfrmZf?=
 =?us-ascii?Q?TfuC3qST77TsgbLj0LRm5L6tVlUCbRzJvKwsESzJKoOrxEQvW8QXdksnRjyp?=
 =?us-ascii?Q?7D4R1OkuR5hmbTc2U1r1ktpuP1Ew9ZOxQTcYlZPzpI4pGFiy1Xih20pEshcD?=
 =?us-ascii?Q?ROiy+R0ftUmxNMyHfGQgluMMJDfi9G48DtkYNp3aoO5LDsz+Sg5I96YOKLQ8?=
 =?us-ascii?Q?1YinZxmGw2aCRle+LAxqlZfbNV6fOx1jkGmpIxmKgAE4rhyJVZ/PIKi+RKBz?=
 =?us-ascii?Q?DooVDmgD8rRI2G9k08y8z9PsTG1q4am3gdKZlfURDbUBg5WuEtX5ugcULuRP?=
 =?us-ascii?Q?KxUP7UC5tyX3VYf/mPLgMPnrsiUcDywjftAQ4H8ti8Z8gaaHD8Ux8mrMNJ0J?=
 =?us-ascii?Q?lkqPtL0iuM8xf6s1Gb+MdB0C2/0uX1nEXaMEowR5V+3gRAeTifOHZYHWsR6v?=
 =?us-ascii?Q?9CAozHYb8bC5tPzxzrxVAO6W2m7gZXeV9z5krFVfBIDQXAYdjFOU/f5fV3Us?=
 =?us-ascii?Q?dpY4hmaMhhIGv5yuM3bVN4ZiH1iD7wzLyHDox26njFURE3ZNvnv24ziShf23?=
 =?us-ascii?Q?RRWB/uw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z9BE6UOJBxacubbicAC+7C3BRqdwfgsUn1fqpCTtgYGSdeorLb7tuDUzM4NX?=
 =?us-ascii?Q?3vMlYjpXVuZcvxKdTZHzqZG0RzJwUFmt/V20GtceJrjFuACQTW0mu062Xy8k?=
 =?us-ascii?Q?eGl71EAXMoU8GaNPT9dUbtxuNIMz/Cak71OPCj+64Dld7oNc25WdhMQM8b98?=
 =?us-ascii?Q?RCxd/G+1nHI1R/OutxnBkZ7EJJBu4whZYpnMFCaqrgvPArlrTxoy6kNI29Ek?=
 =?us-ascii?Q?NiHIeJ0o4lJVqErXLxK8bUZUHvuK5/xl1sjdcqDzpkxNpV439JmUqdEgwhcf?=
 =?us-ascii?Q?bbCigEUPoev1VYxJ+pa8zGTSKVHKFJkFb63hflroAFl7n0gNJ26aCDDQBP4O?=
 =?us-ascii?Q?7MDfPKojcEPdo+BU7ImvEJ6yVNpmKKOZgrPoKfrj1eEk0Qw4j3aboqnwBqPx?=
 =?us-ascii?Q?0QhPQyn1MX2+CR4rYFgetjOu2wRUgv9EV5+K0DtTrkY2POnYwM1F5ZEf7eWQ?=
 =?us-ascii?Q?x44bF0z5/IVHaoZ+skPOt51Cy3k4i6azrVR8vhy7IqdnAbooeBSZEQSfoLkZ?=
 =?us-ascii?Q?ofQx4rnFeUxy35CvKQo/2OncS8UZI3ELjdEajLMG8zqkqfV1ETTLbVoA+vEd?=
 =?us-ascii?Q?15FfnOCeY89NuOOfEmoeeCvP+yzRpkdIG1fmD4gJlc16mtprjRgEFrNS/np5?=
 =?us-ascii?Q?Wrp2FjaK+vh8xorNsX1Jl0iI1OZJoMUWeV+A1XZonRf0s02Kk05jYDfZVSeE?=
 =?us-ascii?Q?/iErjFeKeI/luwULDEE8KMS/Xl9gFZPKXgOl1GQNHGsN5wdKeiOIt8ZTfg1l?=
 =?us-ascii?Q?ttVD3iMmfIRvMr0T982cPVovqOQ0NJgCsqC6YkPaSfNSt6OXNN8drOh/Y8AQ?=
 =?us-ascii?Q?OIV38l9Q+My1SrON0+sIBEirjqhXEAuBzTN0DNPEoEcuiBPOjNlO5Y8id1Pa?=
 =?us-ascii?Q?wVa6Ul2OAocnT2xRwdDf1nhvlNmqC50Q38BrPe7ds4CvcFnnje51qQYZCS98?=
 =?us-ascii?Q?AZFpEBlSwZJ7MPEK1Whxil+DKl+M8k1hQRKjQvV1CTWCDRSK05OsFnRJwg5g?=
 =?us-ascii?Q?HSGaKhOnLFTzPySgkM7Vy14pB4AZhpUnFat+mNRVWgO7DT0FS71+HuA/kxAO?=
 =?us-ascii?Q?3cKCYQ3Fn6zRmcRW4gIp9YrGofXHOUNhNHPtw7wQVm2cp2yZWO9STcQPnOdh?=
 =?us-ascii?Q?8xw09YqJSNnWw+hrxV7716LoKz4qoePshHF+6G3GAnX5y2+0N00Pnwy7O7t9?=
 =?us-ascii?Q?J5JQXbjW1OWnma5p39vI3heJ65aDYUgItxNZqWQT6h38XA7dFN1az5jclPdi?=
 =?us-ascii?Q?r8kRs+nvs9Jr7JX03+hD8nJS6pmyioxqNHhx+Y1SIc7GmtlCfSd/vdeO60VN?=
 =?us-ascii?Q?bqfbbt3HDzBqmyNlLgHlc3WQb4WvvNUT1y6N6UHhkS+tzn5mGtrcsCaq1sXC?=
 =?us-ascii?Q?p1bYruqN/RYBRgW/BLOTZNR0olSizCo8xu6uPbksrxwBVnLZItuAqTVGbrRX?=
 =?us-ascii?Q?sUglTmqtjTfs7ZDeXHJl8HeTXgksx33FC6R0PSwqU9h/F8+uGDoliflnuhtz?=
 =?us-ascii?Q?7SW1wY/uETaqUCCpQghvRe8JYrg3ye9e7u6shfq96cHQ+AtCBbE29W3Vql72?=
 =?us-ascii?Q?Wh9801O/Y4OOTFYHZoJ7EpagbYHygF/xckn+9v67?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 69deb186-6fb7-441f-8809-08dcfe38d47d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:58:41.6329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZrzlT2iXdIQWf99P9fzqRIbXl0eClEx8spXO9kW4K6qVKqfqxlDV/VYf2Mh/pbmxZgL1YVQPEmLoSc2cj4/H8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4948
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, November 5, 2024 10:44 PM
>=20
> On Tue, Nov 05, 2024 at 11:30:25AM +0800, Baolu Lu wrote:
> > On 11/4/24 21:18, Yi Liu wrote:
> > > There is no known usage that will attach SVA domain or detach SVA
> domain
> > > by replacing PASID to or from SVA domain. It is supposed to use the
> > > iommu_sva_{un}bind_device() which invoke the
> iommu_{at|de}tach_device_pasid().
> > > So Intel iommu driver decides to fail the domain replacement if the o=
ld
> > > domain or new domain is SVA type.
> >
> > I would suggest dropping this patch.
>=20
> Me too
>=20
> Drivers should not make assumptions like this, the driver facing API
> is clear, set_dev_pasid() is supposed to make the pasid domain the
> translation for the pasid and replace whatever happened to be there.
> Ideally hitlessly.
>=20
> Good driver structure should not require caring what used to be
> attached to the PASID.
>=20

Agree

