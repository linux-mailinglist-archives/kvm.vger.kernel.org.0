Return-Path: <kvm+bounces-31197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C83899C1256
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 00:26:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 470C2B21EE1
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 23:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D32A219C82;
	Thu,  7 Nov 2024 23:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KNcSHW+p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F1F19B5B1;
	Thu,  7 Nov 2024 23:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731021947; cv=fail; b=RwlXdNkzMj5/9qhMWk0AOKikcg4UhRKCB2rVERoI4ohXf6as42rUa/zDuLg/Lmc7tii6gAKBTKojTnNaVdRmW56YZZQY5gLJYSlN2ZPqKobfohgZWkYzwG3wLpwrhyBNuiARniHO0+vR+ARFcZVYOKj2tHpQ93uMsgggZK0hWTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731021947; c=relaxed/simple;
	bh=o2IczxdcueVah39dzoB2uXCEcG4ekpy7p+onbDFBqDk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MXDrhUIjkUSjl1vQF+tc2h8OfPcb+KXy+UilAl7heiyvFbVbjvAzc9r5keTxMt+Qkff50OgstVW4bwN04Win83chG9WSfnmVTY2tTDiX96AfdN1hPCpiyn7uGsem0d6xVYU+R3V1PZ3EeddCufUf07xuKjFgGv8HsPkxTk6dX9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KNcSHW+p; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731021945; x=1762557945;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o2IczxdcueVah39dzoB2uXCEcG4ekpy7p+onbDFBqDk=;
  b=KNcSHW+pAYMXiZenubhvI63+6tAjfTc+VieLaR0Hbrt88YFWQ+LmWaX2
   Wee6AcQ1E6tuqp8vZBfCYgm8WshhskG0C+aIZ6X3umwZiWCdkoOM0h4Vj
   F1nlq7XyrfDQ0Z1B6kd9P17P6NRqaJ1ILl3eSL0KlatO4u+MgaPf2cRwm
   BsJdzfnIOTNQRY316tDqv7aFUPvSs0oPi2AL69mFi9N6WkBHR1VkppDt0
   dywUJ56vbgmC+FEpSsPhtSmEJDsRMQsYFueyn80zcHXUCoz6sYfvZs9OP
   ICjAVrO+16P7wRe5CcRvLERduTT4kwF5uaEgBz5TBzpaE2Qm26bdf6Ph1
   g==;
