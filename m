Return-Path: <kvm+bounces-62079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A23C36543
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 16:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EF113B5779
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 15:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E66F341674;
	Wed,  5 Nov 2025 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DP6VJwMS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37051340A74;
	Wed,  5 Nov 2025 15:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355572; cv=fail; b=f2VS1nzFWHxdnOoAyxvWIzNLf5qdQg6OrCAkpeOYGMx6XxAtIn4G/r4xYIgDvKyTMi0t1nPJundh/2Tta4jge7ZyXgm68fjimuLYMFgE1XSD5OZ3v5EbUJqwsg1L7j16Xq58m0s6wE+VtJM0a7Q1YdQ7rKvvkChLk2DHu3XpdDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355572; c=relaxed/simple;
	bh=zCcjXV5AkWNDmCiJGYpZ00sraDi/6V++0hLsdFBiek8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dzpZCjT+UcGaeKW7r9JkvkzJ4v1jBq/XLE5+CGT6vP2jyhVAwLc/zUsrzpzoWgR5IVCfsFFVQzlwkI58Gx02/UgqIhKOeOuj3PmXVLku3xW0zC6nCCD1/ASK7PWLCSyxj8XGZVSQQztbBTSquavWxmU3YMh4KRhV8AThwT7xYRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DP6VJwMS; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762355571; x=1793891571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zCcjXV5AkWNDmCiJGYpZ00sraDi/6V++0hLsdFBiek8=;
  b=DP6VJwMSn1tytHNcphb9AFlQZlSLvrulawE4KaMaivsgeC5KXAxKKAIk
   nYFBq7XlvUM+s5HGqJ8F5iSTHpXYxK6hW5yI9AhN1EuA0xWrga6dthAce
   ggnwSwM6cr8FlY9o034D9ZiZhlDr8/Jfgy1p7yW19T8UkjfxH5daW+077
   na3B4mWFxT0XhiTEGRhYBAqjQd4trRLuse1I21dg4Me/eAOi5xkD3j7fc
   QeH1Y5e+gyx5hKn6mQ4mS6IOpTbqvp3Ah3NLItt/aENmgF5PEoCIkIT/X
   f+ZzxEd7ziS/CkMUcuQlETBeDE6gDruOoRClLaO6aKQ63obGhbX8LssgG
   Q==;
