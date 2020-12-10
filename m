Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD312D638C
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392531AbgLJR34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:29:56 -0500
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:61760
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404135AbgLJRQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:16:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnAS2i/5FjP9//XOAWQhco90/gcyjowJMJO5LulC4t+uII40nlUMhUc61ZlJLsv92kxbnuC9a61iJ3qoCd3POK4BsTDb/TcMV5ORlvbH3/LUm8+LlPKwglOGw3z7IBN4bAvDl5DWq/VPvtnd+BQYMK5fy9BR+3JtYZwe96RyoCf+o26s2iDXeoK5DCeCOQdNlR/s1aWgbEg2LbHd/O1jZfhMXrRD/f6W63/putMY9Y90v0GB8nsoMF/mZ24doWuzqyXejHcIARg3ORLnF7Cad5DCowEHrabK6oD95XUKdhCGDDMRxTfF85b1dtnB6XCBnzTZiC7N1A09M7iVBKDb3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rdrg9xdmCo1Mi+20Ub/bjG9z6mIYPEDGliwugujXITg=;
 b=Se19AMLYJFp9pjIR21wpX/DOrtND/AfjTxnH6GfAfNNG7Dzf7XjOR3yQ6/WQn5BSE2KDg409w74QxJWOkLAaQEJyiIEWvZs8c8XINy2eGa2XaEYFS4KL1nDN2FF9pTfmbpai+Uq9Rt9DjyOo4Wd3Q6qYa03t/zxQXK+Td5iJWuuMJKijdTl9A8Jzysx+kTIjebmxpQz0VbXAKwbiJwiQso2BtRWkfgWCgUEyfrO4vqRUN0tN2hBHYj6DJ/8rH/r+bkn73VNv1VRkVu5lHB/T8IUYTYx6sXraxLeqjitRDSxSj3Rm4wHbcFQritr6LhmXQRizEHxYhmjACi/Pt1i93Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rdrg9xdmCo1Mi+20Ub/bjG9z6mIYPEDGliwugujXITg=;
 b=TwGOrA3a9F4pBzd4sqAeJ31Mizi6j3RziARWVB2EUKsIn/PrKAVNImZRyHbkFNTAoXHnrC/IoVaUJz3YHQTc2ozD5YtLOILqabuuwXVgH2x4ZKLckiburaHGuIJRy6Op/OuI+ZpLX/Jpn37JBXF8xVzWBxauLRAoQXVC1YBBWfs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1350.namprd12.prod.outlook.com (2603:10b6:903:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Thu, 10 Dec
 2020 17:14:49 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:14:49 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 30/34] KVM: SVM: Update ASID allocation to support SEV-ES guests