X-CSE-ConnectionGUID: XcOUXcf+T2KWvPd9Y3MX8A==
X-CSE-MsgGUID: o7UhM5DhSZGftWHjjJkJRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34675535"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="34675535"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 15:25:32 -0800
X-CSE-ConnectionGUID: Ot8Y329kTlG1x87rWSu0SA==
X-CSE-MsgGUID: 8hi+qctgSOyEl3ZaaM+o9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="89221426"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 15:25:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 15:25:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 15:25:30 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 15:25:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=retTw2GMLnFBw1lrqPKxPHuUpb2fioActq5GUZtEPPXUqdCrOGvgRTj2soaKvKc1buaQtZdlRVl3bPtEqmfkBSiGrwdpVxY5b490GBsvVpSkqOl39FPo1f1bRyRnFQDyU+J92nmhNpTsJQZO4PQkuw+D17OoRsHi8hvq1aKa/XhRTdN8uM9ErHhIgfzrxfqXWgCmM8dt3iJO4lEeCrYZ+csJAGoujIf301FnaDD/LTGst+Y+IEuMs0KDuTE3gqXKY8gcpIqjqug8qN82U1ZFC6dge8CA+Dvb5uapJgqr07DftXYe/pph8A7s4e1wluVHvlE0l/YipJNgEVANtB/A6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiYd8XVkZeMdYAwcZY4vXCvfRMEMV9WWuj0WRqYTG3A=;
 b=WsLjdQRNp+Hl3iLu+NKSBLOqpdcobcKlLVniWTV3DGotu8aIfDgZU4JxcMvt13Sp2s/H1l7IdJlgJgpj4+2w1xZBmyQ7tpJzaIe9/HZO6cBe1pwLQbp7HuilSv3PS6R2RU4XLsG/727m92Z+ib19lyYdra0/Ttdwd6PWvtfRP1mvlrZ/PoiA+FSB5Xn8NdLIh0CZqvi84odjl8f1EHCu8b36O9RUZiwWDPJKKZA/EpcpF/GwLRTs6Drgm6M75b9DUcBnYAgoDC7ZZsra4m6ef404gIWFbsYT+fAt30R+PkdTb6b9YcCcoEi6PtuTre+12TNViFrBzHlWnAjdRChf5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8346.namprd11.prod.outlook.com (2603:10b6:a03:536::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 23:25:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 23:25:26 +0000
Message-ID: <54c79d38-5103-4233-a903-72e045fc1429@intel.com>
Date: Fri, 8 Nov 2024 12:25:18 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
To: Sean Christopherson <seanjc@google.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <Xiaoyao.Li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
 <ZyJOiPQnBz31qLZ7@google.com>
 <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
 <ZyPnC3K9hjjKAWCM@google.com>
 <37f497d9e6e624b56632021f122b81dd05f5d845.camel@intel.com>
 <ZyuDgLycfadLDg3A@google.com>
 <2d69e11d8afc90e16a2bed5769f812663c123c14.camel@intel.com>
 <Zy05af5Qxkc4uRtn@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zy05af5Qxkc4uRtn@google.com>
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
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8346:EE_
X-MS-Office365-Filtering-Correlation-Id: f4b52a2c-ca52-4a10-20ce-08dcff8375b3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?emRPNnMrdEYzT21LK3pTZ2hBS0VUTXNNMkpDVTVDcVFqaUNRYkhPMnE5NXhn?=
 =?utf-8?B?QThoOGRrcE5BTXRKNUVpcDNLZmpGMmRoWXFEeHVpV1ZkdGYxYi8vUVY4Uis2?=
 =?utf-8?B?MFQxbkVLTHRCM3JHbHU2eWNTUXJEUTJMSHZtSUcvN2xReTNCTHNMSklMdWJC?=
 =?utf-8?B?TzlXdzlDMThRaTBnRW1LWisrMHAvdEdEalVvbExQQmZ5WXI4akRNUmJESGF5?=
 =?utf-8?B?RHdIM2pxUGx1VW9saVFsOGFwUlI4T29IT3JmdU1wZ2NBNE9XVXZqM2c4bTNK?=
 =?utf-8?B?WWc1blR0NFNzaVFlZWU4YWZrVjVKUDI4dXBCd3BMbGRHSkZtekxITGhlK2RK?=
 =?utf-8?B?N3Y2Q05vRE1VUWhCZERLd04yd3hsYVpFQnVBQmR0NWRFS0JkVTZsWTdvdU1F?=
 =?utf-8?B?d2FKcHcxWUtVS2R4eVJFdXlBVkNJUUFUUkNWa1lJU0xNdGFHdytXYko2K0do?=
 =?utf-8?B?Vms2VmRzOXFaTkp3WkFJdVROcU4vT2VpWlg0Rmp1MThVaDBqSXFXMUtKdEVU?=
 =?utf-8?B?dUZTRS9RRVlMcy83WThuemh3bW9YL1VYRUJWUVo4SWREOThUS0V6ZDIvRDEz?=
 =?utf-8?B?ZXRrNGNUWm9RZ0l0ME93M0tWMTNGUE9FSThCOGI0eGZZUlNoam1XNnZhSnYx?=
 =?utf-8?B?N3JXcCtRaVozSWZOUmRPcWN5dnNUcVJDZ1JYYzhaVjBYaGhGYUtLdXRVMGJn?=
 =?utf-8?B?cmg0bkpTUS84WUxxK1VBQXI4bUhTRWN4dzJpQjlWU1Q1aUhJOHk1R3hUU3oz?=
 =?utf-8?B?cll5aVo1MVNPOTBvU1Z6M1VDWWdFNnBpby9mN29ibTJOYkdHeGNEcEhGR0o4?=
 =?utf-8?B?QzJPYTYzekdIN0VHUnJwcFl1SVJabUt6d0d1Z0VYSkNPMm9RcVFITTR5Y3dL?=
 =?utf-8?B?MURFRHFEY0R3V3JVaW5mdnBKd1JVcFBEN0MrcVpTdlhJVnJWM1BrTlplSCtl?=
 =?utf-8?B?dXpuTy9xRE5VNWlPaGRXaFBrU1RKNS95UnBER0pxckJiNkthNmRzbEUyQ3Va?=
 =?utf-8?B?d1QzQm5HVjRQMW9lR2lpQUtrQ3UySmtEWTlTOG4wOWZTR1ZWRHN6VFI4L3ZP?=
 =?utf-8?B?QnlkMFZnYml5bUs5aWFNellVSGw4R0daOFVmMmhabDFUdWVMNDBCT1JZWmtC?=
 =?utf-8?B?WmtFbno1cnVBWE54cVgyVC9TM1hCNlBCTGZsNlRaeEd3WHE5QjZwR3R3T1hr?=
 =?utf-8?B?OFprSGhLYkFBd1VsVWZQMEo3WUQzNFg0Ym5FaFhmdUFwRWlURmZtODZKbVg2?=
 =?utf-8?B?VWdZT2RZLzJCRzBvYlRGQjg3djZxOXdva3QxMWJQOUJVdjQrb0VjMnE0djJm?=
 =?utf-8?B?d0J5RlQ0UmpLY1ZsMzBxOE1Kdk1PWkpWUSsxbi9GVm5QKzQzTnpiem9ZUXN4?=
 =?utf-8?B?M3FxOVFjS1ZBb1ZKK2RyUzY1MEl1NlowcndzSmJqUnZkSlJ5SWp3cnRST3dq?=
 =?utf-8?B?eW8vbko3T2xqSjV6YzBvQ0dmdmwyVHBqcnZQRmd6a3BIS3N6ZUt3dXgzdWRm?=
 =?utf-8?B?ZzlFbzNpUllBQVpTb09oeWpGMVdkVVhiZGx4U0hkQ0FRV1JXOFcycyszRTds?=
 =?utf-8?B?V255bEhVTDZ2QjV3N3Q1bjlBcFJBZksrZXhzajVURGhya291bEh3Q1VIWG5M?=
 =?utf-8?B?Q2hldXNjdFFjRVoyeVgxdjEwNHg0MFYxRk10UnQwVENsSThNKzhZUHRYQmlz?=
 =?utf-8?Q?yVmOhLT6/4la/Vo/a3Im?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWpQT2JvT01TOWFxclFMaDRGZmlNWm1QcDFOU1dXK2gvK2ZEWlNxWklWZHNx?=
 =?utf-8?B?S0h1UkxXU042S1BsNElqUUp5dWZsdlhNcFRVRC9WWEprTnl0aTM1eDkzY1Rr?=
 =?utf-8?B?eVk3S1NzMmxlazNNUjMwWWkxcU5OMkRkbEZGRnkyQXhnZGIxbWM3Z3JlWUVV?=
 =?utf-8?B?U2xqKzBZU1VCQk9pSFpxd3dLWk5aWjNMbXRDV3hKa2dzbUJXb255OUlwM1Fi?=
 =?utf-8?B?ZW1jUmczSW5ubGZvU1dLYm42NTd1c3lVMFRKSjBET1RzM0dFWm1vcGExRnNx?=
 =?utf-8?B?NVN3alZXYVFYOVZLTXViZlFMMWQ2MlpnUStuQlpiaUg5OEpud2F6Rlg3RFhk?=
 =?utf-8?B?d0NXbUFvTFFJOXNFUXlOSlREMzNLZmNBSFc5VVJpdlpBTVAzMVJzck16Vnd4?=
 =?utf-8?B?S210RmFoVnZndjhZWW9rYXFJVGlnUk5vMEI4S29wcUFKbHpLaFdGc3JjNDY5?=
 =?utf-8?B?NXozV3MzWS9yRXlDcnRBNTBCemppSzBaZ0RjekRzVnFpZGdRb3lwNlF1YnAr?=
 =?utf-8?B?dFUrNTJyQnJPcmQxZkJUZlg0a1lRa0thd0d4WktXMlRZOC93bUNmblBSWUlI?=
 =?utf-8?B?YysyQlVueHp2VzBabGRJbFN6Z3ZRd2RsMWpQSXVhQUdhL2pOZWlRSVRTVDhR?=
 =?utf-8?B?U1FXekE5RjRzcTBzblBCeXdOSDZaekFzQWh4Nzg4aGRBWmpveVV3WUVlVlFB?=
 =?utf-8?B?WHhFTzZaalBKWndlazRQN3RlNVFsd00vOWpJVVo4ZE56djlHTVlydHFZdWtO?=
 =?utf-8?B?N1dvbGJtdG1ycGFZV3h5WDRENzRlMHpQTDdLQVRRc3hsZG1zbXR4RDFvTEFI?=
 =?utf-8?B?TENvT3hBRU9SUVRYSm5GdGFNb2xjWC9oU1NCeE1vVVdBam92SDNCQXlIRWFl?=
 =?utf-8?B?cW9VSTg0Y1lUaENoZnhPMDZXallHNk43UGlYazNSNHJVY1c2QVFueHhZSk1m?=
 =?utf-8?B?RkVQSXoxalpXMERScWRobmxJbUtQSnRyZzc0L0VuWkZUT3kwTis5eWg5RUxI?=
 =?utf-8?B?STJKSXRVeFRQYk5rZkduK3pobmpXcWJYa3p4bjVodjlBdDVXU2lodzVab0VZ?=
 =?utf-8?B?RHhad090cktHUWg5NXpBZlR1ZkNyVktHS1hnaE5tMVVEZnA0bU4rekYvcmVQ?=
 =?utf-8?B?Y2MwQjhhZXpVam94U2dNR2pGWG1hcm5IMXd1cVN1WWdkWW9RY0RFK3kybHdj?=
 =?utf-8?B?U2RUb1VkWUZGaHorOWxGSWwwM0ladlRYS3RzS2F3WGl3NlZKMTh3UUkzNEly?=
 =?utf-8?B?eng0MERNbFUyb0lVSWl0NlV0dkkvai9EZ1V1QWVhVFMxTVBjZE5BK1JHZG9D?=
 =?utf-8?B?Y3pZSkh6VVhFblU0ZnZIb0N4NHJaL2FtQ1J5WUtNTTBoWlRGVHcwSUxVT0RJ?=
 =?utf-8?B?VWJPQm5kL2ViYmt0RE0zamFHZXdkMWU0Z3o2NWFCckdXRDk1Q0p4YXdpRnBT?=
 =?utf-8?B?V1U5bXJGQlJJaVc3V2ZLNU5PaEJzVStYZWRpZUxxelczNFNwdkRNR3FIWHBQ?=
 =?utf-8?B?c0V4Mmd5d1BCSGZlREVPZ25oT1dYamR3UktDSklKcEJEY1BmTW5OakVQVFdG?=
 =?utf-8?B?YXBsczVYT09Jb1MzbEFFUG9JUWhQZnRaWGtRcVp3cklkQVRhZzJ6b3dlakZL?=
 =?utf-8?B?aFBpWXRNTnZWY3ZqcWE4Tlhsb3A0NDU1alE4dkdUL1Z3UFdBL1BxY1lsci9a?=
 =?utf-8?B?ME5SVkhuakNKQUpTTzFCdks0cmRuQWZpS3l0cVhCUzY5cUwvakxrQnhDeWpp?=
 =?utf-8?B?bzgvTXhDbmxDb3dnQVBQNk1qQ0NQYlZDSW9PM2RSVXJ3VFA4bjNlNWpmeC9K?=
 =?utf-8?B?UVU5anZneGp2WXF5TXhiQUs0NU9FUTBiMVRDbFFzZmhKTHp0VUxxY0ZIUjlX?=
 =?utf-8?B?M0dhemJzWHFDYzBjWC9VOVdSZml1V0duNGpKa0V6VjFiajY4eVdBeWNoOGZZ?=
 =?utf-8?B?QWgxYkZYL0NKUkNZMXpIYVIrdWErM0xhckZ0UzVoQitrbXBIREFLL09ZMm51?=
 =?utf-8?B?L3ZsTTE4VTNCaG43WG1qZGZjeEFRSzZFcVFocnkzeGdydUJOOWdqaEVjOU5W?=
 =?utf-8?B?N3dNbURYdlZnMmt2MGJmUWJUMWdmMW5sVlQzZHNQeGhLZy9Ec2dLd0VQU1p6?=
 =?utf-8?Q?Zdyy+hAXc/RH54C3jW+07hxrE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b52a2c-ca52-4a10-20ce-08dcff8375b3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 23:25:26.2232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zjedj/lwNhW6yXE6AsiPyJglzNxvq41mMXfQ8/YTNTpsYx3ZU0R3THrzdCIFT8T21P4BlW9TDDh3c0JVsUVEKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8346
X-OriginatorOrg: intel.com



On 8/11/2024 11:04 am, Sean Christopherson wrote:
> On Wed, Nov 06, 2024, Kai Huang wrote:
>> On Wed, 2024-11-06 at 07:01 -0800, Sean Christopherson wrote:
>>> On Wed, Nov 06, 2024, Kai Huang wrote:
>>>> For this we only disable TDX but continue to load module.  The reason is I think
>>>> this is similar to enable a specific KVM feature but the hardware doesn't
>>>> support it.  We can go further to check the return value of tdx_cpu_enable() to
>>>> distinguish cases like "module not loaded" and "unexpected error", but I really
>>>> don't want to go that far.
>>>
>>> Hrm, tdx_cpu_enable() is a bit of a mess.  Ideally, there would be a separate
>>> "probe" API so that KVM could detect if TDX is supported.  Though maybe it's the
>>> TDX module itself is flawed, e.g. if TDH_SYS_INIT is literally the only way to
>>> detect whether or not a module is loaded.
>>
>> We can also use P-SEAMLDR SEAMCALL to query, but I see no difference between
>> using TDH_SYS_INIT.  If you are asking whether there's CPUID or MSR to query
>> then no.
> 
> Doesn't have to be a CPUID or MSR, anything idempotent would work.  Which begs
> the question, is that P-SEAMLDR SEAMCALL query you have in mind idempotent? :-)

