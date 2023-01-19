Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4D4674647
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 23:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjASWiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 17:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjASWhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 17:37:06 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC510B747;
        Thu, 19 Jan 2023 14:18:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEXOVk/EJ7Sb9doam88dUjUE0/dMugXODGhSNHg1Rc5Zv+3Wk7XqERDqZP/NvjoMFjFokUEbI1KvuCLq5KwSL48B0AlzjNhKLXjMziDx/rG6QpmzdesOTfS02FJ06UoUSUoQwOtVT6wHK1fMjtPjG2W63q8+c3q1+Tfp91ec2A/dd8GUSYdPGemzBdiErQdw5SgKxl1pcR4cDOAT4jN711ExdBY80dxXcJSPBsobo6P7Zrb7364PRzxXmX1TfayiufnIxdAL1H203KpBntcuzhiSS9/cO/e6rCNclR+dQ2eQsW5Mrw1sA5HwLGkXTarvJMC1cMZv43bS151o78ooWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQAvO+vPnSsQkwXtBC0qEi41z0FWZ73yOQabW51oc3I=;
 b=MTxA6OBj5LkEn0JxI9INMSHpzmirMISccUAvyO+CpIyGH4QTeoD00Tu0fy8hXch0iyGNnCiIdp4D1y/ILyxGY+I/j3Y384HvAnLOJkWIOIPZqw+xNfdB6nfFfWUfyZBSE4tq/LL1lZlDC4av5lgjjeH3KgbxLQhV6FKEin4SS2Ua2ykMTf7WSbFY8KyHqYTOprU4TAse7lk6uXRcHs9iHoLcK7np88SE4geteZwQAgJrNsH/VoNvDogVTK5pWB7qnRgQ+cSX4qaDaT0+X4h/2B9JfiMglr0p7DB2058xTCoYESPcEaWXBY9y5175JbvPmvCzTKRYI3OWGHBJjVhB3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQAvO+vPnSsQkwXtBC0qEi41z0FWZ73yOQabW51oc3I=;
 b=AjuicwzJEfvXhhYP1FY0p/Evu71ltcTL64JyhNZluAGmk8mnxTkjB+wSyCfR0cZwmJsxxmRBiqrfOjgvSSpViZkAWP+IyKy4ztTbM+fAKuSRwP7+WPX2YRqQRdwwZP8m0/urk5JBD7jlR/zBKeumJErLA0WUdj8Qvc4plUMnBxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH7PR12MB5974.namprd12.prod.outlook.com (2603:10b6:510:1d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 22:18:46 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 22:18:46 +0000
Message-ID: <d09e13c2-3a3d-924b-05b3-560fe1121516@amd.com>
Date:   Thu, 19 Jan 2023 16:18:39 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
Content-Language: en-US
To:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-63-michael.roth@amd.com>
 <CAAH4kHZVaeL57bGAzeDjJDTumsnb96iAYBdhm7cs_8TjBg+v3w@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAAH4kHZVaeL57bGAzeDjJDTumsnb96iAYBdhm7cs_8TjBg+v3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0130.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH7PR12MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: e76a7f86-e9c0-4a26-d607-08dafa6b2178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4gb90v+E0qr24+8KIIfqdJJZDiine2of12V1UILkf0s1bDtm5c3+P+0zw13jvM+vKvY1TzngGUuhGaxBh/S1CfU4VGDn6Qof17eanRKx5J9u9bpsbPXLP6L9djHiTSdguyrOgbJIZ218g3hip5ctZZea/tWoyZOjICgParFON7kY1KyCbY3NqzlVvqq/r5SyvhcEuE/knODl3Z6WiPbBMpZaEY41Mddop9YZkyfnuVUarKl2o9hN3bUAPL7GhW+6OZxBupjCGxUuhZ+U36hDeChWxbjbMRoMFwPS4MOQh+seAqrtL3+i5e/p2vdZ/mA49HHhIqeH1WnryAtMlZkc4FIgqw3nLB8fIczBgorHtZsUfJn9E8Qjk/vc6c+cf4w54jh4FG1i4aGsBXNzgq+uGrMrNjJOHlT7zTz/p5Cb4iss8DLgudflE2nlWxzVzwDEgKiF+7VGq10Hec7rjjG0pRvmIQrYSVkauoSHWN0CbNf2K0k3v97ybK8mL7xdjGCepKw33ur1n2gNjvEpCHpK+Qm2BLg9okRluK+Ojeu8e0Y2vE1Hw7oLXxgz4ErcNkrVIk6gyB/Vlmh2brnRSSLNGjD6i0B0P8G/Y6g5lYgD1HdMg5LR6l7YH7SWR1jTKg6BvW/Lluw6ymZdVHqQa/+jy1osVSKvj/6N5ksMFGmiLo/7OoRcLh+wKso9TBVIkANupgvE14kKmuxm5fMb5lKKipI1TQVxWqIQhmtW0cuksbE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199015)(86362001)(2616005)(186003)(26005)(36756003)(4326008)(8676002)(66556008)(66946007)(53546011)(66476007)(31696002)(41300700001)(6512007)(4744005)(7416002)(6666004)(478600001)(6636002)(6506007)(110136005)(316002)(38100700002)(6486002)(7406005)(2906002)(5660300002)(83380400001)(8936002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFRydjQ0dlRXOGloaGZ0NXltLzJTMkE5NFhPczJjVnpaVHFxcXIvTTdUTDBG?=
 =?utf-8?B?TmI2ZG5SbUc5OEVCSWdUWCswQWJOeFRJMDRyVHo5d2hwRHhRWDFIeTB5d0JX?=
 =?utf-8?B?NjdNWEdHc3hBajFhcFF0WHVZSXowSGdFNEY1K0xwdnJZbXNEMnNRalN3R2Rk?=
 =?utf-8?B?dExqR1B3aGhmenk2R0hkN3lZSkE0cXlSZXdjMkM2WEVRMnN1L3VBZTN0SkRk?=
 =?utf-8?B?eWM1dVI3aGdhWmNIK0VVb2pjOFhGK3paeEN5Y0NDMm9FRVIrc0wyZnplZjVl?=
 =?utf-8?B?a3h0SDVCM1ltUXlIVHJMQUtTUjdXSFczcmErRE1MTy94NlhqWkNwOFRvdmw3?=
 =?utf-8?B?RU5TSHQzdU9pSHJHbnBFbjdrd2hUbUhiM2NFWko3WmNuS0R2TjM5eE1sNmhM?=
 =?utf-8?B?dzNMMEpEYTZnYTBUZ2N5c2EvRmNraVY5TzdhOHpRU2dWQjk3Y2Y4amkxcVo0?=
 =?utf-8?B?dzBKc0FmelpmbzhlNFlYOXNTZGZtTTd4bDRVZ2RYMjA4OUtwYnA4bEgxL0xM?=
 =?utf-8?B?bFpnZjBSbVlQQmxQcFRmSTFMTWwxVTlMTjVNcHBrVWtrRWdlRHBwMTM5YlhP?=
 =?utf-8?B?TnZPbUsxRWl0QzUyMy85RmtVTTRHV29tSDVxall1OTJHemtoYndJbUdIazZj?=
 =?utf-8?B?WlFPdVlsR2QrTmZqc1BzTG9DZmZXd0Z3R3FUUHVkd3VySkhpWEJORnQ0L3hO?=
 =?utf-8?B?NGFxZ0xwOHlibVBHajllS3Q0SXpjNTVKa2tTa3VXUDYzQXZtanJrajk2emN1?=
 =?utf-8?B?UWJUelpmcjgvRjZsWUQ2V2NjbkpXYUlmM3dTMUlVNURBaXJNV1NtNXVLOGk0?=
 =?utf-8?B?WHA2UG9MV0daTzFmUEV3ZHZMRHRIT0V4Slp5U3kyYk9WRUR6TUIxTEtxbTEr?=
 =?utf-8?B?S0xNbmxQdWV0VGFtOThsT2NldmNUZ0pUaStaVUN5Qjk3bjEzR09jYyt3QlFo?=
 =?utf-8?B?UzA4OUpUMjA3cTh0R2tpMkF6VFdjUExvOXE3MURkOTNGSEN6alRFeVpTdzVO?=
 =?utf-8?B?dEtJSjU1c2IvRXFGV0plUVAxTHhoSU03dEpEY1lUYmxxUVlGKzJMY1IycUJn?=
 =?utf-8?B?WUpmL3FPdDBjbjhMdzRnNXVSNUp0WFRJN3RWdnJGMlE1RGlPeExYYVdqS1lI?=
 =?utf-8?B?WjdUWUhaVFNpWDhjNUVsS1NqWDdLbWx5WW5pVVdHNTR1Q21ZYm5wTUd1SW12?=
 =?utf-8?B?aUMrZDQyNWtlaTJ4QURReUQzNGJacW1XWElHVER6MTN1a2JiSndBTnV6NXBP?=
 =?utf-8?B?YXFLN0IvaXByVVFNd25kTzRId2JSSVlOZHA2WllZcUNWK3VWSllJakFaV0Nt?=
 =?utf-8?B?bXdORlBXY2tjL1NYQ095OTZ5dWtXUjNFWllOTHRqOHpvcExjaXVUQmZXbDRk?=
 =?utf-8?B?VFhuWm1tMzFMbzZmWWZ6T3VDd1h6RG1WUlJvTVJIOHlhK241Mi92amt2WTNZ?=
 =?utf-8?B?Y0tYcW53cjJpOHdVM3ZhTlBRRjZ0OEw4dVZweXhwZmxtalZ1NVRxRUQ5Z0pk?=
 =?utf-8?B?RHhIQy9uYU5LNG9uY2w3TmZJMHlqbHBhTXFYbzRFV2RBNUVUaDVqVEl6OEIw?=
 =?utf-8?B?U2pOcnpwbVlQMG85czBleDhTT1R1ZUFwUERpb09Md0krQ0trTkhjOU5Ga3d5?=
 =?utf-8?B?ZEtVbHl2WVU2ME1CUjFSUU9nL0UvVUE4NjNSN0FYcHFCOG42UU9LQWgzREJN?=
 =?utf-8?B?eGdIMkg1MCsxeUVYZm1mZ1FhTzhnakYxWk1US2s5b2ZUYUhEMnhkWjdhSGN4?=
 =?utf-8?B?QW5ieVZhUU42OXJ0RnZxTTFCdEFrcmlkNUdVbXoyVERmSk84Sy9qYW9POS9y?=
 =?utf-8?B?SDdjSnBjUlpWemZLYnR4SVRiRnFjUlhwSkQvWlZ3YkkzeXNaMVI2NVRRY3ov?=
 =?utf-8?B?RzdSMlhtdkVuTTI3ZzdVSGtENnlwMU11d1hsdlJKRy9VYmdHM1IxTjllMHUy?=
 =?utf-8?B?bHdjUWxweW1VcjZJYWVCRHdqcmpTNWdjV20rbUJ3dGMwa3AvdVZVbDV3KzM1?=
 =?utf-8?B?eUpUZlhsNTUrTi9KK0xaa2NBVkxRSjZTR3VYY2N0UllBR25MczVyNHhvNk9l?=
 =?utf-8?B?cWFhdnI0b1h0WGVUckozV0VsV3ZNOTY2S3ZmYTNxUnBmY0FLUUhBcXp4Q013?=
 =?utf-8?Q?v4klIc+u998OjkFeqwHHKpzEj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e76a7f86-e9c0-4a26-d607-08dafa6b2178
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 22:18:45.9483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afhsZLqjDPcvOc3iRwAcJZ/hrzjFh8di3KrNZCFEBhN7PnbJ2+ajbndshX1JOqVOq7oykPTUo0I42htMLRLWfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5974
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Dionna,

Do you also have other updates to this patch with regard to review 
comments from Dov ?

Thanks,
Ashish

On 1/19/2023 12:49 PM, Dionna Amalie Glaze wrote:
>> +
>> +       /* Page-align the length */
>> +       length = (params.certs_len + PAGE_SIZE - 1) & PAGE_MASK;
>> +
> 
> I believe Ashish wanted this to be PAGE_ALIGN(params.certs_len)
> 
