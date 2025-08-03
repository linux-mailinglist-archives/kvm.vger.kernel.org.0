Return-Path: <kvm+bounces-53880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A55B194A8
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 19:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 402E27A9397
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 17:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 068B21078F;
	Sun,  3 Aug 2025 17:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SO75CQz/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BBA639;
	Sun,  3 Aug 2025 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754242913; cv=fail; b=rh7A9U749Qh9KaJfRplXDlO7SoMp+3izeKZp76P9vs7dc0MyGPCYw1OuoupQRRTIwKtTdp4etJGkRY7dww3QKZSMW1SIfa9Gh9TEfLfNbiGtVR+us9cSK1SD3IIUoxG2sqfaNxv60cr4iLl63GqL0EWXvkXCJ/9ZW16mG4yPDjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754242913; c=relaxed/simple;
	bh=vsKO6n8WE/XUdJKCdJjOMvLBggWnwLfVP5RqA+ysdYU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GtrZVZ78iWXT+ImpMQk0+oq4djY1IVzg9cuNw40Lo3XVCtP+gr8+k3qpNQ/M87kxiTd48sZS+fsfESer+wcSZ9/BBSnRYCmXiCDRD7S920/CF6Pfbox7vzX0VcOCQl7t6L6F1LTZqgGRLqeWYuhyRzsLAazFf6y9H0DhsBA/rZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SO75CQz/; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754242912; x=1785778912;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vsKO6n8WE/XUdJKCdJjOMvLBggWnwLfVP5RqA+ysdYU=;
  b=SO75CQz/C3MM0Y+gNTc5Ky7oGvIqDf5eq3NlYSzcI4PJYpx3IRHcpRHI
   19NH7bXG8nsdXymIwMabPmkwmlML2B9P5LVFsSOCoI2rTQU2DTOLn1bvZ
   NuCA92XnMdksRKOjwhMi70faDYmU98jFsXIP96gIyRvppMo+s82Rhub/a
   ihDbqOjOPNPlGnbKWGWR7p4BsEgwfoY9ecwdBtgn5jbFBchvAg5CR3hKT
   PaEKALv/UpGlCHVFADU4gGsa79jOXFHuvIMICao7cMr2twKBDhIk+uuat
   TirwEFre4IwEZsioowM/6RCuLx4KdoezeyAaggbMSus+KEfDCAfjYMice
   g==;
X-CSE-ConnectionGUID: 7Bw/xP85QUW61iZniNIsOg==
X-CSE-MsgGUID: R6I6qVk/SC+XHjptGa3ACg==
X-IronPort-AV: E=McAfee;i="6800,10657,11510"; a="79064595"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="79064595"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2025 10:41:51 -0700
X-CSE-ConnectionGUID: 4mCMPN8BS4O7xSebv1NLpg==
X-CSE-MsgGUID: V3UhMGW4Sjm364sRwCyAfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="201157953"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2025 10:41:50 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Sun, 3 Aug 2025 10:41:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Sun, 3 Aug 2025 10:41:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.88) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Sun, 3 Aug 2025 10:41:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hLGXJCDniQt6Wh5AX4g7tNNXdLClKt4qm8rmKwmjJ1eBzPfiV1xjJMO6nJ47eBUaH1RkNe6027JAUCaL6Qh29CdUcL9IgzOsSTUhtedKeYsBbeuXM2cdzU9COHLSkrYnl0PJjItbK20d94sorpNKZGs/HE+shazXilDyeaey+o6kfrmwgk/p8OTZUuIRTi2MzSwnzNoOwCs+ScnhsgZxKfiFylAHW+RaIFICkTdYXxAy/AZFK/3NwAcx0u4vuXQttejFl7XdFdrAyIq4nwnTyb7m0hoFFJe7c6NretGm1cHEjSLerA8rZfnEr5NWV/y1rQoBQqGSoTtRYatkCQOL1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kiUErEqCA3v9gmXTeypINXvolsYPc4WYFjelQKUOBV4=;
 b=bKZaIKus14ihkYB/awGtsKqJZHpEp5nJkjMEynPkAsN295Sse8yB7IkqVtd+HLKCchYuUqEHplkRdeeJAQ+UWRB//FoLDw8ysLAb49HGrFb/iHQP9UiZulwHAMxkE0l3PZ4f6H9a2Nk9dHLMGhu19HFmiRqhbRh4ybOUpk+hs+iwZUwuB7cci84uD5fX5ohEWgVZnNt3TIwdeQb/XCG6P8C7UHgs2fyHkPBMHecF6YU2Z/2q5o0cUC4caPVPY9ig4k6L7Y6caX4/GMViSuck5pFx/Qk7b1YfsTmFmeQnl1+t/BxqMS3eTQO5SUOcgRm4Zepx1Zj/emGtP5GGjZ2GYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by PH0PR11MB5143.namprd11.prod.outlook.com (2603:10b6:510:3f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Sun, 3 Aug
 2025 17:41:20 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.8989.017; Sun, 3 Aug 2025
 17:41:20 +0000