It is the SEAMLDR.INFO SEAMCALL, which writes bunch of information to a 
SEAMLDR_INFO structure.  There's one bit "SEAM_READY" which (when true) 
indicates the TDX module is ready for SEAMCALL, i.e., the module is loaded.

And yes it is idempotent I believe, even we consider TDX module runtime 
reload/update.

The problem is it is a SEAMCALL, and being a SEAMCALL requires all 
things like enabling virtualization first and adding another wrapper API 
and structure definition to do SEAMLDR.INFO (and we are still in 
discussion how to export SEAMCALLs to let KVM make).

 From this perspective, I don't see a big difference between using 
SEAMLDR.INFO and tdx_cpu_enable() for probing TDX.

I agree we can change to use SEAMLDR.INFO to detect in the long term 
after we move VMXON out of KVM, though, because we can get a lot more 
information with that besides whether module is loaded.  But before 
that, I see no big difference.

> 
>>> So, absent a way to clean up tdx_cpu_enable(), maybe disable the module param if
>>> it returns -ENODEV, otherwise fail the module load?
>>
>> We can, but we need to assume cpuhp_setup_state_cpuslocked() itself will not
>> return -ENODEV (it is true now), otherwise we won't be able to distinguish
>> whether the -ENODEV was from cpuhp_setup_state_cpuslocked() or tdx_cpu_enable().
>>
>> Unless we choose to do tdx_cpu_enable() via on_each_cpu() separately.
>>
>> Btw tdx_cpu_enable() itself will print "module not loaded" in case of -ENODEV,
>> so the user will be aware anyway if we only disable TDX but not fail module
>> loading.
> 
> That only helps if a human looks at dmesg before attempting to run a TDX VM on
> the host, and parsing dmesg to treat that particular scenario as fatal isn't
> something I want to recommend to end users.  E.g. if our platform configuration
> screwed up and failed to load a TDX module, then I want that to be surfaced as
> an alarm of sorts, not a silent "this platform doesn't support TDX" flag.
> 
>> My concern is still the whole "different handling of error cases" seems over-
>> engineering.
> 
> IMO, that's a symptom of the TDX enabling code not cleanly separating "probe"
> from "enable", and at a glance, that seems very solvable.  

