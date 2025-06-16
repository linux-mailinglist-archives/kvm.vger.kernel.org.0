Return-Path: <kvm+bounces-49591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FE7ADACFE
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11DA21893C80
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 10:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17A327F005;
	Mon, 16 Jun 2025 10:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PhWsm76G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A0C2820A0;
	Mon, 16 Jun 2025 10:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750068142; cv=fail; b=SIaB/IeqgKujH8+gI7LCLS5sphPTtBNMo/o+dOwgy8HMOXeIPwBZuIQAJZfQh/0Go4ZzJwpXbIij6RN0tTDgY21U0yoX7x68UKVj5JSkJzZoenY63IrAxlKQWUHQ7eZ+N4JTAoQ6cF0cQ8VTsLMQKknzrJZKN07kdKXe2qRiiQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750068142; c=relaxed/simple;
	bh=ssVjvX+x8eSy7uynhYnLREiyt4NQH7dd0P5EShGi8TA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OvOoYVIPaRgvVDnP8Ga3tZ7qWx3bCf1DMYzw64DOqkiRe3HMmPJ/thWrTtohKt4qfjRFZTqWGvvUdGJ1XoOck8sixTxarfPlb//5QOoBNIq82LzGoEeQowIIVxHdSs/4vubksRDar2ys3tbZWHyVs34ybGtlTIs7iXxzjl8x/Ro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PhWsm76G; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750068139; x=1781604139;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ssVjvX+x8eSy7uynhYnLREiyt4NQH7dd0P5EShGi8TA=;
  b=PhWsm76Gc+H+Fwnv2XIVYXasfpJS9ludQolZy4Xs2ZCNEmJFN9O18Xa5
   DWld3vD1zYkRz6xCwiMBXFOFU4zXZWSsXfD6Q2xjr0P2LW1zlZICU7AHT
   +wfiiMijov5UBxlV+KfiE4b2OdoK3z738u/ozqpRswwq9Kmzy3j3Sxi7v
   TLAdfbA4qZsgXLMEbd2yWUY3M5BZ/o1pkoDSjVL3K8dqxZlt+14tJzHUh
   YdXn8Ma2YlQwr6AGTHW7rlx3B0BiZDBoAjhtGZNklt6aE7D/6QQ7qEnKg
   g8J9tzXhgCwCqYbyg43srukiScWtxrGyYB29R9HM/Ikz5Ct2hTkrjobBj
   g==;
