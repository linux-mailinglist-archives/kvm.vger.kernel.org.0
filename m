Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0790D35D166
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245325AbhDLTqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:46:44 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:45536
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238648AbhDLTql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:46:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkoSOCJrCXh0ECM7H/nl+Et+6aEW7hQ22I6zQhhhDN4qmUPbfZ9SYZf7PvOiAF5n+NFHmMU8EaoNtXh02nYtHEfPd3YZFkWHGIB6xrwM+odo8etKCG0dQ2r8a8tOoaMrsGvOHE24NDOvfv4wTJScL+lP6nhin5ZGi5FiiSZBsjrdO4143v1zHbOXfIoRWMi6QheAVMYkUVOkQNvLG6mkJ5+6wGJxkWoVIkdzo4Sn8zjcxJ8gEXtjlIkBBfOyYPBvfu5PHwlzus6Fanu6H7hSem49KeAu/zR8d+SOPfWV7HUBGDjq4LAglrp4tL1ZYMHKGww+vCcpBcQfqQtldNg0nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQJQQaTWARObKBfzmviOopLOxzSz7S7p/w3nsNWbJwQ=;
 b=Pg2BAQ6OAfMjoP6xenl+gNKNhwqINJvDfPdm06HiQ+OWAiDgcGJI97yLzXo9h+HH/TWSh8l7+QdHxOwMUek7cqCjv4gmOyxoqh3yI+auklLpM0yc86xVwXhMLGPV3WUXVVQN4a0inycj+c0DaxmT8bbmxdamhD5W5oo8/LbJRQ9vtEfxXPv34mm0dMzSWpMOR0IO6xSeFX6WnolTl+FPzEKqk5I8kXc5fTLJyOlxS/3On7yJ3GzN9OeQD4DW24Mffsx9XiVrYtMcfqAzH5zGjYTX6No7TkZTpm0VLoUh1JzNEp7KongPqlwYgYflsO9aMtwKLePQevPhlBoNnBrv7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQJQQaTWARObKBfzmviOopLOxzSz7S7p/w3nsNWbJwQ=;
 b=bGnareZ6Hm9nOAk5RBM7K3BDTNHW4dRQrEiQ4xDo9q/SUMN8kfsFq+7elVzVl6dq+dZ8G+paWXtYNntYRjADbFXvKWv7bGME1zWIzX6hxOLJkxEy6XuPYufO7NE8VzgSGPH54YCf0emHNdEA3LqlB3IpjEXL8OY9ocescUYR2X4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 19:46:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:46:22 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 11/13] EFI: Introduce the new AMD Memory Encryption GUID.
