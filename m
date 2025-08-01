Return-Path: <kvm+bounces-53845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D530FB184E0
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 17:25:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90B76A82EE9
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 15:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F20272E63;
	Fri,  1 Aug 2025 15:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gtzuCK6G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214F727145C;
	Fri,  1 Aug 2025 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754061898; cv=fail; b=aw+2IrFE6I3sUwTyRQXAlv0aIHrGtDQQ+JPe0XaBKg/vr9Aj3IVdOnDKTi4nMcCUrU3g8QVeOydgHWkdNfzo+DJ8B/Eff/yjsaVxe4L88Cb3BCWn2qvnWRalkfxkAo9GC51C5BPLFUHLkJwjeE8qJKlZme3TkBvoP9X1avc/xD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754061898; c=relaxed/simple;
	bh=yweeUKcugXgwDTPzeZAhPfiMi4CpsJvFRuBXCChPDew=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ofN8Lg6OMH8iGYM3CaroLeowEKHGqQANexaexIiQhjWo1dH4bFeIchUlxHhSdvs4Ci8SAs6NUmuR/o9ZCdzbaR4usWUe4LeJEoq7slpRwojT68PYgxuZojH+WKBX8gZ02iXc87FckkoLO7mfcMcrK0aOOH1iV0CkeCuwXb5mEZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gtzuCK6G; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754061896; x=1785597896;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=yweeUKcugXgwDTPzeZAhPfiMi4CpsJvFRuBXCChPDew=;
  b=gtzuCK6G8RywBEr54nZNb+wtu2KCPBFEnrEx4gD/FoO3PnFbwNtfvAAZ
   v9vc5R6XyiSIv1xKzuImSCQLBRItdpgUM/8sFtQYrmze0UvrBKCX0VhVW
   b7DkFwjg9LAKzjxNqeU7dEDpJsWq6o11s2VfFLl/Y0t9DSctYpQtLrmaK
   4U4P2ZKCmnIN4ce8HDuQ2Hn+Q1Hv9cerAtELidtga60qZc5rW+7pfQ/TM
   Eu4dzxjw5ZXBvcOTodXPnJf0YArXNr/fTHOEVEKpi1+RL/9G1pOPaQCIn
   KYLXW0DvZSI/x0v3dDro6+79IgF2jBxY9hAMlWuzhfuOY22isfH9PX59y
   g==;
