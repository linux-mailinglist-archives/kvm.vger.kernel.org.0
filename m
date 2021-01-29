Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63333082A2
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 01:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhA2AqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 19:46:02 -0500
Received: from mail-dm6nam11on2040.outbound.protection.outlook.com ([40.107.223.40]:41665
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231459AbhA2Aos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 19:44:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKq6Vka/tWULRoKEe/S6DQG5AgkBeemdA6TxOI2Y6rBHB/LW826etPHHCrJhDUYN1Oe9mjisX9Ks5Dwm4NTpGUfqpbHE6EqsdqXs10E7zztYInAuIMCcnTeCF0cVMNHleG+RjP6B9UP7wF+r9s9ZpIeCjcku8+xoB6Dgo0IAA/HvNrdzyEhOlwbIgrvtFb5EmWgWcd6OZYgGbrlGsWiduH5IwQDGRBQAPuwhIfWVDRbY8xp5m2807Rc3BUkzrMOOhsLs76e3nsH/EQrbz5PehrTqmg+N9iYgpcyfsvcjlBuNo8u8d1pqr5EGeAwiDUVEG2yNbX+p7dY6EviV9wmI0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CF4J1hbbttjCvzB0KcY0I9jxXx45BP3e7FK7pX8dQ8Q=;
 b=BFB2HfBMAGQUBBSkPimiOcSl6T+fp/ERYjjHh8hNoAkLOh20GjKZXTzOF8X5PYlPFV9TjVpULLR1CJtbXPi3hDQCZ4I72p+La5eXVKKcFX2OQT/Y2X4riSftIYyZ4uncqTDRlB6pZZEtoZ5sn+bPIbDOGWiJv5DPR+pMUQ7zU7ToYdZfZdNBJ80ZcLohpR+di2oEFQIKpTedc4PM8H65Dj+xfpvsX5RVgpPPj9H02PE7EdgAyDPBTjCb/yZIJOIUK8XKrn9RvE649g1akyMoXYX6+BDE48IDNEzP6eR1BpFPJdi9tlmTQAx/zFYDCAEvpCpVRfqnU2mgtQO8HmUnjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CF4J1hbbttjCvzB0KcY0I9jxXx45BP3e7FK7pX8dQ8Q=;
 b=V5P7WmaDwYwn9qNupGJpOVVaOJtpW4QONnSpUSvrQh18Z7t7nyhZ81HjX0MBFC3xdrbhjevQSdrkgTFdcmvZFsTAjMNtHzh8BMhJO1AcBo+2RREVKxEijKUdG9vBBYSfV1GpgYQwaALYwomwfe+OKMrPrN/86IxST5ameSZia/E=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 00:43:24 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 00:43:24 +0000
Subject: [PATCH v4 1/2] x86/cpufeatures: Add the Virtual SPEC_CTRL feature
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de
Cc:     fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, thomas.lendacky@amd.com, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com,
        jmattson@google.com
Date:   Thu, 28 Jan 2021 18:43:22 -0600
Message-ID: <161188100272.28787.4097272856384825024.stgit@bmoger-ubuntu>
In-Reply-To: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
References: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0236.namprd13.prod.outlook.com
 (2603:10b6:806:25::31) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA9PR13CA0236.namprd13.prod.outlook.com (2603:10b6:806:25::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Fri, 29 Jan 2021 00:43:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: de15430a-e38a-48c1-bd4f-08d8c3eee278
X-MS-TrafficTypeDiagnostic: SN1PR12MB2560:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2560658094386A689B8A41E995B99@SN1PR12MB2560.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/gjyunOwikS2pHW0YuWutY7hq++DPgcetead33dAtVgSGHt903e/Rmt49qEv3bbXY3tNMWbkwA+Wzx7EsYLxqLpV/ptrbIEpWzLGs7/JD8Ralby8koqSBim5Xlxm4xnDdFEVyusl4o+1MqAerrmXSSsRtpw2fJZC29ZPuydABpwI/5ZCnW2IB/iajtl2UaueZ6W4qMctprDuHuq5WvXfedkdAIh5Yi3xmfdApGWfPfoJf4CRMW+rQTfg2GMWdyD3cKio1vNap1+Cd3ba0FQQ3aC5vLm/seM+9TWShp21RqE1CPnw75/jvZV6b9EFfaHJOvc6IhVs2VUgMTAuxq0c4Y/1A5gB15+uKBB2eLbOGAGE50eeRtiNrXLo/VQP5q2rEheAKWomjE+f3/ekjvRwjkttM9kAIosHehuyn3kqjUwdyEjAFAgR6D70FV65HaWp2858Cae/HXwgt+qn0PVH9H3XDHaVohHrdVk/n6VR8wptZhvizKcheOS/2zy+PGg3Y9npJXWQVikmKsn+wBMDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(39860400002)(136003)(366004)(346002)(376002)(956004)(16576012)(52116002)(7416002)(8936002)(8676002)(316002)(86362001)(103116003)(44832011)(16526019)(186003)(33716001)(4326008)(478600001)(6486002)(9686003)(66476007)(66556008)(5660300002)(26005)(2906002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dnlqREkzMm9ZcHhubXd0VXlpdmRxbk5GUDR3MEhGeHIzV0NTNU5VWmxNM3hQ?=
 =?utf-8?B?bEk3U0JDekg5SnlwVE9rUXlrVGdNVnc2TDBGTXh3VTE0Y2sxSjZKdDZGRW95?=
 =?utf-8?B?aUJOYURMSXVsSUsrU2l2aDAwNzhjb3FUclhYclVNeDFkUGZJY0tXMFdEeEhp?=
 =?utf-8?B?akoraHRHbkpaYjk3c2dEbFpOblUxWWxRdi9jSjdnRXd3VmVrbGxhaWgzUzlC?=
 =?utf-8?B?bGxGN2hjTmJvYUpDN0d5M0dXakVmK3BhSjhpUm5MVTFZV1JHM2JMa0VmMWVB?=
 =?utf-8?B?dTg0WE9xY2ljS09XZ3l0d29URTZzUDRvbHcyU08zOUNhU0ZlMVgvdncxWkxr?=
 =?utf-8?B?NzYxbTN1TFNrSHMwaGlMNDJFcFE4UlhBZTgraFh4dlUvRVU4a0w0WFJoOVJF?=
 =?utf-8?B?b1NxR1NFcTlXbmRnUEFRUWpQOW0wR0pXRkcwdHIvdE9CZ0oyeXVFYlRqWVFM?=
 =?utf-8?B?WHhLQzkzMWtvSkpITWhmbThyUVVwbGRuMis1MVRXUnpYc2x4bkpRQTZKTW5x?=
 =?utf-8?B?TnkvS1NkOTkwY2lCeFA2UzluVDllQjk1SEtzU0dlL1M1c09PTVV4aUoycGtH?=
 =?utf-8?B?KzB2T0xBamVXRG1HdFZaU3ZjM1lUaVdnVlczSHJlZlJNSDhReDJLaUVzZmUy?=
 =?utf-8?B?ZkpGc2xVWS9NUURvd0lUQ2NVYlBIdHBaS24vdWJxaVhQallmRkpjeDJ5ZG5W?=
 =?utf-8?B?SzNUb0M2RnZDVU1wd0hyMjVvVDEzOGM2cUhDN0NielNmZUQxS1dQdFZVYWV6?=
 =?utf-8?B?b24yWG1nUTcvWGkvUjlCRHdoVGFuNjV6Sy9KeFRUbGVIbHdjMDNTdVRRb3Vl?=
 =?utf-8?B?NzFua3lMNlgvSUUrbnE2VTNqQlFYRGR1RWIySDZBZXdFMU53MTRKemVuaHRI?=
 =?utf-8?B?WHFPL0F4R2dibFdtOU84bGJsV05kdlluSkZma1lNczNCcmxSTGM0eEJkVWQ2?=
 =?utf-8?B?WmV6UnFnUURpLzZvSk5sWm4xSVp2SEhtampaUW1nb2JzbkpaRVBZMGRxbFNs?=
 =?utf-8?B?bWZ3dHlqZUJ3eXFYcmpNUmxhZmg2aytVby9wemlTQzUydUxzNVRWKzNiUE5J?=
 =?utf-8?B?elF6ZzJGbXZZOFIvMXduay8yU1huN0J1MW5Qd2dlNUl4dUxnWGIvZnJuZnF2?=
 =?utf-8?B?dkFIVm5HaHZTaHFwZE5qVnRMaTRoWm0vOXhLUTBKM2orbU0zcGZOY0NXV2hC?=
 =?utf-8?B?eVB6U2l2RUc4NllFd2p3YnZlT1RXZHp4OTY4TDg3RVR6N0ZOVi9FRUs5c01F?=
 =?utf-8?B?NGZVcndIMHlxd1V4YjRtTzJob3lFOFdSVmk1bFRaMjI2WU1tUDNEUjhqaHBD?=
 =?utf-8?B?MW53dDJDUXlBVWFyWnpEMnE1VE5CQmVoemNNYnlCWVZhSWI3UHZRTjJHRE91?=
 =?utf-8?B?dFliY1pCQkdSWTJSbmg5QUlxZG11MjVFdGVoSXh1ZlVlT0R6SENUSmtrUjBU?=
 =?utf-8?Q?lca0qFqN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de15430a-e38a-48c1-bd4f-08d8c3eee278
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 00:43:24.3610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSSRzNK0lfttjnTULG947f13wFC1Bgli6ByHLmsZnMjfjINJAN49gJ/d7nbdMFbR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2560
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR. Presence of this feature is indicated via CPUID
function 0x8000000A_EDX[20]: GuestSpecCtrl. When present, the
SPEC_CTRL MSR is automatically virtualized.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 84b887825f12..3fcd0624b1bc 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -337,6 +337,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
 #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/