X-CSE-ConnectionGUID: HnCtH3dsT6SH/JUF3Voj7Q==
X-CSE-MsgGUID: M7s4I55aSkyiFghz0onDug==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="74737340"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="74737340"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 03:02:16 -0700
X-CSE-ConnectionGUID: GBPX+3EnT5Wg/WK/spb66w==
X-CSE-MsgGUID: 9NsiJZ1STJGGW4Hmhk6g5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="153193984"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 03:02:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 03:02:15 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 03:02:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.40)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 03:02:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BNj5hUS57bipJyJ7XVgCelPLtNdbGoMo3GYEl/Vaz67b+TQ9bcPcQu2uF/XCXzw/maka1dCAFBIFIktGdM5vtqKhkZSNA1pSBeG+4OOBRecEqBiV0P8lacM8HOtCuX0Srn0AJ+UJOV4GexJMhNW7CFx36+CUWULyTXnf229V2wwA9UyvXSRnlg9BIJKqYzeeDMah/mZYvuyQayeGOZnHTeOzmIhCqhpMas7nPvRceVMT3BQ3D6BfGVk4Hl8tWY0uilJ13SIoCHHDi3vwYAWA0H9HI/MBZiLbyQvZdHseyZ6I2MnaMwk+NSwLyy+i4r+fo+LVEofi3EBD0DKViBXQ0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDJzXXj224dM27rcLHxsXI+sdYdrmvJL3XHDHEFyOz4=;
 b=c6AZVicqqVIWQR8VTwLIsVYeI9cVnrVXYg6xPEeL/yd0ffsJBkXmOt1PpHpPSmbdZKsumFefxTW3gTLglAUXyjPfhwG3dTrq176jqqI9Jzer/VVd3G5uwjbat+nc+d8lAX6SkUBp4B7efaY9RvzSBGSnmi/xbwiFJ5tWfKzzfoGX8xlNcYGGDYzOBbdpoGxFNElEKoQcQd+j1P+xzVMHvzOv/kTs45EStswgNyFm8vqM8nNzqGhlLLosgjeYV/yjLCn81pMap2Qf/Ve+2ivLpFwOgqZuovUVxgoVJp11hdXQMMjcBgQso5ndEToJdFWjkUOLHJK4qrTPnG6jGxUQPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB5982.namprd11.prod.outlook.com (2603:10b6:510:1e1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 10:01:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 10:01:47 +0000
Date: Mon, 16 Jun 2025 17:59:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<x86@kernel.org>, <rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
X-ClientProxiedBy: SG2P153CA0033.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::20)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB5982:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b71bb2-16cc-4d5b-3cd3-08ddacbcce88
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eDFkMUUvejhycS8xMXd5WktzRWlQQUJIdlNXcVJNcWhYOGxoSkdOc1dNczR1?=
 =?utf-8?B?cEd6RGswcVRZNnRocytrOGhhTHVyYWZYMzM1V0Z4cVpTSzFZeTJmYjIrdFhK?=
 =?utf-8?B?L1RRZlZLeFA1NFlUTlFvV0ZybXBSRjgzUkU1SzNTTzNiWlJTT3NuVmNXTTcv?=
 =?utf-8?B?YUJSem9xejBFRjhVU0NsdWszK25LMlE1WGxUaisxcnVGQ0Z4ZmE2bDFIUXhR?=
 =?utf-8?B?MUpSeE1xdUVWVm5GUnBaLzhZWnVSZjZudnI2bzFuSzB0UzZMbFJvbTRoenZG?=
 =?utf-8?B?ZFM2cTdGanR1ZEFBSXRWcWlKQktyeDJUcTU2cmM1WkxWZ0NSSFp1VUxWczRP?=
 =?utf-8?B?QXRITDhxTkdmYytrMW5Wa3JhVkg5WGpzSmFRaE1WYzJ4Wmt3VnJWODl6dUZQ?=
 =?utf-8?B?NVp4OXBvMnZCdFhWSlVBYkRxV2lQVmV3RUd2R0hhN25kYkw4NGVGVGRiRTUw?=
 =?utf-8?B?RkNHS2Vuc3h2VjUxbHJBOTdkei90N3BhSkE2VG9kUG5YUGdPSW9ELytnVkRE?=
 =?utf-8?B?Tk5vcVVtWjV1MDNqK3YvMUJmeDh5YXJTclFiZWR4NE9FNGk3QTNpZklwMkVL?=
 =?utf-8?B?TEVyTW1xTkVjamJ4c1puNitmRnYwQzlIT05IZmdFQng4SitoeGJmeWZXdnBY?=
 =?utf-8?B?MTRCN1FDTk55OWE5UE5QVDV1QkJkSHc0VUEzMFBkbXhncmFqZ1FCMFJTZWZD?=
 =?utf-8?B?ekZOTjhRaEV6UnQ0dkdxdVZuL2MxaWp5YmFHYWxVczJBYUtNdHBxRUVQVXo1?=
 =?utf-8?B?VWFaR0JXSWZPWC8yWDJlaCttd2NzbzIrdDFPM1ZZNmpJdU1TUHlsRjBOTzBP?=
 =?utf-8?B?QmdERTlxbU9IMVllK1BCR21jZSs3UkFPQS9hZnN2VDhQUmUvQm9qdndPdzhU?=
 =?utf-8?B?Qml2akFoaFZPLzRJZXU3dWU5RlkrVlB1dDhSZU5JRVl5Y2Vpc0xVaHJYU3Ry?=
 =?utf-8?B?bFVQRElLZTV6VTAzUzRJanhDL25vL0dIdFpUNHR6Znd3ZG5hZjdxVUtMZVJE?=
 =?utf-8?B?elpzeUhHd1ZPbGtuOUhwYWZHaHU5M1luTmhPTTVIV0ZCY21hYTdDY0ZTREJC?=
 =?utf-8?B?K3d6OHRqTWtqOGpKL3E1aTNYTVp6WnRob0pnMXNRaUFPUW9VY0hvaGNyVEha?=
 =?utf-8?B?enowMlhpM2lmVWJOSnNZc2ZHSzZGSU9WcDEvMXZCZ2pLa2lEa2EvM3Z4V1Nt?=
 =?utf-8?B?S0xFR1k3b2ZaaDdRKy95Y0hacWFjQUZjcFpSOTg3UVYyMlJ0bHllMUtNbHl5?=
 =?utf-8?B?bEJrYmN1VnFhQTluaGtqcEd1eW1xQkl3Z1czZm5NVEZtNVdnalpENkxpNklo?=
 =?utf-8?B?Y1ZtWG8rckNUWFFsSER3SE9VWFVFUmJMcW9xOUVzbWswR1JRUU9HQ0JTdHR4?=
 =?utf-8?B?akttQy9sdkduay9QOVFzaHY4aWxtTmtSSG9ON3QxUkFZN3ZCQkxjeHhBTUxn?=
 =?utf-8?B?ekxWK0puM1llMHRSeUtNUnJ5QlJXelRoekxEc01OT3BnNHo4NkU3cjZ6dENO?=
 =?utf-8?B?R0w2L3ZyMEU3cVJYMjRDQXBVcytVQm5mMWUrZS9DbzkvU2xENjB6eE1aVWI4?=
 =?utf-8?B?aFBONkxCQnMvc1ZvQzZJQm1QZVNOUHFLTEN3TmtmcStDczZYQWxnWWN2Z2FT?=
 =?utf-8?B?RGlEa2lQWnhIdUtuZmdzSENUQVZ1NDNPd2sxQk5YRVV3TW5DOWpXU2dRZUxs?=
 =?utf-8?B?d05SdFRJSjJNU0NLU0ovaWNNbEZZcGwzMDYybzdqN3MzMkJ6cWV2a29GbEtV?=
 =?utf-8?B?dkYzOVZOK1MwTThxMmRnVTRUNnhkNmhrMWR3S0t0L2RRYVRyMFRYK1NQcDhN?=
 =?utf-8?B?emM4WWV0Y3RJR0laSmRwV3JpbURMbVVYY25TTkY4NnpVR3J6T1BJbmorWlVE?=
 =?utf-8?B?MVA1cmVVZzkxVW5vbiswbWdvdlhhOEdFaSs4amt0QWlIcUI5OHdjanFzVTFt?=
 =?utf-8?Q?SCyT2BDetPE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWhVeFdFRXJsNmt2K1VTWFdzMzQzUkhCakQrVlZialhrY0dIU1BGWVJkZU8v?=
 =?utf-8?B?UVM5eWt2YTBLallJbnV0ZXprT2JLS2NwTkpyWjh0a0V6SjM2eldBeWJpc09o?=
 =?utf-8?B?T3VuK282SkN3ZXI4U3hleDdCTUprUUtFcDh4MHNQN0dsamxpODJBd2dGbnJ5?=
 =?utf-8?B?MytkdGVEQzYxOUNsckVaVHBjVTJpRzJxY3JJUzR4S2pTR1B4bk9PaVpUdEp0?=
 =?utf-8?B?Qm5yY291VG00djVjeTB6VnpSbWdJSW9IeHNTdnI0TG1vZi9vSXF1SlJRRGhM?=
 =?utf-8?B?eElXOXl2bUZzUHB3K3RsYWpTelVTUnBodXh0NGpLblhPSm50ZHd3Rm5CMWJo?=
 =?utf-8?B?VHNYYWpEcFZJVWRIaUZhcjN4Qy92VFlYS1crZ1I5aGtjWnNJZ2NpUFp0YlBC?=
 =?utf-8?B?djY4dERSMWNpSThGVjg0R25zTndhQ0Q1aW1ZZVp0Zm84T3MzZTErUWVUVFZJ?=
 =?utf-8?B?b29WSFdGMmlOWWZIdll4NnNJZkovdUd2bGxJZ28zanRuYlgwQ1I3NVVhTnhv?=
 =?utf-8?B?aXc1WU9TRVhjTm9xdS95d3lvdE9oSUVkbXVsdG5RZWZUVTJWNTZla3B6Q2xz?=
 =?utf-8?B?Tk1yTEtRUHhCcFBQOVh2enkrSU5JdHBwdjZHVmFxd2Y2RkxHeHNlVFA3S1ll?=
 =?utf-8?B?WURqMEhtNFNkWFhEbGtGQ0Z4UjU1eXU3cnNXazNKMTRpeFJzdDhtT3YyZVdB?=
 =?utf-8?B?bldRSDJzZlBzajlqMjU0bWNlRVRhanBEUmgxTGVCQU1PamdOQmZaZDV4VXox?=
 =?utf-8?B?N040KzVVbkNJZlZhRG9xRktTb0llVlJBcXBQd1RJM2Q0Wm1NbGY5dElmbCtt?=
 =?utf-8?B?SXpVYWlWNXNlTzM4NDMyd1VFYmU2K24wV3Q0azI0dWgzdFRWeTFQTzI1c0Ri?=
 =?utf-8?B?NlBjSGZqVHc4R0N1OTEzU0R2NVlJMFRhQkU5NDkvZUk1S2ZLUGRCZDJtRE5U?=
 =?utf-8?B?RjdDVlFDWCtORUc2Ui9GNGRqMUJXbzBGRlovQXMwcXA2V3I0cTBubTJqdWdx?=
 =?utf-8?B?MnZhTW9ORkQ3TXBSQ2p6bjZKRWxlcnI3MWdBa2paNWpJZE9RMFo4aFl0R1JD?=
 =?utf-8?B?MktpcHF4akpydTJNZGh3ZE8zNm96bUd5bWxiZGV5Q3JteDZUK0hKRUt2WHZ4?=
 =?utf-8?B?WllTdWZiT3RjbEMwRzRKbDlLZmZUbWFUaXpNb3VKVFU2Z25yTEZjNWJuU2pQ?=
 =?utf-8?B?VjBPUkYwRTFJZEw2OXdHd1MyOUdidTRQdVUyYTJJbVN2bmNyMjFFZmlJTTF4?=
 =?utf-8?B?SzlvTmt5V2pUZEF5bmFreG5ZU2E4MlJFelpwRzk3d3lQWWdDNFpRU2laWHV2?=
 =?utf-8?B?MEZqWlZ5V1AvWjJybkxOZHdlM0hCRlcrS3B5cCtHLzdMcm1Td01PWVBMM0JR?=
 =?utf-8?B?NEU4bG1BVWc4US84RXVONGFtMEFpcG1wK1dPd2F2S21qNjdQSVpOS3AybjZR?=
 =?utf-8?B?TEN0aCtQUmtVVmx6TVZxWlV5YWZ3UXNlMDhUNUV2T2JoYllSQzA5ejNYVDht?=
 =?utf-8?B?OVFEYXRudHlFWXNUVmV0OGNsTjVvWDJJZHoxTUNMeS9PNFpSeUhPKzk3S0Yx?=
 =?utf-8?B?R25EbmFTakRWckFoLzhvTmRBMkRxV0kwNGEvTmczcTNPZG0vRDcvZGxkZDFQ?=
 =?utf-8?B?WFkyU0ZuSWVuTzQzZkJpT2VIZHFLQStuYVBzYnBqR1BaNEw5aUN0V09DUkVa?=
 =?utf-8?B?dm5scnRoRFo5Q2NkdGlqSXcvc1U1L0lEdjFTeTJ2WDQrbzgrTXlsdUIyOXpT?=
 =?utf-8?B?TEVKVERBTnhNNTFMcmN3SDVNV2w4QmVxUlZHLzhBWXAxeEZPejZaSzhjVEZQ?=
 =?utf-8?B?dlRYV25vTG1NdjZuOGFzU2o3djN3NlBJc2tuKzNpSzNwTXZCbEVTZ2JidEdJ?=
 =?utf-8?B?QTlJOC9UZzlhRTV6SUViSFRRdlFtV3VuVCtaSWRxZThEMktReng5WmxNM29p?=
 =?utf-8?B?clFtWWoxOHBjRXdkTVQxK1lxTXc2d1RnMlJ1VFRDQVhIQlVWRnQ3S0tObmNS?=
 =?utf-8?B?c3RQNGN4RkpZL1NKSXhQTjVYRHYxKzZ5OWVKTXU0Mk10M0tOVklWNy9meUZP?=
 =?utf-8?B?dHlzZWVhS1dER1pNV29pUFoycmtNZ3h1L2I0VWRFdkpyNlVPL0ZiZ0FUR3hO?=
 =?utf-8?Q?UOqLFTLSsvKvmTPjFQ2D9bNvo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b71bb2-16cc-4d5b-3cd3-08ddacbcce88
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 10:01:47.8166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qcFAM80ZoI2Q2KbP/LyWpDUOKMFFa+eBkUhs/ygQFv2jZS9+LBWFFvVzlNvNQjVzxUEvmLG0/dG+8w0tnol8uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5982
X-OriginatorOrg: intel.com

