Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4044A6F7D7B
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 09:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjEEHIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 03:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjEEHIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 03:08:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F111AD1F;
        Fri,  5 May 2023 00:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683270484; x=1714806484;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C9X/PwrWBWC0+ZjAvd1lvzdVnP/ovhVFl+8x9JPvjKs=;
  b=NUSzuoC47gW8l/CI/eKT6F6MdsZp5T1FMfhiB42k35IUtkcJ9V22QGaW
   3vRoFfKjtZ/Y/2/rxP2aNy2DgR6bjwsS0v7SrzzwtZtfkpY56mQHR+CuM
   +Mu+7QsIA7a8T5UcYDNdZgIvZp4yjIrJK0sLyyUduivZaNQ5KpMUVfKOW
   6Il1sG4pZ6EYzb60rYCQGtx3h9iF+dIqoxOg/tQZKftzsNWEEccpaQhhl
   bnAaKFqBq5XvQMxPzY/So+3At5gEOQPvi3gTWcvtksAB+sfD7ioHhyuOb
   wqZqJYuofDyPU0bVDUaFCBc9iCT4NbQMjaXG2MDLD5xGeD83s0JSf6C8c
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="377225018"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="377225018"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 00:08:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="766944061"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="766944061"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 05 May 2023 00:08:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 00:08:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 00:08:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 5 May 2023 00:08:03 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 5 May 2023 00:07:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M39nMDdsVOIDoBi0gkRY3mAhvMEt7T6ctEyT3MLdJsWI8CQ/GmLCaJ1qbDrgJPbpEzwInROcyJsm3z7rfC5Ohkx8WGyR2rEni/vAs7FTsEkdXwOySbbmBhtuS2KjuJaDEfM83zrzim+m49SAoH9zwKZpha+Owtd85KjNq/YdwLX667DCwC6uGZjPe38WUK1sAsyQylkFrCFyqbLXn+j/rdDp9z56rw22f5/VhJWwUUrdYm5mJ2jInLZiIovXPUC9xt3cS1bkHUc65kQMykDcaT67Ednew3B57wCs4zhg8TTTb8bhg4qgp5CRtQGyg8uHJUF92h91bUk27dlSvXgSjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyZYHk8hoB9dkCDQvzoin/xMbBPRexCqETi1nhTfqbc=;
 b=DzgRrm5PKE0OLWtp8RHcGXYHc+Wozrr7O/oVxxCzjkn52HOxvwShrqSl9mIhkJ4ZlXpD3Lv8zzlBCJgJUP26WN+7OB/AzNKbrD2snubge74WEgFYtWSGrzDR5ioIj71mHkYfrRMbyVcyKDlDd4fP3bXSA2XyQc8VP6ClPYPemezH0lD/EXt3INhpJprNWuquIV2e90Ea6eX72+FNbvmru+xoQdC0hnF/Me1las3LhyuT9s8QsAHUr/vxUcep2Pt3LMpIZPQE4/er9xv5R6z9SbHYZ07Yd01BicoD3sWznwxOrnPPBiCFRTu2fXO1BEhqRepFRJwJlzWm9OOd7Ka2lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB5663.namprd11.prod.outlook.com (2603:10b6:a03:3bc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 07:07:52 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97%5]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 07:07:52 +0000
