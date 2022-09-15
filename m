Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E065D5B9891
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 12:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiIOKMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 06:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiIOKL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 06:11:57 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8806402D1
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 03:11:56 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F2o3gl000455;
        Thu, 15 Sep 2022 03:11:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=FmlryYL2InGcck2u5Qwd/mhswalDsNcAqMgOctimGn4=;
 b=WKlZsEklgkMqz5RuvT68B/HDCEvwDz+oB2Iww9AcCOfq/tdgT4xWu4cQoa54HDSFJsyC
 YPJjkqJaOibMcysCTvJ9cdjGBR9Iqv/THpfpQoqOHC2VxmyMlKaXO+91tpjy1Q8GD20Z
 UX7mFM7smqHoU8OmzF/NSI8ViPBUwbSH/cpXhgOovCV8HAnQM9RzPHBEwBMh0bvwJ9Zr
 9x16MTe1SnQFrALTqV1ObaUNiXAfXkG1831e9F4DCOjnNxWkaljL48++1fddfJSiHMZL
 VY4K1S+AN+LYmk0kQ4SkUJhz3ewGeYqiJFDSxQvOL+eoTddmHCAyQKdvBLeAnpi3eKpT 6Q== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3jjy05cap8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:11:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtUZPCsmECBu8HM3U3Lw1mwKzKoIWUVyNPJhruP0XJau5QOUZoLUGxuOJyErxVoZGgR5sAGFLkZx/8cIlNdUf4nAQ9D4W+y+6wlzliJR4yH+p6Hs14SXMn69CJAKq4tKigJLN4Lfd0IjZwOkvWTq8B/Q5xw4r3bdvepFnVMhzZbiyc4r3pPz4sSI2tD3+2uD+EvaR7iM0N5OPpjTpqDZKBxvN7of7+tqzqaMsxTp0XqO3fcf8NJPVL75Urn/Xpo87nBWPrgubk3m9kEpFL6TFZqnKDTxMi/Zk0f4ieN+ET4U/vGLV9BHhnqh7TF4+X+mlAyOuWmUpV4Y3BY069vkpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmlryYL2InGcck2u5Qwd/mhswalDsNcAqMgOctimGn4=;
 b=g9i82DYhJDSpqgwmadCaYPbjAaqVvqMgVnS2a44cA1ger4KbNane8hgrKbIAfIGzmr0IlmXNHvvrUBIxzi3y/56HdbxT2eu1XxzLEWI9TUokVOti05i08JXMJYG97bCg6lsjGpg2YQJ87bsQRdpiTmslRgaE7dSum/lHi6cgCvDOWkoSP77JEc3Ubzz/nH+A6juvLjumGYHwt34+kTRRGGjrVnKuSUUH59lJSFWBp7BpLuFe3K9e5c+8lBhM4L2dzUIvJn2whHmNUm++OsnQlviOws0JGwLt2TuKACR+pwQVYmRUcNYHiL3OCLPodet/qul/0IVypi64J0oObcovTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA0PR02MB7370.namprd02.prod.outlook.com (2603:10b6:806:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Thu, 15 Sep
 2022 10:11:46 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%8]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 10:11:46 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v6 2/5] KVM: x86: Dirty quota-based throttling of vcpus
