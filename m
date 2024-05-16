Return-Path: <kvm+bounces-17516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07C5B8C71DC
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 09:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C96BB21C77
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 07:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0BF2C697;
	Thu, 16 May 2024 07:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OfxqUy/o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96CC25765;
	Thu, 16 May 2024 07:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715843598; cv=fail; b=LVp3bxzosCMyKyA+uzubH2EfQmePJcDNR7haUH4vbc0yNG1fVcDRpfIc6JueanI1GsuFreqi2owDMeo4Voz4DudXSb8aGL5GWW93RcLstFY12hW0eU6XVlLl33qFeKK3iQQQwVlbWzlyLJ6sf0EiXXBYOL53NGFG26QEuT+8ROI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715843598; c=relaxed/simple;
	bh=R36CZniN0wmC3lGrYM9EqgGifZ3LYd3NCI2OIrWKb6I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KoJCYtQIWbhWC1maFZDjFZsWNq8usfV+STAKMyGMMHb8nC19/G8WftKX3jtINO5ogk8SeTkplxExVLAjQ1Qzl4sApLYkjS/PWGfGHJqNxT20JNBf4hfLomtU4fCmdGCeymjkMjHKipNLD4Y9XDCxDD8TClhdvfuUaexQy1uo1hM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OfxqUy/o; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715843596; x=1747379596;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R36CZniN0wmC3lGrYM9EqgGifZ3LYd3NCI2OIrWKb6I=;
  b=OfxqUy/ogrBLKdBQ+qiQV1ePGxmT4KoHcD98HgVRyHdTnwwGEopTMA4d
   1rxNnJL7O6GyMFmY+n9atJMtMNJCRViJXitenPNWlWbjMvqIbHmM9x0Yo
   RKEE76GewzRZPf9s/4U5IfFBhCTOO7Fk4xTvUKcGjQ/n20tqcjadqDxcN
   9gT3LRrr6n0JBwwV92ldMEWDCR7gcqmPsBuT3C0nbwy1QpZxJahhkZhiP
   Bx4nlNqPfD+0tGNMt4yiq+QzKqkjqb6KBegiazxzfFkU9NcA4y9MxCDFb
   fwimb8VIk7qq90jM0nxCpwXq+rAoBDsM8wn475Kq154e0if3kzQ3WTFk4
   A==;
