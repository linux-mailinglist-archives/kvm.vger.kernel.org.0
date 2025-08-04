Return-Path: <kvm+bounces-53905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE29B1A232
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 14:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFE8D1650C0
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7056625D1E9;
	Mon,  4 Aug 2025 12:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A2wsn7Cu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649B2EEB2;
	Mon,  4 Aug 2025 12:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754311712; cv=fail; b=GFXHaqoY73IEZU2DaDXvOIF4d6qbf1meqBJzYjQGCm+VGt+v0Tl74yMP9wqroynIx+YtyAMic0f/Bm4CdA4yOt2N/tQoqBpTHQ1UorEtCUSCYdKwpwuVmgKuetUAObn2mBwRue46G1w8uXL+wRX4izsJBvRY2RrK50g8ARip7h0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754311712; c=relaxed/simple;
	bh=yBVJVErH30I3e4atgE3UVvSQxEl+0+ybC4YumsVqesw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BhxdSo+7KuVM3hXyKlMUyC52ddd2iGbqrNNR8CrumTVRDriq0crFMza6xTXeEB94O7CEir+Yc5XjlQus9eHhHE1GqJySjUjNNosN4gfyHzCIJ0BYKuTKWLRqinFO1/wOy0PVAYXpHoa6znI6VNXVjZqobrjwFjJJk4KVfm97mhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A2wsn7Cu; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754311708; x=1785847708;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yBVJVErH30I3e4atgE3UVvSQxEl+0+ybC4YumsVqesw=;
  b=A2wsn7CuYEbHFL73kbYK08vt0Rm27JaJB8tbD2wwjtBrVgOJSkEJcQDS
   rWOLNwHxCxJOa+FGSY8Vvs9qgy2ffOkHHIysmON8EqAs+U+pNoqGSptUu
   tTd35JQZlrWo5hxynOT0TvmY2Zr3ihtSCdUp4/MOqv8fAfI3j7a1glU4u
   q5+JEOwYmhrcLgZu7bPxcYC34eQ8pZQf/RU9hXdoeBjHvBnZG9kwS30LH
   oZSlld0U58oKwyzjy17afzp3ZR0GepyvcLL3QbfGUV8zRpNM78GSSkrCb
   OTnHCeVqXig8cuqDBV9H5zC0NXm/66zTFAMuaQTgJsx801mbzHkct+8l0
   Q==;
