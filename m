Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AF42F8221
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 18:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbhAORWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 12:22:30 -0500
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:28768
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729599AbhAORW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 12:22:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwmjpScehQiq2MnDuB3Sx3JC+sjT8Ui0SH7Ke17191gb8ECebA1V8tDk1AzgyPbQnBWM+PAYGBZqINz5DNitd96Qv6n/YD/f3mL5YWT8xM7n32Vl0KPg2R2vMD6osjangg/5DkEkiGLyhyRAkXT6DUiNty/ZDCZP9qLxjhdmcgrwWif08zZvwqfo9SRD9hFpMK+UOyBosXeX631ZwyhTGDsCoEe88b1aHPsaTWxu5dn9RxSYZpXAx7MB/jqDFa3qwVB3tz4aW8DGHe7MyjhSn3tKHVvQe7v42h8FndXRL5zZSrYQDJi3wSTtKAiGlHaPTMXDYMThbCvTXZufnbrNHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CF4J1hbbttjCvzB0KcY0I9jxXx45BP3e7FK7pX8dQ8Q=;
 b=b4lTpWAT9ltXZxX8d5Ytp96x3tYxMWcmmHcDGujcGDX6KfRFsQiQkHwxAejHFgIbqTtL1dWd7GtjVsFMcUr8iNYp4ggTsJmb41yKtFvZnl9FHFoCQDzAcqvxMuVU4qnb6lStr9+Kq+Re3YoeyO4QWIAPIot8CB5ZicMOoEh7mxerb/Ep0kP/R6l2N1ISeiVP2zT4/oXDyHKu6r76WZ87vCzTjMgVm85WWqMdDgbfWz9Kg+gBqR/AxJI1AQpXrdidgsYQYXRMH0/NRxwN7/BojB1uIKI1kFT/+BeQ55T38bPfnOi6l60UmZqNbnULDLVg0gU2g/zTy0u6vB9z/eSLqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CF4J1hbbttjCvzB0KcY0I9jxXx45BP3e7FK7pX8dQ8Q=;
 b=HyhYPihc5ipyZFIaFUpBumFNu34lTt1aMLJXQDA9VJ/lQ4BjukLKvDU4INRRvTGAtiRXfi8zLKk+zWhRtew79QwFhAYRwsYwcDnrrhDhtTi+UJHV+eRR507SbI1n+9mAjhPPJwWglteJq+aM6km8z0oMaVoefOe65MBLXHJoDFs=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2736.namprd12.prod.outlook.com (2603:10b6:805:75::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.8; Fri, 15 Jan
 2021 17:21:35 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3763.010; Fri, 15 Jan 2021
 17:21:35 +0000
Subject: [PATCH v3 1/2] x86/cpufeatures: Add the Virtual SPEC_CTRL feature
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
Date:   Fri, 15 Jan 2021 11:21:33 -0600
Message-ID: <161073129332.13848.9112749469874197137.stgit@bmoger-ubuntu>
In-Reply-To: <161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu>
References: <161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0136.namprd11.prod.outlook.com
 (2603:10b6:806:131::21) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA0PR11CA0136.namprd11.prod.outlook.com (2603:10b6:806:131::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11 via Frontend Transport; Fri, 15 Jan 2021 17:21:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7af23dba-4bfc-48bf-942c-08d8b97a01f7
X-MS-TrafficTypeDiagnostic: SN6PR12MB2736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2736FC400EE3868F1952437995A70@SN6PR12MB2736.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAQUXRplne8pWQ8X932D3ndcMZM8RVToZUKKpM7FZsEx4RRh+glED85Ts8pXj3EW3GJ348zICpqNrbOjUC0XZxaguWyW9/UTZ/WQmWqcTCded1VE3KeHcm06ywT6Ensya8YeIRRMTD/i28imLA26YX3HqZlwtCl95hTm574+04rmw3CNYlah03bzu6Eiy9v2tDrXFqcxs+g9SPwLMMDDE9jet4TKKCu6p8Rluebo0LGU32Ii5IZCsszktZFSBWF/YTm2dKkAEeXntZCYQ9FdBCvppTvDbN5+Pksa2tl+nM/HDd+EPmQvNmc3SGCjz4MopuZUNgUc/oUIJO4h1O7bTgA/OcZn5hZB7rFshiYXIlLuraqIWMwV1kJv4GEqLa3TTiC1lwZ9eIaleWD2Lv5nZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(956004)(4326008)(316002)(5660300002)(86362001)(8676002)(44832011)(478600001)(8936002)(16576012)(9686003)(6486002)(7416002)(66476007)(26005)(16526019)(66946007)(186003)(52116002)(33716001)(66556008)(2906002)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cjVSSVE0TjUyR0RkUWxHTjFacFlGQ3BqRGRFcmJRWDgzYVlyOEZsZzBnTnR0?=
 =?utf-8?B?NGViTmgwQzZUdS9Ici9DMXBuZS8yckpsOC8zRTl6TGhJYm9PdEUxODQyNUxs?=
 =?utf-8?B?UnJiYTQ3ZkduTUdNV291RFNEOFljcGg1S29XNEpSZ1VnVUJ6dlY4QWM3UHlH?=
 =?utf-8?B?QUZmc3Y4MWtWTHZ6TkxTY2Z2RElTWS9yRGRDanZCYUkzd2JlK1JBMlczSFl3?=
 =?utf-8?B?ZHZhdDdrZklldk1TSnlpRVhTVEI1MWxyTVFTRlFpOWtwQ1Yyd2F0VEozOVk2?=
 =?utf-8?B?NE8wYk9UeWNPOWh3Q1hUQjRVMjF5SEkvKzhMSml2TnFYQy85MTdLSGRzMjFp?=
 =?utf-8?B?Nm03U3hORmloaFRUM1NjMjZ6Y0ZBOVZSZFA5Zzk1V2lpOWYyTXQ5VUlLRlVq?=
 =?utf-8?B?Uit0UEE1bXR5YnJWVDZQdisyeGxWWXZpRGFGNGNlWTFFMktvMnRwSWN1ZDBa?=
 =?utf-8?B?MHQrVldnTDRMZ2FFOHFqNVJaODZoMlhwQWJuMWxVK3hCNFZxR0hnNGNxYTV2?=
 =?utf-8?B?UWZzSWlXaHhyTGpZYVRjYVVGaVVHTEtqNTk2bVNhdVF1clBLMGt3KzVGTUxU?=
 =?utf-8?B?SGRrMndOWFhlWWdSYmUwT1pDLzNiVGthelJrSDRnRVdsL1dDQXpyMzlmWW93?=
 =?utf-8?B?R3p6VTVTdjdKTHlEbUlOS1ZxMStXNFlOZ0JBT3FyeVM4anlINExzU05xRWMr?=
 =?utf-8?B?bFJWMWU3bGR3dXBBYWdITGQ4Z1MvMVBvbkxLSnZldTNHYm9GL1dHOU1WMXo4?=
 =?utf-8?B?dGdGZDIwSEExNVZQQTVjRGFHUkNIRFk0d0lkN1MvSHo3NTdQMXZBcCtSU3g1?=
 =?utf-8?B?d280VVhMR1FHeVdnWURibStzbnRxMStnWHI0S21HbHc0TXdIVWw0bzI1QWlw?=
 =?utf-8?B?VllxamhKYjVxZWdxdUNWZmUyUU12NUdCYUZmMlJQcTBENVFVRWVrenhHQ1Vo?=
 =?utf-8?B?RE1kMjFiRlllaVp6cU9iY3Q0ZFJRYTE1eVA3blFtYzNvNjlRZUwzT1YyNnBz?=
 =?utf-8?B?bkVqNGNVUEpDUGpTYWRFTHVYWDl4eUtqcjBNU3VhdDVqNnB3T3kvSW9qdVQ3?=
 =?utf-8?B?THp0dGpxbDQ5WS8rN0lwNVBONlNnaEFvQVMyQkhMZXV4YXAxd09HZ3NGOE1T?=
 =?utf-8?B?Z3dQN3NrbURHVFI5bmJMMWRHcy96TkNEb0ZiWWFQd283VThobTdxRlpHWFRD?=
 =?utf-8?B?cndJQzZKSmNUeHduODkxUVJaQ214WGJLNkdiUFpxaW9URHd5bGtabmRoa0kr?=
 =?utf-8?B?a0NJUHMxbEMrQ0Z6UmM4MmNPVFdaNG1sbVBZZXBqSzZoR3hvWm1DN0FoSGpW?=
 =?utf-8?Q?ntfuLj6v2nzb0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af23dba-4bfc-48bf-942c-08d8b97a01f7
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 17:21:35.0302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EuKQjiAa0tXpvAENDcNBAN6Z9RsYxmBNpjJ3Zrd4KOZq6pvVvIiWJZc0JEBj6t4W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2736
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

