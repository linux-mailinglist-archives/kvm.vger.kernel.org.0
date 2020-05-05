Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665591C62CF
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgEEVQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:16:43 -0400
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:6110
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728642AbgEEVQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:16:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gscxq+tK8PSPykGMVY9fIU1JSFb2HGIZ1MEexLUwMMks1hfXYtH/tWjw14hWLyB4gagVU7rOCupk+9dXZfvDxXIKkAOf0bS1wjWplD3xSyxCkhMmGmbDJhbqj8ZIqutNxu3aAHmL7vleohECBRqtZZBAarwpG8MVqSXs2PpqQQkWmS+5bEpMRuGAS+3AoDjY2PaV5rnOm4GlesLy+ahRZK4sJ8IygdnjX/u0EnrS+EqHjxg0W3Cy+WxQxJ+EzD2UZgLBCjTCp0tQszzJHouPoitbSMtYMtH5WdjWeT/XHEHRci7KlF2X8F6pCNpLnfrNFRYlbEUhRbUbgFW/s9rIlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shPMzEfRG/xoJ/stMxk05l3wKT5pzEhKGN8GTUgE4P0=;
 b=gPXJdHm+8OYcEWuvj6eMKjlBX99uv4AQsOr2djUn2ud6PLjiCyFtfQfJjAUITlQ9bsQp5t6E1F2K4MFyBikUpXM5sip5pZyY1vyuVMwvoEY82Ed7hrHnn2bfRQTUnVAGcSOYNJCrgJ0usESRYDTnlrSmp0TzjB4NWdYwroVpeeNjG6ULh0pfW44McaOE/M30nWG+pAwtVo8+8mj3kyJkMVvYgmRGn+sx68sDgXUy+/PDFc9iEAr8Y9rN8XWNL5mRvm2MTTZwYm+/e/2pqikKmH6Dwrp3HdV3dbMkqC9dr1K6Q19GM+frcw/grO561LWyWrlisWjkZ0vQRMQXO9dYcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shPMzEfRG/xoJ/stMxk05l3wKT5pzEhKGN8GTUgE4P0=;
 b=BLcSK0hg1FxwtlHf2tD9zUjUrRUOwQ52/ts/DgRcmebJu72goxRkYMTyEqQRYiC9zzQjucSb55BQ430y6xjIAsDZQZLE+WVKI/gli8zMdi9Q9AMM62ns4HB01v07HHqlCwZXsBCh6mk4JCxQ4x6x7lS7aCqETWn1YBS9K6uvK1w=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:16:39 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:16:39 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 06/18] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Tue,  5 May 2020 21:16:29 +0000
Message-Id: <9df744ad5d7f8056362b04f34198d7fdaeb8db72.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR1401CA0006.namprd14.prod.outlook.com
 (2603:10b6:4:4a::16) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR1401CA0006.namprd14.prod.outlook.com (2603:10b6:4:4a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 21:16:38 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5b249a6e-558c-4148-904a-08d7f13999af
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518CB24B31833F910062AC78EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: udDPhcebMabbmAILKfH5wLtWuXaTymZU0tWRJXDnOBSnVFstrhmTB8pJxkeLiFfZ1Ne1o9HAwKiOhALn3kyHFAhqnPH5HEG2YMClpVQQqZSSvbrxajVlzo76CYjtE3UiRKlm0d6IZYng/DGp9eGuvcZiLDAAI0rwgfmuodiwO60+sUDZkR+0Ra7CIPba20t5S6S+f62cXWaZ+EmmIb8lN/i5HV17iYwchOssBFipLUvWHsACj88hJE3GYPBd/v1bgZu2Oj1EYA5hgdZq5fr26NK5R2+IHv+0M38sRTsOA6X+Y4+BulIoPKTCYMadTZcBQb/+9aUCx8GK9gkWr4CrEk0sgCEAjbYjP8xdIcc+cdH9A4pJkmA4FE/YqK4s4n1tHxU2UdQtjauU7o89UOs9P0pHHsADdMAufqkQymtuk/hqPQXHCL/6AIsrwPv5UdVC8CdWOeaTaVBDCt8NWil5XCIZfYG0O0v6y+2PwuxzSatAqcaQvwfJBcBHJBgwaYLzYcgti+F92QVHztu8FLdpBY6XA1xYCCJR6qA7+AOwExp2hkq763bF8jEm5QCv9CAz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(6486002)(498600001)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8TVtXgV0r5crcKzUlhvEBOE9c1YGfwT2EkApZEcT4pMaZqSQY+IchAIFQcbGLyy21rlHXQLwgUrYbXK6Yv4pzs/gneLt1POeet8gohh4YyFVKrvHVkctLMTHW231XO5zRcCEWsCHoIXSGxXISWmTXU/hHD9G6Wnz0fsM5slBnSvpPeFBtGPOncaWT+ikcDnn0Ras55Ic3VW6viUBc52PqpFB/aRnoJccsdC4W2HIxvDXfyhFrXEBRbikwAzuG7zgLumI6lZXM1hC2EII+xXyOtfxdBanvyuK4pxO4OkLmFsGPsnidnu2pVH0EQMxm4a03nHYWa9xifEtBPMws4Lsu5doD6nn7RpXFuNxcorUvvUe9LDQYVOPmp3fiQ+YGFxLhUrXuOPgVqoHSltAl5xfahrV7yjHf+q8w40lvFkfVWv26pNdDjnzVAo0/u/f9qH2Cb/NZ+kYarRD6wfPdW47Ax3gmJMRa7GTkQ9O2Huu5r2iJTjOfy+oELJngPqOvitA5XYwnHaYz3FRxEPc/ZxhmQ/AQRABByKjA9xDFHkpM/iq7QKL4+8XpggFRaAEGzpc4kZ6D6s4LLwfaXBOySlvuVwHm7pLMOvH1hI6X5shB0E0CfHJiSw1QrL3UrW8NxfJzBT5YLU8Z3+RqkXICLLmfgge0NZhNPLLZNqHFhsW3lMeu9/t+axJ7TqauMKe4iLVx8oETllZgI25d1SDKpf1IQIhx7IgO5ameUP37drsp8TiWnQaYBh46OYX+HvM4UZPgDyy5YB2Wcl8as8uwiZ+J36bbNOhcGSZc1jtlL0iGgs=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b249a6e-558c-4148-904a-08d7f13999af
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:16:39.2533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5REqI6Q528azz3tqBUEgURmvPEG/946pFuxVDQc7khJtgC61ucLknojg9tsGKKDNB8tWmebSh4up4R8Zpnzeww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

The command finalize the guest receiving process and make the SEV guest
ready for the execution.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
 arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 04333ec1b001..de5a00d86506 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -375,6 +375,14 @@ Returns: 0 on success, -negative on error
                 __u32 trans_len;
         };
 
+15. KVM_SEV_RECEIVE_FINISH
+------------------------
+
+After completion of the migration flow, the KVM_SEV_RECEIVE_FINISH command can be
+issued by the hypervisor to make the guest ready for execution.
+
+Returns: 0 on success, -negative on error
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 165a612f317a..698704defbcd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1327,6 +1327,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_receive_finish *data;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, data, &argp->error);
+
+	kfree(data);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1386,6 +1406,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_UPDATE_DATA:
 		r = sev_receive_update_data(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_RECEIVE_FINISH:
+		r = sev_receive_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.17.1

