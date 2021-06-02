Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2247D398C6B
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhFBOSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:18:25 -0400
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:58433
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230257AbhFBOQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:16:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfONGEfo6OsqRI3NGRKZJhQsS1HU5UYZ8Ji7ek6CXkQ0Bts3NPtzDFjkGuBFYXqGMlM0tE6k+yKqEQUy5D+oeIs85EXo9vSO0DRlXoSgH30DmTx7Xhct+SvxITZMwO98u0cpyQwodMs2tkUaWw918zJyiXm7BP5JnvCxFk2+ZEpIuBNd/jH08wG1fUyt0Y27gwCqw/h0jLjfyt04XNyxnIUnBlvFYFmtGmTKaTMa+PWv0KFde1pI8o5uZ3z7d2GPkxxwlUs538++l5Yfj3irbTOj75P3NzymavMbvDkDtAzfjiXi/NvRkXGbp3qURzFg7Rdv4Az9xsT2ni59bZdo+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJsHY8n2NA4exO9t0dViCB784NHvK8fDVYNzRX7Qd/g=;
 b=CaAyxM//HZ3AngugDdNBRQ9zIgHhCNaS05Qa5FDRSw7n9rw3aifJGiJM9TlVRFyQefWSJuIUy0tUq42JUlKFcK37ordtxaN7pD8w/egV10eJGG1fM9fFmy9T/yPMsEXwyBtX7RokbknATUsCgnWZqHOKpiFcx7vPyhnSnU40WWuvI5BpeL/Z3xxYa0GdAfiIA+7cK+xISsqpAnO+poyiTdaO2TBHa5NcEFt7gwTWBOiX27C1UzkwLyqE2qUy6kKqoCZmPmKqPm/78TFjabMHtGwc6SjwZgqtn+nyL54O7+vF392mLAKzkDSXGGu/F0v2tEekOZG8WHbRclM6HFNUuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJsHY8n2NA4exO9t0dViCB784NHvK8fDVYNzRX7Qd/g=;
 b=b5BCIJtgBOh8YAtgGwBvA0VFs8CKKDBEAYHHyEyPtI7XnoUTxu9/fhToH1HXhD9XNDOFUHqieODH9PUe5GJ8uUracWwZifTrjVDm+6Nab9gvWot5xiTx/owLCw6MZueg9X0+ZYK43Hvmwo0oehRpOOOmZJeHMrIhZ7gSFUcapdw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:12:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:04 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 28/37] KVM: X86: update page-fault trace to log the 64-bit error code
