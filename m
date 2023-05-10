Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93226FD86D
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 09:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbjEJHnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 03:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236146AbjEJHnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 03:43:17 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE522722;
        Wed, 10 May 2023 00:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683704592; x=1715240592;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VUqNaBEWStXRi+RIWS2SH/ddMMeUDYHuIaJKUkirhKo=;
  b=Vg2pNIYbiHv5eyiQaEZ5dLQqPn/wsVg+ZvDNt5pzVnqSY3wjke7ulAVY
   6vVS79l1FJn/59z8O9eeiPukcPHAkE0pcqKNSAJjvef5B2/Zg1SHRf8D5
   en95Rvt405+qvjbJo3/soIQWTWGkwiEp49TexYQBmlmyikyLBJvcXKViP
   bkcY+07kLrBHeXFjKWReL7rkIzvg82Ve6ga2t6tV6SzVTCH50sP+Lc0DX
   E1G8gXI7KjGsgcQZRg3olFmINGsamKZQib7TteNf4qmVPCp5bOnJTFYHV
   7etgADoQQn8MiB8cBRDwsN2tXhE87maYBABaazbiYeZBlIj28Dw7h00IC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="378247891"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="378247891"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 00:43:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="823447821"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="823447821"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 10 May 2023 00:43:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 00:43:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 00:43:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 00:43:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 00:43:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qcfyyjuzw99b/rrjf/3ShmBxvhJtKoE4Aj8tooV+8XeWM/nKgmooR+LVhuwnRUJzU0LTJtwc8l5gUwd4PXeU8ClKUqxTDGFCVGIqpl75EQ3GzI6i0RhA80d4+vNCmyLLLVBLjtj9ecFQolgOSMM9J/mQ9vh1ynilGDcQVlEq7axTcVzgRsN0lPdDtavTdaZC1o8LUzuvXTHUqJPggKBbUmBXJLEIPa7QA6sJvfbOc4btzpnzPzsaZrszNsOHD5w4gVUJV2ivl7RneK+poPg75K7U5FZj0/7FiqVQUYEDtZLy8oawKKCp9yot0CoeGAeJm9qDn8uZmOVfw28/2PPUGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uEXALF+IaCntzjzAhNREsiImcxcjF9Eh6Hem7+5R4no=;
 b=KgFNs/50LSXBcCr+Pt+wZmDuNbqNQHlEBXmPDXRNXtK1y9gLz86TyqgNLramOC6uJjMp4ganr4xkWt7ZmNdUMszf0NEv31X7sOnpRZXlthWA3tSZAcej8djku4xII5suTGKf511sL3EHDu2KxnVceyhL5gv+2XmsV+891ASqB5DeKKvTQrotSWLMr6f9c4dWaw4X014J0iycmXKfW5hjfMg1UGGia00lRT6lqqOXbWskMdEMOkRhzksplU3DwvRCzzWIeh6omLA49NElhsQjXrGGHuYLM4HGIyLI1b6o0qodyHMNJcBcruw82LfiRrhBkrcNUxIicBxEvszs4JhBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW3PR11MB4699.namprd11.prod.outlook.com (2603:10b6:303:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 07:43:03 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6363.031; Wed, 10 May 2023
 07:43:03 +0000
Date:   Wed, 10 May 2023 15:42:52 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <kai.huang@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v8 1/6] KVM: x86: Consolidate flags for __linearize()
Message-ID: <ZFtK/NS8rzCx9Mus@chao-email>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230510060611.12950-2-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0156.apcprd04.prod.outlook.com (2603:1096:4::18)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW3PR11MB4699:EE_
X-MS-Office365-Filtering-Correlation-Id: cb437109-990c-4a36-b6ca-08db512a2f36
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXds6fsHU3pfrFUjG5xnIqfcKeOi9yQjqrYzYBrDMevzpywxg3xAZ0DnpCme5zCWuqaQClKKLePW+bbUlqfxAGmnK2etacap5RR1NwQmo4prGn+vA7nVwgHULiMOPOVaU0wu5nsX5zrp+GZjYPktAyCg8I6Hc+VwIe80R0JmDiq2AaLGNTP66afjxpq5knk8nD2crM709AEZseG8g6MW8BR+XvOS9GejYcH4/sc4VEsN34eA5V9G4oNWmKLCSzPWACcBEoD8x7EXjHT3NmrTEyIZDeYUNPOwOMdm4gVcoWPWVsV3AWEa/biKv26AqLf2q7/+I7vrZyqxxmjVgZ4meWEObKCf4VbmxY3aUJ0BQKnEyjQds5qsGIh1bgfJc3DW8c40jgyMxkWt7IKujf1x3RQJQRpSSWU8cJolRqn6tguR5jcROor2kN6oV/aBdGUVOQ6itZ+b0PNxxcqt1/GivnpGuiU3YF0IvbiZkAOf4SkwZy0YxkeY/yakZ7sTQ3Ol9NOcxTyrqXah7eKYeb5OFBRoA0S/MiCzvru+Xj99IVO1gaw/xFdfUjfOOvfIhU/k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199021)(2906002)(86362001)(83380400001)(186003)(6916009)(4326008)(66946007)(66556008)(66476007)(6506007)(6512007)(9686003)(26005)(41300700001)(38100700002)(5660300002)(6486002)(44832011)(6666004)(33716001)(316002)(82960400001)(8936002)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o5Vx0PbtERwLISNwGhm0VQJvGBi4OnSR9eZF776p7xuqM8Y7cMJXWyKMp7YT?=
 =?us-ascii?Q?4z+zxQ++z+wQFnfUAqgqJ8j8qPdf95W6F3GbRCSSqk+TOwUGAr6kzgmjykOl?=
 =?us-ascii?Q?EpLC9y3xJvKOfOUuvUrq3ZKNW9HGjJsT3QdsyP9UfixtIGogKxRzRxT18sEv?=
 =?us-ascii?Q?MW+i7AhTLZvvfRC0SOsv08iOwSKWwHhzLQe5xhueN+MfVG+DyvJCGNypl9+b?=
 =?us-ascii?Q?6K1g2VMXsX+EUsT73QkKb8nv/Efx4URNcj62+Acv/+YoyGA0lRzZ4b6dkCHt?=
 =?us-ascii?Q?gFOzWThDHOBUxat6e/qk87HZOkLrmZReRjHEMGR3c552XbTwqyGtig4DLEsi?=
 =?us-ascii?Q?9CVDEJ2aqsqiTLikBfrcSAysCGlHdQ5mRnguIQ7rm0/JRHq2CvOvPkW3fdf2?=
 =?us-ascii?Q?aAolIUC8yhNq/Xo9/jUPnFeNIx+vEXHHkXdEBNcTk+8wQGp+XHCsveSZMu9L?=
 =?us-ascii?Q?8jrmvCUqTXilSSHKCxnlTouCyGaAd5R7kWljoJXEA7QmXTk49C/czeCjmKge?=
 =?us-ascii?Q?hdcDQO84jLQVJNQvjkCsl3XHT7EA6M9muU8uVNGhO/QPtecM8Gh+PSqHLbRD?=
 =?us-ascii?Q?JfEwt2joXkM302pvdAMSOZCZGkwmEYoDt96ThvlWuur0JUYUJRso13se6H5j?=
 =?us-ascii?Q?Kci+OVwoeMgIDgOzx5ZS+6kAkDfv5ft2VpQsw0g39dk6eg2HfLNgM7IFg3yV?=
 =?us-ascii?Q?yRGdzRlKURZoW6YdHjchlXt4USct+J/+JaETaDlsV3PHm5bnFyN1yxqHqEOh?=
 =?us-ascii?Q?R+gZw940mP170WU267aI8wAb/XZr6eBynz+StIWd74tSdDrzC1CoEMz9Jg+c?=
 =?us-ascii?Q?kP4NJyDANF97SEKXi7dA3GIYtmWVijckcu+Z8iGqfwXxlF6PsEvdIA6smvPX?=
 =?us-ascii?Q?WcJ3QXNaS2w/QvoWERKv/bVyC/7LXFZd9glrBPvJECsSQVDc51xntn5ncUKC?=
 =?us-ascii?Q?vk62enwTpqw6QmHoIauRzNzrcyzgj4iN4oYCLuwzJEsyxV5y/5rDgA0whhcx?=
 =?us-ascii?Q?bqCOBZu+Q7vyCRagErp7Q1j0Pt4hDBJzIDq5wkl21eRvWbZX/iIR96FRfgWX?=
 =?us-ascii?Q?efN58KhnXavJoYpv2LWel1Ct31sSk97GRERLjQh8TONKHjFkoT7mpSHhLiJ9?=
 =?us-ascii?Q?uJyYKusVpA51CaozcXkMfKH+6/xWt36ATSvkn1aS9yzbNREqJ1VCqiQrdaMh?=
 =?us-ascii?Q?ilUqCO3xgT0gF7S5hSJoglhBtIjpzUYw+1xGv6esvaJj09SeDKEWPwdaXYfi?=
 =?us-ascii?Q?Ajpc7GxXDuyY8W6sSG1/zQxZzpGxjkEG44X0UujL5AujQZ30BKvPkTCcbo3p?=
 =?us-ascii?Q?pp8MQX0eoSAmRNHYitlvo17XVcMje5kkIEC1o+pZ4dATS/UvdxrBCM9HnBRN?=
 =?us-ascii?Q?WCX3rbnor8r1GFemTK791frcMBlHV+Y7wpjlCdDqcWDWyIQsuQ6mYumZqBJm?=
 =?us-ascii?Q?xWgklKE89I5UDRdQ9SonTRlEhToFmtYT141viZ8Rk1ONvC7B+sDSMJHQk+4S?=
 =?us-ascii?Q?6ktx4PG8S4396aJIZ8R9J0GoNpeZy5TUkLcCW4aQz+cfoZbIfU7iGrs1VBYQ?=
 =?us-ascii?Q?CWy+1sycx54KlBujhL82VMcVvVhbSdJbWudd97rz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb437109-990c-4a36-b6ca-08db512a2f36
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 07:43:03.1684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgp9bWWT99SRvg1a0VEgnlipS7cSOyZZiXIkK4p7nYysD8Jk8QKhzyRtiwEzHvT3fndY5Orcj2H4XCjhQcBepQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4699
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023 at 02:06:06PM +0800, Binbin Wu wrote:
>Define a 32-bit parameter and consolidate the two bools into it.
>
>__linearize() has two bool parameters write and fetch. And new flag
>will be needed to support new feature (e.g. LAM needs a flag to skip
>address untag under some conditions).
>
>No functional change intended.
>
>In the follow-up patches, the new parameter will be extended for LAM.
>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

