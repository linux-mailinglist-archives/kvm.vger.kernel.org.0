Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFDE1C7184
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgEFNSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:18:20 -0400
Received: from mail-dm6nam10on2041.outbound.protection.outlook.com ([40.107.93.41]:24036
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728058AbgEFNST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:18:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXee8xr9VexgtAMd2L7YvOrJAhd5m1Qhl6MFXfeFvSH60tFB1XnOSKMSwUlGPm86ggUs+iL9xb9BrTSiAc9QTQuP+uNWTnRxTxL83mQQvw1Qw8kS1K1FoHjoDfSjHCK0LpvfjEQpkCi83EMj+xhYAKkpjs+9/olOmSYdYFRJMzoFVS4tFWM0Rxj5IuFamEYONoMwePnmRLPeATZ8f7i+LNFyshsl301BkR89cMik/CH6NAIODJqszbsifkNmP7NOKcEKVF2WtkyFaxFWANU2Mx4qmUwBBOET0MjkSlR5W812Nakm1p8pif/TpK/cx+mCd7ldsScpWHGBd35lags/xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgZ7+vNXdghQPjoh51NjFBqLLho2bNsqf1chHxvfiUo=;
 b=HfkuGg8ZkTmF5diZaYoFAVNWFZXdNsuZ2A4JXkUyQBMIeGCcCQyQdI0JTBIVD6qPXv5E6T/kZkWYKexzhlc6S13D8dfM94WydmfY3rOsdtSee9uI1QMJHlUXFBp6f2nWj+AIF/q90nadaCk/0rmPsOexJti0OjCyHwHfGhkTqTaVfRG0wxT5bIbtdgrtCfZov1jUCPFcjwsAiyoB8mUy3HwFntJiZOS1n6Pz1ZkSnQoatnO0bb2qerqcr+fKXC1rFC09y5VZU6H/dlBZYIHMt4PHQS9tVHlGgdY8qdpbXSGIR+QLUYCpcGcnYa3DRfmZ3q+hEB+V1HmFQkroZNRBUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgZ7+vNXdghQPjoh51NjFBqLLho2bNsqf1chHxvfiUo=;
 b=F0EiLJjVFhrlk561eIcCgfqvUngkUzWrG228MrmMmz5jl6ldACzDYeGiAqHHhd1UF7PzGLhGZ07YXb9Dj6J6JGtk0Dw/4L2VayTHcb5Wso63Brw/Z/k2hNxyJMn/2UitkoC0ixoO8t+6a2UDMciPx9qEezkmCHUmTWDCye8KxK0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1228.namprd12.prod.outlook.com (2603:10b6:3:74::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Wed, 6 May 2020 13:18:17 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 13:18:16 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        mlevitsk@redhat.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 3/4] KVM: SVM: Merge svm_enable_vintr into svm_set_vintr
Date:   Wed,  6 May 2020 08:17:55 -0500
Message-Id: <1588771076-73790-4-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:3:103::33) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by DM5PR12CA0071.namprd12.prod.outlook.com (2603:10b6:3:103::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 13:18:15 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e13ec9f6-87e1-4a61-b188-08d7f1bfefff
X-MS-TrafficTypeDiagnostic: DM5PR12MB1228:|DM5PR12MB1228:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB12284C1B7A0434F4C1EECFEDF3A40@DM5PR12MB1228.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtyUGAF+y9GvL9pqo79rOEQfX0TfJUbaUWvWEg8F77b5wiETYIoAlu7F2M7ecfHtEJ62EJCVXBO9/5EvhwVMpYjcu9+4GU8XTXCUmuG1BExMV+6YDQpmK/4xFOEE2jg7N1TQnsxdomlRtsXVRdJjwRTLG06xKiNRrmJJbiMGp14FNAAq9y5PO0CI4bJo1TnTZuanWlgqcJtHKun0u5QuHocSvtOe4IU4DNRcgsdXjxEM1Tbjw3A7ujzm/sCtqkxz1UBAW14s5Mw4zfrxUE1OhQslFMjLV8D6yGgz7P6J7wIVKPgcWc8Rpj1MNCrxvxjnfEksmbk0+h5LcQFQgi2UzK2Wf+giwukqw52vg8L9yt66TBr5WxfjxRJaXjpdR+mrx+5Iag7H594d4Ze19ac4nISJPSKOXL7tk36DgbtwZ7sVFIwc/uH+KTtzen2haGwxJMyPwYFZ2IX8KQI6tf07YmACtMO33/24PCejAJFlHnYY+PnL6N2GxdTU/Lg5imhHIgwzVx56SxkgfauYvF5k3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(33430700001)(478600001)(956004)(2616005)(52116002)(7696005)(316002)(2906002)(44832011)(8936002)(36756003)(4326008)(8676002)(186003)(5660300002)(26005)(6486002)(66946007)(33440700001)(16526019)(66556008)(86362001)(6666004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: S3OEfU6Hy/x32D3XDXa7/8EP+omNMrBEfwPgZxzCtjOPlMAZsYPkrsWn6gI7uKx/7oQ5Hwqe5h+dy2ogNqP1wk7NHgF7q3wAmA5riwg/hOX0YwrL/a8FZDYTA64b2A63d1+A8QzyupLsukd32e0QzipeyiCCZSFieYQ9+EppSP1AqExO48RxrYqHeyQb0KM63Aqo7LILp/j2ydjjB684JwOtxRUoBcRJm8SJB3VTcACu6EEN8Y85lDFu7kzdXfT9Im8p7koE51q8O588+YcAJMw569T1hxxRoNjHkrupbX6pqW30mgs4twTLZKD8sLEqvlj/cPHPDdxPtjK3JrqueARPVdh7ypDce39YthsocR5LBhg+BGnYOMBj4+gJUTZEWA7vKwgA08PVCmoPoiXb+NehDHn3YVekRJhPiMwVw4HbO+O8MB8GqkVw3sARpWmpEREU5wjbbITnp/xe41Guk4yleYEwXSM0e4zNP4Ve5URJ9XG40qhYp7+fhKsRhjWnMsGmzXLVZDkcO/iSAskuQcEjoko1tFv0T/U9Ljjb6BbiQYV9LdZAdaNj718/P9p5ECTiZQYbjjdBZ0c8N+bRsBviPskq/0Y3vmIcXQ/DdEjUSNjX51TE5MeNH7Epm7e4aAAwdccogOndE9VBHPwWMLkmidVjEvGr+syFhA3iETcHv2E4bYNJ8k7U9XIKJJGAGXQ/6IMos064GFYPRUZZN8w8sXlw2GEhg4gCC3Ldq+WHBcSDCBptgZe+UBCrdUvCWjRTfD+c+LdHRxksZALZSKQjG0Tun1RpfREJ9sf3QwM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13ec9f6-87e1-4a61-b188-08d7f1bfefff
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 13:18:16.7852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /sF0bIM7c/29VjQrtr2Q9mOn83+YXEE+ZyLRduJNinuJrNmznkVSZWRM1vDmXgXwxMD9nTnDPCmwZC9VCfhj3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1228
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Code clean up and remove unnecessary intercept check for
INTERCEPT_VINTR.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/svm.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c2117cd..8ac00b2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1364,12 +1364,13 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
-static inline void svm_enable_vintr(struct vcpu_svm *svm)
+static void svm_set_vintr(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control;
 
 	/* The following fields are ignored when AVIC is enabled */
 	WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));
+	set_intercept(svm, INTERCEPT_VINTR);
 
 	/*
 	 * This is just a dummy VINTR to actually cause a vmexit to happen.
@@ -1383,13 +1384,6 @@ static inline void svm_enable_vintr(struct vcpu_svm *svm)
 	mark_dirty(svm->vmcb, VMCB_INTR);
 }
 
-static void svm_set_vintr(struct vcpu_svm *svm)
-{
-	set_intercept(svm, INTERCEPT_VINTR);
-	if (is_intercept(svm, INTERCEPT_VINTR))
-		svm_enable_vintr(svm);
-}
-
 static void svm_clear_vintr(struct vcpu_svm *svm)
 {
 	clr_intercept(svm, INTERCEPT_VINTR);
-- 
1.8.3.1

