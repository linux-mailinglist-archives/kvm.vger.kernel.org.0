Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B820736967E
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhDWP7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 11:59:15 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:21216
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243068AbhDWP7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 11:59:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksJe6jpa9G4Wn17zN63uA/b78ftNWToON2m7Z5eUCO6uaGfpeuoU6NfAYVxeGGtTbVlNgsaLz/PTwNzEYSL5idjO1NBFW8oASpzAe1GJn0mcpHRTguyIdNzVmVe0qhEKqvwG3Ik+MaKsMU+tFVlFcD5bUCguiAOuIGb1DV5yrUKA53LG4LQyYWaAg1MHhg5OplxLuafbMdqnjGIw1HkWyOBgUJfPH6KmipfMqMvokQ8dK1vktS0et/wSNKocUaAXkWHyMQLUus5qYyC68NswxtTZdb/uAoaWsxqICbMg0qMSbDAKF/kRGDpgNAHk2ukyQg+Y89tfSHdW7tGKYm7yow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbX6VSM3gY2hDVfwBpZ4zpupPxEYMewOcFc83mr9Buc=;
 b=R9lmtPX7MT0btvU3RwwN/U5raVb3P9EYLI6jSeh0VOxFUfVldHZ80rn6fYoK8CXUqG1b9BwA7YEJHfg5WuGVsLEvItebsISgKv61yrlxsPa9n9VEYbkiLU0SmZGR7W1cHx5BCvORvx94epmmVBk6k7w/zhfm9k8vYlbrH7vgLpMZ5U+Mn3d+e1d6vVSIqcGqDQlCZYF097BM2kJRsrYbM737NmzfKyTDkN6JVw+pA90xFEmVF7H8JHwtvpOC1api2YUaXNKKb+tpkyXRb7jX3vGorHKqlaMjOy72HBLi+192yvnEP1kBkWYib9zt8MSVXISKLfOFIBCEY1IH2nl2CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbX6VSM3gY2hDVfwBpZ4zpupPxEYMewOcFc83mr9Buc=;
 b=VOeRUdY+jJpQmXKGXaWCdUm42qZ3WD/44A8HCSxtyMjNiEjQgogznL13JgxaGevG/qmoumqTxxchMiHQRF6IPaKE8oVujVHhcO3jQedjteZHzr1kScJUVgPOUe5eWHo3FlabllPnCLfbb8eesQyCeTHBk9xEsWOlNB1kVHA71ps=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2639.namprd12.prod.outlook.com (2603:10b6:805:75::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 23 Apr
 2021 15:58:34 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 15:58:34 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v2 1/4] KVM: x86: invert KVM_HYPERCALL to default to VMMCALL
