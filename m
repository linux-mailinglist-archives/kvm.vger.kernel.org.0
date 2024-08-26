Return-Path: <kvm+bounces-25066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01C0E95F87B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 19:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADEE02840AD
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 17:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D1B19885D;
	Mon, 26 Aug 2024 17:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lw48wV1d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EF12A1D8;
	Mon, 26 Aug 2024 17:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694398; cv=fail; b=YyhxQ8gLmdGGvpyJ1aN39krCgj4joFE1wtZyUCDPW4jAsZMV7jF6k0Cx0XbRt1zpetF90eJfG5jEBmeUlt50LDpJ7pewntk7CEY811Han1NpXn8dUgyeHRoPP5meTb2paBSW6nvAog3ijarrh89lWPqlfUq1pq85XMfUWwRc0+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694398; c=relaxed/simple;
	bh=uUJDk0Dmc7ktaScpQHDCD0KfISyby2Lln6nex2cMN6g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eWLBuyHpgzsM9W5FrWoskOUPI74QUc69hU5/Orol5gDFYjVp8pNqc8+6Xxrv4gxESGp3KBrY2FlJcDiT4jzebfKeNrVFEUNY+0USLdg3hyACMHT79LmRwiBb6yYJ2Ru9nnRJpdfI/1TD8hrembuoTj6jCIgln5dCGZk5RlIhR6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lw48wV1d; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724694397; x=1756230397;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uUJDk0Dmc7ktaScpQHDCD0KfISyby2Lln6nex2cMN6g=;
  b=lw48wV1d1WGorijqBnKemqv5drY6Ry2Dk6HUQhMpRVX2R7IemrEAKdWl
   UN6dIb1p6jwYTRtPK5qVOrweuq6xsiqzUKlJIB3FQwez5iXf1Jx8TpPfR
   dWN6QoQyCQmJYn8Iy3bYI3oJqY4MnEhcEbRP/tuv4YHAyYvW5U/W4KvgS
   832St1qXZHpEUx0/TF8KfK4atXL7zfjFBWGU8SgwFY2uB6cThyGVsKvxg
   0jO9s0vQ508e8u2nIYcXtGjXUEFrBkSTmKnYUb8nHbJDLePgB9Gh+VPbw
   r7WTOA8prxfoTlC3YEDAcezY5ZhEmagQF4bxM9eGoVimPDCJ9Wv+vZZzn
   w==;
X-CSE-ConnectionGUID: ElijRU3hSbiwWVUk8Tptug==
X-CSE-MsgGUID: eBRxCBbBSEKlQPO/L3TE0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="23299201"
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="23299201"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 10:46:33 -0700
X-CSE-ConnectionGUID: i0it4l0TSuG0rHXGX75PSw==
X-CSE-MsgGUID: AKFJ1yseQcqioDCI6bv8aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="67517362"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Aug 2024 10:46:31 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 26 Aug 2024 10:46:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 26 Aug 2024 10:46:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 26 Aug 2024 10:46:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ht487CmGDpOjoBUWNHL5U/7bDAagYVkPIqpDYzZHLI2oKi+8nuWE68RFtp+s0jcy4M0FlftqcJXluGSazrfdZiICz6xModWIteR3S1DkEi9pijbeYzyaiRuQrCqAG7yBZD1fdrpVDiOOMhzzW0iAttqmOovMr9YEzCzh3t4GIkQBTTxR6KOay2Ywe+3pY4Wyte/dJ0QPwIxWVXACCBnxIqRb4Cg1ELw35wPtkVODx4UI8PiEvelVB1aEMuYR6PxtSz0VdX+EAqndaLwBd1W0xEFc35/WaTMO8KWgZpy+iFQe5O0O+xmodNjMUvbS5ImmsyYPdJPRk9nMZfnSeZmFBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUJDk0Dmc7ktaScpQHDCD0KfISyby2Lln6nex2cMN6g=;
 b=TrxHUMQip3Er/FsVMe9VQgkRRnAkukLfeycdlvU0EmTg9H+SF4p+4FDNkn3M//hZndKjVTDgFviDcO44SptvD9fKVjIlo6fZlQCHMu5/aDWWtWXrf1xeVnVU9p2U+QphVc7r1W/xv0aaixkKvBibC6gi4PfeNUR9x0qDPib/MFp3qrJKU6srNwsczSiI1SYfvVjRJ6EfRIFCsPpPOPrfE/5Xz3DJQxMh4hAm6+sw8aZOdxoQ88om3SVS93sPI94ePKEKkDioU4kcmgDW9JgdGrzc6wY/JJBNSa/PJ3m93v+IVgCrSw0mm12Zduz++A4BB04DIJU7fubTJO5mTUuY6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8658.namprd11.prod.outlook.com (2603:10b6:610:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Mon, 26 Aug
 2024 17:46:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 17:46:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Topic: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Index: AQHa7QnRzseVoCBaJESngrUu+eI1nLI5qPIAgAA8uIA=
