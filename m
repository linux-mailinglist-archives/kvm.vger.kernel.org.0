Return-Path: <kvm+bounces-54863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E26CB29814
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 06:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 030313BF8AE
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 04:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC46218E97;
	Mon, 18 Aug 2025 04:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U22rY9n+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C26279F5;
	Mon, 18 Aug 2025 04:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755490842; cv=fail; b=cDUp7gRxb704ZLBr/MJ7Gz+24FXeV3KMzpnGoZzSKVingGu8t/EZNhOKUjTFGWw2DLlfpvWGyXiYjO1T06MjSbwxuRRqIosOQS9mOxH25zskZdOIyUWZbWrmepDFRd4ss3UTTnf3KNA9jo0oGfpAaH9xy/oylBkbw3lRQxR630w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755490842; c=relaxed/simple;
	bh=3Dh4vAaV6K8fAXpd8BOqwicDopjokptc2XAhE53WrDE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gZySIeWzUdw073ge5BEV31jCBFaFg1fPzkpXfAgoivBVwk5eTWMffiJ+NZ6jUano70GDoyo4RV+ryrJ5oenvz/qQ0UKDycBkvPHOBPcL55JnddBvxk+Zadwjk1UiZECE0SIsJJUz/cNMHbHYU1VGaU/9DLxczd8IPxuz15O91ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U22rY9n+; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755490840; x=1787026840;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=3Dh4vAaV6K8fAXpd8BOqwicDopjokptc2XAhE53WrDE=;
  b=U22rY9n+SDv/mvPxfumEdcfxnoIu6uzGwPggrqXXbS943ckbFPBdOvjh
   b9abmiKnbt2Ap6jytplAXmrVoEblGsRHRjuKPFYp1KqPHQITE6OX8EArM
   dlboD2qDL2ptfY8wu9/zeo733HcX2/n17jpdVhPG0Y0MmUKWDI9yS9QJc
   CyAGfSv5cDzFQ4ZWcpQVvDRNYsdwI1bqDC2rU5PMNa1yYIthoX90qDpo5
   OIm619ou2DEzm147gRoz303MNvHdjeo68RXed8AwqPQduCSN9e+O9y92e
   YTutHArlJauAyoHg96TXWj5/MzOwaI5+A3eC86Yv+XKamFiTHDztW44C+
   g==;
