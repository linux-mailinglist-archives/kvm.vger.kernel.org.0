Return-Path: <kvm+bounces-63745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E5CBFC70BD2
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 20:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7A6454E152D
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 19:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E3C534B420;
	Wed, 19 Nov 2025 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LToKzBoF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCAF361DDA;
	Wed, 19 Nov 2025 19:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763579460; cv=fail; b=QAjgTpxwC/NQXcJUDdbuhxe7r7k4KwxO6D32xXXztVKh+Ps+n+afR1HDAbYEKA/tVZsxE4ANgpBUVCm9gf9WfMxz2BeMzlEX9FNxmnwX2/KV1Mk+ywkDxhudguBkKnK8VvxLFMR1j9glMhHaIPfJ8dOm4vh1M3mKahEshgsl0Gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763579460; c=relaxed/simple;
	bh=WaeMfTsIGjX/i1/Av873hX4IZP0dYHaR2xaheeYozFo=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=YBxQM8INT5YIZvuz+8q8GPFn/mri4Y4Qkb/fcqyapJRoeUWZGFZTmr1lT20oZKsb9b0jV+izyPLzEacF4kTm35xBIOKrv9iTELPtCK8fk2zei94b5MgP44c+gdJkJ0bVtxwwvOhyU4a+Rx2T2RUAUGK86Vnph/BlU2HYQ5vJP6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LToKzBoF; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763579452; x=1795115452;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=WaeMfTsIGjX/i1/Av873hX4IZP0dYHaR2xaheeYozFo=;
  b=LToKzBoFRnJBUGWCYV2i7CYhuslMvKy7pxAKgGFAEov6+/vutDficjd2
   OFGxUD+BfKJjShs8vq4lxNpEAhQ4aX49U935jRlj4WZoez+mXfK/MraQY
   br5Z7j/QLZGioWRjvOyRpASZkh/8Ex0LTVEwjVt8un1Y1XTCcKjyA3SUJ
   BpQxn8vnNQ0IdEkRRdzb8XIM3vEA1R6K6P/ISBJRNgWZIWfoekAq2TDoS
   MGWe4TQ/qDU7g2gBkqgQSF0oSR1wPeHQDEiPB0cYicJv+2toLgKcODBmj
   6HHX/qysEgfzzN1lWmZXhPbAqPima7DxfJDd4+wx9IzZKFO8hI0bM2A3x
   w==;