Date:   Mon, 12 Apr 2021 19:46:13 +0000
Message-Id: <ae8924d0dcac0b397295f53f7bd3ff06f6a9ff12.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0049.namprd02.prod.outlook.com
 (2603:10b6:803:20::11) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0201CA0049.namprd02.prod.outlook.com (2603:10b6:803:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 19:46:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c0fe57e-1d10-444e-5a11-08d8fdeba613
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44323947129A1DDAA74B2C948E709@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GY68t9F2ZK5HMKuDqsX+5CCB5uNuOEkARrft6dpVkmC34r772JRt4jpJMw7TlHqxjjJV90CKpJ125Hza5gnzeIq2cFf3508WllIdlBQZL/0nGZydevaLgfdtQGub6Sjw9EpS5sbLBQl+6WjPFfnx9IVPCQINnmLRlcj5VSWTlkvZml/vbOcHZ0ms1VbuHqvwuc6QApf/z+YKvYKFCAKD+TMb0dYYGk7b9X5M/+vtOq7MmfL07K+m+L1iCHVY3txpAGLsmvnI8agM3sECGyZE5UpU0ZRlQMFAhJV7/MeOF88rVRJK5KFGLzrktxgMmIGpPe+3ORZkLL+/TImOuj0yVRoRwNSF7RCIN1vBSekoehF/dX/m7BAeqd4R7E6ydzYVRShk976LaDiTbf5R8EMgUNwtS9uPyVyFaylpCN8V56XWv73g4enChlmpkuauLeSpihWCB5zAk6nC3TwhQgcp8lrzlsg0Ra2mPQn1O7l/4kb03jqcN2tjqo1r0Fd4+JDdFlf898D8LA9knpIS8zk9pO+0dAXUVJdkgBw0SluHlJh7z4BknNQ/beDDTVWbGfWvbRjrb2WpscSjDUFJvfQsz6mlD48Fz+rfknQdncGXjqblF/IP1ij1Tnjo51uVxVwEjHFqU31PPgolOKEfc1X746eM4rjEP3l+NnbTwUuHTWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(38100700002)(478600001)(86362001)(38350700002)(66556008)(8936002)(6666004)(7416002)(316002)(956004)(16526019)(52116002)(6486002)(2616005)(66946007)(36756003)(4326008)(186003)(26005)(8676002)(2906002)(83380400001)(66476007)(6916009)(5660300002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ox96hqA39dcaQow5RgNfAtXwWb6V4KyBCY6rK0PCEC/t8e3UsFSp/FGFmo58?=
 =?us-ascii?Q?unrmUxEtPJFKVi6OvJG3Ur/8PJUMKEoPUUX7fTbqOOR7efxGt78Q161SXjFW?=
 =?us-ascii?Q?U36HOiTzeMW6PXw9VzqOt7MsOEzu6F/ftXicRF5NBBqsugf1hvJmpJRmNomX?=
 =?us-ascii?Q?2ru44p3dKSS1aZlQK0PseZmLXVc4nS3CJcFX/gEs1ASGQ5aDomFpXj5U7dGo?=
 =?us-ascii?Q?C/lWWBuSmU4MTQLc1PbitkXodApRmVOfryRyvrODN/Dget926Lts4mru/zxo?=
 =?us-ascii?Q?wz+olxi2e/Q+XDEs4wrSu/a+9wiNN4syAtzWlv9V3fxykcllxG+qNVU44Hux?=
 =?us-ascii?Q?NZ1EijATaI1vtAxT6D8RivI/vOrPMyFEvcn4jI90lcGVgsAjr9xX+5rprLij?=
 =?us-ascii?Q?k2gZdu3Z3EzXh//oECrTVLSc9LvfkZM9eFCZYJM8ze1wYGZx/NNnjoZ1w9UI?=
 =?us-ascii?Q?eAHgTTXgcX0DcsNSmVdtIrVeJmoSeQ7o53hztjo82NhFp8+xtn8XBzdEBrom?=
 =?us-ascii?Q?91+teE9TOPM5hZg58L2eLh55qOAcDSn6DngZqgOwZewDSlfOBKdpf/7nS1rt?=
 =?us-ascii?Q?/6CKlFUCg/pTkfXtvwLfqyE/fuCsPkJAkfpthb43CHtuCxLWTyjytRxFQ/rw?=
 =?us-ascii?Q?TR9j43jKmui980rj4bPx/U05p11Jymgy0+lSqwzDTfPryxuuQXJ4kPClrepE?=
 =?us-ascii?Q?CdhvEU/AoX5PpXd/Ej/IhCcu9DBTvZe2DRhJnML8meLHTy9btwLI6DkgRIw5?=
 =?us-ascii?Q?AFd2yR+cLxlFaDylOYr5jpZeLphSn9C6eBUEZYh8/E7qioAIPXdEBy7uJmWy?=
 =?us-ascii?Q?nvypi5Ko2UAuIdBlHi6tLSmm5j+6HjvDk2E+esQBv935+2r0itALeW+CbMav?=
 =?us-ascii?Q?A1pp5lsaAIsawTQhlXIqC9yikpIYcf9MYpeI8yb35dE+/kUeRhtH3ZUZ+JYh?=
 =?us-ascii?Q?wMQ2ZQvR5PAltY8HyY4HsPsM+87iW9AujfNqGrekOsoVl2DV10o0DfAfRAsk?=
 =?us-ascii?Q?MlLdEvPQz8GlZC+H2D280AkAXDS8qZ47cmXFMGqAIJFmE8JIRm7IXF+stbuw?=
 =?us-ascii?Q?Tkgx+knVvBC3GX4HYvCTrTdnLvDdVgOr0YzMdnZyYrXPufShR25/couG814+?=
 =?us-ascii?Q?ozHtahRzaREM3KJkHTQ8PuKh6aseepkPjeqIJDkAoN29H65IlPkaekd9ym6b?=
 =?us-ascii?Q?hk2xGPXDEOD2sZpXirJ6Z2cppJd27IIIUSjdmSHQG5OvEqE67BxSwTS/upYb?=
 =?us-ascii?Q?aRJpL/c3U0qHKqxRl/jfoMx5P22zTO10deEVhOzGphU/3aJ2coYkHoocqPt1?=
 =?us-ascii?Q?CpfCnzXIwc7hqpEcSDpzuaJ/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0fe57e-1d10-444e-5a11-08d8fdeba613
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:46:21.9512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txLAOhu9TeSiW6m1U1U3Ab6GGqQTxCh4UmtCIbYKvdzvzQDr8YViqBhgK7QrY9eAtSj4qzUQWO6v+G5IhpVEMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
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

