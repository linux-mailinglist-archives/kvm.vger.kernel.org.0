Return-Path: <kvm+bounces-71077-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLxIJoG7j2mmTAEAu9opvQ
	(envelope-from <kvm+bounces-71077-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:02:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C3413A187
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:02:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8DA16301FAB3
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 00:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B687262B;
	Sat, 14 Feb 2026 00:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m5188GIY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9844BEEC0;
	Sat, 14 Feb 2026 00:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771027324; cv=fail; b=SBLwitap3iGpJ2bCHgCkHSyFlyvdrOsIRBVfMZKujYxGWoZ9daz5pEsaezFfFFdqwWcSVgJNeoyoKCpf/EJN/3tBzfMUOw9ZMldP3zJQZSUk0wvDBRLnzp04u/Ad9lv/L4ACz+SHQRUXoq0DwJeMEnY/WeZgN/EoOPNVOXA5bhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771027324; c=relaxed/simple;
	bh=9P7wMV2iW2aVNHa/asQXiYPfapiUdyGuaZmSQ4m0oRk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dsMckvVCuxryOZYkUbbsD4ZBdH71zggoCDHV3hANH15guQyrhPx9lUQm91fs1pHLWqpjMhPmhZ1CddSYTUXqXL36vK6BDX4tNZhQTUCh7ImX6z6WfxaLTEHoL63SLx1u2J6cUaObcJtmOpcnEHHUeVEk9W6kicf8MSJ9SnzsS0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m5188GIY; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771027322; x=1802563322;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9P7wMV2iW2aVNHa/asQXiYPfapiUdyGuaZmSQ4m0oRk=;
  b=m5188GIYEIu3sasUYSW22SKEA0DTFQXfqfuZm+wXBzQgvk6sXu5Gglo8
   /2EiY6zGcT+/Vwqo5e7JjKO4ehmjQCNj/9cNaHstAkEyOcBdmP9L6gmIa
   /YhhKSyBpGcqoP0mnSe4vhTBHnQUC+f//LkjZ3xTfZ+uwHWtOqBRHcR2o
   CmIUNnJrtbyqqjbGli3oIJLtjsq95ten+cmKJaZZh2qTcjWxT2gmjECaz
   MNqsGKKq6T5jUNqvrerCU5wWi7rcja31i6rULUUoxsymn3cLvNHWOklxn
   PWZd8JTENCAOgEpCPmKYHDDKnFkjQTPPI5weq3B/IUwWKYddFPPN9x1hV
   A==;
X-CSE-ConnectionGUID: TefVjAhJRyi0CdFajH3sEA==
X-CSE-MsgGUID: 1Tn5xaFdQg6GGCUn48OxfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="75836515"
X-IronPort-AV: E=Sophos;i="6.21,289,1763452800"; 
   d="scan'208";a="75836515"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 16:01:54 -0800
X-CSE-ConnectionGUID: wQrIoLgxTpyttDspG4954Q==
X-CSE-MsgGUID: lRBhceOVRMqN4K80wYyNPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,289,1763452800"; 
   d="scan'208";a="212897938"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 16:01:54 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 13 Feb 2026 16:01:53 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 13 Feb 2026 16:01:53 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.62) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 13 Feb 2026 16:01:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zc00heEY4GOgFUixzGC4G7HTTaCHpGJGRHB4dGVIldvu3TPDcZgwBE8DCJVBpUn8QXt75TbSPsW/EKqhUMm3B85HGkR1ruTYupVYrzoyq21jYmWHaDqNdrNUOloSGGU5XFYjmL2Q3KiIhYqoQYGGzwnER/qwtKLAiGdgttF6xWo6YumIJQq34ESyPJrmZLzhyOncyu3yZ6H+RmcrrUmtq5z7CZkfYxnCQMSUAPtPsI+97e9KApoLQcplRoSRikHiF1merfHX1zj7Lk9P8vcBZLNt1GwhYJOwzY9buvgry0s4gkeoQc7LzFXFF9/d9LuiPHcstg1lT4ekg1ZdUWGKSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NagdOqnSstxKPZBU6JQceQlUzGSQcR5aJQ57uSCJuEU=;
 b=IDhRZNLFWjhbn2OaWyeOjK0BpWRU0bCHDnrn+BKNM81uFIigv9g/kGTnsOfvuRArwdG7UhuwsoebahQ8B2fySjXJYF1KFCAB9wmD0PL3fdWBElqTbkPeQuntEfvrlzqVLQ2sQcY212pw5DjIIUuAjKFvPbTnPcHwTqwuPuP+LdfAWngZmpueTa2f12IwgtsqlVfOTo+82i49bTjcowhApA5QizSNJwQYaecCEW0f2MbEMcMm9C7hbi0UohnGRGumwCpc0yWniuiK/f/iaPyCmLAprnKmK/HtplLbxDXKhd28DFVivyKpfP0PzB6F2vMXxRkB5YwMFNZ5HwuwvT372w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF2FCF00E1F.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.14; Sat, 14 Feb
 2026 00:01:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9611.008; Sat, 14 Feb 2026
 00:01:47 +0000
