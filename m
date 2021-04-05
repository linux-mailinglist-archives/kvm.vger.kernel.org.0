Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD5C3542BC
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbhDEOYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:24:05 -0400
Received: from mail-co1nam11on2051.outbound.protection.outlook.com ([40.107.220.51]:39265
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235959AbhDEOYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:24:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKc4Kyh6y0s060WROLw0tMJ5p1HpoRg0I0BRpUH2U0uh3esh9JvzdGKoTkcfgC2krrgK5lA/CU0do6/LEWJDK+0C+xZoR8cUaut5znsggel1bDrmN6FmHyFqLYcs94YFQN35UEMsYET0Rdwy1yTw/K8QaiYz2RG/jO0NXB9pp76XPzNrY5cX1HlG10Do0yWjD8Lwqs3Js/8U0M9xicfLScAOE0MIsea2abwXd/A43etR+rX2S7MR/65H6Y9ATDMbdYiT1yGWGvx0wIiFCZcJH7j+Z+hzj2YW5LpIYObROZRNP1AWKC+ql4dN/7gLv1Hp4ySqHDn3qk5GVAmIp3oVcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYVNY8BsTybE58fvtY+jcGFOHWn1tynkMK/KKN9NcjU=;
 b=h3ePSEUJ/eSgS4/lF+eon4d7iFNinZB3jPyMpnSm/hz/hAuZcUpiTplQ0JddJNeJtVdmFzYtx7Qs+8FfOoJ6N5k2ZdszFkYnS0y/GeTk48yKiEdqGCjNlOU8OZVrr9A3bCoet7li+zMknSaNvF1/TflLW5C0i3f3RmLCvDGTaeodD0FI89xkwTKUimT8GokqZ80FO1gGmbOLRFFdmRsLsIiFm+p3pewH3LoX4ub9AK+j7SRiTUl6BSZvkKWsplqh1GfpEIvIGeHFbcCARlOXg8DGL0t7F69+rdENyN6B+CqbvWcVRo6+xMBgTfL0ePurhQT0R9sKB4sVWQcJ/jCd8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYVNY8BsTybE58fvtY+jcGFOHWn1tynkMK/KKN9NcjU=;
 b=211wAsb3mKGUBl9eeGLfPNvFEGDZiWJtO7XvRdtL5c8zNYyQjCk7sOHO2/ajwUpAUXLTLC95G3Ip8MCZBfTc1OyfFeffLCnHkRmfHnwHS+Uc5AYDZlpMdJpWPMQ1iEafIvzfi1RqXbz3v+0y8rpE3ahpCn1m2JuH4tuOpkFk+JI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 14:23:55 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:23:55 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 03/13] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Mon,  5 Apr 2021 14:23:46 +0000
