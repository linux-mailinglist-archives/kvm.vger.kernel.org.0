Return-Path: <kvm+bounces-11224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C8E874525
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:29:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6015F286A87
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111F2139F;
	Thu,  7 Mar 2024 00:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GI1rt8/2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843BA380;
	Thu,  7 Mar 2024 00:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709771358; cv=fail; b=C4IVUgldsFCAX6Lg7m2VguTwYpO+R+1zVOOesY6N6wB2Pd+zoaa+OZLoKXgrreE3nollLy6cKF441xAE4PspgwaxVTZPcqTtDECYTQhohdf2cXzWpZn5ry0RPTiorvWu/K4Yxabv/h4V9wVkk7jmqEJ9yUorJJSpuqAHOlEYuSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709771358; c=relaxed/simple;
	bh=7/yrYTlmm5dnkz+73gN22y0bvWNLnBV9w6d0xFsdvmU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vq7Kd5/dHNPtvT1/8F8EmtoLj/LflbM7+TmVq+nEiHFxIut31uAMqaKG5Sh4PhualQHrEtNdj3TTwfWRoDt7LW74xypurvyahSkeSvmoMe8JqdhJX9Ko7mVW6NMqjKyvI5D92tfdZWYFIMvjtVvyhtgzG7i1tDTqGdQlolgPFPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GI1rt8/2; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709771356; x=1741307356;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7/yrYTlmm5dnkz+73gN22y0bvWNLnBV9w6d0xFsdvmU=;
  b=GI1rt8/2LMa0SjnbOCk4tOoKTU1zDnPB2EytC5HspJfEA9Xir8ssSwNi
   WOXHjhzhXqYNQGsfkP/2JzANdEdQ0fnjX/3PG5o+NU0T0+kBELMf7emdr
   E9scziUx2VV8vrpLEWT9nbRhmljzVyXU7d9LhhMx5/mIoCJ7ZaKbW6YjS
   RH5lUcGCGafrS0reP/2dM8doboY78SKWhc/6Xvd8tflC3KhbUiD3HiuGY
   1akBSPwWa+uEs3xa2ViXrseFV8d9N5ob+X4NYJV3Ilk9GACT4J2Qrga/d
   3A4HQnbbM9gXuXUXMokxvb5NpOER7wF9VLNjNqs4OraP6731AZXKeU/zM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4999449"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4999449"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 16:29:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="14514595"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 16:28:56 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:28:55 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:28:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 16:28:55 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 16:28:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0XXT6W7kZglK2S68NwUFUiN1pWPLLsCrg+8nZ/oMNrj+orIN2ooahNL86mNv9m6QN5Kxw8wUt1V6lcBRl7tlkfKKQbqVfdJzR9vndlQ4IhT64l111K8cPxVcc1VSwmpA5paMrUlsL2quZJ9gNDU74lg0oZv9LSIKcQlXj2zdmzWT6BhLs7y1FtOuUqcBR44cS74TwiXXerrw04wErAnCfV8JWMUhbYw0pQI91AnyHAlN53dSimmaZ3Pw3L9LTDXizgQ7D6uBqUgUGwnjLM5YhBqsQBILREw6RZGEMdemj2wedIAIR8p3YyYFgHJqsxrINhWZFSl4cqtJ8Fh+oFD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIeiBy9CGfChUgfU3LM75hJNEOgsGTUbT3NAxHb88OE=;
 b=jBJ24PktJdgRZJ7ZLBzHfEcdFYExq/CWoL0TcHizHUKYILJxt6qD0Vez2GEbbX1vVLUH3gVLnjRCDOxhhZBwad//GHopEq+shjD3WlXCweDYawWVGzwDLopVnzwLlqQbwYgpcpNNpFIOG/m6gYch+GwRbly4AfPbRctOIXByP5fguUgDcIB1qrXbKCjoAtv3tRJbNHiz/eXyOzIADg3n/b8N3d+8QRYerJ4JueZqz/4pDJ3bu2bt+dz0cVXeqQI1zIKIoDjXvtbTEw06aEF2ZOz9mhYN9oB4P6NjhOSACizXLGyNWimrecgm3w2JYSGW4zAq4yKLez7lAO42eDFITw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8212.namprd11.prod.outlook.com (2603:10b6:610:164::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 00:28:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 00:28:53 +0000