I am not so sure about this at this stage, because you need to make a 
SEAMCALL anyway for that. :-)

I think we can document this imperfection for now and enhance after 
moving VMXON out of KVM.

Btw we are going to add P-SEAMLDR SEAMCALLs to support TDX runtime 
reload/update anyway, so we can add SEAMLDR.INFO there (or before that...).

> And I suspect that
> cleaning things up will allow for additional hardening.  E.g. I assume the lack
> of MOVDIR64B should be a WARN, but because KVM checks for MOVDIR64B before
> checking for basic TDX support, it's an non-commitalpr_warn().

Yeah if we check TDX_HOST_PLATFORM first then we can WARN() on MOVDIR64B.

> 
>>>> 4) tdx_enable() fails.
>>>>
>>>> Ditto to 3).
>>>
>>> No, this should fail the module load.  E.g. most of the error conditions are
>>> -ENOMEM, which has nothing to do with host support for TDX.
>>>
>>>> 5) tdx_get_sysinfo() fails.
>>>>
>>>> This is a kernel bug since tdx_get_sysinfo() should always return valid TDX
>>>> sysinfo structure pointer after tdx_enable() is done successfully.  Currently we
>>>> just WARN() if the returned pointer is NULL and disable TDX only.  I think it's
>>>> also fine.
>>>>
>>>> 6) TDX global metadata check fails, e.g., MAX_VCPUS etc.
>>>>
>>>> Ditto to 3).  For this we disable TDX only.
>>>
>>> Where is this code?
>>
>> Please check:
>>
>> https://github.com/intel/tdx/blob/tdx_kvm_dev-2024-10-25.1-host-metadata-v6-rebase/arch/x86/kvm/vmx/tdx.c
>>
>> .. starting at line 3320.
> 
> Before I forget, that code has a bug.  This
> 
> 	/* Check TDX module and KVM capabilities */
> 	if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
> 	    !tdx_get_supported_xfam(&tdx_sysinfo->td_conf))
> 		goto get_sysinfo_err;
> 
> will return '0' on error, instead of -EINVAL (or whatever it intends).

