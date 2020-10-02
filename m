Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787CE2818C8
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388338AbgJBRHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:07:19 -0400
Received: from mail-eopbgr770080.outbound.protection.outlook.com ([40.107.77.80]:61909
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388363AbgJBRHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:07:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VK8FXQHhdzF119Lynv2L4IuMYlANiZcD4NadvXCZet/ObL+i0+26tk4J0iNlV6zhXwy52zcl1JIeDZHCipKme2YM653XLWAdjAXMk/bnZFlVu6yefb4jdH8KbBbRlD+ynGhwxXSmmEEm5emGjXDhxYNC7/1yEBh/fFkKmfsqH42gW+QlQHvx1TfsEVWFY3YOfISBs6VE8GY+kTBijtaauDCaPav3oqupEUb5XsXDjVZxxRl+kErkwh6u4vcUOmx9ypPNbwwt35pRUKbar9Ts6tEhSUSKVsgD3VDWx/8Fw/LdhG6JbrtAEu0/+mMf69c/hYtzl9k83z8tDresX/QMJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPTJnPyYWbguEbSpImc3vS3qwnD1yOPJQVSgESGXWyA=;
 b=dUlN6IPesGgd+OXZcZTuSVR3usJOqRrzfzUy+Q78gWUHvbFiLEcESZI23Eev9DCGxvJ1/BoXKNqdjHsRmwfKWTflBGZ6ZWv1KSTxcPakhbcr78MKWMY7+BQj5oJ+DQ2KhgkOEKuElrJ8mYNMD2QQx5UAOgXtvCUFNjrHDKhNUvK1h59fmkqi2tS7njpEdzU2WM4l4UVNnzDO5Qu8kJdDjJylIkSgZ0/OzF6ZIcjFLSvPV6QNz9lbOaUmOBkJtOuxOjMM5J0HDvDBcV417mviuww39S1vXLJ8EO44eHv2vBdDYHgkDUSgQxMAADf/6TBB1xy3vahXPyry8peSW7vbjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPTJnPyYWbguEbSpImc3vS3qwnD1yOPJQVSgESGXWyA=;
 b=HT42SvvLf/lltbQElBT+Ry4K5jvhSWCfWIB2A5cM6HCwfzQUFNf8LBrg7fNAJWhBEeb2OH7BbG1vXyW3apUtNnNV77+eqPuS7Y1DLaSb79ebbLteL39xBsPtV7nCjuhZXk+rklNZew9rJX7HCe3XqBn+yxrNt6D8B4+As2jqdy4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:07:15 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:07:15 +0000
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
Subject: [RFC PATCH v2 29/33] KVM: SVM: Update ASID allocation to support SEV-ES guests
Date:   Fri,  2 Oct 2020 12:02:53 -0500
Message-Id: <9c6ee5d0bb37d0f1b4c9091d5d707d6d4e3941ad.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:3:93::27) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:3:93::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38 via Frontend Transport; Fri, 2 Oct 2020 17:07:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c31f1a2a-162f-40d3-1f4d-08d866f59c3f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB421820BB1DF507AD066A8F1FEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MOBiGpWyzFpCq7FKiB8hy0Iw4XcGR7a8XEoAJUhfv3Tcc4v9IEuuBIRc7FVxGgqj3U2nM6iCBhX2mUIA1r1b6hcMrow09YLnc5Ct1SD89PgJuTE7Oy4lf4XE6zJa62C54D0CmPhZvNi6hkdpRR2bbode6JCdr4Sh0oP5miweJbpEt8dQgdIADH10oPmwxntU4G8eFUEeWvLFrYmINFstKx0xfLq2RiC9gNuFZBbfpKWOcA8Vv8TN+/hR4wv/zpqj0gNE8s44RRRiqCYrF6rw6CFGPFkmLjmemN1j93W65yRXP8C5jZOmFyUwjMBAdzc70kyL34+5wfD5AOPanaltgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(15650500001)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: amA8w5JVAttfY1IhhAWE9cWhDnnvtFP0IuR8AwFDq1JJgKJNfZyJHH3/tjKyo03smDRQoyp5Wdbc0Fe6bC0VV55yhIVU+f4gtFkQ7TwFcuhds13Huf6HEewZggM5vuxuIPlnIp6QQfb86ieut5uTHp96hXOMN1ielnPE9R0HglREmkHGgtFILKOlPsS4mjhzRgcJFxSTWopwpxP6DTZIxmbDoITAW1QVPdpGaqlzU9EcEqqWeWTQ3r2dOa4ETRiDrwUwvcc+qKxWFHFyFpJQUNz811ypjCRF52+z1yjNqbVFYkyY4+Xp7Q27vScYvuTCONDAkRTUmlBtdWrdB2xKil/CMu9thACsEfEGFS8GlATkLLpaKWblthhAbn6SnvnWai2vovnuoO05p3hyknYAGBSs7hKo0ZDiC2adv86/mTigw7fmWghPtkTZNcURA1YYpGnWYXT972XksU/LKv/SEXIJ5LmWVR5fIUH+e/GF0rb+djHzMPRCWLsKX1eEymwFLuEWaxbHWxcEhON2KMhmgeQHzfwdlJuvsOgmZCaWQW59wHVnjK0/q5DTEwrwfXqD/rtXQxu7QenynVwULDMlgVHxnhZVsQi66AJuDW06/xf2kXtKNwMqhUfreRZT5gBkw7OreaObn7T1iD3hdewPlA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c31f1a2a-162f-40d3-1f4d-08d866f59c3f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:07:14.9787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJORHUvCJFa6tU6FY1RFHnIA+IWRE2d8PMwup3FTCKVTzIFlMVIh9is6+fvEKtJQJfXSs3n1uQtkL5529zvavw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

