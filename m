Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527A72668D0
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgIKTbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:31:10 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:23168
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725994AbgIKTaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:30:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hS//sYbddjXmPodD+HFUUVL9sILWva5IjllvHVQlmJBwswMQHbOz4dWPppTOgsi5O9YZ3agNT7UxdJGs/ISPSDCFRNd/oFxXe3ed4yDuHtdrdlIz0aU/dbIbLh2WwTUttNax5JTfuDsSnnuXlFWzjF32DrYRzOCToi0GfbaMcYlVcTiLpNidgBhqYGWeSW39lBOkjefyEY1VScJxTRf/6xO9OTFyNgZWFw0J/ojXcPEIXwR/wX63g6UyA5UPyY0GuFi+2dRPWXo44K/2e5tyS4HJWYegkuMKXAaSioWm59OF91CV3EU1i7q+0iUgKUtR7Ps7PoLufR5fW+0uxAwSDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JU1ERznecWKXTmr3oMM4GGrl46agKbxbrbch5Bn4/M=;
 b=j8S5GLk+9w5IcToLeyTQMEP+avWfvcM9liLf4N3yq//BqMGk9N11kMdy9LJbDfUSqN16sh6GgwufB5Ps0jDNuGJy426jvfq0AwSMiVZi0fDV+CfIrQrXPxgyBTAhaZGQwsgx6FiSLd3y1aXRLBOMZXjGZI+NLdER+6UN7kKqq/zDY7kO96gWArNAGGUvcBqffuEKYad/KOHl2B5qFbjqc6v0AAOtfTuIqj35jBUs2hEYv+BfJYVu1Uqx6Ri2l7TOnCrh7Au2uZHHWun4c7reNM8f9O7KHcWngwJ67c/HWL8i4leNZh6RsSfGAfbiozQE+fw/TYvT03CKn75EbiDZeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JU1ERznecWKXTmr3oMM4GGrl46agKbxbrbch5Bn4/M=;
 b=XBUrx+aJzHI6O4F2pLAxkJlccwkuSPaiD34HXghoK89C2stuKKg9b8YBnSqy+TsZ1+XxkXfJkHE1hsU3cWoFfuduoyGboDnhsZ7egFAMDeluntd78HroCINDb+MR+X7T1gLpSVx4wbIxMy+DmD0AQSPGlGSQppBBVjPcw03fJWs=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:28:45 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:28:44 +0000
Subject: [PATCH v6 07/12] KVM: nSVM: Cleanup nested_state data structure
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:28:42 -0500
Message-ID: <159985252277.11252.8819848322175521354.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:5:40::35) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM6PR03CA0022.namprd03.prod.outlook.com (2603:10b6:5:40::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 19:28:43 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a53d6f11-9b6e-4218-7bbd-08d85688e608
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4543C3505E6AB6688CDD6FAC95240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Koe9NhzthnI2Ljzd4u0CWzU9N0ne2OSAsaXg6BcpqQ95K6qGIGZCguO77/IAWU+KYQpN52eOESnfRjIjmf+f+46xYT5E1nCEMf8fDqVkoTaK/iFesSSTC/THVwvqil2uzHyDlBbYR2pCb0bz/8AdavMb0xhZGPDhySxfISfAn/BAZ6QY6Dpys2dXcdl8bDZk9KSOA0+nyO1PofvheQGZ4e8zCbUMYyDZYCt8NHHqbEj2R3SI4YZDcM15NuoFlirUnIapBg9bI5aQfZc5t7G0Qs3fTqbW2gW9SndKSr6AMkF4M1cQebQj2LRlvxni92d0+NikJZMthIkP3FPjKDWh3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tOvaZsLacTieHmxBfRd7ASDNGBxn7dVkNa/F8ATajLmVO/UiE6EhRvOA2J/ib8MidlSmKb5P/XBSvvhPWuwFoXV58M3EgTkILYERJEgHDrgXybxrOlGYGXokjpEv3TiWP08fzGa4hYoxVuOngeCIWAN0GiJiP1x5jurkq/25VBoROwAO2WqIL0eyWCQlEKVrYKM5HdkLyOEbgsMsJl0iSo7Fm0+M83ZHM1fwee4UEKJ0YGBgIFwp0jHc0G6Tj17gAStkpuiOimX3pSIeSfc64ojsvzzAWU5+B2aMZSfh4VBaxFaCtxbTLHvI04Ej17ST7vMwELSCNoO6s+cwvLDmi2N+NXPjfKWN7TlIlRr1oPCXAQ3xpuXS2RlRUKPzhCm5TiYcssc3lYCfJi/n8CTWT16ANWqvsU+MxS3bvH0CxO5zmFWdiNBZXRpRBRRTtL/bIE6eocGn03vifHysojHeHQSJr3j80t3sQGkTsAVFqglUtq0QBl237tb3ma3IgoNTVfC71HqIUhfGq9+BVlZ//H17Z8TXt1AVHJNIftm8TT8zwivpfi2pRPOyjDWjBViZpgJfk02hM6Mug/avMJLdS1QvPMS3ecTFJFfedkPVlnMLGKUzo5/2552523oeVfNS5HKnkgpfWM9ictSAjOeekw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a53d6f11-9b6e-4218-7bbd-08d85688e608
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:28:44.9440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJ9cmmFitBaqp7LC7juO6cAGC8R9HMyCHJYL50ICA5419QEQJyaKlYtwmv8VVTVx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

host_intercept_exceptions is not used anywhere. Clean it up.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c |    2 --
 arch/x86/kvm/svm/svm.h    |    1 -
 2 files changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c833f6265b59..7121756685ee 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -109,8 +109,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	h = &svm->nested.hsave->control;
 	g = &svm->nested.ctl;
 
-	svm->nested.host_intercept_exceptions = h->intercepts[EXCEPTION_VECTOR];
-
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2cde5091775a..ffb35a83048f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -86,7 +86,6 @@ struct svm_nested_state {
 	u64 hsave_msr;
 	u64 vm_cr_msr;
 	u64 vmcb;
-	u32 host_intercept_exceptions;
 
 	/* These are the merged vectors */
 	u32 *msrpm;

