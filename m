Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86FB231652
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbgG1Xik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:38:40 -0400
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:59451
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730709AbgG1Xih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpLwC0MfF+xlScwYH81CLEFzZFhXxNqN9vOs7vBJB64IJLcu/wM63KHfnA7+o6rFfeV8dbh+pxvfrTAo7krDx58GFOcPbOtLfiaGulfBpOSHrhdLry8GPN9H4fEipG+aRhyvc+BOPah18JY080JqNlW77QqF/uU5OjxvaDdvzIvHljyVoX0vGwZEIYWRRWedAvBAd7QLriB0rxCBwEI3WjQwvZqAq0CfONb2qxAV+sdYi/sFbpGRS+MOjoOD6FRPCNsm18tkeVBbuc3bYiwtBk0rM/1b6+Jemz78gBH5T0IL7mCCmbN81p+x+WiEua6eA/0ez+O8aowxIC/Y5eRJFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BvV79pvIS1f2H1Xsgc/wq8B44K32oTJeUHSbFpxgbY=;
 b=oWyGXgC/QWqDu+GEwXIChWh5yKtK5Q1HEVLqkGtqjnpJ+gkD3w3huyAzKc49wniUZDxak/ELvYg6cu7pvYbmHaI1EIQLTTT6C0OL9LsQEZB7d/so6qKiWGZBy7QJtnxBTG6UU53MDYxvr7yVxZiXGQ+hAg81dcIJWkYxpj4Sp/7SuJlbmUAmbu6eBMdrVC7FwpudloQhBvZd+pa8090ltSe0l+/qghMSMAPXldpKDl2+T8sul1DV3V1E6FGjQ153GCePyUzU0GrFTlkCIXw6P1mrKLUVv7/qqoe/hNonw/FV9TzjC+ugUP3VAecm4rd9boWheGFkY73MpTfSqUcYtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BvV79pvIS1f2H1Xsgc/wq8B44K32oTJeUHSbFpxgbY=;
 b=4Argf0n6n1+9cdEyUc1QQDd/FDNz3BhdtDmuZ7V0SmcElAePQzF7cABG9Omm4bznZW4pATf5xBs2tGxTeTuUOWkpV1jWBGhDb5yy7/m5yk+0yznpm3QSz35X9/Be4Evr5CMA8gIoOhvFaFJiNW7CNwys1Od1QSJi+aaSFnRKnVQ=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:38:35 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:35 +0000
Subject: [PATCH v3 07/11] KVM: nSVM: Cleanup nested_state data structure
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:33 -0500
Message-ID: <159597951369.12744.9730595628680359060.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0037.namprd02.prod.outlook.com
 (2603:10b6:803:2e::23) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0201CA0037.namprd02.prod.outlook.com (2603:10b6:803:2e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Tue, 28 Jul 2020 23:38:34 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2a542b10-7798-4d73-d2aa-08d8334f5822
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2559F8A687D2BF37FC0A4CA795730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmj9RKhGAbLo/T2lSwMVqfNq+NeFx8sFCGrR/LJTEJsGTY0dJasXb/Kvq50DxBYI0orfVHLOVy3R47PPfhvFsiALlBH5K/piowu9q06j+KVGr7Exf8qnlhosZGHtP3nJklGE6vbG6om+2y6UCH4WYOEWcHpAB4jCjNcAeR01q0wCKJDAsneTuW3Kj3wWol0ZyTTOQuzC7rMKUCYf/3S4NPIGP6YwQDqR73dyFmTqAKdoXHP8p3YYt6faVWyTUIn7aCIc3X94q+Dej8KwU3Ouk5FJPP1eRQY70nwpv+16Pou08AddzzkJI7rEkHp83iP3MfR54wILu7D/ISSrjgmG/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(103116003)(4744005)(83380400001)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8n84bipaWixyaaF8F/FcTYO7Ci7eeDSqTuJ2EPcDc3OU/4tRDGjiQX61YBTi7YmSS7yF9PlIcpz1yeRvW4nUfTiZdlQCJruLPBRGTk3VDUH8tl4TXpFgq39eAb+MCKPnu6aWXyrW0rsKUJ4jtN+WgUlTzKaxzK1J/k9sahwvDdm8NA5DQlh0NgNqUccDbQKjY/mtPc2zIFzgRw+CPSVrKI/NgVCr5XzHARy2NRJOOmmxzEUCajvkm0S5bJKAkamb7/OZB1so78EqQuJloAZw+pHakWkN1fDdxCRzavvfHVQnQhw2d1/5kbHHDpRkFfqXwurdcMg5+DrOblYlLl21X0CUt3yaqDPT5HTPAdLYK6HfFkbqTK5GZ4RvS4Zgm6cL6yv2RA9N6dzu9m6ieXXHRIqHvqOHx4mMWglxQs8EE6S32UgT4BOOToZH031kAbQdXbBvpt2Hy1WW6ZjMGFCaXyd1imt1Em+e63RzD0MmkV8H11M/Ke6gO8SLi8F366j3xgkavFv6bShT55uW+fzitQshNaQcHGlxeMjqV/nc0gNce8q6KS55OUxZ5tpclOL4qivFcIZmJfOPexNf1YPNNZzSLaQ2IoUtNq67R1zWwjXZ1Dzxs2A+bxgEYo4BYRy65IsreWxNr/TcN7g9WV4oTA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a542b10-7798-4d73-d2aa-08d8334f5822
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:34.9483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v203ciSSugz8QMErl19skZrFP+cOk1MP9Gjc17B73TU0GbJEA3ziLDhgthTht0P6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

host_intercept_exceptions is not used anywhere. Clean it up.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/nested.c |    2 --
 arch/x86/kvm/svm/svm.h    |    1 -
 2 files changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b0e47f474bb6..1318cf1cd0fe 100644
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
index cf0cfd57a972..450d7b196efd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -86,7 +86,6 @@ struct nested_state {
 	u64 hsave_msr;
 	u64 vm_cr_msr;
 	u64 vmcb;
-	u32 host_intercept_exceptions;
 
 	/* These are the merged vectors */
 	u32 *msrpm;

