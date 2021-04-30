Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F283936F9DA
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhD3MRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:17:44 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231766AbhD3MRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1Rzn9WahEob3qGaCdHcXyNd4Y+jd2dIDUxf4U6Di5RYHFCjrybS+hLksd3aaFxMoTyoJxcYSVXfOdoEHneKBli8cZnWTc5285z+3gNZ8FopTPxhVWAw9dRKBgAWHp0v/t9BKISBVjP8sUPSLakK8gxR3uGNODLEHhsg3Et5Nqv9HT1lXimfCgEyfHKOF6zFxUeDAvtK62Los1Swy/q5EQX0HjWRyoLgNdLmGlqUjziZjO8RqXKqMOB835o8ki3X5tOiXl9/ESMWvmnga1/45NeacWMGnzP2nKzCK+DTdEI0xwuy9jKn+Zm1WBgbuLoWe1vRfiEelzjYMR9vqA8k/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSqjj79y9azdiLTw3J18Jb92HW5TNRtkirg8lS4kcv4=;
 b=nJTUtxS3+aT7KI6HxHXpdEPgGB3uj9LP+wV9VIGN+wz0fNaVl1s8+v0AEImcTTA6rWJ530rta/rXGhASWo6iO7CDFh8+QfaieQgzdBv3JULcgEzvKjs/XRoJp8m7C4OhtlM7vvwruTlihaJQ7JM1Nm5dOi0TOw9/qllyhSyuzPsz9ppRkCzu53pSQrAk6axF5GyoNy0rYAwlF8SQe7dFbhQUCPWVrtwujho5KuTnRAdbV3x2u3E30QePbPVDR9epu894kC/iw3SgCYSoIta7BkC+dA9VyFl7WAWYMvEsIfAMdla1mvWJ5dBWBSVA3pRlW48tB8t6/hf5ILsK+wJeFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSqjj79y9azdiLTw3J18Jb92HW5TNRtkirg8lS4kcv4=;
 b=fN2yiPAZegR1bAjJqv0bu8eHFjk1eRgbuEXsgn63BeliKGsp1jyEyqJdZmITXNh9XxajWkZOEXELWHkHn/RyTsxPfjrQObr8ISkLg3aYm0HBB0Q28PyIwHxFUc7mlT33uH+5G1zrgDmnkpLL/I16bYnzEm5hWAl6kclzNlowai8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:48 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:48 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 01/20] x86/sev: Define the GHCB MSR protocol for AP reset hold
