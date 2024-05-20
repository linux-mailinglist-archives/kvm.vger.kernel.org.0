Return-Path: <kvm+bounces-17798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 694BF8CA406
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E77071F2272C
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 21:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6AED13A257;
	Mon, 20 May 2024 21:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ingdq8Ev"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077C51386D5;
	Mon, 20 May 2024 21:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716242282; cv=fail; b=nftyNLP7IaQ9l1OvPee4iwuVgNOHQYfDlMVlzyAElP2tsvlAl+HO6qtDCdEYyuLHyIOkSRLnASh6cC8TPn7XxsLi+YBK7Hi5IaR7BUcX5eEPauOTfF/L5f1oLUUyFGh/MLzSE2VEHxwY4GV1hEEcegvfjcKHyjEiVzqABI7zaFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716242282; c=relaxed/simple;
	bh=LqQl9jwGfAT8Q649fttVW7r2cSNNslp8A73ARchFxZk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WxXaOtKqoDnOrrsTppakv6AREuOOknQhs4C4LSykJaDXomnyMZJzj8kOHQsccOxUmjYXRgtWf+qFJ6A3Ygw5BJ6PWIWC8MuxqC8S7zvJPc1Kh01n3Fi0DBNcxAtCCvcax/3UnhvJ2DfL/l+EmVh8v8/adY2DHQInmHIqgrS0bhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ingdq8Ev; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716242281; x=1747778281;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LqQl9jwGfAT8Q649fttVW7r2cSNNslp8A73ARchFxZk=;
  b=ingdq8Evv8Zgiu6ujfd0xZfdnBB+7NaZ/NAxKO6HM8pwSioLzvp7UOxn
   nc6avqlPCjvvFvRXJv1QR2WXuXSc1lGCX9dGADW6FQ7mEflMBegPyzStR
   uHW8lbbIHCOHM+QvcVDHikw4axyHYM39aN2WehvNC5xR9Af/s1uaF6RBi
   Hl1QpGbd+ONrSWOCNBhmhA5Xsth6auyUrxlmp5MWRHaTA99sRf9kkYZLB
   osbTnGvoB1fBFQir/WUY+iwQXX8yHQf0gJ3OEtDCAazYXV935lZ8lIFOD
   fnlGHxvFxGZ1ADlrArjUPGB8IhrRK63kLDdDjyk0vu7AdNQf8aqcCbRGB
   Q==;
X-CSE-ConnectionGUID: yDKEoQvqROy8tBO7BAi6wg==
X-CSE-MsgGUID: cORKwRP6T+WB/iNMgWDpCg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="16227881"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="16227881"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 14:58:00 -0700
X-CSE-ConnectionGUID: g9f7aNBhSOK+vsGe2RdU1w==
X-CSE-MsgGUID: t7IVyBd6T/magHJV+oIQ9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="55924762"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 14:57:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 14:57:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 14:57:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 14:57:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZ8dK0ULLrVHXeX6eDCHbN4v/WdRWLlYpVGQ5VigS7tC7ys8X5ByTgNxKrOxBsk1GX4vDTWk/idgNGsO7pf1PoSCjFEGqRNp2+jj8shm+Yd6I4n0bI2xJD3Km17+1reSOSiO2lEgUBbhJp4WXVYDxg3PzWxDQZLFZ1WFTK24etr05V+ueq3dpKd2KDpmhZ+nYu2Fi5AvhgD4Jrblx3/jOSlJU1HxKEJJuLUXxEHsCLQkQaPZQm6fW3mdG0d8mbnzVL+H7MYgnPqICdsW75A7qA59Ojv7CWlXV5bOFNSlivV1hxtd0MmF5Qf0mM/t+yyy19qhFRUC65Zeg3vV+ypO8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGOj1mhhvm05e7n36YqO+LEBgn9dg9h3Twj3Oo+fac0=;
 b=Ze+P5fuJhPupxdiSuEwG6MztmHBDNBh1cuHR7oTV5LrNQ9AWe1XwHWPVBzPIFyBXQWAZBf/O1tRt/cXAy7FhUT37GHjge7IR3diHaexc4S5yR7QhRNVOvGN+jzbRouCt/hGQf1t5xa7s3M4pHoeztft79FA54TXve8NI7oWlDw4kr1tBI3tsl9krof+UXfCwV3v4q+DWb2V6ACzU62GoAUR5D1PiIK34xfHpi/lKaLRWWw7Dwd089nK3GpruGBEL/fWCssj14QUJsXhsMBfxpG+m3Z4feSQNuwVF3c2n8EL09r9Mbnzgby1wHfCusg2YqUskgLEEZMNn2dRx9ZF9eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5064.namprd11.prod.outlook.com (2603:10b6:510:3b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 21:57:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 21:57:55 +0000
Message-ID: <e771a7ba-0445-483e-9c42-66bd5b331dce@intel.com>
Date: Tue, 21 May 2024 09:57:36 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 13/20] KVM: SEV: Implement gmem hook for initializing
 private pages
