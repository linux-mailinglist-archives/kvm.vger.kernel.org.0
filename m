Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2010237ACA8
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhEKRIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:08:04 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:62970 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230315AbhEKRIE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 13:08:04 -0400
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BGqbaw022632;
        Tue, 11 May 2021 10:05:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=CkgOdCQY1f8ytYQzmvw55JD1HLRdCbY03ZsEjGklJ1M=;
 b=ZC09PS9oYpJ3285FCUOZ9GxjO9aFG2CFjJ2wQNnkGW3RV2a0gvxM5ZnnF+Kh83nhVLMS
 AdMRc98JbsFqRsKja91hm6VZMWFenhbVNfy8a0knj36h446klYncj/SXOq3cVPn6twmQ
 xsNSx+0K+fpqQd/c49ervXdQbKPxq12key7oc7NMrrEnbBtsaJhDqgYZKbgL8cCRb3UR
 TyvxHzwBZCtN82iEXli48GMwWKM/MX5RTPklR8b0ky0mp6XhZ9sDG2YWymvN+xrd2imj
 WqjzQ4CfnV8mZB9oSWYexk7ckxNVt+ctnzs/+0Ed0fydnoRNZek2dgE8SIHBPIoVxZdG og== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-002c1b01.pphosted.com with ESMTP id 38ewh3bxf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 10:05:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSb7oEhFsQtkKIb7j+6qeSOgDzuPB1IYxW2qTXvSX3mO+HosVoUAEP+5jivAiNtA/DGT2ZycMvslvv/cQZvlLZxEfqFieqDey0zO0JGdqI9iyFxxRda2kqEvjTl4qnCa1nqagTUIwcZBdsKK6IjL5IBNjzjV0uPWcjHVAq2PFHq/mfk9Jr7dBol9nd6zEBBMOyw1S+F0xfBNKZomb9jLzlV6us/+pZps7h1+pE/WLFVgky1y7ggOo/9S1OIwxeAxHwFw/96xOGs6OPb1E+oENPvITbmFttKgY+j8d8lEtOnN8CwmdAyZ+mnWtasMCPYuDDp8yxETPkgSfCwH3MZhIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkgOdCQY1f8ytYQzmvw55JD1HLRdCbY03ZsEjGklJ1M=;
 b=j5s10fUHDH5d1UX10voFbQB7K1/T1SoQl9UXJc8hyCFAftRE06bBOgS4nazc0EPbdArBvEagd+kkjqwks0zS6TZk2icoTJrmiTOik7uHqOzIznwSh5Y9H6KlzMz5KO8SBV7LjJaloY1wmWzjMI9uxzN90jlbKd34aSoOq/XfNIbzVJIL2Dp5nBibE/hDxFuBm2AiPqtr+K2qkgANn20sweL+MYJ5JkGN4VlHGDPX9IlJozg9lxa0JaC1dweW7w7Vf1j8QARJNI3fO68eWQscNwvk7bbGUR3XzVZBkc0rgomAonkDrv0+007Vdfup+aKJ1fVQZlqEHf4rZxoG/Xl6UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: nutanix.com; dkim=none (message not signed)
 header.d=none;nutanix.com; dmarc=none action=none header.from=nutanix.com;
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by MN2PR02MB6893.namprd02.prod.outlook.com (2603:10b6:208:200::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 17:05:29 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 17:05:29 +0000
From:   Jon Kohler <jon@nutanix.com>
Cc:     Jon Kohler <jon@nutanix.com>, Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v3] KVM: x86: use wrpkru directly in kvm_load_{guest|host}_xsave_state
Date:   Tue, 11 May 2021 13:05:02 -0400
Message-Id: <20210511170508.40034-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2601:19b:c501:64d0:68d9:a99b:e44a:d275]
X-ClientProxiedBy: BN6PR13CA0055.namprd13.prod.outlook.com
 (2603:10b6:404:11::17) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02F13YVQ05N.corp.nutanix.com (2601:19b:c501:64d0:68d9:a99b:e44a:d275) by BN6PR13CA0055.namprd13.prod.outlook.com (2603:10b6:404:11::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 17:05:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7edc6841-6bf8-4735-1b7f-08d9149efad4
X-MS-TrafficTypeDiagnostic: MN2PR02MB6893:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR02MB6893AA87345AA06CEDB081A0AF539@MN2PR02MB6893.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y0g/80mlVVAB6uGBvGjcGZCADjIwaVX8c05QaQ4NHQ8NOL5y2cE9N41r2JRb5O88u9ZNAdB3Ao+Ut55YCO0JH2ZkRLXnbEzlHzLR//zfC1AuMLviBqgngXo7cPo6PhUw4ggneB/cbkaqih+VPwbXGgE8CYlo0b3RPdL6blMIP7cfDFFr9WlhGNZea0VQ5EMkq7LSKjrGL8GYxBeEfT4mA0QqF5e8sv7T7O/rt9nlHAvYNGz4q3qRqdJtjLxzxR6nUeGJDHRhLS8EtNDqSZJF8TWOJeVDEOmMoH3GBuqjqtVAGjLnEDaAq9XIkix6Pgho5TL1rQkcI0u5D0vMzRxoy+s2tPPdI0enjQCYG+vvTE7O8SBVEzK9UnfhBXuaX1G3MGf46eah6QrbuZ8f73N1Xvm24a9eK4IZRMWI85L6u0Nj4wYJEoHBo7qhpWHCZ4f+YG++vzCACkCDyrfntwAmSukLqfokEUcM9A2C8AmH5b5ns8MIDHGvDvg3m2JMgt/yVj4nmCiJXvQYn8KA8m9GcudqUbdezELA3T/PlLngGpqhlFa0B0CptO9bpLPomFEEngxyf+xMbtYfS7h48vre//375UN/ZewrNUPj1kyeVoeEstJRRm4O4n16oz0UKk54EgUCstRl34Y/w0irzGBY/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(376002)(346002)(136003)(396003)(366004)(38100700002)(66476007)(2616005)(109986005)(186003)(4326008)(16526019)(1076003)(6666004)(7406005)(7416002)(5660300002)(54906003)(2906002)(316002)(8676002)(83380400001)(7696005)(36756003)(478600001)(6486002)(66556008)(66946007)(52116002)(8936002)(86362001)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?peq6mmhFgYQ89F6jsDVsNAamFMPs7NC1ki3xrIbns6KCTBntTisctok9EUuD?=
 =?us-ascii?Q?lBGmjmcrHGJMlXSNMQJmGOI0/59o6s92DzIUG3xsahl7NaZaEPyylHwSI8/3?=
 =?us-ascii?Q?iHJxlpT2bJuZ/w71+ZusjdxR46r1YtdyInGfP0iAR7TWMS4ZhyH+SSHPeGhG?=
 =?us-ascii?Q?jvj50QiuVWWQ5X8Erhb8wXzWJ2FHT33wSGXFiNP4w6nJjkbIow4bSpTLLmMD?=
 =?us-ascii?Q?SVHFUopdthXyFapECws3MpOmpuDBvHmoR4orgtt5n+Qhvl4WN19IfctmQiCE?=
 =?us-ascii?Q?kOI+MgFjv2CA3tqFeWQCwNAx6GIhDT35lSGrgcVbiX+/XOlcsBeyVCRb2Uv9?=
 =?us-ascii?Q?bmFewvPaD624brTeLik0RWoJkXuqckzWosFEE0jWTOiQfHOFpVJQ+weoyjsV?=
 =?us-ascii?Q?cIe+ZxozyRqV3jiSUgKATSgAWWPIQNjDaI3GvzBMmfAja5XMkwY964iezMSC?=
 =?us-ascii?Q?oVJmHEvqK+pViYTQYwiQwYbQavbZJy44WCH10IXYQGnbb081Bnrz4ZN1P6WP?=
 =?us-ascii?Q?7aSjyCfbV3YZQbqbCkWesz+wzK+tejBrupZdK6xIZ0BRu9FoOVN/v0Yx37LH?=
 =?us-ascii?Q?tl0i0P7XEwCkxDAUONkhs9W8Qyr6hppTnx3d3KeuYZkhGARbDCrRdCyq4ElT?=
 =?us-ascii?Q?t0UcH87oPwY6pOOO4TjYieg3t6S5UnUsHDbL7fkiuCyGs7lF7Ibx4kRJwzA7?=
 =?us-ascii?Q?O4afBCeA8w9Vqlwjyp4zYfJl93+/r9h3v660HCDstwpns3Jk+BIGFRSP+/vE?=
 =?us-ascii?Q?EuK4MuKibfPtyx0zPFLyJHE1ETYcXLx28YMBKU5sA1rdhPyXq9TOq+v0fMZ7?=
 =?us-ascii?Q?d4altPQANKDmX/NzpP1h1BuTpxUkvJ9vv9xw1NBgoaT56/WIC+A2QKQALdVd?=
 =?us-ascii?Q?K9V6RT2ZGDQ4xR/c0blKxdsCPJodgFsYEwonePRn3B7QGCviakvo64N98Te0?=
 =?us-ascii?Q?AFb2GVWVVl2as+J+fekpfs6RbSg8g0z2WpHeby7OxwtzoIa7MDFFUapggQwd?=
 =?us-ascii?Q?fnWQJhqn5cbcrg3NdX+ug48ozObgqxQ8yZwlqMGVPXyh+otEMWM49fXIN2e2?=
 =?us-ascii?Q?hO4/FU6pjFlZJ/P55K1zB0sLT6x+OWz2BnwUUDvgWXb67oKGIHVGcz57xgH7?=
 =?us-ascii?Q?HKyyUuNPXcjcHFgu2YILVjzpo5aTjb1yN2UxR/SWkCWs0sy4ZZsYdodRg/JW?=
 =?us-ascii?Q?O4KDn214Iq48sOh8E4A735M/CWPPE+LAKu+p1M1NgvoBX9p5rF2c9TaBLcnN?=
 =?us-ascii?Q?Yt9LNp73jEqBmQvLJE6zWeVfWHmyE45yi/6yfipmwCphdZT6dP2GqdXcLMFs?=
 =?us-ascii?Q?0rSp0L+afLNjyP7Kht5If+pgvI8tDih6gUSfYoBpM8c2ntO5l3DnCFvsm6SJ?=
 =?us-ascii?Q?+F8B7LHXTjda3nuCe7O4TWGyFFRU?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edc6841-6bf8-4735-1b7f-08d9149efad4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 17:05:29.7897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nx+/e+WZiP4OTrmODgyqhtju8Z54323FY7jLCQEl1HLHgp/vkfIa1AxmgepJr7iCfv/BRDK65OZYj19R3Ou//29ZktHe35THmFotGjCn2zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6893
X-Proofpoint-ORIG-GUID: dzLPA6DVcDMPd36cBZGWkKA0EmkZDJDw
X-Proofpoint-GUID: dzLPA6DVcDMPd36cBZGWkKA0EmkZDJDw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Reason: safe
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_load_host_xsave_state handles xsave on vm exit, part of which is
managing memory protection key state. The latest arch.pkru is updated
with a rdpkru, and if that doesn't match the base host_pkru (which
about 70% of the time), we issue a __write_pkru.

