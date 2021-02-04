Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D611730E8AE
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhBDAkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:40:01 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234252AbhBDAj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:39:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HB8CL+FIYg/wDuhjh5OXfEhI4/UFkLN5/m5KWkloxlLfztg09pajx1QkFoRB0juLmIL/N3s8uRZciRm/O1XNGkhJgMY0vAskjVRr5YD3zvTfpgWFn3duo0JWvySarx2kvLTVRIhHd6NSVNg+t6VAxagCddAs0HtKd33KBDl0vLsLmjMSZhL7pa8HicPmlmCW/pRDhouCQVnrQfi+lrUFjp/pG6WtgHv5SyojaFCRXAa0Kpt6Zk/uYJO+yZmZy+CvYPi+017lCobnzPXZZyOOkwKnP/gaTxX0duRTeIFk9PiGIHQF72G94Ak/gJ2kZ4YB3KiOEXhEG0A+SHbaO4zCQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=jbcqmAsnNh29xv1pJUl0UqTUwjdLtlpmcilJWCtwrbIWLRJ4rRsb0bsEqH+DTTIeOfLDghYMHblZ4mKwlARNve7sph6kU8cg/kEuQMq74TwxZMZ6G2VKbMNfvQ2Wxb2eg2c3J+0HXcZJvS0+L7bL+LnCt/oxisMMH9Nn/c2kH7nUomeDbzqt/t5orzVjxEWfiaoeHvZspEpUvY0IVzXxlNba2ALQuGrdyxnFTJRd9mjCvnsbX0XZUvZkv9vpF2Y7FtABvkuN9uPZrWZTKfjRBGGQjSIG2Xeg27/rt07JRP2vi9j154KlToqnPq0FdHeAorEhEKcK97vPRpnjmxenOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=htxEpn/S1dZYX+HHeBJg/NBMjwOSxNxfIOFrgjYXTDbwut85OxLQXuUY74UI9+FBa3OG79tWmUIA1mXlKdsJNIbgtskUNQUbigGZMdvgMhCwyS4faauoIrndZ2Wxh+tUswfqj304sLITwLTlGSRtWTnjajlHc18jMfrrQiDAFQQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:38:24 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:38:24 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 07/16] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Thu,  4 Feb 2021 00:38:14 +0000
Message-Id: <9be9ee177f7e033f387fe067aed0aa484bf658fb.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0046.namprd13.prod.outlook.com
 (2603:10b6:806:22::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0046.namprd13.prod.outlook.com (2603:10b6:806:22::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.13 via Frontend Transport; Thu, 4 Feb 2021 00:38:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4cf49e64-f12e-4260-5c12-08d8c8a52dc3
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384B7B127E113D416E88C258EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qPTAopNxbirV7obizxjuA81nHSfEZM4ylENcsT82DLjbsqyX6w7fhNDY9CKeRvKqPTrTPyT215Oprh7N67rMm/rKrk9UHWQa3dDioTOGA9RlAI/9Eg9aARwSJ81VnPesvr455otO4HTTkxif4BR0bQ4sNO2Fzl8dtdk0Wlz/X8IR5mcCpil9cyOA5aFLiYWV6kPMEKX/PltpOLl1+dx3zY0EH3GX7/xDug5tSQpR/BZT98IO6dH6MkwIVoyYjnCc+/cD3++we2OfbFZRDr2PZzDuaDaBeYfR+oh9Prd8NNW3LmImDGnQvFKksJUDiJdxnRYnqs7nFEKPrgDWiBOGKWaG3p7mF4LtyoRLW1AlZ0OkGPXpp2BU40xLM/8ujSYYX0zKvC6eIrE7/x1sw1NQzKbqQhEmkH/HT4A4e2uTQpmoieqAT/wqC21MeFsr8Vti4riK67N3RLGckfov4rZHsSLhiEIhmWRGwNHyxX6VUxoWrkMcIcIu9i7gGn9O6NwH/i62knMrPTyg5025OzwvxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(8676002)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bHFtaExNbEJHR3RjQU5yL05oOHpndXI2LzZOM2dNN1I4LzFOa3BsY3RnZ2hV?=
 =?utf-8?B?WG8yUFVTKzhiNHY3M3RJYWtHU28wdE9GSEhNSmNLNmhKVkJsUm5tWWpxNXl2?=
 =?utf-8?B?SmtFdWNQdVVSL1BPaUhTN0dJNU1YczVKZnJKWWpSbXQrQUNHTjNPK1dqeG5p?=
 =?utf-8?B?R3RGV3BKb1ZtdlpjandlT0wyeFNHdGV3ekhqTkNuVmVueDFTODJmbTdpNnVF?=
 =?utf-8?B?MTVUM256akdlQ3BjaDJGMVFTLy9ONkVZQ0N4bUVKaUdkK1ovTTR4aVptZUxu?=
 =?utf-8?B?MzlOcFNQNjhOVkxlakRRdnZRdVlhWEFpOE9uRXdkNWxTbGZxcVhpS2xhVGZu?=
 =?utf-8?B?dHZ2d3NWdW1TRnVSWHJtZEZjejhtYnV0alp4U2s2Q2pRK1ROY1R4a0F5S3Z6?=
 =?utf-8?B?a3FtSzYrN0RlamxnL3lieDhva1J1VXk3VnBzbFBGRGltVlh4OUVPZFBITC8y?=
 =?utf-8?B?WnRuMmEydTlWYmVPd0REV1pFRWZhRTNBOEJUYTZjTzZSdHE4RUQ2RWpnUFJP?=
 =?utf-8?B?dXpBQkZJWnFqdmFCa0ROYXNyQUEyQVNKVXc1M2taaTVGa1JIWkJqbnYzNW9l?=
 =?utf-8?B?NTFWOUxtclZ6KzYxZGEyUVh5Y090R1NPb0JpdUxic1J2OWpJQ2pvcEg4WVll?=
 =?utf-8?B?azE5dkVHL3Z0ZnhrSk1pL01Za2g0TUFhYmhWemdHMCtPN0lkZXRiWVBnZzNM?=
 =?utf-8?B?VlNUcWRLZ2pjSUx0NW9HRERFanp5cEhzK1RIdUsrT0dnTkoxdmhoNnZoZ280?=
 =?utf-8?B?Wm9Gb0FWdHBlSVRIM3FIME1CakpLK0s2eWpKekwvMk5rTlEwcmtUWWExb2FH?=
 =?utf-8?B?emZ4NFAzTVkzZk10ZU0vQU5vUFJlWURxZklkb3lheDJ5MWsxcm5uY3dPYkF5?=
 =?utf-8?B?Y2huejNuc1V3U1RwamhDeUs2TW9mVE5aM2FIM0lvWklZL2ZTMkdjOUFzbC80?=
 =?utf-8?B?UllFbjgvVjJjeWZFNXJaNGw5Nk5ZWFNvZlV0c0dYUWVzTnFySXkyampTZzhz?=
 =?utf-8?B?aHpvOElHT29McTRJM0Mzc21xeGhudThEQTE5eHk3WGFuYjhNRjZMa3BtZ2tw?=
 =?utf-8?B?K3duVUV2Y3M0bDFONlZuTTJiOWtsTmtkQ2dyRHhCTVRnc2dHUEJBY2pteFd3?=
 =?utf-8?B?eDRPUXRWbnJqMWpsLzdVaWo1UnE2VDhnYWJCcklMejZrRVVpczVaWDdJUjdq?=
 =?utf-8?B?NkRmeGp2NS9QM2l0NkN6QkRobG1iUE1JY3lDa0RKekI1V01jcW5XdnRoemdx?=
 =?utf-8?B?RjFLVzhsN29lMGJ6WkxyV1p1YkV3clFuOUtibEtGRFpqL1YyZUJ1empIQjVo?=
 =?utf-8?B?ZjFkK1phVXRMdmxJaWhrTWFuYmc5dW9SRzY1L21pYW4vNlBJWVlzMEtTRkJk?=
 =?utf-8?B?V0Y1ZzdiN1RCazJFNjBHVWFReVBzUW9GTVUvOERkdm1VVEpPNm96RmRNaC9J?=
 =?utf-8?B?aHRnK251TUJKRjhDRStjUS8yZDgyblN2TElnbDgyQWpXbHVXN0piNlkzOUtN?=
 =?utf-8?B?ZGxtcHc3dDhDS25mcFo1SHZ6UFR4bE5tMXVJQzZsSGx1a1RxaElvKzJzRFhE?=
 =?utf-8?B?NXpUMDhqMXRNLzJKZmpCTXFhcFNvZFZOaGFpWVJHQkhDS2NXc0FwalRnT080?=
 =?utf-8?B?RWlSREIxdnFDNkxKOXpaQU9FWDVOWEllSmt0M05ZL2dHdzR0U2dJRlI5Q0hY?=
 =?utf-8?B?L1hCRWpRZzNoYlIzTjYvRktLd3NMTlNhUFhhWEFtMlptV1NxWkM4OHRqQjNB?=
 =?utf-8?Q?AJgbVrafrMUMz6l32rhQqOZ1BZaStf+cKy72bPv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf49e64-f12e-4260-5c12-08d8c8a52dc3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:38:23.9050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aNoRnuQQBQSdbijv1RvVweWtGE+HxcNJEXOozdrJc1/cn5PU38q5tmaOE12LauYEz+hgCy1pF5h/UrT4H2rcnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

KVM hypercall framework relies on alternative framework to patch the
VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
apply_alternative() is called then it defaults to VMCALL. The approach
works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
will be able to decode the instruction and do the right things. But
when SEV is active, guest memory is encrypted with guest key and
hypervisor will not be able to decode the instruction bytes.

Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
will be used by the SEV guest to notify encrypted pages to the hypervisor.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 338119852512..bc1b11d057fc 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,6 +85,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
+static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
+				      unsigned long p2, unsigned long p3)
+{
+	long ret;
+
+	asm volatile("vmmcall"
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
+		     : "memory");
+	return ret;
+}
+
 #ifdef CONFIG_KVM_GUEST
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
-- 
2.17.1