X-CSE-ConnectionGUID: K5ZSXa7xTpWT0Irahy1YoQ==
X-CSE-MsgGUID: bWWH36dsQ3K7F52O8ZyLqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="64169038"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="64169038"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:12:50 -0800
X-CSE-ConnectionGUID: fbb7CgBHRG2I4PghR+sOCA==
X-CSE-MsgGUID: qmwgcrK0QZuzvsQ/6QlcLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="186766610"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:12:49 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:12:49 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 07:12:49 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.69) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:12:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pACm7497/GkwMTvtfWFyNcavhwZblZG2/QFP1ZtA6gIgVCmlLt13u3UNOqPpggfygs4K5S8GgUxj5NjsYZG6IKHz4s3GHlBYCSHmoL5IrBpIOdISyWj1UD3EZ+RcCbjd/lt2hPYZmHWZDCbi+BdmrD1F0UKnduY3uwKZxBjo1XEZ54RH3c4cCobOR1R1KBLNAPFgBmqazb5aNXBLrakQAmxQ3WLP6q7WdlYxCnT1iek386bTmoCW0jT8zfx4AVP2picf7DRwjHbm6SU4TOjcHgF+HYwwN08LOxUmFfeztHoSRwx8uurzDk0m7pT8EjQaFcmRGWPZVsZwdjkIqSi3Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTkppz7S19/7prWaAEWdhdnZay3LwyUIP3Hrqz/7C9g=;
 b=TyIkP+DvTpk4j0+xbjyt67J01uFw17D8Es3yQkmHg5O9d/qzloBbW+wFQdZ9pmKRpL6QQ0k/2E2Bbmwdvn4z8v8zWnBUvIGfJdPGRaT0UcSYN6arkQdLrc504jl6rmaZBSLKNeCg3z7EOKkIVJXy/JVQKEk1UnUGAt8+2x6CLo58a/Nh98OMWdwQ2cMiKZ3GcywZKGiS4GbdIvqr2Jr+3A6PoT534NURq3ah2qKcH/k/Wl4DlMZAejaBw/1WR2oQNSymjQeAA0i34a2MbmpW4XcNDMDSDrZb6v/m2F6sHymqYCNfK8K4xWbP4UKHw9qZHgyNUn4wWJBrkUDI1u7ZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM4PR11MB8226.namprd11.prod.outlook.com (2603:10b6:8:182::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.9; Wed, 5 Nov 2025 15:12:47 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9298.007; Wed, 5 Nov 2025
 15:12:47 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>, "Michal
 Wajdeczko" <michal.wajdeczko@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH v4 23/28] drm/xe/pf: Add wait helper for VF FLR
Date: Wed, 5 Nov 2025 16:10:21 +0100
Message-ID: <20251105151027.540712-24-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251105151027.540712-1-michal.winiarski@intel.com>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0074.eurprd04.prod.outlook.com
 (2603:10a6:802:2::45) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM4PR11MB8226:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e35bff4-bb77-4483-c1e0-08de1c7dc6dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RUl3cVI3NE9LUUUzam5mYzN3ditBRG9TQ3YzSXh6aWFjMTVMRyt1em5tSGxJ?=
 =?utf-8?B?QThBR2xGU29EbFljenJBTmV2dUs0Q1JjNWNPakZUUGl3UGhsVVpkc1JRNXJC?=
 =?utf-8?B?emFYOFQ2RjQ0eFpsZkpVZ3NtZmdtSW5nWVllcHhNTGJjT09RdTlkWGVJbGhQ?=
 =?utf-8?B?MUUxRjkzNHY1VGtxS3J1WGgzTlYrYkxrVERLR0xtUkY0cDFNckF6VEorT3Az?=
 =?utf-8?B?WlpaSFhCaVdEcDh5SVZqWnozS1VQRnRoU2k1Q3hRNlkxNlZGdUpVMlJEOVNK?=
 =?utf-8?B?d1JnMjNoNHF6eUlrbEdzQ3RwMDRxYmtFb0dLZythKzZnUzQxSTZwYjZraGdq?=
 =?utf-8?B?cUljdmVEcisrcDZsZ1pnZ1d1Sms0bENsSnJQOEhodzZ3dG45N2pwWldBeHdy?=
 =?utf-8?B?NU8rcnZneEM4bnZSVC9hc25zUEhPZnF0dk1IdEZ2NnROaEUrcitWWDNPcjZ3?=
 =?utf-8?B?Wmk4Z3FZajE2Rm1SOFpnSlZ3OUo2elIxb3p0WDNIckdDTFErVk45ZENIT3Z0?=
 =?utf-8?B?ek5BakN4VjZvYUdpU0VDczU5NHZzRldpdWljcXpjUUdLNk9FaHI4Z0FVS3Bj?=
 =?utf-8?B?V0hCMWxwc3ludktmV0h6U0NZNjJINlRPeWQxbUU4SE0vNVJYSGRJWnk5WUtX?=
 =?utf-8?B?YUsvR0ZxUnFxQ1dQZTNBZlVsUXVUYXAvV1JoMEljSHZzWjZFTTZjSS9yaEI4?=
 =?utf-8?B?ckRpUy9nNGs0V0gyakE3RzFLbkZaR09LTWhxWWlMcHZVTjNVcG4ydXhsV1lV?=
 =?utf-8?B?WW5FU1J4T2g5Syt6SE5GOEZPSjNuekRXSGNMVDhSaUxTMWR0b01CT0VXR05x?=
 =?utf-8?B?WE40MmFScUdsVXVTTS8vYkhzTmFDV2xKM3RsM25yaXVOQ01sU2x1U3NzTUd5?=
 =?utf-8?B?MWRHSENtYUR4ajJSb0tBeGhlS1pZTXJBQjIxUmR4b21UN2piWmZOc1dqb1JV?=
 =?utf-8?B?UUs1elBZNzc5ZjdVdHRjby9kSjJ0c2tvUGdxNFhRb01KWWQ0UHFNM2Nwa1Vh?=
 =?utf-8?B?VjloR3RQbHBDbzU3WUJyaFRIYTIzNjBUNERJcTNmUnN3NHNRcUhYY1Fhd0t6?=
 =?utf-8?B?blVWWnlQbHNvb1FFZlRWYVlGNFBLV3hpVHpjZzJqQ0tyNFBUN0tMcnVPVDBq?=
 =?utf-8?B?cklocXFJOE9wR2RIRlV6MzhXUHFnR3V6K1VOYUlkb2ppSVJqU2F0Z1ZmL08z?=
 =?utf-8?B?YUM2QU00b295YjdRakluc29PSENoRVpxN3F6OTJkbjR6TUV0QjMxcVB6UjAw?=
 =?utf-8?B?SzNubmZSUUV5c3dSc1ZLNEk2ZU5mZ3ErRG5Renl0UkhWT1EwNVY2dXBVaWY4?=
 =?utf-8?B?anFpWGVVclJORHpDWUpXRVVJNG1yQkxYMEEwM1JxQ3FQaWNWM3FlNHpHQkhr?=
 =?utf-8?B?UzVoR05JcHIyaE02ais2dDRRT1FwUjJjRVAxSmJ0WStEMnUwdlI4akVjMmdq?=
 =?utf-8?B?WGcvc0Y0TFc4eWF5UktYOEdaK3lwZ0xnaGpUbXQ1VWFFZ2FFNkdaTURyNXE1?=
 =?utf-8?B?OGtDNnY1cFBPMXhGbGVrVlZJVVJDVVdlRUdsUVg2SDBGOEZjb05UVG5nQWxJ?=
 =?utf-8?B?MW1VMGFYT1NQVXdVQ0ZtNnRjN3krNU92S1dyRzFWR3FVUmU0emszQzhaNFZZ?=
 =?utf-8?B?Slh3czNPd2loVnFtQzJTQ2dTSFE2a3F1S0Faclo4a2Jiam4yWU02YzlRUXpo?=
 =?utf-8?B?aUl6NG5JdCtxU2JjcXFCQm9UaHhsSWVoZFFTR0tFZ0VxMktuN1dhVWQ5N2o4?=
 =?utf-8?B?d2RtMy9kNFRQc0R5STJSR2FhUFpEQ2tNTzZlWGE3WVNMREpJR2gvMmNRQm4y?=
 =?utf-8?B?WGxWR0xKTlJTcCs5bjgycUdwT0EyUFBqMCs2clV3YzRyMWJiQkFMZGJyWEFS?=
 =?utf-8?B?a3kyVFM3NXU0S0Z4VHRDby9BK2hQSG1MVlRFTElhOGhQKzUrT2lzME5JdVVq?=
 =?utf-8?B?K0FHS0NyM1ZqZ0pnNys3RUtva1dhNjZhYlJlT2dNMG5iSHRoYWw1UEkwWnZ6?=
 =?utf-8?Q?lCKsdFLi7vXqZAUm4VN16v2NKdQhqw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXpaektTRzVIL0FoUHlYLzgvaHBFWjdhWVNkd09XYjMwOGpzSjZFQmg0Yy9L?=
 =?utf-8?B?WGRVUEl3R2Ezc1NVdzZXZ0dFZWRFSk1zTTJUSVFVODhBbXpHMHQ0V1c5SDBi?=
 =?utf-8?B?clF4U0JXSlhLS0lyNW1hbFVGTzhGTFA2TWRteGUwckEvNHRnN2xQRXVIUldi?=
 =?utf-8?B?bDhoeHVtUURWazZ6OVFKVTdpTEhQOVl5eExqeU5MQU1RSVlkYXFwOWY3ZUxz?=
 =?utf-8?B?bXlCNDJRd2RWVXJVYTRxMmxSS3ZQRjhIbUNNY2tEeEFhb3k2OE1hU1VqREhY?=
 =?utf-8?B?K3ZJVEtqbDlQelltcHI3VllaT2xNWUtMYnFoNmFMb3RrSDRhMWhEUXp2a1VZ?=
 =?utf-8?B?Y0ZuckQzT011WGRYWkExNWFBZ0R0Wm82ZVdlOE8xb0ZvZjB0SkpnMGh4a2xS?=
 =?utf-8?B?ZG9DSW9lbkxDOVhQU0M4bUp2bEdEYTM2UmJTNjlBVDVvKzVmNlAxa0JCOUJ6?=
 =?utf-8?B?UEg4cXB3TkNvQ0hHLzJGejFmMzNCTGVwa2xBUm5DWWU3dTd4MURjYjlaeU9z?=
 =?utf-8?B?RWZKUG5ZRXJYOW5wUkYxdUhZMnFKSFk2SmU1cWxPT3NwUElOaWZSSk5mYjgx?=
 =?utf-8?B?R0xtMGFuSFE2cmc3OVBiVGhkV3pNUVErOVU2d3FCUW5DZFZiV3dva3BuMVBm?=
 =?utf-8?B?c0lpc2FVOU1NRXUycG1SVVZ4OXFIRHAzRkxMR0xNSnVseGZDcW1tM0U5TWhu?=
 =?utf-8?B?Y3FLaGRRMG1uclhmellCWTRKcGhxa2pOZUZ5eG9IMUZ6VHpNblBzZ2Zua2Qw?=
 =?utf-8?B?QkFpRDZVcDkrZk5EclBEdlF3WmxUNTdaMXhtMEJ1WGVGVkZlclY3czBObS9i?=
 =?utf-8?B?WVlOTE1DUUdybDRaaEdHaXVxdmNGSVNkVjFMZmJheXluTW5CVU85UW1JTGRu?=
 =?utf-8?B?SEEvZGZiR3lIK1BzYWhXaGNRRGtGMDA0QlhUTzZ3SW0zUnppa3NQWnB1TGtX?=
 =?utf-8?B?bjBJdGVERld0RlZDcGNzalMzcFFuSDA0RlFvcVN3MlF3Mno1NXcrY0Qrci9w?=
 =?utf-8?B?SmNiS1FkSTQ3QmMxcksvL1lMc1hSN2xTNHJKVlo0VHUydmVsWUxzR0xRVlJN?=
 =?utf-8?B?VDhVTlJsQ0lXczBuUjFidEFjQjluUmc4WmF1NkZGQmJKQjBReVhOcjZNRzZV?=
 =?utf-8?B?b3NrdkFYRDlmb0ZIK2YwUWFRSVhYV28ybmNPMWs1bHp1R3ZqMnlQMjVJQlgx?=
 =?utf-8?B?QnhPbU1tTmROdUhvQTBHRThZV1hDak0ySEs0RmljSnBZTVQyNXk5STJ4T1hB?=
 =?utf-8?B?TFQ4VDhMSWltREdQV0p5cDZscE1qZW8yeTlrZ2JNUFp4bDVaL1VISWpiRS9I?=
 =?utf-8?B?c1RPdmNicFZiTFNJVnNtbFY4OWNsRUZxRWIvaUVkOFZGRmgzVmgxRTU4UHA3?=
 =?utf-8?B?c2lFNGZjanBrSkc5OGZZS2RVdUl1R1dhOFZBNDJpRUdyK2d3Y3RSazM1ZUYx?=
 =?utf-8?B?WXBFOHpDdUpQNG5OMi90MTMrM1Z0WWx4N2M0NmFhaloyQU83ajJMdXNPMXV3?=
 =?utf-8?B?YjNSTVYrVGlQR25jQ1lrM1JyT0FFbzdNYjVyNlBpUHVOVnErS0tBYW44N2pJ?=
 =?utf-8?B?RGVjR2ttTUVLS0tMTnYzMExWaitRMkZMa016M1l2eEhVcjFtQ0pCYUNmSkdJ?=
 =?utf-8?B?UUlFeTRINmo4RkZNWGFZOXVGenhDa0ZMTXZQZFBMdmtoQXF6TlNwV1kvOWJq?=
 =?utf-8?B?R1RkOHdBT0ZsY2VjVnlTT0FPcHJzcmpjcDREODFmVG40ZCtpaitVYU1MYUxW?=
 =?utf-8?B?dlNNeDhoSUwxYjVYTVhCY0lDVzNpQSs4SUxPNldvNXZibDhyRFY5NUdHMnN0?=
 =?utf-8?B?bjRXK2dvTGY2NU1NajU5UTVjbmtBZmt5elYvL3ZLSEtVS1FpNVN2TmFBRlZ6?=
 =?utf-8?B?ZzBuMUhPdStReFlUbkRMOHpja3cwZERVRS9aYndzTllvOUYrOFFRQ2UyTUVk?=
 =?utf-8?B?enpGN2tiS3RuUmRGQVVyQmJJT2hwQVBMdUNGU3czamlFMkh3T0l1bXF6VE5r?=
 =?utf-8?B?NXlaUnJPa21JTHBsSlpGT0REcEt4MG5lVnlqQlo0YUNOQU1EaGk2RFA1NFEr?=
 =?utf-8?B?b1lXaFBjazFYRXdoMmNLRmFqdFdqSXZUTXk3TG9qV2N2aVdZOUFvRGF3QVpI?=
 =?utf-8?B?QnN3U2d3RXlDaDdxUkVaQ2NJaU5wa2FPYTZ4MVVHUU5aV0I4TDRwMURFNUhS?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e35bff4-bb77-4483-c1e0-08de1c7dc6dd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 15:12:46.9165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7rZYEQSLy6Ksq1UqaIwYYwbDon2rWeN8+O6cM/OKbCDhjprO6wXHlxbyqKj3Rw3/aFghD0FnXtzNeA+7uyk5pvGb4URaM9ipTN3pOKT4GZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8226
X-OriginatorOrg: intel.com

VF FLR requires additional processing done by PF driver.
The processing is done after FLR is already finished from PCIe
perspective.
In order to avoid a scenario where migration state transitions while
PF processing is still in progress, additional synchronization
point is needed.
Add a helper that will be used as part of VF driver struct
pci_error_handlers .reset_done() callback.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
---
 drivers/gpu/drm/xe/xe_sriov_pf_control.c | 24 ++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_sriov_pf_control.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_sriov_pf_control.c
index eec218c710278..acaf38026c763 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_control.c
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_control.c
@@ -123,6 +123,30 @@ int xe_sriov_pf_control_reset_vf(struct xe_device *xe, unsigned int vfid)
 	return result;
 }
 
