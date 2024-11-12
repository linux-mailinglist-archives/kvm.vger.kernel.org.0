Return-Path: <kvm+bounces-31672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D84A9C6364
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:27:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C01EC282D2C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904A621A4CC;
	Tue, 12 Nov 2024 21:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/3Hae8F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D6D2170DD;
	Tue, 12 Nov 2024 21:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731446813; cv=fail; b=GjIePnTTUqg+qkEStcIq2FdSeGqnljjzfm6/xsYMQZDRW16akYwxVe6yUREFVFNFoP4Xaf5AAQNbKOSxlG+8REfQ7CqnVhxMWjOB0iWUzzhUbq7jINPAHSjlJKa4uMyN1pW6++gFTrKLpNe9hF1enfjinPzecciEiuAwbNJA9ZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731446813; c=relaxed/simple;
	bh=bjtXCgsA5n6V9cgacHBproyYb9bT49xOmQg5xYxIE1k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TLbOkw682X87uz+tEiXF8PyLXy04bppkXWwJksnZSpciYpm9NrvwTjQJEC4O7VWn1Y8MBw9ZwIdEBb8CPADW54Hz6PCWVQn5pJjW9UDYiPlkV8ZDuP/FJ8PvL34clmbw4HFxvyIwr4PYZ3Fzdw+EI4CvjZ6ZS/nEdtAlwGHj1P0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/3Hae8F; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731446812; x=1762982812;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bjtXCgsA5n6V9cgacHBproyYb9bT49xOmQg5xYxIE1k=;
  b=i/3Hae8F1GhfAI+J4oyvwux1s4fr/i0MQlQj37emhSv8z6xhbhhlSsVy
   EbOf7Gfl0s8cV0BlWq4vmwMAyGMtamoHnrHkRrMcVzwWexKo8mbP+W8rj
   ASbwhbNJbwAQ9ixjMS29yIadyLtIdBVBBKpSkRl79vX9DnDy2mvFF6dYS
   ifGxEErpRfWdHJ7keW4pcERZJeeMC9kpXqAdDhIR0waVcal/TRt49tsal
   kAu68ukxYs/vqsMco8VW9mpRkb8feMhk0forjJocv7eBufp+CG9EzX38C
   Cy3SlzmGtLjmttnQ/QpCyx5OzUviUzbrwzIRoaFEksBxDk87yBpYiQmxe
   Q==;
