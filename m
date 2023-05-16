Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F09704874
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 11:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjEPJJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 05:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjEPJJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 05:09:54 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2532D55;
        Tue, 16 May 2023 02:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684228193; x=1715764193;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eairZBIIuxdmIJ5FWiR24zh3LCQ0AdbBS1k1oRbqXP4=;
  b=jcSqDMiHTDYtQLOre3xXBHSBLup0wzD3Y4wEMl2rFjP/Nbg+GhmoTuug
   2LaFCQvkcQ4+iebXB/1deXBtucIpHcN7dIZ/sXpsfa9DiAZJQwhwdUSwI
   DvldKpkSYF7GEgKbzKYaRVRAX2N2uZ3hCvwJEblGyyS1T7V1JIo2a6uBg
   FYGKjSNkPjeF9eAAzohobzJP4YtdOl9q06ThmJtl2gXG94vM4d3TneAHd
   8WHZalsjDMvNGfQBXYyPkvbBUxOKvBk7YwwSBOQ+gQakQgA+Do/gebage
   /idcWTBTmA5JB/G0lCbWLkdVrJHmRCR5/jL0PMPIa5VuaAm8EHBrAKsrT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331042028"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="331042028"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 02:09:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="731918189"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="731918189"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 16 May 2023 02:09:33 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 02:09:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 02:09:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 02:09:26 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 02:09:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dI+JBme9qw8JA1O6Ak+cHrEPsIz1J3UdM9lofq1EgCKllEzKML5d8yOOYkz9hZ9S/mDNAoEm0FNnt1g5emj09QST1IkhjQbbVYS+zdYp2a/OnRg3PZpK8bc0Vtpj21cwR769UEYYfL/zpPgqTwl1uYhr5pQMQt6n+5PbdaaQTCM83hHBs5L5DIArykfeS89ghQ+Qga8kGr6R2xGQ3oZGptrNABZWT395YFhQY3jfddR8HhS8on7dd8Y2PQzC712KgAaRb4bzESZojrVmRmizK9Yfhl5ovvPJMgVwHhgKvipMWI4V1WCZVtqvvw2cjsu6x1f9BVoOCz/smoaZqWKZOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3uW1jnINDGLVTY96jh6dQnCxw6JgBiqyEAsi2OPLqMQ=;
 b=GU76RkP1JhrFa5Gq1Ih2x+nEjkYiqswYnzw8EOVVeDzeqJ05QukQ9CSBpdzBjGTrR3oiCgmDxoXbHgpKx600SMUgL6Ih6Z4oKX1yhrxMUZrb1jaBOqYDrFvbgQdsh4bhgLLp8ao/2rv6JmLh9nfX42fwMpW4YCpBYDM71FA9+iMa6tMY6Ak2CfA5XRN1Fl2IX9qSkN1coUNpvdkbxOivB+T6AsLJ3NX74yWaA5+SIlr5+REeBnEb+umwI+ZPABImkEBYlAXxotLrZgLpPaLTnIt9oaDU9VJC1r75H6C3Q3atdoFE2fiyGXYhrLDa0QqBSPCvdKjS3gyCh9TzP2eHwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW3PR11MB4716.namprd11.prod.outlook.com (2603:10b6:303:53::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 09:09:23 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 09:09:23 +0000
Date:   Tue, 16 May 2023 17:09:11 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 02/11] KVM: x86: Advertise CPUID.7.2.EDX and
 RRSBA_CTRL support
Message-ID: <ZGNIN7O8BErVP88x@chao-email>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-3-chao.gao@intel.com>
 <a88b2504-b79b-83d6-383e-a948f9da662b@intel.com>
 <ZGLkvlx5W0JStTjD@chao-email>
 <9c75663c-6363-34e7-8341-d8f719365768@intel.com>
 <ZGLyEhKH+MoCY/R4@chao-email>
 <11b515b3-bb5a-bea1-ad01-caffdd151bf6@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <11b515b3-bb5a-bea1-ad01-caffdd151bf6@intel.com>
