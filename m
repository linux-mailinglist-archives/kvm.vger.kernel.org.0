Return-Path: <kvm+bounces-37960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50CC1A3235D
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 11:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20C901887577
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 10:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB63208976;
	Wed, 12 Feb 2025 10:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N/7EsF+O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34B82080EB;
	Wed, 12 Feb 2025 10:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739355556; cv=fail; b=Or1g2r+EVCnCWFYIGORAoRE/uCQIeuFgAZKHzSgpezmJwzQc4i1J105iM4Irmgsj+q2Ggi5PSFJIqwvUyOQDTj1WnmRrQBQTehdKBq209CiumjEeXN7OrgJC396Kxc6SgfjzxqDQk5xQINMIdth81VOb9GoN4LZOt95gdJBgLHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739355556; c=relaxed/simple;
	bh=JJB8GSlg8NI4OH0erF48OMXMDt4FSW1Sferz/MXwmBg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PUAgEP/SGenFVeXiEKfFEmbvK7aJHgd6B4nYTWJ/iuEVeHgEr2PKX4lezQ1+0lan5tATLGxoozrb8Y50Th68I1xjlIz4j/8XKytaYR8vqXLjSjt9/+wFljYt6vCxoLX7UuRvWTOkox70zQT7Urpi1LQ4zZVtIqMFdqooz7wWqRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N/7EsF+O; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739355556; x=1770891556;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JJB8GSlg8NI4OH0erF48OMXMDt4FSW1Sferz/MXwmBg=;
  b=N/7EsF+OFb34gxUYc/jL7PUu8VeAtLBCbLE23/mHjrL2bq8v0Y5qB6Wa
   0FVME87CiKYX6hsjRecSngMwr7WH4ZA7ncUFBD1k+ItqFqKyIOjnPkfyB
   XjQk+SXWINMGPxyPitrg3y5fS3AHLan43UNOGlQ1ndjPjvWUGFIzfT4L/
   t9M9fcsByzTizpEm5r6whVne9znDFoUsYf32MLUebWO34o+xj6iHhj8rD
   C/4AGHZxGuxcFBZA2s3zlIHD82yq+X2QqpRkNiqQ8IfRROuvU3ACFN6wo
   UMHhSnatnY3nBPtr+saJGQD3svmoe/OVAtOZm9mPAFDz9uypvnu0lmis7
   A==;
X-CSE-ConnectionGUID: bIY/GDWRQmqbvhIVGGgRgg==
X-CSE-MsgGUID: 546tQ6/cQgyitasUe72UOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="39866277"
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="39866277"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 02:19:15 -0800
X-CSE-ConnectionGUID: 5F0IMtVYSzK5DsCSxp0gWg==
X-CSE-MsgGUID: ZERL/6yOSGqfeC2e85kmRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="143631978"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 02:19:14 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 12 Feb 2025 02:19:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 12 Feb 2025 02:19:14 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Feb 2025 02:19:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MKUN0YEB4nbrIoKVCvOLMJmP+/LzM14QDYr6yR8tg+7/epV2y6rvdaYy6eC1Logk6zM2S9qc0gqHm19jibRkXtWC6fe5T6/ZefgPCbOr+wBL7kUWp0UPn8exRO8227KigQRbbwhfmbl6LijBn7izVzrbViYcBJdBnu/OAA/vUL1izPZIjfFat5gevX6P2N0zL3lPBdqIVijI7qo2FfBcO1bg5sn7P2G4/SGVVQ7Zx4dS9aevQSkSSN+kbIwQbqDzuE0pLtGkXoyiSBlgYIk12i2yAfnMdPdktq8aI34/mJY5eAtqnaxgfW2rskSI2CmKbMgmGb0fTvkgtyr7w7Mdpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXyRt4GfWwyIdSBbI8VDIL7hId6xVUEx+1Y3etJ3Nmo=;
 b=T2dFsurkl6gu3qtp6LD7kuSOgjGqV6Pm0jyM48yiyEyox0JA6KJeJe8qKBPSlCYL5ynJEdITIDtSOKlC/d58jN5qmj1MtsFaMaMZUsxk9/1iNWyj6ENm1Nhu1KG3xZ+9WKEUg5VgT2ZUeMRvQJ+qfk7C8GKkFmi8Gnf0pLYsA35v74oA9Uhb7lkG4VrP6MuERWKGElol0bVVfqfC7YhdE47iZo9OR1DvjE7dOYZLYK2mCCuWWntB+n/MkHx24Ti8ok5S4qx/PVnaE24pyuaPHL7KuJepg5yCeJr4s31UQnijs5Fcel5ToR0mghBxzdmCAVY9pomtNl0anVrTjeJi6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7430.namprd11.prod.outlook.com (2603:10b6:510:274::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Wed, 12 Feb
 2025 10:19:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8445.013; Wed, 12 Feb 2025
 10:19:09 +0000
Message-ID: <1651ff88-7528-45d3-b051-0ea050446c7b@intel.com>
Date: Wed, 12 Feb 2025 23:19:02 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/17] KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
To: Sean Christopherson <seanjc@google.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Li, Xiaoyao" <Xiaoyao.Li@intel.com>, "Lindgren,
 Tony" <tony.lindgren@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
 <20250211025828.3072076-10-binbin.wu@linux.intel.com>
 <Z6v9yjWLNTU6X90d@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Z6v9yjWLNTU6X90d@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:303:6b::16) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB7430:EE_
