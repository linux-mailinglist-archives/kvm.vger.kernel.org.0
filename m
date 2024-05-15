Return-Path: <kvm+bounces-17468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C21CB8C6E83
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E53FD1C2244F
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 22:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3768415B57E;
	Wed, 15 May 2024 22:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="goIK9Oct"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91EF15B540;
	Wed, 15 May 2024 22:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811492; cv=fail; b=Na/wINVWspmiqsASHBVg0oM4cLIip0REG+6wAAUivw9nVSAmQ+5oPGYho1KTYjKnIhyzFMY06QD/6BSD7xcoWDE+wyZch/+AhdhEETiI192gUcS8rfDkQufUFkGP6wN4C5TcmBeGk/lev0DpddF6SLwBE3o1cuOfcV519D90w2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811492; c=relaxed/simple;
	bh=/y+uvYrZ2SXeedxiBCfIxSbMA3A3XI/ItHFlxybhE+s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nbnBWo7ONpPdcX38hBzu+xGhXtgmST0Xaf0QQ+25ZgqJDHhkApG7/Z10zQ37cLs1V186hWtlKeD3/5c/v7sv5GdieEPLxpz1FE1GaMhQxiVP0P/iWqMlNtycDVzqqNH50Sv2Jx89D/55QutqYjVWgx03ItpppU1aItJEXHhNVpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=goIK9Oct; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811491; x=1747347491;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/y+uvYrZ2SXeedxiBCfIxSbMA3A3XI/ItHFlxybhE+s=;
  b=goIK9OctlFO/PPN7XsfS0pkvmTi/ioObt4BuPJjJ4g/+6f1wNLAgY098
   3ns0P8XQtVn7oXhiukOWkpSt1mCWBQ3DSeUMqCpbPf2kGuWg7fybsQvy5
   xJt/zbdlFJFWNwyA4nYxhVZ9sIx2VbN12Vk4orw5jsdGef6IS8rGdutTS
   uKFsDkbXhFTCYtxX449mwsh+R0XDwv2ahj+i3hMy9iuZLz8WXQuGp3gmR
   UNOoolTwStgjTJhrD1e42v5n2Eg7DZa0pPWY+Vt9KTVtX4jsE3/bqByyj
   lNw0VfyuN8QC8wH7CuYqkUWK08G3KUAdBmWFzxxR66N2hKp2Hrn9HAg9H
   A==;
