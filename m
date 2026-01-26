Return-Path: <kvm+bounces-69175-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANILIk7nd2k9mQEAu9opvQ
	(envelope-from <kvm+bounces-69175-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:14:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C438DE1E
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2241C302D5A0
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 22:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFDA1302176;
	Mon, 26 Jan 2026 22:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PGxZSnU/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3311D2874FA;
	Mon, 26 Jan 2026 22:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769465668; cv=fail; b=Zn10bGTXden1jGen4Ru7BlKTCoN6IrjJ1UXw/ntW6wf11i+aNP2rf767bvtf+oPH1fOK6ubv0643V7KQ2jhQpLjQlWbbtDH7xYZPFFTCmloATBmxVnUuGQfrJsKQ1WjtQS6U+JmBWIg8gRZ1atBLdO0DYtsTJNvMDUr6LvUVmXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769465668; c=relaxed/simple;
	bh=mxtJqlrWT7MZ95A7UpAJ0JRFp17vx7Qyl0xSRCS3LCA=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=Sxtcf8aX3RWi3ckXY2T6suiTsiaDqzocDLLw/5j1ER0RLMAJ35CF5tq7ykX1DlNt8u7ISr065K+7q1dSzNMD8/EtVJmwDVTvictz4f+TQX9tJ+KevzaY5qStGxODTQKE7w2aLDtEI6QtwwCQZdNpvRP6iZPRGHKZrvi3xuISFBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PGxZSnU/; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769465665; x=1801001665;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=mxtJqlrWT7MZ95A7UpAJ0JRFp17vx7Qyl0xSRCS3LCA=;
  b=PGxZSnU/oqK/2E4KBeXjndxGtJJGnrps9GyHnwowFugCQoN1cCgmudc9
   eelkmPRt6CjHV02D+G4X+WjuZdYlD6VoW22pTlFx+QKfZ8yhB+JklpmDu
   nGlz6ZkSPezlU4lGM8/dGlqcRtNUQd/0Rls/zbf0lc/HEAKNXByYtW0aq
   iH8WfChXYeKo/u2dviAtxGC/arv0iUBUqX6GVZs+XBS6Yio9MwByBgGVG
   ilzUMRmTiU6r3IsBetsaJXwwWtzz6eXPc8NvThOMJUt8tJKksYHumBAvo
   LJ2imWbnpGeoTprIZulbRQi/vGWLwaZfwUuIrHnZoAi9J++/jTmsLY3T3
   Q==;
X-CSE-ConnectionGUID: BZAtfP1XRbuSouVVjNyDpQ==
X-CSE-MsgGUID: lPQjuyOrTmeBsPktbfwu0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="81762224"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="81762224"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 14:14:24 -0800
X-CSE-ConnectionGUID: e1HVpXZwRsWlvjhtiUaEYg==
X-CSE-MsgGUID: 5km0IbwERYqjX6OZTl2s+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="208033229"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 14:14:24 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 14:14:23 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 14:14:23 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.49)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 14:14:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FAmAhtC7UpwFza6j1JFoFGiQ/tXx1irA4WcTm9Olhk/cpQktQILS12xdYdUPzaTelaVAnI4mZsIbUwxD82uJWZXbhXX6K6iuM2lmj5EWwlQsby6vj6XiI1WHiXM6txyliKJo9SZG45myZDXtpdyCE180PeBT29R+UdY+pjUH5t5tl9oDw70QvjsWxkg0Hy3MN3WfGwnxU7QvhX1NZiTgOYEjuh/02o8groFlnx59omcJeV2MTeeTFXbeItEfttNzx0JTcqj1WzcLR5bybINwyO9OIHyG0ZNqQXG9eDDWR3czCZUqjsAQNBnE4pgjZg1Je39gvV7g9WnbOe19fCM/qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anV6I8Mhh1eDBwpdFENGTPLnaNK9zkhiEejDa7gL+k4=;
 b=U16iyxWQrnyaIIV3i5FQZrzlZ/4aGAsa1Wp4JG2++NA7yqL9+vayEO5cL1xxOyqeMaoDiNvspAOYI1F12JKbYqPoO/nKe6zZgsfLgUXlBTjHxIsJJGZRGXPX2E6V+CD2fJRZhyhRiT8ngadM07NqJinOnIUXLQ2Tu2M9lwno4RgK93shPPNgW7iUFV0NMKMhM2da7NsekUVb2W9+06WmJeHniAhhep5yaZUDYGhTj5/jGFwsJMYTdMNT1ZFCy4LLm3FgxutAYCHEcfcyQzY/x+Qak+4nk69rm+AG1MjXLfk2/52jZFW+M6B59g+1zQEjrAZy8WElqy6RBD8PcQN3kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH3PPF1618AF7BB.namprd11.prod.outlook.com (2603:10b6:518:1::d0a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 22:14:20 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%6]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 22:14:20 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 26 Jan 2026 14:14:18 -0800
