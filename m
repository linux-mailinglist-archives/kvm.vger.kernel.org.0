Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90E7269679
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgINUZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:25:08 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:9896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbgINUWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:22:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIL68BiJKOCXeRWpgGjdDTBqdKBcR5tZDj0b4RR5Q71Lyrsj/dskQXWLYOl3+i/Cu1QT5jxYqHYrP+BpS4J4WMTTuCZj+kpdabrc1JM+ADyLQKnDplnYEmn0lBgVKpHSgALYKatg3IEN6qcdurnYt3P0nO3ZYAtA43kGC/ioEqFHqWIHaZz5vABlE4KiIR9MdLjD9zmR9usFf1Tz9mRDseyLMTNfitIyaq7EbryDTude3a5hX/GP7csVLySaY5p12yBQ/Iqn8cXFhGnwOWj+ptM7sYwm8PpWdqrP9qMC7wv1VlhxP9z80lTmg3roY4qApGINPcQGZgjAnfQ/Q0VOkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc0OUir6g3L4bospm8phOu0Mk7q6hE/6vkpkRes5N+c=;
 b=oNYb1z/Vah/OPO9El5gB/tFZEuC9XYht9p0hEXkojdmgX0npRsjZEQvGsKseV6WRJvJ836klvRXvNJ4oEfBYEJKowS+S2oOs7Mx7bPfstg/YX5LSZ9fz1I59hz6WlzfcFmEy4l4KN2rv6hDkqQdjY5LxWyPuf6W3RyXuPrzhJRDJNOIIgI+OxLPVbiakZ+O13U2W152EGjYQqh0ZpVQ+k8XEukBIYE94H4JtkYmvsZQq/R1vzbpJLZJX/4XMIpckSUF2/JElvvwBfAwRP5K1QUsjUzuQfjuaySsp08Tit45rOa0DyneweGdCzyKMogcVD0OpGGZMkWJTPXqu6M5m1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc0OUir6g3L4bospm8phOu0Mk7q6hE/6vkpkRes5N+c=;
 b=ojPbvoTpKseSuW0L8bCYvKVL9Vsp7mv0NHzH+Z6fhcUFtzjpPBMmJnwP+5+Vl+ZyrZAlw6qRejEvA0mgqFhXKt+/jFa+HrOWK1hQgU+ykSqrMKrnFVNWu+4cOHRX7wFcTbKC9kFTs2UNV74Rm3qytsck/MA7q6KQhzFrmPtFgqQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:20:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:20:40 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 35/35] KVM: SVM: Provide support to launch and run an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:49 -0500
