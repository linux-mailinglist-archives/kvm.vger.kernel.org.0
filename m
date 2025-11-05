Return-Path: <kvm+bounces-62088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFFDC3680A
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 16:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E6291A2458A
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 15:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42B733A01E;
	Wed,  5 Nov 2025 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W7XiDi29"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C86339701;
	Wed,  5 Nov 2025 15:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762357329; cv=fail; b=Q8rMgGDITq/4QIDxNNlnR7AvhShWu7ufXWgrhMtxu8DwtZkHDbbpWM8TnkEfUN0yiPhBt0HHi6tH/wIYK34XnkIDzhhUjhW1QBUvg+0dN18tbwjk1nn/tKCf04KlSGQyV2L85vcFGfXgK9YRIyxPdRgaMk5Ua0oj+J20XbA4pHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762357329; c=relaxed/simple;
	bh=YYTOaG5l5D6xZ866pWEXtPhEYdrb9YtthbP6eTu3qI0=;
	h=From:Date:Subject:Content-Type:Message-ID:To:CC:MIME-Version; b=A9ee+a+0fXsd3beOzMPCPVccaloCNv9KE9q8YBqnfDdgyZvaZ/YvHA/6dkOWL7mlGTEmdclYYMWELTfh9JMTZJcFq1Rx/MwUFc8/fIedM97E10XYs9wutSxiTTa/CMvCg9r4/c2hvwCLqog3aUzWG/29/ocfPPN3C0zWb4WdLY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W7XiDi29; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762357328; x=1793893328;
  h=from:date:subject:content-transfer-encoding:message-id:
   to:cc:mime-version;
  bh=YYTOaG5l5D6xZ866pWEXtPhEYdrb9YtthbP6eTu3qI0=;
  b=W7XiDi29LybKBTnip4R0T2f/QoaU1PIndxyTKLiYlOYIZWjE3YwuJQG6
   y7XNZtNdOoCYmdxIZWdWcNGV6ZCVI/PiwDCXrvv3hKTIvRW7lF+li7aYR
   OkGS6u5RuTnXK2pP6luXlEhEZp2JOXCBFmBNMANfW+qdlw5b1okL4XDR8
   mlnt8DRG+6SlOHdqRsqLVzfjPEsU94KDM6icZjQ8h7IKZPbVPzdYio+48
   1cC2eQsi8Iv8GrSuiJOiFPHbMVr95McU2OPBUOSkjHNa0lX0mYXAdHXDf
   PcUf+79RtNDfN4r0Or7X/T7mZPd1TMuRybxNwWhtCaMJKHNibNFsQpkwK
   g==;
