Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427201C7189
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgEFNSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:18:30 -0400
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:6525
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728592AbgEFNS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:18:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcRzv95RBl9DzestTRdVXxxqRS7wiQDWDqnOhUpNV6OVM5BNkbkBufJdGlobmTi5zrMukQ3uIHE7AJAamgt4eto1O80rHRM/QJaFgt0XxO/+OgGtDC6Yv+3gUWXz1wJ2Oka5fjS5pU+E7TljRVcPTGZbBdLEGsNQafY4zYUGDtEforxrIhsiVY9RzLVcxyTAWstLfxPjN49Rom5s2S84K+6P1JhBRQgWA+p7mX9+h6viHobtVp2HPFxiV/PjxJCtVOHh16krlcBzfcrcA5nLmCIZ5Wji2EdPWAbipDt0thdGPBg1vvgJh2nkZaJN4QrpScInKz+K8CYx7eQZtfMbyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHHOMZpR3eK2tzrC3sApZvAs3wH0hW3rPgR6Bn26IDQ=;
 b=TdgjoR5IjbvarIGnLfuiRAeKPraLNDlRLXjlP04jjmBPCCAZ97klgRaWqK8RVYE/hHyDZmAovGflJzihAK6V9FnmhCLu51l3C81qFEZnNtCcFsvXGSZZZcD/9uKill6EQgzad0JmyH/IUjGxGf31jMMYUu0jSmGj9gSwoDPmrEBO5O2xD/HppFl9OlyOLu9A8tGceqwZ0T+KamXKfPUj/qs5ydW4DdO1Q78ZnKVI7AKG6/8gYyDt0sMPDPKF7lYBas7Oo9qWhCH5ngZU4Y3IOzpgK4KgdZ4CffsS5rmTnB66oSSlLpoHFTJqiS8cX2C6KMAeDkA4LtncDXi7bLtTrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHHOMZpR3eK2tzrC3sApZvAs3wH0hW3rPgR6Bn26IDQ=;
 b=3SYn7fl8K95y2fVN81/AKc/+Doe4LzAVoDHiJdkaTyxJzFhPfM3pvJiOfftzhMCnyOIvqf2lnZRp2Z6UPLQvW9PKbYp8R0UucJCCn3LQBZigC3ms+4fhQLcR5EU1cq1vosR1Sq/xCtentLW1++yuvjKV9iZPSjfl1mfGdneS1rk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1258.namprd12.prod.outlook.com (2603:10b6:3:79::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Wed, 6 May 2020 13:18:18 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 13:18:18 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        mlevitsk@redhat.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 4/4] KVM: SVM: Remove unnecessary V_IRQ unsetting
Date:   Wed,  6 May 2020 08:17:56 -0500
Message-Id: <1588771076-73790-5-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:3:103::33) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by DM5PR12CA0071.namprd12.prod.outlook.com (2603:10b6:3:103::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 13:18:17 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 87063f03-a4d9-4056-9065-08d7f1bff0bf
X-MS-TrafficTypeDiagnostic: DM5PR12MB1258:|DM5PR12MB1258:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1258F13CC10A583FA258F6ADF3A40@DM5PR12MB1258.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:163;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YxVyEbAAxdVfihqs20JH4GMLNpHv5OudBbqhAou0ICSFFRVAle4VNLwwyu+U0vjTvpk5TRXFHOQ/DQUk76HpL7se8IejSRZTyiXA+Zt0luazWCMyGwPTDe9ideJjWOByMZXKkp8uGlHr6QYTafWw2WwRXgW/aEoCzBmFO7FcAWs6BtaV8Fx8Pz55/A2LRSZ7TBPkwyLg8NlNiJMwTOlf10py3Kkb5aApuuteQ26WnxydV7/IoURueCaiva/CiTS5YeyVz0I+OKc+3JyyL5snue3PFIQUNJ9ArbEp+2iT2O26R0TOHlh36qgkBJHioRA7X538B7rTTz91AZQ9fnQCfTzo7hWTy1UgTo+W2pvpT70zR2qcQJuM6sTxzxyI90OM5DbhVD7AXjZghUWoPueyEV28mVcoF0VqS63Du32Xkau1se3CCDnvEsIfB+yRW98+IjIso5ExbVW2eOx1QJowXNvT0j+U6ElnbGFgCtZSR9XyshLRjVF+0vez94ExVWnfSxoWT/yQIfpIJcu3lXvVIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(33430700001)(4744005)(5660300002)(66556008)(66476007)(66946007)(7696005)(52116002)(8676002)(478600001)(8936002)(44832011)(6666004)(2906002)(2616005)(956004)(6486002)(86362001)(316002)(33440700001)(26005)(16526019)(186003)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5tqXaAUgaPvuF5qL9AJamN4jGXw+/PreR8eGhQKlx4qE8Qdsn7uB09dBQpG3B2ak7CNXmY6S6nf0imPbZEOmMxNZkoz6eDo1InBeOKGU5754YW7Xp3Fy8y+Do1NA5vQg8Am85mmsm4/lIN53gr88qWTSvTe/hvZHeo7CKmNqefK+x6b5Agutth7dQCCzpyGTYv8Z55nMQVR9q5z7e/m5SSLYnesgIia3vCXg3kX6vTt59hvfylIF4iCR6Rj+mZXlX//hgWw8wXpsgTZ0S0PKEeRLpMlGJOQTMpIrBlaOrnUfjcIioNka4ZJr6GnSaEUlbnteIHvnnr0vJVjeiiT5i00oDK2v+LffNBQfet0IBVOdiE6pOTuZ5BqyjqaitIOXWjvmDWVUi+2HDwLgeX3ar0aWBaW+/s2/Z9Sa3E78RSnhWcUZ/Q/wGd489Mfl/od7Q7XrccDC5VlLnthd6FTQllO+u4PHPYso/u4m330fnNfwdH4TvjX+XmlUKVf30yAYN6lV9CPG9zy9zDhbBOwJotoYmMNmpSDWHXAiHK3EqEes6KawZ5epHtBmLEnNSwMRmLR9Q0XO150XnU1Uyb8cH9N1owv0FYSroXZ09zgpU2IwX9qEcl89j/ph/G+1XMKGK53N8nkaDVfUvdJ9MF5UZIGYsp9zChyr804Cx3RSCG+DjWrobhjW0b83EaRzqxlLbHG/C7qb6vf8p8RZcgdFbsHs8EFbqlPJwJO+OvvzRII5ivJpPH/3oSO5lBVjwEMq7d+49oMS0xuaCVFG0ti4QCKlsswY/wtXKjrlcUdc+3M=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87063f03-a4d9-4056-9065-08d7f1bff0bf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 13:18:18.2595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yhz4BxlkO8bnIiCNipRJCylvmYlutyD9szQ11caOsi75v2augd/djpx3Uufx3/QJlxwILjl8pKpRo3/E78c/zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1258
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This has already been handled in the prior call to svm_clear_vintr().

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/svm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8ac00b2..553d4b6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2662,8 +2662,6 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 	 */
 	svm_toggle_avic_for_irq_window(&svm->vcpu, true);
 
-	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
-	mark_dirty(svm->vmcb, VMCB_INTR);
 	++svm->vcpu.stat.irq_window_exits;
 	return 1;
 }
-- 
1.8.3.1

