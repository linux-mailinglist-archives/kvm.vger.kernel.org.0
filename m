Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C6E4AC8E9
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 19:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbiBGSyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 13:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbiBGSum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 13:50:42 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E4FC0401DA;
        Mon,  7 Feb 2022 10:50:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UN4gHAKsP/+fs7POMjSJ/jmE+5MomPtlFhIdzmxBAsaqxt0hZIxROiYga/En/np57oCWJPIs5pJVpXAQuQtGF3hNlcm0wkt5qLMAEhDac1eEreeZeDZoaHYR+SAxS4a+fHM8NgMx+oMHS1oTVds74KBy7mp2m4N8Y1k8n36QPD3hW2OYDlEn+mZqq2PmOKBPLsgKCLfIgmDt0ELOIgFHSXdH0K9ji8ibIlBNnv25wswiVh7PBGcEuCTBqd6sEywb7thjiQkhNvCaQIdFFpdCC26ur6WEKgVurSOrmtHYsEUDrCl7CPisCwteTYeTC09u/nFHycqEAtOYsZHo2I9icA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDjP0vgTHjrDSmU6PqYxXwb1yFblzA5G/98vZeaZzcc=;
 b=V5+Ok7U8DsWo7f0OzyPH+rpzIBPvfTqZvFMVLME2MW0q+qV5kvFjfxT1GTxLXPogNtHj4SbeO8mXBbECWdA08HnrHCAa3Zz2LDhQ35+ouchdvOurLZwMA5q5e+C7APv+0ddDhPDG8679E0cTeO2lWvF6XjISBdaD5hDjsfYO5cfUSIdlChxOYiZ/t6uJY8vyoY99RAZNf1cvssK9HE1+BzVV2IUbwoGRoPHI/gEm3u9BsFa2smyZ7ZY/JqguQYmJTk0NKyuV/s5Gny++53C2V71vFqIWbszN8Ae4wTCsXtrMRMz6zfSioTuvhIQGe9GFfRWcGA4xMwoubpUjbOQSEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDjP0vgTHjrDSmU6PqYxXwb1yFblzA5G/98vZeaZzcc=;
 b=N/cGk1s4uibSMH1HECjR+K2y+JjMBfQwFz83WgWbrboNLO/8BDKxI4rOzESsypITwNWZ1Gupd0GT2hGS0A7Db1d4XNUt9CnkR/ZDu7H98MiJ6oKA8zw9FmESKfEd2UADMscgrOi8/Idr00X/vqv8sTcMolHEhjYzj9BHZONRxcQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9)
 by CY4PR12MB1429.namprd12.prod.outlook.com (2603:10b6:903:42::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 18:50:39 +0000
Received: from BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::b9af:8be3:36e5:1a13]) by BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::b9af:8be3:36e5:1a13%7]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 18:50:38 +0000
Message-ID: <ea03061e-14aa-8159-4935-869f694a4715@amd.com>
Date:   Mon, 7 Feb 2022 12:50:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 0/9] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com,
        Sean Christopherson <seanjc@google.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <20220201205328.123066-1-dwmw2@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220201205328.123066-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR12CA0007.namprd12.prod.outlook.com
 (2603:10b6:610:57::17) To BL1PR12MB5221.namprd12.prod.outlook.com
 (2603:10b6:208:30b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bce39e9f-71cb-4991-5f80-08d9ea6abb70
X-MS-TrafficTypeDiagnostic: CY4PR12MB1429:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB14299E07088DB27320343A22EC2C9@CY4PR12MB1429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XemMfJimSxGyZM25/F4w7bbpJkQsuwWmI8Ywa0c30V1lPDd6GFdMVeB2rq9WBzOouHdqKNJj7E5oYIHRSAQXzBKX8/KrQ7EFBiZ7Cq3bbUsadMgw951ccyMvRzP2cphLq3WjfyPyMBD8c3VyQCmkfIJBzohmlaBzxGvhKyUKoDpA5Y771vjbQ85VHoWfcRKW3pBiTSaYr9S0wF1zR6vfclXBIpIoDSH8DZqjYe7n+C6EDSP8KMcoacBS3BTheEflymyGrR9wb0iHFuT/Ia/7/Dov0srVKxMH/xqfYbB+5SIZZ4IxQcGbol4RaRHJGZtFjZB11n1eszsvZUENoLxHmgiTc5GwprUtMzKeD2TUmHuW4zEaxHqzlP+hbYiqH/a8/+EqqMGGeC9fzvYJYNoZ7bb/vwqqJqJx02ACEu2mCBx4WTWsvkLjLSQXM5zHx4DVfIXm3oNfTqE6cLmdIlClNxeVNiWGonnG7t+J0fdYX07BocMczlCwck1O26+tspnGBtwtHu3ywMddzR+U2+zdn9fIDOd/CGKfWr207EpNs2kJwtCng29O5Cn/vM3tciB29I4btIrPhtMKQyEArkND2YgN/jNBdwlyt+rg3l2i8tSrq5XEpyW6xj0Q1/iVMAUdfp4zrA5x2gvq8l9HfeM1IjJK1O4iOnCvmWxnbvpXLTgn/TmqhnVFejlcpYwLa0ysLfhzoEfLjsQE/o8UNDWUuVLFPM0kq/7+KS+ImB7I2dsKBrSTmPqqKGfDGx0Z7gCZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5221.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6666004)(6512007)(2616005)(53546011)(508600001)(66946007)(83380400001)(8936002)(8676002)(66556008)(54906003)(66476007)(38100700002)(110136005)(4326008)(31696002)(86362001)(26005)(186003)(316002)(31686004)(5660300002)(2906002)(7416002)(36756003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0FtQytSMFFjMnRXZ2xDd1RvUEJiMlAyMjhkWjNyV0gvTjQ4a0hQN3ljL1c2?=
 =?utf-8?B?TWhUOE9aQTJab3RCdWRRNkZpazRGVXl0NE85L0dNQW9VQ0hTUGRVVFlkUUM4?=
 =?utf-8?B?NlpiNGxJd2gxaUJRRU1Vc3E4eWZwN2V5L3NqOGJSZlVWUERsZi9meCt0N1V5?=
 =?utf-8?B?dERETmU1UmJxZzJINFdIWFIyQjR1ZzZtaWU4dHhjL2FDcEVtVFpBZnp2dERS?=
 =?utf-8?B?RDVhclFHV3pYemdsSTNaMmpZZUJ0M0hta2haOWFNc1ZMYlRKMjBrU1FDd21M?=
 =?utf-8?B?UmNMQnVOYnpUZkhweVhCZm92THBLZ2FES3U2ZER6YWpUdDVTSXVXcUJCUGdt?=
 =?utf-8?B?MFNNMnRxdFJyY1hXdCs2aDFlbVphSzk4Mk1lKzVnc1pHaGxmL2Q4NDhOSVYv?=
 =?utf-8?B?KzNxaW9yUXNqcGlsQklPQXdGTWhIR1dkaGk0M1o0MkYvZEp6bEFxT1lwUm50?=
 =?utf-8?B?bHhkUk5sVEQzdHZqckU0R1BlUVhzdGJ5VDZhdDR2SnhWcEhFQXpIRmxxNUZS?=
 =?utf-8?B?aVl5OGwrSzlMbm9CL1B0RGJIQXdNQjdvTmFSa0c1cDF4OGkyb296WkZWRUhQ?=
 =?utf-8?B?eDdnN3oyQmFJeFBUR1JQZ3dDUlNZanpsUTdHWVl2eE83YTVnOXpDMEtqT290?=
 =?utf-8?B?TVprcDJhUHlaOWUySDF4OXliMVZqRUo5RVdLSkRFVU9pRXliUXM2NXFocnAw?=
 =?utf-8?B?S3hDRGROSndXcG5rWVBFQkdZNitSczM5TldKSVV0eWZNWlMxbXJsOG9IQkhy?=
 =?utf-8?B?a2FvaVFWZW1VS0FvWHFtMks2dk0rRHIyelgyVk9JYzFUanNzeW5FSGczTFht?=
 =?utf-8?B?SHJXTzdOdWlUVkUzbmlnMmpuL1ZGOFVDbGh3TkxZaC9qYUYxWm81UWcxWnRU?=
 =?utf-8?B?WlhCdnJvS2ExSk5TQitOdGk3YVFCem5WZnZrZFNqY2duSGNaN3N1VXFhT1pE?=
 =?utf-8?B?RkpSNS9UVzQzcjJ1MlRscmF2bFlxRFBpNnhvWUpVblZaZTBWWXVoUzY5R3lL?=
 =?utf-8?B?SEErb1NZdytmRmUxWVJrczRVYjRoZnRUVmVNNDFPaDQ0MVBDemhSdmpobmhM?=
 =?utf-8?B?ZXRZNG5lV0tLcEVaWlIvTG1YUHhLOU1UQXRFNy9zeWNGR29sRmZ3MytGb2FY?=
 =?utf-8?B?TzVEcFc2bXJieXFCYUg4UytCaDhEMjlzd2tHZHI5TW9BN3FMUFZPUXJOWnht?=
 =?utf-8?B?bHB5dnZXemt5MUNRK2FNM0FVNzRVNjIwbVFUcENFak9UZ3NDeXdOdms1Mmlu?=
 =?utf-8?B?SHM2aVlCU0hZR0VWMTJuZHBRYU5QZzFDV2kxZUw5YmNXZmtuZ1FsbjJaNmZU?=
 =?utf-8?B?VU00VFFvVDd2SUtvYWJvbGRjc1JPQXFNU25GTGsxb2JHTHF5Tmg2Zi9sbzFx?=
 =?utf-8?B?aW0wZUpCRkNZTldRcER4OGJmSHNrNjYvb1NGSWlpMVMyTUxTRWJHbjJ4SXBn?=
 =?utf-8?B?TldYMW9FT3BxVFZRQzlCNVVrWVByaWMzSFk2a0F1eDFobjhsK2hNWHcyRTht?=
 =?utf-8?B?QVBrbmc5djlxVUFia0FZeDk0ZTN1ME1weVRUVC80UncyRmt3d3RNT0dKeFZQ?=
 =?utf-8?B?QWJDcHp1NVpRYjV6cXlsQ3NHNENycW1DLzFMRFpIMWgwRmxrcmpiZGdsR0hX?=
 =?utf-8?B?UmhwVDRDejkvY0drdktQSUhKVWQ4Q05ROXpsTnFOWjNCejUzZ2xzVlY3MGkz?=
 =?utf-8?B?K1lnRUZnM1hHWmR4WlJJZnAxYzVtbllweHljUmU1QW53VldSVXJCNmZ1bjBu?=
 =?utf-8?B?dVhySHh4VjhqQyt5S2lCa1l2YlR3VGMyS0dFcG9JMjhkeGt6Qk9SQ1dhUXFR?=
 =?utf-8?B?cjY1bDhqNW02V0VZcTJ1R1FQRGQ3OXBqMkg5VHJWQzAvaVFiTDRXRXZQc3A3?=
 =?utf-8?B?ZklPdnIwQkFXcXNpblBPd0ZTbWRwdDhKTmFjdEpEZGg5WnZIVnQxMTNtY2Zv?=
 =?utf-8?B?TjJHSk40OEpFeCs2bXI2L2RyVzNPT3FSWlRGQWZkTkFYNmwreTRuRWl1YWlB?=
 =?utf-8?B?dFU1NUdvYUN3OEphTHdEWmlTaHFESWVoOUhQendOaGZ3T3p0LzFvUEJiaUwy?=
 =?utf-8?B?ZUFDN1o5QVF5WGVuODNETEpmdEVjcUszdnR6NWppV2tsWExmRFZ5bkMvN0k2?=
 =?utf-8?B?MzQrRnE1N1lRVmR0K0RtL2NzMXBFdnJuUnBFV0lYS1RkUEJmNWZSblhzcjdu?=
 =?utf-8?Q?9l0s0FKnF9LrP/l3sZhSNAc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce39e9f-71cb-4991-5f80-08d9ea6abb70
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5221.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 18:50:38.6146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ypIAvwLPSWKruux4a8HSoD9T3AIamnpzKtp/TwEVZ+BOV9kYdfjbvbTd6YyRM0+7V9s4jS4DLA4LpSN4th+Q3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1429
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/22 14:53, David Woodhouse wrote:
> Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting for
> them shaves about 80% off the AP bringup time on a 96-thread 2-socket
> Skylake box (EC2 c5.metal) — from about 500ms to 100ms.
> 
> There are more wins to be had with further parallelisation, but this is
> the simple part.
> 
> v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
> v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
>      in preparation for more parallelisation.
> v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
>      avoid scribbling on initial_gs in common_cpu_up(), and to allow all
>      24 bits of the physical X2APIC ID to be used. That patch still needs
>      a Signed-off-by from its original author, who once claimed not to
>      remember writing it at all. But now we've fixed it, hopefully he'll
>      admit it now :)

