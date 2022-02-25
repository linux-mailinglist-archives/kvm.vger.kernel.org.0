Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAF44C406A
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 09:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238622AbiBYIrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 03:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiBYIrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 03:47:14 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021027.outbound.protection.outlook.com [52.101.62.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C053F8BF;
        Fri, 25 Feb 2022 00:46:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7upBA3oqY7ZocQ9+GQnBPJF+9Cn4q3rPdA7wfgk+GLphA0PLh5Acp9BnzsfGA840URfy6Gvyg3kb0CZeeXcA9IG1WtAytvUkFShiy+I4Y7hzwLR20vtaBH18RnT92GXLeFByUBhWvHf/qaxinuiPuo4NULgxsPVMGCZ7Sz42dIXnPOTcFAx/HIkiFSDEkoAZXWzShL9shD0Nd2KnD8D+JjPpLhf8kNC8kMjFkBDqkciYRcTD6T/EG2W4IkI8svEoZ+hmd6MHmFtDFMzFb/TACx3VSoYgceYZJK42K8In9GBg4WktQHSzzt2zaQaN0MavQCF5wl5BdfChEWM0fpicA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dn5lKqV0kVUXsFG+fb6TyQE4g2tggcdrDbAXOx3AtPA=;
 b=SAnJ8FQBVlEu8BCAaJMzARpx+4i7mcccpuO2/YY1pUbSCWNLGHdTVAMvgnZsPGbSMZY9VlKOX8b/WsQqMYZjulgbTpGfdcJ7NfOFbznDpLa/Ug9SZbNerIOjIU9hGBGdJwep4Xw9aFsCP05BlL+N5uBz/fLI/53VqTMbpsJ+UMh2ZRInQu3xOxjYLceYPuCkvfo7a8BfVmkLKEaODSAO/GSbcT1nddOy1hIGgUGX9tALoFw1mnR7khsaRDkjhHYz2tvrF8/8TJqoDDsPuDZjkHaLW85MraRo73mV/keY99zqMmB80Nxhz9NXG8SchkVypa2/ByWHQbPGfjbApaysWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dn5lKqV0kVUXsFG+fb6TyQE4g2tggcdrDbAXOx3AtPA=;
 b=iDHPS3T68xGdSfkSXXvNZ1btDvuQRiyRQiD5WOriMCLw63USebIv+0PsntGCHmk99EJlzJSFcE5arY8dlD1VmtFS/0HeTzPdZXHsViIdLDdSy7ovXHomQ94Z/fZ/RDdaoSdALvAwiagNyZfHAIML1FuE/PoFoivxfIKhX5vf63E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by MN0PR21MB3291.namprd21.prod.outlook.com
 (2603:10b6:208:37f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.10; Fri, 25 Feb
 2022 08:46:33 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::ddb8:f18c:c46:a941]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::ddb8:f18c:c46:a941%5]) with mapi id 15.20.5038.007; Fri, 25 Feb 2022
 08:46:33 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        thomas.lendacky@amd.com, kvm@vger.kernel.org, wei.liu@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com, Andrea.Parri@microsoft.com
Cc:     Dexuan Cui <decui@microsoft.com>,
        Andrea Parri <parri.andrea@gmail.com>
Subject: [PATCH] x86/kvmclock: Fix Hyper-V Isolated VM's boot issue when vCPUs > 64
Date:   Fri, 25 Feb 2022 00:46:00 -0800
Message-Id: <20220225084600.17817-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0101.namprd15.prod.outlook.com
 (2603:10b6:101:21::21) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f95982d0-2918-4a00-38f4-08d9f83b5259
