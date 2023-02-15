Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1A269855C
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 21:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBOUPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 15:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBOUPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 15:15:53 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1632597E;
        Wed, 15 Feb 2023 12:15:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCAtwNnyKfqpCIuTNpt3Lu5bvNpYWjYMV0PzNmq6WZ0zvPJInaZkNkmpihJ0Mt8XjQdTMjvg8sFF3u2LO9T5crDIVBS+9vzIveuTh6yHyysyZG1wb5Hd0S0KaepXn49WzKGsbqtqa4V+9joWoBjF4FLF1IaPL/zt6246nSOR6WbaLdnsOIiiI4oEgtuuKBPA1Nme3jjrLZaKojCc639YbGnblV0u3uwv2IXc03lCaQkCPfiUSZejODGgKJV+cj+jMMtgAFfRKhgkaYkOHgF4u/XpJ7T4SJrcmmnf8bD93GVFumYq0FmP9s/Bzf9hKyL6uASSLIXCDCKpEByxfpZBKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4RHxLlFyauevz0FHwIOCFf+4+l/z7sVt5I07rOTRPs=;
 b=L77y/hnwTPW+wcTGLD3wQMW9DTF/4kuwaDCtqHun1JWCWotBrZ15140M2NgJf27i/WFo9dWDX1nidFtVBg1+I0vZyE4h73JKmqYk67cvFJAfwcF4loCIbNTkZ++bQyfQAsER8kSN56orEM25gALvK+VMTrkTPzF175bYA8H/RDSq/9z+edTSVYojLbDqoRub4dhXA9WR7gjKYrFbo5xBOYEAHwwqRCSqr2EB3um8T1YcW/kVlicqMJPAtFt9UJr0OIBerxRRFJPRRF/gbYPw6Rp8L5TULK6BurujjgdvwqwU8ag9Wn7M7XgGSK3rk0desaDoEjTxMgZi88Wsmqt61g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4RHxLlFyauevz0FHwIOCFf+4+l/z7sVt5I07rOTRPs=;
 b=xXkCPqlhe3Itc5C/ohDG/xEB87goQHGm6sJv0SVL/UsA2ekq20N3tRmW7asFXYKrSPzRxxRXcXGl//1PNi5e89irsqZXUIxqcpjQWgY38Vi74XJUhTfnc4KM8oxn0S4G21rrKt90X54Mz3RQsEL8aW+GNx2V/5psh6kDM62S2rI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 20:15:50 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 20:15:50 +0000
Message-ID: <86c79601-2d3d-a6d7-a0a5-baba03e00709@amd.com>
Date:   Thu, 16 Feb 2023 03:15:40 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/3] KVM: SVM: Modify AVIC GATag to support max number
 of 512 vCPUs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Joao Martins <joao.m.martins@oracle.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