Message-ID: <4af321d2-79bc-4245-b701-815be16e5ecc@intel.com>
Date: Thu, 7 Mar 2024 13:28:44 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Michael Roth <michael.roth@amd.com>, Yu
 Zhang <yu.c.zhang@linux.intel.com>, Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-10-seanjc@google.com>
 <adbcdeaa-a780-49cb-823c-3980a4dfea12@intel.com>
 <Zee7IhqAU_UZFToW@google.com>
 <a8dbea9d-cca7-4720-9193-6dbeaa62bb67@intel.com>
 <ZefOnduZJurb9sty@google.com>
 <18510419-3030-4af2-89cd-d642b6135046@intel.com>
 <ZekBBxiackL1dRTg@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZekBBxiackL1dRTg@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:303:6a::29) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH3PR11MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: 37fffe3e-cfdc-4ad9-6381-08dc3e3d9151
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /iI2/dGS17Ay0O9ngdkdvPDMJJhj+3lw4hQu2ZZtWf3sw7nQjuM6g4EaWUkavFEFaSkVZT2Kesmk+VZGLscaJKO8FS4C3/EkER9HQzT0nkGRAJmEeFeY0rTSvEd+pNd7R4CiApp4vYXVkSuf3ZKOgCkQRy8/SCCGgo7jKTzu/yee3IyqmtaEPOjzRj3i+96G+KMykfxxCs4FzZTOgN17Y+j4bkgQw4t+5Jrk9QHm5/jMTeQa7T3R+zPTUb65Hw0a71PoTi0dY4POlnqsIkHNuv6dFK9ZbqjBl+Xs9AqVKkLk5i5FKq6mCvopqSyNu3ktq3Je9q8xuHQhD0osOp4WXncu0PktiSaHcb8RqkRmoxoh7VxWfHMHD7uDbNLK7xn73CEZj9sKEVFZ2QFGMmxdbJRdvSApFMYwYSYksrLmhjh6H13owrMEASXjnv0Qh5LD+xFMDXvH9bFMNRx5/YCG5NkzUN8+8mL9GAlFaNBw2IBqVi5sF8X/yUjcXczHNgUaKyOnDS1SM0fTV63GrDt2JF1PCrAmNfNa6b81ELoT0djf50DukzUVJv0h9dR5819qP1njZcL+//0R80iEAgbu2ztgQDqPpRt91rxhYmAPVBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFVxMURQaGVQUE80R2w5cndQOUFrUUJvK05YaVlwWCtkTEZ3ZmpMZFhiWlJr?=
 =?utf-8?B?Z2VrUHQ1WFpYWUFnV1R5V1ZjdnVJM3Uzdi9OTnpIZWx2WkwxK2V1TjVNR3VD?=
 =?utf-8?B?YnUvT2VkalVkLzYyZ29PbCs0dFpRTkNMeEYyUnRNbnB3ZU1yZlBTZzQ3cE94?=
 =?utf-8?B?VFNSOHY2TlVxTHMrSGREVVpLZE01eXc3U3Q4NEFPN052SGlrZGpMbHMrVjZB?=
 =?utf-8?B?ZVNPZThHR2FqZlVuUGR5RmJBU2J3emZyTnlWNWxtSTJOcFVMUndJOXZUZDdP?=
 =?utf-8?B?Ty82OHorN3VOakJzcmN6ejNzSkpOek5iYXpmWmVsbUxtZzNNeDV3cG1DZ0U5?=
 =?utf-8?B?MXg0ajdrSW1KRDVuTkkzYlB1R1hIRWNrcFZzeDVQYWFmVklRVWt5Zitoa1hl?=
 =?utf-8?B?NFZ1MkwvVFR6S0V4SGN2TGJESzA4QmZFVk8wWUsyMkRQVlc0a21sQVdGQTlD?=
 =?utf-8?B?clhJOE56aVFocDJ0bTBLK1NlWTdKOTNHNmM0Y08yell3M0NsQ0FmRUw5bVhF?=
 =?utf-8?B?cmdvRnZPdW14NGZhazZWK1h3Q1ppMUw4S0o5bzhZU1pzd0ZIckc2UkR5dFlE?=
 =?utf-8?B?eU9ka0FNNHk2YTdZa1FnQUpKK2UwRkcxQ2ZwQ014eEpNUlB4ckx2bjhsbU85?=
 =?utf-8?B?czJIaVc2Nit6N25xcGI4eFIxUldUNDMxQytwM2l2QjJvanVNTXlrNHdJQW90?=
 =?utf-8?B?dkYyODFKbjFJbklUM0RvQVY4bGlRNHEvd0p1MGZXbStZUFp4UStTeldnRUJv?=
 =?utf-8?B?ZEpxQnVBRjg1UHFFM2J2VUU5MnU5SU1mMXpDWGltTmpFNi9iRXNSZjRpN3Z2?=
 =?utf-8?B?WXZNUzZUaG1zdTVPeW1ETmE2akpJUTVyWEErTzQyZmcyak5vZnlnMHR0YUQ3?=
 =?utf-8?B?dGRkT0lOam9hWk1hd0hhVERDVVUrNTYvMG9mMU9yenNhZlQvaVpLaDA3d1FT?=
 =?utf-8?B?dkpucjltS1ZYTGx0UjR5MUdwY0NhbU94bjFzZ25WWVNmMjJXTTdXbDFTWGRO?=
 =?utf-8?B?V1lBSHlpeGpIZEtGejYyTWJ1L2YxanA2Tml4VVRFbHRyMFdwM2lLVFZyZjZs?=
 =?utf-8?B?bjJtYTFoWnVTaStUQnR2M1hWNmdDQlc5NVZQTG9HWXhiampUbnZ0ZUJGeGJO?=
 =?utf-8?B?cjdPV2VXWFNNdDNEekh6aFJ3QXE1SUFTeXZESE5aKzNqWFFNYWVNdGZJaGd6?=
 =?utf-8?B?Z3NPUEttV2IwcmozS2NkVGoyZTU0RkZzS09MTDNzUzJTb28xMkZoT3U1STMy?=
 =?utf-8?B?T0xKMzZSOFdreFBia2lGY0Z6QXczYWZTRDducCs0d2NVb2hTdkJYRnlPWXR2?=
 =?utf-8?B?b0J6ZzFvSXl2N3d1djRIdDhkZGFHUlM0WDQrYTVEM3JMM1gyRkpKYmpjd3Y4?=
 =?utf-8?B?bG96OGJ3UGxrTjIwQldFNjkwYVdhUlFqMmRNUjV5N05FdFVBQjRvT2U3cHBo?=
 =?utf-8?B?Kzc4ODdKd1FpaExuQUhRY1QrdG5VNjR3NzZ1MWRQaFFkbEQrTUY3VFNwNjgz?=
 =?utf-8?B?cUE5bXJnL0pFekFnK292RHRnQ05XR3Z4YXVRVUJJb3hPY1FuY0NBN2gzbXFs?=
 =?utf-8?B?eVZTaEhSVE16cnhJa3hGSDROdXV1RDhhajMwTXd5Qms2V1RCR3k0UHVFZ3JG?=
 =?utf-8?B?blJoUVVGME14OU56dUw3bkZzZE9ma2xJQ2w4YmIzT3E2Vy9BVURUVHJNdzJn?=
 =?utf-8?B?bm5uMk5PZGNNNmFpNzBPUDltSGU1bzZHY2YrVTh2U0YwZ083M0gxVlA4WUdy?=
 =?utf-8?B?bEI3cXVLZCttR2lRaWtsbWwvbStRcDc0WkhXeTRrdHhPV2VqS2Q2VFI5Uk5U?=
 =?utf-8?B?Z2lMQzdxbzZVSSs5QjI1QkZFVjRjd2hLbFNqWmFZZDkydldvdmV6QTVBTjFl?=
 =?utf-8?B?cUNFVEdPc2VrRVFWMFltL0F4Ump5amw5elpEbDNZQjZaeUtxZHl0dWVaQ1do?=
 =?utf-8?B?YkRUWlFwRHp4QkZicXJ5bFRRT2dJUEVTTnk4RFB2eEx4MU9MT25RWmgxRTEz?=
 =?utf-8?B?R3J6YTFlSkRyVHNyQmdGZTJ3VDR5eHRtU3lMMUNpKzAzcDlzd2NMakZUang5?=
 =?utf-8?B?amhQVmZvcklnQjVNOGhPTTV6bDd5WVFheFI3cm01T1RETGRMdjk1Q2xlWnlP?=
 =?utf-8?B?WTR4TTg0YWt0aDhiTGtQSHlmUDVLeVRPVVFoUzdqVTNleDIxdjk4bWhIMHQr?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37fffe3e-cfdc-4ad9-6381-08dc3e3d9151
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 00:28:53.3235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3eVMhn0bnjhgpXq92LNPDUXdLKCIi8fHhWQz9e6xy3ND6vgEoFj1zGNhp+XDjrHJnVX3yJzg0gsiw7VYzZ3DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8212
X-OriginatorOrg: intel.com