Message-ID: <6d8dea79-c9a1-5b69-3841-86f2e322a1e0@intel.com>
Date:   Fri, 5 May 2023 15:07:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 11/21] KVM:VMX: Introduce CET VMCS fields and control
 bits
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <rick.p.edgecombe@intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-12-weijiang.yang@intel.com>
 <32dbc22a-421f-d513-c605-88d9c7538b0a@linux.intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <32dbc22a-421f-d513-c605-88d9c7538b0a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0059.apcprd02.prod.outlook.com
 (2603:1096:4:54::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB5663:EE_
X-MS-Office365-Filtering-Correlation-Id: 014d4dfc-bc1c-4409-08ae-08db4d37710a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bVuoCaCnspXy3zENNjMPX2WrNpxw7bqfZoUKLUwrxsge0crAUSHbtzpK8xdUSlfZa359U88NS5gMS5wY5TtjTQyR8cfq9G7fjkwLeiJSXUhBVinRtY1RplAyQPVnuh6y8fJVMENEz7SqUFZAXsfDYkpJG0zs058Bx58wQxdsopExrIZwT/pNgbXUWWi6fpNC35gB+js8bvJuFuIuDMDBcetBtk8VSsTCn+lU2VtB7O+jAkbmltKWzJCVgFZEVCQsHNMEkK404bDnvxiZzyL/M28Us74gMJg2fe2MMjKcSx9NX3HSV/98S3q6AJEU36qIkS9wHnGC8TN0KuFSFATtSYTgpUbKPJ6w0pS5QsoljJj9lL8BLVpS1l0z4GxrC+rmwCKn+p3cX9gJvyCL2AcOWO3iPH7pDxweceA/LxUvMMqEh+dWCp78dl/IhnajUQdCIXZCVDcv0Pm9MRweNNFPV/DZQrd0/FjSjaYJbJqEH8BiMlnZpSGLwWHAmCbvW5wI4jdRBFnVhNU4wkBBVQEI4ypEMuBZBXBM64kvCy9lbFR2g2KrL5zGfK+9OvV3Mgxt9TVdJloFYkdqnr87xRYkxyFI00OvKZrFX3BW5hDRkXgULRItf71P5hkcVyAWaL8hdqy1noWSpipbQwOKfAUPxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199021)(31686004)(66556008)(66476007)(6916009)(4326008)(66946007)(478600001)(6666004)(316002)(6486002)(36756003)(31696002)(86362001)(2616005)(6512007)(6506007)(26005)(53546011)(8936002)(5660300002)(8676002)(2906002)(41300700001)(82960400001)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWhYZnBCTk5xQ3A3TVkxZUM4V1doYm9RVGlWL0IvNDFWVFRYRGw4TjZHV09t?=
 =?utf-8?B?dnhSYVZrUWpGMVJSOFN4T2R2M05uZjBGMHV0Yld6d2xHZmdkNUVlbWh1QWxj?=
 =?utf-8?B?Ukwvdm51ZnNVeXVLaFZuTW0wYkRwdjdGQnc0cnRjdGIzdE1QMnJWU1ZIbTFS?=
 =?utf-8?B?NVVOUldtL2FhQ0FnZkNjZWYyQ0xnTTRJVnVhYlE5eVBSakJtTmthWTVtRk9u?=
 =?utf-8?B?aWo3UkhIK2hUU3daTGY5aXFrZ0JiZldyUkd1aFNnTkNia25JTncrQkdNOEVq?=
 =?utf-8?B?azNYcHp5MTBLYUl1MEFHaUYxUUpSQkJFM1VEa1QyYm1SOS84RE1ZY0RZNmU5?=
 =?utf-8?B?S0ZiTEJCdWdWV3hMS3czb2Jtb3B1SDBESiswdWFUSWdwS2plako0T0YyWWxU?=
 =?utf-8?B?WjZ1dERDeEpYa29ibjNwV0JWanliVzE5MEU0bndzMWhaSENXbmtoaUkvRmNU?=
 =?utf-8?B?R1dIVFZ5YjFhT0lhbitXYTlIeFFwRlljN1RzanF3WTIweUh2Ny9lYWUrMGhw?=
 =?utf-8?B?bmZHSEw0OEVYMUZhbUJrbmNXZFdPbkJROCtZekRpWTdiN2ZuTWgzTkU2aUxM?=
 =?utf-8?B?eW90R2pSUVFNTTBNV2FYMWNMdm12QTlyNXJ1Z3pSTlZvU2xXYTJXVEZDQUV6?=
 =?utf-8?B?REJJaHd5UnBtR1pOczZLWUNkVUdSbnpERnoxWnB3aW02SitlcFpyYTM1QVQr?=
 =?utf-8?B?a2xQc3VxVlVRcmlPVmtweVhoNEpwMHlna2xMU2xqNEZIL0tCK1l2SUZ5T2JP?=
 =?utf-8?B?MC8wUEFpbXJBdjVRZWJZVURJd1hPaVpNMGxQR2RibTVZQWtxZjJZaU1zaVVV?=
 =?utf-8?B?bUdKUDJhSVFJS1FRa2M0UGVpR0xMU0djZWVQQmV2cUVVQkJJUjZrZkRzS3o0?=
 =?utf-8?B?MTFZdjVFZ1llVGo5bU0wQXV0eW9YWTAxZG1uclpidWJac0VNSFp2QytLTE9H?=
 =?utf-8?B?MHFsaFpQQ2dvMFQxTFpTQmhYcGN4MTVFZEtGc3RzN3dTZkRaVWZzWnVhYVFk?=
 =?utf-8?B?V21YTDVmM3E5RDd0bzdmOGZuS1hjK1U0Y04wckpHOVF2TUVEa3VpYTZQSHhB?=
 =?utf-8?B?QkVTTjV5dUdKM3BSQllDd2h0eHdhcVlaajlDRFhQblduWTYxNDNBRGlGYTNw?=
 =?utf-8?B?ajNCY3ZySWlQYmpzSy9kVENOVjRSM3VqNDhjbTlVZXBya1pTdW02d21YM2xT?=
 =?utf-8?B?bGRQZEdoTnZyWXpqem9zdFBUZzBOaXZub0RMMGVqaThEU0Uxd2RxL1BweSs0?=
 =?utf-8?B?TGN6UjZwOHRwVXQzR1JnZkk3cGFDWCthSVZGbU5aSDRWZmxOWElmZzZQVzU5?=
 =?utf-8?B?NHc5T3Y2SGM1TFZWSDhrNDk4dC9tLy9DVWh5VDdqK1lBYmNWVmJKMFFMMzZR?=
 =?utf-8?B?VnhJVHVBeXNka3FxNFFPdU5VbmtMRlNlNzRkNU9yVlYxT0ZNWkl4dW1mZ0pi?=
 =?utf-8?B?R0lQMWFjTFF3Sk43UlQ3UFpSZkI1SFMzaWZVTEhiV1RwQmRaNjd6ZWpqWm9m?=
 =?utf-8?B?TXhYQmJVaGNNRHJHTXRad2pkU3JNc3pocmhWMFFXTmJoZzRSNitnOW05WThx?=
 =?utf-8?B?cDBkSkR1anJVeG4xcFBMT1BTbmdQMHJvRGVJUHE4M0FrQWtsemIwZ2pGYi93?=
 =?utf-8?B?U2oyamRHNkFKUXYzRmpKV2VQWmI5NXh1ZDNrSXczWFFNaDNhdkRZSlBMSld0?=
 =?utf-8?B?ZDFlWUdXOEJZUmF3bDYwdmRKTmc0Qmp3WVN6UjkwUWIwYlRLTTQrZGdTL2Mw?=
 =?utf-8?B?WlBjS0xBWDhOazhvNDZpelFXeHBEZEZmMng5T2F5b2dLajl1WUo5VXpJNHJF?=
 =?utf-8?B?bG53RUc0ZkNDWC9zbFUySHErZThMd2RiUWtjd1VxSTQ1c2VKb0xCZmkvZktF?=
 =?utf-8?B?Z0VzV2o4c0tzVVNjN09mTFNKMHhxaFc4REVFeG1iaDFVM1R1ZTJkaDZXckJY?=
 =?utf-8?B?SDhCTTFzVmNFK0V1SnFuOHVPck9lYU5JRUdxNzJzZGFEMHBUc016aStHeVdG?=
 =?utf-8?B?VUt2TnJzZTRDZDdUQktZZVpoeWF0WjJaN0dIdW1WZVJFNVQwMmRja05SNjNk?=
 =?utf-8?B?MEpjVlBpZnN4SFprbWZEdWR0elRsUW5hL1lWNDBOMHFLUTRtRmh3YnZCcjVW?=
 =?utf-8?B?a0F4Y2l6TU5KOGYyVnlJNkRrWklCb2xsTVhSbVp1UUtoZ1Y4QWRyYlVoT0JY?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 014d4dfc-bc1c-4409-08ae-08db4d37710a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 07:07:52.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWf6mUxbzWxiyju2s7M+XSrujUEcCbVkq4VDg3JS6Ovn3ErJKw1P8YX9MxmTjsFa40+6AcT007DINDaOUopUsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5663
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/5/2023 10:22 AM, Binbin Wu wrote:
>
>
> On 4/21/2023 9:46 PM, Yang Weijiang wrote:
>> CET (Control-flow Enforcement Technology) is a CPU feature used to 
>> prevent
>> Return/Jump-Oriented Programming (ROP/JOP) attacks. CET introduces a new
>> exception type, Control Protection (#CP), and two 
>> sub-features(SHSTK,IBT)
>> to defend against ROP/JOP style control-flow subversion attacks.
[...]
>>
>>    MSR_IA32_INT_SSP_TAB: Stores base address of shadow stack pointer 
>> table.
> According to the name of the MSR, it is interrupt related, right?
> It's better to describe the MSR more precisely.

OK, will change the description, thanks!

>
>>
>> Two XSAVES state bits are introduced for CET:
>>    IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
>>    IA32_XSS:[bit 12]: Control saving/restoring kernel mode CET states.
>>
>> Six VMCS fields are introduced for CET:
>>    {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
>>    {HOST,GUEST}_SSP: Stores shadow stack pointer of current active 
>> task/thread.
>>    {HOST,GUEST}_INTR_SSP_TABLE: Stores base address of shadow stack 
>> pointer table.
> ditto
>
[...]