__write_pkru issues another rdpkru internally to try to avoid the
wrpkru, so we're reading the same value back to back when we 100% of
the time know that we need to go directly to wrpkru. This is a 100%
branch miss and extra work that can be skipped.

To improve performance, use wrpkru directly in KVM code and simplify
the uses of __write_pkru such that it can be removed completely.

While we're in this section of code, optimize if condition ordering
prior to wrpkru in both kvm_load_{guest|host}_xsave_state.

For both functions, flip the ordering of the || condition so that
arch.xcr0 & XFEATURE_MASK_PKRU is checked first, which when
instrumented in our evironment appeared to be always true and less
overall work than kvm_read_cr4_bits.

For kvm_load_guest_xsave_state, hoist arch.pkru != host_pkru ahead
one position. When instrumented, I saw this be true roughly ~70% of
the time vs the other conditions which were almost always true.
With this change, we will avoid 3rd condition check ~30% of the time.

Cc: Babu Moger <babu.moger@amd.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
---
v1 -> v2:
 - Addressed comments on approach from Paolo and Dave.
v2 -> v3:
 - fix return-too-soon in switch_fpu_finish, which would
   have sometimes accidentally skipped update_pasid().
 - make sure write_pkru() users do not regress by adding
   pkru == rdpkru() optimization prior to wrpkru() call.

 arch/x86/include/asm/fpu/internal.h  |  8 +++++++-
 arch/x86/include/asm/pgtable.h       |  9 ++++++++-
 arch/x86/include/asm/special_insns.h | 20 +++++---------------
 arch/x86/kvm/x86.c                   | 14 +++++++-------
 4 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 8d33ad80704f..5bc4df3a4c27 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -583,7 +583,13 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 		if (pk)
 			pkru_val = pk->pkru;
 	}
