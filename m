Return-Path: <kvm+bounces-71444-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id vf98BXVnmmk+bQMAu9opvQ
	(envelope-from <kvm+bounces-71444-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 22 Feb 2026 03:18:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6007516E692
	for <lists+kvm@lfdr.de>; Sun, 22 Feb 2026 03:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD1033026599
	for <lists+kvm@lfdr.de>; Sun, 22 Feb 2026 02:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E0186341;
	Sun, 22 Feb 2026 02:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jdjPHdcT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C2E182D0;
	Sun, 22 Feb 2026 02:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771726691; cv=fail; b=FrqZBfUJDe/GQ0TsHSAhSeU7jx4BAOJ2uMjijSerEIi38Pl7P7jgMQdXnV84s25bsV2nRcSVlwxurDrHl1wNGKVW1ms8dyKAVnIW//0lEkDcL0afGs2YKbmwRazqaL016BDtYVG1n3BsSv1Ky3G/1Wqd6IzQDzIlT1L0SiICWuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771726691; c=relaxed/simple;
	bh=ANsjr7IcNZRSkB2HnKDJJnIuu86GBOm3wWHBC0vTZFs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F0AYNrFEcbfui72Q8CTRlZS0/smMBj4RBQahyPO3CD3+uwP2hFWFICWc/4FOhgHSTBPTPXT2aln2N3EGkK0Il1+H/hFeum27zBbEPROFV1vNAcD2t5Rkt03jNAgWfkbBwGNer5S7TNNeTzVKGvnqm8vl/pAxTO0dTk/SxXuVJjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jdjPHdcT; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771726688; x=1803262688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ANsjr7IcNZRSkB2HnKDJJnIuu86GBOm3wWHBC0vTZFs=;
  b=jdjPHdcTB7DFQRU+GLCsSCCOVWOYqAoKX3Ey4VfpwVYUe3bPqCopMODy
   zSV0LhIHDdVazSrbjTSdjU/qYPIj+wfDLvJApwRItptDJpyBJUm46zItJ
   UJdMT5+Js0XBmAqyEzDv304GbN6cRimWamkyylecKq5NYabKY+ZmIBo8U
   WP147euhi7FJt9itnTZQpvBVWH8+ARecMq7Cy+W7xvDuFtammVO2WUGaJ
   RkA3q3Z4BWkDkxqTQZVHHn6xSes9xh1tVkR9blZZ3i3CfnMeNNUDxYK6l
   aAOGkHDbzl6rN92xf2MQws9C20OA87qIPGNA92KgrHbm6IhV6N2NmFAIS
   w==;
X-CSE-ConnectionGUID: E1/HjOeUTVOltL3onQ6ceg==
X-CSE-MsgGUID: rd96yVwEQXC6oG9dP8q3aA==
X-IronPort-AV: E=McAfee;i="6800,10657,11708"; a="84127672"
X-IronPort-AV: E=Sophos;i="6.21,304,1763452800"; 
   d="scan'208";a="84127672"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2026 18:18:08 -0800
X-CSE-ConnectionGUID: DeBvb15XQNaExYkAlrZZNA==
X-CSE-MsgGUID: hSLUaV3USn2yddBtHPrtAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,304,1763452800"; 
   d="scan'208";a="214174601"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2026 18:18:07 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 21 Feb 2026 18:18:07 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sat, 21 Feb 2026 18:18:07 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.38) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 21 Feb 2026 18:18:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iB1Yh9wsVEPmmrr/ibXUELXdc2J7Rdjnl2KLomSD6ADHjezXER9ZZ0piol6EZTlg6Mb/xN4SVpKLRVqs5N453NP73COWGPYrKYnT8vSrn1EZHB1rZiIjOye3Sto01vqTLG7gQyH1a6VnYp14uqg/tma3IdLQDBYoQEHoyuSOHtLAGz3kVPjbR6Cf/SWPvSbFPqSdktyamEfJIR5aeZEhhLgLGp1qgN9RK3y8vaDxASB5oDeHFYCZ44g3SlFkV8jOj2B65POfmbqhrfqaEAPj5S89OajX0AgtbRYaeMmc8pPIokbmiyKql8cONQsE1vXCZnzEf/KHxYMiig5HP5rysQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANsjr7IcNZRSkB2HnKDJJnIuu86GBOm3wWHBC0vTZFs=;
 b=s2lW/2Crix08HR9ivmZIIQ9yGlSKHVQaGo5oaUXpTzTTqNSaY9D4BBinegXeGROW+xZ2LuGw73ZbRN+cPcCljfwMqriDBXHA44X0JgVpAqorNhTyDE4Zxh7+kCoN6HxKBULg4XjYeeUsg9+X3OxSbExQ3gHMVe5ZTyb0aj7o3l7e0NqA0KSUJhnVAbLRA+2y7jKeRIP/eskVaj0ZmKD89fAl/8NLC2R2ePxMB0c0Dzb/ydeijroIMaQcvGOOC72d5Hqz4lqXjXNb8XnY1HNp4C6qlJGSrcv4yV200Y6LF3MrRnKjukYBBfT9s4/VDQZF8E4n9oRKCaVmOETabWO1WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8455.namprd11.prod.outlook.com (2603:10b6:510:30d::11)
 by SA1PR11MB8318.namprd11.prod.outlook.com (2603:10b6:806:373::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.19; Sun, 22 Feb
 2026 02:17:58 +0000
Received: from PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf]) by PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf%4]) with mapi id 15.20.9632.019; Sun, 22 Feb 2026
 02:17:58 +0000