On Wed, Jun 11, 2025 at 07:30:10AM -0700, Vishal Annapurve wrote:
> On Wed, Jun 4, 2025 at 7:45 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > We need to restore to the previous status (which includes the host page table)
> > if conversion can't be done.
> > That said, in my view, a better flow would be:
> >
> > 1. guest_memfd sends a pre-invalidation request to users (users here means the
> >    consumers in kernel of memory allocated from guest_memfd).
> >
> > 2. Users (A, B, ..., X) perform pre-checks to determine if invalidation can
> >    proceed. For example, in the case of TDX, this might involve memory
> >    allocation and page splitting.
> >
> > 3. Based on the pre-check results, guest_memfd either aborts the invalidation or
> >    proceeds by sending the actual invalidation request.
> >
> > 4. Users (A-X) perform the actual unmap operation, ensuring it cannot fail. For
> >    TDX, the unmap must succeed unless there are bugs in the KVM or TDX module.
> >    In such cases, TDX can callback guest_memfd to inform the poison-status of
> >    the page or elevate the page reference count.
> 
> Few questions here:
> 1) It sounds like the failure to remove entries from SEPT could only
> be due to bugs in the KVM/TDX module,
Yes.

> how reliable would it be to
> continue executing TDX VMs on the host once such bugs are hit?
The TDX VMs will be killed. However, the private pages are still mapped in the
SEPT (after the unmapping failure).
The teardown flow for TDX VM is:

