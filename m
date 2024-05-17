Return-Path: <kvm+bounces-17562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3688C7F46
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 02:38:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 821E22838C4
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 00:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73794C157;
	Fri, 17 May 2024 00:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wts9TVLd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21BFBA29;
	Fri, 17 May 2024 00:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715906286; cv=fail; b=mzaqZm761kZh/okzJsX+b3zZpO7vBTgDEg0GKWZ2yRfd38zd6nahGiKQfzK+toGaVgURTAqgTGe+t17huCsml6bNcWJtD1jBzSAGb2At14uoqPjBJ2rt5o8Mu97U99H3QHGzj5qDR2A1kmIsGsXGmnK/oswy+na4nTUFj+mT2ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715906286; c=relaxed/simple;
	bh=ZPcmVgUVDKN7utQuNDX809PMV/Et3KbLjsv/5QHLI7A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AX5rcMuomnPULVENxCtb2y9aaftHf4YmY3qx+9Q1Hu9rGkqNDU+OUGs+LXkBRDBbjLU4Q3LFMV6bVJjGUVO3ktbpP5to5JwYLiMoi3+YOCUrKFbyS9KukIE6EIcesXSLxGtLGOPn3QBMvCvkGQSOPo70RxianbgYyhTPZMmFVPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wts9TVLd; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715906286; x=1747442286;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZPcmVgUVDKN7utQuNDX809PMV/Et3KbLjsv/5QHLI7A=;
  b=Wts9TVLd6iJOrKRLpQONd1pwTVfH6Jgme4Ayo1aSd2D2CIInb9FFbKGD
   Z3gFpkNoPo6z7fq8sQ/+t3Dx4dB2P5ymJdGs+IZXiyZmY1BRvVpp1K6Q5
   uz5ks4QPz0zbI7nL0tTGQISPCYC044r8Va66KD1lVmjDPMeslQNEkb34I
   iF9CFJPAYSRmalJoQQgcz6H/SSlQ0lXaGZLYN3R3Fkq0PwIDYsRl+EXBC
   fW3PD0dB+xgJmeoxsVCejcx9wirlAY7KF07RMic3nzauklH/rFpjd9RLS
   hcfLYqQJeo3vSBAKcAFNMy6eUvKHq4FvlUbd5t7UanqPutd5Jt09G4DLi
   Q==;
X-CSE-ConnectionGUID: DFyPM1ZtSoiQijImzsb3MA==
X-CSE-MsgGUID: cR8DwOTfQ/WQf9odHpf64g==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29563449"
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="29563449"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 17:38:05 -0700
X-CSE-ConnectionGUID: 0d7GVhbfTZ2hYn+Mo0Pldg==
X-CSE-MsgGUID: YC05Z50mQ3eIpjzSbyhmAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="36173779"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 17:38:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 17:38:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 17:38:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 17:38:03 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 17:38:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAqidoq8ZYWmca2k4ZyR+uZq7ShCR63OHhRQjLrqRkWtEC98SuBmAtTsIJsibePa7GOKbNmsJ9Q12MWugdyBBkddAM0Q2W9rZQxG7gwqOAimKVMDN8eVzFlM32gvp1P3ldZRL4QXaWPrO4jAqJ8qpfdhElck8Te3dzp0acsX4qlR3bHEsqxyXd4BCrauKhEbuR1OgyS/3Pvxh0cNtGBNq+GpeIp1oAO1z+KioUJ7/wCrPNKqpadJcBDNzghzzpdtOLQz6wNSHa1qv+tdvz5gyEHQYf207b+7H7O76mv241bypQ2KDnkppynxQRGoWRBoPgGOAmrVXPsBBUcVx2RKjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwQj/8Tcxf7LQNkm5ef7wEzGDD3Euvk4WTVCeXL5Y04=;
 b=ejQGlojfeBdofJ3NTY/ckAtDb612rVaPbh341uNcAm4iogISqLZsQReCsQXhoSapfMiJLJeSzqAa4pYeeNpvXrjffTJpeQR96tX5KNROysjnz3lxNk26IZXK9TnRaIL9rBbrkgawIBp8V92W+K5rKyMKsxsFSX3N4h+2DgUBzsSXiAHSfBzHI5zwj7ripz47jPzSgRkMOOxMmD5Q7vUOhhkneuy1sYqACFyEIC8s8R6V2eED/nhpVANF/tQ6pfY4SrkQgSbfeX3PXhgkwBQgrvA5cj7B29Lf4cUBqLfX7bEgLhZ+QDq4L5Vc7Ja5ZCrW+VDYnoXg6HqMKXnOtt2zaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Fri, 17 May
 2024 00:38:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 00:38:00 +0000
