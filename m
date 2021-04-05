Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EA23542C4
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241351AbhDEO0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:26:25 -0400
Received: from mail-dm6nam11on2058.outbound.protection.outlook.com ([40.107.223.58]:19712
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235915AbhDEO0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:26:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWDA/4MXP9a68MmTdcqqYfBYvunPRaNOYEOelY7vqXtvrrxWyCqK549JepO5NhkSoNGcxw2kpr7Gbzx/mvJg0bMa+5tDCchusRy1anVo8j04fmgzBt3S8UkA0qZ8fV+SS7szf5Gsh1NcYsWqfQhMFe3yJsu7pE+5rXNBFCfmGYaKa3C3WYnyx6vYxwTknbYBdk6HjJ4xvNra85QUALJ091YW/E+H/iNELrvkGOaG21mpW1tNlj9N5In0Fvq+OS0JhKReCFDVNgPKytkTDcwVV0DTBYP5NFxvkq9LHkdlCjBBkg7TUIZP4EQv1dteJQG1sF0vdpZlayp+Cd5c2F/XYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLNAo19buTg3Yb1D6/ZVJBYv5MP2n7HijI3gYDV3fvM=;
 b=Ae6H7X5zpvsR96eDg77YPQ9iIJMyVPpUH7XsUUzl+vBPsugMG1jn1hbhUAhBr83a/a7gQyn4YZ0Si8bodLeMvDTCqURk+GRHNm65k4ntVqnfZVaVhwg2BZfD54XYSAL+is1qT+pHM55eJNE46zwRSiY1RRbAS/8HKcKIb386k1npgzJrKAE52lsy0gmimjMcNZaBIxlCWhW2EWxibkK7DcUG15YoS6t5D5ulxImzrIUbubGRVHkEtxhJKdZ2oa5M1yvgYvjWyeENkUZTOzvmy6U4FM+qP2rWKTHn/lFczpnHMBUs0R4vP9Tg56dSQyhnVicnGVHcsP2OPdGqRIYgJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLNAo19buTg3Yb1D6/ZVJBYv5MP2n7HijI3gYDV3fvM=;
 b=2sZwhCEN+7ukIDbpEb/+rokq+R/QUHXDcK/ovRoAIyTAvLF8t7tnDRhwEW0lCbbgpwZ17kDU6z1Ylo+LWa3jSk4dt10TwYZpDyIsoOe+iJCdGqxffzgbF+EX0IUQgp2JuOOpJhDdkdN4Gr7CrY10EGUs9vW/hQ0dNyoAFRkJyhY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2416.namprd12.prod.outlook.com (2603:10b6:802:2f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Mon, 5 Apr
 2021 14:26:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:26:14 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 07/13] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Mon,  5 Apr 2021 14:26:04 +0000
Message-Id: <999bdd6f4e9e2d7f4bdc20cea9459182327f505b.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0061.namprd12.prod.outlook.com
 (2603:10b6:802:20::32) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN1PR12CA0061.namprd12.prod.outlook.com (2603:10b6:802:20::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Mon, 5 Apr 2021 14:26:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cddd17eb-b637-4bca-1501-08d8f83ec49a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2416CC087EB18E5B47606BF58E779@SN1PR12MB2416.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZQz6VECSIl5HrWr4N3afKbQQ8nI7qaPmiJpMPcRgkyqThABdr5PXgikAafNQMc/mIxKz78wwZwbvcBdsfQlfMcmJBAzOpPZpf0skapCy3wvum4UXtLajxa5w58XQvRTN9QBCHE1krC4/VsGJWcET+5EbtoUaoRfuKRZxn1dShpvS54eEyY7CednUGY7l3jn+PhjEv2CtOCtZMuAuVuUksSOqh1b2yIBJrGaP7G3+5pL2uVDFFZ6Os55ODezmW0XrxfZ3aVmuZ7JKouC0VxGvUhrV85Xfmwp3lP8Yg08Awo8nblvQy0Qy5QRyuXHf5Kyi27Fum4x345Q/DRiiQbCn6E4JGf7SFVUBbppH7EHFbB/M9MHsGTTpdifBqRmFFB0liokgVDVz+Plemij3VSZbMyFDcyJso+H8HxHEXfF4Qb+S6i4sbtf5nf49mY5Mfg/oe05BMn4yV/+cwxFFgysLmGKvk0ytUIrLlgHukDJwOa1KarJ5QPeygT6N+lUgJbzG8FPUebK0OavW3zvU3xCXZoAmSFZ5QV/ojoaeGXkqYX2NwAwR26TL86ZVFG8HMgV5qRd6tBSNYzaSs8mTWNQ/mdHAh/9vWLkEUOLhf8J+Lb3Zn2rHGsELCFzU2WV0beITO6zhyydMJTWw2Zy5GM2QoDtHdmfS34uDBNKFv60BUt0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(7416002)(16526019)(186003)(52116002)(36756003)(26005)(6916009)(7696005)(316002)(5660300002)(2906002)(66946007)(38100700001)(86362001)(478600001)(8676002)(8936002)(4326008)(6666004)(2616005)(956004)(66476007)(66556008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VkNOdm1VN3d2Z1o1S2ZneDFHT3J4Z0VseEdVK3hLdU9MNGZQM1EvMHl4VG13?=
 =?utf-8?B?Y1VhdkJLTDZYQms1NHA1YTZCbmFFczc0L0pkZzI5VVhiWDEzd1o2QjFTUXlE?=
 =?utf-8?B?RTJ6T0M3d0k5cmFaN3BNQlBzWHlpK3Y2ZGowVkhtZkhuUW1xdU5LSC9zTHA4?=
 =?utf-8?B?bmJMRDM0NnJQa01rSEJtRFV1SzJpRUhJOFkzdndpV3ptN1JyZVp2QmsvU3Ni?=
 =?utf-8?B?S0NaK0lLa21keTZrc0Fmc0pWWkNYaC9hMHFSdkFjZXg3R0I2d1IwZjRjUU9K?=
 =?utf-8?B?bmJtRFVwampwbnJSQi8wQkkvaVVqS3hRM0VPaDd1eDk5cUY5STIzWGpkUWFB?=
 =?utf-8?B?QTJoeDJVSGFYSXI0aC9QVXczUU1PSlk2WVllVWhod2NFSjVzK1lMbnh6dEor?=
 =?utf-8?B?aHZjc2ZzNkhXVElFNm04Q0xSNDQ4eTNEQXRmRGNQUjAzZ3d5cC81QWxmNnJ3?=
 =?utf-8?B?ZGdIWEI1R2pEZy9acXJDb3pwakNhTUFZRXA3c1RyYlEyV3gxd2huRkV2OVA5?=
 =?utf-8?B?cUpiWVZ2Z3pWYWp2ZXR0amx6akNRZ0F1eGZ1YVJyWVBwOXRvSzVVTVJLQkxs?=
 =?utf-8?B?M29CV25QOTZ4UTVZbnNVWVZTWjE2Wmo2M1g4bHppNG9EbnMyUUYwaWlmeHNu?=
 =?utf-8?B?d0FkWCs5M1hSWEJrUHlMM01Qd1MyK0U4Z1VsdWc2VmtHL25XQXJqTDY3UmJw?=
 =?utf-8?B?NnJyV1l3L3ZxYkVhVGtCMytCQ0l3SmFlNUxqSE0zWG41VFh4dXBaek5hYktl?=
 =?utf-8?B?S2xZcFFtTUJZa2FEWm5yV2pZaHIxRkFsM0dRY3BRV05GWnpPVDYyOXA2MVpB?=
 =?utf-8?B?K1JsMU1CTkpmTjBRTnB0RjY0a0NIOTFQamJCTHlZWjJYRFhnQld3RTdBSkhC?=
 =?utf-8?B?MFpXZHp2UnR2WDROalhpR29GK3cwYmp0azhEMXl1enBobis2b3k1Y1g0d1k2?=
 =?utf-8?B?Q2M3ZDN4Z3FBNTlNeE9IcTBjbzFPaTZ3M3JhTGljSTUxZWp1NVUyQzQwbmxW?=
 =?utf-8?B?aWhzUjNZTVNYMXR2OWlNU3d5bEU0MGoyR090Wk1ScVR4Q1p3dy9jNTFtSXpm?=
 =?utf-8?B?VE00dXlnUDMrUHR2MnJIdVFGVDVmc3c0TURka2l3TnNseGh2dVo5ckZ6enI4?=
 =?utf-8?B?eUpTUm43ajVrZVl4MGtFQ2xxa1VTcjkvbi9SN0ZCWmlnbytCbUEwNVNSUlFo?=
 =?utf-8?B?L2l6WU1icUtyeFlvd3FXOGVTdmN1TWY1L3J4Mm80eUw3Q0tmVGYrbjlWTi8w?=
 =?utf-8?B?cjRRTjFIZjlpUEJhRFZrWDRZdUdtbDY1TGFPdGYzeGE2bkovR3JoRVdDRllM?=
 =?utf-8?B?c3VieWU3bTd6SFhyN0lPMVR3YnZnZXlpR21CUk9NNTVJUDBuZHZDZWs0RVhl?=
 =?utf-8?B?QU00NFhQUVlyd09MaEpQbG52U3NXQ3FiT1ZWMWtGSkNGc2duanJ0R1ByaDJr?=
 =?utf-8?B?aHYyQXd3V2ZqMnFXRzFXcmNhUGZzeUpsOTM3cUIzQUs3STVGMXBEVWdoTHh4?=
 =?utf-8?B?RG5uQTUrK25lMEprRURsVmtZMnJUckNNbUdiRHhsbGlnZSswUDVZeHhLSHVF?=
 =?utf-8?B?UWFaSUxBRFZsTk5SbTNGMlE4bG5ibWFnUWgzTEpJV1lnR0lzNlVHdDNIUEVv?=
 =?utf-8?B?R3phM0VkN0hMemhoM2FnOTJaTW1iZUszWEFETnRrbGUzS3BJRnFTMGllMUg1?=
 =?utf-8?B?Q2Yrd0lXbWZ0ZHNXR3g5aUlCZjZKU2dNaGFBOHFMeWVBMjNkaFVGc2pZTjE2?=
 =?utf-8?Q?dBeRymO8biltFTrAD2vUeRgCNYtODleXHFcKNfS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cddd17eb-b637-4bca-1501-08d8f83ec49a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:26:14.4677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fEdUADdQbOQUm/io9MUgtqbXnoUjL4MpEC6BFoOURSgu1B7Nr3KIHXRMq1ZMEmC6s0429Wr3dWiljWI5LC0Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2416
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