X-MS-TrafficTypeDiagnostic: MN0PR21MB3291:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <MN0PR21MB329198B30AB8A8C496B1818BBF3E9@MN0PR21MB3291.namprd21.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TudcNnbej8MFe0t29nCIZ4FGb9K16EH5/Wtl5ePSLNImsN2XdeWrE59MKqAwERzqgGNHO3GSRoXGFAlZpjJm2k/iGxLUSolvdfg99o6QQdwn27+csszPoMiL+wEOMMZEL6+r2OofB6mwAKtCt/WnpQU0ypljCcn0wcnxYHlHJjXCoyDkid1IhHQgAATSTy0jWhVOw7XUF3Mano7AMlUwfDMShIJOdlgdoaJTpzGpxH9CRpcE0aeVUvcHwar8ZZVsqhAONLpNvL0FEIx5T7pYaADOVsprFI+WMFI9CIxFrfwLx9UvOWpGhQED8aDXGNVIamMECvqmER9b5SohuHfRZQeDIge9QqKWtcmG0RttLgBUqka5RmrjfMJgA6W5dQwMLWY82ky9+wdWtD3mTI/Xs2NSsw946rpSgv4sVZuAnPj385L21kknC2ux6ZYM8p4cRBxh0sBikPhRyjI1R90Ye4mgJEp+G11i/KaJ8r9dTQKKTw6uq9xX1IqejJyBV36DxcpnhO5C8vHALtjPuj4sVI1fdxlhSOIJP/ABtfe5HxIGTdmQxkNvq+hMdAGVJmkQXLlebstq1gN2Fv+Z9FfUVNm1OcUtxlNQtath32FlfeR672fsjDpXm9Hf7iYzc5HaDIWSlXEMtjvGz4GRu0DnqNhLfarmQ/YENxZT6Ct1hFP3Eb8MmF+iliqGQ7Qwybcmf5IZdW4eBDQbxbOs8p3qhiYzxqxCt30B2gnbAIHmhLA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(7416002)(2616005)(6506007)(508600001)(186003)(36756003)(2906002)(6512007)(10290500003)(52116002)(5660300002)(83380400001)(3450700001)(6666004)(1076003)(316002)(66476007)(86362001)(82950400001)(921005)(66556008)(8676002)(4326008)(66946007)(6486002)(6636002)(54906003)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G8NT3nhV3C0UHVmRzMZjaRH+10WiS4hWTk2hVp6GBv+B6Pn/pMafHkykeW8F?=
 =?us-ascii?Q?/FY7/k/IbtB6fnlENYG4pxwJZ5cYiropDAOJjbSGGogmOwBD1U4lTmUPnRuP?=
 =?us-ascii?Q?8XQmnJKdzteaKvH51cce/+AIhQip7/W4bw7Hj3wKByTF+kuFq2te9xU6rbJK?=
 =?us-ascii?Q?DIUhHWLn6VRiMBBCU8Q5BHnR4dVCjQCO5XzZ88VztH2GPUz+QaaFdWcb7bLK?=
 =?us-ascii?Q?maL8fD8f5fn1Bq4s8KHnEjck1PmMxlKHV+J1JJpG/q8OZVqHX4ZEXCrAB61k?=
 =?us-ascii?Q?pw+rX/f4Nr7o5FIMnyPXLF3n6CID3DHeC9Dvc2dvlUD49vM3QB2uMFzKmbxl?=
 =?us-ascii?Q?IRYmd2CkIGPjcvkI4fePzJTUOMaKawAjBg63veourp46R6dtYMpJ8vVwQmWO?=
 =?us-ascii?Q?o1uYn9nVJ1ddjIVSkJoe7GYVj7rzDXnpfNiPtpHg87XUq0TAyrnWFcURW+JI?=
 =?us-ascii?Q?u0rZhTwCRkYmTE6110fCnDveT0cbB9RSFpqPi6DqWQ4x9ADFDuY08ieaIg3V?=
 =?us-ascii?Q?Dotuo09fEx9oDUPVPRp+0349xNlqLkLdKY6D26JpsRY0vli9t+nplhHAHB+7?=
 =?us-ascii?Q?dxlZU33s1C66RNf1UTzT2ekXGfmYRoCVdpENPn49G5Jdg/cdS5i39EC6uMCS?=
 =?us-ascii?Q?AZh6v6nHOwvzme4HukbgTzyERX2cQN+A5Lfeb0zZAOUZAMUvCEOlAkkXM7jh?=
 =?us-ascii?Q?7EwoiuZIFBLiB7Ukn1XDVzqqx7adpiRmZEd0t+8B+N4E4QHyuHYSrobdyQJE?=
 =?us-ascii?Q?sV8eKHaUQsOJpnurNbKms5u/Pt5eXzbwwIq/9R7WJqABpbAsicbqe4cXqmca?=
 =?us-ascii?Q?6cF1p/mMlKhOv+2W/gCsAT9PCMtuinEouixVoQrEyO9lEDAH0Wsp0G9hOzh+?=
 =?us-ascii?Q?cdrDv2h6s/+eoqTLJ0k26LseMbx9LehI4vKqEkvXyeXPs8IZo7cGohQc3tTR?=
 =?us-ascii?Q?Mdkewn5SXqiRIGCOAaQRsWM6iTg7Uch5bfQ2OSsQHiebjcMK19AXwKbWG+VG?=
 =?us-ascii?Q?djBbGSPxgjmyK7+Jv+VqDDVOW9eZrZG25n8AsLRGnftzadf15QEwcOdzS5x/?=
 =?us-ascii?Q?+YvO5sopSEVmcRRsekDa8kkvX2hEkHeZo80bjGAbairLqYL9bHFzhFJDCTF2?=
 =?us-ascii?Q?2bapOGCVoRxVGoXOvF4itTZZ7hQoj57ywRBDK3Ui6sYtWjiL1hPaT7oiCB8+?=
 =?us-ascii?Q?9pb9i9bbXvHVVxAaRjYPn3FW7b9wnY+U5Jp/QFCKSQu7MPlWnTnh5BsCZE0V?=
 =?us-ascii?Q?PryCVCUpM4nvvItfmlfEB0ZHXIdEC52pJk1/DmrTgxM5u4duwi4ZcMdMf9LS?=
 =?us-ascii?Q?Y3xlf4zssCPZs9WVWQYLdpovE1oky3QTTF6JUP0llkfPTe5LRMCoGNxr7xze?=
 =?us-ascii?Q?gdEiG3ZRH0GkxXOwpMH1mVxCsH6tP/enEfhJkKV7WaeHOLr8fMz0sOfdHK4j?=
 =?us-ascii?Q?iTbw5h1jYB5M224+J1UT24R3Sk2YB5G4ryWsYzT/8FNArW5/Zh39kmshd0FZ?=
 =?us-ascii?Q?1KeYJaRQYj3VAjLO2W1WhSzZlpqp/3ZxcHquPNG30YvozEnDIxYAt8PkmAB0?=
 =?us-ascii?Q?LBZ7GwuooDyovMosu+q2hMvBfRbAmOwEWNjePSWHB+pRqHQ10G0VxP3gSERx?=
 =?us-ascii?Q?LIaitGwxs6aLT/cQeDUsJFIT7NA6EpwbVuICvajbVXel/AOl0MrldoSVV9Kl?=
 =?us-ascii?Q?ErPltKxZsA1ZpmgIGm2loNV6hk0=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f95982d0-2918-4a00-38f4-08d9f83b5259
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 08:46:32.6884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3lLGoO3QP3LihEdWZ9Rbepa5mbaCks/kEHz/gufhfEfV9gK311WQvPouLvhHO0iZ2waP1F6Gi1StMF9mrVJ2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3291
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When Linux runs as an Isolated VM on Hyper-V, it supports AMD SEV-SNP
but it's partially enlightened, i.e. cc_platform_has(
CC_ATTR_GUEST_MEM_ENCRYPT) is true but sev_active() is false.