X-MS-Office365-Filtering-Correlation-Id: 6de93762-daeb-437c-2a84-08dd4b4eb00e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S3RBNU1ZZUpJSWlHYldQc1BFZ1RsbUVEVlVYMjBXMjVYTDBDdE84WlFjOUly?=
 =?utf-8?B?V1RIWkN1djdOS1RJang1SDhSQkJ3QWtVS3dJL0N4QUZGa3FCaDVMWG4zQU02?=
 =?utf-8?B?dTZFRjRXYmV5emtZRi9mSjEzNVFaS1lGWUtJbkpyaVRFYWw1RWQ0dGtFRnUy?=
 =?utf-8?B?Y1M3aTExMTlwNjVyWWUyMXFoWmpSN3ZVUS9vdmp1eVlEOEFiMXo2Y1BqWDFY?=
 =?utf-8?B?Z29Rdi9KQS9IZHBJRktZK3lOL0psRU1vYUFwOS9NbkQ3Qi80N2xkOVo5V3lQ?=
 =?utf-8?B?OXJlbkE4d3dqTjFuOEowcDJtaFFYQzh3ZlNrU3ZYWFc5LzJUcjZ1NFVObDVY?=
 =?utf-8?B?VUNmRElEc3ppRFhTZDEyT3RIQmRhR0JWL3NkVWRtZncvVUR3ZTJ0cEpIaUNt?=
 =?utf-8?B?cHRpRGdoQkt6M3JWalFWRXBBM2pFdE9iVmpOOTMrdmJWYUJNQmpJUjZrSlV2?=
 =?utf-8?B?Rko0aTh1dE81YnBkMU5xVGRoT3BRY2NMOXpIMmhzUjM2YnNYY3dGdFpROFgy?=
 =?utf-8?B?YWUyQSs1ajBEM1JmUlZVUEk5MXNEUlR6QkFuZk1xUlNUcTFoTk9RQ2FrN1Q2?=
 =?utf-8?B?NjJUeVRNbDl2aTZXTmY1eWluTmkvU0N2OHBPMmU5dDRLSG1Kc1NrcHBpYXU1?=
 =?utf-8?B?eGpYdGoyUmxPeHJxMFdRclZxQkVHbGw1REQxSmZ6b0o5Rlg0SStrUVdTbk1t?=
 =?utf-8?B?Q0M0S0s2RVFjQUFMeFNCS0ZMdXlyeGppSysvbUVGUzUvM0ZEcXpoRllYM2Y4?=
 =?utf-8?B?M0ZmTjhNenIzSEZBbFFwVWl2cTIrWExiM0FBWVR0ZzBwQVRsU2tVdGx5OG5C?=
 =?utf-8?B?cG9MYWRNM2pkVU52Wm9LdmEyM2pPRFFqMU9hSTg3QXB1ajRuOTRDMWwydFRw?=
 =?utf-8?B?V0ZFNHkvWG1abFlWWDkwN25SS0JsclhoUVBSWFZKZEZhWFEwRTJNY1FRTW0v?=
 =?utf-8?B?Q251ejY4QnZqYWR6TGl5cjhKTUNXMEYxSzZmMy85dy9jdXFLbkhNdCt2bzh2?=
 =?utf-8?B?ZjZqK0lxMVBkazFhOXNnais3TmZqTUZVVDhxbUpISDU1SThuM0ZBS0tWcXdT?=
 =?utf-8?B?eVd2Q2YzK256R3FXZDhVZFpNdllGR3NOZ1dXenZZamZwRitVV1lrVGw5UWI0?=
 =?utf-8?B?TFVnVXNLNzUxd0l6aVRGK0U0ZTJuYmJOU2pRUklLY2x2eUFiN1RjQkZyMXYz?=
 =?utf-8?B?SUs1SmJEUFEvWGJ3WDZIeU1jVzVhOTJwR2licTJMQnY3RmJlQjkxTDRwNlhz?=
 =?utf-8?B?cHRJb1NLYi8xRGNkRW9OT2pqM2xwTVJJb0hCNm1SVUgvemdWdnY2eFVjcndi?=
 =?utf-8?B?RVk4dGpHblhKb2t0WUJpcEREeWpWUndPQ3JaWkR5d2lKTlRDSWNWRXBOTGRo?=
 =?utf-8?B?d09JcWFJaGVJcXhaOEVEdG9XWStRc3pMSVJTRjFOSFFCU3hqSWRxSklOSHRR?=
 =?utf-8?B?dllZOHNnZEV3MnozR24xQ01KS0ZmZFF5eVVuekNqeXY3SGFSbWpGV0QrWGRm?=
 =?utf-8?B?WURqa2h5S0pmNnBRUExua3FENU5vNzM1OEQ1VGRNQ21GMjZSWjVObGRvV2Zy?=
 =?utf-8?B?ekNwZHFHRTMwRnNvek5GTHVIZE1VcWRyUFJRUnViSklRTXlXRjdJdTVKR2hl?=
 =?utf-8?B?K2tOOTRHWnJQNzNqMFRZZ2xmRC9sZlFiVlQ2a2dSTHZ6VGU3eElDN3pmOWhC?=
 =?utf-8?B?RDZWcmxpcFZoMzVsOTJXT2pQUmtQZDk0dE42R05kSnJYKzdzaWtuM2N3eUE1?=
 =?utf-8?B?cFR6UUE0Q2cvenVDRFdiVmlsdXArMkdpbGFlU1FYQnkzU3ZTcGpCS2Q5S0t3?=
 =?utf-8?B?RjZTa2M3N1d2MHpaRHg3czNSZ05UNzFLYkNlSklDSGx3cDFpd2hRem44c0N3?=
 =?utf-8?Q?XoXyc8dJib8En?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2xBemYvUDVvdGNOZU5yM2VCU0VxQnRsNWRKTGFVNmdzR2RpbGJkTi9NUWE4?=
 =?utf-8?B?cW9jUzh4aWlzTUttUys5MlhtcnpsanVxc1hYUS9ZNVZpVHFUam5CZkZYWVJw?=
 =?utf-8?B?bnh4UU12SmJRZWtoanZrZ3NGSnoxM3F6ZC9VUEpjaitGdjg5OU5nQjlVdXdW?=
 =?utf-8?B?RzBkNzVPVVU2ejFpVFl4UmU2V0p4UmkwRjZEcUtPT2pyZ3VRT2QxaFZCR042?=
 =?utf-8?B?Y1loS1R3OWFMVkhKd25jclV5MmxBMGJ3Vzdub2piWkdHdFpkMzJscmtycHZu?=
 =?utf-8?B?R2lBRC9PSjRxandVbzc2MWc4TnZpZnZIUGh4WGNqOWVsOWJNbTkwUlFtZm13?=
 =?utf-8?B?MEpIdjh0R1dNZll3MzZTdEhld05ZR0pDRklEM3AxWnVlT1Vhd01OUEl2VGxi?=
 =?utf-8?B?bDhUQ2poSU9Rc3FjVUcvMXRiRkE1dDVNVWJFbThjWjlrR0I1R2lnZkhuQ3BB?=
 =?utf-8?B?SExOVUxQelhSM0JEeVlubXZFMHdiNHRBajVJdkFETWRRMmdXZmNkeFlZQmlT?=
 =?utf-8?B?azFkT2RMV05UTUlhQlFtMlhYYU5pa1NSS3RJajJGa2JoRlR4SEVWSEZXbVdt?=
 =?utf-8?B?ZUNhZTI0OXRSVWZDaEg0U0VLQlgxVis1TnIvWWR4cjJCRk9wTHlodjN0WUhz?=
 =?utf-8?B?NXdDak1LYVlFbFZNekdWV3RqVjY0bHVxK1dQbUhrckZmbHVrRzVDczh1UjhX?=
 =?utf-8?B?bDlUMGNoUU0vZmlsdExWM0ZDK2JnaFQ5M3J3S3dMam5sL1VHVmNrL3ozNWV6?=
 =?utf-8?B?VFp2NFgxS2pxOWpVR0xLTlhobnZOelRjRGpjUkpRRHRzWER6Tk1zSGtsN1Rs?=
 =?utf-8?B?dlVwNWJ1MjM5MVA0b2JvSjY4RnAwQlJqLzRDQ1ByaU9aR0l5bFRtNi82c240?=
 =?utf-8?B?RnJqUmNNSThTVnFmQkZ1SnpLZmg4cFlxaHRCQVM4YUlVeW0rbmVId0FXZTJ1?=
 =?utf-8?B?UFIxUGxvQS9jQy9jWmZKUUR3QzJCaWRRbmJmNnhWT0M1YXFZaDlkdXJiYXVk?=
 =?utf-8?B?NDBYdXpqZzlIbVByNVNVTTVNVkYra3NlRmZ2QVNpS0VtQnc2MVppdXVheWdW?=
 =?utf-8?B?SmliNVM1Qm96L2dsakdpeG02M2hubURYMWR2NGVuaSswbXJncEtaSTgwaCtJ?=
 =?utf-8?B?RnhGd3JQeXkxcTMzVEtqczF0dnJQK241ZnJDcFBoRFlDL2pSRW1vZEdLWWJG?=
 =?utf-8?B?UUlLbG5lMWo4Snk5WU5BOE9Gams2SkdsWTBHalg2RFpUM1JTVXlHdU52Tk02?=
 =?utf-8?B?OUdLU2x3VWZKT1NOVU9CRHpjMVNUWGJ2ZXYxcEtHS1VBcWJKTmZPNnJEbUFy?=
 =?utf-8?B?a2NlQ2I1U0llMEQrSmNsdTBPbjQ0NmpmVmhJM2FrZ29WVUIxTHQxdWNZQVA0?=
 =?utf-8?B?dU1GR2NuSmY5bW1RYjJSNDVJWmEvTlQ0aEptaDZaQ2s3NWg3eWdFL0hleGlp?=
 =?utf-8?B?YmVJWlUxQUYwQ1BlckFTbW5aMkswTXhwNE5sSmtPdDAybFcxcDJxUHJlZnFB?=
 =?utf-8?B?ekZicERvWlplMWt5bkhmQzFodWxOc3pCaTJBaUdFVlY0K3Nia2l5WDFNdEpZ?=
 =?utf-8?B?ZXpuUm1leDZQSWNrZlB1a1YrUHdTbm5WU1hUWGdYVnowWUd6b29OS1NmZGhQ?=
 =?utf-8?B?ZXRsQkRsNTY1UjdHV1BwOGJzdmNJQ3I5M1RyOTRMWGxqTGRaajhSdFdJZ2ZL?=
 =?utf-8?B?SGZGVmlEQTZGZ3UwcmJ3czRNWFhJSEFqRGhjYm9LRUlGUDRHTXpQdmpWUm85?=
 =?utf-8?B?M0ptTUVWYi9LamhHM3U2RXdUYkZtazAwQnRzT2VxZllIdTlBUnNjN0daWUk5?=
 =?utf-8?B?T056R2NTZHJEdDNGRVBQWU0rNFozZUxWbUx3b2NtV24wNnBPaWVlRng1Q1ov?=
 =?utf-8?B?UnZxcHl3QytjcTcwNnExTnBRWXN1VUxEOExCMm94TDA0QmhYa1BQQUJEYTFq?=
 =?utf-8?B?Q01UL3h4bHJEdmZHbjdBbFhtT2NmQ1l3b3pQbDRhQk5lNndFOGxFWEVYeU9K?=
 =?utf-8?B?QVNMcUJEUnpuODVmdXIzM3YrVWU1UFl4VWNZVi9YNHh6ZitxMnBZdWt3cGUw?=
 =?utf-8?B?bEVUVW4zWkloSzdUOFZ0N2xBQS9kcW5vSkticXAwYXo0Wi92V0hmN2FyRjJP?=
 =?utf-8?Q?vaeRAaClOZZ7zTYkcaGu4xIwf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de93762-daeb-437c-2a84-08dd4b4eb00e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 10:19:09.1405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJrSPIpPkUXMpmuyOb0d3uXiH/4F6d6DbtohyYLF2xjdfzJ+CLyRdbFDzOHj7fNKox+RTY4T76Et61YhqLGpUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7430
