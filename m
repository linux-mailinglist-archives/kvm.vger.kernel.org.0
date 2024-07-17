Return-Path: <kvm+bounces-21781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD03933FC0
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 17:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AC241F2410F
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 15:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A983D181B9F;
	Wed, 17 Jul 2024 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="drKkWUsM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB6F181BBD;
	Wed, 17 Jul 2024 15:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721230477; cv=fail; b=vAU3lZNldfbjSjGtrYphRJ1GE4I6CsdQQOer/lEbHeHMYBPjBlT/tbXm/55/5oTxGdmjJKi1KJ3CQ6KsN1YlPtbqKhCvF68pghnNETiuDTX8pGrqqFO1Az71i4xSNjnnI52K3KPobeCphz+UBZhQwKSUP2BHeEVB0F4Zzy6av6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721230477; c=relaxed/simple;
	bh=/P23Gq6MIXyUUWVK+6Eh89Tv80xDP150dY6VqqdLHYo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sYPtaYHdppmFcis6l150Vmp6X/hy0AUKWAOVzYQIU11aVcjSFzkIvG/hlEnLxCilo4KFFJHmv2Ki71cqOehT4tWbXN1aod3ntpAk4W+ntIUdyORAFUobSHUJ73KAfEpwGndOSqkPj0mF0r22EAF/SEi0sjfly+33mZOZnn5/Nuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=drKkWUsM; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721230476; x=1752766476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/P23Gq6MIXyUUWVK+6Eh89Tv80xDP150dY6VqqdLHYo=;
  b=drKkWUsMpssWQ5uac8u6ak5MGkvVFzKGl1OewTCphmde21twqMhW+0hY
   VC86RkGSQneXRyiO1NZ3MR9Ss49YFYNSA2LzYK6GheJSd+hc7Ns8Kdu5B
   p7v2k7fqD7ALO8iZWT2aEohrmSD5gD6vvjIP3IsAMKj74rkTzIeBPz2+u
   Y4Fhejqu85mdJCeMr2UjXorDOqs3UoYtKll3ppEL5jJbXoiGJF2Ta36hX
   lUtsP1yMwr9iTa5xRNBV45Ddb+3roakb9WqmkkpQi7KFcUfqRZMqau7KJ
   ANX3amTo90oBf2XPehBMYGFFqMYWQiXKDdj5lI00RZXwlAs2rnHHwEMzw
   g==;
X-CSE-ConnectionGUID: fPyk+Pn7Qd+eef2qZ76GJA==
X-CSE-MsgGUID: dD3ckTKcSPWT24bs8znbGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11136"; a="18929687"
X-IronPort-AV: E=Sophos;i="6.09,215,1716274800"; 
   d="scan'208";a="18929687"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 08:34:35 -0700
X-CSE-ConnectionGUID: 9p1u6d0BT7C9tZKxe0eEPA==
X-CSE-MsgGUID: M3Iyl2lXT+KRybaFleqpFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,215,1716274800"; 
   d="scan'208";a="55578069"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jul 2024 08:34:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 08:34:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 17 Jul 2024 08:34:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 08:34:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eoUlQ6eK6M1KIcnG/JkwXrntlBesY76lXUm3Qhj/MT9vSZiDF7wbM0EJ5+FTADPkIojbQvSB6u+CRqmWUKXk+RBX1igvn65NW4b2/+DBNgnY5DKSi6tmMlobnU3rQKUiHR/DBZYONPzV7x9mL4SpDr+sytO3dJQARx1Qk9VB01lPHNOJxscTWrmfp3pLNVG8pT4hXom76LDiDukBlk74ZTM2cRyFRz47NUo2YD7WbKZ4khCyfnAMhxffirJ2J4BXiOByUS4sUBbBK97OMOTsnsEexZpNSTNtPsNORf/p7n+2qxAc2oGV1InsIM8Os+7NnzawvI41bRyaNjMwods1bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/P23Gq6MIXyUUWVK+6Eh89Tv80xDP150dY6VqqdLHYo=;
 b=bsFe3LK4jSVIpbWTR9VCMm0JXUyEO/e+1bDGPU6yYVefYwr/KDpUbbvcu2eSLmq+WC2PGcRIhlx3ECw7crUw1QxnLJwvRXBWlwYQEXQhqWUixYYvBkVb5MIU9hhp+UF5bZGp9J4HYzvw5StZ5Q8Z4AJzpuQ3HZjxH5c4Srb1rPV/RHgBLxtqa+Byu7ByaadQcMsrduLo5ETqEsPCN8TKs+JIHzNq1CkRoqJHkECIRGjsPyi6Sths6X+zPALZ5gWb/Oyr5Q723sZpq4XmfqkMEEZzgcXKj7ZnWF7LREPdFXmyR/0feD+QdZAAF+O3vgHHuL71RodVdanNEoXh4JxRpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SN7PR11MB7066.namprd11.prod.outlook.com (2603:10b6:806:299::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Wed, 17 Jul
 2024 15:34:27 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%3]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 15:34:27 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: James Houghton <jthoughton@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.org>, Axel Rasmussen
	<axelrasmussen@google.com>, David Matlack <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
