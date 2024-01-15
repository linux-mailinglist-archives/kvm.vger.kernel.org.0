Return-Path: <kvm+bounces-6173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7534582D307
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 02:56:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D4A1B20D24
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 01:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155F617F6;
	Mon, 15 Jan 2024 01:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FqLbxoSS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8287815BB;
	Mon, 15 Jan 2024 01:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705283757; x=1736819757;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ysNGEkQ5iXgKHi/gw+1r6JErZvnXEL2+lGHfvAE8RSs=;
  b=FqLbxoSSXDvmqQNj2RwWgXJhH4upLsZcD+np0ukkZ7dy7iOgTjscb5Bs
   2wTRyAvkgaR4iHSNfGW8OkP28ah/vHmb5OIuimT8KPZpGB9bvWa8fTatc
   kZndKhAwZKh6Miyia9gdIIB2HtSxPb14ijQUXuZdS3sKAY697SnBGAHJ9
   IZLqiZTzhhCTjOSKENjB5MoXwXc/g205W0TVdkI20m/S96sLIc5hCdRCi
   HW+AS/Kem+3YAvYRt/EyMDwdV3gUOdDj2nubH3GgMjsxvhgE1uL4/cyUk
   v6vwRh74w62Z4zo9uz2OonTDNFHhQjPs4hI3UkeVrG3tgW9y9y2PtRK7F
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="20991614"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="20991614"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 17:55:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="817668073"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="817668073"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2024 17:55:56 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 14 Jan 2024 17:55:56 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 14 Jan 2024 17:55:55 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 14 Jan 2024 17:55:55 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 14 Jan 2024 17:55:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ja9Ub3qiQnUHCpOylay9dvmMTJGe5Ci5kwnrEkVbx2HK5ThYWYJfcE0u2SWCXjCLuNu14XuwFbcyzEMcp+9g5AW6DV7tL5e9y8iQXLclWUGDFjvgRH91Hta4WBhPQKBMJWQ1YPvCaUGsrSoA/KQhmbeGzlFClbloM24W6G8oj5RbTbAxaAR/EFydG9TIvIlsmlLpMMaAJrulEpHV3rBnqDaIwS/adDPRNUjMKc3WCNdFPWhhtFrdWkqXINKHOaPcMmhQXQoNIDPWrIhPxgqSBGh83W/Qxod5AX6cZp8tqL0M8IZeT1BZRM2hYmDtbyjNG6sm9yZmZFueUn8ptgkx3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJQwkvgk+5I68IxZkq1fFrkp7TfdfHIBQsb5kKjoiMo=;
 b=oNQomo8w3f8T7F2t5io0qjlfzfusmYCRuS+QCwoFAlmZU/CGnYfjnJpeSnSTqtoaNye10puB0remg9NecGVeUl+VAtyNVO50gJrxO15YgUwa7uKaFlqGPhxX84oeQXD+NVyyRxr+Yf2SB3REO6m/Y3/velDnLTEfemR7YKGxaruSkWrw7xXi76UBPPZl52CA1eI2L0LNv4110fwJtu07Q5bZwh7usIzOamgw+cj3XK+FO9Ip28HIQWplrRsutIBa8t8VVppXwYhBgDpLpyMcXzShHWiH09/TqGiFv+/Mh9INWXFBLppJDxQiHYsz2/AEefja3rb8seG5Af5tZ3Nvng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 PH8PR11MB6855.namprd11.prod.outlook.com (2603:10b6:510:22c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.21; Mon, 15 Jan
 2024 01:55:53 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::c66e:b76c:59ae:2c5d]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::c66e:b76c:59ae:2c5d%7]) with mapi id 15.20.7159.020; Mon, 15 Jan 2024
 01:55:53 +0000
