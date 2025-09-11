Return-Path: <kvm+bounces-57336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 648A3B53934
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AC30585430
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB7E535A290;
	Thu, 11 Sep 2025 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z52mR7SW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4673A35AAAF;
	Thu, 11 Sep 2025 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757607854; cv=fail; b=Namk4OVJYpDI5eN5QPEC6+8m5yZ2SE1b87XKfTIfMe7gBEOcZRxYGw7HoWkuju+JOR0GGLEKVhvCp5nmYCt9pS403lFxwV3W/ZiUnEzk53YzpGg62lFc7KACrwi3znsZSSBVkBedOFrBjRHHSx2QT36dp1Lh0HG3o+XcuPXFroQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757607854; c=relaxed/simple;
	bh=EbUoboJCLXN5xNfLzWb5V+MPtoqzIwyY7ASdU6L0UyM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GODdUK9lqS7v/eOew9ApzzVqHWti/K/YQ4jpEEzPiBkUtUOO3JZzKPxocUxfoxeF5dwwMWyXcKkHJCZBYK4rX/6cv5iD+FOXyP7+mQbHe0s7Sfb6s49CfGtZ7ennhVZhBDBt8nOXw1VSiu7PsqKrZEh5JoMeydBLRTbS1/8bo8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z52mR7SW; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757607853; x=1789143853;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EbUoboJCLXN5xNfLzWb5V+MPtoqzIwyY7ASdU6L0UyM=;
  b=Z52mR7SWNxeU8azkksV+u2njJcDuNJNEPOfDttxn7DxlrICdJih1aup7
   oFbnev3o0+XAtFCRWBiMlfm6R8NHhQq4eyFlvZdYwEM/RdGYfyPxmabfd
   3d7f8OvYUqr1JDZJ1ltJd+stvB9HXxUBZ93t1M//tq1xB52bB/inSGomJ
   EUIZ6pcQx5ZgpUuYaGCMycCOAeXrafE44r85ljd9D4O6oaMke2xbklGhQ
   g9lV/XwJYJ82HJqbX3VblSZCopApUZqWCZ64XSRDTl2pgy3GonG+ND9dS
   QgmzKdmL0jmumtQqqYmCp0mmQM0COJ/J5hYv7L/tuPyZk5ynqjxuE9E9v
   A==;
X-CSE-ConnectionGUID: FmGLdI/+SPGuVOJ/4IT0RQ==
X-CSE-MsgGUID: Ks+gMTcoQEWNs8BbuD5KJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="59883216"
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="59883216"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 09:24:12 -0700
X-CSE-ConnectionGUID: MJR1J1CwQjC1mzQFBlFXHQ==
X-CSE-MsgGUID: Ux+ruywCRZO6JdusG+06Xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="197415807"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 09:24:10 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 09:24:09 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 11 Sep 2025 09:24:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.80)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 09:24:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CAnsWs3pEbd9eJlF+MKdj0u2rN0aSIyrKU7p2jMqXxUfGZZgkJJhkmfqfpUAUjsrnu5wfwuqTdmUAnXBVFLTrq1vnk97qfVE6QPv0f5awg4wGZcDqDwBPNcwNQAKq27Hvei4kUnGOfvkrdH4XKBuZkxgOZlav8F2VtKd3WmAOEJMxUAeAykl7Hy9CFzrQQH93TiOAjWNKHZPm5PDq2OyVKVYlBbm9L2TC7rfbBIDJ1RBxQdZgWUtBBmBKgxSm7NXkQOzPn/ohjtZCm5sJ+4WGlxgMsyaX4e58kbJpvY13K3UrtQyLfUV/O0K24fYN5tPa6IUZTkW66BwJoJfsHnxDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2F0iY2DNRj3HAr6WG+FZxTjlr8LH1I49eifO4DR0lc=;
 b=pReyxijAhgGXHSftsBPnhrL3+t7htjt/+zGt6pmXnWEReUJOO0GTyFRVFaDG1aCAai+nrcwxEAXoFUJ2kvtiDK2VzG4lr0tAhQ6+abEpxb5UES876NtNm+Jmno+D+LIvQvkQCKl9n21B/8fK44ocOfEpWBHb3s68xAaqicEzTrmRK0eMrH7mslTOr1AOQgnca0kSJqd9IggRA5fOGDqDrQFJIJMY5yUJajuBhV39CyB61MwDMJrPb8RDcuthgzOeRuQoGHFZJ6zaFe3/PRVBCpegTk8GHaK+WEUHboRq9CtiM9SGfSxiMPjsc8+3TxwY8Lz2uoULd0CYpWKgqNAlVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW5PR11MB5786.namprd11.prod.outlook.com (2603:10b6:303:191::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:24:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:24:04 +0000
Message-ID: <0bacc30d-0e0d-45da-ab13-dca971f27e2c@intel.com>
Date: Thu, 11 Sep 2025 09:24:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 26/33] fs/resctrl: Introduce mbm_assign_on_mkdir to
 enable assignments on mkdir
