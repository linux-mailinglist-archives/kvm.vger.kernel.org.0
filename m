Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54B26E38A3
	for <lists+kvm@lfdr.de>; Sun, 16 Apr 2023 15:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjDPN0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Apr 2023 09:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPN0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Apr 2023 09:26:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746F919A6;
        Sun, 16 Apr 2023 06:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681651566; x=1713187566;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=XUlJRaeB6MHwuZXNMi+OsVLPuUknfLoD5JDtyVfxF14=;
  b=hI4m4XuEk00pIuSKjX8ysn9JR4dKOuZuG8TV7dZp4FA95GCuphNeYSe1
   qjOVHLZydSMXxmPYbWnjpcqLdUWkM1X/okKoRfnR+qJm6mkT00EP+a2uA
   4Wo92U0wd6dRHgSWAx9a5bPk4bsB1WUtyH5w0VXc9be2fJsDuHblbOk+T
   zzGArEptGeVjTiNygpJjPSCuhFof94Xfn5FhdYrcNqVqpjUcSaBfUBaTv
   o2A4Q7Vif8bJatVwaAsOUuDwq3aFJgRfiAudzfgl12JMBYCsMdlUhnI9z
   W5ZZR5CCPov1rP9yFUYLSikpWisuhMcrgfyRT4rRanvNYnJH6kBwXTj1F
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="431024826"
X-IronPort-AV: E=Sophos;i="5.99,202,1677571200"; 
   d="scan'208";a="431024826"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 06:26:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="692980390"
X-IronPort-AV: E=Sophos;i="5.99,202,1677571200"; 
   d="scan'208";a="692980390"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 16 Apr 2023 06:26:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 06:26:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 06:26:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 16 Apr 2023 06:26:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 16 Apr 2023 06:26:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMZ52cSHqPzMkuu/klNOVlIhaMvFqD0E4rxieVowRFDqU5EsC3QxZb97DA1v74KjWM9/A3CZnw8ua1PrtUzMFyPu62GPf7kiRlQ6vVK//DIdXXi2jZPEw8G/coxpu89wr/qoyoQue8Nzn6O0B+fZgohMFVkgLLb0aCdq+E2mRvb7Qu7BDTxM+ZuF8AADG79BegrYiM7wVYp6tCcavspVwwjLaFwibYaz6Q/HLwyol3JbdFJUPJm2BYSP1KassPfsKa/t3ElLbgmtg+J2t8lNmrAT9m2i4fWww07W9HGbdnOjX1QlzyQon6hshg5TdYzLzOMV6jVXV2W8upE4XrChaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ahzXFiYInrskuKIlcRxwdj3RxvErBJBlTepy20p+rM=;
 b=NRorIixs6c/p7qNZWOpiBuErm+0qo3JdvgdPHIWIAJiOCfskZGMx93awN4ei94D242RqV9cjACtCbJdmqw+8+TqC45LzNz4RS6EQY1GLGCef6b39Uv1meJPPDTcidMhib41Kr0SnhONe42iZq1hLdXN0PzpieNg2UJ2sLm1uR0g7uYaNYwFgyernZVdv/6URBc7EdF2KVotZvbLEnMnNtbnN4QKWqaDWSldNTR+hm0ALlf8qp2L8hn5gwHzU2UNblzKwCUlVEikCcIdt/l3WKxgjFQiGo7vFrRzGf6eJ3XYIdUO/yf7yOAQkYkR/tG5dT+KAT9rKSvamhdtBkIz3cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by IA1PR11MB6490.namprd11.prod.outlook.com (2603:10b6:208:3a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Sun, 16 Apr
 2023 13:26:01 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6298.045; Sun, 16 Apr 2023
 13:26:01 +0000
Date:   Sun, 16 Apr 2023 21:25:50 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 02/11] KVM: x86: Advertise CPUID.7.2.EDX and
 RRSBA_CTRL support
Message-ID: <ZDvDAlc/TOrIjvlS@chao-env>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-3-chao.gao@intel.com>
 <2ff6d934-bd9c-227b-9693-911a85145da7@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ff6d934-bd9c-227b-9693-911a85145da7@linux.intel.com>
