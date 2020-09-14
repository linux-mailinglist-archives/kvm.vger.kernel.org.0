Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47923269628
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgINUQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:16:18 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbgINUQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:16:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvoa25wjsKmaISFOrLl+ev23gmzJhtHBrJ7h1s16wHGwoSmpuOhXmMEmlUOnf6AZF2C+7OD8OiXLGyc1X55FO9u5aFZNYq7+eVlMTeTU2EjqwlhFHNtB+HfMPXo0dFpg+LvcAteAqg0y97NaojF+WYcloESeb9MsAHFIKOSTSRY44420JiiiVjg2ZXUlVIGLh+ltFLRoGcmNnK4Gt+e5IqjM2yXC/MX8WRKqBTjVYE5bi1QqUQ3UYmFngMvVqFgbfMMO8Z5NjvhxP5DePOQy4HSQ1dj2TH8id3lGEbgoJUTE4cnyzraEouFaXVa72e4A5808KPeyMgbBEkgwP7GUuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRWauB7/1o/5aY0SFVNgxzYOKpGt/WCPlw70I4UfuFo=;
 b=RLhGChOqkZ8aKDQocOmLDZbxi68P8kTNqzg/sTZzhhek/ztNwyrYTDSkSYCAznIx8zSULk+IJNF0a1v/y5Ux5n6WnMWxIV9PjrwtDlg0samk5HzFiDefmD95zLNFCQg7DAp3zwnwcuThQEWGf1ZktLICSmOXy8YCZDT9/pY4m+gDtDFBtTdoCMt7cjNrWRMfhhpsceqdd2ygMlN+kPuni+jGH9x4OlfovRv7t5XllVKA3II8hslRXMeOfh49OcB01ZG8tgx0UisKj5lrTQiEms9n3M13YHxmGu4FvDJ3AuK+jYEZJVgkvJq2AlIiKPzcii2epZLrYAdSywxAoS01Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRWauB7/1o/5aY0SFVNgxzYOKpGt/WCPlw70I4UfuFo=;
 b=gBLiaaMbVvTRajGZtgXP9k12Lk+05T9yb5dIxkcvSHstOaLY2a/R8kwGAprwCY28Aby9D7IXsQHrAiA43J3KsTQWi6bX2OaMmqneJp2TPEDuHRgddG5PNQDV9nPNQdXH8LsVwJ7xAZ1bE3nsJkMAhvFrJ5UwDF6vl8G4tN/FPJo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:16:07 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:16:07 +0000
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
Subject: [RFC PATCH 01/35] KVM: SVM: Remove the call to sev_platform_status() during setup
Date:   Mon, 14 Sep 2020 15:15:15 -0500
Message-Id: <266ec828918d0e4a77b52b15aaa457b2df01773b.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:806:20::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR03CA0019.namprd03.prod.outlook.com (2603:10b6:806:20::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:16:06 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: abffb001-326c-4f68-ae54-08d858eb03b6
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1163E67E8EA3DDDD1299812CEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eO9o3m9SMfSrnBq0OtXqSTSBQhrzBAlfIWpaVVFbHT6RbOsRSQWu/kNHOLE8uz56e7DOAV9c6TqHQ0vuX9tbOQL9jNVw9PCz0ICAwp31yQmMGnT5FU5xudSAjBZTsJT9ZScMxnqskaiD2tnY5L0f+F+sDg7Uy1pjtvQndNVvGGK/vDSBS2QKi+oetnI4azacgyiXmJqWmRgv9IYJmRxDQ3LDaP8vM3Pqw3/13KNp8En3Z6BavZNdoHy/sKFflnLjUihRxXYqz1dR2rf/1TwISAMU5wZHEI+OPXk2JTWg0Sh2gp4Zrgv1HU5mrrwBwJ7C3TJv2KASaiQP/t/i0CFbsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Jg+lTZDz9rmRb8LzxB8G0sCCKidlFhT04AIS8LLj+84nvxncj6uIMi+9AQ2tVXDp6X3FgdCdZgzaH+s5QxdD9mqz5pVw6/6ivESqaIPrLqDAIClJli8y+I7saICKKms4Ma7um5JjgbIx1UxmO/sk9OZ6vPj5GPZjG+o5o68bCH8ydQFyj73EGK32LVJNVdE3yetRj1FYFQosndcHIto6Pt9BgKdnqRV2ktypZhY+NnEr/HxlWUIIwn5XaRt0O3dbTY/DgJoVk6ergb5H3mwh1ONUzYASdJnSYyjSLdBj0nFtvnB1ifM1v2KnG5SZhLjtbRoYu+ogmUiOEwZ/xwJuuHWP/f1M1A3n9CJ0ws8Q1eXfOhOyPqn87/c4zgPSk4CYHXe9wWh5e8LGUxSX4QLd0uU+CsXycCNAI34NShIOjbVrqu2lTQdO7/YV8IQqnv4ZGmzUsDi1T3PVE3gvhOqiWi/gpTY696cWf5LOYIu/VQq0Vtn7Ur13V3htFevsaX+ABdc4Z94chr4vmQFzv1MalhEnNhXoeU9OCLP8kxP3KURPWoWLHovhCwx/60zjI0LMM4gGO+ovbH/NVoYAFN2sjJhyKJqhbTjI+XjdsMkF9N6bPF7VAJylmbtoaCT9ppy/XDfHjLByh2FgSLjYjVtCiw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abffb001-326c-4f68-ae54-08d858eb03b6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:16:07.7417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxiRu/w+UsYCl7tASdbSJtP25OSo7o06prUcfU+9k1REvyFiIVVYR9x+ycBO2AvmlUJZTwsgf8mSd0poMOCtfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
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
index 402dc4234e39..fab382e2dad2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1117,9 +1117,6 @@ void sev_vm_destroy(struct kvm *kvm)
 
 int __init sev_hardware_setup(void)
 {
-	struct sev_user_data_status *status;
-	int rc;
-
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = cpuid_ecx(0x8000001F);
 
@@ -1138,26 +1135,9 @@ int __init sev_hardware_setup(void)
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

