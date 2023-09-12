Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C636479C3A6
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241361AbjILDEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241085AbjILDEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:04:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA102484F;
        Mon, 11 Sep 2023 19:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694486208; x=1726022208;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=j8WU7CIx0A9coWIQlmMRM4wy5VpCgf1zqjAwmi6aDNc=;
  b=ZhcOXrfQZLjVJYQkjjZBU4kDrYl4g4Fxz3lK6mOgRixy4FjPg0lkZjjA
   c2Z2DIjSzQhp9xlQckpl0yzX+bR3qaRDdHhb8TAfZEm3ATyE4esXq7gYv
   3qRhModlDWXrzF3zQmli9f8W7qmjwUcEFpQyyUJIU8zK97v6XQjQtHY91
   NuuZ3S6R/870nLOackvecxuMR0506Crk8zgOcfq0I5kXJVKA78+CZWxB3
   cho1MDnU0AkPUCsCaEV8jeCwoiHikKYS/YR5Lpg3JzJEIoRT3Lu+F54qI
   eIagSpRSHrDpvmZfnVxIfFl2orsNqNrzkoKQ/ZcmiFbadSkJMYuZd4ECv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="363292886"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="363292886"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 19:36:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="809046776"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="809046776"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 19:36:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 19:36:46 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 19:36:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 19:36:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 19:36:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncieXwRb9cDWnPWCDFzBev3MbJwBgzO2GukmKesrpBqwo+Cy27hcP3WchoxC4xlwyATENNavb0YsvlyzKT1xUKamnmE5V4rlr96fFjBOJSi7+rCCqxfb88kN2GMxqmDX86SBhZGKOMRS0VllmtwMIilHGcheCdDl0jDzQoOaDMYr4EzrKkbzJcLETWB3amM/5bFNoZtrJ9GC08bhRUNK4HdzqDFfEM0u7EcZaQASCztEfvirk0glc3boMxLPsSj38YAgEsmVfA51Zsu6UdIH2jIUUps91Fns8zxF4XmPoD/6LIfF+o2psHA2HPVFqaPuJh4EKh8mOifMeb5yQfDSCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Y2IW2gGA6+RkRb/e7gayzNf0HuctXl1HdndLJxAbm0=;
 b=Im9pr9pb3LPVutkLeM+EfmnMHeNSV0VzKkYE1J/1mj7wfbHRrlvgSnswzPmY6mobPBptvCnawmww3SbcvuyEXt5qo+sXLlAHwY8V1eIZ3+0VSP8lrnH15D44kGAO2Nry9SBLwB7/yFEGOZmnD5no+N5uzlZuGzxsy4exPBgofkmhYbtF7fd2NIJjIUHc7Ip7s5h/UE6a3i38kjSxVsQ2P5rKidMr4oYMNMXlQlD+54gHEJF4nSm0nea/saiGg6447iXyt/hl8HnXbuTTrWIJkWcvRl0CWtlVHf2l7OnaTeZ7UNjOH8TM+A/Uj+hYv8DlayfcmEocM0SGCzH/lX7hgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by BL1PR11MB5527.namprd11.prod.outlook.com (2603:10b6:208:317::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Tue, 12 Sep
 2023 02:36:43 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f%7]) with mapi id 15.20.6768.029; Tue, 12 Sep 2023
 02:36:43 +0000
Date:   Tue, 12 Sep 2023 10:36:31 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Manali Shukla <manali.shukla@amd.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>,
        <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>
Subject: Re: [PATCH 03/13] KVM: x86: Add emulation support for Extented LVT
 registers
