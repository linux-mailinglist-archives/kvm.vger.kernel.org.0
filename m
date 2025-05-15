Return-Path: <kvm+bounces-46709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A74BAB8DBA
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 19:29:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B68116C902
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 17:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99B9259CA1;
	Thu, 15 May 2025 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TDC1Bzjr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43C21DF990;
	Thu, 15 May 2025 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747330144; cv=fail; b=pePLvfxV871pk8QW0h6mjprAS3EScf7WjhLRKK6Wv95A/0ShG+2D9J11FeRyRWZ1m1WlVcyYSb7bGvMPl9bxSlGvA0FgjqpvfQTz9hfGTzm+ItPRoetFLZjdZbPah8rhR9JM/afHfIQu9Pd4L1fDXu8/aAmQhVx/nILWllt1cRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747330144; c=relaxed/simple;
	bh=aD2lnrbv68NCSx4Mr0uceRq1QzdXNEaMbh53tpix9EA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=el+2vT3cPRB0RbN11+2LxDU73p+DTo7/bX5KiwtTGshMUrCWpcmAFsrBj22J17xOny9zA6r0KWZdjRdl4M3Lfy8jRVQZxs7SGwYldGi6Vp/q1BhlesjvsMkGeb6/+oVEh+VGZ2TukT075c3dQMj9LxxrLCf4qtqY4i4UN/u2tKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TDC1Bzjr; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747330142; x=1778866142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aD2lnrbv68NCSx4Mr0uceRq1QzdXNEaMbh53tpix9EA=;
  b=TDC1BzjrzjAwLVb1OH9uk+CGnQFKPvytR0Vm9jnat5ByQi4NR/4jYygx
   2XNtSnz3dGY0BCa+fOWnIo/mrkARMyAgMzkZ8Zeqnvw8AyhnkYUJqfPJg
   2VX6zyMjtHLq6/vuGp5jTGuXE8lAknVvmKMiaTPQUBGuZLgQXyKo7rymd
   ByU9YwkXbB2rQ7Eu+TdSI4/hieAFbTmapupSoQwAlz5IATsbqQiit0WgA
   2O3PfMhBgkSGqPGe76U/0RM1Y1r+wczZidZ8q2/koBRYqjmxH6fSFavxU
   gLq+zQhKEYXSPIF3gT7c+xC+uEyNeWN66nnggAqRHxZv7fb5KBkW2kLPw
   Q==;
