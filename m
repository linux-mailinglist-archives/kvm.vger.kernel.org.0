Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2354A7976B0
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjIGQOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbjIGQOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:14:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19EB2D52;
        Thu,  7 Sep 2023 08:51:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZWkS2ZbZZVadP9Kd/ek3VNNpj3r3RXGflvWFVExbIqRXsQr9Vzf67GD1rhnv5c0MULbKYv3gVM/zNMzSm51PVRDKmI3KDvEu6hGTBHx7+mtUN+iuX7CnUjZNCFkECRyaIIsz1qglodLDrq4poM7RHsmLjAiIouNmMvAEtJlJqK4cLrURfG5eXe6hDoEaqgV14X/WO3JDbagdhkQbrPI+9WMHHK9GoBXXqjG6GQfHiisQ5HBNa5qvP8Nqg6RhZHH2oYSMQ81F6Slyh1NMInfkRjEbuhYzYsQTNe8xyNdnGNNa3nYh+VQpPXYhDm4MjhNnzCW4yfno1/yJAYapXAJgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYWjHRkwlu/BFY3LNZPdrNtx8ypbk4Yila7LEHB7WTs=;
 b=FqVMXwjiAQjnIbK0RAz59qwGas9Ob2kmd9iqGVvUhHNoqnvKuWPIjHGsv5kNaUl52zo5aKHr4Iob1nxd138yMicscbp8oFIULR2b3qhPjjLteUOa74TkkquyrmbSMHN8I/CbCkCKLqlF1qCB7ixJMCJ4GDZd/gRJXY45RqrdFrv/VLr6poAAMFN/00RjzY/gmyGG/qg3fTpn239bxKB89ddOvi/6PkY0HnIqWEDWcvLXWkcCL0iNra1sFqGLZQH2GhhLRD4LfJUyLTS9XsJsbL3OYC3WnJTR5zEDzZ1Z7BRKg7ZA0DW2VpzE0ToM2qOtI58x4ixLIyqoqZlrVsf89A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYWjHRkwlu/BFY3LNZPdrNtx8ypbk4Yila7LEHB7WTs=;
 b=civKQIBueI/m4FTJca1a70N/wcGHsnCvOm9kGORWFMRb9aEDmLT5Pv5W4i0oJdu+pUTXlJt6k6i1pnWpmqBUBTRCXgNTZmbHsqToDSFN4N9uVsKUE5nZsKEoxnkXw3L1i9/pMu4NHFLZ6jBOJOWaWM+dN3HPy1yHAAo5lckd+UY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6768.30; Thu, 7 Sep 2023 15:50:06 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::6f26:6cea:cd82:df23]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::6f26:6cea:cd82:df23%3]) with mapi id 15.20.6745.034; Thu, 7 Sep 2023
 15:50:06 +0000
