Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705EC23E554
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHGArO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:47:14 -0400
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:60064
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbgHGArL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:47:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aM+NIZJmp96LN++Mu7vykIgR0bN9Zg3Z4U7oaORPxJwr6GUy1nsBTFLPIRZ7OYxU+jy++TZz249DCPdr/6fcHGa6Skeyk8oqZ4jx0FH6fjElgfRDdwpzgecoeomfW5qBqEavJkC6tc8akpo9paxhqDnVqmPSk5QvgSZ+xaoNEcb20fDYqEJ4Z0ap6pBqDCqcg11xIwb9iEPxYUwmUlYr/d4BwMnFim1JDx1NemY9PUOH2JDs20UKG6pzCSTW5mRzjMMaMzsmtTaIEVIPSeE70qEAWVUk9K+iiBqYJyW7k50oWIdU5Jse8k9MOFi2SwJYeQot7pJ1AzTI3MbDN1FXHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqIK+sbjSGRERqMOW+99tS1Wit9VDhwdsPbKcW9fJ3E=;
 b=VxNQnu2w4I6P0b+vHtLAypoS6NzTgI8htzvD7+m5uu8L9kNmdYr8HJvAzAGQM+8zvxjcJh8Bs+TXvJHKGX+UW/88OTuhU+yXjAuswN+TP04uYSuiPx1RJeayJCTxEZk3TJtR8plu5kJUr8nnEfIOAmnZOizShN1+dS5L0p1UfZjISkBQcqZG1zXkO/m3F0PWHc4zSapCGePF2TdHPL5GlFgfU4Ew6iM1uPIE+8uUR70/bgDT2O8g649a6ZhDj1wGD0kYKm/K50WsyMfMujaiTncS+APx70wieb/5m+FuD2t68XqWIDX1Apseer39IYBb/jOJIEQqENBPBAAulAiD9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqIK+sbjSGRERqMOW+99tS1Wit9VDhwdsPbKcW9fJ3E=;
 b=CsMMfp1o7Wq/DbK6oUi/P9lYjq3Kbtpa0FvTcqKYV8gQOySWC/cVz++KioSsyqylXDqTpN2sg3KLVswRXANv74Je8cKqfvgJzOKNCVoz5cr9QPqcDaDsmwUxUWontt6avc13MCjSQzYEfPrMM9NxzL0qROow4ZhPOauCPmJH/Ek=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:47:08 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:47:08 +0000
Subject: [PATCH v4 07/12] KVM: nSVM: Cleanup nested_state data structure
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:47:07 -0500
Message-ID: <159676122778.12805.17553021827193643253.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0004.namprd05.prod.outlook.com
 (2603:10b6:803:40::17) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0004.namprd05.prod.outlook.com (2603:10b6:803:40::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.5 via Frontend Transport; Fri, 7 Aug 2020 00:47:08 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9904e1e-b7e1-44d1-77b0-08d83a6b69f7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44798BC1D49BA7D4D0F9545D95490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y40n/j9ipOS+V0QXFlO/MCBrP5ZxWorhenGDpu8yyaQ4Ul77rnP/0T+wt8DpRCoHUK06ciXc/876S1n4aFU3Ih+G8r7mKKYdiIVR+L07rUI8t3W22WyH3VyvRtbmCKaGq4ykv6rkSNx+jsmN20MfuJD5VRsgU1+lbpkv6sxtqLPBVIFy/0uBTW8y5N+iS39Vl1uMoLkMbIlqa/T/Z5fxiMdirrvnWHiAVtORblGrfPejkCs6MUHP+L/MLRUxzZH94BIGAJJkh8wCNBAX5YKZ5DB+sXSX9dVXYhJsA1RUK+X1IQTZbUCyI8ZU6yBPhSo4KHov5Rlzp8n7wo0H37cgEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: j7LtQbVM76IRViR1XFcAu5tdeoFm6CfuZy8NMuqVAtZ61KA037t1wDqWAoQAyRO9xOTuqtHwVkqevv7UzuNim0i3RV/OjA+pt2o9RQdVhqiz4XD1FW4bWCoPrmP3/QwSc95zX+CjSW4/UNyAkqlyfMwjJDN0/jrzu7IKe75xTrHaWiggz6g5qxohSbzkUL6UZ5PreJGXsKYg3dzRZUQTxcUDToW+OT2o9ZZiqTLICjcx0d+vogMwlq2fjQB69hqJG7CDD1TnXy11n45014QpsYFicK/AHlBpwAYaUJ7ylfM0hoVlg3MUhbqHW18P0eVO2wAAl+5aJamOoCtlLTubSMc1lz9aSA4j8h57PfsIdJaghpCBSGbnvSkKNQGzXMFy+3bwXBAsFAiIqlGXx06Lo4N9Z0LUgwFE80TjpqNT2HTOBLi50Meg+c86RIVpgOSV6NM7W2XkqT6a/tGevEb2/c9g7EbYCo6t/QABopQVa/xRaNu4c/qpHozJPU1QHb0XP2SKlCBu0D8L2m+B7w0twqHmGqlSrGXoNgPmx5gTzAgSt15UUNOk4ffCwCfPWt4errWF7X1Zyp49/eF24Cf3Qbb4RFYqYzgD6T2r31eLH2daImqXzdgEqPXpie++Ow5k2yijMh0xLnPEbckhumV1oA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9904e1e-b7e1-44d1-77b0-08d83a6b69f7
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:47:08.8151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6UK47SErVNhgTNTit45hRbaFsDn3fb+HfVRtAIE1FdtRXBcOu4CmK59d0plOHeb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
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
index c0f14432f15d..aa591120b4ab 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -116,8 +116,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	h = &svm->nested.hsave->control;
 	g = &svm->nested.ctl;
 
-	svm->nested.host_intercept_exceptions = h->intercepts[EXCEPTION_VECTOR];
-
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2fe26c2df3e4..0025d6f2641f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -86,7 +86,6 @@ struct nested_state {
 	u64 hsave_msr;
 	u64 vm_cr_msr;
 	u64 vmcb;
-	u32 host_intercept_exceptions;
 
 	/* These are the merged vectors */
 	u32 *msrpm;