X-CSE-ConnectionGUID: /L6BknoERk+QK/L5ek2OkQ==
X-CSE-MsgGUID: L29yF/DzS9WCKSpjNHXULg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="81865464"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="81865464"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 08:24:54 -0700
X-CSE-ConnectionGUID: IUlhA9x3TfSaXOHA/iTWBw==
X-CSE-MsgGUID: yN/gBNPJRLGPH1D40AV0kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="194422801"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 08:24:54 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 08:24:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 1 Aug 2025 08:24:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.58)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 08:24:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jh88OWoEB0pr2AtBibjgtwSl3h76UnGWUZdUv0X/Fwl2wsL8N1n/2wNqzp4pQQMthECcpnBrQNDZwsEUwHAMy+RMdEkX72pVA7sbQwD4NiGa60+i45VBA5VqTF+lH0CAX6wGoLyOQ2MJRzDA/Iw8Ng98JQjVJEb9pZMFOxVbpF8w8SffKHUmhOUe8HTbEoRFBathUf38zjKAaqnmsdndswbwQpLd/3RXBP4zhDwzaImz3vt/TZpMvGd22k/W9WxfVaIjjH1ZlbEEORsgvfnyMJX7cIw4e18/c9BcgfxaXw0Fx40Ch+XexxQ6dMEN7XnC9X3shO1+5XJh0K2oLVEaGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lh2EGCJ05whTzpm1qSu+B6c/OOVq399C9bHol23R5AA=;
 b=F5+0zN41L9W9d8DkoFKgEzY6bcMhEKI5vdyqQdAb/PEwV1RBL+22wZ0dHWQBOE0ifUYPz1vXIp08wV7sVKoXhY/IeVlrDi0fixFL6fKHGMTsflTVOPoyS5C5MEO2F2FZHrbh5TqqKD+W/6VOC1cFD0Hxl+5spa2fV9UGCMyM0J6E3QuARLvLvGBK46gEZKPwyej1ZmI+VBeZyMxFy8lv5yyhy0jvZb99M5L7FWM9wLgbwu++z6RXvyof+VNPaqJAylFlWuM989SU7EzvVe/hBw25VG6KFcFKHIbPI1LQGjy/TMg0FpSxrpFfKiszai9ymefnpi2tgRINi67jy1RYQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM6PR11MB4643.namprd11.prod.outlook.com (2603:10b6:5:2a6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Fri, 1 Aug
 2025 15:24:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8989.010; Fri, 1 Aug 2025
 15:24:08 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 1 Aug 2025 08:24:06 -0700
To: Xu Yilun <yilun.xu@linux.intel.com>, <dan.j.williams@intel.com>
CC: Chao Gao <chao.gao@intel.com>, <linux-coco@lists.linux.dev>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <eddie.dong@intel.com>, <kirill.shutemov@intel.com>,
	<dave.hansen@intel.com>, <kai.huang@intel.com>, <isaku.yamahata@intel.com>,
	<elena.reshetova@intel.com>, <rick.p.edgecombe@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>
Message-ID: <688cdc169163a_32afb100b3@dwillia2-mobl4.notmuch>
In-Reply-To: <aIwhUb3z9/cgsMwb@yilunxu-OptiPlex-7050>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
 <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>
 <aIwhUb3z9/cgsMwb@yilunxu-OptiPlex-7050>
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via
 sysfs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27)
 To PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM6PR11MB4643:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b40f737-8627-4e19-9b7e-08ddd10f7575
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eWpvRk81WmIwaGNzZnZpSEJQeVRYRDN3anY1VFVJNVArRW5nT2dNRERweVNw?=
 =?utf-8?B?a1Q5RWZBZjBmYWltQ0RxZ3o2bzdlVDZad2pZaVlTVzJwTFdZS0owQjd5b0pN?=
 =?utf-8?B?WkxodXZRdWI5VXlTNkdnNmRuVElqUjhUVXNrS3l1ZFVDZS81NTlWelk4ZVZP?=
 =?utf-8?B?OWllUzBiN29CTWdCNDlRL0JYWjVBUWs5OUEzWUFJNjhZeW1uYkF2WnhONnNp?=
 =?utf-8?B?bitZdDBRdHlMWTErWUhjNjJIaTFXV0dvOHRXZ1pac284N0FqNWFGWnlVQncr?=
 =?utf-8?B?MjVlSXA5TTFqaFVnQ0JRQXd0T29LbHFwS1FXanlNMU5GZy9oemloSEY2UlBi?=
 =?utf-8?B?bkErZzA3VUFrSTl3eTZOOTBMV0FJS2hhdjNicXZzenlnMFlkWXBOTk9zTnZP?=
 =?utf-8?B?ZDQ5d1M4TFJtZ1M4Wkpyc2Y4Z3BGQTA5cEQvc2Z5b3lsRHljUnl5MTM5bmY3?=
 =?utf-8?B?OEhpWk0xNjc2VlRsZ0JvRjZnMnBQaXpRYkIyN2JMSWNTakpIOW1aL2Y3SXNE?=
 =?utf-8?B?enpUUWFDZzhTRHA0amFXYlM3N0hBRjV3L1VsR1dLNGRTR1R6bWFTTXI0cXF0?=
 =?utf-8?B?dDk4cUdFN2FkTytSVVhGaEliT3JCZjN1cWk4S1VodDdrcUh6SDFYKzN6NzUz?=
 =?utf-8?B?TUE4MjV4MEd4YlhCUEtKTU93NHhEYTc5SDYrdTlSTnlic2FESi9VeEdFVGxU?=
 =?utf-8?B?ZlFSUSs5VXdmZkZQS2ozOW1yTk4vT0NKNVZqQnBjYjUwc1VuSEU3UFh0Witp?=
 =?utf-8?B?MlJBU0FqYU5YVFQzVmxqdkVEWXpKZXRDaURaTjFybmN3UWtoYnFwZjhFOHRl?=
 =?utf-8?B?cmllWmh3UmdhS2wyNTZCUVdEUG5PYzdBNkkzeTUzaENCd2t4Zkd5czkxZG1k?=
 =?utf-8?B?Uk9aUnhMOU9kekFSZzcvbStOaXlIcE9QZDYrOXM3UkJTTnpaVmdvb2dzY2U0?=
 =?utf-8?B?bDN6SE9MZmlScy9DVmlrdU1lSTdBdGxJVGEzYWFDazBza2dvSGMxb1dRdCtL?=
 =?utf-8?B?ejE3Q2pGZVBYYVo2QnROOUlQREwvNEgycXF2bjhEVXdueEJFbE9scmEwNlBv?=
 =?utf-8?B?WjluWnZmaEVqQkxvcTU4VjBxZXZKb3pmNmU1Z3hhbjJOdU9FWU1mOUduQ1Zt?=
 =?utf-8?B?aFJvWE1aVTFGYVJ1ajQwazlJTXZpNzVMdkVVT2c1TmdzYW4vc0czZXRSTjJm?=
 =?utf-8?B?NjZqK3h6Wk9OQTl2bkxCZU1xTDVOMFFwMFRySFFUYVFNMnU0Wkw4Uk4yNjFZ?=
 =?utf-8?B?M1J0ZlY4VVR5K1ZmOXJOWXRnUkdvcXMyRW82ZVVDbVlzUVZ1UW5IR3pKaDJN?=
 =?utf-8?B?RUJsdWtGYTE5MkNvQk56S0UvM0VQS3ltcmFTOGN6OVNKdHdOQVJVSzNiY3kw?=
 =?utf-8?B?bDF4cG1JZTRyOUxadXdlYzdsQ2RTaUtSNGlkU0RCaldleW5uY2kyTkhBbVJF?=
 =?utf-8?B?UDJmQytoUGxCOW5VRVVuYzZkbWJoZTEwdjZBZkhpakg1bVFTM0x6QlNnblM0?=
 =?utf-8?B?bXRZQjRXQjVmRUwzUFYvSHVqWmttSkJzd1E4SmlwUTQ4Ym83MG4vc0k4cHBi?=
 =?utf-8?B?UEtyeUkzRENxOXo2RU9mcHZOOEhaYVVuRG1Rc1JONDNrRDNrTjc1UGVKL01L?=
 =?utf-8?B?S3NqT2E4OFlrM3p2aHZKWFdXcStCS2V3a011SWRlZE4vNjFJdmpXczZxTlhw?=
 =?utf-8?B?MGtRM3ZrSEo5UDVremF6bnY2TVZDaXdFSUQ5ZE5oa2FWdFNYS25UYnhySkx3?=
 =?utf-8?B?SkJkanpaVWs3Uys0QXl1WVg4OWdBbDJndGQ5WkpESSsyaU5MMXBGeG5jSU1i?=
 =?utf-8?B?S3B2anhwN0d5WU83cEhnZ3JUdFA5OFlPak90UTQxaFdNU2sxVFRUREZsdGgy?=
 =?utf-8?B?aXUxZ0NjUlF3cUwyY3VYeE8yelF6MUdVV3lqRGtTOUllZ2k0TkdmNmVta3Nj?=
 =?utf-8?Q?Pi5zSvSKGZU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3lXYTlpMnhnMDBFMXp4ZzZPUWc3aHhxVncvamVJdFRMZm51WE82WnE4VUor?=
 =?utf-8?B?VHdRb29adUVkalJlYzY2WFZZUE1nUndLSWliRW00WUk0ZURaNnQrSU5qc1pJ?=
 =?utf-8?B?SWMwbUI2MlRJVUkrVmdRdUxiQ3JHeExLVXVYNVBqS0hzU1IwNkQ1ZE9xOHRn?=
 =?utf-8?B?MFczK1FZMUp6TG1tZ2xKVUpvdEVwd2tPNnpvb09EZDI2VkRrSEJYMkpvZDU3?=
 =?utf-8?B?NDN5VG9tSENNMWk5aUFKbmxta3RvVkRuaFV2OForc0pQV0tmVE9EZUZ6R09R?=
 =?utf-8?B?ME9FcG1Bc3VDdXhmRXdBUnRTNGl6bWRhdzhXcURPSVVtOWJXY2k5Rk1KbHNo?=
 =?utf-8?B?eGlCbFMwckM4dWlyR1BEa2FSb1czUWJsZDdCV1pXN2xCNW5zTzVjMnVVNExz?=
 =?utf-8?B?dUJtRCt1WVJEQW56ZWVkS2xJUGNlRmdpSzBxTWpNR29iSGF2eEVPc3hoOVR1?=
 =?utf-8?B?d1FUTThTR3g5L0FCdTZsbDVoSFlaWVp1T1lrU3pGK0c0emVHOFhFRDk3UlVH?=
 =?utf-8?B?akF6dnpKUzFha1U5aHozY0NKOU5tYmFCL0p5bHVYcWVMSmhaNXpSWGxEOGdy?=
 =?utf-8?B?MnJ6eXk2YTJwWHpqaXhiS21yYzFlQ0ZJaSt1UXlNbmtWWU05OHA5cmY2Vmty?=
 =?utf-8?B?M1dGNE54ZVRzS0hNbG1tQmdIcUZTN0E1Y3lBS0RXUHBJbWhWdmlEZlJXL29h?=
 =?utf-8?B?em0zV3EzMnBGMkR2MlI3di9kbytPUTdGMUttR1dUYmZ2Q3JNeVlYTm9LUHp5?=
 =?utf-8?B?N3k1cUNtWmd0UHYxNTF6M1h0SmVFdHdnbVNMdjlxVjlxTEtKWTg4bUlyMFFo?=
 =?utf-8?B?QU80YjRoWlFuajNCWURJMlpzMTh0K082T3RzeVllRTRMOE9jQjMvc09rRm4w?=
 =?utf-8?B?QkVOaWhRaUt0aVAyRVJVNHN6Snd0NVo3eW5oMzI0VFA5aENHdVFBazVvKzNP?=
 =?utf-8?B?TURhdDlpcDVJa0tjMldhMzZRVmY1cXdkZDJhZFhyUWw1QTdSaEpaTjc0em1V?=
 =?utf-8?B?b0wzRGdnYXM2dkgwVldQN0VZblBWRG9JSWhYdnpXTm5IWktobXV1UVZyTTFo?=
 =?utf-8?B?cndaNGFiRG1uVkxUYisyN3NzZkgybU1vYVR0QlIwWDhYTWI1VUtlbGNUd0Fy?=
 =?utf-8?B?TE15QTNYN00xbjlleGhmVmgzNmJvUmd1OVg0dC9XSGh2WC9lSXh3KzlCRktt?=
 =?utf-8?B?THNHVWpScnBUUDRxOEtMa01tM3dmVUxQd1RYaTFGOE9qR0JvNTd2eGxaYVkv?=
 =?utf-8?B?eUk0aGVXTVhnMzE4U3hDb1EzZ0dWcG9kTDBGcUZGZCtEbnlBWXFLbWdUTVdL?=
 =?utf-8?B?NkpWcms0Q1VINnhQK0JvSXJRYmdVYU05U2FOY24vZlFERVErVFpwcFNLa1BP?=
 =?utf-8?B?a1pidXg4bUtTTEZMTFd1VU1nV3V2eU5keEUyMG5VSGtBUU0yZzdzVlMwRHo2?=
 =?utf-8?B?RWVkTFliQkc4eWx4WlY3WGlNWjNVcnhsdTNmMEdJNU1HTWE2ckRVeEZsSlJr?=
 =?utf-8?B?c2s3S29zU3dGQzRLbS9VREU4MmtXeWpNNHFielZiSjI1Y2orc0tqUkZtUGlD?=
 =?utf-8?B?azNPd3VMc3dOL05haXNsVXQ4TFN2UEkxcDNRWS9tTDZibGUrZXRTTE55YVVi?=
 =?utf-8?B?TnBpRkZ1bHhCK2VwMnJJSTJ0RU5IQktLNlNVWUo0ZzE1NHRHU3RUMmZhRjM3?=
 =?utf-8?B?VVZnQmNzWExKMFQzVGJ3R3NDVnkyeG5YeGNId3lyQ2dlRjd6WHQ2SmJPc2tD?=
 =?utf-8?B?M084TS8vVFNkY080a3pJcFpPWTdrczFXMFRJQWp3TWxsOGhNUGRCb0M5L1hw?=
 =?utf-8?B?aXF0emFuckZkSTFQeUwrdzl4OHRKenNMUzlQY1ozQVdmUnF1MnluUjdqUUo1?=
 =?utf-8?B?M2YrOTNLM3FmRU9BTGN4YTlZMTJnalpnSVdBVUM4TXhUbTlsNGNnam1ld2l0?=
 =?utf-8?B?elFCdHZjT0JxdXNQTTVvRVNsN0V5NC9oYy9iZU5CWGVBMnM4bDRxbTEvdEFh?=
 =?utf-8?B?RUFJdWRMbHVTVGlBSG1DOG5xYjVtdnMyZTBEZnpQWW9jYS9QMHlPR3pyOElv?=
 =?utf-8?B?ejYxc0RRM1NRam9sLzVvQllkNXNSakllckExanhzSDQvQ2dKckNYZUhxVkVt?=
 =?utf-8?B?ZmpQbWVwS01YUVBpeUJFMkU2VUgrVTZSNWJ0bS9pRkNTcFJVV0dFcDU4Y1Vp?=
 =?utf-8?B?S2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b40f737-8627-4e19-9b7e-08ddd10f7575
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 15:24:08.3510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAFU2WngrJ1ue6NqfgPUJ3JobzR/hTxqVV8cTx6eg3WZofmblTDrBCGc0A2E7H0EhVf9HsUiz3zEK3nQtoLxEDFFDNNjuXASeyzCNjQV42A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4643
X-OriginatorOrg: intel.com

