Return-Path: <kvm+bounces-6376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 199B483000A
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 07:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75943287F56
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 06:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3068C09;
	Wed, 17 Jan 2024 06:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N5wlxSwM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AC979DE;
	Wed, 17 Jan 2024 06:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705472185; cv=fail; b=ni45tnpGvPD5BcXkTaZ0vBwf3UbXNAnEV4a0SPiGu/LolGCPv98NHsJzrpEauKOn9k7580ybCq5fVA+ep/+7vziNX3xNWEjeH/wTXMjmRgZeUECni3LYCK1WttwT2etbg3V0GyiQn7Y06CdpwIDCKgOzCl3YuO1/sUVos89xxFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705472185; c=relaxed/simple;
	bh=eNKDgATXsn97m+a63CmFc/YkCBxXauf0TniHaxnzbJw=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 Message-ID:Date:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=ElXw6it5OF48Lh3blD8ri7py8PWDXhIZVbg52Ti3i8TkbfBb5YrmZN+O03mXcjwqcV627NciVlgkw33HUeJ88Wuj6S7sRwCoi+nadH8h6zTKQOzk1sW6JCogPpt6XWBeSdjYA950yqvyAGDECOK0jIu6ivc4fn9MnqJF+BqdXGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N5wlxSwM; arc=fail smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705472182; x=1737008182;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eNKDgATXsn97m+a63CmFc/YkCBxXauf0TniHaxnzbJw=;
  b=N5wlxSwMUKFHF8gNSpXEnbwoiLNGzdzG1+381U7fOikbQwCCsiWBpLES
   zXP6cKKgkRYa4XEqKUolVn9ksQPZqTpgZ1BMyrPOy9Kbsdy1lqgGBOHgx
   FTxKUevc11DtOmjBsZcY36xb+VuBN8OmwGrA9pCqJJpJEZvFgHYFIG3wY
   n5cBy9uPyxij/at+e2B+5enk8uGluCRliRSsGHmGKoc4sZcFZy2JsMj3b
   SB+r6OzI7FDGQ0DBTiFlHxz4zPpz0zm7WheHZoVIqnJcG1FvQPP1NJq+E
   /gEv+CplRtSQuR9cVthHcAU02GL9UNIaHTpUIcQFhshsT2lHdwmoQaEBB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="398951803"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="398951803"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 22:16:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="777334753"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="777334753"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2024 22:16:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 22:16:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Jan 2024 22:16:19 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Jan 2024 22:16:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQy7AYTyiMwCygqhcf3aB86eRU0orLYwHa6QkSxXSIxcn7YHZAEkoCZ/8dkXCAPsmsL9VFsfnEGoEvOGT5MkZysZdkE38z8bX+/fD4Biayg73kdIlPbe6/QwiK/QCGDU+hC4JUG8P4pmsIqXsadTsEv57G4QBS/rrS8X9fam6vhx1x2CMizoa6eEjB/K0ouaIps7Mj0lwVEuchmz5LpvpuQePoOwAp+fAAsink5XRblUMYYTdCgn/Dy07Hc0YBJYjp+Snw8Kkssf6kzCclhKa91ih3VX/7+KfS5O1gPQcemnfX+TNJ7ywPNrqp2+YLR0sMlQ++fWllggQTZM7/VYOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBpZyG5nAWqmKWj9i4QgK0r3jrVPs96uzbxfj1j5rWo=;
 b=aXcC5BCcnkpuC1jENXHFKPKohipaNJPOAYFvK6RkWEMll1Wue6Go3Ik4A00QEvX+mzQ4J2vqQeipP/oomRO4otnx+Ke/n1nCCjqb/WOBo0WrHkS4wVWG+PI4mMHzjEEXasPbzKJFhI8xU4XHJnVnJm8sU5/ZCAyTWWFOqbiEjLHvE8pkoaE0nbAygkXSWHjsOs5vCuBLV64lKkL8GOBLnTSHHxVfCdDs3kTMkT8zJS6PDtcBQ5weTM2Z1Tt3bci8uUe3+wIvEgNzvBshfgzPPOI79cvI0Vw8FHe6j/0Kx1Z5pls6mVei50f0N7YvG53KMdo03mL3uo5NZmWadsC5bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH3PR11MB7297.namprd11.prod.outlook.com (2603:10b6:610:140::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.18; Wed, 17 Jan
 2024 06:16:17 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7202.020; Wed, 17 Jan 2024
 06:16:17 +0000
Message-ID: <4a27b660-ac03-4ab5-bf2e-cdddb0147bdb@intel.com>
Date: Wed, 17 Jan 2024 14:16:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 22/26] KVM: VMX: Set up interception for CET MSRs
To: Yuan Yao <yuan.yao@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"john.allen@amd.com" <john.allen@amd.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-23-weijiang.yang@intel.com>
 <20240115095854.s4smn4ppfjfa2q2z@yy-desk-7060>
 <ee2c5c91-68bd-4f78-aafc-c14093f05342@intel.com>
 <26258c1a-2908-4931-8d6f-fac6754ca2e8@intel.com>
 <20240117053114.6ykoke6gjp52ehvz@yy-desk-7060>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240117053114.6ykoke6gjp52ehvz@yy-desk-7060>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0038.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::7)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH3PR11MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: d4925a9a-291a-4342-e937-08dc1723d093
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S5/k1jzWVMgPN70un+DNcvhdOr1nwfX2KQXp1O3sB2NLNQMK4uXHgCq/rLX1lmWvpLriVxyNhSu21vNopApuaPNQwcxTPR+Z6x2AUZ6GKh/0G5diZnRkKQdaDpJjYdJFRuC4d3aeYBWY6ejpQXYkvoY2JeieAQEQ+8RdPVM7Atrpozi6LL6FoToTQ1Stso3ioRFm0OqWzo3KLRb9DsEeLR0qPupOEgGRmqK78++l2sxFI8BeCUjDD+hwe/1J/5qj8tKZiVSwW8tSnI6Y7lHl10gNYgz4FvzPxb9Ikhr1/W2UegpkLGk87mKA18+rQNwv8dHIqDO9SZStO1mbbMW5GsiUGSX9D8ZJxlfxZTG6BVw7VBuINI+6d7Zm0Ynn2jgSTQ2WpSyaF8nIdhY8ZafULgkHvuDQjA2q2sIlxeaKHE7CIUC0HdgSKGJV6c9qmOWS2M9qjxQHiNwZf2DOGE1fJJKxEek2XXsMaOw1IRs3tXpObcVjcOGuMzM1ZdT8z25bT/V1wqw/McBIubZ9waOeGYFke9xRpR2dpGLBRtyhi7gYL8+zxDOfp1GRgLeS3c/BEBPpRH/0uTOaQsTEZT1t8SnKoW1R3Y7m/O7ab3WyzSD1a1FoWFA69THaEKGlx62emrhkOfMlGjGTKB7WukYXtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(31686004)(31696002)(86362001)(6506007)(6512007)(6486002)(36756003)(53546011)(2616005)(82960400001)(38100700002)(66556008)(26005)(5660300002)(66476007)(2906002)(6666004)(66946007)(54906003)(478600001)(4326008)(316002)(41300700001)(8936002)(8676002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YklldkowQkVCYjZMdmJKeUpIeVFaTUdWWktrWkx6UisvOEcxQmtGbFhzTFBO?=
 =?utf-8?B?S3AyRGI5endPVDRFUHR0YUk2L0U2UDJDeWZVNkFZblpJMWEyQUp6MTFrS2VY?=
 =?utf-8?B?a05oY05PcGE2RWtXdXhlOXk4bWR6RnVybTJxRW4xcTdIQkhnMmhsSy8vNW1H?=
 =?utf-8?B?K3BoYzF6cE16VFVBMkdQU04yY1FVa3ZhMjZwejJMYUlVd0tnV3FnVjc2V3pN?=
 =?utf-8?B?dkZHelhQWWVNNTlmT3FuWkkydlZmendueUlwK3luVVl2dHM4UFFDa1d0R2Iv?=
 =?utf-8?B?YkR4anFNZ2poN25Fd2pOdGpUQStFWjRnSXk3N3pJVmJ0ZU0raFhLVFNhaCt6?=
 =?utf-8?B?MVZ0VFZub3g5VVF5cEFJUEdPc1BJOFpEZVVPdzcvbEgxMmh2MGpTc0h3ajJM?=
 =?utf-8?B?YTdTNXQvdG90dVJJOUdMaG1aZDFEU3pEYnE3Y2FnUVhsYXV3aVZhS3Z3SXdL?=
 =?utf-8?B?UzdyZ0tOVzNwZ2RTTldrWldibC9QK20yVi83NHYwNXJhaVZxM2tiRTd3bGJV?=
 =?utf-8?B?b2RhcWI2d1dscHVpcWwzS1dTL2dRd1FJRmtMU2tEckxzWUdoSnBQajE1N3R5?=
 =?utf-8?B?RzFuU0dna1dxTFgveXNaVUNDUkJneGl1bEk2ZTlCNGxJZUM5SEQ2Mko4cTFJ?=
 =?utf-8?B?eWRIdDQxWkRmeG9MQXQ1WGRVaE1ueEtMNzdFa3VkUmFPY09IYm9tZUxNTEhJ?=
 =?utf-8?B?Unkrc2toZTNPbkJJSUFiUy91VEFrbi95cnhmdnpGTUxTNUg2VWVPVk1pMG5o?=
 =?utf-8?B?VG81dnA2Tm5nQ2JUanF1NTJKM3NUUVdEanVoSEVxNGtja0xqUDMydkpNci8y?=
 =?utf-8?B?WUVJclR1SlNvWVVBRXNISEw0amtJVklnaDd5ZEhWQTJjYTB1RE9SclUzTFdy?=
 =?utf-8?B?Q3N4Y0RQZ1pyaU5hRSthVjlrR1pDUzFENkpKNXJKd25ha3pVTm5MNmhiRHpu?=
 =?utf-8?B?MDNPTG1BbCs1eVl4ZHZjVWl2MGNWQmVlTlYxL3Q5SjlVYm56YVljRVZIT3ZJ?=
 =?utf-8?B?QVMrZEw3V0hjeEJnQ2crSkMrdmM3TGtQVmhxaisyQUY5aThobCtLUW94bzdq?=
 =?utf-8?B?Sk9jWEU5Y2orckZsVHhGUklGSGo0RTd1N2dSSGVnMG41dmpsVm15MVBNaU8y?=
 =?utf-8?B?R1FZbVFiWEJib1ZwNkgyR3RGQXphTTRsTzFUNHVLVHJodUdOdTdNT3JqZUxr?=
 =?utf-8?B?WitnMC9hQWpMeGVpRU05L2VjZVM3WWFwdExFMUNSVmg5TDNPYjJ3aWhrMmlB?=
 =?utf-8?B?ZkthL3BxTGRDU0NPbzFzekVhTHljeU1ubmc5cVJPY3g3WkFmWS9Xa2FRS2ps?=
 =?utf-8?B?R0Q5dVEwNE0rTmxiQUc0eXV3UnBMcHBTUHpUMytCdjkzNzFpRHV0eXloRENz?=
 =?utf-8?B?aEx0L203TEk1d0dGdlhVdnpaT1I4U0JudTZ4OGsrQ09ZWEhEVWNySUozcWl6?=
 =?utf-8?B?aEY3d2RJNFZhQnVMNE1MRzNhY2ZFdWJzQnJaT002TUp6NEpRSnQ5TzJOMjA3?=
 =?utf-8?B?aU1sMTVxYTRXMksvSERXUngyTlpHSngvcmRwajY1Z3M2YjdFcXhNMWc5QTlp?=
 =?utf-8?B?czNIOC9seHVkWDlvVEt2NmdhVDFJMWpWcWc5aGNXamNzS1FnVlJzTWh5VGJU?=
 =?utf-8?B?bXY1Q3VmWERNcUtaMUdIODh6K25WbjNORm94OHpoMUM0ZThXWHVsczFKd2gr?=
 =?utf-8?B?RzdtVXBFN252REk3UExMRHRoNFBNOVNOY0w0VVZ5SFZmbG9MVzJ5NG9JaG1r?=
 =?utf-8?B?eEZYeHM2M0dSbjRZSVNERkVGTVpkMUJRVmdVN3pEb2RPekhCcHd1VmV2K1JK?=
 =?utf-8?B?V3ZBV2YyZ011dGgwR2VTaU1oR2tjY0RVZ2hXZUlXdFhnZVVhdjRzQWMrMHRz?=
 =?utf-8?B?dWcwQ1dFOTJkOFVSTjVQQnpaeFMxaXpnNDVHUnN3ZXdla1JmaFdMOUEzUndO?=
 =?utf-8?B?ZUc3b0dXRERUVGRlSVJIYW9SMGtiVEZIYlB5TFlRTGVMb0MxQTcwbERDWjJL?=
 =?utf-8?B?Nkt1OTRJZFFwSlB0MHdNMXk5VXdRSnNMZ2xiMmN0cGxHeGlxZXJETUxkeVdv?=
 =?utf-8?B?UHFpUytvWkp1MHJTMk0reFhRalJlMnJMMnJkZWZsUEFDS1lsbGRDSnlPYlJO?=
 =?utf-8?B?dUZkSmt1cXVNZ1RXb05HZXdmOHc3TWNncnpEa1JoK3BqeHNweVFpaEsxcVZQ?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4925a9a-291a-4342-e937-08dc1723d093
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 06:16:17.3744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C9e5ciQOtaw1ES9+Bx/6N+0ELFIj1k92FT8Bm66l5Gz18RJs+8Ig8b7uBa15Hiy9jX7a5q1PtYkxq+DvaLRFxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7297
X-OriginatorOrg: intel.com

On 1/17/2024 1:31 PM, Yuan Yao wrote:
> On Wed, Jan 17, 2024 at 09:58:40AM +0800, Yang, Weijiang wrote:
>> On 1/17/2024 9:41 AM, Yang, Weijiang wrote:
>>> On 1/15/2024 5:58 PM, Yuan Yao wrote:
>>>> On Thu, Dec 21, 2023 at 09:02:35AM -0500, Yang Weijiang wrote:
>> [...]
>>>> Looks this leading to MSR_IA32_INT_SSP_TAB not intercepted
>>>> after below steps:
>>>>
>>>> Step 1. User space set cpuid w/  X86_FEATURE_LM, w/  SHSTK.
>>>> Step 2. User space set cpuid w/o X86_FEATURE_LM, w/o SHSTK.
>>>>
>>>> Then MSR_IA32_INT_SSP_TAB won't be intercepted even w/o SHSTK
>>>> on guest cpuid, will this lead to inconsistency when do
>>>> rdmsr(MSR_IA32_INT_SSP_TAB) from guest in this scenario ?
>>> Yes, theoretically it's possible, how about changing it as below?
>>>
>>> vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>>> 			  MSR_TYPE_RW,
>>> 			  incpt | !guest_cpuid_has(vcpu, X86_FEATURE_LM));
>>>
>> Oops, should be : incpt || !guest_cpuid_has(vcpu, X86_FEATURE_LM)
> It means guest cpuid:
>
> "has X86_FEATURE_SHSTK" + "doesn't have X86_FEATURE_LM"

No, this is invalid within this series. With patch 21 to prevent SHSTK in
32-bit guest, I think the check of LM here can be omitted.

then
vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, incpt); is OK.

>
> not sure this is valid combination or not.
> If yes it's ok, else just relies on incpt is enough ?
>