Message-Id: <5082bd6a8539d24bc55a1dd63a1b341245bb168f.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0059.namprd11.prod.outlook.com
 (2603:10b6:806:d0::34) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0059.namprd11.prod.outlook.com (2603:10b6:806:d0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Mon, 5 Apr 2021 14:23:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 550547da-4c50-487b-9fef-08d8f83e71bb
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27672123622F45D1425C0B328E779@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EetquNzebLFx5+WWh4lV8fvoBzd0cLsG3srX9inzhWx3tPiSdUbH1+6Yrxf/IsdOAKXeTD5pJL5IrnkEeH37N/Npz84+NP/vJxe2Z7D04rroLDUOVOKZiCsdaKKd9l0XZcX74E2SaPF3Vdn/4yvthaltioanZZBiV+CmZC7cxL1cwaSZ6sUJnpoe8aC3YErYCJzYEUPdOU4lS0jBfrbZf3CjtYLfiu/v4/EBew8Kh0rRe68nZ6ciHUn9v8y5uvnUKCJrW9PP0R6CW8kpV4Z+Od71LxarHRJKYUR1kuUGGx+NxRmRf3Am6fzx/EJfFEOlulLB9ViqdlYgfyhLiVBivQ/h4/f5hKGqdRX+PjZLMKSQz4DOfBRQnhFpBxDymVd3UBzbpo2kzrb/lLmry571l2SDGjLjjevuzz5sRwLCQG6J8avxWu8vhL4CsDzZu1GRLzA5J05CEUKOieb+0qWf2wUqIPs4rl1UCSytaJ7yx4xelY92qMxH66M5sdIjMhRhvZjzjeYtwcUGl9G5IIsb3fshMUgTBk7r5UQhQoWKzUzImCswPynqfJR8t/r4372Z77sSm+DhNMbFhNc3C9/7el+82HvzkjLp1BwUy1TsFGfgePqyus4rlEbXAhX8q1VvFhgSW9veq8xsDJ4ATIWlug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(66556008)(8936002)(66476007)(478600001)(36756003)(83380400001)(7696005)(66946007)(52116002)(5660300002)(186003)(2616005)(16526019)(26005)(86362001)(2906002)(38100700001)(6666004)(6916009)(7416002)(316002)(4326008)(956004)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TzI3ejdQd25MR1NoUVVQajVmRmg2cXdoUXlkaGZVVWhXeHFSeHdKTldXeFhI?=
 =?utf-8?B?Kys2QVhtRGlldkRLRjV3NTJTTWxxYVhOUnplQnBvamhmbmhKNno2Qk45ZGZ4?=
 =?utf-8?B?UVZFNldhWkVPa2NmRUUya09LMnlwOUJ3MzFsdGhZSGJKUlpSc1Nwb21MTGE1?=
 =?utf-8?B?eEVvSzdQWjhXQzRSRlk3S2s3V05NRTFlblZGY09tZVlIRVhaaXcwakVKcTI4?=
 =?utf-8?B?bjFpaWZnb3MyNW5ncHVSa3JSUXhBWi95NDVnM0czemxsSy84eDM0S2N1VUti?=
 =?utf-8?B?amgyNDZGbVpzYmNmLzl1c3VNMmZVZ2FXRTR5OVl1U2w5VW9sN1Npc21JdUhV?=
 =?utf-8?B?RDBkU1VkYzliQTZRVHQ2Q2FrbjJOay9nL2tCUU9mU2tOeU03ZlA4aHdvamdR?=
 =?utf-8?B?RllLN044eU9zYW92MHZTMWJVQWxqL3dBSzU5QmkrUWZYRDU4S0dKMEsydjdo?=
 =?utf-8?B?ZmpZbWRpeldEaUdxZGU4ZjNibTRXM0JFOHFDTjhMR0RKaC9HNWZic1hPYVAz?=
 =?utf-8?B?bGt4cDJmaGZkNFB4M1pKT0lMMmpSendqRUtIWEpkK3M3WG5Bb1JyUUlySUMr?=
 =?utf-8?B?U0huSnUyVVFLcnY0YnNKM29obzVaNzBta1FPcXFKOFdIK21zbi9RK0tZdzBN?=
 =?utf-8?B?eVJoSEt6dVgwdk5IUXdpN3loSzFaL0FKdDRURUp6amM4ckNxVjlodk55YTNO?=
 =?utf-8?B?eXhtN1lVbHJLVm16U25WNjUvcG9KWWhrL2tTZUZIc2s1RmVhbkJJajRQRzVE?=
 =?utf-8?B?dnZKMzN2TG8xOHJOcHdLVzdkb2VFRGVkaGtWV0d3MXdoMnFCNlV3Z3JJRUxk?=
 =?utf-8?B?dlJld2FTbW1IcGFBbXRUTGtyMTVIQXVKWElLNVArOWdhL2JOaUVUa3MvUG0z?=
 =?utf-8?B?blRjNUtnbExtM3ZxVXRWQzR3empRQVlWWGF3OFdaZHRSV3lDRzVnUGpoTS9q?=
 =?utf-8?B?bmtFQnpBeG44YktHaGI2S0FnYjJIQWN0d2QxVklSWE53OVVhUzBNSVdiVjM1?=
 =?utf-8?B?Zmh6TDR1N2ZRT0FQMDNMY1BiU0h1Zy8yQVVyNHJyS0ZIYno1QzZSdW9JRVVa?=
 =?utf-8?B?Zk42ZzR2ZFUyb0QwcndGOGhYZU50eUI1bU9VK0lQdUt4U0dEZDdaeVJMb3Zp?=
 =?utf-8?B?M2ZQUWlDdlhrU1VSSEtyZGNWdk1jWjRGSFRlREdQb3BLcDJ6R3hTYkhVN2lq?=
 =?utf-8?B?eThWNS9IWTl0Q2dCNEZaMERzTkJDcndMdGpRMWdDZ2pWYXZJSUlqNnRlZ3Rl?=
 =?utf-8?B?ejBqMnRrejhUZjEyQVRrdTFoZS84UTMwQUV2WDNRcEVxdHRvTzVCZDR4OGxP?=
 =?utf-8?B?QW1lR0hRR01RRUcxb1FFWUFpR09seUtMcFNleVQ1V2FyNnZDakxvbVFTRUdl?=
 =?utf-8?B?SklETWNpQnFKYnpLZHZaaE11Ym45NW1EYzhWVVFHdDBRUUtXUzRKcTQ4MWZV?=
 =?utf-8?B?Z1paUFZxMkdpNEFxOW5zYlRtNFlJWlFLNHhGZ0xwRnhxcWo1N2NOL2VueUtp?=
 =?utf-8?B?NStoUkFYbnZLaHVlY1QzZy82TGRmTXo1NlBnV1YzdGRud1RORCtxQ0ZmYU54?=
 =?utf-8?B?Z25tbENCdTRPdUJCVitEMnZwOUVUeTA3aHp6clRmdHpwSTlrdkZ3UnpKMHRw?=
 =?utf-8?B?d1FDK3JVcDZIL0Y4WmVZTEkyNnhXbFpvMldZbWtrZDJuTmdaRXNVTEVhQzRj?=
 =?utf-8?B?S3ZtTDZ5MzJ6cVJ6SGRXYi9GZlhXL1UwWXBlMW9xTkhWVHFhdHFGWURUY2lH?=
 =?utf-8?Q?CNG3pF0OTEIMfh9DUomRoURFBJywsoGbeId6CZR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550547da-4c50-487b-9fef-08d8f83e71bb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:23:55.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ifooUy1JouaSZ3LvtRR+9G7xzIIZW/bk3a+ql2AFM5v67WFM0D30DBBpA/RXfY520F7Cm8Kggg2PM+TKl2o9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used to finailize the encryption context created with
KVM_SEV_SEND_START command.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
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
 arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 3c5456e0268a..26c4e6c83f62 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -335,6 +335,14 @@ Returns: 0 on success, -negative on error
                 __u32 trans_len;
         };
 
+12. KVM_SEV_SEND_FINISH
+------------------------
+
+After completion of the migration flow, the KVM_SEV_SEND_FINISH command can be
+issued by the hypervisor to delete the encryption context.
+
+Returns: 0 on success, -negative on error
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 30527285a39a..92325d9527ce 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1350,6 +1350,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_finish *data;
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
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_FINISH, data, &argp->error);
+
+	kfree(data);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1409,6 +1429,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_UPDATE_DATA:
 		r = sev_send_update_data(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_FINISH:
+		r = sev_send_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.17.1

