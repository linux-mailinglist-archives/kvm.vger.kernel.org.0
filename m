Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EC71C62F8
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbgEEVWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:22:33 -0400
Received: from mail-eopbgr680083.outbound.protection.outlook.com ([40.107.68.83]:13287
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729012AbgEEVWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:22:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVJjNCRCRdWZZYpJ1nhQ2HEwyEtvfNu5KUHjcIH9K1RiC2GuZwoq0EHrG+da3EkBNnsKi73SRoy9lB/cNxnSTEFTGyEGB6AKaA8mYrywGeaamgB79FlEgQsW0/fmJINUH8QOOkYHHuFfV1BCB0LMqdnPZBiZGkfFUfZKAF+h6AUYJgcKElG/t/4FZ7EHXAVC0kcGZTUkwtitM9tslo2sOTDIDGV20uRVbHriVyGr7sVqfmOzrQX6HrZ8lVFTLty80xEFcpN+8mWmWsjw40uQaTlX09CEDTxtKHLvE2V4aaZvHFJC6swoHip4jCxbc6QOkqajNzvaWfp307sjUBnt2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9098FbS/ih6PujoFe74gEOURfZhPMlbdmUwU1cvULw=;
 b=D0+HeN0qwr6mtOerRcVYONay3p4yjXmbnYfiyi05YZsE2GVuYt6VCLQVhKE4uq6BL3EFcies+vUmUfCNFQQMT9vlf7FT79ZyNaiL/fzqf8QBC5uW6bN3PgeLeOdsH3PUX8hFZIS7NkxBWV2dPSAovWvfdQatKkEYJOY2bvUTLaROL1FJSIUuurD0cjfXfj4sSXs6202qjclO/XpPfGprk4WkD7vmUUXr4qaoT2d4Q4SQnUZuKuxM77QFeCCVjAlw4wTJXh0C6prFj0kB4xGmMlSjddEIUKl0vRAMamgDqcLEuZERr0ffUyKc5bde/cPzWDtLK492l++AsJDPCrzUrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9098FbS/ih6PujoFe74gEOURfZhPMlbdmUwU1cvULw=;
 b=BF7l7040aFllP0Zoj759Rvr4oTg+HQzdBTYfKiW1jUWl0Zuv3qzOEzPaByLSXg5zNt36BGSh/JerzSGkbxYvQnNa7+Wap72Q5zE98k1g4GGq5gKazypO4wFA5mltSvL+yIqanxdrqt8vyIRXbGjTptm3R6HSJJUhyFKop3Rg+QM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:22:30 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:22:30 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 18/18] KVM: SVM: Enable SEV live migration feature implicitly on Incoming VM(s).
Date:   Tue,  5 May 2020 21:22:21 +0000
Message-Id: <a70e7ea40c47116339f968b7d2d2bf120f452c1e.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:4:15::11) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:4:15::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 21:22:29 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 84ccae53-9f40-4866-8709-08d7f13a6aec
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518300D9BB507C9B27338828EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MlmxByyXe++BTu6JcdeTXf7/yF8V4aioABz8YqmuEDDew2x30RtX5nPcTXudbo/VFP6ZhnKR+afGdezE2lCcbWa+OsFy6NuP3UGKxyhxyqDqzQa8inTRAz7Ghgm282UvqHkwKsW0anO6fuMSl/HK/q6rXi2JknZ+JzszERiMVU8qauVGg7YBaAkYQug/86WKosuxUohTYy11vk0UYtOEQ5+5THMVKsSrEI547p+2mh0PLP+NbNbigzWRbVcqBHN3e9NRql/MFykVQcAP/+XuBPgc9NTm0Ic5WCEJMxOqVwfKfvrSQ5o2bCXMwapwLDt8TMoekDYrDpXGIXIxYZIYlsIBqOIXeZsu5b2x7WVYtxHRrkK+q0XX05Eqqocrzf18Q4rW5FK9qvzDg9j9dhz/kqotcNfzAb84GQLcb3ct/zxpsaTJxJofdunMnax1y1ZZzyj37wv2cbHCSP0adiAZJ1aQrD+FoZCN2wFTKHdnjlnu5rq1WJT80+1zydy+xlSxBByBLVZp+83nyHSdrGSMUZI8LiHOyFwB1WLhCGT9V6PKy/10t0HGn7b2KjpKJJsj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(33430700001)(86362001)(8676002)(66556008)(7696005)(66476007)(52116002)(8936002)(7416002)(4326008)(33440700001)(316002)(66946007)(16526019)(478600001)(6486002)(6916009)(26005)(36756003)(956004)(4744005)(5660300002)(2906002)(6666004)(186003)(2616005)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: coU6DRLgi07RTD0efX+TmUokISpYK6dXVvSI24mnlDlztiEdjpIOzk4C1+rN6s5/0ZXp3bDJYMHkAkQ32PvGkqUp/ONDy+kLwN+Eg2gYXuRoc9WNpuvaDcM4mQaED6wDumH6H0T+EOW0U1ufTunuALPVrMyEvE5ZPSYig4symnOyDrRRbh4fsUJ4WurNbZX1vG4GxV8uAY1j7m223DaVkKD0YP1Wxkd2mZbYCE+n4l1nNbtWxQKMlTEws1m5hMTAhykYjuV+7K5qxoBOtaLjOer39DmDfoVaisLcnN1PCCNJAIaQVnohBOKWEgS1Xo+K3wZSpFc69pJPgpQyyNRSXv1jojl5NoRMjkps4NoFTI+MPe+Entrb65PkVZ59xCzriC5WGVgD48Bgw6grf4KRMeFWFziMmrX86ythQ3PYxuj2BjGW20C+SY+l8Wa/0//HkaxMDlp65IhNkblhXUmXe1PaaACPCvqJwe7cXRIeimpIUe88J18IJ6Q/MRUwhcQ5DFXTNNFvHsGbP17OfsdszjmDVoM3VApXwgCjHWlysOQVqT8GxHqsFrFzArNLEQZTBXoMVFqlk6/PjTYYScfVSNgKkeusmu/YnZRv/VfwpdvyiNDEePS85dC8vuRVQ0CD1ra04o0IsBweZJ9aqaRRBloBfKtueKc1IRyQLtTBoOo+Lxkw+DypqaOFCOj+WgOJyZim0auF+YmEZ+KdB5Iu8qbup6IUSbbHxekpNw4CMj0JKLsbcnPO7ric2w1GOEX0Yyo5au2nMwwwJvFI3VwoFQZN1yykbCiTrto+su0py1c=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ccae53-9f40-4866-8709-08d7f13a6aec
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:22:30.2716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l62jqcMv1DGJEmF36LtbVBv02nkvRcqICJhYZY+ZEYFgTMgUI9Q+VtVL3MV249aGFT24Xck1VOJyOoe9ElCptg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

For source VM, live migration feature is enabled explicitly
when the guest is booting, for the incoming VM(s) it is implied.
This is required for handling A->B->C->... VM migrations case.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6f69c3a47583..ba7c0ebfa1f3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1592,6 +1592,13 @@ int svm_set_page_enc_bitmap(struct kvm *kvm,
 	if (ret)
 		goto unlock;
 
+	/*
+	 * For source VM, live migration feature is enabled
+	 * explicitly when the guest is booting, for the
+	 * incoming VM(s) it is implied.
+	 */
+	sev_update_migration_flags(kvm, KVM_SEV_LIVE_MIGRATION_ENABLED);
+
 	bitmap_copy(sev->page_enc_bmap + BIT_WORD(gfn_start), bitmap,
 		    (gfn_end - gfn_start));
 
-- 
2.17.1