Message-ID: <d9c2a9b4-a6b8-4d29-9c22-ebdce77f3606@intel.com>
Date: Fri, 17 May 2024 12:37:49 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com"
	<dmatlack@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
 <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
 <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
 <9556a9a426af155ee12533166ed3b8ee86fa88fe.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <9556a9a426af155ee12533166ed3b8ee86fa88fe.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:303:8c::25) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MW4PR11MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: cccbfab0-f0bb-4305-1697-08dc76099a7e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WllrQUF5U09EV1NDUXZBV1ZBQkNYY1M3aVNldDJMRkRjT0FDbDlCUi93M2lm?=
 =?utf-8?B?ZUhUK21RWXFCckRsRVhTNW1SQjQzMlFZbkZUZnhsa0NJdDk3NVRLeFpwYVJr?=
 =?utf-8?B?ZVF2a21WQ284ZHNseEdRNGJHVkM0clRKVG1ueVUzbjZzc2FkaTQveElyY05r?=
 =?utf-8?B?aHdFRTh5RW11dnlHR2t0VUJqSTdXUFgzSGdoSjRwd2VpVGJGOVhhaUJJeXRm?=
 =?utf-8?B?MHJlN3RhZEQ5UmRETzlpYjdxdlN6QjF1Ty9QbFBwNzVYU1hVRk1wVVEyNTJ0?=
 =?utf-8?B?aHhFZTEvYVdsa0ExZVA5cTd4M2ZJcGxFajFYZnpPb1JBTVBjRE5PSmg1OUV2?=
 =?utf-8?B?SGJrem1TN3RySC91NXdUQm9ybXM5RTErNjdOQ2k3eDBnVlNzWTR2d09kS0R6?=
 =?utf-8?B?NWhBSVZsYklEWWxmRFlFTExYd1o2bGJUaWk1aGpjSEt2aWJsWGdqd1JOTkor?=
 =?utf-8?B?UlVnbmpXbnJzQ29GYkVYdkw1dVJvZjNBZ1h1RjA0VUhuY2dtUjM4UDdxTDNM?=
 =?utf-8?B?QVFDM1BzWXR5QitxZzJnYlQ5aXI1Mkk1aEwrL0RpUE1zcnZ2c2VUTk93d2dC?=
 =?utf-8?B?emhRMUpuMlhBdjNZTUdBY1hJM3RWWlpLQWdzSnd3MDhJUDAxOTJ3bVdkZDE3?=
 =?utf-8?B?QTdPUXZERFNkU0w1K3g5aXBlS1pDUjJmS2hHV3lKaHYwV2dXM0JPVjVnWFAx?=
 =?utf-8?B?VGd6S0pkYi9sTnFEWGJqdHNrSjJNQlRyZWlOZ1BmREVRTUFzUkk0TnlvUUdC?=
 =?utf-8?B?VHduRmlsUkFQdXhNQlFVWjJMNDNISTJodG1wN0ZmZSthZGpqQmh5YWRoUUNp?=
 =?utf-8?B?cnhEUk1FenZEeGVYZTdaWWVrNWlKU0hVQzFHanlDRXJVQlRScUtVMndWVldJ?=
 =?utf-8?B?bnRDTjd2VE4wSWxLYjYrYmxsekVnNkxBbFRGREtXZG5pV0Z1MmtTNi9oTG4z?=
 =?utf-8?B?T0xJYWNxdVJVMStmWTZNTDkyeERMdDF4WmRpVkRVMWFDVnBBcTI4OVBMRzI0?=
 =?utf-8?B?a0E3N2prMHJOWk15YnVCbHkyOSsvb2Zua0RRSHoyMGZ5RmxpSzlpL0ZiV3lU?=
 =?utf-8?B?NllzOVgwbExxZkU4RHJBazg1d1M3K0U4Q3ZldXdWRmh2SmZ3ZjdkOHh2TjJ4?=
 =?utf-8?B?OFZ3cEtlbUpmWWk3eDZnbDEvMzBNb2xpVDZnaWtpZjV5WGovb1FBUG9zYmNI?=
 =?utf-8?B?cDc4N05ZK3VROTRKL3BxblNNbWVUUUtGcVIyc3hFRmNhYzZ3SVNZSWJaRWpL?=
 =?utf-8?B?NzVTU0U4NThGOXNiazhSUTZLTnhRMExrSDZaK2pJQ3l2Q2ZZcFpIRDFGTkhj?=
 =?utf-8?B?ZGprZnJOZXIrd01QNUFPdlZSeDZUOUVJOGRjcEVsL1BCdTFqbTN4TTcrYjc4?=
 =?utf-8?B?YThEQ0NObkNlRWhnUUFwdnM3TFdSLyszQ29HQlk0Y2dyUzdoOGpkU0s2Mk1R?=
 =?utf-8?B?bFBINVBxRHNVcWJGZG5MTE9KbG9EMTZIaVdaL2NhRGJqL3Y5cG0rRFVRUWRk?=
 =?utf-8?B?dVNpYzdna1ZQUFJGMkNEN3dHajhFTzJOUlFjM1d6K0VMZlNQbWFqUW4vdS9u?=
 =?utf-8?B?czliVDR0YzArUTdWSEhVczlQQVBERXk3N1hGaW1FdW9oRFhseG1tampuL1or?=
 =?utf-8?B?dFVQNEdFRk16WUlaUi9nSzhFZzh5RnBsRGJMZXR0MWlYdkhRa2kwNStreVlF?=
 =?utf-8?B?c3p1c2NYREt3TWdhdWFOekUrT0hjTFRzMjFpeWN2d3QxSEFwWG9oZnVnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3h6VmhNWk55ZHplcm5FN1UvQkRsYVRpaW1VZWZmR1haa2FQTk9PSW0xYXl5?=
 =?utf-8?B?U2w0Mko0anRXR0V4bTdNSW84SnhjMHVROFpoKzdxVFRqVVdsZ2h0VXlNK091?=
 =?utf-8?B?M3lYQXVhY25ERThhVzloYUQ2WWExeENzNFhJd1N6N3cxVUJMamtVRUlCVzg3?=
 =?utf-8?B?TTdPSVJGdk1CQjV2MmpBYWlNQnducjBPMWJDVTdvQll6ZUg1WnJiQjd2VmI5?=
 =?utf-8?B?SEJ0cUdOYjdybnNUd2tMaXlGc0JmeXB5WXIzQzQrOVdlZnRpRnA1UUc3QkE5?=
 =?utf-8?B?MFJLSHhjRW45UUp5RVA2U3NjeUN6Z2NwelJHWmpvWndtdEg3Y05nSFJ1OENM?=
 =?utf-8?B?NlVXWFk2RklHU25wa0hmcnZUa3M3QmNvRW9SYlV1STZPL2JIK0I2YzZJeDd0?=
 =?utf-8?B?TGt1MVVQV3ZzTG9Ib2NIeG1DQmRQTTZQaDJEc2hxYkd1dE5URHV2UHBOK2hS?=
 =?utf-8?B?TzBpeFZaSXBwQUFpSVFVdklOallXK0ZPSGsyS1M1WWVPSERFRWVSRG1HSVQ4?=
 =?utf-8?B?ejhlRkU3QTFzeE5mU0FLREZTNCt2VUoxcTJTQ3BGUzlha0ZTWmRrOGhSbWk3?=
 =?utf-8?B?RDgxWnJjRy84eDJEb0djaHg5cGluTURlT3ZYR3ZKREpDeEtaS1V4TE5ZbzRr?=
 =?utf-8?B?NWtJSENOVmRaQ1hHRlNYQXlVV3dPZHlCQzFsOFllZnM0b0l4VUtUbTNtSlE2?=
 =?utf-8?B?bVpUUGxCd01hSlEwQzM2bFA3NGo4OGZONXlGenRJbXVsWGswVGZ3VERLSnhP?=
 =?utf-8?B?RFA1UVBYeGJYZ3pQNlZCMGoycTNyYmkxUzRwSDlFZ0dFTzFzNlBSbjJaVFV5?=
 =?utf-8?B?K3F2enkzc0xGUXJrSys3dVdvZUVQV1FobXpQbk9BYS9EaDhqallPQnlUM2Fh?=
 =?utf-8?B?ZklKS1Y1NDM2dCt2VjRuaXR0blJ3aW1iRkNHQjdWM0U2QkhyY1p1QjBoYmUr?=
 =?utf-8?B?ZEtGbmFQdW5xcXcyM0NhK0lGbEs5MnlwZ3JNNVZlUFlsS24rS0ZVZmpmRFV3?=
 =?utf-8?B?VE1CZWtLY1RkTGRpOTIreW5FT0VJWWFBK2kwOFY2Vm00U2ZvNnhaNHNYRjIy?=
 =?utf-8?B?YldaZ0h1c1lKdUFQTWpJQ0RQQ3NiUG1YczkrWWpjYmFSZzBKcS9XcXNJWHAy?=
 =?utf-8?B?RjVhOGtwYVB3Nk1PaDIzT2c3V0gzNUM0SjgyemlqV2U3SHFGRFBmVnJMRHVN?=
 =?utf-8?B?VURhYmw2QThzb3NGM0VWSnBBMjBnUDlyMUc0b3lVckU4dldHMFRSNzZ2ZXhX?=
 =?utf-8?B?VXV5dW5tQTNXOXRpZHp0NGVNTmhXOXlOWXJXUStOWXdXelNVWFptTGE2ZFF4?=
 =?utf-8?B?SE1tWHRoMk1IYzFpRkF3WExQUUxKYW9wVTE1UEJ6TFVGTzRTNVJ5eFk5RVp3?=
 =?utf-8?B?OEVTQlIvNVNyODk5UGdQaVBacmVFN1k3T3Bia0phODZscnRYVk4xSG44TnhT?=
 =?utf-8?B?ZkZwVEpIQTU2QWljRVhGRng1QUZtS1NDdXhOZUFXT3ZSdXpIT1VWNUVlTnRC?=
 =?utf-8?B?WlVEbW52eW5NUFpVV2FnNXh1bThoYjlYZTA5VTZOZmp6K3dwS2huNkI4Qkox?=
 =?utf-8?B?NlhCaWpaOFJwbUNlZVcxMGh0ZDdOZjJPTnFScXk0V25BTjFNRHJzaCtIeXZp?=
 =?utf-8?B?THR4TFE0eWtERWFuYnhnNVRwRHkwZzdYMnBGR01EVVFRQi84YVR6RVBGS0NR?=
 =?utf-8?B?dGQzSjRMNmZsNDJjTktpRnR1bkJ1VWxrUHNMc2FOMlNSSWhmQkRXNGZvNFNM?=
 =?utf-8?B?YllzT3NFWGt6Smphc2VEUXZoVERjT1hYd3FKOVBNME9wMSs3K24xR3VFcG4v?=
 =?utf-8?B?USsvdkhSN1Vwb3JnelVYSGlBVXNNQkxEdFJkVmFleSs2YmpLdElUTW9VT3VF?=
 =?utf-8?B?U1lCYVhXM2d4aFBweWVHRFlWd0wxQ3FxNlo0UmQxT2J2SWlNQ21BejVZOUJR?=
 =?utf-8?B?ZVhQVG02VkxtL29zNGRGK0FLTGpBcHlsTUdvdnlhOXZwUTh2bmhtNEN0NDhF?=
 =?utf-8?B?bWRkUU0zcmdNMDVHeHRVNjQ5WFBtTFZ6bUtXZm9DaWhtSDB5bmJaVHdhV1hH?=
 =?utf-8?B?WGdBZ1hmSjJlOG5PYllwZTN1NmJrbWJTVzQxR1BXWmRUQ28wSzFvTW9pMHpH?=
 =?utf-8?Q?AmI5G2tcfGBKcpHqtH0GqvBDj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cccbfab0-f0bb-4305-1697-08dc76099a7e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 00:37:59.9584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocFyCJdgOcgVzT9hO52lUo5+1KMvT3p1G241wkM2EcWUZvxheKcsr5d6Jd7rWmK2dgcr5FcQsKR4FzlV3JSSgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6763
