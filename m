Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F407836F9E0
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhD3MRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:17:51 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232113AbhD3MRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmg+F/Sc26KEiC1lbd/Htsb+WYNSSHyWEM0bCQMl5WnJfixpYY7GSZ18u8O3R14o+qyjltDqAIjBH0Y5KkwpCoJBxzOAk+zGZAsE7ATVt82Udlu6R5NnYvoegVYPxno4Gy5sb16qCUpH2nSx0ASwjq2cGQtjFxWvfVbZK7kdvGPb4R7a1NVd31vKIHdBr1X/Zdh9oxUkFfm6gO0bTrJ5vQCp6AwSd3pp+awH8gOdn8ESvP09Gywsw7ACqqsyaKED+8OnyB/Thr9QsKavzBC32qXJA+l7Emn6pMn4QbR19fl69sdmtG2GlAYPh30cZ36psFLzrcWUxtVRdpDaAOHWDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4F9SFG9MOaqc/XYqz2nbXNALvxyqVxTzn0jQk0bLwc=;
 b=NKmU5aq8HR+T3WPZWMWD+GpGzf6XjmtAbWuSkgQ1kPoe8iLTOXrZ+hxHV+TxNMNHTzy0dpQ61j1tDiuffxhAo1ry/HR5oskXtrGy14ZB4dOGL9y4UhckQ1H8J6Yukm/0pBLE7aRfia1fGlAz9njmmEWEnw4NS8KmKhtBrXimJ9DYWEH48O3/fXIZDrtlNG4O1JSyOayw1//nJ2QBZlKtBKWEgkvhu5ToZM2Eazjg/G5AUCl4fOze9ilVuaVGM+2efg/J+vXmsiSL1A0gjUecLUZThcvFA3Pvkraww7rphOuxW+uEI0zKckomYaI5L1D/OO2LF3m7aqgMs5TshMbDaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4F9SFG9MOaqc/XYqz2nbXNALvxyqVxTzn0jQk0bLwc=;
 b=Fss1IQG1oOvxabWcJXnjMSNLUXk1omFtu9rhwX4egj3GGNSfNNRnSNjJ/rXPhMu3kjRNvjwDAVu+70U2EWX3fBGQo7URLGvH4eDDnQEjNV6LYOKyjLss6237YLY6mbmCSpzmVi5HDUhp18hEduK27iUFZ8hqZ6LLdqqNQiM/QFQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:52 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:50 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 04/20] x86/sev: Increase the GHCB protocol version
