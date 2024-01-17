Return-Path: <kvm+bounces-6373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BCF982FE9F
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 02:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5BDCB24FB3
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739FB1C11;
	Wed, 17 Jan 2024 01:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kdeAEib/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E5615BF;
	Wed, 17 Jan 2024 01:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705456739; cv=fail; b=n1thktkNrq9yA19G/EractaTAKavzcpCPGspg1BD1RncxoHvMwM19ZAoN5bQP9SgkHe3ATKXs1IAjJJszXk7+RgXoK9gxJt4XPjOjf9/rtxhqPzu78zPUr1ssn/6KNTw/CcI7H/bWmyLAl2VbOn/Nez6OjT8TobRhsYDCSgY8Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705456739; c=relaxed/simple;
	bh=4yZZNoLwQuXri8LqMRs5khu7PHShHM+Sm4kJWaiN4IM=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 Message-ID:Date:User-Agent:Subject:Content-Language:From:To:CC:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	b=m0b1xdyd3E+ulJyoOGDjItvQdHjpOFFdbbJ1uPaf0+PcqlIRMC1RvXW9tN95czVB+Nw0ruAU8asXs7wzGeLJ/afCoJRBAVJy/3Q81qslYYqE2dCCVfBDtGB/cgmLyAgihlMZf7NrpT2dfZyX3BTaqxgqmO5AN7DBu9y92IqzYMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kdeAEib/; arc=fail smtp.client-ip=134.134.136.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705456735; x=1736992735;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4yZZNoLwQuXri8LqMRs5khu7PHShHM+Sm4kJWaiN4IM=;
  b=kdeAEib/wyUrqBuwW3eClZpljq38mgjQ5AdGubcfG7qmqVhTZJWd1U4d
   z7WMOVlfc4yZpVpOoLbhPapyHH2IOVmdpbtstHG/wdyve6uRMU9IWrlXR
   hNvlxUzwT1NH0EB1SXPiYUXXPiYgSz8ouNVSyniGy576osqnfK4Ou6jE9
   vvSRU2sbUIr7Ag/A76yNj5wZvfHcVaJ2r8IETOq8qy4Ohcr0B7kX8mW3+
   vViSSbNkwNu+1zE2q7FkJhJvjRMlRA/g1/U0TCL25XdtjR8qHOwjKIcnn
   mFzm/v5RrbBEHcvOD8ch5FMysC3gk7POwoQBoUYuqnuhVcuVY9JQDBkjf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="466423378"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="466423378"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 17:58:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="907578970"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="907578970"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2024 17:58:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 17:58:53 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Jan 2024 17:58:53 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Jan 2024 17:58:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kn2Qhz6kGKWSnP/u4Oebz3jgEcbXJmNNLHCQYcLa1Bs5WdmUECbeTKp1TcIVlG0Dyp9z/J9GBVwTBchXNZHG1FoyfCblP3fB8VwApsf9iKxcms8Kz28jdk9jfnBI+xDCLZ8WidMit0UiDLYbCgCcoWV+RmjHWkrsRebGSlNqudKFgSJ1Zwlvcxy/j5TzaMSkCoIn6BN7fpJy/CbIAwqo0C2E3g16riPIbV6f4ljI2p1E9XwUoHil5E9rlRn/JpqdBXlXpM7jpILJi/FkHJTEg7M4h6+Km3p6QdL8MGkT35VK/b+KUPSCKz+pR8alWOzB2gYvhxsbZ4SvLcW024uOmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9dxnhMrgAgaL3md6Aj4JLF+STT+R7WqmaMW4TFFrX8=;
 b=nWdeMot23zPKrtdUihEuyI76uDf81nNxr9Jkz321wDfOW/Hm4pfanrsjFus+vuIudf9pVG6jHkjiyxZa8GOZQWMT5nvAjQ3jgxzTYucRcS/mv5UHAfJ28PGifwA//r5wx9gqoXL+kyV9kUYsPKjZ8sAlUAKhG0YjmIdpylsBKYcIkXYhhEYYKQpiIsGKovURwrh+mM7NhQ14y0cKIo2M0nSlIO2JDDkFeZolF6S5jCtcrd1QqOWsfrjBd8fEdr1ldSd0UXKM47j8/yNzfyt7oJZL9t7WVxYk+QAPxJ2TkBcRFm+pB7ONCQGAjy/c3gzuFtiTGv3HmAQFZzu0c86yPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MW3PR11MB4537.namprd11.prod.outlook.com (2603:10b6:303:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23; Wed, 17 Jan
 2024 01:58:51 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7181.022; Wed, 17 Jan 2024
 01:58:51 +0000
