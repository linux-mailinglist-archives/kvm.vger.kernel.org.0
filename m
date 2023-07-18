Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A106175888B
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 00:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjGRWeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 18:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjGRWes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 18:34:48 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB33CBD;
        Tue, 18 Jul 2023 15:34:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frYhNuwFTiUkHUp0pVoo49Fh2zSygWpfk/+hESePeINE/E9sgW/n0rClBSg1y+QC0IzBUBEjyIxB5//OLrdZ/Ed6p8SUxnH51B8dP59uNATm8tSsQfG0jEjOSOR82ox/Z9Uxs7eSA01ZSmn7d2ehPTLk80M0bip3cDSb95BJkshOMjOTVG+RYgV5NzUgjjwKEydQ0nXWI53LN+WL60HH0hmJRmWPTQhhpbCwtxAqku6V+gRKKS0e4MZBXqtDbyjcVrOFkZysKcgFeFOprbXDuOYCTu7sqw5pRaCiloMQ54JDUKnXQigrgO0UsN7LDYxLye1LeUOYH4vSSebCX3hZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QL+QCEmAvI9Or2D2l7WCdz3umSrHHc1RZyajJt49EE=;
 b=ks6eJzX+0yFvo+5Ypbd79qb0P2Y4tXV0pBS01geEIWvk6lEU6RQ+7JeKsF86VNwubqviUb4GZIyp9OqegpPtwK05JcbtT9TVk9WZM6DaHUyWgOsxsM2VSE7ZEHSlTvay3KTuRRPeuQMKAH1gUCNrWnRQXlO/65HCVrBpQ+ohrCh98vn1Mu5FUKEgQUNeqNIMWOzehIj7a+CN4dYmDwIX4jBEI/ErsF9woqCDKrV7HOSqJlUnDmUba2Qf9ArqcykHmMAGCflo3+bzWwIqpP1/6+QBUdsAcEfipW4AnGMYNctgZ2YsHVA7/aOVZpOpiXBT8TObwwxjM1d3YnMTcLHhpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QL+QCEmAvI9Or2D2l7WCdz3umSrHHc1RZyajJt49EE=;
 b=lrqws8lX08rGB28cIof1xp1kGdrzJjtkhvrMtvKtgCph2WNpn+QDVvjHG5pavqEfRGuBJwHeE+a0xtm8Zf0xWdSXmsgSzpyz2XBowQSqaD99iOrzHy+nX3QL5p6AIaOCJDG9KM3Jk9Lld/mdT7iJVUPS6KRzTP881bZ5gpFXdnU=
