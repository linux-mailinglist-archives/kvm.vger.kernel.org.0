Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90BD2668E6
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgIKTew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:34:52 -0400
Received: from mail-dm6nam10on2075.outbound.protection.outlook.com ([40.107.93.75]:49377
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725835AbgIKT2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:28:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyi/i5NGGL/Rvpld8rudFDBOXQAoQ6EmJYNoTQf6T87GTa18MAeIcPRl7DkqBzaKZ7J5xKAH4s2/SYPsyziLzys2/6i4oYHwxJjH/keDQ22ioMCOtcRt0yfACZq5E6/yRqxJ0nRiGwQ5kRlsbIxUYpD9zFBBDwOjZ3pu00WkSKogH+CFNwmncJ5BWRM1tDcDXf3ADQxXd8y7aKJPBz/SLg9FC6PO+Of1Aa+mw0BFs5qhAF+0eclnLnL5bXNHkYcBZ2ksGcBBt2GyAQLOndLfY3LQlQZoRhlkOVtuz+FpCnGub5eI4bMQ0cWIwXn6mhe5i0BOLXwIZn8CUPlysLa0gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsEd+IONZz7nfctO26GqncX8mvyIk9ArYkf/jcTkvFc=;
 b=ah55lTjUgyAfEzMyoB/+bmeVmU7lDljyB9MmchYKzAJLJOD5PTZxbTTxmzw23o/G0WIudzO1h4+ithnyyU4hCfoKKCcVLE8ckOhwuBVckU+IpMGk/m7XF9tuF4PNsozu3IWbz7s3hUunyQJ3+VQPMqHCOyTTFR5KPaY8uXtfXQBVrT2OONbIn8B3L6HCiJ2xVZQhM5sCwMhQkjaAmNosLCweVew7J0ADrF6XLhhfI6EEQ43WHgvsJX45Bvjsumn0uRYcdV6riX/W2DNKK6p7RQlO/ZF+Ne/AK3g7ea0Gy7YCCkoyCrKgg+HG9m+8ZTUcZ3+tbPpgCtbTzWIq9fgtVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsEd+IONZz7nfctO26GqncX8mvyIk9ArYkf/jcTkvFc=;
 b=ZSIqcAu9yl+jFb9f5uCa8bVNysyKKqSIkJdqgJxCXbSNiRdW9QrDRz42Gk23leVR1XB7oLUf3mIZFW3t1aLvUbRu/oKru3ccdhw8LSxGX8+XqBchPIXkw+iYE+WwVBVU/jbCFWa+ziOh9EtD1DcQrXNv/OVV3BtcXqMcLbf4jTA=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:27:59 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:27:59 +0000
Subject: [PATCH v6 01/12] KVM: SVM: Introduce
 vmcb_(set_intercept/clr_intercept/_is_intercept)
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:27:58 -0500
Message-ID: <159985247876.11252.16039238014239824460.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0024.namprd05.prod.outlook.com
 (2603:10b6:803:40::37) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0024.namprd05.prod.outlook.com (2603:10b6:803:40::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Fri, 11 Sep 2020 19:27:59 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a6adda3-6338-44b3-632a-08d85688cb29
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45435A49D1B2E66976FBB78695240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a9qzhktaRsluvhbmJeJFRn5DaeGO4OL2y54em7ojLe0W7t/J6E2SMQERQakKhbi2DtBRUiPIjMJGoBYNLmYurlp7rfr88ppH3eA1fYVcjB6R+9wnWvwDT3YtyL4nK9jDv2THNRAgCi5rE7O0pfMXSMA9fVCbme7A/FgWZPD6Gq5IGN+tWB9BEUpV5oM36mwwv9sLn8/3Ba+ypMO3wyK7fNBx1BsRj6QDfCN5mOBmQo0yg5J6xbEDhSbzjMdhHZ00vF1hjP0gdnwZM+i76ZE7csFyGo67i9Hx5ArBOyN48XQVoFZhCPPTvRcsUN6xN9O3OYv67U8/ljE96/2x/8EtNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9WapRrfjuvClAjC/klkuCCrpya3FMC6Mw7ZfWjaNY02hXHFoLFMPo7WGKFEaYfy2PP0Kk/WiSZz/tcLGlqyAZwlI164e2TF2kOjbpoXcvqUNaGyXpbnYD8aakKniJh7SWZyihBYUVgOCAhNg9lJx1l/bsGhVsuq9keEgrdJXITjNQ8GghHowcP8hpEmNGuJrXhv9bhZIR5HSJIlcIa4Xo4ikU5sRLedLenNJjyC5S+bNPK4BnGtfutGPh2mW7kThEk1M6IB6fkqQuf6q0Xhl14treha6raITcjdJtlyCn/+Hvl405ql8TMbeOKAAKEUdevecLfFavHSeyXrVWlSCT40XEy9P3js3Y7gfJTPppWVtFGc3fC80EfX25JOl2KjHncbOqys1Aqpi5EBf8PBeR44LRTSWSaMPjIB+rP40+pWqnO/YVqYzTOpAIhF/GS3l1NAeNNrq9MpmopF4dd/FWjIbDzY5UjgxyC8T/LnADS0bF+TlDyWaQmeAjXOWd8nZLwZuToMHQvCeSTQ4nHJbVvpHSEX7O+Np1HHtwAdBZbJkG9ulWN03WJutbsw+VdUrB50gLLMSRZh5gE2w9Hp+imwbeQhcZeJ5H2ju3/1CRx6JQBK+LgTvpKi7L6JK4DdraC50j6LiN8siGJMD7qC05w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6adda3-6338-44b3-632a-08d85688cb29
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:27:59.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XTcBLrJJTxGiO9p1X9IR1N4kZHBdQuMxK06yI7AYY9uXOmI4ku+eF8cYzoJrvALQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is in preparation for the future intercept vector additions.

Add new functions vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
using kernel APIs __set_bit, __clear_bit and test_bit espectively.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e1731709..1cff7644e70b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -214,6 +214,21 @@ static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
 		return svm->vmcb;
 }
 
+static inline void vmcb_set_intercept(struct vmcb_control_area *control, int bit)
+{
+	__set_bit(bit, (unsigned long *)&control->intercept_cr);
+}
+
+static inline void vmcb_clr_intercept(struct vmcb_control_area *control, int bit)
+{
+	__clear_bit(bit, (unsigned long *)&control->intercept_cr);
+}
+
+static inline bool vmcb_is_intercept(struct vmcb_control_area *control, int bit)
+{
+	return test_bit(bit, (unsigned long *)&control->intercept_cr);
+}
+
 static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);