X-CSE-ConnectionGUID: m+BAT9PeSKWIikzAjuHOOA==
X-CSE-MsgGUID: /XloEmYUQg+qNNr2lnBLtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="56697841"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="56697841"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 13:26:52 -0800
X-CSE-ConnectionGUID: e7Hl/JyWSYiwBKF1wfnynA==
X-CSE-MsgGUID: 2VAICQLiRnOB8PlgCVF+pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="92727524"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 13:26:50 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 13:26:50 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 13:26:50 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 13:26:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qB94Zo9aZcucDBCx79ciZygX74u9XW0gsrPgXtwp+cRdlMbTEAwq4gKAIju0eUEXGkgfe7EbX9RMVjRjJBEjc6N4zuONt1A4JlS6S4RLQ1Qi096Ftt9bwc3Au88qLPQzI9wtrIoD/94YrgnwSrmnhnHpPMxTg+WxYP+9pvRymDIO7BieZg8lik19jIuoPLMNVV22PM16+kzthaAd726aigSXAo2xT582v6gqJWiTwwUy+omXAdhHJtB93KxZLGQgsPruNZcPcrx1VBkbDYznI2D61kI/QvLRbJoi3xQV5Y0stzzb/NbHJ04x/ML6cRcY+oU5gKEx2jrKVsa2VlfrIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjtXCgsA5n6V9cgacHBproyYb9bT49xOmQg5xYxIE1k=;
 b=d9EIZx6BtmTBSaxoQDytlicXLB57Z0qAaWR7AbY1WmZ8sYx9Ht706DpNNk9dP8f/55VsiCy1Hx43vGmhDJg/S1Rm57SVIDz44Px5UTQ9/hi9wKNIJ5Kgg1WAkzR3uF4ejK5uTc0Ij6D054HHCZVSz85rRNE4nv7Z4Bg9n3txItsro5NBLfMKPDGSp0u1sbYpPh84R496qpJeG2gH8rlnAsdsB7+MvbxcV9crryr7mFCN1UrkYx8YT/PRw9CTNW4K3WDgmq9dxWtLT+niYrZ0zEO/wdcCq9DhZx3adkPUfpzmtaQVYPBO/Bw/X+bw91f5g/WClwAy0moBO0MNCnwioQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5232.namprd11.prod.outlook.com (2603:10b6:5:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Tue, 12 Nov
 2024 21:26:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 21:26:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Thread-Topic: [PATCH v2 00/25] TDX vCPU/VM creation
Thread-Index: AQHbKv4pVcc0TTk+90Os28TjCMK+G7KhPi+AgBL++oA=
Date: Tue, 12 Nov 2024 21:26:46 +0000
Message-ID: <0ec7f4db5fc409f23572eb4c43c51ebeb61274cb.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <d0cf8fb2-9cff-40d0-8ffb-5d0ba9c86539@intel.com>
In-Reply-To: <d0cf8fb2-9cff-40d0-8ffb-5d0ba9c86539@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5232:EE_
x-ms-office365-filtering-correlation-id: abf6fae0-610f-48a8-3ba7-08dd0360b669
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Rngrc0pmSC95UVo3N2RtUi82S05mWm5yUFJoNzc1b0dHSmtYeUhPNi9KdmIz?=
 =?utf-8?B?bVNRMlpNMVZqMk5ONkVDbGdGY1lhWnQ4Yy9vNW1nUUtDSUZxQVBMN053RS9X?=
 =?utf-8?B?Q3ltN0dIOFRXaG8wMm9XeUZkTVZ5ZUl2WGU3RWJISmtMbGZONkd1R3lDTWhX?=
 =?utf-8?B?RkpqRjByakZUNS9wQ0k5MzFzM0ZZM0M5V3FQKzRBR2Q3cjNSTVY4OWQxZ1Fj?=
 =?utf-8?B?cEZmWEdla0RwRXRVQ3FvMXM3Z2Y4bG5VanN1MVV2RlFsclBWTXhnQUNBbEIz?=
 =?utf-8?B?RXdGTXdJZ21SeVB4UjhjTkhaclRaM1IvVUk5VXNnb3JESVVESUpuandZUjVs?=
 =?utf-8?B?TDVCRDZnSmNhOFRLaHZBQ3dCelhoY1VGdjFUYkp1WXlEOTErMm5WaHlzV1U3?=
 =?utf-8?B?WUR6RmhOT2tVSzN2WlhNOGVnZDZ2NFNCUXBuamZ2bzhVaXhrMDBwSnlxTEJp?=
 =?utf-8?B?b1E0b0c5aWhkVGVLOVNNRFpIaVNuZUZQaEMyempmdjV2RUpBRzhIazQyaHBP?=
 =?utf-8?B?Zzkrb1VOZGEzNXdGQUxiQjFsM1BncTRkTVJhbDlDdGZvYi94Qm5HQmpvL2FY?=
 =?utf-8?B?NWxLRHhWMlNJYzA2aGEvanQ5Syt6WFgvZVdENnNrcVBCQzJzZm4zWUMyaW1B?=
 =?utf-8?B?ZlgrL2w3dTU5Ri9GTlljcEdtWTV1ZGJQV1hIOE9oMUgrQVNBZHpKTGZQcDM1?=
 =?utf-8?B?YmZzL2RsYnlQRytLaHF4dFNKdGdMSnZGMExDVW8yWWJuZms1WFN4aU9ObU5u?=
 =?utf-8?B?aitjbnhmbitUcXpWRlNMaFdCaEFXdGZwcGZjeFRCNitYN1d5NWJTWndVaHVp?=
 =?utf-8?B?NW02bXVFLzdRRzZVL25Vc2pySHRLckdQd1kveEVmTVBrbzQzTFRSUThDR1lr?=
 =?utf-8?B?Q0JKakUwZEh4SWZTMWFSSkxydnV6WGxITWZyekVwU3NPVzVEVWtzYTI3QU9r?=
 =?utf-8?B?WVBhaGNKa3VtcmRpdzVMeXFVaHYrOHBHbm03cFBjdENWdjFJU081MDFuVW9p?=
 =?utf-8?B?K0FyRW1NMTgrMGpIbG1tRmVNZXJ2SElnSElQV3FBMTZ6Vjg4ZmFQVGEyZzY1?=
 =?utf-8?B?b2tFL0lNaDdRamdackMwSlE1enJ6VlB1R0krMXlQRjh1VUdwUmlsS3FNck1K?=
 =?utf-8?B?dldrNXpCMk1mRXl0WlBlZ0pEMFNKWmlLQ0R3cUs3SWtjMTFOczNPbXdVbEVH?=
 =?utf-8?B?cWVqRlVieXJjVnByTEpLV3l5VW9MQVU2dCtORDVSdXJ5SGN0YkxMakFkckJI?=
 =?utf-8?B?ZkQ5MGxEcFRuRWFPSE1ET0hxb0RHeFlZNWNvWjVHQTJrUnlnQUdMK3JBaHpO?=
 =?utf-8?B?cm9obisyU25CMUJ2cVp0cGd0dzRueVRpVElwNjJYVHIwWDkrdXdHUWpyS0hO?=
 =?utf-8?B?aXhOMkZpdGdrK05wMThDUFloZzl1YnRNMTgybEVQOU5GV3ZMUEY5RVAvaFNG?=
 =?utf-8?B?VzFhbEVsangzRjRHLzBCemk1MFZkWUllZC9sYW1BNXd6SFZTK0V6SDJIQ2Nq?=
 =?utf-8?B?eHgva24rYU9hczZXWmRUWHhIZ1hGUUhVamlyREdZZTVLZUdyazV6NFNYYlI2?=
 =?utf-8?B?aXlVMzFtYUZWNVZCck9maGdjOGtMVHludnlwazdxWkorUDk5Vys0ajJTYjJj?=
 =?utf-8?B?Z1NMWjNlOGR6WjczdS81SWVTekpRNnl6bWtuQ08vZGMxYXV5aFNjQUh5R1JU?=
 =?utf-8?B?YzJPemlIdjBLWnBUWWpGYkV0L1JIY09NL3Vra0FLZE10TzNMMmM2TGFZUWp1?=
 =?utf-8?B?SWh1dmdtcFpUT00wRnZtK3cyYlJhSVBtckNtOU5lRTRQSzFuMXdCYlBJbFBQ?=
 =?utf-8?Q?GCf3DluexROhJPHEkggVw5LxccabkNXui1fQM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V001Q01RMGFLSS9nbDZSZm0zdmVkZk4rWWNYVng5UlQ1b2JEN0NnRHBwRFlR?=
 =?utf-8?B?SnE5elVRb0MzdU5Td25SUFc1Y1hjYlBNc01MNHRqMlZaRk9vVlhRVWJmOVIy?=
 =?utf-8?B?SUZ6VW9FZ09OMlpYejN0QmRmbG5ZMFhoYzJET2Z4RGJEMmd6S2NmczN1OWRk?=
 =?utf-8?B?Vlp4bGt1RHJIa2V3TUpQeVNPR1RtSnBleC9FRmtMbnMzOEJlcnU5VWtuU2Iy?=
 =?utf-8?B?UmRDUVpQY2FwTUVhUzBxRHZVTWZMY0ExMDVVaXdnNy9Ua0tZMzc0SEtGYVZH?=
 =?utf-8?B?OE5vejFaU1UySW9ZbVFqSno5WUZOYkVTUTVDN0sxZURDK1pLRjlyeU9CVUxp?=
 =?utf-8?B?MkgyS1FWV2RjNERYd2xTVDBDY0MrbTBjTTFVTjcwYmM0ZUpUVWxsejkzZktq?=
 =?utf-8?B?NmVTd1pYZjlJKzVPeS9ZVEc2VS9DZ01HNmd6UUlETmZkMEI5Sy9Qdm9iSmJS?=
 =?utf-8?B?Mis4Q1czMG1wTXZWVGEwN1ozVXV5K2hDL3VKVFQvOWtlbGE1MTJZTk1SU21q?=
 =?utf-8?B?UkFScXU2S0tBWUFUa0VjcUhoclFYWW9jUXZVbGlOS3pLT0hHdURVZFVUaG9S?=
 =?utf-8?B?NjAxZ1p3aFZYOGJENEtNNUlnQVZQa1M0Wm1uOThTWE1HZmM5cHM1Y2pXa0pl?=
 =?utf-8?B?RmhIQVV3VUxHTnNEcDZGeFgvQ0tnbVNMSDZZR3cvZG5DbnJIL3NxRERCQkZh?=
 =?utf-8?B?MzllUVB1ZEJZb1BiRGx2YjZwdDliRG1kZEk5SnUzMWtCb3pZT2xMTDMzRmRR?=
 =?utf-8?B?eGJrYnByUzZIUE1wa0NpVSs5MzJlSWpZT2ZobjQyd1FwdjFQK3E2ZmtPa0dw?=
 =?utf-8?B?UnJ1VXkyZkpiYzNHenpJZ0NXVjc3M0hRcWRESUZaYUQ4RXF5eHR5ZGFmSFVI?=
 =?utf-8?B?Y1RUOFZVNm9ENkVGRGlFakQ5Z0RvOVRmREJhdkJkUVY0MzYwUGpCMTZMUEpv?=
 =?utf-8?B?RTlpdERscTVhbU14R3lKU2JkZDU0RlJ5N1VTcFVsaUZQUVlZVjZJYTBEVU9k?=
 =?utf-8?B?eElZT20vclBjVnA0dVRBMnZRQnRBbDNrdW01Y2tiOEMzdFUwaVRZdEp6SUkz?=
 =?utf-8?B?SytBUldWQWlFRDdMTlpMdlo1VTZXRFVzVFVackd4RTZ2OWdia2w3S0NLN3E3?=
 =?utf-8?B?SjNYa0hlNnRnQ2dwMG53eVdONERqOVpnTU1kdnQ2cHFmUkI3TGlVdThrd0pT?=
 =?utf-8?B?YlE5TkNGOGxqQXlyaVVYTGM0ZlJFZUFTdVhZdmV2bjNiN2x5YVRTZDhnZEgw?=
 =?utf-8?B?eXZDM1Bzd3kvYTBpOSt6K0h1d1R0ZkIyQjd6Q01VSkZBN2laVE1ja2pIY1hi?=
 =?utf-8?B?aUxBc3Uzek9GVWo0bGJ6aHJkcSt5OTB2cVNBQjhqTmU3MUxySmR0eVNaOWdx?=
 =?utf-8?B?THdRT2UzUFcyTHBCei9CM2tLaWVZR0h6Tnl2K0g3UUU5aldHcmRLWEtORmNq?=
 =?utf-8?B?eEt5S2tXUkxlNmtBRG5HK01vV2toSGx5WEg0dzBFZXlkcXhXQ3N3elllTnhp?=
 =?utf-8?B?SW9LWVlWMVhDV1h6ODcwNXdCNlhLQ29vT3p5b3NsYUhiUTgrTGVXZmxCQ2dO?=
 =?utf-8?B?a1crRDJqb3ZzcUF4THJTcnZESXFrRG5LSk1QUW9TcVNNSG9wY0pJRitvR0xT?=
 =?utf-8?B?b0FiZW1KUHZxSVB5dEVTM1NZd05jYUVYR3ZRKytLWFNkVHpEd29DTkk0cXpN?=
 =?utf-8?B?eGRCMlNrOHVCV1pwc255RW5tV0RGQ3ZrSmtNQTdraGNPTTFhbExhc3hocGVS?=
 =?utf-8?B?bVpHcm0vNVVvcjF3Z0xxSHZiRTdZOXl3U2VGVmdWdE9NUXd5T1RKd09yZXhx?=
 =?utf-8?B?T2liWUdHaEZDcUhuZlNpSGI0amZZVGlSellwZUg4RTAva1o2SWJQMGdPQVdY?=
 =?utf-8?B?aXdzTXRzVlgvZ01uWmVYeUF5SWgyOTRGaEFUTmZ2TkROa0lCUndqWmo1alBH?=
 =?utf-8?B?NnJGSS9RbU5KUmRJa2xvNFdSOHFOQW9lRFpTK2Rrc3ltRHU5Mk1vdldGcWJJ?=
 =?utf-8?B?d3poWXFSdTdpbjVGMEZUNGd4QjlDT2tRYU5qMTlHLzlkSjdjajh6WlhNU011?=
 =?utf-8?B?MVFNS0J2QjZLaTNhRjdld1ZlTlVsc0VHazV4Z1ZyWHRtZ0RYTTlUdzY3NGh5?=
 =?utf-8?B?eHRZMUVuc3lDazhqeEU1bjUwOTRwdXdzOFpNNFhYaHp4SHRncEZUOGVpVzZu?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9E73B7E6E4FF4458DE29E1D67E247B6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf6fae0-610f-48a8-3ba7-08dd0360b669
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2024 21:26:46.8154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nybfJbeNHllqX+SD7TA+tZ0ZqYbKpV+u61g/LV4zuXmRvfFzMQ7RwiqqeMsKORpvy5+xgdlpzDKIu+Bwosd+uy3Vdk6Grbw4X+Ga0UfXmzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5232
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTEwLTMxIGF0IDIxOjIxICswMjAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBPbiAzMC8xMC8yNCAyMTowMCwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gSGVyZSBpcyB2
MiBvZiBURFggVk0vdkNQVSBjcmVhdGlvbiBzZXJpZXMuIEFzIGRpc2N1c3NlZCBlYXJsaWVyLCBu
b24tbml0cyANCj4gPiBmcm9tIHYxWzBdIGhhdmUgYmVlbiBhcHBsaWVkIGFuZCBpdOKAmXMgcmVh
ZHkgdG8gaGFuZCBvZmYgdG8gUGFvbG8uIEEgZmV3IA0KPiA+IGl0ZW1zIHJlbWFpbiB0aGF0IG1h
eSBiZSB3b3J0aCBmdXJ0aGVyIGRpc2N1c3Npb246DQo+ID4gwqAgLSBEaXNhYmxlIENFVC9QVCBp
biB0ZHhfZ2V0X3N1cHBvcnRlZF94ZmFtKCksIGFzIHRoZXNlIGZlYXR1cmVzIGhhdmVu4oCZdCAN
Cj4gPiDCoMKgwqAgYmVlbiBiZWVuIHRlc3RlZC4NCj4gDQo+IEl0IHNlZW1zIGZvciBJbnRlbCBQ
VCB3ZSBoYXZlIG5vIHN1cHBvcnQgZm9yIHJlc3RvcmluZyBob3N0DQo+IHN0YXRlLsKgIElBMzJf
UlRJVF8qIE1TUiBwcmVzZXJ2YXRpb24gaXMgSW5pdChYRkFNKDgpKSB3aGljaCBtZWFucw0KPiB0
aGUgVERYIE1vZHVsZSBzZXRzIHRoZSBNU1IgdG8gaXRzIFJFU0VUIHZhbHVlIGFmdGVyIFREIEVu
dHkvRXhpdC4NCj4gU28gaXQgc2VlbXMgdG8gbWUgWEZBTSg4KSBkb2VzIG5lZWQgdG8gYmUgZGlz
YWJsZWQgdW50aWwgdGhhdCBpcw0KPiBzdXBwb3J0ZWQuDQoNCkdvb2QgcG9pbnQuIExldCdzIGRp
c2FibGUgaXQgYW5kIENFVC4gV2UgY2FuIHRyeSBhIGZpeHVwIHBhdGNoIHdoZW4gdGhlc2UgbGFu
ZA0KaW4ga3ZtLWNvY28tcXVldWUuDQo=

