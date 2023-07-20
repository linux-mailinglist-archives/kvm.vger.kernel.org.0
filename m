Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96775B799
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 21:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjGTTLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 15:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjGTTLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 15:11:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18159E;
        Thu, 20 Jul 2023 12:11:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKZ7LZO9LXE344xUzv2b7FmbfMnpwRGn65uolrxV3JuDc2gNiE/XFCBmjmlVLlGHpX0GjHVMgI3wwHJSz1mFwPeu+Wt0X4U+3fUqWp+g+lvSZ0lGTqcR9u2tKrKH/pJFOW73e9O1AxrM5+PKZNci+onkT2n6BYJAlU3Ut5qhcl74bm7k8kEuOoDPBMq/QiGnzXYJ/LisjPhObse5G7fUSF4yc0qdrhguQ0lDyL4vJdcPsW94AfcYMKimfNOQb1/UeEjcqMENnnhNWh58/+vANhMDLB2h3GRR6f3hyF8zahxLt/eIEzHRhEW1Pksbk08gFoSk3hC8vS/m+aSVWnNnwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HF08v0YjbDlgUIEEG9sIEHxgjF+Irmaa20Jud8VnW14=;
 b=oJAuj5QO1/+x9sQSW8+z9nRxDpisJkbFCjc+EmIKtxTjE85iHNsFfqurT3TAGXUmjfy8UN8APg5OEyK7HSZEX5mA/b1kgh/057SRetN6RrOzcCVbuq26wPlzWzz4xOhZC4w2km4R0he2xr5mK0a/nc28u78nJYLqpkZNdOjSTzrRolI71TLN0YCRuVxt+EqqejKPr9enouRDY49XefTd0A+uM2wUOISQZJaCGFgUghsHxKymZ0N9gjvHBVDgV9uRKxgha1JQB0FmuRdgu9J3+bL4bEpF9ZHXg1VvSrG2xOCy40i4nxF8tEINkpL6s8ce0eThtr2Y5NXCXE48V3CHWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HF08v0YjbDlgUIEEG9sIEHxgjF+Irmaa20Jud8VnW14=;
 b=LRGW3JqjXTFjPOFpjBEI5e535vteKisPXyNjG/1H6eaz4riGNzBWXXdaMt9fmd6LyFWNqFcuoe3FmXIhAns68FxkIaiPVK/UprkCKDWrklR6/84A21cudDUIrjKz22Y+qOJAWKBwOpS0INLm+Oiv5KAe+0Xgsj2kDO1JbFIFBds=
Received: from BN0PR04CA0194.namprd04.prod.outlook.com (2603:10b6:408:e9::19)
 by MN2PR12MB4304.namprd12.prod.outlook.com (2603:10b6:208:1d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.26; Thu, 20 Jul
 2023 19:11:32 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::c2) by BN0PR04CA0194.outlook.office365.com
 (2603:10b6:408:e9::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28 via Frontend
 Transport; Thu, 20 Jul 2023 19:11:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6609.28 via Frontend Transport; Thu, 20 Jul 2023 19:11:32 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 20 Jul
 2023 14:11:29 -0500
Message-ID: <a11ba4c9-8f6f-c231-c480-e2f25b8132b8@amd.com>
Date:   Thu, 20 Jul 2023 14:11:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To:     Dave Hansen <dave.hansen@intel.com>,
        Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-9-michael.roth@amd.com>
 <696ea7fe-3294-f21b-3bc0-3f8cc0a718e9@intel.com>
 <b8eeb557-0a6b-3aff-0f31-1c5e3e965a50@amd.com>
 <396d0e29-defc-e207-2cbd-fe7137e798ad@intel.com>
Content-Language: en-US
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH RFC v9 08/51] x86/speculation: Do not enable Automatic
 IBRS if SEV SNP is enabled
