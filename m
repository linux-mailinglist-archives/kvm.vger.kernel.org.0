Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E78375D021
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 18:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjGUQ4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 12:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjGUQ4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 12:56:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CED273F;
        Fri, 21 Jul 2023 09:56:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0OlP/SvVNUzUcFq2jgp4G766NMWA3GKPPnxEvgJ03G2aCn0ceeYBx+5hIJ+KswN0XkeY1YTonYNFEuyg6AeLw3cW5BCcpFTq/cHs5+/DXxEjLmtzgxgeyUXhRygXPz9dX7RPUmUkk1NtW5DNC2EGBjGvI3DkX/1SaB6OhQY3RS7IogCYnyNhnlTVBEuewS7BOWfvcZtXbs0zuZl4dA+oUuh2ZjGVaKVtDyWm9O9m+igaLI1DuQAwYBngSGqbNJkM7SoqbyJqrstvfINMbx0NjzNU76eC1BXQbBdT31edVOvcxAObQNyhMEJ8upqxi+uPeCyPCAq6PMoZGxNFZKxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQvq1HrwllugMC8nYNRzOQ2dSUzaJitG4366iJ+J1Og=;
 b=ahql1c9E5KmfNaSR+JjTvZRjPCXuWPq0u32eAFfkDOivFtanpcyFF53A/+CcwbkJK8N/ggkCcoPV2wHSx8++/p+LpilfPZqUy580kTw//vzhT3EEvgVLIgEl3WKqSSJEKW+36Ji2j13We+rSfl2o2aO4P5STPRkZAZ43z1i2m8gHVjsmfpHzv94z6pBpLeHtGF937Pn27D5/HBUoJ/rT75zGoe0vXsfWokAN2d7bfXLHS5vDrQRzr7XeTDi7HKdbvijblxDMXSIUMIk6pyZhahVwpsTQqAVAfKsP51DxhlxVY5pdtvLGZd/IrMExpPgHQ/QsOMFZQIGwo/jZ/Y/M0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQvq1HrwllugMC8nYNRzOQ2dSUzaJitG4366iJ+J1Og=;
 b=A1gL/WAJ2GtJcCIyddYAN1OdKuBVS/ng07uXGw0ns3gIeK3jNukj1wfCbpBcToNifCXEMLHLYnHfmKROOhrKkQ+IFQP7CDyxxBWomkG5zirD+2IZom11p4EoSgRKa6PKt0ORYBGpZddGF0yN0L6p/MCOCXq1JJREioIYX6OH33E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 PH7PR12MB6635.namprd12.prod.outlook.com (2603:10b6:510:210::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 16:56:28 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::dc32:2220:8357:314d]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::dc32:2220:8357:314d%2]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 16:56:28 +0000
Message-ID: <72939733-c736-98ec-ed09-e835d8f988b2@amd.com>
Date:   Fri, 21 Jul 2023 11:56:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH RFC v9 08/51] x86/speculation: Do not enable Automatic
 IBRS if SEV SNP is enabled
To:     Dave Hansen <dave.hansen@intel.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-9-michael.roth@amd.com>
 <696ea7fe-3294-f21b-3bc0-3f8cc0a718e9@intel.com>
 <b8eeb557-0a6b-3aff-0f31-1c5e3e965a50@amd.com>
 <396d0e29-defc-e207-2cbd-fe7137e798ad@intel.com>
 <a11ba4c9-8f6f-c231-c480-e2f25b8132b8@amd.com>
 <ac578d2f-7567-708d-f131-9899f1b8dec1@intel.com>
Content-Language: en-US
From:   Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <ac578d2f-7567-708d-f131-9899f1b8dec1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0028.namprd05.prod.outlook.com
 (2603:10b6:803:40::41) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|PH7PR12MB6635:EE_
