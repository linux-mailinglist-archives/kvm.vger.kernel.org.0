Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8A758DE4
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 08:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjGSGgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 02:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGSGgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 02:36:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A011FDF;
        Tue, 18 Jul 2023 23:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689748551; x=1721284551;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=OT4WTVvH9tf5/dlVvTiAr/1zEZ3n1sLnHsNy7hD8IkQ=;
  b=dEcaJet3VzVPSz0pePD4kym94PfWuoMOmw2kkW+Qu7QMWVsSArCMWVbV
   GWST+wS+Xqab9MJrSNAgyG9skoCuij7fmtFh2LyiKskr1kpmll1hBrQlL
   kGnjqZC8N8iLy8WMYYdVc1/KmuBiJYKaB4sZ3AtJxkhAIbUSdlRuLZDlU
   07OGZicGgrCBbDmQ4dBY2DPqFXRTeYrE1ozzzkR7wwXJisp2su24xi+IL
   zFgGluJviLfs7uGcLygSrGQhNZlR6vZeorSgfMkL+dNvQUvda6Pa0Gypr
   nYqo+uv8EowlCC4bokK3QHh5diWT+UXTlO7bUgF+vjqLaItzZQtdnrw3c
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="369031184"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="369031184"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 23:35:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="814025207"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="814025207"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jul 2023 23:35:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 18 Jul 2023 23:35:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 18 Jul 2023 23:35:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 18 Jul 2023 23:35:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 18 Jul 2023 23:35:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKXtGXvpOUFXXCO7uy+xAmxdkzFBc68nibNoP2mQRO3bzfqQBBwJyYZq90mSNqk9gosnHvPHJ98CiaAK4cBZuFQdbY1vJtQi+Q2yMSKFTUscAJEkJAz6ZjEZYzsP7nib+1xxQWpPzZZikV1pSghXtc70MQ6nzidduzt0UONUhtDxOMmIL1iJT4SK5HuzDS2A4PHz/QCVvF6lzx++k8FsJ/ygQME/fKRlBQEYTljsOzCqZ+oidXaEszX0iqHG19wqByLaUit1iCREVVxt/MYff+XJ3sxCFIHi89gLw8JrNt4hzcp4C86eWkJRVAPzNIVA0QfeG9fRTQws+pZsb6tniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EzO6VSU5nSON2Ssfz6O7lb7gePKocrSMN9+YaPeXKk=;
 b=jEg0C9cwReE/Ozp5LY8VjdnJlytInyGhM0LkkCz8LhxJsnj52fT9lPb4ANofBsPGqEZee1NEQKrMyU9CbAH/rTWaEgARPT02h33J9/is68Yh8PSP6atLUnhvftGvtRDV7kxxldciivMXOlxDNqAQnCpzW0oEaP5ZPzTI/W4fNj/qG38hDGiu/Sy6/UzHXtXzCQBj3jUTvNuD055Aj1R3CjuP1Phz6glQ0cgWOmDItTMYpvJtFT+v8UcvDupQuKS4RMWtog+5vSZ2F+ebz89E5K/rQ3yqfa2KnLDwHO8AjXG2g/uEhtWxEe0q6kcEzAUe6ILjeCzCFOs0XGXB7ZNp6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6483.namprd11.prod.outlook.com (2603:10b6:208:3be::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Wed, 19 Jul
 2023 06:35:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6609.024; Wed, 19 Jul 2023
 06:35:46 +0000
Date:   Wed, 19 Jul 2023 14:09:01 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     David Stevens <stevensd@chromium.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to
 __kvm_follow_pfn
Message-ID: <ZLd9/V6EAxSwEAzY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-6-stevensd@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-6-stevensd@google.com>
X-ClientProxiedBy: SI2PR01CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6483:EE_
X-MS-Office365-Filtering-Correlation-Id: cf01554f-c24f-4ac6-caca-08db882261fe
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+uJ14KCQkehmcVeFsjsxN5qWboimT/LwipHJM76Uxq7neoMetaLC5U7PTKs0Q5wcvKTZkITkhPMGaAqxaaMKsmPB4WTJXHNIUHQDpSweluSath3AIcHOX7Z2JCnJWltQICCCOU/0O4zNHveWcj9lfmWBoeQnIz3cSpN2ZXnQYh39+0tAavZ/UceuSMk4hjkteCEY8055ptb8zWYA/CHGiFqNvPsvWD5XG1r9HhkFliprDqaIGfAKqWul0RIqtdst1qesj9HnPwRwsx0Z/0cZuO8+d1JozyuB59PTgl0pl4c4PeAKJYu938u87+FLH/TyxdqU+0FYhvxu7QalxQwqNdI1cSb4q/R/AR+Hz9+Zx06oNP9bTxvnCM2P/E6MPAyNQ1yBXaOaZAwDetlJRlwufFA3lFWObj8heIIYb022ChmwuhK1n3FpbDkJXncOmBrTXCiceNTSvPB4x93Z9d5mE/zUPyUtC31F7XZ1ASa0AJreD2p5XAGMEtGH7P0wxhOyHu35h5dem57aR+6PmRpnADTxIFdQenf0NS9JTtXLuEVK7zD/tPQMISO9Z5leQWB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199021)(6666004)(6486002)(478600001)(82960400001)(7416002)(8676002)(2906002)(54906003)(3450700001)(8936002)(5660300002)(86362001)(4326008)(6916009)(38100700002)(66946007)(66556008)(66476007)(316002)(6506007)(41300700001)(26005)(83380400001)(186003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sbxNv5NUZEgP8FrcXUtPj5X8cf6uBGJkOV0/xjfVrVgrYshHCOcj3tn1C3kO?=
 =?us-ascii?Q?xwh+a91XGxp1WHraFZPfjnvDqyH+/xNPQQew9RvpDafr+mW1RT1vj3mZNwJA?=
 =?us-ascii?Q?Gfn4jGrm3lHC3BhuZPf4DR5EQbxq/EakKqv6dwrNCAzzMrulJKicNLX+0hXJ?=
 =?us-ascii?Q?GFW7IXD1NZ5wegFT40bAMAmyEtPXXtYFIxRyqd64M8JwwH3mdHjQNRNVmp2P?=
 =?us-ascii?Q?JVneMWh9Joo7mplNhRystvjL4NKjfOh8eUkwdA2f/2NJ8BNFjuMtaDB0C2SE?=
 =?us-ascii?Q?OFKTfOz0eVYwY7ztiNA1S8Srt2E3VMBnAaDICBJMlcV89y+p71WafL3DwasC?=
 =?us-ascii?Q?kIjBFjLo34tjDb0k12IOX93dIR5gef7nkyuuiG7N7xqJeYLHWhwKvK25pvAj?=
 =?us-ascii?Q?QnnVQnFYQ6lW1oQxmX5sBmO1skxlPOYmXKp5SMGWFHey1ITX5Osne0DdUkzT?=
 =?us-ascii?Q?8niSAqVlw4jVGlNZcrUcTiybtL9jaIpA3P693GM0qlMQ1xIJhTpk12c0yuH3?=
 =?us-ascii?Q?ppIFsjHHzRqufQ2+GYNKVMsARDLekB5vVolc6m++2vlnqg3BT7PR72aB/n/b?=
 =?us-ascii?Q?j8sjHIIloul8ys26t96qsmQ/ecnvxTpsdg6Rp+wlnzUc5ttB9ZVjX8sKHOlQ?=
 =?us-ascii?Q?kk0WMnfiKGAsPxOr2+wPdpJrOTmZLJuJxOnuNwBNggB27AorSmasZbMRqxWE?=
 =?us-ascii?Q?0X8Nz/L0Pji1j875QsqE4ZH8kSOXZztwdny6LDYO6aDNLghbgmTrjO+B0qRb?=
 =?us-ascii?Q?me1gbrD+jfN2s2kOFxeKE4YnLvGD2csXWSFEB4b29tznRDYY7IpnzDUPAiUZ?=
 =?us-ascii?Q?BP2SHBWowR/wtMgmwsiFRcjEHzOiDMnte1kXZPolz9nisUT09IzMvjTOz9GC?=
 =?us-ascii?Q?PpGttKCXLPl2GQhh/cHGyfGA2QJ0u/W6pGp9a/mSXxecc5fa455VTrmWDhnm?=
 =?us-ascii?Q?OL4nUEY7CYczrlzdpS8v8hx6DA5XJfrOg6SDpkxN8KCn9CBVdHZooYVaND7V?=
 =?us-ascii?Q?yDItgnnZoCXmbdDjcESsBpRjyB0aUANT+fSvxsOfsUZ1SCYGp3HLAx/qJ381?=
 =?us-ascii?Q?PylF0rkJdnFPUWjt800hsdStLb8s5X5pC0LtWBww/Bnraacpsg0gKB5dIxiA?=
 =?us-ascii?Q?s0sGDSuWrPrpItMd634GLKF8Afi47pQ6yYoN49WlLsgT/6Gtrex06S0WE/mR?=
 =?us-ascii?Q?moGXvwDPiu23TJzx8UJ5kN8fvySUgnUXh6TFdgPFPGtjytI3qEwqQl0HjoHE?=
 =?us-ascii?Q?ZHVU6hgJ65TStpIMz7WlFuqUeCmlBcA8YwQbFTII9xA5nmwivVOHCifh2kd9?=
 =?us-ascii?Q?b/mc79javAzGwgByp2j1V0RDamRzAL/DsupyyCbPRTbNxiN9TPj2ahJ65zVc?=
 =?us-ascii?Q?eml87c/pZjGzal58yHdiz59rQz6BOTT99JBkXsYbjEaA7k1Jz7EcCVq3PolT?=
 =?us-ascii?Q?mJW8GZwbpsf7rST/hUX4i4GMsKDKkhBh4hGmF+VJbMXdUZH46aJ8gh/tCUzx?=
 =?us-ascii?Q?99oHLxElL31CYWFfWJjSQoS+rnpBJs5h295lTexXZneGcLin5SqA6mjLFcCa?=
 =?us-ascii?Q?fLWNtggDEO0tgUamApjFWWOG1skLjBX995peA52o?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf01554f-c24f-4ac6-caca-08db882261fe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2023 06:35:45.9252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QWuJJL+xWPZkh52/xeExwvrFqCkTp/GLoL84zlqPcOKBuyL7aUvS7AeAyHA3WOdfAavtDuJmRdUJV6tlvt0a7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6483
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> @@ -4451,7 +4461,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  
>  out_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(fault->pfn);
> +	if (fault->is_refcounted_page)
> +		kvm_set_page_accessed(pfn_to_page(fault->pfn));
For a refcounted page, as now KVM puts its ref early in kvm_faultin_pfn(),
should this kvm_set_page_accessed() be placed before unlocking mmu_lock?

Otherwise, if the user unmaps a region (which triggers kvm_unmap_gfn_range()
with mmu_lock holding for write), and release the page, and if the two
steps happen after checking page_count() in kvm_set_page_accessed() and
before mark_page_accessed(), the latter function may mark accessed to a page
that is released or does not belong to current process.

Is it true?

>  	return r;
>  }
>  
> @@ -4529,7 +4540,8 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  
>  out_unlock:
>  	read_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(fault->pfn);
> +	if (fault->is_refcounted_page)
> +		kvm_set_page_accessed(pfn_to_page(fault->pfn));
>  	return r;
>  }
Ditto.
