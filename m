Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0833E1B4DD4
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDVT6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 15:58:43 -0400
Received: from mail-dm6nam11on2109.outbound.protection.outlook.com ([40.107.223.109]:6625
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726158AbgDVT6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 15:58:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBJ5CZQylruQAwGp8NGTYYw+gZxG72j2Mzstn7f30fO5wIFTaxxbHl6iFmHItSI6X60UYUKzuJpTer5eLmEoQYisbIZ4sZELMjgh48EhtqEEq8v1EalvK77xoUuK6BHqAVFqJQGKZ7fOLqdYI+X3bEzHkDdxJ52zfg6FFS09WQtWr/k2imV75QlnyVeikYfzqAXFtAZEIl82KazBn5BWY1IjKTs6uWT7uAKHK5pS3x1eUBa6Rv0qF6kGmY1hPXsn5uKXCROYrGEar+M1Zrs9UwyTlx80oeQtgyZ2fvdrUgCAp0xG0AICNynYItyA7aq6Q9kTG8tDK4SncCtF7q80vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZCGC1hl4qYHX9P4nKjkybcUPVyLM/057OCoaFiqEFM=;
 b=LrtjQhdKL74FlxtViBs5G9gZ3E6FdYe7sVRL2VDtL0CjDDOE+VFO/Mbw2/ha4z4V6MRImlb0Hbnaccy5JEAZFV0Lzqh0g+/+QaetRPYeZxtlW7GjVHagL8KKAbyNvrzTVCGgLmlfMi61r0x9oYb+aV+vegXuoRG6sokYnM6CrvSQ5Qm38e7iEn1GG3XonaeIneB7rPNs3waDT7SOuziWHGYOVV18AzBIiiuuTgagBt3BDBS6jcCO54j+N8bJkub7KWCyzsAi1Zd/j76aWTRS27icHDt72aDjIl7ULDrBqdzACjhzEiLyNWa01HFpV+vsOO82Git7wiiJMFI5sjy6jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZCGC1hl4qYHX9P4nKjkybcUPVyLM/057OCoaFiqEFM=;
 b=V/MEbOp35JygXGtbq6RQR2e7vd8mRQHOYMLEhp5CUtZkYBChsvFJsWMGJ9HlsjIycuHfXqxmr4nW6B8m/40LCBD5p2u9ptGgCz2j74vafp2sJKSs/1iooMerJ6LE1gdkliniMh55XhzK1QpYaWXp8mopIlkAi2qC3MgWVMoh1b4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
Received: from BN6PR21MB0178.namprd21.prod.outlook.com (2603:10b6:404:94::12)
 by BN6PR21MB0148.namprd21.prod.outlook.com (2603:10b6:404:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Wed, 22 Apr
 2020 19:58:37 +0000
Received: from BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec]) by BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec%11]) with mapi id 15.20.2958.001; Wed, 22 Apr
 2020 19:58:37 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     mikelley@microsoft.com
