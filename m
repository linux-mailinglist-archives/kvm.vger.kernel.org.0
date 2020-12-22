Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A7A2E1053
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 23:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgLVWcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 17:32:45 -0500
Received: from mail-bn8nam08on2053.outbound.protection.outlook.com ([40.107.100.53]:4961
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728429AbgLVWco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 17:32:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCkKZmZlVlOBwmZ40/9r8t3ITT+pRF9saLVBF7FARLGFRdFm9cUKc1NnrOeJIzICCb+uQP+OYkcCgrf+iMoGNf4zFFGRQdiitTcRn5bRwTvwf4C43CPp9ypB95kJu9pkZg5f1v3H8tACplVOhsmddllCFou7snojC2dZ/4zpayugxgdC/WrYVvjRABGJdIaKuclJvPEcDcegAjVKIJRMostrxYz9/pDXHL8+sDKACBDOLt35yCd1ysWvHSniEDj2zSsgjI6rJgnzMgNeNI6rLHTK/PDgaMlgzwZ/+gy87wxXTjBPD/1SsYGWU56luLOcrlpW1TT1LSNdqJcOVm6yYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwQaj7nAVZme4C/obXrkq7w4+hAUSeuOa4iFC1vDl1I=;
 b=l5f4+8P5RBDoJCO+Jdwq76GVgtzLdbGduBuN9E8EKsSMzRNFgzuK1mEv2orjTrlnTu5BJl5f6N9nKxbbfZOTsNGf9gFzi5Y7ud4j+L9c4qsmbula+PAAiF4+M4IJSgk6cbZ+Zz0rqi+piM/aV8AqhLBzesb+UyBZmiufLp61rxoWw3QQ2vrI6ZyjRltSuTSH+HqV9U/KtE1SA7qqipojvtCdWrRRX7ULEgoqOB1W7ixdooBNE0rXIzh7bS67mRAQPY60Xm1W0ub7eapZhw9lR+O6vK2Z5DTsVtHUl6IfhDpA/FAR2mkPnnnnQybZCOxxOu6V3VRDf4fPd4G+X4dd9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwQaj7nAVZme4C/obXrkq7w4+hAUSeuOa4iFC1vDl1I=;
 b=4TCkKPr5JV0JdzKctmH4MXAO4LqPxTT/mwqYX97bpJvrkULGd62qSoRn+2s797m5sJnOzN3W2CmHGDdPWRZejfX2qfipbWTRixjXu1+RzkWMM8MZOBfeYxt22xJFAU3hvvJK6x1DF/n9WvUOJ5QquQvcitQs4mcVCiRQzZvzkug=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Tue, 22 Dec
 2020 22:31:50 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 22:31:50 +0000
Subject: [PATCH v2 1/2] x86/cpufeatures: Add the Virtual SPEC_CTRL feature
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
Date:   Tue, 22 Dec 2020 16:31:32 -0600
Message-ID: <160867629293.3471.18225691185459839634.stgit@bmoger-ubuntu>
In-Reply-To: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
References: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0134.namprd05.prod.outlook.com
 (2603:10b6:803:2c::12) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0134.namprd05.prod.outlook.com (2603:10b6:803:2c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.19 via Frontend Transport; Tue, 22 Dec 2020 22:31:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fad5b82e-00a4-4dcf-9e60-08d8a6c95fe6
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23819947D5F4B01AAB33F1C395DF0@SN1PR12MB2381.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ykkFARxMSmfgIqLvC5BWpOHHQirvHBIrsZdxnyBxR8Poapunjqmp0IJXqt2xGa0c2zIojMJLc8nTPcICU0W70P5PPsSPNNJkpjxp1PueOhF9/f6/06xq1//tmXE/X4DewmJ3ftw2SjhzrYXGOn0t/S1kwhpxc6alI3o0EZxHzjxylbF+RcIEXY5Dknjzigctvoa6UB4MTyZ4tj5/SmR2MvWVZbypmCEOqNNlV698LNmrWSmhSc+19mRC1Lq+ZshxzQjmGlntbk/EzNzzXo7Z85szTtn5hMXUon953iy1RMh2qV4AcwiaudkI0KDNuO8UKl0mhoqrkvV4Z/afuOYDxh80aYGDCv+Vaqp/6VlwhzLsWuNtt04CYajNPCoa6okRmI6x29NlP7m/+MAb/1mq/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39850400004)(376002)(136003)(396003)(366004)(16526019)(66476007)(26005)(186003)(66946007)(4326008)(103116003)(5660300002)(7416002)(9686003)(66556008)(478600001)(33716001)(956004)(8676002)(6666004)(6486002)(86362001)(316002)(2906002)(8936002)(52116002)(44832011)(16576012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NUd2VkxZdWxHeU1hMGVLM1BqS1QrQlVJRmk0UzNCcG9HdUNKempiUnR1aTlP?=
 =?utf-8?B?S01hM2cwblV0L3hkZFl0QVRNWHBXUmo3ZGQ1QWloUDkzdWNUOVNDTUhYUnpM?=
 =?utf-8?B?WVZFelJxci9rcDZhUzJmUndVU29Ld3htcU1NdVo4UjFjRFdSejEwYmpVWXFi?=
 =?utf-8?B?clRyeHAzU2FwVSt1czZSYUpTRHZEc0k3MXVJUGZCSlhuZy9mdTdjWUF1Y1pP?=
 =?utf-8?B?M3J1K3N5cmh5MFBiSkpvbzBiUDhzbUtBaFhQdk1FWERCbHptYk9CRW9rbVl3?=
 =?utf-8?B?eXlrT1Y2SDJKbHZGNHdtMkhjSGFHbDBvYlRxYTF0Nk1QNWY4eGx2ZkQ4UzRp?=
 =?utf-8?B?RHpnVEJqRkJEbHcyOE1MU2IrKzVqZE1OSFhWSUVSRlFqSWdyNVlnK0tVUmJP?=
 =?utf-8?B?YnVLY2JUZVdnRGt2S0czdzEzU1ZCUis5dDRMSCtGS2tYWmVKbFAwYkVRMGZ0?=
 =?utf-8?B?UDViRWRJUUc1d0djQkJNalhIdEZQM1BDTHJEanRtaDN1YTh6bU85d08wZ2la?=
 =?utf-8?B?N1M1R29hVFh6NzI3aGd1N1I1K3VESUM3ZlZ4cU56ajhqaEVQbVNIQVJXT1Q5?=
 =?utf-8?B?by8wb0ZCUThUK2RUVVZXMEZhemFHQW5xeWJlNlA2ZlY1NDlJOVV0U2pvdW42?=
 =?utf-8?B?Zm9WRGNRN0crMytEc2RjSEJiV1RjaDdZYTd4WXorbmtSRmdMaDlvRjBhMUlx?=
 =?utf-8?B?RkQ4V0JXanZnSklTWXBpMzNibW5YM1lKbDN2SzI4cEZIalRWRFlHUVpFRWkz?=
 =?utf-8?B?MXFZalgzUnBHSTBmRC9rakRLRFpmOGdnRktQYnhHRDFiWUdyYnE2WGJIME9Y?=
 =?utf-8?B?N05zNnBGRmsweGVFY0srWUNPcVc5Wm12U0pZWllTSkRuaTB6RHBZMmVDSUdm?=
 =?utf-8?B?Z1hUUStKL1NpTE9XNmVHalV2UERlMTJnQ1B0d0puWkhoTW5IVE5sZy9VS3Zm?=
 =?utf-8?B?NVd2ejRENjJaUjZYYk1xTk44YkdkNjI2Nk1qNzdGYXNEQ3htM1hXR2Rqekxl?=
 =?utf-8?B?NzM5RGRySldUYXZYSjZkaUgrajc0TnZqR2lMVXJoWGpMTVVha3orN3VaNmZ4?=
 =?utf-8?B?NjkrMkRFQXM2T2FWMCthaVl4UzRyOVNvalRCKzFWbFN2NkRTNEtXRUliYUhq?=
 =?utf-8?B?Nk9wK0ZBSDFNK3ovcVJhUGRramsvL3gzRy9RbkVWWW5lQ0oxK1ZoU1BmZ1hz?=
 =?utf-8?B?aSt0NTFnWjl2a3BibmJHNnRMb0V3UTlBQjZzV2F2SXFGQm1DOUFPT2h4NmFY?=
 =?utf-8?B?TUxoM2ZQa0hIUmdPRm1xY3Bqc3ZvR3hieG1rZ0VFQ0tocWhFenpJZTFwVi9v?=
 =?utf-8?Q?CYTS1dn9E/2WPu6HZiF2dKwdx7V63DH+bh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 22:31:49.8722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: fad5b82e-00a4-4dcf-9e60-08d8a6c95fe6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmtQE7+FDsrpTpdV01m6IXrIncNDn19MdVy6KESMJfTKp8vTX2I6Yb69l0GiObgG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2381
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR. Presence of this feature is indicated via CPUID
function 0x8000000A_EDX[20]: GuestSpecCtrl. When preset, the SPEC_CTRL
MSR is automatically virtualized.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dad350d42ecf..aee4a924ecd7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -335,6 +335,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_V_SPEC_CTRL 	(15*32+20) /* Virtual SPEC_CTRL */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
 #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/