X-CSE-ConnectionGUID: JUnr2avDQ+ixX8m8T9KdHA==
X-CSE-MsgGUID: /3IErPl+Sz6dT7NO6n2xzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="67151237"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="67151237"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 05:48:28 -0700
X-CSE-ConnectionGUID: hbOBgUyBQ06SIvTPzlcZBg==
X-CSE-MsgGUID: ACv67PEsRVOG6f6A9fpsHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="194988084"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 05:48:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 05:48:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 4 Aug 2025 05:48:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 05:48:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s66ZRLKFtIbiwVWjYQsUxIQFvSg95WhoW1JPyFrWPSFI9OnwH6wmgM1kDVUqZqKw13vm4L6btIjEmNCuab0Qzu+03od7MtGs1Ok1iMKzMqUPiuWyldqtylW1eJgmSVom496E/U4Luh+9cWDwCCVG78Ntu99LSgG5of4J5Ll3VHNZ5UDKsKeLvj0k13ftNbhgJtAV1c2xYuqxXektAipxkJ9Bv8K0SY3lhBXVO76z6drfxEKXfRAO7znSxH28ydJ5Qbn6IC6EhCUuSZ3E9bnwJiJC0fts1HjCearHsWeKsUE7WQNYei6tIDBicIaD32/hFDUQ/X/PH1wJJc1Whi/XdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBVJVErH30I3e4atgE3UVvSQxEl+0+ybC4YumsVqesw=;
 b=OKcRoI99eNzWk0jUv+YXApDvLeFBuGIMMKBl6EQlvXOgdQDiiERyxP/mwceanbaUFOibbzKpiigQ4sZKIl4ttBO5d9gppfeZNhI6ENs2J4p9V+jqpbORlM5556po6N7FrGCOuDCsHTgwDjT6ghGEyNN9YMd6WQqw7d4CvCdg8VV+ZGChza2lQ+mu8D7bJWtVzK0ZlCm5RTYKJJH3fjK35Y8HzMeplj+FCmFN8QfLG5qFeFfs3HTHHSuySF4FK4MSUl+OZKrqKgHLdDhyMgQGGfbdiMhoaNEyQSwIq2xgp/sthUWEnUGa1nMgal/pSA3SYxv6UaX1b7apljZkIrSelA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB6992.namprd11.prod.outlook.com (2603:10b6:806:2b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Mon, 4 Aug
 2025 12:47:57 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 12:47:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb/7MLtHK6BqodHUKBqQjOH+Kz87RNe8aAgAUA0IA=
Date: Mon, 4 Aug 2025 12:47:56 +0000
Message-ID: <f9631567afe3e72e7a99724092426cc06e887ed6.camel@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
	 <03d3eecaca3f7680aacc55549bb2bacdd85a048f.1753679792.git.kai.huang@intel.com>
	 <aIx5jcdZ32mjOfXg@intel.com>
In-Reply-To: <aIx5jcdZ32mjOfXg@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB6992:EE_
x-ms-office365-filtering-correlation-id: 80fc8c7c-7110-4d44-2f8a-08ddd3552300
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QlppWEhHdGVUNFRKaXg4UmV1MHdoZ1ZqNVc1S0I5QVFYNUlzVnVVTmVTdDFr?=
 =?utf-8?B?UTF4dHdVd3lMM3prWmM3TTU5TGRJTkd2TnZ4S2xxRy8wZndkT0NHSno0T3hR?=
 =?utf-8?B?Z2Voenp2V000NXlRZmtEQ0s5WjU3Tm9venhZRVlQUkpSOTBsenlSZUprSGFu?=
 =?utf-8?B?ZUxVZXpwakJlTjhLMzJVZkpMeXl6dTBqS1NwUEg5OHRVRUlZekJIV3R0LzEy?=
 =?utf-8?B?Mk1paDhmeDZpeEVJeFNlQlAyRTFGTDUyN1JYMVl3K0hTV3FTSVlxaGNkb1RZ?=
 =?utf-8?B?OTFIOUo4YkxtQkU5ZXJTa0ZjWlRHTkRzVXZDaFdmWnBsZjRtOTJGL3BjN2Jo?=
 =?utf-8?B?c3p5UzJzSVM0cERvZ0FFbSs0MkJoUitZNVEweW9TVEJzcWxkc2xUT3IzM2RK?=
 =?utf-8?B?azZhMG11VzBYL0pqS3c2ckpkZE00b09keUp6U1lTS053TkdNT2Y3MHd1RHY2?=
 =?utf-8?B?TWxuYVh6ZmtNMDA5WWlwWFpScnl3VVoySVlZWFJXMXZFL3BENWFrSG1lZjNx?=
 =?utf-8?B?MmNQVTJrVFduSWN1cWZneEQzMXlBSEdlaTM3cHdVYmluSnZqNWNLMEgxQXlX?=
 =?utf-8?B?cVN2SW1tTEtOM3pOcGwxcU44MXdWbG95eXN3VGUrQmREcTlCM1BCZDI5K2Fj?=
 =?utf-8?B?Q1dQTEI5aWFocW9aOVRqUUV4L2FHbXhjWHFpS01MQWdMSjNsOEFFRDV1dmVM?=
 =?utf-8?B?SG1xV0hlQ2lRYkJGNXIvZThGbG9lRnFXbm9pa0FyN1d1V2Z2eEVqd0xzK1JD?=
 =?utf-8?B?bTNFTEN1Wi9JenVJY0JjOFdmTXdUVWN4UzJJc082SG5aSEZ1NHZhYVFuQUx1?=
 =?utf-8?B?Ky9ka2xhVFlSR3lSbW0vSVRqL21rL1I1QnZNYVBSSjlTL1c3cDFEcmV2bHlK?=
 =?utf-8?B?OEFMdEI3L0M0aUQ1TS9RdUNhODd0QTlEeE5ZVmFjNHlQNGMxMzRhVFRkYnNu?=
 =?utf-8?B?VkU3aCtqTFBUMkgwMVFpSWN6cXo0OU1nbmtBbDcwVkU2OSt4MTluaW5uWjht?=
 =?utf-8?B?Qkx1TXdycUt5b0l2WVNQbEhtTElJVDY2UVJOZVUwSlloMUdVcDRpODYzWWJZ?=
 =?utf-8?B?NFFldVJmdEsrZEREcE52MDJhYVRldCsvRzhJRUJISlB0Y3ZpbWFxeTJXaHNV?=
 =?utf-8?B?R1N5eFllVUdVRHRwNmc2c1dma3RNclpoMTI4V3FSVkcrNHBnOS9zSTEzLytC?=
 =?utf-8?B?ZVJOeGxsUHFzR3FSbi9DVHdMUWpiUlBvdXVNaEFlSVloNFdMMDJpWTBzYnRB?=
 =?utf-8?B?NzBiQnR0MWQ4OEZlK0o1K2Fwa29QclJTVUt6QkRNSG8zMjFiNUtPcktQSzFO?=
 =?utf-8?B?SXNIczBTWFNCQzJYTFpKR2JJSXJwYjhUTFhQOENWUUlRb042U1Q4d2VSQjRY?=
 =?utf-8?B?bEVTUkwyYnQ1VW9xN3JEMGpVOVlmMDg0MVVoc2JiRGtKdktsOGlZVTR3QjVI?=
 =?utf-8?B?OUFqMml4REd5UTM0Y09aUGJXazB3SGNxUjVyS2s4NkRKbGwyekJTTlE2Szla?=
 =?utf-8?B?d2JhUGhwVXdwOVJpVjNraGhzSEFrL3FkSncwSXJWL3RUWDdvbHlsQ0xGRFpU?=
 =?utf-8?B?UnIzY0RUMnYrazdIU0dqaC9ad1A5dkt4U2hKS1VGMm9pd2o4YW1XbmFyMVND?=
 =?utf-8?B?cjRuSERsQTd5YlBnT1JCcW9wd2JCbjJTbzk2YnZyOFZTRzJtSEM4QjF1NE14?=
 =?utf-8?B?RlFkZFI5QVhFMFRxZ01zcTgwcUhNMW9CV05saTNjdWlHeURXUDFDS2pTUGMx?=
 =?utf-8?B?NG9BRHpKLzhteWpyMkt5STJaMUJhTUcycVE2YkZnMDNoOFRjb1JLUjh4ekUr?=
 =?utf-8?B?cjAwR3lWb3FaRHMvOTkvdzd5anFLT21xNHVORW5CK0pyZjhUbnQrU0dlaTVI?=
 =?utf-8?B?dFI0WlN2N1JSRUxTZ1FWOFdGT0hLZlhBa05EVzNCbDVwUVlnZTJTS2pBR3VP?=
 =?utf-8?B?WVJXcUlXRWl1V3hqMm93OXgwei9UQlVlaFAwNFppb3ZKWnFhUFh4K1ZzWXpk?=
 =?utf-8?B?UXhORTJEWHdBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ums0NFJqdUd1MUFKVjZySzR1enVLM1RQTDR2TlY3eDM3SkdBbE0rVXg2ZDVL?=
 =?utf-8?B?bDMyejhkcGZJTWJZMTdrcEloY1QyTUFXSTAwNkRrQXhWbktIbGNsV3RKcGw2?=
 =?utf-8?B?Z3Q2c1hPb0R2VkpYRkpvNElOTjdMRUdQVHF2a083ZWlqeHFjUFo4eEo0WDNF?=
 =?utf-8?B?TGxVL0RiMFF2dURwTWpWTW9GbmFNV2E5UnhTYzlia2EvejZjMW1SdHh3RkNW?=
 =?utf-8?B?TnZFT3l1V1FObk9pRmNNbUs2bFFPQXFUY0V2RkQrb2ZxMTVuZTVhYkVrTHBE?=
 =?utf-8?B?bVlJeWlWWDVXZmFTQjNac04rWURyVHg0WC93N3FkMnAwdTlWTG1WM0x1QWFN?=
 =?utf-8?B?amFHalVBdUdCYzBaVzlvYU5sTndENytkQ0UvZkNvM2l6TFlSdEJHbGY1enVs?=
 =?utf-8?B?WWJoZGVNUFpoOUk0WVlmd0YyTmduSncxZlNOR0pOYzFLZURiSHdQQ2lCRzdY?=
 =?utf-8?B?Z1MwZ3lsa3A3UEZPYUhpbEttU2k1b3BNanRSeEtxdmFycGxIamJYZFBlVVdU?=
 =?utf-8?B?YkwwakJtYTczQnB4NnY1eWVMa2FYS2VuVCtiOHU1MnVKN21hN2N6RExVVFND?=
 =?utf-8?B?U0hNTjI2V0dvZVg3U05UdzRESnhVNEw5Zk1xby80clVPV0RPSGVFM3ZjMEdn?=
 =?utf-8?B?c2Y0dFZWOGpkZ2QwUjJwTklKRVhOSDAyVXBHNWFGemlBSThiMkZwNVlGWUVO?=
 =?utf-8?B?S3FSVVd6SCtDS2hya2V5aUcrai9rS2VCUmdZT2hhSmFwV3V6eTVHczFSN0lB?=
 =?utf-8?B?MXM5bDhsdnJRNVpVZ2tVU1c3czAvQ3JlYXlkelY1VW5nbjdjb1ZScEZyQmlK?=
 =?utf-8?B?VUN1RVRFUE5QaGlVMnFTMTZWZ2t3bG5zUnlaZzVnNUdqcnhna0hjNGV3b2Jn?=
 =?utf-8?B?VkU5blVvNG1pcmpoMVdpRG1EeWwvT29VVVRuVDMzRk5lMkg1aDZYU0h4cG00?=
 =?utf-8?B?R1RRcU9US08wb1BZY3NwektGeXBVWDRsZVBOKzBacFc0NTBwMkFvK2R5cnVZ?=
 =?utf-8?B?c0UrMTZtRXJ1bmhoL0NocHNTcEFzVC9GczhDMHNxekpRcEtuNUcvL0VmdGh4?=
 =?utf-8?B?anVjNXUzQWRkRjN2N3pZeUh0Q3NsaVoyN1EzSnBLZFBGdnYzVjRDeURvb05Z?=
 =?utf-8?B?NHZoczcya0R1Zm5qcExkR2lMZy9DZllkaVp0RExhMWxLd2UzOVcyWCtndFEv?=
 =?utf-8?B?eUo2RWpmdnBUWVlOV2g3dm9LcVplaGxyQVBPTkRRUW5IaUpRcWN3eUU0Nmxl?=
 =?utf-8?B?Um8xSFpJZ1ZMdk8wczdqUVZIK0JLUTJUSzZzZnIvKzZxbHhEcTBhdjJHVGlD?=
 =?utf-8?B?ZWt0WUY3SEU2VE1zbEVxY1h5MXY2ajFyZ1MxenFEWTVacnE5THpMOVcrNGx5?=
 =?utf-8?B?VmdGTUt5RXNMYUt5NEJ3V3FDQnhGa0hDUzA1bllmclpVZHBhakkxT21TMUwx?=
 =?utf-8?B?Q3JudmxMNXhJZ2wwWFFNS2UzYlFsWDZ0ZjJQamlCSVVhRG10ZUEwUUJOR21q?=
 =?utf-8?B?RlFLeTRnSStYMVBubWNVZXJmYUd0WWQ3OVhRcTMxVEp1ZTlNSkRNUnFoVHRK?=
 =?utf-8?B?M0x1bW9tL0psbjBGZXdzcVhqZ0w3QTdDU2dnTyt5aXlVTlZZSTAwazI1WGxK?=
 =?utf-8?B?V0lsbmk2RTRaMXBFRXhuK2hPYzRXRjFkZU1WRGcvUmpZWHIvbzRHWmxPallU?=
 =?utf-8?B?SGdUUXIwS3hORlgwVko3UmZ3YU5rdEhCOEt2ZlFSTWR3ajlMc1FTSWpEWXpI?=
 =?utf-8?B?UW5rK09oYTJOZ3VpekNNRi9yazM5MmdMYlBYWENyTW00V0g1c0s0bkI0K2Jj?=
 =?utf-8?B?bHJaZGFlQXpYb2NJeHNTdVVGbG1UL1FZMFdFK2RLNTd3R1BOTFBTT3FmODBr?=
 =?utf-8?B?cmxLRTJwQldHeGxBWTJFVU1ITXV5VlJXU0xGTUNyOGNOOG1nbDhIa1JJVC95?=
 =?utf-8?B?SUNXVkIzL0F1N1A3VksrTURzWUp6NXFMTDhieDAxZTFpSWZtSklHMnBTeHJS?=
 =?utf-8?B?QjYzZ3V3VTFEcnF6U1BxZm0wY1htTm1uZ0lkY0RsMUlmYzN6OGt3bmp2SGVP?=
 =?utf-8?B?dkJaWVFEam9LV1IrcTJPM0xZS2dEbWJxeG16Q2xLSDZybVRVcHAzZG43ZHhz?=
 =?utf-8?Q?vjoctFLHboXSFALbog5cmrFzU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40E292750D7EB84FA9BFE3E1A5C9630E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80fc8c7c-7110-4d44-2f8a-08ddd3552300
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2025 12:47:56.8750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JYW4kZZiP4KH69U2sx6ChZ5OCWbNYXOYOgNKxTyicszn0uKuIWRdmD7EINP3qMALoMbCPu/9F7R/h8hoPhTGbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6992
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTAxIGF0IDE2OjIzICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
VHVlLCBKdWwgMjksIDIwMjUgYXQgMTI6Mjg6MzdBTSArMTIwMCwgS2FpIEh1YW5nIHdyb3RlOg0K
PiA+IE9uIFREWCBwbGF0Zm9ybXMsIGRpcnR5IGNhY2hlbGluZSBhbGlhc2VzIHdpdGggYW5kIHdp
dGhvdXQgZW5jcnlwdGlvbg0KPiA+IGJpdHMgY2FuIGNvZXhpc3QsIGFuZCB0aGUgY3B1IGNhbiBm
bHVzaCB0aGVtIGJhY2sgdG8gbWVtb3J5IGluIHJhbmRvbQ0KPiA+IG9yZGVyLiAgRHVyaW5nIGtl
eGVjLCB0aGUgY2FjaGVzIG11c3QgYmUgZmx1c2hlZCBiZWZvcmUganVtcGluZyB0byB0aGUNCj4g
PiBuZXcga2VybmVsIG90aGVyd2lzZSB0aGUgZGlydHkgY2FjaGVsaW5lcyBjb3VsZCBzaWxlbnRs
eSBjb3JydXB0IHRoZQ0KPiA+IG1lbW9yeSB1c2VkIGJ5IHRoZSBuZXcga2VybmVsIGR1ZSB0byBk
aWZmZXJlbnQgZW5jcnlwdGlvbiBwcm9wZXJ0eS4NCj4gPiANCj4gPiBBIHBlcmNwdSBib29sZWFu
IGlzIHVzZWQgdG8gbWFyayB3aGV0aGVyIHRoZSBjYWNoZSBvZiBhIGdpdmVuIENQVSBtYXkgYmUN
Cj4gPiBpbiBhbiBpbmNvaGVyZW50IHN0YXRlLCBhbmQgdGhlIGtleGVjIHBlcmZvcm1zIFdCSU5W
RCBvbiB0aGUgQ1BVcyB3aXRoDQo+ID4gdGhhdCBib29sZWFuIHR1cm5lZCBvbi4NCj4gPiANCj4g
PiBGb3IgVERYLCBvbmx5IHRoZSBURFggbW9kdWxlIG9yIHRoZSBURFggZ3Vlc3RzIGNhbiBnZW5l
cmF0ZSBkaXJ0eQ0KPiA+IGNhY2hlbGluZXMgb2YgVERYIHByaXZhdGUgbWVtb3J5LCBpLmUuLCB0
aGV5IGFyZSBvbmx5IGdlbmVyYXRlZCB3aGVuIHRoZQ0KPiA+IGtlcm5lbCBkb2VzIGEgU0VBTUNB
TEwuDQo+ID4gDQo+ID4gU2V0IHRoYXQgYm9vbGVhbiB3aGVuIHRoZSBrZXJuZWwgZG9lcyBTRUFN
Q0FMTCBzbyB0aGF0IGtleGVjIGNhbiBmbHVzaA0KPiA+IHRoZSBjYWNoZSBjb3JyZWN0bHkuDQo+
ID4gDQo+ID4gVGhlIGtlcm5lbCBwcm92aWRlcyBib3RoIHRoZSBfX3NlYW1jYWxsKigpIGFzc2Vt
Ymx5IGZ1bmN0aW9ucyBhbmQgdGhlDQo+ID4gc2VhbWNhbGwqKCkgd3JhcHBlciBvbmVzIHdoaWNo
IGFkZGl0aW9uYWxseSBoYW5kbGUgcnVubmluZyBvdXQgb2YNCj4gPiBlbnRyb3B5IGVycm9yIGlu
IGEgbG9vcC4gIE1vc3Qgb2YgdGhlIFNFQU1DQUxMcyBhcmUgY2FsbGVkIHVzaW5nIHRoZQ0KPiA+
IHNlYW1jYWxsKigpLCBleGNlcHQgVERILlZQLkVOVEVSIGFuZCBUREguUEhZTUVNLlBBR0UuUkRN
RCB3aGljaCBhcmUNCj4gPiBjYWxsZWQgdXNpbmcgX19zZWFtY2FsbCooKSB2YXJpYW50IGRpcmVj
dGx5Lg0KPiA+IA0KPiA+IFRvIGNvdmVyIHRoZSB0d28gc3BlY2lhbCBjYXNlcywgYWRkIGEgbmV3
IGhlbHBlciBkb19zZWFtY2FsbCgpIHdoaWNoDQo+ID4gb25seSBzZXRzIHRoZSBwZXJjcHUgYm9v
bGVhbiBhbmQgdGhlbiBjYWxscyB0aGUgX19zZWFtY2FsbCooKSwgYW5kDQo+ID4gY2hhbmdlIHRo
ZSBzcGVjaWFsIGNhc2VzIHRvIHVzZSBkb19zZWFtY2FsbCgpLiAgVG8gY292ZXIgYWxsIG90aGVy
DQo+ID4gU0VBTUNBTExzLCBjaGFuZ2Ugc2VhbWNhbGwqKCkgdG8gY2FsbCBkb19zZWFtY2FsbCgp
Lg0KPiA+IA0KPiA+IEZvciB0aGUgU0VBTUNBTExzIGludm9rZWQgdmlhIHNlYW1jYWxsKigpLCB0
aGV5IGNhbiBiZSBtYWRlIGZyb20gYm90aA0KPiA+IHRhc2sgY29udGV4dCBhbmQgSVJRIGRpc2Fi
bGVkIGNvbnRleHQuICBHaXZlbiBTRUFNQ0FMTCBpcyBqdXN0IGEgbGVuZ3RoeQ0KPiA+IGluc3Ry
dWN0aW9uIChlLmcuLCB0aG91c2FuZHMgb2YgY3ljbGVzKSBmcm9tIGtlcm5lbCdzIHBvaW50IG9m
IHZpZXcgYW5kDQo+ID4gcHJlZW1wdF97ZGlzYWJsZXxlbmFibGV9KCkgaXMgY2hlYXAgY29tcGFy
ZWQgdG8gaXQsIGp1c3QgdW5jb25kaXRpb25hbGx5DQo+ID4gZGlzYWJsZSBwcmVlbXB0aW9uIGR1
cmluZyBzZXR0aW5nIHRoZSBib29sZWFuIGFuZCBtYWtpbmcgU0VBTUNBTEwuDQo+ID4gDQo+ID4g
U2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+IFRlc3Rl
ZC1ieTogRmFycmFoIENoZW4gPGZhcnJhaC5jaGVuQGludGVsLmNvbT4NCj4gDQo+IFJldmlld2Vk
LWJ5OiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiANCj4gT25lIHNtYWxsIHF1ZXN0
aW9uIGJlbG93LA0KPiANCj4gPHNuaXA+DQo+IA0KPiA+ICtzdGF0aWMgX19hbHdheXNfaW5saW5l
IHU2NCBkb19zZWFtY2FsbChzY19mdW5jX3QgZnVuYywgdTY0IGZuLA0KPiA+ICsJCQkJICAgICAg
IHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZ3MpDQo+ID4gK3sNCj4gPiArCWxvY2tkZXBfYXNz
ZXJ0X3ByZWVtcHRpb25fZGlzYWJsZWQoKTsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogU0VB
TUNBTExzIGFyZSBtYWRlIHRvIHRoZSBURFggbW9kdWxlIGFuZCBjYW4gZ2VuZXJhdGUgZGlydHkN
Cj4gPiArCSAqIGNhY2hlbGluZXMgb2YgVERYIHByaXZhdGUgbWVtb3J5LiAgTWFyayBjYWNoZSBz
dGF0ZSBpbmNvaGVyZW50DQo+ID4gKwkgKiBzbyB0aGF0IHRoZSBjYWNoZSBjYW4gYmUgZmx1c2hl
ZCBkdXJpbmcga2V4ZWMuDQo+ID4gKwkgKg0KPiA+ICsJICogVGhpcyBuZWVkcyB0byBiZSBkb25l
IGJlZm9yZSBhY3R1YWxseSBtYWtpbmcgdGhlIFNFQU1DQUxMLA0KPiANCj4gLi4uDQo+IA0KPiA+
ICsJICogYmVjYXVzZSBrZXhlYy1pbmcgQ1BVIGNvdWxkIHNlbmQgTk1JIHRvIHN0b3AgcmVtb3Rl
IENQVXMsDQo+ID4gKwkgKiBpbiB3aGljaCBjYXNlIGV2ZW4gZGlzYWJsaW5nIElSUSB3b24ndCBo
ZWxwIGhlcmUuDQo+ID4gKwkgKi8NCj4gPiArCXRoaXNfY3B1X3dyaXRlKGNhY2hlX3N0YXRlX2lu
Y29oZXJlbnQsIHRydWUpOw0KPiANCj4gSSdtIG5vdCBzdXJlIHRoaXMgd3JpdGUgaXMgZ3VhcmFu
dGVlZCB0byBvY2N1ciBiZWZvcmUgdGhlIFNFQU1DQUxMLCBhcyBJIGRvbid0DQo+IHNlZSBhbnkg
ZXhwbGljaXQgYmFycmllciB0byBwcmV2ZW50IHRoZSBjb21waWxlciBmcm9tIHJlb3JkZXJpbmcg
dGhlbS4gRG8geW91DQo+IHRoaW5rIHRoaXMgaXMgYW4gaXNzdWU/DQoNCkFGQUlDVCB0aGlzX2Nw
dV93cml0ZSgpIGV2ZW50dWFsbHkgZW5kZWQgdXAgd2l0aCAidm9sYXRpbGUiIGJlaW5nIHVzZWQs
IHNvDQppdCBoYXMgYSBjb21waWxlciBiYXJyaWVyIGFscmVhZHkuDQoNClBsdXMgd2hhdCByaWdo
dCBhZnRlciB0aGlzX2NwdV93cml0ZSgpIGlzIGEgZnVuY3Rpb24gY2FsbCwgd2l0aCB0aGUgYm9k
eQ0KYWN0dWFsbHkgaW1wbGVtZW50ZWQgaW4gYW5vdGhlciBmaWxlLCBzbyBJIGRvbid0IHRoaW5r
IHRoZSBjb21waWxlciBpcw0Kc21hcnQgZW5vdWdoIHRvIGRvIGFueSByZW9yZGVyaW5nIGhlcmUu
DQoNCj4gDQo+ID4gKw0KPiA+ICsJcmV0dXJuIGZ1bmMoZm4sIGFyZ3MpOw0KPiA+ICt9DQo+ID4g
Kw0K