Subject: [PATCH v2 1/4] KVM: x86: hyperv: Remove duplicate definitions of Reference TSC Page
Date:   Wed, 22 Apr 2020 12:57:34 -0700
Message-Id: <20200422195737.10223-2-mikelley@microsoft.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200422195737.10223-1-mikelley@microsoft.com>
References: <20200422195737.10223-1-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0078.namprd19.prod.outlook.com
 (2603:10b6:320:1f::16) To BN6PR21MB0178.namprd21.prod.outlook.com
 (2603:10b6:404:94::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MHKdev.corp.microsoft.com (167.220.2.108) by MWHPR19CA0078.namprd19.prod.outlook.com (2603:10b6:320:1f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 19:58:35 +0000
X-Mailer: git-send-email 2.18.2
X-Originating-IP: [167.220.2.108]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 218d2491-aac4-47da-3a51-08d7e6f78b83
X-MS-TrafficTypeDiagnostic: BN6PR21MB0148:|BN6PR21MB0148:|BN6PR21MB0148:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR21MB0148D628A502B54A68B622F7D7D20@BN6PR21MB0148.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0178.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(81156014)(82960400001)(8936002)(10290500003)(4326008)(26005)(82950400001)(5660300002)(107886003)(956004)(2616005)(478600001)(66556008)(66946007)(66476007)(6486002)(1076003)(86362001)(316002)(8676002)(2906002)(16526019)(186003)(36756003)(52116002)(7696005)(7416002)(921003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1752yKqdsvkH1CkUQFwigt3CYVjSx8FN00WL1VNxyLtGhAsJg5+Dqs5zvPd+SDFY/B3DNv1tqXb9PDkRIEhliseTqqBwCM42yrfrw02F7WNc6/gZh1Cp8oVVOcLU+BU+qloYDYGBA7xFAxNGIRjGNI1o/CYY1wKxTI3dANSNuzqULsdhCv0uTFTSo9h2ENqzFBUVF/xv1XIFzqHR9zZHpCfQPKCB6A6JomHYPHDO4GUuzK/eNJ6jph9eQxbRAdEiIvLD/R7DOWN1Z/G0amLWcgaL6mBcH7cIn0C9Hrh0g57LDvdnGVnV7D6apD8V+9ixEAhYpGkVO23kroHFX/F3xskEA8SsRBMezg2N7+LrwIjPO0lXtqMaRdFi4AQsHReZb/4281+sGGEHVKk08mSzi2lTsEI7ypQVMiPsitZ//wkupOwxbgdgg+HjXItBk2qX7zNo3Wdx8Qet/ntjU0AhDpPn8trJM63RrB7PD8LLrL4=
X-MS-Exchange-AntiSpam-MessageData: bz3U0syiuvEFTKQRnFLQwCoWB17AXxgkGadfo/mOKaox2WFIdMGRQtJZxe8kn+QvNQU/YkoTMLadt27wPRBbfZwintCC8h1/qToN32IInDqqZPJ59S9DcHAhyPKcfCdRWlnPDbSwrEiSdddTq2nFfRUNFvmfcShCai0/jW+lDDjkDHAAvZNupCpAOCom/iKjJpSVDhhCsHR/ZtKdaKdKara1rhzeEqpsPMAQpMOF9+rQGS1kUs/JEHmtMDu3aO71I+0XVoxXV4r7BEPjBCxZBDUFL6MCB75BgiQLsdd+4BQyoKHmjN/snddVZ01BzQsxqs5aKr9IFgo/ZrTgODaFdB2cHSX8N2cboeHBXwVDg4AU8ERBb8Di3LclyhyNzeIyGITc1RWH8N0Fqr/0yrjgVWS+AHVNbEGWbLyOk/NDc2liijgynI1Ey0c2vYOO88cjgSf+h9dQdLQp2vdSRA8dVx3mxRdfmJTVaiZcSMyqpNJ7PHgklZ8gCMBKeIAueei3rWUi5SXc0L9gSBZHlJspvnv1BO2jY0Qas8Y+BEDXlq+qSCkVQ+4v8Ff1AddzGFyizShuM1euO6gOMJZkPiD/Uf3m6c9/V/vjza47FEL3YpjnOsxwZvNTOjgdotr5XS7TcOYoHwMpG9hrylSF0YLzL2Gk2KicLZalNcp4HpyibK5FanCrqlzGW57ACem1V8vDLczdE+eKndaEnMd5w/YFd3OLyBYnQA2uR3nUge8aZLoF9t+nABym9uu4EdYLZK7XdDPL0vxZMaLvuJigSgI/9PfXz+HseNzA8+HftfMSBR0=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 218d2491-aac4-47da-3a51-08d7e6f78b83
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 19:58:36.9637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EN0LugPXZvgmDhV1VLl6zf4D4qpOxn5F9PD/jOU3dR5nyBdBWbW62pO5ONTW+HeWZE3yVp8BGxoZu0LyYfQyzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Hyper-V Reference TSC Page structure is defined twice. struct
ms_hyperv_tsc_page has padding out to a full 4 Kbyte page size. But
the padding is not needed because the declaration includes a union
with HV_HYP_PAGE_SIZE.  KVM uses the second definition, which is
struct _HV_REFERENCE_TSC_PAGE, because it does not have the padding.

Fix the duplication by removing the padding from ms_hyperv_tsc_page.
Fix up the KVM code to use it. Remove the no longer used struct
_HV_REFERENCE_TSC_PAGE.

There is no functional change.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 8 --------
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/hyperv.c              | 4 ++--
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 29336574d0bc..0e4d76920957 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -303,7 +303,6 @@ struct ms_hyperv_tsc_page {
 	u32 reserved1;
 	volatile u64 tsc_scale;
 	volatile s64 tsc_offset;
-	u64 reserved2[509];
 }  __packed;
 
 /*
@@ -433,13 +432,6 @@ enum HV_GENERIC_SET_FORMAT {
  */
 #define HV_CLOCK_HZ (NSEC_PER_SEC/100)
 
-typedef struct _HV_REFERENCE_TSC_PAGE {
-	__u32 tsc_sequence;
-	__u32 res1;
-	__u64 tsc_scale;
-	__s64 tsc_offset;
-}  __packed HV_REFERENCE_TSC_PAGE, *PHV_REFERENCE_TSC_PAGE;
-
 /* Define the number of synthetic interrupt sources. */
 #define HV_SYNIC_SINT_COUNT		(16)
 /* Define the expected SynIC version. */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..4698343b9a05 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -865,7 +865,7 @@ struct kvm_hv {
 	u64 hv_crash_param[HV_X64_MSR_CRASH_PARAMS];
 	u64 hv_crash_ctl;
 
-	HV_REFERENCE_TSC_PAGE tsc_ref;
+	struct ms_hyperv_tsc_page tsc_ref;
 
 	struct idr conn_to_evt;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bcefa9d4e57e..1f3c6fd3cdaa 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -900,7 +900,7 @@ static int kvm_hv_msr_set_crash_data(struct kvm_vcpu *vcpu,
  * These two equivalencies are implemented in this function.
  */
 static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
-					HV_REFERENCE_TSC_PAGE *tsc_ref)
+					struct ms_hyperv_tsc_page *tsc_ref)
 {
 	u64 max_mul;
 
@@ -941,7 +941,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	u64 gfn;
 
 	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
-	BUILD_BUG_ON(offsetof(HV_REFERENCE_TSC_PAGE, tsc_sequence) != 0);
+	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
 
 	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 		return;
-- 
2.18.2

