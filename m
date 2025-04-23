Return-Path: <kvm+bounces-43872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 211FEA97E1E
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 07:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51E2517BBA6
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 05:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7784926657E;
	Wed, 23 Apr 2025 05:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kqRWD1Eo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A452581;
	Wed, 23 Apr 2025 05:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745386643; cv=fail; b=idie2HttGCu1SpNnJiarBgI+2/40ax8R+ArhZJCh0DhIsueOzZuw8f8GcnjZDhyVrRmLpRXaD1VyMdX5FxeN31ceK0t7pi53k9MPTmydgFhKfcxbRjJqZsqIuU3vN4hrBYhRnl0ovKTM1QLQKRrMz2RV8c1OMYeU1I6aax4pSXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745386643; c=relaxed/simple;
	bh=mwGUR78SQ+gK2GAi0iFlkLs6WPB/iXl26vKqjvjVA7o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WUpReN4zgxhPm8qIaMwAS++pQjyEyxGC5UIq/cpIMQZD98JHLWqN/UlY7P5fjztvD7AYBpVOwfsUdoxUqvYSLI7bXlaWXga2CGPPaHVEL7iSuZg2tiONHtwJWRZ/jMbc5ULwDiM5UTkNf/JAHRWa0AjbI5BG0V0TMdl+B09PQsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kqRWD1Eo; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745386642; x=1776922642;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=mwGUR78SQ+gK2GAi0iFlkLs6WPB/iXl26vKqjvjVA7o=;
  b=kqRWD1Eozfl1/XLkmCrN+aydEf0LCclCeGgZFnF899mco2CREd1HywG6
   fJRRqKQnqeDrkVBsQtkNCSI36T2qtfYqd0nGXivLPsmvwuPzTJX61ByYK
   gm2jN+bRCpk40OwAOx5A3E9FK+8bCsTsgXz7aJ+i2mwoYdFKqIBpDi+QZ
   8NKpi4s4fXvKfr3t+1U9OugFMda9zcklkYGhcdz1Fr9FWVPRBAOl/l+xg
   G4vTjunYg/4MIo2F/Jg3st7ULeymvjYxWhY6c7LA1PIcp2BiWjqM3t2sf
   Q3FF1+NPOr8IUv+LlQnyBP4VlVjR1cXjAunFMTDmZJcFOqUX0ImDhwSNa
   Q==;
X-CSE-ConnectionGUID: vl91/ZZISR6GtOrMpP40zQ==
X-CSE-MsgGUID: 20mr3wTQR02SZYP04sQbcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="46843512"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="46843512"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 22:37:21 -0700
X-CSE-ConnectionGUID: 3iRzmXTKSLO3/cQpczB2WQ==
X-CSE-MsgGUID: JwpfVQigQZ+4e1+wK5otkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="133160152"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 22:37:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 22:37:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 22:37:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 22:37:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3Y4QzTCLTv4RzAspSPh6iie9Y9R9JeXn8J0c6AoZrAg4Jux7O86UPqem9DMWnOrSK9bcJbzrdP2pwxJ1JW1DHo+vbFSTZ4OxAqPZWZ4/sAdn5GFMexsvUaWSpG6O0m6adA2VHIbmos3O7TtpoQgfCHTHpYmLp/ZUNV+wzZLgEZiKFa8VACnx3HJGXzZ9Bcdc6kWvHgyrUuBtltje6I14bABvLNwvIPRWJ5cPvJFfGSxGKZhY10XKa+VwBO5KAEN6zIZG3nAjf9pe7Z+iPeYEitgQLDGL220qdg927wg483Udp80aPgxtp+L5tvUl9DOi8jawOxA6tLo3oXXx4tjjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9zh8AUvVxfTF2goEMd/U2Qk2vok16ssDUMJC8F/xW4=;
 b=ZBRNVJrpD3Z7J5/TFski0JLkxwvz0D4sftBoFOxNHWz08AZSTAH/66ZexEh09RmLu88GNhjwr3tDZ13ye3sXwqfS7iOuQPJ8e0AF3xc1QxBY6Reh4O3Ku9ytdUv46ZkpRnnUX385DMfWw+TXmGaCgGx5NB9xH9z0MpG5wx/kXG+SZC4X92+bd5LDMk7puiMC4JSrCGnYvqLTth4mv6mx5BhKZC6xPyQfCH/qwgLfpd+UfsPXeKhlGukKgmLgF4qAXGq3pRIAosrFZ9YHwdKfOrvjhpY3x3HvWri8xbqB3+jLyaBuuQ8y09M6vHekhuU+N87vDleoH+devncUNNPyrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 DS4PPF641CF4859.namprd11.prod.outlook.com (2603:10b6:f:fc02::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Wed, 23 Apr
 2025 05:37:18 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%5]) with mapi id 15.20.8678.021; Wed, 23 Apr 2025
 05:37:18 +0000
