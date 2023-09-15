Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D177A13DE
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 04:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjIOCdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 22:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbjIOCdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 22:33:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAF7268E;
        Thu, 14 Sep 2023 19:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694745186; x=1726281186;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sumyuu+0PRmnzgxSzwgXlYPmV5OZyO4F4pD4zzRO/OA=;
  b=m9POo8Nr5FSUKCh+/KF6NPI1JsXQxL+yvmHEniNhqfy0t98DoJAOQMig
   A4Hi8qJJIBay5IB4xf7wcWm2NDtdGYPQTDW4QUejaqY1ThVyid6PjlhJx
   ympimCar1WlRMvnn+Pdk5L01FcliLbcngkcL9/MeZinePrRgvCadTU1vt
   1u+hlei1kys0dyDh6CD90v3O/HV2yic1QDKviSoVKHySQePXlQFu2/YlB
   W8V0UbZDZYKVxWChK6i6LDE6PXlYFa5FnKUygUvYiTyHU77D3yMMPjXs/
   wMPs4Cb0S4N/9y5kZF1KmaoYkewaM5sOPDCM4Tx3JT/djK2ee6rTM0DLn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="382960930"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="382960930"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 19:33:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="810346466"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="810346466"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 19:33:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 19:33:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 19:33:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 19:33:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 19:33:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lA+nl7fsNXaHiEI8L90w1EZ42CZ2FNXftsMm3+qBUW/29ziH1prF39MCokxDfCuHX2psVeeH5T+JD08MHpJgn3Rgl9CmrRPoHobtvEgB7e0FYWpruYwcLYMiGEApbakJRq8rz874fYUTTclm/vJViiAQ6NFPS2wwsVuA/jAvEOPGT3n/AqRYHoW1IMf5LuAvQYhZxA+xK6M8arN0j6X0TrCLzrIKXqt9uF7/Pfe81Topvi/2/oUsueuE1z0ehPehiMB7kkoIg29EnlEJHI1ypT7VxTaNYzRs5NcbNp5ybSTDJECLe6dY+XhFI1brtSAqmJ5MWeQo6V7dF3LlSB5Oyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sumyuu+0PRmnzgxSzwgXlYPmV5OZyO4F4pD4zzRO/OA=;
 b=AGVIjz+/NjRjj/qwN5d72k8Kkl9+LTUNJA6pANsVvmOzyZb4OGcVIvpQAF/98Mf7VOyvy1/fra6/r+mHDCVPXppZc17CI96dW5ofUCzXrNv5bn+6Qyr3p84HUjafUJ4z/hrhnnlnMTPoChLgBiwCxZ8dl9fJXH1JLw2/JCWrNt6CeNwi/zeGqsm1kXm9Ac9bUbWv7hS5GpB6NV/KMJU4wEpjZMzT1p9EzJac3aPeo4V4eF4WvCf6+025ooWXOe78MzthXSpa8asLGMJN3XaKttINUpxICHhaaLzM1ndQrjvPz6N0FnpM8GjDTRFrJ+E60RAVq60/dQs2u1qrFbVWTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA0PR11MB7912.namprd11.prod.outlook.com (2603:10b6:208:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.34; Fri, 15 Sep
 2023 02:32:58 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 02:32:58 +0000
Message-ID: <8307c089-cff5-db41-5248-7e0f2801143f@intel.com>
Date:   Fri, 15 Sep 2023 10:32:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v6 01/25] x86/fpu/xstate: Manually check and add
 XFEATURE_CET_USER xstate bit