Message-Id: <ab02aac928f6ec8238a33041827e96876bb94c9b.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0116.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR02CA0116.namprd02.prod.outlook.com (2603:10b6:5:1b4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:20:39 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6188e6d6-123a-42c1-107c-08d858eba5fc
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB298800E32E89858F922D094FEC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62fq3umFS+A2DNEjpyVsjzEJwf/sjE0GQtjp92WvJQrcUmNdEAGrUR9r97xSDzce38ifNvGva4XkQ9hvOCLPVXaGClJp1MiOnfBTBUnWvq+iWlV5bAaOdEEe+7sCfSWTZzgHBu/LEnBMrjmsH3W83olCGFnHVBsvSiHeq5hT+78bjS2XmzuMej297v4xdWr/iAtUT93os6lBp2Cdr628ceFGK+PP3wcyxMivkOKWxncp9aCXQPPBVzAzauC1CfG+Rbegwi38DxXrBMd/w9VkvpV1DylXBd1CzulxYMF1une+Nwj7XG1z1AXmTpLZlq0kLMndPBJHISBGnnwSaUmCMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hKZyuqnCNRjxouKtW18roeIE/NTxkP38ZA/cI6RqqnHaEAcwWn2iFsCrQ5J6pVqb84AMUa9UDjAK2M2iDH/iJ7NUId2p6GoarNMaREO+hNesEjWTuOfhfMnYdm6vjWT65qU9ymkamvKNvGKwfka2iGWlfLT7yLj4/5jOcwqrMUhvryjS4pWsmL3siK+I4yTxa1SmTcWk34LcJ9YrT6NFf29Acm+D1g0XL3VynQSkxJtT3dyf74bija1H9+U3v+NkzEWAXG0z4GLW9lddDUAs1ixkdM327OJbhqFLUQqZUAGHmBQEsXNrYBwusSnHcHLmGVoK6MLpLRdnjOcJY+u1Gkd+2kuuTBjMpIavFfQdTGQbKDN6K2wheDMe//oNpMNBw9BnDfle14vYNWbJbGAhM0/FrRuy3Yt82GUdlNmuLBPc3dEiVHNNl7YQX152FANOqeetTLaeUb1AARZZK7At6MAD2gljo72UreMOyQCXJG7MI8698I+sqWk0NXtmZOvVpEyFxwqD0oY2KL310KK3eYINUUJGh10mBRP5+6TY/9IToeStT3oBWFy5EmSpRy8znerXYuhIsEmLfNektzWubzPDZTH09UjUfbDgOI107uif9TYcoKSI46jFnrZyGP/0TgsPmVXM4kD7+Rh4yCujbg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6188e6d6-123a-42c1-107c-08d858eba5fc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:20:40.0303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOsi1T2cNWglytFNxY9KCtoSfa3djpTYauE9hNxik8tfIlAl/LG5zmMqBaZfTFEA4lMthzE2/oFtM86mX+uM5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

An SEV-ES guest requires some additional steps to be launched as compared
to an SEV guest:
  - Implement additional VMCB initialization requirements for SEV-ES.
  - Update MSR_VM_HSAVE_PA to include the encryption bit if SME is active.
  - Add additional MSRs to the list of direct access MSRs so that the
    intercepts can be disabled.
  - Measure all vCPUs using the LAUNCH_UPDATE_VMSA SEV command after all
    calls to LAUNCH_UPDATE_DATA have been performed but before the call
    to LAUNCH_MEASURE has been performed.
  - Use VMSAVE to save host information that is not saved on VMRUN but is
    restored on VMEXIT.
  - Modify the VMRUN path to eliminate guest register state restoring and
    saving.

At this point the guest can be run. However, the run sequence is different
for an SEV-ES guest compared to a normal or even an SEV guest. Because the
guest register state is encrypted, it is all saved as part of VMRUN/VMEXIT
and does not require restoring before or saving after a VMRUN instruction.
As a result, all that is required to perform a VMRUN is to save the RBP
and RAX registers, issue the VMRUN and then restore RAX and RBP.

Additionally, certain state is automatically saved and restored with an
SEV-ES VMRUN. As a result certain register states are not required to be
restored upon VMEXIT (e.g. FS, GS, etc.), so only do that if the guest is
not an SEV-ES guest.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 50018436863b..eaa669c16345 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -201,6 +201,16 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_es_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	if (!sev_es)
+		return -ENOTTY;
+
+	to_kvm_svm(kvm)->sev_info.es_active = true;
+
+	return sev_guest_init(kvm, argp);
+}
+
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
 	struct sev_data_activate *data;
@@ -501,6 +511,50 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_launch_update_vmsa *vmsa;
+	int i, ret;
+
+	if (!sev_es_guest(kvm))
+		return -ENOTTY;
+
+	vmsa = kzalloc(sizeof(*vmsa), GFP_KERNEL);
+	if (!vmsa)
+		return -ENOMEM;
+
+	for (i = 0; i < kvm->created_vcpus; i++) {
+		struct vcpu_svm *svm = to_svm(kvm->vcpus[i]);
+		struct vmcb_save_area *save = get_vmsa(svm);
+
+		/* Set XCR0 before encrypting */
+		save->xcr0 = svm->vcpu.arch.xcr0;
+
+		/*
+		 * The LAUNCH_UPDATE_VMSA command will perform in-place
+		 * encryption of the VMSA memory content (i.e it will write
+		 * the same memory region with the guest's key), so invalidate
+		 * it first.
+		 */
+		clflush_cache_range(svm->vmsa, PAGE_SIZE);
+
+		vmsa->handle = sev->handle;
+		vmsa->address = __sme_pa(svm->vmsa);
+		vmsa->len = PAGE_SIZE;
+		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, vmsa,
+				    &argp->error);
+		if (ret)
+			goto e_free;
+
+		svm->vcpu.arch.vmsa_encrypted = true;
+	}
+
+e_free:
+	kfree(vmsa);
+	return ret;
+}
+
 static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	void __user *measure = (void __user *)(uintptr_t)argp->data;
@@ -948,12 +1002,18 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_INIT:
 		r = sev_guest_init(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_ES_INIT:
+		r = sev_es_guest_init(kvm, &sev_cmd);
+		break;
 	case KVM_SEV_LAUNCH_START:
 		r = sev_launch_start(kvm, &sev_cmd);
 		break;
 	case KVM_SEV_LAUNCH_UPDATE_DATA:
 		r = sev_launch_update_data(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_LAUNCH_UPDATE_VMSA:
+		r = sev_launch_update_vmsa(kvm, &sev_cmd);
+		break;
 	case KVM_SEV_LAUNCH_MEASURE:
 		r = sev_launch_measure(kvm, &sev_cmd);
 		break;
-- 
2.28.0

