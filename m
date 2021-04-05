Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC863542D2
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbhDEObD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:31:03 -0400
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:14458
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237352AbhDEObC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:31:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/3rqWiPLkIkHHidVwVp7devP2I7Z+abv9kkjbdpX4kbpFBl1vrZL9WksZTYvHveYXLHlHrAYD2YhHcRP3oDAMfTjROOBsQBgxUbLFrmwU9Bb4VemITNFbWJKL5dss7D8h+5gUdL22EOgbBFL/UDaVSqhjoa6tapF1JWvQUrsZRAGNk9PjKWTJ041QK8nOy7h3G28fHEf9TNAzqrTqoPrmxum1xkgvzSehet33hQbfFNtWlWpgm3JHzT5KZoQ/6nVvOf6V4A2LgbX5uAIFUvPyKTf+8WHfOQHwCxi7DVEm+hgCqivXA5z2jXY9d6sQafPq6X3Y14Mo+dv5KbWhMZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQJQQaTWARObKBfzmviOopLOxzSz7S7p/w3nsNWbJwQ=;
 b=gB5K1ELRkN1Zb26J3KcHB3ojUHMBQxD0tm1A5xZ3n6TVEDzFcgaV8P07CWNDTz68oDiD8GTg5bolbDLLHY28H5xd0IqLpVMvM9K1nXK421DglzeU6tCaGY1BTo3JXHJhsMhFOHRdy6SXUZ3ED0w8kSZjwejGi6otMN9vG6siXi0o1+BziRQ5Nrn4MbQDJfm+S/0wWV6vS3Jr7xsvxWTUGV9HKYH7/T0b2iAhMftxF88Drahly7CpQQzxAyqE0TR/YkjuIUrxeUP6Gb+1GHxcNEzogXUyyRWX86wiF78vR/7ZYgi4detLEv8JHgnyeolBe6A9e5sWvpf8dLTWgu463Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQJQQaTWARObKBfzmviOopLOxzSz7S7p/w3nsNWbJwQ=;
 b=Os2YykXeA0otdwRZRPff6L+g+aat8S+omEeXn8zh6OMqjYPCO/oRJP2Cd0Fi7xTuONZqfWtK5CVh8mhCb7HhyL5PlNm2TQzr/NliLKijsEiTNmfkPbrT6UjE8m/PQcxuVns9NdMei1uPHZYkIWIcOzNqpdoqgO+Qi8RTsRP/zO0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 14:30:54 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:30:54 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 11/13] EFI: Introduce the new AMD Memory Encryption GUID.