Date: Mon, 26 Aug 2024 17:46:26 +0000
Message-ID: <2f9dd848f8ea5092a206906aa99928c2fa47389d.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
	 <a52010f2-d71c-47ee-aa56-b74fd716ec7b@suse.com>
In-Reply-To: <a52010f2-d71c-47ee-aa56-b74fd716ec7b@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8658:EE_
x-ms-office365-filtering-correlation-id: 936f9743-4e5a-4606-9c16-08dcc5f701fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aDdjL2V6bGFTUXp5UllQeFVJSVNaNnd4cmhkSHJSLy9MYlBuamZ1bDFrenlY?=
 =?utf-8?B?VlhxRTlKZWVZTjZuUFpINlRjcmp3WThYRFQwOVVRWHMwZE9xYUtNdzdjNEha?=
 =?utf-8?B?R3BVdkhSQ3dHc1AvYUliQ2h4TWJTdjJyMzRKb01KbnlaNUFBczMxejVWbVdS?=
 =?utf-8?B?Rm4xaC8wUzl5b2x5T0FWTkF5bEMrS2RlRElpTlQ4RmdvRWQwN2NHYmxwYjY3?=
 =?utf-8?B?TjZSajBBa2g4b3FGcFZtUUhnazV1QkJkZUhUOVRVR2tyWTRyblVCMk1xclVE?=
 =?utf-8?B?TlJCWitZMU1ScXM4NzlnY3dFelloVUJlQ01rdWkzRzJ6K2wrTVNlTllOVlQy?=
 =?utf-8?B?YkpUWkxSR1NmZS9NVTlkSVJvUytNL1pFSzRmdHZ4SmFMN092WTlDVEFLbjI2?=
 =?utf-8?B?dWN1cTlkTUNMQnhRRFJmd1kxbzRpWHNIM0FzdWtVL0NhSVFCNjFIakNmbGtx?=
 =?utf-8?B?c1h6V21nMjhkMllhQ0JzSlZvMFE2b0I2c0lKZmhEZGFkd3NaYVMrZDVMMVp3?=
 =?utf-8?B?Tm8zcGcveXNWOGlzeW1oTzF5SXV4YTZYd3JZWmhxQnlnRDdQZlNId2xyNFQr?=
 =?utf-8?B?MFRaWGwwcjhvVG1WUVl0ZFVOekI0TDNYeW5UWlNVeWJuZkU3NUVXMHVjSlZq?=
 =?utf-8?B?b05QR0ZGSVZZZW0vNTZGRVJVeCs0L3ptYzUzNFI1Z3RlZzhDRy9aQkRueEk2?=
 =?utf-8?B?bG80U0o2VnpVMHQ1RkdRZUYxOXR2NVJ1bWJrVVcwcUxqaEF1a3hMKzRFTjkx?=
 =?utf-8?B?QkxWWkZUM1dqTFkwRVJzUWVidS9rTTZvQzhKWmlEU3h1cVNJOXV0dGluUmQx?=
 =?utf-8?B?NEFUa3duQkZsbll5Z1FFK0RRZzQzenRIVjlUR2RJak1QRHZrWE5VQktZNUlW?=
 =?utf-8?B?U0s0WE11U3prWEo2TlU0eGhudGMwOG5YUFhtRS9wRkVBRkZyMklTOWk2WFp0?=
 =?utf-8?B?TytGdllHbWV3YmZDQkRZY3RLNVZFVmJ5MjM5RVFUaWhtUk1Vakt1SCswN3Fu?=
 =?utf-8?B?SnNqZkdVeFhaYzdCS0tOWHdJOHV2VXFQM1U4N3dKNHh4dEhYVEp2R1FmNmlD?=
 =?utf-8?B?aTVqUXgxSFkrYUVsNUp4RVlqTk43S1JVUWQ3RlZ2cXNsV0VaMUpIbjdkNGJV?=
 =?utf-8?B?YWNOSCtkY3JCdmM2TkdFTzNsQkt0dnRRQ29qL25PUjl1QXVZY1JQM0JNNEN0?=
 =?utf-8?B?c3NVMTRrQ1pLd0Y1RFF2cDJPWWwzeFBNc0hNZEVqZHEzMDQxYlZYZloyUTRx?=
 =?utf-8?B?L1JMVjVSZDJtaTh4YUVkVWNURlJuS2VUdUViWk5zY3ZneVd3bVlWTmkzR1Iz?=
 =?utf-8?B?RGQzc291MHdYNnl6bjA2MndRM1JEZ3hoODhjdmtjcXR3ZGhWZmhRODc4eFdy?=
 =?utf-8?B?WkdFcS9UU21ES2V1OFBuSmRhVTVWZFNDZk9Gc1BySTU5bkZjVWpaZXVBc0p2?=
 =?utf-8?B?TlpVRG1tRkxzZUcxYkVyM1NIMCs2WHQyUGs3ekczYmh6MWZqekdJYUV6NVNF?=
 =?utf-8?B?MlFKZzRNNlcvZ0g2dWRLbW10SEh4QWUrRGJoZjF0T1VtVFoxL3A5b3pYKy90?=
 =?utf-8?B?NHZmRHRhSEtjdjlBUEdNN1VxOGtKbldrTmNFcFUyM1RPVDRHMk5hcTFuSHds?=
 =?utf-8?B?ZEdlQ09vdVErNEd1MmhmcDIySUsrK3hneTN6RE52dGxJd0ppZ2s4clp4VEVO?=
 =?utf-8?B?WldFVnJrM1pvVDlxdjZOTVhETndvS1p6eU5wOHA5czRBWjE0VGptaTBuM0gx?=
 =?utf-8?B?ekE4MWw4WXp1c3REVmlsVFNENDFSajlXSzVWWlJrQWxwd3NkUWc4RVNqMjVH?=
 =?utf-8?Q?JT4hW5eHKanAwmWUBD/+U+9G6v4QwiOUuJQhs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTZ4RnlZN01xZWpwUWRFRC9jcGhQZkVMOVUraHFJVHMxWUx4WER4TzFNazRD?=
 =?utf-8?B?L2pudnlORllXMFVWSHd3VVFxTmlsdGVuSmZGOWJ0bGhCcTBQN3Aza1lXZlB2?=
 =?utf-8?B?WHBnZ2tKWlNvdTBBWmhYcGl5WDBjWm5zN3J6RytKRngvZTF1YmRhcGJOdVFV?=
 =?utf-8?B?R3p1Z0V4cSt6cUtIOFUrL1lpaVhlN1ROU3l5amt5NEpEY2pKRmxadDA2dkdP?=
 =?utf-8?B?QlpQQTJOSnNkVWhSK01DbmRTWTNrbitKVitudE4ydlpobjRnYStGNDJmTWVI?=
 =?utf-8?B?U1BXcS9uSW1iQnhxeEVrdjhVejg4WER0amNFSFk1OFJPNUZQRFN6ZG84bkp4?=
 =?utf-8?B?a1ZkNVI5K2E3K2J3K2twK0hqZlhLamdSTWEzNlhFcEpGbnZNZ29IazJUZUJq?=
 =?utf-8?B?ZTUvTUZ6REphY3VKd29Td2hlR0c4WFJTWC9ZcEhNQ0UxNllqQ1dvNzU0WHRr?=
 =?utf-8?B?MzU3RHVqWkJjcjZKYmdQbWJONEdRZDdFT3BWblBYVVRHRjNhbHdTZVF1UVV4?=
 =?utf-8?B?S3FNVzVQRnFWVUFIT3lwd3paeDltQ2l4VUQ3dmNNRHBDR2xwdVE1dVhGeG5n?=
 =?utf-8?B?T0w5dHppTzFiSGNxV3R2T0xzbkVFSGdreXJWaDlQTm4rNU5CaWlrbFlMK2pV?=
 =?utf-8?B?T3o5UHdRQkF6ZW9oVi9CdG1sYnRpRnBBNlF2ZE9TU0x1ejFjNFFiK2pRNE96?=
 =?utf-8?B?a3h4Z3ViWEh3b29QWDBGM1BVWkIvSXBRN3pJS1VOOVpaUXVwd0NyK2tPS1VZ?=
 =?utf-8?B?TjhxbW5OVU1KVUU2Q3lCL01MSzk2T0VDWUg1OURHMjJJS1IyM25MNS9sL2dx?=
 =?utf-8?B?MzdJcEV4TjJidDVxVElOeXNmbW1yUCtkRW02VHNsV3ptQkJZQmhQR2RFcEZt?=
 =?utf-8?B?cjR5R3U4WGt1WE5Qd1AwdDBzTnhnNVBSNk1MTXdtODU4aDJ5Q05TSWIxSm1h?=
 =?utf-8?B?WmZjSk5laWRGbHkwYlZUOGkxZ1dRZW9jamJsTjJhNFdwT1ZhczZiLzY5T1F6?=
 =?utf-8?B?allvaEhKYXRLQ1FXTFZQLy9HTEJCMllxWlBicmU4N3dPSWN0NXRvZHcvNjlB?=
 =?utf-8?B?SU92aStZMFFzV1Q2bk0yUlhoNmlCckxXbFNGUURPMVh6QUNjaUkrVkM2eVZK?=
 =?utf-8?B?WEtUVmlrM3l0cEpJM1Vid2xDYTU1ZDZzVkdxcVp3aWZQUjJ2c1pjYmxLZDIy?=
 =?utf-8?B?d1A0Zy9NaXZhSXpoQmpFUTZhS0xjcHVMMmljOVFleTNjZzNsV1V6bFQxL3li?=
 =?utf-8?B?enpZRjkva3lyODg2NlhqWVVvaEdkYVdTNnN3VEFjeTROQ1ZITU5jVFJ3VHFq?=
 =?utf-8?B?cCsycDBBRmZZQmU3Tlh0eUF2S2ZTSXRXcGlSaVNuWStjVGN6SlpmdVFmN1BY?=
 =?utf-8?B?L1ZXTjZGRHF6enpDVFBPY0VqR3BYNzZkRzY2a0dSYk8zL1pyUlBYTEJtQ3hI?=
 =?utf-8?B?aVo2blNwc1gxeVBKOXpDUEdoaVRhbnpHbU9YNjJIRWxBM3JiRGl5K2FNZnMv?=
 =?utf-8?B?dEtLTG1zTUxyK1MwVllZSU4wdmRjUzg5SzUwcUpjSFIzMnNyRlovR1lpaXlK?=
 =?utf-8?B?K3llU2ZGMTBGUFN4RnN0MmFlb1J2N0JRMVY4VGxnZm5FNVpDRG1EZG9JWWNh?=
 =?utf-8?B?STFMK0lLcE1JdXIxTmtEZG1kVWlIa21HM01Pb2cxS1BYWno3Z3FLNWkxdlhj?=
 =?utf-8?B?OTZxZlVVa0YvRTF0MFJRTGRocTYyeFA1UndLRWVLV2FQU096blFEbXNlcDZD?=
 =?utf-8?B?c1hZVlN1RnBnZU92TU9kMUVGOEVRdXZFbEY5cjZHeklaa3NxZldIWVJXRUEz?=
 =?utf-8?B?c0t6OG9zVXdNdVZPMTg1Q3U1QVRpbEE4Q29COUI2WHBTUG1JNUxOdGJEU3pJ?=
 =?utf-8?B?b3Y4QTBncER0M2Jra0RmbFhFVE40QWM0eWRHaE5vVnlBZk1uT1hmbkdoSDI1?=
 =?utf-8?B?SXNxL0ZOeTRDQWF4dVIrTmFsc3lWREZDVm1UL3Bzb3RhdE5aKzdvcU5MMzl4?=
 =?utf-8?B?WTFTT0hVS213WnZsRzBxMDVha2ppVW1ZZjFMYlYvMXVtSXhnM0RIODB1Umln?=
 =?utf-8?B?YUdJalQ4aW5KcVdNN2g3RUJ3NWdIMHJ4d084VWhLTFZTNHR4RFZMY0tjeWF5?=
 =?utf-8?B?U2gwellzUytwSEdmVEtBQTVRc1VtT2R6QmEvK3JBV2Y0aUUycnJFS3J3Rmtm?=
 =?utf-8?B?bUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C2696D7379E344FB4199FBB99E2A37D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936f9743-4e5a-4606-9c16-08dcc5f701fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2024 17:46:26.0399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pDOaFOfY24Qii0cKZgv+N7Y7IBKpEuJoEGY8BEoidsutPZ/rNm0La0PiEHhIL7fmEeHyS9P8YGt57kHYgklm9+eBz51tzm0HzQwAI+jVBnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8658
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTI2IGF0IDE3OjA5ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qDQo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqIFdvcmsgYXJvdW5kIG1pc3Npbmcgc3VwcG9ydCBvbiBvbGQg
VERYIG1vZHVsZXMsIGZldGNoDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAq
IGd1ZXN0IG1heHBhIGZyb20gZ2ZuX2RpcmVjdF9iaXRzLg0KPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKi8NCj4gDQo+IA0KPiBEZWZpbmUgb2xkIFREWCBtb2R1bGU/IEkgYmVs
aWV2ZSB0aGUgbWluaW11bSBzdXBwb3J0ZWQgVERYIHZlcnNpb24gaXMgDQo+IDEuNSBhcyBFTVIg
YXJlIHRoZSBmaXJzdCBwdWJsaWMgQ1BVcyB0byBzdXBwb3J0IHRoaXMsIG5vPyBNb2R1bGUgMS4w
IHdhcyANCj4gdXNlZCBmb3IgcHJpdmF0ZSBwcmV2aWV3cyBldGM/IENhbiB0aGlzIGJlIGRyb3Bw
ZWQgYWx0b2dldGhlcj/CoA0KDQpXZWxsLCB0b2RheSAib2xkIiBtZWFucyBhbGwgcmVsZWFzZWQg
VERYIG1vZHVsZXMuIFRoaXMgaXMgYSBuZXcgZmVhdHVyZSB1bmRlcg0KZGV2ZWxvcG1lbnQsIHRo
YXQgS1ZNIG1haW50YWluZXJzIHdlcmUgb2sgd29ya2luZyBhcm91bmQgYmVpbmcgbWlzc2luZyBm
b3Igbm93Lg0KVGhlIGNvbW1lbnQgc2hvdWxkIGJlIGltcHJvdmVkLg0KDQpTZWUgaGVyZSBmb3Ig
ZGlzY3Vzc2lvbiBvZiB0aGUgZGVzaWduIGFuZCBwdXJwb3NlIG9mIHRoZSBmZWF0dXJlOg0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2Y5ZjFkYTVkYzk0YWQ2Yjc3NjQ5MDAwOGRjZWVlNTk2
M2I0NTFjZGEuY2FtZWxAaW50ZWwuY29tLw0KDQo+IEl0IGlzIA0KPiBtdWNoIGVhc2llciB0byBt
YW5kYXRlIHRoZSBtaW5pbXVtIHN1cHBvcnRlZCB2ZXJzaW9uIG5vdyB3aGVuIG5vdGhpbmcgDQo+
IGhhcyBiZWVuIG1lcmdlZC4gRnVydGhlcm1vcmUsIGluIHNvbWUgb2YgdGhlIGVhcmxpZXIgcGF0
Y2hlcyBpdCdzIA0KPiBzcGVjaWZpY2FsbHkgcmVxdWlyZWQgdGhhdCB0aGUgVERYIG1vZHVsZSBz
dXBwb3J0IE5PX1JCUF9NT0Qgd2hpY2ggDQo+IGJlY2FtZSBhdmFpbGFibGUgaW4gMS41LCB3aGlj
aCBhbHJlYWR5IGRpY3RhdGVzIHRoYXQgdGhlIG1pbmltdW0gdmVyc2lvbiANCj4gd2Ugc2hvdWxk
IGNhcmUgYWJvdXQgaXMgMS41Lg0KDQpUaGVyZSBpcyBzb21lIGNoZWNraW5nIGluIEthaSdzIFRE
WCBtb2R1bGUgaW5pdCBwYXRjaGVzOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2QzMDdk
ODJhNTJlZjYwNGNmZmY4Yzc3NDVhZDg2MTNkM2RkZmEwYzguMTcyMTE4NjU5MC5naXQua2FpLmh1
YW5nQGludGVsLmNvbS8NCg0KQnV0IGJleW9uZCBjaGVja2luZyBmb3Igc3VwcG9ydGVkIGZlYXR1
cmVzLCB0aGVyZSBhcmUgYWxzbyBidWcgZml4ZXMgdGhhdCBjYW4NCmFmZmVjdCB1c2FiaWxpdHku
IEluIHRoZSBOT19SQlBfTU9EIGNhc2Ugd2UgbmVlZCBhIHNwZWNpZmljIHJlY2VudCBURFggbW9k
dWxlIGluDQpvcmRlciB0byByZW1vdmUgdGhlIFJCUCB3b3JrYXJvdW5kIHBhdGNoZXMuDQoNCldl
IGNvdWxkIGp1c3QgY2hlY2sgZm9yIGEgc3BlY2lmaWMgVERYIG1vZHVsZSB2ZXJzaW9uIGluc3Rl
YWQsIGJ1dCBJJ20gbm90IHN1cmUNCndoZXRoZXIgS1ZNIHdvdWxkIHdhbnQgdG8gZ2V0IGludG8g
dGhlIGdhbWUgb2YgcGlja2luZyBwcmVmZXJyZWQgVERYIG1vZHVsZQ0KdmVyc2lvbnMuIEkgZ3Vl
c3MgaW4gdGhlIGNhc2Ugb2YgYW55IGJ1Z3MgdGhhdCBhZmZlY3QgdGhlIGhvc3QgaXQgd2lsbCBo
YXZlIHRvDQpkbyBpdCB0aG91Z2guwqBTbyB3ZSB3aWxsIGhhdmUgdG8gYWRkIGEgdmVyc2lvbiBj
aGVjayBiZWZvcmUgbGl2ZSBLVk0gc3VwcG9ydA0KbGFuZHMgdXBzdHJlYW0uDQoNCkhtbSwgdGhh
bmtzIGZvciB0aGUgcXVlc3Rpb24uDQo=