Message-ID: <ZP/Or2UqdA/EIzE7@chao-email>
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-4-manali.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904095347.14994-4-manali.shukla@amd.com>
X-ClientProxiedBy: SI1PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::20) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|BL1PR11MB5527:EE_
X-MS-Office365-Filtering-Correlation-Id: 2451751d-3b2b-445c-8212-08dbb33919b6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cnibbsaVlAH/sJHcK1G8sOUHjj/Nxd78GKa5MewGGscEDHjSpzCUIE9Gy3NtWsFlqAJe2pIVguchULepCLSSo23ikxBF4bX8FUJmuRO9X1IKrcapNg+jU1parT/RnbnFI3QYpi8iK9eOA+ghXyy0UKyEyp0KNI0K6FzT0vXDPan5ciIgaLsyISBVSE18Qedg57RudGdHpbJUx4fSAvoVvipTJaW6cgn50x98cGxWDQWNZLipm/uWEEGe3XTG4HvV2BIsBMhDWUaesk7vUAH817lyf8ReGwQlPTCYLq3LReTXgG4s5PltjbcUKu2BSrSwild4/3yR5+zIYv2se9sZ5deXuuOlIPl+/Bhv7mChtHCvx26QxJmhwLVRm2VvPJmIj5IvjkdLVtAixDCa4XEVrkXoQvBxE/Tlbe8dI/ylSW4N+p17wnXl6Byem5WsKm4kUZll/HIGU7cO9kZTIa9g9e71nqWMNytpLLZgOxrgi5AUZhV/AvCYkjbGaCUVEWy+Rs7U0X5RIvScLKtvMQ+EQn83p22ha2i1vt9SxU5yj3U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(366004)(346002)(396003)(376002)(39860400002)(1800799009)(451199024)(186009)(5660300002)(44832011)(66946007)(6916009)(316002)(41300700001)(4326008)(8676002)(8936002)(66556008)(66476007)(33716001)(478600001)(38100700002)(6506007)(6486002)(9686003)(7416002)(6666004)(86362001)(26005)(2906002)(83380400001)(6512007)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o6uhJCkP0xI8yG+3y9L04ceRmLz0WxscQndLmMVwtoXczI3IABn+/Bqn0n2n?=
 =?us-ascii?Q?C+W0CwVC1Bvtbrqivezrgf+iVQokDCHsWq/TfMsvdO5AGH5ftCKEs/usXCRf?=
 =?us-ascii?Q?N/awYNYq9m5pyuTAqEBaAc6jSDu3vxd1aoR2UZGyNdEiM0jIggXmnBVylfmv?=
 =?us-ascii?Q?16/O31Xs3MTGB2q5jCk7wYpmr4AqQLwk1zyGXma6j6HeaDT5bi27upobaSjl?=
 =?us-ascii?Q?56jAjUMPboir+G6IJsJ+svWKSEiUX3YXIQEOZzR0y49eJjWUkTcN29EhC+u7?=
 =?us-ascii?Q?kpYMJjUVPYGUC59F2q7/OED+rnXXWWnwdt+LWJpZ83J6zulw29DNFvdtuwDB?=
 =?us-ascii?Q?2izWgeP4KyDAiAruXiLdZMUBBPXiBRtUs3PE7jz8ejDGjUh6Yo6KfzBsKWdX?=
 =?us-ascii?Q?eCEEvCNrN26Qx3lcMwHcykABnKwxUiHTS433EWye3Foz6bxosiQxF5+r14T5?=
 =?us-ascii?Q?4SY7+/55tpe6NrM9YtPUb8nvHMrqIqzS1XH1HBXLWtqV8IarFmWT86GIm7mp?=
 =?us-ascii?Q?3NpHpK90JSzQ+kVPm2sMJe28BEbR5PGvx1zLRVl88gOnkX/7rBX7L5rGNKTy?=
 =?us-ascii?Q?ccVoemcug4CDDmMbpSLQKIsUA0TbQrWEWdiWCDIKKsH3VfZS1ZohhrDR8+hu?=
 =?us-ascii?Q?c7MVpObDI8IoSfccBxnE+bHrB+uYmyklU9PTihzyJdTJ6WyRiZL2p1S6dRTt?=
 =?us-ascii?Q?AzbDDX3Iqq6ZhEASskvLvTkqqGf5fYLb51iXQvIF1rIvCPp0qHDJG8s4Yn1i?=
 =?us-ascii?Q?1cGUDx+GMQm8aS28k6tr7FRts2wZ/odY0W4qNG9HGAV+FwTyGobWou5Pbdn5?=
 =?us-ascii?Q?UGo6QGfjNix6HXRlrgkdn+F6gkWpGAej7qNWi+jZJiD+NJ2MYNs6ERRtQx4m?=
 =?us-ascii?Q?5Q5TDhtLxlludJA1ahS70ybPihPhZMFE/tSiJwiISSAhgfhcHDH2Ly5v4Bk2?=
 =?us-ascii?Q?IfaufkuTYI0ltQhjnxYUkm16EZl4xDIqjBHosEmkT6jnvTRgIPYDBkKSTvgS?=
 =?us-ascii?Q?CGxkLBToMeSXDOrTxRBtuKiSYzDeO1zaPja+d5Vf3BYr9u+Mnc3phgKyYXxe?=
 =?us-ascii?Q?eiVQseLqP21Veo0Zjw0GBmN/QYxHxvHkb1xtrSS+ud/tC7dWAVnbBZpavVSk?=
 =?us-ascii?Q?rv5wWaz5jQ2YcQpr5TxSlTepJvWnaBg7AfWUTW+w0jlmwWFpEgdTWBW/IwS0?=
 =?us-ascii?Q?GlnKPMyTdcURh3AQZ1snFGBFlFTfUdpRR0gmXj5AsJk7XayG6KZT8UFXOmhh?=
 =?us-ascii?Q?MaQRMtWA8ysMje1iK3BmE7pSudQP95Cl7XDTAtueHPd26NUX5zkFF4U3EB2Y?=
 =?us-ascii?Q?SeylTpnJ+mUJGQlKFooRG8etvvau6iZcnsMWIts1LLQsc8hzbda+she+BPYe?=
 =?us-ascii?Q?DpQsLdfmBurJNYeZpDdGeWA+7hOiJc9qzMcZj7PBARCdhjn6qJBN/2qRRptx?=
 =?us-ascii?Q?jioweufV212WS6ZwNhdWV9XoLmfwU+VBrJwDzatGGmot7nWnxbUXiCIEH/4r?=
 =?us-ascii?Q?0UGsMJ1jSuqLlfm4F74wsuGyGnTvXdJkpmVD9/5Kv8TTltfSDvtOqcEa0kXg?=
 =?us-ascii?Q?WSacmLxtTJXOqc6eb4dKPUM9W/RpSeCMhneDSvT9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2451751d-3b2b-445c-8212-08dbb33919b6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 02:36:43.2048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jnZK2YgZu1C2yJfNEPAj4U4hn+CWMveusUfjT6b6eANJ9s9PCG2Q4pnlOxd+eMWTsDDNVi6RU4v9AF3nof6ZRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5527
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 09:53:37AM +0000, Manali Shukla wrote:
>From: Santosh Shukla <santosh.shukla@amd.com>
>
>The local interrupts are extended to include more LVT registers in
>order to allow additional interrupt sources, like Instruction Based
>Sampling (IBS) and many more.
>
>Currently there are four additional LVT registers defined and they are
>located at APIC offsets 500h-530h.
>
>AMD IBS driver is designed to use EXTLVT (Extended interrupt local
>vector table) by default for driver initialization.
>
>Extended LVT registers are required to be emulated to initialize the
>guest IBS driver successfully.
>
>Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
>https://bugzilla.kernel.org/attachment.cgi?id=304653 for more details
>on EXTLVT.
>
>Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>Co-developed-by: Manali Shukla <manali.shukla@amd.com>
>Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>---
> arch/x86/include/asm/apicdef.h | 14 ++++++++
> arch/x86/kvm/lapic.c           | 66 ++++++++++++++++++++++++++++++++--
> arch/x86/kvm/lapic.h           |  1 +
> arch/x86/kvm/svm/avic.c        |  4 +++
> 4 files changed, 83 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
>index 4b125e5b3187..ac50919d10be 100644
>--- a/arch/x86/include/asm/apicdef.h
>+++ b/arch/x86/include/asm/apicdef.h
>@@ -139,6 +139,20 @@
> #define		APIC_EILVT_MSG_EXT	0x7
> #define		APIC_EILVT_MASKED	(1 << 16)
> 
>+/*
>+ * Initialize extended APIC registers to the default value when guest is started
>+ * and EXTAPIC feature is enabled on the guest.
>+ *
>+ * APIC_EFEAT is a read only Extended APIC feature register, whose default value
>+ * is 0x00040007.

bits 0/1/2 indicate other features. If KVM sets them to 1s, KVM needs to
enumerate the corresponding features.

>+ *
>+ * APIC_ECTRL is a read-write Extended APIC control register, whose default value
>+ * is 0x0.
>+ */
>+
>+#define		APIC_EFEAT_DEFAULT	0x00040007
>+#define		APIC_ECTRL_DEFAULT	0x0
>+
> #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
> #define APIC_BASE_MSR		0x800
> #define APIC_X2APIC_ID_MSR	0x802
>diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>index 7c1bd8594f1b..88985c481fe8 100644
>--- a/arch/x86/kvm/lapic.c
>+++ b/arch/x86/kvm/lapic.c
>@@ -1599,9 +1599,13 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
> }
> 
> #define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
>+#define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) >> 4) - 0x40))
> #define APIC_REGS_MASK(first, count) \
> 	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
> 
>+#define APIC_LAST_REG_OFFSET		0x3f0
>+#define APIC_EXT_LAST_REG_OFFSET	0x530
>+
> u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
> {
> 	/* Leave bits '0' for reserved and write-only registers. */
>@@ -1643,6 +1647,8 @@ EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
> static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> 			      void *data)
> {
>+	u64 valid_reg_ext_mask = 0;
>+	unsigned int last_reg = APIC_LAST_REG_OFFSET;
> 	unsigned char alignment = offset & 0xf;
> 	u32 result;
> 
>@@ -1652,13 +1658,44 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> 	 */
> 	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
> 
>+	/*
>+	 * The local interrupts are extended to include LVT registers to allow
>+	 * additional interrupt sources when the EXTAPIC feature bit is enabled.
>+	 * The Extended Interrupt LVT registers are located at APIC offsets 400-530h.
>+	 */
>+	if (guest_cpuid_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
>+		valid_reg_ext_mask =
>+			APIC_REG_EXT_MASK(APIC_EFEAT) |
>+			APIC_REG_EXT_MASK(APIC_ECTRL) |
>+			APIC_REG_EXT_MASK(APIC_EILVTn(0)) |
>+			APIC_REG_EXT_MASK(APIC_EILVTn(1)) |
>+			APIC_REG_EXT_MASK(APIC_EILVTn(2)) |
>+			APIC_REG_EXT_MASK(APIC_EILVTn(3));
>+		last_reg = APIC_EXT_LAST_REG_OFFSET;
>+	}
>+
> 	if (alignment + len > 4)
> 		return 1;
> 
>-	if (offset > 0x3f0 ||
>-	    !(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
>+	if (offset > last_reg)
> 		return 1;
> 
>+	switch (offset) {
>+	/*
>+	 * Section 16.3.2 in the AMD Programmer's Manual Volume 2 states:
>+	 * "APIC registers are aligned to 16-byte offsets and must be accessed
>+	 * using naturally-aligned DWORD size read and writes."
>+	 */
>+	case KVM_APIC_REG_SIZE ... KVM_APIC_EXT_REG_SIZE - 16:
>+		if (!(valid_reg_ext_mask & APIC_REG_EXT_MASK(offset)))
>+			return 1;
>+		break;
>+	default:
>+		if (!(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
>+			return 1;
>+
>+	}
>+
> 	result = __apic_read(apic, offset & ~0xf);
> 
> 	trace_kvm_apic_read(offset, result);
>@@ -2386,6 +2423,12 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> 		else
> 			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
> 		break;
>+	case APIC_EILVTn(0):
>+	case APIC_EILVTn(1):
>+	case APIC_EILVTn(2):
>+	case APIC_EILVTn(3):
>+		kvm_lapic_set_reg(apic, reg, val);
>+		break;

APIC_ECTRL is writable, so, I think it should be handled here.

> 	default:
> 		ret = 1;
> 		break;
>@@ -2664,6 +2707,25 @@ void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu)
> 	kvm_vcpu_srcu_read_lock(vcpu);
> }
> 
>+/*
>+ * Initialize extended APIC registers to the default value when guest is
>+ * started. The extended APIC registers should only be initialized when the
>+ * EXTAPIC feature is enabled on the guest.
>+ */
>+void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu)
>+{
>+	struct kvm_lapic *apic = vcpu->arch.apic;
>+	int i;
>+
>+	if (guest_cpuid_has(vcpu, X86_FEATURE_EXTAPIC)) {

Do you need to check hardware support here?

>+		kvm_lapic_set_reg(apic, APIC_EFEAT, APIC_EFEAT_DEFAULT);
>+		kvm_lapic_set_reg(apic, APIC_ECTRL, APIC_ECTRL_DEFAULT);
>+		for (i = 0; i < APIC_EILVT_NR_MAX; i++)
>+			kvm_lapic_set_reg(apic, APIC_EILVTn(i), APIC_EILVT_MASKED);
>+	}
>+}
>+EXPORT_SYMBOL_GPL(kvm_apic_init_eilvt_regs);

looks Extended APIC space is generic to x86. Can you just call this function
from kvm_vcpu_after_set_cpuid()?  then there is no need to expose this function.

>+
> void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)

The extended APIC space should be re-initialized on reset. Right?

> {
> 	struct kvm_lapic *apic = vcpu->arch.apic;
>diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
>index ad6c48938733..b0c7393cd6af 100644
>--- a/arch/x86/kvm/lapic.h
>+++ b/arch/x86/kvm/lapic.h
>@@ -93,6 +93,7 @@ int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
> int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
> int kvm_apic_accept_events(struct kvm_vcpu *vcpu);
> void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
>+void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu);
> u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
> void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
> void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
>diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>index cfc8ab773025..081075674b1d 100644
>--- a/arch/x86/kvm/svm/avic.c
>+++ b/arch/x86/kvm/svm/avic.c
>@@ -679,6 +679,10 @@ static bool is_avic_unaccelerated_access_trap(u32 offset)
> 	case APIC_LVTERR:
> 	case APIC_TMICT:
> 	case APIC_TDCR:
>+	case APIC_EILVTn(0):
>+	case APIC_EILVTn(1):
>+	case APIC_EILVTn(2):
>+	case APIC_EILVTn(3):
> 		ret = true;
> 		break;
> 	default:
>-- 
>2.34.1
>