Commit 4d96f9109109 per se is good, but with it now
kvm_setup_vsyscall_timeinfo() -> kvmclock_init_mem() calls
set_memory_decrypted(), and later gets stuck when trying to zere out
the pages pointed by 'hvclock_mem', if Linux runs as an Isolated VM on
Hyper-V. The cause is that here now the Linux VM should no longer access
the original guest physical addrss (GPA); instead the VM should do
memremap() and access the original GPA + ms_hyperv.shared_gpa_boundary:
see the example code in drivers/hv/connection.c: vmbus_connect() or
drivers/hv/ring_buffer.c: hv_ringbuffer_init(). If the VM tries to
access the original GPA, it keepts getting injected a fault by Hyper-V
and gets stuck there.

Here the issue happens only when the VM has >=65 vCPUs, because the
global static array hv_clock_boot[] can hold 64 "struct
pvclock_vsyscall_time_info" (the sizeof of the struct is 64 bytes), so
kvmclock_init_mem() only allocates memory in the case of vCPUs > 64.

Since the 'hvclock_mem' pages are only useful when the kvm clock is
supported by the underlying hypervisor, fix the issue by returning
early when Linux VM runs on Hyper-V, which doesn't support kvm clock.

Fixes: 4d96f9109109 ("x86/sev: Replace occurrences of sev_active() with cc_platform_has()")
Tested-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 arch/x86/kernel/kvmclock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index a35cbf9..c5caa73 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -239,6 +239,9 @@ static void __init kvmclock_init_mem(void)
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
 {
+	if (!kvm_para_available() || !kvmclock)
+		return 0;
+
 	kvmclock_init_mem();
 
 #ifdef CONFIG_X86_64
-- 
1.8.3.1

