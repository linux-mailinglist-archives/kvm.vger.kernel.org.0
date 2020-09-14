Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DF026967B
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgINU0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:26:14 -0400
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:56449
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726365AbgINUVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:21:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUXgxgJHCdhSmyQF/KOypXs1zCbsgu2UDcpD71GPaAexWsfBDw2zC4fw9btksLLIoegQc66Ryn/OJpDe1DZzqURT5X8MM8OWL3xmMTvNmG7ijR4XvODOwBVU6OIG+8IozHEWs40Wb1wt2yGwK1zHTya9v7Qs9PhRpa7TjtnHfPQclvgWYj13/jvS9mRSDXVJ0AgLy1sFDBuMPbRsYih2dATrvkfwIRAtlQlqvKta2WebjD1lpC2IlEDni2TJSlmSUGnxmpMTXkiyVxMw4jkK3sCKVorytgW4bL7+lYJCQQkOGs6VowPnpNqve0+i1yRzndt6PQokZaPXPeeFlh3S3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEQ6FB9VGwkgnblCuzjmRlKwfh3nECSEgvXesiXIoxI=;
 b=HogTov1VrgFn02Do2lRphZtAQvB/KiXSLmW94j+rwurd1vnS0+2SYnvJzdql6t8z9BpZ5ptbZ4YcQ1FxY89gDZLzljoG8bqWtfaH4dQoMAnb5uWDOHl7q1VQYantiS4G8BQq7aHKh/elk8n1EU/UDQSehZ1Q2y9lxTmSklvCLmt3fK5GE0qdmGw7fBE8PbtALeUe42xH6Rw904m48TuV6BgRK2XWZs8tvhPtwHz8jVGq35cjeaSXBkfb3ADMWBya/vxFPTdKZGeD53C6M2qsMOTiu5NekKHXnZza5TBytbBWxRj+WtWdZ0W7SjsxuLw5Oq7zOLV+dB+b3EG8qna+4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEQ6FB9VGwkgnblCuzjmRlKwfh3nECSEgvXesiXIoxI=;
 b=k3zzsAkVsatwiaxfaXeyMqD6DZApH5fOiqHlTLIUXyRKKx1VIR5EEWOwmukFfaHZrhlBHStKeeEE4CXAA047xbJLXgn0yuRbqmHwXqAZMFtErAn7GERjuVP/VadXx6phVN9ir41W7cRb79HCtAeIGJdwfAR0I+M4ZxXjSJNAFok=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:20:08 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:20:08 +0000
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
Subject: [RFC PATCH 31/35] KVM: SVM: Update ASID allocation to support SEV-ES guests
Date:   Mon, 14 Sep 2020 15:15:45 -0500
Message-Id: <aeb8bb44fa0187b05bbd7399e103ac871432b091.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:3:23::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR13CA0014.namprd13.prod.outlook.com (2603:10b6:3:23::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Mon, 14 Sep 2020 20:20:07 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2a8d3509-a933-4f82-a702-08d858eb9352
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29885E39CA0EFF4D25E5BC9CEC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z2b3d7+zsMODOGaHJAx0xa+N+6beV/f93Ziapmk1mjEM8MDW4CD+mrBX0cUxIHv03mM3C2rXKREKlRmA1tyzH8+KmLTAldJNjLAr7Pqbb948biwI67EQxHX6TQyMBDAIqStuBDAwTbTitJ8AqA1YFusT2WlVbWOxp2boHpb2h5GjCUhywWoXk05h9bk5mxZPbHBxILEaDIR0l2qOzh8IBY/q2LED6ioTIy7+gy04UTA7QXsknjBk92AttEhvizfRYnQwbI7ppfteXNHO55faA2P0AKOVpzKCEMAvdV03WiS5j3ujPBimF/bm5DBC6YdHHHuCDcrFi/AyqIA+uQD/2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(15650500001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vRtdn6OB+hsxTgteiz5114VWzLZK11RkMaYd457U5RCshf71a64ioVmjcNP9HjOQZOY8BK1mbiBhi6CIZIYNJ2YBYLueImtZK6mx81BFYXGDL29sxaFycmvVMoFXO9NAPbWtuleb+pnUtsI+pytjkZzobLvqo5uFeLAd2XbyQVklJf7KtCdf07jbkTb1ifeg+mep+LtJJiyDoZeWYKHprnm2/MFTXQmAybzQ5ClCguekgPYayIK9kz2l8Y+VXzCC/JtdWfHY0pYaVZMJxvF8hWDo8O/sJSLXKd20KwgjpCpROaoHbMwJjXzTBSSfqBaI+Z7Q7u2+FJY3e26oKdmNUVeOKaoPPsvOmGgvKscbdK42dH064CqhRNd0rUGzLY40kMzqvtH1P73vuFPREWJmsQlW3XYxTQ1XFY7RfLuyyE/O3LP7qLHGAoMl1jvTOaPX5gxryZfZx4U/H71O1l63VX7db7Qu1BSilZx1vb71mXT/7gEzEHr2Rit1zzR3cFNjYeDi5ePTUy8ULgalF/yGlAo6GMym4wFeH4hrxkqDU4WuggzhuKBwbTa7sQZEPZ+sBrBz5EC89xa/Kd9DHjxOORhvxbML/weyVVkZP5/CR5+Y+PlHotNVpm4lZGO2GGlpBXo6G87zx4RM2NOsDrZK9g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a8d3509-a933-4f82-a702-08d858eb9352
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:20:08.7090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fwsz+NI0UP0JbxbxOUQr/sNP9b1uY0GGQx4gi+kWJvEisieYVVJwvVqu0foYyrHUQ0pd0r82ZC/drmk2numEfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
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
index 15be71b30e2a..73d2a3f6c83c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -61,19 +61,19 @@ static int sev_flush_asids(void)
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
@@ -81,20 +81,23 @@ static bool __sev_recycle_asids(void)
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
@@ -176,7 +179,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (unlikely(sev->active))
 		return ret;
 
-	asid = sev_asid_new();
+	asid = sev_asid_new(sev);
 	if (asid < 0)
 		return ret;
 
-- 
2.28.0

