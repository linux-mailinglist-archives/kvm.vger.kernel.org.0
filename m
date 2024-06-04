Return-Path: <kvm+bounces-18833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2308FC032
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54B081C22531
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3B4F14E2E4;
	Tue,  4 Jun 2024 23:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OwXC1U+x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1729914D2B8;
	Tue,  4 Jun 2024 23:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544987; cv=fail; b=Tl4Vo9j69sZI/qgdZ0uSTvaPIbPMXa5nLLYVwdO7fZveMQ/FBYMtYPUTNRzOpxpX/XKAUWO0Mhyu1sCTIFkPbO/X7JeC2qWm/VLllJvKAT1jUuIuv9bInrWiBV3UayDelXyl2r+3knynd0MuggGvOu/Qt9/1rLEF4+CRRFxan2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544987; c=relaxed/simple;
	bh=yC2prlpw9jJW0+tQde7I9fjgffpeKTssxPQ2rqJMm/E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dRkpbvWxmXtCf7yuEtd87IUXt9QKqKXYjisocLU1Q3uaWX/vTQEyFrrnPKllH9oEecxCOFDu2EDDwFPr7bQej77ipqW+DodGolO833OyLOsnuztlZBUh34CTgocLHgRIvXjTVEBHaWLUCZTVCRaBdMrMKjTKXXY3zGutqhvQVeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OwXC1U+x; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717544985; x=1749080985;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yC2prlpw9jJW0+tQde7I9fjgffpeKTssxPQ2rqJMm/E=;
  b=OwXC1U+xhaqNXEuo09TCvQkYhIqib22ZIXx5bNsc+5utFDWbXarTnC2Y
   QYS+ZLVMxIxlXkr1K7OvfB5xPXBFV4kxa6fbKqHXU+u3LA45IC2R74U9g
   zp8rzCnZImGwv2PoB+Z/+XdFWiHo1MOOgXboLWU5KX6TGD8h20mG85KbP
   Mw7K56dSzjBNf1DJmjl0ZLJ5qScELOnI5ROIhwnXcOsrrm6ZUDlWXj9gw
   lWRknnKAs1Oxb6lfnwZKVkCRbeE5/9D25vVa1LKvJUsagvwd/5VycajL7
   dyjMbtzafv+rPaZA8JuR0sLr/YOGR8RfIs3bvJw3AvsNwN2pPA7TssMYZ
   w==;
X-CSE-ConnectionGUID: hgbD+igPSMiNtAu3YownWw==
X-CSE-MsgGUID: ZPwgy6lPQV6o3Hb8XjBTVw==
X-IronPort-AV: E=McAfee;i="6600,9927,11093"; a="13963163"
X-IronPort-AV: E=Sophos;i="6.08,214,1712646000"; 
   d="scan'208";a="13963163"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 16:49:44 -0700