To: Borislav Petkov <bp@alien8.de>, Babu Moger <babu.moger@amd.com>
CC: <corbet@lwn.net>, <tony.luck@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<kas@kernel.org>, <rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
 <3b73498a18ddd94b0c6ab5568a23ec42b62af52a.1757108044.git.babu.moger@amd.com>
 <20250911150850.GAaMLmAoi5fTIznQzY@fat_crate.local>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250911150850.GAaMLmAoi5fTIznQzY@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0333.namprd03.prod.outlook.com
 (2603:10b6:303:dc::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW5PR11MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: b18374d1-4f8f-4b79-dace-08ddf14f9fef
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WU1Kem05OHRFVFhXRExJSko2T2RvR1hzNm1BMXFrVGpzaFFSSkM2WEZFUDJj?=
 =?utf-8?B?MHpYWlZwS24zc1h2bHlkSFEwTkMxS0E5U1k3MWZIYzZrR3dacmtJc2hjZUZQ?=
 =?utf-8?B?dTF2c2JTT1p2aDhhUEhrMnRBNXpFUUI2UjNtYm9NYjA3by9QckxwaEZiRkRP?=
 =?utf-8?B?c05GS1JudzBuUHdrTExoaTVKRzFVbEpWZDJ6N0hZOW11eGVZRXIydHRzQ0wy?=
 =?utf-8?B?S0VyV0RYZGpwL21oYk9UYllHMWRzQUxEbWVTUkZVdU1velJYc1RGU3Q1R0hW?=
 =?utf-8?B?UFZQZXJwSGpkSmlxMTJ0Yi95dnA4K3VVeS80NTl4ekJab1VJdW11dnMzSTlE?=
 =?utf-8?B?VkpPS0Y3YUJtWUlBZytFUDhEMjlJbkYvSmhRbjhvUlRFMjJsZXpiek0rNk5h?=
 =?utf-8?B?d3dIajBqZ2FaVldOeE9mcnVkMzlWQnJWM3liSFVQN3o1RkNuNEI4V1ZVVFkz?=
 =?utf-8?B?VTVwUlpFSlBBZVVqTGJSL0tBL21QYis5ang4U3Rmanh3MDN1dHhxY2pWY2w5?=
 =?utf-8?B?aDBycW1CcXZyQU5nZFptYnpEdnFDOUhHY3NENzdTaXViOVpTSTVxYm1FNGZw?=
 =?utf-8?B?amxTeWhUVHY4dnNYWFhPWTNKMnFpeWhHc2xuTUhNRFkrSHg4MEZpVTU1MDdv?=
 =?utf-8?B?Wk9XQXdRNW5nUEdhTE95ZnludnFnZmlrSURHYk9icVNZbzE4dk56aUNwN3Ru?=
 =?utf-8?B?N1hoU3ZXNXhtekl2bXV1UGNZcFkzWHdqYjlMUFRqMU5XaGhZRVpXYTk1dUVP?=
 =?utf-8?B?bHdnU1lseFZUQUpaTTF4NGVBaXZ1bnZYOUVJWTBzcWs2Q0l1UmlaeEFsZEhX?=
 =?utf-8?B?SlI3U2p1WjlGVUxaUlFhOGZlMnRIRG15b2E0d0pvNlBaTll1YlhGYnBybmF6?=
 =?utf-8?B?Rkkwc3ZPQ1ZEbCtUMFlaVVR1MENjVEp0ZFVrNnNpR0xydklLZXFhSkZTcnph?=
 =?utf-8?B?QW4rN1JVdkhwZnJqM2ltbGNiWGppdFhiRUpoWFV4MEhrU2V5SzkxbTZZeE9j?=
 =?utf-8?B?S3VZSTZ2dDE4cEtUUmRnZHBDNXF2SnhFaXJRcFJvZEh0ejFqeE9pNnM2cWZo?=
 =?utf-8?B?bDlpVjVqV3BxWTNVTE93cnNndUdISTJiUzVjbnNaZDdTc0NBUWYrTXZuNFhW?=
 =?utf-8?B?bFpucjRJWFl4eDRXVGtuaFI3VjVuMzhnUGJxbHBVWFhFZlB6eUl0VnFGMGxD?=
 =?utf-8?B?K1RqWlcwZ3k5LzdKcTV6TDdxUnVJbWtrbVd2V1UzdDFvOU1laCs1THlDKzlE?=
 =?utf-8?B?ODhtdElmYWpXOFpodGJ3aGduL1dLWE9GZjNvajJZcEJUb2l2bVJTajNEbHFw?=
 =?utf-8?B?WEh1a0MweHhFbFVzNUVubnkxZVJuOTVnTnA3WFB2aXBIS1RVdU1aR1lxc3hN?=
 =?utf-8?B?ZTlycXVyRzdobzkreTFLeC9MS1BvUnJLY3E2c25MOVBCSzNUSTh5ZFFhQ3Uy?=
 =?utf-8?B?RUxxUC9tY3dpSFJDRVplMTdQSTBEZDFqS1ozQ1hoeUNaOHlmek9veS9uWXlJ?=
 =?utf-8?B?SFRRYmJMWnFVYTJmVk1semdIWXNROUVZQjRnV2k0YUdNQVg3YjhIcmhJOUlF?=
 =?utf-8?B?TFkrTlpjZHFJM1hwak9aWHNxaG8wb0YzQUYvV04yVm0wWk5GZ0EvOHFVS1E2?=
 =?utf-8?B?bnFIUVlYVzR6YUN6dk9PblhvV2piRkRGUDRCbVY0TzRGSU45bTVvUFJmaGFM?=
 =?utf-8?B?RTNKVEYxQUR6MjVnT25hUFZiUmFnUzE0NUU2NG5SVGtJcVNGRmtBTFlkSlFw?=
 =?utf-8?B?QkdGQk1xL25mOFpwQWhOZkovbUZrRFRFVWlNWXdJdXptS3FIdmsyVC9GNTVS?=
 =?utf-8?B?SHFIbVRCQStkU0tITUtSalRPVGFrL0hHbFZabDVYa1ZqR3g2SUxpdHh6Qk91?=
 =?utf-8?B?TzRsbmkwdFpJemFYUkJRYkVuL2o3dXRZUEloRXYvYnhad0FldWlaZ2h3bjJL?=
 =?utf-8?Q?Oa/hV1mwRBs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkxENDAvUm44Z2RFNlh2UlF5Mi94MjR0V2JCZWxIMGhObE9ZeUkxMENselZw?=
 =?utf-8?B?cjVwSDEvam5LUEcxRzM3Q0E4KzhKL0FFeDhFYk94c1pBRTMwN0NpcE5JdUxM?=
 =?utf-8?B?YXBZR0JwTlY1ZDNxQ1VlODREcWs0bXp1R0w2U3phdjdTckNzb2JtVVZhSG55?=
 =?utf-8?B?TEZSREFYanYxcUpNcEFGVzJ0OXdmaloxeVJFU2pRVkdRaWRBNmh2Vjh1RkFT?=
 =?utf-8?B?TWF0aGVEUTQwdlc1N3NEcExFK04rVmxZZSt6MmdZS1dCd2o4VjBTWU9mSGRQ?=
 =?utf-8?B?MzNlcEZtNUhycjlsV2JxbW96RXVzUC9kcEV6K2w0NXozYjRhZllqc0xFbUpo?=
 =?utf-8?B?RklTMTNLS3dmSUtRSXE0Y3p0RWsyOTRTQUZVWjBncTZmYWZRWFJpRE0yNzNy?=
 =?utf-8?B?RVl3bzhKaHNseVBnUisvNmpGT1dyQ2tvNnA0K3AyTTRhTjhJTlNUcWVORVR2?=
 =?utf-8?B?SmV5K1B0dUp2RnF0NTk2TXhRT04rbHVqcmhMbkJHYnE2dWtTd0ZRbmM3eENB?=
 =?utf-8?B?VHdia1VWek5wUWdDZDFuQTJCc3Z4YUMvSkxRdTdPMFhuWmx2OHp2b3lwUFU0?=
 =?utf-8?B?Z0YwTnY1WmRRQ3lTN0thTkY4eE9VLzBLMXhxdmFZL1ZaNmxXdE1HS0dHcHRO?=
 =?utf-8?B?UFpMak5VSVk1M0o0b1k3eW9IOHpSaHRaRXdzOVVHWU91VFZkUGVQb2phUU9N?=
 =?utf-8?B?MkhrRjhra2VUeDZQNzRxWlVyNG9uU2lGZ0JMOGhYVzE2ek1jQ0VkalNrWnJO?=
 =?utf-8?B?Qk1TWmpnd1hQK1ZBQlpON2pTVld4aTRSMVo4TDVRMW1sSjBqd0l6ZWJCdFVK?=
 =?utf-8?B?K3FyNjY1cllYRUszZmYwekdGNGZDYUdrKzh5TVF6WkJYZ1BtcDZKQXNzdSsz?=
 =?utf-8?B?SThwSStURXM1OHliaXZVVFBBQVA2SjlGWi9ZV1RUYkJyOGpQRlBWZDJ3eDRt?=
 =?utf-8?B?OU1NZmR5VzZ6RzlTaUhsa04vL2UwV0tFd0hNZkNWdFQ2bHBiNko5d0JmcnpL?=
 =?utf-8?B?ekhSQzBmRW9LVThNUEtLOXBXNS9hVERKTE5mcnhSLzEvcWxrYURPVmRkMjc0?=
 =?utf-8?B?WE9HZnQvYWtUc3RTVjcyMkZhRHYzWUFVTEFmbzdaSjIwcytkMWdvbU1lUHJB?=
 =?utf-8?B?TjBSVkpqcGtjMFNhRUcwWlBmV0I4WFpkczlnM0dvYmllUVFPemNGSXYra3U1?=
 =?utf-8?B?LzY1ZjdIYWpqYnRYd25VbVRHNTl1ZTk1ZnlnQVFTZWQwakNRZEVuZml4WURN?=
 =?utf-8?B?OGhneVRwdExWYXkwWmwveURDdENKeEoxRWZrNUFIakpEKzlVTFJBRGJDM0JH?=
 =?utf-8?B?SUd4Mnp6UTIxVjlmQnl1NmU1QlpDRnJlZGMwVTFxUW41M1BHaEhsSElkKy9x?=
 =?utf-8?B?aXFpZ2JUNVZmT2lJZzRTelJCQUplZDZEL04xa3A1OFhkOFM0Vkk1azBpdjI0?=
 =?utf-8?B?by9QNEYxZUU5UmpRZUl2bTBRL3UzeFNiQ0pQQ250U1hXK3QvbERyUFJiV3Nt?=
 =?utf-8?B?WEM5Z05ZTTlDVmxoeVZUZDZHV29iSzUzTnJ5dnp0ZThNbERUak85N1J3RDRo?=
 =?utf-8?B?R1k2NmJkNnIwbTNicHBLaDB3bmdOcHpoRmZ4cVlmaHdGVjlFbzY4aytlYkl4?=
 =?utf-8?B?U0N1emJSWnc5MGZHZTB6UlpicjFKaU1qWGNlQ1BXVzFWUm5Od2pjQ29IMzRL?=
 =?utf-8?B?TWo2S0gwVWh1ZUNOeDlOSWh5VGlzMHB5UWRiMVFNTVREMWNBOFc0UWdIc2dM?=
 =?utf-8?B?Tk5mcTYwVHVPL1FBNFNIcVlZekZ1RjEwOEZHZzlXcDFEVWdmd2YrK3BYQWZW?=
 =?utf-8?B?cXZyY2pocWdSWXJ0d2R3OFRibE56bWtBWGIzSmhMNEhWQVd3VUdmdHVRRHNQ?=
 =?utf-8?B?VWxQZ0R4NDhMRzlvVkhGdmlNVlNiNjRjaUZyZU9ialVaSUlpdi94WjJTWC9x?=
 =?utf-8?B?U015NW8raHlvb0s4T1FnMnZJVnZhNVBJcTFwOFYzQjRvenhJRlJZZS9CLy9S?=
 =?utf-8?B?bDJ5ZFUxQWIrVXZaVG10VkY4Mjh6dHVnTzFwMll4ME5lYm8rRHdya1c2V3pw?=
 =?utf-8?B?SmQ3Y3lMdHhlSXRCL3ZjaWNtajFrWWtCNFg5SXRiVXdKTUxnTzRydXNXZ0d6?=
 =?utf-8?B?QXVnQ1ZmS2NHZHVGZXJRYWx1eVgwdzVHRzdQQzJja2pkcU9qZVNYZG9PUThX?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b18374d1-4f8f-4b79-dace-08ddf14f9fef
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:24:04.6086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVg36qCvj80YPx6sPRH0qKlkkYkRw6dosL10IxuZ+3/tCaTqspYGj/MJ1vVFgpX4OKeEK2NnRYJVbpCjtiwtR2HkXJZw+tra+Me1+HvV47o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5786
X-OriginatorOrg: intel.com

Hi Boris,

On 9/11/25 8:08 AM, Borislav Petkov wrote:
> 
> Please tone this down in the future - it is really annoying and doesn't bring
> a whole lot by repeating things or explaining the obvious. Just concentrate on
> explaining why the patch exists and mention any non-obvious things.
> 
> Everything else people can find by searching the net.

Thank you very much for this guidance. You raise two issues: repeating things and too
much text that explains the obvious.

About repeating things: As I see it the annoying repeating results from desire to
follow the "context-problem-solution" changelog script while also ensuring each
patch stands on its own. With these new features many patches share the same context
and then copy&paste results. I see how this can be annoying when going through
the series and I can also see how this is a lazy approach since the context is
not tailored to each patch. Will work on this.

About too much text that explains the obvious: I hear you and will add these criteria
to how changelogs are measured. I do find the criteria a bit subjective though and expect
that I will not get this right immediately and appreciate and welcome your feedback until
I do.

Thank you very much.

Reinette



