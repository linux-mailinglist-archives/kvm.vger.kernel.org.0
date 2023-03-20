Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EBA6C112B
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 12:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjCTLvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 07:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCTLvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 07:51:17 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1DB22A09
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 04:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679313075; x=1710849075;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5Ey6kyWQjZhMD/LX+cbwN1O1/dCtuO1SPWEh4sePT3k=;
  b=FvrQTTf5FHTQUTXrULgmRpveUjBeoCKDDeCkl+KjQv7kEDrXhCAwzT0X
   7/su7JwlLoSJ/6BHRL4TiuZI3A95A/9Rg/m2nwB4SL/cDKRrqAuQf5DbK
   8rDBNVTbyMbWxtphLGiSBRXHNwsAVExWBR4LTxKrYlA/9EkqqzrrQ3wfo
   +Hp4KkX4xLO66J8blb7i96esvsExcQhQDtjX73mnHl6lwFVX1+AOw706L
   BcBbZW26+1ehQDAe6g6iR0KW5HwutscBT1eMt2Wp6GS4SkG1OaMvBifFs
   t4sNGmHMmqYm8686OUNhRNhmqNAqDoqj+Ya+96VgJN985QF1Bu67flxzI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="401213682"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="401213682"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 04:51:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="1010442257"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="1010442257"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 20 Mar 2023 04:51:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 04:51:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 04:51:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 04:51:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 04:51:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kq80w09/IMYpnKfYlB5vFcBgvDppmUzoqWC5NyN811p/76a0zIwmO2a6GePB/w26AQ74h9LHMLhN7I7ehMDAZkebvGf6viAeycYtd3ncCI25JiH1xfgg3jpHSvKioctxJ04W6xat7mPYI2LhC1mthWSqlu5QvVjuSsGUhUJ4PHyDWftB18eYYBBWpvSILHkXxH/M4nE7e0uKavExMGwJZbX/a1vxsSho5KXbXkwZmR2OOnsKbJQh0DRh59JU2rlZliZkwyZVrI5tHtrsuLsIQKMLDei8/ckuaWsGhOOnldZGmnfDmTM/J2DEqyy2lT+ZW6rY4g7IynKkSrS7uKaG1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2hJW1N6+zax7M8368jpdC50p5f6yKaLmkU4NWJ6rn4=;
 b=PtW2TigLh78lVuCGzv+NXqtVpporm3wA3InXg9SBmxy0AjpB4rn+Gx4fsLQiyYuu6I73T/hf0oRnGbI2jwTF+DXs3nTN+EY4yaBg9cFAF29mGcblNv7k/j6QOJSTXSKJQY43+1Ksy9t/sflm45AP3pQVyhQzF1Pq2scymA+e4aeh/nhiLQ8HbB/oxRjqZPngrF/nx3TEkLLJQQLuWXQDYr/8Tm8MYMRipCeP3gYNu3UG250vhVxAtZ+XzueilfKt4FkjeeqfCUbexVIsvoaJ6FUlqHyNt0JrSD/fR76QHAa88TtjzRWrsFS7QiqyLqL+YSq/980nXW0pWU9fP9Ojgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CY8PR11MB7136.namprd11.prod.outlook.com (2603:10b6:930:60::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 11:50:57 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%9]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 11:51:01 +0000
