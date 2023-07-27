Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892AD76445A
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 05:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjG0Dai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 23:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjG0Dac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 23:30:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535AB1FFC;
        Wed, 26 Jul 2023 20:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690428631; x=1721964631;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aS5JFDZ484Trv45+QjYXdPheE2ZEkViaYvPrFSXk9DU=;
  b=LcdZVpq3wcVzRqXE7LVFq/mnFqTmP1g01QXURks7H2DKAWbcnisw05BL
   aozaPjHIYwyS99rLM+0sAjFmsrcrDqGO9usLJv90eYgvLZmLfiJViba+Y
   R+GNlsb9nJgU2Tx2LC6vQvS39lwJof1GJWXIgYn1ByVKWvEP/in45kEp2
   8GjWdeb5jiMRlrXMC6mBUTccyoO8mi3ArehdzXeoiPJWt5OnxC3WJq3jw
   EzC7IvAaR9oZT/SwzTGxw7KChFCqzoMukQiCE53uPGkzTiqEhHhslGOiT
   7JHLyOU14GjDuy5nsb2QpiW/gbf5nQlTaD91JvZ+5btatndsCO6BpqTzD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="434467853"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="434467853"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 20:27:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="792150525"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="792150525"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jul 2023 20:27:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 20:27:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 20:27:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 20:27:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 20:27:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FY1BeXLaJagWW+lU4tlAI66JQwNbdZNnKo0ZQnLWy//m4FrtfNop+FerC2GkPldpv5Pg80tJvuQGosXSxPCQXq+8lgX2V1HERk4LXSmOOttzgA3D9fqw2McITPNk78eIYIe7p/thQnQWbTiSf3vwFWxGkdzrV5SuT56ke9TWsW5WTqqv/rHILTGvJxacX6riHUtyB5lL7WMB6VgWyx7ziV3dNXr9/jzG+qY5Gd/8DKKja3YT9GdfGAwIuNccRAOHUAtPvm51vpSOJpfqmX5zslMBK68U3Q1oyCDpnyFPrJYDQAR4xBDSONXpZLKaBhFZ+Lfm+Y7RRV6jC31jJM5zFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0drNgtlwEcqaGYSsSs7RW3i/Un5bIKETUAPlBZuvOWk=;
 b=AQkdNgm70W2jsJrGCLXF3D14iANiBv/5e2ae1In44TDIpbERZBq0agVKQcPmN6WZREHEt40d1Xd1IeVW54j5q4JnjuDqCG1TI7xLSvW7XYeyIxq5uWcwibsWPJY06DXB1/K9wW46M9/krQG4wH7DjwVKnIV3mm9HHNxMGT+pUcul3ite13GF1e+pbIJ55pK+CJRiAhkxJ9DcbE5MtfQ3qOUk2OogIVxhjPgnA3qvsxdQmWwIjsFcoFDbC/sJAB7H5tm927IOKXXO9fu+z2JXqlTzF1A8WUaSctsZkAQnUQVMkTFdOpCyz8R9DxkDXzWzYWJELhvZJkbHbty8eHdgkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6781.namprd11.prod.outlook.com (2603:10b6:806:25d::12)
 by BN9PR11MB5545.namprd11.prod.outlook.com (2603:10b6:408:102::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 03:27:28 +0000
Received: from SA1PR11MB6781.namprd11.prod.outlook.com
 ([fe80::a0cc:e384:90cf:3f95]) by SA1PR11MB6781.namprd11.prod.outlook.com
 ([fe80::a0cc:e384:90cf:3f95%7]) with mapi id 15.20.6609.032; Thu, 27 Jul 2023
 03:27:28 +0000
Date:   Thu, 27 Jul 2023 11:27:16 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 16/20] KVM:x86: Optimize CET supervisor SSP save/reload
Message-ID: <ZMHkFOwsNaAm3WWu@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-17-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-17-weijiang.yang@intel.com>
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To SA1PR11MB6781.namprd11.prod.outlook.com
 (2603:10b6:806:25d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6781:EE_|BN9PR11MB5545:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cfbf04c-2e25-4532-85b8-08db8e51672c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l33/xWQdECCMEePuKVfWljcrVEtaSRStfLTlizKO8IDyhoSUH+ZKkaqlmBuJzhRBTXr87w31afzRAhsQ8tjIXb/58C/Mg0UDHwPZ0iBQA+lvXUZfrpMoCzc56xfKPv5Sboh2We/LcQolD7xkArFjUlxut3vuD5tRI3/+NPrGtW6ITkelbgeodis3oGxgMhIuhwvgZjGwY608Iy+Jqc/EdHfiiHWU6FdRF5U3jCJMjB4T7qlzlOBVNM1Z9Qz0pMzApB4K9kLJrILU7+O3r8VTLRJNnD7rVRuFPEBmbJgJHhqEdRyhLNVv6IaNPTu7Uchpsx70sQf27jFsOhEHxMtvBGHTyy9HuFMrna1owhn4gm5XCXIUvPXYM5XhfzC2DG+bXIg8csBqOdadGjL9c0uFDcos6EPvEfV03qo5HygnwDc0nRoKOczD0cMWL9CAickigJrGdVKC7NZxYGds7OSn/8gCZ/1Wr1ahS0gGGaIWTas4YmejxYcTY16XoPRdz9SIzF/qUxmRPtOiajdFRirEUpEtQfN7UCL+4FnzTE0FFkpNS27KzxQRyVTOU5UAiqlw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6781.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199021)(478600001)(9686003)(6512007)(6486002)(6666004)(66476007)(186003)(26005)(6506007)(2906002)(6862004)(33716001)(66556008)(66946007)(6636002)(4326008)(316002)(8936002)(5660300002)(8676002)(41300700001)(44832011)(82960400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SxTAAUbsFsuQM1QSXCN9SSNhQbharN0SiQTD5siEuQdCXBpWm9pFZVNlTgjB?=
 =?us-ascii?Q?94bJP2j7E5AjfwXBSH7VFTMKkPs75+cjF23Iwm3MUBozQqhsxKO/fjJzAHlN?=
 =?us-ascii?Q?wGCIJO5q0mHP3ReeNkYMWU8dE27a3HQZIsRBrPq9wDKO2IX+iksKosZMmaL9?=
 =?us-ascii?Q?LmClYgw78xDicPzXdwoOD1MuwDmo28fbbxRDmRA8HAvVWJe2kdd1o32U1ZfQ?=
 =?us-ascii?Q?eJjb/v5nrwRpg95uIR7dpQUdafYEVWFR1hDTIRpBMKqbgyqFFL3cLB+G+lSs?=
 =?us-ascii?Q?BbMVQaojJeoO9DqHcxSwK0yEx/i8zF67LEMESYA1p4tQmQaKTA6lXcberAXw?=
 =?us-ascii?Q?2IZvi0FzpS6sPqqJkm4Tt22qNBIE1/bmnuPAbWGp6mQOPZhOZvM9ypZui8go?=
 =?us-ascii?Q?HjAqjatz9+l0O5YkMEPZkLYN28F4i53qH5fJ5YQNPM0Kh8YDLSEaSC2kaqJ7?=
 =?us-ascii?Q?YP5viceQ6lNThbBRqKuHmtRD3fdhnbk/9Ngdd970Tl7lPnqg88cX7T+cQIw5?=
 =?us-ascii?Q?7z2t3OIU8z3ISbqhGBhXSIKxYL7+yzVwi4vpp9ik/0E1A1orjOL/uS7XIEIt?=
 =?us-ascii?Q?bLDV/dwpS2NPdfmW4nTooAvfy0jxwxoFToiU2daXksE8lCELzZPkAMUCHOKj?=
 =?us-ascii?Q?sXUoXjuA+zuquhrSG9qSSLC34tEY7fYVi3Nn4mgZNzvLCArwxKzj62icJL+4?=
 =?us-ascii?Q?c4m1McLeQtqCfU+8R5ORjyBXE6LMpOOPy0X1vEqvM4pmmGRiOXAP8ylFEGKj?=
 =?us-ascii?Q?Y6PpQlZe9nCGZY7X8HiFs6awjTQ9rsMUuz2FWtT2MXrs4yjS9oe4QjnZzfwr?=
 =?us-ascii?Q?8rPFV71VxO0lY9sB/5v7bFTnjBDpIZvpjPFjWX0lWk4vUBKZnmMqM0XKt5dT?=
 =?us-ascii?Q?eGB3sFYLjcqEdRlpV5HmMN0M39q2mmh6M9zdl6ESsdgtaty3GI3BgWmRB0nr?=
 =?us-ascii?Q?uF9xpv9A7qVGzFsoxeezQSPjDXOYvg6ksuA4Gix4YnNLeHVhW6/QGxY+4wmZ?=
 =?us-ascii?Q?oZtStOlPCP1l8d/YrKWL3uR0dfJxj7zqwY7EocTLLm/YhCoZ+Qw9q1C56yTd?=
 =?us-ascii?Q?Jft2xpXx4VvjNhpPFs/wbiAmnM8cD6yRRAy7dQ/aXI0ZYwRt4l3XbYB4N4Nw?=
 =?us-ascii?Q?gLdtdAb4RevbE1i/wxNnZ75nUv1mUBz4sEw/OY4XtiP7FbZNQCEU9LI5AFG7?=
 =?us-ascii?Q?Fs/PrE0v1s+ZueRrO+53fvUgmUP20YmE94qAiyItfK7o/Zka+UlTx10s4ZWi?=
 =?us-ascii?Q?v3RvTsAF/oFleRwurk4Fh+k9AQL8y9NuOBvQYWNDGjYakNGUq8GI5S+67u6C?=
 =?us-ascii?Q?0EOvlwAlMUZ/hEmMcJuNvMlWSzgzEfGodvPcamHqCtA4YNLfIwIjLWVmLhkG?=
 =?us-ascii?Q?xI8i771OxkLu3OB/7aA8wrGfGAr07PZ0r3ql03FFp9kGhicnpAlUV50fBw3r?=
 =?us-ascii?Q?EEwp96dCyWq4yM1bMBgUTNEoe5NknL63L+e83tlzt20cdDgwtTpXWqmQeI6s?=
 =?us-ascii?Q?d/VieDCX/srCh9X2/KXF3dQkF+46EZWre/q/DO7D72RKOZaEf5IEbtuJPs9X?=
 =?us-ascii?Q?CQkBn8tO3LwX5oYfUlYG2dYQX1Pn4D+KWgnTEJCO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cfbf04c-2e25-4532-85b8-08db8e51672c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6781.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 03:27:27.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrX95Rl9DZA6AsVsiji43ljtSoih3s1iooveUghKR27sqKxbdiAF62R8+peBX0QcATypyiA/1O+BCONk5djZHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5545
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 11:03:48PM -0400, Yang Weijiang wrote:
> /*
>  * Writes msr value into the appropriate "register".
>  * Returns 0 on success, non-0 otherwise.
>@@ -2427,7 +2439,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> #define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
> #define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>-		return kvm_set_msr_common(vcpu, msr_info);
>+		if (kvm_set_msr_common(vcpu, msr_info))
>+			return 1;
>+		/*
>+		 * Write to the base SSP MSRs should happen ahead of toggling
>+		 * of IA32_S_CET.SH_STK_EN bit.

Is this a requirement from SDM? And how is this related to the change below?

Note that PLx_SSP MSRs are linear addresses of shadow stacks for different CPLs.
I may think using the page at 0 (assuming 0 is the reset value of PLx SSP) is
allowed in architecture although probably no kernel will do so.

I don't understand why this comment is needed. I suggest dropping it.

>+		 */
>+		if (msr_index != MSR_IA32_PL3_SSP && data) {
>+			vmx_disable_write_intercept_sss_msr(vcpu);
>+			wrmsrl(msr_index, data);
>+		}
