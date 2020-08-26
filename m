Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF4253806
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgHZTO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:14:59 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:11707
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726834AbgHZTOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:14:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xnjop5hHLWYWH6SRPp86WXkx32GDSE3YzlBeg4zJcbHckgwZkek3D4B/GebF/PMF+pOsG2keuB4lC/hCHFxnd9V5Ir488kha7/tXOrTvtYIsV16flQcAw5TLPh0ZlW5ssJovsFrqcjIjeUHkhRJpzRYQ5XPxoStaJmjGYOi5K6bzFl58w9IOYY/943J4hs553HpWD6wEuM+1YkGDBHNlqdZ7MDFlQ4An/wZPCt8CXq0bv0Hl8bk6K7MEF+2Zu/8osVTKpx8ykXRnlPvOAKkfjfuvx/p9X99YjGDZOV881vj8EmSXUCzF8xgWlU1bZl/OvW15rijJ8KNchdcE1XWqgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RaMlFYNoR1P0Krz72BADyV2LKcblkTBsnbNQpWGXfpM=;
 b=O+ZiAvEddQUbT82yFahtrXJ8Gq65M3DEpkZODa+QLQ4Eo0C2B7a4IEL2ZHoHLrB/ahP2o2PG51qH8jCTVaXv+nKKLl4OQ/HI3RT2SF7bDVOWnrvcaid6bJkhAGvtztcY3O1mQ26oicq4N2aqb643jFtyiCR4tO7koLH5SNDPW+3zAfVT6vOAIJg0e3xly/BmLMmZugIwdDR/G7+IlkDpj/AIsZx+XKaSRiThg6rQZgl1zZll5Vs0xIsb/Wdf6kUYcWhD60igWSQfsJ0N/OdJPBZ8WB4SeQWeG1DN6C259so+Bdz75S95uhE4oq84OhUWeulzY3W/BTQpQmpCvY8wUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RaMlFYNoR1P0Krz72BADyV2LKcblkTBsnbNQpWGXfpM=;
 b=ArH+bCzyPZ38C+LWMii4SbyZIBAuLPkBVCfdTBvHGWlTN3J3B5kmQUHZfz5iPMPmNqS032NIEAP/YzJQIKK5uglALN4um63xfMX+Llgt4KFcdBeECmRUOU0vX3oUWI5YbXj9enYEaEvwTKy5C2f9wXwDRnYvKqp+zgifmXkNjN0=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2461.namprd12.prod.outlook.com (2603:10b6:802:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 26 Aug
 2020 19:14:40 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:14:40 +0000
Subject: [PATCH v5 07/12] KVM: nSVM: Cleanup nested_state data structure
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:14:37 -0500
Message-ID: <159846927770.18873.7353727438893595666.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR18CA0049.namprd18.prod.outlook.com
 (2603:10b6:3:22::11) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM5PR18CA0049.namprd18.prod.outlook.com (2603:10b6:3:22::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:14:39 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c59a09a5-93a9-4a9d-9166-08d849f447ff
X-MS-TrafficTypeDiagnostic: SN1PR12MB2461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB246118D90F55D81FA520F37595540@SN1PR12MB2461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bya1Sg5/7WEtUMwbW12kIASYsaS6pi0VkmydcBc9Tf/0ptGX2s5nixXxo51lGsFmD89JOFSvINAQrYli4XCi867LNw/Ecx2fXia6guAjD3egXroDcqQQE6oo7YdDJ13oe8oXVMgDhQ4tnhdl3YuVNILw87KUR5l2yKsyuj2pEr94dXMb7DT5xBIaQV+jreDTUl98T/VLI82y+DSZBIKG8QZX9UlK7qqwLc9sU6Cjwtp78suAGZOxfh1N7FcBs/7HrGbxNdl4xnCnfnnllKjYXwQ4UrziPh/oclIarRbQTvGU+wwuOg96YewiEduT4XdYH0RQiBfJ/6+gBVX1sW29xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(956004)(44832011)(66556008)(8936002)(66946007)(66476007)(16576012)(9686003)(7416002)(26005)(478600001)(6486002)(186003)(86362001)(52116002)(8676002)(316002)(5660300002)(4326008)(83380400001)(2906002)(33716001)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nKRDeoYZbBZ0Uoa1SrWYONKzE67/WRZU2vOPWhr+89PoPwUycG+cFr9V9G5XHmUeUFWQjvahHjpfNRBolKAD1V7gYeDUpomdkRKavQTORg7hfqMUs6mdVdm1sXDhgjdQPSdS/eEXahEYZV+fAqQSV8+xAlqkor7txceYv8HwbS3W7gdBH6v0bE0hpdvzGPmujQoOf93vZZdQP6/NWIxLgwDhFhIfKyLvPSM9O+rLRfGWFILpbar4JtSWh903Mi3VpQKrjlT4FF8RPZp9sJMgI2UDNVbRrqaYc2fY9KLIRBxfQJA4BYmXlGHxDyfUjQJWoEP1TZkNd9vBd86qQ0R8r0z7k0t8/LyixfevXZBRStau7BYOUNoijKAC8ownLpSZGSkoyv7aGmoJ0ZA8YmQaRyZnt6jqAuvhBuy/K4JAXB8XPDSPrqhgWj/LIOqs8MiR0IFvKOXJofgUGWw9H+lLZcB3QydIW0NxX6lct8iz/RQzYqjsifEceKl7zWB+kXDAUjhOizFA8fgDGuzAt0jDTaThjsTIiml4pVF3UHbLOpWx8FD/1SvRZ0Lbiw1blLjRiEV/cHDlg/AhOyAU8IK8i8RwTryAsvwxiMZPzLTbIatOVBDAfPb2SWLY2kNulL/FRIf1esmV/mIVhs9t81GXMw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c59a09a5-93a9-4a9d-9166-08d849f447ff
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:14:40.3513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAxKWKl51HsLWzjXpZLey4/65T3yiWGM8ACpgO4lAWUWZag4N60dR1feuncXARvv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2461
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
index a04c9909386a..9595c1a1a039 100644
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