X-CSE-ConnectionGUID: 4vsveEPzQQOU+sqzha34kw==
X-CSE-MsgGUID: q/KN28VhRryD9js3dEtW1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,214,1712646000"; 
   d="scan'208";a="37287847"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jun 2024 16:49:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 16:49:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 4 Jun 2024 16:49:43 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Jun 2024 16:49:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwpT5gX7thVuWohN9VMyEP++4An9q0BSjc27X+rOJyRDLpRqGn1XTB7iCtrLcIyUh3KG2Buj749GiSwTtjgtSQoQeW+Yu1082zao5fHgRjRDkkAc4Q7sIe0O1ijJ3yK6FLUnlQ//7dsvIJY2DL0sRJxoQp7Z0bDJkyEGxUp/jllwTLoV6EOfm3vjozGdDuU+TjdoiEt5YQ5GKQZE6fEIGGzWvtCNuWBECT3jW8lMll6NY6aUkWoYODK3m5L9MdqjHzTG4EJCh1qNpO+ImnRFQnPobfucUqn9nbD1+LyXWaNXiQMJ3iBe2rC2ujCphthGR6M6uG0295i9EyVYIUaeBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCwq7wmH2frfTed+up85royEjD2M8kDSPhf6GKXpOOQ=;
 b=BPS6rYD+k9g4J7Rgeqq3VZzF8TAMxDrAvL3gQ5fZL9Kk9Y/U1LJWsKRYsbUlbeVvFQGO4F0UB6jbSOXmQrF7ymBwKjNBz+EisvZd/i8P+645tXwth1Ps+7s3m2dRLGV628kyQ0ZdJVosQR0trjatnKNmVZjWU7s1LKJsJqp0KbZlzC7WwiW/bpVVj1KawELVWZnHlMOcKrfo9VmdQ4VTAEhJUL57lmi7dAzd7jv6h7Cr+9xH5/nPSQLVPdwZxDfD96Z9LqmTyYNx/p4jltMzNvDDwQgQQqOq0AlvQCHs7xWFTuxG3qoFRpbwgkDPXj2vUiIOAoyLs9al3vRZXXFMAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB5823.namprd11.prod.outlook.com (2603:10b6:303:186::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 23:49:40 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Tue, 4 Jun 2024
 23:49:40 +0000
Message-ID: <d2d64211-bd70-4212-811f-c039d2d8dabd@intel.com>
Date: Tue, 4 Jun 2024 16:49:37 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <cover.1714081725.git.reinette.chatre@intel.com>
 <eac8c5e0431529282e7887aad0ba66506df28e9e.1714081726.git.reinette.chatre@intel.com>
 <Zl38b3lxLpoBj7pZ@google.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <Zl38b3lxLpoBj7pZ@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0123.namprd04.prod.outlook.com
 (2603:10b6:303:84::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: fb2a3a56-80ab-43b8-24e6-08dc84f0ffe5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QnJlcjlaMFRxYVhPT2ZVN3lGeEEyaTkxVXNVZWwvdGx6bFlXM3luWHhzOTZQ?=
 =?utf-8?B?WVhzUm45Qmw2TWRsZWg2cndRY1o2NG5HU0dWZytDSUIwYmJ5VWU4SHVKd2Nw?=
 =?utf-8?B?eWRablBPZDk3bUltcm9NVDNBZGZtL3F3UUtpLzR5MUV6UXk2cWNyRDBIaDJM?=
 =?utf-8?B?RzZweEhyWE9DdDA3N04yWm91NldOYXZCM0FTcXl5YkFoTFFxeUJiL3Q3a0hQ?=
 =?utf-8?B?N0E2TFcrdUJGNzZrdlNXb1FOOEVnaGV4ZkhTMWpPTmxaSkNNanFDOHkvV2Jx?=
 =?utf-8?B?dmgxTmZMNE04MzdNYW51Y09YMSswNVFPY2R0NUpsUHVlK29qUWhwR3NWN1dr?=
 =?utf-8?B?VUtxV09kMDV1WjJ3dDFnY21hQkRVRkRnTlZ1eUR5OWFLdWFpTXJ0Y29ERVBS?=
 =?utf-8?B?S0Vjck5qeWg2azFTY01VOThyOURMU3dzUE5DUmgxTXZQV0ZmV3JUN1VIRGJK?=
 =?utf-8?B?ZzlBME5KVEtzaGlGNXd2RnpKZGJaMVBnQ3dwK0dSeCtJTmVQblBDVnR2aVR0?=
 =?utf-8?B?U3J5Wk9HVjYyOTlQTHRFVVNRNVU5dWVhK00yMDFKT3NuWjN5bnBvVEVFOHpF?=
 =?utf-8?B?WmxkVmdQdm1jNTc1QUwwY0IraUU2R3BVVGx4Zkd4a21UT1BQa2FEeEtaZHZ5?=
 =?utf-8?B?RVRNZHQxQms3bGJPa1YzNjVPWGRHd1VrVFpseE1EVlRLK05lblVYZndRRC9y?=
 =?utf-8?B?cTNJMVZUVUdVTDZJMWNtMzExYzd4RHYxZnJYU2FHeVM0OC9KZFdZbUVXMFlN?=
 =?utf-8?B?Y25WYlBUNDI4NVdEeXdIOVEvbzY3QVVJQ2RCZklkRkxRL1FIQ2VPdlVpcElT?=
 =?utf-8?B?N2RTTEpDQ2l6QlV0WWVTSUwzLy94TENuZXZOclFYb2NWTkhjMHRrVllVMkc2?=
 =?utf-8?B?ZkV6OHk4WmpManpjVTcwaEZSVG0yMDBWSVVDaENzTUo1ZUhYem1MTVk5YkZG?=
 =?utf-8?B?dHlBVjc4MVlEZXJuaklnMjVDNldZV1BrZEtKME8weFhCUWlsZWtqSk5iclhJ?=
 =?utf-8?B?NE9ya2kvT0NtSS92VFZ2cy9scHhwVEhBWnhrc3RVRUliTXMvR2JmOHN0TjZ0?=
 =?utf-8?B?TXkzcUZmYXYzeE5XQTdXTngyZkI1aDZOcHZ6aklhK2FlUjd0WU5qSDlsbmhP?=
 =?utf-8?B?MDR3WXNPTXMvK0ZyY2x6RmJ2OWptQ1QzQkplR2tUaDVua3VqRnBMQ3NtNmdO?=
 =?utf-8?B?V2w3amNSQ1NpK3ZRWnhBZng0d1RJYTB5NHZOZ1huUkRPeFpYbVZOSW9XdVIv?=
 =?utf-8?B?N0pSRmc0RVBiMUQ3a1JRN08vQTltcTRpeFU4enNmTTRMeks1bEtnaGU2a3Zv?=
 =?utf-8?B?R1VwNDlRQkdDTDY4UTBxMHFod1hmaFl0UjdJZysxUngrT0NCSVBGL0tVaG5t?=
 =?utf-8?B?VmlUVERCejVMVHNJMjV1T1dSOUc0UVMyNURzWHVOQVh1RlVNOS9jUUdxaDN6?=
 =?utf-8?B?dUJMTkJzeFpRMkVxMzltTWMzNXlZRnREc2xkUUNMaGF2d2tWZ2hhaWFmWnVo?=
 =?utf-8?B?L1k2Vmt2cU9mbkhVUGE1ME82UVpuQXd6Z1crTWw5N2Jvb1Z6ajFacGpkNXZx?=
 =?utf-8?B?REZGNVFWR25zNUo1OHFRTFlmVzErcGJhNlQ1cFhWR3M2UzF3ZFBBVCtWdUdl?=
 =?utf-8?B?SXhEY3ZvUzJYWElyNWlicXAwWno2YTRuS0hmMGNQMitSMmRabEhDR0R3ckh4?=
 =?utf-8?B?TlhsTmRYQWIvd1Z1bWNJd0MxaHovdVRWR3gxQStaejNMTFJiT0JiRTNBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VS9GNXkzSmxHcWtiM2VzUHNJbmpNb3Y3VmhvenJWb0lNeTZlVDEyWnVRcEZ6?=
 =?utf-8?B?TktReTBvMUorRnEvdkpockJnTzFoNlExVG5IZU45ZnZ5d2V6eTFzd0FMbnJN?=
 =?utf-8?B?SGdndzIyVlpzL0ROcGxWM041VDZXK1oreDMvbUlmbFNVSXNTWnFIbFY0R01J?=
 =?utf-8?B?bkZrNHM0YmRMMXRlbXFwUFBqQ3R2SzdUWGlyY0krZDRHcGtMdTFJNGx6Y1FQ?=
 =?utf-8?B?eXRJbzhFT0tFZHpaT0F4bG1IOUhQaGVGbmM5WDErc1RUSGNjTlJDeUhIako3?=
 =?utf-8?B?bWlBMGZqTWVGWE5tUHlZVm5FajhhSEVBNnRKR1NjcW45cFp0eno0T2o2Zzhl?=
 =?utf-8?B?bmgvbkgyME96ZlNDeDBKck9kV0pYYVVMRXpYekRWNWJlRFd5OHlUMHhVaGs1?=
 =?utf-8?B?ZTlJWXVFQzZSeDhBRWNLdjFSd0cwOFgvWmtRNnNkdVRRckd3b1hSUFM2Nkd6?=
 =?utf-8?B?UHVzNHBPc3ZRYW9XZmMrcWtvUUlNamlqanY3N0UwMnRJT01jM3Z5M3RyaUo5?=
 =?utf-8?B?c2g2ZWZGeTd2Q1AvOXI3Q0hEak1hb091bCthRFV6MVZtMHkzVEgvSmREK0FK?=
 =?utf-8?B?YyszZkpmT0VzajlYMGZlWmtFTUxtcHpxSnFWaWpkRFhrSnFSSHlIMlJkM3U2?=
 =?utf-8?B?dUNWSmo0UXlVZm52ZDZ6ME93Q3lLTEtHajRqRllnckhJNStUcGM3RVh0MjlJ?=
 =?utf-8?B?MHdSZUlmV0tuMkc1bVhJZ2NWTmEzOVdRNnFYTjl6Vk1IR2p0ZmFVc25WQXAv?=
 =?utf-8?B?dFRCL0wyWGhZMkR5cXJ0K29wWWR0NkdnMFdueUhiTnhlYlZ2QmRpRHBaUVIy?=
 =?utf-8?B?L2N3ZzBLdDlsNlNSaFh1Mk1VZlJPKzlyTHFDNVdEeUlWRUR6UVVhWHhpNHRH?=
 =?utf-8?B?Rmo4bjMvc3BUL2NzWTYwNkppNVlaS2I5TGFMUkVwYlUrOWN6R1B4ci9IRnFC?=
 =?utf-8?B?VDhXR1QrT0JKZ21EQjYwVy9mL2MyTnhsRGNyblpYd05rZWRnZzhNdnhSQ3dK?=
 =?utf-8?B?T0wyVnVPQ0xVcHpPdks1U3RuZXpBSEVPdWs3MktTMVhSQTlsTWMwOWRVOVFZ?=
 =?utf-8?B?dzFTY0FZa2x3T3RTeUkxOG1FNGMxamdXMk5WN1lGZzcvYm9Mb2R2Ry91dGht?=
 =?utf-8?B?V2dPZDVzckMrNjZVZjkrT2I1N0ZOOE5UQllRUE5ieFBsSzM5N1NrWTU1cFho?=
 =?utf-8?B?ZlI3TExTSGtkYUl3VWs5VkJZcHdLRHBXaFUvNWtjbEFMb2VwU1NQZ2VIVm1S?=
 =?utf-8?B?c1NVRXp4YkxwdFQ3Z0JES3REUDZ5QkFVY21DQVM5UEdhL29yUXhyQzZVY0Y5?=
 =?utf-8?B?WFlXZFJpOGZPZUJFRkgyQ1o2Y2sxaFpxc3VoRXNwb29HcDdBNzRVMU9nZnBp?=
 =?utf-8?B?cWM2Vll6TEFtbzVicXhjU29kdVR4a2FJNGI2eGg2Nzgra0hVNytGVWl4REtK?=
 =?utf-8?B?S1VqM3hwVmFORFdDdUI0Um53MW9aVXFUREJpQ1V1QzlWTnhrN0FibnVXVlJW?=
 =?utf-8?B?NUdHMThYSEFGSGNPbmQyS0U2cVl2UkxTTGl1Z2lXWlVwaXdNa09CSEp5VU9h?=
 =?utf-8?B?Y0x3ZlByRm91elRXd0ZDUGlOYXM5SGZOUjFYcVlmMHFORXoyNitzbkk2Yy9H?=
 =?utf-8?B?VVNuamczYVJoeTV0WW1CUkFIMEh4Um05YWx1YmtxYzVXSVpaTnhXNmU1NW9V?=
 =?utf-8?B?d0RjSkY3aVJOSFFhei82dG1rRGZwbGR1Q0o5NUhCeWNodjlMWnNkVVdPcTkr?=
 =?utf-8?B?TDBadDVIa0tnejRVeXVHdEM4Y0FqNzNURVoxVDFvYTRuaXZtQzNyYzFIcnZl?=
 =?utf-8?B?Z1RxVnREbkNSTUJLQm10cDlXUGNPL2E4ZWdnL0piYkYzOCtNblQ5cXVqUGZw?=
 =?utf-8?B?QjB6MHNzSjJWcUo3dVpjZk1XL3lpam1YUXFjaXcrWFBpNSt4SXdKWHFGODJR?=
 =?utf-8?B?Y210YVROYkpCNDVMMjl4ZCsvZzhDUjdOMlEwRmZpSitId0dRdXBVMEtZMzhB?=
 =?utf-8?B?SUdUTFlxcnh6ZUpEajdoNURueU9lRFBiQ3RQSlF0YXdLbThwOHI1NGQvOTBU?=
 =?utf-8?B?ZmRUdjg4endjMlNrTDZOdm5YeEtRUlliNkJaN3lCK2R0VXlmTVpkeEVYc21L?=
 =?utf-8?B?aXlJY0hHcWN2WVB0cDJNekFwWUpRZEhGQzJLampEMkhCMXdleVlYc0Rzejk3?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2a3a56-80ab-43b8-24e6-08dc84f0ffe5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 23:49:40.0902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JGGEZXA7tpwdIJJ2yblmAlAQeObjD1QFw0w/7tO4+o4qPz5ejwhHYlgQuZyTT5Y4/7TTB/qmLNfMmXggPk9KXOMFad3s0YnBiptDsJrJjLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5823
X-OriginatorOrg: intel.com

Hi Sean,

On 6/3/24 10:25 AM, Sean Christopherson wrote:
> On Thu, Apr 25, 2024, Reinette Chatre wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Test if the APIC bus clock frequency is the expected configured value.
> 
> This is one of the cases where explicitly calling out "code" by name is extremely
> valuable.  E.g.
> 
>      Test if KVM emulates the APIC bus clock at the expected frequency when
>      userspace configures the frequency via KVM_CAP_X86_APIC_BUS_CYCLES_NS.
>      
>      Set APIC timer's initial count to the maximum value and busy wait for 100
>      msec (largely arbitrary) using the TSC. Read the APIC timer's "current
>      count" to calculate the actual APIC bus clock frequency based on TSC
>      frequency.

Thank you very much. (copy&pasted)

> 
>> Set APIC timer's initial count to the maximum value and busy wait for 100
>> msec (any value is okay) with TSC value. Read the APIC timer's "current
>> count" to calculate the actual APIC bus clock frequency based on TSC
>> frequency.
>>
>> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>> new file mode 100644
>> index 000000000000..5100b28228af
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>> @@ -0,0 +1,166 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Test configure of APIC bus frequency.
>> + *
>> + * Copyright (c) 2024 Intel Corporation
>> + *
>> + * To verify if the APIC bus frequency can be configured this test starts
>> + * by setting the TSC frequency in KVM, and then:
>> + * For every APIC timer frequency supported:
>> + * * In the guest:
>> + * * * Start the APIC timer by programming the APIC TMICT (initial count
>> + *       register) to the largest value possible to guarantee that it will
>> + *       not expire during the test,
>> + * * * Wait for a known duration based on previously set TSC frequency,
>> + * * * Stop the timer and read the APIC TMCCT (current count) register to
>> + *       determine the count at that time (TMCCT is loaded from TMICT when
>> + *       TMICT is programmed and then starts counting down).
>> + * * In the host:
>> + * * * Determine if the APIC counts close to configured APIC bus frequency
>> + *     while taking into account how the APIC timer frequency was modified
>> + *     using the APIC TDCR (divide configuration register).
> 
> I find the asterisks super hard to parse.  And I honestly wouldn't bother breaking
> things down by guest vs. host.  History has shown that file comments that are *too*
> specific eventually become stale, often sooner than later.  E.g. it's entirely
> feasible to do the checking in the guest, not the host.
> 
> How about this?
> 
> /*
>   * Copyright (c) 2024 Intel Corporation
>   *
>   * Verify KVM correctly emulates the APIC bus frequency when the VMM configures
>   * the frequency via KVM_CAP_X86_APIC_BUS_CYCLES_NS.  Start the APIC timer by
>   * programming TMICT (timer initial count) to the largest value possible (so
>   * that the timer will not expire during the test).  Then, after an arbitrary
>   * amount of time has elapsed, verify TMCCT (timer current count) is within 1%
>   * of the expected value based on the time elapsed, the APIC bus frequency, and
>   * the programmed TDCR (timer divide configuration register).
>   */

Thank you very much. (copy&pasted)

> 
>> + */
>> +#define _GNU_SOURCE /* for program_invocation_short_name */
> 
> This can now be dropped.

Right.

> 
>> +#include "apic.h"
>> +#include "test_util.h"
>> +
>> +/*
>> + * Pick one convenient value, 1.5GHz. No special meaning and different from
>> + * the default value, 1GHz.
> 
> I have no idea where the 1GHz comes from.  KVM doesn't force a default TSC, KVM
> uses the underlying CPU's frequency.  Peeking further ahead, I don't understand
> why this test sets KVM_SET_TSC_KHZ.  That brings in a whole different set of
> behavior, and that behavior is already verified by tsc_scaling_sync.c.
> 
> I suspect/assume this test forces a frequency so that it can hardcode the math,
> but (a) that's odd and (b) x86 selftests really should provide a udelay() so that
> goofy stuff like this doesn't end up in random tests.

I believe the "default 1GHz" actually refers to the default APIC bus frequency and
the goal was indeed to (a) make the TSC frequency different from APIC bus frequency,
and (b) make math easier.

Yes, there is no need to use KVM_SET_TSC_KHZ. An implementation of udelay() would
require calibration and to make this simple for KVM I think we can just use
KVM_GET_TSC_KHZ. For now I continue to open code this (see later) since I did not
notice similar patterns in existing tests that may need a utility. I'd be happy
to add a utility if the needed usage pattern is clear since the closest candidate
I could find was xapic_ipi_test.c that does not have a nop loop.

> 
>> + */
>> +#define TSC_HZ			(1500 * 1000 * 1000ULL)
> 
> Definitely do not call this TSC_HZ.  Yeah, it's local to this file, but defining
> generic macros like this is just asking for conflicts, and the value itself has
> nothing to do with the TSC (it's a raw value).  E.g. _if_ we need to keep this,
> something like

Macro is gone. In its place is a new global tsc_hz that is the actual TSC
frequency of the guest.

> 
>    #define FREQ_1_5_GHZ		(1500 * 1000 * 1000ULL)
> 
>> +
>> +/* Wait for 100 msec, not too long, not too short value. */
>> +#define LOOP_MSEC		100ULL
>> +#define TSC_WAIT_DELTA		(TSC_HZ / 1000 * LOOP_MSEC)
> 
> These shouldn't exist.

Gone.

> 
> 
>> +
>> +/*
>> + * Pick a typical value, 25MHz. Different enough from the default value, 1GHz.
>> + */
>> +#define APIC_BUS_CLOCK_FREQ	(25 * 1000 * 1000ULL)
> 
> Rather than hardcode a single frequency, use 25MHz as the default value but let
> the user override it via command line.

Done.

> 
>> +	asm volatile("cli");
> 
> Unless I'm misremembering, the timer still counts when the LVT entry is masked
> so just mask the IRQ in the LVT. Or rather, keep the entry masked in the LVT.

hmmm ... I do not think this is specific to LVT entry but instead an attempt
to ignore all maskable external interrupt that may interfere with the test.
LVT entry is prevented from triggering because if the large configuration value.

> 
> FWIW, you _could_ simply leave APIC_LVT0 at its default value to verify KVM
> correctly emulates that reset value (masked, one-shot).  That'd be mildly amusing,
> but possibly a net negative from readability, so
> 
>> +
>> +	xapic_enable();
> 
> What about x2APIC?  Arguably that's _more_ interesting since it's required for
> TDX.

Added test for x2APIC to test both.

> 
>> +	/*
>> +	 * Setup one-shot timer.  The vector does not matter because the
>> +	 * interrupt does not fire.
> 
> _should_ not fire.

ack.

> 
>> +	 */
>> +	xapic_write_reg(APIC_LVT0, APIC_LVT_TIMER_ONESHOT);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
>> +		xapic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
>> +
>> +		/* Set the largest value to not trigger the interrupt. */
>> +		tmict = ~0;
>> +		xapic_write_reg(APIC_TMICT, tmict);
>> +
>> +		/* Busy wait for LOOP_MSEC */
>> +		tsc0 = rdtsc();
>> +		tsc1 = tsc0;
>> +		while (tsc1 - tsc0 < TSC_WAIT_DELTA)
>> +			tsc1 = rdtsc();
>> +
>> +		/* Read APIC timer and TSC */
>> +		tmcct = xapic_read_reg(APIC_TMCCT);
>> +		tsc1 = rdtsc();
>> +
>> +		/* Stop timer */
>> +		xapic_write_reg(APIC_TMICT, 0);
>> +
>> +		/* Report it. */
>> +		GUEST_SYNC_ARGS(tdcrs[i].divide_count, tmict - tmcct,
>> +				tsc1 - tsc0, 0, 0);
> 
> Why punt to the host?  I don't see any reason why GUEST_ASSERT() wouldn't work
> here.

GUEST_ASSERT works and changed to it.


...

>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_vm *vm;
>> +
>> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
>> +
>> +	vm = __vm_create(VM_SHAPE_DEFAULT, 1, 0);
>> +	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *)(TSC_HZ / 1000));
>> +	/*
>> +	 * KVM_CAP_X86_APIC_BUS_CYCLES_NS expects APIC bus clock rate in
>> +	 * nanoseconds and requires that no vCPU is created.
> 
> Meh, I'd drop this comment.  It should be quite obvious that the rate is in
> nanoseconds.  And instead of adding a comment for the vCPU creation, do
> __vm_enable_cap() again _after_ creating a vCPU and verify it fails with -EINVAL.

Done.

> 
>> +	 */
>> +	vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
>> +		      NSEC_PER_SEC / APIC_BUS_CLOCK_FREQ);
>> +	vcpu = vm_vcpu_add(vm, 0, guest_code);
>> +
>> +	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
>> +
>> +	test_apic_bus_clock(vcpu);
>> +	kvm_vm_free(vm);
>> +}


