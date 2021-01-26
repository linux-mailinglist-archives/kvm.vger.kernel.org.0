Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459B0304C3E
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbhAZWh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:37:29 -0500
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:13408
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392634AbhAZRjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:39:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmJOQlcjcAYJbTkGHvBCeeYD4JUF1uR4JCMsUetjz3r1NqkVgWtmXW9/iFCOsrf2rodIP7D/i8Wb6B3ctawSQSoPGCTe8mlsmDgFZ90MAM7MPCBwxvaWaShdztoNKIVsYWkoEwb5CEkuOGE5SvnUp0ENjIwUKBxgXCa73HCeF9+vDJ0xoAgJb6YlOTCW1EXC6IX+8UrZpjgynRGirnL9SSj27aAzwjsGPaqqCVlki39F3teU9H9lgx9nPUv31BJyymk9xD7rjr4XxthX/rntfhZSykePBbkwW8RJu15Qzta4PcK0Zolj7qpYFuDCwbU4JfmyZWk+cpQjjpJ3DujyCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WjCjqNwQxZDZUw3moMX0D0fUfH7UK2ltKPE5+az78M=;
 b=P2iTDyC1hB2DGVhsHArgE/Szr+AT2JHHzvYokqB8tuTaLiYZxhYvsYdmGcoAdJiF3EvcwjwelaZxxwFIpbboE+4e0Qv7HlYFZWloagfkWlno1+BpB070mYq48GWrCPc5SR6KvP7wBfJu0B/zOU7Qb/JPC2hRKQATXEVSEq4hqb2XpDNOu6We3raS9Ew1MoyJz+CfVknMRNHqqv2khiImsTvHiqqtbFwTC/oJBn48HqlUw7kuFnyDB6tkKYhZb4UaW1TEd4cAy2mgtlE60bAjWjdWfv8s8UFVKIhPz39WyhdM425vCK2Ktwrp1VdKFSuwVHfJBDvGjYsgVZqSZ0097Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WjCjqNwQxZDZUw3moMX0D0fUfH7UK2ltKPE5+az78M=;
 b=rrxLVoOrlJOvHungGonvso6PeUVFEHlWY4TP3OaUPPdY1jdx5ABwZugF3wKhdb8lDOUWJo4fO4Iw5WHO0rItC+X8F1oE6LAGJ8fmt8L4O4hPDclZDDN1097X8dfP7W/4hurF8C34dU5UkrZlYw3y+PcF5GUETm2zoQupvcOvrdM=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Tue, 26 Jan 2021 17:37:21 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 17:37:21 +0000
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
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v6 2/6] sev/i386: Require in-kernel irqchip support for SEV-ES guests
Date:   Tue, 26 Jan 2021 11:36:45 -0600
Message-Id: <e9aec5941e613456f0757f5a73869cdc5deea105.1611682609.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1611682609.git.thomas.lendacky@amd.com>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0220.namprd04.prod.outlook.com
 (2603:10b6:806:127::15) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN7PR04CA0220.namprd04.prod.outlook.com (2603:10b6:806:127::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Tue, 26 Jan 2021 17:37:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a1aff093-a15c-4b33-6458-08d8c22108eb
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4153661131D6CA766B71253BECBC9@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z4vwzT5MnsnRGPnwAlXM32A5MhJ+oQ+tx2huGnt3MhB1jK9B4IoDEQlQBVBbjgLb9PaF73I7OWxGsl48d8jscSveertwa3RuZdi8NSvT3Xp4hBbotg6fHE5koCpcXCwVaT27grva8nnT9WCBiMKSmlKXOzbA20C4u8ggnjXLWg0+MaUsgRttykGb+9wxV04KNQ45wlJXgn7HN7sP8NLTTqolnAoWqQNalJ3sfXEwYFvObXoXs2Gx+ZVlGkoY9sT3LczLmvw2KSpaS29vUXwsrSYpRpf0npJgNgm2dj4/pnPpqajqoUEmTodvbkvMTR1X4Zf+acrqEyPdKy6tPOBl4GOLfU8d2y62/olH0jMirRZNYxBnCAivdT2PhRoqHxhrcXc4ul6d8w7RqFlO/64+Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(8676002)(7696005)(52116002)(478600001)(6666004)(7416002)(4326008)(2906002)(66476007)(316002)(54906003)(5660300002)(26005)(2616005)(956004)(86362001)(36756003)(186003)(16526019)(6486002)(66946007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rpnfQcbS9IUw046Y/QXgUGeERf5Uf7rOeSX3KZPoWcNj0hLWvM2OpFPBTFpb?=
 =?us-ascii?Q?HIAa1qDdvOqebDaz+GmrOrfs9hUBmQrzENtS7qfXeND6t3I8mTUWdPIe1fqT?=
 =?us-ascii?Q?aCSYQ87OgBhGsuYzRztziwAzGGyQzY6TvfDqE4eXpXz4iKC8yH+/a31jlPne?=
 =?us-ascii?Q?QEmmN7kOcbuUps5A4y2PVMdttAIL/d4TKwCjWNTjWe+L2KrNcJxh5Cs5jcK5?=
 =?us-ascii?Q?tlTS3izJlyMYSVnX7dvNdItqzK8Y/qgnh2yfJZJZ0fFtPQriKcpSbH+Sqgsz?=
 =?us-ascii?Q?5DoONepu3ax1Cix+WLIb+wJ1aIyg4MwGuDt6WIXbd0vX4Jk0003pnLNPpZSw?=
 =?us-ascii?Q?lVy2SgggMWLyeNEvc6J69/wcUvabs/cVh0Fb77TK18m1x3/18wm4gFJOV2FH?=
 =?us-ascii?Q?D2z+3D/7TUHpW+NVINrYli0+8/yVHqqWy+NKrdCtRu4vhfylMx3at2BYNz+n?=
 =?us-ascii?Q?qKzCID2B3bmZDuF1XPuPEYnRD3NV2+CuP/lDDzJzzyTQ/knp00bAV2HAiw+l?=
 =?us-ascii?Q?8HzH/Bgw2Vn0AlwKGKeThxmH9kxY26PvIO8kLuzk0xnkqDEO5FyBx2Chf+1N?=
 =?us-ascii?Q?BPBTPpymp6eP6IsUkjTv3p+PtM8xQkKX95LYILwEnHQla7WGK3kA+Un8ykEC?=
 =?us-ascii?Q?pKqFB9uc5NjJFKlrdLo/1JU1y1WNfoP119Mxz0I8CDnlPnlkOkH2+7ubUfiN?=
 =?us-ascii?Q?8X0WCJKt4HwWPeeCZznqaKd2cMFSTcXeFRc4GV0kNpKfngk8xS9AADdC7QCi?=
 =?us-ascii?Q?2QA3Rly9lbFM6QpTSCEzcP8ocYdcbt6D7HYA0GZKFLvJxZVSDbOru9Dav9pO?=
 =?us-ascii?Q?LMP2cholFd6gXquqFpKHbpO/md/rK+Hcg9ouwATqYo4nrooufA/pJdSB/pyx?=
 =?us-ascii?Q?j1XitLKkGvpTbosv5eTj9iC4gX+AImbWBu76n5sAEsSEciTjyE2h4YLR/lBX?=
 =?us-ascii?Q?6lIPp+YaGrfjHc3MNu5M0xlnZpUM2c213NVrk0waLz4MHoqJQo55nnT3duCm?=
 =?us-ascii?Q?5zcd4xwUTb7OQP9dF6/6ENXG3U46ngTAEIl5qaqAO5djmUxFar1fSypBnRKr?=
 =?us-ascii?Q?jdlBdvGs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1aff093-a15c-4b33-6458-08d8c22108eb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 17:37:21.3968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ChVEYz/Svh/X/msvDkfd92a2AJyma/f7jxB3BGvMau2zFElGKlWTYeDrkjdqIAiLVPM9Curg6F8lpXR3dfDMbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In prep for AP booting, require the use of in-kernel irqchip support. This
lessens the Qemu support burden required to boot APs.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index fce2128c07..ddec7ebaa7 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -776,6 +776,12 @@ sev_guest_init(const char *id)
     sev->api_minor = status.api_minor;
 
     if (sev_es_enabled()) {
+        if (!kvm_kernel_irqchip_allowed()) {
+            error_report("%s: SEV-ES guests require in-kernel irqchip support",
+                         __func__);
+            goto err;
+        }
+
         if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
             error_report("%s: guest policy requires SEV-ES, but "
                          "host SEV-ES support unavailable",
-- 
2.30.0