Xu Yilun wrote:
[..]
> > > diff --git a/drivers/virt/coco/tdx-tsm/Makefile b/drivers/virt/coco/tdx-tsm/Makefile
> > > new file mode 100644
> > > index 000000000000..09f0ac08988a
> > > --- /dev/null
> > > +++ b/drivers/virt/coco/tdx-tsm/Makefile
> > > @@ -0,0 +1 @@
> > > +obj-$(CONFIG_TDX_TSM_BUS) += tdx-tsm-bus.o
> > 
> > Just name it bus.c.
> 
> I'm about to make the change but I see there is already tdx-guest misc
> virtual device in Guest OS:
> 
>   What:		/sys/devices/virtual/misc/tdx_guest/xxxx
> 
> And if we add another tdx_subsys, we have:
> 
>   What:		/sys/devices/virtual/tdx/xxxx
> 
> Do we really want 2 virtual devices? What's their relationship? I can't
> figure out.
> 
> So I'm considering reuse the misc/tdx_guest device as a tdx root device
> in guest. And that removes the need to have a common tdx tsm bus.
> 
> What do you think?

True, do not need tdx_subsys on the guest side. The tdx_guest driver
is sufficient. This was the approach taken with the RTMR enabling, just
append the sysfs attributes to the existing guest device.