one nit below

>---
> arch/x86/kvm/emulate.c     | 19 +++++++++++++------
> arch/x86/kvm/kvm_emulate.h |  4 ++++
> 2 files changed, 17 insertions(+), 6 deletions(-)
>
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>index 936a397a08cd..9508836e8a35 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -687,8 +687,8 @@ static unsigned insn_alignment(struct x86_emulate_ctxt *ctxt, unsigned size)
> static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
> 				       struct segmented_address addr,
> 				       unsigned *max_size, unsigned size,
>-				       bool write, bool fetch,
>-				       enum x86emul_mode mode, ulong *linear)
>+				       u32 flags, enum x86emul_mode mode,
>+				       ulong *linear)
> {
> 	struct desc_struct desc;
> 	bool usable;
>@@ -696,6 +696,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
> 	u32 lim;
> 	u16 sel;
> 	u8  va_bits;
>+	bool fetch = !!(flags & X86EMUL_F_FETCH);
>+	bool write = !!(flags & X86EMUL_F_WRITE);
> 
> 	la = seg_base(ctxt, addr.seg) + addr.ea;
> 	*max_size = 0;
>@@ -757,7 +759,11 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
> 		     ulong *linear)
> {
> 	unsigned max_size;
>-	return __linearize(ctxt, addr, &max_size, size, write, false,
>+	u32 flags = 0;
>+
>+	if (write)
>+		flags |= X86EMUL_F_WRITE;

this can be more dense:

	u32 flags = write ? X86EMUL_F_WRITE : 0;
