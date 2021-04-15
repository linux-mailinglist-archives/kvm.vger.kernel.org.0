Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E17360F85
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhDOPz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:55:27 -0400
Received: from mail-dm6nam10on2075.outbound.protection.outlook.com ([40.107.93.75]:28384
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232913AbhDOPz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:55:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnLdlQOKjFTGxVhIZfoU2A5jTaD4FFwQRGACnJCQyWUcFCGiWruvp3WHBhgo5HWKHRhtZZrK6PmdfJ/GhYTB/pD6u4yXAaCliFJa4Fnmp6v8V3V8cHUy9Cc3EojlAHYgSajHX8KJgxaKmO+7hhuZUIJBw1PIMlWkOQgJKs4Fd4b/L30652R6lJitYk91T7RxR3Z7NhZpHvF6CKdibdhORCzibzqe3gBL7tDoxHRrDBIo7C7tIwG1HB5Hixk7rXdjC016R5ByAmpymzWxbBYTZq+8/qHO5EWkQM6z5VOFOjsqG6/xFzAWKplaRPpgSOOgjEHyJG0eoBeWS+qxiQBksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UL+lHwQVytiB/W+Txx8qhIcS4kg9BpXMgb/clYt+Co4=;
 b=KvUJ0FLejOqP31PaPWvktplZRf30sdy52OQHfnkjsJKj2bjz2nF95uDbbmKAerj3zV93Tf16M4y0+jmh1CusnXGz1EsG+yAiXARtn3iRflRWJUbejNLBXmF0ioHhzxgOk84wuLGq3bvtAwHJdVRh3oeJxdmQ6CftBIhdoS5EQusIkEvWUQCsoF8A3ry43MWkxk8MfNcDHtLkucpXwzFLtoNfHwqd3aIIw1YgPDTmm9IjPUVBViPB8nN41LWKqGvZwgYtMRmWv/DTPFCkB0j4AKyyJnX/mWytmfcCnN3ungwISj1Uw8tNKA3dQ+hRgVVVj3ClKysUpH4OrOzc4W+NIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UL+lHwQVytiB/W+Txx8qhIcS4kg9BpXMgb/clYt+Co4=;
 b=KlRW151RXOER1v6Tw/JDrs+1MEcSNJemYzLTfFF4Wh8/hRsktQU5ZGCDOQcaVK/frUhuvthQDBPvECePz/tjRh3y10J8Drzg/R4ny5rP1LrkTFHZ3gRWAvzLtS3FxzursEX2l7bFna6cOy9iRlkfPTkZNkHnikaTmI6t5gXd5R8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 15:55:01 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:55:01 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 04/12] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