To: Chao Gao <chao.gao@intel.com>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>
CC: <reinette.chatre@intel.com>, <ira.weiny@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>, <sagis@google.com>,
	<vannapurve@google.com>, <paulmck@kernel.org>, <nik.borisov@suse.com>,
	<zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Chao Gao
	<chao.gao@intel.com>
Message-ID: <6977e73a7a121_30951002f@dwillia2-mobl4.notmuch>
In-Reply-To: <20260123145645.90444-27-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-27-chao.gao@intel.com>
Subject: Re: [PATCH v3 26/26] coco/tdx-host: Set and document TDX Module
 update expectations
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH3PPF1618AF7BB:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e1d4b0f-5ff6-4548-233e-08de5d2840af
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MUd3NkVDVWtUTittVXhQZU5OMWFzL0QzVDlxZG5PZFhWUG03bE4vbzB1alk0?=
 =?utf-8?B?dDY5K052d0NVWU55Y0RjbnIwSG9MaWtRMk1VVW9XdGVOOVE2MjJ6VFEwb3hk?=
 =?utf-8?B?a3NVeDFsVWFkQjBrTkVncFRPdVpFL2wrSjkrRXhKM3lQS25XcEtMdldRQ0NB?=
 =?utf-8?B?UExXUTdiRCtEOTZ3VkkydU1neDNMcWgzQnYrUEE1SXFlVFZVbzBlODFqVFZk?=
 =?utf-8?B?VnRqdlhQUzZrQ3BTM0E4Q1ZhVlVuY25WeENtTjdjS3E1c054ZWNuQytkMlJR?=
 =?utf-8?B?dVZiYnlBY0VRVEtJTGdqWEh0S01YREx0Nm9RVk5BYzJ4ejZHTmtMUjhoQktI?=
 =?utf-8?B?d1NNdzR0NTM5WGxwcDlBVVpTaHp6L25PTTJQSUU2WnROZWh5ZEsreFZHdFlJ?=
 =?utf-8?B?ck5FSVE0L081SHdlSTJwcU16M0tuVTNkVUdOV2Y3YUorSHQxMUR6VndCTkJh?=
 =?utf-8?B?aWVzSHlYa3RjdzlDaFZRS1NsRStKNG1hL3dGbnRFZTA4TVZkTjhUeEl1U0Vw?=
 =?utf-8?B?eTVSZXNpSmtaYW0xM3JrMlE2eFFWb3BNOTRpWnVlTXF4WS9jRjl5N0JTNytX?=
 =?utf-8?B?YWgzTEZaeFNCM1dtVzVhcTUvNWZhdjR6aENnV1R0ZDFLL2p6NmpmUHhVNk1D?=
 =?utf-8?B?RkphRmptRlpMalVPVEloemJvM1A4Tlp6S2RJMWxRMk5FU0o3bFovRG1FVi9a?=
 =?utf-8?B?Y3RCd1FyWVJoK1ova2diMElDTlhoVkhQcUFPS0pCT2pxMzRBdVN5M3loS3Aw?=
 =?utf-8?B?dDdDUHZpNC9RRUpleGxkYTJVUVBnVGg2YXJ5Um5odklRZSs2NW5jcFlKU0RF?=
 =?utf-8?B?MEd0ZUU3MWw5L3ZhVk5BUXJDa3JnaVUweHhoYTJlUjRhWitnYnp2eDRqWW1w?=
 =?utf-8?B?TVRQQ1gxb2x1WTJLTXJqOEw5c2Rvc01rRXZDUGxYampKTmdJbHRkZUJKUGxv?=
 =?utf-8?B?aGRTWFc0bzJoQ2ZRbEpnODhvUlhFckR4OUpJSE53bmZ5clR2MzdpSDd3bWFs?=
 =?utf-8?B?U3M0cUw1UGRuSXJvM2pCek4vRmV1TmhIajVCbGlFQTRWTnJVbGdLSlRHTGJr?=
 =?utf-8?B?QXFTaXdjMkxMMGp1RWVjWmM3MTYvZGRwUTVQaWY1bENMNGF2Nlg4VUpJeWlo?=
 =?utf-8?B?bm5yUlBkUnpTUGJoazU4d1o0aGV4T0d2alROQzRBSWxJT2VjN2NxZ2VrdmFQ?=
 =?utf-8?B?R2tLcVlNWStjeC9FMEJwbXZoaXhqV3owYkVXU25wSGViaGJSMTBFdG1ZN0JK?=
 =?utf-8?B?dklJY0FidEg0TTBDekR5cmJ5WHBkdXRsL1dVOTN2L3lWVXdCNEhiQ3BleFY3?=
 =?utf-8?B?ZWVuZ0EvYi81ZGlONFlNMGt2L1hCcEk4ajJRNkhneWJRc1RnbmJTRXVEZzFo?=
 =?utf-8?B?TGowOXpNQ3RhWEpCeG1nS0xLZGdiTEFBNkdtVGZwYnZoL1JBU3dQWXhmOVU4?=
 =?utf-8?B?SDYyeGw4T05objlOdGNUSVlMY3ZqV000WW9QRVUxNkhQT3Fha25STVhnVTBo?=
 =?utf-8?B?RU13SzhPdU1YS1pvRnJHYkowUUUwOE5UdU1vSm0wR04zNEJZbGxPN2lSZDlP?=
 =?utf-8?B?TFlRQ1dGSjVCK1oxNE9VNVEweExadnF1YWhFeTJFRUVHd0pBdy9oUktzVzl1?=
 =?utf-8?B?Mjc2dlluNVJlVTlLcDFuZ1BkOVRCc0xTY0plUlVzcUxZM0xYVW5IRlJjbndz?=
 =?utf-8?B?TlFvNG1yWHFOeWhjd0E0M1JHTWd4Vnd2aytSM3QxVEZpMi90ZzAwWlAyTzhZ?=
 =?utf-8?B?cytyK3hUNWZpczZLT1J4ZGVpQWVnM1d5eE8rVTBIT1p2R0Noc0liTnQ4SW9q?=
 =?utf-8?B?bVE5NG5FR3ZQUVQ0RzJRWlovNFArdUY1QTB4REdUSTNlNk5mSWFpbEl1blU4?=
 =?utf-8?B?VGZlM1Y0a05BOGdWYWN1eEt5WVNwVGNjKzIvR08wVTRyTU5Yb2RmNEkyYUJD?=
 =?utf-8?B?TWtET3o3THA3cUxiZW1jZVR1Qk5EWjZLQVRLQi9tYlhTTmhEZzFGTEpaMDFE?=
 =?utf-8?B?a0JhenRIU1p1YnhmZDFQd3hKdUZtNmREWVNNMlpjZ1BhL3M5OThrZHhQLzZk?=
 =?utf-8?B?R3dlcVVHSHRobGY2WWJWVWRwOS9VM3pvU0JGWjZoYnJIVzMrTFhobkszVS8v?=
 =?utf-8?Q?t20cvgNI95Yj7M2CfI/BR/uEL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elEwMEZEMWhIbUZtSzU0dXM4VjFUK2xMNnFWWUtBUHYwMkJ4eVVFNGlOelN0?=
 =?utf-8?B?V2I2WE9VU2JBdjl1bk1oclBadEJwd2pxblR0UVhnYVl6UmJrQVlvSDRhZnBE?=
 =?utf-8?B?UWo0ZWhyaUt6dzFubjFnVkY2bHJHUHRtclhQSHR3eTZHb2JpQ3hJRi82clc5?=
 =?utf-8?B?ci9wUWNORkNxU0RQeGZRSUxTeWp1QlFwTm14ekp2dGVLd21UUnZ2Y0wyRFpP?=
 =?utf-8?B?VkRsS08yWFl5WUtudmpJc01GbFJnVHZjVlJlaVBkaEhwZGhFRlc0QWpaaVBq?=
 =?utf-8?B?bXV6YzZEZ3M2dWJ2eDFhcStJbjc1VFZybXg2MmpsdGdmMFNKdkNZeVY5RHBT?=
 =?utf-8?B?aGw3bUFaMWdjdFhyaCszWk9uR0hiYmQzZjZxRGtPRi9NMklTQUNNMlU0Y1Q4?=
 =?utf-8?B?bk0rZmdhbmszQmxDYjFEbGF6ODdlWHc3Z3RVUy9oVmVmbDBtY0JVVnI2OUtS?=
 =?utf-8?B?OFl4bE9EQmlBdkxGcmdNa3BHZlhLa3BHcW5hemFGaXlMZDMwc2dUWXhCcjdi?=
 =?utf-8?B?K2lucUFxZG9pVnpuV1ZQUHkyVll4WE9ZNkJZUE0xVFRjWjBYd3haSU4vajYx?=
 =?utf-8?B?dm5nVkNaOVJxMzdLU3g5Q3F5S0F0Zm1lVUllS3VGdHRpSnh5U3FJWHBGazg4?=
 =?utf-8?B?bVNBa0VNRmUrREhRRFF1RXNqby9lMlRpcGNjM0hEZXRtT1o4b2ZkcW9Sd0xD?=
 =?utf-8?B?RDlKOVhrdlFXODgvY3I3N1dFd3FoVnNOM0JoeSsyczRkVEo2N1g1ZXVSMFZs?=
 =?utf-8?B?TExDQU1rVlpBZ01wN2Y5SFh1ZlRlRE5LSVpKUHl6blNoWVJhS3ZaM043V3h5?=
 =?utf-8?B?NGRMMHlwQWd3SE1pRjNQZTVnWkhuekl6NVBnNWt5VDNqNEpCTmpudWxpKzM4?=
 =?utf-8?B?MmhObXl1d3kzcUlDOGs0SmxNdkVzcGVOcDJkL3Vwd3JYalhNcnFFUGx1YW9G?=
 =?utf-8?B?NTAvQUN6MFpQbC9XUWN4THJ2N3IwRTMvWG9OUkFoRkxwbEtsbGNNdDVYMml5?=
 =?utf-8?B?a0RXNHNwYTM2blUrOTVDdnRSRWw2T2N5R0tQSU9xb2krZkx4MFFHcHhUUFJJ?=
 =?utf-8?B?d041NTBOMWFpUGVLRG9pY1hja1Nqb3h2VkF4UmJWci9xYmVjZmtxQTlSTWgw?=
 =?utf-8?B?UVFoTmZadTdRNVRrbXBDNkJ6QmlwcXpMMDRiSDlEL0pmSEVUMEs2Z2Z4V3Mv?=
 =?utf-8?B?V0htV0FHMWlaR3QxWW5uOUYzd2NURWNuYmlSL0tETDBjVVVDcExwYXZzc1U3?=
 =?utf-8?B?WUJCRyt2K0I1WWlXbnV3V3NweEkwaWdXdmVlaGMrREhUM25WSlU0WUplNDVU?=
 =?utf-8?B?S0JEdFJZY09iSjV0KzExWlJRMFhJb3F3QUNpVm9Vc2phK3JOZUdrbkoycDVa?=
 =?utf-8?B?bU9DLzFSOUtKV0RWY1JjbHErYUNXQ29CZS9nenQ2RTN2clFBdFlOVGM3b3RC?=
 =?utf-8?B?T0JQR0I4M2FHay9oZlFiRGRlRHRVeWQ1Q2FSY2RZVWFEdkdRY2tONzU0MDRa?=
 =?utf-8?B?T0pMMEh1d3RCVEFMOGtKckI0Ui80ZFBZVE5lb3djVzl0SEFZLzBUcy9uRWd0?=
 =?utf-8?B?K0NQTDBIRGZjTkVnMHJLa1Ezc1FCU2FDVkZ3Q2NEaUQxZEtDZms2dngySEUv?=
 =?utf-8?B?bjdaWFVaaUplMmNLRGdLSkpzK054YzY2dS9Zc09KU0w4VmZSc0RrZTMyRnM1?=
 =?utf-8?B?YWVRNzlMelhSd2ZlS0lSZStFQWFuVE1USnZpR0x1V0RMZkZ5ZnYwaHhjb0w5?=
 =?utf-8?B?bzRZYmpEVC9sekZEbTNhdFJBekNKRVJPZEk5bE9YQW5iZWowSkxMVUxzdVdJ?=
 =?utf-8?B?ZGYrc3BOclIxcStNN01LZUlKc0NKZS9yc2ptdk1rTDRsbTMwZ0RZYVBmeEMy?=
 =?utf-8?B?WG5VVkRtSWJ2VzhMdkdLRVNjNDFDMW1hRWx0R0wybCs5RC84WC94a3p2ck1q?=
 =?utf-8?B?K0hPTmtpN056UXpZZFpZMFdDWmJHaW1IOGlYbnZ2akY4blZnOVNXbG9YT3p6?=
 =?utf-8?B?MzU5b3lvV3dOV0VBM3k3QU1hUkJYb0ZCZGg5V2U3YmlPMzlKUDB0UC9ZL2dj?=
 =?utf-8?B?NWNPQVlIN1Y1TmIxTTJ0Wk5sazJrR0NVQkdoMFNFR1BNbVZzMWlORG5kUWJs?=
 =?utf-8?B?djdJVW1MZVY3Wi9jMUxjbXJYTktkZW1kc2E5amMzWlVFV2U1dnNWUmROZ2F1?=
 =?utf-8?B?RnNKWEpMQXZOendUU0I3bkpUZ3RmMGZRcUwyblY2UGtjbitoWjBEMUhZL0o4?=
 =?utf-8?B?clIrVzdVellXQXJIMzhKYmE0ejlhd1RqeVFrcEpkbWt6UWhGU3dCaEkrUXEz?=
 =?utf-8?B?RU9JeHV2Zm9WUmVZL0ZzVlluSEExb2pKaCtQODFXcG1FTlRYb1FCVmZWNlda?=
 =?utf-8?Q?OnhF/97YTKYf8wYs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1d4b0f-5ff6-4548-233e-08de5d2840af
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 22:14:20.0282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: queF0vDPDxy1T2GDYs29SaJCP3NbOM+GuyfyBYkJELdpT20TdEFA+dg6Z6tW+GcZ499MHy1ENp+ERvj1ehE463MjhuYFMdLqQwSMLN9Pn9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF1618AF7BB
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,version_select_and_load.py:url,dwillia2-mobl4.notmuch:mid];
	TAGGED_FROM(0.00)[bounces-69175-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: F2C438DE1E
X-Rspamd-Action: no action

Chao Gao wrote:
> In rare cases, TDX Module updates may cause TD management operations to
> fail if they occur during phases of the TD lifecycle that are sensitive
> to update compatibility.

No. The TDX Module wants to be able to claim that some updates are
compatible when they are not. If Linux takes on additional exclusions it
modestly increases the scope of changes that can be included in an
update. It is not possible to claim "rare" if module updates routinely
include that problematic scope.

> But not all combinations of P-SEAMLDR, kernel, and TDX Module have the
> capability to detect and prevent said incompatibilities. Completely
> disabling TDX Module updates on platforms without the capability would
> be overkill, as these incompatibility cases are rare and can be
> addressed by userspace through coordinated scheduling of updates and TD
> management operations.

"Completely disabling" is not the tradeoff. The tradeoff is whether or
not the TDX Module meets Linux compatible update requirements or not.

> To set clear expectations for TDX Module updates, expose the capability
> to detect and prevent these incompatibility cases via sysfs and
> document the compatibility criteria and indications when those criteria
> are violated.

Linux derives no benefit from a "compat_capable" kernel ABI. Yes, the
internals must export the error condition on collision. I am not
debating that nor revisiting the decision of pre-update-fail, vs
post-collision-notify. However, if the module violates the Linux
expectations that is the module's issue to document or preclude. The
fact that the compatibility contract is ambiguous to the kernel is a
feature. It puts the onus squarely on module updates to be documented
(or tools updated to understand) as meeting or violating Linux
compatibility expectations.

> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
> v3:
>  - new, based on a reference patch from Dan Williams

One of the details that is missing is the protocol (module documentation
or tooling) to determine ahead of time if an update is compatible. That
obviates the need for "compat_capable" ABI which serves no long term
purpose. Specifically, the expectation is "run non-compatible updates at
your own operational risk".

So, remove "compat_capable" ABI. Amend the "error" ABI documentation
with the details for avoiding failures and the risk of running updates
on configurations that support update but not collision avoidance.

> ---
>  .../ABI/testing/sysfs-devices-faux-tdx-host   | 45 +++++++++++++++++++
>  drivers/virt/coco/tdx-host/tdx-host.c         | 13 ++++++
>  2 files changed, 58 insertions(+)
[..]
> 
> +What:		/sys/devices/faux/tdx_host/firmware/seamldr_upload/error
> +Contact:	linux-coco@lists.linux.dev
> +Description:	(RO) See Documentation/ABI/testing/sysfs-class-firmware for
> +		baseline expectations for this file. Updates that fail
> +		compatibility checks end with the "device-busy" error in the
> +		<STATUS>:<ERROR> format of this attribute. When this is
> +		signalled current TDs and the current TDX Module stay running.

This wants something like
---
See version_select_and_load.py [1] documentation for how to detect
compatible updates and whether the current platform components catch
errors or let them leak and cause potential TD attestation failures.

[1]: https://github.com/intel/confidential-computing.tdx.tdx-module.binaries/blob/main/version_select_and_load.py
---

...although I do not immediately see any help text or Documentation for
that tool.