Message-ID: <26258c1a-2908-4931-8d6f-fac6754ca2e8@intel.com>
Date: Wed, 17 Jan 2024 09:58:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 22/26] KVM: VMX: Set up interception for CET MSRs
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
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
In-Reply-To: <ee2c5c91-68bd-4f78-aafc-c14093f05342@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MW3PR11MB4537:EE_
X-MS-Office365-Filtering-Correlation-Id: 6867fb8d-5ef8-42dd-5885-08dc16ffda25
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtkY1l5sY5mkB9PElCpWVvLmXc08NI937n+X6n2iLZ/3GZuHCCaYJ3SjokCEONvV4QGzIB7ykLznNr/AIuHgNHEv87NBAgg0IElEi2OuE2xiuUQkkxqUhN16tXmEWkTzR88gNx/o8o3TSTLwCCVnOKY2DOP2CMHKb5jq8MvsGX+eQ1nOY8mVwGEQS0M6WAST8o3H6VRyJMQfemGbLfgCtGcZoVoVNsvRTz/hl3J21tor8EULKLyxaecYWftTubEKlyus6wGNa+2g4vViVHNz8ShJ+3ont3SDx2WAtpBU0bP3ASioU6B+493iSJfq1lryYWY/EILJmFDy/GfXDVQ1nauZytBDwS/EIG2noubDUkEhoNPpjXMdXigtobXEMDyuts0UgPq2OlAz5SrrFfjR4tIuutizqbCtcSu7QgfDdtXhIxj+c64Z6zNVTSOvG/0dpEIQ4cg3+jM/Y1+Jc44g8Zv2gMAhg/r1xLXLQqJbP6AA0YepcZhmtYeI/3Cv+o0pXDCkAeX4BtQOfuObezy8sOIOHu/UWFqgc34GfOGnCi0asenTRGHz76J40mc234o9FzdL5KUtCRVj5x9NAijT5awXO8PcU2ENSpBsHdun1lec3V0qf+j0ANNVkjLh9QrwveB/9aTh2JhjdqGGtYh4dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(396003)(346002)(376002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(31686004)(6666004)(5660300002)(4326008)(66556008)(6506007)(316002)(8936002)(66946007)(54906003)(8676002)(6916009)(66476007)(6486002)(6512007)(26005)(2616005)(478600001)(38100700002)(53546011)(4744005)(82960400001)(41300700001)(86362001)(31696002)(2906002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnNCNDdnZDgweloycHIzWHRiSVpTZlJ1NjI4TEVrOTJvOXVXTWdpcFFvQWFG?=
 =?utf-8?B?c1lxRnlNVFBGeDhPRkxRZkdnNitoZlN1YTVQR1pNeTNYbTBKRVU5QkNwcmNo?=
 =?utf-8?B?aktic1lXalJTR0o1c3R1eDFKSWVmdGFySk5kM0o5alBidUZkblM5SW5QTFFX?=
 =?utf-8?B?NHhBWEJoOGZ1WG9VMGRnOCtCNmFtMVNXYkxTOHpnMzh3OWt1Ly92NDJ4UlFL?=
 =?utf-8?B?Z2JmUlVmcHd1alNnZnRQZEVKaVZTaDBSalZjLy9zOU81ek9YYnNXUC8yWVV5?=
 =?utf-8?B?VTB0K3ZYcjhycFZzZFdHU3F0U3cxTkpoZ2pISStOUE11WWFiVXFxV2lnZzJD?=
 =?utf-8?B?UTRvdElSclJualc3QlRMa2VPUGo4Q25xTytkWE40QUxZYzlGUW9SL0liWFZQ?=
 =?utf-8?B?N2tZcFVPQklKN0VPN0Z5K1BNcG9OU3c2ZHh3bktmZGpMYzc1SmJaM0pWOWJx?=
 =?utf-8?B?S1dGTWRqZWY2dk9idnNZSCs0VkxNTDFQSEUzZUNKbWc5S0ozNjVhNi90SHhs?=
 =?utf-8?B?QzUwZm9tTzM1UU1UaXBseGJiRFNodytxeURjTi9SZjhReCtIK0NzN24vZ2t6?=
 =?utf-8?B?RTJUcXVQV3M3VGxBWEVCdnpReXV2OHQxcFRzdTFCVFNxZnRtVU5qQkNMUXJV?=
 =?utf-8?B?MkZNRUdCYWU2Yk1uVDBnZFl2QzZiNDNDa2ZpOGcwVjExWE5JSllnYTVFY1Y5?=
 =?utf-8?B?eHY0SGxtY0Nxb210aU93TWNucmprTUlpdzJoMDQybGtjY1BWcitiL2RxWGt2?=
 =?utf-8?B?TVlqMUtpV0tybzJ6WWVuT1hRMDZMOFNWaVhyNlZNc1A2SUdPRXpWaGRhTXdm?=
 =?utf-8?B?Q2dlWGxPYzhnRlFBdU5hd0M3U0s5empmcG85TjUzL3EveEtXU1Jva3c5WG5y?=
 =?utf-8?B?aWhnQVZ5bjdCSHB0QUF1MmJMMDJSeTUveEVSRUV0Y0FsdVFiQldFS1FEODBq?=
 =?utf-8?B?QWRPSlF2S0tZWkpUVlFyZmgvVENTOVNleCswQk1TZC8rK1NTVCtPbjNXV2Q2?=
 =?utf-8?B?UnJnRXdMZXEyVHJJSEYzZjBiaGFzL2M1b0RQT1hteG5MUjcvVGlub0RHVy85?=
 =?utf-8?B?VjZVczk0aEVOZUR5cDhZZU14aHJjTmlBR3pEaTVCTFVseXgvd1pQVWhGaEt3?=
 =?utf-8?B?Sk9kZkoxT3ZsYnROOTdWeHBLeHAvcEVZQUVJcmpKOVpHbi9iMHBWNlhNNDhu?=
 =?utf-8?B?VnhVaGhscjAxL3R4TEN0V01KS0llczJOeGY5YWlqZFh1VFEySG9kbEpkN2Rj?=
 =?utf-8?B?dElUVTZHUTBPcXUzdjNFUFVtQ1EvTFNDcTZqbkhJVmdrRmJGNjlNQ20zUWtm?=
 =?utf-8?B?aDZoLzRLK0IrdStRSGt6UU9PTkNKRlRBQWZSM1NNU09kMnJpc3FSQ2hYSEhO?=
 =?utf-8?B?YXFqM1g1cEpWc0trZy9SNXJqT3JSQ1RMRzVDMFdrSFhmNzZrQnpnd20yVm4z?=
 =?utf-8?B?dERIektJM1RIZEwyTjNKcnB3UzlCMkkzMzRlU0hvL0twWWpZQVIzSjdSa0RG?=
 =?utf-8?B?TlZVZ2VOSUdrUlVESkJLUjhncndmcUJ0VSt5T2wzT0ZpMVFWQktpYmxMMTF0?=
 =?utf-8?B?K3NQMmtYd1RHM25JNFJ6Y1BNWWQ5eWhqeDhnWVVZcXh0S1puUjZpOEFSRkxK?=
 =?utf-8?B?bVAzd1V1TzhlYWtRNHJqajRFTHRsOWIrSzRuTVhJSnBSSE92RExvNkZuV2NP?=
 =?utf-8?B?b0VCR3Zqd1o4R3FqelBWS01JcnRrdFlFbEQxTTJGSEJ3bFJsUWFydlp6L2hS?=
 =?utf-8?B?U3laY1dJQS9FakFqZjdEY0I0Tkw5SFo3RTZPTEhqVVp0UmZzR1E1UStaMnVj?=
 =?utf-8?B?TE1tbUZTMExSck1sNDd4bWhsRXlpVU1CVlVSTzIwZUJTN3J5TG1BaTlSWC9a?=
 =?utf-8?B?SmxOQ2RxYlgrRWphR3I2MS9qaTVDU1NUbUNhL3RZa1BpaGFEa1lHd2V0clNO?=
 =?utf-8?B?V3l3M2k3OHB1YXBtS0FxRUNGQ1M4UVluWXpScytZem96ZXdKOUFUQytENE1y?=
 =?utf-8?B?RnZPRkY2djlmTVhVY2piRHJYSmxjSkhKclRZSmtYOXYxZUlVdTUvUnpDZ3ZG?=
 =?utf-8?B?YWxBQkppQTREL3VKcnNXelp6dXFzaEsvakREbk00aERmR0ZLeDFaajRYa3RH?=
 =?utf-8?B?OWhrK0wvcnZ2V0ZkeFpxNCtrNFR2aFBNYlo3akhvU2tvZ1QvS3pva1lOL1R0?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6867fb8d-5ef8-42dd-5885-08dc16ffda25
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 01:58:51.4880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMGAK3mvfA5INUvduQzW63pv0qJZjSNgJOm/M5ZV+xe2ADkLhgsy5vzglCUNuW3GmNHLjcBGXLDLFNHrTOC6vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4537
X-OriginatorOrg: intel.com

On 1/17/2024 9:41 AM, Yang, Weijiang wrote:
> On 1/15/2024 5:58 PM, Yuan Yao wrote:
>> On Thu, Dec 21, 2023 at 09:02:35AM -0500, Yang Weijiang wrote:
[...]
>> Looks this leading to MSR_IA32_INT_SSP_TAB not intercepted
>> after below steps:
>>
>> Step 1. User space set cpuid w/  X86_FEATURE_LM, w/  SHSTK.
>> Step 2. User space set cpuid w/o X86_FEATURE_LM, w/o SHSTK.
>>
>> Then MSR_IA32_INT_SSP_TAB won't be intercepted even w/o SHSTK
>> on guest cpuid, will this lead to inconsistency when do
>> rdmsr(MSR_IA32_INT_SSP_TAB) from guest in this scenario ?
> Yes, theoretically it's possible, how about changing it as below?
>
> vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
> 			  MSR_TYPE_RW,
> 			  incpt | !guest_cpuid_has(vcpu, X86_FEATURE_LM));
>
Oops, should be : incpt || !guest_cpuid_has(vcpu, X86_FEATURE_LM)

