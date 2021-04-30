Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C548836FAAE
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhD3Mmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:42:40 -0400
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:17504
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233284AbhD3Ml3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:41:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrwzZxrW9tUK6Os5BWgBfbs9mmpuTxk/8J9ZVgUibM7U8UW59wLYABFAODK52t16tidFO+gIwQBufvx3KLqQrZ9o3+EO4QrIPK530bMAzGoX8xxLgp2BkGVtBazQvUhNAVZu1DLonxWOaxRstvKA9wvinShjbVMxJDCAvYvc9nEl/7x2+KL3vTWow+4qhl8NRAXPOla/E5dwW04gDMSo0VcuxRW/6EMrQ2ryLHyYQ6KHRpRgjO5IuBpZU+7zQzUJ4uqnNcvv6zB+kShR49FMGv686ljHdx1GQUwpSRr0CDm1fJwGUC6DFST8xI3is6INf7o//kBVgal8uRPN4d7NPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJsHY8n2NA4exO9t0dViCB784NHvK8fDVYNzRX7Qd/g=;
 b=NSSSTrzkACnAbUxlkP8UGXynaDY6ZmVwCc8oqnoYkKn//IDwj4insDRxXb0gRzSuI/38kIjVOsG2jTPQJ9jkvbXphF7C5EO3npf/DpPkSSAIGruvbQIS/UOfDl1z/pLu48Nc5sKDgkXSopihvype/acq4HohCg+FLFcZQm3p+qVQIGqJGnoV1Q8cFH1U150K/9OHjKKzbAObijIouZ2XK3Lx59247UYAj2xve8UfQLqk00V4lGRQbGYgfVSYimz3oEQ6gi4rYjnTaLmPCiRV/1GLr+0xsWvj0jlR75GgI+/dGcx2a5kVz94mxnRCUcpQr4Ygk199fRXwniHwmAl0Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJsHY8n2NA4exO9t0dViCB784NHvK8fDVYNzRX7Qd/g=;
 b=SquzaKHpxdat2EB4RKKD760nxt+PM7WOhusw5HMDmT88Az3n9OHGs1iMu+BwCI6u+A2+v5ysv1bp+gz5KzVCsffUrs3YIM9miSvBwG8wRKf3WbQgppAC0Sa53/WHdmakA3RHMNvlGQoqgFIWSy6jxFZOlXngK9DVahc63fv0MG0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:46 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 30/37] KVM: X86: update page-fault trace to log the 64-bit error code