Date:   Fri, 30 Apr 2021 07:16:00 -0500
Message-Id: <20210430121616.2295-5-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74acd16f-7069-4aa1-4270-08d90bd1d541
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4431235AD5D7192F59F34B0DE55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tkrsEhDlDhpEaZq4NDMxmusSAKFcjPyWDYPdMF2SdpxjVG2ZwFfk8xcldCHi5sb2mE4NgOjJVuTBhA3ea5nwK46hxVmbT3CMiXWtAk8wZXe1NGbK0FYN3iETOuCewHFc2ZcEvCdINALwFiOUcU6YW09u+Tt3SP+2vQsUlJm7d9QSMLXlmod7vYRbgKVfddK1RnKVlUfd+PMxidzAwN73fek6aCp1qrYb01L74qqSW6ulcVq3EuND283v/rOaS0V0lR+VpYdOKz42QChMlKe9TO1QYlyhyetldT6Ev3JuHN4r+RPisGh9hFuPwq7enOiOh8L3fNTUH7A/hmnHOLTHnhAqwgfC9S9K3NcYw/wGXBWzFBpabtn41CE0C5KmDtc6/WD3z3+bP3p0FxKmIhUBYpI4hRXbqzOVkyt2M0HXTNDYapuV74pmpsMn3ystyBrCcEgkuqrMUGCV00XSZXWal9qfGV55rsHiGybquAm0NJxA4EZzPlGAg+Unagsut6ZQDuzF8bj8XN/awba7M5tKd4ebLIrVPwtbq+DayHdzqSAWPqI+0cK7LkEGf3J6d32aS0tMsIvbfc26dFlhwz2rVAepisw3sQZKeo5hl5yxpwDLMEHAMiLSjSGFI7GgqkSHzdAEW6sM2eN/q8kaCbl57w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(4744005)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?W3WptkEctgs5ANWDQ8DQEjsx3Ea54xhjBghCQHzsXXcyJsgTBAbdUTjbu72f?=
 =?us-ascii?Q?ebgikEHmJbazontjgILCG0YLWEoPo5KAPRO/jOGGfiebasFFYJVVCmCWwZlJ?=
 =?us-ascii?Q?DIjb23Hyn5uz3cRuK78kIgr1nb6NOxWk7Tke2mk4s2tEm2kdWz2xK6gzP/sz?=
 =?us-ascii?Q?1eA4WC1Z0cvUjjxMhAVzH8qCNEXQlsrMuusLu1V4h0LMVi0UC6TO3nq7ckF/?=
 =?us-ascii?Q?Z20+tlVh5rt2q+rHD/N9xJXgWtYpoC+PNDzSVLq1tSAe/HMzzI3nPbaaBYOC?=
 =?us-ascii?Q?UtU/e9Ucf3HBSbpYRXFwaBIWLBN3S7d3XTDYSzmShFLTeJBhBnSrcNiqBCbl?=
 =?us-ascii?Q?ggPuRt3sy6LaSy8NB2rMnT+6JuDXUwxz6xWAJ42JyCdcg7ttPNkhgjFXzu7a?=
 =?us-ascii?Q?l+XkzW0E3QyIKdwRcKIfnRbQ/xmmBq7iTcsz95MeFBWLmwufQD2YcFHlJzrr?=
 =?us-ascii?Q?0vO/xsZeqI3+7Eukf6dpCnbfnbywm3zO+Q41QUu76lBsf0TYh7W6iZRwfDSt?=
 =?us-ascii?Q?ZLyCrUvQ7wdpEdXXXOJtBe2WCkqADfRXMMN9L7tpM3jMmklWJMB6liJYwWiN?=
 =?us-ascii?Q?I9lhj5zfkkNGWA3DcEmtURJ8LAEl5ELqY1lSGQrReqTpgGMp0Y2m12+xV2Jd?=
 =?us-ascii?Q?qiR3o1nVqTc6eyKGmbjZIPdMIqjzyU31L0teGAgUwWz2I4cn6xt9yfj70BN5?=
 =?us-ascii?Q?kz4L+0KnYRiwHVVJ9fV/OQbQateMGqOlYtd73ig/s4yIM5Wq8Rfhke68SoWR?=
 =?us-ascii?Q?CyWUtHIGdT43BkjdoaoirhHw92j5WsTRxa1c906NewBQCt/hGeGyiPnXBTZ2?=
 =?us-ascii?Q?VqIk6rDRRPQToczYhJPODp0RM1DuA9oyCfWh7ELRUfm/iILX9/dzFth9rNxK?=
 =?us-ascii?Q?J1PS/RovzNxgCeswxJpzg8JeyH/QCuX+rJMPWgwNm75XysOmLreRkX+ndS1f?=
 =?us-ascii?Q?ddJyArt613rshUToopKMfhMuTvLyL545wcaEs7S5IucbsgbGNBQwRjcU+CNe?=
 =?us-ascii?Q?GDU2jR1weq2FaVMP7yYympqXmNPD6vqhTnwMjGmXiyTCna4bc+AO44bclaZc?=
 =?us-ascii?Q?dr+XV61tf8NwX3GAIXj3GZs2jFosIDSSH9/evqwjeS1wOAgvXj53B5AQ3ToX?=
 =?us-ascii?Q?uldODUzhMJYZdMIxiRYZCElour/zpqI1alOMhJ41EEbILbshTpEm7D7cIdsY?=
 =?us-ascii?Q?44nddZQRpWnWC3byKX7DdBUsqD/XA8NqU5RlcI+vtz78W5JsgJtbTmFG13UP?=
 =?us-ascii?Q?2+3mMzcg5Yv9BU+4AWNaeaTzDM35iqUCNX1ivJrgUA8yKeeuuBz2M9a7iF3z?=
 =?us-ascii?Q?eXh4xv9FpV7renAe0khdECeC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74acd16f-7069-4aa1-4270-08d90bd1d541
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:50.5468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqMzC2/Uc3wELd4mazorRxs53HnOYJyByrnziTH4VPxPMX6VHxXJJm4DhUjwiITDuXBORwKquY5AXjJZvaQ/mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the Linux guest supports version 2 of the GHCB specification,
bump the maximum supported GHCB protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 7ec91b1359df..134a7c9d91b6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -13,7 +13,7 @@
 #include <asm/sev-common.h>
 
 #define GHCB_PROTOCOL_MIN	1ULL
-#define GHCB_PROTOCOL_MAX	1ULL
+#define GHCB_PROTOCOL_MAX	2ULL
 #define GHCB_DEFAULT_USAGE	0ULL
 
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
-- 
2.17.1