To: Sean Christopherson <seanjc@google.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "tobin@ibm.com" <tobin@ibm.com>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "alpergun@google.com"
	<alpergun@google.com>, Tony Luck <tony.luck@intel.com>, "jmattson@google.com"
	<jmattson@google.com>, "luto@kernel.org" <luto@kernel.org>,
	"ak@linux.intel.com" <ak@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "pgonda@google.com" <pgonda@google.com>,
	"srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
	"slp@redhat.com" <slp@redhat.com>, "rientjes@google.com"
	<rientjes@google.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>, Jorg Rodel
	<jroedel@suse.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "kirill@shutemov.name" <kirill@shutemov.name>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "ardb@kernel.org" <ardb@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-14-michael.roth@amd.com>
 <41d8ba3a48d33de82baa67ef5ee88e5f8995aea8.camel@intel.com>
 <ZkuJ27DKOCkqogHn@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZkuJ27DKOCkqogHn@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0069.namprd17.prod.outlook.com
 (2603:10b6:a03:167::46) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB5064:EE_
X-MS-Office365-Filtering-Correlation-Id: cb468082-4150-4661-9f2b-08dc7917e72f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z3orNEZSdThlTDlJUmJ0K1FYcE9qeVZ1OU9IcUt1WXlGQTJlZHp1N3M3MzRJ?=
 =?utf-8?B?RjVCTmxiT2JSMU82Z1ROeGhrOXpKU3dsay9reUY3dWhMU2d0M0xwZjZVejdu?=
 =?utf-8?B?OGYyL3o3MXBrZTNyaHRJeDJoS1lEZUR6Ym9qOGViYTlwNXpuSXRJTWdpV0Jj?=
 =?utf-8?B?bVBaRUtpSGhsRDFDU3pRTngyaFdMZ2JjVjRtWUorczRQKzcrT0lrL2xoTjdL?=
 =?utf-8?B?Tkt2RmVmUUd3SjFac3NuZTZGa2ZvbVlOVjZXVTNMSHdiMjB0WnV2cWUza0ZN?=
 =?utf-8?B?ZHV4VHo3MGV6MWV5Sm55b1A0aVFrSmYrU3hJaEV4WHRpQzY4eU1TdUwvQkN4?=
 =?utf-8?B?TGthZDFHRVcxd0FTWEJqdTN1NGVuaS9CZkduNEF4dEwyUjNOUS9MTE8rVjdR?=
 =?utf-8?B?dDFGeVN0Y0JkVjFkR2F6ZnhmTmd1dTdtQ3BzMVZxRlVmQTNWN0NydisyNnlj?=
 =?utf-8?B?YVk5aWpmV3dPY3RUb3RoWFhQODU3UmRYekpRNFVHZDlMSS9hZUd3MUwyaUZN?=
 =?utf-8?B?OHBqTjZtNVZyYTR4M2tTMUtuUmdoS2gyOFRTTjJacVZScmVNN3RKd2FQU0RJ?=
 =?utf-8?B?bVo1Y0Q5cTJ0N2RPdTkxUGllSUxHVFN4Q1RzR1RFUm52TjAxYzVNQ3BMWVFL?=
 =?utf-8?B?THBhUEh4ZFJIZ1ZJcEdPajgxWDR1ZXg3a3d5aXloOC81WFFOQnZaK1JxMndM?=
 =?utf-8?B?WHRsN2RkSVgrN1RQUnU2VDdzbHlZN0g5Z3hISytsZ1JFWlZMRnNXdjdZZmtq?=
 =?utf-8?B?djAvNjNzZ2dKcUFxMVA4SzlhVkZBdXJCZ201eEVTMGVRRzZGSDBhWCtqM0g5?=
 =?utf-8?B?NHNLSEtKM2V4c29GK1ZKb2VJZlNTQnpiQjZGZ2ppemFUQzRsYmw5MWE4YWFt?=
 =?utf-8?B?Tlp2M1M5MWJvWmtjT1RqbFRTdWt0dTdoNmdSNG54NXVGaTBDbEJ2V091bEEy?=
 =?utf-8?B?Mm5VekJIcCtQcXJIc09vMTlHUUJOUjhNZ3Y3QVkrK3Nzc2JCbEdDYXNoeU1y?=
 =?utf-8?B?YVprVUNFdktVMnd6N2Y5a0JmUzJ2SzZpRHliNkhGZEFISnRST0U3bjFhdjUv?=
 =?utf-8?B?VlRSOWlJaSs4UndzNEkzS1h5SWo1M05XYXFpSjdCcVdORHB2UWQzTk5HRDhE?=
 =?utf-8?B?eDBVZmZaSXJXbjdCUUdodTdCeFBXNWwzOWdtU0t4UFRxc3FKRFpNbDBxeXpO?=
 =?utf-8?B?VExJTS9qNXl6S2F6YkRBOU1kK21KVW5lSkpEM0VSS2lyelBlbFpmRmRMZEtQ?=
 =?utf-8?B?dmZZSTZrck5wZTd2VXNqY090U2hYY05Gd3gwY2NNVkpzQll4SVNCazh2SlMx?=
 =?utf-8?B?UVVoZTY4K3dTRitlemY4MmhLb0Uyc0dFQlBWdTdzWm1IWTRsRkpCZVFHN0Fi?=
 =?utf-8?B?WWhsNkcva0RPeDdMZkg1ZGsxaDhCRitDc00zWk9hZ2RJcVc3WTgvaXRrRmk2?=
 =?utf-8?B?ZHNOUGY5cFB6d1Zmc2ZvUjEyaHAxRnhybEJIQ1diTllDZ0tKN2J6S0toSUcw?=
 =?utf-8?B?MkVVY3FkV0E4cDJuRU13L2Zpb2REWnFOL1l2emh3MzErQ0lvYXZqTlE5bVNO?=
 =?utf-8?B?NkxTTm51U2Y2Y2IxcGRVUzhPY0swaVpETkh0N3ZqUHdjbHlVbVBweTNlNEta?=
 =?utf-8?B?RzBSWFJYSjEvUk9uMDhNdkY1YUtHQ0RreFZKZG45UUUwTDAycmg0allFMFdy?=
 =?utf-8?B?VTloekNXblVQN0hmdkVxelo1TWNNV1R5enN5RGI1ZnRLZGNvdzlLbE5RPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUtaM3Z3SDF6NjY3c3FNa3BhL0hRRldKQnhrL1BCcVdQNXBDd1UyMDNKcmtv?=
 =?utf-8?B?MDlqTEpOT0cvMWwxYnZCUHdqKzArQ2kvYVpNaEtWYWZCeW9LR21KbkRJaWZL?=
 =?utf-8?B?WmdLaHh3OEMzb2ZWSFl3cXEzUnJLNm1YRnQ4YUN6KzZITGVPbi9VSkovN2t4?=
 =?utf-8?B?VnFpU0FpVTNpMThUZ0YwY1ZMUEJaNzVkdTJUTk10NGVreDJwVGxBS2VWU1FW?=
 =?utf-8?B?WXgxYkgzck56MUV2MmFWYjZONjBDQ096YUdZakFyQkR0N2tCYUFnVlRXcndq?=
 =?utf-8?B?MTloSWJKRURpeHZTSVdNMHNiOVU2eXpERHBHSW94VkNOY1dWN0FocENENXgr?=
 =?utf-8?B?L3BoNlV2WGU5YVMycjE3a0MraFJ4Ykw5eWxMOWwzaW42REVvaytKVk5JU0JZ?=
 =?utf-8?B?UmNyanVkMlRJTGNsdmppTVNrVFV4WVNTcHBjUVQvY0ozY0VRVW5KMjF5cUNm?=
 =?utf-8?B?RVBNQ09IQWZoYmxZYXkyekFoLzNzWDhCNHFIbmxRT0Z3Vk5rZ1JFWjhXdlhj?=
 =?utf-8?B?ZU1SeHVaWDJYTWxVZmNZRWZFNk5TMUFHMkFTYWNGbm41OUxBeUI3ME9vTUpF?=
 =?utf-8?B?bG1yOG5pdWlXd1JkNzBPOSs3ZkRWV3d5Y2psaVhkOG9iOU96dyttdGxJdWVY?=
 =?utf-8?B?eVNXbnhTdFM3MDlyWk1RQ3dMZm1Qd0U5d3ZoS2Z0K3IwaitydE1CbU5PaVBO?=
 =?utf-8?B?b3BOVkhYczEzK0gxNzVxeFhiZDZpZkQyTkJXdVYrWVNaZHUzSlI3NmxOWmFo?=
 =?utf-8?B?aUFQeGw3SnZmTDMwU1FSMHR1cHlLaVZpZnpVQW1ybG82VCtkS09acFlaZEg5?=
 =?utf-8?B?RzZKUzhqeDcwN1NPdXMrcU16K1llQjM3WnRXQ3YxbTlxb3V4dEZETGdNNUpp?=
 =?utf-8?B?Q1FyUlFlSVFrNk5FNUNURHM5QnlUaDh0U0FhSUo1bHFNT0N2U1FmeVJTWlVm?=
 =?utf-8?B?cEhQT1QvMXU0WFI3VEV5U0R5cUh0RHhzeCszVWIwdEl5RkJmdUkxYytIY1pr?=
 =?utf-8?B?ZFNsRGNRMXN6UHg2NmxBUHI0Q1h1Y3Izb0d0eXJ3Njh6cE1IWDNNdFl6SWEw?=
 =?utf-8?B?QmkvbkhzR0FFQmY5Z0tMOGJGWlpSdkVhTFVueVRwdmoveEZRQlg5MFpUQ3Yz?=
 =?utf-8?B?VXpjSGwya0U5Y056TzEzaVQvV3A4ZzI5K2dUVWcxS1Q3ZUd0VU5Uc3BxTWMx?=
 =?utf-8?B?eTdxM0VGK0NNVkN2M3FZTjFyUUNUbXkxTGxGUHBnUkt5QVNsMVp6MFo0QjEw?=
 =?utf-8?B?Y0g3WFM0RkprUWduZUtWTHZ1K3h0UTdGZmNqRUlNZ3VnUHNCeTM1TXplbnBM?=
 =?utf-8?B?MnR0MGgwNjZUeDhaQklyTzU4eG9vam5pQnFMTkI5WHpxVERkUVdhTE1ncDF6?=
 =?utf-8?B?MDFsbDJsa1Yyb1RRNW9UYjVrM0tZYUFKK3l4L3pmSmdyMi8yYldYTUhvWGpt?=
 =?utf-8?B?Zjk2MnZZOWt1UzdTeVJoOU9VWmh6bXhqSVBZNmgzdnMwWDRuNFZTZVZjMTY5?=
 =?utf-8?B?V2RNK0lvd2dVR2dQdUl2K0NSaXIvODJaU0dKajA3VHJLT0VQYnJ3UHJTTWk2?=
 =?utf-8?B?WHJxeXRSNGdtczVTK1lhQUJGNVV5UXV0MW1GbW9CUktVM01hdTluUU1uMW53?=
 =?utf-8?B?aDFiL01tVEpld1F6YS92T0tsOStxQ2NTbzZlekl2dDJUSEFUSzZxbExEQWJP?=
 =?utf-8?B?NEplMXdqRmlWL1dMcHJxVmRnK2hHaE1aYUZ3Q2xpT0FuOTRXRUc4eXpSV1pa?=
 =?utf-8?B?RFdUUm54MGFXbjZuL3l6STFhZkFkK1BlWUZ5TisxWWZZMHdWR0NLMVp5R244?=
 =?utf-8?B?RHdTNTRnZlliN1d1bGk2QUtZZnJzM1hXK3dCUkgrci82aDAyQWZPakVLdkhQ?=
 =?utf-8?B?cmc4a3dNYzJnNTZuKzYrTXRtbGJFUFhHcG1nYUQyR2hxYXRsUkV0enlvV1Nt?=
 =?utf-8?B?VUlXQjFlclVsem0xU0hReDgvVnQzZWJSNXpiMjZvOWlwcVhqTzlTSWpZVTFO?=
 =?utf-8?B?QW9nRHJ6Zm13U3p0SFA3WWhpTzVobld1RWh6TGVzZWxrQW9FK1dtcU1wTCtR?=
 =?utf-8?B?OVRPOEpqNEgxMjZCRkpDNlpRdkFLcE9iSlR0NmllUjZVN0NCZ1NidVprQTRK?=
 =?utf-8?Q?CNxS4DhV3/vnVtIFfVlXVeL4e?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb468082-4150-4661-9f2b-08dc7917e72f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 21:57:55.1472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iK2zjqv2LdkV5AYU5TFNYxBqmdh0i/wtRTSpvIiItJtJpZgVU87cIYB+WTvVOxZxv3S24l72LffGyFjJ1V8EgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5064
