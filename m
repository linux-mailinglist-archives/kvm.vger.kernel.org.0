Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240A57BEFE4
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 02:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379245AbjJJAto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 20:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379232AbjJJAtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 20:49:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B500A7;
        Mon,  9 Oct 2023 17:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696898981; x=1728434981;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WzpqpSrfP29QNaFz/VFme3xldoA+PWXZ8r3N2cfgxNI=;
  b=cKGzhCRk84ABaLEEOlEPS8VUkpA/OYoZvIXFgipTTE4qnDS4WKYRb7In
   ipH9tyTZBnnufEpHr/oI7Fh7Fkcvb00nZrjvIfd4kWDPSP3Bk73TFHXny
   mKOK78CYNzRs4Y6t+dcLDqL9z7RZi4NVOEvwy3pO+Vjynwzz+KFFVqQXQ
   g8Vswr9WuGDxc5/8oxygedW8AWQmcIn6kkE0EmBEEXN4dZSl1XfNWbGbp
   2uMcSCRXTsnUMzIYR17zrzEaX+sewIn1WllUKYnNYvWeyPHg+Up6mp5la
   Z/EZE6610dQGq44u+YRzKvcwgx1ifz6CrUtGrsMVTukB5sw3dL7ajUHXq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="364574270"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="364574270"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 17:49:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="819023480"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="819023480"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Oct 2023 17:49:36 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 9 Oct 2023 17:49:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 9 Oct 2023 17:49:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 9 Oct 2023 17:49:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 9 Oct 2023 17:49:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VT6toxsYNn1gzN+sSffvBxkSYqDyqF5X9yRjNcuWyQnzSdeRF1wiv0cLgs8MJO8Hq3FlsfPUPbApU1ZDtHZkAEA1tmh0lEdDfuLPGakR2ZiZSsTamBT00ZrRpz27UHQZXwqwxj7MD4RO0K3nTt1TM/Y7nMpPBuF6cy5M9tbEjZTaNTCn//k4lsJeYKYhOnU5qW3sZcH9n7wq+LEMduxlfU9OVjYugJJ/bFiKnLVUQz9aSYWt7PvxES0hw6g0Jt2dpWu82ME5+GFunJwXlEThoA+ggjwChJQ6YgtFfaVQNISUdk5FVYIxbHQTfzd5s5noYc0fgabShZW/pvzW8NIuxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOWrpn/7CuRx5L851DkESxhZitGjONrz5NSlK+kDkN0=;
 b=BPWK9iL8BUA/I6MjJY8BptxvwY3cuLRpT6smbgmbfGpxCOWJ+qI0K3f6kPW3TNc/jl6JL2ckP9i9xUQ/nVv9vG+srh45X06yV6aoVNTzNX4qQnKu+z90j48ebFEva8YsYi77TyPbUSstkRAtHIW+DDhoxwqjuaD9Y8jdcy73Tm2gz/lldxVwC06B6FzkkKojJQlGU4juTXflXbtizcm4YbKNOWDdyvjNRD6FNJgkmJNAvofgDRI3j6yvRn+txutdF0SfNHsHikctH4GX+OJYdoe7Iva5Iu1J+e4jrEphamd/PHiRNUYTZ531E8tv1r9AdAI5USJclqthJidU6nZEMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB6145.namprd11.prod.outlook.com (2603:10b6:208:3ef::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Tue, 10 Oct
 2023 00:49:27 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6838.040; Tue, 10 Oct 2023
 00:49:27 +0000
Message-ID: <880fca81-8109-c171-add0-63b90c289bec@intel.com>
Date:   Tue, 10 Oct 2023 08:49:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 12/25] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
        <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-13-weijiang.yang@intel.com>
 <ZSJEKcNMwBuO6TW3@chao-email>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZSJEKcNMwBuO6TW3@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d19b35c-2803-4c0f-66b5-08dbc92ac103
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wJvGhv4Vr+qB3dfLtgWp36XozScBuwHf5t5IAamBp4peX0sRoU6aKEZtGQtfAXsZQc0StinI4EZJMA+UQXBk18UJdbJcqsukIwCAXUYaWsXICTTusoN8dv9qH4Sqx1b2RXv2pGMUPP80eukHyX3jd8BCzHgB0iIlUA05BKfcWk98VGGh/ecA9/n8cJeJsqs/q5/TyChSanTGqV6sPmWJzThzb7D79U6RJa7NOcEdeEOrx8JdpJY4oSPm6tWBeOF7ZxXPGNVUacoB0v35nbmFUeQfqgjtsX4navkVCIHmy/q+umFqFOfUbIN0yDKmT3OzzxKB3pkGbbSwJnoQhj1pez0jbxo67H5gqCP5hrqZNxxihDCPZoNUuy9zRzsVAEAr0wEFbASEQNlLJqvi0LohAao6bYvO+PiiJIEUwjB7+CSLF7V2gbDCSQ8VSJ7zV0vBvygdwzdkP/WWs0hi1CCv5tMxI4A832DN3+40ZltXn3h+LdpJUpZgIKXrRm59pGNDvy7VV/E4fczBRXZjYcqLLhff6pb+NCfgU5orY2pCeBvlKYzTUgd5KK0ipoeivQiA/j8CtFJrIaa1kLUvM89irXPff/+tDok6gzOYh1Qh8YMIDu6Z5/ngn0sYQUNJIONXHPlKCzoLch9cA8CDDomPjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(346002)(396003)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(6512007)(53546011)(2616005)(6506007)(478600001)(41300700001)(316002)(83380400001)(6486002)(2906002)(66476007)(66556008)(66946007)(5660300002)(37006003)(6636002)(4326008)(8676002)(6862004)(8936002)(26005)(31696002)(82960400001)(38100700002)(36756003)(86362001)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2EvWlNEKy9VWmhOMGZRVWRjeE5FZmFsUUR4ZTdvQ1VSRUM3L2E3SGxXM2ZX?=
 =?utf-8?B?NVl0bThodDFFc2JSckZIM2REdWF0TTVydnpRNmtOTFQxVUZsRU9waXE0TDF1?=
 =?utf-8?B?VEdZaFUvNTZ0MVNhWXFOUVRybGhVWVY0WFg1Q1dMYWJzY21YUFJMZzJ0WnIv?=
 =?utf-8?B?eStCbHBQNzJpM3VoNUVTdE5hVVQvMit4eWpTZUJQaWRCYXpFWjY2OC9ic2Nz?=
 =?utf-8?B?VjloM2UreU84VEQ2a2NhRXZtTFl5V1dPOXhJeGsvMDI4cTJOWkErQ3JheG1y?=
 =?utf-8?B?cFptaDZsSXZJYktJYWlseW10cWREcFlRbEtSbGJTYkloUHVKeXVaOCtSMmxO?=
 =?utf-8?B?Vis1M3pPWlNIVERmZHF5QnpIUkp5Ujh5eFZNNytvR1ZEa055NzE4RGZSQ1R3?=
 =?utf-8?B?Mm8wa240d1BCM3QxckozZGtpd0JRMFErdHpIQlVxRU4yOUhNOFJNUTI1NVox?=
 =?utf-8?B?WE5rQkpVcUtVZE5SUlh4eWU1MjgxV0NwU2VwUkh6R2dhK05IR21yYkZ5WnFQ?=
 =?utf-8?B?MHE1L3A4aFNZVnlXRTR5RjlpbmR5MVlTdUNFVkw1ZWJqZEUvajlOKy9ydDgx?=
 =?utf-8?B?OWJKeTh4WXdZb0daT3hHVldvQlU2WGQrbi9hM3E1WVJLa3psRkRybUx5c1Jk?=
 =?utf-8?B?bExIMUtxcWlvNXJUMktiL2ZkQTBLUjFraGRCMHhnbXV6WFMxdGR5eUJ6ZUJv?=
 =?utf-8?B?dXV5RytmOTVtSkNwV3d2RGpJakV2TnpnU1JoR1YzRTNKeVRwYVRTVm13WEpZ?=
 =?utf-8?B?eWxGempzZ2NCMGRUTXVBV3Z1dFZRbUN5UXdDWkVpUXFFVzNnUElVazNzRnEv?=
 =?utf-8?B?bGp1S0VkcUJZL3lwZEcxa2k1bXBPdGpPNHVEY3I5VXJqRlJMSzZyM0VUZjV6?=
 =?utf-8?B?cmhxZHh2dDRTT1Y2N1FESEFaNG1QNWRKZUtqWStpaHpra1czK1V5cXNvbVJx?=
 =?utf-8?B?YVp4VDFUM3YzcHdwcWpxQ082cVNDMkNNdzBQMUwrUDlnNmhyZVgyUitrRXF4?=
 =?utf-8?B?WWhZRW1BNys1UzRJa2hqQk1hUEtZSytGSWNBSXhsaVZ0c0hGaFBqRS92VzZw?=
 =?utf-8?B?Q1l4WFBCd09kRzdlVTc4NGZtMk1aL2FyUFk5T0k0MDRERldHSDdjL3BEcDBt?=
 =?utf-8?B?cjJCL1oyOGxwT05xeHJCODZLSzkxTENlSExONkY3aWVvN1pSeHY1bmEzN1VO?=
 =?utf-8?B?aUJ6UHp5WWRZTUtMem55SFc0WFZIT2JnNzBZVWtFWVFSVlQwd2RLeHlMbDdL?=
 =?utf-8?B?VzdaZHhaN2xXN2JsMWpFSTNZcmRTdjZabk1VeTE0M3RzZGE2cWhuV1B0RVh6?=
 =?utf-8?B?eG1zTlpMVGR4UkJoRXYvbjd1UWVnZStWZEoyNUx2MVBnWVZ1VmpBVlJtanJS?=
 =?utf-8?B?VTh6Q3B6VmpQZkpRUTZHeVl3WlNwOUF3Yzl0ZVl5cnZ1dk4xaWYraW04TUtu?=
 =?utf-8?B?KzZySmkxbHQ0Nmh6TURRQldMZjI1aVlwK2FiajQyTUk5NjgrWWcycGltYXgx?=
 =?utf-8?B?OWpCZHArSmVnOStKU0pwOXg2R1Zhc3FqV0lJZ2VHWWk5UDRFWXUrT0F1ajFa?=
 =?utf-8?B?aW53U2dwb05NK0pkUExONzFRV1VVUXJTQkdGRldaQWNDREFQK1B4N1VPVDhW?=
 =?utf-8?B?SVhmd0g3eWRFV0owV1VVNWM4eDFjd0dBVGlOU3Zrc3VYcStkU2RReGcwOEpy?=
 =?utf-8?B?cDFpZDJOZytTdGs4cVRocEI4eGVSVmJJVWhaR3dxY2FVTVVMdTZpYS9yeHVx?=
 =?utf-8?B?YVBINjN5T2h3QUd0K3pJUFhQVEREY0VPU04yVHJYQkpRVXUzZkNiK1JkQVlz?=
 =?utf-8?B?TEl5d1BpNEFRZkNSbUxSb0hOQzFhcDliMElFOFVvTnJoR2lEOGJqQzlVaERR?=
 =?utf-8?B?NGNiWFE5LzMzT0UzcXQrM1RYTlZvNGdkV0Y4V1FFMHc4bTNWcGhuY1B4eTd1?=
 =?utf-8?B?RzdSQ0t6amYvbkkyYnp1ZmFBcmVkb1VsU0NicHpaM3pPOVVLSWJNN09rSm1E?=
 =?utf-8?B?WGdsTVdmRlhVbWwxMFhzeUk1aThxRndKYXkzbFE3NDlzeWVUSzdaNDM1dlFX?=
 =?utf-8?B?ZmNSS2dKTjlQdUU0a2xOb3pzOEo5bHU2NXpRVGdDMGJBd2dHT0t1MGF4WnEz?=
 =?utf-8?B?a1RUY0VDUzNiS3J1RWZyUGhWOXEzNlBrU0RueENpZHUyVHllbTdZVEVyZGJU?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d19b35c-2803-4c0f-66b5-08dbc92ac103
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 00:49:27.0772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oPAgtWHtK/9tZa0YOxnMcpUPgCpxXM3W89E04Kq/sxelNLjGgl5gbzPg3xaKo8LMwIcYjghC5SEWs+mq23O+bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6145
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/2023 1:54 PM, Chao Gao wrote:
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 0fc5e6312e93..d77b030e996c 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -803,6 +803,7 @@ struct kvm_vcpu_arch {
>>
>> 	u64 xcr0;
>> 	u64 guest_supported_xcr0;
>> +	u64 guest_supported_xss;
> This structure has the ia32_xss field. how about moving it here for symmetry?

OK, will do it, thanks!

>> 	struct kvm_pio_request pio;
>> 	void *pio_data;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 1f206caec559..4e7a820cba62 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -275,7 +275,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>> 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>> 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>> 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>> +		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
>> +						 vcpu->arch.ia32_xss, true);
>>
>> 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>> 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>> @@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
>> 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>> }
>>
>> +static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_cpuid_entry2 *best;
>> +
>> +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
>> +	if (!best)
>> +		return 0;
>> +
>> +	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
>> +}
>> +
>> static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
>> {
>> 	struct kvm_cpuid_entry2 *entry;
>> @@ -358,6 +370,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>> 	}
>>
>> 	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
>> +	vcpu->arch.guest_supported_xss = vcpu_get_supported_xss(vcpu);
>>
>> 	/*
>> 	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 1258d1d6dd52..9a616d84bd39 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3795,20 +3795,25 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> 			vcpu->arch.ia32_tsc_adjust_msr += adj;
>> 		}
>> 		break;
>> -	case MSR_IA32_XSS:
>> -		if (!msr_info->host_initiated &&
>> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>> +	case MSR_IA32_XSS: {
>> +		bool host_msr_reset = msr_info->host_initiated && data == 0;
>> +
>> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
>> +		    (!host_msr_reset || !msr_info->host_initiated))
> !msr_info->host_initiated can be dropped here.

Yes, it's not necessary, will remove it, thanks!