X-CSE-ConnectionGUID: PL362IxGTX6ERlmo725zDg==
X-CSE-MsgGUID: YV/mLNqiTtKjb7wttHREig==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="68420127"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="68420127"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 21:20:38 -0700
X-CSE-ConnectionGUID: 2WitjwIWTKy0W58p3CCEQg==
X-CSE-MsgGUID: OwzsqElRTGOh6qKlZlxjgA==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 21:20:38 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 21:20:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 17 Aug 2025 21:20:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.50)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 21:20:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pR7o3Xe6EB0aLUhErWRtBJlv7FZx0i2TTvJKU4p16Ow95VhUDekMAg+ZUsvhB0ASBMLl33SAC048tQcHRQBfKGeuL1MCuxSr547FApImGwOZR2kd9Bu/eNAl3VO/GSESCY1OnVYUCoxKhAHuQDXvf7HAqzTdYeZXlbpbGEMhDdumOSyGGHsRtHK2/3QRgUz59R0jvPIWLHOiJc65a7A4Fuu3xjjhfg150E5jNpwYPyJQ4f87lKAvGdvrR6wChMnfc0z5jfGKHeL7nct//bQrZZk0Eyz0l7jrTOEap6pimmaH2Z7C/7y6kz8QzznV4iwv+m+b4T2joumyN89tMF9V7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/TRkj/CbGAp7UJLka//rBdAp+WdFuK9TnIhZwRVVh0=;
 b=l2VpoiOBAJdWYPfShzIMjhcVLwytUn1eHD+J8HGceQ+R3YzK+f9l1haUjfDRFjn+W7opYhOndUzQYsvt2EU6aGOiSVd2FE3DiNNnotEPFETmmx0hJeMCPusFzUdjPnGN4LoZYQ3JNVZlBayrauBHuGsO5HM+DgqwkucYsSkR2ixu/uU8dsfCIFvcmse5Mtw1OibKMmZ5blWSGb+Z8/Rttq33FwJ447Q4mQBMJIWSO/XKhB9C/QpYVLQ26SBqKGZbfAFvdTr848JvUWblflzIOi8rk/RH5mn0SdgB9pXz0tBIwDr/i9+FJX5kUzITqWOFCvvfbunrLqOOYut1QR/VpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB8333.namprd11.prod.outlook.com (2603:10b6:208:491::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 04:20:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 04:20:29 +0000
Date: Mon, 18 Aug 2025 12:19:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 22/23] KVM: TDX: Handle Dynamic PAMT on page split
Message-ID: <aKKp3fyoYgaaqidm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094616.4776-1-yan.y.zhao@intel.com>
 <CAGtprH8a4i-U-4Z6=Bk87FsC2nG+UbTVWB1Sc8oYXMJs7pHUwA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8a4i-U-4Z6=Bk87FsC2nG+UbTVWB1Sc8oYXMJs7pHUwA@mail.gmail.com>
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB8333:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d39086d-44c8-4dd6-44d5-08ddde0e906d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M2cwOE1EcnZ1VnlNWWQvcVFsTWxGclhLdGRjS3ArQ2RWL2JZVFpGajJuYzlE?=
 =?utf-8?B?bUthb0lFUlJIWnRLMjNxUzBFVXI1RVBKNm1SekV2T3I2Snd3TWpNOG5wWVlp?=
 =?utf-8?B?MjVpTU9HNHNNZk10NC9neHNVL1VFNkpXM211dzc5WTU2ajdHbjBWOXYxQ3FQ?=
 =?utf-8?B?VHVYRGphRXY3SWtWeFBObG5vVFhQa01zMTdKMlZpVk85Rm1ma3hTYW1UR0xV?=
 =?utf-8?B?UGE0dFhrMUkycnR0ODlTYUNJR3I1N2poUWtuSUo3Yml1eWFhY09VVlRsVFRI?=
 =?utf-8?B?TjcwV1k0NTNpOW1FU2ZSK1Q5aU16YnRUTytIZm4zdk9qU0VBZURzZndWbTZ2?=
 =?utf-8?B?UmNGbUJFdXp2QjNGVXFscDhRa3MvNXBOMDhwVWs0cDE2MGNpR2k3b3lsMUhZ?=
 =?utf-8?B?aGFCbENHdkFxS0NINnVQY29sWk8vQTZJWXN2bWlIN3gvNWhCUi9HOHlXRWJs?=
 =?utf-8?B?OFhYV2FSREd6TlA3YU00UmNRUGdSMHAydUZWMndGMUZUSEEwUVlUVm94Zit3?=
 =?utf-8?B?T1Urb2E3SHZkTnJwTXBzbXVFY0xCeGVFRUwzQ3JaK0dWa1ZQeStnRVRUTDNz?=
 =?utf-8?B?TThFR0tKQzRYTEcwK3U2Wkg4dzB3c0sxRWtDRDY1czFXQnVCdGxnSVlkeXVU?=
 =?utf-8?B?c0xxUlRqY0lubzZETk1DNlFyM0hzQit0UmR5ZGFFbUdJQ09OOU1wMitkUjAx?=
 =?utf-8?B?cWZ6SVdMUmN1UmpNZFl3Z3lGcDRoS3NZaGtFWXJJSjNGdWFvKzYzWWFZRXBi?=
 =?utf-8?B?SVJyZ3BaQVJRYS81VVAvQkZyTnhaS3B2ZTNsQWpDcGZHaHM5UTM1TW9UN29i?=
 =?utf-8?B?Z0poRGtyTmVUUkRqY3ZmZ1BGbmhnTzBCTHl0MzJyZk9WQ25iUFptWmlwL2Na?=
 =?utf-8?B?Rjl4NXkyVEFXZ3BOOFVIbHVBVStCMnlscFd4WWg3QXIwUHJSbWRSYm9Hbmhs?=
 =?utf-8?B?ZVlyZEl5amlVaTEwbnFpK2VCSXlJeG1GNkZHTDBuSkdRL1JWaVRyTTZRc0dh?=
 =?utf-8?B?bXhUbDYwaWs2d0xtVjk3eXRzODZxbGt4b2RLaGhCTEdjUGtuME1ldWNKNEdN?=
 =?utf-8?B?TnR4a1Z3T0FNOXBNV0RoOVFCMDJyd3I3djNVMUxkdVV3Um5CRlhaMDNDMnZR?=
 =?utf-8?B?alIyRmo0Qnd2SjFwWllwTkZQaHo1ZEE5OURYcWVWempjQ3dDcndtdXhRaStL?=
 =?utf-8?B?ZEc4K3JVanZFMzJkRHNSY3l5RHZDMzJReDIzOC9kUngzVUFZQUN2MFN2bWpl?=
 =?utf-8?B?SzhHNDgvcjBLdDNObWJVa0FXT0tzTFQzQWhVeHNqM2VOOENDSXpwQXpYVEEw?=
 =?utf-8?B?MUxSYSs0eUxwclQwajZwR3p1cHJEVlFPYWVzc2dJTG1oUlFsVGM4Q2prVy9z?=
 =?utf-8?B?NUIzVExDS1Rta0JoNXNCTm5MMFU1TnJBVjd2cXJlWG1XY2xKUnQ2SE5PY2oz?=
 =?utf-8?B?cXVHZ01kUHVhdDhxQ1RzMzNlUC9HMUFXcEFHN3NRakVIYkNvN1hoT05rcDJ5?=
 =?utf-8?B?aHh1em8ycUhkMkJrQS9pVitUMEx2RjlzRGQzUkFvcm1BTUJ0WStSMFdGNmps?=
 =?utf-8?B?b21DWDFVSjB3bVhJYUIwUEJQV1JQVVZ2cDE2K0JOSTg2bWFsam5sT2ZwZm9V?=
 =?utf-8?B?ZXljaThneU9NSTR0cXhSQ3BUUmt6ZmZsTHY5RFd6QlpjOEFNM1dWaEg4S0NV?=
 =?utf-8?B?QmZzMUFOTitoTjkwTGpFN3FlSjgxR1dlUnRsektCNlh0NlA2TSs4MHpJeE5j?=
 =?utf-8?B?MENEb28wTzlBUUVmbUdaUlozQ0lzTm0wKzB2N0RSakJORVhEUnByVzR2YXc0?=
 =?utf-8?B?QWkrdEdIS0RBc2hWL045UUE3UHlvTzBvUi84dmtxQzNYTzl6OFQvQjE1MGE0?=
 =?utf-8?B?Z25NYkM2dldOcTc3b0JSV1gwSTg0SUNXVnI2OUlNam1rbnNmQ0hKVzdHUjFy?=
 =?utf-8?Q?aaEgsiwEiws=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzFUdE91Z2UycFY4amQ2QlJ4SmlyTWR1eHNSYkpwTUUzd0F6NzJHSXVlTDNz?=
 =?utf-8?B?RTk4WEgraVNvSHAxdGx3MkhjQWJCWjUwN0JabkthZEtqc1FZeW05VWZFNGxQ?=
 =?utf-8?B?U200OGw4SDA0d1pKRVdab0lGdWZOY2FJY3d1dDNINWFQMENuNVZVK3VRdHpN?=
 =?utf-8?B?Mk55VHJPTzBFV0w0NzVsanV1NDdDUG5EOEdCSmg2NHNTNkxtckwzeFhuQnRD?=
 =?utf-8?B?ZEFjKzNhb1lhL0pkMXNIUDdhK3NOUHV4eU9nWWdlU1Z2K2RJMEVsRkNDSENx?=
 =?utf-8?B?RkkvNXJyTWhtSXVVK3Q0REpZVU1IZE8zb0lkZWRpUGVqdHZyV0x4VlBsbS8y?=
 =?utf-8?B?TUY3c1V0dXgxZGxrR3FLdDZ6SnBwWi9QVlU2MHVucEMxWldiU0daTUxPWlRk?=
 =?utf-8?B?enhBM2tIWlRnRkZyZUVhTi9qa3djVUppS0JCU3k1OGFBWUEwZ29FQ1lLY3h4?=
 =?utf-8?B?blRYVXNnbDBHL3lCN0dNaVJuSk9ucVJKbGJPcU1NY0sxK0tZb282ZVBvajRt?=
 =?utf-8?B?K3dSV0tTdkp0cGg2WUcwb0NGNlNscjkyVmF3WHU1MUY1VkpBVXpsWCtwbzVW?=
 =?utf-8?B?RzRoTDNGMlVyRGJqK05LODAyTng4N01JaEdCcGVIeXJNNytPNWg0NjE5d2hx?=
 =?utf-8?B?RkxlV2FuV0tJSnBKVHYybG5hamVWeVptMmZ1RFY2RGJXOURUTzVLQ1h5d2JE?=
 =?utf-8?B?WTM0NGZDTCtYMzdnVjhCa0I3S2tHcGxST2dtYzkrNmtUeEpnWVNyUmVlc3ht?=
 =?utf-8?B?VXlncjhRbGluRXhmQnVzbk1sb3grV3Z1QWsyTEFENzVSU3ZFRVB3SEU5RkRG?=
 =?utf-8?B?ano4UjlQQ1pMdTZuT2dSblJ0T1lsbFVjRGdzT3BQZzZDb2dtb1owRGV0aEYz?=
 =?utf-8?B?R2hGU3loZ08ycVVCR3M3THZIdGlQak8zVXF6bEk3MkM2VHNqcllIdVN4dVFY?=
 =?utf-8?B?SXBKUkwwZ1p5aUdlSUpicC9VUXdxTHd5ZHNZc0RmSjdCT1RNVnlkZFJiRm84?=
 =?utf-8?B?dForaFN3UCtSK2RBSXlZemtuTTdGWU81SGVZUGlvTWNqaEdzN1VsenpuTHA3?=
 =?utf-8?B?UDltWVQ2QzR0VEdFSEN6OStIekkra1crSk9JRThyc0phZW5naGwveXVRTE05?=
 =?utf-8?B?S0ZTd0N3S08vQkRyU2dBazhXK3pxOTB1MWRDSXlHSnROTVRwZ3d1M0FvdHcz?=
 =?utf-8?B?cGxpMURLcnZuYnBiUHgzZnQ4VlVKVy9LcGdwNXVyWGdxeWZ4WEhNTWlENm1k?=
 =?utf-8?B?TEdIZTM4R09VNHVHTkQrSUpvWjd1aXpocGs0U3N4Y0oyeXRFRWtCR1RraGty?=
 =?utf-8?B?b2pCbmZzM01GcWRFT000UEpuSEhzREpDNTJodTlDbUJFeENabVlMdFRuRlg3?=
 =?utf-8?B?d2d6azRmZDduR0MwdkF6SHBFZTI2anFUNGFMbkVSemprd3RWdE5IZlFTV0xj?=
 =?utf-8?B?WTYza2hza1VkODMrRG1aclMrSXNzWWFXSzlCczY3QUpLR1UzQkVDRCtYMlEv?=
 =?utf-8?B?NHBuamYwK3Nxdlk4dUJIZ1pCZ1JyMFpDeDZYOWVvSm5yVVRwZDJUYTlFMGFQ?=
 =?utf-8?B?bkwzWFFoamlVNWo0RXlaWlJxanE5RFplMW1hSUlScU9GWTZTMjhHeStiYlEw?=
 =?utf-8?B?dmtwMjNLT3RscGRxMDJGZ01xc1VqY3VEZUlvK0puTUZRaHNpaUpkYUNYUFBE?=
 =?utf-8?B?bWhYRXVpaUpxZXZ4VUU1TmxBM3dqWE1IM29YQWdZRlNKRzNKbDZsN0pTL0RJ?=
 =?utf-8?B?ZGgyNm5DUzB3U2l3ZWFJdWR6Nkp4QXdGTXhFWlBSU2J6M2g4Z3gwanpkb05u?=
 =?utf-8?B?Zms3M1NRN0tvOGE0b2hRT2NLQ3hkd1gzMG9qQjJDUjkycnZEN0Q2cGFSV1Z2?=
 =?utf-8?B?dHNKOTlNVytZSjE5YVBUeldtRVNuMGNncXVHcm9iaVdQMkpGL0wrUVlpZWta?=
 =?utf-8?B?SnRRYlZHWldnVWN4SExSU1RuVDRlRVNSclEzVFN1ZTk2dm80NTBNdytEN2Jr?=
 =?utf-8?B?T2dpUmVodVFTVHRwdlFJNG5BUEFxR1dWR25IUHZLR1hjV1pPKytLWHhacHgv?=
 =?utf-8?B?UHZvTEJsTWk0cjJpRUwxejJ2TTFDSnhhZzkrNXV0Z0xDMjhzaldOdVl4TUcy?=
 =?utf-8?Q?le7stNFdKDfIc9jnO8ZIFF8GO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d39086d-44c8-4dd6-44d5-08ddde0e906d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 04:20:29.2945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNQDH6ScmFJr+nToJNnpnA44QorMF+ijDimp/Bd3L9Ov5Gd8ZAcMusEclRoYrL+aXPcik15PAVH8+JbHDGkY5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8333