Date:   Thu, 10 Dec 2020 11:10:05 -0600
Message-Id: <d7aed505e31e3954268b2015bb60a1486269c780.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:610:38::19) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR05CA0042.namprd05.prod.outlook.com (2603:10b6:610:38::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Thu, 10 Dec 2020 17:14:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1030eceb-cbe8-4d4e-7480-08d89d2f19c1
X-MS-TrafficTypeDiagnostic: CY4PR12MB1350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1350A3B8F004B0A4E1BF49F9ECCB0@CY4PR12MB1350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eSTRoIAhqVc5sE600OVW/eKO/YCFlzxpUFO6+eitTx8fytW+MQ3bu+xUpDMzjYl7xTSkTt/b69QQH9awEaaTSy3iMaUJ9t6GMDB+9q1U/G3j7KJlHS2CpcMq0qtIc0Du5qw7J79r9fPPkqL0nbP3fdSsdxqC/J0gm2DAymOPdK5m8FKiwobpO4bs3qWSt1AWFAaAF95Du6MY6KH5uW680KlfuhRPym09HCDMIoei+oDbgdeZtyGn61tUGswjofrrc/RNi9S0AGZPfGYnd6SaHyla0ImhNSoU/EiwniMOaeNjvwmwqEahrjNR4ZqXP+W+Yo/oA+sHZkpjfd4vg0GXePx+vyWFjWds7je4V3YK9/uwQzVY81gKlwtVVrht8Qeo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(6486002)(8936002)(16526019)(2906002)(2616005)(54906003)(508600001)(86362001)(52116002)(66946007)(36756003)(6666004)(8676002)(7696005)(83380400001)(4326008)(34490700003)(956004)(26005)(66556008)(66476007)(15650500001)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cMmuDGrrsSArjkVyl8CWHguCUYGCjejYcBu9of07oVudWpKdU6PO2+jpYJVz?=
 =?us-ascii?Q?v/E7BpDheGzWjfBDeWXgeq4GNO2k2DlDzzMtX8YiAqT57NcnqHk5mN+Q6mds?=
 =?us-ascii?Q?ugfCCnDmClr+MVTugzU9fW+r3eKpNLyHc+6u37grQZOOnYGOmJn557YH7O36?=
 =?us-ascii?Q?LzXSbUSkQTf1VJCz4DmNGinkBlPwHk+umiuyRG3qgHvfTj7o/6VBRvX3rSon?=
 =?us-ascii?Q?dP9BxcKIWa7nMW9lE7MqfNKaq7APw9glZzytRzu5KHDzI7QdeVU/sRyMuHaN?=
 =?us-ascii?Q?dhJ2amXstZ6dZFowu2rXlLD54KBtSM50bqXbhe+93d58ahRgS729h7owcBK4?=
 =?us-ascii?Q?Bv5WIaDyW80I0ydjqU7Zn78Z+dJipqwGSlSwLpzO18mr5HyD97DuRqp9VPcZ?=
 =?us-ascii?Q?GeE+VI3i2ChsZCRVc+NYHxx+I04xymrVy3qdIkY7AvXBTos4wM+LvHovwQ2F?=
 =?us-ascii?Q?iECGKFwNyWxOQfSXU3XinqOYGsOAxgt/xj0o+IxCKJMAE7q0kpF4CBgWcgiH?=
 =?us-ascii?Q?6QLcBcQ2IIeVKqbMKVaTkVX77hpxtsrEwwY1q6bLiqHJcBOeibaRYeyWCdxy?=
 =?us-ascii?Q?OmtLgTxYY3PcUD+OIAJwxFZ/9aLniP5pvQ+r8jI2d1Yv3M3OK6+csn0waGpt?=
 =?us-ascii?Q?9XMwJ1+skJvHz+VVKdsgHYQah+3rU6VLfsh37b7fYNMrKx7yQY+6qEd2oTrE?=
 =?us-ascii?Q?UUqZfBwq7yhhQgEqwz7fyaymkgEQcu/yWmgbwK1eZ6duInxUy/DnRwhMSqCA?=
 =?us-ascii?Q?cT6TWzzgzLsLnduBc11VWGK2UqAfDDL4AuagQ/VbtqBX1H72tzSLDx9FkLmA?=
 =?us-ascii?Q?DOesSTphd/vDtVpZ554xTbCBALTDATq5NWnvu8bmFiwV+tL8TXv3629NmQJP?=
 =?us-ascii?Q?+QMvLstEvXiz+HNK/7YLG9WZy0oKyZeQchnO29Zk9yf0YAammhUvfJ34crJx?=
 =?us-ascii?Q?07e9R/ziZRkqhHuZmd9nKfpWL/d85gWxNK5bXfXZ8hc23FpOBDYtN7ZKHo/5?=
 =?us-ascii?Q?BP4f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:14:49.3257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 1030eceb-cbe8-4d4e-7480-08d89d2f19c1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8d2YMUdpVnwL/GB8YIzeS6ob0fRZB2obEKfauDshwuFbVzHbhVWmgs5vXqZxkpOTLWImwZCFcLPrS8VYImq5YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1350
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