References: <20230207002156.521736-1-seanjc@google.com>
 <20230207002156.521736-3-seanjc@google.com>
 <20230207093350.5db155ca@imammedo.users.ipa.redhat.com>
 <0e12d654-d388-a0f9-e7f9-7e96921786b7@oracle.com>
 <Y+J+dS8ZRX07kgt7@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <Y+J+dS8ZRX07kgt7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:4:197::19) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|SJ0PR12MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dfa35eb-e3b2-4d8a-bad6-08db0f916e6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m3HIvKwQ1kdJdzwOwNKaql+ft24crWeV5BfflSBo1iiWnfABDK+g88iImFbduEKWd5vbqim0/5ggIp94EjbgEb+0yshK6W8Jdv332j1y5Chqinv21N2i9+hrgVy4Y12Hy84omA3q/J5OGQtLALLeqtzULwxtsL0D7iTCZFpN+YLO+rESKifpWNvW75vq8/g6UPuu3Xm8qJrF7BalrUU0l1OS8BSd0zgspOkr3iuMGn20bW9JyurhQ69ciIsBmbITEAGC5dr2K3BvQO4XIwg1uDJhoJaIDcB2kgug/trEMMzSSt0hgBZ/TrHhtajb4QO5JJswkhQ9NxPDD/KZEpJuyqHmw9bTgUR5w+bqahfSXFGbNvudK68o3aAsGA6wsmeECYDLsD2aqBuLtRJBjuYRb3U3eYK4kqHxLnQIRDSLpz22F+MzRflq2Rrw+co/E3tLTAbJDQ6hH7QrvF/3pnvfreCZaKg1aO+zCdxliICyePGOFVJeyAboFNQk8y4MqHwIj2hKbZaghdb9YuPPIb6xVJPjLfU/4cYTjL/1W0Dx+l44uWJt+M8WgaGKZSkuPrgklQGzvEkFldfW6wtnY27NBj23yCjXeQkRJtNYEJ0EUJBNafkAnOaKrhWqdBHaudEfEYoVTufUVKoaYT5gepI+kbcODCb7CULtvKC2PY8zJdcnhuY5/IZDTD8i432mI+G2GmbnxrIY6hl4Snm66d+g9Z08Jtbeu9geGYWBkkSY3Jg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(451199018)(83380400001)(110136005)(54906003)(478600001)(2616005)(6486002)(53546011)(6506007)(6666004)(36756003)(26005)(186003)(6512007)(38100700002)(41300700001)(5660300002)(86362001)(8936002)(31686004)(31696002)(316002)(4326008)(66476007)(66946007)(66556008)(2906002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDVMMXNGYmxoUWdKb1FWUDNoRTJYM1ZZWUFoaEMrTENEN3Vtd2gvdDE3SUFr?=
 =?utf-8?B?cEtqZUtpbjdXa3haeHB4emM1bTNoSDlmaXJRSUREaCtraGFIaHRXMjJPdXhT?=
 =?utf-8?B?N3I0L085QlB6d2dSM2w3bWV2U0N6cFBvV1NpRERMMmRWdVkwcmwwVm10eFpl?=
 =?utf-8?B?R1orS1VFSGpWVjVJd3o2Mkxpd0VPNlJ3Z053U2ZWQ3gyckt1K0pYbEU1aHZQ?=
 =?utf-8?B?U3RIa2c4Z3dvMkN6eHlBaVdyRnBrU0VRL2YvRmNPWTZKdG5rL3F2dXhkNFQy?=
 =?utf-8?B?YW5jWGFIaTc1WmZWR2gzUTJ6OXR5NWVNc3JHV1pKVUFjQW1Pa0NuMitaTEU5?=
 =?utf-8?B?MGVadS9UaDRRNGtkVG9RS216WCsvaXhtanZEZkdiVjY3Mk5qZ3U5VlA3Sktk?=
 =?utf-8?B?S3RlSkFNd01Ea1hOYkxYdVA2YkhuY3V2eDgrTmhzWld1QzBmTmZGVlhoYTk4?=
 =?utf-8?B?WkVHbUN0ZjdRem50SFNyUEkraVp0d2RXWFFkVDdiY3hqZ2VtY2R0UUVTN204?=
 =?utf-8?B?VFR3bG1NdmIwc0pyQ2RCd1M4bDdBWUw2ZWlQeFlVc3hPZ0d2WGtubE8xUEFh?=
 =?utf-8?B?MTh6WGZKTmZjTUtlaW5VTW5hNFlmeEdOanhUTXV5T2l6U1ZXNXVOOXFOREZr?=
 =?utf-8?B?bFJOci9UbVNMR1Azd1FtcE4yd3RuZmVyeCs2U21wV1krN2xjYUdyL0JlRHhL?=
 =?utf-8?B?R2l3dktYRFA3VjN5VHYyTnBtSVFDaGwrTHpjajFES2xvdWdtN3NwQjh2VUZT?=
 =?utf-8?B?NmIzWldhaUdGRitNYVh0aC8rM2x1cnpPei91ZENQS1NiSWZWZ0dmWWw4R2Fs?=
 =?utf-8?B?REFJUE5xTFZ5aUpJZ3dnQlVnek4waWV2dXRiWGtPZUJudVk0VWV5TXlwMFgy?=
 =?utf-8?B?Ti9YWFZUUWtueTNuRkZUcFdxb2tHNnBzMzk5RjBmQmlzcUxlMnMwWHlnV3hP?=
 =?utf-8?B?bTJtMW51YjgweUZlOXNwbTVYdjNSOTlCZVdBLzg4N2FJV2gzV3lhQXBCWDhm?=
 =?utf-8?B?cXhpRFpTT0hwdGc5TEpoRUVzQkVybU1Gb3ZhRzdkdUxVQ3ZxM2FIMHNpK1lK?=
 =?utf-8?B?WkZzb2ZPc2ZhNitCS1hrWmdIbkJKeXlsQjZKbFZsMGkzZUtjTWJzVm93MFhO?=
 =?utf-8?B?TEVJV2FTZ2hSWHNWN09jREl2TUVFTFRTdDI3SzVtOEY5c09MUHlmL3VUWTJI?=
 =?utf-8?B?YWsyejV5ZDMyLzZBaTV1VGJ2RnRSVU1SNWNLWXd4cm82ZmUzZmh6N2NrdGR1?=
 =?utf-8?B?aFJxdUtPKzJFYmkzVkJ1Q0RIaDEvMHBFaTU1ZDVpcEZ0R0dFVDNtNWNtYzRj?=
 =?utf-8?B?Uk9COGhiN3p2UWwzd2FhU0ZiWUJHaTNScFA2T1hpNm96QTNuckdjSlR4dUkx?=
 =?utf-8?B?dHYwMjltUzgyOHdENUpFL0FZZlZiQldxNkQ1TkNsWDhaajJBVG9Hdzc1MTNX?=
 =?utf-8?B?QnNzeEV6ZmRVbUM3Yk9sMlFQUUc1SkVvS2Zta1dIaE1RNGoyb2ZYQjBwVCsz?=
 =?utf-8?B?dUptVDgxMWRyaU5WY0RiRDRaRHVVRmF0TzhORE1qbG9UMXpiNm54TUJnR3hj?=
 =?utf-8?B?V09Ka29uV0lMWWp6bXdxQVZpbUNPdC9VNXVvQUFvTGc0R2UxbFV0WTF4K1dZ?=
 =?utf-8?B?OWdSYmg1VU9ramxZSUlsTkk1SFpmSVBxdU9sKzd3RjBjK0h5bGFpMFhaSWdU?=
 =?utf-8?B?SGFsejR1ZWlWVE1IeVNWNjR3NlE5dGFCZzJiVmNHdEFITWR2RUw2M3J3ZXc3?=
 =?utf-8?B?UmY2YWpUZW9VanlPdmZnYk5MZFpJVWUvY3BqMEJYOWtLNForblZWTWhKTzRS?=
 =?utf-8?B?NEhMcDdjMHF5MVlnRWRsenZsQ3hpcDhEcVFRSDErRW1PbjNpMDdtZjhXS2JG?=
 =?utf-8?B?WmVIOHo5WEpieHVyOGlWWUtIVTRYQzM1UTZ1QmZibXg0MTFlN3A5cVN3NUNw?=
 =?utf-8?B?UzFDVnEzVmlHRlJ3VEw2ektNZXJoSFBXV2RVT2QzVFhFNiswVWQwbmVraHcx?=
 =?utf-8?B?dDNXMndYMVBiWWJvYW5DUmJhK3ZRTytzamQwdC94MFpCbDVub0o4Sm1PYjB5?=
 =?utf-8?B?N0tvQjYrT1dESnNmSjh5Nm1IL2RyOVpTMEcyeEFuTEJBMkdCQ3A4d3lHZkV4?=
 =?utf-8?Q?zu/VCEB//Ezyt70cuH3hbtl8W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfa35eb-e3b2-4d8a-bad6-08db0f916e6e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 20:15:50.4054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FIEebas+jTdAfGSXa/EbtxcTyUYsp/2yQFp+ryhPreHvSMO7P8VSKjYnb40kmMHXRMayY24xgrXiWV2Q8vaK4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/2023 11:38 PM, Sean Christopherson wrote:
> On Tue, Feb 07, 2023, Joao Martins wrote:
>> On 07/02/2023 08:33, Igor Mammedov wrote:
>>> On Tue,  7 Feb 2023 00:21:55 +0000
>>> Sean Christopherson <seanjc@google.com> wrote:
>>>
>>>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>>>
>>>> Define AVIC_VCPU_ID_MASK based on AVIC_PHYSICAL_MAX_INDEX, i.e. the mask
>>>> that effectively controls the largest guest physical APIC ID supported by
>>>> x2AVIC, instead of hardcoding the number of bits to 8 (and the number of
>>>> VM bits to 24).
>>>
>>> Is there any particular reason not to tie it to max supported by KVM
>>> KVM_MAX_VCPU_IDS?
>>>
>>> Another question:
>>>   will guest fail to start when configured with more than 512 vCPUs
>>>   or it will start broken?
>>>
>>
>> I think the problem is not so much the GATag (which can really be anything at
>> the resolution you want). It's more of an SVM limit AIUI. Provided you can't
>> have GATAgs if you don't have guest-mode/AVIC active, then makes sense have the
>> same limit on both.

Correct.

> Yep.  The physical ID table, which is needed to achieve full AVIC benefits for a
> vCPU, is a single 4KiB page that holds 512 64-bit entries.  AIUI, the GATag is
> used if and only if the interrupt target is in the physical ID table, so using
> more GATag bits for vCPU ID is pointless.

Correct.

>> SVM seems to be limited to 256 vcpus in xAPIC mode or 512 vcpus in x2APIC
>> mode[0]. IIUC You actually won't be able to create guests with more than
>> 512vcpus as KVM bound checks those max limits very early in the vCPU init (see
>> avic_init_vcpu()). I guess the alternative would an AVIC inhibit if vCPU count
>> goes beyond those limits -- probably a must have once avic flips to 1 by default
>> like Intel.
> 
> I don't _think_ KVM would have to explicitly inhibit AVIC.  I believe the fallout
> would be that vCPUs >= 512 would simply not be eligible for virtual interrupt
> delivery, e.g. KVM would get a "Invalid Target in IPI" exit.  I haven't dug into
> the IOMMU side of things though, so it's possible something in that world would
> necessitate disabling (x2)AVIC.

SVM-AVIC is independent of the IOMMU-AVIC. We can enable SVM-AVIC, and 
use the legacy IOMMU interrupt remapping mode IRTE[GuestMode]=0.
However, I have not explored the case of combining of the two modes. I 
can look into it and experiment with this case.

Thanks,
Suravee

>> [0] in APM Volume 2 15.29.4.3 Physical Address Pointer Restrictions,
>>
>> * All the addresses point to 4-Kbyte aligned data structures. Bits 11:0 are
>> reserved (except for offset 0F8h) and should be set to zero. The lower 8 bits of
>> offset 0F8h are used for the field AVIC_PHYSICAL_MAX_INDEX. VMRUN fails with
>> #VMEXIT(VMEXIT_INVALID) if AVIC_PHYSICAL_MAX_INDEX is greater than 255 in xAVIC
>> mode or greater than 511 in x2AVIC mode.
