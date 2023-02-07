Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E594368DDEC
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 17:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjBGQ1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 11:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBGQ1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 11:27:16 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4841A49D;
        Tue,  7 Feb 2023 08:27:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iitd6jGvW7y1dOYXZA4rfG2+/Uy60siEiKbvV6jmTFnqvgaMnp4mpMhQxpBxj5IOtzj0Qzy7epdBJpcigA4LwpQgyVaB7ol0kMje/ppqwmohb3Jksvne//zQrG9qj/BL1B5eaQA2lP4LDqAAbpQ8BA96s4iaJWnv9wla4zKjmpAJ9ewB+UWogDHkSDo4oijqB4eP+cRN+/z1HyMurnapwZasQHGaUUXXxvLd+tc/9oAKODfOD+eOL52cPFKNckN4rKLjrQU/NPT3JnNjfa4HcnPc9pr6WKfOBUvB/KiDWAUVlbid6JHRWqthwiSN068j/05Xhiu/weQaP68HeC4aHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GfqklM9+1l5eNGmiYdCRTUB7O79bFc8CiHYJuo5qjEA=;
 b=JdDeS0L1/WSqX9gm2SxeK599ZheLPZyrEZnM/MXX5I703dBkK6wf9/7W+GLISXn6WsZnsgscyYf6lNLcwu4Dg4owPwdR3KplTWwcIGxisbS9CCZAzDjEvNRY+APbI0WI5KT1B2VHPXsBbV+f00mMJP/kTE2SJVC5JImfKM1hZVjjS3L+m/A6XGj2whQ/zvpdPGIeZC/6RGuI6seYT6zUnLk5Lf5PZLbhOrDfupfR3fKMbKN2kXEJWDNi1Fr5YSm4AvSY+q7hNP5fzU2xFuWtv3EQcsZGrrmUVx+jtl/tH0s4WNYi7b6bpZkJyeAAtDmKOlKtgLKT7bZTA+QWegLL1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfqklM9+1l5eNGmiYdCRTUB7O79bFc8CiHYJuo5qjEA=;
 b=pIsJgnnNlrBzTOvN8wPEmgnjEnF81kGGEshl+JLU8oUFxp9lTAtQsNuV9q4TCWhaKVRhYKj2xtJgns/VyB2ukr8xIZHDUaGkvOgLBoo+Q4Ppujad90/Sj41BuLJFWhOKbE8s29TvzRsdSq+Xb1RMbNas1eGrZfBrw/BhejdxhAQ=