X-CSE-ConnectionGUID: 34ODoqroSJuKvdtAIHvZ/Q==
X-CSE-MsgGUID: 6fFTaCSLSNK5jgtBPbcSNA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22512663"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="22512663"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 00:13:14 -0700
X-CSE-ConnectionGUID: slqkkNfdSTGMiDT39s7hWQ==
X-CSE-MsgGUID: pzLCMoYgSFetc5e1Y0VYSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="54531449"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 00:13:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 00:13:13 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 00:13:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 00:13:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 00:13:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FR4XOeIZUzWrE/mNutkLt9haLlCVpmmE1efRLAt3wlLprFEMlNPdpADVCEE59xtmbweGHq8w5pIfcMFVD5TBLXQ+fabCK2dK8BuGIADSEoHGrADZOOrS0sc68rFV6WKleGmZDQmA8RdlW/tVYhv9bpG4cok8ugqttwHfijsjgKy/VdGg9mZFwdfg/Ykfpjw6Z7igSIUAWpRWeNCkGfhjiD/mfOFf/iergfR6jPyeH7Wcfb55uQ3ADCFhXgcLCOgKX/PbPwfs8/OR5AdaYWclMxtp0WghnAZwiEP6J9QMDNy0xJsSNHWwnCPT80jD0Lgzvq3tRFpD6F368AfQwEZQmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPi4mX5huI4X8iGAC7OBNNyGvsJX6gAEm9qB8UcI1j4=;
 b=BtfNSPpGL3o+9N8gDOco0pn+kPwNakS60zgNXrbvT8MH0ESEHWOloSN6rNwL5xSHkBtFfOZipa90A7rNRxOVOQrtuJDnDue15ppFfhe2XwQwpY48+SbjH7CbpUgCyg8/hFxtKQBqbLe/OFK5XMZSGkHWN2+aFN1LejUXL9rk4Zt6H0ItYsOsW7No64SVfXz1Upm/tT/0gK+ch+R94FdWSGDMwomOQCSwi8jmB3OGHcjWv8cZS4ldPvpriNeV4CxwxCGQKXq46rgMXkSRR/TTxlnqP7gabaPaWBv5s2wTXmwTUsi3fEawHPqYKV1lxOutCBSxI2GinY5UEOYsWRWnoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4805.namprd11.prod.outlook.com (2603:10b6:510:32::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 07:13:11 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 07:13:11 +0000
Message-ID: <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com>
Date: Thu, 16 May 2024 15:13:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>, <rick.p.edgecombe@intel.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <mlevitsk@redhat.com>,
	<john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLNEPwXwPFJ5HJ3@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:194::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: be5b2fa4-f7fa-449e-e4ae-08dc7577a4dc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dm5CTmRBNzJwM3lXOWwxY3NlZllkbG9rNk1pdDkyMTFQQitDc2ZJYzdVNGpH?=
 =?utf-8?B?clh6eG5xSTNBT2ZPRG85eE01WkE1V2ZsL1grblhkMWxuVVJrZ1ZnRCtCNFNw?=
 =?utf-8?B?RS9ZSzcrWnlNUTYyWUpQRUdPQlM5YzZ0c0RlRGVwSCtucU1MNXMvemN6M2hI?=
 =?utf-8?B?OTFZcHFFbmk0NHdhdzBiR0FQb1M2Q2dLTFlYdzRwZnFiK0dLLzNpaURrd29j?=
 =?utf-8?B?Q0NDMU5BYlNWZk5VZThPaVV5ZDc4YjJmUC9VRnRrWDFUaW15ek1XMjNHMS8x?=
 =?utf-8?B?bUo2S1NzSXgvaS9MNEptSlRXbzRYdSs0aHJzUENzSmlOZ25JZXV6bE1Zek92?=
 =?utf-8?B?c1dNQUdxZGZhT2FwVUIvdFc2TzFVR0hkYy9iQTF1YTBvblY5Vlh6dzdvK2ZD?=
 =?utf-8?B?Um9ncC83OGNZbitxdHBuQTZmZ3VXZ0lzcjRJZXVEN3VQb1ljTHdDMnYvdmth?=
 =?utf-8?B?cGNoa2VzckxsSCt0azhzczQ0RmdQcXlabTdoQ2JXbEduSDlnaEpKWWFidXls?=
 =?utf-8?B?ZEpiNWNCbUxnSnd0cHdKVnFRTUMySWlYbnN6Vm9oRzU0RGVHQTgyWGh3TXow?=
 =?utf-8?B?TWdvSGFMZFZPZkw1eldJL0hIL0Q1OGxUOUcxUk5yLzdOYzB0SmhzYUUxSldX?=
 =?utf-8?B?Vmc0WGFUMm1UQlVCOHJzVTIzTExLUm5BM1VBNUZKTEN4UVVOQ0F3QndNWS84?=
 =?utf-8?B?T2NEbUJkQVR3ZDdnVm5BREY5ZmxlSitDeS96NEI5MWhLRmZlOWhsdjV1d3V0?=
 =?utf-8?B?NDlmbkNwbjVxZEpvaFBRZGFvNlY3MXpSdy82QWVxdVRXZFdkdE1ETy90Tkdu?=
 =?utf-8?B?Snk5eFlXWHd3TkJQOGJSellWRENvZEJPL2VyZHUyOERRZmExOFFtWjlXcWNH?=
 =?utf-8?B?WkhhSHRST1c1dXVMci94R0lRZ1ptVXRUMDB5eHoyTnVXV3lXOHJQUk9UQ1Yy?=
 =?utf-8?B?VWRaK3dWM2ZOTEdWLzJmWGJXcEh5bXg1YU5NcGpCNjBvVDJZZGJWWUNqYXkw?=
 =?utf-8?B?b1ZVdmVTSEZXUzdUOXo1SkNXMHhXRVREMHpDb0F5RzVGWVQzRjlzbW02a1pj?=
 =?utf-8?B?R1BteUROeXFjN1dwbFg5b0lyMHdJdGtDWTA2MEZha0RUdG9yMUVNOWQ1aHZW?=
 =?utf-8?B?bWR6MjRvQ2xOaWZBNlVZZ09SVzE3UFdGOEJVd202aWtEcUpIWm15aGJrVkIy?=
 =?utf-8?B?N003STU5RC84Nit2ZUJDZStIOGdacUkwZng2SEowRzJjcEg2TEw1NWNiMkFm?=
 =?utf-8?B?ME96bnlGUHJHbmE3Yk5DYmdGcFRJdDVTZWdsb1o3cUo1NnZPcDlOWElRZEJY?=
 =?utf-8?B?MDcwWTJuOWFRSjFRTTFncnZJVERWVC9YdndIMU5HNXRFK3ZGNThKWE9BdzM5?=
 =?utf-8?B?RkRxc1hHekNkZFhTWFlIVFh3b0t4SkdRZWt1SWh1WVE4dWhqMmVqRXJLVjN3?=
 =?utf-8?B?TkZxZFFSZk16S2NENGIrZlJCNzN4eUxHZy9iMmF5YUUwbCttWE42Sy9ZM1JZ?=
 =?utf-8?B?QnJBM2FGdHp6dzBhK2I1S0xuV1R6dUxSM3k5NW1zNDJHYjEwdWtSSHp1Y1dN?=
 =?utf-8?B?V1U1dVBvdTZkblVzY3FzZFhhb0NGREhMSytpL0QwNThHZ0YxcklEVHRWT0N1?=
 =?utf-8?B?dDB6U0U4K3ZDdkRJdWxRTFhVNWpNdWF2RDFDYWNBQjhFakd3Y3gzY2J5a2x2?=
 =?utf-8?B?SC9PZDE3SnpMRTJGdGpkQlVXR2N0VSsyQnpXVUFVMW5HeUJFL3pVclp3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUVKQnhVaUY4TVhrMnlFUGVJRG9JTTloTTZtZ1lVM3VnRnJpU1M1azZTYnhZ?=
 =?utf-8?B?NUNTeWtuc1ZoTkVnS0U2Sjlub2F0ZDlzdXFvMkVLV09kRkI2OG9uaDVqRExP?=
 =?utf-8?B?aXZlTW03ZFg2Yi9MYnVxMGdPZjVoVXJGenc0L1VsSVU4eWkxYzBqTHBwNFBs?=
 =?utf-8?B?UDdUT1RwRWR0d0FEWm1RamRhQUVXTndValQ2Zi9UZXlwVWFteUZwTXQ3bGZF?=
 =?utf-8?B?dUdDbTNWRFlsUTgwdEFqRnlPNEo5eGRCb0FUUTlRZldLMWNOK0dOMjdqK2FU?=
 =?utf-8?B?U0tDY2E4M1V6VmI3TVdqRlVBYWxaOXFHMlB1VjlPTUhoYjFDWWxJSGx2M3Bu?=
 =?utf-8?B?a2ZqcU9BZnB5cmVjampCVkQ0NjlYR1BoMUYrenBBV2s2WVpLOWVmUENmNHRB?=
 =?utf-8?B?Z0c2M0dwNUovZnNPNEkwNzZWYnd1eUtRcThCZXJ2eEpQUkZ1b3FLa3Y5VzFs?=
 =?utf-8?B?TFhBN1M5TlR4T2gvUFJXSml4enRFZUpqMG5sRVNuaExXWFJLVXREby9nNjZa?=
 =?utf-8?B?dDhYOS9Ld3pDdktJc2lrODRSSHBHdXFNVjhjZ2paVHUrZGZpZHJRV1lRSmp6?=
 =?utf-8?B?SzkvNU1UZjB1WlJ1anVhcSttWDBob2NXQlFrMlJReVNiZmJYelNSa1VQVGVi?=
 =?utf-8?B?L0hyWG9MNW9FbUdRTzkwc2drTEo1clErblZKTGIyaFZYQkVKNW9lV1hvQk5X?=
 =?utf-8?B?NzZqNTgyTHphQnBsYVJETkFJY254dWlJRVR1aVRjd0k3eXdXOHhGR01hcG1Y?=
 =?utf-8?B?MXhTMHNqTE1xS051dlhpNy91aUdlQzJmd05YYi9IMXFHWDZCYjl0aW90c25V?=
 =?utf-8?B?NE85VFVuM252TkZYbFVqZi9hbGtkVVA1dWgxRjh1R09rY0hwMXpURkRQY3RV?=
 =?utf-8?B?Q3RwUU9zNjZXWTVaUTFtS1o4K1RHVkpvL0NISXJ4TzF3WDY0Y2sxNEN6eXcy?=
 =?utf-8?B?YnhJS3B4bGprQUZRS3FOaDlsZVc1V05QU3o3N2NYQ0xoVWRHQkU5Y2hEQkdF?=
 =?utf-8?B?a1JvdTZBVlJGbTVqWkFRQUdxU2N5RThFK010aTFxd2JLNUptdEoyS0QzRlhU?=
 =?utf-8?B?REEwVkVaUEd6Mlo2V1lRWm1pWldZMTljQ3ZwckR2SEQ3NXY2Q2YxWUpoS2pU?=
 =?utf-8?B?VGF1VEw1UmFWNHR0OHdqc0F0SG1SbHpJTEJBSWJHRFl0U0ZMNHp5bFU2YzlK?=
 =?utf-8?B?WS9QTGtyQ2FXa2ViWUpUelhFdVoveDVDN0VMUXNIQkd4c0diTDNrVW9PYnhS?=
 =?utf-8?B?Q2NNbUNIb09GUVc2d3ZKU2hua2hqSzhLT01KZkV6cEJ6eGprRk9qVS9UV3dn?=
 =?utf-8?B?aWF6S00wY01VWmk5NlVrZUJQL3AvTG5sSVJ5cXh3WFd6YVQ5emJRNFVYOUtH?=
 =?utf-8?B?empGM20vWXgyQklMZE1xbGZtelNtOWlGZStFeW1maVUzYjNoUU5BUUtNZUpK?=
 =?utf-8?B?alRISkhLZHNKV3pGVEEybGhVTWNidy9mS1BrcVl2MUJIWG5WRGdVTzFncXU1?=
 =?utf-8?B?WEw2VU4raytiTGE3NnprRGNZZFc5RWFXRHM0M04zWnZsdjJtVjlvY0VSaE9M?=
 =?utf-8?B?OG9uQnZQbGkrVlBadFc5ZXJCdjR6M0M5UG55TDVLQnFNVnN1QWJkOWRKU1c2?=
 =?utf-8?B?MEh0OXdnVW91M01jcjNsZDV4Y0VEWWxCampaeXV5OUxmSjJRRzFmTG9CeTB6?=
 =?utf-8?B?OUpLSnIvMEdGL3Vwai9rdDRnSGpsZWFZejZHY0tTSTdXTVdVUWRTV2VyYXdq?=
 =?utf-8?B?aWZKOFh3NXg2R3krNnJyd1lSbEZYWXpFV3dUV01nS21OVmtWSzAzbGFVc1F5?=
 =?utf-8?B?MDNGS2pZU1dhaEtpWkdXQTZhajFTSTQ4NE9NaHFrV2xKeGV2QlNxeDkrWU5J?=
 =?utf-8?B?cFV3clBKRUlqQW42T3VjSzRzYU5YWngzQUV5SEVLbjZFT0NNTUVqcVo1THgr?=
 =?utf-8?B?blp2RFVRTnZOSVBBWEpvZVI1cW1kVzM4eWtHSlk3MDJJVUtnU3pLb3pNYkcv?=
 =?utf-8?B?Nm1wL084elV3M29FZ0RjUGh2ZENxRlRYRnpwRVRYNHdnWjZGTUlwaUhWMm5I?=
 =?utf-8?B?aERaRUREVndHU0ErVmJjSGl1R1JCVXJGN2RhMnBFVFpTTWg0MUZMcmdtZkRt?=
 =?utf-8?B?dHl3dVpwMHFlekgra0JMK0xYVFlNVmhrSVZjUENwOGk5OE1CbmcvZ0N1a1lE?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: be5b2fa4-f7fa-449e-e4ae-08dc7577a4dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 07:13:11.0742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLuBivF5aYUCQcQ4tPtpxQWqgCK1DJAUXiAHvgQsGaJFWvWXFbk8HAdxb/B6vIvgdd2RuUKI0DZndtRGiPMtOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4805
X-OriginatorOrg: intel.com

On 5/2/2024 7:15 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> @@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
>>   		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>>   	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>>   		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>> +	/*
>> +	 * Don't use boot_cpu_has() to check availability of IBT because the
>> +	 * feature bit is cleared in boot_cpu_data when ibt=off is applied
>> +	 * in host cmdline.
> I'm not convinced this is a good reason to diverge from the host kernel.  E.g.
> PCID and many other features honor the host setup, I don't see what makes IBT
> special.
>
>
Hi, Sean,
We synced the issue internally, and got conclusion that KVM should honor host IBT config.
In this case IBT bit in boot_cpu_data should be honored.  With this policy, it can avoid CPUID
confusion to guest side due to host ibt=off config. Host side xstate support couldn't be an issue
because we already have below check in this patch:

+ if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER | + XFEATURE_MASK_CET_KERNEL)) != + (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) { + kvm_cpu_cap_clear(X86_FEATURE_SHSTK); + kvm_cpu_cap_clear(X86_FEATURE_IBT); + kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER | + XFEATURE_MASK_CET_KERNEL); + }

What's your thoughts? Should I just remove the quirk here and keep everything normal and
peaceful?