X-CSE-ConnectionGUID: 765F8M4nQSS1f4d2lpmrOw==
X-CSE-MsgGUID: h0IR37PDTNO/Jf6a47dhdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69251374"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="69251374"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 11:10:47 -0800
X-CSE-ConnectionGUID: uOUxUD9ZS+65O7GC0W/5eA==
X-CSE-MsgGUID: KozS9t5SRMmkyZ6mqGtl0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="191577338"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 11:10:47 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 11:10:46 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 11:10:46 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.18) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 11:10:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTnwcysSS5nYY1X8V1udVPmjGrNn4lLpy09nQYPEyxR2RCP6bGap/he0RK+wHoYTBHSKAxyKX/Cmb+US8HaKnFQRFNLLykFfzHksjwUHUwJ5eHKEBBSBRMUKv+YQ2WHdCyLl5H5fcdc0zFJ6ncCzXa5HL8Mu/cnba/l+wC6+2wlYRaHN6mMs2NCpgBNBQaxqbLDVRDiebTeuwysV8jwIqx3wWNfdd1Z1b/eqauHEkt0IO/NeLBcTyXLHa+i39QLXeC8/+YFDeOVAittTx7wsBsMDlYwAJzixr3/bDMV0foQtnDFMT835b5HDKAGHVWSfeZfKe6/VicUS13yvZU+koA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALAXmDhPaODP7o13Rs/7nhrK1liHi7Rjr6p66iEFnR0=;
 b=dLQTbtS608yoE2YSY3xRGH6svhJN28L2HheoYlxsRE3AiFQcRII5+qKkgrrjC6aSe6999QXfxu3PSPGZCpnwbIJbvGE6fApi/CYeM32G81/QzR/fQ/oykPWVV6y4ETjYn5V1WOGY9ryNx5pDHyt9zi+sfhNJXITLshk+K21/bY0AW3DDaJDcNsa5qHhLulzoSh4iqOmoFDL+UGj5ukZGCXL4nVbOXxTD1sbTENpk0aDsjsy4ROkvzwSuH+6Mw63gXXE1BdSTShvynMzIGEsYxa0EP4TX/bUJtbsXb8ECy9xCReq96MOhsL/qMlTVRvA7e8lQbCbdhrZaA+0ZPue/AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB6055.namprd11.prod.outlook.com (2603:10b6:510:1d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.19; Wed, 19 Nov
 2025 19:10:43 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 19:10:43 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 19 Nov 2025 11:10:41 -0800
To: Dave Hansen <dave.hansen@intel.com>, <dan.j.williams@intel.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
CC: <chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<kas@kernel.org>, <x86@kernel.org>
Message-ID: <691e16318f5ea_1eb85100ce@dwillia2-mobl4.notmuch>
In-Reply-To: <e3830b06-dac8-4f22-bd07-98073886678a@intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-7-yilun.xu@linux.intel.com>
 <70056924-1702-4020-b805-014efb87afdd@intel.com>
 <691dee3f569dc_1aaf41001e@dwillia2-mobl4.notmuch>
 <e3830b06-dac8-4f22-bd07-98073886678a@intel.com>
Subject: Re: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for new
 TDX Module objects
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0163.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB6055:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aa5fbdf-9e9a-4208-bbe1-08de279f5625
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TTZHeWtYRSttN095Y2IzcjBvT2ZCRUkxejIya0hlNExxMm1rUHAwT1lzQVVS?=
 =?utf-8?B?eDRRV09kODhONDd3UnNFbzRwYTllckV1NTB2ekdSZGpZanVIYWdjVlE0V1FT?=
 =?utf-8?B?em8vZDdEU3psNUVCZGk5OVRmWkNvcWh0QXowanZQaDR4VnVWbVRHM3NIbCtW?=
 =?utf-8?B?SkM1NEhCYlhBbDVKWTlOM3RYY01GOVQrbDBpcGxzdmc4MGJ6SWMvbkhHcWNG?=
 =?utf-8?B?dGxpM0ZCMWwwdmFwS1orVm9obmxzTXZFMmRFTU11QlNhdThRUC91aExuTGwr?=
 =?utf-8?B?NEdWd2plblJSWmJxV1k4cmhUWmdld0lEOERVSDFvSDRCajdaT0Z5bjRlTERM?=
 =?utf-8?B?N0hRZXR5MHl3eGtKRW1oQnlzaHF5L3ltNUZxYVcvVXFwS0dUN0tXNlA3RGE1?=
 =?utf-8?B?VHFyRVFOT3g5MTk3R2dtNjh4bk9OZ3JCV0FISG1aWkRsc2t6L2c1SDNwTjZw?=
 =?utf-8?B?UGtzT3U1U2x2SnF3ZUpjQnVMNHVNMW4zVVo2UE53RmJMM2xSeVc4ZXEwQXg1?=
 =?utf-8?B?YzJ5ZUN0YUprR2d2WXRjN0t0VkhFOXovdUpucDgrRG0zUzZqd1RJUzh6Zmhh?=
 =?utf-8?B?aFRGZGtvZVdMNm5ZQ1BpekYvVDRVdll1WWdYNVczc1ZhUzM4cTBDSXcvVWRZ?=
 =?utf-8?B?cDk2RitvK3N5R1M0YS8vYUZReTlWa1pKRzVqTG14U1p4WVhZVmo1WVZZUmFR?=
 =?utf-8?B?NUNFWHVRS21uWmwwUzE3MGlXL3gwZTY0OGh4Znh6QmsxRVBZNHgwaGlmRlA2?=
 =?utf-8?B?RVFsNkRYQW9ycFVzNEhoQzhCTmwzODZNSnFIWnBDZEt1ak5jY0VMUjdPMExW?=
 =?utf-8?B?N29IalNUbXNrMk1HN25QMFVoalFDaTlqb3BMdkhoNmpxMGxuQU5jY254UUNs?=
 =?utf-8?B?WUNiL2JiNlZsbzhUakZnRnpkNHNZU01mVExBN1FqS0RGeHdOVUNZUi85VmZa?=
 =?utf-8?B?bnIyNS9JTVEzYXpQSU5TRHc2c3JnVHdzeDNkZXQ0alB2RXZlMlZFMFFveUp2?=
 =?utf-8?B?OFhrQjd4TW9Uc2FhTlFCNHQrWGFkMGkvSGR2WDRsK2U3MW52NVZYZFdVSE5p?=
 =?utf-8?B?dURCUUN4Z3RyclZOcTNHWDN3cUJFSVJXYlpwdFNkM0FyWnc4K1hwKzFYSWhM?=
 =?utf-8?B?NmN0OXd0RnBnaGVnUk9sYXdLUDVGdm14VExCOEdJVjI3ZzMwN3lya0NCVTQ0?=
 =?utf-8?B?c1loaXFOcHBkQUpXWTZoT3lhdjQ4K3k1M3lqN21LaEtPTWxBa2NmM3JObWNQ?=
 =?utf-8?B?VUhsYldydDJXVHhUREZiQXFnZjU5cHA1TFQxZDFCNUNKMEl5WHBZWUNDVlJj?=
 =?utf-8?B?RS80ZmhIRUM4ZUNmMUtSNlJ5YUFncWhkdlUzYmtIZEJYc0NjeXQ3OWVJNkR1?=
 =?utf-8?B?eDVrV2kyNjh4djM1SjdodmREK3UyRGZJMUJxRnlGc2Y2YWhISVA3N29PUEly?=
 =?utf-8?B?S3BxekxCeVdWUlNWcSs5SEtCRHdDVllsTEc5dFdET05Vc2tZZERNa3pQdFBa?=
 =?utf-8?B?amhrMTNyanlWVk12RnphckdzTGt1UlBQSi8xQU5CWWUxZE9RQ0IzeFJDdkNN?=
 =?utf-8?B?OUZiTmRnSUZkb2Vucm5EWENBT2N6VUZuYytVR1c2d1ZiNzRUVGl3ZmZkT2Qx?=
 =?utf-8?B?anIzTk1VNnY4dGJDUmt1STB2Sm9GL04vdXhoaVFhMFFFYldKMHdjWU1XWml0?=
 =?utf-8?B?WS9EaUc1MCtVR3hQMlFvOWtUQjJMZDlna2cwNUxORkphZk81Rkg5RENkTElZ?=
 =?utf-8?B?MEFuOXg0ZDF5dWdrbW53ZnZtZG1QSmVCMWNpVjlVeUZ2V0JNUDJrNjh5a1lT?=
 =?utf-8?B?YUVWelgxM0JaeXJmZGlBaURzZ0xpdGJFQkRtZEp5SllnNkZHMTNMMmZudkd5?=
 =?utf-8?B?ekE2MmtnNE05Z2YyNkxQSzBiQ2QvdzRKc1B3OXFYUGk4RkNRRzI0N290YlhG?=
 =?utf-8?Q?z7ar6P2aJuPCabcB53YwTeq4szUmIZZa?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czNSazNnNVJmTHl3cDR3OEVPemhhZFdHcjdwbE9VakhiNkN4Vk4vTm1Zc3Iz?=
 =?utf-8?B?RWpid3V6WFVrdkdHR3lJZnpubjkrWWV6QTdya2t4UUhGNVlXcFB2MytMUDkz?=
 =?utf-8?B?Y3ZnT0ZEWUJyaWUvdGZ6UFFNdEpDcndEWHNaVW1sQmxKR01ENmI2cWtETC8x?=
 =?utf-8?B?M1RhZXAvOU02UUtFWWZyS0NmTVV5Z213Q1RZRlVsZnJyWDdPaTA3bkdOU1J1?=
 =?utf-8?B?blJGVk5sckt4WExRbm9PSlhmYnlBQUZNaXRpVVBDZjZwQmhBQlB0QjBzOWt4?=
 =?utf-8?B?NG92TkVpZGlnTVZqV0JVd0UrSkNNbnZoSFdmV2FiS0FGcUtLNnpyc1hKcDlB?=
 =?utf-8?B?ZWViVXUxZHdpenEzZ2s3L082amxURmMvZ3JPTTZWZFU4cFcyK2owUENER1BJ?=
 =?utf-8?B?dkNpMXhlUU9hZ0lwR21VSGh2QnNDZ0o2Tng1RVhMREExcHovZFV0bHZkdFhE?=
 =?utf-8?B?ODZlVmVtTWVFeklmcXFONmtjYkZFWE1qNW9OUWlGREgwblJ5dFJTT0RSOEtG?=
 =?utf-8?B?bEsvcENzRWJEdVR2UFlka0NvcFRycFBqTmdYdUE3b043UFpKdzFJblR2ZDI1?=
 =?utf-8?B?NWNRR3I0OVhYUEtDWXlxbTU1NmI5Z0c0cjF0UzJSaXlxNXZFMk8yUjgvWHhJ?=
 =?utf-8?B?UXhvcTNxNTd0ZURjMlJySW9mbHVLcGhBdGZXdkxPc2xuWTZmaXZPTHlTRDd1?=
 =?utf-8?B?NjRNN2JRaWlwSzJSeXhPNlg2cnJrUkUxVVFnYWRtZFdNdFBWbTV6SVp1YXZ5?=
 =?utf-8?B?RFBLL24zcEZxSFdocFZMWm5YNG9ZSHNMWWlPc0xIMCtOZ0pTanJhbFVnMDNE?=
 =?utf-8?B?bk1RYkxjRXBXeGxUQ0p1ZXgwVjJtYWVIaEFqNGtoa2VKLzJwNGIrbmRMR3Zs?=
 =?utf-8?B?cWF0ejZKY21reG5oSG9odzZYVkNCZ29NZml4OFUzYjIvM3l4b3AzZ09Ub2Vq?=
 =?utf-8?B?M1g5ODBISWNjUEh3M0RWK0tQWklPNXF6TllOUUFUR256RCtkUmY4elJFRGNq?=
 =?utf-8?B?TXpQQnpWVkszbUhDWkN1WTNGMVpIOE0yQTJ0MmE2UWRPa0NpODAvWmhxd0l5?=
 =?utf-8?B?SldYd3BibW5Wd0czcEtzdXNRT2Rsa041b05FV1djU0NSRmRmeVBvM1JzOGpS?=
 =?utf-8?B?a2NNUEdCQS9MMmlJbDNsamxSQWJuQWQ0UE5MTmRxZ2JHM1VBT0ZKRTRYWjM3?=
 =?utf-8?B?TFkybDRHK0JsOHpkR1ZxRFV6YmJvVlRUNjFzdGxvT3JQQzVkOVhCcjZsV21B?=
 =?utf-8?B?bEo5QU9SWU45UDhUT2lLNUIzcFFTVlZFK1BWaXNVTi9KREt6VHBrQVZkVytW?=
 =?utf-8?B?RUQ1T3lsc2pIQS9YZmpXV1FGUGM5M3NuN1hCblV5bnZUc0xIREFVRXRuejZi?=
 =?utf-8?B?QXhwUEd5QjVwZFBONk9FK0wvMDY4RXNQdkdaT2s4czBGbUpIT2RxMmtFZVpM?=
 =?utf-8?B?MkE2Y3ZGOUFUMFBpdEFtdFkzaTQwZHNic1lKbTN5R3JSeERScDlZSm5ydENT?=
 =?utf-8?B?WFlHZUd6MTE2WWMzcGxuSFJGbDZCbVVudFo0VUdPbVdqTFpOWk1iaS9XR1U0?=
 =?utf-8?B?ODV1L2FCNHhyeHRFK0FxQXBWQUxOSGtFYUlaVnRvdWF4R2Ezdkt1N1V5SnhF?=
 =?utf-8?B?RWlGWS95VXlYZHNhU0F2UHdkaU5TSDhxTml1bGZDU3dWSWVIUFcwS1VnU0xO?=
 =?utf-8?B?cytIRENkMW9nQ1NwdFJINmJtSWp4WW9pYkM2b0dGakJySkxBeDY5Yit6d3Z5?=
 =?utf-8?B?Q2NJNHRxcFFMdy9VZUNPOW5sbGswYlIvNWFIT3BoQ3prcndqcnBDRWgrWVo2?=
 =?utf-8?B?N2d1QTBuV2lQblA4U3ZuQU1TbXlUQUYyKzduMlNrL28xOGFqL3VUeHNtdHRm?=
 =?utf-8?B?cTZsRkFKSHNRbVNNUU1GSnlMUXRkalM1YjNqb0ZkZ0NDZnIxUnEvZVB3QVM2?=
 =?utf-8?B?L0NJVVRYRGcvaGZldzRjMGZIaXBwM2xMTitzeVBZL2tERlNMR2hGQUtmN3R2?=
 =?utf-8?B?VjF1Z1RyOVZpVUxTbEpxcEc0NnFRSk83d2o5RHduUFRXRmsrdGVCcHMrMmNE?=
 =?utf-8?B?YXRBc3daTERPTStmOWJ0R1ZSZEU5Q1l3MGFwNnN1Nk1lQTZxNVluaUpmQklF?=
 =?utf-8?B?dzcrc2VZRWl2Ri9FNCswTVJ4SUp2a2luWnF2dS9wYWY3ZEo2MGU0RmRtcmlX?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa5fbdf-9e9a-4208-bbe1-08de279f5625
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 19:10:43.3569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZvyI2F+g8d4cfRxbbMDQPUjRA1xMt9R32mDhC1reuIRHIYoRjRxXU0BfGfCU1OYnaYhh3x1gHppm/HnuoGqpoxrS0dycmYAyNkjFOjMUw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6055
X-OriginatorOrg: intel.com

Dave Hansen wrote:
> On 11/19/25 08:20, dan.j.williams@intel.com wrote:
> > Please document that tip prefers that goto be used in cases where a
> > single goto target can be used.
> 
> I don't think it's that hard and fast of a rule. It's really just a more
> general: use the best tool for the job. For instance, if your line of
> code was already on the long side, the additional __free(foo) might be
> the straw that breaks the camel's back.
> 
> So it all depends.
> 
> In this case, we have very linear code flow, very long lines, and quite
> uniform allocator use (they can all be kfree()). That tips the scales
> squarely in the direction of goto.

In the absence of near term future use cases that will violate the
uniform allocator observation, yes, today's needs can rely on a single
error exit path.

For clarity for Yilun, be circumspect on scope-based-cleanup usage for
arch/x86/virt/, but for TSM driver bits in drivers/virt/, do feel free
to continue aggressive avoidance of goto.

> But there's already code that takes that allocation order into account.
> It's also going to be in this patch whether or not __free() is utilized:
> 
> > +void tdx_page_array_free(struct tdx_page_array *array)
> > +{
> > +	if (!array)
> > +		return;
> > +
> > +	__free_page(array->root);
> > +	tdx_free_pages_bulk(array->nr_pages, array->pages);
> > +	kfree(array->pages);
> > +	kfree(array);
> > +}
> Ideally, we'd be able to define the free ordering requirements in a
> single bit of code and use it in both paths.

__free() does not effect object destructors like this, only the
constructor early error exits. It would be nice to have uniformity, but
that is more something that devres offers rather than
scope-based-cleanup. Devres is not appropriate for this path.

So yes, some mental load needs to be spent on validating the order of
the destructor path.