Date:   Fri, 23 Apr 2021 15:58:24 +0000
Message-Id: <76ad1a3f7ce817e8d269a6d58293fc128678affc.1619193043.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1619193043.git.ashish.kalra@amd.com>
References: <cover.1619193043.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0078.namprd11.prod.outlook.com
 (2603:10b6:806:d2::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0078.namprd11.prod.outlook.com (2603:10b6:806:d2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 15:58:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d28f07b-add5-4ab9-f28b-08d90670a639
X-MS-TrafficTypeDiagnostic: SN6PR12MB2639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2639E3F467017B9E309AFA848E459@SN6PR12MB2639.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mkziyzWRth5e/CaMoZEhdZUXWWMzGWDCvc2cm3unEbW4nZnKKAbicBArySox2X/nfCGUEBFZYVR5KWCBlmsQJNJpf/bWyQxMQ/83kAMfc81wSDNWuq60av7hgg+zDV0qD0Kj7lSZ1dY7Lr5VkopMODhY1ew8Lk7S40wN/Z1GjF5fEadQqus8GxgRoARtpHSLTMr/0AdMQTwUtXadZ1OBzFRJ6yo+9lCW7naByqa5D/aq2lh3wREdXACxOQv/JFYnvJznJ9Oz35GczL26FeqVq2HPuZOS2oeztx5ywQi4L2VD8L5Y4cHhuii+dgzOPCmQ6ghtSEcwb0BRYVlCReO1RYNoZaKKnL974tAXM/KT/gZsH3KUDuvTQ+mBKpdp/w9ubYWeve1EG5XeJhg6Ucf4+8jF9uAFc/ZJ8QJtWeLCF4sEi9smoZV/bbpPV/ELxWiSkSbu6+/huWfAYZNPHEpAYKx58RwWM8vJGltm3zdYV+CwINjeK+YKI0lkbi2bIWozsKbyuDUicMlFDaIsatxnyyatnh2iezRcwuGK9h1Ql9HVTG48Aq2ZmlX+kJ8VCYR/+YNOP4Mn5C6afVybWD9Mib0mLLf7jwEcsjFdszqbSrC15pmvuRwebWZwhgoQVpMXRwPGptvcSbQOsFDZaAXANsrG5JfwYBvNR0MDE0Sl77A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(376002)(39850400004)(66556008)(66946007)(6916009)(4326008)(478600001)(956004)(8936002)(26005)(186003)(316002)(6666004)(7416002)(52116002)(2616005)(6486002)(8676002)(5660300002)(2906002)(38100700002)(83380400001)(38350700002)(36756003)(66476007)(16526019)(86362001)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?62ZnAa/BMWbdQBtPHfdu3bve5+E3xVbAqTIWScI1++cZ6bVja530mGioQuMR?=
 =?us-ascii?Q?2bSZ6uTpXYr8CI9utUb79O5CkQpKiKrcP7yIuAAxzfse5qLb5OP5F2DzHvkb?=
 =?us-ascii?Q?/5mFj73RlgHBdCTTa7vWPqFpwJlaqVUkE2DgsO1F0r7QxKt3gETE54q5pu2U?=
 =?us-ascii?Q?/xoue9Et9rWqpn0qPL4QZ4pLhfgwJQS6vu25ecb8leHTDlaVtpoYwkiU3WD7?=
 =?us-ascii?Q?/7FgEmFrPBMLJxhSd9C7GEbzxg/fPrh2f1xP87u3k0a8F+WqTex2I33kZaMq?=
 =?us-ascii?Q?R1gn6BDEq/gl6vKvDF4rC3OQqSPfg5rh8iwlJOhFoOwZJR+/cdzL6DEbjLSo?=
 =?us-ascii?Q?81ZpLvoMeTWPS9CJv4tOD5no+9DkoLs5/pv5YuzY6xBAhwysNBuxziT0CjJz?=
 =?us-ascii?Q?hAIvaup3g2BJjosOscP2/p6E8+SkKwsGoiAMsqReAE7+r3YS2S+v4PQqu/Hn?=
 =?us-ascii?Q?pC5aqmt+Y2p29fF6qtv2UuUFdXVNlpxoPjqFplbmGkYNtSG2nkdGSQqGuV+D?=
 =?us-ascii?Q?9GBEkYqMZ0lFYayRYP/HfaUVTtCP1daqSw5NDQoOohkFubFA2r31rKhQeo8E?=
 =?us-ascii?Q?V+0IoPXjzJq9PmEiM2hgtBNqz6H7QAnueurbXKr75P13KWPFadmho50xXwk/?=
 =?us-ascii?Q?Yh31gP2Ebvw1KccVgfJNMFz6NR6HzNAd0qLoN/ESg9ZqrTuFTodfGEv89wPe?=
 =?us-ascii?Q?+QLB4OP37cRwiUl2QJJ7ncqINrbjFgSQbPcVKXQldUzKDlCiRh9z/uSb4GKz?=
 =?us-ascii?Q?P7FXmF9wzf7XnA6lgHK2dhAfx7qgYG8te2n+VIg6l8MhWHpxr1jf9z9X6IbH?=
 =?us-ascii?Q?ZCRNmuFQDEzQ86rVMb4NIHOnhkbXXM6FVD8mhgIa8Fci/jckvirdi1jpVilp?=
 =?us-ascii?Q?nR3B7u+AUdxB0gV88hG2CfCbPTec5zaGHdCHm/Pe8yU1uE2XwZryLHgfAF5Y?=
 =?us-ascii?Q?x/DoPkok7ypTdSX3uoKlV2uXsU8d3NYyo7s4Km94DZeXAb33azrHLPcX03Zb?=
 =?us-ascii?Q?OAFj4uw8xEJo8JbEtUytqLf2o9GAA2OX44Ao/RsSEmXLJDT1tNs1l91y/Vwl?=
 =?us-ascii?Q?Qn5mo5tcVxsydinKmEqv45Gt0DsCX2U72rTqUxGyP3120XimkgRtKIcgKxM6?=
 =?us-ascii?Q?rtwImZPjcWN+r0lTIJVuILwb9lha8EG3QFYHGzDX2W9L5cOC9Zsyq/AxDMwM?=
 =?us-ascii?Q?U9/bsQByIE+9u/naqeCwXcb0UwrFmUdTz8EViFmOfPUggjrSYUltwv2+w3Rn?=
 =?us-ascii?Q?VRYIlCq32SF9dyRILR9sdZGShfdGKmsRfeXjLp52sgQ2JDNTPtdXDZuT2Q9N?=
 =?us-ascii?Q?5p5XATvYRDM8H3c1HkdKIIMY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d28f07b-add5-4ab9-f28b-08d90670a639
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:58:34.8612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNe+5IaySuLt9JjE2WuQtsAPe894mu3G6FPi8LTZZMYX+VA0gZfaJbVWExcifJM/CJEFAJu6+GygavBrTyNkKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2639
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

KVM hypercall framework relies on alternative framework to patch the
VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
apply_alternative() is called then it defaults to VMCALL. The approach
works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
will be able to decode the instruction and do the right things. But
when SEV is active, guest memory is encrypted with guest key and
hypervisor will not be able to decode the instruction bytes.

So invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
and opt into VMCALL.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_para.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 338119852512..fda2fe0d1b10 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -19,7 +19,7 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 #endif /* CONFIG_KVM_GUEST */
 
 #define KVM_HYPERCALL \
-        ALTERNATIVE("vmcall", "vmmcall", X86_FEATURE_VMMCALL)
+	ALTERNATIVE("vmmcall", "vmcall", X86_FEATURE_VMCALL)
 
 /* For KVM hypercalls, a three-byte sequence of either the vmcall or the vmmcall
  * instruction.  The hypervisor may replace it with something else but only the
-- 
2.17.1

