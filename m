Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1B42AC898
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732608AbgKIWaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:30:10 -0500
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:19175
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729454AbgKIWaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:30:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxwDIrLAuv5Tq26f+3LlGtEnD9/N2AcWI91yQfmlN3g04W/ORNisDdbAZj+uUtKdTS/VY1X+4BD3dOSOHAKxIs25I2ajM8cUTQnSMLJeovFWGaLYrBW6XtIP63/iYwTbjmkA3Jn9Wd5ehuCugyAv4xhNIK4OcI0jrqpmVv89vKfTPLrBv8FZIWjjJI+6Bqay59FmwKfs1aSc/uXNlYJvsj9y5H4FnF+k0G5fuaS+VLGHKbmdkYiAEe5FHsrylUY4Fip0xOlU+HaQCVDfMCfZHnj0RlRanjo4WoUay6+RTf9/3YRee18J/zIdEY5rwhgEKbkN02lMZX/PoP9ksELd4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUZ93QNq9ZsU5wHlmMuKPrixiCiBBeuvoKnaX0mU5GU=;
 b=OZFGyz3mdu2gSxdTiMulQhDlz8TLHj5BWU6GWdm+gY8VIqflWmc2nyqGMBYoX65GKCS4H0Mwo76gwbHK31FdM0AMYvurAWp1O7Df9hvJngtyBCQdDPRuGcirl9Y7yALrGeStUYTObJvT/Dx2O1AknEN/7MWKByyXnjn5V516PUAX1c2CYZIrynJucBcrLUciNllgCbNy6y0omnsuZC1yPX3RBhkQIzUP/ctDoNUrFz1xDaGYCuiYpgU0NfjA/D879ZmwBs+p9txTHNhsmmuP0DnWIPrHyDDYUfCyNAPDgKvO0LII6U22dqla7MIV8Gy/iXO5JQlqt8oTNHqcT2JD/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUZ93QNq9ZsU5wHlmMuKPrixiCiBBeuvoKnaX0mU5GU=;
 b=narx9+yT8H6HjmYk3QALkhmmOdj/u9goX4h2DjuL6580DhrT0/bhmsnQtMHzobMDkfirAR+1YuaXUmGVqdDPbecfiFu17aV0JCCc96eKLDkqMAsiNg0ZkSJUDztwGM2R0YjnaJT2fNYmH1PgQ0Bdr4mwGjSyJyVs934YTeqKPA4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:30:07 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:30:07 +0000
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
Subject: [PATCH v3 30/34] KVM: SVM: Update ASID allocation to support SEV-ES guests
Date:   Mon,  9 Nov 2020 16:25:56 -0600
Message-Id: <79b42f254a5e140150557927a27227cb2d0a507c.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR12CA0024.namprd12.prod.outlook.com (2603:10b6:4:1::34)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR12CA0024.namprd12.prod.outlook.com (2603:10b6:4:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:30:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 49a5f0b6-9cb8-42db-aa90-08d884ff02aa
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40582D39D40BA5E28D299960ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7bzcJYCFYZeIBh9dHxdzLkVEYXrKh4A32K2VpcSDy0d9IXeWcX2anav2mfhLyuvgX+aw7pcE5fD3fx0z4NU2m4WfGowAuUSQn4PooixIwb7fJXoQA3rOZYDOXZ21XPdFRqJtkxy1RognJjSAbJQ6OPG29WrvmOBx7d7zUtBAVqoVVVHm+Qglh1I3mOUo1LhEwLgggLT6eTvrplRwKPYKz34deY1nkbmxrUZjli4B98qvtUFERhgRRYgUcM62+38MnEN+ZVBv49qjGkdg/sLGKF5Ztu2sA2NCkq/WPXfVBMP5OCesZ4Wp5gcww1lJ/GYzeoXz1h2LuAVI5C/vc4+a6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(15650500001)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aSpvanWHvHmNtRCxrIrHkaiwYUpykv5gBVsyU1hQTzG5aNHJadvYG1YnGlUkBbI9peUyRIDBGgtPYmwN8RqKXd4k0xcAvbLSzyUPZfsEI8ODjUHFwHd8hI3I/gvJ4HPnjdlSps/c2FRvSYLOisxhIloVmadWMMcRfrW5DF9ieae1SwWAAmZ31FruXN6GgFzHHtr1NRHKauxjH1OIolNqtRay3U1cfblUCphaHXV5JwWLQTXb9ibV40jW5CahZmThTARNEFzEG3McqihwJI3tpsLQlwth/7nrq+GZjjUKcNk1TRhJdDhGHmK1e0hbes4keiNgZ6bCyBF+S4DnrHNDKekd80mNjVsdr18I+Y9aRnJOOlwqmqpev3sttpYFpD6d5XAL4kQ48IFOGzgVah/Q73vUybl6IOl37F/KEvmlQn4NDG7KyygeCxWjJXN4Fiw9XUy7SzOjy4HgnZgfd71Tz8CCbhFTiTLOEEBcurHJN4ZRc1y/yMEV+yO2iF8730QLLT0Vl82ej48tx30ZFLzPylEjCeK33I2AynknhUc25D0V2+QcIftCtuNuMt/FTx4g/+v4C4dx0ZKTBYxV7x5WtI+2E6PQvI2nIRA+C4ZwLfS9FnAoFLGMG/WUqcqrCibeQDBLhMJRKTbzmAAz3EfqCA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a5f0b6-9cb8-42db-aa90-08d884ff02aa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:30:07.1170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwSl/ghSWW5eRmSQN2ePmKxdWXxO46NT+fuT+EPWJWWKforA9dvB0klb4kgb/ZL3klV+gFaz4ZCNc8DnSvhEGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index 375169fc3dd5..158f2f41571c 100644
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

