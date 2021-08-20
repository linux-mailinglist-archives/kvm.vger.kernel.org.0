Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF06C3F30D5
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhHTQEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:43 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:59393
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236023AbhHTQCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2D5jJV0XfJnW2hUKCAtzO3iNZBV0tz0X4qqbEEWxFqvyDIaoejLsiYrNcFh7i73rvLrfRLnmaM67zWOEw7VGTqtn5IgB/IHe/26sUdPqIEF37H24AgGUKYrIuxa2Ce1bGfPc64ZNdeqcnWUu+nWWoxUq91pmdlj1KsPiGKU1fBmWRvSWgVhSJVEaATbeW+aJewBeSv/0T69ojKAlLbeo1ihd1lK9agH3KfmVqF9CWEsyj3tFOccty9f2pM0fWVm/tvCIvwZMBhicfRZpTkn+hswtuobhWT89Z3ykubQR4FjNfvxdstmKg/w2zuHbR+RD7HMKqFivHuGl7SnzeEdVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/fFbM3lIaVTOTAHNz7wMPxSLIXzCNn48RusN+8ZPqg=;
 b=XPdkbwA1kg0LvVBRBkG+2JChj//qgfZ2Oh7hce0WKIabfYa23kQ50q2ZlSIKv7+q8EKJBNe9rjGlDz3s9H2sUI7hW+6C/uU0Bh+/1xADGF/N0+Xu8IW3fQXkKGFLg+B3UcQ3b/PtGqt8GWQLTYSCchSQ/1fXaBEnAGDAQZg3/U2nxE9Z/P83SZqOH/nkqljQyqXTYUmsuVTJvwX7ZBRYd1g3M0vv6HbiODr3/84hzxez8K2aGXDa2D0ZZKpvCya6Q5T00HgyDVSYfJiE9sMAGvvvymURixu5Q7+3Fxf07woldL1mQLjR7/P48RgLzD9mmMe2hUVHd9h5jYFSO3SWEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/fFbM3lIaVTOTAHNz7wMPxSLIXzCNn48RusN+8ZPqg=;
 b=FVkRl2Oewe4FdB7xRTKSK5Vkzf1GCoFwfY6bjoD/jWGhtgk46KvSm+Zrc6o4OigjcuwvWL8IDDFn9XOm+/RbM6tT8JiSWOC9aQK2vU0qkI0S5uZdH/ve04pAqY04/VEnB5tOPuUW+KL+3tSj/D5Kg2zi/JVEpzxOoAyUYIkcmRU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:06 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:06 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>, stable@kernel.org
