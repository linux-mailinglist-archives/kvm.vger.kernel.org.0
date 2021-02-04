Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E9E30E8BE
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhBDAmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:42:35 -0500
Received: from mail-bn8nam11on2056.outbound.protection.outlook.com ([40.107.236.56]:27937
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234027AbhBDAmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:42:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiW3NY5Mmk+PnOMHKNdt7aRWtgeiJbKBOf1i6YmdTUH3hK+blW7Av3cs3thc74GILHxFvRyYRXnqKYL2nxEuteu3TybrnqPTkPchzS7fEEQG8LOHIAiRhzLJZqJNGMT6ErG5ANRNj9sDKFobt7IicXWE9aIuc2O9bKcH73iCVPdYMOwL+hhnUE4sVIMDUg9dvvaTK3be54kwF3Mr6oaUzWlMkyIA7PBBtNR9KvIfNjVKo6EQ5r7VJeoeCd2rTWwVDKukhwjsxqSsHtVuPlGHGYaRoEmV3q6VvKeKHxOhPhEIM50j66qqlFaA8gsxgztSNknNb4cvG/j+28DHxajM1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wNiae25896FC3ky56yNZqP3Nc4wJpOPwOMmsz4Acfs=;
 b=grrBNz4p9O3sXeb8QlQ+Afl4qTWZQWV7Z92cyJmTUtOCmq7ssXeyCKn0hq3D8QuVEbeiBgjFNwcpE1NV8ORLluduWvrLwNEPPIOVxDHC9OTxkNYEE5wWrThsPEzizKNV8LW/+Iw/QHRtans9gu7AB79P2nK8k866VCQMCOTdlVknYPLrbBlDkUwngIMcvUNad6d3OHlGonJl5luKh7HapUneVON6zXex1HWnIgRGDPh44KfJ7bP2YUN76XkybJvfbEQLwhtWDsdt29JyX/EKNCCgNwIewJYbI6Z9r9WUOXIuXoDon173+mo6DvHj6bLhsFSMbONRJDKIOvgrE4TwbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wNiae25896FC3ky56yNZqP3Nc4wJpOPwOMmsz4Acfs=;
 b=e9dnlrwAc6ldcostrg5iENwKtd2Ws6ko2RUVZdWhcNIzgFHp7O0tqbqTFJmyBJq+hM3XFPTWo68UVmNOltYzEb84Plu9C1wAh2byNYRXwgwi5GtkFV5K57o1MHTRL45IX3bAdqjGMGrIoY+0VpAknjVhHinDc89Z7LKoJwlMfLI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:40:11 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:40:11 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 13/16] EFI: Introduce the new AMD Memory Encryption GUID.