X-OriginatorOrg: intel.com



On 17/05/2024 11:08 am, Edgecombe, Rick P wrote:
> On Wed, 2024-05-15 at 18:20 -0700, Rick Edgecombe wrote:
>> On Thu, 2024-05-16 at 13:04 +1200, Huang, Kai wrote:
>>>
>>> I really don't see difference between ...
>>>
>>>          is_private_mem(gpa)
>>>
>>> ... and
>>>
>>>          is_private_gpa(gpa)
>>>
>>> If it confuses me, it can confuses other people.
>>
>> Again, point taken. I'll try to think of a better name. Please share if you
>> do.
> 
> What about:
> bool kvm_on_private_root(const struct kvm *kvm, gpa_t gpa);
> 
> Since SNP doesn't have a private root, it can't get confused for SNP. For TDX
> it's a little weirder. We usually want to know if the GPA is to the private
> half. Whether it's on a separate root or not is not really important to the
> callers. But they could infer that if it's on a private root it must be a
> private GPA.
> 
> 
> Otherwise:
> bool kvm_is_private_gpa_bits(const struct kvm *kvm, gpa_t gpa);
> 
> The bits indicates it's checking actual bits in the GPA and not the
> private/shared state of the GFN.

The kvm_on_private_root() is better to me, assuming this helper wants to 
achieve two goals:

   1) whether a given GPA is private;
   2) and when it is, whether to use private table;