do_exit
  |->exit_files
     |->kvm_gmem_release ==> (1) Unmap guest pages 
     |->release kvmfd
        |->kvm_destroy_vm  (2) Reclaiming resources
           |->kvm_arch_pre_destroy_vm  ==> Release hkid
           |->kvm_arch_destroy_vm  ==> Reclaim SEPT page table pages

Without holding page reference after (1) fails, the guest pages may have been
re-assigned by the host OS while they are still still tracked in the TDX module.


> 2) Is it reliable to continue executing the host kernel and other
> normal VMs once such bugs are hit?
If with TDX holding the page ref count, the impact of unmapping failure of guest
pages is just to leak those pages.

> 3) Can the memory be reclaimed reliably if the VM is marked as dead
> and cleaned up right away?
As in the above flow, TDX needs to hold the page reference on unmapping failure
until after reclaiming is successful. Well, reclaiming itself is possible to
fail either.

So, below is my proposal. Showed in the simple POC code based on
https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2.

Patch 1: TDX increases page ref count on unmap failure.
Patch 2: Bail out private-to-shared conversion if splitting fails.
Patch 3: Make kvm_gmem_zap() return void.

After the change,
- the actual private-to-shared conversion will be not be executed on splitting
  failure (which could be due to out of memory or bugs in the KVM/TDX module) or
  unmapping failure (which is due to bugs in the KVM/TDX module).
