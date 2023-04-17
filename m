Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5AF6E40C7
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 09:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjDQHZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 03:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjDQHZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 03:25:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68926E4E
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 00:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681716311; x=1713252311;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Yrx/FAPM2hs0ftDHLuFMW51lGMTYO/+EakinGpRRI8g=;
  b=AawMcj/aUeE2gQN9eeaYypFUMcoLiYFH6Q2FQ0gwN8747scjgDNlpk/v
   c62bLUJOu2fOWmV2vs6bsat2UMvmWW4KWvOBby+ctobmrPezb82p4kbtZ
   jNFJN+s6cx9SfAFuG1bzQcCCyAyzOAuYxEi6vBxPD03xPNuCAySK3dlof
   zW6n8XXUVdJMLWn0OrilFGFLey7zeZvRYw1xj9dJCiNLiyejzR2HJhsgr
   3eok1ZVulteOrbMMtIZs+JvYDfRecvK/iPLkvzS36YkVjA6g7RdFnhhxf
   2TJ1/jkbq1+2ILOf06P6YKr2rrGYCNq7vLPyVn0G0ENbZC4vidX7gI38m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="347565373"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="347565373"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 00:25:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="936743982"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="936743982"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 17 Apr 2023 00:24:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 00:24:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 00:24:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 00:24:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 00:24:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUz11BX91rxv+5z+OhCJ71F/8H5lhYnfi3W9/doT4M1PLp0b3t/AoU+jYnjxFMPppnLKb59U3hJFTq0vmbNVgStWfdVrtUlwAL+VbI3i9buBwjABdQwQYgnSmPkFL2Ck6KqaMkvRtDAtMHrfnT6OErT4V6RhbawK1H7145SafLTlrQR60BInmYo/MWyLblf9x18kIh1+CZu+JIF+gwSbxdEqBIYUhJZ6JACF1tVDfovNBrk2ihOwgY6zY+6MG2t00JGH0tSpF+omm+KFDtSHa/6UwMVqjOiYe1Gg5JWu7V1nKqWolEfJGgeYIYPfGw8vwJpShOExHvpYj2KFZmvBtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8eIwNA8lKn481GtAShFShBfv2ueaXGZwjG2OxcVmOU=;
 b=Z9Z4dpdOcp6SD1Wsz6IBNbPyAcxngR53pAOqMjfEY8oPJOroRWoWhzEcIaVZZ7h61iz6bdoaPZ3goK1K2AuSIehGLVv13Hly33EZBXGSQNBnZ6ZuB3oCe+Y1+0FgYYug9qHsj4PXnN3pMMHwpsKIryhfinlk8QQv57hYexvECa4uE39r5Bg4kURPAamQMUD7yy6DG8Ddy0S1wS3pgLr7hwYPGWHOw2P6cZpt0/Vwj4Avw6rpCD5aIMfHSqc2rugxM7Y8e7PyQi6IoX/ulDR07+ysFb7qejb8hJWRMBRHA4dkcQ/nnA4oPR87wyv3lz/UVdZUigbqV6honJZuVu+DUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH3PR11MB7914.namprd11.prod.outlook.com (2603:10b6:610:12c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 07:24:51 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 07:24:51 +0000
Date:   Mon, 17 Apr 2023 15:24:39 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <kai.huang@intel.com>, <xuelian.guo@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Message-ID: <ZDz0N4yBomWLnz3N@chao-env>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230404130923.27749-3-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0166.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::22) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH3PR11MB7914:EE_
X-MS-Office365-Filtering-Correlation-Id: 214ce85a-d69a-4fa6-2638-08db3f14d50a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CSeu5LjCmt6rk3K5cadD41isV2kqzWenYwqQ6TbrdIJ2EDxxh3/BRZoJ4J7utvq4sqNQa8kKlf8NhbNabJrDP1zAcrU/cGTgS3LfAiGjB+ypOGOI7uewjQZlcywCmtEkGY7ltylrAgDOZTKg0opj+MFsdIaj1pq5QcuqLD5M2MEl2BVzLqWWHHasTtO+CJ5FH3XHgTLHPDbZpAYkZbgHdWFLLQRPhRBsDRxJ1lKLoeHdKUIfIbW8iyMUbyM0P2OagZDTLlgJjb7y7vF95O5+pAs2EgqEYW/zi5TFYy+EBJ3F8pWNVgVCsmWNh8daZPE1q83J/xsRv14CuThYozxklMScCZrUaKyZJF5pFhr3vpkRo2IS36vqrOwFAyJ+c00g6eQBSEsu+0DRBfPh+/SijfGLsK+8bUh4avycp1t85uVVHrtV8PC5lKsizDb/5F+c0rqByP3yfBOgHkDarcLZwly08ugkwHjt8Ho69WI7YrEIujxKYjgme2hDvNSFWxEnF60NKRRUv0dtGchxEOF3fYTSy/jNF7ppAkcqqSkU16UcWI23sFRrygWTSUGhemqu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199021)(316002)(4326008)(38100700002)(6916009)(82960400001)(66556008)(33716001)(66946007)(66476007)(5660300002)(44832011)(6666004)(86362001)(6486002)(41300700001)(9686003)(6506007)(6512007)(26005)(186003)(2906002)(4744005)(8676002)(8936002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GpVQkTjJU0G+tlO2hyQAkcHdIpKtJT+3vu5gpjCzxbnvTWKzryVnzMVLtb7g?=
 =?us-ascii?Q?AURp53IQIY6Plv/ci8YkC2PTWc/uKlVp+RRbwgqDyNM+GZfHn+yFSOA7VbP/?=
 =?us-ascii?Q?dIANA/V5cdk3V2BFdYvhg/t9aAVSBSHCVrS4ZroVgpCD4QteTI3nZBjH04ov?=
 =?us-ascii?Q?EnKWzX6rxb4a1PaTYMuIjfQJ9oORqQUW2QXlEwCuQWCQRgf4I85o3Ekk/ApX?=
 =?us-ascii?Q?a8G+dEMfwwFTnLNkXpoPapv/4hA9sr21sCyOLh1R+7AZhmxtfq7YWmKa6Nrn?=
 =?us-ascii?Q?tlMZbPjiBLTwmbZldz1yU9ERAHtcYFbYAXkgydlyl2uzOaIFg0tK0b/XO7dV?=
 =?us-ascii?Q?sGlDkHPI5rr5ADH6W4BPcbBileXf+kWUVpQNfsr0xuvjnwlj854TGZO63fTM?=
 =?us-ascii?Q?MRv//XZaWO4hN8LvEUvicXY9PM4hCdrbawRePm8IEBX6DWOPz5Be9DeBX3jX?=
 =?us-ascii?Q?oU+utLBXDTXLpODv5q/Kk9Bdwe9IJqoSniNswPqEmJhEOkkHDTJc6nCrUyar?=
 =?us-ascii?Q?YJI1G+6OswuNgUejEf8uwboLcYNa5ClxYVOq2kw8IHUBuYh4ARR3qLMveJwn?=
 =?us-ascii?Q?wXp/A39Vi0U/2qvaEDPVAPpolCZklM5ZqhllvzsPHlvZWWEIrtPIh2E0xS/u?=
 =?us-ascii?Q?nqRpwr6kHJ19Q45XaZmxi3gwWpgfrGDcrw/6joKWFWAuvMxkpM3qiweZMdkE?=
 =?us-ascii?Q?ceYi0Bb769PmlJMQgdQFMxhftePUMbGKT5BWU5fR2O/LFv74XN7owBtAomVy?=
 =?us-ascii?Q?X/+6JIpoAikC+c80jjwj1pI56n/v2zVHB0HWlZ6VO0xxixqx/s1vp20D1qUq?=
 =?us-ascii?Q?oO/oQ56jS7XuaS+ilgSsrHJtoYDlmwurUQdO1lkRL2wWmuEs9ZgPUXE/Jb8S?=
 =?us-ascii?Q?y3RKVzIM0IsxcQ93kOJVvaMzh84IxL18o1DjgImCy45NlS9uiiWGwWQV5446?=
 =?us-ascii?Q?CMATmCI5jLOsj/Ic09W9/eiCPr6YFphuX78TLTn8lB9911mA+suGTnfavTFm?=
 =?us-ascii?Q?PnUWSMQQb0CBmW74pDnD0VN8gtFcG2LTkwAOD5OND5kxp/rPIcKX8zpv1fBs?=
 =?us-ascii?Q?JtpKGf5IveYGRxPiT9vOGfyazRdgf90HLQIEwbBNV1CRNudYlHf7kFfJzM05?=
 =?us-ascii?Q?uu6QafkOLoAyFEmavjfF+pUqi0Sy4OGT2FTNsB54vmclHaEDqS4x7nB1+unH?=
 =?us-ascii?Q?w8XQAZRPMp7VkPOIppIk9logmrXZ7ECZ/BMMIwRDBo8imR6FX33ipZmzSLio?=
 =?us-ascii?Q?0maorcsTEBKAqFJcE75cVduM987G4N/w1OdeNfeCxFg2NskNSUH9/3lur9aQ?=
 =?us-ascii?Q?Y5w8zsn75IitGMt9n7VuI99sJs3C4oybM/R0QeC4p8bl2CasGGehSvZ5YKAp?=
 =?us-ascii?Q?Dxy3q22CFSUJ2WHwSV+G8ixy+CdUmARhcMDgXEVUluovPv7/2d3G+jBqY7Or?=
 =?us-ascii?Q?vSHwOVyzsytnSXSQTzC1jmcWq4GpWKjo1I70n/UGgz7Q3SrtGk8Z0Kl4XBBo?=
 =?us-ascii?Q?ssYZSh9EhKBxlNoVmfsG51HSiCOh3Yqg/sqX8ZlM3TFRmxEvfjfLMshpa9vH?=
 =?us-ascii?Q?k3JF+6Zvst+6Uf8Ph0BwzkbsTTj5tK2zN0CIFpmZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 214ce85a-d69a-4fa6-2638-08db3f14d50a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 07:24:51.2576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhnYuy6+ibI6QvrTcdnJJOj6MBtLhrw44Rcea0QK7NBVctdsX7bNdo7U3nl3opnt78mdWgo6gf/nnmKYMh7IPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7914
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 09:09:20PM +0800, Binbin Wu wrote:
> /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
>+#define __PT_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))

This is an open-coded GENMASK_ULL(). So, you'd better use GENMASK_ULL() here.

>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -1260,7 +1260,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
> 	 * the current vCPU mode is accurate.
> 	 */
>-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
>+	if (!kvm_vcpu_is_legal_cr3(vcpu, cr3))

I prefer to modify the call sites in SVM nested code to use the new
function. Although this change does not affect functionality, it
provides a clear distinction between CR3 checks and GPA checks.