Message-ID: <4269af34-e606-4096-ac9f-3a958e6983a7@intel.com>
Date: Sun, 3 Aug 2025 20:41:14 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Vishal Annapurve <vannapurve@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Nikolay Borisov <nik.borisov@suse.com>, "Yan Y
 Zhao" <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
 <20250729193341.621487-6-seanjc@google.com>
 <b27f807e-b04f-487d-be13-74a8b0a61b42@intel.com>
 <aIzu4q_7yBmCIOWK@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <aIzu4q_7yBmCIOWK@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0306.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::16) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|PH0PR11MB5143:EE_
X-MS-Office365-Filtering-Correlation-Id: eb173d18-f57b-445e-c9dd-08ddd2b4f460
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VmNRKzM5OGNYYWY1QjRON2E3cDkzSTJna1hPbXJLalQ4eVZnNE05bFhEb2dQ?=
 =?utf-8?B?ejc5UnB6bWpnemhLVEJHNjZ0Vm1ncGpaUVJ1aWxoaUg0UUZMSnlaWUttZmpu?=
 =?utf-8?B?ZlF4RkNkRDJYaE9HemdlTXhoT205b2V6RGUwdVRIUVhmNjVzT1MyTndSVjBO?=
 =?utf-8?B?OHFRY1BXRlExMllvRE9QWFdSSUMyaUtyRHUwY1VHNHJEOTZsNFhkQzVHTnpD?=
 =?utf-8?B?Wnd1dCtVMWlMNDRQakhYMytqcnc2bGwzZE5FeXIrRVRTRi9rM3d3OFZIRmFu?=
 =?utf-8?B?UzhWaXprUG1PSzFOVEZPUDNETXRzaWVpU3crRWxGU1Ryb1Y2Q2RKdnZxOWl1?=
 =?utf-8?B?RUtSVmR1V1FHdlBZODYrdElQaWFReFh2cjV1Z2pTY0tZMmdNM3RTK3czL0Er?=
 =?utf-8?B?dVVLTUVySTExVStpc0lWaWt4OG5GdXorNEk5Z2JLQjBnbkFCSGU3S3NTWEhQ?=
 =?utf-8?B?aDU0b2ZBdFRTZkU0Z0JPaVVVQ3A3S1A5VG52eUM2ZDlnL3JSam1aTVdKUnBY?=
 =?utf-8?B?REVjNkRaMG1nalI4L2IrRXFheXVjenZwSjhIZlF1VVhPR2ZWREpUUEpoSEZI?=
 =?utf-8?B?dDFNYlVwWnQwN21nejQvVlVWenJIbXoxd0d5c3FRRngzYmxIbWRVUmNzQmFR?=
 =?utf-8?B?emFFR09iRXNFS1pSTXpLVmlxUVdQeTNjRktLYTFCMW01UGxmaE9tbGlWRG5u?=
 =?utf-8?B?V0pMUU9VeG5WSWNla3czRk1JY2p1aW5rZkNUMEgxVnlMSHdrY3VsU0ZUdE9R?=
 =?utf-8?B?alQrY25MSjhxc0hrdGZFSCtHYnY0MWlXOWZMT0k0aWlEOG1zWVl0cFJLa1lz?=
 =?utf-8?B?MUxNVlBmZE9BR1VlTGgzbloxb29OWVhPTFVYVWtLbWViM0RweDJqcENIVHNq?=
 =?utf-8?B?SjB6WmppQ0ZQaEdBaGRqWlovRTdpU1d5WDZ4SUQwQ0tDTUpNeDFXM0ZpNnVN?=
 =?utf-8?B?WWQ1QVo3dWdLSXhYWXhGQmR3Qi94Y0szZjltSEZXMFpiTkYrZWdJZkdoWm9C?=
 =?utf-8?B?ZElNTkk5MVV1dk5saGhPMmlSR2l6Q2o5SWp0aytTU3I1TlVxOTh3d3l5S0s1?=
 =?utf-8?B?ejVDMThMbWU2QlVpWjBpclFjdHU0TERadG9OQVB3TklrRVJRWXA0QkZjZ1c2?=
 =?utf-8?B?SGd4SDY1S0NVSDdJS2taNmdIOGU3WEdiYmpXRDNORCtEWUxiWWhuOXdmeElF?=
 =?utf-8?B?Sm9ob25xd0U0YmU1a2lzclRHK3J4cUJma1lnNVZNZWc5dzZPRGlSRjlMQVBF?=
 =?utf-8?B?QlEzVFRwaStST0tuak9Id0dUR1dsMUZBcTNJWTV1VHNUcWlDN0cxeVhPeVZt?=
 =?utf-8?B?aXBmMWpYYzdEUjVjS0ZrTjcwRU9MRzBxUmVMM3pJbDlLR2RrVUc3dTFLRHFG?=
 =?utf-8?B?dURRSm1IbzBZLzVlMEh4R3VZU2tlZDhidFlCRjFMbEpMYmdpUnM0MmJmNEJ6?=
 =?utf-8?B?RGw3NHN5b2JGczN3ZkdKVzU1UFdxSHY3OWRoMHVHTzEyUjRtTVpBcnpoUXdP?=
 =?utf-8?B?VzBUTEJ6RHFFOFZnSi91dkFyT2RYa1JxcWtuWWNqRFNYNWFFNVlGRUxaTHdl?=
 =?utf-8?B?WWxOdWFWaExmb1RxNWcvWFNzV3VETW43blFnaEFjTlNtSDlaYUpBOHJpTXZI?=
 =?utf-8?B?aFFFblhNT3hzbzdNVmE2aUZtRWkrT0I3aDFBK0VnN0cxQ1pJVjVjSm1vZXkw?=
 =?utf-8?B?a3pQNFREV1lRcGV5MHBaUkVsTmxENGJBR0tLOU9zTXNsMWFmUDRWTFpHUWxh?=
 =?utf-8?B?ZjExZVFaK2hmY1NQaWJyUUd2RGx5UU1JMzhnWCtnRytKYVVDTWFGSEc4Uk14?=
 =?utf-8?B?QTB5TUJYeWNsZ1JVYm9zeDhwZTVpQjBmSXBRdDBwTTMzU0V0d2FjYnVaTTRt?=
 =?utf-8?B?WDY2QzJKYkx5dk5VVktFZEJhNFFUV2JDK1BCb0NQbGM1KzlwZndjaFRQRS84?=
 =?utf-8?Q?Sfp6D/Am6Pc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2I3MHFzbUJqRHdzckdZanBKWWVUNkxEb3l2OGxJMmRyTkpWenZscmx1M24w?=
 =?utf-8?B?alRNT0d3cmJsL0ZtaEloaC90b3hWR3hEZG5TWmZCbVhlNi85NFB4ME1Jcmp1?=
 =?utf-8?B?aHNqQWMwL3FURnNNU2tMSUJXUTR2a3FibktzNnBHOWd4TnRGeWV4Um5mM2Vh?=
 =?utf-8?B?MkxObXFTMzd4YVpUV2ZLcHh2TXVhaDYya3dHa0YrN1NkR1ZoVllTS0N5NlNN?=
 =?utf-8?B?d2pCTWxPWWdPdC9Uem1neTVQZzZFZzhmQmF4ajlmQlBhbUlrVWdNSm56c2lj?=
 =?utf-8?B?SStYbDd4L0tscVBxZUhZMnUwSk5MbC9uNE1yWTZkRHozRHBPWWE1MEdmblJP?=
 =?utf-8?B?N0lsQWprb2hrTDEzK3pEdnVHNUtKMkl4K1dua2M2T3MwanlkZlZVY1ZQa3o3?=
 =?utf-8?B?QnByd2gyOE1VcDFwRDliSXZGczlid2RCK3Z2OUdCSHN5bE05MGM0ZWZ0TUVL?=
 =?utf-8?B?OFJQR2oycEx1MmRKM2hJcndLZnVDTVRqemZwdVNoMHdCbnJSNHNMcG05c2Uy?=
 =?utf-8?B?QlhWWm9XU1pLdFB1TXl6T1J1VjQwemVjcFgvUEpoQTNhNEtxcGh0OGZaejJu?=
 =?utf-8?B?cGxvQzhVSG52V3lSbURhckQzRFZPaE5wblZOeG1qZVZQK1JKNW5hVTU3OUR5?=
 =?utf-8?B?MGp4aldZVnBWS2Ftd3BsUGlmMStBVnpNSnJLYTB6TDh6YUp6L3ZwU0NXWWsr?=
 =?utf-8?B?TjRkUlFDWkR6NmMxd1NLOFh2bWtPYzBoazQraHM5cEFuV3J2eWNWWEZlRTJ1?=
 =?utf-8?B?Y2kvWGZIanVGNEczYnpqUHY1anRyWVBXR2VRL0EvSzE0dUV0MTF5a2kxTVhG?=
 =?utf-8?B?c25QR0todUxnS2RnQjRHb1pFRlpMSWJBbmNiWUVlbHpCZzZXa3ZRMW5GdE5E?=
 =?utf-8?B?MmcrUGdXODhJK1FkM0IzS2F6Z0JCVmNNcEtuZjlVVjhRL1ZTSXd5V2JIUTN0?=
 =?utf-8?B?SWlySXYvakVZWXVCU0tLMklXUmJPNW9ZRHp5M3FVK1JqZXdVSWpBY2ROeCsv?=
 =?utf-8?B?N2RUbTFwMzkwUmNmVHBYREl1TXh3MWpJTEluYmFhaGswakc3azlrL2I5ai80?=
 =?utf-8?B?YWRtUWxvem5pb2pDUXJ0bDNsN2ZFK2pzdHBhdUk4c1pYUkxydDF6VjhUTG4v?=
 =?utf-8?B?a2dGcVBvbEVoQTFZYkdoYThmY2liL25hOE1EZ1JjZndlMkVrSHlOQjFtWTdJ?=
 =?utf-8?B?UFR5Sko3SUhiRXlibys1dG9xRXMxUC9vWk15QXQ5dEhPZkJmSUt0K2dTMDcy?=
 =?utf-8?B?aW5VTk1Yam55aFVUcERBcms5VGpoN0ZZUjBNcjVMUUExT1JBSllwUEZ3TnZy?=
 =?utf-8?B?YUFSMmFMT2MwTEFLKzlxbWFpa3B0RVo0UE5hY00rMFZZUFdXRUtCeWNZS2ZG?=
 =?utf-8?B?QXVCR2x3M2RERXF4Zld3dlFhY0UxWnVIbXdjKzhqcG5QTkNOV2dWQW1pSzAy?=
 =?utf-8?B?ZUJZTVBFN2dDVGFOUTJ5NUwra0JaaGRDSDBlWUp3S05nZTZaYWpjblZxUGFB?=
 =?utf-8?B?WWJLMVhCTERLSFJMYmQ2QmtCZ1FJalZXc25ldVQxT2NOeEFLT21zQTYvZGZv?=
 =?utf-8?B?bWJzT0hSMWZ3Tmo2TUpwU2RaczI5MCs5U1dTc2dRMjIxYzArRGxSSkhITERI?=
 =?utf-8?B?Mjh6bVdLa1c5WVVWR29oQkN1UVJ5VEZWZko0anEzblZ1bm16NFZlSEw2a2tq?=
 =?utf-8?B?bzh3ZnJkaEVPWGNZMUFKU2tGcFFXOHNJUXg5RWM0bnVrTmhkZWZpdXI2d1pI?=
 =?utf-8?B?YStEUE9tWFBqdERsNGcxbXBXd1V3U1NEZFZQQzRTRk1xcW9tU3h5eXlWMHlX?=
 =?utf-8?B?NEpadWZDTTZaYVk5Z0lHaC9OdnlOR0pkOVJBL2Jhb1MzelRCWFpoR1ovNUx1?=
 =?utf-8?B?NllkU21BVUxVNDFxSlpkeGZPN1pDbUVJOTVEOHFaVW5Wajk0aVNJbUM1aExh?=
 =?utf-8?B?L1Uva0Jmd05ZYkU3Mk0yUzRoaVpndzhsQ3A4WmhhREdRK25FUGZnNWJpR2FK?=
 =?utf-8?B?bUhRd0MrdDEyVm00OHpVSlR1Y054TEdOWU1OSFRQSTN3QWk0UXJ5WjB3QWky?=
 =?utf-8?B?ZlpZeDZzczFycENCM1R3N3lOa0NVVlJHVDJOdndDOFA2RmRVRmdPSkR5eXhl?=
 =?utf-8?B?R1hrZVVaQm1qUDZhWVBtcm5RbUdOalF5dFpaRklmNzdFYk80WTdZRVhKWm9G?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb173d18-f57b-445e-c9dd-08ddd2b4f460
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 17:41:19.9164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+owsXmwIrJIxoP/1Y3egE2tjlxME46kXAppSYYN+gf1Mmt2HYAQaHSbBwjAB4q9CY0Ttw7a+QI/ejw2LcQ7eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5143
X-OriginatorOrg: intel.com

