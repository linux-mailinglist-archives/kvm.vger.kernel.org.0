Return-Path: <kvm+bounces-6154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8FF882C51F
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 18:59:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEBC81C21E73
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 17:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD9B17C9C;
	Fri, 12 Jan 2024 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="caTFgGnB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DF117C81;
	Fri, 12 Jan 2024 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705082335; x=1736618335;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g9Xw4w8McrjWofSCPsOIGhe6XfbS/rMQTnIbjTPfqdE=;
  b=caTFgGnBRf0tbu08yNxH9xBQ2Kapg/Fi/jy3kPVVBvLjCS/pCoAYPvxC
   ovR7qiwA7SV80qpc0um/A9KAF0CSTduPS8/Jrotl6dK2FPbtDgTb6LgIn
   k6dYNNmsaXuqnWpUKneKbOf+isTtRr/ciD0JIxwC6934cilh33pT6LIrr
   PTvMSP1wCSA32jUmizwJCpxLMWIWdGIokq+wvv4ISWLC+Vg84ZV9zX+R5
   vZpl6vo5y8gV1LdIYDtdq7vzVH2EgvSeXT8ubQFAqE0l41pFT353N/0gu
   DwM07zCJ5SmbB92unqxVEIEUD7MaDusL9RowxYMgK6m2acXhoAW3SepV7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10951"; a="17845096"
X-IronPort-AV: E=Sophos;i="6.04,190,1695711600"; 
   d="scan'208";a="17845096"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2024 09:58:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10951"; a="783112023"
X-IronPort-AV: E=Sophos;i="6.04,190,1695711600"; 
   d="scan'208";a="783112023"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jan 2024 09:58:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Jan 2024 09:58:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Jan 2024 09:58:49 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Jan 2024 09:58:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gf3nk3+qNRTDR7XxSQxy9QluQL1kgSfHyu8QTR33JQLC+EhjufhjF07FQmI33qmKMcZcoVlzaryr30GihU+8+e1Q4u4UvkosW0+1XMCURrGq+xEgLtdz5pEytkWEguS36wDcDQYhDu1PDJcnq12iYyptYuxehTau5hzniUEllpFhsO7UcDwqMd+/0e0B4HF1xD2Uh0zMXIun3ch0XdGRcwpSUQJ2sl+QrMlkjkg4ahYoPjVNmOAdeDjF3/ZE/AECtj5zojDvQFl+FmsPmIsUNFDFR6QffAtU/tOIP2OYzpPsSU/iL/LkbsXuuQHxexVIHwNULN1pNSoEpqqLBJlDeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9Xw4w8McrjWofSCPsOIGhe6XfbS/rMQTnIbjTPfqdE=;
 b=Xrl1f0FqAVeYAoT7hRBiMZXhzBTTIS7OTjgUJLCgARan1rA6pJk91s/ThYQxOhQ5fD1iPYAUMGWm8HSP26PutMaQIZb8hZJuY9UtvnIL/4SmJYe4BrN84rC7faF4QUeFXVD5COm4zAIZw17S3JfXBn2rX07DZLtiXf6V2Q3ENmbNB3NIyR1oXUjioIzdgAUu18nsRJUEcrqBdRVi+K0mT2wgrWxwIDsJ5boyOgYOjHrbJlg5SMrtBj1j43bsO5JIVvZPXKX5jS3ghRdVfE5aE5ijyAlpho0roksDSmWzXCn1eSnA7pbIstNX/WA5tWgrXesmJqQ/2eBCj1qyxf+Tcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by PH7PR11MB5795.namprd11.prod.outlook.com (2603:10b6:510:132::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Fri, 12 Jan
 2024 17:58:47 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1%7]) with mapi id 15.20.7181.018; Fri, 12 Jan 2024
 17:58:47 +0000
Message-ID: <3fdd1acd-8c8b-4381-aca4-def1a032737c@intel.com>
Date: Fri, 12 Jan 2024 18:58:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] KVM: nVMX: Fix handling triple fault on RSM
 instruction
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<zhi.a.wang@intel.com>, <artem.bityutskiy@linux.intel.com>,
	<yuan.yao@intel.com>, Zheyu Ma <zheyuma97@gmail.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