X-CSE-ConnectionGUID: nGNPZ2gBTq2yU5bZsEwvzQ==
X-CSE-MsgGUID: vK4LyJ2tS/uantjai/lC3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="60298868"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="60298868"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 10:28:57 -0700
X-CSE-ConnectionGUID: MN4qFDswRSqo0H2QbmkWQQ==
X-CSE-MsgGUID: GPA+gApySz69GXbRj253Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="143201959"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 10:28:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 10:28:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 10:28:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 10:28:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mDwfw5awot68vWIqLKA9a32HdMUiNJ5OFaMxBTDSmaUxlAyylD8jaHMNcIqVX4nB2v5y5SEb+E+8Bri38jNJ9ckUTmc1o58Q1XNa3WRb1B/64Qe0WLdJsbgRIlrJtcfttIj29iNSxCpCVjcdQAuTYTj45P7O0h49I4KaHNui9D9VF6nSlM+ZycAe5DnDq+G7qnV34YLuxSoeeWiN1HDu/ftj21iAjQ7rqdv+H76ADr+zMxBiWjgdlpV32swPCD8z95m3HEXAUzB4bJJp6FRaK2Jclu7h3sUSYYNxxmsUh9HQtDQdu06kcuwiyhCZ8JgyP4dE/GyYd2PRhnOKBuxB0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aD2lnrbv68NCSx4Mr0uceRq1QzdXNEaMbh53tpix9EA=;
 b=fmKKv6spLujrKdgzRxzPG60pPPjqfv6vNz9HU7HmT0pUsgPRS+mnIK+RvoQnPoimBp/sJpwr7W1TJSHZf0YccHBfjAjjmiMIL4FLhJYsuBRWaDKLm/DHGy9z5k9Kcb3gHjnmfrYutvzwEVfMbhvQbgxDmygAaURrAWi46dDylrqyAvyodDb8IJ9YqSGHqiDQSCeivtFIv3DPJUghh85XSmtbAZf2D2g0+xbTfLVJu07HJcmfEFT6kHKnvhQ0DjgvTdg0afEINPBnvQ8NXG0WTGXsGZzxHYObm9QZpxA6AZtglqPtTAPhq/+GxRrH51DXRie9xPrNEGmy3sKNeS3frg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6525.namprd11.prod.outlook.com (2603:10b6:8:8c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Thu, 15 May
 2025 17:28:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Thu, 15 May 2025
 17:28:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHbtMXplPLpm4nddEmAiCVIEk5qsrPQ/bSAgAJ+u4CAAJeqgA==
Date: Thu, 15 May 2025 17:28:52 +0000
Message-ID: <81413f081fde380b07533a7839346334bb79d3cf.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030445.32704-1-yan.y.zhao@intel.com>
	 <fd626425a201655589b33dd8998bb3191a8f0e2f.camel@intel.com>
	 <aCWlGSZyjP5s0kA8@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCWlGSZyjP5s0kA8@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6525:EE_
x-ms-office365-filtering-correlation-id: 5982b265-7152-4602-cebe-08dd93d5f63a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aFJBUjdRU1BBSHVqSkFQQ0NJblovQXdjOHN4NnRQR3ZnUlFiR1NaQ2owempM?=
 =?utf-8?B?dUVoeUZ0UDM4T2MwV295QjZWZG4vMVg5cnhKTURHcGtqRUpVY0swZDZnaXVG?=
 =?utf-8?B?RG16S1Q2c1VjMU93U0pWNUpuK2l2NGtnVlAvQUFYOHZHNUtiL1p3NTFPS0to?=
 =?utf-8?B?dG1lRlNRdzA2ZDdLQlpobDZuZ2Z1YUxFa2ZyVXBsdi8wL3BFUTZ3NUJTOWNS?=
 =?utf-8?B?Y2lJOGNuMGxsNnMzZ1dsazFLSkdVZWpBSDI5a0E1QjlJamd4bVRrUUk2SG5j?=
 =?utf-8?B?Qk9oL3NUcWxrN2NhUzVxRGV6QllnZHhMYmgraFl0N3BDdXREVW5aNkpvdG5l?=
 =?utf-8?B?c2ROR1JIOEdIcGw1Tmxja3g1VkpPb2Iwd0tzODhpdTJ0S0dEVFpoOWMyL2p2?=
 =?utf-8?B?UDJQMGpTV1IvVmdzT01Bc2oxd1Q1VDJIaDZLaWEzZE9JQjVKcUFtWWd0VjZW?=
 =?utf-8?B?dnlFbVZKODJJRWJCVHNYdFNmTS9ldVd0YXRaYWZVaHZyeFFUZXdoeHpMQWJD?=
 =?utf-8?B?bUN6VFdvVEFGblFmVzlaUWJlV0k1a1BlWnY2eWRSUEdrb242ekp5YjVBRTBW?=
 =?utf-8?B?a2VKV3EzdUVPSTUrem9TOENjakI1MjhqS2NYYXZweXpXMklDekFoTVRSaDF5?=
 =?utf-8?B?RFh5RkpFS25sS1ZWWTZzU0swQ25vUEJ2MXR2YldyWXcyYk5oL0Nvb211bUNv?=
 =?utf-8?B?Nlg5QjdEbzFmNVRwd1lYNkJwTExxYk84L2VoZlBKWmk4K0pXK2JGNkFETHJR?=
 =?utf-8?B?cC9RWUNGMEhCd1JnZklIVnllMFBlSnJOSXp2aWFUbmxHQ3pVdEtvWEV5bUJV?=
 =?utf-8?B?dVZ0RVRwKzJraS85ZGw3OG1PTXlRWFQ1a2FCaFhBZTFQaGNRbXhldTFyaDh3?=
 =?utf-8?B?cy9qZm9WVDdldVc4dnRjdytXZTREUkNVWnFxQ0drQ1I1OFhJU2ozMjhneEI2?=
 =?utf-8?B?S1YzTEZKN0xiRi9ZRUx6UnM2U1NxeHhLN1lTSTlpWUxZK0RxWE9PK3R0L1J6?=
 =?utf-8?B?dmJJOVVibGxyeCtiSGJVSFR5UHFMRDVGNVFQYWV0YkhsLzV5cVVTSVJDOWZh?=
 =?utf-8?B?blZvRXdsSHlxbHROMDhHMlZKM1hXcjRMMjMwOFF1aEI1OVc3d01USUFCdE5P?=
 =?utf-8?B?SSsvNEZOTGg2c2RYNWlSR3hFV3RiL3lGMFZVTjhRbWw3V3RBSkVHZ1ppNG50?=
 =?utf-8?B?MXVhdGkwNEIvMEZHOTB3VVJvdjNoYTNGS1JCWXl5Z1VwSUVmQ2I2VExVSk91?=
 =?utf-8?B?QnVPcnMyY3BzeTNtYVZNOWczQjYzekdHVk1rNllGbFRtQ2RRTWFLcTNrOTh2?=
 =?utf-8?B?Y2V0ZCtqbXJKUGxFMEp4Z1VwMjk5eGV2RnB3MnMzM3Nyb01Tc2V4MjB0dCtE?=
 =?utf-8?B?UlR0M0N2aVhZdWVBTE5ydElkT1ZqUXp2enBadUE2OUJMUU9oSnBPelRIUk5Q?=
 =?utf-8?B?aC9zOHk4SEsvcEhJQ1NvQU90U242d2g4QmdSWXpTOTREL0pmczdZL25YalNv?=
 =?utf-8?B?NXdqOVNrTXE3bFJSY0FhUUs0LzZvM2gwUVV6UVJHZFJ6QnBqdC8rbVpRdjRO?=
 =?utf-8?B?SW1ERlIxTGY4a292WjZndXVtWHhtT3hFeDFuNTNheEJiOGFTYmI1bG1yLzdG?=
 =?utf-8?B?WldQa081ZWJPZ25tWktXVkJxTHZ4ckZ2bGd1MzV1alV4T3g0a24zNXM3V29O?=
 =?utf-8?B?ckJXUTZ1OXdMQXNNclBqTmdPY3NiSnpoVlBNenk3cjY1Nnp2czF0UXdQTVJy?=
 =?utf-8?B?bWplNXBUMmdraG5ocmdKSmZmUmRKcW96cnhXakhua2ZkNjNzMmNLMGRtY2di?=
 =?utf-8?B?OWN5NTJnNm1UbXU1VGR2dENTWVRWQmw1SEJDUkF4MGlwRjZnTm8yUDFRNE9V?=
 =?utf-8?B?WFRKWnVmUTcyY1RvbXpZNHdudU1YNDNacVRhbXE5OWtodGtGek9RNENJU25m?=
 =?utf-8?B?cEFTTzlvV2pJUm43eUdRRlJha0YxeWJvUVRKN1pkOUlneEJ5Zm0xeER4K3dU?=
 =?utf-8?Q?ylf5GVrN6bStOs9odHCZnvqYGOPFsk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djM2QnoyaGI4MkdQNnQ2TTlmTDBJbXRhWnhmb1M5bE1kTTJ0bjVVYXRhb0RW?=
 =?utf-8?B?dCtaMTJtTWx4WUFtWW1OVlM1ZEFxa2w0bTFCZkRDL2t4NjZ0TW9CTDVrbHZh?=
 =?utf-8?B?Rk5jdTFkRUxHdThyMS9qZGtrM1U5VlU3WEpFSUNFM3NKYzZyRVEvT1pKVy9x?=
 =?utf-8?B?cGV4a2lTT0NtV2NWZUJFanJib2tybGUvckw5WHlBaHI1UERLVW5LUWtDREdl?=
 =?utf-8?B?eVBFMVlZRDBvTnZjQ1lsSnNsWEpUZkJHTXN0VjRqODFVTmFkSC9mRUxublpC?=
 =?utf-8?B?a2RpZEpSSnhuRXNaV2VmdEdmR0pNRUpvZGR3MzdCVnVFYWc0YkhnVkpGRnRZ?=
 =?utf-8?B?ckJieEUyaWh6dHA1TjIvWFp5TFJIRVBIL2Vma2VJSGh5cHpZMTN0cGk4dG15?=
 =?utf-8?B?dzAzN1ZoSGNCVmNCY2Mzcy8vekVQcUd0TTJYMVkyZlREWk8wRmtaeW9zWVNw?=
 =?utf-8?B?Mi9XMWI0dC9pbWxvenJhL3FYUW1PMGtJSHdJNmpHUzl0blA5VGlYS2RhU2lq?=
 =?utf-8?B?UVBpNlI1WW9BYkIvYVp3ZVBMTWxXNmdhSEFYTVlkNDRyMDhCUSswb1dMaHVp?=
 =?utf-8?B?blBvTGJXRUJUVDg1eWZROW0vWnJyRXEyT0JFMUFRM0ZicHZzeTI2WlpBRm01?=
 =?utf-8?B?OUdzck8ySUtUUXJlUmU2RUJJWkF4QThEejl5QzJLWC9qQ2M0RGxpM2FVNzNw?=
 =?utf-8?B?U0hvTlNreHJvTTIvYzNyc0ZoTDdsVGt6a1NxVXc5cmdObmRnb0VvQnZGa2Fy?=
 =?utf-8?B?SmZmSUxCRDJDSlZNVTRKL20xSmFUVGxWOUFMVExNMHZnWGxYRWFhUnQxYURQ?=
 =?utf-8?B?S1VUc1Z0Y3ZzMEZSN2FYU1drVXFsQ0MrWXIzaGhHL3VybHlwaUo5V1JOdHgv?=
 =?utf-8?B?dml4dDlmY1hsRWk0R0FtMXZQMlg5SGVYU1BJalpTekwzQ1RRT2RkNDQzZnNs?=
 =?utf-8?B?ckpNWllXRk53VHo3dDl3QVJvd1NGQzNYOXI1dHQxelM0NE5iOE45ZmhPL0M2?=
 =?utf-8?B?c3RPQU5ETkY4c3JwMURrZFNqQ3E5Q2szeUtPakZNaWlvRWk5bHhtWFQvWG5n?=
 =?utf-8?B?V0Q2aDMvbTFxQVk0c3VBRnJYb1R1UkIxeWlGQ1FmYlNTMHppN1pzdzlXQllK?=
 =?utf-8?B?MFpxQ1lCTzg3a1pBZkljSWQ2ZzBLaUNRSGwrL284bzJJQ1dBRzRYRmtCK2k3?=
 =?utf-8?B?aWs5dk9GSHR2SHpuajI5OWc2OTh3c0VTS3gzMkhCMmdzRlU1NXpOOXY1SDUz?=
 =?utf-8?B?S1ZCWVh4WXNud1hHZ2EzWmUzbWQvVTBMUGdkMjNIRFRwaWM0aHZrb0haNTE2?=
 =?utf-8?B?UG1mUjdQOEZRRkJ2MmhYdmtrellaZzIzUXRJaWFFNFNaZjhuYSsvby95UW41?=
 =?utf-8?B?c3dIeFVnVUI2NjlRNUIrNSt5ZzQyM3pDMG1aRlYxWVFVbkVmMjFicDlYTVlo?=
 =?utf-8?B?OXo0K3J4Um1WVWhQVjJjTHk3NlVFMVdmM0RldDN4UHBiK3hwZnNiRVhFeVJh?=
 =?utf-8?B?Q3IycG1QMytrd2JEc1Y0Wm42ZFNrcU9YZytBQURKcFFBbURtUHdIVmpicm9p?=
 =?utf-8?B?dVZjVlFUMnVIVGFIM2Q1Vm8rY2l4bEdwTkg2b0RQZW1CaERPeGhmd2Q1b0tn?=
 =?utf-8?B?RzZ5aFRUTlRwMUpoeVg3RmlQVTZCSTBad24rSklEM1lKZGdEbDAxUSt6U01x?=
 =?utf-8?B?d3g4NEYzMmdiOVNxQ1Bzdm1sSi91SGVGNWN4bXdoWk4rQm1TZ3VwWTNTNmc4?=
 =?utf-8?B?dTRLYmJDYjRmQWNyVTZ3UHo0YWswOVZLRkdEbXdwTmt6NjRwa0NYd0QvSlI4?=
 =?utf-8?B?b0l5am9sbGFvbTFLNEJ6ZytPUDdta2pFalU1TlFWSlBzWkFqNlZFQVdNdzNG?=
 =?utf-8?B?QWt5UEQ3SzNaQWxpZG4xb2d4aTFXaUs1TmV1QnVXMm5aend3QkRKMHlLU09V?=
 =?utf-8?B?bEtXTG9oSXFEajViMlFPaytkYlRpaWp3anFHcEJDYkpPRTZqSmpobFJWOFNM?=
 =?utf-8?B?TmJmWVhyYitHN0VjdXk0R2ZoL3pvcVJHdkd5NHpOaWgxVXJQUmR3TFNXQmlu?=
 =?utf-8?B?T282YnNpaDc3Tm1pSXlrNFdvVHlQTE9hK2xxZlFEbXNvbis1NjRjdWVsdC9O?=
 =?utf-8?B?VldjYm40cHB3MStFL0Y1cnVMbExsTTVnc3VsWWVrWWdqSlB5dTQrNitNZGZE?=
 =?utf-8?B?dkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5940961C2BE5B04DAF91BA63761539F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5982b265-7152-4602-cebe-08dd93d5f63a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2025 17:28:52.4649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZvjsaEY9i6lHHbQTFvF2LbbCg/AbNiOTCG1qazlZ7g2HZ6BTvC5XEk9DqmxkLaa8/prXXveNRrOntwh44YmfBZEnCnRPTC7/CZXvQi/jUOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6525
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTE1IGF0IDE2OjI2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
V2VkLCBNYXkgMTQsIDIwMjUgYXQgMDI6MTk6NTZBTSArMDgwMCwgRWRnZWNvbWJlLCBSaWNrIFAg
d3JvdGU6DQo+ID4gT24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA0ICswODAwLCBZYW4gWmhhbyB3
cm90ZToNCj4gPiA+IEZyb206IFhpYW95YW8gTGkgPHhpYW95YW8ubGlAaW50ZWwuY29tPg0KPiA+
ID4gDQo+ID4gPiBBZGQgYSB3cmFwcGVyIHRkaF9tZW1fcGFnZV9kZW1vdGUoKSB0byBpbnZva2Ug
U0VBTUNBTEwgVERIX01FTV9QQUdFX0RFTU9URQ0KPiA+ID4gdG8gZGVtb3RlIGEgaHVnZSBsZWFm
IGVudHJ5IHRvIGEgbm9uLWxlYWYgZW50cnkgaW4gUy1FUFQuIEN1cnJlbnRseSwgdGhlDQo+ID4g
PiBURFggbW9kdWxlIG9ubHkgc3VwcG9ydHMgZGVtb3Rpb24gb2YgYSAyTSBodWdlIGxlYWYgZW50
cnkuIEFmdGVyIGENCj4gPiA+IHN1Y2Nlc3NmdWwgZGVtb3Rpb24sIHRoZSBvbGQgMk0gaHVnZSBs
ZWFmIGVudHJ5IGluIFMtRVBUIGlzIHJlcGxhY2VkIHdpdGggYQ0KPiA+ID4gbm9uLWxlYWYgZW50
cnksIGxpbmtpbmcgdG8gdGhlIG5ld2x5LWFkZGVkIHBhZ2UgdGFibGUgcGFnZS4gVGhlIG5ld2x5
DQo+ID4gPiBsaW5rZWQgcGFnZSB0YWJsZSBwYWdlIHRoZW4gY29udGFpbnMgNTEyIGxlYWYgZW50
cmllcywgcG9pbnRpbmcgdG8gdGhlIDJNDQo+ID4gPiBndWVzdCBwcml2YXRlIHBhZ2VzLg0KPiA+
ID4gDQo+ID4gPiBUaGUgImdwYSIgYW5kICJsZXZlbCIgZGlyZWN0IHRoZSBURFggbW9kdWxlIHRv
IHNlYXJjaCBhbmQgZmluZCB0aGUgb2xkDQo+ID4gPiBodWdlIGxlYWYgZW50cnkuDQo+ID4gPiAN
Cj4gPiA+IEFzIHRoZSBuZXcgbm9uLWxlYWYgZW50cnkgcG9pbnRzIHRvIGEgcGFnZSB0YWJsZSBw
YWdlLCBjYWxsZXJzIG5lZWQgdG8NCj4gPiA+IHBhc3MgaW4gdGhlIHBhZ2UgdGFibGUgcGFnZSBp
biBwYXJhbWV0ZXIgInBhZ2UiLg0KPiA+ID4gDQo+ID4gPiBJbiBjYXNlIG9mIFMtRVBUIHdhbGsg
ZmFpbHVyZSwgdGhlIGVudHJ5LCBsZXZlbCBhbmQgc3RhdGUgd2hlcmUgdGhlIGVycm9yDQo+ID4g
PiB3YXMgZGV0ZWN0ZWQgYXJlIHJldHVybmVkIGluIGV4dF9lcnIxIGFuZCBleHRfZXJyMi4NCj4g
PiA+IA0KPiA+ID4gT24gaW50ZXJydXB0IHBlbmRpbmcsIFNFQU1DQUxMIFRESF9NRU1fUEFHRV9E
RU1PVEUgcmV0dXJucyBlcnJvcg0KPiA+ID4gVERYX0lOVEVSUlVQVEVEX1JFU1RBUlRBQkxFLg0K
PiA+ID4gDQo+ID4gPiBbWWFuOiBSZWJhc2VkIGFuZCBzcGxpdCBwYXRjaCwgd3JvdGUgY2hhbmdl
bG9nXQ0KPiA+IA0KPiA+IFdlIHNob3VsZCBhZGQgdGhlIGxldmVsIG9mIGRldGFpbCBoZXJlIGxp
a2Ugd2UgZGlkIGZvciB0aGUgYmFzZSBzZXJpZXMgb25lcy4NCj4gSSdsbCBwcm92aWRlIGNoYW5n
ZWxvZyBkZXRhaWxzIHVuZGVyICItLS0iIG9mIGVhY2ggcGF0Y2ggaW4gdGhlIG5leHQgdmVyc2lv
bi4NCg0KSSBtZWFuIHRoZSBjb21taXQgbG9nIChhYm92ZSB0aGUgIi0tLSIpIG5lZWRzIHRoZSBz
YW1lIHRpcCBzdHlsZSB0cmVhdG1lbnQgYXMNCnRoZSBvdGhlciBTRUFNQ0FMTCB3cmFwcGVyIHBh
dGNoZXMuDQoNCj4gIA0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBYaWFveWFvIExpIDx4
aWFveWFvLmxpQGludGVsLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRh
IDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBZYW4gWmhh
byA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBhcmNoL3g4Ni9pbmNs
dWRlL2FzbS90ZHguaCAgfCAgMiArKw0KPiA+ID4gIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
YyB8IDIwICsrKysrKysrKysrKysrKysrKysrDQo+ID4gPiAgYXJjaC94ODYvdmlydC92bXgvdGR4
L3RkeC5oIHwgIDEgKw0KPiA+ID4gIDMgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKQ0K
PiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggYi9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiA+ID4gaW5kZXggMjZmZmM3OTJlNjczLi4wOGVm
ZjRiMmY1ZTcgMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0K
PiA+ID4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gPiA+IEBAIC0xNzcsNiAr
MTc3LDggQEAgdTY0IHRkaF9tbmdfa2V5X2NvbmZpZyhzdHJ1Y3QgdGR4X3RkICp0ZCk7DQo+ID4g
PiAgdTY0IHRkaF9tbmdfY3JlYXRlKHN0cnVjdCB0ZHhfdGQgKnRkLCB1MTYgaGtpZCk7DQo+ID4g
PiAgdTY0IHRkaF92cF9jcmVhdGUoc3RydWN0IHRkeF90ZCAqdGQsIHN0cnVjdCB0ZHhfdnAgKnZw
KTsNCj4gPiA+ICB1NjQgdGRoX21uZ19yZChzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0IGZpZWxkLCB1
NjQgKmRhdGEpOw0KPiA+ID4gK3U2NCB0ZGhfbWVtX3BhZ2VfZGVtb3RlKHN0cnVjdCB0ZHhfdGQg
KnRkLCB1NjQgZ3BhLCBpbnQgbGV2ZWwsIHN0cnVjdCBwYWdlICpwYWdlLA0KPiA+ID4gKwkJCXU2
NCAqZXh0X2VycjEsIHU2NCAqZXh0X2VycjIpOw0KPiA+ID4gIHU2NCB0ZGhfbXJfZXh0ZW5kKHN0
cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1NjQgKmV4dF9lcnIxLCB1NjQgKmV4dF9lcnIyKTsN
Cj4gPiA+ICB1NjQgdGRoX21yX2ZpbmFsaXplKHN0cnVjdCB0ZHhfdGQgKnRkKTsNCj4gPiA+ICB1
NjQgdGRoX3ZwX2ZsdXNoKHN0cnVjdCB0ZHhfdnAgKnZwKTsNCj4gPiA+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMN
Cj4gPiA+IGluZGV4IGE2NmQ1MDFiNTY3Ny4uNTY5OWRmZTUwMGQ5IDEwMDY0NA0KPiA+ID4gLS0t
IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni92aXJ0
L3ZteC90ZHgvdGR4LmMNCj4gPiA+IEBAIC0xNjg0LDYgKzE2ODQsMjYgQEAgdTY0IHRkaF9tbmdf
cmQoc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBmaWVsZCwgdTY0ICpkYXRhKQ0KPiA+ID4gIH0NCj4g
PiA+ICBFWFBPUlRfU1lNQk9MX0dQTCh0ZGhfbW5nX3JkKTsNCj4gPiA+ICANCj4gPiA+ICt1NjQg
dGRoX21lbV9wYWdlX2RlbW90ZShzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0IGdwYSwgaW50IGxldmVs
LCBzdHJ1Y3QgcGFnZSAqcGFnZSwNCj4gPiA+ICsJCQl1NjQgKmV4dF9lcnIxLCB1NjQgKmV4dF9l
cnIyKQ0KPiA+ID4gK3sNCj4gPiA+ICsJc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0gew0K
PiA+ID4gKwkJLnJjeCA9IGdwYSB8IGxldmVsLA0KPiA+IA0KPiA+IFRoaXMgd2lsbCBvbmx5IGV2
ZXIgYmUgbGV2ZWwgMk1CLCBob3cgYWJvdXQgZHJvcHBpbmcgdGhlIGFyZz8NCj4gRG8geW91IG1l
YW4gaGFyZGNvZGluZyBsZXZlbCB0byBiZSAyTUIgaW4gdGRoX21lbV9wYWdlX2RlbW90ZSgpPw0K
DQpZZWEsIHdlIGRvbid0IHN1cHBvcnQgMUdCLCBzbyB0aGUgbGV2ZWwgYXJnIG9uIHRoZSB3cmFw
cGVyIGlzIHN1cGVyZmx1b3VzLg0KDQo+IA0KPiBUaGUgU0VBTUNBTEwgVERIX01FTV9QQUdFX0RF
TU9URSBzdXBwb3J0cyBsZXZlbCBvZiAxR0IgaW4gY3VycmVudCBURFggbW9kdWxlLg0KPiANCj4g
PiA+ICsJCS5yZHggPSB0ZHhfdGRyX3BhKHRkKSwNCj4gPiA+ICsJCS5yOCA9IHBhZ2VfdG9fcGh5
cyhwYWdlKSwNCj4gPiA+ICsJfTsNCj4gPiA+ICsJdTY0IHJldDsNCj4gPiA+ICsNCj4gPiA+ICsJ
dGR4X2NsZmx1c2hfcGFnZShwYWdlKTsNCj4gPiA+ICsJcmV0ID0gc2VhbWNhbGxfcmV0KFRESF9N
RU1fUEFHRV9ERU1PVEUsICZhcmdzKTsNCj4gPiA+ICsNCj4gPiA+ICsJKmV4dF9lcnIxID0gYXJn
cy5yY3g7DQo+ID4gPiArCSpleHRfZXJyMiA9IGFyZ3MucmR4Ow0KPiA+IA0KPiA+IEhvdyBhYm91
dCB3ZSBqdXN0IGNhbGwgdGhlc2UgZW50cnkgYW5kIGxldmVsX3N0YXRlLCBsaWtlIHRoZSBjYWxs
ZXIuDQo+IE5vdCBzdXJlLCBidXQgSSBmZWVsIHRoYXQgZXh0X2VyciogbWlnaHQgYmUgYmV0dGVy
LCBiZWNhdXNlDQo+IC0gYWNjb3JkaW5nIHRvIHRoZSBzcGVjLA0KPiAgIGEpIHRoZSBhcmdzLnJj
eCwgYXJncy5yZHggaXMgdW5tb2RpZmllZCAoaS5lLiBzdGlsbCBob2xkIHRoZSBwYXNzZWQtaW4g
dmFsdWUpDQo+ICAgICAgaW4gY2FzZSBvZiBlcnJvciBURFhfSU5URVJSVVBURURfUkVTVEFSVEFC
TEUuDQo+ICAgYikgYXJncy5yY3gsIGFyZ3MucmR4IGNhbiBvbmx5IGJlIGludGVycHJldGVkIGFz
IGVudHJ5IGFuZCBsZXZlbF9zdGF0ZSBpbiBjYXNlDQo+ICAgICAgb2YgRVBUIHdhbGsgZXJyb3Iu
DQo+ICAgYykgaW4gb3RoZXIgY2FzZXMsIHRoZXkgYXJlIDAuDQo+IC0gY29uc2lzdGVudCB3aXRo
IHRkaF9tZW1fcGFnZV9hdWcoKSwgdGRoX21lbV9yYW5nZV9ibG9jaygpLi4uDQoNClllYSwgaXQn
cyBjb25zaXN0ZW50LiBJJ20gb2sgbGVhdmluZyBpdCBhcyBpcy4NCg0KPiANCj4gDQo+ID4gPiAr
DQo+ID4gPiArCXJldHVybiByZXQ7DQo+ID4gPiArfQ0KPiA+ID4gK0VYUE9SVF9TWU1CT0xfR1BM
KHRkaF9tZW1fcGFnZV9kZW1vdGUpOw0KPiA+IA0KPiA+IExvb2tpbmcgaW4gdGhlIGRvY3MsIFRE
WCBtb2R1bGUgZ2l2ZXMgc29tZSBzb21ld2hhdCBjb25zdHJhaW5lZCBndWlkYW5jZToNCj4gPiAx
LiBUREguTUVNLlBBR0UuREVNT1RFIHNob3VsZCBiZSBpbnZva2VkIGluIGEgbG9vcCB1bnRpbCBp
dCB0ZXJtaW5hdGVzDQo+ID4gc3VjY2Vzc2Z1bGx5Lg0KPiA+IDIuIFRoZSBob3N0IFZNTSBzaG91
bGQgYmUgZGVzaWduZWQgdG8gYXZvaWQgY2FzZXMgd2hlcmUgaW50ZXJydXB0IHN0b3JtcyBwcmV2
ZW50DQo+ID4gc3VjY2Vzc2Z1bCBjb21wbGV0aW9uIG9mIFRESC5NRU0uUEFHRS5ERU1PVEUuDQo+
ID4gDQo+ID4gVGhlIGNhbGxlciBsb29rcyBsaWtlOg0KPiA+IAlkbyB7DQo+ID4gCQllcnIgPSB0
ZGhfbWVtX3BhZ2VfZGVtb3RlKCZrdm1fdGR4LT50ZCwgZ3BhLCB0ZHhfbGV2ZWwsIHBhZ2UsDQo+
ID4gCQkJCQkgICZlbnRyeSwgJmxldmVsX3N0YXRlKTsNCj4gPiAJfSB3aGlsZSAoZXJyID09IFRE
WF9JTlRFUlJVUFRFRF9SRVNUQVJUQUJMRSk7DQo+ID4gDQo+ID4gCWlmICh1bmxpa2VseSh0ZHhf
b3BlcmFuZF9idXN5KGVycikpKSB7DQo+ID4gCQl0ZHhfbm9fdmNwdXNfZW50ZXJfc3RhcnQoa3Zt
KTsNCj4gPiAJCWVyciA9IHRkaF9tZW1fcGFnZV9kZW1vdGUoJmt2bV90ZHgtPnRkLCBncGEsIHRk
eF9sZXZlbCwgcGFnZSwNCj4gPiAJCQkJCSAgJmVudHJ5LCAmbGV2ZWxfc3RhdGUpOw0KPiA+IAkJ
dGR4X25vX3ZjcHVzX2VudGVyX3N0b3Aoa3ZtKTsNCj4gPiAJfQ0KPiA+IA0KPiA+IFRoZSBicnV0
ZSBmb3JjZSBzZWNvbmQgY2FzZSBjb3VsZCBhbHNvIGJlIHN1YmplY3RlZCB0byBhDQo+ID4gVERY
X0lOVEVSUlVQVEVEX1JFU1RBUlRBQkxFIGFuZCBpcyBub3QgaGFuZGxlZC4gQXMgZm9yIGludGVy
cnVwdCBzdG9ybXMsIEkgZ3Vlc3MNCj4gWW91IGFyZSByaWdodC4NCj4gDQo+ID4gd2UgY291bGQg
ZGlzYWJsZSBpbnRlcnJ1cHRzIHdoaWxlIHdlIGRvIHRoZSBzZWNvbmQgYnJ1dGUgZm9yY2UgY2Fz
ZS4gU28gdGhlDQo+ID4gVERYX0lOVEVSUlVQVEVEX1JFU1RBUlRBQkxFIGxvb3AgY291bGQgaGF2
ZSBhIG1heCByZXRyaWVzLCBhbmQgdGhlIGJydXRlIGZvcmNlDQo+ID4gY2FzZSBjb3VsZCBhbHNv
IGRpc2FibGUgaW50ZXJydXB0cy4NCj4gR29vZCBpZGVhLg0KPiANCj4gPiBIbW0sIGhvdyB0byBw
aWNrIHRoZSBtYXggcmV0cmllcyBjb3VudC4gSXQncyBhIHRyYWRlb2ZmIGJldHdlZW4gaW50ZXJy
dXB0DQo+ID4gbGF0ZW5jeSBhbmQgRE9TL2NvZGUgY29tcGxleGl0eS4gRG8gd2UgaGF2ZSBhbnkg
aWRlYSBob3cgbG9uZyBkZW1vdGUgbWlnaHQgdGFrZT8NCj4gSSBkaWQgYSBicmllZiB0ZXN0IG9u
IG15IFNQUiwgd2hlcmUgdGhlIGhvc3Qgd2FzIG5vdCBidXN5IDoNCj4gdGRoX21lbV9wYWdlX2Rl
bW90ZSgpIHdhcyBjYWxsZWQgMTQyIHRpbWVzLCB3aXRoIGVhY2ggaW52b2NhdGlvbiB0YWtpbmcg
YXJvdW5kDQo+IDEwdXMuDQoNCjEwdXMgZG9lc24ndCBzZWVtIHRvbyBiYWQ/IE1ha2VzIG1lIHRo
aW5rIHRvIG5vdCBsb29wIGFuZCBpbnN0ZWFkIGp1c3QgZG8gYQ0Kc2luZ2xlIHJldHJ5IHdpdGgg
aW50ZXJydXB0cyBkaXNhYmxlZC4gV2Ugc2hvdWxkIGRlZmluaXRlbHkgYWRkIHRoZSBkYXRhIGJh
c2VkDQpyZWFzb25pbmcgdG8gdGhlIGxvZy4NCg0KVGhlIGNvdW50ZXIgcG9pbnQgaXMgdGhhdCB0
aGUgU0VBTUNBTEwgbXVzdCBiZSBzdXBwb3J0aW5nDQpURFhfSU5URVJSVVBURURfUkVTVEFSVEFC
TEUgZm9yIGEgcmVhc29uLiBBbmQgdGhlIHJlYXNvbiBwcm9iYWJseSBpcyB0aGF0IGl0DQpzb21l
dGltZXMgdGFrZXMgbG9uZ2VyIHRoYW4gc29tZW9uZSB0aGF0IHdhcyByZWFzb25hYmxlLiBNYXli
ZSB3ZSBzaG91bGQgYXNrIFREWA0KbW9kdWxlIGZvbGtzIGlmIHRoZXJlIGlzIGFueSBoaXN0b3J5
Lg0KDQo+IDIgaW52b2NhdGlvbnMgd2VyZSBkdWUgdG8gVERYX0lOVEVSUlVQVEVEX1JFU1RBUlRB
QkxFLg0KPiBGb3IgZWFjaCBHRk4sIGF0IG1vc3QgMSByZXRyeSB3YXMgcGVyZm9ybWVkLg0KPiAN
Cj4gSSB3aWxsIGRvIG1vcmUgaW52ZXN0aWdhdGlvbnMuDQoNCg==