On 01/08/2025 19:44, Sean Christopherson wrote:
> +Chao
> 
> On Fri, Aug 01, 2025, Adrian Hunter wrote:
>> On 29/07/2025 22:33, Sean Christopherson wrote:
>>> +static int tdx_terminate_vm(struct kvm *kvm)
>>> +{
>>> +	if (kvm_trylock_all_vcpus(kvm))
>>> +		return -EBUSY;
>>> +
>>> +	kvm_vm_dead(kvm);
>>> +	to_kvm_tdx(kvm)->vm_terminated = true;
>>> +
>>> +	kvm_unlock_all_vcpus(kvm);
>>> +
>>> +	tdx_mmu_release_hkid(kvm);
>>> +
>>> +	return 0;
>>> +}
>>
>> As I think I mentioned when removing vm_dead first came up,
>> I think we need more checks.  I spent some time going through
>> the code and came up with what is below:
>>
>> First, we need to avoid TDX VCPU sub-IOCTLs from racing with
>> tdx_mmu_release_hkid().  But having any TDX sub-IOCTL run after
>> KVM_TDX_TERMINATE_VM raises questions of what might happen, so
>> it is much simpler to understand, if that is not possible.
>> There are 3 options:
>>
>> 1. Require that KVM_TDX_TERMINATE_VM is valid only if
>> kvm_tdx->state == TD_STATE_RUNNABLE.  Since currently all
>> the TDX sub-IOCTLs are for initialization, that would block
>> the opportunity for any to run after KVM_TDX_TERMINATE_VM.
>>
>> 2. Check vm_terminated in tdx_vm_ioctl() and tdx_vcpu_ioctl()
>>
>> 3. Test KVM_REQ_VM_DEAD in tdx_vm_ioctl() and tdx_vcpu_ioctl()
>>
>> [ Note cannot check is_hkid_assigned() because that is racy ]
>>
>> Secondly, I suggest we avoid SEAMCALLs that will fail and
>> result in KVM_BUG_ON() if HKID has been released.
>>
>> There are 2 groups of those: MMU-related and TDVPS_ACCESSORS.
>>
>> For the MMU-related, the following 2 functions should return
>> an error immediately if vm_terminated:
>>
>> 	tdx_sept_link_private_spt()
>> 	tdx_sept_set_private_spte()
>>
>> For that not be racy, extra synchronization is needed so that
>> vm_terminated can be reliably checked when holding mmu lock
>> i.e.
>>
>> static int tdx_terminate_vm(struct kvm *kvm)
>> {
>> 	if (kvm_trylock_all_vcpus(kvm))
>> 		return -EBUSY;
>>
>> 	kvm_vm_dead(kvm);
>> +
>> +       write_lock(&kvm->mmu_lock);
>> 	to_kvm_tdx(kvm)->vm_terminated = true;
>> +       write_unlock(&kvm->mmu_lock);
>>
>> 	kvm_unlock_all_vcpus(kvm);
>>
>> 	tdx_mmu_release_hkid(kvm);
>>
>> 	return 0;
>> }
>>
>> Finally, there are 2 TDVPS_ACCESSORS that need avoiding:
>>
>> 	tdx_load_mmu_pgd()
>> 		skip td_vmcs_write64() if vm_terminated
>>
>> 	tdx_protected_apic_has_interrupt()
>> 		skip td_state_non_arch_read64() if vm_terminated
> 
> Oof.  And as Chao pointed out[*], removing the vm_dead check would allow creating
> and running vCPUs in a dead VM, which is most definitely not desirable.  Squashing
> the vCPU creation case is easy enough if we keep vm_dead but still generally allow
> ioctls, and it's probably worth doing that no matter what (to plug the hole where
> pending vCPU creations could succeed):
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d477a7fda0ae..941d2c32b7dc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4207,6 +4207,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  
>         mutex_lock(&kvm->lock);
>  
> +       if (kvm->vm_dead) {
> +               r = -EIO;
> +               goto unlock_vcpu_destroy;
> +       }
> +
>         if (kvm_get_vcpu_by_id(kvm, id)) {
>                 r = -EEXIST;
>                 goto unlock_vcpu_destroy;
> 
> And then to ensure vCPUs can't do anything, check KVM_REQ_VM_DEAD after acquiring
> vcpu->mutex.
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6c07dd423458..883077eee4ce 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4433,6 +4433,12 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  
>         if (mutex_lock_killable(&vcpu->mutex))
>                 return -EINTR;
> +
> +       if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu)) {
> +               r = -EIO;
> +               goto out;
> +       }
> +
>         switch (ioctl) {
>         case KVM_RUN: {
>                 struct pid *oldpid;
> 
> 
> That should address all TDVPS paths (I hope), and I _think_ would address all
> MMU-related paths as well?  E.g. prefault requires a vCPU.
> 
> Disallowing (most) vCPU ioctls but not all VM ioctls on vm_dead isn't great ABI
> (understatement), but I think we need/want the above changes even if we keep the
> general vm_dead restriction.  And given the extremely ad hoc behavior of taking
> kvm->lock for VM ioctls, trying to enforce vm_dead for "all" VM ioctls seems like
> a fool's errand.
> 
> So I'm leaning toward keeping "KVM: Reject ioctls only if the VM is bugged, not
> simply marked dead" (with a different shortlog+changelog), but keeping vm_dead
> (and not introducing kvm_tdx.vm_terminated).
> 
> Thoughts?

That covers the cases I listed, so it is fine by me.