On 7/03/2024 12:49 pm, Sean Christopherson wrote:
> On Thu, Mar 07, 2024, Kai Huang wrote:
>>
>>
>> On 6/03/2024 3:02 pm, Sean Christopherson wrote:
>>> On Wed, Mar 06, 2024, Kai Huang wrote:
>>>>
>>>>
>>>> On 6/03/2024 1:38 pm, Sean Christopherson wrote:
>>>>> On Wed, Mar 06, 2024, Kai Huang wrote:
>>>>>>
>>>>>>
>>>>>> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
>>>>>>> Prioritize private vs. shared gfn attribute checks above slot validity
>>>>>>> checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
>>>>>>> userspace if there is no memslot, but emulate accesses to the APIC access
>>>>>>> page even if the attributes mismatch.
>>>>>>
>>>>>> IMHO, it would be helpful to explicitly say that, in the later case (emulate
>>>>>> APIC access page) we still want to report MEMORY_FAULT error first (so that
>>>>>> userspace can have chance to fixup, IIUC) instead of emulating directly,
>>>>>> which will unlikely work.
>>>>>
>>>>> Hmm, it's not so much that emulating directly won't work, it's that KVM would be
>>>>> violating its ABI.  Emulating APIC accesses after userspace converted the APIC
>>>>> gfn to private would still work (I think), but KVM's ABI is that emulated MMIO
>>>>> is shared-only.
>>>>
>>>> But for (at least) TDX guest I recall we _CAN_ allow guest's MMIO to be
>>>> mapped as private, right?  The guest is supposed to get a #VE anyway?
>>>
>>> Not really.  KVM can't _map_ emulated MMIO as private memory, because S-EPT
>>> entries can only point at convertible memory.
>>
>> Right.  I was talking about the MMIO mapping in the guest, which can be
>> private I suppose.
>>
>>> KVM _could_ emulate in response to a !PRESENT EPT violation, but KVM is not
>>> going to do that.
>>>
>>> https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com
>>>
>>
>> Right agreed KVM shouldn't "emulate" !PRESENT fault.
> 
> One clarification.  KVM *does* emulate !PRESENT faults.  And that's not optional,
> as caching MMIO info in SPTEs is purely an optimization and isn't possible on all
> CPUs, e.g. AMD CPUs with MAXPHYADDR=52 don't have reserved bits to set.