Date:   Mon,  5 Apr 2021 14:30:45 +0000
Message-Id: <4b36af89adb2f8009e07f371548e632e85350dde.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:806:130::35) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR13CA0030.namprd13.prod.outlook.com (2603:10b6:806:130::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Mon, 5 Apr 2021 14:30:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 528c78f5-35f3-4c9b-3bc2-08d8f83f6bbb
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45090843C9EEEA76578036248E779@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8GA0ogaBW7tWoFN3O/XYGO8Mees6O5RZIy8P/9TWOngUpRC3DZ7J6xdUABF8w2sIDC2kBgKafx5UN8Uk7nM5DeEGCw8wuhNAL6Yjk4UPyd69d8KsUR+AXJdGBDr02xtVBlmmmmgKyhRPbhMhsFD07gdiFFoQjmzmYroOIV2+ksvsSeKKyHrIeLcIfpw0cJbRvDIXpWTSqtPvMHBN72QqBsd00NEx00zKlbdCn3EiW80a9gUZPlXrA5s1SqW9kjRqFLkk/KYLU+ObbEAWSIVQfXhkIupQEq0WT1iZ2yPHyowLwCu47WzfaMTAkMhzKxweZFzC7lwLeHqhMpeQILyoWAJJ8tA5t2uv+qqfqKcis61eoZcC0IL4BVBKGCPdY7ft1y4Q2LcNQpYXwcx9nnoy4DXHk28cLUCHsyTvLvdQShhn+/+Rhq2rwQQidjDfS2rZaNPEnkU65Mrg98r9yLs2hplSivEF2mwXkMelUazF7KuThqyTahTQmFNigpaRp7TuL789xAlB2Rbg1atQ8LMQpwhI3gj0EF02fZiXJcWy0KaEUql5yUzgXzlELwpyfjAvUOFNi35d+NEoby6WhJMgcqDlLACT/UtEH/d0RUYMOHElHvKpOSj2yNpnE/n6ME6LglMFq5vyV2vJX6t4cgkIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(7416002)(2906002)(6916009)(8936002)(83380400001)(8676002)(186003)(26005)(38100700001)(16526019)(36756003)(4326008)(2616005)(6486002)(956004)(7696005)(66476007)(52116002)(316002)(6666004)(478600001)(66946007)(66556008)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o8q8UGQmrmZnQZv2DdR/RQ9+mYGzj0QOmCyEKIYNIb6NuXmbp0wcxo+a9nKn?=
 =?us-ascii?Q?3MsetL6v4zXr0qvovxNTeU4RbTdx/wWSHuQ0boaw4vi8iO+L30M+r6mT2KRV?=
 =?us-ascii?Q?fJYHn6jw7XRkM51AzXiaXo9IpdNpwmvyfJV0DZReZ+Zkg3O3R/9zeGl+ZKGO?=
 =?us-ascii?Q?gqiP+2WFDDJ0bGCA92kpudTBQ+lJDQ32Spjc6hEQizckae141OQOWchksuuY?=
 =?us-ascii?Q?EuqcYNW5Onv6WwM/8/TS2ljtUD12W/MTGsYUYv0I8dJQvnrzrxRMpKCDrIfe?=
 =?us-ascii?Q?ngvfhzWpoSWap5wVlljjPn54ca6bJOE024tlYzBR7YixLCo1Sg8vVZrG5YRd?=
 =?us-ascii?Q?ILZuilzrI+tz0rLe1zJ3KXpVNC6t8gefMGIsZU0/j6r7S/fYbalnFyRQun+N?=
 =?us-ascii?Q?vmCKlB1bBmtMIxId/cBen+BZoSG+rx90IfLFpZStCKDXtkt+Mc0p86t+My8O?=
 =?us-ascii?Q?jP5PK43b+Prm16aaFnOigJtqaKnv/P93ZQJLWImhlKqJ/Hcgm1nFSMM89IZS?=
 =?us-ascii?Q?WsJLbEK2sQXLdFuaazI+XYdxcmHd8JolV02jI4HSbYFX14AuNZv1wT/M4ruS?=
 =?us-ascii?Q?6e0OvRMNe7MF7Pq0hRCVPQdXEa4h/nn/c3oH0xNzVaH+rmD/6GldjRX5t9dp?=
 =?us-ascii?Q?lbdfiDv2Hq1pyQQvDIdJwWEgCWYYbyrmpXg3eIpwL4HbpRHz8NplgqyNDoL6?=
 =?us-ascii?Q?EOYbiMT/locdjIXF5cqSLIqnD2vAieBdUBFT7txVDg5UDeFoYeSyFFFcdVRH?=
 =?us-ascii?Q?vo3FXl78tIJHvYyd78lzlXf0Rf+mh0cmkmmlwvNNLH6d/6rmkoYQxan21nY2?=
 =?us-ascii?Q?UpiYpgI1ejgTjy7GkkChYRiatR3ynobAXuMrNV/3cJCzDsB1DxQzHZaRoBEr?=
 =?us-ascii?Q?tcWh5QeEVdoz9MWDLH1mSFCBphR+hOyi8sAMfnmWp8c0lEC+V+axsBN+/auc?=
 =?us-ascii?Q?2bzxON41uhyND00tEW6Ji5I8gaXl0uH3+3y0YNPS++T9ruJ8OvN09YpBnopg?=
 =?us-ascii?Q?/x2fDFjPTGuxiDIT4YJXKenRmmaEs/sprePSltb56rb6YN2RoV2orvyF4mia?=
 =?us-ascii?Q?15XbRPxpr+AK+D1ZnLCHQfRV+Gjiw9Ds12IqBOzqJgCCncb1tkNvXEhiSz5k?=
 =?us-ascii?Q?B109GJNLlMn/JaTXBJiajQVBLPYNUIjiW2l3oTp4Z+IZ3zfitjfh4EENzBqu?=
 =?us-ascii?Q?ZDT94vqEZytb8yu/oGIRmyhQHT/3J+ZCPHt6WCYhHyXqGdzlKosikj4eSCNC?=
 =?us-ascii?Q?Vi5ry4RlPVCPbpa9xErVhG3Mk2LRR53WZMiu6N36o8bOUvqLKdyZfsW00mft?=
 =?us-ascii?Q?1vb7WlL9q8Aqz/rz74ecVNE5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528c78f5-35f3-4c9b-3bc2-08d8f83f6bbb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:30:54.8155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 42VlBgarantXXC9d6xHI6vEtkdlvYcPtg+nx/lNjFFO2lhtPz/mkgkBtHAhK1HwSDjrbQ9vTHBKQlaqK4In39A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce a new AMD Memory Encryption GUID which is currently
used for defining a new UEFI environment variable which indicates
UEFI/OVMF support for the SEV live migration feature. This variable
is setup when UEFI/OVMF detects host/hypervisor support for SEV
live migration and later this variable is read by the kernel using
EFI runtime services to verify if OVMF supports the live migration
feature.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/linux/efi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6b5d36babfcc..6f364ace82cb 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -362,6 +362,7 @@ void efi_native_runtime_setup(void);
 
 /* OEM GUIDs */
 #define DELLEMC_EFI_RCI2_TABLE_GUID		EFI_GUID(0x2d9f28a2, 0xa886, 0x456a,  0x97, 0xa8, 0xf1, 0x1e, 0xf2, 0x4f, 0xf4, 0x55)
+#define MEM_ENCRYPT_GUID			EFI_GUID(0x0cf29b71, 0x9e51, 0x433a,  0xa3, 0xb7, 0x81, 0xf3, 0xab, 0x16, 0xb8, 0x75)
 
 typedef struct {
 	efi_guid_t guid;
-- 
2.17.1