Date: Wed, 23 Apr 2025 13:37:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jon Kohler <jon@nutanix.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 13/18] KVM: x86/mmu: Adjust SPTE_MMIO_ALLOWED_MASK to
 understand MBEC
Message-ID: <aAh8fD8pyxEIiBU0@intel.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-14-jon@nutanix.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250313203702.575156-14-jon@nutanix.com>
X-ClientProxiedBy: KU1PR03CA0023.apcprd03.prod.outlook.com
 (2603:1096:802:18::35) To LV8PR11MB8680.namprd11.prod.outlook.com
 (2603:10b6:408:208::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|DS4PPF641CF4859:EE_
X-MS-Office365-Filtering-Correlation-Id: ca5d8b22-ec0d-4b79-c906-08dd8228e8d5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YmJnemkzWTlFSzV1a1ltUU1WNm5sWUdIZ2pxK3ZLM0ZDaFlncG9ZSGJRL2N1?=
 =?utf-8?B?WWIvV3oyVzBpMGt5OTgxSDYraW5pT00xQ0xyaUJXektFRHVta2ZmNEF4Sldw?=
 =?utf-8?B?eldXak05MnFnQkVHT0NDRUMvMDh1L1J1OEhMUlNqdmhudFpZbTdSR1JOMEww?=
 =?utf-8?B?RDFocXRLWEtCN1V0VVBBVDZTVUJ5WUFNeS9iWC9tbStPNzU5UEdEWDlKNDFP?=
 =?utf-8?B?ci9ieWVBQVFnMEduNlllZzZma0xmeVZhMmswWVgxKzM0RkcvUnM1KzBGa29O?=
 =?utf-8?B?QUtpckdqVUlWVnVWc2tEVHQrdC9IbThydkExQlp5L1Q3dWtlMm1TenFJTm5a?=
 =?utf-8?B?MktlcE40MitZQThINk14K0t0bjBaR0d4OXNRTjJNR1JycjZTZDZOWllieG1Q?=
 =?utf-8?B?MXlycU8vWU5XNS9CZkpXeXhZN3dLQU1LZ0diYzlSQks3NWNaSzV6UjRyR2VJ?=
 =?utf-8?B?Wkx2bU5lWVJrMDV1ZEFuZ25JTzE4b2N4dFA4cGFiY3k4UktqMms4eTJlK2JK?=
 =?utf-8?B?WVVrR0JnNkdJNlRxcTVYZm43cE1lYXBoMUVjbFZ6TWszTEJWYnZhYU5FWVRZ?=
 =?utf-8?B?cC9EY3BjSzRWRWhpWXNuK0ZLK2Rnc0hxTFB1ZUROUDdqMnRVYXpiMnFxS25G?=
 =?utf-8?B?OEw0aFJiUExDek9KTGdvd2hoMDJYYk5YZlJZN0E3SVp6Mm1aem9aNWFMVENo?=
 =?utf-8?B?VnZCb3lIemNTc2Q5SEw5SVkxRG9BUmZIUWc1b0ZacjhzaVFHM2pMRG50ZFlY?=
 =?utf-8?B?MXZWeGNQWTFwVk11cHpZVVQ5SUQrOXd3cnIxSUtIRUlvbG1jakkzd3JmTFYv?=
 =?utf-8?B?bkxKMFhQaTYxNHY3MlhPZjY5OVpVUkRtM2txMHJLN3pabTY2S2dwd282Ymc2?=
 =?utf-8?B?aVpQYkFiMFVnLzVQT0tIeklZQ1VnWTBpRHNoNlZva2RqVWl0R1ZNMUtxaXp6?=
 =?utf-8?B?dXNjeEloOG1UY0ZWdzg5U3dIVmJvd2F4cnNwN09oOUIzUW94d1JiZVFUUGVD?=
 =?utf-8?B?MkltbUk3Sk1LMmJLREJxblg1eHk2OW1XemxHczk5VHZWaE5IM21BWGEwdVFK?=
 =?utf-8?B?enR3WUJqRGs0eUdQSU5rSjVKSmhUWjVqeU0zOENrdG9INkdnNUJ3ZlFUay9V?=
 =?utf-8?B?U1VjdDhNeEJHcHhSY1p5VG04aVhVSTQ1TVBFekJMQithT0pRSGdnV2JmMWh4?=
 =?utf-8?B?a0NONlM3ZnM2blFJYnNwMmNMMlM3K0c1SGh1Zkg5dWpxbUNiT3I1U1lKZHRy?=
 =?utf-8?B?bnJOMHhFeHh4Snl5Ym5rSERUN0ZuLzd5U1RIN1VUODVVcU5KaTVmS3F5cG40?=
 =?utf-8?B?QmlZbCtyV2VJMmJ3a24wNjBkMk15M2RLV0tuaDdoWmIwZHNLNVR6TmZxdDdD?=
 =?utf-8?B?QzdDeGdrVldiSUJVNDhneno0ZFVGajYzVHpkVUNYMTNWZk5JVlBJNHZqVmhX?=
 =?utf-8?B?Rk5wTG41bUpoaWJRdHJWNTFsaUhmc2x2akRULzliUk5oN1Nja1dXNTR5dzRL?=
 =?utf-8?B?SWxrUXlienJMbU92dEZ1VVVyYzdGUlozZzVISFo1MHY5SGk2SmpQM3BaSWRw?=
 =?utf-8?B?SVJ3U2l0bGNYWWh3VVJTVDhHOHVpUEZIRE9JYnI5VVF2Q3FZbVVwWlMydnRs?=
 =?utf-8?B?TnRBd1BNNHdVMmZSZjM4QjBYUWtYN1BoaS8rMzJIdHpLcW5YWDg0UVVyTEYx?=
 =?utf-8?B?aUkwbVV4a0xGd0VOdnduMysvNmZrVzd3MG45MnNadnMvY0IyclZ0d1B2TWRx?=
 =?utf-8?B?WlZORzFXK1dSSEFSTGp1S0dCTjg0cE5jWnQrOVVrNHpzcVkrQ0h0bEhWZFJ2?=
 =?utf-8?B?UEtEVWd3RjZodUZSSkdveTRIWFhMYVRnbXpNN2NVWThxY2Ryang5eUlBa3p2?=
 =?utf-8?B?NTE5WHpWRE5sdGh4L3FKOG10UXhiZUhNN0hWYkJZWUdPWHc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkhjVWo2cXY5TTZpajAxQTg3Y1BiSEttbi9TU045ZGN0RHBMOUU2c2ZmWDRn?=
 =?utf-8?B?WkQzM3I5ZkQrV2l4WkUyU3RZeTJQdzBwQUFsZUdpN0puTFJrTFIzbWoxMCt6?=
 =?utf-8?B?b2RPR2FRVjFaYmgwbHpkRGl3L2ZtZWpUMGtVcjlJaXBLVGpoSitRUVk5ZHhy?=
 =?utf-8?B?Vk82NUtPUXk3Qll6OC9RR2g3U0wzS0RxSHIyOEg0b3NRM0U3VFpQOVV6Z0Va?=
 =?utf-8?B?cTlWbHZHaEcwQzg4NWdWZ081M1BId2o1bGRuTjFzRlJSSVdVem1jT1ZQaGZF?=
 =?utf-8?B?VUF3UDE2bmNBV0lsd3J5aGI2aG03M1BTdW9BSUV2UXp0RURuQitQZHIzanc5?=
 =?utf-8?B?SEFyOFFlQlUrbm1vdzNKUkRRa2Y0T1FBUTRXbjVPVWl6Z2VBSjdkbGZENjFo?=
 =?utf-8?B?U3JKdGZkNUZmYzJzeEZ6ZzdwT0VZNWpVYmcwalh5NWNaaVhaalRwQXk1dDlD?=
 =?utf-8?B?SGxTR1N0aWw5aHUzZjM2N1h0TU9KeE1XTWFkN2VDL2RUNm9jN2VNQURmV1Vv?=
 =?utf-8?B?ZTZpVldkYVJyM0NGamZ1MWpBK1krTkovNlZaQVZiY29wU3NqenpUODVwYndX?=
 =?utf-8?B?ejMyS3M2Ri9BWHJKb3RYREsxL2o3MDkxRkZUL3lCM0YrYkd0OVdZSHlCZjJL?=
 =?utf-8?B?b2xLQlZKOURpUkM0eFRoaUtmaFA1K2NwQkNJWTBQOElHVzRCZFEzdGI5MEtu?=
 =?utf-8?B?TDBUbGwzd3FQeG1rNUc3VzV3NjFvYzNhQ0w1SVNIZzVVdnowQ0FUM2h1R3lt?=
 =?utf-8?B?aGhsaXUwcUJZYTdrRGM2WXQ2Y0JON0lEbmlLcktYbW1wY3BKMy9CNUUvVGxu?=
 =?utf-8?B?VjI1aGxMY2hpcHBZOThkNGJaem1JRGR3WnBuUk95VU13dWxwa0NyNGdGb0oy?=
 =?utf-8?B?dGgyRDdzL0hOZjU3eEJiR2t4NUt1TWJjM3NqMi9ObkRyME93cTgxSFd3cU92?=
 =?utf-8?B?Q2M2K24zL3RqY2xvcUhKcXgwT0d1NDV2QjJIZVNRYjFGbTRMQ3VIYUtpaHNu?=
 =?utf-8?B?L0wveURSS0lsSlpmNUdmcFhsT1VFRWlZTExSRUI3Z3lUOHJRaVl5MzNpNHlr?=
 =?utf-8?B?RHVOTTFvNTc4UFhYeC9xSk5zMFV0ekZIRGNtbzE4VXJZaCtVLzZTZzNWY2Vv?=
 =?utf-8?B?OWNRaVRWNnZkTzVoU1R4MXkyS1JPZUJJcXNxSDJhTWI3VVdhSFNFWWpDM1Zk?=
 =?utf-8?B?cVd5QWl0dDNjaks3MFcvV2Z3d3lBZjNpeHV6K2NNSWRtV2dSM0lVNlQzLzNC?=
 =?utf-8?B?WVBBUDMxSStyZTVEZmRVTHJ1OTMyN3E1NUVWdUI4VUpCbXdoeDFYL3V4eXZZ?=
 =?utf-8?B?OWVXNG53MWxPOFVkQUk4RWgxSlovNlhvY3BTbUgydWgrMzN5MFRFYUd3cTNX?=
 =?utf-8?B?a1NaUmUyMDVmKy94NUxmbzkzZlg0T2dhb3AyZ2pJRGpvdE0ybHFRVmNpSmhw?=
 =?utf-8?B?M0taUTQ2NzZaWDRFZU5tS1l5YnFBRmZVKzAwdDIrR2w0QjBxRGNKdXRJVDJw?=
 =?utf-8?B?MmRVMndXRTlNMmIrRk4zWW50S3lWbnpuMUNWVFNHY1haYkxDaCtHOEswYVZp?=
 =?utf-8?B?Mmh2S1puK2JPRm9JWEcvMU4vVjQ0UFRURWZwUTQ4akh5YlFxTUF5Y1ZUMzlq?=
 =?utf-8?B?OTRNOEg5cGR3OWpGVUQ4MWtHSlJsVnZ2TDRwNG95M3p6SVZUNXI2YjBYVTM0?=
 =?utf-8?B?VHhibXp5MmNjcXRUQ3dIcU5xSi9hWEpqOStwOEVGTm44K083d2dJdElVNDl3?=
 =?utf-8?B?Sm5NeDMxSUM1Z2xvQWhDTUUyQmx0ZktoVW9iYlNHRU52Q1l5a0FmMml2WlNl?=
 =?utf-8?B?VDdVVHJiQzZiaENoc01sK3dxOWk5ZW9kelBaNUxmd0c5SlpGOENQRmlVUThG?=
 =?utf-8?B?NUk1dktFbG5NTW9XeGVXNVgwUGVqQ0R6L2N0NThHWXB4Y3lhYUhWaWEzcnhZ?=
 =?utf-8?B?Q1E3czR4UjYvcjdmZzFVVWwydm9ESGJjZ2l6cWpNaHMyalpjdWtaZSt4WXZq?=
 =?utf-8?B?TXJPL3Q4M29lcHkySXFRY2Q2R3ZleGZkNFNHbzJYWDBmZ2FPRWpFUjBPdGls?=
 =?utf-8?B?MzhBSjZZOFlhbTFCOHlHeDhKWjNqZkJZVFVOSDcxTUdhdEdKK2toMitKbFc1?=
 =?utf-8?Q?KxqC+Gf5gCaxugfI+pQDbCE+N?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5d8b22-ec0d-4b79-c906-08dd8228e8d5
X-MS-Exchange-CrossTenant-AuthSource: LV8PR11MB8680.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 05:37:18.3421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AX4+n+fzXdgTPRtuATmSfLsKGPJkAbJqQNJyPu4jxhgkHss2joKrkz2S6tEjrSdi3QE+fii7to3uuE0vVxyD0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF641CF4859
X-OriginatorOrg: intel.com

On Thu, Mar 13, 2025 at 01:36:52PM -0700, Jon Kohler wrote:
>Adjust the SPTE_MMIO_ALLOWED_MASK and associated values to make these
>masks aware of PTE Bit 10, to be used by Intel MBEC.
>
>Intel SDM 30.3.3.1 EPT Misconfigurations states:
>  An EPT misconfiguration occurs if translation of a guest-physical
>  address encounters an EPT paging-structure entry that meets any of
>  the following conditions:
>   - Bit 0 of the entry is clear (indicating that data reads are not
>     allowed) and any of the following hold:
>     — Bit 1 is set (indicating that data writes are allowed).
>     — The processor does not support execute-only translations and
>       either of the following hold:
>       - Bit 2 is set (indicating that instruction fetches are allowed)
>         Note: If the “mode-based execute control for EPT” VM-execution
>         control is 1, setting bit 2 indicates that instruction fetches
>         are allowed from supervisor-mode linear addresses.
>       - The “mode-based execute control for EPT” VM-execution control
>         is 1 and bit 10 is set (indicating that instruction fetches
>         are allowed from user-mode linear addresses).
>
>For LKML Review:
>SDM 30.3.3.1 also states that "Software should read the VMX capability
>MSR IA32_VMX_EPT_VPID_CAP to determine whether execute-only
>translations are supported (see Appendix A.10)." A.10 indicates that
>this is specified by bit 0; if bit 0 is 1, then the processor supports
>execute-only transactions by EPT.
>
>Searching around a bit, it looks like this bit is checked by
>vmx/capabilities.h:cpu_has_vmx_ept_execute_only(), which is used only
>in kvm/vmx/vmx.c:vmx_hardware_setup(), passed as the has_exec_only
>argument to kvm_mmu_set_ept_masks(), which uses it to set
>shadow_present_mask.
>
>I'm not sure if this actually matters for this change(?), but thought
>it was at least worth surfacing for others to consider.

KVM needs to emulate the hardware behavior when walking guest EPT to report
EPT misconfigurations/violations accurately. IMO, below functions should be
modified:

FNAME(is_present_gpte)
FNAME(is_bad_mt_xwr)

>
>Signed-off-by: Jon Kohler <jon@nutanix.com>
>
>---
> arch/x86/include/asm/vmx.h |  6 ++++--
> arch/x86/kvm/mmu/spte.h    | 13 +++++++------
> 2 files changed, 11 insertions(+), 8 deletions(-)
>
>diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>index 84c5be416f5c..961d37e108b5 100644
>--- a/arch/x86/include/asm/vmx.h
>+++ b/arch/x86/include/asm/vmx.h
>@@ -541,7 +541,8 @@ enum vmcs_field {
> #define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
> #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
> 						 VMX_EPT_WRITABLE_MASK |       \
>-						 VMX_EPT_EXECUTABLE_MASK)
>+						 VMX_EPT_EXECUTABLE_MASK |     \
>+						 VMX_EPT_USER_EXECUTABLE_MASK)
> #define VMX_EPT_MT_MASK				(7ull << VMX_EPT_MT_EPTE_SHIFT)
> 
> static inline u8 vmx_eptp_page_walk_level(u64 eptp)
>@@ -558,7 +559,8 @@ static inline u8 vmx_eptp_page_walk_level(u64 eptp)
> 
> /* The mask to use to trigger an EPT Misconfiguration in order to track MMIO */
> #define VMX_EPT_MISCONFIG_WX_VALUE		(VMX_EPT_WRITABLE_MASK |       \
>-						 VMX_EPT_EXECUTABLE_MASK)
>+						 VMX_EPT_EXECUTABLE_MASK |     \
>+						 VMX_EPT_USER_EXECUTABLE_MASK)

This change is not needed. whether MEBC is enabled doesn't make
VMX_EPT_WRITABLE_MASK | VMX_EPT_EXECUTABLE_MASK a valid entry for EPT.