Sorry I forgot to add "private".

> 
> My point above was specifically about emulating *private* !PRESENT faults as MMIO.
> 
>> I am talking about this -- for TDX guest, if I recall correctly, for guest's
>> MMIO gfn KVM still needs to get the EPT violation for the _first_ access, in
>> which KVM can configure the EPT entry to make sure "suppress #VE" bit is
>> cleared so the later accesses can trigger #VE directly.
> 
> That's totally fine, so long as the access is shared, not private.

OK as you already replied in the later patch.

> 
>> I suppose this is still the way we want to implement?
>>
>> I am afraid for this case, we will still see the MMIO GFN as private, while
>> by default I believe the "guest memory attributes" for that MMIO GFN should
>> be shared?
> 
> No, the guest should know it's (emulated) MMIO and access the gfn as shared.  That
> might generate a !PRESENT fault, but that's again a-ok.

Ditto.

> 
>> AFAICT, it seems the "guest memory attributes" code doesn't check whether a
>> GFN is MMIO or truly RAM.
> 
> That's userspace's responsibility, not KVM's responsibility.  And if userspace
> doesn't proactively make emulated MMIO regions shared, then the memory_fault exit
> that results from this patch will give userspace the hook it needs to convert the
> gfn to shared on-demand.

I mean whether it's better to just make kvm_mem_is_private() check 
whether the given GFN has slot, and always return "shared" if it doesn't.

In kvm_vm_set_mem_attributes() we also ignore NULL-slot GFNs.

(APIC access page is a special case that needs to handle.)

Allowing userspace to maintain whether MMIO GFN is shared or private 
doesn't make a lot sense because that doesn't help a lot due to the MMIO 
mapping is actually controlled by the guest kernel itself.

The (buggy) guest may still generate private !PRESNET faults, and KVM 
can still return to userspace with MEMORY_FAULT, but userspace can just 
kill the VM if the faulting address is MMIO.

But this will complicate the code so I guess may not worth to do..

Thanks for your time. :-)