X-OriginatorOrg: intel.com



On 21/05/2024 5:35 am, Sean Christopherson wrote:
> On Mon, May 20, 2024, Kai Huang wrote:
>> On Wed, 2024-05-01 at 03:52 -0500, Michael Roth wrote:
>>> This will handle the RMP table updates needed to put a page into a
>>> private state before mapping it into an SEV-SNP guest.
>>>
>>>
>>
>> [...]
>>
>>> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
> 
> ...
> 
>> +Rick, Isaku,
>>
>> I am wondering whether this can be done in the KVM page fault handler?
> 
> No, because the state of a pfn in the RMP is tied to the guest_memfd inode, not
> to the file descriptor, i.e. not to an individual VM.  

It's strange that as state of a PFN of SNP doesn't bind to individual 
VM, at least for the private pages.  The command rpm_make_private() 
indeed reflects the mapping between PFN <-> <GFN, SSID>.

	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned),
			level, sev->asid, false);

> And the NPT page tables
> are treated as ephemeral for SNP.
> 

Do you mean private mappings for SNP guest can be zapped from the VM 
(the private pages are still there unchanged) and re-mapped later w/o 
needing to have guest's explicit acceptance?

If so, I think "we can zap" doesn't mean "we need to zap"?  Because the 
privates are now pinned anyway.  If we truly want to zap private 
mappings for SNP, IIUC it can be done by distinguishing whether a VM 
needs to use a separate private table, which is TDX-only.

I'll look into the SNP spec to understand more.