Date:   Wed,  2 Jun 2021 09:10:48 -0500
Message-Id: <20210602141057.27107-29-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e63e3224-3870-4c3f-9adf-08d925d0660e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592D3E07F052FEC7A929141E53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1c9QTLjnVUrRfH/F1be6xcMgyxZqOLp34CwZTYLq0oC2jsCYiByiYPkQxTGPPKopXfQI1tKUp7sClFta8Ran2vB3JwpvzI7eYGsPQQd0NT+jBFUnSgvYaZoUU5K7XTuwXhsNkQqGN1GAE/XrNhdlrvTvF5ZO7k9MuS7CLk52X/1rPFJ1VXONgN6IN6LX6jkD57aHs2qbBzNw6tB4YusKCh/0zuZ3rbmpg7EfXUspJiSVBEhwmh3pvXmBFnAuhLYU5zBGHk19q7JhA0PVAWu2Gk9IsC7vafS3PJn+/LSBgp/ydhMAoVd6N+RTKNOvYLCgX/t74efpyfNKYc2x3ER2jScWpu0dH6lXmFUpCZ6kxxSC+BK+7CMGHk4BSEW4PBmBuiTzMHY66YHRkmSvFEtzFG1qELakF7AHwB4BkTuuggitybqSl0RTDB22FkFpg5znl9IB7jEsylhorAKnOWJ3ux+1tfxgcWplmDgvAOW7eRAtSzp6p/CpNzSKznEOkHsjztUFfiVm9AEoEFpj5SlhYTBxiZDnKk7AdsJWaaAvmj7ZIOPjRMr7m/WEcCkEWmvuTwH667KQDHlmPqP7IXgnHWjr4qNeCLYcszyB2e7TIa8N8bUob8clwiPzEyBx9Uew1ocE2H9ehQqKvX7l+wg9Cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(8936002)(8676002)(36756003)(498600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WxhEby/+l2J3Ss0rTer7mWWFjJoVgJlYIJYiI/4McG38U1Ydo2KQC/tCaYw6?=
 =?us-ascii?Q?Ypr7+t+qoGkfxwRIyiTe8j73iLDF0snl1+lZmMwmdEXDDgTiETyKW+U4f8WI?=
 =?us-ascii?Q?5p3Q9/8cmGZdGB6iAaqBRDTHm80sCCmiVoUr2uGCef1P76+eFrsjoDHpemWM?=
 =?us-ascii?Q?QmT9rIR3vNTDAR6oxfHw0ld9DQ3EvdYiTt5akEi5DsnY66Ehweqszk9SvG4J?=
 =?us-ascii?Q?gq00LBrKQOeb4R4NmScaYlNQoweSXT7ivL8mqgZu93FBDth5ejVmOaAA0xMp?=
 =?us-ascii?Q?FkURLNI+LC5n/QP2ZW2jIgKiiRqQuIEAYEdm8SmmlqT9yF8Rd4kq0bDhpHTf?=
 =?us-ascii?Q?XcDFSHMWUvzYosT1iounPob3ui3yuFsjaIsFrmOozh1TVIZzNajVRCaJOc+E?=
 =?us-ascii?Q?jqFdHyoLX7mE1QR5qMVtH/rcNgFWfGo03tarb12lkZDQLiIBwbLmRb4nW9VW?=
 =?us-ascii?Q?lYrcl0GamcuQQ8h0LSboj08bA9r9m3CsTXJZa0kSPhRwfdOtBmDUT49rHsvu?=
 =?us-ascii?Q?R34jxkbdiVkgaL727Y19KVzv77874weLAoemG061WJudiD2Hr+93XZmtgd+V?=
 =?us-ascii?Q?PeOVWPpqK4zhKe9exibgj264w8a5wvcfLdh0115lwj1ycZT7wfD/iSe0UxFd?=
 =?us-ascii?Q?zUZGnFf1JP1WMiEvTSD8h8+DW9wgqAHs+ucgK1Qi9+b6hW4l3fY8y61Yzz1q?=
 =?us-ascii?Q?7sxzgFCjXICoNwnuW0ntaBl2cJyG6+46Ch3ezYLe6QQCpBaDFgDKjbCxi6Hy?=
 =?us-ascii?Q?uOeKzy3u+McF94I2dUUSwuUjaKiBTeOLodkCoB/PJmY1PzOKWzIYK4PWxwCH?=
 =?us-ascii?Q?nLQXovajMWzTUT2urm/dX1yJhRgBJOW3ZfcBq9iCLfxTpKJH8llv2q0iAbva?=
 =?us-ascii?Q?sIpP2MTsgXwS5913HHNNmG18yi10fuyiV2gxHCeeh/OcBdSwnj000+qJ+JrM?=
 =?us-ascii?Q?oFeGXSPq0pccOPqy0F1pWtOztUsEYpw8Gh99gArsYNtF+L6l8Wai18gM7vQD?=
 =?us-ascii?Q?hMf9VuODK3h8TNYW1yLZcOIrSgMhAh/K6HGOOq782SVkf+4FO8N4qqJyVRei?=
 =?us-ascii?Q?gudGEBZAQC+O0dXc0PfL6sap7D9B6surPExe9uymjJMxEFoNMfQsm6wJpqSo?=
 =?us-ascii?Q?pmnbDLktckzsHBkbMMFo2ihPzNIfwDZbiN03oOUYLAE6bHpbXHExF91TiNZC?=
 =?us-ascii?Q?ascVFLh5eWZgjrn+Afk6Upzuz1g9gx4r06xcfkpBHvu1A14AcI1UGcug4c+o?=
 =?us-ascii?Q?0L4+fQpFJU6UPk99DVg0L00rM0umlVFtv+ErisJr1DGer794psV3jfhCp4gK?=
 =?us-ascii?Q?eROu6ji7yEA7UoSt3m/VIbeE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e63e3224-3870-4c3f-9adf-08d925d0660e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:04.7213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Z9wGdBLA2bwMY/D/pYG7rSsD8AnHPrgfDnzwD/Uuidu4R+FjKYR5Hn9UED0qGuQ1Gd6Zw/3b7jgX+nM06zRbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
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

