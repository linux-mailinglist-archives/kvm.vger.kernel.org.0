Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE401C62EC
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgEEVUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:20:24 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:35425
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726350AbgEEVUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:20:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvCP0kDVzczrNyRDI8sbYXSbaifXh+0sxSwwI6/0WUhTDvkIXioGoXKOmNkgZqiWVA/IEIhXHGP4e9r3MfrPhRdRoL7utbpf0ViZrxf8JQAmBNxcn9UjNipjLQEsxmYk/Xx+ShfKuByBCxMPYQdvYap0Nhsy4GBEVxGVIslsRiRxxSpHipgmQrkr+A8S0Y/7wGFLGpqkVxuIxWbK3k2VvYRMhPf9eXuZHPR3xlEmfOy/TN9TvxBzyoP2Vu7oRN6Ay6r0LDHLtA5tAMLLlS49zFoft3zzOBNKKWwrv/fItoYuMWdSNYabG5eqOxo1uytJQqAV/aLGPzxGLFhMBRSSqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D/kK5cQCLuGeO7hC945SONJQJPxE71P6AsK3LWgYTk=;
 b=bgGAbdPKjUjku970jGicXOfvsgKI+ppnKjHX/SWnYXQ/T3+KtJnKYIBblMaO2XaChitlJLHJCH1ee0pZVUQFGfqG09iZ75jvnSLhvR0WrBy8JFSOWExlCTrO8MgmUY4pLZfdPc7u6Hk9nRuQKqPI68mf8pPUmVOnLq4jpi6b5KD3lVXjqfIoVoscsqEsErqXdhb+/yJfK5fY2fcsGitgSZPwH7N9T3WCAhgYWsX0Qv4NvOxDTypDlIXRDyjMkGktS/8TAkGIy5ctbej6qR691NdcSsJWyar2wHOdHEEweCcVJH/oajQbzRU5yvlYwJouIv0/J6T5/tH1wOBWuCsb2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D/kK5cQCLuGeO7hC945SONJQJPxE71P6AsK3LWgYTk=;
 b=3XCt+yAN1oMCEz4hZxw/PHO7XmNQ7ZWitWCUSUMhV9EnlhcF6p1pb6GXxcfBkKKQs2y9SPXWZB9OOIlOeYJfSOwM/ZlmCrGOq+xDSDb3sdHZhl/VZqKhepv2RqyX1Jf49pGyZLN6drmnqZzHT116Xu6Qodl7cBK1YWZrQ3Z18IU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:20:20 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:20:20 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 14/18] EFI: Introduce the new AMD Memory Encryption GUID.
Date:   Tue,  5 May 2020 21:20:10 +0000
Message-Id: <abeea5c7dc54cf86e74bc9d658cef9b25a8fac6e.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.16 via Frontend Transport; Tue, 5 May 2020 21:20:19 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c66a1315-9d42-4c51-7cf4-08d7f13a1d7b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB251853675F7249C55379790D8EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cCMYPo30k/cHdH4LE8RLu1MGBdDHXs/EgEqnhg8sQg2uPHRdDrN8e33OdnHL96N0vY0HwzgYTtwvZsvMCA4Esmmw5N1Tczt14JdOoyOaOp1b/FNqEs6tUgFtdLUkVfCuvUMFPadyJ0g4ElMLuRFeA5Fe9L5llDYwQh+iH10GEQcEjtMN+qBM64auiRM6yIKv++V5afNMMfBU/0sBp+jWXL6xY3wUoyGcdVANKeLtfPUTFUVea62ypxfXaGh72KLohIJB378Q5Y0uXWp/jRiVnUAIXgN/Vlyn1NrwA6qd85X0QOpMgsd0jZwB3cpgdDP8GvdC2kfOa94YlSjUM2HbuQ1jJIHWz5KynxulcDpYUGTvSIJro14s4u6UnNzTgEfoFlgEehti0AJQM6ezs8l0ytntYwPFzUGjmCqcA7XRCAeDJ6SuHIzlTHJ04Sob6Ql6M+cKkUDZLpu2y6WGZU+bY0dk/BWudQ7PqRyJD6gg0rQ9iXQVqiOKsdrEWy3NRM+hlHIDmcAw5mpS7irJXopeefYeQhVQoZVhUG1GbnGtfu8LImh/B6IntWibw4qnD2ra
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EaSLzdjKbVWIg348tdZflwQT/6VpczASOGYB9VCdw6dwnqwsYKIGxhKW0jRKf/5DEi9w513Jam+LkUi+xvqHVXujYQYbPMeB2JXHHupPUwxaYDed3vcNNegZo9eM4FMFX99EMYaVpai4v6N65v1+qozUmOierrbTNsnszVsg0dhOD/PSHotn/9S+5gbB8RcQH2eDlQbGhapYONLroI/MoneBg0NM48NvMpFJOEL52s76K/6ctPq7mJ7LOLKIxVOTkzXLrD28tb6APDar6F8DAdyusWQofuJ9Ij8rf1MhSGwXu+1QsIVXFUpZD/ynQuBFm8/piTFEwbn1BZyxsSded9vetTwMiLMTv111bXcfCqx0+lh2RpfzNyvs3UlJ66K5RQkHkQbPWRO3Nfuc1mIfix43gnHKciSU1k8P80xRGxC/eaChGUmCooQeXszKjx8STezh5l8XX7/1FqeSgaA8PnUurai4o32PO9t/oMcb7BLObvTAvr5TwULHgJc2bqmQu6Xo5gCGsNN9lG82ZI+r/r5DklW575aUlx9u9iX3Zc6PMdBXqvcBjX9bjmF5uTbsuTGtDEm9Qmcvy3+0Pqx4YllkIzeHns5LFQlVt8DdFDAVRzaA5vndLpL9pjqn3yKC+/zBXzKsWdBxmrcqo1AD8eRjlicme6bg4KgdVwnu8sEKP5qXNGp65+Bv/BA3Ewme0kHZ6jawXjbnTp5AYs+R6lLv+unFrUeDJtuS/fZ1WqV5dqPNWS7uLLy5vUXgsM+lSCmpF5yh16XT4QL9byGjt/oYnntO0GTRGZTZZZiAkQY=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c66a1315-9d42-4c51-7cf4-08d7f13a1d7b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:20:20.4002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ieIM9XTNMcOdsBqwJhZwE6AzER83wCe6wXU8K1qAts/9iY6O4FsHzG995RsorxTwyhy2GWBee76q2Xj5SuhAbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce a new AMD Memory Encryption GUID which is currently
used for defining a new UEFI enviroment variable which indicates
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
index 251f1f783cdf..2efb42ccf3a8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -358,6 +358,7 @@ void efi_native_runtime_setup(void);
 
 /* OEM GUIDs */
 #define DELLEMC_EFI_RCI2_TABLE_GUID		EFI_GUID(0x2d9f28a2, 0xa886, 0x456a,  0x97, 0xa8, 0xf1, 0x1e, 0xf2, 0x4f, 0xf4, 0x55)
+#define MEM_ENCRYPT_GUID			EFI_GUID(0x0cf29b71, 0x9e51, 0x433a,  0xa3, 0xb7, 0x81, 0xf3, 0xab, 0x16, 0xb8, 0x75)
 
 typedef struct {
 	efi_guid_t guid;
-- 
2.17.1