X-MS-Office365-Filtering-Correlation-Id: 261c11a0-54ad-48ec-d7bd-08db8a0b6ccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kqtXWyrfaqzS7NXERAzttwJRPPkpl8CMe/x2v8e9PhsaSyPtbEqc3LbJPqU/CycY5zcKc7sb6XZ/6I1pOdj9k0Hed2gU/5/ZHby5J6xxdRas413ULwR3/+hWcWDU04+uoqaT0PCfyJN+0GBMyK2NFWXtxSD5YuctKwAMgkSLpdvHRp9WYGMFAnlBMdNVfGbyR90FSKVVBMxAgeipwKUSpZ9dTMbU1yaZsXfDjvGzzg7Cd0Bt208TfIqNtkb/v6p7sjZpvD77mCXMvdAGhLgM9GVMJBzuCm33ArB9x8NlW9VPcYPk12ti+aGNtGwDODQc5qwcdLBjDkx94Wvxhac1jYo2/LjYnTuBhb5nr8sIWf3SZYUitwu0BfHICCsyUDeE2dcq293UYiKCtPKUqnM6WlLkHda1Z2jRgWoeZa5Lbr8hH7yjY5rzMtPojWU6nhDrvzmJjfMd7KRPaPLFajRm4YpqQpz/sXzu9qyvPx12CQVOCd4j1OnGYobyH+MFN9TG73pRocTcfp8d/u3pY3hEzCNDg7o3+yx3kKPqH8qoRtBsZKNVSwwkcQmUXXwqPumtJgZkfLyRJH0kKsV0zP3FYlcPSf+tI6tsxjl3/U8EIYrKHk0TWttCrB/d+bnTjw/4bo9Xr4Rb9PKz6D8Yznhpvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199021)(6486002)(6666004)(6512007)(44832011)(83380400001)(36916002)(36756003)(2616005)(31696002)(86362001)(38100700002)(53546011)(6506007)(186003)(2906002)(8936002)(8676002)(7406005)(7416002)(316002)(66946007)(66476007)(66556008)(31686004)(4326008)(110136005)(478600001)(5660300002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkxsL1E3cnM0RjJDdExlNGM4eHRqZGpUSmlEeVR6REs1b2VsTGdvWnV6S1RW?=
 =?utf-8?B?MSsvbUhoL01TajJIbUFldXljQm0vSENXbDBqNS9uQjJpcDRzS2p2YnZ4TjJB?=
 =?utf-8?B?b3dHaDVSUHVKQXR3TzlwNHhTVHp6SWtzSDF3bDFIcFM2cVhJNkh6MEI3MGs3?=
 =?utf-8?B?SjNKWUJ2YjVMdFdIaTVEWS82V2QrMiswSG52Z25EQ2UwZkZhU202ckFhVGx3?=
 =?utf-8?B?OTE0eEduREkzVFBmQ2t3eFdFOFU5Vnd6dytONko2dkFQR2p5dmFsYnN5SllM?=
 =?utf-8?B?ajRpNERnQmdnS3BCM2U0OVBlMkxQQmozV3JTcGhsUEJSUUtnUkdjeUFZakdV?=
 =?utf-8?B?UE5IaTgvblVnZWs1VEQvaUFKM3NmbXJlQUxFNkQzT1FNMlAyMmNWUHNSMVYw?=
 =?utf-8?B?TjBFUGlDSkdEcmFUZnVLcUU5SXRXRzNEMklwTnFYOEwzNEMzTHRZSzFGZ0xJ?=
 =?utf-8?B?V1R3WU9YRHBwUjlubnduQkJ3TjQzbE9iVjJ1YVRYRXVlQXQxbW94ZjZRSVhu?=
 =?utf-8?B?OTVXdHJSdUU3QWUxYm16UVZ2Q2JsQVJwUjJKL0h1U2poUXljaDdIRjQ0d2Vx?=
 =?utf-8?B?WjB0R05JNlpjNlcvM2gxNStTMDBqUnR6MDRKY3cybjczSzlXOTlvTnoyZG04?=
 =?utf-8?B?cU0wT1A5N0FXWXAwaVlySnJ3MFhHTmtqUmZhK2tNcUwrampZY0w1a2VaT2tD?=
 =?utf-8?B?SnQrQW96dzZDNm1rbHp4WlJaTEtSTVB4cVFzZzBRMUY2bmJZRmJzSW9LQ1lk?=
 =?utf-8?B?VlpDZzZHK3E1MjUxNDVubWJpYWE3NTgzY3BIUUlvamNvVTIzTHY5eXA0YnZ0?=
 =?utf-8?B?S2Z4c1pmaVA2UldWanZWL0ZrN3o5ZlpibElPRkdDN1ZIbWRuTXEwMU9uS3V0?=
 =?utf-8?B?VTYxNjdubW1mTC9meERBOHYzbEl6REwrcVZEMW03WlF0NVdIc0xyNTJDOGlT?=
 =?utf-8?B?bzFZb0piV1FhSTNGRWloYzhueDd0R3I3ZmtTQzZhS1o3ZjIvcndUUVA4MDNU?=
 =?utf-8?B?TW5PWlBHUEMwMzhBYVVDZGhIL3lEcFZnbGpzUlIwbVpQbE9ua3JudGQrc21T?=
 =?utf-8?B?clh2MkNTS2MxZE5zMGI5elE2amd6K29pMWtRSExmUHZRRy9Xd2dNS2YwZWVk?=
 =?utf-8?B?Tms0N0NvMTRiekl4b2kzcFhjaTNGUWl6R0pGQkxSVXN4RmluUWMvZ1ZMUzZN?=
 =?utf-8?B?WW5jWFpoTHQxRjU4RHRPclV4dVowYTZVUnlBUnJsVmEvN3l6ZFozbDNReVpq?=
 =?utf-8?B?YTlmNlJjMkRmOGhUTEtCQ3JxdHBSMENnMVpMMHlGNDhFd2NVRkl3Nzc1OEQy?=
 =?utf-8?B?dmRUeVNqN2RaTDJ3L3F6SHA3R2ZvRHY4b1RXVm5OZ1hIUEZlQVUvbWhmanpw?=
 =?utf-8?B?N2tPb0s0dWtTaGxtc1J1ZHFVV1BzUXpNK1N0NkpSRnR3bTRvd3VCMElScTZj?=
 =?utf-8?B?NjBaOU15VGlWTThlWkczSk5KMC9kMCsyT2lzZ1BmSFBycnh1bEZsZG9CSkNH?=
 =?utf-8?B?TVpHcjBkZHMrRzRJOFFpL1lXTmxTeWkxSkpQWUFERVJQVnYrU0tzS2hOUjNC?=
 =?utf-8?B?eXgzd2pKWXptUWhpMm1vUEdyUEFQdk9pZVV4Wkk2UTRiTTRTWWo1UGh5Vjgy?=
 =?utf-8?B?NWcrNzlaT1NjdHp3UEl2ZGtQSk96a05OL2Fpak1aYmFnbEFEY1RkUzlMbks3?=
 =?utf-8?B?ZlRXaXNlWDNyS3hSR2M2NVk1WU9LZTRTek1zQUEyNHdiMnhJdHNJelhYVVhi?=
 =?utf-8?B?YW5xTDUvb3ZINStJK1FNZjJSQ0k0ZzVWWFMrWUJwL1MrbDFXNVhLZm1hdENE?=
 =?utf-8?B?NDJneTVib2JQMGJyZ1FtWExUaDlzeDV2ZTJFSG85bVZIekJVdm5veFg1OGZu?=
 =?utf-8?B?anhrYmIrZWJPNWsvdmJ4SlFURGFyb2o2MkppY3ordCsvRnZjZ3NCdmcyTWVV?=
 =?utf-8?B?eVNIc1ZRd05GQytXY3Qwd0hER29lZnhPd1Bnb2EyUXZkVUNHalVReVIyNFgv?=
 =?utf-8?B?ajB3RUJjd0ZmRVkzMisydmhod3RDVzBFangvSFZ6OGx5b045SHNxRk9zMkVC?=
 =?utf-8?B?WWNuaXdJTHA2N1RaUURVeFR2VTM1Q1F1Q0Rnb1pqYWNucmY5dnpqdVJURitQ?=
 =?utf-8?B?WU5lc0oxSzFjQ2ZLTzhxb0J2dDFFQUZXOURENjVuazBSMy9wU21vUkNTN1VR?=
 =?utf-8?Q?eWJqwWaWjy10aMhgY3D37ehPjGvOfdYHhvNbe2Tt8HBF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 261c11a0-54ad-48ec-d7bd-08db8a0b6ccc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 16:56:27.9484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ONp9FGJV2gCB+eZCaxY6Bc32PbtCbUIuUbAp1PRUjTQoaZ7On+gn7IUBoDVopUKCMS4PUSXT69jubPDJwLazOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6635
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/23 5:24 PM, Dave Hansen wrote:
> On 7/20/23 12:11, Kim Phillips wrote:
>> Hopefully the commit text in this version will help answer all your
>> questions?:
> 
> To be honest, it didn't really.  I kinda feel like I was having the APM
> contents tossed casually in my direction rather than being provided a
> fully considered explanation.

Sorry to hear that, it wasn't the intention.

> Here's what I came up with instead:
> 
> Host-side Automatic IBRS has different behavior based on whether SEV-SNP
> is enabled.
> 
> Without SEV-SNP, Automatic IBRS protects only the kernel.  But when
> SEV-SNP is enabled, the Automatic IBRS protection umbrella widens to all
> host-side code, including userspace.  This protection comes at a cost:
> reduced userspace indirect branch performance.
> 
> To avoid this performance loss, nix using Automatic IBRS on SEV-SNP
> hosts.  Fall back to retpolines instead.
> 
> =====
> 
> Is that about right?

Sure, see new version below.

> I don't think any chit-chat about the guest side is even relevant.
> 
> This also absolutely needs a comment.  Perhaps just pull the code up to
> the top level of the function and do this:
> 
> 	/*
> 	 * Automatic IBRS imposes unacceptable overhead on host
> 	 * userspace for SEV-SNP systems.  Zap it instead.
> 	 */
> 	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> 		setup_clear_cpu_cap(X86_FEATURE_AUTOIBRS);

Clearing X86_FEATURE_AUTOIBRS won't work because it'll unnecessarily
prohibit KVM from subsequently advertising the feature to guests.

I've tried to address the comment comment, see below.

> BTW, I assume you've grumbled to folks about this.  It's an awful shame
> the hardware (or ucode) was built this was.  It's just throwing
> Automatic IBRS out the window because it's not architected in a nice way.
> 
> Is there any plan to improve this?

Sure.  Until then:

 From fb55df544ed066a3c8fdb1581932a23c03ce6d2c Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@amd.com>
Date: Mon, 17 Jul 2023 14:08:15 -0500
Subject: [PATCH] x86/speculation: Don't enable Automatic IBRS if SEV SNP is
  enabled

Host-side Automatic IBRS has a different behaviour depending on whether
SEV-SNP is enabled.

Without SEV-SNP, Automatic IBRS protects only the kernel.  But when
SEV-SNP is enabled, the Automatic IBRS protection umbrella widens to all
host-side code, including userspace.  This protection comes at a cost:
reduced userspace indirect branch performance.

To avoid this performance loss, don't use Automatic IBRS on SEV-SNP
hosts.  Fall back to retpolines instead.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
  arch/x86/kernel/cpu/common.c | 5 ++++-
  1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8cd4126d8253..a93e6204d847 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1347,8 +1347,11 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
  	/*
  	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
  	 * flag and protect from vendor-specific bugs via the whitelist.
+	 * Don't use AutoIBRS when SNP is enabled because it degrades host
+	 * userspace indirect branch performance.
  	 */
-	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
+	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
+	    !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
  		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
  		if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
  		    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-- 
2.34.1