-	__write_pkru(pkru_val);
+
+	/*
+	 * WRPKRU is relatively expensive compared to RDPKRU.
+	 * Avoid WRPKRU when it would not change the value.
+	 */
+	if (pkru_val != rdpkru())
+		wrpkru(pkru_val);

 	/*
 	 * Expensive PASID MSR write will be avoided in update_pasid() because
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index b1099f2d9800..0bf9da90baaf 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -151,7 +151,14 @@ static inline void write_pkru(u32 pkru)
 	fpregs_lock();
 	if (pk)
 		pk->pkru = pkru;
-	__write_pkru(pkru);
+
+	/*
+	 * WRPKRU is relatively expensive compared to RDPKRU.
+	 * Avoid WRPKRU when it would not change the value.
+	 */
+	if (pkru != rdpkru())
+		wrpkru(pkru);
+
 	fpregs_unlock();
 }

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 2acd6cb62328..3c361b5cbed5 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -99,32 +99,22 @@ static inline void wrpkru(u32 pkru)
 	/*
 	 * "wrpkru" instruction.  Loads contents in EAX to PKRU,
 	 * requires that ecx = edx = 0.
+	 * WRPKRU is relatively expensive compared to RDPKRU, callers
+	 * should try to compare pkru == rdpkru() and avoid the call
+	 * when it will not change the value; however, there are no
+	 * correctness issues if a caller WRPKRU's for the same value.
 	 */
 	asm volatile(".byte 0x0f,0x01,0xef\n\t"
 		     : : "a" (pkru), "c"(ecx), "d"(edx));
 }