Indeed.  Thanks for catching this.  I'll report to Xiaoyao.

> 
> Back to the main discussion, these checks are obvious "probe" failures and so
> should disable TDX without failing module load:
> 
> 	if (!tdp_mmu_enabled || !enable_mmio_caching)
> 		return -EOPNOTSUPP;
> 
> 	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
> 		pr_warn("MOVDIR64B is reqiured for TDX\n");
> 		return -EOPNOTSUPP;
> 	}

Yeah sure.

> 
> A kvm_find_user_return_msr() error is obviously a KVM bug, i.e. should definitely
> WARN and fail module module.  Ditto for kvm_enable_virtualization().

OK agreed.

> 
> The boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM) that's buried in tdx_enable()
> really belongs in KVM.  Having it in both is totally fine, but KVM shouldn't do
> a bunch of work and _then_ check if all that work was pointless.

Fine to me.

> 
> I am ok treating everything at or after tdx_get_sysinfo() as fatal to module load,
> especially since, IIUC, TD_SYS_INIT can't be undone, i.e. KVM has crossed a point
> of no return.
> 
> In short, assuming KVM can query if a TDX module is a loaded, I don't think it's
> all that much work to do:
> 
>    static bool kvm_is_tdx_supported(void)
>    {
> 	if (boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
> 		return false;
> 
> 	if (!<is TDX module loaded>)
> 		return false;
> 
> 	if (!tdp_mmu_enabled || !enable_mmio_caching)
> 		return false;
> 
> 	if (WARN_ON_ONCE(!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)))
> 		return false;
> 
> 	return true;
>    }
> 
>    int __init tdx_bringup(void)
>    {
> 	enable_tdx = enable_tdx && kvm_is_tdx_supported();
> 	if (!enable_tdx)
> 		return 0;
> 
> 	return __tdx_bringup();
>    }