X-CSE-ConnectionGUID: 6J8KESW1SpiIqEg1gtAlwQ==
X-CSE-MsgGUID: F/CmEuNHQ5u5Z6eeLhgwuQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11726102"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11726102"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:18:11 -0700
X-CSE-ConnectionGUID: hMnDbVxPSy641X2ho4ndPA==
X-CSE-MsgGUID: aSIAZGc7TrSM9TIV9HNoYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="54406308"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 15:18:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 15:18:09 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 15:18:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 15:18:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 15:18:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1ZN6jhojhiJyO3h4e+VNXLnETQw6SDoQiLyHW+lQv/mpiZAqvwFdTppFK91FRYWem7fLEUutcFYjlyVP+ByJwfOXvnr5AQbRhVFBxut9hU1NVxDdpy0wdBpswvnxyYwIgHjoHlxuw2Nq0ZwfpOmeg8iTO2oL3XbgyBuQjkxX/PXd3Ol7rqhVSSaoG0FsC1X8LGEJT2KlyIwo7TFZb4TS4rIxUO/kMT+qoNK5LeovVm3PT3s+gWRVJpwko2XrW67V5qnxdPREo00gGCtyVB3Ic3uVT4kjOVULXLr+SlQZkW9KICNAWe4V3oaWvL5wsQap7cS9ce9emZnGaEfutRLmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ostewhjni1Ig93z0dALee8udv/+9HqAQruP5hWjBBv0=;
 b=Ez3Gkh9cb+7hXu3ELEqt4wDKveNB2ZJVfGRQf5htXjN4JPIvi2g9QEhmJkvl0fvwJ+xfhIrrjYTo9xfm+PcR8NO0WvZJbyGsUnCRqYDdxqcbuq3lfv30pvVGEpSAuNdFO/PV6elsdg/JBNjr2+eqXQbdaXo4i/Wv/0yhwsAYdVlTv7nysiL5q7Xnwop0uFXJwQ1+LAmp2wubgIVrap0nHaap1VCV3RIKz9yWG2yPfBkC/H63CWBeyFs9+/7Ku+H4oTnJtifQdw2TGyMBwqdovCYhjatSwKtNrpKB1plkTzB/UCZXICn4H1YCedqwxs7hf3tjp4k6nxgVaRSFFa+L7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5794.namprd11.prod.outlook.com (2603:10b6:510:131::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Wed, 15 May
 2024 22:18:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 22:17:59 +0000
Message-ID: <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
Date: Thu, 16 May 2024 10:17:50 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
To: Isaku Yamahata <isaku.yamahata@intel.com>, Sean Christopherson
	<seanjc@google.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, <erdemaktas@google.com>, <sagis@google.com>,
	<yan.y.zhao@intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@linux.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <ZkTWDfuYD-ThdYe6@google.com> <20240515162240.GC168153@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240515162240.GC168153@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0342.namprd04.prod.outlook.com
 (2603:10b6:303:8a::17) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB5794:EE_
X-MS-Office365-Filtering-Correlation-Id: f82411b0-fd71-45b1-85aa-08dc752ce11c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TXdyU2tIZ3RCQVFGMmNsMzRreHhKRzlwbzdKbFViSjZheUtYQU1GNkZXTXJo?=
 =?utf-8?B?QThNN3dpYklkaFFzQnkxdkhPTE5YRzd3MHBWd2NmTGRYSTQrejdwUjI2a2JJ?=
 =?utf-8?B?STBsclp5aGhnV3ZyOE5qVVYwNy9iOEFRa2FWZjROOHpjeW02QmFXZUloemJj?=
 =?utf-8?B?WTY1TE1HWG5uUU1RdUpYSUhXdXQ2dGd4RUFRcjV5czBkYjZvdVM5RVF6K2dm?=
 =?utf-8?B?Q2JxdmVoMHVkSXVPWXZYVzZmakxCTFVIRHlTL05BQjZZaHpUbTFQNCsvK1dW?=
 =?utf-8?B?RTIveEUyV3B3ZEpUSlFFSVdvNGhwRHhtSTJWdGRnMUVqeXdjdS92MXFJT3E4?=
 =?utf-8?B?djVQeWJNQTJObkxOR283ZkNkVXM5T24vKzdZeGVKaDFtczVzNlRjZDhDVUhQ?=
 =?utf-8?B?VDBwcWVPNmxKQzYvc1BiN0V5V0xyZXdRMVFaR1d0Z002cDRjQXdUd2dpOEVK?=
 =?utf-8?B?VnJTRkhvQUhodTIrbUxneWVPbVlvQlp3R3pHWUxlRlI1d1FDMEtJTFJyS2pa?=
 =?utf-8?B?dnV5NEx5eSsvUUh2cVAveU1BMDNPOUpGOTZtNWJya3hKSW13S3p0blgyeDBB?=
 =?utf-8?B?QzJuZjlYZW8zN0NjK1R5c2RQd3pUejdGUVBSRnVleExLTDhIRFBBZEFFNy82?=
 =?utf-8?B?OFJvYU5uRFdBYWVMZVFNbUxJa1BXNEV6bjY1WnZBY1c5ckxNWmc2N2t3U3V1?=
 =?utf-8?B?ZmQ4RTlYTWFqOExZMC9sVHpnRDFCelpPV3J2bjE4anNsMWFTNW1peFkyLzZn?=
 =?utf-8?B?UkhIbldnNDgreXVvczNINis1YW5nN0N3N1UrdU9XQ3VZY3NLQW54MG9FeHlE?=
 =?utf-8?B?bENOVDRuUU9oRkNrczNkcEZXYjRWZ3lpcUxzT0JTb1VyYk5rMkVJSnNQZDJV?=
 =?utf-8?B?WWxhR00vT3dWenVYMTVJbzg3UU9NdkVzZlh6TnNoS09nb2Q3SUg1NTEzY2ZU?=
 =?utf-8?B?MTJ6R1hxSzN0d0FxRU9BbjZTWjNwOWNUUUhYaGU5RWppRTB6bmtEMkFXQWdG?=
 =?utf-8?B?QkFmdUtlRVhkWTNoMWtoVkhDdnV4WTM0RzBsencrdmFtR3Ixa3d2b2JjRi9E?=
 =?utf-8?B?ODh3VDNIaGJuOXhJYXFWZGduZXdmczNjMk55Wm1lUnMzZ21qdVFzRmxRNlpJ?=
 =?utf-8?B?RzdvOUNIUVhLZGVDRmFNOEZQOEdjMnJEUnhlUWl1K3FWZlB3YzdtKzBRVW43?=
 =?utf-8?B?ekYrK0Q4S1NCaWFCV0laUUpnRGdjUTVCaUEzWDBVSDFFMzAyVktaaklzUUc1?=
 =?utf-8?B?a09VdzNPU2U2VGRWMVQ4S09Uc3dGR3ljYjBKNi9SYzVOZ1pkZmdWQXVLU1Qy?=
 =?utf-8?B?Sm5tM25ZUWNHWTYvMDgxdm0xRDBQWFF2SFJZUVplRmNpckhMYksrRmNBY0k2?=
 =?utf-8?B?MVh5Z1dIVFM3S2Z1NVF6QzZUN3pEdm5jbzNqRVdJSHlZa2J4OGNicUNwd0h4?=
 =?utf-8?B?dlV0VjM1U3UvbDNGd0JKRTc1YWZLNWdBMWNaWnc5MEMxTXQ3M1RnMnBOZndX?=
 =?utf-8?B?dVB4TDRUbElTUk51eVduQTBKNGQ4VXNrWVBPY1owQ1ZCd21tbVVuQ3BjS2Y5?=
 =?utf-8?B?N0tqNDh3bG9md3kwNDJ6SnBBNGpLd0swNng3Wmt1T0g3dHgwb0RDbjc0ZGw5?=
 =?utf-8?B?V3R2Kzc5UG9nTmlidFpVSEN5N015Q3RzQmdaaGxrZGxwN3BqWWVSSlZBeDU5?=
 =?utf-8?B?U0VzWjJIUXJwakNYdGpaNEZIeHZNajNjN3RYZ0w1Q21TTGpKM3JsUzJBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUlSTDBZQ2VKYVNiRHpVajBWcFM4cTg5elhxenp5V0RXQTVFcFA4dlUvek5o?=
 =?utf-8?B?UTA1dmlwOElKUE9oNTdCN2Z4citVaHRXNm8vSVRlMG1mVUZkRVFkbW1zdWwy?=
 =?utf-8?B?RUVvb3RlWEx0RlloaFh3UEFYYlN2NUZScExMQlI0Yi9kLzF5Y3RyanJKeXk3?=
 =?utf-8?B?ajlRT2diWTFyRjRMVzkrR0JTSjluaWMxb0NVVUNDOWFia0xqKzRzbGRMZUwx?=
 =?utf-8?B?RDVFa0MrK21nOEhOazBoR2J5TklpZitCODl5R0dQSzBqbU9WSWt2UVhBUDdh?=
 =?utf-8?B?Rm9QWEtCNjFQLzBpVFV0L3hPZG1NdU0zNks2QWUya1FoUjdYcFN5c3JkSVI0?=
 =?utf-8?B?bklyQktRWEtRN0duc1hndUM4K2twZFpOU2tjeURlMThMMzBETE1yckhZaXIw?=
 =?utf-8?B?c1d2dkJucWRMYndwZFl1L1c2Q3d5TTN0OFN5UEJ2NFVteGpudyt6TnQvMSt2?=
 =?utf-8?B?QU5iZ1VDMWZpdXZDOEU2TCtSQ2h3bnV0bCtGaDdQcUh4Uks3OER6WERVMjNP?=
 =?utf-8?B?czhlaXlCbmJRblVqWml4VlRFWEpCQk0waHNHenB4aTJHbDFrdEtzaVJIc2Rm?=
 =?utf-8?B?TEY0dVhCMjZWT0JVMkR1QXBFN3dQL1pwRjN6YXUvWEdVWGoxYWN3UklwQ3NZ?=
 =?utf-8?B?VlQyZ2w2RW15dlFBVTh3aHdodHBmRmtSaUs3Y1g2QTlFanN2N0JwTUt6VTFi?=
 =?utf-8?B?dXcyQ1E3bHU1RlhHYUVPRVFPT0h4OWduMHBUTVhUWEpHK0F4NWlWQlIyTzR3?=
 =?utf-8?B?V1oxYnRscWl5VHhLY2dNeTB1QkJIVjZlWk01Zk8vT0d2dVlIQUMzK21WRzhV?=
 =?utf-8?B?NXBqeEkzOWVEV1ZaMitwdWk4MHBnME5wTUdJZnlBT0FqOHppUU96cXFPOU9u?=
 =?utf-8?B?RTNzNVVPbFZuTXNpT0c5V05xNmd5SXoyY1pSZjlka2tTbm1kak1NekkxZ05k?=
 =?utf-8?B?Q3NIS2cvSjhYa291cDV1QUVmYmF3eGtnV3lkSmUzMi9lREV4Szl3aUNpeE9J?=
 =?utf-8?B?OHllUVgzTmhDUVFDNmFaYmVvT1E2enNmbEZQTnNLb3l5bUJ5MDZXSkJPUkNM?=
 =?utf-8?B?aGE1OE40QTlxQ2JOeXpubjFkNitwNkF4TFNISzA0Mll4alY3Ukl0bnYybGFB?=
 =?utf-8?B?VUExT0VjL1JQTFAvaE9WRVhwK2Z0b2VRSnozcU4yZlp1MDRaZS9HVGxLNzNF?=
 =?utf-8?B?VGNJUVJUSzNsOWV3d0dSTjZKeTJXc2FpMUNZd1ZielNMUkUrdjFKNWh1WUV3?=
 =?utf-8?B?ZFhTckJtMnFxd3BRVGNXanQwWmFBT0syYlJjVGVYeHVJNnA3NTNvTDZzTDNT?=
 =?utf-8?B?WS9BTDhTTUFVR3V2WlNiS1FXcDZNbmFqZ3VaWUVGM250anZkQTdGbWhFMGYz?=
 =?utf-8?B?eG5mOFVnYm5lbXdCLzhqYTNkdnNEYXBPZ21uTmx2K00rK0hoN2l0dWtBNW04?=
 =?utf-8?B?b0ZYTFF4L2EwTVlBOFBBTGNPTHBuQUVRNWgzK25EVUxsQlU3bjJrY2tnQ3Mz?=
 =?utf-8?B?TWZCNXVPQlNQajY3alEwS2JnUW42ZlNZbzdFdjc3TkMveE14dlQyTk9mYVYr?=
 =?utf-8?B?OWVsOVU4VnRvUWVvdndyLzd1bFdKTVYvQ2N3RkJ3YXp3bm9sbUg2dnZEMzc2?=
 =?utf-8?B?blVzWnlucndRdzZwdkV3c3ptOXZxL0FDU2dlRnV0RUVmWjdKTTRxa2NpYTZt?=
 =?utf-8?B?bHFwNG1qWk5FWC9nemJ0eUgyQ05lUGJJVDRIYW1SdG16ejdNL2ZFeU1zckQv?=
 =?utf-8?B?cmdxSXoybDgrSk8rMDRXVmppQ24xVWZiMnVmcm1NVnE3Y3hqdjF3SnMzRHg2?=
 =?utf-8?B?UVpyZ1RXeFJMTG9hYzNGcW1QbHFTeDNKSEZxYTNwRDFZc0JYdFQybS9Za3Vy?=
 =?utf-8?B?M1hHRUwrZjh1QVpWYm5ZVWFNR1c0TE9kY2RwTzlQd2ljMGE5by9QclVpZCtL?=
 =?utf-8?B?d2p4b2Q4cmlUZWdUbHJFZ2JmaXZTb3EvbjRFWUFWWXhPL2dSNk8zaGNDd291?=
 =?utf-8?B?dVZ1YzhGZzZNSHR3QXlHUkZUbnlRVUk1UjdEZDUxZC9jblFBQjRNNVd1Rytn?=
 =?utf-8?B?RjVTZ1pqZkdITEFvK1pUczRLQnBpVzA1d2J4NFlDU2JIbC81T3dmYUVrWTFR?=
 =?utf-8?Q?jftZNOzgKIP2LJL1E7In/qHrv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f82411b0-fd71-45b1-85aa-08dc752ce11c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 22:17:59.7335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5/XKHZzwmZ3auoZ8EWl+VGmX1l7snX/nANPEPT5hZYRkliG7U169KTGUE0CJUTX2W7lXZW2EWFxmhDDuTyvhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5794
X-OriginatorOrg: intel.com



On 16/05/2024 4:22 am, Isaku Yamahata wrote:
> On Wed, May 15, 2024 at 08:34:37AM -0700,
> Sean Christopherson <seanjc@google.com> wrote:
> 
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index d5cf5b15a10e..808805b3478d 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -6528,8 +6528,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>>>   
>>>   	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
>>>   
>>> -	if (tdp_mmu_enabled)
>>> +	if (tdp_mmu_enabled) {
>>> +		/*
>>> +		 * kvm_zap_gfn_range() is used when MTRR or PAT memory
>>> +		 * type was changed.  TDX can't handle zapping the private
>>> +		 * mapping, but it's ok because KVM doesn't support either of
>>> +		 * those features for TDX. In case a new caller appears, BUG
>>> +		 * the VM if it's called for solutions with private aliases.
>>> +		 */
>>> +		KVM_BUG_ON(kvm_gfn_shared_mask(kvm), kvm);
>>
>> Please stop using kvm_gfn_shared_mask() as a proxy for "is this TDX".  Using a
>> generic name quite obviously doesn't prevent TDX details for bleeding into common
>> code, and dancing around things just makes it all unnecessarily confusing.
>>
>> If we can't avoid bleeding TDX details into common code, my vote is to bite the
>> bullet and simply check vm_type.
> 
> TDX has several aspects related to the TDP MMU.
> 1) Based on the faulting GPA, determine which KVM page table to walk.
>     (private-vs-shared)
> 2) Need to call TDX SEAMCALL to operate on Secure-EPT instead of direct memory
>     load/store.  TDP MMU needs hooks for it.
> 3) The tables must be zapped from the leaf. not the root or the middle.
> 
> For 1) and 2), what about something like this?  TDX backend code will set
> kvm->arch.has_mirrored_pt = true; I think we will use kvm_gfn_shared_mask() only
> for address conversion (shared<->private).
> 
> For 1), maybe we can add struct kvm_page_fault.walk_mirrored_pt
>          (or whatever preferable name)?
> 
> For 3), flag of memslot handles it.
> 
> ---
>   arch/x86/include/asm/kvm_host.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index aabf1648a56a..218b575d24bd 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1289,6 +1289,7 @@ struct kvm_arch {
>   	u8 vm_type;
>   	bool has_private_mem;
>   	bool has_protected_state;
> +	bool has_mirrored_pt;
>   	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>   	struct list_head active_mmu_pages;
>   	struct list_head zapped_obsolete_pages;
> @@ -2171,8 +2172,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>   
>   #ifdef CONFIG_KVM_PRIVATE_MEM
>   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> +#define kvm_arch_has_mirrored_pt(kvm) ((kvm)->arch.has_mirrored_pt)
>   #else
>   #define kvm_arch_has_private_mem(kvm) false
> +#define kvm_arch_has_mirrored_pt(kvm) false
>   #endif
>   
>   static inline u16 kvm_read_ldt(void)

I think this 'has_mirrored_pt' (or a better name) is better, because it 
clearly conveys it is for the "page table", but not the actual page that 
any page table entry maps to.

AFAICT we need to split the concept of "private page table itself" and 
the "memory type of the actual GFN".

E.g., both SEV-SNP and TDX has concept of "private memory" (obviously), 
but I was told only TDX uses a dedicated private page table which isn't 
directly accessible for KVV.  SEV-SNP on the other hand just uses normal 
page table + additional HW managed table to make sure the security.

In other words, I think we should decide whether to invoke TDP MMU 
callback for private mapping (the page table itself may just be normal 
one) depending on the fault->is_private, but not whether the page table 
is private:

	if (fault->is_private && kvm_x86_ops->set_private_spte)
		kvm_x86_set_private_spte(...);
	else
		tdp_mmu_set_spte_atomic(...);

And the 'has_mirrored_pt' should be only used to select the root of the 
page table that we want to operate on.

This also gives a chance that if there's anything special needs to be 
done for page allocated for the "non-leaf" middle page table for 
SEV-SNP, it can just fit.

Of course, if 'has_mirrored_pt' is true, we can assume there's a special 
way to operate it, i.e., kvm_x86_ops->set_private_spte etc must be valid.


