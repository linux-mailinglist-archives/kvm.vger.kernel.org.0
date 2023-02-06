Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457DF68C54C
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 18:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjBFR65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 12:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBFR6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 12:58:55 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF922CC7B;
        Mon,  6 Feb 2023 09:58:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/JLWCbVOkmtNAHkE5R/pfYAkfF7suYzp8mHafT7VuMI8hgPDBlq2miQBOLY/w59opCLUOV43J7nsWAxqqtqBxr3aur9vpZEjAxbJvrYEqPJDaTAiGTpSNUJALmIXOGZf8mGUR9UIq5z9HKoNlDYo7XgnH7lClvJHpUsOsXhKx+zmj/dkOKyIjIKJ1qQBF8D30rZ0FAS4ZEMxe94mP/cTry9+WDaTJwknefUXkGyAkqcNn45MEGBbGG4o1O5gFddJBEGU5Uf8sOyRMUA9AT4PNJ6pS+K3/11pFbdB8VIfh4xTRERllph5VygvTLP4hkwJ6FvGB/gi+jPk2/hpeB5ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vhAG3Jatz+EPDmLz8EffQ3IXKaTdg0bdHE1t33/2lko=;
 b=P4ue3xNV33ZmkLhWtb/bVonnMnksN/xL//MdMtE0hOkJOCUFCntoSvMqnBQrhFtS8OsbTFHQbEaQp/Dh9Cm3BO9Dj7EakEn+RR2c4+yeVrGu05Byg2WYCxwLF7PxUtcOqPlka6fVwZ4Ew73GYBU25oI0c7TbFXZbha2FWZS4LlvRAw8ncuNrjgX4cq+srAihW9KvKSg42ycRMntm6MkGdz3fFBJ4zCUJPjPl4vCj8mWk4hFvtmVgk6NPCtApP9K8W5vkZ43+/PLwYOY3cL62qH+f2CCuxobtLt2fsgV2ggeRBDqxVVn2mi61RuYoz7YHNBhI4Z+1M5MiB/8U9Ii77w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhAG3Jatz+EPDmLz8EffQ3IXKaTdg0bdHE1t33/2lko=;
 b=pGoVOOs1HsOtDfSn7o92LuCwojMeHqhLziBk1D9bsng7PS2022HMNISyZ/StVZnNETrr+gm/7qQYlfTwsVlcPem5ZfovazRwVNiTqqk7N/pRVjHLi5VNbBqWs++Em2NjgegU0r5AC/6dVPrnfS5GmtOK29Oicg7K1CEJjrDYWkk=
Received: from MW3PR05CA0004.namprd05.prod.outlook.com (2603:10b6:303:2b::9)
 by SJ1PR12MB6098.namprd12.prod.outlook.com (2603:10b6:a03:45f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Mon, 6 Feb
 2023 17:58:50 +0000
Received: from CO1NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::6a) by MW3PR05CA0004.outlook.office365.com
 (2603:10b6:303:2b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.15 via Frontend
 Transport; Mon, 6 Feb 2023 17:58:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT112.mail.protection.outlook.com (10.13.174.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.35 via Frontend Transport; Mon, 6 Feb 2023 17:58:49 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Feb
 2023 11:58:47 -0600
Message-ID: <7abdd9d4-4ce0-458d-93f4-bff575f04345@amd.com>
Date:   Mon, 6 Feb 2023 11:58:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
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
Content-Language: en-US
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
In-Reply-To: <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT112:EE_|SJ1PR12MB6098:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f83e067-5764-4648-6ff7-08db086bcd0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tc5844DvxkRAS0SUf34e+zWJm4a4sG6bDKqI+HqC8hmmrpqTeoKrp/iF62BY9UE1mM4e4q1MknXi6jFnv0eKHR/zeQn7RUOAYuCa8JqflIGskMHvHZFOk9vKpZvzGgIYLONSLuzvVER7E85lzaqIP9eMjQZpiKw9O5tNlUNozn4D12CRheailGFPqHWA1s8d4epuObDCWXgec2KXy7AuQeB6/M2+R6SRkqS0B/IP3doGNb9btSvqvqDVpNZp3WIA7D3wNgVlVI7Wt6/hAc+Ge/fpwdJQXLRzKFYQ2AQtxKBiR+Sk8Ew29//1quzX8Pp2q/YH2Ze5OUKTN6bFD6t5qleIuIyfi9t79wGZkIS+EOsvc2gnHP+O0HDNh9je75zrF/D0/i6SvKH+iT3rWDKtM0yy1ugetliATOXfzhbCVFox7HQeqhcSUosV6jUYxXkAsdM+d1RC9psoz+kS01RhyT77MNptyyPEE2e72r3hYkgOqYyXTkIZsz25J22JySqE/HhEoLo4MGafbUPWd2yZVllYe0Z8S2d8EzuS51o876LL2YfIy+qcFcNDJ3Kta1zRcsKdtNpKxWlkSIF472nSGWPeLBYnVI/JTcyjKDdftb0aQXYxz4QjhTREy6IJ0NIRK017V42+t2KUB66Z4VUMFdz2+W4lUfD8LOLZoke+pDJ15ZnBytpsMOYA/MNeQ6lRi6P97wHSnb8SW2JVyEP7d12/dtpzgjJWzjrSy4IcQtfoUAcT62mcB0RLQTLEjkZbAl+4dWP7qVNHP7tDbN4InA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199018)(46966006)(36840700001)(40470700004)(2906002)(31686004)(4744005)(8936002)(5660300002)(7416002)(36756003)(41300700001)(4326008)(86362001)(40460700003)(8676002)(70586007)(31696002)(40480700001)(70206006)(110136005)(54906003)(356005)(316002)(16576012)(44832011)(82740400003)(336012)(478600001)(81166007)(53546011)(36860700001)(16526019)(26005)(186003)(2616005)(426003)(82310400005)(47076005)(83380400001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:58:49.6005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f83e067-5764-4648-6ff7-08db086bcd0c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6098
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/23 9:40 AM, David Woodhouse wrote:
> On Fri, 2023-02-03 at 13:48 -0600, Kim Phillips wrote:
>> If I:
>>
>>    - take dwmw2's parallel-6.2-rc6 branch (commit 459d1c46dbd1)
>>    - remove the set_cpu_bug(c, X86_BUG_NO_PARALLEL_BRINGUP) line from amd.c
>>
>> Then:
>>
>>    - a Ryzen 3000 (Picasso A1/Zen+) notebook I have access to fails to boot.
>>    - Zen 2,3,4-based servers boot fine
>>    - a Zen1-based server doesn't boot.
> 
> I've changed it to use CPUID 0xb only if we're actually in x2apic mode,
> which Boris tells me won't be the case on Zen1 because that doesn't
> support X2APIC.
> 
> When we're not in x2apic mode, we can use CPUID 0x1 because the 8 bits
> of APIC ID we find there are perfectly sufficient.
> 
> New tree in the same place as before, commit ce7e2d1e046a for the
> parallel-6.2-rc6-part1 tag and 17bbd12ee03 for parallel-6.2-rc6.

Thanks, Zen 1 through 4 based servers all boot both those two tree
commits successfully.

I'll try that Ryzen again later.

Kim