X-CSE-ConnectionGUID: jOJ+Agk+QC2f/rkPeDrCgw==
X-CSE-MsgGUID: OBPv9nmiR5K48D1WmuBpFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="75590335"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="75590335"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:42:07 -0800
X-CSE-ConnectionGUID: tjCR/G4oQBC97M3ZFvIbtw==
X-CSE-MsgGUID: JhtZ3wflR0u8S5BSwa7F6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="187182549"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:42:07 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:42:06 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 07:42:06 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:42:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zSqx4hJMIBcoFASmPQH2xq3aU/ENCsEbD7kEjyiyPLD5FxzwPxtLasILdLU9gpidjSUzf2D/wyixUZwH/gcTaS+hd4uwG/cm91HpSv3FnDOVhHin9M/ADKQW1NI8/EtNiKHGoHAqlocue+qo4oAIXErVDrv4qEOcllFd192NLxys8Wsrl7XMbC25xDkHkPZsgEKBjWrFLhgb5BHXixHNFQqRcndmDzgmVvETDrm00nJrKZ55HXTFAmoHL3VXOv4vuA0VpKqMHWWb13cYJqu/fJynPP2ExvyCsy5AekrUEBNB2I6Ju9ZrDZxJHHuqrh2TFqDH5XiMFIx/TRWAinxpMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7H4oIoKs1Q5fZ7A4cqUhla0hs5KR/zIeFYyjPkLDEw=;
 b=LCMGDdJVwR2thAIHgLPz+N+b9fpMVKIAvZme54cd4U9E/jzZYHxCHc0jkIPt+1C44VThoMTPeSN1+jTyUqT4g+U5WVDkC6tFBSdKoNjGWSJFM9DdKsn+GbKYxM+TGLQSp8/kEGPyKgnxAJX50X2+N+/ypN5xv41y+3VIAqjP4F3NKWPcfKr3Ok2Zkl5IZEDrDQUf4EpWx+RmyD9KUa6i2ucNMjjZRIG2BlPyZzGNb29W1UFUu5aXbNjO/PjfvGsx9Lf0X07RXXncC5eVOX36jrJqmpPzDf9Zo8mnSYQQ4oaCEEWGUUWG/LN53r5s2sNBGBnN+/8vICGspHRtQfOvHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ0PR11MB5071.namprd11.prod.outlook.com
 (2603:10b6:a03:2d7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 15:42:04 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 15:42:04 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Wed, 5 Nov 2025 09:44:26 -0600
Subject: [PATCH RFC] KVM: TDX: Allow in place TDX.PAGE.ADD
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251105-tdx-init-in-place-v1-1-1196b67d0423@intel.com>
X-B4-Tracking: v=1; b=H4sIANlwC2kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDQwNT3ZKUCt3MvMwSIKFbkJOYnKprYWJkYmlmbGiQkmyqBNRXUJSallk
 BNjNaKcjNWSm2thYAm4lSC2gAAAA=
X-Change-ID: 20251105-tdx-init-in-place-842496310dc5
To: Michael Roth <michael.roth@amd.com>, <seanjc@google.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-52d38
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762357472; l=2948;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=YYTOaG5l5D6xZ866pWEXtPhEYdrb9YtthbP6eTu3qI0=;
 b=Okh4xgZ7DuS2iVxrheYOI6S/qchs4tu+MPmMAZ56D913HQrJuWZV9I1SVEdi8NvOTsVtmf1x5
 MHINTyAs65HBM1AjdNE2hBASyHu8jW0fBnAQNBqr8eJj2igqABdh4O5
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: BYAPR21CA0008.namprd21.prod.outlook.com
 (2603:10b6:a03:114::18) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ0PR11MB5071:EE_
X-MS-Office365-Filtering-Correlation-Id: 02722855-c6b0-40b0-3f6a-08de1c81de27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y2Y4cDlNeXhzVnNEVVl6Tm5waERpTVNtamFvVFZKMFYzM2QrMG95L3hRSGZl?=
 =?utf-8?B?NDlCMFBUcGhwRnlXQkdGbUJ6WnQrRWp5VFZKUitTSXpFMVo4QnpIRGNEbWtl?=
 =?utf-8?B?TjZLTkFhRkRlV29iM0F0QVgzSXkxL2s3aS9WblpMajNrVmtvSDU5aDVqMjZ6?=
 =?utf-8?B?RGEza2lxZTYrQjBDV1FTVWljVll6L3N6bEI1dHhGRTRaaG16Q0pvNHg2ZzNN?=
 =?utf-8?B?cjRCdCtXa2UwVWx4ZXZuUEM3NnV0QzZ5K0g0c3VOalQxeVAySmovdHlvbS9i?=
 =?utf-8?B?bkl4M2MxV0dMVkRrZWVrS2NIUmJGZFRCUmUrNzB3Y2g5TmcvZis1U2N4WFh4?=
 =?utf-8?B?ZGdwRCtRc3ljeXlrZ0JUQjlIdlZUVDF3TU5aZ2lTZm9UVWl5RGNJdk5WL2Jq?=
 =?utf-8?B?b3k0Zk9nbXZkWWVobnB2cDlXMkpFRHdTcHpYOUdSVndkdi9ycEVUMnZncVdG?=
 =?utf-8?B?VUNMYURPZU8wN3hNOTJNU2pjb0lSaE1meWJNVmNCblNNQTlkQ1RUTFhZZHpW?=
 =?utf-8?B?Kzd3S1RjUldVWHNMUE1uMUkvU3g0VllkUXZyYzdRb1RUbXpaZXNZN2lTU1Vi?=
 =?utf-8?B?M2ZNMTRXazBFRDNjazV5N0FqM043dnVjUTFlcEdaK2xVUVpWV0toaitxWTkx?=
 =?utf-8?B?VWZtdk1pZUJ6b2gzR1lUNXhPdUxUNUR6cElSNVQzWExxTW5OYTZXanRramhY?=
 =?utf-8?B?RzVOdHR0enJaN0xhUTNrSmd6UE00Yk1PNzc4NjFBQ0Q1UmREeHBDVWd1bll6?=
 =?utf-8?B?TTR4OWxseDRIem0ydGN5WVhCcTV2aXZYTEh0SWdJcStHMFpmUjVCcGRueCtU?=
 =?utf-8?B?NlFQSGVMSWdmUkRrZVYrMEFvZU1jL3IrcWhZLytDeVBDVVBYb3V6eHY5VGoy?=
 =?utf-8?B?M0xrcHVxV25yenM4N1JQdHNjZWxUMnJkT1A2Mk9PeTFuQmlUK3pyblI2M2V2?=
 =?utf-8?B?Vk1pK2hyODBEb0lIMWI3L2EyYkt6blpicGQ5VDJ0YVJ3RXBPSGZNTnpaNTF1?=
 =?utf-8?B?STFMdnpUeEFLYStiMWpqM3BLREUwekFCWFdwaDBtOWlDTlRYcE1oNk4xUmJn?=
 =?utf-8?B?dUx2dVlwczVrWG92bno1eWN4NmRhaHRQQlprZVJYam1YNmdWNGlUa1pyUnZ0?=
 =?utf-8?B?dUxCcGlFN0ZTK2xJbFNzZE9ScnZvY2lqbEZJb1dTU3NRUGE2ZzFNTWpaL25V?=
 =?utf-8?B?TVVBTWJoc3VEMjU0TFRkdytIZHBmWXVpWjFpMUxCZUp4cEdQeGUrSWJ6REpw?=
 =?utf-8?B?RlVFZ2ZRTmJwUEJ6UXRLbWdTR24xaS9qWVk1b2RLMDlzdXZLa0hsY1dZK1NI?=
 =?utf-8?B?SFdQdklJYkVGZ3JpSllRejVka3EyMkNGTEFrZ0NxS1JlbzFxdlJQNEJlT2xR?=
 =?utf-8?B?SnRzVW1vVUdmSFFEdzMzQXJqaW1jeUd6YWJVM2FJcXYvQko4MnhTK3gyYkJT?=
 =?utf-8?B?cmp6L0xMUFpZMUtMYldaNHY2dXpNdlI2OCtzbERiK2VjWnJacTdmb24xRnRp?=
 =?utf-8?B?MTN1b3AvdjdYYXRCSlQwS0pvNGhBaG1rdWY4bm9CeFFCYVhlSStIei9VUlhH?=
 =?utf-8?B?anRMTTJZbEpIZi9Md2xXOFFwdm9jRHI2UDl0cVNUa0grKzl5S0VIdi9YUmpa?=
 =?utf-8?B?SnZMZXY1S3RVNVV5WXc4YStLMFJ4bUNsenNBWkZQTUt3bjFVcUE2Q2plUXh0?=
 =?utf-8?B?YWVlby9xZ2d3MjFZQ0pSdmllK0E1NktVa0lELzR3bW5KUURpclJ2SU9qOHgw?=
 =?utf-8?B?VW1VZkVacjVLSmxrdHRkOXQyUGY0R1kwVkthUWkvZkw3RXFBSFVqTWlhZUFH?=
 =?utf-8?B?eFlTY1dMTitsMzFuTW0zdmZlRVAyakFyaHV5bHVzaHZGUmZoSFZUSGRhODlO?=
 =?utf-8?B?V1c4MWl3NmQyWE50TEM2WUNyWVJiVlRCNU5EYnlaVGdYS3E4Zno2YW94dVRM?=
 =?utf-8?Q?fcrk0m38qYH5eR3gfjdKoBadtH90PMyB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVpBSEpYWk56RkVjdVQzZ1FlczZDa1k2Y1N0b0lYVTdUd1FCQmIyTTgrL1U0?=
 =?utf-8?B?OXNwY1M1S1gvM05hSlNzMkZqKzE0K0FXR1RoRm5veVVNSFF0cFlLUjNpc2E4?=
 =?utf-8?B?RDJkZ3lXSGJDMW5wQmZTRXg1KytmbTR4Vk9NL3JMOVE2WElhVkg0YU92NE94?=
 =?utf-8?B?M2hHbGZ1UDRicmpJandIL1FYNEhUOFFodTNmVWo5SW1qZkE3UjJkZFYzbzlM?=
 =?utf-8?B?cGs1Ujl2TThNZUVTQ241M1hHeEpuODFYNnNRQkUzd3I5ZDVHMU5pUlhYNGpS?=
 =?utf-8?B?V1BsNTRZSDdZVjVXODVZcUxmMzR1Z2IyZE8rR1IzaUp1c1FxRERsMklZVXhk?=
 =?utf-8?B?MTFJSndYYVNQMUtKMWl4cC8yM2VsRS9WcXVvU211akkxTWU5OFgwajZpdVp6?=
 =?utf-8?B?VlpNNXlYWXlrZU1UYXRlejE1WS94YzBUM0NSZ3JDNEZZa1pKWE5zdTY5Qjh4?=
 =?utf-8?B?ZUlDSVBHdWZuYTkzUkxlOWNsUmxGNG5pYk9mNHk5aDFoL1BSRzhNemhoYjZx?=
 =?utf-8?B?RFlLem9lL09DdFVaY3kvQTFkWWU4MmtGVGk2UWVhakNMYkM3WElDMitBMW5a?=
 =?utf-8?B?K0IwSVlrekZtdFpKV2ZPOGIxWlZwTTNuZlNkZlpPOHpHSVozN01BdFh3SlFH?=
 =?utf-8?B?Ni8rZzdwYUJkbW00bFRmemRDcEZTNDJRaWVlSFZLY1UrSFI3N1ROalBtSTRy?=
 =?utf-8?B?ZzJjOGZVVjVXaXhxak1odlpNbFhTUmo5MEhia3dHRCtkb25mb1RuQlVNWVl2?=
 =?utf-8?B?VkdGaFpjRFEvNmxtTW9xYnovRFBaMUNEZHc1WW1lZDVtNlpNZytJMG9tVmoy?=
 =?utf-8?B?UE9scDZOQ2IrNDM1c3p4OGQzQXZWam91aGtwZXo2NkdwOVhtZUVSbURodFQ5?=
 =?utf-8?B?T1U4dG5OemVNcXNGcWtwZU93QWF4N21Qc1BtekcrSWN1MmgzM1ByQ1NoeWVW?=
 =?utf-8?B?YkxkOXlZcnBvRWs2OWFwTUlHNE9uVUVJOVpMZExTOXJwM3Z2RHM0Ym9acDgw?=
 =?utf-8?B?UVFldmFFSFcydnJxZ1g1a1FyVitCYjBGNVRaQ2tIZzdyc1pyU0tpZjN4dVZF?=
 =?utf-8?B?ZG9tN1dlMktTVlI0dHkxR1UySzAydXlsRDcvL1BJUGJMUEY5cG9sNC9mUDBv?=
 =?utf-8?B?bnV2aDA5T3pGWENuaXJTWDJyMForbmEvc3kzL1cvalF6U2dTcENsaFdTNkZk?=
 =?utf-8?B?Z1ovdG93bFpZWDlEdGZYMHlURmdPdE03T0JiNzFIMHFVWk5rbm0rVTBsV0VZ?=
 =?utf-8?B?VDNnOTBMN2pGcWVBdDBobmZla2NxeFJQaXFNYjdHb25kaUExZzBoVWFoTmZX?=
 =?utf-8?B?THMzdThLMFkxbm8vWFFueVY1TUQ1ZTR5YWNXdVlCMHg1TWIxVk8vZWRuL01G?=
 =?utf-8?B?NG1lZ3VmWXA1amJCRWNWcFB0Zy9tNlF6WUg1Zm5JUUpXeW1ST1FOTS9JYm8x?=
 =?utf-8?B?aG5tcWIyVGNhZ1V1ZEpvWDZBWEIzNmZpWVJnMnBlaDdkSE5yblhoT3MvZ2Jw?=
 =?utf-8?B?dk1Nck13NWdHc0VsYlE2MG01cXA3SE5rZ1BTVm5HLzNYc0pUNUZveGFBaWEz?=
 =?utf-8?B?V0wxMityZk05bmQ4Nmo3U0tvSEZxenpRby91QjFqTjBKRm5CYUUwampYWllR?=
 =?utf-8?B?dXZ1NTc1NjNXZWdQQnd4Ujh5WWU0NGlkbFRlMHhhdXR1SHdMaUhiMFZzcVRo?=
 =?utf-8?B?ZkFwSWhLVzR3Y05GNXBMSWxUcHF3Um1odVI3bXZPNFA5UzNtVXFBT21YeUdF?=
 =?utf-8?B?dGVtaFhiSzN0TTlHaEFSbHY1aWIwN3I0aGRuMVBmOEIxRHl3ZjNZaUlwRVdt?=
 =?utf-8?B?ZTR0b3RlTnNON2tMdFVQeElMamVuOGZ2MnhVemZSZm9pR05mK3lZM0pURWFr?=
 =?utf-8?B?TzRuMXduUDRxSDRvR0NUQWVnZy9mVzlXdko1S21OditGWlpFdXNScEZkc1Mr?=
 =?utf-8?B?MWZtZHBSKzFaa01WSVdHVW9YZ0dKNU9NTlBFVjlaQVBkYWZwd2dudWNtV3lQ?=
 =?utf-8?B?OW9rc0hvOVNFMGVVaFA3cmk3eU1aN3M5ZHFwL0NPZnhuMEE0NWp2WGZpUkZL?=
 =?utf-8?B?MXNnZnhMTHVVVExpL0cxY2NUSWJrY0p1VVUwNWlTMzhLSWZwUjQ4L2l1TDVk?=
 =?utf-8?Q?j5RGDHYmRDc3g4MO6lVsPnYTK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02722855-c6b0-40b0-3f6a-08de1c81de27
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 15:42:03.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+smN/ucfUpJoU1IoMS/V1lH1fzW1T/lEEjRRpfnohfDpC464So2BZtfCAJOYN2qSRunpI39H1SOWt/yTYL/fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5071
X-OriginatorOrg: intel.com

As promised in the PUCK call today here is the patch I spoke of.  The
commit message is out of date.  I was building/testing this on top of
the old TDX selftest series.

This is untested but compiles on Linus upstream.

I looked through my notes and found that I was concerned with how to
force an unmap after conversion.  With what we discussed today I don't
think that will be an issue any longer.  The conversion to private prior
to TDX init should (could?) take care of that.  I'll have to look more
once the gmemm populate series and Michaels stuff is posted.

Finally, after Michaels lifting of GUP to gmem this should be unneeded.
But it shows that TDX will be fine.

<old commit message>

TDX.PAGE.ADD can convert a page in place with data.

With the addition of mmap and shared/private convertibility within
guest_memfd it is no longer necessary to provide source data pages from
which to copy data into an encrypted page.

Also some code, such as is in the selftests, do not require any specific
data be placed in test pages.  So one can skip the allocation of a
source page all together.

Allow source data pages to be specified as NULL and allow the TDX module
to encrypt the destination page in place.

Not-yet-signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0a49c863c811..8056d896f0ba 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3181,11 +3181,15 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 * Get the source page if it has been faulted in. Return failure if the
 	 * source page has been swapped out or unmapped in primary memory.
 	 */
-	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
-	if (ret < 0)
-		return ret;
-	if (ret != 1)
-		return -ENOMEM;
+	if (src) {
+		ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
+		if (ret < 0)
+			return ret;
+		if (ret != 1)
+			return -ENOMEM;
+	} else {
+		src_page = pfn_to_page(pfn);
+	}
 
 	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
 	if (ret < 0)
@@ -3228,7 +3232,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	}
 
 out:
-	put_page(src_page);
+	if (src)
+		put_page(src_page);
 	return ret;
 }
 
@@ -3289,7 +3294,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 			break;
 		}
 
-		region.source_addr += PAGE_SIZE;
+		if (region.source_addr)
+			region.source_addr += PAGE_SIZE;
 		region.gpa += PAGE_SIZE;
 		region.nr_pages--;
 

---
base-commit: 17d85f33a83b84e7d36bc3356614ae06c90e7a08
change-id: 20251105-tdx-init-in-place-842496310dc5

Best regards,
--  
Ira Weiny <ira.weiny@intel.com>


