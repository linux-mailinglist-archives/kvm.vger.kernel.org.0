Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A226C117B
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 13:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCTMHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 08:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCTMHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:07:08 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DD57A85
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 05:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679314027; x=1710850027;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gxqlTawRnH5SnZDafGt89iSQxSPvbVC2HF3wbCsn6GE=;
  b=Z6ty+BRiy8qmbSaHpGmjIMsPolNTszTj3rA5t02Q8v9cALIbb0qwJfA/
   Omwf/gLXgZ5Tnf+e7/++1y/H71DnqRL5RfpNV3PPiq+pyHmYK4Gkciy2L
   BuSh4b9mE8TLtoMZmuX7UJbCnLD3C8cWbgOvT4xtgxb96geBFEZLTItu3
   wKs5SyNqM3+ONrGvDEhQBbtWaUvJgJbO4Ho9LAfMrY/X1pSlwydPTDPQe
   2f1kDcJKeCWv/Y1RypjG2J1oqCycWOJQweXFTyLWFzi+BYHs9M3T6OlkK
   uFq3n5V2TTq3A3f2NzByiXnNnpgVrWcD6K0Wmte+FaAL/Dy9920qWeiRH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="401217157"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="401217157"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:07:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="711337385"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="711337385"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2023 05:07:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 05:07:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 05:07:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 05:07:02 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 05:07:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQeXPNjFEpbELqdWLQb+yZnvDPkzQd7h4kcOd9qJ4EB6yuTVF4lvBt7EjzlFqf+bJ1Gak/KDV9DQFHX0Ttqxxwx465aHK3h/BSxCpGge4Osz9Rg0NlwMWh04e/3dJ6TaeNoZFgrOxt1g0jeb4GvM2m+E78zaNamCZRUInedFbE0qg1J/XY3Yz6CPVBPeal/DOq8Ix7KOB4K4J1/5fYkV4C9W0rmz3zCrzAbkEIQ8bdYb2CcloRPUrQUfgrtDB5xknDkgpX3v6SS/VBLasCs8+HfSU9DNr4EkemTJX7jWkpKEd3vovDz4cLyBISBT/yHJFssmgzmbHl27MwRgzE9bLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cD/nDHxlsu3l1GgU9NmLtaLD/YNPzBPhPQGsWVk2jo4=;
 b=mAOLyRExDHF81fBHZXFmQGXJY+00rbd/asEqr0RziAVyb8eSYt90/R6JaEiY3aR4PHkKhKoEK51/tmgR6FHVbMPP9Dm54oV3yJ5svqEkczeO+S9LphnnPi0zKCC4axt9+0PkHp+JDDTCkTVzUtv7qab5vrQ6/otJ3A9bNr21H4uAPmofkJ2hVocgoC1Rs94A2avH6OWrxbHIE2MaQ78zsCUc2qNOnj/kxgYwDIw3X09jpZ8Z5oDnXQFCzZheAgCZH9K3GgFWVahESk3TgI9o7VF+BXyJE1OgUtPN+Zv1LzJTyhV495/sdKHZmkYXelkGzj3KvF5TKbMb260pJVa4sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH0PR11MB5046.namprd11.prod.outlook.com (2603:10b6:510:3b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 12:06:58 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%9]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 12:06:58 +0000
Date:   Mon, 20 Mar 2023 20:07:25 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v6 5/7] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Message-ID: <ZBhMfRoAujRSmaRp@gao-cwp>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-6-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319084927.29607-6-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0214.apcprd04.prod.outlook.com
 (2603:1096:4:187::17) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH0PR11MB5046:EE_
