Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03155775141
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 05:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjHIDLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 23:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjHIDLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 23:11:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D0E1FC7;
        Tue,  8 Aug 2023 20:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691550697; x=1723086697;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rYxbdbogBIzuWripnkf4IgdN3Fz1XOxial70o7cLNIw=;
  b=Zd3LXqVq74Qj9K9Io6JMRhJO8+gXrYvv2MZsDUhYOxpzJDzDuliiOeDT
   kXWcxZFIHPQHrQePO1bL3bWAU/xtbqQGhM7Mm672QaudvdB2dBvYFt4/n
   C1X3oUgw0ium9Ds9yQJMz1yT7Qng1MSduDNCuK30UgTuuvLrMdVlrDzHE
   EFodF2eIDP5ycuPjlgVGsyxUCPVsQySeQ76eD7PWYQcYJh+K4/9BDO445
   ubXBj0op/SoSofBNiHu0qs+cSVDUoZ2UZCG1x34yrhfEDnRbq/bnF8As1
   VroxdhbVh41a5rZKCGiJEoD/SpSdNnHs1GfzMXNgJH1+O2yy7kFm8KIDJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="374716862"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="374716862"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 20:11:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="845755343"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="845755343"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 08 Aug 2023 20:11:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 20:11:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 20:11:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 20:11:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 20:11:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MACf07ndliLgiBxp5DcLFUXEwkgTPecjJjjt/+1y/NRtrjbI/pZvIJYxct1zztmjlP+CTRC45u5BK6emg/Sr15ssCX1V5UzujwkMj5FaBBkepdWUfiQQREbY/C5xxHhU6SujNpM0m1FPK8CIQsnK8YINP0VM047IkLk3RK/FcpaPkMFsquJ2dJ1GfAtot1mMWRI50Enlxx+6JOXHXVTAJcaABfMKfcVz4vH6XeZWz8Q6NrGrvNhQeF/1GQwCYjhTjJIz7ZM3TP01INqtGntzOWJpoErxDplyz1zieIzkHODPSpFNGryzYWP5zLfRMFSn4bj4msj4yBkjgLMQKbJY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYxbdbogBIzuWripnkf4IgdN3Fz1XOxial70o7cLNIw=;
 b=BSXaFbOkCwfPK/5ei2j3SWyoLuSc7p/r6PTlrVCxInMUN8QEpS9XDcXTmdJBZGJkVCPwIhCbED07MftKTv3BaXjJ3KbjIOLI43NJu29OvwvaMseyBPsTaKsal4k5dC95JLuUJ6TjwW4MvX2SZvF9Z2JKYjrqJkjT8MLm2YQJu1mcFkzCMsVrT5By+TScYkXmUtVwSOR9DrBiEFP09ZhV+1iJv64uJBn53x21hBQaZP2RINROVIaiUjlcBhE93JmiJ37BiGxybyhWqqYWVc7hcOlQKttFvDuv70E2pMRWm2/9WDdsTn3YtgVhuO3bIBCcguLPkJD6+cs3lROpCU2I3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB6962.namprd11.prod.outlook.com (2603:10b6:930:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 03:11:13 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 03:11:13 +0000
Message-ID: <f5c7b43e-80cf-53b6-730b-ff9e1c023f13@intel.com>
Date:   Wed, 9 Aug 2023 11:11:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
CC:     <peterz@infradead.org>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rick.p.edgecombe@intel.com>, <chao.gao@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-5-weijiang.yang@intel.com>
 <ZM0hG7Pn/fkGruWu@google.com>
 <8066f19d-68e9-711b-acdb-7554475602e6@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <8066f19d-68e9-711b-acdb-7554475602e6@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:820:c::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB6962:EE_
X-MS-Office365-Filtering-Correlation-Id: 1347669d-c7cc-4d90-c669-08db9886499c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBzTJ63WlU8FnFYgSuRf4soh3TQBN0hnfGLBKxca9i4xOEqw+zfulYlPHw1SrDSYOwEFrE7a84E7OylCIkELx7UH92VdjUDLEP0LJlPiRlHYJuC32bUwoO1yGdoc05SOB3TIWkBbY7a7cSh/YBeYJT/aa2TKnk/gZHFXogw9cNZiDt/EndYtBQVE1t1Oz2b/HBZXiTcfgeVxpVeVATxFIuul3+lhv1JjOXQy12Yy62qxb4CJY4OrCFopNPis/Rveahhkt4xGSasKA2AV3j+I8h+3PoQ5HsrlQ5KT2OQCC1ThLPavVgws2nZTeZ2ZGLfBBOXB1dgy41+xOkXzv5EfObpgzHSBJXmSrJHxQp+BvsgkKXRqyWIOaMRaQSPmCH6NFwp8tH8tkD8lxJGOhR8MuRCWlT94EFbtCDm6d8KP+V15IXXIJC3ci7wqroWx4nHaVf7EhWWLbpw5LsBo+4tCkJINb+cjM8kaQuOKCApRaAfIAKddZcT5Xk/U308gx0AFNFRrXcBA1gVOnofIAQ6ryyl2cFc+DcLmmqjL1dmNRNIzZ8Pzipd8ACpnOddFTHlPhy/Vt46A+fPmDdM6C0w0ELYkEdRmYfFSeP4kdACInQnvN7OsReA8enKOXXA9ly74AmT1iZd/URmrX5STELDhdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199021)(1800799006)(186006)(83380400001)(316002)(66946007)(66476007)(41300700001)(4326008)(66556008)(53546011)(6486002)(8936002)(26005)(6666004)(6506007)(5660300002)(38100700002)(6512007)(8676002)(110136005)(478600001)(86362001)(31696002)(2616005)(4744005)(82960400001)(36756003)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODV3KzVYdGU1LzZVcllxU0N1ZTY3aEhSQnUzMWFrV3pPUThoTTRXTXY2ekpR?=
 =?utf-8?B?L25lZ0RuSVlRVXBoaE1UOGwwRlgxMnF0QmxsS1ZadHluVmxRelpMS2oyeWx1?=
 =?utf-8?B?dmpqZ01GZ1l3bWUzSExmUkk5UWJuQzNxaUdDQzcwTlpTOHpreXFGaXJtNnlT?=
 =?utf-8?B?TktQeVh2eTcwb1I0K0x2M1FVNkRvQVdUZnk2bzNFQTU5V3N3M0dnRE9oR2lJ?=
 =?utf-8?B?bjhMZ1oxS0VCbmduOTNiTHZQd3duVW9vemxVQmttVkdMN2pnU1pLR3NhVVM1?=
 =?utf-8?B?SFR4Y1ZEQ0lnY2xGdG5WK2tiNHNWR2djZjQzNE9mZTdLNHF2TzBXRitKWlVh?=
 =?utf-8?B?elpQZzdSQy8rQVV5aUo4eFpnemdoNjMwMkxmbk8wR0I1NFRjZGRnZ3liSkFQ?=
 =?utf-8?B?RFVKT1h6d1JxeWQ2MmNKdVRnZElndC8rUDc0OFJ0WjJjbXJyVHQycDNZbDJ2?=
 =?utf-8?B?MGtpRG1jdzQrNzl3N2lGa3BUZHdWM2xUTm90b3JRaTRPT2NISHdQY1k3ZXJH?=
 =?utf-8?B?YldIcWVSTW16NEdtT3ZCTEUwZjRwUFBOT0lhZXZ5anVNWlNJWWE5a3Uzc2Vy?=
 =?utf-8?B?QllKVVZQaEFyMHRHSHB2ZXU4YzNxWm1WdUdvVndxZklZQUE1dUlmMGVLS08z?=
 =?utf-8?B?WjN1UlNuME1jZExpUXk2aVBVMFFQRDdtVVNTL1J2dk5JTmxTUmkzOHJwZjd5?=
 =?utf-8?B?eFg5ZC9YNHhqQWpKaEZaY3V5L0xGWVJXbG5MZXNhMHhSSTc2ZnN4Qk4wc2Qv?=
 =?utf-8?B?SndBNkZaMjIwb0JkSmpHV1BRV1lIcnBvQlBNaE56WDdReUF6RmRZZjZJQkFF?=
 =?utf-8?B?d0NoeE9ScndHUGJOU1JwRXFjczBMRUQ4OEFkUklNZi9xZjFIYkd6VFN0NkYy?=
 =?utf-8?B?cndNeVNIQVRpOGREUkZpbjZZVFI0OHNibXB3d2RxTERoYVZCaGo3YmNtT1Az?=
 =?utf-8?B?bG5LMUFVVWU4elN5dFdqaEZyV2pJNitTaTh6UkJYUFhtUWdWREpGRmkwVGZL?=
 =?utf-8?B?UVE0L0F2eWRuNzFvSDh4YUNmNEpFZENrTHZjYmZsazVOV0R6UmpOeDVTak92?=
 =?utf-8?B?UWg5anhGTkt6eXl6bGcvMkxYTFBZa2V6cy9HdlVrRStZMmdXZU9iOUhWVE9F?=
 =?utf-8?B?Ykp0M2lUYkpFUHU3dVZhK2svd0pSUnlBREp2SDJ2V0pZM003MVRTY2dxNWV5?=
 =?utf-8?B?Vk4ybmtLRmtId3V4YTdUTXpYSW9NME5nQmxNN1N2V0lrdWxBNjBCVDBVcGdQ?=
 =?utf-8?B?Y2xPdTFEMjNXK1p1bWQ0Z0pGRjA0L21sUjE3Q1J4MmJPUjJUWEZRYWtWRnlV?=
 =?utf-8?B?Rm1YTVM5U2lncHlrTStXZ3F2R1pCd2JwVEhJT1Y4REh0OCtwaGd6TlZ3SVJC?=
 =?utf-8?B?bzFhbS90NnRnY1JPQnFacHBtMG84UnA1NTNoY1ZvVldZanoxVXgwZkpYRFNY?=
 =?utf-8?B?SDNkN1dxc2xjLy8zdzQ2dlV4cStjWUtxekhFZ3RwK1djSXp0WTlSK05ORzBU?=
 =?utf-8?B?STVtQll1MzlrSUZRaFZkdzlTV3E4Y2U4YUI0andoOU1UdWJyYU5aOGNKbUdo?=
 =?utf-8?B?UTE2MmJZelNNTTExdy9TNWNxOGptZ2lKcTBZcWt6dUl3Y2xBTy9lRUtHT2Qy?=
 =?utf-8?B?Q05XaGZEYk95SG85RFhiMFF4cTN3K28vVWhtN0FIRXdTNExKMkQ1UEdpT0Q1?=
 =?utf-8?B?OFNQRGdlWGRzTFp5VnNGM3RUaUZ1MEJrZ2RzT0xRemUrNGl4LzZaTmZWWFM4?=
 =?utf-8?B?TUxEcnNXMkx5dGZhZVgxVjBVanZ1bXp3cWgxNUNtZGFXTGw4S1UrcXI4NlBK?=
 =?utf-8?B?STRMYU96M0M5elpmT3grQWdGNUlERnROcFdodVNKZmJQRTJuUzZVc3F1YWpY?=
 =?utf-8?B?RXY4ZE9zWWRSVWFXOW5USXpEVEFYRUsySGhvbzlkbytlTnU3ckcrWmFhNlJ3?=
 =?utf-8?B?V3pWRi9XTGVTNG0zMU1nMlM4clpUMW1SQkx1Szl2cXhPSDdlQUFzNWV5UjBq?=
 =?utf-8?B?T2VjQVp5aE5HRXJlWmlJUkIzeTFhbnFzcDA4aFdkYm5ld1BQZWFqSVN1UWdF?=
 =?utf-8?B?anJ3SUhqbHk1cFV5eDJiN3ljaEd2cWExL21iMnh3SHY1dDJJbE05SGpiN25V?=
 =?utf-8?B?d2YwTlBsWW13a2tuWHNDYWUvMVgxblFPR2pVTFRiZ09MbXppY0d2SFNpa1gy?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1347669d-c7cc-4d90-c669-08db9886499c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 03:11:13.2370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUnnrtbHNzuNQM2kzuqFBWK8+LVgJRckeVRZdAMjbqOLfPtS/96DnZaIjXmC/cephiR9F2yhlrxeJ7iA1+R7Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6962
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 5:43 AM, Paolo Bonzini wrote:
> On 8/4/23 18:02, Sean Christopherson wrote:
>>> Update CPUID(EAX=0DH,ECX=1) when the guest's XSS is modified.
>>> CPUID(EAX=0DH,ECX=1).EBX reports required storage size of
>>> all enabled xstate features in XCR0 | XSS. Guest can allocate
>>> sufficient xsave buffer based on the info.
>>
>> Please wrap changelogs closer to ~75 chars.  I'm pretty sure this isn't the first
>> time I've made this request...
>
> I suspect this is because of the long "word" CPUID(EAX=0DH,ECX=1).EBX. It would make the lengths less homogeneous if lines 1 stayed the same but lines 2-4 became longer.
Yes, more or less, but I need to learn some "techniques" to make the wording looks trimmed and tidy. Thanks!
> Paolo
>

