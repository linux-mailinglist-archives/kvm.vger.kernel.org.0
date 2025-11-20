Return-Path: <kvm+bounces-63835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B927C73FCD
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 41EA84E439C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EBD3370E9;
	Thu, 20 Nov 2025 12:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jVzXDKC7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE302257842;
	Thu, 20 Nov 2025 12:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763642236; cv=fail; b=VVM2phaNWY6+AtK55WfuteHLim2Jk/SJVEAAHJDNgKfVijBbIqkdCjIDFn0VkZivrM8XOLnmtTEyOp7HmPigP2Z4/kkZSo19W29bHDlXiMZANd6pKCuj3BdycA2qTKJulmxjHRhVi+K/owxFm29pekuMuDRnoZvtNkjVhGiff54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763642236; c=relaxed/simple;
	bh=UoUjCJBxGrc3TJo6UVqD6eegOpPKuj44H1kHYPfI9jU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aAq5AKlbTSPMRB5Z5PIBL97ztttmPcJSHaBA6HyDP4s6lU830fkt14Guh8QRJBG3zL4Put31qhOIA731adVkEpQPuLzp7NsuOfTdri+wvf5QFzIn86KIsl9M3NOzJ42vr2y+LoddpAn6phag3ofCxEqW4FONzbhOgTLfSnkn+C4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jVzXDKC7; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763642233; x=1795178233;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=UoUjCJBxGrc3TJo6UVqD6eegOpPKuj44H1kHYPfI9jU=;
  b=jVzXDKC7kD2qjaCTK+c8v+fbvjNXIREqZGXv8/WwuMHUaG5YDkhfexcF
   X1HwbYRcTYIOzQPQWXPurDy6/sRZ/okBUQHITn0jTALftv8REuw/JqWQ1
   NsXJUboefC0mZfYuK7H16YsVaEYVdMyMIeVorC2P/RFQr7scezqGNKbi8
   9OWiYYkHQI/txlLTYCCzF5GNtnHDax1tiG1atz0XYUlLKWB8fBXsL7JnN
   uSTz2/Fhhabn5omr+31BPiOnM7oqx2vqnfOL0PMJtNua4271Eoq0FKayO
   elqHoM0qGsZ00bN5HA0D664sNL8XEG0JPgdFR5ZOdLP7FdrXjm6M+Pgl4
   g==;
X-CSE-ConnectionGUID: wzTuqRfOQ1qUhxGQpBBYZw==
X-CSE-MsgGUID: r0jDBkFgQF+Q6eLlPSjvRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76037786"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="76037786"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:13 -0800
X-CSE-ConnectionGUID: uJwg0cIHTuOrFvf+okbuQA==
X-CSE-MsgGUID: S6rA5885RcqTizHr60+Ozw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="190633800"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:13 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:12 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 04:37:12 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.36) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p10XeDB7kt4AoLMVrS8ogD12oZ+swMvJOAuqeQ0IdiewZhaQtNgtkKAkSaHJ2S7dJxFMHBcTuUI9C7CTzdDaWANIdYcOhJYAH2NcKxMrGxKFmDyvdg7xoPSizHnk4ZS9WXudjH1wkAEKEUtGLEcVRDKRn7qc36DH835mDPtNhiLFKkZkLeufH10LC/Y5fJsaTOapdxUqo+8XeI2J+DFOmLZ57X4B1qjbr9GLHIAHbilOm8BrAMtve1rAwl4rRKdtjgV6X5D9h8cTF8MTTLQ3mC+litHGbMNC0RvigHeDSn95FqxG+Q3/eAcr/CJr7TSxYuyOMXYC4+FQDib3KTPNgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZ8cgaMQBo4Z096FXRmjD1ki/ESCMqvv0+65pBwtQ2M=;
 b=cVEfKABPLXyAmGMfT5H7sTZp26EZtpdh+lXmiq48GZ6KSQsD3rt4pptZipXxUVydHq/3VI4vWhzf2Zj3sT4YR+YTytXv80gs0e/r0o/2XOtBuF9dZeeN9/PmzSql0QxFCQO82eit/vRVgI2zlmPMQFwD9q0BEJFZMaxmaH6IQz3c+MHIxBMEvOEv4FHn3xwr2y9IvNFWACXFyeKiphlXqztbY1hG1vLcnaRoI+ZU4P+gNzsjp83veaRWLTjjh6u9PEC7rij9ion+c7JiTry82q1nb0tK+999RxzYm+2tAcXdxJrV9SXgOq+Zm6ccFBEKate36BRgDbzhqnGKaFF6xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFC3B7BD011.namprd11.prod.outlook.com (2603:10b6:f:fc00::f49) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 12:37:04 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 12:37:04 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, "Kevin
 Tian" <kevin.tian@intel.com>, Yishai Hadas <yishaih@nvidia.com>, Longfang Liu
	<liulongfang@huawei.com>, Shameer Kolothum <skolothumtho@nvidia.com>, "Brett
 Creeley" <brett.creeley@amd.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, <kvm@vger.kernel.org>, <qat-linux@intel.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH 0/6] vfio: Reset migration device state using dedicated callback