> > > And put the tdx_subsys_init() in tdx-tsm-bus.c. We need to move host
> > > specific initializations out of tdx_subsys_init(), e.g. seamldr_group &
> > > seamldr fw upload.
> > 
> > Just to be clear on the plan here as I think this TD Preserving set
> > should land before we start upstreamming any TDX Connect bits.
> > 
> > - Create drivers/virt/coco/tdx-tsm/bus.c for registering the tdx_subsys.
> >   The tdx_subsys has sysfs attributes like "version" (host and guest
> >   need this, but have different calls to get at the information) and
> >   "firmware" (only host needs that). So the common code will take sysfs
> >   groups passed as a parameter.
> > 
> > - The "tdx_tsm" device which is unused in this patch set can be
> 
> It is used in this patch, Chao creates tdx module 'version' attr on this
> device. But I assume you have different opinion: tdx_subsys represents
> the whole tdx_module and should have the 'version', and tdx_tsm is a
> sub device dedicate for TDX Connect, is it?

The main reason for a tdx_tsm device in addition to the subsys is to
allow for deferred attachment.

Now, that said, the faux_device infrastructure has arrived since this
all started and *could* replace tdx_subsys. The only concern is whether
the tdx_tsm driver ever needs to do probe deferral to wait for IOMMU or
PCI initialization to happen first.

If probe deferral is needed that requires a bus, if probe can always be
synchronous with TDX module init then faux_device could work.