Received: from MW4PR04CA0296.namprd04.prod.outlook.com (2603:10b6:303:89::31)
 by PH0PR12MB8031.namprd12.prod.outlook.com (2603:10b6:510:28e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 16:27:02 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::e7) by MW4PR04CA0296.outlook.office365.com
 (2603:10b6:303:89::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36 via Frontend
 Transport; Tue, 7 Feb 2023 16:27:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.25 via Frontend Transport; Tue, 7 Feb 2023 16:27:02 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Feb
 2023 10:27:00 -0600
Message-ID: <163a0729-628c-4660-4c54-114dca1e4d9e@amd.com>
Date:   Tue, 7 Feb 2023 10:27:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
Content-Language: en-US
From:   Kim Phillips <kim.phillips@amd.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, <tglx@linutronix.de>,
        <arjan@linux.intel.com>
CC:     <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <hpa@zytor.com>, <x86@kernel.org>, <pbonzini@redhat.com>,
        <paulmck@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <rcu@vger.kernel.org>, <mimoja@mimoja.de>,
        <hewenliang4@huawei.com>, <thomas.lendacky@amd.com>,
        <seanjc@google.com>, <pmenzel@molgen.mpg.de>,
        <fam.zheng@bytedance.com>, <punit.agrawal@bytedance.com>,
        <simon.evans@bytedance.com>, <liangma@liangbit.com>,
        Mario Limonciello <Mario.Limonciello@amd.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com>
 <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
 <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org>
 <7abdd9d4-4ce0-458d-93f4-bff575f04345@amd.com>
In-Reply-To: <7abdd9d4-4ce0-458d-93f4-bff575f04345@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT048:EE_|PH0PR12MB8031:EE_
X-MS-Office365-Filtering-Correlation-Id: 932e70ba-3225-46ca-e2f6-08db092824cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mst/+JKS6X4fwkB2L5F8vvEme9at2OO/DX3YBlaYCe7SU05vYAnATGvjLMl3wBJ9upjvZz24d1xiCVpRNaxkcnsskV0TkWcFFpZGI08nUOq82e0sIQR61m1adFjdveakiVc+V3hU+yTH32VVrVFiXN6jVblr1SgvKQsc8IKF9nAs3Sll/zceEgog6bO502NG3SBFaDrItT3543WFHQka5pNvFPTkLzkFcfFCeZLReksFJ0Q6TYMv4CCiyALvN/2ORzoCTXlRyHgKFpvX5Vmw00UApE0NKmiA0foSDS9griF2zikZBT4XydeCeJbLx3pZUutdkjsex3uW9/5eKA57Ur/RALndJgLLwLnuBw7DLqjO9RZiR5i73pfOPxH9+l1U+Cm87nj5tFyp2A7e8mbDNIzW5sqxoWy75RvwmjZXd7Hhoj0a33/WNahehck0nRT29ZCLNg7cPIyRN+3OirVLPxv54E2kIXE54CUX79e3fSJpbVx+5l8emUXhfISm0mHP74jMLN9NCH64uoHKtv1ju0FO1xLGjyJC/Oad86qg7V88yZIZOdjHplW9/hiXx/FkHcTCKKk4//p3Tr1qw1xEt5j839ueKHsfEaIvjVMU0g5ymTfex+gzh7KmeQ8CrbH7Q4EKtnFk5mV45SHNGgHemv1VOjjvuVQkh+Hs2WsEim1GfvmHwkKD/zIWhfvHI3dr2Efj6AZ7A83N0IgwNfCu6mv+5LINccxOcqtElb5NTdztmuY+O3rOOzGKVZ8mccfGhILy0t01VlvtSSE4cfZt4A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(31686004)(53546011)(36860700001)(82740400003)(70206006)(44832011)(70586007)(54906003)(82310400005)(16576012)(8676002)(110136005)(316002)(41300700001)(8936002)(26005)(4326008)(5660300002)(7416002)(356005)(81166007)(31696002)(86362001)(186003)(16526019)(36756003)(47076005)(2906002)(426003)(40480700001)(478600001)(40460700003)(336012)(2616005)(83380400001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 16:27:02.2465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 932e70ba-3225-46ca-e2f6-08db092824cd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8031
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/6/23 11:58 AM, Kim Phillips wrote:
> On 2/4/23 9:40 AM, David Woodhouse wrote:
>> On Fri, 2023-02-03 at 13:48 -0600, Kim Phillips wrote:
>>> If I:
>>>
>>>    - take dwmw2's parallel-6.2-rc6 branch (commit 459d1c46dbd1)
>>>    - remove the set_cpu_bug(c, X86_BUG_NO_PARALLEL_BRINGUP) line from amd.c
>>>
>>> Then:
>>>
>>>    - a Ryzen 3000 (Picasso A1/Zen+) notebook I have access to fails to boot.
>>>    - Zen 2,3,4-based servers boot fine
>>>    - a Zen1-based server doesn't boot.
>>
>> I've changed it to use CPUID 0xb only if we're actually in x2apic mode,
>> which Boris tells me won't be the case on Zen1 because that doesn't
>> support X2APIC.
>>
>> When we're not in x2apic mode, we can use CPUID 0x1 because the 8 bits
>> of APIC ID we find there are perfectly sufficient.
>>
>> New tree in the same place as before, commit ce7e2d1e046a for the
>> parallel-6.2-rc6-part1 tag and 17bbd12ee03 for parallel-6.2-rc6.
> 
> Thanks, Zen 1 through 4 based servers all boot both those two tree
> commits successfully.
> 
> I'll try that Ryzen again later.

The Ryzen 3000 also successfully boots those two branches now.

Thanks,

Kim