Content-Language: en-US
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-2-weijiang.yang@intel.com>
 <868ea527d82f8b9ab7360663db0ef42e6900dc87.camel@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <868ea527d82f8b9ab7360663db0ef42e6900dc87.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0005.apcprd02.prod.outlook.com
 (2603:1096:4:194::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA0PR11MB7912:EE_
X-MS-Office365-Filtering-Correlation-Id: d132d6f0-1d15-4910-2b36-08dbb59412ca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AuBR6gZ++UjRx0R1tMAMB67tCVYULFB/+/kOM12zWTyKY4cO0SnhkCXHS7Sh1cr6ICs0yvQMQUn08iaEUCgSYJiXEDGNaZ6JM0WBssbqJG4UhfsjuAtX5yl700VyqdUWsa9rGvi2KSx4i2PkTG5KboWabAH8rZkENWs7kx4yjxErcDW53Q9jnrVlfBSh/Y0UKwBW+T2MqXWOlNhHPqoOBn60BZwOsGDO/y5RHAjpb6kLdR6/DHdr6e5e1BQ68fY4Cn3eUUSPieZc+ZHWl5vlJZzwReS8x0nHG/LXNkYJCT/dNof4933BBN3MK+YtRq1KlipKufi6TaDTJatl2JYAxVkGu2hYrvZM8yBTWLBnza2/sjzhX3SBjG8LHFGkHoTpOzLNeuIvquNQ+QZ2UjYDnlrBFM/P1uM4ZTtYuOAJZQcksaX1UDjw7aPfNJ57jZLzH3idmAhcGZIOYnGVE7KffMrEH9CCaFMMnW/bisfGDm9A5L/UB8FFQwbXuAM4WC1aqixLaLfIQffuiwLjtADqHixGW/pu2hz9GQV+WipmbZD22FVZJrIIhVD7Ee6Fd8YVLiKc9PQ/brmOn3DDtBxMBw+HSePXHgBCxPD055hJXtQR29G7wORxcTGK1xtCdJPtT/S0kpnR5g66Gie7RSy12Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(39860400002)(366004)(346002)(1800799009)(451199024)(186009)(110136005)(36756003)(6486002)(6666004)(53546011)(26005)(6506007)(478600001)(83380400001)(2906002)(66946007)(66476007)(41300700001)(8676002)(2616005)(316002)(66556008)(4326008)(5660300002)(54906003)(8936002)(38100700002)(86362001)(31696002)(82960400001)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEQ0bWNsU2hwNHhHRHU5RG4xampGczBhWTVaY3dMK1hMa21UcFlxTUZSWk9D?=
 =?utf-8?B?Z3lodmdQVzlMdHI5TjdrN3NvemRERm5Eb2c1Z2Q5R2REUyszWDVNWFNMZm43?=
 =?utf-8?B?Q0xxTGx4VUo0aDZoa2FZUjNQNHNmamxab25lc1RsRklrOGRnRTNUc3pEWmRB?=
 =?utf-8?B?WUNTdUtFam5sN2U2azkyQjJLR1FtSFBpdThERUowTWhBcE9sTzJiQXVaTG4x?=
 =?utf-8?B?eEZlWmVWOXRWc0svYUpjaEtjNmo2M1hBd0xXeENYZUlXaTBpTEg1U1ViN3Z2?=
 =?utf-8?B?bjd5VU95dWdralRVY0NrRkZoNzdLdnB1amE2STNUMG9xbCtFU0gzYURBdENt?=
 =?utf-8?B?c2lSSFJBK2hsbnZXWElScUtXTHBTemVpYlhNd2VIK2hQdU9QQUV2bVRsWmlx?=
 =?utf-8?B?dFJNTjVGTGVJM3l1c3lhRmdnZnZURWNJKzQ5RFN1V3BlR0x1NTRscTgreWR6?=
 =?utf-8?B?ZVF6TFVVMlVSaHFpNjFJV2xuL2hhT0RrK2labUZtd3NKUWdQRm1yeWUvZGVm?=
 =?utf-8?B?MytudXBFZCtKMWNHVGlpc0FNaFB3V1FFbitYMkNMNU93V1BRMlhOUjhZK2FK?=
 =?utf-8?B?dGhram53ajA2TWdBTEQvd0VWbEJ1NzhnMEtCbFhveDVDVFdLUnpmMHFUd3Fv?=
 =?utf-8?B?bWxhcXRNOHowdkhxTFpjL2plK0pSSHl4QjZ5WXFYV0xvcEZCOVl0NlF5V21I?=
 =?utf-8?B?NTZJN1VvOFRQY1hwYjA5OEVsbUlNMjUwWnNyRHJpTVNCRUw2UjlRdC8wcUs0?=
 =?utf-8?B?cTFhUkZzcklScEFwbkl0c0hvd0ludU0zUWRsb2dZaEJrU0NMYnZQRXpHbVhE?=
 =?utf-8?B?a3laUWt6Y3ZXeEV3M0pPZGxkOW9OMFgvK3loQWRxUjlGaHd4aFhBaUxVajND?=
 =?utf-8?B?MUkxZERLcXozK3NZZDlKL3Mzb2oyd0xSUE5wNy9xdXZNWDVxNjdMUU5VYU5j?=
 =?utf-8?B?VFNrZitQbXYvcVR6a1htSEZxK0JnZGU1M2lTSmgvT1d6TzhHQ2EzSHU4Z1Vv?=
 =?utf-8?B?WlAyMGc4VGJBVXNmVGVteGxxdExQYjN1TUF0K1hnSWVpS0ZaSmUzZlAwYTFO?=
 =?utf-8?B?K2dlSVlzSSttQ1M3d1FPcGFtbVJocWtJaUE1dEswTHNLU1U2MFdFelhmR3d3?=
 =?utf-8?B?NTE3bVNEVkM2WG5tQWY5VGJKdVhPbFZMZWhPdmswdjdEdWxmbHFCNDVQdUtu?=
 =?utf-8?B?bXFXUzJ3aGpFTTgrV0tzRmUxSTB0UzRHOWJrcEQwSWp4aUJBMG5JRi9BZ1dN?=
 =?utf-8?B?aS9pNzNQdEpRbml1eEhJUDhDT1RKa2xHeVM1WEJsVWdvL2VSUmpoRDBjZG1s?=
 =?utf-8?B?MzJxQ2k5djJJQ0N0VFE1RkJPWnlhNTJLQ1RKOUVKRnVGLzNNcHBwRVlxdldP?=
 =?utf-8?B?SjNPOUdaS1Y3UUR2bnZKa2hYMm04Zi9oemVQT2JwSUQ0ditLZlZINTBabENp?=
 =?utf-8?B?eVdlL0xOSnJDZ2ZBMFNyU2tRcHVQNml5eSs1dFVaMlp4WkxueU5odDBOK2Yr?=
 =?utf-8?B?MFU5ZjE3dGhjZDJLbTVxZDFNcXFMb01TeWhGUnk2NUJYQ1FmdDNZODhMdzdQ?=
 =?utf-8?B?TTBvZXM4d1I1SU1RMCtuQ0R6VDlmMEV1UU40bFV4RWNiYXZpZGkxQktONElH?=
 =?utf-8?B?ZU11QWRFVEc2b0RQZVVJUVF1c2g1VDVadXVBKzZ5aGM3bnZBQkpIcVNPcktz?=
 =?utf-8?B?MzRyeFlOL1Rsb09jOGVXZE82UE1CRGRFTEh3Sm9tcTBERW1KR214aFJFbjBZ?=
 =?utf-8?B?NDg0OXV6ckxUWTJWUHRmOU5FZmVRTisxWTIzSmprSVJ2VU8xVTBjOFZMWndW?=
 =?utf-8?B?TTBBOE80aHowK3dFNEhyekhIaHQ4bjJWWWVrbjFaU1o4dTRKSDdhSmdDTlVK?=
 =?utf-8?B?eWRQem82dVBnOVgyVHRkcDZxRStuOHRwSTlGWWtqa2VmZVFXcDJHV3liYTZ4?=
 =?utf-8?B?L21JVDhUREJlUXNnaWIySCtTMnhsck8vczVmT2VsUEFaWEJyb0JvVE00c0RR?=
 =?utf-8?B?UlMwNGZjYW5Ca2ljRnNwcmtMdVI4SC9Nck9KK1RhYTdFc2Q4SVlyUDdBOWtQ?=
 =?utf-8?B?L2gzT1g2QnFiQVlYd1Jtb3lTaW1kWnBkcldlbmY4M1dBTi9XemFWeGpEbU5F?=
 =?utf-8?B?TzFNODV0a2YybExoSC92cEVCQnZ2OXBSVEh5djYvSk8ydStjU2V3MWl3Vkhz?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d132d6f0-1d15-4910-2b36-08dbb59412ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 02:32:58.0035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FqKPNtdNHU4oDaaNNvwtZw2B/+k2d/wEwV8ARnHd+0d7n6gCw4qHGNnFCHYggd/K5XxietTG6v1X4iFiKeR48g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7912
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/2023 6:39 AM, Edgecombe, Rick P wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
>> Remove XFEATURE_CET_USER entry from dependency array as the entry
>> doesn't
>> reflect true dependency between CET features and the xstate bit,
>> instead
>> manually check and add the bit back if either SHSTK or IBT is
>> supported.
>>
>> Both user mode shadow stack and indirect branch tracking features
>> depend
>> on XFEATURE_CET_USER bit in XSS to automatically save/restore user
>> mode
>> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever
>> necessary.
>>
>> Although in real world a platform with IBT but no SHSTK is rare, but
>> in
>> virtualization world it's common, guest SHSTK and IBT can be
>> controlled
>> independently via userspace app.
> Nit, not sure we can assert it's common yet. It's true in general that
> guests can have CPUID combinations that don't appear in real world of
> course. Is that what you meant?

Yes, guest CPUID features can be configured by userspace flexibly.

>
> Also, this doesn't discuss the real main reason for this patch, and
> that is that KVM will soon use the xfeature for user ibt, and so there
> will now be a reason to have XFEATURE_CET_USER depend on IBT.

This is one justification for Linux OS, another reason is there's non-Linux
OS which is using the user IBT feature.  I should make the reasons clearer
in changelog, thanks for pointing it out!

>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Otherwise:
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

