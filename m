Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA25F19720E
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 03:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgC3Bfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 21:35:51 -0400
Received: from mail-eopbgr750052.outbound.protection.outlook.com ([40.107.75.52]:4518
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728324AbgC3Bfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 21:35:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrVHEurZTAgqsJDhkxUtM694+t/xQ81IdZwG/nChSi4c3l47/1ASbOqxv4OHR20AUoKGoMlcnk3HiVW6B835Lmt0RM+91E2avdIuwT/xxgrcj1ysgMKCLBuBRW8flEnZ052Ze4wnqMzUDV10Kazg8a7edB4HkIllxOvwlBhoHCDLIPf6uE+CqVWL9NkrcV619TRkHlEtuH5QXghtpXQrC0w1dWVK6kHw6lJ56nfuidpCm8lI+IZCydt04u/H5BfwKgtq1/Hr28Q0JvO/5ESpP6P65YdC1CA1fWVCqwfR0bV228fYQGPj/3XtwIN1l9tRmGnCpVDAxFjHGPQ9ydcWMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+0q6Nyh9f1u3yEndkck8hsJTicRQCuicnRxNyF547g=;
 b=CpBt81T1ubtbIrG/VUBvi+mORmP11qTFidWDgVh0oqECt5fGRG72riYLsGNj6HIij1cbJ6BdZAM6P/Q8cRJM6X6u+VBqJGTtLZEedizFpjDFFDfsK83Ecrpbto8GNOBH+O4/nB1A9VyW+8SOxczJY9pcTfCjv/jVJUyPgjlhD74H46FsDTIp/a0VphkAVgn+0KP9sScR/j7+puLeX7+tQsx9TxKSd2WDvHvuqq3PATjXkQ6MCLQH8qQy72kLVhx5A7R53WQvLcic5g1x5nmYqGi2f0EXqFrIkeqEh07JzgBRvMWFREf8cvUpHayPqycYj3r3d019JWeiVo7Nhl+8AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+0q6Nyh9f1u3yEndkck8hsJTicRQCuicnRxNyF547g=;
 b=XsWgcwxE0Fe9lYXaxZVvgoDj9smym1RZGNCo+ey5FWCWFUVPWUwhDyoDIQ7elXcucous159H1fOAkfhiHDfqhWFmyeaMId6Dl4gVup4NC+JjfjjtPTKlL5UCYAmQpsAD6vYy5TsPXfvV0+VPYNSsSFSjZrWnUh0CRvW07nqQGr0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1387.namprd12.prod.outlook.com (2603:10b6:3:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 01:35:40 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 01:35:40 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v5 06/14] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Mon, 30 Mar 2020 01:35:30 +0000
Message-Id: <0f8a2125c7acb7b38fc51a044a8088e8baa45e3d.1585531159.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585531159.git.ashish.kalra@amd.com>
References: <cover.1585531159.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0068.namprd12.prod.outlook.com
 (2603:10b6:802:20::39) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN1PR12CA0068.namprd12.prod.outlook.com (2603:10b6:802:20::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Mon, 30 Mar 2020 01:35:39 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e790265-3ce5-435a-2585-08d7d44aa7e2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1387:|DM5PR12MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1387260C88B938BE8CE38D118ECB0@DM5PR12MB1387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(186003)(66574012)(66556008)(6666004)(66476007)(86362001)(6916009)(66946007)(316002)(4326008)(7696005)(52116002)(5660300002)(6486002)(16526019)(26005)(36756003)(478600001)(7416002)(81166006)(81156014)(8936002)(2616005)(8676002)(2906002)(956004)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OUTb1YglYWLvc+faLujq2E+g4l5fONu8aW/6jW5ev0PXnShJ62jsfxbrIa+bv+2Tqjxrn2Tf0SeHQwU5b5Exzk0AkzkT+KeXcMEEG06bezQgp3/wq+kGbnByb0mi5C1TVXdcz6NmwgffRnlLca5iuWJOworUGsKYD8ZqjZR8KA6nccMtsBxWIDoytJ4M3OWsnfK+6Eu4I97IsbnCI6UPVcCiexkitRIJGy+a5TR4vlB1sRtcJGf6g7DFiNESIWaMNbjWEsZH14TnpbhLH3K1cjixNRq54dtTbjxn3TlCSYzVfGmXwi6x5k98paYV0rjkbrcTROTVlHVK6WSAhmVDaY++y5/xhnwlutmJe3B3rGlVL7hoQou2BbUXlE/eWRodaVOfzBSC1O4ivY6DhkkiQREomtVOILipTc1+mFKZi9po3BF04Ic19VyU73CSO3/2kxiBRObxkRjRFWqmDZU5Sw2Rox4rZ+xbVDn6SsWrkjNHZA6cAMX+vm9AWN/SGG7q
X-MS-Exchange-AntiSpam-MessageData: H58qb3eQtglsEdv6QuxK/7X4UDBlQ+fH8XhSOM4A0F8n9hqnuWdOHUaBKlSSz0PwdA2N9qhtqLnycgTO9RjJKp26GxwFEuaQcSIYrc2VMVgSp0Epezlz8HUoNsFeNm+XF18jsqvQ7g6SXPFIzb0SsQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e790265-3ce5-435a-2585-08d7d44aa7e2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 01:35:40.7168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WuqOAsNbGkM21Dgj3KyWtIOrkU5MljIA+W8dAdN0ZgQRIWp4yvbNk+nN/h0PLyL5qXvVrIjEPo6IG5Yvm56axg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
 arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 554aa33a99cc..93cd95d9a6c0 100644
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
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5fc5355536d7..7c2721e18b06 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7573,6 +7573,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -7632,6 +7652,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