Message-ID: <188f7a79-ad47-eddd-a185-174e0970ad22@amd.com>
Date:   Thu, 7 Sep 2023 21:19:51 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 00/13] Implement support for IBS virtualization
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org, seanjc@google.com, linux-doc@vger.kernel.org,
        linux-perf-users@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, bp@alien8.de, santosh.shukla@amd.com,
        ravi.bangoria@amd.com, thomas.lendacky@amd.com, nikunj@amd.com
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230905154744.GB28379@noisy.programming.kicks-ass.net>
 <012c9897-51d7-87d3-e0e5-3856fa9644e5@amd.com>
 <20230906195619.GD28278@noisy.programming.kicks-ass.net>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20230906195619.GD28278@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0157.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::19) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|DM6PR12MB4265:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ef0fc6-113c-4061-582b-08dbafba1b42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +jPFkNNK0gtIxTzDU6amgB8mx6euHRBeirxzzwfSmmtf72FzJcvTz48fXkDiFCrXoKJgFs3+ceUoxQnBrI6KCDUQ3dIkANiRfUEmxNNLxGYG4BsGtws9ZieoAn0A7M90DDKk+jGzDK+SeObeJ+8gpha8PgMR0090PCO8eaFNGrzuTFAh50zb2oNiY6pSQMoxG4e40aVmXWZJrKAYXuUQmyU9R27FwxV88hWVJ34tUmewtdasY2S2jsbXDoAdNDT3hkqhAodFTwEGCiGU28c7AP5eGcshszudP+lGpgCgiNca7CY0M1jtA93hBGY9e0f5uYO4CLjnnRWE+qgK/FOOIu/iSBYs81mIN4kO8tO2En5Rxxargnng+MPgFpCt88xCVUpAfni9wQIikmIdFWBMDSr+pU19XPFdVeEqY4XcDS4R6VgT6C1LBezhCgd2qV90B64uvvTb6A/dQvFYB0jfSJcZWRtWf4pqN3YYCEot8rsGoUXVRZ+H0GrY+Ia1f4hQWWj+JtbJjOnig4QNWBK3mVuALH+uyjbPUrKB22h2x8R8bIUKBYiBhxgSVp2FcV+vscEFUzv03CD07SWeG3445BC8bneNdw7ELK7AsnG+XaD9LUBNsUGkbVReri28YmwgHBMQU75n8fLK0shdTWWvpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(376002)(136003)(39860400002)(186009)(1800799009)(451199024)(4326008)(5660300002)(8936002)(8676002)(41300700001)(66556008)(66476007)(66946007)(44832011)(31686004)(316002)(6916009)(2906002)(38100700002)(83380400001)(6512007)(53546011)(2616005)(26005)(86362001)(31696002)(36756003)(478600001)(6506007)(6486002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzdDb1QvZ0RjTnNKUUF0VG45VTIrWlNVVUlRRThTR3M5OW9NbzE4Uyt3QXVL?=
 =?utf-8?B?dUk2VzMxZFh3Q0ZRbE9rSTU5SGlTK2s3eGRtN0dGWEk1MVNhS1oyY3NWR29X?=
 =?utf-8?B?NkpNejBndksxWWUvNHBMUkxrYmZmRzMyZ0MvYmlHOWN4UFdKa2p0aWVVMGcx?=
 =?utf-8?B?SUt0bDBteThMTWt5M3hxVU8zTTBxbThGRURPS1U1VjEvZE0zb2lqOTZRa0pG?=
 =?utf-8?B?bzVVSTc3TjRkU09ReXJtaGRTaHdadTFVOVcwWkJpcXJHazVjaVZ5QlQ5S3Qr?=
 =?utf-8?B?QU9pNHUxamxxZEg0WmpVLzJ3ekNNVUpKVkZMbXBodlV0QWVxaE9KbmxDM0ZI?=
 =?utf-8?B?anY4OExSLzFZLytxQjRMRTYyeURBck5zYy9kbU5tUUJxZWJNdk5rbWNoR0Nh?=
 =?utf-8?B?VTVUVDZwcWpNcnY2YU9wS3ZyYlExRDNLVVVLbFY1ejZadzFEMW9HT3Bqa3Vy?=
 =?utf-8?B?c0d2Q09zVnZJRzFldFZnV3QrbnphMXpUYzhueGdROWRTZ1h0QW5Hc2duM3dI?=
 =?utf-8?B?OTA4U2VCSS9zMjRNRUpIa1lpWkkwdFo4eEE3amxpMCtlNzNLRndQdGNoMjUw?=
 =?utf-8?B?Q1U4dDIwdUtkOTcrb0hWRm81Y0E3VTRabUJCOStkdHUxT29kQmJDOFFTTmFk?=
 =?utf-8?B?QkMwN1pHL1duOWZ6dHZXQjB4UytiS3NuUzNjRVRMMjM2eGNUNU1hVnI0a25S?=
 =?utf-8?B?OXZMOUM2MjEvWVFrTm5RS1hweXdLTU1rMDFLcjlyZTMvS0I3WEhkbDZJQVRB?=
 =?utf-8?B?RU9uQ09lNGVPRm1Ndy9yQkNacTBwR2l1VXArb2dJcktZazV0cUZTdjZ0cWtv?=
 =?utf-8?B?YWM1ZjRxVEZNejhYbmFrZnQrc3I0VGhXK3RNRkF0YXZRQkJ3VkdycC90VCt5?=
 =?utf-8?B?azN5UTVsOGQ0d0xpaVdFMVM1YjNaQTdUZ0xJOFluOFhXaXo3OHNrWncvUnp2?=
 =?utf-8?B?aDF5V2FaaFhPTkdnOVVXL2NGek5pMUNtcHh2TkFiQWhKMnl4cGtZTCsvamp3?=
 =?utf-8?B?QXlzeWNwYURXZ3NWZUY4WGlKbTk0RkxTQ2lNa3FITWtMeE15Tm9CWU5TdC95?=
 =?utf-8?B?WXk5MDg1eE9hY2JKSGxnZ1JzZDM5L2pacUZRZmtqV21IaHFKRWF1dlhFekFs?=
 =?utf-8?B?RDV3Q3g3a1hrNDRDQ1VNT001dU5Wd05iTnhhZlVQaHBRRjR0N2xqcWJUTmE4?=
 =?utf-8?B?M29xU0s1bVBuN2FjaUpnY3NsaGR0L0RyZUJJQTVqWG1wM2RBRXEyanhIdXNl?=
 =?utf-8?B?ckF0S25OakpCTnNsMUtTVGlHeFVSQzN2WWIzQmhhR3N4TEVNaEtaS2VEWFph?=
 =?utf-8?B?aWN1NmpMTVh1UG56dm5CWkN3NGtMZnhvWm12aVR5SmJwQW1sTFBRL1E5Nmtm?=
 =?utf-8?B?emJhK1Q5MXVxSitQbWU0RmhqWGU4STNlS2N5MmRQN3FxNVVCUzN1OXlOK1Vs?=
 =?utf-8?B?VjE4R01HYmxtS3hjcjhGcWNxbVJicnExZzk4bEp3UEZ0N1Ewa1RpTitobmVN?=
 =?utf-8?B?RUdWMFZDL2JWMEVYSjRWUXdqUE5XSUdDVy9iVDVEN3E0NkloRDJUOUxwRXVj?=
 =?utf-8?B?UVVSaVk0d3NTaW0xZFRhQlRUSVVOK3ZaK0xSdlR1THZIN3FsZysvaEN2b2xZ?=
 =?utf-8?B?bVByS3BCWlBsa3ZhUjBXSWtCN2tFYllKeitvL3lzT3lTd21KVkpva1hSSlcr?=
 =?utf-8?B?MmJuWExQQ29ldXlLU1ptay90WVNzY2FLTXJuU0ZxazV5TzMyUVRCZkwvaEx0?=
 =?utf-8?B?d21DT1ZEeHhzZWNxU2pNNXNkRnZiY2MrYjBkd0tpamFnQ1IvRkZCbVZiM1l5?=
 =?utf-8?B?N1c4MXlnSTJVcTd1Wi9Jc2huNUJKTmp5YzROS3lTeGxZZTVaZGZqUnA2cTBm?=
 =?utf-8?B?M0d1SHFUekpOdUdLVE1MWjNEMXcyVmEvVTJYcmpBdFpzWGZPMVQwZ2g0ZXFR?=
 =?utf-8?B?VHdZWG5hRVFuckdUZlh4NHlteGh5OUVybnhyaUtuQkJOTGRnWE00bzdnMDFm?=
 =?utf-8?B?NzlFZkc2ek9Md3BVazRua0Y5aU1qSXIwTG1iTm9PaFIvbTBnV2p2V1Z0aUxr?=
 =?utf-8?B?ZzIwTUExdVg3YWNZQTh4U2tmZnc2T3hCUndiVUszRzEzY2ZDczN3TUNFNlF2?=
 =?utf-8?Q?7PAKhSUIheEBPGI4AAaUNTsgn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ef0fc6-113c-4061-582b-08dbafba1b42
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 15:50:06.3673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RQEc7v8rco+30TUwdpO0LwCXXoBchN6rioMn/mOXkzsyxwABVoPJIfymL08txBg6C+JNzpKgOKbi82+OJ437Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4265
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 9/7/2023 1:26 AM, Peter Zijlstra wrote:
> On Wed, Sep 06, 2023 at 09:08:25PM +0530, Manali Shukla wrote:
>> Hi Peter,
>>
>> Thank you for looking into this.
>>
>> On 9/5/2023 9:17 PM, Peter Zijlstra wrote:
>>> On Mon, Sep 04, 2023 at 09:53:34AM +0000, Manali Shukla wrote:
>>>
>>>> Note that, since IBS registers are swap type C [2], the hypervisor is
>>>> responsible for saving and restoring of IBS host state. Hypervisor
>>>> does so only when IBS is active on the host to avoid unnecessary
>>>> rdmsrs/wrmsrs. Hypervisor needs to disable host IBS before saving the
>>>> state and enter the guest. After a guest exit, the hypervisor needs to
>>>> restore host IBS state and re-enable IBS.
>>>
>>> Why do you think it is OK for a guest to disable the host IBS when
>>> entering a guest? Perhaps the host was wanting to profile the guest.
>>>
>>
>> 1. Since IBS registers are of swap type C [1], only guest state is saved
>> and restored by the hardware. Host state needs to be saved and restored by
>> hypervisor. In order to save IBS registers correctly, IBS needs to be
>> disabled before saving the IBS registers.
>>
>> 2. As per APM [2],
>> "When a VMRUN is executed to an SEV-ES guest with IBS virtualization enabled, the
>> IbsFetchCtl[IbsFetchEn] and IbsOpCtl[IbsOpEn] MSR bits must be 0. If either of 
>> these bits are not 0, the VMRUN will fail with a VMEXIT_INVALID error code."
>> This is enforced by hardware on SEV-ES guests when VIBS is enabled on SEV-ES
>> guests.
> 
> I'm not sure I'm fluent in virt speak (in fact, I'm sure I'm not). Is
> the above saying that a host can never IBS profile a guest?

Host can profile a guest with IBS if VIBS is disabled for the guest. This is
the default behavior. Host can not profile guest if VIBS is enabled for guest.

> 
> Does the current IBS thing assert perf_event_attr::exclude_guest is set?

Unlike AMD core pmu, IBS doesn't have Host/Guest filtering capability, thus
perf_event_open() fails if exclude_guest is set for an IBS event.

> 
> I can't quickly find anything :-(

Thank you,
Manali