Apart from my uncertainty surrounding CLI I believed that I am able to
address all your feedback with the resulting test looking as below. Is this
what you had in mind?

--->8---
From: Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH] KVM: selftests: Add test for configure of x86 APIC bus frequency

Test if KVM emulates the APIC bus clock at the expected frequency when
userspace configures the frequency via KVM_CAP_X86_APIC_BUS_CYCLES_NS.

Set APIC timer's initial count to the maximum value and busy wait for 100
msec (largely arbitrary) using the TSC. Read the APIC timer's "current
count" to calculate the actual APIC bus clock frequency based on TSC
frequency.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes v7:
- Drop Maxim Levitsky's Reviewed-by because of significant changes.
- Remove redefine of _GNU_SOURCE. (kernel test robot)
- Rewrite changelog and test description. (Sean)
- Do not set guest TSC frequency but instead discover it.
- Enable user space to set APIC bus frequency. (Sean)
- Use GUEST_ASSERT() from guest instead of TEST_ASSERT() from host. (Sean)
- Test xAPIC as well as x2APIC. (Sean)
- Add check that KVM_CAP_X86_APIC_BUS_CYCLES_NS cannot be set
   after vCPU created. (Sean)
- Remove unnecessary static functions from single file test.
- Be consistent in types by using uint32_t/uint64_t instead of
   u32/u64.