References: <20231222164543.918037-1-michal.wilczynski@intel.com>
 <ZZRqptOaukCb7rO_@google.com>
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <ZZRqptOaukCb7rO_@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::11) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|PH7PR11MB5795:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d78e682-1f5f-4089-3bee-08dc13981f7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ub8hVUsD8tSNFUivz8J3OntmxH9kzbW7dRkp8NcN5Cs8gGWA/cvvbPRlJSHwsAP/4l454g2p6h75ZwrTRmnxgBt8SYtIk9ND+lNxvYdsqjs5AlWivhHvLC7EeYP5YkNm7iy6dNGUP7VHUROGnEFHXQfDu045/r5eH2oikyD6ucwadYG3Hht+thZI4FhB6RJFOhz1kWFAJClHsh8+mwnSOAzJJMkNxGXo9N0FJQXCFXA4js7Dy7+Wh0RQnZJd3GV6DuSbX3XMkccrvQz88S2eKreg8vdmQNqlfM5gl0r4rHCIalj41QfDU9bQN043+rXmiJb5HaphY2CknCOfaJw8AR8x6e3uh59pRHH4JD9wM/WzGTaS3y+beNw+2J7UPTH8xDr5NPnQCXUQUIgZcrzM0CZXGjej2HxDgn2+gPEv96PGAnCxh4XwUFY8PaZ6kDT210+2xzUvApzzvnYwSYWFzAHSdK6820d9V91jPX/s+89r6ursCg4Udsf6Nx5yU2YCDOhazNCz3dfc9ufuTnxtpgKLluAy9UDwAEAQcF8ffqTF/1LPqxXa+Vtei52OiXtfEfqnktyfhlerfGuskGtRYi/qubT3GHlRsehP9vJXayW1Fk6vnMaAESEEliUq4DeVbEM82l9xVhZLMzF4YyJm3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(376002)(346002)(136003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(31686004)(83380400001)(86362001)(36756003)(82960400001)(31696002)(41300700001)(66946007)(6666004)(38100700002)(66556008)(66476007)(26005)(2616005)(53546011)(6506007)(6512007)(6486002)(478600001)(54906003)(6916009)(316002)(2906002)(8936002)(4744005)(4326008)(8676002)(7416002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFRQWXNsZk1pazZUSTRJYnhEcjJtV2c0bUdxQmdiMXdxYVJNRHNZeGxVcmlX?=
 =?utf-8?B?anh2OHZFa3gvdFBjc04xVCtMRlpwWDVQSEdFa1ErQUMzVEo4eGNDdDNqNWUv?=
 =?utf-8?B?OEV3MjRWbW8xU3UrQTRlQlFEM25iTFRaV3ROay82RStTNEZwN2JlTjJCbWNR?=
 =?utf-8?B?eGs2b21sNW1mNWJxbU9ZM2hSei9abEJhSHp4Vm16amgzT09aUzdZTlJtVE9U?=
 =?utf-8?B?MVJMaytXQkdZTnVHTk1lek9DOXNuZFhHMUJocU5EMUMvUjVkTTI0QTIrQ08r?=
 =?utf-8?B?SldIdjRXQ1RUQ0VQcDEvYnpWaE56U0JDVHUweUlvTlVyWTB0c1FzY09vOHBn?=
 =?utf-8?B?V3BQUEJvVEI2UkVtZ2xUVkh5OXEybU5iRUhVWmdhYUxIb05sU2Y1ZGs3cTEv?=
 =?utf-8?B?NXU3UG9vaEEwblB5aFBSS0VwMGxXZmYvd01RNFdJZUVLWmd6WVpGQmVZNTM0?=
 =?utf-8?B?MGdvNTdKclR2RHNFY0liM0FMaDhwMDNCMjljRysrdk5ENGF2QnF2SitKcDFN?=
 =?utf-8?B?TjQ3dkRsZzdPNVlmMnhoOFBlVkg0WStUSEtOWm1RWGIyWmNtQmxvSnFCOEYr?=
 =?utf-8?B?b0psRk9DZU5mL3FoWVB2TWxzSXZkd3pTUXAraVIwdlNXQVFiM3oyRTA2K2lr?=
 =?utf-8?B?NUVZYm0rTUVQUGFmQVFQWWN3aEFZeVZwOUZjbU9IczlzbTl5WWZQYmJnNGxz?=
 =?utf-8?B?MlZyYi9ON3haWDFXd1VnOGtJYjBmOHpyZVY0dTJSaVhlVUN3YzdMWHV1TzZZ?=
 =?utf-8?B?N0RFOVJrM0M2Ums3MlpUUmRxRzh1TC9JNndnTnc2VDVEVmxKK2U4NnRBK09D?=
 =?utf-8?B?R29PMklBcXlpbVZoUi94VlNOc1lkUnBYbUxxNlIwV0F5d3RGckFvTjJ6ZStj?=
 =?utf-8?B?a3RCZ2owV2VGaERld2dtZ280TzE5cEJVMWtxZ0V1MmxFMWIxQUcyQy9qWVAz?=
 =?utf-8?B?eVNSK0NSRHk4bUNtWjRRcENxTXNPdnYzdW9YZ0liMytxeEJOSU9VNEE4aG45?=
 =?utf-8?B?aTZFZElRL2dnTUFaR3pCWUgrenppU0hhZ2pPWUVPbm8vVG5ESjROMXVTY2Np?=
 =?utf-8?B?ZEIyV0REWFBCWDd2YStrdWdvMzZiWjRWYzRpY3NOUkYvZ3FmTGZGb2pwZmtD?=
 =?utf-8?B?cTNVWUJlUFNRektnUGJFVm9CTUk5Qm4yMlhlOFY0SnhqdThrSTU1S0Y2L0xN?=
 =?utf-8?B?OS9ueC8xVWVka2p2ZVJyTDM2emlsT0NoaHVlcWErOFFFS0g0R3FOV3YxaHpU?=
 =?utf-8?B?ZXJwQkUwQmFzUDlvdE5KaUw4a0lla2crMW5UTlRXVFIwQXlJcUNzTHovc1Ix?=
 =?utf-8?B?WERPOE81TXN2eHJWWW9hQXRiOHA5WXhUY2pVRFQxZzZaMzVpOVNPcDUyZ3Bs?=
 =?utf-8?B?dVdzbUVZNlVVN3dvYTRwTVJxZG53Q0FlVnBMTGZVTEJTZU9KK0tBb0Fqa2JF?=
 =?utf-8?B?WHlnOVBCK3p1aXhVd2pLeExHOXVnMmdPUlJsNGJJM21YVGtmQ3p0dEQvZ1FZ?=
 =?utf-8?B?K0JMTE11a1F1MFp0bDlsSDFHbDFkamkyMW52MEZTTUxPaVdWZW5Da2N1SVhU?=
 =?utf-8?B?eDkvTjUxR0VVcGJ1aStvU3U2dDJGMGw0ZG5hNnU3NklLUFhoTjcwNnUzU0Jy?=
 =?utf-8?B?aFpmV2VhQjV1aForTy9mK1h0RldqalU4cWxyQkxjSXlldW5jZEZJUE1vRkdE?=
 =?utf-8?B?bmZsSjV2OTZjT2Rucm9DT1l4eSs2ZWpQM2h5VHpYTm5VcEhESlNUdmdCanVo?=
 =?utf-8?B?TzBhR1ZwRjh2N01kcDNiY0dOOVg1VVFFR091Mng2NEVOYytLUHlFamhVTWZN?=
 =?utf-8?B?U3JhUWNCSnY5eDRLVXp1YmJlZjVwVlpCYmlMYzFrandKWGxsTkR5b25OYjRv?=
 =?utf-8?B?OU5tSVE5QmtlanpTRDRETnFaL09PNTc4V1ZaWWFiRzhrZm9HSW5QM25Mc2Zh?=
 =?utf-8?B?WWJpTW1KaHZMNkoxbm01Q0xWYVo0Z3ozc1ozMWZSQ2U2MmNNR3dFMjZZUzl6?=
 =?utf-8?B?U2VnUkVvOXZyT1k4bWY1elRsMlBoVWdGZDhBRE91UDVWcWRrOTBlSkxscXh5?=
 =?utf-8?B?b0N4eEd2KytrbWZkTnMvRktQZ2R5RHcxMzIvcGJSZjFTQ0NpTFh3b3ZVbHpG?=
 =?utf-8?B?dmJxZmR4RUF2ck5XNE0wNkxCbUJaSzNqcE5UcUg1YktrUHU4Zk9PSWFiQTU0?=
 =?utf-8?B?QlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d78e682-1f5f-4089-3bee-08dc13981f7b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2024 17:58:46.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVfSEEeOz9xYVD6eMxacfLtwEVRr2GI2/m8lGfJEXvaJv9ZelIl10/hWfNycmwlP9jXn65TB/0GxHuYKTZwk45QNsqUKzxCtmSTvo4OxiYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5795
X-OriginatorOrg: intel.com



On 1/2/2024 8:57 PM, Sean Christopherson wrote:
> +Maxim

> Anyways, before we do anything, I'd like to get Maxim's input on what exactly was
> addressed by 759cbd59674a.

I think enough time has passed, and it's safe to say that this e-mail
got lost somewhere in Maxim inbox. I think I'll go ahead and post next
revision of this patch next week.

Thanks,
Michał

