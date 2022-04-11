Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A8C4FC3C2
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 20:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349003AbiDKSFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 14:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239422AbiDKSFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 14:05:03 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AFBBF4B;
        Mon, 11 Apr 2022 11:02:48 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23BF185Q009337;
        Mon, 11 Apr 2022 11:02:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=Tw4nD6RYgOURB1T2+NP2lq4QO8mrxoysJhPXTYbwBFQ=;
 b=0HRKIaxvp9viuwH+gzozoIUxKmq89s//Wqnr7QOCD87CiP5K1v/Nr8YoBXhZYw81ReYb
 uI7sy4HEW3mCI/WeF4YoNsyB0PLQCYpZHbSBXWp+xeh7Kke0n6Ctu8skyU8zpiM/vKX5
 Zz0AGnVFoeHhqR4KR8BEska/ftcL0tguPOKWKvoVZScoLx2OhXR9ixvb0QBzVd8K8oPl
 p2wPceVXRvh4oZXsj/J9zEm3q37l9iwhGw5E1TAS+spG4z0ZZ7q8nt+xcrs9+cJpfcpw
 2q2SwLCq9rjgyBU/iRnnf/G6/SjxN66CPLUx6UZuP2pa1VcS6WwPpcH9KS4bIbLKBn4c zA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fb9pvm2et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 11:02:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4uCfQpj9zO2wn10fQOkzcG2OoMdKO7mwxEbuH2J+WDPL7u2C1unlp2RsWLdZoQxVlNsJoV3p2Z5tWWyP0qukSbNsYDHI3T2URav7qeEp0yUqQFYvwvYPH9tobtf7u1XC01vzSyq9reXBUh47f3L5jKyq80y//wfRzYx+VHjdkNyzsVpPPuA6Va/m3dKNNR/4UHSspJ60gbzwnRpHCFe40lGCSzwH8/RfZL7vlfnZLtS3Zb+avVTPhQi0IcxVOHlYbNr+s3Nc9yh2OcxZewlTYC9GVx+5EONbApf3hoSxymYfh4N1EMw+Y1igLVOIksaWDyroje7pxhRQx65Olycog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tw4nD6RYgOURB1T2+NP2lq4QO8mrxoysJhPXTYbwBFQ=;
 b=RvjPHGCN0iW+5uOMjz3o4kOQ48p/ITnNTzubh7BkwykX4/W0aoRAcnA2hg0/g3jy3zVokxn+0r+uBwMTgWCTGVNPyAgBYj33okKj1v+rX0VjVDkabQI6fddwb3FfslMBXEtCesFTn0qZ6n94pdzv7g5WxmiUOXXD7qcjx8CkDToCrIT2yRENJXdGi7WT1Mt/W/jQfg3f2MliXnqb8NBuEpdAtga1OhHeUvAQg9zf5iiU5zTXaGAZuIsVYSEIxlf+2vgYwoAdXNjcNTETo6ht1jNpP3xT9mi+fOU0z194+Fbi4099p+murPgwQef1IlPbYftMKWC0whOdtrgZyEFISw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by MWHPR02MB3326.namprd02.prod.outlook.com (2603:10b6:301:6b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 18:02:26 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 18:02:26 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Jon Kohler <jon@nutanix.com>, Andi Kleen <ak@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Date:   Mon, 11 Apr 2022 14:01:29 -0400
Message-Id: <20220411180131.5054-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:a03:333::30) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c738e17-4d9f-4cff-6ce2-08da1be56fda
X-MS-TrafficTypeDiagnostic: MWHPR02MB3326:EE_
X-Microsoft-Antispam-PRVS: <MWHPR02MB33260292244920A74325A0ECAFEA9@MWHPR02MB3326.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sSaPf53YHG5KMAjp0gA2fU/MgLoKUGIy7HeaJkPMN736If2dC7NlQuNdn+h2U3o2gDOlEVps2fXXBz6WOAhse1g9Obwm4aykwbIx9CC0MbUo3YlRdn6ElTFuOhXMbkls/Uy/CcWrOYKGfsSxeHy1UauPpEQueJHxuYJWSU1oKkrF7jTbTiBjaG0gapzR3FTDG75ZWXKPwqX0tDxf5VT0kXWwjTVA4j9IVTTzSTvBzGK5bqlOPrZtpN3pKfXGcTeEUhP00Bnhpg3UDJaVxUy0QoeeN5CU6strD9jVn7+UZU4r9BQWCyQ0fHxxQEqJ6Lpc6+FcF6fwdVltIogZWQJaDmovoPsEzlomaIeanGvaYFZjL5/W1Muv1WVjey5Rt3K+FqCGqhIj7GQ4kK0cDBrrI2M74gpINwmtFZ3Rbv3zjoHFoEcDZAhFeG2LEXY8fJyWBPxxTMF4/+Px2a2oA/+524L9tZNWFI5fG2uFEjCLKzZhE43kbQ5Ih/d4u32p4ks7VCV7DGIqlr+k2QlC/X7etVo9CHMf/6TIbjStRepJ/PmDr8AVJLG0aFG15diKyuUp4+Jv0UsUZwMF37CTOwlKTN8o8EzzpK02jpMms/7xLMkG1euu0rydhoB1euERuE7OkEU1mDrcluVBYA5YM4SSdB33HQMzNycvupf91S3Ru3F+5oOoBIeYh+jUsPVwVeSCnn+RRx7knH8616e38v529A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(86362001)(66946007)(110136005)(54906003)(66556008)(66476007)(508600001)(2616005)(4326008)(8676002)(921005)(52116002)(6506007)(6512007)(38100700002)(1076003)(83380400001)(6486002)(8936002)(2906002)(36756003)(5660300002)(7416002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bX9sCYtagWV/4iyCjJYWirvG2BjOFCRebUWyxh9qe8wnclJZIz8mAEZeIX15?=
 =?us-ascii?Q?h4rR0bePIWz8w9GXrF/KFBvtYp6/MeRVoMNqJ9gni5hg1fn5v9jpmJCVdILt?=
 =?us-ascii?Q?HGduLmpQbalb03z03pjz0gBOWOzsS/00zdeS97moosqt8pRUVwedSpoVuffp?=
 =?us-ascii?Q?cG7XD3n9yfOnqMY4yqxHe7KQk5tjgV24GjzJ6lM9sMW3hJd2NAtneGjYt4px?=
 =?us-ascii?Q?OJsykTNrKt6DYap2VFzxpGo5y5cd31nLA6ZWzOjjREKNK2bIcKA7fYYRnjY1?=
 =?us-ascii?Q?JCcXZG9br2KBwtRQcqoW57guXkJUSQpxxnpcbugJc6bJo1gTrkHYNC8CYH0s?=
 =?us-ascii?Q?aZYL8/TQ43fGVek4AykZBFKvDPjfveS+blY+aePN1LJ8sVhjWfSRDdbps94X?=
 =?us-ascii?Q?BJR23S2g20CCQOo3jXz1vMv+kEjxfv+TPm/BlO2/itK7V9iIiSiNEBtePIIR?=
 =?us-ascii?Q?FPGWkr+oVPLSn2tm7uRZvexudxh4JmCjMnHhIpdklinBKhBz/WVcp+N4aCJE?=
 =?us-ascii?Q?5xkwu89W8vO5BAT181spFl3rQNvnyUJWaasFkQAxmSFpgtujaKBFTj5qGgEe?=
 =?us-ascii?Q?bOsiOSrSNbWFFvx/viJGU45DVjbMiLNCttdzoQsOApOTJJS6yApn4DSIUGY0?=
 =?us-ascii?Q?DKhkg7cb5meeNJ7pt45Bf3T0BooAU1aF5qEPmipe/kapq6XvzAAMLkwm3waG?=
 =?us-ascii?Q?AvNtb39CK5HHruu+ge16sPX3qM1uIbDOUDVMVqjjcUmV/e+nOIq8bdnzC75h?=
 =?us-ascii?Q?zpDwRKwiRwmwLp2jypKeULklpBUkZLh0LPFPkgA6JoSWEXq/JX6NTdN2yJ3P?=
 =?us-ascii?Q?qYE3HRUiT3X8+CceVtbWivDQobIjcCN6C1zUYm9xDO4+lzvcEzPjtWmeDXMf?=
 =?us-ascii?Q?MpZk3xgX6mVUQW270wujFzduYZ+SHupxC/kqOkyS1b7T30OyAphZ59h3wZZS?=
 =?us-ascii?Q?PhK2EGFFE3qgdJpHDK3iJ0++aqD5unqKRoHZlsTG90fywUPHwQRnS1KJbmpi?=
 =?us-ascii?Q?EY7Sx8pNa+PSI7qz7F5PNRgKEzZKG+wrAEVLNcnRK1+mQwXBD5Mdnau1zRO9?=
 =?us-ascii?Q?1pRWLlebHQVDKK4sXCbL7tcZ21HzYularf5Sp15TiA4xmJRg6OzSwDvFL84s?=
 =?us-ascii?Q?OPSiGK9RPBlfqSr6lHXuhX6LzXjo5stp/VCSDbysplfabL8fSW8GnJZpm11q?=
 =?us-ascii?Q?HA2DtSD14OslSUZJr2BqkQcrTnOyHWF3EcwMc054kkWmAE/+lVmLsTNW8DTP?=
 =?us-ascii?Q?+McQ23Fmd5uApXcrCV6OrFhR/noF0z7xLeLfw0zh0cHNg8+Oxdr4ZzIbcJ+r?=
 =?us-ascii?Q?8mZzH9ZLMJx6PB0ZBTBXU1w8mqncPmA5MmOhWkNjjPC4+Ok4S1IXeRFq5jMf?=
 =?us-ascii?Q?paRj1ZtxayY9I60ka0wvlqPtJTDmZk4Auz1rLQUHUJhRpMEDv0N/9vRtAjQ0?=
 =?us-ascii?Q?103M2A+SNARLgYVjw1/mB5RFskLhu/aCZj6hjFQlKc5BYlioLRUI+vPOSv75?=
 =?us-ascii?Q?K5457l+Wa2YNmuJiEfuvGHiG6OkrseaomI9YXNj7NcuZQRv0bTm/m1TZIPKw?=
 =?us-ascii?Q?/OngWTczzcA/z/BcQBE3JMuJXZOJlWCm6Qyw804z8Dmkw9ugjyXNENNdBTOs?=
 =?us-ascii?Q?1zEoHvtgjgJKFpGpLMhhIGPq35ucPz3lPoMemeDVJFi1WIqxx+moLTTwu4/n?=
 =?us-ascii?Q?EFY/y5CoM5+HV+aJUNFFAqeFgZM90h4DHmQnyCilwwWQxQpWkW71WcKldHtg?=
 =?us-ascii?Q?kQCA4/bUicbJbP2iqKtsl+Btr8SHL6IqE7s3PBTN2zwiSXEnHDXGhFTV+i/d?=
X-MS-Exchange-AntiSpam-MessageData-1: 6pIVo1lrQUNHF9szU5SvkPp5PtfxAUcOJRs=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c738e17-4d9f-4cff-6ce2-08da1be56fda
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 18:02:26.7517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTna3ggiGSzKUIE8S13Cn/zZG1Y4ObwFPdfbrSpRt9ccAPz9RUxvyiAvp/fR5EwiwofDGPGiWFo0xDiPZINQSNakpO1Yu123ZdJDotMfBpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB3326
X-Proofpoint-GUID: vRSLJGX78rorvv_4jlAcS_a8I6sSmQYV
X-Proofpoint-ORIG-GUID: vRSLJGX78rorvv_4jlAcS_a8I6sSmQYV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_07,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move automatic disablement for TSX microcode deprecation from tsx_init() to
x86_get_tsx_auto_mode(), such that systems with tsx=on will continue to
see the TSX CPU features (HLE, RTM) even on updated microcode.

KVM live migration could be possibly be broken in 5.14+ commit 293649307ef9
("x86/tsx: Clear CPUID bits when TSX always force aborts"). Consider the
following scenario:

1. KVM hosts clustered in a live migration capable setup.
2. KVM guests have TSX CPU features HLE and/or RTM presented.
3. One of the three maintenance events occur:
3a. An existing host running kernel >= 5.14 in the pool updated with the
    new microcode.
3b. A new host running kernel >= 5.14 is commissioned that already has the
    microcode update preloaded.
3c. All hosts are running kernel < 5.14 with microcode update already
    loaded and one existing host gets updated to kernel >= 5.14.
4. After maintenance event, the impacted host will not have HLE and RTM
   exposed, and live migrations with guests with TSX features might not
   migrate.

Users using tsx=on or CONFIG_X86_INTEL_TSX_MODE_ON should always see
HLE and RTM on capable Intel SKUs, even if microcode has been clubbed to
prevent functionality.

Users using tsx=auto get or CONFIG_X86_INTEL_TSX_MODE_AUTO get to roll the
dice with whatever the kernel believes the appropriate default is, which
includes the feature disappearing after a kernel and/or microcode update.
These users should consider masking HLE and RTM at a higher control plane
level, e.g. qemu or libvirt, such that guests on TSX enabled systems do not
see HLE/RTM and therefore do not enable TAA mitigation.

Fixes: 293649307ef9 ("x86/tsx: Clear CPUID bits when TSX always force aborts")

Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Neelima Krishnan <neelima.krishnan@intel.com>
Cc: kvm@vger.kernel.org <kvm@vger.kernel.org>
---
 arch/x86/kernel/cpu/tsx.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 9c7a5f049292..a24e5e471e3f 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -78,6 +78,20 @@ static bool __init tsx_ctrl_is_supported(void)
 
 static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 {
+	/*
+	 * Hardware will always abort a TSX transaction if both CPUID bits
+	 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
+	 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
+	 * here.
+	 */
+	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
+	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
+		tsx_clear_cpuid();
+		setup_clear_cpu_cap(X86_FEATURE_RTM);
+		setup_clear_cpu_cap(X86_FEATURE_HLE);
+		return TSX_CTRL_RTM_ALWAYS_ABORT;
+	}
+
 	if (boot_cpu_has_bug(X86_BUG_TAA))
 		return TSX_CTRL_DISABLE;
 
@@ -105,21 +119,6 @@ void __init tsx_init(void)
 	char arg[5] = {};
 	int ret;
 
-	/*
-	 * Hardware will always abort a TSX transaction if both CPUID bits
-	 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
-	 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
-	 * here.
-	 */
-	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
-	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
-		tsx_ctrl_state = TSX_CTRL_RTM_ALWAYS_ABORT;
-		tsx_clear_cpuid();
-		setup_clear_cpu_cap(X86_FEATURE_RTM);
-		setup_clear_cpu_cap(X86_FEATURE_HLE);
-		return;
-	}
-
 	if (!tsx_ctrl_is_supported()) {
 		tsx_ctrl_state = TSX_CTRL_NOT_SUPPORTED;
 		return;
-- 
2.30.1 (Apple Git-130)