[SNIP older changes]
---
  tools/testing/selftests/kvm/Makefile          |   1 +
  .../selftests/kvm/include/x86_64/apic.h       |   7 +
  .../kvm/x86_64/apic_bus_clock_test.c          | 233 ++++++++++++++++++
  3 files changed, 241 insertions(+)
  create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ce8ff8e8ce3a..ad8b5d15f2bd 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -112,6 +112,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
  TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
  TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
+TEST_GEN_PROGS_x86_64 += x86_64/apic_bus_clock_test
  TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
  TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
  TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
index bed316fdecd5..b0d2fc62e172 100644
--- a/tools/testing/selftests/kvm/include/x86_64/apic.h
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -60,6 +60,13 @@
  #define		APIC_VECTOR_MASK	0x000FF
  #define	APIC_ICR2	0x310
  #define		SET_APIC_DEST_FIELD(x)	((x) << 24)
+#define APIC_LVT0	0x350
+#define		APIC_LVT_TIMER_ONESHOT		(0 << 17)
+#define		APIC_LVT_TIMER_PERIODIC		(1 << 17)
+#define		APIC_LVT_TIMER_TSCDEADLINE	(2 << 17)
+#define	APIC_TMICT	0x380
+#define	APIC_TMCCT	0x390
+#define	APIC_TDCR	0x3E0
  
  void apic_disable(void);
  void xapic_enable(void);
diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
new file mode 100644
index 000000000000..f2071c002bf5
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024 Intel Corporation
+ *
+ * Verify KVM correctly emulates the APIC bus frequency when the VMM configures
+ * the frequency via KVM_CAP_X86_APIC_BUS_CYCLES_NS.  Start the APIC timer by
+ * programming TMICT (timer initial count) to the largest value possible (so
+ * that the timer will not expire during the test).  Then, after an arbitrary
+ * amount of time has elapsed, verify TMCCT (timer current count) is within 1%
+ * of the expected value based on the time elapsed, the APIC bus frequency, and
+ * the programmed TDCR (timer divide configuration register).
+ */
+
+#include "apic.h"
+#include "test_util.h"
+
+/* Guest TSC frequency. Used to calibrate delays. */
+unsigned long tsc_hz;
+
+/*
+ * Pick 25MHz for APIC bus frequency. Different enough from the default 1GHz.
+ * User can override via command line.
+ */
+unsigned long apic_hz = 25 * 1000 * 1000;
+
+/*
+ * Possible TDCR values with matching divide count. Used to modify APIC
+ * timer frequency.
+ */
+struct {
+	uint32_t tdcr;
+	uint32_t divide_count;
+} tdcrs[] = {
+	{0x0, 2},
+	{0x1, 4},
+	{0x2, 8},
+	{0x3, 16},
+	{0x8, 32},
+	{0x9, 64},
+	{0xa, 128},
+	{0xb, 1},
+};
+
+void guest_verify(uint64_t tsc_cycles, uint32_t apic_cycles, uint32_t divide_count)
+{
+	uint64_t freq;
+
+	GUEST_ASSERT(tsc_cycles > 0);
+	freq = apic_cycles * divide_count * tsc_hz / tsc_cycles;
+	/* Check if measured frequency is within 1% of configured frequency. */
+	GUEST_ASSERT(freq < apic_hz * 101 / 100);
+	GUEST_ASSERT(freq > apic_hz * 99 / 100);
+}
+
+void x2apic_guest_code(void)
+{
+	uint32_t tmict, tmcct;
+	uint64_t tsc0, tsc1;
+	int i;
+
+	asm volatile("cli");
+
+	x2apic_enable();
+
+	/*
+	 * Setup one-shot timer.  The vector does not matter because the
+	 * interrupt should not fire.
+	 */
+	x2apic_write_reg(APIC_LVT0, APIC_LVT_TIMER_ONESHOT);
+
+	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
+		x2apic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
+
+		/* Set the largest value to not trigger the interrupt. */
+		tmict = ~0;
+		x2apic_write_reg(APIC_TMICT, tmict);
+
+		/* Busy wait for 100 msec. */
+		tsc0 = rdtsc();
+		tsc1 = tsc0;
+		while (tsc1 - tsc0 < tsc_hz / 1000 * 100)
+			tsc1 = rdtsc();
+
+		/* Read APIC timer and TSC. */
+		tmcct = x2apic_read_reg(APIC_TMCCT);
+		tsc1 = rdtsc();
+
+		/* Stop timer. */
+		x2apic_write_reg(APIC_TMICT, 0);
+
+		guest_verify(tsc1 - tsc0, tmict - tmcct, tdcrs[i].divide_count);
+	}
+
+	GUEST_DONE();
+}
+
+void xapic_guest_code(void)
+{
+	uint32_t tmict, tmcct;
+	uint64_t tsc0, tsc1;
+	int i;
+
+	asm volatile("cli");
+
+	xapic_enable();
+
+	/*
+	 * Setup one-shot timer.  The vector does not matter because the
+	 * interrupt should not fire.
+	 */
+	xapic_write_reg(APIC_LVT0, APIC_LVT_TIMER_ONESHOT);
+
+	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
+		xapic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
+
+		/* Set the largest value to not trigger the interrupt. */
+		tmict = ~0;
+		xapic_write_reg(APIC_TMICT, tmict);
+
+		/* Busy wait for 100 msec. */
+		tsc0 = rdtsc();
+		tsc1 = tsc0;
+		while (tsc1 - tsc0 < tsc_hz / 1000 * 100)
+			tsc1 = rdtsc();
+
+		/* Read APIC timer and TSC. */
+		tmcct = xapic_read_reg(APIC_TMCCT);
+		tsc1 = rdtsc();
+
+		/* Stop timer. */
+		xapic_write_reg(APIC_TMICT, 0);
+
+		guest_verify(tsc1 - tsc0, tmict - tmcct, tdcrs[i].divide_count);
+	}
+
+	GUEST_DONE();
+}
+
+void test_apic_bus_clock(struct kvm_vcpu *vcpu)
+{
+	bool done = false;
+	struct ucall uc;
+
+	while (!done) {
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_DONE:
+			done = true;
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+			break;
+		}
+	}
+}
+
+void run_apic_bus_clock_test(bool xapic)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create(1);
+
+	tsc_hz = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL) * 1000;
+	sync_global_to_guest(vm, tsc_hz);
+	sync_global_to_guest(vm, apic_hz);
+
+	vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
+		      NSEC_PER_SEC / apic_hz);
+
+	vcpu = vm_vcpu_add(vm, 0, xapic ? xapic_guest_code : x2apic_guest_code);
+
+	ret = __vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
+			      NSEC_PER_SEC / apic_hz);
+	TEST_ASSERT(ret < 0 && errno == EINVAL,
+		    "Setting of APIC bus frequency after vCPU is created should fail.");
+
+	if (xapic)
+		virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	test_apic_bus_clock(vcpu);
+	kvm_vm_free(vm);
+}
+
+void run_xapic_bus_clock_test(void)
+{
+	run_apic_bus_clock_test(true);
+}
+
+void run_x2apic_bus_clock_test(void)
+{
+	run_apic_bus_clock_test(false);
+}
+
+void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-a APIC bus freq]\n", name);
+	puts("");
+	printf("-a: The APIC bus frequency (in Hz) to be configured for the guest.\n");
+	puts("");
+}
+
+int main(int argc, char *argv[])
+{
+	int opt;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GET_TSC_KHZ));
+
+	while ((opt = getopt(argc, argv, "a:h")) != -1) {
+		switch (opt) {
+		case 'a':
+			apic_hz = atol(optarg);
+			break;
+		case 'h':
+			help(argv[0]);
+			exit(0);
+		default:
+			help(argv[0]);
+			exit(1);
+		}
+	}
+
+	run_xapic_bus_clock_test();
+	run_x2apic_bus_clock_test();
+}
-- 
2.34.1