Date:   Fri, 30 Apr 2021 07:15:57 -0500
Message-Id: <20210430121616.2295-2-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c779ec0-efc2-4536-4761-08d90bd1d405
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB443140CB2B8B87242B6EEB41E55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4IXNfZ2kJrjBLR+hgx9Wse5C1E2io/tOoqsAm1AsYNwWvdNDEgGAPUdHtno1nF9hIRfrI6dAYewrDeml8DK25oDQEauRU0DH+exmoHSE+6LTM9yPOWr0DmVOS0tmtcquWCSVsRZmX4D2mB2z4TKHvmgyTDx40QhRlCSJH8AGHKUtQe4iuB2eKOpzZzzvRJasZ2AlETsQaIfxNaYImjHNtbQPWZJvwX59mwDwbD6wxfhoV+V6iHqHN2ZNv76/1sI/Y5CLZq65ekGZ3JKRFx0JrkvvjnckZJLs15Nk4BAq3/byfXLKK35GHlVJTtje2vna7ePIj0Xqt3dm5/oS6MhIR0f8DduI8nT3KnPUazvakWzsJ/tBs/f/afvZ3pvf8xD8/e60dUETxkLlnx8dZccPGLbluFQhQMSABG2zo99qop1A1Hk5Jgu5z0gbv2RB4jtnT6I5dyY4WHlkcht2QPVkHCYQyeauCuQpMMYpRrKijiDt227uQYVFuODRluzpw2XDm2qnkITZ3zykmoEbB0sD2bEAJd5hOthQxn/rxnOGqsmygIipd/bh0Bdo1X2j6ZKnnyEkIybISOuT6AErxJqgsmUP+WwObk9Jb9esxQ0sLbGzuVsClvtLGXu/SDcR77VMrwYHk5dJqLQHxAfdBHzhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(4744005)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+IW/lbas180EnTIhXa3Gf1CTBIVtXI1gZXAolSreE3DVSNbO/c7U4RD69HQx?=
 =?us-ascii?Q?0W9yhPyPbSZSBj4qHg8fwNnA0i5ZvNEyBmEplnV20+oE9UAucCu6R87sLpHu?=
 =?us-ascii?Q?gWTXDF2m+3Fgt+UDaay+RwcacFKn9uYZvrXVxYvNIu2SEuQkFB62rrqP6mwQ?=
 =?us-ascii?Q?FyVm4U/nYJGzIGHNj04fO69rsXb+3eEVABuvnMnnc2R6QqkzvPdkg8n5nlKv?=
 =?us-ascii?Q?4F9c/xBWYz/ZLpT3SXkByjsNBd5vChi4y6BJ+MebPKHEBTqfS1ZX5IDfaY8T?=
 =?us-ascii?Q?vAbVExHh+c6lFn98Hinvuhtzpr95YaQjditYhG5y6ySprTMfpGh08gfLrveG?=
 =?us-ascii?Q?I77yvYSwFuZ6W/diabrSgk0H9Z4AkPD2CAiS4WfsboU9pi4+wkRynlHJG8vY?=
 =?us-ascii?Q?qA4lI9SFUOFfQPkQ64Ht93+TWdFIu7gU4eVXMcpY36kn2u60FicxelyA8u6y?=
 =?us-ascii?Q?TdpYE+ox7mKModjCZWmPBTbpisgV1oHwNjELbugSvzXz8+eJeN1j3lH5BDIm?=
 =?us-ascii?Q?whdKq78UrT9o/37+BRe13DJ2euktJ2xZ3pVrLoxD08oOhha6vhjnoqvgwt8U?=
 =?us-ascii?Q?JeFsJzHaRgeVtVlarwEGLBj2GMrY2+sT0dQ3ojVAqLXi8UUSDVI9o0YVPaeF?=
 =?us-ascii?Q?j6UhuTO3Eham8LVyAaAa6FfFdCu2UyW6WHIkOh1lQzVh5c62cifuNdkb/rvV?=
 =?us-ascii?Q?KQq5disoFrBMUL9kqkLVTVvW4dLUitMBp/BhEqyPXZA6E/oZ5OsTZYCLzp0o?=
 =?us-ascii?Q?59qWA0ssiYUCPBogOt7qUfAob3oYJ9sdDW+JAnjVXCVOKyYihAoG4Q21NyT1?=
 =?us-ascii?Q?OL2ijP8KukglP1uhF4O0c7onFwiktDn5GkO+vroKpGtMolimSkoR3EjaTAEX?=
 =?us-ascii?Q?KkxcvLvBWB8KdAbbCCYEY3ZHo01PBAIOgQVYeirxPb4O8ZQYhHX9LRad5N6C?=
 =?us-ascii?Q?fcbEzmLVM3gGYXLGeIWEoez8pwRIGkmT6b1RbYhbLEXeMT5tqtgWyop2oDrS?=
 =?us-ascii?Q?4FuQWH71tqo3cR6lccLbzPytwOK3Krb9Q0uHzOl6K7t+hNOybZYt17A/hFMs?=
 =?us-ascii?Q?phPuYSjLBrRE30RgAwQ++A/YAPbLV/d3xHlEPWwkJh/khobxreHgxBazQCfC?=
 =?us-ascii?Q?xB9t22o0E5k0S138567+tpD7AQfbFClEdwLaZLvffXnWD2H+aSa1vj+Aitbr?=
 =?us-ascii?Q?3458U7Da0aS6I50PjRtzFdW/tTw+o2gDRZo5jHGZrNhebHbl/gt3q0/347/G?=
 =?us-ascii?Q?q3eTQMmMdxb24geND2vLIHApjo6CG1delEmSShCqTM0eTERYF4SW2u4gabvb?=
 =?us-ascii?Q?9EH+BoV+QQvnxRWeQbXdreit?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c779ec0-efc2-4536-4761-08d90bd1d405
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:48.5010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJ4sPVsIK147fIfxXnkYHBN2kk+qOU989EbT4ZjuaO6VwJUbDEJtNomkvItbp5leortLNoGPCHlRI0nvSzKwAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of the GHCB specification added the MSR protocol support for
the AP reset hold. See the GHCB specification for further details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 629c3df243f0..9f1b66090a4c 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -45,6 +45,12 @@
 		(((unsigned long)reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS) | \
 		(((unsigned long)fn) << GHCB_MSR_CPUID_FUNC_POS))
 
+/* AP Reset Hold */
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	0xfffffffffffff
+
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
 #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
-- 
2.17.1