- other callers of kvm_gmem_zap(), such as kvm_gmem_release(),
  kvm_gmem_error_folio(), kvm_gmem_punch_hole(), are still allowed to proceed.
  After truncating the pages out of the filemap, the pages could be leaked on
  purpose with the reference hold by TDX.


commit 50432c0bb1e10591714b6b880f43fc30797ca047
Author: Yan Zhao <yan.y.zhao@intel.com>
Date:   Tue Jun 10 00:02:30 2025 -0700

    KVM: TDX: Hold folio ref count on fatal error

    Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c60c1fa7b4ee..93c31eecfc60 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1502,6 +1502,15 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
        td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }

+/*
+ * Called when fatal error occurs during removing a TD's page.
+ * Increase the folio ref count in case it's reused by other VMs or host.
+ */
+static void tdx_hold_page_on_error(struct kvm *kvm, struct page *page, int level)
+{
+       folio_ref_add(page_folio(page), KVM_PAGES_PER_HPAGE(level));
+}
+
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
                            enum pg_level level, struct page *page)
 {
@@ -1868,12 +1877,14 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
         * before any might be populated. Warn if zapping is attempted when
         * there can't be anything populated in the private EPT.
         */
-       if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-               return -EINVAL;
+       if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm)) {
+               ret = -EINVAL;
+               goto fatal_error;
+       }

        ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
        if (ret <= 0)
-               return ret;
+               goto fatal_error;

        /*
         * TDX requires TLB tracking before dropping private page.  Do
@@ -1881,7 +1892,14 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
         */
        tdx_track(kvm);