Date: Mon, 15 Jan 2024 09:55:43 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Message-ID: <ZaSQn7RCRTaBK1bc@chao-email>
References: <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
 <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
 <ZZdLG5W5u19PsnTo@google.com>
 <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
 <ZZdSSzCqvd-3sdBL@google.com>
 <8f070910-2b2e-425d-995e-dfa03a7695de@intel.com>
 <ZZgsipXoXTKyvCZT@google.com>
 <06fdd362-cb7f-47df-9d1a-9b85d2ed05b5@intel.com>
 <ZZ1h9GW93ckc3FlE@google.com>
 <cf043809-430a-4072-b0fd-201cd469b602@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf043809-430a-4072-b0fd-201cd469b602@intel.com>
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|PH8PR11MB6855:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a8f98ac-a8b6-4240-0278-08dc156d1b12
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yYgCCBLxHJmiZ1LFCwqmC7MAWJBsHMyicVzZ1NIKUxINVqPaMvyUxaXNyPKClRi6QdomnhaAOkJbKnQmD0D9m4Vu0PBlqijF8XvlnLeSw+1jacZx90iGRMd/5Hqd+tAn9ZtOKabf9knLCb7azCx2iawRr9u2wdCF4sXIC7ne64Y8snRyZxjx5S2J2VAv+deuICPwIQWHlGnb7RXejAWfGt2KUVPmVoQx+D69ptZqKYnXCcWc5687+opLogK27FBVQzdmX27v0VX/bEXNv1L4gsGORVO+ucc/vKlDvLzqSol33/R+/bSm6Yokk8kdbR/24OPx8QrS8Z+R4m1p9pYSz3284J4tXsspCqPYHGJZ7QYDqXrIWOyoQHvKReiZuS6QFpCTzrKMx29A6PY1BlqqXwJUSnYhXQaTpVQ1wU1diew2dozKx9AEB6BWJIwxCZWPl9N33OgWhd4rVzuSg31ngN3EQ2GHceh8HKOV3gbm2ZvxcNm90X8y/O7hBDlqsBR0H7g86bzTCUVh4woTVNAEwdBtjrZW7LumqKxDWf+THbtqUsqSb+U0SqxvBpBoghMg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(396003)(136003)(376002)(39860400002)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(6512007)(82960400001)(38100700002)(33716001)(86362001)(6486002)(478600001)(6636002)(66946007)(54906003)(44832011)(6666004)(53546011)(9686003)(6506007)(316002)(66476007)(66556008)(5660300002)(2906002)(8936002)(6862004)(4326008)(8676002)(41300700001)(83380400001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?GpxsuWMU8L9UFbRmwTtvmxSaMx3PruJlPQhFZyKoJq/A699WLAtiyHJYxQ?=
 =?iso-8859-1?Q?3CTOC5h4+kvXu+q2OUBOe5jjaLTs4NNH2kN5qCIjhb/9LApzXJSl81n4HQ?=
 =?iso-8859-1?Q?8iiFKaTERq1FcnwLRptpmBfAqNNtISoZcNchaNkk54f6UBEicavypPilQT?=
 =?iso-8859-1?Q?/ZyfdjMwtHil+C9ZP0V/LMjHJWIMvJ2nQYGtvlc/zspdnlEVgVm9Pz78fv?=
 =?iso-8859-1?Q?crE1Xx+mcgfOfoj8iJROWzOMXJFrplpx9CqN1lQf7dqyN0y81U2Rl+Friy?=
 =?iso-8859-1?Q?0WYETOJOFwE+mR7pT2ljYnZVhpmGlGQEN6dSm19CkkKXxMaMqfBmlFeHel?=
 =?iso-8859-1?Q?WY7MtA/r48+1a8oYZl0HeNQtX9XK3c/EmFmkE4G/dziqGZMQI1LFVOB7hc?=
 =?iso-8859-1?Q?5XCfKAvvRzxmP7myGmdBL6WI/f8Z6cOoFAsD6jbAMdN0ZWkqHyN74QCC48?=
 =?iso-8859-1?Q?ztOQCisTrQZ3IfFXDR9psvUSbD/iBGeE7m39Lzlz+QsJqJCmrVqTd+gT+j?=
 =?iso-8859-1?Q?0O6bOipUkueVN5/Z0pfL5P+GTMg3knjRbzh4+N9yqHHgaL90h1H3ntdaiS?=
 =?iso-8859-1?Q?DCRHGxKM07sp+q+PTOJC5eQU7QZ7y6ppXKsiQNyD0ilEbIwxcdBuTliajo?=
 =?iso-8859-1?Q?lf/Hpy5RTqNWjyPnWKH91Ckn61v9BhpDEBbf4kGgp0MLLe0sqcsEIk555y?=
 =?iso-8859-1?Q?N0HNJbV1KnThNg2TgiInf8EBN/tLywrzVa1n4YOshArli/qhAL3oPYHIpn?=
 =?iso-8859-1?Q?D69GFJWnd2wXcpJjUVF8WxqzTuJIwYykNDw4fEhESLC0cv8+TskxRKQhfq?=
 =?iso-8859-1?Q?0PV4ic6Z7yWug7m5YTWuSnZISglDJUWjvMwofKWzh2iF+qwzX3+RQJCTjO?=
 =?iso-8859-1?Q?rkGTjY87T9tizR9e72AUD9QmVd43XawYh1tXI1RARcDhmxcl3gK6LaC85t?=
 =?iso-8859-1?Q?qCoe9tdeGTmloCyYND5Zo0JlEhczE4JVvmULbaSRaY1J+ru5F/inQo5z1F?=
 =?iso-8859-1?Q?RjsEgm4g7fk2KZ7Qzt1Bej9UBHR6tTPc6RnOZ7hR+mPLxlynCjgaKKf5oG?=
 =?iso-8859-1?Q?XXSWWsmc9BiUPrclAIec2+5y/mNN/+ZjVskbj/XU5pF9YCy+rwjHUt1WC8?=
 =?iso-8859-1?Q?zpxlEr1A+OhkXKWJV0d8CvCDNqMCuxbT5dek3YpG5aEERzAhP+5ECFvZ5J?=
 =?iso-8859-1?Q?TR8VTAUQsRq1VRFg+ut7euDbt0QXRZ+86KIHKs9zwWctUbF8U3exUD1hti?=
 =?iso-8859-1?Q?ohVaNKYaGVzvKoWeKnAKbRHouW0TD1Bw6LcFyRUtb+tlqIxAQPs4xuoV2K?=
 =?iso-8859-1?Q?aMnqyOkkckFuI6TQwwdbMVGP2Bwi7nLO4lmL1CHU9DDI1Wo0mZcje31tUP?=
 =?iso-8859-1?Q?0EJk87HlV2/AF+6VZ3tWrn8XAaDYryyXJMoRxadRIL/zlFuBbf1l4g/tB1?=
 =?iso-8859-1?Q?78VlsvbL0ksQxKK9djUl9VOjfHq1YqBsxozcTVo+ykrlpf+KpF82GtS17q?=
 =?iso-8859-1?Q?1RBxYfmdfRjI0j8NiJzkwYf0yMlp9U1SToddGseBvBnPJPKbRHC0sd4Vaa?=
 =?iso-8859-1?Q?Jbc17Ewlequ6Uu5afh8atPLLKpY9xjwErk1XRd9nZaKT71un/q+W4CUzK1?=
 =?iso-8859-1?Q?9gmgHc48QSJD1wM+g8ahjIbDtWDWHLYwfV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a8f98ac-a8b6-4240-0278-08dc156d1b12
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2024 01:55:53.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bGRMPd/4rwzVaS1JuWalLKC2cTjWTioKdNOt8L83wYSKGYczRkvzzwkMAkCOREilN7hhRqnnhTe7ezu/qgKZQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6855
X-OriginatorOrg: intel.com

On Thu, Jan 11, 2024 at 10:56:55PM +0800, Yang, Weijiang wrote:
>On 1/9/2024 11:10 PM, Sean Christopherson wrote:
>> On Mon, Jan 08, 2024, Weijiang Yang wrote:
>> > On 1/6/2024 12:21 AM, Sean Christopherson wrote:
>> > > On Fri, Jan 05, 2024, Weijiang Yang wrote:
>> > > > On 1/5/2024 8:54 AM, Sean Christopherson wrote:
>> > > > > On Fri, Jan 05, 2024, Rick P Edgecombe wrote:
>> > > > > > > For CALL/RET (and presumably any branch instructions with IBT?) other
>> > > > > > > instructions that are directly affected by CET, the simplest thing would
>> > > > > > > probably be to disable those in KVM's emulator if shadow stacks and/or IBT
>> > > > > > > are enabled, and let KVM's failure paths take it from there.
>> > > > > > Right, that is what I was wondering might be the normal solution for
>> > > > > > situations like this.
>> > > > > If KVM can't emulate something, it either retries the instruction (with some
>> > > > > decent logic to guard against infinite retries) or punts to userspace.
>> > > > What kind of error is proper if KVM has to punt to userspace?
>> > > KVM_INTERNAL_ERROR_EMULATION.  See prepare_emulation_failure_exit().
>> > > 
>> > > > Or just inject #UD into guest on detecting this case?
>> > > No, do not inject #UD or do anything else that deviates from architecturally
>> > > defined behavior.
>> > Thanks!
>> > But based on current KVM implementation and patch 24, seems that if CET is exposed
>> > to guest, the emulation code or shadow paging mode couldn't be activated at the same time:
>> No, requiring unrestricted guest only disables the paths where KVM *delibeately*
>> emulates the entire guest code stream.  In no way, shape, or form does it prevent
>> KVM from attempting to emulate arbitrary instructions.
>
>Yes, also need to prevent sporadic emulation, how about adding below patch in emulator?
>
>
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>index e223043ef5b2..e817d8560ceb 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -178,6 +178,7 @@
> #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
> #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
> #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
>+#define IsProtected ((u64)1 << 57)  /* Instruction is protected by CET. */
>
> #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>
>@@ -4098,9 +4099,9 @@ static const struct opcode group4[] = {
> static const struct opcode group5[] = {
>        F(DstMem | SrcNone | Lock,              em_inc),
>        F(DstMem | SrcNone | Lock,              em_dec),
>-       I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
>-       I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
>-       I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
>+       I(SrcMem | NearBranch | IsBranch | IsProtected, em_call_near_abs),
>+       I(SrcMemFAddr | ImplicitOps | IsBranch | IsProtected, em_call_far),
>+       I(SrcMem | NearBranch | IsBranch | IsProtected, em_jmp_abs),
>        I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
>        I(SrcMem | Stack | TwoMemOp,            em_push), D(Undefined),
> };
>@@ -4362,11 +4363,11 @@ static const struct opcode opcode_table[256] = {
>        /* 0xC8 - 0xCF */
>        I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
>        I(Stack | IsBranch, em_leave),
>-       I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
>-       I(ImplicitOps | IsBranch, em_ret_far),
>-       D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
>+       I(ImplicitOps | SrcImmU16 | IsBranch | IsProtected, em_ret_far_imm),
>+       I(ImplicitOps | IsBranch | IsProtected, em_ret_far),
>+       D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch | IsProtected, intn),
>        D(ImplicitOps | No64 | IsBranch),
>-       II(ImplicitOps | IsBranch, em_iret, iret),
>+       II(ImplicitOps | IsBranch | IsProtected, em_iret, iret),
>        /* 0xD0 - 0xD7 */
>        G(Src2One | ByteOp, group2), G(Src2One, group2),
>        G(Src2CL | ByteOp, group2), G(Src2CL, group2),
>@@ -4382,7 +4383,7 @@ static const struct opcode opcode_table[256] = {
>        I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
>        I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
>        /* 0xE8 - 0xEF */
>-       I(SrcImm | NearBranch | IsBranch, em_call),
>+       I(SrcImm | NearBranch | IsBranch | IsProtected, em_call),
>        D(SrcImm | ImplicitOps | NearBranch | IsBranch),
>        I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
>        D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
>@@ -4401,7 +4402,7 @@ static const struct opcode opcode_table[256] = {
> static const struct opcode twobyte_table[256] = {
>        /* 0x00 - 0x0F */
>        G(0, group6), GD(0, &group7), N, N,
>-       N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
>+       N, I(ImplicitOps | EmulateOnUD | IsBranch | IsProtected, em_syscall),
>        II(ImplicitOps | Priv, em_clts, clts), N,
>        DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
>        N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
>@@ -4432,8 +4433,8 @@ static const struct opcode twobyte_table[256] = {
>        IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
>        II(ImplicitOps | Priv, em_rdmsr, rdmsr),
>        IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
>-       I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
>-       I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
>+       I(ImplicitOps | EmulateOnUD | IsBranch | IsProtected, em_sysenter),
>+       I(ImplicitOps | Priv | EmulateOnUD | IsBranch | IsProtected, em_sysexit),
>        N, N,
>        N, N, N, N, N, N, N, N,
>        /* 0x40 - 0x4F */
>@@ -4971,6 +4972,12 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>        if (ctxt->d == 0)
>                return EMULATION_FAILED;
>+       if ((opcode.flags & IsProtected) &&
>+           (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET)) {

CR4.CET doesn't necessarily mean IBT or shadow stack is enabled. why not check
CPL and IA32_S/U_CET?

>+               WARN_ONCE(1, "CET is active, emulation aborted.\n");

remove this WARN_ONCE(). Guest can trigger this at will and overflow host dmesg.

if you really want to tell usespace the emulation_failure is due to CET, maybe
you can add a new flag like KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES.
for now, I won't bother to add this because probably userspace just terminates
the VM on any instruction failure (i.e., won't try to figure out the reason of
the instruction failure and fix it).