And AFAICT we still want this implementation:

+	gfn_t mask = kvm_gfn_shared_mask(kvm);
+
+	return mask && !(gpa_to_gfn(gpa) & mask);

What I don't quite like is we use ...

	!(gpa_to_gfn(gpa) & mask);

... to tell whether a GPA is private, because it is TDX specific logic 
cause it doesn't tell on SNP whether the GPA is private.

But as you said it certainly makes sense to say "we won't use a private 
table for this GPA" when the VM doesn't have a private table at all.  So 
it's also fine to me.

But my question is "why we need this helper at all".

As I expressed before, my concern is we already have too many mechanisms 
around private/shared memory/mapping, and I am wondering whether we can 
get rid of kvm_gfn_shared_mask() completely.

E.g,  why we cannot do:

	static bool kvm_use_private_root(struct kvm *kvm)
	{
		return kvm->arch.vm_type == VM_TYPE_TDX;
	}

Or,
	static bool kvm_use_private_root(struct kvm *kvm)
	{
		return kvm->arch.use_private_root;
	}

Or, assuming we would love to keep the kvm_gfn_shared_mask():

	static bool kvm_use_private_root(struct kvm *kvm)
	{
		return !!kvm_gfn_shared_mask(kvm);
	}

And then:

In fault handler:

	if (fault->is_private && kvm_use_private_root(kvm))
		// use private root
	else
		// use shared/normal root

When you zap:

	bool private_gpa = kvm_mem_is_private(kvm, gfn);
	
	if (private_gpa && kvm_use_private_root(kvm))
		// zap private root
	else
		// zap shared/normal root.

The benefit of this is we can clearly split the logic of:

   1) whether a GPN is private, and
   2) whether to use private table for private GFN

But it's certainly possible that I am missing something, though.

Do you see any problem of above?

Again, my main concern is whether we should just get rid of the 
kvm_gfn_shared_mask() completely (so we won't be able to abuse to use 
it) due to we already having so many mechanisms around private/shared 
memory/mapping here.

But I also understand we anyway will need to add the shared bit back 
when we setup page table or teardown of it, but for this purpose we can 
also use:

	kvm_x86_ops->get_shared_gfn_mask(kvm)

So to me the kvm_shared_gfn_mask() is at least not mandatory.

Anyway, it's not a very strong opinion from me that we should remove the 
kvm_shared_gfn_mask(), assuming we won't abuse to use it just for 
convenience in common code.

I hope I have expressed my view clearly.

And consider this as just my 2 cents.