Message-ID: <cd6b3030-50be-4e75-bd88-af306644cf7f@intel.com>
Date: Fri, 13 Feb 2026 16:01:41 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: "Moger, Babu" <bmoger@amd.com>, Babu Moger <babu.moger@amd.com>,
	<corbet@lwn.net>, <tony.luck@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
 <91d50431-41f3-49d7-a9e6-a3bee2de5162@amd.com>
 <557a3a1e-4917-4c8c-add6-13b9db39eecb@intel.com>
 <f72a62af-e646-40ae-aa16-11c7d98ecf03@amd.com>
 <280af0e2-9cfb-4e08-a058-5b4975dd1d16@intel.com>
 <6e4fc363-7f3f-41fe-aaaa-fc60967baade@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <6e4fc363-7f3f-41fe-aaaa-fc60967baade@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:303:16d::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF2FCF00E1F:EE_
X-MS-Office365-Filtering-Correlation-Id: 61fc4bf1-f534-44c1-34f9-08de6b5c3f05
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S1oxSGFBK0VmcExSQlhIdkdzc0dIUWpIOEpaQkJaMzlWWHg2VWd6SjE2VjFP?=
 =?utf-8?B?bXVxa1lNSDVSUWVYRURnK2l0QTZCY21BOHBXbmFPVE1acU5Ca0ZGT2QvNVFN?=
 =?utf-8?B?Kzl2Z3VOaXVBZ0FadEhWRFhJd1F0elRPUjZoeDdSWGVOWTZ4czRYTC9vR2dF?=
 =?utf-8?B?WlFuT0N4UTBITEgzdjgxQXlFZDd2bHo2R1c1eWJkOHJxOS9RTlhPc1hmRWJ0?=
 =?utf-8?B?TEhaQmg2S1hKRjdoUVVxVVNKbjJhcWhBVnBNS28rR3k5MEdXSnFRekxPRU02?=
 =?utf-8?B?SVE0alp1ZVNUWEp3Y2M0RStTTUNiMnZSMUJHWFJGRGMwYXdkLzJidnhJamFY?=
 =?utf-8?B?R1hTY250RzljMG1UQXBodEM1WjFjLzBoMEE4OWthOEVselRvTitGQVdINDNz?=
 =?utf-8?B?S041cFF0MjhBRDZJQ3ZuMEJIRnFSU2ZIdFpHSjl2Q2VtcnB1YUF4WHllK002?=
 =?utf-8?B?dnJwL29kZkl4WloySUdhVm8xZ1JUWFdzSUVGbSt5SU9BK0RQbi9TdGh3aWNQ?=
 =?utf-8?B?aEw5OGZ0TjVDN0pQTHdXb01sVW9EUTF5NTlKUCt1YnRWUW5KZDNDL3JERGxT?=
 =?utf-8?B?dnltdnN6UEZndGpYRVJMZ210MjR6eFFFcUlDR1R0NTREQkM5NjVxRnFiaVBH?=
 =?utf-8?B?UG1Mak4zczJzWmcvam9pOEhINTdtS29nWUNUU082OXdTNHIrT3FXNDZqa1VQ?=
 =?utf-8?B?cjR2dkdLK2lCNGgvbTUzeWxOOGZQdGZlL1gydWRRbGdlYWwxRjdVanZRbDQx?=
 =?utf-8?B?VVVaOGFZTURuV0MxS2dRNGllVHZxcDhuMVJsREdmMTVjc1F0TVloVW0xVDRX?=
 =?utf-8?B?c1ZRWjZ1UnVSRVBTWFNLQXBpNG5qQnBqNldldnVKenl4a3dOL3FoTGxUZUZr?=
 =?utf-8?B?VTdrQ0hvK3JFK3NNMjZTRzBwWGhRd3I2QzZhWFRDaWFGYmMxYURDQ3Q2YkFt?=
 =?utf-8?B?VzcwSVhaSUNvVzBkak1RR3A1dkVQUE5GRUpHUThOdHJ4MGZwbnZnUEI1TE9T?=
 =?utf-8?B?UWc3d1dWSUpyN2IwcHlEblNPTXJPeHF3Z01ZWXZ1OW5iZjRkenVydUtrQ0hs?=
 =?utf-8?B?VktuVHBzV241d1UrUWU2VmlnaXBzKzN1OVJWc1ArTU1CK1pFakhwbHVVVURw?=
 =?utf-8?B?L2h3YjIyanV4M25MOFRWWDgxQmlGK0UzcnFzQ3F3aGhJb0ljT3doUXFwZGh0?=
 =?utf-8?B?Y1lxaUo5MU55R1BkM3ZlMlVURElRMDZjU0s2cWtIb0Q0RUlLYWgzODFiWW1L?=
 =?utf-8?B?QURTNFBpWE9mcnBlVE8zY3MwMktqTTFwWHpzazlPc1NiOURFNnUvNmtPeEtW?=
 =?utf-8?B?RitJd0tkcVFJSFhOTEFjNGFDR0Iyd09LY3drL3hyNWxub28zcWJkdU5sbVNM?=
 =?utf-8?B?bWgwV25XTDBNVFFoaXBJUlZETkJ6U3VHd2QrcFJ6OUZsTVhBUE96bk05c3dw?=
 =?utf-8?B?N3dVSjBSeUdPNGo3cmRZSGJaNzFzcW5hSU5ubjBNcytuOUhRbmxNZWtSWHRI?=
 =?utf-8?B?NDBHMXJHVTgzNklrUlZ5ZGFiblVRVFVveks2VDdINXl2clRmeVR5S1lPU1d0?=
 =?utf-8?B?THJudEFLWXU2S05GbUFZRnpoMWFmc0k5L3BQUGFXY0hsWUlPcStzT2JiY2tp?=
 =?utf-8?B?b0Vab2FBWm4vZ25PVUFWd2NPQUJTQlErQnJ2MWpqS0M0anIwa3hCb3h2Qncy?=
 =?utf-8?B?UU9IU3F4MXlmVkp5WHI1VEZwcEN3eDlCdmx2eFc3ckNrdVdNME1Memo4Ymcv?=
 =?utf-8?B?NnZ5S0V1aU1yUXFkRkFSUDRkVUpKS2VSZWE2d0dXWTV4WG0rVjI1QjBTd0pu?=
 =?utf-8?B?bGhlVnViL29KK2RhNEszVGdjelpLYUptQytqVDd4MFg1Sm1oNGUxWEdpMjY4?=
 =?utf-8?B?K2dIS2ExT3lkaGtaa2cyTnRsMTVlR2JCQWd4UmFVaE5jMkp3bzREd1RlcHAr?=
 =?utf-8?B?SXB1UUkvRytmQnpZbU5rd2pVQmJxMjV1TlF3NlE2ci8ya1Bzd2ZZQUFjSTg1?=
 =?utf-8?B?RFJHN1ZGNjFvYUM1Y2dBR2xxTHkvZUdzdGhTcldidHBrT3BPRE9OQkoyZjAy?=
 =?utf-8?B?U3NwZ0RBUVUvM1cxQUQwM1FVTXNpSU4xRU1LZDBYOHNiWGszT243bUpaaXlz?=
 =?utf-8?B?ZFlYRXUyV1RKd2h4RzFnY0ZFTkplTzJIaHIvQjlaMnRsYWZ2bXZIMnpwVndK?=
 =?utf-8?Q?EMDACIyStTXk1RV1WPZz3ns=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTYvakpmWHd5SGFMWWRYdUN0TDZOMk0reW9pckowVUhKSzROQm51UHhVdTBm?=
 =?utf-8?B?UEo0WWU1ajc4RWpJOWE1K0JvRW8wTmZ3dXN1TTNPTmF6dWVtdndnL3B1SUpB?=
 =?utf-8?B?WFNvaGU3WkVWN0JGU0pWbVBMdUw2M3ZWZG5IOXQzSHJOSDFrckxmeDFaVng0?=
 =?utf-8?B?bEFNQ2lmS2ZuUFZESWFDR05FOUFZYkxnN0ZXaFcyakowd0ViZlI0cndmSW5n?=
 =?utf-8?B?MXBkeGRxR3d5NGhGakR3TlVWWDZXRTVJUEZESVhETVVOL3c3UFBFbnVHY1Rz?=
 =?utf-8?B?cDJBSEVnUjJlMzlxV1F2aVV2ZWFCQ2NXdTdXdVA5Zjd3cjVwV2FYWVJvdElW?=
 =?utf-8?B?cXdUd3hESmoybzZwbUZqSDBqTDNYRGh0eXUwOVMrNE04UmlYTUlqUGhkTFpO?=
 =?utf-8?B?eml4WFhyZGRXd2xINFdvYURrZ1ptUS80WFNFTUJ3eklvRzFuaWV2T25KRGp1?=
 =?utf-8?B?VWxpaWVaaE10VTFvbXVKTCtoU1RhdnVSdkVCelJpNjBYNGVIbkdvZGo5OHlw?=
 =?utf-8?B?bkFZTCt2c2NBUG02aEpkemtISnNPdzVndnVsaEIyYlFDWHRhRjRMUlpzYzZi?=
 =?utf-8?B?cEF3TVU2V3AzOGtYRTVkV1FUdWp6WFZUOU5hN0lyODlCdDlDMXRpYlhUL3l6?=
 =?utf-8?B?TU5MMkpBRmJEOSs2ZzZjTjZycWpzUzVGQkU4WEFHdFZ0dnVPUGhlRmxTRVR0?=
 =?utf-8?B?QVEzd29UWVVvZUt0RjBnTGJEdkw3LzlOTFBPY1lSaVp3aE94MnJGYWhUblJP?=
 =?utf-8?B?Sjd6UlAxMVNyZFJ6UFNuOTFlTGErVWg4OTA3b2xNMUNOdVlNalhxd3E3QmUv?=
 =?utf-8?B?ZmxJYjNGc3ZuRnd3VENoZUo2MFF5ZVRMYXdJZGozdWIxdnlKRW81Y0R4dU5p?=
 =?utf-8?B?VUVKUDVpTEx2c285eUtiQ3EvK3FxUXVQOUNsWDdHQS81UUNVelYyMjFCQXlZ?=
 =?utf-8?B?ZzlpbXJZWWltcE0wT2E0Y0ZGbkU5MC83Qmt0c2NNbDFseGRBRzlTTkJDQndu?=
 =?utf-8?B?YjNDRGwzVWc0Tkp3V2ZSU3VtejU1eHdiUmsyeVZkNHkwSlk1UnZVZ1BKSkxT?=
 =?utf-8?B?djBQOGdVNTA3TFg5aE9GVEpwU1BUcFBwQk12VmtWY3EweTZQaFRUS2FhejFK?=
 =?utf-8?B?TnFKZm1iYVZhN01pY3VtcjZIVkxRNWlRVTlYdlJYdVBnbFIvRnVjdW5tVDFY?=
 =?utf-8?B?M2p4SnZNclBmYnlrYjhNbHFnemZSRStadExlNjluMU8wZWF5bDExS2FVRmdi?=
 =?utf-8?B?VndNZkV3bTdCNldsbFFRV00reCtES004TGVGUi94THdKNEpnMzB1U1RBcE1k?=
 =?utf-8?B?RGJFZ0J0L1RLRkEyR2NtVU42S0FQUS95V1FWbUtuRm03Q1NjWktSQTlmNVhK?=
 =?utf-8?B?MTRQNnhDUFg4U0puYld3ejQxbEpWa2FESHJheEpnL2ZUWXU3NFZacnk5aG16?=
 =?utf-8?B?TXFJMHpEaXlGdzdZdG5udXdrMEovTDhLcWpKY3J4aHRreVB0aHBiR1BPdGdT?=
 =?utf-8?B?UFZOM2FleUIyWU1tUWZOdE5WK0tQVVRGdGlTRjBOWjJyc2VzWW9LL1RrQm52?=
 =?utf-8?B?R0hFSTlDZkdHcG5LTHUxQzJ1SitkQTQ5eG1FZHNLUmpOekkzYjN4K3hrNHFx?=
 =?utf-8?B?Q01kdE9IeWdNSUtkeHA5amovdVkrK1FRY3NUMDVnWVJRTHcrZFN6M3RYa0pw?=
 =?utf-8?B?OTNldUY2SHBMK1lKMlBVQkVBaTBSWmpFTnZNQVl6cENJSVJLSWgva09oZU1v?=
 =?utf-8?B?dGFwc0FwZWhIN09Kd1hlSWFVcUFKV2MwaFoxV0N3RXZLRGQ1d24zaG1WWW52?=
 =?utf-8?B?M1hjazh5bHlWT2g0MkdhbUlCZnRpQy8yRHF5a00yTmpLajRnMko5cExIczU4?=
 =?utf-8?B?TEpQMXlyQlBjMmo0bVZ1eGl2Ri9SbXhqRWpiQjJTOStteTlNQVkxdHdNNlBr?=
 =?utf-8?B?N1BzUmFSSFlEOFprNndlVUswQklTZVZGRmtnRks0ME1YNmFxL0VOL2lrTkQw?=
 =?utf-8?B?LzRaNzhxU2hVWTJ1REs2cHMwWVk0dWh2ZGFkN3hEUTZZa3k4eXg3cjRIQXhq?=
 =?utf-8?B?MHNtRVpLZk9abWlqcldaR2R0RVEyT0NlVmk4UWFrQVE3TWZuRFRBNzlsN0xk?=
 =?utf-8?B?ZkJKdTJVaEhHTHJhYnA0U2huNkNpbml1SzFnQXFJREI1QlVRZW1pMXdCMTBq?=
 =?utf-8?B?MjFSVy9pSzhMS2QrWFhZRzFBVVgwYjMyTi92VW1QY1pMUENuQ0l2WTNHdXE3?=
 =?utf-8?B?RnpzNEJ0ZUQ3TWgrelpucERnM2dJdkVaeVhkdkxoM3crbE0weFVFeEZ6RmNH?=
 =?utf-8?B?djVoNFRHNGhWYVNGc05PeHdoblRjY1pqbDB6eURNWXBjdTlpby95dGhaT3R4?=
 =?utf-8?Q?nJrRAZNGL+97hNvU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fc4bf1-f534-44c1-34f9-08de6b5c3f05
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2026 00:01:47.3096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SnJdy2cPlvyB2AHjtPIqlO2lrVib2i7ELOTlwG3Qp1QROH5GamQTfdQbNDIzspGQOV6SpJPjtZoPa/vOJcik/pwd2nc7+CtnkZleaaf1+ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2FCF00E1F
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
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71077-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 15C3413A187
X-Rspamd-Action: no action

