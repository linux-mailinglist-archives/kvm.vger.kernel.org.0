Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AB66E7120
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 04:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjDSCcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 22:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjDSCcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 22:32:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D0D4EF6
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 19:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681871538; x=1713407538;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mVJWVjRi8xZPa1kNKQGfQ1PSEfx3tHwCbOdH01de08U=;
  b=dqBPvWiUIOJQxRoNGRt8V1asc0NoBgUOveWVUMZPB0s3WWirCpQ5pPlA
   i6W01apR57KdmdK0VMrXaVcWzfwZUcaEA+9XvHO2flDAYp8F25KO6+hjR
   Rc9tejZ/iGJb10TaJilM9ZHCNPhzHkK948Pi3IP04xL5IZsGWYZ4E5+WT
   asy+9hY3pGQG5PQUT983sJYqBjQVqLXTwUScObo1TiDCJA/u5CL3RieCn
   LoQocLG2ECI7KfnfpAoerzuWohH8rHo1Pe6wbESdJ4gM3pOJ8sVFOtL57
   y5236GDKBzdpaglbWb7fvIrzY9DyJUAliJhZf5kEyUv0CP2HZ50xvHVSO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="329507233"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="329507233"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 19:30:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="691318176"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="691318176"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 18 Apr 2023 19:30:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 19:30:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 19:30:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 18 Apr 2023 19:30:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 18 Apr 2023 19:30:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZLJvoMlCgQ/HQ/RvLGXjPw4DmS2IT2frQvOym+0YLjwBAvmBY+HNlFUjPTzgZQkjb2ZUv4T0vFQJsPtD/10UT6FNy4NRCkenE06JDmeECpCDrLc3HB4fcmXDC10/iubkVVjaP8eSlLLSo27jo1zy8FaxI+gSPHnkQXMnhQdVPqBvogwubU8DLTd4vpDABb7lpiPaVw14l3qRkLDmjkSr258+uheosgGGsZSHGcYqSFbBmWQdXC/X+qfvVL1vQxY/Awn/W3ChFeHiIwcZfMNIHOfjCALAbxH6yYsQsnkTUPvQM5zY/u6Se3BlmEocZYJgNtkRn48Pg6jLHAyKVeaGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mVrClD3e7iThPeBGvxG/0dCxiQ2mKfUC3JdaxOFZQuo=;
 b=QdJ2LHCuLcwtKNSgBc7MTEE6LKvd/UBpwcXzMcr2NAthvrtOKiW2QlWB+ivQ8XY3BmKAbENTFDPBxJTn+PNAUVOGKmcjBI4cAGikOdaMKhfn6CDLCrUIzPMK6GHgbckeS7b4E330CRyBd29QDx6bo1J7oepsSLByjAQDrRN3VcnAIAMh/RsYFRZmuwrmoJOEFXIravmcE7ch0I01HdcQwJmxWqbMmukq4I8GXR1lrZaE3ACt9RS6qMxGt/xuQGw5SU9HBSLzr1Mp0/T+NzBFyt5MVp3N0DdWDF/TY+K+t+rOU3bdAF2jTf8Dl6TBnK2hncFEWARVgArvnLrbuO5qYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MN0PR11MB6009.namprd11.prod.outlook.com (2603:10b6:208:370::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 19 Apr
 2023 02:30:20 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 02:30:20 +0000
Date:   Wed, 19 Apr 2023 10:30:10 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <kai.huang@intel.com>, <xuelian.guo@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 3/5] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Message-ID: <ZD9SMgA2h8XUXsBw@chao-env>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-4-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230404130923.27749-4-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0110.apcprd02.prod.outlook.com
 (2603:1096:4:92::26) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MN0PR11MB6009:EE_
