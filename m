Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39675721E0
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 19:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbiGLRkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 13:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiGLRku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 13:40:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4AFC594E;
        Tue, 12 Jul 2022 10:40:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8anWmEiYzpw7DEQ6nidGKaW8PDLGAYe8wIz3bv+hH684CaqiUXgKy1mODGWzE3NSQBNaVMcBw9QMz2ihf5nDTYUXwsvWqF8mF3BBS+R/Lan0yaq6kxKcnMXrKsyDjW7RY3C1vPUCk9sO/90/I6Lxu+1cXQlWaY8GeP1qEPp7A6K9npEv6I4fw450/uOO7FmI9pLCB5jx4sXLmZhTE67+BLfbjbQN6rPu2RQPU/+M2R6e0so/Z2vNiibL2uR6A7ROslB3xzPwbm+pnbNO5HAG+qEeiPZnSfGZmU2yqcw8GD3IrP6NhRgu+VEhl256u5vS0iKKIrkb4aN5F54gqKBXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RkGs3ZRDgJchaP+sbMuOXRk791E9ws1v2DUVWvfS6Jo=;
 b=kJ0/H0W4FJVGzwv1FEXlPTP/6MIH9j8yGl4WCWpwyL1PZAWykTv1vv/QCx6iokxUyv3r19e9mT0PhDjvoRUUA6Qq7oLElzbb0SH0rC7Yx+qa0lh0Wsi78JzLpBkJ7iTMBWHAjIereNHdO/Dq/4VF5xSaR3cGB9L0DEFk5ZmmXYu76Cav8qG5seM9eZ8hs5G7pYZy0DjwMZnG4msHDkHK+MNtuVnVKcJz/CVf7ogx//MjL5a1t9kRi2EqcVmidwAKnJO3+9EYLCH9lltW8U9vRV3n9mj7tRh15YFELaNEVeB72DAAGlWqGuqUJco26TuMma7SsHTS2X9GyHJVdj/Rug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkGs3ZRDgJchaP+sbMuOXRk791E9ws1v2DUVWvfS6Jo=;
 b=X1c6xVv9J3vxsTEJcO+5Hix8DHQudO2YhtdtLDj6gD+75gMONFedCURD2wPuO4oPBzhBzgYj/qJ/7tyz1c7HgPphTi5YmFOiMB19YikHgonjW/GRz9LTi8V3pO0WdN5E6JPnCVNwd0jTmDQsN3QGcUm62PfUAEgfB/DBlMcxqII=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN2PR12MB3199.namprd12.prod.outlook.com (2603:10b6:208:ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Tue, 12 Jul
 2022 17:40:38 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0%5]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 17:40:38 +0000
Message-ID: <c3b80f5d-a0e6-ad5d-1c28-c08aded21a11@amd.com>
Date:   Tue, 12 Jul 2022 12:40:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6obGwyiJh7J34Vt8tC+XXMNm8YPrv4gV=TVoF2Xga5GjQ@mail.gmail.com>
 <SN6PR12MB27672AA31E96179256235C338E879@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6ryLr6a5iQnwZQT3hqwEpZpb7bn-T8SDY6=5zYs_5NBow@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAMkAt6ryLr6a5iQnwZQT3hqwEpZpb7bn-T8SDY6=5zYs_5NBow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:610:38::31) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8d73517-0be3-40e4-8717-08da642da210
