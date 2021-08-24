Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775193F5CC7
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbhHXLFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:05:35 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:9635
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236327AbhHXLFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:05:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EumJEpxVrbP2emah4yPo7zBzuWY0d+3sJJvd3qcOX9YGPGwYG3+CQ8Px3wuXpjs48CHNPl5sbYt3jUqdCanZxNIBdJtlLL6I4SatfK9NXzaCzjfBdQqFMD/WBedYzT7426/mQ9NZm7R+fgxrCcrp6s6kjnNeOuU3hFt2imQ7z8KyZnBIxpsWTLEB7zQzsAI3YRQfTeQDAy/MqjAQQqOgqDAOPRrh42sw850BFqNu8E4Jr4RJ9YOXCKRL6OFXp35z7BXR8cd260pfN4ogOT2AcEcbrh++CMJv0pnp1F4XBtktQVidVg8oWDD5aM7FdnJtygZrj8/Ga/FdfffOX73p+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XBquK0XcJHWbJXF9Y6rxYl4ULJia69zhpS5165zn+M=;
 b=ZRYkIJlN5DjTPS+crp05X55NTHnmq5c2g7E1o6SiXxZCvzcCCaldvbJw/q+6jk+RC6W4qZCInz8NFbLgxeRdrQLC41tuLoPyDCQ7uhpeY2oLoFuCe5eACyvprWbAOQ3iB4VHvWTpwR48QyKYQOEezMEwwM0mfiQ0/Ysc4azHt6LFjIOnGnHYowdvTF4JDg2GIIwF3ROqVRrEE7Lxt1OvBzglaBxbRj2VOavxwEG4ePflfSkfozbv2xAd6YHKOD/py5Ppk1nG7HKrOebTLxVypQZx9dVXWDB1G42wcGKgUIPhUCbb51ZF3yT8JOYIr+vmLSBxrgpOiiNs/5Lk0HGezQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XBquK0XcJHWbJXF9Y6rxYl4ULJia69zhpS5165zn+M=;
 b=aGIbges/5clJRztotilWLDsKMT0rpwD8UnaCoFufuOgttbGo+VjvNwzvTvVIc+XpPwbqG+YqujimvUltqACTFl0Rv38T4sJ9fEr1GAMTyl7yGIFfN4eZoMsNh07sBH91Io+KwGSiRj8hFUka/96glr3sv2G58tFbByZacNe5JHA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2544.namprd12.prod.outlook.com (2603:10b6:802:2b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:04:47 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 11:04:47 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Date:   Tue, 24 Aug 2021 11:04:35 +0000
Message-Id: <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629726117.git.ashish.kalra@amd.com>
References: <cover.1629726117.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0101.namprd11.prod.outlook.com
 (2603:10b6:806:d1::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0101.namprd11.prod.outlook.com (2603:10b6:806:d1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 11:04:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7edf858c-7cc4-44de-9be0-08d966eefc81
X-MS-TrafficTypeDiagnostic: SN1PR12MB2544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2544B80654986AE552342ED38EC59@SN1PR12MB2544.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lxtgLBUWjH1ifRpqQYS7rU5yCKLQ9MP+iERcGc7iHiSUimb5xw+ogL+1zYyxtXqGUXIAABWyMiEO7qsy9zssQC5DxVwFKq83FrGBaPy+V4edqhQRvJ3x+SwjFtQ7kE/MZaomYlObMgcFCl0l7N5ps+vDyvm2XczTS8DlGj4gkCAOzfdmMk9dyRsWjDVBH7MD8i1XnNcq6VuZ7MKCTVVGA1WRJtGkBgS6wo4XyaTNBqjoFTRfb49ahuEyH4OXuZ4a4ARm0mQKMRfWUvvcakPcNjotFDxyGhY3lhiOPOrjN6qf95GesBEg8UzmGBvkR+fgoHNt8ZH4NUiS/T3OGjXc88PqLmGerTAzd1R80WsnvSHPEbKOCKy/VWoeQpKRi98iA91bB3rm2dTg/9zhqvD+Keog21WnTpmOnn+6UIw+sS58tIQ2pQ3/hfydCBl+NeQgBqV6pr5PHCwmmLoYPBDRT9m4LaHAZ7y5o1nCTz5uTnIfDq1QPvTjkpDMgVJNp/RDq//8yFTDgYUEhZIZq7i4ZR24zzR2Oz0Om9yXQYqf+nSZQamSt71buRgY2AZcDWGyJ7GfuoO+RKR75I31S0GfkenDyEnvBbeoPLo6c1Jxhqb8q5WsPmxJfQ8vzH8XzsSxduu2srT5/B6dhYgdwr+pn82N41p9Str3Se2HX4Y3Ygah5A8MSyzpJN/wEPljnVLzEb7Unl8Y/8jTK2acY74Dfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(36756003)(83380400001)(2906002)(6666004)(6916009)(956004)(86362001)(66476007)(5660300002)(52116002)(8936002)(26005)(2616005)(7696005)(66946007)(478600001)(38350700002)(38100700002)(6486002)(186003)(4326008)(316002)(8676002)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MCa4hGGuCYkgUPgpRzXT35H6GZeVHKrT3d+YYr0IFPc5vZGMZorswSLGSplF?=
 =?us-ascii?Q?FNtEAsLLW6r72UiggS8KvCfTMoAn04UTXrdzOaRiF1j2x+fGQCduuwnXE7yS?=
 =?us-ascii?Q?zxDWSOZoCVu+cw/oNLmUY7UVh4XUh65m4lFfsTwJVeC5hTc2t+VpSoYrq2an?=
 =?us-ascii?Q?YN8rTsBbT7W1WiRM8+xyyl6LSzi0BYV4weyf+Zc+XpnhM5X9ZhZNcVrfvYWn?=
 =?us-ascii?Q?QLs9454uGO7nar4SSqBcQEUq1BK+MzyxshVeuIq8GdXcxzaBR2uxCq3gfN8X?=
 =?us-ascii?Q?eT0vniiar/ktYhkewUylUi/gZvKVblsDYoAKXik4Z4UQwYkrHqut+k7I6STT?=
 =?us-ascii?Q?X+9zFAluOSTzWAq3+oVc3Hk1qw5nmmlFuZvVSJhAZB0SFk3jA7BP5JagtIC7?=
 =?us-ascii?Q?Beo/BbKbRw7L0FRGmb+yxTIZDNlPHucje+FCJtODh3ATOq/UO2t1taOewI59?=
 =?us-ascii?Q?X4LYYTLc/6qtLmfuAtARDWTP74cGaej9/60x/7/sgrmq3RqyhHb5ilNwgVa5?=
 =?us-ascii?Q?6S0KKoO8rVJbohgNXjvaoO+owvieJjiuzP03XqFYHfUzirWm4uTjRxKQmfJl?=
 =?us-ascii?Q?pX3lkwdlKBcPWZTHDVI8rdg1kR3XIST9XHZQV6J4XOxb+IMEuMZAJVD9VOT0?=
 =?us-ascii?Q?+HiAa5l+PZqlu08mdH5/tOsFuXsbFGQl/b9uSdGNeUxl1CN4gcbC8GczfBn9?=
 =?us-ascii?Q?oJrCzEoCTQyHsXfZtZ1atljECEJ0nO6UfKnQq6gqQvWhMq46TLUGCPDiL/OE?=
 =?us-ascii?Q?gYFbbHFq1XVJYviY/d7vtn2rU6ZffQ4aSH8pDPB0vfgnVDGzN3tN6AwxhETg?=
 =?us-ascii?Q?J9ZaReu1w2fNXJQahkSy98aHlLUNACKOTnFgZw4yA52gW9oCih43jtGU1oY8?=
 =?us-ascii?Q?7hBhvwqSKFm8deQ+nhsAMDe2xANX3XfoUd1Yi0to65+cwiK+NA5ooIQeMQ5q?=
 =?us-ascii?Q?pB12YS+Wd2jpLcLoDFYzwDtfGsS2K1+K2k7ke3fGyKQmin9RO9fgZtf8Y7wQ?=
 =?us-ascii?Q?mo0M2aNyx32WW3rSASVdNStDUNceXkGO7EPI9WDtEVJxlxgNEAKKtQCHJ7+U?=
 =?us-ascii?Q?3DpGJyO++HmTu+qxBfnDncCvbBsr5ecB3O1Fcx0OStxhReZLJixtZFJAapL6?=
 =?us-ascii?Q?wRsMalENMc46dXsucW7JWlP94zjxKoqsv5GeZRY6/PjoZi12ySk2/hsd8RDp?=
 =?us-ascii?Q?cdJI/bTabvZhJJRirAZo4RYa9bRs1+paWsqQjHJ4IGUv1+Srom40Zlidxuza?=
 =?us-ascii?Q?0pPiVbWjz0RIkBEn/+8Jfk+/cv8gKNai1jpPjfyJIMkyf1UQ0XDhNok6Udqx?=
 =?us-ascii?Q?z+9QhPwv3no81R4Fkw8a4ecY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edf858c-7cc4-44de-9be0-08d966eefc81
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:04:47.6186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHBzsXcelvdeKJRsdLoFzPAJLfMg767hmyBhYHeGf8f8Tz6uJ/tr1S8kdryr1T/xjjXbhffM5Mycdht/goX+Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2544
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

KVM hypercall framework relies on alternative framework to patch the
VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
apply_alternative() is called then it defaults to VMCALL. The approach
works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
will be able to decode the instruction and do the right things. But
when SEV is active, guest memory is encrypted with guest key and
hypervisor will not be able to decode the instruction bytes.

To highlight the need to provide this interface, capturing the
flow of apply_alternatives() :
setup_arch() call init_hypervisor_platform() which detects
the hypervisor platform the kernel is running under and then the
hypervisor specific initialization code can make early hypercalls.
For example, KVM specific initialization in case of SEV will try
to mark the "__bss_decrypted" section's encryption state via early
page encryption status hypercalls.

Now, apply_alternatives() is called much later when setup_arch()
calls check_bugs(), so we do need some kind of an early,
pre-alternatives hypercall interface. Other cases of pre-alternatives
hypercalls include marking per-cpu GHCB pages as decrypted on SEV-ES
and per-cpu apf_reason, steal_time and kvm_apic_eoi as decrypted for
SEV generally.

Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
will be used by the SEV guest to notify encrypted pages to the hypervisor.

This kvm_sev_hypercall3() function is abstracted and used as follows :
All these early hypercalls are made through early_set_memory_XX() interfaces,
which in turn invoke pv_ops (paravirt_ops).

This early_set_memory_XX() -> pv_ops.mmu.notify_page_enc_status_changed()
is a generic interface and can easily have SEV, TDX and any other
future platform specific abstractions added to it.

Currently, pv_ops.mmu.notify_page_enc_status_changed() callback is setup to
invoke kvm_sev_hypercall3() in case of SEV.

Similarly, in case of TDX, pv_ops.mmu.notify_page_enc_status_changed()
can be setup to a TDX specific callback.

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
Reviewed-by: Steve Rutherford <srutherford@google.com>
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 69299878b200..56935ebb1dfe 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -83,6 +83,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
+static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
+				      unsigned long p2, unsigned long p3)
+{
+	long ret;
+
+	asm volatile("vmmcall"
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
+		     : "memory");
+	return ret;
+}
+
 #ifdef CONFIG_KVM_GUEST
 void kvmclock_init(void);
 void kvmclock_disable(void);
-- 
2.17.1