Date: Thu, 20 Nov 2025 13:36:41 +0100
Message-ID: <20251120123647.3522082-1-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0237.eurprd07.prod.outlook.com
 (2603:10a6:802:58::40) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFC3B7BD011:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e84ce74-782d-4d80-507f-08de283182ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U1JpL3YyOHBIaUZUQ0xkQVRIWk44S0V1S0NGWmtFc1JBUy9ub3NJYVcza2Z6?=
 =?utf-8?B?c2ZDVXJ4SXlEUGlNaXhvU0xISG9QeDE4ZGlIVG00ZGtSd3RUZHl2eHhkcTd6?=
 =?utf-8?B?NEpydzcvTVFpaE1iaFFvcThqRlpzZ2VhNmIxNnVDeFZMQUg3cnp6Yk1XTDRp?=
 =?utf-8?B?dzh6Nk1IRktjdEpTa0gxZjBabVZkb2hoazFWWDBDWDR1T3dGLy9qNkpENk5L?=
 =?utf-8?B?bGRvQzNWUFRmaC9qK0VtdXhRTkpWOUZYcy9OeXlNOVMycHBlQ3l6STl4Y1NF?=
 =?utf-8?B?UXdRNkhYOWRVU1VWamZkcHFrUVEvM2dRMDBpVDR3MlRiQksrUStvTWVkMHNp?=
 =?utf-8?B?N2J4Rm1SZTh0WmhBZVFsRmVXQVBlVVJUd0l4OHBCYWZUZ2YxZm0rV2hWR1lK?=
 =?utf-8?B?S2w0SUN1NnRTTks1QTZzRk5kcU8wNTUveW5UMStSWm4xdC8zU29DZmQzTTUy?=
 =?utf-8?B?bGxlZm9mMUpQQjJJcEJsNjRucTdlcElQZGRkakRPRWs3OHNwWmljSmhiOGJv?=
 =?utf-8?B?NXNtOTFGNWlVT2RCdGg5YWtNTnovdE1xUmVRcWJiVGlaNWgrSzU2ang0VGJC?=
 =?utf-8?B?enJTNXBkOVREMzNvMkkvT01SaFBnRkhiM0cyNzBEcDFyVVE2WUNPNmhmcXRq?=
 =?utf-8?B?TCt4bnlTSnU4aFBqUmZuUFAxbWorVTM5cEsrTlpSdmZOMjhFWmRybEZyTXE1?=
 =?utf-8?B?cnRBeHN1WkpOUVMyRjBPcDVQNE05U2I4TUVNazBXa0FlTFJuNktJWnR0RHBi?=
 =?utf-8?B?S1FBOXgwUU4vbm5TWDROb2hVVUdNbi9oZWR3MHRabFV5bmZsUmFVN2tkb1B1?=
 =?utf-8?B?NXp5dFRLeGJORzYyTXJkblVTaGY3cHcxMmc2VENNbDVqdXBsTGNPVUhtVjRm?=
 =?utf-8?B?azhybEk0K1c5MExjajNyYk0yOGg5eVA4VWR6SFo4d3NvQS91amRHckVPS285?=
 =?utf-8?B?ajFDRmdkWklKYTIrejVHTmhxZ3MvaktKR0dKcXA0ZFRXd0tpUktZdmt3alVH?=
 =?utf-8?B?ZjZXRlNuN09Vc1dmbVFCZUo5RlVMbUF1YWRMUXhhMXJKSTJVTTBTTVdQZUdS?=
 =?utf-8?B?cGZtcE9XUXF1N2FYUkRiQmMzd2NYZGpvamlaNkZaZWxXZlJuZ0hCZUpDWkFO?=
 =?utf-8?B?VFRiTWlPaTFVNStGMUlVaHhHRXBEcllEZy9JWVRVRjZBVzl5WTdtdkF1bUov?=
 =?utf-8?B?VVlsSWowLzFkRWJKckNrd1BkQUROa0ltcThudE9nZUxZWGdrZ20wRGhvNktP?=
 =?utf-8?B?bXc4SmtKeWxNUktFODlMYmprcm11Tno1N3ZUQnY5TzNGT2xMbHQ4TkdqdHdy?=
 =?utf-8?B?ZFpSN2doMVBObGI4VTBLeVp2UTgwbnRyb1FReHRtZEF3cDZGVTFkRktBNE1R?=
 =?utf-8?B?dVErZTN4L3MvNzdhbmFFaUJlZVN2QzV3bmpnc0RXa3luci9YMW81WVpMeEts?=
 =?utf-8?B?dUtxVWJkRHBIdml5b2psUVFTY1BZWndFdUVQa1EzMHEybzczQUVUZkdtdnRX?=
 =?utf-8?B?UmUxb3UwdlNVbHpud2tzRUh6V0ZyUDJ2cWI2SHNRdUpyeFlnMmNybi9XUXpJ?=
 =?utf-8?B?YVRXRW1MZVFTWUoySVlUVzB2aEU4OXlZR3E0RS80MjFzTllCUzdjQUF1aHR2?=
 =?utf-8?B?SDAwZitGQ0RxVGFlSjZBS0QyeUV5NmdzZjRzMDB4ZkcxaWk1clZyVkJCQlpk?=
 =?utf-8?B?OXZabHBJTER2SDUzUWJiUVJ1OWw2cUxTaldPbjl0T2RDU2R4anhkcXc5a1Jk?=
 =?utf-8?B?Rmd5dUs3SkxmQlNOLytjVWtjNG4yTU5vaDlSK1dMMVZWZ1ZvVE02SjBONm9Q?=
 =?utf-8?B?cm1aK2t2SXBxODl1R2NqVk5ZeS9HcWNMNSsxK1ZhT3daMjFWb1NpRlk1Ky9y?=
 =?utf-8?B?SmFuSXZJSGNTMURkWE5XbGwwOER0K1pIV1RyejFhYmZjS0RuWmROcFFhbmRa?=
 =?utf-8?B?VHhZdFBpVTVGTzhrY3NOWENib1ZHckJvOUVVOWZwSGVYWTFUVXdNMUZkR3E3?=
 =?utf-8?B?eUVUVFZVb1BWU2JYUHVGNGovTi9EbFdXcHlsTlRDbXpMRDNPYzJZeThQZ2pp?=
 =?utf-8?Q?yCEYrW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2dJSjNJU1I4NjRIRDg2alNlSDRBN1FRRmJ2UkZCRi9Dc0FucUpNUWVtSVhz?=
 =?utf-8?B?NkFReE1neTZkR1AxWTZ1ZEIyNWpSSTRNWU1razNIVHp1ME15MEg4Q01ySzRG?=
 =?utf-8?B?ZEIxbXo1c0dSQ09WTW93My83ZG5sWU1sR1B3eFhsYUdtZ3kweDdIZnFWTXVt?=
 =?utf-8?B?amIrb1N6Ukw2RUhRVXREcHZXR1hpci9lWjJZUkVDTmh3em95U1MwOUptV3pX?=
 =?utf-8?B?Unk3NWZBQVdoVjNDTm9RUWU4MjZFOTRXSGxRQXV1Mk5aNzZOKy9aOFordUYx?=
 =?utf-8?B?UzdMdWlaMWNJdWJWODREMWtrS0xrQ3psZW9yOTBDOXB0WHkvc1VkRkVyVldF?=
 =?utf-8?B?aGR2ZjE1VkZuKzc2dkxlaitGR1ZFbStIY0Vib20yUlVxK2pRMkNTMjFYZUdh?=
 =?utf-8?B?Q0FOcGQyYUhsZDBST2dhUVVDcW96c3dpNXlKY3M0Um1yZEdYMW4yaGdoMzFV?=
 =?utf-8?B?Y2NVVUZOSDZ2SlBwRUlLRkl4YTk3dUlJb3lSbWE1eHl6dTBqaVdOQy81SGoy?=
 =?utf-8?B?bWdKNWdxT2wvSmhJeHVMWVRIdS9aZ0hRMm1RZ0haWGdGaWxkeVA1MG51WWl0?=
 =?utf-8?B?Ky9sUXBsSi9CVzNpTlB1Z0VWZWg4NGNGS0twMjQwUE1vdEdmQU1heEFEcUd5?=
 =?utf-8?B?MS9vSjF6eGJXZVZKRko0VE1QcEIxdXdaandCN2F4bFpsR3VDaDhQVVVtNWdL?=
 =?utf-8?B?VkY2QnpNWEY2V09ZMkN0K2xUMnJCWGYxVHFEK1BLMmtHa0Fhai9OQ1ZONTNs?=
 =?utf-8?B?dTJpRXVBRHJrRWNRazhvcUlvUnVzZUFaMjZacWR6ZkZUSENUQjNoTGZwdXox?=
 =?utf-8?B?ajNaVXFHdEU3Vkp2djlRZWlvYzdxMFFGb01sR3pwM05WK0pTQVdmWUI3YkE5?=
 =?utf-8?B?bHIrVmhaU1Vja2ZsVVJ5Ym1aanJkR0RDVGtvak1rNnRnV09IM2h5LzJseUdy?=
 =?utf-8?B?bFZ0L3czMzBzSTc0emZSa2dwUWwvTzZQbDdkM2Q2Q25wNXFuVjg1VnVqWDd4?=
 =?utf-8?B?RnpZTlJxRDhaVnlIZ3Y2a1d6L2VRSE9PRlVDZWJQaks3TWlnSEphTUcxQW41?=
 =?utf-8?B?czJiQVhZeW9MRnROeDBHWjU2cFl4Vi9QL2JEelRuSnZHTkNaaHpWTDg2ZkZw?=
 =?utf-8?B?dmZrMFkxTndza3FZR3pVM1JmTnR4blRYYzlSL2FqQVRHYzlKSTc3Q25CWllx?=
 =?utf-8?B?bnMrNDJyNk14eTNsWEZwYUpZa3VFM1JIWnRNVGcvTTlscGdFMkY1WGZnZWJ6?=
 =?utf-8?B?S20zZ3RwRDFueWYySzlzZDBQVm9wcy9jMElHaFZKTTFmZ2VsM0pLVjkwZTdR?=
 =?utf-8?B?RTg1bVA1TWFyYXg2UzVTWVQwYml1ZjlIZlc1NVpjekI2VU5Bb05pMTNYNE81?=
 =?utf-8?B?cUVacUVTZnRpYzRRR3hYM1BPWFpZVm5nUC9vdmRBNVhIeldTS09LVEVMT2ZK?=
 =?utf-8?B?QlUwZ1FUUmZHdWVLbXlHdjgybHM2akRhaHduWkxneEJFVkdvREtiM0txTkE2?=
 =?utf-8?B?RUhjZUlza1VCVXQxYW5kUDNGc01NdzZqSXROZzhseTdqaUlHUzlWOU9ZQTJu?=
 =?utf-8?B?Vm4wSjdYTDZmcWIxUEJLeEpqM1VrQmlzOHZPdXZKYkF6TzV1aklmQzhWaTRs?=
 =?utf-8?B?WXFFMUFTZUtMREFYWGs0VGdWS3NrdHBVL3ZoMGE4a2luTmdTZ1FoUS9JSUIv?=
 =?utf-8?B?K05EeTcxQzlJTGhEYVd2QnZHWHdXM2FNQ1NDWGRnUFlwVEg3bEt6Q0tvQ1pq?=
 =?utf-8?B?VXpsaWl4UzFNNk9QaGExRXBBUHFLYnRJZ0EwSCt4L2k4b3ZEdUZ2MVFTRmFB?=
 =?utf-8?B?MnhPOXBwUUp6TkpCV25aa0dNKzJsbytEVnhiUHVlTVVRYXJwTkRtSGR3VGRz?=
 =?utf-8?B?bk5jbEZVdXRmdm9WN2lMbkUyYlBBY2pQenBLRTQwWitSNlora01FejFqRGh6?=
 =?utf-8?B?QW9vZFp6UkxReFVwREhNNUluR1kzMlUxcEJCQ080QVNLZ3N0NVdyYzhvdTB0?=
 =?utf-8?B?T2JoVk93Z2FDNm0xTzk1SEozRG1RbXZNTE95SzVzdWZsb3ltZlpMRkhTbEFa?=
 =?utf-8?B?ZjhjbFhnQ2tBSUxxOXBjZU04VGZ0eElBSHljS0JHa2FGcU9qNVJlb2pPRU1u?=
 =?utf-8?B?TWdqN3ZPWWR3OG4vQTNPK0lDSXhsQUJIV3Q4Umlxam9ia1BWaWlyaUp6dkVw?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e84ce74-782d-4d80-507f-08de283182ba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 12:37:04.7390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJ+IhdlYvz+eCnZSRt2nn+ujuRS1zafT99fJuo6QwmS/JcqTq2N5fQXcOZk+NXxxxlQkyNo4bC2bzU1SlSmiEooEQ/3DA33ZopFuoCQohNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC3B7BD011