X-OriginatorOrg: intel.com



On 12/02/2025 2:47 pm, Sean Christopherson wrote:
> On Tue, Feb 11, 2025, Binbin Wu wrote:
>> +#ifdef CONFIG_KVM_SMM
>> +static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>> +{
>> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
>> +		return false;
> 
> Nit, while the name suggests a boolean return, the actual return in -errno/0/1,
> i.e. this should be '0', not "false".
> 
> A bit late to be asking this, but has anyone verified all the KVM_BUG_ON() calls
> are fully optimized out when CONFIG_KVM_INTEL_TDX=n?
> 
> /me rummages around
> 
> Sort of.  The KVM_BUG_ON()s are all gone, but sadly a stub gets left behind.  Not
> the end of the world since they're all tail calls, but it's still quite useless,
> especially when using frame pointers.
> 
> Aha!  Finally!  An excuse to macrofy some of this!
> 
> Rather than have a metric ton of stubs for all of the TDX variants, simply omit
> the wrappers when CONFIG_KVM_INTEL_TDX=n.  Quite nearly all of vmx/main.c can go
> under a single #ifdef.  That eliminates all the silly trampolines in the generated
> code, and almost all of the stubs.
> 
> Compile tested only, and needs to be chunked up. E.g. switching to the
> right CONFIG_xxx needs to be done elsewhere, ditto for moving the "pre restore"
> function to posted_intr.c.

AFAICT, if we export kvm_ops_update(), or kvm_x86_ops directly to 
kvm-intel then we can even take a further step to just set those 
callbacks back to vmx_xx() again if KVM determines TDX cannot be 
supported at module loading time.  And this can cover 
!CONFIG_KVM_INTEL_TDX as well.