Date:   Thu, 15 Sep 2022 10:10:48 +0000
Message-Id: <20220915101049.187325-3-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0235.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::30) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA0PR02MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: cb3ce053-0ea3-4c9a-2460-08da9702b20a
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ctvrl8IdvRT3/pjEke0hhNLu3sUm8rbFyBbchLYQW5Tj4l7hPliuj1rBvjw/gHuVM9NE51vD/LZ8m9EFipOe275epUmK6GUrR/L1rqlybWjowVgyFZo5BQO//pPNOsFtdCp6YmrzGK1k8zs/MxBAfonxvqiqGBMQ0o2fgFcQ6nN79hLP2/bGEtKjHCxlPkwvFfo5YEK3vrgW5bHSbjEdNRqLbrEZJarH2unAGFTQeUVGnZue8TXhkFiszVVvBiRWXlMnozVtl72aO3y3xFND4iYBdfWd59xTVV32ejzcNFWVgLGbevcrfebPtqHSMsh3CgbIZeFtXjfLHfXlveKV9yJdn6YRCOIAltom2LvOMD/eO0ZNK+VTbkLXwAflnZY/T44ltDl6q+K8uTcn1UZKWx3VN5ahc+ljSZxHFNn3q3J1L58BEVjjIYSnR31j47AVmyjBsGPpKSOaeqQ0PepzmbURbpDBJUcSI4pkK4ZsvZfbvF+yV/DtMJEaE8+3tdXOZou+hjI1T23pWpBTl8vQCVtg92zRjbQVley8sg1V/W6BUrM7F7DqTrIN6Xv+qi32eDAkQ8pbD96vPyYsO0wwKtDFu8j5dlR7MvL+kN91GYgzlUWC7Ou77wvXEkkzr2SSFXhFI890gaj28dsV/xDgIHLRlNjc7gKiL5tONnGYDvC6tbikBp3DLvexlr48diqJNUr98GoopRe4sTMOR55c0cQkcpVHb5iJHZr95Vi1SkL6Hz2wVMp364ObxKkbIqeTMA9YlGiXzbbbbgMhLzjm+6BwX/1q0VSg4cB3IFbfSuw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(52116002)(107886003)(2906002)(38100700002)(41300700001)(66946007)(83380400001)(2616005)(186003)(6486002)(8936002)(6512007)(316002)(66556008)(478600001)(54906003)(6506007)(4326008)(5660300002)(86362001)(66476007)(8676002)(38350700002)(26005)(15650500001)(36756003)(1076003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PJaixZBQIp5VfXDXCWGisGMT4HFFsb6yghbaPJmu25fJp+YQx1AIqy1uAy7i?=
 =?us-ascii?Q?zB1GSJmgz9b/Wj50OK1W999LvBjF7yPVHMcQD4llGt8MpMS9HNLgbu2ZnY6L?=
 =?us-ascii?Q?5A1KGEO1T2k3Pn0YEvdqGDc/f3eaetwKFTLHwDDCK67lVU4jzkgadReX+W3W?=
 =?us-ascii?Q?1ZIL8KyLfs2Cl8a6pcuQUzUy5Q1oHc50mNsjTjT4l8yJ3ARUC0Z/LIZO/ws6?=
 =?us-ascii?Q?Zdj1hQWjrgTyj2gz6oyIXXyeqPeppu5gDYs8do0daWOCQ2zQto+U/ztkt5Bz?=
 =?us-ascii?Q?Xrb8vmsfzzKlsofvbmjS2zyToJEMWK1XCi3kau+oyP4mGK5JLKPwzawLF+lG?=
 =?us-ascii?Q?MMVZ/dOicH/Qz4GcQ2+wryyf5jUPU3dWI5YyqEzd3F6i4sIOB42FcP49fQWZ?=
 =?us-ascii?Q?RW2iojdDjUv0smtghq/yQdICgT0hudKw253uumpsI9uI/ls6YVU/Z5oaGtPx?=
 =?us-ascii?Q?zxullLkmOsDAMa93vgB0BwtNnnTUvtWM+xTepDfX24K+vure9urtHhDM44/A?=
 =?us-ascii?Q?jr76uzrXY/PoiZOmIo8ApHgS9dMFDKWQdII3Z8Q5Mh5xlqcrJK2A5bIooyZm?=
 =?us-ascii?Q?5E70OrnS4OhfYTEk4vje1NPJ4m0NKX33MIpdfyL43HkjFHWcjmPiT7bploTZ?=
 =?us-ascii?Q?86DcosKMNcHF6jvFgUdHnxwLSA5Huxk9fw6af3GDdg0dN3jg7wX59QBaP36c?=
 =?us-ascii?Q?CQ2h7BYH2XMlra+k0h9ULSPk6+vLb5CqTKzy9+Y/0Zdph0AxmE7KswFisUQt?=
 =?us-ascii?Q?3gBXCNv5quaCP3iHgDs6d6N57zEmT/4qVMAAPmuvI3X5hjjVFvlsdcNBfZT6?=
 =?us-ascii?Q?sbKPgrQKdnjxtnR8kiTeJoj+P/GQ6HdX/RT0BgClw+f0KggNV85iCW7DnS07?=
 =?us-ascii?Q?UXHgNe2OcHAARs4rhMjLpmoxSPzvSM8VqUEGrYra1lPml6oefmaxaBeMEUdn?=
 =?us-ascii?Q?ow4Z0TQqXKi4c9tpOiNCMjqHdof9XaRVgFEkqK6IqCELYEZ084S6YoNO5REX?=
 =?us-ascii?Q?N4NuyQtooiTxPFEHsAamnH4VpwIG+Vm/oPSmWa7WBwEAP/VLLv8WdnDC0qoz?=
 =?us-ascii?Q?1HAXqU9rii8DgiOMUCyQOfz9Kokzc+CcAa4wZ5SBXXHe/CLobJfH30v+joMl?=
 =?us-ascii?Q?yG86WaMsZd81dCKx5gi65cMR8DY/SMrl+w7k6LfAPxA3xnbZFfq6dgGvtaLg?=
 =?us-ascii?Q?FQkFz5jDIAK3iyXstDlAUf20sLAdfFsOCtLiXtboOL6554TZ2VUvN96/keoN?=
 =?us-ascii?Q?9nNb6SWVZ95GIx3HbS1qo5XujGEWkKZkzT0V1rHtedYD1vTQ9ca2n5y22/gC?=
 =?us-ascii?Q?FIklHjbw3FnUPGr0Iphi8CVq3AjKyET6tCUpomOReb14hDKTVpnvYBTy7hWh?=
 =?us-ascii?Q?nIBklWSKhIrqP0V1I2LDCOSRruUEWW4tFPVR6+ojJu7MvK1XOosSHrWkqz88?=
 =?us-ascii?Q?fMy+NLfMBg7sCJX0QNmvWpQdu2CFj9McatNmPQAlgkGCryFGWFgkDvHdMrLs?=
 =?us-ascii?Q?2TcgZAt1ROt2R2DqRJwuMJC/k1E00s4078VD8MP5L6XOud8fKrS7Nwgfi5UJ?=
 =?us-ascii?Q?57x3E2WRBDttD/esFpNE6KJH1h7UlxKlgUYByjqk77Xk/EpkMnMFEsvm4Ehr?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3ce053-0ea3-4c9a-2460-08da9702b20a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:11:46.0021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxDwACn3sJLnXE6qfzMFldtmLs0XBEllYkYEsTJN/bccL5dnuuCc4WnA9M52w314+Ke3aexmev2E8Kd3aaEi26KMthOdiZ5RwBstmT+fRNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7370
X-Proofpoint-GUID: NGOiF_jMF0psvEzL9GUXwks-rHAfgWL9
X-Proofpoint-ORIG-GUID: NGOiF_jMF0psvEzL9GUXwks-rHAfgWL9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_06,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/x86/kvm/mmu/spte.c | 4 ++--
 arch/x86/kvm/vmx/vmx.c  | 3 +++
 arch/x86/kvm/x86.c      | 9 +++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 2e08b2a45361..c0ed35abbf2d 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -228,9 +228,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
 
-	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
+	if (spte & PT_WRITABLE_MASK) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
-		WARN_ON(level > PG_LEVEL_4K);
+		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..140a5511ed45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5749,6 +5749,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		 */
 		if (__xfer_to_guest_mode_work_pending())
 			return 1;
+
+		if (!kvm_vcpu_check_dirty_quota(vcpu))
+			return 0;
 	}
 
 	return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..8447e70b26f5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10379,6 +10379,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			struct kvm_run *run = vcpu->run;
+
+			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
+			run->dirty_quota_exit.quota = vcpu->dirty_quota;
+			r = 0;
+			goto out;
+		}
 
 		/*
 		 * KVM_REQ_HV_STIMER has to be processed after
-- 
2.22.3