X-MS-Office365-Filtering-Correlation-Id: 26edc6ab-0257-44df-a78e-08db407e052b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ssc9kGfx8kjIcqF8MlGizy8vYSrSHIOrXVxXRA4NYRn09kS2ysJEx7bSQKsT8WD2H4CjTm1Mdw2gatAugkm03Ou1g22j4+ZNDC+vqlamr8YKLUf2hX7ZPKom+MxpaI42loDx4Ta7zCEl8JXWfF7pMjStov2g16i1BnJOjW8CZHR3rI/JOplcB82BcqBQDpJERO6MmrJxtditeYQDzzplbXaP91Vqjqs75ZylYWHnYa+SG94HZGsb8wH5yBJ8Uqz1UBB0s2Ki2HPzIhpxP3+dgjVF39kjmvP/cjeIL28veNWpyMhLKi5ug33D3mgjkcGu7gjXJZZBJDwc5cJVNEU8gqUiNbgpGxuj8/4PJ1exAQbvZeAPLMOUYlQ4dVcX3Ab9e6nx51IV/kwWQJPOfbox/SnWXodoajFN6m6HPY259qzs7zLi//mOoivZX4V9HyqSLFVRPLrZEQhR/6q6ptC6zvALCVQJqLyHksYuwfrxBmxfehyVawpmecBTZROBeAk/N7N4rkdyjsfUEzO9HVsCWOlUR4wDbQJv9aNneWjm2pd/41CNakWKtoN42qHOzSuK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199021)(9686003)(6506007)(6512007)(26005)(186003)(83380400001)(6486002)(5660300002)(478600001)(38100700002)(6666004)(82960400001)(8676002)(316002)(8936002)(86362001)(41300700001)(6916009)(66946007)(66556008)(4326008)(66476007)(2906002)(44832011)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5bITDHyEpljcPidfcmZyjzGSOziOrg896Vmhr9R5Bf4fmtosXPYHN3Z3bCEt?=
 =?us-ascii?Q?5vN2WpVC4yUCd9bMccO9girvy7s7FSJ/FuP+lRbfEcB0pJwxGBo91QlD61hj?=
 =?us-ascii?Q?yFxKONDykRxjVZpqPqgPQ1PEBzsGq8UMs3cgzqQc/TvVxpBv1oItkX0EtE5Z?=
 =?us-ascii?Q?pr4AESGU0B/YaI/nXJ5wNHTfY6lQZuwY4Ik7jn73omCWAQ+Ovq92i6KOXkk2?=
 =?us-ascii?Q?KsPMfg8T5EfJ8365XU5g4bpXvdxOc9zQg5jbT2IcemejKO9w/SWNv1bw0UJv?=
 =?us-ascii?Q?YIjXJ+l4kj6LreqJmtarsbMlfV5M2N1zYdDY1ndJLrJm4s6ZARc/h9BCsNGW?=
 =?us-ascii?Q?xpqXeYZlBpA6FWD0+Aaspk6thkBKzZ/B8OP/IZlmZ25lvt+ODwHPZxpFQ4Fn?=
 =?us-ascii?Q?OrgtCmpD+kHTYcoZh+fjvVsBy0CsBHUNiTW9mSRpHPGNOl4SgRSCi8OGnIn5?=
 =?us-ascii?Q?Rfr8oEXeHmJ+N8YUjGWazKIiKCPndjbfwpU8b6tjEHRuCZbtRv8Y8J9BVscf?=
 =?us-ascii?Q?dQ6PEqrKAuqgMdd2yqBIMuqZTUo/BK9QrkkAQPc6CbzwAnhlSLhbqxVL2YDp?=
 =?us-ascii?Q?IRrMKvC+0p9BMpnDGKlNYHU+cwKa8L35I1AUETj/i9+N6yp8TATgk4X2taTo?=
 =?us-ascii?Q?XXg9Srywa6X29jNXpTArzfvHpbfx2241kK6fYlYAUYBMvr2hMCXJbCQdMTwu?=
 =?us-ascii?Q?VNXNeTlkEnbkJTbD2NrSX+s7MEm78GHvd1hfxVLdZK/ABC3k8Ny0gh7gnVke?=
 =?us-ascii?Q?7rTvFgga9yTqLsCVoDUPmTHSt376Mbw9Zgk3KaW7KRxpxw4c4aTd/ET+dfUL?=
 =?us-ascii?Q?+Ep0CdiddBsMaQsaAM7Q8l1177/4O2tLAIjDfWavl8k+tjD2Hf+hF6+9vpVN?=
 =?us-ascii?Q?hXFTHBsA+JpwAh3WWeR7Bafn7YKlGUuxY53IoSnY5p9auElSEKZSI/T+0Q4G?=
 =?us-ascii?Q?zsg0eguGxaXZsdgfkRwU+J9ZpM1lnBAxpV+TE3tREiDGKshFIPWOd5W6N95v?=
 =?us-ascii?Q?wynnlIeMjfYZ9/Jt+Sgtv7mqRGqq5bwJA2iWJE5nD5OV/foq/VXldq9LJyQ4?=
 =?us-ascii?Q?9tnLWGJK0r7gWvIFGv7RiKzen4H2fUeP1ENq1vdfClnHoT45KSPwN/Jf0+6p?=
 =?us-ascii?Q?14YLOxzGY5J+9sJRU2LXJunhAMUrm1aQ0RdHyMuiBS/wRihOGAvy+SHBidgv?=
 =?us-ascii?Q?gMIZfMIcAf/qyalTdSurbZ9TCUyMA5jscngLQusLfwJSn87JvqE8/zsNOlS0?=
 =?us-ascii?Q?Uet+sYBH1aVmSaXsOPTiNPqiX5qCCZcAoW3dWgLfZdASX2PALxpBXlp9tcPo?=
 =?us-ascii?Q?IACmUeMiyL5FYij5wR2zvJ+JFtig2cgfQbitjSyJLot2SMs/3V5EXJ7Idr5h?=
 =?us-ascii?Q?mPRy9LQq6Xt3hpArGr3S03+3xPfDqXocAqhMsXFN6ANn714vY6HXZK7z/9Bg?=
 =?us-ascii?Q?/cHAHYCwNJU6frDnl/9SX1YZ9FmU8DwRyvsMeVrnDy1vxQ4amdBFM9AtM4Vt?=
 =?us-ascii?Q?trUmovV407P2k2BNVqRXV/1z+1Ctpppm94bCuM9GXCtfllYgCOinPefVfXnM?=
 =?us-ascii?Q?30DzNE702khGpyJsozbnaCpLbJ3Qiy5lTwwD7w/G?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26edc6ab-0257-44df-a78e-08db407e052b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 02:30:20.2721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JonFCq4PKOcSGFNaaRTyVm83rjiaxSWjIfsH/IQ13J+1dl9eJyH+eXEll9DtFEUR50/PFN3fiiG3uKD5veRd2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6009
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 09:09:21PM +0800, Binbin Wu wrote:
>Introduce a new interface untag_addr() to kvm_x86_ops to untag the metadata
>from linear address. Implement LAM version in VMX and dummy version in SVM.
>
>When enabled feature like Intel Linear Address Masking or AMD Upper
>Address Ignore, linear address may be tagged with metadata. Linear
>address should be checked for modified canonicality and untagged in
>instrution emulations or vmexit handlings if LAM or UAI is applicable.
>
>Introduce untag_addr() to kvm_x86_ops to hide the code related to vendor
>specific details.
>- For VMX, LAM version is implemented.
>  LAM has a modified canonical check when applicable:
>  * LAM_S48                : [ 1 ][ metadata ][ 1 ]
>                               63               47
>  * LAM_U48                : [ 0 ][ metadata ][ 0 ]
>                               63               47
>  * LAM_S57                : [ 1 ][ metadata ][ 1 ]
>                               63               56
>  * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>                               63               56
>  * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>                               63               56..47
>  If LAM is applicable to certain address, untag the metadata bits and
>  replace them with the value of bit 47 (LAM48) or bit 56 (LAM57). Later
>  the untagged address will do legacy canonical check. So that LAM canonical
>  check and mask can be covered by "untag + legacy canonical check".
>