SEV and SEV-ES guests each have dedicated ASID ranges. Update the ASID
allocation routine to return an ASID in the respective range.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4673bed1c923..477f6afe5e33 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -62,19 +62,19 @@ static int sev_flush_asids(void)
 }
 
 /* Must be called with the sev_bitmap_lock held */
-static bool __sev_recycle_asids(void)
+static bool __sev_recycle_asids(int min_asid, int max_asid)
 {
 	int pos;
 
 	/* Check if there are any ASIDs to reclaim before performing a flush */
-	pos = find_next_bit(sev_reclaim_asid_bitmap,
-			    max_sev_asid, min_sev_asid - 1);
-	if (pos >= max_sev_asid)
+	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
+	if (pos >= max_asid)
 		return false;
 
 	if (sev_flush_asids())
 		return false;
 
+	/* The flush process will flush all reclaimable SEV and SEV-ES ASIDs */
 	bitmap_xor(sev_asid_bitmap, sev_asid_bitmap, sev_reclaim_asid_bitmap,
 		   max_sev_asid);
 	bitmap_zero(sev_reclaim_asid_bitmap, max_sev_asid);
@@ -82,20 +82,23 @@ static bool __sev_recycle_asids(void)
 	return true;
 }
 
-static int sev_asid_new(void)
+static int sev_asid_new(struct kvm_sev_info *sev)
 {
+	int pos, min_asid, max_asid;
 	bool retry = true;
-	int pos;
 
 	mutex_lock(&sev_bitmap_lock);
 
 	/*
-	 * SEV-enabled guest must use asid from min_sev_asid to max_sev_asid.
+	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
+	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
 	 */
+	min_asid = sev->es_active ? 0 : min_sev_asid - 1;
+	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
 again:
-	pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_sev_asid - 1);
-	if (pos >= max_sev_asid) {
-		if (retry && __sev_recycle_asids()) {
+	pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid);
+	if (pos >= max_asid) {
+		if (retry && __sev_recycle_asids(min_asid, max_asid)) {
 			retry = false;
 			goto again;
 		}
@@ -177,7 +180,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (unlikely(sev->active))
 		return ret;
 
-	asid = sev_asid_new();
+	asid = sev_asid_new(sev);
 	if (asid < 0)
 		return ret;
 
-- 
2.28.0