X-OriginatorOrg: intel.com

Hi,

In a recent discussion [1], an unsafe locking pattern was discovered.
Initially, it was believed that the locking issue is related to calling
copy_from_user()/copy_to_user() under state_mutex [2], but it turns out
that it's a generic issue that has impact on all drivers that are not
implementing a "deferred reset".

This is a first attempt to simplify the migration device state locking,
following a suggestion from Jason to try and solve the issue on core
side rather than duplicating deferred reset in all of the drivers.

Introduce a dedicated .migration_reset_state() callback called outside
vdev->memory_lock to break the locking dependency chain and convert all
of the drivers to use it.

[1] https://lore.kernel.org/intel-xe/7dtl5qum4mfgjosj2mkfqu5u5tu7p2roi2et3env4lhrccmiqi@asemffaeeflr/
[2] https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/

Michał Winiarski (6):
  vfio: Introduce .migration_reset_state() callback
  hisi_acc_vfio_pci: Use .migration_reset_state() callback
  vfio/pds: Use .migration_reset_state() callback
  vfio/qat: Use .migration_reset_state() callback
  vfio/mlx5: Use .migration_reset_state() callback
  vfio/virtio: Use .migration_reset_state() callback

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  7 +-
 drivers/vfio/pci/mlx5/cmd.c                   | 15 ++--
 drivers/vfio/pci/mlx5/cmd.h                   |  3 -
 drivers/vfio/pci/mlx5/main.c                  | 59 ++++-----------
 drivers/vfio/pci/pds/pci_drv.c                | 10 ---
 drivers/vfio/pci/pds/vfio_dev.c               | 12 ++++
 drivers/vfio/pci/qat/main.c                   | 36 +++++-----
 drivers/vfio/pci/vfio_pci_core.c              | 25 ++++++-
 drivers/vfio/pci/virtio/common.h              |  3 -
 drivers/vfio/pci/virtio/main.c                |  1 -
 drivers/vfio/pci/virtio/migrate.c             | 71 ++++++-------------
 include/linux/vfio.h                          |  4 ++
 12 files changed, 101 insertions(+), 145 deletions(-)

-- 
2.51.2