-       return tdx_sept_drop_private_spte(kvm, gfn, level, page);
+       ret = tdx_sept_drop_private_spte(kvm, gfn, level, page);
+       if (ret)
+               goto fatal_error;
+       return ret;
+fatal_error:
+       if (ret < 0)
+               tdx_hold_page_on_error(kvm, page, level);
+       return ret;
 }

 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,


commit 240acb13d4bd724b4c153b73cfba3cd14d3cc296
Author: Yan Zhao <yan.y.zhao@intel.com>
Date:   Tue Jun 10 19:26:56 2025 -0700

    KVM: guest_memfd: Add check kvm_gmem_private_has_safe_refcount()

    Check extra ref count on private pages in case of TDX unmap failure before
    private to shared conversion in the backend.

    In other zap cases, it's ok to do without this ref count check so that
    the error folio will be held by TDX after guest_memfd releases the folio.

    Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index af7943c0a8ba..1e1312bfa157 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -521,6 +521,41 @@ static void kvm_gmem_convert_invalidate_end(struct inode *inode,
                kvm_gmem_invalidate_end(gmem, invalidate_start, invalidate_end);
 }

+static bool kvm_gmem_private_has_safe_refcount(struct inode *inode,
+                                              pgoff_t start, pgoff_t end)
+{
+       pgoff_t index = start;
+       size_t inode_nr_pages;
+       bool ret = true;
+       void *priv;
+
+       /*
+        * Conversion in !kvm_gmem_has_custom_allocator() case does not reach here.
+        */
+       if (!kvm_gmem_has_custom_allocator(inode))
+               return ret;
+
+       priv = kvm_gmem_allocator_private(inode);
+       inode_nr_pages = kvm_gmem_allocator_ops(inode)->nr_pages_in_folio(priv);
+
+       while (index < end) {
+               struct folio *f;
+               f = filemap_get_folio(inode->i_mapping, index);
+               if (IS_ERR(f)) {
+                       index += inode_nr_pages;
+                       continue;
+               }
+
+               folio_put(f);
+               if (folio_ref_count(f) > folio_nr_pages(f)) {
+                       ret = false;
+                       break;
+               }
+               index += folio_nr_pages(f);
+       }
+       return ret;
+}
+
 static int kvm_gmem_convert_should_proceed(struct inode *inode,
                                           struct conversion_work *work,
                                           bool to_shared, pgoff_t *error_index)
