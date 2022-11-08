Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161B2621F83
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 23:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiKHWsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 17:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKHWsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 17:48:22 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AE464A1F;
        Tue,  8 Nov 2022 14:48:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fj9pbWlHLQmYLSG7h/e3jAEFVH6Jzp+CCAtdFs+62SHLd67LZK0tYG3FdqGae/CgK0evRRaAZmju+aqXZUjlpA6c8EwQ1TL61BLUHrFIb1guCmBUeNpMRwgNVz/llxykHmUkelw6h9B0lirFziETEFKmnQS3a0GOV+UHjmpR2ObLLbgeV/kjy17f4m52AVsYm0ScfV8tdCsiKF75y7CNWk/6hHTi3YbJ6IhyFKME88a4dUZgVa6cwSbGarbxmd0ushph6Tjw0FseOii+jXFJ0BbVQUvtWjwK1N5zHlfvKlwkczZVtek0eAwDuEuAxpAkfCMfub4rFD9BGHPWhUuTmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/Jx34ECwwWQHLbUbXYSYxvvpWsiHRDpsjjdt/eia5s=;
 b=O96ack4F9L38hLEPneFabKwy7FKB2XuF6HIjGTh1Ow892CsmLj0EZlb4VJUyW06xVjEzUAOyMlnJf3BkrAokL9+tFQWh7+uV6abyjbNrPMwQIpQW1PC5KvKWw+lfOLmQDNxDBTEWPSyi+UVWkkWZo2QoeBioSGj6MtcgGq2v6pED1HrbaaIeCjK/9XV8poTOiYiWfCV65Y2AYv47+949NHurQKRpsuHpIyfMT5xlQwipwCW8Dtt9g/Vdeycf3hPYc952z4EC9lcAXz4JUd+G+o569fZxKly4XAsduahaA0ZkZgdenAa29yVdOsgGnQONgSmAQbwXVCb40lhSnkJmbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/Jx34ECwwWQHLbUbXYSYxvvpWsiHRDpsjjdt/eia5s=;
 b=SYxZZzgfivV/Zny/SMX4VXgNB2QTVKFl8zhS0k3MJwEzEHLV1c8h19zeT1scS/lOgFd/oZ/VKVYHx6j8JKvJVlWcxKi3GrbDJVio0Us+/uNjc0g3BimMb/9A/gr41xFVOmfwfw8k+QPrO6VYN+ngNpByXv0OA0x1Cn9jM91+YgQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 DM4PR12MB6541.namprd12.prod.outlook.com (2603:10b6:8:88::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Tue, 8 Nov 2022 22:48:19 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c%3]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 22:48:19 +0000
Message-ID: <4c8945ae-62c4-7550-dc75-068cca99e678@amd.com>
Date:   Tue, 8 Nov 2022 16:48:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 3/3] x86/speculation: Support Automatic IBRS under
 virtualization
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-4-kim.phillips@amd.com>
 <CALMp9eSpKGCYK_1r3o326ui5RVoH73_RR5-LR2Div9Jm5zvk6A@mail.gmail.com>
 <f25152d2-7045-94f4-d5dc-69b609c0be6a@amd.com>
 <CALMp9eQF7iPXCNkafmaGHY5Dzg+opt0xp+Y8ceML8RTxFyCo7A@mail.gmail.com>
