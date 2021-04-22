Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA83536884E
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbhDVU50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 16:57:26 -0400
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:36448
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239575AbhDVU5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 16:57:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiQGfO+XMnMXlBCnoc4Zn057dR6WUY1gvB1LSbZamfcOnXETjiOTt1K68zqB+iy5IdixEEg4xBi8nEkAsPWQskVF3ndA16rQ8Er4eFZmo5AbkP0a1EZ4v3eCKWvXvplXgSf39j+FLZ68gU/76O14mkoxdH/cnyi5BPY0Gb9l6Ga5I6LWKUSOGEbV292+BCDCjdhHlQlgXD9LJI3DAZOD+QHd/MJw6l6Xw/+7yAhDh2JQyfFSKuLmMMhoVbRXlFys3MKN01Kh8+fy40Vk6O2MkgJG2b9MSVwBUXxKr+t0hRiJ25D8xYG/RLFg/vcY+DYaXBDMzfcvs2+vAaKq9u9yoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kP40PdU4Z8HHa6wnZVnRT/zhr1u8HNB3yWt0AcQt+JM=;
 b=g2I66d1BYWz6S1+mhN7QoGgaP5iMisGjFTDxm/7h2XG9QWwuvZG+UYrXEla80sbmjVz7U0ccnjeKvC1KJcgMSRbcySA+cX8hQOKMY871SQUMawMZdip6EPf2vhHA3rap1j/sBwUpzcscBm7ekx2Q7WeIl1byJ0Qp1OmQZTR8TgCUX3IyntzhLGsOCS0dOeD18QVT3uWmZpsw9Br9PnHHr+3dvFKbdv6Qn1EFlmHqm+D0UW6ERyx6ISp5WKpZ8XDYqvBAaXACOklUN9dqJGkhz+y8hdL/VHeljQe4na6EUJ4sExMsjg+f48xqWL3MNzCXcL/4tEJPCt2aIsjnuvWnsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kP40PdU4Z8HHa6wnZVnRT/zhr1u8HNB3yWt0AcQt+JM=;
 b=rvaIkUk7wx1SOk7scAiK71P9inIVF3QOiJoV6oBMq6z7iKOW5TGO8rea0FkQ6r46s4+GbL4c1QoinoR+Gpvh1RQaT+iW9K5QIem52ijd5a7OxAzpGIAeigtbC3NTqMTJjWn9ZtLEU0U1VMwpGkdy6frCjOlwZ86/6dKAnk2QNwM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 22 Apr
 2021 20:56:48 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 20:56:48 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH 3/4] EFI: Introduce the new AMD Memory Encryption GUID.
