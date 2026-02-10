Return-Path: <kvm+bounces-70767-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EGXpDzVai2ljUAAAu9opvQ
	(envelope-from <kvm+bounces-70767-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:17:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D16CC11D056
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:17:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B83C63007505
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2EE38885B;
	Tue, 10 Feb 2026 16:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cwa5se3k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007E92DA75A;
	Tue, 10 Feb 2026 16:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740273; cv=fail; b=f/i3P6wYIWRf0CguLT0LWQ8/RsuNIp4XSrh3uexuTV7ZHanR6FAMYF3ucn9+gyCzng56WnXyTel8K7N4FbkhRojXz3zHb87y5US69WXLf4+Rw/KR4w7RxzxEZVd7s44qIfStLN2Zm9nI7CD8xV+6KMQJl1GGzOxdEBKZ6MkofQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740273; c=relaxed/simple;
	bh=5IwsImknE4wrF5JlIH9lrmo12pjxWXB6NKjj0x744Ds=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eJDMkpPFnk+byyRdQsJma0dF6/V0eVlzr/9B54jrPfBsz0xi8DOHunX4v9y1CbSlRfRZ64jopiatG/mleu3ZOTiPpyzEtC0xTqNcCzlz1zcAXqL6acesHVu/8ErlaPJzQOA6Kbl30LJb1+Zgr0g9ndsSqX7Rfal9DstI0jIG9g8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cwa5se3k; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770740272; x=1802276272;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5IwsImknE4wrF5JlIH9lrmo12pjxWXB6NKjj0x744Ds=;
  b=cwa5se3k2KFvzu4OLaLmm4wgbD8Ra5pjpMXN6OiNgVNUMBdET0XT/U8T
   ghN+Ae7b16XJTjS2ag7LiaWEab7cv0LpbpFd1PFEQofdYRhH4Z4GIurWJ
   nmS0GnEsJyyRvfHb2/eEdAeZBT+DfTQ+OE7G3QizXluTTq5pUvqhZtRJ1
   Wk/1K+0Z5FFBVTNgAaA+1ba07emnTTKIw6DY4pjDGZFbG7M9ZxAhUa07q
   bmGm+y3bFiYlBN3ISfH4o3UO5w8mGAl/CAjscB59240EQhwkEJ9ZWCIrY
   wKSeNEN3Ysam7cnOLUnZSk2cpOsHDKp9TDj1C3XYIB8YgAKJZJwlMHv5D
   A==;
X-CSE-ConnectionGUID: FjAXuK84RtWC9IIhErEXhw==
X-CSE-MsgGUID: 7/6f9kOzSFKcPwPRWaZPTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71083583"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71083583"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:17:51 -0800
X-CSE-ConnectionGUID: ql3Ifg+UQU6D6hfElNgD8A==
X-CSE-MsgGUID: HDoO/ossTymM5xJf5U2uCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211289163"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:17:50 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 08:17:49 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 08:17:49 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.2) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 08:17:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CRaAdLTVYHj2mlZaZDtcr4s1X0CoO2+bc5Z92vSH0RsUKsOPk/Gc0XnvFGpE9E+UgSFGaZJv/Q+YZ+hv95Pz6lyNqPt36BfXxnsmIxNfMPz8E5gpxMPHBKjvxF5RiONZWlLFeab/rinY3N63bq2zNqkLAV2oKQeOPy7jg/e+WzBbkssgP0VtVCl7KUjubNF51u1e9p7BoNfqZb3rGTuePDbMuTLTp1535tRSSO6lg1pxTtShvPg5tSWeAAJR1/Ii0MpRtZjwZOY2onDsCem2ycMB5hJ44FteMxz0YWo37M1qbS4y8nOp47Ld3WscaB1uJAXwMuH8g7ZhAKmHxTWuiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEyR02biKPSSDrxtCrjzLquB5G6v1EoKFNUY5fvOi1k=;
 b=FNrz0xjLW3PPTSUkabb1f6Dl9AQHo73hXeQJBn40lQNLBYD6WoJh17TGe0AkoGP4+6/FSwUplNGIx+s3Jxp8Ny4CxU4sJQ8jKZpUDh6SBHZZgzpWd7fF9CXM2BSSU872CDCDK1o5QsJiiEqikC7E2E121TgYgP1SzPX/qpeqMnue4GyjeRR2o2ZaE49fgd39DtAW0wbOrTZhM4uq1Hf4uhTBPOztyvJCc9SPpj/4Om5fFsxCPAvL8cF3SIOG5XOiA8KpMyFEY2dOpG9loeq0e0PwMi5tlQFehCbwF7/CrfaMIka3AwJsLMUSPRc7s7i/TQR54bK+ve6eFa2Is7+acA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BY1PR11MB7983.namprd11.prod.outlook.com (2603:10b6:a03:52b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Tue, 10 Feb
 2026 16:17:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 16:17:44 +0000
Message-ID: <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
Date: Tue, 10 Feb 2026 08:17:40 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Moger, Babu" <bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>, "Luck,
 Tony" <tony.luck@intel.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BY1PR11MB7983:EE_
X-MS-Office365-Filtering-Correlation-Id: db1f3385-ba75-4639-963f-08de68bfec2c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZWxKSFFTY3NOeEg1Q3JwZzBpS2xCbjlhSUJHeXNhWjF0YzNUNEF0djlQNWpW?=
 =?utf-8?B?VWd1WEFNMElZZzVQdXV0RVZyVmVjZlgvN3ZnZWdkMksrVzRpZ0NyV2pFWjlN?=
 =?utf-8?B?KzJ3OUcxWjN6cjZza1ZNVFhNRzFDUjFMNW4zVWVUVzRMQXFJSUdKNElkTENP?=
 =?utf-8?B?eWU0MzNxSGFuc2lvQXN2V0xnRnBvSFRBelk5RXhKUE5Ba0ZFeE1ydXRlK2R3?=
 =?utf-8?B?ZmlVc1FGc3JIYnlBeGlWeDdzRjJrQ2Y4bFpQb3BPTXgyUW1yTHBMd3JDSFVL?=
 =?utf-8?B?cUc1eGh5dTFZa2VmRXZCNFJzNE1lWGduYzNxSE82bXpRVWRrNEx1NHVHU0xs?=
 =?utf-8?B?MThSZnJMS1NRVmJSR0F3aHNsNVBEdnhSUXMwcncyOUNRQ3ljaFlud3JxUFAw?=
 =?utf-8?B?aGR5a2paTWV4MXBMYnBEdjZBb2M5NDBtdmhBQ2xpVEdtUEVFYXdoRVkrZVFC?=
 =?utf-8?B?b3NLWVNqSWdNK215SEtGR0VrOFBvZHVEN0FTSWhDMzFyRVg5SVpiTTVkenNO?=
 =?utf-8?B?K2lUMVZBTGczUUc4QnJ5RmRMQ2JjcC9jVUFodVRrSnNIZG1kVnBjM1VCaXB3?=
 =?utf-8?B?NldQTFFobjd2VUFGQVI1eTVneGl4djZJT2oyakZTZjJyRlltTm4yOXFrU0l1?=
 =?utf-8?B?QlNyVDBmYXNaQjY5Y2g3Yyt5OE41dWNONEhKSVExSXlYY0htTHR5M1NVVjgx?=
 =?utf-8?B?QTd2WU95UTVZRElhd2FieElvMXBwaUoyNEM2TzQwRU9rZEFiRDZJSVJoeWl0?=
 =?utf-8?B?YnlkdWd3UXBCMUp0M0ZtRWM2eGRFaGZob05PSm11SkZlM2xSendEVFNEZC9P?=
 =?utf-8?B?cnB2b1RDUjEvc2p2d21SdmNEMFFYeEVxNjAyWE9rWVFZdnI2cm1JWWY0eEcw?=
 =?utf-8?B?VW4rUndoTkRrNzFGZTZyc1phcmNLaDN2T0Jtb1lxMXBjTlFsaHhMcWgyTUl2?=
 =?utf-8?B?NWV0RjQwc0djcHVRVGpCMlRYWVQ3UVVkcFBMak50UHBQR2ZmZnNiZ3hKU1RD?=
 =?utf-8?B?TFk5RW4vTzMxVG5ubWx5TnhEU1JPeTRqS3FlZkhtZGZMRFllMXVPd204SzlI?=
 =?utf-8?B?dkkvT05yNHplcEJieG5EbTlINDVQQ0JmYURMOTQxSTNUeUNnKzlnWlhGTHVY?=
 =?utf-8?B?SHNxSGkyZkRCNjNwSmRDVDhneXlYdmk3OXNZM2dOcjg2WUZ5VksxQ3BVdW94?=
 =?utf-8?B?VlhMYzdPbFE3SU9UZ0xrUWZPUXNtdE9nb21zbUlYQnFlMjFncGVnc0pYdnht?=
 =?utf-8?B?NU8zWnRNV2hVdkVoUkpGUnlwRkdsczRQc1pBVkxkcFZnQ2JZczJXQnAzTk85?=
 =?utf-8?B?S2ZyV3RDTWVOekhCV0kzd2NSMCtNTkJ3YmJuSTNJRWI1L21aSlhNa242d2pC?=
 =?utf-8?B?R04zV1FUY29TNzRTNHVvUGt2TGdweUdpcW5jeHQ2QkJKT1M5TWJKejYvbzUy?=
 =?utf-8?B?Ujd6cjUxWTdpWXJqbDRSNFA0MVFIZ3E0c2dqbU5Rdkw0bVhYTnRDa2NKV3FL?=
 =?utf-8?B?VFF6b05ZSTBBd0ZwaW9sVkVZS2dtM3hOTkQ3THRzOUUrQ1VNSS9PaDhvMXcz?=
 =?utf-8?B?WWE0YTErb0h6aWZxNUJWY2ZiTXhHUVpjNVgvZFJNVkR5dWlxVVcranpudENW?=
 =?utf-8?B?QzFDRDFXTXZwYWNwblBYOWwzUnVpemwrczQyRVhncHpiV3pwWnNVanJBZmkx?=
 =?utf-8?B?eXZUOHppbTRKQnRGanhzWkVwTTlHQ3pvc0NaZUdGU1czRjZLYkNLaXVIa05G?=
 =?utf-8?B?VHZ0MzY3dzZNQVVxQlJDcEVyVDduTEx6VlBrTUZBNDhYbXVIV2t4amJlU0FV?=
 =?utf-8?B?Wk5NRDZxdEFxbXB3Tm5sOFdoU281dnp3VmhpejZpRExCanNhN1lMdE5pTUVE?=
 =?utf-8?B?bDV4ZWxqOXVuUUJZcDFtMXY0QVNCS1N0RFJQUTVzaSt5dmJRZDE1VFlhUjZE?=
 =?utf-8?B?cDdDcjAxQ09BbDg3NndJYjVCalZsVkRVSzRoYWowQUU3eW9uZ1VrUTE2WW5r?=
 =?utf-8?B?VksvQ2kyTzNadTJJYThyQjA1QTRreGE1OWx5cTN1MFNOUDNYcUtqZm5HRkxn?=
 =?utf-8?B?d1lkNi90ZzE2RWcyblVCRnZ2d0M1a3JsczVieVV5YzRhdFZOMnE1ZG05U2tX?=
 =?utf-8?Q?LMkU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXVxeXJWVnJGZkY2QzBIcWd4WERtalJmYyszZGhWcm9VSEg1bzdjUHFlR2U0?=
 =?utf-8?B?NnhnMVNEb0phbnFLL0NuS2NBT2FKOExyc3Q2VjRvK0t6VndRZzFDOWNhd1Bh?=
 =?utf-8?B?YWZiVkovZ3grN0Vwa3Q4RHlHUWxzWVd3UFBTQU9VS1A0NXZVRERuVmxmVkVS?=
 =?utf-8?B?VnFsMFovT1RWa3pJRmRDRmVlckJJamRMMWVLSktWMDJIL3JMd3FjbEpybkVM?=
 =?utf-8?B?Tms0VEJCSDRVRGh3bHNzeW45WStFUFlNblBHYmxkVTg4Y1NkeG5pZitiang1?=
 =?utf-8?B?dnpQa2FCN01TUHhadk1VK0kxb29TMWo5TDJaT3VDWHFsWXRYYjNOc1huMlBJ?=
 =?utf-8?B?NGtJMXdQUUQrUENYYlFSUnR2NjZ2UEQ1WWQ5ckZHZTRqbTlNbUY0WjV4N0hu?=
 =?utf-8?B?dWlVQnNiUU9vTkpmeEcrczg0SnRpa3FIQ1BVMFBpTHJLcUtZZi8xMWtWTFVV?=
 =?utf-8?B?NlErUEIyUUhQOFFKWHR2STBLTnEvYjRvcWRGSnA5ZFBKY3EvVGpTREsxVWRq?=
 =?utf-8?B?Uk9aL3MrZTIvZDQ0VjB5cnJXcFd2OGp3RW5HMEZEQXRvZXFiSGh3bVRHNzQ4?=
 =?utf-8?B?OEJGa05RN2ZXUm02ZTdzWTFYOGpzWEprY2s2RWtMTU92eS9lMlpmMmRqUis0?=
 =?utf-8?B?a00xWkRxR3hqM3ZKaXVKMGxEcEtEMGQ1MTNzcllhcitudGVRL2RSaHJkdU1a?=
 =?utf-8?B?TzFyNjdmME45bGd3eHlGQTRoMzhBNjVnenNZejVxaHJ4WDZpeVdBM0JNYW1h?=
 =?utf-8?B?bWY0WVpmcVVZSkNTWFdSajQ3bU15RzBWaGZHU0JrSmtLUWRvQVc0cWo0blVI?=
 =?utf-8?B?Q1IvUE9VR1pKb2ZRazQxK0tEYS9JOTFUdXlBa2Z5WmhrNm9Rdlk5bHVscVgr?=
 =?utf-8?B?ZmhTVGg0MTB6Z2I1eWFKTWFwS0pMei9BTksvcDRvU0Rsb1I2TTVKVE9ldVox?=
 =?utf-8?B?OGJXUlhSVjZFT3djY3MwMEhPWkN5SDhjcnRZOUNHMjZ6UGJkV0hJS0tHNXQ2?=
 =?utf-8?B?bE1YcDQ4aGErYkNWVGR4UlltemhndHJwK2lrUDV3akdURThldEtTRk1mZzAr?=
 =?utf-8?B?TWJzYkY5V29KVnFYYllHQ2doREFmNFloeE9DL2k2OXFzb3BaNm16b1p1aWhD?=
 =?utf-8?B?ZGpzTHgyakMzQzVwSDAyb3VVdWVFaC9lcHZpenNnVHVwZWFBb0VTa3djYVlI?=
 =?utf-8?B?KzNoZEhKOU5zenJmRW43K2hGV29wMWFrQlJDampoQUl2Vi9KWFlneGVQZEc4?=
 =?utf-8?B?ckJnL251UFpTWjJWVlFMWXN1akxXV3N6dUorTzRWQjNkSG00TE0xeHhQMHFD?=
 =?utf-8?B?RDA2RzB2VEV2QmNZQ3FoMjFwcGVkR29vR3RYa3NjbXZSNWpzUGRzZlhNYXBS?=
 =?utf-8?B?d1BGWmtYcXRZekdLRGVFOE9wcFVOTUc4U0JrRXI2RnlkM2xaclg4ZklvYVJJ?=
 =?utf-8?B?OEJKdU5YSXo1RVdZYlliMlpCc0s1YzllTXhJN3JRNUZBRnltZi81aWgvbVo1?=
 =?utf-8?B?U0F6QTNxMStZcmthQ21Ib1FCakVsY2NRVW5COEd5ZmdwWHdMdTdGU3ZMdGhh?=
 =?utf-8?B?OGU3NFFtYURxUmNWbWxTTkdPbFVKVG9tbnZxb3dCUXFzbFBJZmNNQlVYMmw0?=
 =?utf-8?B?aDR5TFBBclVmQWxwdk56dFRyQTQ2UVN6VUo5VEx3dm82OXE1TXJuZmhNOUxQ?=
 =?utf-8?B?aytHSStkVCtKeG5JOVEwZlh2bmo1SW9zMGsrc1pWTGhwK1JiZzg3azJwNmli?=
 =?utf-8?B?ZVhOVzNvWlE4azRITEJvTFNnSzRKR2hpZnZUMjVHQUVraTJWS2h6TDZBaWJN?=
 =?utf-8?B?STgxYVBjRDdCdGpoVlgvUXBpaVRvK1VNQ1ZmakliTGF5SnhyK0NwTUswT2Vy?=
 =?utf-8?B?Tkdselg0MFEvZDhGclNmK2VnK2lTS1FIdlpLUmMza3hLRWFXN09NSTlMR1dx?=
 =?utf-8?B?K2pXdTBRVzZsS0taZFFYanJ5ZU5SL3JpOW5ROGVaL3VsUUtQcnJxdlM5NDZ1?=
 =?utf-8?B?SEozNWlYUWV5dEQ0ZGhmdTFLSUpnbnNZZm40aUFUamtpN3FySFJUNUdhaGZY?=
 =?utf-8?B?cXBBYlo3cWx6WEhUc1liOVhVMHNJc3RZcEJWc2w1N0VEeUNhTDRiVnZ0bG05?=
 =?utf-8?B?Y3BuT05Obk1VM3libExKL3R6YTcrL0E0SlBQQWgrY2lBelhzVStHbi8wRmJt?=
 =?utf-8?B?L3Bnd2owY1NTOHU4NGNqejdld1RWMW5aSDJHUXIyRmpHOXF0RUN6clN1K3I4?=
 =?utf-8?B?VFpWc3pORFd2R0tBNnJJSHdvVEtxYjlCTklYZ2V4aHByU3QvVXdWU1plTlBo?=
 =?utf-8?B?eTVDT0NzbVV1S1pBRkZ0d0FPSjVMbVJzNWhQcDF2ODEyU1ZBMWhsMnhUUUsw?=
 =?utf-8?Q?K09kp/+2xcv5CJEU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db1f3385-ba75-4639-963f-08de68bfec2c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 16:17:44.6549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40SUyuiih3ekKTaPm0UuVv/yx/Kn3uZLEeWrq/DeEU8tCGg79NNf8MlRKkOkUE+hB/OjhRYODZbCuA/nOhvcEhv/B+yl11YIWhAW/B5Y34c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7983
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70767-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D16CC11D056
X-Rspamd-Action: no action

Hi Babu,

On 1/28/26 9:44 AM, Moger, Babu wrote:
> 
> 
> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>> Babu,
>>>
>>> I've read a bit more of the code now and I think I understand more.
>>>
>>> Some useful additions to your explanation.
>>>
>>> 1) Only one CTRL group can be marked as PLZA
>>
>> Yes. Correct.

Why limit it to one CTRL_MON group and why not support it for MON groups?

Limiting it to a single CTRL group seems restrictive in a few ways:
1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
   number of use cases that can be supported. Consider, for example, an existing
   "high priority" resource group and a "low priority" resource group. The user may
   just want to let the tasks in the "low priority" resource group run as "high priority"
   when in CPL0. This of course may depend on what resources are allocated, for example
   cache may need more care, but if, for example, user is only interested in memory
   bandwidth allocation this seems a reasonable use case?
2) Similar to what Tony [1] mentioned this does not enable what the hardware is
   capable of in terms of number of different control groups/CLOSID that can be
   assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
   MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
   example, create a resource group that contains tasks of interest and create
   a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
   This will give user space better insight into system behavior and from what I can
   tell is supported by the feature but not enabled?

>>
>>> 2) It can't be the root/default group
>>
>> This is something I added to keep the default group in a un-disturbed,

Why was this needed?

>>
>>> 3) It can't have sub monitor groups

Why not?

>>> 4) It can't be pseudo-locked
>>
>> Yes.
>>
>>>
>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>>> would avoid any additional context switch overhead as the PLZA MSR would never
>>> need to change.
>>
>> Yes. That can be one use case.
>>
>>>
>>> If that is the case, maybe for the PLZA group we should allow user to
>>> do:
>>>
>>> # echo '*' > tasks

Dedicating a resource group to "PLZA" seems restrictive while also adding many
complications since this designation makes resource group behave differently and
thus the files need to get extra "treatments" to handle this "PLZA" designation.

I am wondering if it will not be simpler to introduce just one new file, for example
"tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
resource group to manage user space and kernel space allocations while also supporting
various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
use case where user space can create a new resource group with certain allocations but the
"tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
the resource group's allocations when in CPL0.

Reinette

[1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/