From:   Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <CALMp9eQF7iPXCNkafmaGHY5Dzg+opt0xp+Y8ceML8RTxFyCo7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:806:21::20) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|DM4PR12MB6541:EE_
X-MS-Office365-Filtering-Correlation-Id: 104dc1f7-87d2-4d83-7c2d-08dac1db54ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /kgUeDa0IUqXuCYRgRU3QjHKb19iRzicC2MgTiElbNMG8xgnTMYcxefy2JN8lNYy6XjtnFfgryQ1CqiTOqTSewO4262nDvVTIMA1RJF42zja/z7/uGcB+kXAnx8+cF+8ovAf+2umPAjIw/EdiIUaNJjpou/VB5mgnnlVk0SXb6BLKBCrd8oJd+nvQ7U7gWGyOsvnH58MifXtwS3vL7rraT1glWleuN0MgvlWMqukgcqru7lj6dU4SKxaunLh0Xh0XO0uxiCtqvT+K0XizLBpnCbJ8fH3EsuElKNMQeItXq1oPoUOLCHpm0p58pw55zYAV7jIFHccezzWje53l4vb3/kSHOhlCB5WTwWTyedvV3/mT74LYqmOYs6ZoOFLAf+tLORDQNmW6uUTzITnj0oc6ocwB1vUBj/yLcC7OE07dK99vi4YUoMfWrge1+KAg5/5VuBvYZomVyWx4ABck6i6EJYgANJhOk3P9Ub/nyRHLtLXS+hp7cxxTPIf0eqk+yLmGZMFO+Yt2bZntCs2j0qGGigg2prxQf4chMW6R4CW9IB1MCEcXJvi5cfZUWFvFTRQ5RPRa0hFwEpwHlae6OW9+4wDwNyPX3QL0+rtARv53QZDI/mQZLsEAG++Zh4Rvb1oF6akdu9nvVwtu9yHQZaAQTC01bqfnUWjXSppJsCDZJWjYHx8DPsvctbYdjzZQ/3/x8Bl5M1QPST0scoeoQo+KaXtbhvOjy7d/BfIiUf5E+LB4/YV2XuKmE0NVnW/x0x8VuPTlokD7zzTzPSF9GF5svzBsPkHPBxtlt3IEHf59Xo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199015)(6486002)(5660300002)(7416002)(36756003)(478600001)(6666004)(41300700001)(2906002)(44832011)(66556008)(8936002)(66946007)(66476007)(4326008)(6916009)(316002)(8676002)(54906003)(38100700002)(186003)(2616005)(31686004)(86362001)(6506007)(53546011)(36916002)(6512007)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXlpRER0NjZldHZKbFZRaU1vcVhDUWxZaFphL0ZUdzdWeGh2RGhEdlA1Z2Ex?=
 =?utf-8?B?bFdKSmJETFBDU0kvMG1UUDRybjNFcm9rOXIzOUJadkNzelNoZXc2MjIvSnFE?=
 =?utf-8?B?b1BvUzZZbmo5QlhGa0I0cGIrS3BrcU1xb0RTT0c5TlV3U0phazh0OTRCTElP?=
 =?utf-8?B?Vlhaa0FEdE5JVzRKSjlNbU5KaXF2NjB2Ym1Ub05oR25CTWEwRG9lL2JKMFg3?=
 =?utf-8?B?ekVqcVZjMEhIb054cCs4eTlCTXVCUHlIK0t0Y1VrdGVISG42MzRDRzBoWjhC?=
 =?utf-8?B?RGtZZHlubHpHSTM2Z1BuOTF2SUdwUGpuZXdjeFBLQVdwbUZzOEVLajJUOVJu?=
 =?utf-8?B?TGdsUXZmWSt0Qk5rajU2L2hzL2IwMzVmTm4rbzY1VCtvT3JQWW9aUkhxRWdR?=
 =?utf-8?B?S09BeUlyS2p4NDNGd1FHWC9OMkN3V0l1WWNqWDJiRER2UHV1VHF6ZVBMVE9j?=
 =?utf-8?B?bm5MOWNJdFF6QjZLem5WTWxjYW5hOHhmODhac1gzMldCUm9uS1JxMmc4aWZa?=
 =?utf-8?B?R2daTzNzUG44N3ZMV3FCTC84cllzTmI5RTFaRWhpbFpIcGxIWU5MYk9WU0c3?=
 =?utf-8?B?cU5GcFNwdjA0MWpXazg4MjUzRU80Sm45YnJzaEpCQ0x3cmQ2QyszQWVYTkJM?=
 =?utf-8?B?TWlsZzdVMmsxN1BZYmFJS0tpd3dReElzdHU0M0pMMHpVUDlUYkx1eTM3eUEx?=
 =?utf-8?B?SU5zVUswMSsvU1ZpTzVxYkM2V0J2N29vaU1iNndzQjI3NDZWUWJFNjdXSjIy?=
 =?utf-8?B?eDV1NjRJTmJROEY2SFhCbllZaUVtdTFCYmRSajZBbWZDOWYxQnJvUEpEQUly?=
 =?utf-8?B?TnZERXlNWmpIMEI0WmdqVHdXNDl2QTMyc0F6YTZRLzM0dUYyN3YxZXU4aHlC?=
 =?utf-8?B?WnlZSXpZMWJ0TkVqdlBKcllxaDc4SERqemw4S3hKY1k1RFMxelRlT0VocTFa?=
 =?utf-8?B?UVRCbnVEV1QzRUNXZ1NHZlZpb1JKOHBWckVkODFwNGpJUHlRZFBocXNJZTUx?=
 =?utf-8?B?WWFOOEhxZ21nNkR0dDZCTWN5UnJFNko0ak9UK3BkYVEza3ZNWnoxWnl2UGJX?=
 =?utf-8?B?L01hQUlMc2treW4xSXcvckI4eDBVQi9CeW1aRFdlVllpUG5wci9QWDFVbXJ1?=
 =?utf-8?B?RENHblhhWjZKNTd1bGhMa1MvU2IvZi96ZEI0NUZqcjdhYzZ1U2p6bllBMW9X?=
 =?utf-8?B?UklCYlk4Rk9BMWRCeFJDeTYya2VjYmI5TkJzZEFJUExWZ2VKakFodnZ1bTBC?=
 =?utf-8?B?YWhoU3B1U2ErVHB6ZlV3R3p3R0hhQ21wN1FpSktxdVpvYmdPZWErSGN5SGhw?=
 =?utf-8?B?akVxaVRoZ3AvanV2RFBxSkNnaHNBWEV4NG5Mc2FoSXpOTWpDQ2wvV0pmZktB?=
 =?utf-8?B?VkhDTnBZNjIyY2RaVXZGRytXOXBqTVZTampMZDRoR25GYkxEMVJZb3FVUU0x?=
 =?utf-8?B?YjB6ZGtLSEpoTk5ZaGlkMi9Meit6a3RBS1dSelNKVmpUTy9zOU5yUjBzUTc5?=
 =?utf-8?B?QnVhY2loN09lL3BZZHZOcXB3bkxINHltRkpsSmVCZENSNTk4dEQyNlZRNGtB?=
 =?utf-8?B?M2RyZXFlZEx2RzM4MW5BcTZ2YlhGdVIxK0g0bTdueEdyNm5LWkFvWVNVSWZP?=
 =?utf-8?B?cExSNjVKWENCWnRVa2ZBYy9aeEJvNUd1T3J4dkZKT1JVa3ZEa2JLZUhxNWlG?=
 =?utf-8?B?Mk5ubXZOcTdZZlBlMVBnQUJvVFh1b3IvOU9XVFp3Z2VEVmY5WG5SWTBlcmts?=
 =?utf-8?B?bFNjanlNQ1ZMSjJHdEQ3RUlZMVdCV0JZR24xb09ZU3l3NG15Y3FkTnhta0JV?=
 =?utf-8?B?aTFKaVRXS2d6alR3dFlnR2pvbElQeXk5Tm45d0h2MmlKaFJ3YUdTcnZzSmU5?=
 =?utf-8?B?VVE0b1NtazJPeXcrWTJJRHRuOEpLbkpvVDlQZ1RvakdYM2Ftc01OVzdrUVRB?=
 =?utf-8?B?N3pPcVlZclZ3ZmFVTW1QTVVDSldrZ3RzdTljRTlSNE1rUGh0c0hvdUZwZGRr?=
 =?utf-8?B?aEFPRlFPSHh2aFN3dE9UeFIvb3JWTTNXWU9MTWxScWNNTi9wcE1OaVNlcFEv?=
 =?utf-8?B?a2NBYTRxT0NVMnEyMlFZMytVK25qN2h4SmE2SnpHdkVVby9tRUR2OENZdlA2?=
 =?utf-8?B?emV6dkFnaGdIYUo1MjZNdWZGTUlDZnBuejlobjFFRHVYbmpSd1o0UFVRODhE?=
 =?utf-8?Q?wJWAx62ndFRZYS9Vfg6po5ddfXIuQY/t5TiAs8O1BL2M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 104dc1f7-87d2-4d83-7c2d-08dac1db54ac
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 22:48:19.0341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vytip/eyd81I+X+fRNYbphLfKgiMCWB6/lte9ALLzWc2/ywZaZqEgBKP0EPLjjWoMW8PmFSC+9N/0UDtdRt3BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6541
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 4:42 PM, Jim Mattson wrote:
> On Mon, Nov 7, 2022 at 2:29 PM Kim Phillips <kim.phillips@amd.com> wrote:
>>
>> On 11/4/22 5:00 PM, Jim Mattson wrote:
>>> On Fri, Nov 4, 2022 at 2:38 PM Kim Phillips <kim.phillips@amd.com> wrote:
>>>>
>>>> VM Guests may want to use Auto IBRS, so propagate the CPUID to them.
>>>>
>>>> Co-developed-by: Babu Moger <Babu.Moger@amd.com>
>>>> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
>>>
>>> The APM says that, under AutoIBRS, CPL0 processes "have IBRS
>>> protection." I'm taking this to mean only that indirect branches in
>>> CPL0 are not subject to steering from a less privileged predictor
>>> mode. This would imply that indirect branches executed at CPL0 in L1
>>> could potentially be subject to steering by code running at CPL0 in
>>> L2, since L1 and L2 share hardware predictor modes.
>>
>> That's true for AMD processors that don't support Same Mode IBRS, also
>> documented in the APM.
>>
>> Processors that support AutoIBRS also support Same Mode IBRS (see
>> CPUID Fn8000_0008_EBX[IbrsSameMode] (bit 19)).
>>
>>> Fortunately, there is an IBPB when switching VMCBs in svm_vcpu_load().
>>> But it might be worth noting that this is necessary for AutoIBRS to
>>> work (unless it actually isn't).
>>
>> It is needed, but not for kernel/CPL0 code, rather to protect one
>> guest's user-space code from another's.
> 
> The question is whether it's necessary when switching between L1 and
> L2 on the same vCPU of the same VM.
> 
> On the Intel side, this was (erroneously) optimized away in commit
> 5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and
> vmcs02").

Then why hasn't it been reverted?

Does its rationale not make sense?:

     The IBPB is intended to prevent one guest from attacking another, which
     is unnecessary in the nested case as it's the same guest from KVM's
     perspective.

Thanks,

Kim
