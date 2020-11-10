Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922552AE380
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 23:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732398AbgKJWmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 17:42:21 -0500
Received: from mail-bn7nam10on2052.outbound.protection.outlook.com ([40.107.92.52]:58465
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732314AbgKJWmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 17:42:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kb3x6IFEqMV/HRwf3A3GWdF1Y8/nhXMdD2VITh8h7zPyilrti5C498lf2zs4fwAefbTRg2DUiHR34rrP6podd7Fv8EfI6VAElf7LhW199gBkDE2LIYtwCzj3HQB87lixqse4Hs/Lp9zebdUvPW6kzLVCeEzKYWXM1tcgHHQBrTLf1ODDD4MD5/5/CrpHB6qCccafE5NW7TJceGgw+OSitV3uCQejO4UC3OXIJgfrR1v6t67BgrrAw1R4LlDKllC0wMkYNm3pOtHYS4y9WU3zEHHlvPqJtXOD286dQ9q37F9Lbs/jIeKReOMIeRxWGQCly+qesV7M/DbjUN3SQPDxpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ld1/j0FTxqs5JZoQ9D9m+PbpnGiTPmd+wXwhgKpzV4U=;
 b=Mutbevr51szV+QrCQvnMw4jyR8yqKn+gacSShrUp+0f7TjDdEmLr3KPAqdK13arxylWeqBqJ3b5u3aHCNfTim6TXBnllRCUIG6GpdkqdBEh4j+SpCKKp2iaFiQSAIHVuEHc4C5mEWKkmo36ws1gbG3QT/mzb3fR0lSb48ZSlyioOF3j3T2tlGyHNXFCnd2lYsA9nsfHpXGCeKPB4QdkIWnFC+l3FRqxanAsneUJpYTOq2geGjc6ijWS58m+nurmglgoVM4tSogwMaEo6JB3l6QM4VQoOShyNW+bQbdv8vs6bjXSUjfANItsEQZEZ9l3GoOpO9+lP9/bCP/plRV5Ncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ld1/j0FTxqs5JZoQ9D9m+PbpnGiTPmd+wXwhgKpzV4U=;
 b=y2ykcCirgBPox+MjgmaZqL9ry494aI05V/s5/CPPnZVoFk1Twu8vn7zM6EnWqgbtzOnPYNd42voBpJmyv4Zc+9XM1RVpEunW/5jQQJAzaFLBC7EEtBRnQLxU8ZjcFKt1viB9Y1G0SgFh7qrg4olQTu/uArYX8bSfbNs3H1/qUig=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4590.namprd12.prod.outlook.com (2603:10b6:806:93::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 22:42:17 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 22:42:17 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        Brijesh.Singh@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ssg.sos.patches@amd.com
Subject: [PATCH] KVM: SVM: Fix offset computation bug in __sev_dbg_decrypt().
Date:   Tue, 10 Nov 2020 22:42:05 +0000
Message-Id: <20201110224205.29444-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM3PR14CA0131.namprd14.prod.outlook.com
 (2603:10b6:0:53::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM3PR14CA0131.namprd14.prod.outlook.com (2603:10b6:0:53::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 22:42:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5cc2c8e8-e647-4f8a-8da5-08d885c9e012
X-MS-TrafficTypeDiagnostic: SA0PR12MB4590:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4590F0504B1BFC3BC5FC9F278EE90@SA0PR12MB4590.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gd8B2gGWYHcoJOH5M3DCHCggF/W3rWx9p+zxg2Q9tS6wLJtGE5AqtLaFhzdIurukNbHTkqcIaFseFRRBDeDUTjY8fmCMcaXvIEZovp0y79r2YKlvF5NX3hMiVqcak6QsEqxIgZsu6T5Skk39cDMD8XRoDIgVSS8p3jBbh6w1NEL1DoY1jirFSrWGn1Wq8VuYQ4njp1YhtN7WXZ3GNM8yaFQgi5gLHQBQchAN6AmA6KIl4vqEGwmMyZe/MZlO9HhrADnbqTXVG4VJPZjdZqQU+Y0cfv8PCAXSTwbUvk6asxXB6KZmvjrv0v/0Tmo/Dlkmua3n+ZF91n5CCLFIRyfCjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39850400004)(376002)(136003)(396003)(83380400001)(8936002)(2906002)(478600001)(26005)(186003)(16526019)(4326008)(316002)(956004)(2616005)(8676002)(52116002)(7696005)(6916009)(66556008)(66476007)(66946007)(6486002)(5660300002)(36756003)(86362001)(6666004)(1076003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zLPd967Hckv4v8+E4upnL572adzifry9RLyPlM3unIC7E9OuTxaWqLBIR/YbqFLTkVlp2UVMjYNL7j0hP3532hBjo6hoOGYE/lclhzshBlblK0n1oPeeX0x7dhNf1YGtAx5X3K3joFG/atoaEssLRLtB5naZ3nYzGK1UWA+8Jp8Qcb2DtyjvRslH4btR6QsVwIcg4Xa3psFH2UVOEa9yiZBa+E9CNL/qWs0OC/T0tpBjprfo4WF/nNl0AbeJFMIW35iYLCMzBQivKe+pbwloVuzXWG4PKJ7Vj7usLPO5KSCW00OPRMx+xJkB24r+ec7AVuy8axCHbUpNyIBo577wa7rOJvre32KWWm1IMSjsYxMveDZBTmJgzcGGcop5Y2ACK+ttfhgdoonWmnNCZKX8z9CTVE2P3r/svzkQggeS9AlVw0Ti4DVds9zwnq5sdCn4EnWkqdmuxDOTk/s6Mi6pI+Lx0iDUQovIo7NoI4rZU8S+1n+doPQU6tvJi6JlvBM5Shg6HfJ0TJ38If7VMGLpkGxvnAt/FG43AJc9gwPaJEe3waJywNsn0vcYXZcecz1/aByUI+ApRV1JIVzb/09yH61yTfjjWSRJkghYCcXrJdTrf9G4PJEeIN1n2duh2gCnF30tgao4OsK5ZeBhQzbXGSGLZroSGwrcFfSCe3F8rH4bTPRejjB6uKpDL36SU0UU70nIUQoiPmR1BKdKxxs7veOf9yNbLRaIa54aNVfTBHpFthITR0wCxXvOVF2WjQLRWfrGLp4foOQ4Pg3S1SK1mIz7ifw9Hpw1+hYHyXl60NnXSx2umfryIHhqhlDnoccTG47TKpsfs7khNMpaWtRXZCv6O77bkJ15aJvk5+M9Nv8YaoXRdTKR8bvGlF+nmKcXnN6Fk2/dlLdqycQcDw0Zpg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc2c8e8-e647-4f8a-8da5-08d885c9e012
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 22:42:16.8857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCg1ONHlCSgiBNqFt5geaEFqPPea8uciczYoFln9I8N1bmKDe0rDxez/eVGEh2HXfbee/qftFF4fMNjp7YFcDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4590
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Fix offset computation in __sev_dbg_decrypt() to include the
source paddr before it is rounded down to be aligned to 16 bytes
as required by SEV API. This fixes incorrect guest memory dumps
observed when using qemu monitor.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c0b14106258a..566f4d18185b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -642,8 +642,8 @@ static int __sev_dbg_decrypt(struct kvm *kvm, unsigned long src_paddr,
 	 * Its safe to read more than we are asked, caller should ensure that
 	 * destination has enough space.
 	 */
-	src_paddr = round_down(src_paddr, 16);
 	offset = src_paddr & 15;
+	src_paddr = round_down(src_paddr, 16);
 	sz = round_up(sz + offset, 16);
 
 	return __sev_issue_dbg_cmd(kvm, src_paddr, dst_paddr, sz, err, false);
-- 
2.17.1