+/**
+ * xe_sriov_pf_control_wait_flr() - Wait for a VF reset (FLR) to complete.
+ * @xe: the &xe_device
+ * @vfid: the VF identifier
+ *
+ * This function is for PF only.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_pf_control_wait_flr(struct xe_device *xe, unsigned int vfid)
+{
+	struct xe_gt *gt;
+	unsigned int id;
+	int result = 0;
+	int err;
+
+	for_each_gt(gt, xe, id) {
+		err = xe_gt_sriov_pf_control_wait_flr(gt, vfid);
+		result = result ? -EUCLEAN : err;
+	}
+
+	return result;
+}
+
 /**
  * xe_sriov_pf_control_sync_flr() - Synchronize a VF FLR between all GTs.
  * @xe: the &xe_device
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_control.h b/drivers/gpu/drm/xe/xe_sriov_pf_control.h
index 30318c1fba34e..ef9f219b21096 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_control.h
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_control.h
@@ -12,6 +12,7 @@ int xe_sriov_pf_control_pause_vf(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_resume_vf(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_stop_vf(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_reset_vf(struct xe_device *xe, unsigned int vfid);
+int xe_sriov_pf_control_wait_flr(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_sync_flr(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_trigger_save_vf(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_finish_save_vf(struct xe_device *xe, unsigned int vfid);
-- 
2.51.2