>  For cases LAM is not applicable, 'flags' is passed to the interface
>  to skip untag.

The "flags" can be dropped. Callers can simply skip the call of .untag_addr().

>
>- For SVM, add a dummy version to do nothing, but return the original
>  address.
>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>---
> arch/x86/include/asm/kvm-x86-ops.h |  1 +
> arch/x86/include/asm/kvm_host.h    |  5 +++
> arch/x86/kvm/svm/svm.c             |  7 ++++
> arch/x86/kvm/vmx/vmx.c             | 60 ++++++++++++++++++++++++++++++
> arch/x86/kvm/vmx/vmx.h             |  2 +
> 5 files changed, 75 insertions(+)
>
>diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>index 8dc345cc6318..7d63d1b942ac 100644
>--- a/arch/x86/include/asm/kvm-x86-ops.h
>+++ b/arch/x86/include/asm/kvm-x86-ops.h
>@@ -52,6 +52,7 @@ KVM_X86_OP(cache_reg)
> KVM_X86_OP(get_rflags)
> KVM_X86_OP(set_rflags)
> KVM_X86_OP(get_if_flag)
>+KVM_X86_OP(untag_addr)
> KVM_X86_OP(flush_tlb_all)
> KVM_X86_OP(flush_tlb_current)
> KVM_X86_OP_OPTIONAL(tlb_remote_flush)
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 498d2b5e8dc1..cb674ec826d4 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -69,6 +69,9 @@
> #define KVM_X86_NOTIFY_VMEXIT_VALID_BITS	(KVM_X86_NOTIFY_VMEXIT_ENABLED | \
> 						 KVM_X86_NOTIFY_VMEXIT_USER)
> 
>+/* flags for kvm_x86_ops::untag_addr() */
>+#define KVM_X86_UNTAG_ADDR_SKIP_LAM	_BITULL(0)
>+
> /* x86-specific vcpu->requests bit members */
> #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
> #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
>@@ -1607,6 +1610,8 @@ struct kvm_x86_ops {
> 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
> 	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
> 
>+	u64 (*untag_addr)(struct kvm_vcpu *vcpu, u64 la, u64 flags);
>+
> 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
> 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
> 	int  (*tlb_remote_flush)(struct kvm *kvm);
>diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>index 252e7f37e4e2..a6e6bd09642b 100644
>--- a/arch/x86/kvm/svm/svm.c
>+++ b/arch/x86/kvm/svm/svm.c
>@@ -4696,6 +4696,11 @@ static int svm_vm_init(struct kvm *kvm)
> 	return 0;
> }
> 
>+static u64 svm_untag_addr(struct kvm_vcpu *vcpu, u64 addr, u64 flags)
>+{
>+	return addr;
>+}
>+
> static struct kvm_x86_ops svm_x86_ops __initdata = {
> 	.name = KBUILD_MODNAME,
> 
>@@ -4745,6 +4750,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> 	.set_rflags = svm_set_rflags,
> 	.get_if_flag = svm_get_if_flag,
> 
>+	.untag_addr = svm_untag_addr,
>+
> 	.flush_tlb_all = svm_flush_tlb_current,
> 	.flush_tlb_current = svm_flush_tlb_current,
> 	.flush_tlb_gva = svm_flush_tlb_gva,
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 4d329ee9474c..73cc495bd0da 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -8137,6 +8137,64 @@ static void vmx_vm_destroy(struct kvm *kvm)
> 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
> }
> 
>+
>+#define LAM_S57_EN_MASK (X86_CR4_LAM_SUP | X86_CR4_LA57)
>+
>+static inline int lam_sign_extend_bit(bool user, struct kvm_vcpu *vcpu)