X-ClientProxiedBy: SGBP274CA0014.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::26)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|IA1PR11MB6490:EE_
X-MS-Office365-Filtering-Correlation-Id: 5226a1eb-45af-4880-1444-08db3e7e1ef1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EF/BaF7Xl9DsSuHhguDXk3DM2NJ5IWSHmsW2LQWBJvrdIRp9IoydHqcwBdn1NWtoELoveRrdHIDUO73RjeaiCCM7HQKwoFD2x+ZdcCbuW3uWzq9VEqBj+gSCN5mnhUulDT9K9xY2CNHQwYZieA5NRlEv5KR8Qe8ZX2k6czrbK+kr4G5CKWHY/urdJO5oblkzOXHGzAxExMd7aPYdkAcAqkwqZukkxuyd4TtQoF+6yLsM7GFZPq8R+YkaGWMcYuz5GIAnIwlJE9y/haQJuZ1K6LtShxm9okaYfv/TPRpqR3U7K5Vld30QzgOgi5xCe+WgV1EVf1SFQHDwr+zABFQEFK2bl7wZIkSgTBO+Is8oL4HL9d9kG/yBHcp/o/h4/KnYi4oE/pIg9HMp4Jaqr+w/nEHr8DHjDNTn964LIcuHRGlwwRh6WZGt0vgFK4C/FMjIFOto6r8TSQQLMOchTnJw6CyZ6u5bRUTqxlu/cOwczg9KfXpxZiiWZFszwgli8VjCvXy7mAqPUBEzb/mCOxibftbJz1FEWlPPvXC0+PPxUCcuAuIGdJLTr5VhydLrg1YN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199021)(316002)(54906003)(186003)(6506007)(6666004)(478600001)(6486002)(82960400001)(41300700001)(4326008)(83380400001)(6916009)(66476007)(66556008)(66946007)(9686003)(6512007)(26005)(7416002)(44832011)(8936002)(38100700002)(2906002)(5660300002)(8676002)(86362001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?q2+voTK82iiL3PpZGSdfzFt9MK02ZufiE4/daRVEtLmWSSRbin0vjjcQlw?=
 =?iso-8859-1?Q?Tq7RpNaEYw2RLBe/883LJnmRRgfHz5QiRuxgDWyI0Jy4OMCYQDQ5ZAOXoS?=
 =?iso-8859-1?Q?h5T6vlUtBl6M289/lR72utp5pl3PxZ+ZeEvMbX+TllxpfK4NjC7ZoR9UCV?=
 =?iso-8859-1?Q?eyt4F+zlfE4u8n+6CM2uCqcTUxJ7SSAEtnpLDAtQXiA+ZuS3jQaDSQtSfY?=
 =?iso-8859-1?Q?qHTJeNzTg5U8f3rS3bFGYewapQEnapxW6Vy7E3s7W0t8WGlhN/BtU4aEJq?=
 =?iso-8859-1?Q?U54rpoa7aJArrGNrU5SzhNvLWb4RBNuy6gCD+pmJ7y0lAHm0YDqnMlNQ/u?=
 =?iso-8859-1?Q?DdU72uRpo9gS+W+fDgLcGieddfFFqfV+GugrqnPMLTxVRpOd23Z03otTKX?=
 =?iso-8859-1?Q?kLtnUm8/loY3uBDimAEPume10ymI3TaBdtbubjazGcDNu5EKfANUcRdPZg?=
 =?iso-8859-1?Q?YgN87OfG7yvoax5O5i2XWeJrZhS5E9fvOVwCLEO8o8qg5YRg7mXJJE29+3?=
 =?iso-8859-1?Q?2snz7osBDerI2wOdHJhSAlP/1mnfMGVQDqc7w4EokhLDsGKDIp8TfbrAeV?=
 =?iso-8859-1?Q?kidC63+vGkYAzOi31FJWln7PoEhA3X03K81ftoq0PLnw1YdpAb+hCViekf?=
 =?iso-8859-1?Q?LuZBNB4/1cTwgIJs9P1LV9wLm/5oO/OCj99pz8R8NfmuNluIhDilAAm0zq?=
 =?iso-8859-1?Q?c3rmhBdEP1rHz8l/CRgfkuzQfcYf+0vv3IVDYmw/+qOagF3E2Ii7bZ2Gwu?=
 =?iso-8859-1?Q?dlsquCBwwgVwMs4+Do7BgpjHCRSX232qK6eSUiT1/p5Odr2eXNrJrH5rTS?=
 =?iso-8859-1?Q?NEKpXqcDDZZG7YS6ov4EhcKlOrr3TmtGAmswuwQ8PNKnEQw9WEHS2/EtOz?=
 =?iso-8859-1?Q?bQUQyADebcn/d7McRJax5J3hUQHhhqH3WoXs7nCUkj8T6CIvrXBUjmHYKU?=
 =?iso-8859-1?Q?xR3sClYRwAGsz31WREQQpjnGZudORZsgGuOD0vf45ueq79bHsVKXs089qF?=
 =?iso-8859-1?Q?g8/Mz3gH4vFGLFOiDId0OWGECRidrNwPySflWi7PArfhXQtMq5202LTpkx?=
 =?iso-8859-1?Q?Ujn2wPnKyGZlXpYb9LFXA++DrRrdtMMqGDhKwGfn7W/NMNeFifAYgW77Bl?=
 =?iso-8859-1?Q?TD+1sGzrML9buLDKVlTblytXXMGIIo/Gn2eGEpzpZOiEjts7rqCF8VebV3?=
 =?iso-8859-1?Q?3r3q9Sk6KSbQsRSJ1Jbbe06FvG15CyYEvMDWrNS/ofkY1oVQDjG66XxtoI?=
 =?iso-8859-1?Q?iThEa0CcMPs7DG2DzqIhjkKMO0bIwv9MlJC3ktrTk3/scX3yIZcXp6+iN6?=
 =?iso-8859-1?Q?I6Kc6W37NHouQbcqTKCX+IcvE/sxljzrmAB850HdRIW3N6dRU1a+tZkbKh?=
 =?iso-8859-1?Q?HaDrPmoc13CDxpRTcJTDTtK83Z+7vZFqUCh4fxIj3isVY7i39oIGXI93E1?=
 =?iso-8859-1?Q?vqC2uOHoeZG7M4hOg7WUYUdUlq24yc064hcJfOBfWbzkEjauaGJn0PCO9Y?=
 =?iso-8859-1?Q?1nqKR1XN2rXdi53XXCH7JH+5LDPTVocew+TAQN+9gCM6n59KULyNd5MxHd?=
 =?iso-8859-1?Q?0aWovzuYhHhz85+SXBKh1DvoPJLuRz6aRZjML5t6jfXlppWtCapiblJTis?=
 =?iso-8859-1?Q?yZXB0rhQ6wM2Z/KmmRUwDu4zuVAISNsaE3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5226a1eb-45af-4880-1444-08db3e7e1ef1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2023 13:26:01.3842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dagIl1syzNNI8ckNAmiPYQIuVTMREAuYYUko5NNS2htNnL7D9BQGIQux0TyZtY1+2wxHapYVL6Oh38OWCpMKMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6490
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 16, 2023 at 03:04:59PM +0800, Binbin Wu wrote:
>
>On 4/14/2023 2:25 PM, Chao Gao wrote:
>> From: Zhang Chen <chen.zhang@intel.com>
>> 
>> Add a kvm-only CPUID feature leaf for CPUID.7.2.EDX and RRSBA_CTRL
>> as the first feature in the leaf.
>> 
>> RRSBA_CTRL is enumerated by CPUID.7.2.EDX[2]. If supported, RRSBA_DIS_U
>> (bit 5) and RRSBA_DIS_S (bit 6) of IA32_SPEC_CTRL MSR can be used to
>> disable RRSBA behavior for CPL3 and CPL0/1/2 respectively.
>> 
>> Note that KVM does not intercept guests' IA32_SPEC_CTRL MSR accesses
>> after a non-zero is written to the MSR. Therefore, guests can already
>> toggle the two bits if the host supports RRSBA_CTRL, and no extra code
>> is needed to allow guests to toggle the two bits.
>> 
>> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c         | 22 +++++++++++++++++++---
>>   arch/x86/kvm/reverse_cpuid.h |  7 +++++++
>>   2 files changed, 26 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 9583a110cf5f..f024c3ac2203 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -685,6 +685,10 @@ void kvm_set_cpu_caps(void)
>>   		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
>>   	);
>> +	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
>> +		SF(RRSBA_CTRL)
>> +	);
>> +
>
>Is it slightly better to put the new added one after
>
>    kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX, ...
>
>to make it in order?

Yes. Will do.
