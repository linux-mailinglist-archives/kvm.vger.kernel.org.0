Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048C22B6B61
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgKQRMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:12:10 -0500
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:47201
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728598AbgKQRMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:12:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yt9czJ6pqEbjpjbp25EMbmewSIQbkWNareP3JiRnA9sAr398xS4fXb8oqarrgNrIgUsfM17DXIA2CCrA2p5Q9DkcW3YKd/oBvZPgFxV19rGQfqeVLjzhuSilc4N0TLi3T3yi/VjwRShcBrexWaGgvgonslGwRc09ZR09Oa6Xr1Wf6we7eWJVyIhY9wCdMW033W94ff4ldH1IOFLWGhJyrCdFY8/zb7ZdNFZzlsSw8HEmiswOepTwFRn05ATro5MCrlEv1ouOUhoc22K8QMlogc3rgAJpWnN5pnKg6u/1aBR6Aed/QHmQMBB50VYIY336HT7kQIS7ooXpt/nSHO8Qjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rdrg9xdmCo1Mi+20Ub/bjG9z6mIYPEDGliwugujXITg=;
 b=iz2FxDOoFN3+Ef0oI3Lk0K3Wk83/EnqHyNAKyBSzgKBMVzfJOLj36ivpi1CYnlXeBtxgD3Fqo5jlAIfmPLt6mlu/Np+jpTGg2tbxnHXvup9dmw9Qyvs9ir9lv7+0Qu1uW93EOQxPcBCitoWMlrSkpZivaceaJB3q5uR1QvlrZKyOrKuS6f6CcuOipATxx6cE1aSOk9UexlO+5gwFJW3JseqxLsVS4krQyhM4vMtuRMJpGUMHjTt/FrXkzy4rGLbpW7Uob4Mx6B1MKi8KG9hOMhyqXSzqqXlKn5YClBIHWF3JQmaRJXPe4xP3msEINyYGD/6wnUjgLC/aRcly6RWJgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rdrg9xdmCo1Mi+20Ub/bjG9z6mIYPEDGliwugujXITg=;
 b=yBFO0b51mKZFJpksdi+4f0zBC3hTPGN8FiStPvZCpPj9CkZg4I09eBQaGby+eEP1WEVJyInb4Ze0cwNBeFpaem2f9U1bRJAaGElXgnGnKoBOEzaWlmrO64k8b4juZ38SrHDOkExhoSo0ri6nLVelKITEDrwjsqNhvgS2ZyLCcnQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:12:03 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:12:03 +0000
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
Subject: [PATCH v4 30/34] KVM: SVM: Update ASID allocation to support SEV-ES guests
Date:   Tue, 17 Nov 2020 11:07:33 -0600
Message-Id: <1a7362f8a5fb643689d935f5a252983ad0f482c2.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0134.namprd13.prod.outlook.com
 (2603:10b6:806:27::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR13CA0134.namprd13.prod.outlook.com (2603:10b6:806:27::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:12:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 109d203c-fcf4-4743-969d-08d88b1be720
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17721FA73C734F0B0A2370C3ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HF2XmdE+ir/2cRPBF3vlPiQUCYqIWG10z0OMDgu+GBahV9xNFUdoGAWXdLtwhOHLuruqlseZoDxZAIMz5OtNvoG2suBuTeHnPdPVl7i8hiOV27jb69WModsuI/ZC6w7q/JG38T5podhBOTjuU7tNdyoCiPe1HUr/vzFGU4GcBrUefTB1C1uEh6Rnz23AuoFrFlZW+deFZvNHszgTc26cisX4uatUzp6njpx3IqLI0xg6Kpwk1+qJQGa+lT9keodAUXjVbxtjk5ecWyWXlIgdOn3ZPASythEcZ6O2FkwOs2Wxd7W2Qn8vWqPwPnUn7B7TiNx0rD33u0NY/M9qYTV2EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(15650500001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pxI/BWyDA93rCovbJicpFGSqS3unky8+A/Kx/zF1lx5zp2ef6JtTGlh2teiIe+bxu8VWc2DrHS10bTYv5VCfwYc0+BRX4JSQT34s/gNkVfaZ5klsvLvvuXeWV52uUi7QuJKLKeLPIljiYA70frqWMHYlDNEuPhSxr2ZjC5+xbh9bYwRRinpJJkrdVCnw4LsvqLmxxpSGIX+BsD9Ni9723hxYBC4Eg5ZP579zegiNCPs92rJjypGSMPOxKjYVrcfK/4xY1v+3JNUKZuWib1+yJLiaBdhDy7SvZ6s6oqmZTNqWP3e9RYg91S37y/kjB/3tXnZgxeRm/CMZdfJDSnG+9ufkHMURLIDd3qGqE7qWSF+obqk+V8Ng9/e0OZ4GnW5ZesdX1tfHnJasG93ohUySgmyqPSXc1eZ9E3Mtstd9NEaxkls7kcckbo4pwlQCrBP/EPAETCaPKtxzcXYh8XEMSIYzOsVCw4JKYvEVRToP8QeWsDoRTOXj9j6G5exVLgBLhpBWjZPsB+KYKMMj34wegMulf5+UlpJDc447U3rUe7ItdKnkm3khwJWvERin4iesLk/lsYQyg/v8SaMBnRycAxp7K9ExDZyu/vVb29ZkqB9JPAM3uHQdovhK/sx6qSpV/BnpDe0OoFKIiz/cLztKiw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 109d203c-fcf4-4743-969d-08d88b1be720
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:12:03.3544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2lrDAK5YuvN0C4JizuvyJlJE1EDU07WSfda3ORpRd588yemz60/r3uUnXJXtLvQbnhnmqnovWBlXUXRmaYBSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index 4797a6768eaf..bb6f069464cf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -63,19 +63,19 @@ static int sev_flush_asids(void)
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
@@ -83,20 +83,23 @@ static bool __sev_recycle_asids(void)
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
@@ -178,7 +181,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (unlikely(sev->active))
 		return ret;
 
-	asid = sev_asid_new();
+	asid = sev_asid_new(sev);
 	if (asid < 0)
 		return ret;
 
-- 
2.28.0