-static inline void __write_pkru(u32 pkru)
-{
-	/*
-	 * WRPKRU is relatively expensive compared to RDPKRU.
-	 * Avoid WRPKRU when it would not change the value.
-	 */
-	if (pkru == rdpkru())
-		return;
-
-	wrpkru(pkru);
-}
-
 #else
 static inline u32 rdpkru(void)
 {
 	return 0;
 }

-static inline void __write_pkru(u32 pkru)
-{
-}
+static inline void wrpkru(u32 pkru) {}
 #endif

 static inline void native_wbinvd(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cebdaa1e3cf5..3222c7f60f31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -912,10 +912,10 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 	}

 	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
-	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
-	    vcpu->arch.pkru != vcpu->arch.host_pkru)
-		__write_pkru(vcpu->arch.pkru);
+	    vcpu->arch.pkru != vcpu->arch.host_pkru &&
+	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
+	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE)))
+		wrpkru(vcpu->arch.pkru);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);

@@ -925,11 +925,11 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 		return;

 	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
-	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
+	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
+	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE))) {
 		vcpu->arch.pkru = rdpkru();
 		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
-			__write_pkru(vcpu->arch.host_pkru);
+			wrpkru(vcpu->arch.host_pkru);
 	}

 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
--
2.30.1 (Apple Git-130)