Drop "inline" and let compilers decide whether to inline the function.

And it is better to swap the two parameters to align with the conversion
in kvm.

>+{
>+	u64 cr3, cr4;
>+
>+	if (user) {
>+		cr3 = kvm_read_cr3(vcpu);
>+		if (!!(cr3 & X86_CR3_LAM_U57))

It is weird to use double negation "!!" in if statements. I prefer to drop it.

>+			return 56;
>+		if (!!(cr3 & X86_CR3_LAM_U48))
>+			return 47;
>+	} else {
>+		cr4 = kvm_read_cr4_bits(vcpu, LAM_S57_EN_MASK);
>+		if (cr4 == LAM_S57_EN_MASK)
>+			return 56;
>+		if (!!(cr4 & X86_CR4_LAM_SUP))
>+			return 47;
>+	}
>+	return -1;
>+}
>+
>+/*
>+ * Only called in 64-bit mode.
>+ *
>+ * Metadata bits are [62:48] in LAM48 and [62:57] in LAM57. Mask metadata in
>+ * pointers by sign-extending the value of bit 47 (LAM48) or 56 (LAM57).
>+ * The resulting address after untagging isn't guaranteed to be canonical.
>+ * Callers should perform the original canonical check and raise #GP/#SS if the
>+ * address is non-canonical.
>+ */
>+u64 vmx_untag_addr(struct kvm_vcpu *vcpu, u64 addr, u64 flags)
>+{
>+	int sign_ext_bit;
>+
>+	/*
>+	 * Instead of calling relatively expensive guest_cpuid_has(), just check
>+	 * LAM_U48 in cr3_ctrl_bits. If not set, vCPU doesn't supports LAM.
>+	 */
>+	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
>+	    !!(flags & KVM_X86_UNTAG_ADDR_SKIP_LAM))
>+		return addr;
>+
>+	if(!is_64_bit_mode(vcpu)){
>+		WARN_ONCE(1, "Only be called in 64-bit mode");

use WARN_ON_ONCE() in case it can be triggered by guests, i.e.,

if (WARN_ON_ONCE(!is_64_bit_mode(vcpu))
	return addr;

>+		return addr;
>+	}
>+
>+	sign_ext_bit = lam_sign_extend_bit(!(addr >> 63), vcpu);
>+
>+	if (sign_ext_bit < 0)
>+		return addr;
>+
>+	return (sign_extend64(addr, sign_ext_bit) & ~BIT_ULL(63)) |
>+	       (addr & BIT_ULL(63));
>+}
>+
> static struct kvm_x86_ops vmx_x86_ops __initdata = {
> 	.name = KBUILD_MODNAME,
> 
>@@ -8185,6 +8243,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> 	.set_rflags = vmx_set_rflags,
> 	.get_if_flag = vmx_get_if_flag,
> 
>+	.untag_addr = vmx_untag_addr,
>+
> 	.flush_tlb_all = vmx_flush_tlb_all,
> 	.flush_tlb_current = vmx_flush_tlb_current,
> 	.flush_tlb_gva = vmx_flush_tlb_gva,
>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>index 2acdc54bc34b..79855b9a4aca 100644
>--- a/arch/x86/kvm/vmx/vmx.h
>+++ b/arch/x86/kvm/vmx/vmx.h
>@@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
> u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
> u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
> 
>+u64 vmx_untag_addr(struct kvm_vcpu *vcpu, u64 addr, u64 flags);
>+
> static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
> 					     int type, bool value)
> {
>-- 
>2.25.1
>