In-Reply-To: <396d0e29-defc-e207-2cbd-fe7137e798ad@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT087:EE_|MN2PR12MB4304:EE_
X-MS-Office365-Filtering-Correlation-Id: bff98c7a-843f-4386-8ead-08db895520f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p0wQy22Jpw+LxeV1rQEgtQSNHnzR7TfU41AT+LCg0ljqd45B5vf0EWrshMVWfLxzN8eeR/GnNrEIupyWQ1CndzklHM91SR6ViBX0tn9ou+Kk3ik5lpRiO9U6pIXRQXmoEpSyFQYFMRbIsUQhfySeAA9E1jLTdwc7L9Fs92cM7SJixYqx8pUkho52NnBlLLeqxxXYgOcopEY3ksjh8uKy8VX67dMxdT0dl17RsvBiDMFADisLCfQwuzXXKjDJBtICiKzDkrAEUrgO67K+x5ToAvsuRjPbRr1hrP1wUrZJ46xmsILmEbOqc9MOE91A0XAGhuxw7W5MNBMs7+XD14eL6H91T8oXHqnDV0x2ytM4+4UX4kJbXN18KBUJrgZjAHma7SUOGhJO6UJwmUbbeTLRI4Sm1vhAms0TRE9vx5jph4DAmcTOBkz4yR9IxyzcTPrL5ULXBOaZPXGxoLCTP7oWdrBTwwYyxFh4n+GtrVXxhtHaV0iNKXZnvfjGJ/nix7oWX6sRrWifAngHnq/GwjoZBevf/aSj80dWPnT1kuEr/q+bdCgHI+UCz+cssAkiA+rFUgELWHlttCHzAGZ2HxlKij5Usl1HuzHuxk4SgjX1l/sL2BxcMER/sRTbuyY5tbI9NFRjVsF3KLaxFz23QRz5cAa910Yy7hrpfI0rB6nB+FC+Hjah29OkZQKGl0c+rG518EFNYIIzi+tinQTGsXxWVwyLIhx8julwstXq8cbNYAybLwI9vAPfjk3MwTrhYMXhGeQLzuarTdc0bJulLBEJ0xr1AxUaafJ97GBz8fraHLQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(82310400008)(451199021)(40470700004)(36840700001)(46966006)(336012)(186003)(26005)(6666004)(16576012)(316002)(70206006)(70586007)(4326008)(16526019)(40480700001)(966005)(53546011)(41300700001)(5660300002)(54906003)(44832011)(110136005)(31686004)(478600001)(7416002)(7406005)(8936002)(8676002)(2616005)(356005)(47076005)(426003)(36860700001)(40460700003)(83380400001)(2906002)(81166007)(82740400003)(31696002)(36756003)(86362001)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 19:11:32.0621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bff98c7a-843f-4386-8ead-08db895520f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4304
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/18/23 6:17 PM, Dave Hansen wrote:
> On 7/18/23 15:34, Kim Phillips wrote:
> ...
>> Automatic IBRS provides protection to [1]:
>>
>>   - Processes running at CPL=0
>>   - Processes running as host when Secure Nested Paging (SEV-SNP) is enabled
>>
>> i.e.,
>>
>>      (CPL < 3) || ((ASID == 0) && SNP)
>>
>> Because of this limitation, do not enable Automatic IBRS when SNP is
>> enabled.
> 
> Gah, I found that hard to parse.  I think it's because you're talking
> about an SEV-SNP host in one part and "SNP" in the other but _meaning_
> SNP host and SNP guest.
> 
> Could I maybe suggest that you folks follow the TDX convention and
> actually add _GUEST and _HOST to the feature name be explicit about
> which side is which?
> 
>> Instead, fall back to retpolines.
> 
> Now I'm totally lost.
> 
> This is talking about falling back to retpolines ... in the kernel.  But
> "Automatic IBRS provides protection to ... CPL < 3", aka. the kernel.
> 
>> Note that the AutoIBRS feature may continue to be used within the
>> guest.
> 
> What is this trying to say?
> 
> "AutoIBRS can still be used in a guest since it protects CPL < 3"
> 
> or
> 
> "The AutoIBRS bits can still be twiddled within the guest even though it
> doesn't do any good"
> 
> ?

Hopefully the commit text in this version will help answer all your
questions?:

 From 96dbd72d018287bc5b72f6083884e2125c9d09bc Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@amd.com>
Date: Mon, 17 Jul 2023 14:08:15 -0500
Subject: [PATCH] x86/speculation: Do not enable Automatic IBRS if SEV SNP is
  enabled

Automatic IBRS provides protection to [1]:

  - Processes running at CPL=0
  - Processes running as host when Secure Nested Paging (SEV-SNP) is enabled

I.e., from the host side (ASID=0, based on host EFER.AutoIBRS)
If SYSCFG[SNPEn]=0 then:
      IBRS is enabled for supervisor mode (CPL < 3) only

If SYSCFG[SNPEn]=1 then:
      IBRS is enabled at all CPLs

 From the guest side (ASID!=0, based on guest EFER.AutoIBRS)
      IBRS is enabled for supervisor mode (CPL < 3)

Therefore, don't enable Automatic IBRS in host mode if SNP is enabled,
because it will penalize user-mode indirect branch performance.  Have
the kernel fall back to retpolines instead.

Note that the AutoIBRS feature may continue to be used within guests,
where ASID != 0.

[1] "AMD64 Architecture Programmer's Manual Volume 2: System Programming",
     Pub. 24593, rev. 3.41, June 2023, Part 1, Section 3.1.7 "Extended
     Feature Enable Register (EFER)" - accessible via Link.

Link: https://bugzilla.kernel.org/attachment.cgi?id=304652
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
  arch/x86/kernel/cpu/common.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8cd4126d8253..311c0a6422b5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1348,7 +1348,8 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
  	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
  	 * flag and protect from vendor-specific bugs via the whitelist.
  	 */
-	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
+	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
+	    !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
  		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
  		if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
  		    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-- 
2.34.1