X-OriginatorOrg: intel.com

On Wed, Aug 13, 2025 at 10:31:27PM -0700, Vishal Annapurve wrote:
> On Thu, Aug 7, 2025 at 2:46 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > +static struct page *tdx_alloc_pamt_page_split(void *data)
> > +{
> > +       struct kvm *kvm = data;
> > +       void *p;
> > +
> > +       p = kvm_mmu_memory_cache_alloc(&kvm->arch.pamt_page_cache);
> > +       return virt_to_page(p);
> > +}
> > +
> >  static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
> > -                                       enum pg_level level, struct page *page)
> > +                                       enum pg_level level, struct page *page,
> > +                                       kvm_pfn_t pfn_for_gfn)
> >  {
> >         int tdx_level = pg_level_to_tdx_sept_level(level);
> > +       hpa_t hpa = pfn_to_hpa(pfn_for_gfn);
> >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >         gpa_t gpa = gfn_to_gpa(gfn);
> >         u64 err, entry, level_state;
> > +       LIST_HEAD(pamt_pages);
> > +
> > +       tdx_pamt_get(page, PG_LEVEL_4K, tdx_alloc_pamt_page_split, kvm);
> 
> This invocation needs a return value check.
Ack.

> > +       tdx_alloc_pamt_pages(&pamt_pages, tdx_alloc_pamt_page_split, kvm);
> 
> IIUC tdx_pamt_get() will result in pamt_pages allocation above, so
> this step is not needed.

This step is to allocate pamt_pages for the guest 2MB page that needs splitting.
The above tdx_pamt_get() is for the EPT page to be added.
I'll add comments or update the param names for better clarity.

Regarding the absence of return value check for the tdx_alloc_pamt_pages(), I
think it's because the tdx_alloc_pamt_page_split() retrieves pages from the
pamt_page_cache via kvm_mmu_memory_cache_alloc(), which is guaranteed to succeed
(otherwise, there's a BUG_ON() in kvm_mmu_memory_cache_alloc()).

> >
> >         err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
> > -                                 NULL, &entry, &level_state);
> > +                                 &pamt_pages, &entry, &level_state);
> >
> >         if (unlikely(tdx_operand_busy(err))) {
> >                 tdx_no_vcpus_enter_start(kvm);
> >                 err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
> > -                                         NULL, &entry, &level_state);
> > +                                         &pamt_pages, &entry, &level_state);
> >                 tdx_no_vcpus_enter_stop(kvm);
> >         }
> >
> >         if (KVM_BUG_ON(err, kvm)) {
> > +               tdx_free_pamt_pages(&pamt_pages);
> 
> If tdx_alloc_pamt_pages() is not needed then this can be dropped as well.
> 
> > +               tdx_pamt_put(page, PG_LEVEL_4K);
> >                 pr_tdx_error_2(TDH_MEM_PAGE_DEMOTE, err, entry, level_state);
> >                 return -EIO;
> >         }
> > +
> > +       if (tdx_supports_dynamic_pamt(tdx_sysinfo))
> > +               atomic_set(tdx_get_pamt_refcount(hpa), PTRS_PER_PMD);
> 
> Should this be
> atomic_set(tdx_get_pamt_refcount(hpa), PTRS_PER_PMD -1 );
> 
> as tdx_pamt_get would have increased the refcount by 1 already above?
This hpa is for guest 2MB memory range. There shouldn't have any increased
pamt_refcount for this range before a successful demote.
So, atomic_set() to PTRS_PER_PMD looks correct, though atomic_add() seems even
safer.

