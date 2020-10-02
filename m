Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B44281885
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388246AbgJBRDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:03:25 -0400
Received: from mail-eopbgr770073.outbound.protection.outlook.com ([40.107.77.73]:20128
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbgJBRDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:03:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VykRV1qWItWIFXGKAJlAQ7nJNy5AdEzmQDypGtpxhnLZz/27J6UrFGX+65SlnuDYm1BYtJDQndfJwGYdNerWAnfUSB+CJbsg2fgXOKENLyOiyDHOOpWKlg2VfOCkiGSEoQXN9CkVL4ROxULoMFdT0bWg9gd0k2HhiOfSNbMIqeprhryGKQ3c9Y455pK1+QuqRkIEO6zUQhOqjyeaBNko37D794KG+/QZIWOCA3l/peQSM1Zi7fby8T3fzcMpR8NdB1innesgxSvUGl6lrGe/3hwQQlIS3VS7FlAZPSq73Xcn2m/2wwKW1RA8RoSxXks2FKVz3EH1tgxK7lNTtqZEyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5dAjRtLqXPCMFK+M/jwLa4b/t2Fn6BY5q79TaGmjCk=;
 b=Hf90HVdjo//8xzhXwjgMnjpWBVqcWNiLPMzcJ6YksjD/BGrshDy3/NVQnMTGoHVUFkajLaE/f0SIhPvEU0oGGmT6QVjQdbI3iuEuPoRVtAw52XwYmS781XW05DyrlAav0VBgxU3PC8totx78EeI2NGLVkWE1pfxV/fpVtD5OF/ChwSwC0qn/7myisFHyXdmuZVpYg3blf12F3T+zUp4lBoYNC4y5bax5jYTn4skkfoyFZgJhR6qDrDCuU92eZXuSwEAT8iGEzbTVZD8ZGQpLjMlqtDS60YgsHVIjwy3NjcZwmiVqmZ43dnMKeuh1BFLBoqb1p24n+trdsgZ7bO0K3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5dAjRtLqXPCMFK+M/jwLa4b/t2Fn6BY5q79TaGmjCk=;
 b=Pmz8pnwlyaMFsUh21g9LiCgZDOaT6V6uzVSud2ubgLCEha9RcfFHvix69LHNc0FTj4D/4kpCF+JMWJQznWVX5rRF/hPje/M7yx6/ktDaJz672AcYD1MA5xY57LDa5IPzolDvL43k+2HdA+N7Kn8m2mE4PdkwxLiKskK3U5VayAM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:03:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:03:22 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 01/33] KVM: SVM: Remove the call to sev_platform_status() during setup
Date:   Fri,  2 Oct 2020 12:02:25 -0500
Message-Id: <25be6a2f43efdf8af842c175cbf4d8542a15482d.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:806:d3::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA0PR11CA0008.namprd11.prod.outlook.com (2603:10b6:806:d3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend Transport; Fri, 2 Oct 2020 17:03:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8fa4ba96-ec59-41f1-de16-08d866f511cc
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218F3525C4A8820A69C2178EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CNuWyWEutMVYzfKSWshDsa1PZLSTakFAjzr6/4Qq6gmAFizKwOAB22HABDnqI3+FvfyOwf5yd+kAMOzEXDEnDM0IWQG6tugQ9gOEBTCHcgdlmxa+h7vR5rdl0QNbpRSTOhI4qEgriVcuai0EbMXcGbwqQntjJxeGVJp47l1V65HNCkUjz/2f3GTpGpJJIABClY5wFwMRszIHc/Z5VXxA/uAR8hfYMK8LE8JgaIk+UQF/+L1EJpPH10vAVfhMcT8cmP/nr4pOXKrMT/Or1KR6PfZFA1cOuFRo4AmLiUP/OnrCs1Fwu+dmmB7/QONDVQbzSt55d5dUoicudDAW4YnAcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5qXLSHZTNlyIppQ1SS4iVRp2efIgP9BBF0HM2nqb64xkhGZTMGFPCHMyDCkcZ3f0s8wxig9vOGqip7FuRlDWO6wFXKLaqUP7JvuCeBGUDES8m/6k5N+syP+Eh2uMjijSzyR8ud5lvyLKaMfMnqSi1x4B76s31L/k2bNvnyAMfRE7XxSMV25K1S7CC8T2rC3NzaBMKcLg5Ki5Xr5X0MdYf6Qb5votwyaK0uItQne0tKJ1jsTEm8r5GomHSGI9lOSK3hJaxx9x/nY5GYhz6j0AaBCTBUMXAT6GvUbdJhM4z6/GPwT7SugqtKUD2XTwAAA9lC+2tlkAZ9rCuakbTQP1lZaVJpOToSl0ft/L7zspb1NLjlyvFP9Qm2DV7f5UKh04e0GSlhkQ30bHNkoI9SIoiSDFFzaxvjBB8dUMeIBBYJTSiuf9sk0GA9+wTy/28fMgw/Op8EnPs3HhGFVfrWzZlzj8+Kvw9TZfHOpsmr9FFR1LAip51OfmQeBSdL+QeAtI7OtHIFv6n2SlmKdedDtwGvoHdlCrJPEt50BXQFXU8fqZ8E4R7Lx6tnPGMpklDWIl5L9kqyIIj4kHj4hLA8bBB+uv6ErOggD5mqs2gnux1t0BAoT8ADDUhQYXFFUoReXWX5YlJdRsuPzMZyyZJnFqBQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa4ba96-ec59-41f1-de16-08d866f511cc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:03:22.6613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pbAXq0h3rUG50CN0XYYxNuUBl7Tb/+1p5LIVgxhEX2dxyXV2oeLbY46R4i+ZetwcXwWR7m4LbbFE6gqoOAPZjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When both KVM support and the CCP driver are built into the kernel instead
of as modules, KVM initialization happens before CCP initialization. As a
result, sev_platform_status() will return a failure when it is called from
sev_hardware_setup(), when this isn't really an error condition.

Since sev_platform_status() doesn't need to be called at this time anyway,
remove the invocation from sev_hardware_setup().

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 65e15c22bd3c..2febbf916af2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1126,9 +1126,6 @@ void sev_vm_destroy(struct kvm *kvm)
 
 int __init sev_hardware_setup(void)
 {
-	struct sev_user_data_status *status;
-	int rc;
-
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = cpuid_ecx(0x8000001F);
 
@@ -1147,26 +1144,9 @@ int __init sev_hardware_setup(void)
 	if (!sev_reclaim_asid_bitmap)
 		return 1;
 
-	status = kmalloc(sizeof(*status), GFP_KERNEL);
-	if (!status)
-		return 1;
-
-	/*
-	 * Check SEV platform status.
-	 *
-	 * PLATFORM_STATUS can be called in any state, if we failed to query
-	 * the PLATFORM status then either PSP firmware does not support SEV
-	 * feature or SEV firmware is dead.
-	 */
-	rc = sev_platform_status(status, NULL);
-	if (rc)
-		goto err;
-
 	pr_info("SEV supported\n");
 
-err:
-	kfree(status);
-	return rc;
+	return 0;
 }
 
 void sev_hardware_teardown(void)
-- 
2.28.0