X-ClientProxiedBy: SG2PR01CA0144.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::24) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW3PR11MB4716:EE_
X-MS-Office365-Filtering-Correlation-Id: 7957e4ef-614a-4d06-4495-08db55ed3d6a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zj9nkYZVqCTjMdGVc9gEETeePD734eUTdwXpWmFpGzzKuSYMZLMGt8iefIK6prr2x3glBQaWH4pqBdHQpOMNXylgPJn1B/6Xm1n/taNGoaTjhFEy8ipD8GaZPN8ztYsdczdIVjp8SM6CrZYOG1MaRioLz8E+Esb7LCqRE8MAHIikboiFf5jNwM7sWntrgk8hKoUwhc18jOdLMymuCEdIeOeXOhRWkuuhLLOcHUgKR1lzevxehYVlDs07srFj+MIHi0HeGcvv6DkWYrI6ZoDorWacLgDyCdQq5im+geBuyBAcZdZrdHSHN0RICHX08YcmEdo/JSFqK6QOQEFvLEibSzxdsWclc4xeohUd1xjqDcFHn8fv1ZoThuTpSI2r8MTZuZBzJYDiCqyeBb7tSpi9e6UNBVTP3DstZ/s0lFVkT0N8HR9DrybABM86H8uDj7MHpMw9ZjFp/tanR3P057VmL6FRigxX3iX8XacYBlTTNopncvB1zZ3LGqc6VTFlDzzdWp91ijHUuyjwqJ1WhEuT9kJWJZy8Jgd9UzombgbeuCd+ZY9JdXYpNqQQDrkGLyXM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(6636002)(4326008)(2906002)(7416002)(44832011)(6862004)(8676002)(5660300002)(8936002)(41300700001)(66476007)(86362001)(316002)(66556008)(66946007)(54906003)(478600001)(6666004)(6486002)(186003)(33716001)(82960400001)(26005)(6506007)(9686003)(6512007)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2qPGlmErJefBEp4i8swCfWTPZHr8/JXcQO0w5RLVBl3RKoQUMwWhH7lItOHX?=
 =?us-ascii?Q?c5lDjZQyRHTX+nxaMqNCKxUruBEgMcDkrYUzEqro5oieaYTwu8uoTGEumlVE?=
 =?us-ascii?Q?202URUlyuDUU6DjNTZRCH6zC2MUaArJA+iRpAc2jfdxrCBHqRIRzdiYHROp+?=
 =?us-ascii?Q?KACeignMkAkYKT7aDY2AkRtxJ5IDRMfvj4i09YqqiMhWH1pfYoZg9klskqhw?=
 =?us-ascii?Q?uXhKNV9XRVoGEZnHpSTWr6OOnK87P5dgjDojwEJ46Djy6iiynvbXGUbiOTwk?=
 =?us-ascii?Q?I2R8Qj2BFJfOkJRaBRp4u/hrN1BMiwTzMmPwPg/AkXX9xieVTlmcBj1bL12S?=
 =?us-ascii?Q?1t6SdA4n9jLH7zH6UU6/VJfuHS2y8SA9KoM0gA8oR9AeviWlJDKW2Y9jFjxz?=
 =?us-ascii?Q?S2lXQm9KR2Gsg06iFX/Wuka8FVT2D9Q1f/uTeO6G9AoD7FZRxniZh6n9UJgU?=
 =?us-ascii?Q?q9ywqWLmK/s9JjVxzUUfeK1dHjr7mbIPFwvrK7L5p/2jdRZkKL5SblYBqgPH?=
 =?us-ascii?Q?SJKPoVjKgPnuA1LuT44kU+qDlBb2p9TpGkg/TMAWOmGWRzXVmiHoYZ8wCefY?=
 =?us-ascii?Q?tBLd1eUob6aZ34bL9V4i+kWrnRO1QY8EkEimQlIRvd1Ej3KE1TJv+qIE09bp?=
 =?us-ascii?Q?oKHDPCxAmgPx7gcF5TKQ9lbq0il+fGEvWDT63XOOe5kYfYv3sGsx2icjDvWb?=
 =?us-ascii?Q?duhOCd0SmdOKztJLgIxHZy0lGSkZHM7jbXidGDoV8i7YaTnhODbHWzRvCriQ?=
 =?us-ascii?Q?K8V9OOZole/yIos0zfXuzuuDojQhN8k/Lp3DflZWN6R5lOI674sjd9T89yDO?=
 =?us-ascii?Q?6sF9w8QA+6wskRecvc+QTxtKiVaaGm/dh2k93li6BtmhfnX9+gVLj5D2K7kw?=
 =?us-ascii?Q?Xo195Nv4/5U0vEwsNY3R0IjLff+3rEIXxkGp1udanya66XJVoM6tDQ9CQqOo?=
 =?us-ascii?Q?0mvYwmYf2inZhhTatrgHZVEDexoiXZQlmcuF/ctluVQc0KrxRSYrYoJDPXn+?=
 =?us-ascii?Q?vUx7rFapsdL3lqvylvL9UjBhwPERKTfuu+gv/4yyDSm5ekq8/lXqA9Hl/uqC?=
 =?us-ascii?Q?bCF7CSj1XRUrJnQPxMJrEcY/spZDVwhFJX31POD+eyiVNdoT8ivRGuX1P1Xj?=
 =?us-ascii?Q?KnsGw3KvlPyl3Fvt+qe9V4NtEIBRQscoOCQmYQontsGAbWoGkWzzBXHwshuH?=
 =?us-ascii?Q?jUFPRwdzQ95EUpmOhaUFsii/yAVKvnGzyvxPDuFo0Ht9ReqFx85IIFbp6ImM?=
 =?us-ascii?Q?oLh18x6IY8ngMs8NDrLGGzkjIX5Vu03ZlFI2HM27VvIxHm+jzkdNHREMQnbn?=
 =?us-ascii?Q?5sFQb9HiNQ/96zhLt9yzsIyxnDkfF77mohLHTmB17YWd8wNDx557xKg1zJIb?=
 =?us-ascii?Q?bgJ3ep5LkQvmj/ZqxCXAz2NFuvek0//XSEDcL3OrNh7tOSTwKSIw3yivGXDu?=
 =?us-ascii?Q?4/4x7kkJwHAG+uVenUogBoskZE73dV1P+qL1T4Z60opw3oveVViAplJmpEO4?=
 =?us-ascii?Q?e1YckSg39Oj2Iy9kfXirlNFsghJ8W+hg0Es+pP390VZG667KgX+rpWwR+i2p?=
 =?us-ascii?Q?rSM0ic4kU51+5KO1i7UAek3qO20QyajRzz8D/nXK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7957e4ef-614a-4d06-4495-08db55ed3d6a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 09:09:23.2124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prwRKu1CeWiF1+YcEri0AIKg7KW5bGoks6isnbkAFm28sHs9Mmk+vVcOZkYIcZfnySly75C4SMJRS6SgIjciYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4716
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023 at 03:03:15PM +0800, Xiaoyao Li wrote:
>On 5/16/2023 11:01 AM, Chao Gao wrote:
>> On Tue, May 16, 2023 at 10:22:22AM +0800, Xiaoyao Li wrote:
>> > > > I think we need to fix this bug at first.
>> > > 
>> > > I have no idea how to fix the "bug" without intercepting the MSR. The
>> > > performance penalty makes me think intercepting the MSR is not a viable
>> > > solution.
>> > 
>> > I thought correctness always takes higher priority over performance.
>> 
>> It is generally true. however, there are situations where we should make
>> trade-offs between correctness and other factors (like performance):
>> 
>> E.g., instructions without control bits, to be 100% compliant with CPU
>> spec, in theory, VMMs can trap/decode every instruction and inject #UD
>> if a guest tries to use some instructions it shouldn't.
>
>This is the virtualization hole. IMHO, they are different things.

what are the differences between?
1. Executing some unsupported instructions should cause #UD. But this is allowed
   in a KVM guest.
2. Setting some reserved bits in SPEC_CTRL MSR should cause #GP. But this is
   allowed in a KVM guest.

>
>Pass through MSR_IA32_SPEC_CTRL was introduced in commit d28b387fb74d
>("KVM/VMX: Allow direct access to MSR_IA32_SPEC_CTRL"). At that time there
>was only a few bits defined, and the changelog called out that
>
>  No attempt is made to handle STIBP here, intentionally. Filtering
>  STIBP may be added in a future patch, which may require trapping all
>  writes if we don't want to pass it through directly to the guest.
>
>Per my undesrstanding, it implied that we need to re-visit it when more bits
>added instead of following the pass-through design siliently.

I don't object to re-visiting the design. My point is that to prevent guests from
setting RRSBA_CTRL/BHI_CTRL when they are not advertised isn't a strong
justfication for intercepting the MSR. STIBP and other bits (except IBRS) have
the same problem. And the gain of fixing this is too small.

If passing through the SPEC_CTRL MSR to guests might cause security issues, I
would agree to intercept accesses to the MSR.
