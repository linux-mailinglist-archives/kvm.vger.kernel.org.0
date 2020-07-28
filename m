Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F46231640
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgG1Xh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:37:58 -0400
Received: from mail-bn7nam10on2083.outbound.protection.outlook.com ([40.107.92.83]:53648
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730516AbgG1Xh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:37:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2gotQV2NqpBbGkcdWo96o/aygJUlKGTDFUGMRbCkJL4P1sEma82er5pTG+mjjPSGFLSukgX8TtMJHR/FWriI3W4va0pcXcgKA57Ceio5j1NraY/B9scr5vFnEZAG4ab44mM+2cDLpzNO0/45RdX0L83Ujp/BYo2kssMGnJfrEMEJ/jT2lWKxtITwOPhFOZ9ESzLF7M4Via4wSP/JsE7nN51hd5w6+lNk0zpjZU/lablOhITEx8v6uKnM3K7TWkQYiKhx6ZaC22gO0dbAwjjUurFEiYLUwNWJF7TJYPEQVfEVlIy5p+OgGv71a6JRDdaBId2jDEpHJrx0qZ+BVy2zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fv6zavBBMW+IXDrqsHluFp3siVaR4yxfyV94g7Gx8aw=;
 b=L09X0MjOxJEumu6PrWrfXNhsmS9sxu3jSK5Di6V4JawVaAKJT6OW6mvYqdVrOEV5FHe41Y9zePVb7xZdhTZYXgWigwHcOXhbIftGFcL4YHAxnozdH4iNYwNkMwD9V3EJV4Frn1sZNoNjkjZXnC8nXj/Agjo0lo/XFq60mJGhiNPEhVE0FaekG+j1gz272qIURnJRg/yipyolmbK4BvJ9GpKlahqWvQF/yx67rIXJwH13g2NNf9uWNkrI3/0SHpvz3gjTp1s9zifTV0F5yOV1jP2Q6TFndSZuj2YVVcW5IMteuFmlvhyFU2CNcBPb31s7CqZqkU2GpFsIHJjRS7fnJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fv6zavBBMW+IXDrqsHluFp3siVaR4yxfyV94g7Gx8aw=;
 b=WLgNbNy4yba4ta1LFHMOmBhIIdKjFRDk/Id9f2obE0hmScjgOAgjvqarOGMTXtCAYcAo2p2FsjPMzdtojtSLRm2MiKVmrdIk/NxzTdzrAIVQzdr4Qo2cLAd1xk+oLKJCwo/q7e6z7eJ0x4/+OzWd6Jb6x0wRRfNAi/8kwLQSJW0=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:37:55 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:37:55 +0000
Subject: [PATCH v3 01/11] KVM: SVM: Introduce __set_intercept,
 __clr_intercept and __is_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:37:53 -0500
Message-ID: <159597947370.12744.8741858978174141331.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0029.namprd07.prod.outlook.com
 (2603:10b6:803:2d::14) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0701CA0029.namprd07.prod.outlook.com (2603:10b6:803:2d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 23:37:54 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5d7536c-3fe6-4164-62f1-08d8334f403a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25591F6CA22E58AB731E31E395730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EjKhGJ0jexe1ztBU2hGr39qb3oe8jhbNdmBsbcNKsGYcHwUk0W9+f1Ivo2xgA4aA7fqtFYTF1B4gt+aFHqIqQt/+Vrwjime5rGS7/r7tzpfnnKE1u4+VEQTmHFvLRr5h+5glKvhcoKbL/k3tKGbae3RqDJ5ouf05WB5ITOmMAwdhyg4TrdxS8QfO5UDnXXBvgHe25fusPRzOey9LRvBTCx1uvhXF5zkTNHHdj222Ma+rzGgRl2JmoA7M2AKpLlriqZIBEmyWJE0cNKC4hTDanOY0GwvovSZ0sf1GgfaYQckS0eDN9FIDZrzzBK3HxxIB2MlyeXouqCxuytgCdsdIlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(103116003)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IPJtb4OOdcQ4t4ImitEcO/nuOZe4iLceq3KsAS6Br/0d6xnlXsWr8Q8KdmKjvoGtNeug7u1GlY0X9tPU9lzFGlTJKq4NJduMbfEfQLLTtrui2EoBLnaFNthTV0v4e6ICZzFzxVfLdX5U/j9X/kYws81PjFqegjZh+V5XzHpb45+2z99bFrovFalcM0trAx0O2mWLLjI9A0pO9GqAmw7TE25sS2/hZhlJfwAF6tQD3m8b3hD+p3mTXCUCKOXbxmROLEzErhvOfRh7DozObiRJj06oS1qlWjWws8KCCOAlrQJWmkIHGYx6YeyVpygujZYMx7lQ08TJlpAXC/Dwll5yKqXOeztzVHXl46Kxax1i55piYj2pUoO90csHG0Ilf2JyiIuw1/N8yYc0byYcDFy1D1hFz6sdjztLzEAamTJ8hiKSyu1DDL70wTg1NYMx4HGaF4fBo80e36eSXWmx2pZYE7mpuvIrfBDjWPDy9Pqz6irbpZBxAaV2H78AN6PzqgamOf/7Wj3Ru72WtZ5yFRSNuL0pSmlumKO3O/pnIW0ihGAn/wM55QKUenJ0V3cJww/eaMNxnSYetve48+VAIrnFFBVriL9CjwfSIII8lGQ6T9Ndq0lZICcEe7bkMiNMgb+usLta4E7YOOosupLp7RXTHQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d7536c-3fe6-4164-62f1-08d8334f403a
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:37:55.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgRWFKS5ksNNSlV5Wmxqkq3JuByJdCgMg21aA6U9TWas39/qyoTFSU794gcvX43s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is in preparation for the future intercept vector additions.

Add new functions __set_intercept, __clr_intercept and __is_intercept
using kernel APIs __set_bit, __clear_bit and test_bit espectively.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00a5d82..3b669718190a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -217,6 +217,21 @@ static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
 		return svm->vmcb;
 }
 
+static inline void __set_intercept(void *addr, int bit)
+{
+	__set_bit(bit, (unsigned long *)addr);
+}
+
+static inline void __clr_intercept(void *addr, int bit)
+{
+	__clear_bit(bit, (unsigned long *)addr);
+}
+
+static inline bool __is_intercept(void *addr, int bit)
+{
+	return test_bit(bit, (unsigned long *)addr);
+}
+
 static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);

