Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD207FCF8C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKNUQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:16:49 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727185AbfKNUPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8Po6JFwoSGPqFuYLXo/Fodb3GPUFrFYlNmgnZj9/aYpK92edeojA5HC/h3NGN0d+KWsD3ZxlJXKDKaZP4iOj9RwDzy/gCW0G/QGKjCRR9ws/jJQqPgxTZ6OIxSLnuAAe7BMfviUxN/RtzqnXhrRQKBlwmNvwpBdsDrm/mRE5FQg1qeFBSFaROenUsvQabzmBCF+rVa/9B2znKs2LTU4BqTdNhtKqZMBjrxGJFBgdi/f0+4FZVeSLQp6eebWHwMtVb9DXvkcsge6SAKeGtlmACEKoyN7t0FAzl+M6nbGHsP0+VzL+MlINUzEGYASS3j2tDB3joOZaSTJABtFQ+HLyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71CgcQ3TewjjKfr3f8+9ZcCEmaQBjCjOXiCFS6EZmPE=;
 b=bDlC/Usy7AxPRI/aGjGxJj+lx2dLukHCqYfYB30Tm31zhfilKj1mi997j/sM19OZBeG+z84/9b73CWzvAZBLriIUf1rZy+AbA0mAvY6AYdD3SYYYOZMvzWZnnYQJmGnKdNMzaSzu9j5yHrXg+byzdGFOeeBdb30dPeYvd92vmMklwQvHB+f0uTNbGGVzA9DpSpxAl7QLQswv5g+SJBysEmO9VsVhdYMWlsgzPRjTpNpZUAE/uB1K+ijdzQPHBOiH5cFSQ7jRCrUt8mCYFLP4R41mr5ifPJXzKiLEonlFbbHP6EilTl67YfH0NvPuw0ZdlkhZVICN7WZkdif9hwYL7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71CgcQ3TewjjKfr3f8+9ZcCEmaQBjCjOXiCFS6EZmPE=;
 b=zap2DWwKDMKnyqMjdgXqvQ81/3kT844xswS0q5sAfptZOiNUgVjjgsua6ao4cNHO5zxh5YwWajRG1iIOLYmeSBX7xgTcJgy6IFT0pTupalnULVGssH3r+xqIm6+6MWZhlIRLsQYh95bu3VOPXIS6Z+vRZjQ3LUyJiwFdB7XI6ow=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:40 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:40 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 07/18] svm: Add support for setup/destroy virutal APIC backing page for AVIC
Date:   Thu, 14 Nov 2019 14:15:09 -0600
Message-Id: <1573762520-80328-8-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c53ddb08-f8a2-4ff5-5761-08d7693f6b24
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB37397EF7DC70E1607645C5BBF3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+4k7UoJzadGiv3DrxqEzZv0EEAXFdrBsMN0nnkcTO9qMgoyyIAIyIh46cLNlxJrQW4lHEi7wL5D+hUrTYgXNIImZ6w6PcaAMpBE7nN4nqFRD8pvK2h45zSKGOMfjU/fFvyJawMlnymQcEVYnPUg6JgOY52V81V+p+3HOIA8Qz+cS6KjYmLaqBuUS5e4ADZDX/06zRgk8KCDEK17pAP+okRyKsm0qs5UpnO+C9snCH9IFFsT9dUOx25qi+kSwWRToeOselmGoHFzzx+bQGnJgPs981SbjdhZYCWEOlAXzwiVP7jcfr84dL+5NpwZc0dgw1ZEqRp+UivRDHeAQd2L/z/jlwIdl+kk/sBDYhRJUur8t+AubWEKRX1vbLTnCjjmxipxTrQlmBhJgTTxv+1jcYKoszvgQJMKSIE+xF96V9/xmHmLDMKG8hi8ZaVwMV3q
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c53ddb08-f8a2-4ff5-5761-08d7693f6b24
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:40.1232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJUzNMmLSYIq+T50X+F1t4WbH83dhLYJL7gB0oTvU4YxgyosCkWcWqoNxP/vQWBcJihknRy4PYlDMWI+cltVnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-factor avic_init_access_page() to avic_update_access_page() since
activate/deactivate AVIC requires setting/unsetting the memory region used
for virtual APIC backing page (APIC_ACCESS_PAGE_PRIVATE_MEMSLOT).

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 38401f9..3ffb437 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1673,23 +1673,22 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
  * field of the VMCB. Therefore, we set up the
  * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
  */
-static int avic_init_access_page(struct kvm_vcpu *vcpu)
+static int avic_update_access_page(struct kvm *kvm, bool activate)
 {
-	struct kvm *kvm = vcpu->kvm;
 	int ret = 0;
 
 	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.apic_access_page_done)
+	if (kvm->arch.apic_access_page_done == activate)
 		goto out;
 
 	ret = __x86_set_memory_region(kvm,
 				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
 				      APIC_DEFAULT_PHYS_BASE,
-				      PAGE_SIZE);
+				      activate ? PAGE_SIZE : 0);
 	if (ret)
 		goto out;
 
-	kvm->arch.apic_access_page_done = true;
+	kvm->arch.apic_access_page_done = activate;
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return ret;
@@ -1702,7 +1701,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	ret = avic_init_access_page(vcpu);
+	ret = avic_update_access_page(vcpu->kvm, true);
 	if (ret)
 		return ret;
 
-- 
1.8.3.1