Subject: RE: [RFC PATCH 08/18] KVM: x86: Add KVM Userfault support
Thread-Topic: [RFC PATCH 08/18] KVM: x86: Add KVM Userfault support
Thread-Index: AQHa0yM7POpElz68ZEeIzVnb9wOHdrH3jBVw
Date: Wed, 17 Jul 2024 15:34:27 +0000
Message-ID: <DS0PR11MB6373C1BE8CF5E1BCC9F2365BDCA32@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240710234222.2333120-1-jthoughton@google.com>
 <20240710234222.2333120-9-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-9-jthoughton@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SN7PR11MB7066:EE_
x-ms-office365-filtering-correlation-id: b3631801-0af4-483a-0bc9-08dca675f1b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YUt3cGJzUkRLSHlmZkFLYnlGdlU1SE5CM0JyNXJ1RC9ScTBwTzQvK1ZBRGNh?=
 =?utf-8?B?U053UHZFdVVpSnVvSEUralRnbW1IbXZMallwTTNOZ05xaElzSUQ0dGY4OUFj?=
 =?utf-8?B?OFNGdmxTbnRvUUN2TVJGSlRxRVpvanhLUCtQUC9DQkxWRHBuWUluNFVhbFk1?=
 =?utf-8?B?VVVTd3VVSm1rZHYzM0VuUEhhV1AwMHRMTnFxcWx6ejM4WHY3cWc1emZ5bWgx?=
 =?utf-8?B?aWdHQUZDa0t1Mmk1RjZVdURLSjhxOStDMkRhLzhuOExsUnZZTm5yVWt2czFK?=
 =?utf-8?B?cTAra2hjaTdYdUV6WFhaOEMweVFucEd6OE9KdCt6VWY1eVU3ekxEc0FEbmVw?=
 =?utf-8?B?QkxLemFpWGZpSXkwWU9Ua2c0d0xPL05kUlE3RWdWV01oTUd2NWwvOFNpcm1J?=
 =?utf-8?B?VU05TGFyYzF4WGYxUUErdGkveXhpMVdYZjNVdHBSME1vM0dWT1FCVnRERzJS?=
 =?utf-8?B?elhLdzc5blAvdUpRbDViUitOb09HNHRSNHVERWd3QVBrcWtiYXR3UG1tempp?=
 =?utf-8?B?RWpwbE8yN2FEdjZadFNWQThJdXovZnRuTCt5K291a3NrWXdqbWRnUWVCUjJm?=
 =?utf-8?B?dE1Ec0gxZ1I1U3pndmVLWnV5VXhRSU5HY21GbnpBWGRZbVNQa2dNdm5KUkRX?=
 =?utf-8?B?OFhXRUhvUDQvdnBKVzNnbkJmbTlmV3Jld3BGMlhjSkVyK0tsUXVJeW92WFNP?=
 =?utf-8?B?a0N6clVpMzJYUGpVcExvaWlRajFEMGdrWlRXZkhmV29JRlhaYW42dmxZVEp0?=
 =?utf-8?B?dWNrNURHZUpQRTZBdFlLZmh0THNtSjYwNG9obTNsZG96dzNhVVJiS2FKZUJy?=
 =?utf-8?B?Y1h3NmlJWDJXUHdaY2RSVFdYcHk0bXE1ZkdLWEoxMHppRCtzcGp3TzRzYzFa?=
 =?utf-8?B?L2U4MGFqZjdUL2tkbVhBR3RBYWFTWThIbVJyN0V4OW5ibGlTQ2J6NTBqZVlk?=
 =?utf-8?B?UUlUamdYNE52T3U0TG1WamxnYTFseDJsOVN2M28vTTlPbCs3RkxWQm0rbG9y?=
 =?utf-8?B?clV2bEI3SXIvMnRlQ0VBWFg4a0tlUForSzR1S1FBWDl3YVhvaFVhTC96cVBh?=
 =?utf-8?B?SDlOWldOeURtU3JxYW5XQW1QUHNWVWFDLzVNUnFyR2dmdEhGNDIyVGpqUTBm?=
 =?utf-8?B?THFwWXdzb2VRSmRWNFA0MnNGNVIxSVAvL1c2eG5jOC9BcnBST1dneTRCZWxH?=
 =?utf-8?B?L1VGSENjTWVENXErY21VeWVVendZRjJ5Vmw3VklyTU0vaEIwbVM2M0srNXVO?=
 =?utf-8?B?WnAyY0FUSkZkLy9MTWRkeS9SSzRJQUVoSTNoYlg3Z0djQ1VxTTZlQk81eTNP?=
 =?utf-8?B?akNFVG9hZXM5bEMxMmZmMTNTODJqbDlKMk9EY04vYlF3cGFSTit6WDZtRmhR?=
 =?utf-8?B?L0grcjBhYUFETnpxVFlpOEFCSEdYR05aamwwN1lobGkvQlRhTzRLSUhtV3No?=
 =?utf-8?B?eE9LbDdJOG1JYTJDa0lXcTVjRGdDbUJ3NytOOHZEYVJDL3ExNUwraEMySy9j?=
 =?utf-8?B?V2ZTTHQwQzFhTHBuK01MazJ2SWp4TDBkQ0ZjTmhyVlFkWmxZdkNJQ1YyMFh2?=
 =?utf-8?B?dVZHZTF2dWF5dDYzVS9LZERCZU1DWStVVXlpR1NYbFdpZE55cEtDa0V1ZjAw?=
 =?utf-8?B?QnRIdUxZZzBUU1l0dG8zQmJQNVhSbWlFQzdHMnNVVmh1aWoyb2dhNjRFalhh?=
 =?utf-8?B?ZnhrckErRUtTcU9rb1NVR0szUXprQ0UyK1JqR2RZb2FVUGljZE01VFdhc1Fy?=
 =?utf-8?B?aitraGRPZ21wb1BMWWNjT3F3bTQ1d0FVaU5FcU5RUFA5NHZYaTRyTjNiMUNM?=
 =?utf-8?B?WFp1VC9vT2VFeE1VeEJyQjA1MUtWOVNXMHByWjlEbzBqOFpoaHBzcHgzbnNB?=
 =?utf-8?B?UnRtQlNaeXZ4cU5wWUFCTkxrWTU3Sko5Q2YyMk8wQWluSnc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emFxUUhGbHg0dS9XRmhmM2plTkp3OFNrWDVXNGVaUHh0dENkT1kyL1NsaWV6?=
 =?utf-8?B?WU9oRWVLY3MxTGFlZyswNzRXUXpZZzc2cHZ2YkxUaEZTV0xUdXNjRGplUjY5?=
 =?utf-8?B?WEY0RWltY1ByMmY3cmJnc3pwdURWTWkxejFPOStIWW5mazlxajIzRnRidVZa?=
 =?utf-8?B?RCs1SGFUTktMOEdCZjVoVGt3ZThQVGFMRlIvRWczR1RPWWpEWWRCZThZa0p4?=
 =?utf-8?B?bHBNOFJFU2NwaHdDZXZUUGZIcTU4T0pMK3ZrMjY0NnFjYmJpMVBRZlY3ZUtw?=
 =?utf-8?B?UWQ1SE53NjlUWnlqU1BLTTVXVm8yK0ZpN2hwdzB2Q3VCNUxPSnh6UHVWUkQ4?=
 =?utf-8?B?cEN5STlVZzgzYjlCY3B5V29tZnlCbC9kZ0REWHlqdFdtbUN3R2VaVUpkOVQ3?=
 =?utf-8?B?Rmg1dUN3SThLUVgrT2ZZTzVaR0RpbXRrbHBOL2RqQisxQ1RKMDBDMEQ0OEVk?=
 =?utf-8?B?VnJuTHl2RWJZa2svbTRBQURObG0wSndrVko3S2hZaUcxeGpBcXAxeDhzR0g1?=
 =?utf-8?B?T0NrSmExckpoNmpiSWRkSTBaNjdEOHVabVJBODgvSFN6elAxS25FczVLMW1R?=
 =?utf-8?B?SW9JNVMwZmQ1cWlvR3IveG5ndFB4QWsyMFVwTFBRbVkvVUZMaGlDVkJmUWNB?=
 =?utf-8?B?RXVIT1RLUUJQdjlvcWVoUUlpdE93THNIc256Q2JsUUlyWTBjTFZhRE5XSGFJ?=
 =?utf-8?B?NFhaNC8zOUpvN2NnWjBmTjQ0dVJLL2RoYnRET0lNZ3RqMXA4Nzhpcko1QzlC?=
 =?utf-8?B?TE5yandjQVNjbE9GUmtBWithQ3NISklBalJWb09JbEZwS00yZis1Q0FwUEtS?=
 =?utf-8?B?R0tMRmFMY2ZveXRBbmhsUE9qMkNmNWxVeUVuTkM0YlhmYThWbFc4RndISS83?=
 =?utf-8?B?bFE3ZGNCM05oSGllYUJQWHBacmpjQ1ZFYUw1N1FBYlZKVkpSTEoyU0VWQzlK?=
 =?utf-8?B?TnVBb2ltbEpIanVMcW5ONWh4WmtXYWg0WkhxcEtUZC9zbTRyQjBDQUdKWDlz?=
 =?utf-8?B?dWlDemhUb2ZzOVcrTXpyR0pObnZObmlyMFM1cHI4QXZvNUhUS3NNdUlmdmxi?=
 =?utf-8?B?em1TelpvdUNLbGpkOGVITkpnZElXZnBwMC85VHRMZE9lUnZ1dGNNOURzd2R3?=
 =?utf-8?B?b011T0NrdW9yT3RRTnN4dUJhU0ptWFNtVUo5R2ZXMlVsRnRRT0pOQW1TSjdH?=
 =?utf-8?B?N0ErYVBsMUhuSXRhWVMvblVFRTcxMWs4ZlNVR1J1Skt3M1NjVE9HSk9iVE12?=
 =?utf-8?B?b3k5eVJERlFiQkV3UHdmd3d5K3krKzdZa3FDK2V0UWRrN0JiRXA3Y2JVeHlU?=
 =?utf-8?B?ZVVnWE16dDNrS21KWitRQW9Fa1dxQUwxY0Z6MGNhTE94b3k4dGVibFhxampY?=
 =?utf-8?B?Vjh3djNJT1hySXlTWVRFV1hsS1VMNmFTaDVYSzJDT0MwVUhFR2dmN2hwR2ln?=
 =?utf-8?B?d3U5b1dFWkhtN21XSmVPc2MxZXcxMi92RldralZxK2RTQlg1bCsyMTZGQ2hK?=
 =?utf-8?B?QTF3WklFWkJIYUpXbkJCRXY5REFkS3NXRzB5bWFBdTFIeWtrUzdrdXJpT1Ey?=
 =?utf-8?B?UW9US3FYWGFuRDI3QkRKUFdGbGFTOTlmbWtyaVBJSk1xUlhMMEcvQU93aHly?=
 =?utf-8?B?OFBveGNxelFzaU5aby9oUXJKbE9teEZGTjJBSjlNcWdidzJwdWxOcW5EazdK?=
 =?utf-8?B?NlpNcDNIMjkvaWY2ZFlvVnBJZFREVzlRVFlybGNRZTBEZlZqY2hwWGZZbFNH?=
 =?utf-8?B?SmRaUHFKQXVNZFBOSHZyeCs1K1V2NllLSmpQRTdNb1JYbC83eE1wQ1FiWlNE?=
 =?utf-8?B?NGU5azNQOEpkclVjYjgzQzBPSnFDWGR1NkoxQ09oSnJ6ZzdveEVrUnl1U2Vn?=
 =?utf-8?B?eThXbnAvWDR4VjVOc1RQMmFTMjlOOFg1WXRXNnoyMFNKYmpIY1BnMmkrTGlM?=
 =?utf-8?B?azgrRTJXRHJnVlhNQ2RmYTRyQnl4ZmV6NnhsZTBFV2dzVHJ0NlhSRXB0OFJl?=
 =?utf-8?B?V0JKTVB0Z1d4MkZlZnlUVm1GWjFmNWI5bng3SExWL0pSUEZOT2FNSWhuWDVZ?=
 =?utf-8?B?NXZhdm1NRUdGMm41NTRUVWhTdUR0Vm9aemRpa3F5WE9HUlBNU2FaVjhUME96?=
 =?utf-8?Q?ohNFGyy/Tda4f4guRvSB9eeOt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3631801-0af4-483a-0bc9-08dca675f1b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2024 15:34:27.6085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4k5HcrXOUhHmmY84Zs7SkwKcXm3W+xGtcC7en86CO3UKPZEoEm0Pyxsw6Ow6V+kOsEkTGUhlRpq6rwVcKPsukg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7066