Date:   Thu, 22 Apr 2021 20:56:39 +0000
Message-Id: <eadc5fbf90e02fa4955f66f0d62661ed781c3dbd.1619124613.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1619124613.git.ashish.kalra@amd.com>
References: <cover.1619124613.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0801CA0021.namprd08.prod.outlook.com
 (2603:10b6:803:29::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0801CA0021.namprd08.prod.outlook.com (2603:10b6:803:29::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Thu, 22 Apr 2021 20:56:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2caacb1a-ec9f-4eba-be95-08d905d125ac
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509F0D0D96E0CF914F4493E8E469@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MAhMdgjj9TLObeUyAkXTB2A4PARxou6oE89ClQ3OKKbqphVosleihY+lsKbX/6Tg62NqZ/bpAR/u8VHdA+UkQtIjlMYOtd33JPajByI/PuzPCRAA3DJFx0otNk8mnPkS2nbO3i0NO2vn+lfiJev6/wJaKkVqKOr53z82w/WwHng3LG5hHh3fMNGz05Egeb5DpvWheM7/cbmXEWcJmu6MySOFiKYdts5Wh//hU+KYL1qukADYT33YVLCSRAefmLkZWLtJvO0jKau7jX5ilJlIWFIs5WqeEgvL4E5dFFLV/3USeMuw8tVh58upzIOeSE4RhuddDWtdGQTecDQeHJKvATsedMz5MHyjpaceMwkZB6FOUUXrVGRKKQJCtRiCdx7f1Xamjq3lgMkblmaX9UsOSMOPE9llg8O07VUuCWRF/EX2SMF0phcKByMQi3+5UXvljWivQBsu6QDfKH9kcwn7WvRhqVSIpC3jdYLknxtM+ULLy1ha9IlyskcUPVqxWvol599T0dkFCO5OQ49ZtGbXzgSG5nArQnSSGjaDCmpQXaaPdDKbtRuf6wfd/Gk4Hd/qd+Xsl/TTCTLSFAOxb12n+1jvk39VlhgapF3J/JHfa+DBMq9pjEQSx19uoFYOX78zE4ym063FwU+87iMC1BcALg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(8936002)(7696005)(26005)(8676002)(2906002)(186003)(66946007)(86362001)(38100700002)(83380400001)(6666004)(6486002)(7416002)(16526019)(66556008)(36756003)(6916009)(52116002)(4326008)(5660300002)(956004)(478600001)(66476007)(38350700002)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?frq3yls1anxbELJrSvA8UaF30UsrYd5uw1Yh/C3Dlhuw1TE/jmKfFWgRKq8q?=
 =?us-ascii?Q?2PmfzrMEntSyDHPtefot4RwPO7Mvi7Nwi1pCRewuhqbLYIJk/ecFpNWUotDE?=
 =?us-ascii?Q?zXp37q/qfLvYVLItfsgo14+qJksUrQH7I23fEOYMgyz/kmplWtihg9KMcyA+?=
 =?us-ascii?Q?O/Qqf/ISXPiw7dB7nnbGxgFHPe+tUVjY/poDr9idPwJIG7pPbGmwSoAiQRJ1?=
 =?us-ascii?Q?1YzTGnfZGS4wl9bnVkxru7uB8UzevW1jmGn2BauZ5jmeb9tYF5C84lXEMu6u?=
 =?us-ascii?Q?dFVRgC0fyDtnglg7dfjOk8WzMrcSh2TlAkjlrBYz+9BE7z0u4n3s2Wm/vzAf?=
 =?us-ascii?Q?sfAbDP8DdgCqtajN4EYMT9nLTCgd4ndIrmiUW6tIrpaIHuPfE6AONgrB2H0L?=
 =?us-ascii?Q?cX7DW+KVtpdMQQu4bbald4rIrHjZJbYqNWHXsnT1EMB7eFMMTPlcRKxJVN2R?=
 =?us-ascii?Q?hYjIhYhoqSd27uz4iBm7/ssPckJ+/DIgvmqmMl4RLuhwy3YaLiRFAKxVbpwN?=
 =?us-ascii?Q?L4WtXXi1EZpR89MEYNnZRruzvNZ+z/EG4PcSEKSDKWIpZ8P5MiWKLs7wVx4g?=
 =?us-ascii?Q?Ill8c78UthMXYXQjygrJJ49ChX+JgkzqnvgqMFF/+OMeiknEo8QurG4tBzIb?=
 =?us-ascii?Q?v492uMu8QsbQFGdU3tiNjsg65jevuZp3p/2hbJtleYNFVdTGTSuuOrhJ0jEK?=
 =?us-ascii?Q?R2iUX1VDQPHs2SNKS02IE+TVhFpqgWPoPh6qOIxQ7Me3UIpby1dK9TrTIWjE?=
 =?us-ascii?Q?VznZ16SpSS/8BUn2yjGcg6ERKL/FVbrFDBijKf5k+1R36NczGWl/saf0tIOv?=
 =?us-ascii?Q?vkKU9MwaidWNqBTyH3FHNsqZwi+5EHdTv5t7/OjjWvzqo0tlzS9buHqFxlQi?=
 =?us-ascii?Q?UHrQHr2/1g7MT2dczR8Y1/MGDvidXCbFrOdDryiJZSwjaf5TC4z7wwSAxOyM?=
 =?us-ascii?Q?Ah/xT9/ahq0ungQsaAGKXXLbxpFJmtxUBvQynhz18EG92U6c3bssfbqAZ10G?=
 =?us-ascii?Q?XVgOOQiWrvoYkD+6TOVlP+U0at4DPiE5AiuN107E8FBp6FxrF70dT07WFGIQ?=
 =?us-ascii?Q?Dv+yR6jhrBag2x27LN0h0xayvSt7RyANQ95faq1rL3p3y4F0mSXouVsWbWva?=
 =?us-ascii?Q?40AGcVsarWotCaQkhkbHNhX7t2Otwj1x5OirJQZqU7TEPKzPAMLLpMT63j+6?=
 =?us-ascii?Q?C9oyzN339NdJnQA9O/E+LxrCNzjCrmKt/aSwSMiShMrq/P/Zyc1jia4O63Yp?=
 =?us-ascii?Q?JxpriLCm1eg/6uIiriExsc1Y6V7g83hJMndzUFACumXGH0xj/BvcyH/JRl39?=
 =?us-ascii?Q?EQggdbX3hN8f9hrHLty9eiGo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2caacb1a-ec9f-4eba-be95-08d905d125ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 20:56:48.9106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AwmQ1xedRhQj7755Z6eOomt7ub8NLVfQaWh5zFHqrINRqSa4QCs1+ZcYXyQ1SDjGyYvOywXr/y8hE0QFZZK2Iw==
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
index 8710f5710c1d..e95c144d1d02 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -360,6 +360,7 @@ void efi_native_runtime_setup(void);
 
 /* OEM GUIDs */
 #define DELLEMC_EFI_RCI2_TABLE_GUID		EFI_GUID(0x2d9f28a2, 0xa886, 0x456a,  0x97, 0xa8, 0xf1, 0x1e, 0xf2, 0x4f, 0xf4, 0x55)
+#define MEM_ENCRYPT_GUID			EFI_GUID(0x0cf29b71, 0x9e51, 0x433a,  0xa3, 0xb7, 0x81, 0xf3, 0xab, 0x16, 0xb8, 0x75)
 
 typedef struct {
 	efi_guid_t guid;
-- 
2.17.1