Thanks for clarifying this.

As mentioned above, I would say we just use tdx_cpu_enable() to "probe" 
whether module is present before moving VMXON out of KVM.  We can 
document this imperfection for now and revisit later.

How about:

static bool kvm_can_support_tdx(void)
{
	if (boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
		return false;

	if (!tdp_mmu_enabled || !enable_mmio_caching)
  		return false;

	if (WARN_ON_ONCE(!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)))
		return false;
}

int __init tdx_bringup(void)
{
	int r;

	enable_tdx = enable_tdx && kvm_can_support_tdx();

	if (!enable_tdx)
		return 0;

	/*
	 * Ideally KVM should probe whether TDX module has been loaded
	 * first and then try to bring it up, because KVM should treat
	 * them differently.  I.e., KVM should just disable TDX while
	 * still allow module to be loaded when TDX module is not
	 * loaded, but fail to load module at all when fail to bring up
	 * TDX.
	 *
	 * But unfortunately TDX needs to use SEAMCALL to probe whether
	 * the module is loaded (there is not CPUID or MSR for that),
	 * and making SEAMCALL requires enabling virtualization first (
	 * like the rest steps of bringing up TDX module).
	 *
	 * For simplicity, do the probing and bringing up together for
	 * now.
	 *
	 * Note the first SEAMCALL to bringing up TDX will return
	 * -ENODEV when module is not loaded, and this serves the probe
	 * albeit it is not perfect.
	 *
	 * Another option is using P-SEAMLDR's SEAMLDR.INFO SEAMCALL to
	 * probe, but it is still a SEAMCALL.  Currently kernel doesn't
	 * support P-SEAMLDR SEAMCALLs so don't bother to add it just
	 * for probing TDX module.
	 *
	 * Again, this is not perfect, and can be revisited once VMXON
	 * is moved to the core-kernel.
	 */
	r = __tdx_probe_and_bringup();
	if (r) {
		enable_tdx = 0;
		/*
		 * Disable TDX only but don't fail to load module when
		 * TDX module is not loaded.  No need to print error
		 * message since __tdx_probe_and_bringup() already did
		 * that in this case.
		 */
		if (r == -ENODEV)
			r = 0;
	}
	
	return r;
}