Date:   Mon, 20 Mar 2023 19:51:28 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v6 6/7] KVM: x86: Untag address when LAM applicable
Message-ID: <ZBhIwLfkBqwvas9d@gao-cwp>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-7-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319084927.29607-7-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::15)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CY8PR11MB7136:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d5e62a3-ab27-4c78-aaf7-08db29396064
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CVYxeLTi61klUGkVumPhWWrWqxgIqe3EVO3NmMZO1zOMQp1ZUQi7xHhtj8/tfCbyJH8hZBPOa1gT7VoWwMNc5aNvY9xtjIsAy10MqZkm0nK1uEag/KS/AzfX24kbTNjLgJU0zP3tuFcSyFGhM7d54m91dYVgPI7a96JO1E2BE+OLFEOQhVYbbDQEcOJutc4fY27BLI01sQ0EgyR4vCXOBLRqRqUqPrwS0fVB/Cm44bqn/DDRzaoM60dBJodG8Gxd+j20xors9vitB8HMCyvrUdTSyPpM718YlKvzhB0rb++vZr++IHqPlxpyCvV5yQhYmPie9ovctiL1otU9TLQc9WVSaUF9l5NHBoRVQslXQPUfVWqgeKs6zyn3RbtBkPhPiLY27V/5CfFnB4ZZP9EIJ/UGlR4rZj8rAYqCZTv9wMU9X33IJYqmYm7iUAVXf8h3HcsMDKoU/Z3iYC7hvi3g7E1qvLwHdC8+Etx9mPOMC5kXCepi3Mlw2MJhA/ypiUgQNS7oS5LiuVRlST8wY91Hx9b8FK1QvxTD2JXdtcAaO8FLBPFcygvcNC6gZR3SqDUMD1PQW78t7/q6bONwKOpFuB5Jwx69KHUBiC2o7hhbOpwfcpAb2Ej0JG2TyJE2uLnFuQI9oZB2IdXGk7puD5b32A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199018)(41300700001)(6666004)(44832011)(8936002)(6486002)(5660300002)(82960400001)(186003)(2906002)(478600001)(38100700002)(66556008)(316002)(6506007)(6512007)(86362001)(26005)(4326008)(9686003)(83380400001)(33716001)(66476007)(66946007)(6916009)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OfV9UT/qIUIvaXBM9+v+sdPoic5vuzxi9qpncETboOvaDyMsB+0NX//213IF?=
 =?us-ascii?Q?JjtCtSAcT0VnaJZGwL+64jR7tsA/oqzaGDJDfCLnjttmagbtdGNV5SxBAApl?=
 =?us-ascii?Q?g+sgzN/X5+j7TOE5K/Ledt9gauhIFzesLWTQCTzlG7p1NfXBAthJy2mRJ1My?=
 =?us-ascii?Q?/L227jfkbA46ntKjEIwCkWhQSIxZL/JH7WImMUroY4+gO7f9M2zLd2CU49JN?=
 =?us-ascii?Q?yBezh5mvYyNnzVh9VkwmApaiGGC2akjDT9NjetkQqtl+swH/jgdjGAzfLL1l?=
 =?us-ascii?Q?Q+Mg602bvccnkLA4XlWRa0lDVZPxw29rXQsmiyih3kTH/QhG5H9gRUr5HWDx?=
 =?us-ascii?Q?0KI6KB98xU1BYTVeyuh0L9YKcIziyMoMVJkmc7amGtZxLqST53FSeRNY+3OZ?=
 =?us-ascii?Q?MuJMyDQ1503mO4BZTvF6TewuJjbOObX2DR1cBh6yExrzX2DLxHXteV33P/wA?=
 =?us-ascii?Q?Im+nhfutjjdQ9QHZctCijlXXaC8WvHvhnsxkGT1QfYpZ3f6JEBD0T/4RZX9o?=
 =?us-ascii?Q?yMj0CjGbtC8ViQ+nNrgngHNfnGmmBUJul/xJt4UZzwEotya3WdzuadpCRKFJ?=
 =?us-ascii?Q?I4U6VO/NCWBGyFPBtznnoNrJqAM9kPdquUp6A+HooN44h29x9z6vR1giyG2E?=
 =?us-ascii?Q?cXp5VF90c0no5WxnGg+XT1mS+0CR0Zbgd3eGnfxKlIwkJD70RJ8NRY26G8i4?=
 =?us-ascii?Q?8AwcUhcCD8Ajn3CU5gx40HcM2rGsG5BwV1wkfJsmwOETc0wu5aFUke4Wq5aq?=
 =?us-ascii?Q?hHP8w2aZY/AG9vR0+db6/poMEHHAFovbEgB7BWLbdvrPIM52LLq5Xkbe4tJD?=
 =?us-ascii?Q?nR37pzBFXQ2ud6ELsBjheXbojHYcZ3SM0cw0NVEi4J8bXrVcB45l/kkj9Ac1?=
 =?us-ascii?Q?91rYRMybviomyq7i0xV7ed6taZfUIPBikFChi/stNH++Zz2ERWVYQSL7/r2O?=
 =?us-ascii?Q?gqsltHcjOTqadCkbxNzdYXvSiuQsuXD9x557Smt71SeAdNnMBUwc0/YjJhcj?=
 =?us-ascii?Q?iJRlW0gekHPJcSKQmqcocH4Ar/xDa7mOydM1Eu0h/Cynin+jFETyclf4gknb?=
 =?us-ascii?Q?y9obVLhfsLwVMU+Txrm8IVEx0P6HcLLon1LAfxv+DWHjfQ5ugrukRwxFr0+J?=
 =?us-ascii?Q?3kbPBSOExXckcRfTJdHJbgA4EeTZBVRbaazscRrUZ1vtjGx25wWAs1Bd5vC6?=
 =?us-ascii?Q?4+UEylt5mmkYwlTuKXYcM8tJnAFQF67Hs3i2hlaEKj9hnr1mtRuJtiONUeCC?=
 =?us-ascii?Q?hUBxfMdJLpc57TN0x/BYOayR3sV1YpByi3YpRyxC7EfZqk2FZieAYb2G2/JL?=
 =?us-ascii?Q?JdnVedw8+iQHIdYClI+HRksWMSb6bImOTTlERD3zcgfw1m2cyomqigoCcp+B?=
 =?us-ascii?Q?dcYZDM8NwJgr92Gr6hxbdnm5PjqwSqR5BFoHLZzsr/AOfTgg1iv44NdkVflM?=
 =?us-ascii?Q?MG8zghz3tbpUOVuq/WpRtntBlw7azdLHEEusyi2imHYzS/0Nb7hYIZXNCfSl?=
 =?us-ascii?Q?Us/64Xokspa9h1EEIzYzpGp9fo9+KqsI3Uy2zs2+lCudTpSkq266JWfr1Ab9?=
 =?us-ascii?Q?vOQw7JbNssA8c4zRr9CnznClrF0bmPYr1OP4U9jP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d5e62a3-ab27-4c78-aaf7-08db29396064
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 11:51:01.2172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YVpH+6TFR1MRiOpJ6W9aEDMDG3NjviO9XQXBWJB1BYjLLN7/rG4TasSXYOjHSP93QGO8bvnUzSQb3+Z7Osyzrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7136
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 19, 2023 at 04:49:26PM +0800, Binbin Wu wrote:
>Untag address for 64-bit memory/mmio operand in instruction emulations
>and vmexit handlers when LAM is applicable.
>
>For instruction emulation, untag address in __linearize() before
>canonical check. LAM doesn't apply to instruction fetch and invlpg,
>use KVM_X86_UNTAG_ADDR_SKIP_LAM to skip LAM untag.
>
>For vmexit handlings related to 64-bit linear address:
>- Cases need to untag address
>  Operand(s) of VMX instructions and INVPCID
>  Operand(s) of SGX ENCLS
>  Linear address in INVVPID descriptor.
>- Cases LAM doesn't apply to (no change needed)
>  Operand of INVLPG
>  Linear address in INVPCID descriptor
>
>Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>---
> arch/x86/kvm/emulate.c    | 25 +++++++++++++++++--------
> arch/x86/kvm/vmx/nested.c |  2 ++
> arch/x86/kvm/vmx/sgx.c    |  1 +
> arch/x86/kvm/x86.c        |  4 ++++
> 4 files changed, 24 insertions(+), 8 deletions(-)
>
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>index a630c5db971c..c46f0162498e 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -688,7 +688,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
> 				       struct segmented_address addr,
> 				       unsigned *max_size, unsigned size,
> 				       bool write, bool fetch,
>-				       enum x86emul_mode mode, ulong *linear)
>+				       enum x86emul_mode mode, ulong *linear,
>+				       u64 untag_flags)
> {
> 	struct desc_struct desc;
> 	bool usable;
>@@ -701,9 +702,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
> 	*max_size = 0;
> 	switch (mode) {
> 	case X86EMUL_MODE_PROT64:
>-		*linear = la;
>+		*linear = static_call(kvm_x86_untag_addr)(ctxt->vcpu, la, untag_flags);
>+
> 		va_bits = ctxt_virt_addr_bits(ctxt);
>-		if (!__is_canonical_address(la, va_bits))
>+		if (!__is_canonical_address(*linear, va_bits))
> 			goto bad;
> 
> 		*max_size = min_t(u64, ~0u, (1ull << va_bits) - la);
>@@ -757,8 +759,8 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
> 		     ulong *linear)
> {
> 	unsigned max_size;
>-	return __linearize(ctxt, addr, &max_size, size, write, false,
>-			   ctxt->mode, linear);
>+	return __linearize(ctxt, addr, &max_size, size, false, false,

							^^^^^
							Should be "write".

>+			   ctxt->mode, linear, 0);
> }
> 
> static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
>@@ -771,7 +773,9 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
> 
> 	if (ctxt->op_bytes != sizeof(unsigned long))
> 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
>-	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
>+	/* skip LAM untag for instruction */

I think it would be more accurate to quote the spec:

LAM does not apply to addresses used for instruction fetches or to those
that specify the targets of jump and call instructions

>+	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode,
>+		         &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
> 	if (rc == X86EMUL_CONTINUE)
> 		ctxt->_eip = addr.ea;
> 	return rc;
>@@ -906,9 +910,11 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
> 	 * __linearize is called with size 0 so that it does not do any
> 	 * boundary check itself.  Instead, we use max_size to check
> 	 * against op_size.
>+	 *
>+	 * skip LAM untag for instruction

ditto
