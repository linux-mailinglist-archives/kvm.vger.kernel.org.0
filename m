Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FEE26AFC8
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 23:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgIOVmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 17:42:24 -0400
Received: from mail-dm6nam10on2050.outbound.protection.outlook.com ([40.107.93.50]:30689
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728124AbgIOVbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 17:31:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvMRp8ykQ7ljWVSPTLhFhECDgwjC6IdNio7GrMQEiv/ATSP7flgZlUTBGP+wv7VmRmNzaoRyhlzIuJmu52g399n6QThCGYYwToXbmORBCoRKV6e1o6NoTimtKIIzHhjUTUP8xMI3tcW1nllgabZTjCA+FL7dFTzVMMLMZiJUzzsUw6iOf1PKkBaPz7NtglWrCu0fVlIBgDDf32EB8Erui8Bp6Qef8QpczHKDwS43xa8vTvvhRnV92CV9P31JmDLUW0tXFO7Xsus7lQIFqUbSf63AMADnXuZTv5XCbaTN6gt3CgtAAy89TA/rinEbaoDPJB0LFE14NUcIK7Fh1gDG0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ycV0xdRknSZ3vAEGYSJeRPZJ+9Q3xBqw3WL1RRP48E=;
 b=E/pFPejiuKS8zgFGSjI00roR8l9MUUwO6UiWjC2q/+6HU/cGKjXH80lh/PxTBV8z8Q6PffcLihFsVbT4B3b0jnPfNrBJkDpn+t0C+cUCNqHsjLvImo6Qjl5CGahs/CmoDTxShoVFq7lmQ2AFa5dF/Ye2I71ivaH/iUSjHHdasfCurkBkWqlTd0KlDaopp+7RDgGo/RbItboq2QUvrqtm5kEaT0nlN3LKfoI1t2Gag52OIKuevcKylrbV32jKh20OZjQrnCwjofuMwyIddC1yTH/stmLTdtQJL2uph4SOdL/PCoMRJYrWK+S68BFYQYhc03Fr7zZMiyn4Jo9KNefF/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ycV0xdRknSZ3vAEGYSJeRPZJ+9Q3xBqw3WL1RRP48E=;
 b=A9sNDD63jtY2QQbZ5pSrjENuxq9GnIdyPe3WQ30nwc1AQr6LHjEk4Lk5YB7l/75YzhAg7jP8/XscJGHgqSjYV8+/LQ5PPrqtAhU7E3ANZq0R8z5gTxCtur5jhjHdF2D+n/SS/dMAcVhQaa/6Kpsu72E6j75FMQuVThoCvCDQCio=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1607.namprd12.prod.outlook.com (2603:10b6:910:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 21:30:42 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 21:30:42 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 5/5] sev/i386: Enable an SEV-ES guest based on SEV policy
Date:   Tue, 15 Sep 2020 16:29:44 -0500
Message-Id: <8e560a8577066c07b5bf1e5993fbd6d697702384.1600205384.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600205384.git.thomas.lendacky@amd.com>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0120.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::22) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR02CA0120.namprd02.prod.outlook.com (2603:10b6:5:1b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.19 via Frontend Transport; Tue, 15 Sep 2020 21:30:41 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d0bdae57-f3b5-47ce-5db6-08d859be9951
X-MS-TrafficTypeDiagnostic: CY4PR12MB1607:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB160713CA51DE6DE40B3F6A26EC200@CY4PR12MB1607.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QphyhJbXiqa7nYb4sFtH+ax/7xNmay9vwA2q9Cu+P6Ox7FGuS7VMjOqRlg2MFDN17ZzeyQrhLomEV810IbTuCmsXuE66r2lYAqQX8dU5SF0uBMiNMocEy9IbFDZvbhN2GzeLt7a60PH7dc9BPwRgLArQyCdWVgj++KUqF5sfs8Ny6lMw+EJ4NGM7jADXnWhRL/r/ITrZ6xAgVV+V+4vLbeXue220t4Ami081Vxd9wH8JlZ4JF4yygbgsfpfknB0SrOIKQ7ACWu9u8pXhc332rqHrQJBKT2bIb+bxtKZAPv1PyYzav7pi8YvPPLkfedkpUU8x9+oQ+OYLEtp/GunnRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(5660300002)(956004)(478600001)(86362001)(52116002)(2616005)(2906002)(7696005)(36756003)(66476007)(8936002)(66556008)(66946007)(316002)(54906003)(7416002)(26005)(6486002)(4326008)(8676002)(16526019)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 47GMNjAWOuJCdlJy2GSLH/1ruByqDPly69GECDd9SQUAnLyIPLv/tTCK7RHsJc8tx/vG+Z4mEDX5NujLTEMQPwSInB8CbOn3A2Aq1IyE62mMuOyHSwo8/GTAqKLzn7jkCf5wNionEB0AIKhqTvEIV2n9CpJ2pOUucRSz2X9Xazm/DJdhuag4r1vT2OPMAJxSRBErMhWdtyFharkr3sJtckYR72Mvghm2AehNrKAn/omKjYsJnjI1CYCRYGR6LqSlARBcfHk4RJkaQc0ahnclbEdAprhofWBqMlQUXPb6IAoP4BnoaMTHtKfpWn0KsNhqqi5pR5Zv8vbRyJip1psr+P0SW+AXq8Zxgv0Y/suUxiXBXwLDRK/GtiyIh3250IlJdzq+2T+Co2Swt0wFzMtK+t/Ez3Q5AKHHiQ3xKdE08+DzI9snfHf5+krIw1ihcfy8ne5m5boujGNlFCMVvisg6xSHa71tsuKp/bmVQqZXW6kGexT0XDixyTrULVls9M2JXSsEuQISofNuvgxQ5ml+UNSqyHhp22Udouf9+6jaynbWNo/sq59ugxozsisMjJMn3SgU3G7GHHG8yeTckWl1FGjmwG0Xer/ij57N4c8miYRaVSZEfyxOiYH5mx5OFJn3yGTWbtDTnd0NZwuXQu0LRg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0bdae57-f3b5-47ce-5db6-08d859be9951
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:30:42.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2JkiRUzGHCOrSK5dh8YCB6V0rjvT/6VOCHfdhWz2VWvv6zS55QbDBor+oa1s0JyR0dChXKzMIxbQTA62+ReL1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1607
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Update the sev_es_enabled() function return value to be based on the SEV
policy that has been specified. SEV-ES is enabled if SEV is enabled and
the SEV-ES policy bit is set in the policy object.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 6ddefc65fa..bcaadaa2f9 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -70,6 +70,8 @@ struct SevGuestState {
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
+#define GUEST_POLICY_SEV_ES_BIT (1 << 2)
+
 /* SEV Information Block GUID = 00f771de-1a7e-4fcb-890e-68c77e2fb44e */
 #define SEV_INFO_BLOCK_GUID \
     "\xde\x71\xf7\x00\x7e\x1a\xcb\x4f\x89\x0e\x68\xc7\x7e\x2f\xb4\x4e"
@@ -375,7 +377,7 @@ sev_enabled(void)
 bool
 sev_es_enabled(void)
 {
-    return false;
+    return sev_enabled() && (sev_guest->policy & GUEST_POLICY_SEV_ES_BIT);
 }
 
 uint64_t
-- 
2.28.0