Received: from DM6PR03CA0052.namprd03.prod.outlook.com (2603:10b6:5:100::29)
 by CH0PR12MB5387.namprd12.prod.outlook.com (2603:10b6:610:d6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 22:34:42 +0000
Received: from DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::58) by DM6PR03CA0052.outlook.office365.com
 (2603:10b6:5:100::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33 via Frontend
 Transport; Tue, 18 Jul 2023 22:34:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT113.mail.protection.outlook.com (10.13.173.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.34 via Frontend Transport; Tue, 18 Jul 2023 22:34:42 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 18 Jul
 2023 17:34:40 -0500
Message-ID: <b8eeb557-0a6b-3aff-0f31-1c5e3e965a50@amd.com>
Date:   Tue, 18 Jul 2023 17:34:38 -0500
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
Content-Language: en-US
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH RFC v9 08/51] x86/speculation: Do not enable Automatic
 IBRS if SEV SNP is enabled
In-Reply-To: <696ea7fe-3294-f21b-3bc0-3f8cc0a718e9@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT113:EE_|CH0PR12MB5387:EE_
X-MS-Office365-Filtering-Correlation-Id: 11c184ce-03f5-410b-282e-08db87df2e12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1YYsrP0hQ/P27PiAe6epnE6OnoMtqCki7F1wqrZsbwM0qyfOKbzc3LE8nJW/YtltaL1u1X9hkkXPAHqCRaHNNGPuS893yHD8vJPUJdF2HvxkDGnZQ28lTU5w2/F8gRzsm4iihymWVzQcELpeeVG9xp6vQwZNCqK2VnRnLg4ASbRVAaAqD4dnnbQY8SLdqJ18t6iXJSw0FzZf1LM3wpanXlqcV5XcMwOWxgZ05HjCKyyY81Q/+EcTApTABsi8DHONzPOdRU1P7/4szdg5lpV3mniRhJOajDdIu+YfhgIETJDTHB4GVKB9YnYehjGbuKPf+uFldviP3JZEc2wsZ3TA9qxDObYSVhoi0e1ibj4dKEnhtpeyWD9gHKovezu6qwjfhwxB4dvJJSfWJpYB6TFQokAhgLAaxoURgRjGKrLDLCppr3caWOjN5/MMnnIwJrwpfUlT6PzU7hiQX3KXYWMoXhtgo7SRZw2hBLiYHAPTOqngCre66S4idqrEob7Zwji6TgHuYGo33hRPzIOOFkf5IEoOzstTwBvegGh5CXOcBXRKtwnAXK7lt4C93m/nVfsaZ7DzOovqo4VE4k5uLQK7uDDxl4JnO6ocNh5kjeqdNMkBa88Uc/f2edgKpaDqEqg2fXbV5t9vaud4tg/SVZA4rkPRr7vK/ZOqrGtrnXRD6Yo2aqhsSmuUxRkJwIiPsjZDkbwix8HGxlUTnAOV6hn4MhQIGKfZxZ2YsT3DSXYBA2ytnN6mkVQGeUnp2UjwcHr/AkJ3SDJxYZvjpFAIyjd1JRCXW4es7Md+mR//cKZqU0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199021)(82310400008)(46966006)(40470700004)(36840700001)(82740400003)(478600001)(81166007)(356005)(26005)(40480700001)(53546011)(966005)(40460700003)(4326008)(83380400001)(426003)(8676002)(44832011)(7416002)(5660300002)(16576012)(2616005)(47076005)(316002)(41300700001)(7406005)(86362001)(31696002)(2906002)(8936002)(36860700001)(31686004)(186003)(16526019)(336012)(70206006)(36756003)(70586007)(54906003)(110136005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 22:34:42.2518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c184ce-03f5-410b-282e-08db87df2e12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5387
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

On 6/12/23 10:39 AM, Dave Hansen wrote:
> On 6/11/23 21:25, Michael Roth wrote:
>> A hardware limitation prevents the host from enabling Automatic IBRS
>> when SNP is enabled.  Instead, fall back to retpolines.
> 
> "Hardware limitation"?  As in, it is a documented, architectural
> restriction?  Or, it's a CPU bug?

It's a documented, architectural restriction:  When Secure Nested Paging
(SEV-SNP) is enabled, processes running as host are protected, but
those running with a non-zero ASID, are not.

>> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
>> index f9d060e71c3e..3fba3623ff64 100644
>> --- a/arch/x86/kernel/cpu/bugs.c
>> +++ b/arch/x86/kernel/cpu/bugs.c
>> @@ -1507,7 +1507,12 @@ static void __init spectre_v2_select_mitigation(void)
>>   
>>   	if (spectre_v2_in_ibrs_mode(mode)) {
>>   		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
>> -			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
>> +			if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
>> +				msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
>> +			} else {
>> +				pr_err("SNP feature available, not enabling AutoIBRS on the host.\n");
>> +				mode = spectre_v2_select_retpoline();
>> +			}
> 
> I think this would be nicer if you did something like:
> 
> 	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> 		setup_clear_cpu_cap(X86_FEATURE_AUTOIBRS);
> 
> somewhere _else_ in the code instead of smack-dab in the middle of the
> mitigation selection.

Good idea.  How about this?:

 From 6cf32e8d8426190b1bf1b1e04ceb35bf0bac784b Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@amd.com>
Date: Mon, 17 Jul 2023 14:08:15 -0500
Subject: [PATCH] x86/speculation: Do not enable Automatic IBRS if SEV SNP is
  enabled

Automatic IBRS provides protection to [1]:

  - Processes running at CPL=0
  - Processes running as host when Secure Nested Paging (SEV-SNP) is enabled

i.e.,

	(CPL < 3) || ((ASID == 0) && SNP)

Because of this limitation, do not enable Automatic IBRS when SNP is enabled.
Instead, fall back to retpolines.

Note that the AutoIBRS feature may continue to be used within the guest.

[1] "AMD64 Architecture Programmer's Manual Volume 2: System Programming",
     Pub. 24593, rev. 3.41, June 2023, Part 1, Section 3.1.7 "Extended Feature
     Enable Register (EFER)", Automatic IBRS Enable (AIBRSE) Bit.

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