From: "Miao, Jun" <jun.miao@intel.com>
To: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Miao, Jun" <jun.miao@intel.com>
Subject: RE: [PATCH 1/1] virt: tdx-guest: Optimize the get-quote polling
 interval time
Thread-Topic: [PATCH 1/1] virt: tdx-guest: Optimize the get-quote polling
 interval time
Thread-Index: AQHcmzSSxX4DDVEvZ06iSQPDmi9uV7WL+7AAgAIJFvA=
Date: Sun, 22 Feb 2026 02:17:58 +0000
Message-ID: <PH7PR11MB8455A677E5BB797F9074E1EC9A76A@PH7PR11MB8455.namprd11.prod.outlook.com>
References: <20260211085801.4036464-1-jun.miao@intel.com>
 <20260211085801.4036464-2-jun.miao@intel.com>
 <1cc137df-0940-4eb4-b7c3-2e5e8948d9f5@linux.intel.com>
In-Reply-To: <1cc137df-0940-4eb4-b7c3-2e5e8948d9f5@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8455:EE_|SA1PR11MB8318:EE_
x-ms-office365-filtering-correlation-id: e760fb91-209b-4b3d-e1cb-08de71b898b7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?V2pqeDBvK0RSQTlCbTZBL20xUlc2RExTSytIaktQWmVXeFNMQ28zQXNnaFFh?=
 =?utf-8?B?NnlGMDdFbDE1NHdKelhXVjQxM2J0dHBwYzBsOUhFYStQa1VnT1FkcUh4bVF4?=
 =?utf-8?B?S2xrNzVjTlZMTkFnTzZkTDIwUFFCZGNDZHhWRWszTVpMdERtVGFxcVlOTUh2?=
 =?utf-8?B?NytPOGI3TmdrNC94ek5aSDh4STJYbUhEUWZqRzdQR2k0VSt0bGJvd2Vtd0xn?=
 =?utf-8?B?TGt5cmNnWjM3MGlGNXhpcEVqOHd6dXlZMS9iVWp5TXk2eWduZjE0ejk1WU5w?=
 =?utf-8?B?aGF5eTJlRHUyYWJDN25uc2lPTG5qN05GTUhNd2J2V1hkaktDWk56NDVydFBL?=
 =?utf-8?B?RmhDSVA0TkxrQXBoeTJaVU93QXBzU3RRQzkvRDFoWVd2WUhpbE9PZ0pWYS81?=
 =?utf-8?B?bjBFRkxoZ2ttL1FVZmFGeGthdXNpcmU2QW52NTJKVkJUSU91bWZIMUE2MkVm?=
 =?utf-8?B?cU5QRUJjRGMvbVExdkdBWXdLRVJqVzRHRTBkMUtXd01GU1F4MmFVVEFlQnlt?=
 =?utf-8?B?SUFRSFZpUGt0engrZFNXQjRjMG5LcmlsWnh4VmhLOXQ4b3pHVnh0Rzg4Y3Ez?=
 =?utf-8?B?QVBvWHBLdS9LNE1OV1FmRFVYd1BxYnRuRzZQaTlHbk1qYWlEMmt1WGtLaUVp?=
 =?utf-8?B?UkZKUml1L24vZHZsWnRSZE5ENkFta0k4Yk5haHZ3NVJGZklNL2lOb1lmdE5i?=
 =?utf-8?B?dnhZMVF0SWhEZ1ZYQ1N2aS9TYXRseVpwbC85S1JjSlF3VG51dGlqbEhXb0Qv?=
 =?utf-8?B?OUdBRlcyWWZDa1JsOFNIL1ZTUVorYXVqQnczdytxWmx2WVhjOTV4azN0THFw?=
 =?utf-8?B?UXI3TVB0RGgzRmJ6bVBSbFNCamRKZTJNUkxPOEV2R3Mra096WWN2Q1NKR3J5?=
 =?utf-8?B?RDBBZG9wUHVnQU5KakN0WlNSRWNCTmp5L3lLaVp4dURwcExRdmNYVjZYWlBY?=
 =?utf-8?B?bzRSRjQrWi9SL1ZyUDlwaytCRGkwNkViRXY5R1B0WEVUTFNLNUhjejlRUFRm?=
 =?utf-8?B?djFKTUpzQUwxQnp2WjUwaSthNmNyNUdSdzNOTG1kWWllNGVrWmJXcWxmb0xm?=
 =?utf-8?B?U2FiWUxYSlhhY0E0SjhZMk9kUVp1YW1yWVpYYUJqSTFQdGFoVVpqMU80RTRV?=
 =?utf-8?B?Q3d2NGVpR2t0TkQ5OHlZMFZ3dnN5QzdGV3VZTWMvbWN6RXBnUGNNMDFnNGJV?=
 =?utf-8?B?KzV5V1JNQ0VETWRLS2o4NVArTm5jNzI1elZFaVBmZnpYMGZCRVFjbUxDclNX?=
 =?utf-8?B?NEpjUmNUSmlnSlJXNGRBb2Y0Rk5SQVU2ZDlaQTZ4Y3Nnc1BJbFlvcFJzQVNE?=
 =?utf-8?B?aGdjVlUwZndCM3FwWmdtVGhFUHIzNnR4eVRaL21hS3d4ZGZoT3ZVY1M4MGVn?=
 =?utf-8?B?dXVjeitiTTRqUHRGVEhTVmJ5ZjVkQzRkTjBYaDZ2cnd2K2NYVE5ZYnUvRWww?=
 =?utf-8?B?a1R2VnRyT0VPTXlUNGh2Y1lRUjlDUTdyTFA4STYvVlVEa05IZkY1Q0k1QU9X?=
 =?utf-8?B?a25PMkl4d09yNkY0QnJndlI3OE51bmUzdXFyQ2JzVnB1akpqbDcrYWlualMz?=
 =?utf-8?B?TXdjNUFuYTBqK05xS1p1aktOUjhaaWFsU2J3bnYza0dXekx1Qk0yVG1wV2E3?=
 =?utf-8?B?NFlZYzc4N21XMkVHckxtUHpxaGVnSWxqZ1BxWE0zNmY5VzlqcVdrb0c3NFF4?=
 =?utf-8?B?azYrUFAyMUsxS2VNbWVTbjQ3WXVLMkZIUFhXMm8zem1JZlpPUFBPZnJ0dXg3?=
 =?utf-8?B?TUJPNlNtb2RQOERJMjRrRzlUVFdIc292TmtHRXdqRWJMZTNUTHB2RDFkUWY5?=
 =?utf-8?B?ZjNOZjFWbXFlTFhiOWlkZGpQWWh6dHFJMzJkeHIvalE2c2ZyVk5nZmJKVWhZ?=
 =?utf-8?B?b3NPLy9qeHBIOSsyeDBibXhIRmppM3FMUlRzYUJvYVBBZUkxUTBuRjFqVnZa?=
 =?utf-8?B?Wm4zZzdNSGI5VnJCbVpMRE44dlpMY2svWFlrM2xwMWFZRGJmNUpsRzRZQ3lL?=
 =?utf-8?B?ZjJaVkgwMkxuZWNFNTY2VklXZEFuZ0ZIVzRWUFcreU1nOWtEY1RON2NGbnln?=
 =?utf-8?B?ZWtOMEZ3MytrNCtaMVByMDBGM2dsSHlGc2NYR2lxNURTYVRVOEp2cmpORUZL?=
 =?utf-8?B?bnNtaFdKYmQ2VEtUZWxNalZPbWE0T1YxeUdGcklIU3JaMVhZNmlFSzRnakdO?=
 =?utf-8?Q?61+XUnCXbtYk19homGmIxWo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8455.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3JGOEtyNXMyMFRZREowRWJ6WThlQklFQTkzQ2ZEWndMdzZhblNGVzNjYWUr?=
 =?utf-8?B?L25Vd1NCdjkrMERoQXJwZDVCQjAzNzhlS0VONmd1U1lJWjQrOUx0TU9yNUMw?=
 =?utf-8?B?VUwwb0NzOElVYmZZL3BnZmxKL2VLZDZ2R3crUTlQQkgrTTdBMXBtL29FaTVN?=
 =?utf-8?B?V0ZDZzJtSVdkcHdtUjYvOHlqVG5DUExrTy9DMWp4MVZQQVJFbllNbUVteDd0?=
 =?utf-8?B?UGhRY3VOa3pyV0Z3MW9LblBKQ2RiZEdsc2hVbjBzVjNBNFNHdVVQem0zaUl6?=
 =?utf-8?B?R3gzRldKZlpWVWhGKzUyWVFNQlhkdmtQanB2K2s4eTZGb0FjMUtaZFZnMDZT?=
 =?utf-8?B?N1RvdUpVMXo2aEkyYkt6TzlGQktwRHpsaUV0bmJGYTJnQkJ2cVFpN2FhUlps?=
 =?utf-8?B?dW1vTFEwUkQ4SlJNamZ1LytIN0M0cVlxU0ZvRGNvRWs0c3VXM1g0RjdkZzFh?=
 =?utf-8?B?WXFxRCtZbCs2SmxlZGQwUlFtTDRhYSs4SU14ZjVNME13WnJCZHhETDZkN1pI?=
 =?utf-8?B?ZWZqczM0RTNUK2twZGRUNmRsdUw2eHlKdTEraWV5ZmIvUnNMdU9QeVZidlpr?=
 =?utf-8?B?TzdSOFVlMnQzcmNkdEdhbGNMamVDNThMQUxQbG80b2RITWhrYVdGTy9NQmp4?=
 =?utf-8?B?ODV2bFZPTEZnUTZHd2RVaVZkbENCRzh3eStwT2N3MTNRdHcxOFdVV0hpaXpM?=
 =?utf-8?B?Q1ZXU0dvWmtRbnFMNFUxMEg2UWRBQ2h3akRBSWQ1N2tDY0s5WmJpaWU5OEJL?=
 =?utf-8?B?ZUJwVzRVRmJpN0hCa1RQR3pxd0xjUkZnRWR4R0RqeU9tQ3diUk9HN0oxN2I5?=
 =?utf-8?B?dDlmZnpuYUlkQ1VMdFh1UURQL0M5WEhlekFRMFpwbkNVQUw1dEhmSHp5cVNX?=
 =?utf-8?B?ZmJUNVBQcnY2c3JFbjZ0Z0JEMXZrd1NXYzNoYnlpUmROdnNsWWFqT053cGJB?=
 =?utf-8?B?clIyQmtuUDlYT1R4YmFUYXJiaThwbEwxcytjdDVINHVmQkQ2R0ZPRmVKeFdz?=
 =?utf-8?B?aXZaSzZIWTJsYUQycUorQklsRmI3Qzd2d1Nhak5jRG0zVXBabDNnK2ZhTHhR?=
 =?utf-8?B?bU8yZW1pNEJsMjM4MGw5NXkrQnZwK0IxWUNZVjJSSklVTElpUDRraDNMMGpO?=
 =?utf-8?B?VDdyblhzUWc4QjdDUmlaTkcveUY5NTRLOVdLL0JSbjd1T0dEWkFVTmFMYUY4?=
 =?utf-8?B?WlZYVVFYR1c5eVRkaTk2K1MyYUk2M3JadHFuV01TRnhqK2Exa1JUQk1yRnlx?=
 =?utf-8?B?U0lac1I2Q05xblpvcDMvVXp1R1pKTzlObnFRWitJK2dKRHRrSlhKa3Q3ejBE?=
 =?utf-8?B?aFI0aHVDV3F3RUZVYXBrOGl5QTc3aWhCTlVvS2k1SDdEdlE0RFAxdUhUU292?=
 =?utf-8?B?bmhKZkhjaWk4VnlOQ3hFZXdDWE1BWlpUWFEra3F5SzFENFkrU0J1NlQyN3Bu?=
 =?utf-8?B?Y1QvZXJUU2dZcFQrM1I4Vjh5bnZLTC9PTktxVDdIN3ZTSVVJS2VlSEVkOVdI?=
 =?utf-8?B?b2hkeDNacFJyeS83TXVnWW9KN25qUFN2cjMwYWR0cVhBdkRjRUNhNWxWakJu?=
 =?utf-8?B?d0FzQlpiUnN2YUNHNmFEbDhmWkhLcllRU0p4cW5oNFJwTitWRW5JZEVDTm5B?=
 =?utf-8?B?NTdBODNaVXR6VUN6S0tJdFlZZytyUTFjaDVGcTJJYzRPd2FxWmpFa2FTK0Y0?=
 =?utf-8?B?RVArRGNCVDFRMDNOMjBYOWxCbEdySmZTYnNSU3lvOTJhLzc5TEJRNngyRmJC?=
 =?utf-8?B?YVBDL25EVU54a0RsZGxNVkZkc0d0RFUzOURBcTkvMENnbE4yKzBZZEsxK2dy?=
 =?utf-8?B?UW5qUHlEQ0NOdGVqMHpKMk55ZzJ4c3hlQ2liSm53bGFlVnk0dTNNQlFVSlZH?=
 =?utf-8?B?YVdDN2J4aENGVmg1Y1M2Q0VxdmU2dW9SaVNFcHdIRUhaM0o0emhKazdKS1FK?=
 =?utf-8?B?dlJIUzRXczAwODFuZ1pXdG1DU2lnZlFoakl1QzFrMXFKbFFSTDRQYmNKbkZj?=
 =?utf-8?B?OWx3bTdZT2hVOEVnKzRWZUpKSGxjekpJZFhZbHFMMmNNZzYrMCs4WDJxZ0dM?=
 =?utf-8?B?SXhtRmN6dG5ueTJjUGlHVW0xVHBESXdZQTFHay81TWhCS3p0NGpGbUd1V1Qv?=
 =?utf-8?B?S0RJSm9zcUFwZ3FVWjBibEFwdVlIK1cwSzBnVWNMb1JMYUx0R3NMQmRyZ2l1?=
 =?utf-8?B?ZlNHZm53U2ZzZW5kK2lxRkcxVUFWeGp4TWNWY0NIbHFNZjdUb2pYdFdHaCtF?=
 =?utf-8?B?ajh1WFVpV2V1eWg3bzI3b0luTmRmSitEVnVnak5KK1l1RGVCK2tydXZHUU9T?=
 =?utf-8?Q?g2YPeTsA5BKZ6q9ogC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8455.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e760fb91-209b-4b3d-e1cb-08de71b898b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2026 02:17:58.3254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iE7b0Wnn04osJ+3u/3392eNVPFFxeBaraTkc+HzoLlRxOoSnWEJnss0+IyMlTpR5qe1z3ZsFubI+02skUkjHmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8318
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71444-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,01.org:url,intel.com:email,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jun.miao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 6007516E692
X-Rspamd-Action: no action