Date:   Fri, 30 Apr 2021 07:38:15 -0500
Message-Id: <20210430123822.13825-31-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf173de-a802-4d0e-40b9-08d90bd4f776
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2688957DA612002D979FC8D7E55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +q1p0Xt7Uj2/nqZsJtfFoNsKSOJw7e2BpDrzIAnFtpDXv7s8X/faCg/MHnHo+Rey8zjxv34/wAEtJ6iXAyO3DSWPIfW/zF6S58M1EwyzH6n/jXoHalmdZTrkOr4lXJn2SXzp1ga05YnMCVZnQGFP8jv60fSncg+v45Q6OlfseiDDJdCm0NWpYZQLxSP8ZLDDbUPfsofV6HZ2yfUnVs8MYEho7auuLiXwvDVMIJKaqs/TW8VW0FYi3fzyTjeAWgILt0dinzMfM2tbk/2L8NQ4S6S+VhDQOkHDDKiZR4MvBzSdqrSgYnCfoW5A9+YSAYGyw4eUsFvonI2OUnXZWCIPRd5k5xz4v4i3EWaISB6eUFSNlpjunCS2cwYsRiAo1F5L/t3kRPHsRf8VuswQloU0j0T5dIOkZp1zVMBKqciIXeDrrTY3PZQeJFnWK/s9hRh2tSqiZXWNmMOk1uHrUlgCobY+EBeuaRMtlgjcK44+XkHD2H8Hdj14Y81C+IybFTCQnythodpP1q0Rd5sY0JxWphxLJA48vpu1XzCYBgnha1lCs2YWCjRqbc9h1v/HoBQ81qUu2coGJYHVo1iUBwCaeMPRzfH7DR5f85zxKAFx9QcErsr07lDV+ZVWfnSEDCEVZgoXqPTQkv6N2Jyyg5QPHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o5No8qrilln7rG5Qnsxabv5K5Zcka62idTw0eDrgnb0f8/1rf/EYclrC+dzw?=
 =?us-ascii?Q?dbdbVzx61SDaufB/to31CWc1R23b1aHcRKDrsdPkQfR4LtCd/J1iZVJBsZA3?=
 =?us-ascii?Q?i6uTliDCb4I8isqnK0QveOwUFub7WnQtMmbDMydyLEof2nEUbWSoO/scuqdf?=
 =?us-ascii?Q?478zq2sbaVfsNFYR1z5/XUgr/ndTaukgQtmeVdSZNy8KIluAJAIcMved5tmX?=
 =?us-ascii?Q?0EvUmxcyB7jzW3sk11p5cM+rNfCbypA9EsxtnUmDid+/laV8M10X8Iw7Sh+p?=
 =?us-ascii?Q?A6GiPJCz6aBm4gboZFriGydA7OozpTDExQqMXBJrIF4cX2vOsjIFvAPr6Xdb?=
 =?us-ascii?Q?c96J6BeNJIW05sj8q/kVTfxZc5RWch3NwLvt1wKNzPGSyuWJuCSNNreFa3Sg?=
 =?us-ascii?Q?cQEshZdC9EhtzfXZovUA4TR2FOTaBWpToWvVVB2Q79S72q2cpMsuxqj5xi3c?=
 =?us-ascii?Q?s1zVe5wnRFA+HHU8YKiPVlD6rMat1ZqbcuLf2AEeh0HPF7m6YmOEwmESs+kh?=
 =?us-ascii?Q?kT461GvooEsRClxr1DjGhvZeFZPtd01Q1v73pvPqyUtCbA/1HY/gHAZl5Le9?=
 =?us-ascii?Q?DLKTaWIPwRwBXYbzUwGa2x9gQDEkWcROf7Mq1mcWYSrRnledgpj123+Oe1IA?=
 =?us-ascii?Q?ggkEZmHnPdqv7Wr6XaarzqmqGAlxT//DZrPVHOQunz+bwMWrj6ONoA5MxgXL?=
 =?us-ascii?Q?beg0aw+Uo8gHK7+jZv8zMfNHqWXv5Qyqlhqx1joNLxfs6qnb7Y3wuGp90maX?=
 =?us-ascii?Q?hpeUWiBh43KtJQlPMdGplXjt9Z+glGJ6692lQCAFGTjoXLuSOzmlf5/zfM/z?=
 =?us-ascii?Q?f/S4oqq1zlvMGQPQmjVd2tlceZHXpiRkevHFaZtwv/a1FfcECgHD+SDGurw6?=
 =?us-ascii?Q?8AV0QmHaGs+gHqdigagOy8+BVu4ZnuNcr4TrZZh2dzZ4EJrJ62e0NLQO/wOZ?=
 =?us-ascii?Q?091qjTHN7Upv8nATEjvNJJLUTxXvoc9qEb65chs/fUo2J30O1Zk7BH+14ERb?=
 =?us-ascii?Q?TnE91+CZ+yAoOdoJIWtb+O6xetEHD7MqnwH8J7TV+ZQBh3NzkbtShtruJ47/?=
 =?us-ascii?Q?mBIaxGWiGTMk1IIkseeqZ3WMXT0wfw+NMb99mZfPyfLa5cOtSaDct31pJ5e5?=
 =?us-ascii?Q?NKerYM5zIcOlkztSg/QO91HzxzIo1BdP3OYbucxIEnKuUB8cc2JCd8V/jKpU?=
 =?us-ascii?Q?+9zAxU2NeJbWOVq/T6/INLs+xMvZ6Fzf1Qkp7rkZTbvWAVGC8S0O6VpDWLZM?=
 =?us-ascii?Q?qO6kx5paIhGfqEd7Ui4WkkMrvMelM2KFgIQZKX2TXsbQpjUGzbVC3mMtYQzT?=
 =?us-ascii?Q?BMtdbn7j67O18i9y20WP9MxF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf173de-a802-4d0e-40b9-08d90bd4f776
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:16.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ckMlq0wJsGshKVB36Bh/aUMtNJmD1lFMGSXDz3Eq9K91UqHikwpjCxX5EJtJpdkV3GwGAfVkI4u10ezDE0A1Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The page-fault error code is a 64-bit value, but the trace prints only
the lower 32-bits. Some of the SEV-SNP RMP fault error codes are
available in the upper 32-bits.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index a61c015870e3..78cbf53bf412 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -365,12 +365,12 @@ TRACE_EVENT(kvm_inj_exception,
  * Tracepoint for page fault.
  */
 TRACE_EVENT(kvm_page_fault,
-	TP_PROTO(unsigned long fault_address, unsigned int error_code),
+	TP_PROTO(unsigned long fault_address, u64 error_code),
 	TP_ARGS(fault_address, error_code),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	fault_address	)
-		__field(	unsigned int,	error_code	)
+		__field(	u64,		error_code	)
 	),
 
 	TP_fast_assign(
@@ -378,7 +378,7 @@ TRACE_EVENT(kvm_page_fault,
 		__entry->error_code	= error_code;
 	),
 
-	TP_printk("address %lx error_code %x",
+	TP_printk("address %lx error_code %llx",
 		  __entry->fault_address, __entry->error_code)
 );
 
-- 
2.17.1

