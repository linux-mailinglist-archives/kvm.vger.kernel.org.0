Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6163C23E548
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgHGAqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:46:34 -0400
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:19169
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgHGAqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:46:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8gmW0Eo7GjSnGNbE/i+0usv/YxBzYRsKAbE6mFEmNHDqnlOWIC/HyvgHod7XD3TmQ6wY8lpNmbGyLVsuQCudPBC7zjJ76rVXoTCV+lQ0Lo/+dpXQ+L+oTH54bjPkP6Ciz0b2Xd8FojZwGF/JrCdkeYCiYf1xGQA1NvRQyDzG23BQy1lDXhQIY1Dcoa2Y2ddoWfSZ7vi5+z+MYboGgUbvZ00nio1XpmoQ67A4FCag43zBpCiFoHhQCWNQItw8byJxWcOK/s/Ja+vOiVj+V1ceZgjMez0z6mEGMaMxQsETjL7+8jxycz0ElvqINNL0L8rion30l5L48wK6A61EmJ61g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLHr1P/78y+aHbvdJT3nm6q4XPc5Zv8AvX3Ih1p4e2s=;
 b=LBzKGs9CrR6FYBEc3yaBQfh1gEclcvnmSy0uxUgUbtHlFGzxZsQsn8KKA9cQL+1f7Ntr6+DhDR0yNxYUtcDOOGHvKaVhoJl7pVGBF6V0vfwWNWORuyFpXtsyD06TzsV/Jz6nfKJKja+IhR9srBGCas68Be06Gs1pI1sl4vvMI6PtK/hJG/zOK/bQ/OKO7HPD75x2lnsVdcauYA7817tnEFjV9dN+RZoT4GJoBsF4BrDxX0xlwMByx3pC7SQldZ+r/fDqF8G29Lo9VLNbB+4yahbWler4F+RslJjhP25PW419OoUyCzeq4As6yLN9vjyeIy+hCde0+Fo9Ez8g/qFOMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLHr1P/78y+aHbvdJT3nm6q4XPc5Zv8AvX3Ih1p4e2s=;
 b=sJa92ZZ/361HCVcre0vLVHFxixDDxh4Zf7a3L9UZ9Czt4Xc1BqfgeaQmAZSjsCW/Xga4KYJ1PU67LgdnMyUwCjaMoPNuggJ00tjy382J8xjFQ24XSOTEfVvplKaK2DEyyhKR4+UeV64aSzcBZBP/xD2syvr453ZB+2r4yfqNJ9c=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:46:30 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:46:30 +0000
Subject: [PATCH v4 01/12] KVM: SVM: Introduce vmcb_set_intercept,
 vmcb_clr_intercept and vmcb_is_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:46:28 -0500
Message-ID: <159676118836.12805.4817403954662511426.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0092.namprd05.prod.outlook.com
 (2603:10b6:803:22::30) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0092.namprd05.prod.outlook.com (2603:10b6:803:22::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.7 via Frontend Transport; Fri, 7 Aug 2020 00:46:29 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 733b359f-7d37-4ca2-9574-08d83a6b532d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4479ECD7255D87D1BF2FF65B95490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZFlDbDoACf2SfQlE5MGWF8L7EM7CziQPuc/ecXGl7ljr9AtwtPg7xV+wQUEkz1wcFrfaGxGtbSkWPb7wi7NnAN0A4MLFJJj4DZv+cDyimsjY7LGzrFHktJ5UMulkvv3PVss+sSk7WZfgsKhyMzGxhOjM2aPpMBjnjGQ5utN+xVQiBwoFKdjt55DJVD3SDk7eScDf833fddBa2h3lDSReA/tOvGLWTmwiUYbYh7LJBoeYM+OHm+h36juctfAymt20Mj0i7HlprNNUZYC9Eu6QPXje2Lz6fHa/hi7mJ1ehYxmqFDOJFw3PLb3Pr3ieBoyq6Op+U+C4g2xVMLDt9PN7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MQ6H6b2AiVCK/0jzZF/oEdC41B3xYT+pkn5ytHuku5GqMDu+gHKlEaE2Dwb34sJmlCvlXWLF4TILRSZBh8ogSylSCEv5Bj5jH/xGKviAT5H+d5gLA4QMJvGvmn/x2ekQkBH4Q5RXPBcrFcZuyLjGI4lQbY8oeUYmOvU78slpAc5YL7eYYLPO7nVqRPLt6tgW41frZloBz5Z1B3H+I2XsHZLSpSiavukKKqOwRBsOXLud1ARm796VwCAafZTg/13Z6zkyQWGBGD0nWubXZZ3iT07OpsMARqA7xiNZDU9hyyU89sh7l6GwmyNU8DhrKhs5VlVJ1HKN9pNhvx5/N+oJYsd+kZbDqh7rFG3CRgp/SrAWo5KpnX9WqQ/Vj1cbaPkl6vwmmdZ+v7IzXb5XYEkNXN4xtNephgiztGUAO7IFiXN+OJkNRUMpLAur4iSVNwNEUtYvsEI19QVzeMw2bqulpir5Lm9gb4Z/pvIXbyHDt8H4OMlwyYsSolFWk2xe25omzyTy8MnSLYowVt1PyysUYdf+89htoxnLQmKsbf8MQoJ9rp3DFS/WCe30IlKv6xmFsacGvGVgg+IeagrcF+IiGNU7lvyuoMhue/73ulVmN3QXdz41zXniJL33xEygRIo8v43y0XXuobG2cU/NVia9Gg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 733b359f-7d37-4ca2-9574-08d83a6b532d
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:46:30.5722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiWojceaHJg5MTfYuzggx0IG4prWwPAsYWEjZoCg0AWItk9E5NzxOJeA7lURFsjx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is in preparation for the future intercept vector additions.

Add new functions vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
using kernel APIs __set_bit, __clear_bit and test_bit espectively.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00a5d82..9f3c4ce2498d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -217,6 +217,21 @@ static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
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