Pk9uIDIvMTEvMjAyNiAxMjo1OCBBTSwgSnVuIE1pYW8gd3JvdGU6DQo+PiBUaGUgVEQgZ3Vlc3Qg
c2VuZHMgVERSRVBPUlQgdG8gdGhlIFREIFF1b3RpbmcgRW5jbGF2ZSB2aWEgYSB2c29jayBvciBh
DQo+PiB0ZHZtY2FsbC4gSW4gZ2VuZXJhbCwgdnNvY2sgaXMgaW5kZWVkIG11Y2ggZmFzdGVyIHRo
YW4gdGR2bWNhbGwsIGFuZA0KPj4gUXVvdGUgcmVxdWVzdHMgdXN1YWxseSB0YWtlIGEgZmV3IG1p
bGxpc2Vjb25kIHRvIGNvbXBsZXRlIHJhdGhlciB0aGFuDQo+PiBzZWNvbmRzIGJhc2VkIG9uIGFj
dHVhbCBtZWFzdXJlbWVudHMuDQo+Pg0KPj4gVGhlIGZvbGxvd2luZyBnZXQgcXVvdGUgdGltZSB2
aWEgdGR2bWNhbGwgd2VyZSBvYnRhaW5lZCBvbiB0aGUgR05SOg0KPj4NCj4+IHwgbXNsZWVwX2lu
dGVycnVwdGlibGUodGltZSkgICAgIHwgMXMgICAgICAgfCA1bXMgICAgICB8IDFtcyAgICAgICAg
fA0KPj4gfCAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gfCAtLS0tLS0tLSB8IC0tLS0t
LS0tIHwgLS0tLS0tLS0tLSB8DQo+PiB8IER1cmF0aW9uICAgICAgICAgICAgICAgICAgICAgICB8
IDEuMDA0IHMgIHwgMS4wMDUgcyAgfCAxLjAzNiBzICAgIHwNCj4+IHwgVG90YWwoR2V0IFF1b3Rl
KSAgICAgICAgICAgICAgIHwgMTY3ICAgICAgfCAxNDIgICAgICB8IDE2NyAgICAgICAgfA0KPj4g
fCBTdWNjZXNzOiAgICAgICAgICAgICAgICAgICAgICAgfCAxNjcgICAgICB8IDE0MiAgICAgIHwg
MTY3ICAgICAgICB8DQo+PiB8IEZhaWx1cmU6ICAgICAgICAgICAgICAgICAgICAgICB8IDAgICAg
ICAgIHwgMCAgICAgICAgfCAwICAgICAgICAgIHwNCj4+IHwgQXZnIHRvdGFsIC8gMXMgICAgICAg
ICAgICAgICAgIHwgMC45NyAgICAgfCAxNDEuMzEgICB8IDE2Ni4zNSAgICAgfA0KPj4gfCBBdmcg
c3VjY2VzcyAvIDFzICAgICAgICAgICAgICAgfCAwLjk3ICAgICB8IDE0MS4zMSAgIHwgMTY2LjM1
ICAgICB8DQo+PiB8IEF2ZyB0b3RhbCAvIDFzIC8gdGhyZWFkICAgICAgICB8IDAuOTcgICAgIHwg
MTQxLjMxICAgfCAxNjYuMzUgICAgIHwNCj4+IHwgQXZnIHN1Y2Nlc3MgLyAxcyAvIHRocmVhZCAg
ICAgIHwgMC45NyAgICAgfCAxNDEuMzEgICB8IDE2Ni4zNSAgICAgfA0KPj4gfCBNaW4gZWxhcHNl
ZF90aW1lICAgICAgICAgICAgICAgfCAxMDI1Ljk1bXN8IDYuODUgbXMgIHwgMi45OSBtcyAgICB8
DQo+PiB8IE1heCBlbGFwc2VkX3RpbWUgICAgICAgICAgICAgICB8IDEwMjUuOTVtc3wgMTAuOTMg
bXMgfCAxMC43NiBtcyAgIHwNCj4+DQo+DQo+VGhhbmtzIGZvciBzaGFyaW5nIHRoZSBkYXRhIQ0K
Pg0KPj4gQWNjb3JkaW5nIHRvIHRyYWNlIGFuYWx5c2lzLCB0aGUgdHlwaWNhbCBleGVjdXRpb24g
dGR2bWNhbGwgZ2V0IHRoZQ0KPj4gcXVvdGUgdGltZSBpcyA0IG1zLiBUaGVyZWZvcmUsIDUgbXMg
aXMgYSByZWFzb25hYmxlIGJhbGFuY2UgYmV0d2Vlbg0KPj4gcGVyZm9ybWFuY2UgZWZmaWNpZW5j
eSBhbmQgQ1BVIG92ZXJoZWFkLg0KPg0KPlNpbmNlIHRoZSBhdmVyYWdlIGlzIDQgbXMsIHdoeSBj
aG9vc2UgNW1zPw0KPg0KPj4NCj4+IEFuZCBjb21wYXJlZCB0byB0aGUgcHJldmlvdXMgdGhyb3Vn
aHB1dCBvZiBvbmUgcmVxdWVzdCBwZXIgc2Vjb25kLCB0aGUNCj4+IGN1cnJlbnQgNW1zIGNhbiBn
ZXQgMTQyIHJlcXVlc3RzIHBlciBzZWNvbmQgZGVsaXZlcnMgYSAxNDLDlw0KPj4gcGVyZm9ybWFu
Y2UgaW1wcm92ZW1lbnQsIHdoaWNoIGlzIGNyaXRpY2FsIGZvciBoaWdoLWZyZXF1ZW5jeSB1c2UN
Cj4+IGNhc2VzIHdpdGhvdXQgdnNvY2suDQo+DQo+SXMgdGhpcyBhZGRyZXNzaW5nIGEgcmVhbCBj
dXN0b21lciBpc3N1ZSBvciBhIHRoZW9yZXRpY2FsIGltcHJvdmVtZW50Pw0KDQpIaSBLdXBwdXN3
YW15LA0KDQpGcm9tIHRoZSBjdXN0b21lciBpc3N1ZSwgdGhlIG1vcmUgZGV0YWlsICJUZXN0IFJl
cG9ydCINCltQQVRDSCAwLzFdIFtUZXN0IFJlcG9ydF0gZ2V0IHF1dG9lIHRpbWUgdmlhIHRkdm1j
YWxsDQpbQmFja2dyb3VuZF0NCkN1cnJlbnRseSwgbWFueSBtb2JpbGUgZGV2aWNlIHZlbmRvcnMg
KHN1Y2ggYXMgT1BQTyBhbmQgWGlhb21pKSB1c2UgVERWTSBmb3Igc2VjdXJpdHkgbWFuYWdlbWVu
dC4NCkVhY2ggbW9iaWxlIHRlcm1pbmFsIG11c3QgcGVyZm9ybSByZW1vdGUgYXR0ZXN0YXRpb24g
YmVmb3JlIGl0IGNhbiBhY2Nlc3MgdGhlIFREVk0gY29uZmlkZW50aWFsIGNvbnRhaW5lci4NCkFz
IGEgcmVzdWx0LCB0aGVyZSBhcmUgYSBsYXJnZSBudW1iZXIgb2YgcmVtb3RlIGF0dGVzdGF0aW9u
IGdldC1xdW90ZSByZXF1ZXN0cywgZXNwZWNpYWxseSBpbiBjYXNlcyB3aGVyZSB2c29jayANCmlz
IG5vdCBjb25maWd1cmVkIG9yIG1pc2NvbmZpZ3VyZWQgYW5kIGNhbm5vdCBiZSB1c2VkLg0KDQo+
SWYgdGhpcyBpcyBzb2x2aW5nIGEgcmVhbCBwcm9ibGVtLCBjb3VsZCB5b3Ugc2hhcmUgbW9yZSBk
ZXRhaWxzIGFib3V0IHRoZSB1c2UgY2FzZQ0KPmFuZCBRdW90aW5nIFNlcnZpY2UgaW1wbGVtZW50
YXRpb24geW91J3JlIHRlc3RpbmcgYWdhaW5zdD8NCj4NClZlcnNpb24gU2VydmljZSBjaG9vc2Vz
IHYxLjIyIERDQVA6DQpodHRwczovL2Rvd25sb2FkLjAxLm9yZy9pbnRlbC1zZ3gvc2d4LWRjYXAv
MS4yMi8NCldoaWNoIGluY2x1ZGVzIHRoZSB0ZXN0IGNhc2UgdGR4LXF1b3RlLWdlbmVyYXRpb24t
c2FtcGxlLg0KQW5kIHRoZSB0ZXN0IGNhc2Ugd2hpY2ggSSBoYXZlIHNoYXJlZCBhbGwgdGhlIHRl
c3QgZXhhbXBsZXMgYW5kIHRoZSBjb21wbGV0ZSB0ZXN0IGVudmlyb25tZW50IHdpdGggeW91IHRo
cm91Z2ggdGhlIHRlYW0uDQoNCknigJltIGN1cmlvdXMgYWJvdXQgaG93IHRoZSAxLXNlY29uZCBm
aWd1cmUgd2FzIG9idGFpbmVkLg0KV2FzIGl0IGJhc2VkIG9uIGFjdHVhbCB0ZXN0IGRhdGEsIG9y
IHdhcyBpdCBqdXN0IGFuIGVzdGltYXRlPw0KDQpXYXJtIHJlZ2FyZHMNCkp1biBNaWFvDQoNCj5J
IGFzayBiZWNhdXNlIHRoZSBRdW90ZSBjb21wbGV0aW9uIHRpbWUgZGVwZW5kcyBoZWF2aWx5IG9u
IHRoZSBRdW90aW5nIFNlcnZpY2UNCj5pbXBsZW1lbnRhdGlvbiwgd2hpY2ggdmFyaWVzIGJ5IGRl
cGxveW1lbnQuIFNpbmNlIHdlJ3JlIG9wdGltaXppbmcgZm9yDQo+cGVyZm9ybWFuY2UsIEknbSB3
b25kZXJpbmcgaWYgd2Ugc2hvdWxkIGNvbnNpZGVyIGFuIGludGVycnVwdC1iYXNlZCBhcHByb2Fj
aA0KPnVzaW5nIHRoZSBTZXR1cEV2ZW50Tm90aWZ5SW50ZXJydXB0IFREVk1DQUxMIGluc3RlYWQg
b2YgcG9sbGluZy4NCj4NCj4+DQo+PiBTbywgY2hhbmdlIHRoZSAxcyAoTVNFQ19QRVJfU0VDKSAt
PiA1bXMgKE1TRUNfUEVSX1NFQyAvIDIwMCkNCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBKdW4gTWlh
byA8anVuLm1pYW9AaW50ZWwuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy92aXJ0L2NvY28vdGR4
LWd1ZXN0L3RkeC1ndWVzdC5jIHwgOCArKysrLS0tLQ0KPj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGlu
c2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dmlydC9jb2NvL3RkeC1ndWVzdC90ZHgtZ3Vlc3QuYw0KPj4gYi9kcml2ZXJzL3ZpcnQvY29jby90
ZHgtZ3Vlc3QvdGR4LWd1ZXN0LmMNCj4+IGluZGV4IDRlMjM5ZWM5NjBjOS4uNzFkMmQ3MzA0YjFh
IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy92aXJ0L2NvY28vdGR4LWd1ZXN0L3RkeC1ndWVzdC5j
DQo+PiArKysgYi9kcml2ZXJzL3ZpcnQvY29jby90ZHgtZ3Vlc3QvdGR4LWd1ZXN0LmMNCj4+IEBA
IC0yNTEsMTEgKzI1MSwxMSBAQCBzdGF0aWMgaW50IHdhaXRfZm9yX3F1b3RlX2NvbXBsZXRpb24o
c3RydWN0DQo+dGR4X3F1b3RlX2J1ZiAqcXVvdGVfYnVmLCB1MzIgdGltZW91DQo+PiAgCWludCBp
ID0gMDsNCj4+DQo+PiAgCS8qDQo+PiAtCSAqIFF1b3RlIHJlcXVlc3RzIHVzdWFsbHkgdGFrZSBh
IGZldyBzZWNvbmRzIHRvIGNvbXBsZXRlLCBzbyB3YWtpbmcgdXANCj4+IC0JICogb25jZSBwZXIg
c2Vjb25kIHRvIHJlY2hlY2sgdGhlIHN0YXR1cyBpcyBmaW5lIGZvciB0aGlzIHVzZSBjYXNlLg0K
Pj4gKwkgKiBRdW90ZSByZXF1ZXN0cyB1c3VhbGx5IHRha2UgYSBmZXcgbWlsbGlzZWNvbmRzIHRv
IGNvbXBsZXRlLCBzbyB3YWtpbmcNCj51cA0KPj4gKwkgKiBvbmNlIHBlciA1IG1pbGxpc2Vjb25k
cyB0byByZWNoZWNrIHRoZSBzdGF0dXMgaXMgZmluZSBmb3IgdGhpcyB1c2UgY2FzZS4NCj4+ICAJ
ICovDQo+PiAtCXdoaWxlIChxdW90ZV9idWYtPnN0YXR1cyA9PSBHRVRfUVVPVEVfSU5fRkxJR0hU
ICYmIGkrKyA8IHRpbWVvdXQpIHsNCj4+IC0JCWlmIChtc2xlZXBfaW50ZXJydXB0aWJsZShNU0VD
X1BFUl9TRUMpKQ0KPj4gKwl3aGlsZSAocXVvdGVfYnVmLT5zdGF0dXMgPT0gR0VUX1FVT1RFX0lO
X0ZMSUdIVCAmJiBpKysgPCAyMDAgKg0KPnRpbWVvdXQpIHsNCj4+ICsJCWlmIChtc2xlZXBfaW50
ZXJydXB0aWJsZShNU0VDX1BFUl9TRUMgLyAyMDApKQ0KPj4gIAkJCXJldHVybiAtRUlOVFI7DQo+
PiAgCX0NCj4+DQo+DQo+LS0NCj5TYXRoeWFuYXJheWFuYW4gS3VwcHVzd2FteQ0KPkxpbnV4IEtl
cm5lbCBEZXZlbG9wZXINCg0K