Date:   Thu, 15 Apr 2021 15:54:50 +0000
Message-Id: <c7400111ed7458eee01007c4d8d57cdf2cbb0fc2.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:21::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0008.namprd13.prod.outlook.com (2603:10b6:806:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Thu, 15 Apr 2021 15:55:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c499711-96cc-4b3a-80a9-08d90026d3c6
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45929455686B0EE7FB4DEF208E4D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yeBGT9I+dG6v6CwetAVF8URw2ionJyHbHwvaql/7mEkh/vnlFgkhEmi5IyoxjwhfxgWXmww1LfjA+HHvyHyVHt0elOyOMr2d2ok9uly0zbRUSCWHhF0cMxBxyZ1y5EoCVf+pATtpTr2CTkPy7rAk4gjfw6U4kPflwpVRLKtu/T2GBDdam86IOqfsCv/mdoJbInRqCL3A1fij/mS+od/hSVwvjlzhB8/4AM/j5avg9vtTGHfZe5FDhda+RohJ0Hus/+j9M/2FXdJR/uedkICbM2XUcnZ+iU4T47ogVsncxlLxT2W48FBddT1Ouhok9ostH4qcMi7e46GU0LQcK9uxFXcJ52mIHkE2jB87+xh22fzHa7TYEr1VLU83bZnULzVlA65toX2ggpxsoKCLqlmWlkrYkswZDP1wDwSbwDKQ9XnPQHc008BHjBnst3h7E4zuNXG4wirNS5upX+z8iw3PPvIAP008q5txs5Hr2EZH79+5Si8yX8nC6+DbZbs9LcR5r8IttgtvlBgSzVoxA+CE8q16BCyKO8E5g7nfFCsdNBwF7VbwDpmCJhKKXbLleIQbn5lNx3x2nhV9tbhQ3D5w6y1PaQcW6H5JHX0Hf9crhpBlfw6paKotDUtu4NHLBh9KC0qsw+nalRi5+hB/546cYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(5660300002)(186003)(26005)(956004)(66556008)(16526019)(4326008)(83380400001)(478600001)(6666004)(2616005)(6916009)(38350700002)(52116002)(86362001)(36756003)(7416002)(7696005)(8936002)(66476007)(8676002)(2906002)(66946007)(316002)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dUZOdDJPL05lRjJxdlJzK2JsK20wZm1seUprcGVkaVlVRG9qUmppWmlmdDRk?=
 =?utf-8?B?clJOaVNoZnIyZEp3Vllhb0Uwa1pqakFiVVVuUnBEZGc4VHg4RGJQc2hXTk85?=
 =?utf-8?B?L1J0OXNnbVI5T1BGeW1OMDU0U08rcDk4WmIwTWtnU1hEYWNMS2liak0xTUFo?=
 =?utf-8?B?Z2liM3ZPcVVBdkJOc0lXdWFzYlk2UHBza1JBUTlmQy9TK3FmOEFSWFBTNGt0?=
 =?utf-8?B?elQwT092SEF6QStzbHFINXJPdnNjK2VJWGNlbmNmSElUcUhFZ0V1R2VjdGNJ?=
 =?utf-8?B?ckpBMjZvMHQvMVVBd2NBcURvWDQwM1ViQ3hLUWN2N2VPN1BNc0RSbitOQ2Jz?=
 =?utf-8?B?Z0NxZDhqKzdoaWdXR3IvT1Z0aVFlOE5LTVhnWVhvTGNqajNuaWh0Ry9sRFR4?=
 =?utf-8?B?T0htVC9QUUhxM2xUOGhsYjdiSnhMdkYzS2xNYnBvZmdkSkRaN0Y4S3l1YURk?=
 =?utf-8?B?a2xrQWZRc3YveDV6bW1DREtReWJ1UHFOQkZaSTZnSFlIU1Z4anc1UW91ZUVp?=
 =?utf-8?B?VlVRcDNOQlJXZkhBNk5kbzROLzNRc202S2FxdXVneEt5UjVuNlRKVDdpSm11?=
 =?utf-8?B?S2trbG9Ja2pldXZEYWQ5eFBXQURwL0ZqR1E3ai9zRXo3NGZWWWh2c1BzUFR6?=
 =?utf-8?B?d216OVJHQ2xJWThLY0FHK3V1T2VndmxGajlrUmNrTFFjdW5Yb1lGeXFWcy9V?=
 =?utf-8?B?SUxrOVFsTG94VGVsUXNRUHg3MXdCZ1hCSWVmVGJkTUo2MDdYZFNsMFVlbnov?=
 =?utf-8?B?WTM0STA0a0o1bzhpOGxTKzRSYlFDTzFYWVdxT3hGbzZmYVNKSGEvbFc2eDhr?=
 =?utf-8?B?UXZ5QmNmWUdEdGpOb1BlbEE3MElDNDIvVXlSdG43MUN6U2FydzJYY2JkdTk3?=
 =?utf-8?B?emJrNEY3THpXSnVsVmhsaEJKcm55bEV4aTFjRElIRTI0NTFNSXBsUEZhQkZj?=
 =?utf-8?B?MjdSMGFldlVHZXZQelVqcGptUmdJOXV5VjlSKzg2WGIzNXI0bDByckZVTzh3?=
 =?utf-8?B?dFdVcDZOcTFpeVEvZjBpZEdEK1dabElWZDhGOVZjTmk1K1Z3a091Qzc0Y2N2?=
 =?utf-8?B?U3JDc3JLUzhXUk8wU1l2T1JnekdXdkdpdnh2bjVsbVMxQzhBK0phRXRrREl5?=
 =?utf-8?B?WkVwalcxVmlSVFVPaXVqbGVaaVlubHdaS2VkWURpOGx2OXpjSGNTMno5OUJY?=
 =?utf-8?B?cld4MEd3RW8vVnFkdFFHQnRWSGJreDNRZGZBdmZJekZ5bkVKVUUzOVZrZDF0?=
 =?utf-8?B?SWtKWVZkUVZjNEdoL1Urb3dWTmxWRytmc2JJd3ZFUmlCRnpoN01NZ3RrQ0I1?=
 =?utf-8?B?WG5EYldoZnFtNmY5ZHluNVVJTnh6Sit5dFZhVy90cVFiWjFYdmV3T01neEpi?=
 =?utf-8?B?WkdhUGJ6b3BsRkZlWW9Oa1ZCN0FVZFUrUjhjWEhJRzBZaTN0aVh6d3dMcWV1?=
 =?utf-8?B?cTFyVWFMUGRqZzRpNEw0THdPN1c3VHlEUzNERjRQYy9XWjQ0S3RmT1ZIZWpt?=
 =?utf-8?B?Y0Vhcjk5N3VUV0FjbFQ3c09lVS91V3pQUjRmSUxqdlVPaTNldlVmVldmbVIv?=
 =?utf-8?B?Znc5RG1RQ2oyOW56bWdnaVJKRW1lZFhrblV3YzVJbWY3SUIrN2NscExSbDcr?=
 =?utf-8?B?Z3hDVmZob1NqMkVHYkdUcWdwS2o0U3RIWVJ2ZzhyY21BZjFhRC9zOW01aHNt?=
 =?utf-8?B?Um9rTEs3bEw3QXRNakVtYkdJREY4UllSVEtBYmxVakZ1NWVLeWtPbTJkQjQy?=
 =?utf-8?Q?CMstTCd6dgKw5aL+wVJZGfSKwAmIlRT/97W5sFv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c499711-96cc-4b3a-80a9-08d90026d3c6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:55:01.2564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2pY1Yfn9csqslUIAxvZE2PRIx7UOCpNdsxpTps8Nw2Irl7VrqYO7gCzPkH63Fm82rdpcoko0voUTY4mM1hy4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used to create the encryption context for an incoming
SEV guest. The encryption context can be later used by the hypervisor
to import the incoming data into the SEV guest memory space.

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
Reviewed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 29 +++++++
 arch/x86/kvm/svm/sev.c                        | 81 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 119 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 26c4e6c83f62..c86c1ded8dd8 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -343,6 +343,35 @@ issued by the hypervisor to delete the encryption context.
 
 Returns: 0 on success, -negative on error
 
+13. KVM_SEV_RECEIVE_START
+------------------------
+
+The KVM_SEV_RECEIVE_START command is used for creating the memory encryption
+context for an incoming SEV guest. To create the encryption context, the user must
+provide a guest policy, the platform public Diffie-Hellman (PDH) key and session
+information.
+
+Parameters: struct  kvm_sev_receive_start (in/out)
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_receive_start {
+                __u32 handle;           /* if zero then firmware creates a new handle */
+                __u32 policy;           /* guest's policy */
+
+                __u64 pdh_uaddr;        /* userspace address pointing to the PDH key */
+                __u32 pdh_len;
+
+                __u64 session_uaddr;    /* userspace address which points to the guest session information */
+                __u32 session_len;
+        };
+
+On success, the 'handle' field contains a new handle and on error, a negative value.
+
+For more details, see SEV spec Section 6.12.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 92325d9527ce..e530c2b34b5e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1370,6 +1370,84 @@ static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_receive_start *start;
+	struct kvm_sev_receive_start params;
+	int *error = &argp->error;
+	void *session_data;
+	void *pdh_data;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	/* Get parameter from the userspace */
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			sizeof(struct kvm_sev_receive_start)))
+		return -EFAULT;
+
+	/* some sanity checks */
+	if (!params.pdh_uaddr || !params.pdh_len ||
+	    !params.session_uaddr || !params.session_len)
+		return -EINVAL;
+
+	pdh_data = psp_copy_user_blob(params.pdh_uaddr, params.pdh_len);
+	if (IS_ERR(pdh_data))
+		return PTR_ERR(pdh_data);
+
+	session_data = psp_copy_user_blob(params.session_uaddr,
+			params.session_len);
+	if (IS_ERR(session_data)) {
+		ret = PTR_ERR(session_data);
+		goto e_free_pdh;
+	}
+
+	ret = -ENOMEM;
+	start = kzalloc(sizeof(*start), GFP_KERNEL);
+	if (!start)
+		goto e_free_session;
+
+	start->handle = params.handle;
+	start->policy = params.policy;
+	start->pdh_cert_address = __psp_pa(pdh_data);
+	start->pdh_cert_len = params.pdh_len;
+	start->session_address = __psp_pa(session_data);
+	start->session_len = params.session_len;
+
+	/* create memory encryption context */
+	ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, start,
+				error);
+	if (ret)
+		goto e_free;
+
+	/* Bind ASID to this guest */
+	ret = sev_bind_asid(kvm, start->handle, error);
+	if (ret)
+		goto e_free;
+
+	params.handle = start->handle;
+	if (copy_to_user((void __user *)(uintptr_t)argp->data,
+			 &params, sizeof(struct kvm_sev_receive_start))) {
+		ret = -EFAULT;
+		sev_unbind_asid(kvm, start->handle);
+		goto e_free;
+	}
+
+	sev->handle = start->handle;
+	sev->fd = argp->sev_fd;
+
+e_free:
+	kfree(start);
+e_free_session:
+	kfree(session_data);
+e_free_pdh:
+	kfree(pdh_data);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1432,6 +1510,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_FINISH:
 		r = sev_send_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_RECEIVE_START:
+		r = sev_receive_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d45af34c31be..29c25e641a0c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1750,6 +1750,15 @@ struct kvm_sev_send_update_data {
 	__u32 trans_len;
 };
 
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