I'm no longer seeing crashes launching high vCPU-count guests with this 
series.

Thanks,
Tom

> 
> David Woodhouse (8):
>        x86/apic/x2apic: Fix parallel handling of cluster_mask
>        cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
>        cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
>        x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
>        x86/smpboot: Split up native_cpu_up into separate phases and document them
>        x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
>        x86/mtrr: Avoid repeated save of MTRRs on boot-time CPU bringup
>        x86/smpboot: Serialize topology updates for secondary bringup
> 
> Thomas Gleixner (1):
>        x86/smpboot: Support parallel startup of secondary CPUs
> 
> [dwoodhou@i7 linux-2.6]$ git diff --stat  v5.17-rc2..share/parallel-5.17-part1
>   arch/x86/include/asm/realmode.h       |   3 +
>   arch/x86/include/asm/smp.h            |  13 +-
>   arch/x86/include/asm/topology.h       |   2 -
>   arch/x86/kernel/acpi/sleep.c          |   1 +
>   arch/x86/kernel/apic/apic.c           |   2 +-
>   arch/x86/kernel/apic/x2apic_cluster.c | 108 ++++++-----
>   arch/x86/kernel/cpu/common.c          |   6 +-
>   arch/x86/kernel/cpu/mtrr/mtrr.c       |   9 +
>   arch/x86/kernel/head_64.S             |  73 ++++++++
>   arch/x86/kernel/smpboot.c             | 325 ++++++++++++++++++++++++----------
>   arch/x86/realmode/init.c              |   3 +
>   arch/x86/realmode/rm/trampoline_64.S  |  14 ++
>   arch/x86/xen/smp_pv.c                 |   4 +-
>   include/linux/cpuhotplug.h            |   2 +
>   include/linux/smpboot.h               |   7 +
>   kernel/cpu.c                          |  27 ++-
>   kernel/smpboot.c                      |   2 +-
>   kernel/smpboot.h                      |   2 -
>   18 files changed, 442 insertions(+), 161 deletions(-)
> 
> 
> 