@@ -538,6 +573,10 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
                list_for_each_entry(gmem, gmem_list, entry) {
                        ret = kvm_gmem_zap(gmem, work->start, work_end,
                                           KVM_FILTER_PRIVATE, true);
+                       if (ret)
+                               return ret;
+                       if (!kvm_gmem_private_has_safe_refcount(inode, work->start, work_end))
+                               return -EFAULT;
                }
        } else {
                unmap_mapping_pages(inode->i_mapping, work->start,


commit 26743993663313fa6f8741a43f22ed5ac21399c7
Author: Yan Zhao <yan.y.zhao@intel.com>
Date:   Tue Jun 10 20:01:23 2025 -0700

    KVM: guest_memfd: Move splitting KVM mappings out of kvm_gmem_zap()

    Modify kvm_gmem_zap() to return void and introduce a separate function,
    kvm_gmem_split_private(), to handle the splitting of private EPT.

    With these changes, kvm_gmem_zap() will only be executed after successful
    splitting across the entire conversion/punch range.

    Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1e1312bfa157..e81efcef0837 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -318,8 +318,7 @@ static bool kvm_gmem_has_safe_refcount(struct address_space *mapping, pgoff_t st
        return refcount_safe;
 }

-static int kvm_gmem_zap(struct kvm_gmem *gmem, pgoff_t start, pgoff_t end,
-                       enum kvm_gfn_range_filter filter, bool do_split)
+static int kvm_gmem_split_private(struct kvm_gmem *gmem, pgoff_t start, pgoff_t end)
 {
        struct kvm_memory_slot *slot;
        struct kvm *kvm = gmem->kvm;
@@ -336,7 +335,7 @@ static int kvm_gmem_zap(struct kvm_gmem *gmem, pgoff_t start, pgoff_t end,
                        .end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
                        .slot = slot,
                        .may_block = true,
-                       .attr_filter = filter,
+                       .attr_filter = KVM_FILTER_PRIVATE,
                };

                if (!locked) {
@@ -344,16 +343,13 @@ static int kvm_gmem_zap(struct kvm_gmem *gmem, pgoff_t start, pgoff_t end,
                        locked = true;
                }

-               if (do_split) {
-                       ret = kvm_split_boundary_leafs(kvm, &gfn_range);
-                       if (ret < 0)
-                               goto out;
+               ret = kvm_split_boundary_leafs(kvm, &gfn_range);
+               if (ret < 0)
+                       goto out;

-                       flush |= ret;
-                       ret = 0;
-               }
+               flush |= ret;
+               ret = 0;

-               flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
        }
 out:
        if (flush)
@@ -365,6 +361,42 @@ static int kvm_gmem_zap(struct kvm_gmem *gmem, pgoff_t start, pgoff_t end,
        return ret;
 }

+static void kvm_gmem_zap(struct kvm_gmem *gmem, pgoff_t start, pgoff_t end,
+                       enum kvm_gfn_range_filter filter)
+{
+       struct kvm_memory_slot *slot;
+       struct kvm *kvm = gmem->kvm;
+       unsigned long index;
+       bool locked = false;
+       bool flush = false;
+
+       xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
+               pgoff_t pgoff = slot->gmem.pgoff;
+               struct kvm_gfn_range gfn_range = {
+                       .start = slot->base_gfn + max(pgoff, start) - pgoff,
+                       .end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
+                       .slot = slot,
+                       .may_block = true,
+                       .attr_filter = filter,
+               };
+
+               if (!locked) {
+                       KVM_MMU_LOCK(kvm);
+                       locked = true;
+               }
+
+               flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
+       }
+
+       if (flush)
+               kvm_flush_remote_tlbs(kvm);
+
+       if (locked)
+               KVM_MMU_UNLOCK(kvm);
+
+       return;
+}
+
 static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
                                      pgoff_t end)
 {
@@ -571,10 +603,10 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,

                gmem_list = &inode->i_mapping->i_private_list;
                list_for_each_entry(gmem, gmem_list, entry) {
-                       ret = kvm_gmem_zap(gmem, work->start, work_end,
-                                          KVM_FILTER_PRIVATE, true);
+                       ret = kvm_gmem_split_private(gmem, work->start, work_end);
                        if (ret)
                                return ret;
+                       kvm_gmem_zap(gmem, work->start, work_end, KVM_FILTER_PRIVATE);
                        if (!kvm_gmem_private_has_safe_refcount(inode, work->start, work_end))
                                return -EFAULT;
                }
@@ -1471,9 +1503,10 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
                 * expensive.
                 */
                filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED;
-               ret = kvm_gmem_zap(gmem, start, end, filter, true);
+               ret = kvm_gmem_split_private(gmem, start, end);
                if (ret)
                        goto out;
+               kvm_gmem_zap(gmem, start, end, filter);
        }

        if (kvm_gmem_has_custom_allocator(inode)) {
@@ -1606,7 +1639,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
         * memory, as its lifetime is associated with the inode, not the file.
         */
        kvm_gmem_invalidate_begin(gmem, 0, -1ul);
-       kvm_gmem_zap(gmem, 0, -1ul, KVM_FILTER_PRIVATE | KVM_FILTER_SHARED, false);
+       kvm_gmem_zap(gmem, 0, -1ul, KVM_FILTER_PRIVATE | KVM_FILTER_SHARED);
        kvm_gmem_invalidate_end(gmem, 0, -1ul);

        list_del(&gmem->entry);
@@ -1942,7 +1975,7 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol

                kvm_gmem_invalidate_begin(gmem, start, end);
                filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED;
-               kvm_gmem_zap(gmem, start, end, filter, false);
+               kvm_gmem_zap(gmem, start, end, filter);
        }

        /*


If the above changes are agreeable, we could consider a more ambitious approach:
introducing an interface like:

int guest_memfd_add_page_ref_count(gfn_t gfn, int nr);
int guest_memfd_dec_page_ref_count(gfn_t gfn, int nr);

This would allow guest_memfd to maintain an internal reference count for each
private GFN. TDX would call guest_memfd_add_page_ref_count() for mapping and
guest_memfd_dec_page_ref_count() after a successful unmapping. Before truncating
a private page from the filemap, guest_memfd could increase the real folio
reference count based on its internal reference count for the private GFN.

