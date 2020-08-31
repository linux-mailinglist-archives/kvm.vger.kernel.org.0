Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3452B257D7D
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 17:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgHaPiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 11:38:11 -0400
Received: from mail-dm6nam08on2072.outbound.protection.outlook.com ([40.107.102.72]:2625
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729367AbgHaPiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 11:38:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwixvjLXwdWBYKHm25nGt56zo6QGp3LuS/owzHjj8HIPZNp7M9+MCVeBk151xU11KYpOW+TuX7pLDQhZBg/T82e3Ec3AEiHRGkl6ibIYPCm3G3YxJ6/BOlAXYQCUTnJXcLbZ9ETQ1YHc5EYZNzuxWTODmkhLGunTeDeWcEx/YGpoP/aKtizQgRwk7rD/ZidmzuYfzIr+uf2sHBfjGWyQqg8C8wE7ZWaSDLvETUPmOTrK55l6yykhOT45prck28YC8phCipV13IbJqNQM7rAT3GdST7slPej+5iCOI2+6y9iiLx42LQm9kXU48PItqMxVwJCcBAUYfwk3GLc+PZD4RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5v8tLZ5EMykDQReg1Sn6uVLFLb85eKqfhkZ7LCH/KsE=;
 b=K4uf90xg+AAuMpxNRBBMMWU8aBkXlAe+rjykQkNYhaw0vJb9le9GAhHSp2my4wO7iLMNQV3GR3s+Gx0rscBnnriDcy9LBDdpaIT+6hIKrSJtH6ocDAiNF8i/xBQRbDmKC8lgdzsCew6lQs2S+R2C0XVJ830j7jDKCpqhOHN4RPIphKvL6mj2CP4+5wFmG/vC4b5nJEviWHMso3hsn4KjwyL6FtQl06SqOOjiCSlmpedPHjbMjrJY4PBixPU5VgUlPIHGWmVt+WycRwyVd+qCc/fzmlJohgMpo+9yIULD2MhGr8PcFw8ljWYTnkgWBoa1qbVkF3mdEqwZjtAV2OF5rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5v8tLZ5EMykDQReg1Sn6uVLFLb85eKqfhkZ7LCH/KsE=;
 b=CchfDdmOVKAfhEjDZjZzB4y1EY5MkylBwS4R1cgUF4UXUMWO+rJDGJsiBcco3XP1ErpF5XM+xzalh3NQQgsH0jgCb9tl/9GvCJBGpAFfJTy4VbLkrfkL0e8iMEC4t9lsAYzbT5qcyKHniM9ZvFGMQpBP1OYbpgk/L7v4NLD7Arg=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19; Mon, 31 Aug 2020 15:38:02 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 15:38:02 +0000
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
Subject: [PATCH v2 4/4] sev/i386: Enable an SEV-ES guest based on SEV policy
Date:   Mon, 31 Aug 2020 10:37:13 -0500
Message-Id: <fac216062a7914a6ddbc76ec9ab1e8f55f437073.1598888232.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1598888232.git.thomas.lendacky@amd.com>
References: <cover.1598888232.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0105.namprd12.prod.outlook.com
 (2603:10b6:802:21::40) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN1PR12CA0105.namprd12.prod.outlook.com (2603:10b6:802:21::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 15:38:00 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d5244da-23d6-46b0-b62a-08d84dc3d851
X-MS-TrafficTypeDiagnostic: DM6PR12MB4484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4484974D326C07692FD405C7EC510@DM6PR12MB4484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zCs2wjvIHkWROqgIbOKwu29BmOQtbQyTR3lx1O/pby1+XkUGpsuBjbTdm+kb8ltoHEqMj+aaDMdkXCTWo3Ry4FbCXPMGBzR2NApfbIJapFJolO+rlt32eVFgHwnbjs/4b3EIvYRPfE4WFerYpXl1xP9RGhqJ+6bRPgiqsn16C2UidPg9Yc+qAMO+NBhxmluIxVMMuJb/yxz9KzdIA5UrSxC9tcmetogeYMGOvMH58Ak7jeMhfZBdHBAora1O+gdtj7YUYz0CQVOHFGNtybPUkteoICx0SGd4OBeUX4xKl5Ix6AwI2u9ozXcqHS51dzRshLZSdqXY7Y+p02++RAyRnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(54906003)(956004)(16576012)(7416002)(2906002)(6666004)(4326008)(2616005)(6486002)(316002)(66556008)(8676002)(66946007)(478600001)(186003)(5660300002)(8936002)(86362001)(83380400001)(66476007)(36756003)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2T/42Q1+pCntur19Loj8ATBlcarFpByAB/kZnyRZmf3E5sv9I1kmrWMM2BDOvhI2GVpcvyndcoKxXMVZ7uDXjs9MXtRKROKMJlH4c+O6s5NFeEvNVJ7ysTF/rBzqubxR+bhp/F/1VlmdS142go491cjZucMquWgiUblfCFXf0YhoBD2f6zzZZhIg7gr1vXUL2NUcWjwCEawKP6SnKJMUa0+yiM7dWOx/kdrCQBu0W+vvakxUwIQYUI34PbO35u8Zgighky/XNmiQoVnXjOBbRwZQPsQSJjMoGrvfFK1DUx+FyLAXv32Axz/AMmi8Fzs7Gw35CQa0gOJINCzl4AoGiUQ4TmhUnPuiamZjC99MhsTYe2S55tcFZVi1Zp+/bu48xh7CtsXNnu4m56LGmVtN9ApDyTmaOoojmk7Bcxk0cnb8D6UuhWZ2uxkJzPs5tWVO/ODjIVYvws7qL1o608w4y4b4ORrXQzpOVo+R6dyp7X3Xn1C+Wwo2eRlUT+SjReoIzhVSc4OovPk6593vptr6PZWvApKv90/iQV1IEXh8wHbiwMqlrfm/LXOi/NIRLFbV6eS2FiksSBnpPS6uYmGkU/0qQK6PyTy9efvKqgvJl2L9Xuqa7XCAYeuvijdzS2JNp8A7fFrpPbZyLX68KZBK4Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5244da-23d6-46b0-b62a-08d84dc3d851
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 15:38:01.9638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtRUDrlZzqyOFf/lRPmZdcua+6jBfbeRVfGEPZOvtyKqUFfIFa46VDy/PJQZtDqY7vvlG3ghFWoGKdSiALqd+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
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
index 0bc497379b..0fd142abe9 100644
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