Subject: [PATCH Part2 v5 33/45] KVM: x86: Update page-fault trace to log full 64-bit error code
Date:   Fri, 20 Aug 2021 10:59:06 -0500
Message-Id: <20210820155918.7518-34-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba326c64-17b1-4318-2848-08d963f3a60f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB457429D738BFD5194AF98D8DE5C19@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJRtYz/dy54Q4jlkRByeXcyCEo46dg4AhhaAA68gmuaZnjVcuIl+ZzcqHm7lWmlk7HSwvSkgWfNwUZDY3Kgiv0huS2FT4K+yC9sLINA25+GIVvRZpKHIY4LUs7PE6nhfISLw1RAvWtPK56ryPOKk+kd3ujnEyUUJwp1D0qJ/1cpQPHt993hnMztkToNJINskqnYe2mtyJHQGH27ho+eq5E+CTW9vwCrSmgWpG3jYhm2CAIHU6ueKm6/EBN0Hm33JvseBaIn8kfLAsiz8lOH77gC7MJ1wa7JGKeEfLX5zR2hQKLIykZqOZnrbcZPMsOjjI0KnQwHirDufqREXZQ9rUxguxMmuKn8Jy0J+9w+IaWut512SmVQq4NSe3+7g98AycDg1I2reLbCszioHeAgbRc0t3PH4vz5qE8an/S6AkIbhoKIWWM7AjKI7QJWT2ZH1IbUzRkzLK+RkdbNG+PFpFGrFSYpTP9RAz0qASJD24gV9Is2QDScywhVu7uqmzNfyuhPjy76N044qq699wtwSyb4FPZf4ByaMtCMyDDmi1AYbIQz4H25airBKbiWFQlrTwJYWKc59eowfSN34LJItR+Yw6YdJ5IrXxrGHyNI+QxoEbb9bAX9ByHbLSqpKb6k+ef/NA1mKiu0N1K+kWaz0ose8pHPrAJ4YTSt3kBG+srD6C2WSBx8ujegKOxZdY65e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(38100700002)(316002)(38350700002)(5660300002)(26005)(44832011)(4326008)(66556008)(54906003)(7416002)(7406005)(8676002)(66476007)(86362001)(66946007)(6666004)(2616005)(956004)(8936002)(2906002)(36756003)(83380400001)(478600001)(6486002)(7696005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+U2Qoqbucw9sDGzsC5hwkgxV7KGlAeuugYPsnI9n5K015JncuF3lv0VYywRF?=
 =?us-ascii?Q?4RmHNYUiYnWtQZcmgKeGnvUhMh5OE3fYUAiC/7eXEaT9g9MtU+jW1VJb1PJ8?=
 =?us-ascii?Q?VP9dBeM3AhJ0pHsjqMiDRQSkF3bxHLZV4tK9+RTNqWsRHPtOnf3VIYEf1W5d?=
 =?us-ascii?Q?5WGiDzcKRTPx9e9WP41WBqFaAnmA99k4GZLkYSYw/LT7IWMFWkrH8o/gUDGL?=
 =?us-ascii?Q?BlTvxKksv223d9UDKGP5KWALPMfeCkpmSa0EKa0zKcLqoQo3oWdixhritMhO?=
 =?us-ascii?Q?BFnL0CMgt8ss6Lu9sioJml8D6JVPc+u0PHq5bZtx9h2M17VeiFh5zIk3w+lV?=
 =?us-ascii?Q?jP8+1tJnnkeQWQvG4x6ST6WNzA3BJHpr6ZIfa53P3M/u5Gi+Vv0nPpKA5mc1?=
 =?us-ascii?Q?J6cnSyZVXkCJKyyeOBbgxtPh6Sw+yJHw8DFkf0uiOIlh7hVeVHB9p8LaMdK6?=
 =?us-ascii?Q?XuTqnERfIXv2JL45giGHI1H3OzCPGw3yTsCGG7WsOTyldXdgKYgFg8Ymb89F?=
 =?us-ascii?Q?LjG9kfiSYRBXO2aAC8SSabf727/BU4D2eUNo3mNj/rphDYGKHujKllIu+2DL?=
 =?us-ascii?Q?4KQiisiqWi2fut2U9hZKw+rcxLAaGrLpVwNO4sIY//f4C/Tbx/jH44MrFCAM?=
 =?us-ascii?Q?FQDH488xvHgRkKYMvmk21XQBqb81klZVsAupM+vVP/XXb2dhWQQSUrd819np?=
 =?us-ascii?Q?tlAmQLoS3ljN5KBYPKRbx/Whc7aFdBrO/fiIJ3+BLzMfYml3juwwKdV26hB0?=
 =?us-ascii?Q?mQNJsvt7EgDyIjesH2I3gwDsHA4q8ElE3ZtxNye1D0nncDKPE0peVf+P8Jf6?=
 =?us-ascii?Q?EC6AuRt9Uh1FXjomufYinaB4tkwHPbG1nHIQ4i2Saa9h8LGA3bY31IIyri6z?=
 =?us-ascii?Q?/7kcq/vZzlrpBrzzAKTQksb4yL+s+qs7tF7+y+uW3q/2Kwj+GTIKDmSF/UpA?=
 =?us-ascii?Q?nUOHoLG+w3ARbO7Xoe6BRDDVkp2wNSTVJethk3IfK/gUzYII1YFp3q9N2ek3?=
 =?us-ascii?Q?/CaGYOcXQZZ+LmYVzVWWqWO4KMiMoT5WPXOXt3OM0sl9kxe2T1uGEpGTAQKP?=
 =?us-ascii?Q?s1Io2dU80ygr8lRGZmB0U/kM2K/U1VMLWb6iEurbDN5w71TS52CYG9OviuGy?=
 =?us-ascii?Q?8xzafh6yOyEU7j/5Rh8SZ+clcET5jc8HOeqPEsatrG3E/jxaw+0Y2eekQs1h?=
 =?us-ascii?Q?YDGlXnNwGWf3lrjY6xg4mvyx7rO7Ux+pRESG7EsLdAywirRLvtBu3KFA8JS4?=
 =?us-ascii?Q?qOgMkm3eGMYCMX3InYjbGmPIYdQ8JgBkXUXw1KZFw+lqBsBZXruSAy4zEK2i?=
 =?us-ascii?Q?pI/YpKZK0pRYedzhzPoVA9kR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba326c64-17b1-4318-2848-08d963f3a60f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:36.5598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KK1MWpH5kUGTr+AGIJ4zXOY3l3ysLSa34wFUCAGZPaHxnq8NB2ET8t33lP/mJSh/zOwMhM4KOaj/8JfN2RXZrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The #NPT error code is a 64-bit value but the trace prints only the
lower 32-bits. Some of the fault error code (e.g PFERR_GUEST_FINAL_MASK)
are available in the upper 32-bits.

Cc: <stable@kernel.org>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b484141ea15b..1c360e07856f 100644
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