X-MS-Office365-Filtering-Correlation-Id: f82fefd4-c67c-4b47-9aaa-08db293b9b15
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhHo8jR8jQ/GFK7iajrj50sWr+bRfwIrL3FeUrgwOwI/swMy4mEiC/lgMhves9xjQ5KrY1pI3slF/l2KFDajYz2kSuvinTciJdGJYAuRDGaojSOGSVLJhfX73NEsP9ysVlfOAQmaOn7o6UyWTg2L4zrQNuDwtEXzIDGG53RjR5f75+7oEP0EUcXIIwNgofp2LYwNTLXaluMFIYrvdBFYuVJ8WUqdQqs1EzDWql7ABBTssnAxFxjNfjk9o4Se3k3U0W4csETF9IGErxT8xkOBC3CbSHAXU8rFP6nJR+5K5QbcSPYvZksgZF7nJ5E/XMiKWnauncR2thkpIydtJbxFb5JhonGmae20B3ygQVC986uJnupPkN6ceo1t5G3w+mYMfgmTezeS3pytKKlmyH3t5nfF2m2hMbtpyisTgU7j+z/5Xb7tWG2VjDOsvhSmur5AJG6YmVr/n9zbwhMWOYEuECHKQbSuDEiN7JAOx/w9WHK3t5ONJFC4JqblZ2Cli2X4QXmiKoR0erRBUvTdedqBPayLqamkUrCnt025ztVrzYyyXpto//68/fIk7N6/poeXHYy00582I1JZWG4lRvzI+fJ5WG5y/Wry7TakF/d1Hn/oA0m/KMVddAJbY7fEmWeKvuU2gIoLu52DWHCD0zCkyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199018)(33716001)(316002)(478600001)(6486002)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(5660300002)(6916009)(38100700002)(86362001)(44832011)(2906002)(8936002)(66946007)(4326008)(82960400001)(66476007)(66556008)(8676002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xXlx2Ea5rOtk+AwuP/1Pz7i7P/iV+fpAkPOeK9HdZIjjAmrBjShvK3ajbH2C?=
 =?us-ascii?Q?VKhusRMsFKc9k4oVqpjgz7Pkc+CxwV34zi7C3mYTEZD9B0Sysi2f9s2anMzq?=
 =?us-ascii?Q?SIqE2WZS3XDouGF3vyNCPgFC258IA7fMQmXZzm9GEzlokB/xiiQBeQe+A9b1?=
 =?us-ascii?Q?xk1lz6LdWfI0HXqO2Eh9ht15AsKi4SeoLKOW0+seXExNfhb5shdZt5QgKGxb?=
 =?us-ascii?Q?jlBKUMHJYGxrR270hKe6zquJA8X2rQXT59evChCKrXLpCcP6v1YCZ0SNPfDa?=
 =?us-ascii?Q?aazH8/ocVKu6HWcnnRHkwqFqdZm/5YHlG4y6zL3WD04jRqN3PHm9Du4gMV90?=
 =?us-ascii?Q?rPaJQ60VFzQ4LofN1sthsGxBIyEISyYcY441U/uqc8QRBlsJZVfERwszkGBy?=
 =?us-ascii?Q?l15iQs2UWowODYGX4vOAoW889fnunBGxOZFbXrRj7x6rfKCUaRiPqEj4YrQ3?=
 =?us-ascii?Q?mMNAa4/jzwoV2VIMQGEjk5SxZdd+XslN9PdXjhb2WrNDmTTRqs5wXYtzc17z?=
 =?us-ascii?Q?1qHLA3ZkXH+MomPdCIQ9GhHff7WcqqhgqLVEb1ZTswkHaRZJAXbjcoUHK9aq?=
 =?us-ascii?Q?WNJJ65T3WlZCh1h1FnpRqeSiaRG6R8k71+0TcY8W3hD9jza5K3kjUKzt/0mr?=
 =?us-ascii?Q?aRt4RGTPZHbBwzhSMgPEHYaOYQRBcKid5uUnHKYITVM4F4vC/u8JON1ZFvNS?=
 =?us-ascii?Q?iN36CmKVtcRfCJfpwoxP7CaYJ21Jg/eMcXCfGu/zMBz8XH4tjOEaoEqU8Tyg?=
 =?us-ascii?Q?I1ZHq5gb+eFqoiizhG7PVH2lQSiNAwecv/gTMrtooNgV4/t16U31efhNZjB4?=
 =?us-ascii?Q?/HuChKHW045JBo/Jepz5Fxs3Pt9KbhaDm2y+oa9V+4eW54RNlY4Zj0BWTnl5?=
 =?us-ascii?Q?7jCr5UG5xNP1WrgfVgiNeXixzQy8nX7ZnF6/TDiks5P1B5fXLY3meeV2daME?=
 =?us-ascii?Q?amKtEyEoZNbNqWxoB4ogH9GEj+7tL4voZGfFqU6+vd3OM85cXeYCXoHL2vju?=
 =?us-ascii?Q?jwP90yj3W7MeBmKwjYgpOCBRf1LRWTLnlzb6A0A1CJByQqfPC6efPoZxhqvR?=
 =?us-ascii?Q?GR7RsL+4wPmnxUpjSANbIn0RVIUi1wFOqU7PiJypye0XD2hS6Rph1+CgaFDO?=
 =?us-ascii?Q?FJ+xmD/ZsaSz/2noximqszwSEanImoVJ0GKX6OpIbjW7lMhgOhtjsYTk4Ild?=
 =?us-ascii?Q?SL/SndzmR5E/n+2X2GspI4hnQGhtLrFRZP4CPOzmqKf0WJhmQLEiwYdLuCEa?=
 =?us-ascii?Q?nz/JBsuENnXBCBZ1A+eAgwfN6Yn4hYB8AS8aG6/dCfr27sqhqQHd0g5DYByC?=
 =?us-ascii?Q?lOIuFK0Ao5AIzGJ1QhmQL+MCv0q8ZqQUxv+AjniMPF2VLa2lmKDQ8oRN4wA8?=
 =?us-ascii?Q?qMuTgEEJFxGqcJ0ez9HfuP8X4X26IY5IklXPnaNmmNMn+G/Hqe4o0q+tezQR?=
 =?us-ascii?Q?UQnjXizcN0sE5s0v11FILXbOQR+mM6uhwgObwVgApOI9nsgDL0rYM32ku2xD?=
 =?us-ascii?Q?3AXL2K0aF/EgQ6u8TGxIKie4SfaShO7CD0UM1wnHPbwVhCmXAWZtvBPPSGHs?=
 =?us-ascii?Q?qouW3IlfObbwt+d2oMsKPwfy52qYJiWAuJEZiGoW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f82fefd4-c67c-4b47-9aaa-08db293b9b15
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 12:06:58.6937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIvguxZuuINWHZL3YQ9M+laT+zEoWRK3/gAhxwZUK9diLzy0JfuPJio4Wu2vxFLGR2udp9vYMGYx4KTonkkopA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5046
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 19, 2023 at 04:49:25PM +0800, Binbin Wu wrote:
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
>
>- For SVM, add a dummy version to do nothing, but return the original
>  address.
>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
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

Suppose AMD doesn't/won't use CR4.LAM_SUP and CR3.LAM_U48/U57 for other
purposes, it is fine to use a common x86 function to perform LAM masking
for pointers. It won't do anything harmful on AMD parts because those
enabling bits shouldn't be set and then no bits will be masked out by
the common x86 function.

Probably we can defer the introduction of the hook to when the
assumption becomes wrong.