Hi Babu,

On 2/13/26 3:14 PM, Moger, Babu wrote:
> Hi Reinette,
> 
> 
> On 2/13/2026 10:17 AM, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 2/12/26 5:51 PM, Moger, Babu wrote:
>>> On 2/12/2026 6:05 PM, Reinette Chatre wrote:
>>>> On 2/12/26 11:09 AM, Babu Moger wrote:
>>>>> On 2/11/26 21:51, Reinette Chatre wrote:
>>>>>> On 2/11/26 1:18 PM, Babu Moger wrote:
>>>>>>> On 2/11/26 10:54, Reinette Chatre wrote:
>>>>>>>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>>>>>>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>>>>>>>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>>>
>>>> ...
>>>>
>>>>>>>> Another question, when setting aside possible differences between MB and GMB.
>>>>>>>>
>>>>>>>> I am trying to understand how user may expect to interact with these interfaces ...
>>>>>>>>
>>>>>>>> Consider the starting state example as below where the MB and GMB ceilings are the
>>>>>>>> same:
>>>>>>>>
>>>>>>>>       # cat schemata
>>>>>>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>       MB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>
>>>>>>>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>>>>>>>> MB limit:
>>>>>>>>          # echo"GMB:0=8;2=8" > schemata
>>>>>>>>       # cat schemata
>>>>>>>>       GMB:0=8;1=2048;2=8;3=2048
>>>>>>>>       MB:0=8;1=2048;2=8;3=2048
>>>>>>> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.
>>>>>> Thank you for confirming.
>>>>>>
>>>>>>>> ... and then when user space resets GMB the MB can reset like ...
>>>>>>>>
>>>>>>>>       # echo"GMB:0=2048;2=2048" > schemata
>>>>>>>>       # cat schemata
>>>>>>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>       MB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>
>>>>>>>> if I understand correctly this will only apply if the MB limit was never set so
>>>>>>>> another scenario may be to keep a previous MB setting after a GMB change:
>>>>>>>>
>>>>>>>>       # cat schemata
>>>>>>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>       MB:0=8;1=2048;2=8;3=2048
>>>>>>>>
>>>>>>>>       # echo"GMB:0=8;2=8" > schemata
>>>>>>>>       # cat schemata
>>>>>>>>       GMB:0=8;1=2048;2=8;3=2048
>>>>>>>>       MB:0=8;1=2048;2=8;3=2048
>>>>>>>>
>>>>>>>>       # echo"GMB:0=2048;2=2048" > schemata
>>>>>>>>       # cat schemata
>>>>>>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>       MB:0=8;1=2048;2=8;3=2048
>>>>>>>>
>>>>>>>> What would be most intuitive way for user to interact with the interfaces?
>>>>>>> I see that you are trying to display the effective behaviors above.
>>>>>> Indeed. My goal is to get an idea how user space may interact with the new interfaces and
>>>>>> what would be a reasonable expectation from resctrl be during these interactions.
>>>>>>
>>>>>>> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.
>>>>>> hmmm ... this may be subjective. Could you please elaborate how presenting the effective
>>>>>> settings may cause confusion?
>>>>>
>>>>> I mean in many cases, we cannot determine the effective settings correctly. It depends on benchmarks or applications running on the system.
>>>>>
>>>>> Even with MB (without GMB support), even though we set the limit to 10GB, it may not use the whole 10GB.  Memory is shared resource. So, the effective bandwidth usage depends on other applications running on the system.
>>>>
>>>> Sounds like we interpret "effective limits" differently. To me the limits(*) are deterministic.
>>>> If I understand correctly, if the GMB limit for domains A and B is set to x GB then that places
>>>> an x GB limit on MB for domains A and B also. Displaying any MB limit in the schemata that is
>>>> larger than x GB for domain A or domain B would be inaccurate, no?
>>>
>>> Yea. But, I was thinking not to mess with values written at registers.
>>
>> This is not about what is written to the registers but how the combined values
>> written to registers control system behavior and how to accurately reflect the
>> resulting system behavior to user space.
>>
>>>> When considering your example where the MB limit is 10GB.
>>>>
>>>> Consider an example where there are two domains in this example with a configuration like below.
>>>> (I am using a different syntax from schemata file that will hopefully make it easier to exchange
>>>> ideas when not having to interpret the different GMB and MB units):
>>>>
>>>>      MB:0=10GB;1=10GB
>>>>
>>>> If user space can create a GMB domain that limits shared bandwidth to 10GB that can be displayed
>>>> as below and will be accurate:
>>>>
>>>>      MB:0=10GB;1=10GB
>>>>      GMB:0=10GB;1=10GB
>>>>
>>>> If user space then reduces the combined bandwidth to 2GB then the MB limit is wrong since it
>>>> is actually capped by the GMB limit:
>>>>
>>>>      MB:0=10GB;1=10GB <==== Does reflect possible per-domain memory bandwidth which is now capped by GMB
>>>>      GMB:0=2GB;1=2GB
>>>>
>>>> Would something like below not be more accurate that reflects that the maximum average bandwidth
>>>> each domain could achieve is 2GB?
>>>>
>>>>      MB:0=2GB;1=2GB <==== Reflects accurate possible per-domain memory bandwidth
>>>>      GMB:0=2GB;1=2GB
>>>
>>> That is reasonable. Will check how we can accommodate that.
>>
>> Right, this is not about the values in the L3BE registers but instead how those values
>> are impacted by GLBE registers and how to most accurately present the resulting system
>> configuration to user space. Thank you for considering.
> 
> 
> I responded too quickly earlier—an internal discussion surfaced several concerns with this approach.
> 
> schemata represents what user space explicitly configured and what the hardware registers contain, not a derived “effective” value that depends on runtime conditions.
> Combining configured limits (MB/GMB) with effective bandwidth—which is inherently workload‑dependent—blurs semantics, breaks existing assumptions, and makes debugging more difficult.
> 
> MB and GMB use different units and encodings, so auto‑deriving values can introduce rounding issues and loss of precision.
> 
> I’ll revisit this and come back with a refined proposal.

Are we still talking about below copied from https://lore.kernel.org/lkml/f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com/ ?

	The MBA ceiling is applied at the QoS domain level.
	The GLBE ceiling is applied at the GLBE control  domain level.
	If the MBA ceiling exceeds the GLBE ceiling, the effective MBA limit will be capped by the GLBE ceiling. 

Reinette


