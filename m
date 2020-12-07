Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24552D1D81
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 23:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLGWiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 17:38:51 -0500
Received: from mail-bn8nam12on2086.outbound.protection.outlook.com ([40.107.237.86]:2913
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbgLGWiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 17:38:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0JO43OQEYOwSsJ53fEgMAl/tyAv3gjeLdiuVmKUs2WX7iqHV8vlzhccVFXQvCzaI662RVCQHVye8IrQqJgMi9tZq6ZgjJ952thVtAHXWEYA3QvWGNtSfR4EH6mc6R04dQF2l+TNoD8pxbXJg8VRCDTVcwjRAn0iCymo6UOZsIK9f/zTCrEHEK4djVMYnAXe/NXkw7CgQxf2JwcM/sxF2rkPWU43eNIVFzE1lOita0MVGX4ZU5HT72s/Pjy1h+3wmiaj2/Y5tjgXsZQ5kS7srAfiJAigpqbYLvgNf/AECVMQXMoexNqhDrM1FAK6gM90HNE9y892baatw3QRSBJ2bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoQYyh6yGJCrZs5BesxAmBbidfZrsBZzhpoIav534RY=;
 b=JGI26UA5PJ/KbF2UoqQYv1IsNZUCzeu3tlMO1k1M6woDVwhW5/Pbzs/yzNFqnWiDcn4Eoen0AvCkUyZmSzJgL260c3AEk4j7ajG5gFL4Ye9EFqVFWTOZYGH5EU5Im580Mf3mVCxBfhR/9YjzDswI99PkX/ZyKpHNihyTEclEk1ePay+O3vk/0bFC+WZyGGktd92A6pxbVswhnOCb2S2krBIVL8xSJbT74LOXpAXHrWhLESTSo7U5tR9MzGsHWfSU5X0eq8qbTYOcznfgIttQsw+ShW8BPsxKMzVWvEnxXbRlmRO7P9wCBcHl9AJXTG5zGR+G7ifBAYK9wA0YyiiO2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoQYyh6yGJCrZs5BesxAmBbidfZrsBZzhpoIav534RY=;
 b=j8L1uFLsgE0k1/zNFGoIm/tdh7tUOSsU3R9K9mqtW0zuL54m0U3TLg6sN0lEz3jEiKiKDkvtJ0KGepj9+X9EWQo52trYf5zeJsOVrwlz+yVvPOAovYD4TfptA5iu8ezuKxFhCwd+uJh3bfW6S7JEPq/veVEyckkMzwa8UzE+CdA=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Mon, 7 Dec
 2020 22:37:55 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 22:37:54 +0000
Subject: [PATCH 1/2] x86/cpufeatures: Add the Virtual SPEC_CTRL feature
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
Date:   Mon, 07 Dec 2020 16:37:51 -0600
Message-ID: <160738067105.28590.10158084163761735153.stgit@bmoger-ubuntu>
In-Reply-To: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:610:59::31) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by CH2PR03CA0021.namprd03.prod.outlook.com (2603:10b6:610:59::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 22:37:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2abbbe8a-3ef4-4531-6b6b-08d89b00bd39
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2384E171611A3B7C12C447C995CE0@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZbvmMG1b9VXHlo1Bar6PU5RPeVRGgeP6CTYV13eJcdpPFPYEC5u7ckMUhRRyXn/3ymWLdB3Y3gScnlSMHTrDcsmrS/mDYG5GRM21Fm+Gp8gmyqHUsDPGCOxltDmNhVsPtpQ3oNm/vyqb/iv5eZkMY2DgtWx0kikm8CWNLnHiUxZVTFNs3juzrkuQF4r64YP/bL62klGMHTu6tHQ22kEdRzCf2qVftCgkt9kg1KsM1WwOp04339wDmal5oFrETs1WK9D/b85I8OKwmtYmJa7PS8WuGGz0Lb9b+hA9F6NW+2eHap87MOHP5+VCiiMRnVDdiaGSkNlGUVhKT6nz+8I3Cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(396003)(39860400002)(376002)(366004)(136003)(2906002)(7416002)(9686003)(478600001)(8676002)(103116003)(16576012)(956004)(8936002)(186003)(86362001)(44832011)(66476007)(6486002)(52116002)(26005)(33716001)(66946007)(5660300002)(16526019)(66556008)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eTZRbkU3L2ZoWlVpVzJYbFd4dC91THIwT0NvZThjdDdSUFQySzhDQi9DUlVM?=
 =?utf-8?B?SjZtTTB6Sy9ONjRpUTNPOWNycVpjU2ZmODV0Ylp4d0FNVkVIcUFwbGFoSE9W?=
 =?utf-8?B?QStWZEZMUjczVG5LS01peVF1b0ZpV29RVkc1Rk5jMGtXaFBJTVlBcWd3STdE?=
 =?utf-8?B?OVkxOXFsa21ZYkRmclZVSlhZUC8rVHlnR0RlZmRrdXFmUElSMVFFMmZJOHlz?=
 =?utf-8?B?SExLVk9zMnEweU11L2lmdVowSmhlS28vUlJJd1R6QklSWHRoL2c5UEUvazNJ?=
 =?utf-8?B?d3htU0Jmc3JCK25jeUs1UzNNaEk1OXRta3JKb1VhOU9QWlg2TG1rd1gxalQy?=
 =?utf-8?B?V2ZkdzJHMGFwZ1ltaVZMVHNkZ2pGek4vNCtWbUQyWUlWNHJOTkN5TWNiNldW?=
 =?utf-8?B?TktGbXh6WmFsc0RPK1NBMG1ZWHhxWWhZaEcxL1lWZExKMXVvQ2V3eGhvVGxY?=
 =?utf-8?B?RFVJQmhTRlk4OEtqUVcvczlCS29Gb2E5Nm01ZGJqaXVTR3dmQTZIRWY4Tlo4?=
 =?utf-8?B?WTIvSkkvaS8vY2tNOU9mWitUVFVkdGl2S2VwUWtZU2FJR3VlL2ZoT0lybTVM?=
 =?utf-8?B?TkhLVlNhSm9MdkxXSW1SS3FYQ3h0NkxDYlBDejdWRXRjU0VHN2E0RGtGallh?=
 =?utf-8?B?TENkKzVHUFNpeXA0Q0dGNzU3VEZ3dlFUZTIySDdaVTRnRU1DMnNqUDExejVH?=
 =?utf-8?B?RTFVUXFTQTNGY2tQUDB6TktvaktyajBCV3dOZDFrc1FnNitPa2ZwWW9nS1E1?=
 =?utf-8?B?Mm1QMXhZcGdROTRRRmdFZ0hQMVZKMjc1cnozcW51Q3FXOVdtTmNNWk9BdkU3?=
 =?utf-8?B?ZHNVdVJCN2V6S3hiMG1oc0hmS2d0ZlNvc29VM0lPbWN3UHIzaXlQMzJNN05z?=
 =?utf-8?B?bXRoRUpsWDZld1BkSjB0elE4S1A2ak9sQVFzRFoyc3l1bVBYZVpkUjNYTllM?=
 =?utf-8?B?WFdYUTZWTysrb0F0QWRBVjdwTHpQWUR1UEdOOCt4SlN6R3lEbitMSU9CZ0gx?=
 =?utf-8?B?UUVYa3pZYlR1V3FUdTFLak9sRTJ1Qm01cHNzRWdjUFQ3YnFiUXlDbW82MmdJ?=
 =?utf-8?B?eGxNbFhXTURwZFF5SlNsNjU2VTVaVGRmWDI2ZW9JQ2ZZZ2FBdW5QTEVNdG94?=
 =?utf-8?B?alNlLzBkeHExemFhTks2RUdyMUhWbEpQT01EdFdTNEgzZEt1UEJpZ2xvczMy?=
 =?utf-8?B?Y1NWdnRHUFRXN2VseWVzQmlPRzVrVnI2MWhad0ZhUzVNaEhxR3JKd3pVWmh1?=
 =?utf-8?B?OFFVTWpqeXd5d2RldmhqaExsYzU0SVdlM1l2VEhFRmdLRzg5U2U4V0J2VnJW?=
 =?utf-8?Q?Ti94bTMwmdKjRkxbgdbpKhkQ3zafU0ER4T?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 22:37:54.4660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 2abbbe8a-3ef4-4531-6b6b-08d89b00bd39
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6puj/OVV5ncsIarbv+aklFDXmN72WKI14Zk6WxMum8IJtcA0sV8utCmbSY8q1B9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the SPEC_CTRL
MSR. This feature is identified via CPUID 0x8000000A_EDX[20]. When present,
the SPEC_CTRL MSR is automatically virtualized and no longer requires
hypervisor intervention.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dad350d42ecf..d649ac5ed7c7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -335,6 +335,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
 #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/