Date:   Thu,  4 Feb 2021 00:40:01 +0000
Message-Id: <301a3078f4604e23d8c2c5a2e1d4804a3b15dffa.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0197.namprd04.prod.outlook.com
 (2603:10b6:806:126::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0197.namprd04.prod.outlook.com (2603:10b6:806:126::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Thu, 4 Feb 2021 00:40:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b0cb4362-fdbb-4faa-2001-08d8c8a56dc5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384867E19817E3515288BA98EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qx9J3SBLGR/MIX/nk42gL7uCd4SkzEzrh9bkeKGPHY4NeZ1Wy+W66X+6NDpGUbqE6hY8bDz/vX1uHAe1TEWe9N9Ofgx0dTfJaX7Y9b5hTrl3UQMniXaj6Cssw/MvRC1MKFc4qlDIv9TPMp3k8BnS3rYovGOGsa1IydoUVu0zBkIDUgJNDK3podREdu2Ee4+DsTRp/LnvyjkmiG/7NExwU4Bz2jCaRaO/ICbWU+Kr7SWAoFZ/iCuuoHmpVVORPUD82v++WAExQQEBz4T+KbnKXL1awzKu53Niz1v0WhXAeVgyXYN+NOj1fFErziVG1TK076xzenmHL4479EaEIfk+55LmxGl7SWvRVsy89UnsiIiMqbl+EeZM1flbG2WkvExIseC8mofl6tNPqeYJle1HzyjcM5Rh754KSoV2ruFcAILdRFpr8LxLQonqBmhZFbvhOBRAuVuO236Mzquz7cAjJGJ8etvUcxVTS1qdRQGSldAbVPMf0B/vfW9evQ0OBQIvT3b+ReudGzewC82BUfPquA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ptIbAP4G/ZmBvZA/cESVPncAGd8U8E9jS4JE9wfEkvNB2O1GTz+TZYxTETcf?=
 =?us-ascii?Q?SJXQ49nm/MSsQ0Gjk+VgdOH/vX+RS+CsUg6yVecacOvJj21rxypRwiSm63D7?=
 =?us-ascii?Q?y0xdNOUIS4+7TILkIsls4JCsTdHs2ILQynPdv8g8TEfC+xToN9WIpdjUc8GY?=
 =?us-ascii?Q?PVHVe4M3v/RbcAglK0OHgYrB+mniaxQJqiGp1WmZonYfax0lieTnvn1MxcBe?=
 =?us-ascii?Q?OfA+sxp/VmaSFEi1LTSV2gcdoi3tygQqlyJR/qaZJD5lMyH4sqvF5QJBrnZ6?=
 =?us-ascii?Q?omUbcLDBfG5Bo35moFDoRyP3XpF6ps8dIXE8fNveHVjPRcNTpkFxaFEu0GHH?=
 =?us-ascii?Q?jcmUlnNg3QQkjxm3jdAqXz1mslMm9w+ylLHxJKuq7mNSjQ1j5vflv4eQMXsQ?=
 =?us-ascii?Q?JLjLsHrhIk+whmzKD1DhAIN22r5RrYznUpirilgVsmCHY2NZCtgnfa+duUc0?=
 =?us-ascii?Q?QQDvc1h6d2wR19qLn96uqiTv2qHNeJK3rmHxzIV8EfWhBKESa/oIIhduR1lA?=
 =?us-ascii?Q?JWoHneOP4eM8N7T5aiBNPHor1t7QeKVv9+AsnJbCTfpkUMK7iRjlK9KHzFbA?=
 =?us-ascii?Q?CsNPU1oESDREhuIMocOlC8TEyTLu3G6WreFS8yujCv8rqWojQ9aarV9foyUD?=
 =?us-ascii?Q?b1Q4JQj2JpJ1ObxJtkRW/Hw+lzKVUwrqQ5GgrSFLKy+0N94WeQKVMgZGbs/z?=
 =?us-ascii?Q?pJZEYDMiPf8yhSxfNJgI4NBUIPflFXQ3xNtr06fLGLJ5PJChJi3/0jwbREql?=
 =?us-ascii?Q?1pXE09roF0biHSgsHyj1qXwEIrMXyi3+XB7QXz43GlBb52iwqzsie/mzq2QG?=
 =?us-ascii?Q?s+rBiWmiJT7Bju9H69bX4SYryrIT6Msn+sNhLKdKpzwaOGMaYAnFGUixES2W?=
 =?us-ascii?Q?H+Y4k9wY+GnyhXG/sM5jXiOoPpHO0uclLJ7yELdfUKq8mzUsZI5iSuN5Qio3?=
 =?us-ascii?Q?fKj7sXrX0JH18HHnsQesNjIQ9ShI3vKGUCnwfHJKOEGKuqQptr/CLRDytQZQ?=
 =?us-ascii?Q?XZgcQ7PEbhUS+mQnc6S6WjTLOL5YN0RvlVuJRfcetDq403ylkIF4nuw/dTyt?=
 =?us-ascii?Q?mYpi5ySgzvWGMjtLmH+rQt281V25YTgwETfAG4KeY/9OsjgUz/nA0t8o+H6M?=
 =?us-ascii?Q?w1A8OyomRGmxyR307Qx7DueHVcAu7WsaPq6wPZewh0deJYlffc142nCUt/YN?=
 =?us-ascii?Q?BzxgIB1cU+DNynJHooI7uj46j3fTAURmRCVfdbVh0JE7a39SjiCL1RUVNlXP?=
 =?us-ascii?Q?9PkvbtMdj96amvDLc53hXKnk9uAyS3nh9rWeY8PWoxCjvf6f+a8sVAMjzSQp?=
 =?us-ascii?Q?5ZCuZ//FcDUai3vWGPDie3LE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0cb4362-fdbb-4faa-2001-08d8c8a56dc5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:40:11.1248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtLGCJkQSgFD9OaNQo7W4S55sEBtwjwNrVZKYQHva5rkZO8fAdgOtuCKcj0eMZ5ozsm/UJSJc4I6GxGjA/5Ycg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
index 763b816ba19c..ae47db882bee 100644
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

