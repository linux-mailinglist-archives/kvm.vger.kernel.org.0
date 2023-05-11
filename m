Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF606FEB84
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 08:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbjEKGEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 02:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbjEKGEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 02:04:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFE830CD;
        Wed, 10 May 2023 23:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683785047; x=1715321047;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fQdX6MlxWoL5cAhK1ds+5Jx75XS3G0WdRZzSEX5kDE4=;
  b=Li0a4rsdu8IkhxxexvuDoPuZiuCnYq/FYeDc62n5kaT0NcAkW1M00xeW
   DpJrvUk4X61482zrRu5YOY+U8mMidqgi+HvzVAC6bKsgIzTFr/13nur9Q
   pVvGsCN2suaPjoSDBYNo0tseuuuJI9GMLs+uXcKBAHyyix4VdasERGetw
   OuCags9ah3jNVBERVDwcv2bguvMiilSmbcknCDzcrJYCyfJYNXnuMqMiI
   /5SeGjBmXu4/CL82dBN8uiyfOP2iEf0WrR6RlbwxL4aPs7+G99Iazpxh7
   vyOXKlRRco9cX6Z5BuYD+OQhBZOiacfAkn+J5esDkz61G7xTJ6mIrzsJp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334882382"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334882382"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 23:04:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="946004840"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="946004840"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 10 May 2023 23:04:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 23:04:06 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 23:04:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 23:04:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 23:04:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+Rt7RK2XaHTrPrYUuxYGZLXrQDtflCEuMfcjBhNoAdGzXWojpP2uwz/HovIeD+dfMCfXKXSn0zChh+cDPJb6vGrmXSYyPI6tjwtBeR6lRmpKa/1Uusl9e/pn7QW06c3hU/MBrVr1fMdldaNlgtc3E9rPaqd4p/NPyXdpEzLe7LterlPXaIYv2cM1RDHMsgVtcAt05CznxmnxiaD+xeJVGJaQYNzyaSgLMkPedql08YDighgMf2S5M3DMzl1x+Y54sY/kX8ZYAgahvcOBlnMPInVLx5lM6Mu99EMwGHiik/be+LBaqbX7J1jaLGFcvcYrD9aSzFI6Qk8sTx3YD2csQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfN5fFGchh+ofDcT2fVrXCl9+wCbWXJIzvmho5OmYhk=;
 b=W4wnXzOqlJ1kNcJlLTjeO8Zm0PgeQIEGRZezDUcbIs5X0FNvJ1z36wMwdM69vVE3zMxtuKM2n0xer7nOuOYT3OE6b3VlD41OVnAjtizEULVp3pEAeASnhPhOc11jEAmHUEZgLXM6HUALwPwrXComo4n8tK5yVoW8TuVOpAnX4haJZofK1jf4Aj0b5gBzdLuDKcqHWGGwJcOv/joK75/fRojlkboAF419vgU6hFAXTep4xAl90OYCrP/z6BVRHcVM0lk7VwUHkuBM+S/eEagxHUzwrjcTVtRxXuJY2muxF4wnGsKjPvBRCHk7WhPTvki+WassjlEZQuld8M2u16ES1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH0PR11MB5457.namprd11.prod.outlook.com (2603:10b6:610:d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 06:03:51 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6363.031; Thu, 11 May 2023
 06:03:51 +0000
Date:   Thu, 11 May 2023 14:03:40 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <kai.huang@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v8 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Message-ID: <ZFyFPOo2Fp+yVU2n@chao-email>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-5-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230510060611.12950-5-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:3:17::25) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH0PR11MB5457:EE_
X-MS-Office365-Filtering-Correlation-Id: 32429420-69c9-4546-0ba1-08db51e57e46
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FrYvVpALz7Y8RzrHtazAsyhrYLFmLhKC9UjYPK3vsRmvBz7K1nLGqOgEcbaWrCdKmHeXoxwN3DTOfBI+jckgxJRLDBwAfRE+v76d93xIckDkCEyaXTplRl3bnTqwCWpXVIki83iyw42ecr5Zz3WjA94ckisy/1IluRCm758CATY1khLtpWvgjQJEXrMBAwV902OGZknZYi7hR1RSfJAxpo+0296NYL4tpfCzBpqojeQx8KZ0bkgo72lDPGWKbPUrxN2C2YwI5nZvGzXtOWmY36NZUw24DxaRMylMz0DOrV/FUd6eqg9nxMpMmpe5pkzvtTn4YjOMKPqAV7jvNcfJPUxJHy02r362NFXS9JEabso48Y80Hdc4yr13bho9zwmJ6c75kRkmqiiJjBYP6Ng1NIVK8m55kIgyh73JNtpoXY9o2L10VoFMbTdxP6ljcPtbyG6ielxDbrV/mKlIuRsDpediHzSNvS2bbg9UBXXIWBGbPOixqodSSuWfhW+39emr8meBwOQ48kJ15GjfxmLYN13KxO2XnYH7qHk/ky0t7Et/61SAQBV5J+Z92nJJWYLG2BSubWg8MkV9HtTFEFbntNyyqSZ/LVv4xnwzXHfsE4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199021)(186003)(2906002)(83380400001)(38100700002)(33716001)(86362001)(82960400001)(6486002)(8676002)(8936002)(316002)(6666004)(41300700001)(44832011)(5660300002)(478600001)(6916009)(66946007)(4326008)(66476007)(66556008)(26005)(6506007)(6512007)(9686003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WvY6KVtPfQ5HLZIhW2FYv1SE/xI5B+iXn7ztPaLktVsghyvrPAfMEdSKMxaJ?=
 =?us-ascii?Q?fU7PLafZ04FPz9DTm5uTD1vtuejSgS2UyyhfRhA++ZSq5QZ7lT8+KsVsoDBL?=
 =?us-ascii?Q?DGTj65vAPzjz0y8G+kECZcNe/UaXRyvsj5LZ1BNz8RvzqQFXKu2EA7cf4zHS?=
 =?us-ascii?Q?taRDSM5nSCPLRAgzob2dkwCawJCrF3S8Z35B1jOkAgjAhZynsdTGPNwQ3LCr?=
 =?us-ascii?Q?tcNMVqRa3IT3SN5TZZUBrViYY0sI8Re0umHq9DfOuGCjKfL30U8FqCeGWY3b?=
 =?us-ascii?Q?nKHN1YFpN63FtQd8xhrNeEvR3u0FNes43dmvgcJK2C13WqdsBkpkDuw1SwLE?=
 =?us-ascii?Q?g4Giky+Y8yz7ELqzeaiIjZPH7QWiLWygZ4JBINXNUosy1Bvjq5pw/9EtAj1Q?=
 =?us-ascii?Q?Gj82M70qzHJhryfUZQkf9sN/Xf3Al8Apl0UgDtFhFXaoCqrwRTbdo2rVuoJB?=
 =?us-ascii?Q?kHZcRTStD3BWWjBMhNdGyDGPO8oZQfkG2QfzAaVsD1AP7rG84R+tua5h9INe?=
 =?us-ascii?Q?DHQjBC9biO6xyVkxNY5JPAco9hSgNwA5OpT3euJ4jqQWbvjZyq/tJH/dxj+6?=
 =?us-ascii?Q?V8ZHwy/yhF8OqEixhoDLhPTtxNPeT9gNmMMNjTwM4MIoNYJP6j+vc0GF4LlZ?=
 =?us-ascii?Q?CzxdItpNcm6/lKDunUPETROuzvf56k0lt1NIhG0uSfWvaa4bwJe0g/1cfgN8?=
 =?us-ascii?Q?M17cAF8qlxJDE+bxOR1tiMoN5VLFPCWnbhrFb8IHo+XTeRkvjep84RkyFxQy?=
 =?us-ascii?Q?qQfM8Bu9kCiWiQqU908WWJkJrPTfoYylzr/swo502piTfXwOxCjCNXqHxQU6?=
 =?us-ascii?Q?Iu6zYjVrrQW4b/wArg1mAxichhV1txv/hOYmH3pMrNtBW5cKv4cCxcb+FHxH?=
 =?us-ascii?Q?A8YL3hULjTlk3Gn7D52Nsg4Ox78bJy5cz+1KZfL8eTY1uUrEb5KH7XQ0OVBa?=
 =?us-ascii?Q?RXMdGUVIUvDJBoa8obYp+ULGGbz/LC+EgsmJ+PKJmjn21RQuHxrF5gNaO7tI?=
 =?us-ascii?Q?MdSozO1pvxYZi9LPWHtKx/9Smst7szZcilt3mJ3CV56K/reOatnh/wZ/Q69c?=
 =?us-ascii?Q?iTauQymzsMEBmwIF4tk4tF8hkyN61BNQ3WCl2zAu0ju/t5ARReeLcjF7hpYX?=
 =?us-ascii?Q?ojtGsRp8/5LrClvaqXFen40qjJU1pnkdNTGtfSFwG/JnRYcgA2DbR8v2Gw1N?=
 =?us-ascii?Q?NxJczsFEuhIGlEJ+Ytuz8I+egxtTJM7b9fgArLAKv1YJx7WU/ZqPt45v4yrw?=
 =?us-ascii?Q?Pnh1ZZ/FTev86Bxdr+OSk3xe5zCEICj+QQpT1X4IzP5kb3FUUJOoaF945FBx?=
 =?us-ascii?Q?VAB+6/lHMg6DOKfCkAZM8+Skl9DzAHd44GBhXrOxJ1TcekhxKLsv4EdV6qqu?=
 =?us-ascii?Q?1upzPQjxSEScbJiLogHMDe/ZdHKaVHwnh6TxT7naTHHqugbAf+d6kT/Z2cob?=
 =?us-ascii?Q?kuviuOhiATy8vXCMCduJcqSdJCIuMFmAYqkfvYcWHjLiPPsDMaKkSWDf1S9u?=
 =?us-ascii?Q?zDGDvcHlPcSNC60gwkr+Hy5UqFiPI2CnUzXLSkJURuLvkK0mSWpkLgfpjVEJ?=
 =?us-ascii?Q?nK5t32kRZp9Nol1G47A4ZzB8oJbV3IZPTiOuIcKy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 32429420-69c9-4546-0ba1-08db51e57e46
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 06:03:51.4205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QuEKzVcO0Zm1QxHLPdQz8xDbdf1jdE2P+FLO6gxsP2mdxvHm3T5RiJmiGKpq/5jfuvulr0qB413WGl5EcMJqtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5457
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023 at 02:06:09PM +0800, Binbin Wu wrote:
>Introduce a new optional interface untag_addr() to kvm_x86_ops to untag
>the metadata from linear address. Implement LAM version in VMX.
>
>When enabled feature like Intel Linear Address Masking or AMD Upper
>Address Ignore, linear address may be tagged with metadata. Linear
>address should be checked for modified canonicality and untagged in
>instruction emulations or VMExit handlers if LAM or UAI is applicable.
>
>Introduce untag_addr() to kvm_x86_ops to hide the vendor specific code.
>Pass the 'flags' to avoid distinguishing processor vendor in common emulator
>path for the cases whose untag policies are different in the future.
>


>For VMX, LAM version is implemented.
>LAM has a modified canonical check when applicable:
>* LAM_S48                : [ 1 ][ metadata ][ 1 ]
>                             63               47
>* LAM_U48                : [ 0 ][ metadata ][ 0 ]
>                             63               47
>* LAM_S57                : [ 1 ][ metadata ][ 1 ]
>                             63               56
>* LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>                             63               56
>* LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>                             63               56..47
>LAM identification of an address as user or supervisor is based solely on
>the value of pointer bit 63.
>If LAM is applicable to certain address, untag the metadata bits by
>sign-extending the value of bit 47 (LAM48) or bit 56 (LAM57). Later
>the untagged address will do legacy canonical check. So that LAM canonical
>check and mask can be covered by "untag + legacy canonical check".

Do you think it is better to remove such details from the changelog and
instead document them in comments e.g.,

>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>---
> arch/x86/include/asm/kvm-x86-ops.h |  1 +
> arch/x86/include/asm/kvm_host.h    |  2 ++
> arch/x86/kvm/kvm_emulate.h         |  1 +
> arch/x86/kvm/vmx/vmx.c             | 50 ++++++++++++++++++++++++++++++
> arch/x86/kvm/vmx/vmx.h             |  2 ++
> 5 files changed, 56 insertions(+)
>
>diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>index 13bc212cd4bc..c0cebe671d41 100644
>--- a/arch/x86/include/asm/kvm-x86-ops.h
>+++ b/arch/x86/include/asm/kvm-x86-ops.h
>@@ -52,6 +52,7 @@ KVM_X86_OP(cache_reg)
> KVM_X86_OP(get_rflags)
> KVM_X86_OP(set_rflags)
> KVM_X86_OP(get_if_flag)
>+KVM_X86_OP_OPTIONAL(untag_addr)
> KVM_X86_OP(flush_tlb_all)
> KVM_X86_OP(flush_tlb_current)
> KVM_X86_OP_OPTIONAL(flush_remote_tlbs)
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 46471dd9cc1b..bfccc0e19bf2 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -1588,6 +1588,8 @@ struct kvm_x86_ops {
> 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
> 	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
> 
>+	void (*untag_addr)(struct kvm_vcpu *vcpu, u64 *la, u32 flags);
>+
> 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
> 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
> 	int  (*flush_remote_tlbs)(struct kvm *kvm);
>diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
>index 5b9ec610b2cb..c2091e24a6b9 100644
>--- a/arch/x86/kvm/kvm_emulate.h
>+++ b/arch/x86/kvm/kvm_emulate.h
>@@ -91,6 +91,7 @@ struct x86_instruction_info {
> /* x86-specific emulation flags */
> #define X86EMUL_F_FETCH			BIT(0)
> #define X86EMUL_F_WRITE			BIT(1)
>+#define X86EMUL_F_SKIPLAM		BIT(2)
> 
> struct x86_emulate_ops {
> 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 9c80048ca30c..b52e44758a4e 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -8134,6 +8134,54 @@ static void vmx_vm_destroy(struct kvm *kvm)
> 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
> }
> 
>+#define LAM_S57_EN_MASK (X86_CR4_LAM_SUP | X86_CR4_LA57)
>+static int lam_sign_extend_bit(struct kvm_vcpu *vcpu, bool user)

we can let this function take an address ...

>+{
>+	u64 cr3, cr4;
>+

then it is natural to add the comment -- "LAM identification ...", like

	/*
	 * The LAM identification of a pointer as user or supervisor is
	 * based solely on the value of pointer bit 63.
	 */
	if (!(addr >> 63)) {

>+	if (user) {
>+		cr3 = kvm_read_cr3(vcpu);
>+		if (cr3 & X86_CR3_LAM_U57)
>+			return 56;
>+		if (cr3 & X86_CR3_LAM_U48)
>+			return 47;
>+	} else {
>+		cr4 = kvm_read_cr4_bits(vcpu, LAM_S57_EN_MASK);
>+		if (cr4 == LAM_S57_EN_MASK)
>+			return 56;
>+		if (cr4 & X86_CR4_LAM_SUP)
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

To document the difference between KVM's emulation of LAM and real hardware
behavior:

   *
   * Note that KVM masks the metadata in addresses, performs the (original)
   * canonicality checking and then walks page table. This is slightly
   * different from hardware behavior but achieves the same effect.
   * Specifically, if LAM is enabled, the processor performs a modified
   * canonicality checking where the metadata are ignored instead of
   * masked. After the modified canonicality checking, the processor masks
   * the metadata before passing addresses for paging translation.
   */

>+ */
>+void vmx_untag_addr(struct kvm_vcpu *vcpu, u64 *la, u32 flags)
						  ^
					nit: "gla" or "gva" is slightly better.
					It may be hard to immediately
					connect "la" with "linear address".

					or even better, use "gva_t gva"?
>+{
>+	int sign_ext_bit;
>+
>+	/*
>+	 * Check LAM_U48 in cr3_ctrl_bits to avoid guest_cpuid_has().
>+	 * If not set, vCPU doesn't supports LAM.
>+	 */
>+	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
>+	    (flags & X86EMUL_F_SKIPLAM) || WARN_ON_ONCE(!is_64_bit_mode(vcpu)))
>+		return;
>+
>+	sign_ext_bit = lam_sign_extend_bit(vcpu, !(*la >> 63));
>+	if (sign_ext_bit > 0)
>+		*la = (sign_extend64(*la, sign_ext_bit) & ~BIT_ULL(63)) |
>+		       (*la & BIT_ULL(63));

nit: curly braces are needed.

Overall the patch looks good to me, so

Reviewed-by: Chao Gao <chao.gao@intel.com>

(regardless of whether you choose to make the suggested changes to the
changelog/comments)

>+}
>+
> static struct kvm_x86_ops vmx_x86_ops __initdata = {
> 	.name = KBUILD_MODNAME,
> 
>@@ -8182,6 +8230,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> 	.set_rflags = vmx_set_rflags,
> 	.get_if_flag = vmx_get_if_flag,
> 
>+	.untag_addr = vmx_untag_addr,
>+
> 	.flush_tlb_all = vmx_flush_tlb_all,
> 	.flush_tlb_current = vmx_flush_tlb_current,
> 	.flush_tlb_gva = vmx_flush_tlb_gva,
>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>index 9e66531861cf..e1e6d2e03b61 100644
>--- a/arch/x86/kvm/vmx/vmx.h
>+++ b/arch/x86/kvm/vmx/vmx.h
>@@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
> u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
> u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
> 
>+void vmx_untag_addr(struct kvm_vcpu *vcpu, u64 *la, u32 flags);
>+
> static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
> 					     int type, bool value)
> {
>-- 
>2.25.1
>