X-MS-TrafficTypeDiagnostic: MN2PR12MB3199:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUkpOJyaDb/MeQwWtrcZiU7L1I9LxPj0WbqyyhxqkiTUzNBmjrHHp2fTKvWQGaZ2an7vMWU1TXj6yFy1ENKmgri2uuibL+tu+uTkTEPZRSACucgUc1ICbff8xt2lYFVmT+BaVl5LJ4eYBQfnKfroavIi51HjMO6Tr1jvWXITvyzvx1GkIA/mfISL6VAkuVZH2nZsmzVG+dEOVpsFmzq8/RIsULb/ejFfxFaTgg9406Q/EZKgVlup6+DYfB0JJGzh58bh5Wz5h1RCNFc4vF8WA7SO1mz+wgA0VMCaQEo7ZhHeRH09gOJSlUNEDK9HaClQbUq+Xgu8YbQx2nc1Bbe8Ekr2UdKhOBNgM1kuyw9Fk4ojqyjm6/JLNChGtd3MYCzsWzltfk5bG3UdX6T09hj2886MHuJKX6dZAxHrYUi5VppbsZw60U/VtXkTsMbEEmVrCLUSfOo6rJSYPu+HLQpiuMTsMr7HgeTPU06ZarZ33kjV5/z8IhZN4Y2jVb8qdgrxwhP3y3xu9x/4Sb1BKz8m0CLecD0vLI7MSLKKvFVN88L3nu6e+5NVcXrui3KWvACoZlZdmh7fxi7hgCYcaKMbx2RXbm89ETNcTYWtsasweVXSE1oOiI4XdPICzO7EW8F3HkIeHz93YXRht24LzZk/8Aajt20dAXZgrXOsD7uC7xCjFsENj/omRwhAUAqoG72lpqq0Zc/6P4lkyb7wDuFDWnPqRWUCfRADr2NWg/L+HYCwS6X+8u8pYzZiDqxESGfQXbz4AfkK6vQpxp5nYBoMf8ms3r7evYPkMryjDI9XU+K3mZfZgha5ctcbdFEDHd5DQFYewEuoQF1VulYgQKZbV66yWnpO6uzhlgexTfHMiluNHWbhaep33GM4FXMWq52B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(6666004)(6512007)(966005)(6486002)(6636002)(54906003)(478600001)(6506007)(110136005)(38100700002)(83380400001)(41300700001)(186003)(53546011)(2616005)(26005)(31686004)(7406005)(2906002)(8936002)(7416002)(5660300002)(36756003)(66556008)(8676002)(4326008)(31696002)(66476007)(316002)(86362001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2NFeVhJajdZWDh4RG1PMVdseUVROUpoK0ZuQmN6Q2pwZzZsbEtTMXlLeXVI?=
 =?utf-8?B?Yjk5WHdnQ3poUVhOR0M4QnV6cTNaT1FZWlpNYTlDYnBVb3N3ckhmbTJ5ZTJR?=
 =?utf-8?B?UjBWRy9SNzhEU3B6WFhpRysvczlwOVdkL3Vaa1JMc09HOVpwZnFOUFJ3NU81?=
 =?utf-8?B?bFl3TXdtMkpyWVJoS1REb3VqM2NnaTg5Qmx3bCsvdXpYNWxKT3B6a0txVFB6?=
 =?utf-8?B?Nm02cjIwMFZUUVZaMThBOVNwc1dNMjM5U2x6QmpMK0dvWGhGUVJMbXg0Y0gr?=
 =?utf-8?B?V3VzWHVXTGVXYTFBdnJOVXpKZzZkc1JMOFAvMWI0MlM1TmIxWHd3ektMVHh0?=
 =?utf-8?B?ZDNsVk1QQUczc3lkMm9oU3EvakZvdUlmVGlkZ3pXUHdaUlRlck5MTG1GUENQ?=
 =?utf-8?B?bWVnU0JLdUZRM1dHa1NOY0hSSjNvbDNFQnY5a29xSnVTWnU3ZUNHUW53NklF?=
 =?utf-8?B?U1o5Q1lTbVpOOVdrNHJ6RkNsU3FVMDdUSm8yRlJGS2x3QXlmQVRncXJXR3pP?=
 =?utf-8?B?QkJtV1UrVUQ2aEJZdFVBdEJ2QVFySS83SXBqZ1UwVWFhOTJRaDA4bmkwQUFR?=
 =?utf-8?B?S3h0STZGOFI1Y3RPRzBnUXdnM1hxWDdNSUljSzQvOFhoYnltZmZoTVlnVHVD?=
 =?utf-8?B?N1Y4STdqYTh1Q3c3cFVJVUdyamVBZ1ZpcC9YR0VIZDVXcnVTM0NBYnh4a3ln?=
 =?utf-8?B?NjlRdk5sVmtnaHlwZ1QzZEZUR2NjZEV6ODNyYU4rR3JBMHFqcTJKcGlPQnJE?=
 =?utf-8?B?ckRVYUNiTFpqVzVqZFIyekdVeHN5UlBGTnhsYlpyUXpSRDB5ZEZteUpWaEV5?=
 =?utf-8?B?M2t0NEI0eDFLZjIvLzdaTVB5b2ZCMldCN25jenc5U3A2RjQ3WnVXR0k5WVVM?=
 =?utf-8?B?aTVSci9XMlFNQ3REMGRzRllvSGR3TlBrYW82Q2dZTkp5aUhTMlMzcXFGWG8r?=
 =?utf-8?B?ZW5ubUpUSncxZ2o2a092d2trWitGbVgrbGFOa3YzVDZyY2JWaktLcTZrai90?=
 =?utf-8?B?eEJkR3V2am5CdFdieWRPZ1psZmY2OEhPZzF4Rk84SWdFY3ZOaVkxck5zV0hG?=
 =?utf-8?B?YVNrUGl6bXdLTTZuUnBGNUNoQ3Q5aHF1T2tWd2g5SnRlYkVDbFVZYUlLVzhp?=
 =?utf-8?B?TWJOUHJCUXBjdmRJTW9WSnhxL0xYbnhiOS94VzZBT2plamIrVEU2QXZrZml4?=
 =?utf-8?B?bmlVK1VnRHpwV3p0cndrL1hqSm5NbEhHVjZ1aFFEZnlkenNBaVVXQXMyRjEw?=
 =?utf-8?B?Y0UrVGpWR2hXYkRFQ3Jnd0pmSEsxTmxMK3pBbm5aMG1nUUdVdDY4UFV0dE9V?=
 =?utf-8?B?WlRlVi9LZE5YRFdRYUNPZVlTSmlFV2FkUTVUeGFHdVFsVHlYQTFGdS9UeXpz?=
 =?utf-8?B?aUdVamRqYjZlaXpUWkhjODIrbU5iY1o5TVZ5bXUwWWZQb2NXWXE0TFZvQmZu?=
 =?utf-8?B?UWNZTERWZ25hNit2L24wS2Y2bW9UVGN4bFl0SE1CSTk2QVk1SUNIbUY5Y0Vr?=
 =?utf-8?B?cnRORUVqbk53R1R4a1I3TmxqV3dOeU42dFRRcnZ3VkhEc1pKcmhnWUcwTk5H?=
 =?utf-8?B?Nlo2d2NrM2h4RFRPN1dhcXZoSUNEcTdLOTdveFVieCt5S2w0VWNCb3U3QU5i?=
 =?utf-8?B?YjlRWVlQMStXNDNwS3FpV1h3Lzh2NWk4L0FhaDV1Z3VxMmN3UXhHTW5TeW5H?=
 =?utf-8?B?NG5aQ0xwYTVyMXlHVmVlMUpxRHdtUVFUM1VXd3A5a2dURWNGTEtUSk5EbW16?=
 =?utf-8?B?Y3VST20xWHQ3UXk3dDBHYjBDdzFCcHFLc2N5RlFtZHpqblM5a1lCK2NHV1FE?=
 =?utf-8?B?YUgrTjFha0oxWTZTRWVTWE13WE9RMUxMTVdTTkdSSnUrYlR3VUVqMmwwQ0ly?=
 =?utf-8?B?YnJhS09rSTlJNHVJcHlaak1GZ25OcHk3M1Z4ZmVhWWpFTWIzNUpqTEVyVjl3?=
 =?utf-8?B?THpvZ1ZvUEVpcG9KdHVKTG5FL0xUT2tGYmt6NDgrV3ArcmxObDhUcG85TFJ5?=
 =?utf-8?B?YWRqcTFZdlozMWppZ05lcmNWTkdoTUVzNnNlZEsveFBTZFBIbFRGNGQyNFV6?=
 =?utf-8?B?WUV0czRNMkVaVS84YjYxN0RHSHgvV0RUSHF1V0Mxc2dwRWw5dFQxcTY3NEVG?=
 =?utf-8?Q?ZDu2ZRg8PChYwjK/peFRJD/Bw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8d73517-0be3-40e4-8717-08da642da210
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 17:40:38.4456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f++Nchx3sl2HlltAOawuWWqET6kow0GiYczCYjdQgMf/Xn9/lnOHLtRnUKMxNt3GGqYLIDZyMbPlow384k+k7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3199
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/12/22 09:45, Peter Gonda wrote:
> On Mon, Jul 11, 2022 at 4:41 PM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>>
>> [AMD Official Use Only - General]
>>
>> Hello Peter,
>>
>>>> The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and
>>>> stores it as the measurement of the guest at launch.
>>>>
>>>> While finalizing the launch flow, it also issues the LAUNCH_UPDATE
>>>> command to encrypt the VMSA pages.
>>
>>> Given the guest uses the SNP NAE AP boot protocol we were expecting that there would be some option to add vCPUs to the VM but mark them as "pending AP boot creation protocol" state. This would allow the LaunchDigest of a VM doesn't change >just because its vCPU count changes. Would it be possible to add a new add an argument to KVM_SNP_LAUNCH_FINISH to tell it which vCPUs to LAUNCH_UPDATE VMSA pages for or similarly a new argument for KVM_CREATE_VCPU?
>>
>> But don't we want/need to measure all vCPUs using LAUNCH_UPDATE_VMSA before we issue SNP_LAUNCH_FINISH command ?
>>
>> If we are going to add vCPUs and mark them as "pending AP boot creation" state then how are we going to do LAUNCH_UPDATE_VMSAs for them after SNP_LAUNCH_FINISH ?
> 
> If I understand correctly we don't need or even want the APs to be
> LAUNCH_UPDATE_VMSA'd. LAUNCH_UPDATEing all the VMSAs causes VMs with
> different numbers of vCPUs to have different launch digests. Its my
> understanding the SNP AP Creation protocol was to solve this so that
> VMs with different vcpu counts have the same launch digest.
> 
> Looking at patch "[Part2,v6,44/49] KVM: SVM: Support SEV-SNP AP
> Creation NAE event" and section "4.1.9 SNP AP Creation" of the GHCB
> spec. There is no need to mark the LAUNCH_UPDATE the AP's VMSA or mark
> the vCPUs runnable. Instead we can do that only for the BSP. Then in
> the guest UEFI the BSP can: create new VMSAs from guest pages,
> RMPADJUST them into the RMP state VMSA, then use the SNP AP Creation
> NAE to get the hypervisor to mark them runnable. I believe this is all
> setup in the UEFI patch:
> https://www.mail-archive.com/devel@edk2.groups.io/msg38460.html.

Not quite...  there isn't a way to (easily) retrieve the APIC IDs for all 
of the vCPUs, which are required in order to use the AP Create event.

For this version of SNP, all of the vCPUs are measured and started by OVMF 
in the same way as SEV-ES. However, once the vCPUs have run, we now have 
the APIC ID associated with each vCPU and the AP Create event can be used 
going forward.

The SVSM support will introduce a new NAE event to the GHCB spec to 
retrieve all of the APIC IDs from the hypervisor. With that, then you 
would be able be required to perform a LAUNCH_UPDATE_VMSA against the BSP.

Thanks,
Tom