X-OriginatorOrg: intel.com

T24gVGh1cnNkYXksIEp1bHkgMTEsIDIwMjQgNzo0MiBBTSwgSmFtZXMgSG91Z2h0b24gd3JvdGU6
DQo+IFRoZSBmaXJzdCBwcm9uZyBmb3IgZW5hYmxpbmcgS1ZNIFVzZXJmYXVsdCBzdXBwb3J0IGZv
ciB4ODYgaXMgdG8gYmUgYWJsZSB0bw0KPiBpbmZvcm0gdXNlcnNwYWNlIG9mIHVzZXJmYXVsdHMu
IFdlIGtub3cgd2hlbiB1c2VyZmF1bHRzIG9jY3VycyB3aGVuDQo+IGZhdWx0LT5wZm4gY29tZXMg
YmFjayBhcyBLVk1fUEZOX0VSUl9GQVVMVCwgc28gaW4NCj4ga3ZtX21tdV9wcmVwYXJlX21lbW9y
eV9mYXVsdF9leGl0KCksIHNpbXBseSBjaGVjayBpZiBmYXVsdC0+cGZuIGlzIGluZGVlZA0KPiBL
Vk1fUEZOX0VSUl9GQVVMVC4gVGhpcyBtZWFucyBhbHdheXMgc2V0dGluZyBmYXVsdC0+cGZuIHRv
IGEga25vd24gdmFsdWUgKEkNCj4gaGF2ZSBjaG9zZW4gS1ZNX1BGTl9FUlJfRkFVTFQpIGJlZm9y
ZSBjYWxsaW5nDQo+IGt2bV9tbXVfcHJlcGFyZV9tZW1vcnlfZmF1bHRfZXhpdCgpLg0KPiANCj4g
VGhlIG5leHQgcHJvbmcgaXMgdG8gdW5tYXAgcGFnZXMgdGhhdCBhcmUgbmV3bHkgdXNlcmZhdWx0
LWVuYWJsZWQuIERvIHRoaXMgaW4NCj4ga3ZtX2FyY2hfcHJlX3NldF9tZW1vcnlfYXR0cmlidXRl
cygpLg0KDQpXaHkgaXMgdGhlcmUgYSBuZWVkIHRvIHVubWFwIGl0Pw0KSSB0aGluayBhIHVzZXJm
YXVsdCBpcyB0cmlnZ2VyZWQgb24gYSBwYWdlIGR1cmluZyBwb3N0Y29weSB3aGVuIGl0cyBkYXRh
IGhhcyBub3QgeWV0DQpiZWVuIGZldGNoZWQgZnJvbSB0aGUgc291cmNlLCB0aGF0IGlzLCB0aGUg
cGFnZSBpcyBuZXZlciBhY2Nlc3NlZCBieSBndWVzdCBvbiB0aGUNCmRlc3RpbmF0aW9uIGFuZCB0
aGUgcGFnZSB0YWJsZSBsZWFmIGVudHJ5IGlzIGVtcHR5Lg0KDQo=

