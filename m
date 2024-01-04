Return-Path: <kvm+bounces-5610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CC77823AD3
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 03:46:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04CE6B239D6
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 02:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA20E4C92;
	Thu,  4 Jan 2024 02:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="meTiBWja"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426964C67
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 02:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704336358; x=1735872358;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=0yYpDyrMjZDGEJv/2K80kW4U5X5dmQDcE2aIv1Iiezw=;
  b=meTiBWjaxtPbNJSDyUiEPY3hJe2ku2GLiBk+DuIJfP8XOrDLIwIrzi3d
   KHRhCMBM56FpIi58Z08oySMm21cG1dVDQDtPG9SCqWaxYZBAWCOmygyoT
   mX7eQOlZnSL/mwG02xQna1xwCxSYOO7ppBc+Nz4QPsLsv7TX0TVcZowf8
   l5L9aOXBZUXVLwBiLfwSwSmOJ74sqK2/qUjA7NMQTdnuy8+mxkqX8z7Ti
   AZBcJB3qEJBVltoL9a/llVjASzhV7G187kgHXTqpTBrt2MHS/hnzu/3I8
   q6b/caxZ34FrQ02jKobu0F/5r1NODKMGdHSa+rIMQpCEPa8TzPCjdC8WL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="3931330"
X-IronPort-AV: E=Sophos;i="6.04,329,1695711600"; 
   d="scan'208";a="3931330"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 18:45:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="809052466"
X-IronPort-AV: E=Sophos;i="6.04,329,1695711600"; 
   d="scan'208";a="809052466"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2024 18:45:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 18:45:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 18:45:53 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Jan 2024 18:45:53 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Jan 2024 18:45:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3CCbMjvY8B+m2zaddORsoCGZWeLP0FS9xJlvlWF3z34rHLYRkpj9b6kMp39cMj+NgMNTGgo0Y23JblloJyRkpIpHBzfO51WfDgitM5qiSO4SKfXt5Vm/odTZ4GopUOZ5MNCS47ePDd/OguwYGxFeZ7TFx9Ta8KRb8kou89ALtZSOcQvxUVuuSuZAkD6nc83Ek0AlxUvy//bxlCEGXtgYuwk/+1Krycide5KevzjNqWy2oD0mWipo2Ylv6q8iRWsnBzPks3IH4muYgEP5nmFLEp+bEPU+eRDLRwDCHKLmbFiNII76s0ET2UqIcOouy4dHgLvJ5TyynO7cFNQqe+AVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cS2+5jD+awSyr84iH0GM331MhqWWPzXpClbhoxm1tqY=;
 b=fI/brFBZK5WxQpqkBgir4EsEpNt0kwZez7sIUck7jLuDGsdt69F8rWtstu3mMWSbE08YY4WzBHjifcuV1+g5CI5SBw5vpsI0rdSXSofWQezr4RcOPXOlewLoild8MHAUw86VyiqPi0gyPWA7SdFdjZ6FFJ4gRGIQ0ZPShLAawgJ3ZZoNcDr0kZ/UKCZ2LT3dO/79sYC/aDOgdhj1esuNyrfK6jbLK4l/RE8uqFNi+2My/lvOv/TIkNEelEcLqpSXVBg+O3xWY0gf6JkYMrKaVhdfDYsfA8f8KSrqmC9k7hNi/yX5LaVQsaXBtkH4E/CZsfguC4Q3Fg7Ml/gCYUYrCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN2PR11MB4630.namprd11.prod.outlook.com (2603:10b6:208:24e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Thu, 4 Jan
 2024 02:45:45 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 02:45:45 +0000
Date: Thu, 4 Jan 2024 10:45:35 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Jim Mattson <jmattson@google.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	Tao Su <tao1.su@linux.intel.com>, <kvm@vger.kernel.org>,
	<pbonzini@redhat.com>, <eddie.dong@intel.com>, <xiaoyao.li@intel.com>,
	<yuan.yao@linux.intel.com>, <yi1.lai@intel.com>, <xudong.hao@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
Message-ID: <ZZYbzzDxPI8gjPu8@chao-email>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com>
 <ZYMWFhVQ7dCjYegQ@google.com>
 <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050>
 <ZZSbLUGNNBDjDRMB@google.com>
 <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
 <ZZWhuW_hfpwAAgzX@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZZWhuW_hfpwAAgzX@google.com>
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN2PR11MB4630:EE_
X-MS-Office365-Filtering-Correlation-Id: f8085b8e-7ae0-4d6a-e148-08dc0ccf400a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0pRbC1sHNrMNSlY/DsUFmcU8PmcuZND/igxcO/MvXKVCMnC8pHDqYvBIjAmXABE3PtoWCJsht6q5zPr+S2k8KWQHwZSENSud+tPgIg/JmikkfM/0r63ISXiOLtHUqb/F5+PmG76ME1B+oDJ9nSFmf0rLi4bOoS5So2twcuynEalMrvkDazphoMYvPp88vMM56GsACk76Z+i7Va/xqNa3YR6AS4A0jvDfpKrS9Z9bmLg34X1/z6jTEdbgO8Po/C6nodnpn7DJ6YCFaE0OpZTKNebG6zm/TgVaEgeYoqkNMMJ45qwR57RXqg+pMsAP7PZnC7EJigUmYwq0MhTl6JlXM47eoZUCAsFLihSzs/3U5eTF4BwPeAvE3mx9r/L7LF83KXj277SLchcc2eL70yDiYWsKGO9UfpoyEIZvB9Pcy1Tss+8kwa2tPIkY6KvRNKQgoMBjlTPCgm2FLN2nhj+g9OJwoiFfoqspvFljolO0CUOJe0DqgFnkNdgJxm3i2SjzK9V3PhjQTzWMfymeGaHlNz5HvoW1RBzNxKpjXzw3oUGWyqsiJ744tkPG2gVX+uF0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(366004)(396003)(136003)(39860400002)(376002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(66556008)(26005)(82960400001)(83380400001)(38100700002)(66946007)(54906003)(66476007)(6916009)(6486002)(316002)(478600001)(86362001)(5660300002)(2906002)(44832011)(4326008)(8676002)(8936002)(33716001)(53546011)(6506007)(9686003)(6512007)(6666004)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUI4dEd6OFVKMzQxN0NqNEdQR0dCcU4rc3ZjZnNkdmdTWUhBL0UzV3hYZ1l6?=
 =?utf-8?B?cS9acUZvV2VNYktKSGpXbStFU21UNDBLSCtrRVNvTnlmTUVWditwRVpzTnU2?=
 =?utf-8?B?R3BqKzRVVWpJaE5DNktobjhudWpQRm5scEFSYi85c1VKVzNKTDhRV0R5YTRT?=
 =?utf-8?B?VTRxMmFPZFFGTnZSN1dOeDhORWtIS2Z2Sm5lVFMyaVV3SUQ4WVFISlRxSXk3?=
 =?utf-8?B?bExldmpmMVE0Z2g0V0R6YlVVbGJxam05bFVGYmRCWFNteVpjbjlLMVd6WjYw?=
 =?utf-8?B?aUY2N0NJZUVLYU5sS3JGRUtZQTZiWVAvMCsxSTJmb1lHMlBjS2RLN3VjMGZi?=
 =?utf-8?B?azRNajZWN1RXR29kRUNZNk1UUks4ZnhRSFM4M2wzdXQ4OHRPcWoyMllHdzVq?=
 =?utf-8?B?MVJJQldXMjlROGl2WWRuY0FxOVlHR0p6TjJPcXpqTTVtNThEVkVXSUFVTUh1?=
 =?utf-8?B?c0dCV0M2QUU4bk1qcnZOUUpoUGYxMVhZN2YvOFZMVmE2YkVSRWJ2YnluUWVN?=
 =?utf-8?B?UlVKOWFqOVg1SVptbGJwRG5GWE5aSlcyb01XdEladWs5eUc1cXlNVkdnNXdq?=
 =?utf-8?B?YlJVZEZoYmJhZ2t3MG81VDNZVUNkaTVXM2l3c25FaGJocmtUalhiclBFWlI0?=
 =?utf-8?B?T05NdVBuMlpYQmJ4a0RvYXV2SjR1V2RXZGh5a3V1RUdyamRQaS9DMDVaZlZy?=
 =?utf-8?B?aTdDdDB6dVFqRlprbjlBRmJSeGJnMlJsczFPNG41NGdjMUlqV25ESTBwSVd4?=
 =?utf-8?B?eXFXOXBSSWcvRk1IR1hDT1FiMTdua1V0dkRoakVNcjdHTmpNTTFTeFd3OWxj?=
 =?utf-8?B?NXViVVNXNnJmTnE3Sm0xSDdGcHdUdkQ3ejAzMGpUQ2ZTRzN4d2YyQ1JGYS90?=
 =?utf-8?B?M0g2N0hJRVJPRkhUY2o5bUF6YXNSRDJ3VGc4VEVDaTVSYVk0clYwNHA1YlBo?=
 =?utf-8?B?ZW9zT25Bam5MRkRFdHlUWW56Mm9MY0hEVlN5SkdiTDc0MEs1UUZnN1M1QmhY?=
 =?utf-8?B?aC9qcWVjZ2ZYeHNlR0ZSKzlYL2l2c2IxRXZqUHZXWEpWeEovSWg5RlR4N1k2?=
 =?utf-8?B?VnJtWk1NUEhFcUVaTXJhYWlQZ2pOWmlWbUFRQUNwQzJIazMxZ29FMmZ6cnlI?=
 =?utf-8?B?eEJ5ektFQUw3WVp1eFNacXRRZW1IWTR1bzFkME11aWI1Z1JWY3pyak92RzNP?=
 =?utf-8?B?dmJKWUMxUlVBT0k2Z21IVEJMTGRqQTdUZmtPRTdUa1MxVm52L3hCblZ2eDVw?=
 =?utf-8?B?NjZjRVJCQklKL0EwRUVXaE5ncWpmWm1HbU1DTDlnU3RlNFJZRDRUam5Ya2N6?=
 =?utf-8?B?eW45TStvWVhPdnRwakI5c0FudmtJOTlkeC9KZnBXRUUrZTRNSmVHK3NWblRp?=
 =?utf-8?B?eTJlaExZdWxhdEl2djBCOEFJSml2TGJEbXlKeHlVUGQzR0tobTVCTmxFZ3NK?=
 =?utf-8?B?aVhHK0dXUEUyd0kvNWZkdlQ4clc4MW5xK3hlWG5zblFFY2hoY2ZhaEtBMk5j?=
 =?utf-8?B?M0hKbWZZd1I3NGh3Z29JM2lSZWFwdVFhdW04R2IzUTdiSmt2ZGVWSWlOVDcx?=
 =?utf-8?B?d3EwM2Z3RlRnZGFzZ3dxQU9qVVJoL042bDFmd1VpQ1FBdklCb2UzNmxaYzFm?=
 =?utf-8?B?OStoOWdyc2tNWFRJbUhRd2tGam1TYXpBSFNsY1dzQ3VRbmFLblVvNXpuci9q?=
 =?utf-8?B?bjBZeWZtTC93Y1FRMlVtRHA4TDhKekJ1My9hQnBncU5GRm1OdndJMk5CRnJk?=
 =?utf-8?B?aHFQeGRsYzFXeVo1M2d4dXE3K1hPdlBoSkZlNGxDNmtpcjY4YjRaTjZzRjdW?=
 =?utf-8?B?YVdVcE02ek1oTGZIUlh0ZFI1dlZhazYvc3p1SjFDK2grR2RNVzFZQ0FONlUz?=
 =?utf-8?B?STZ5UWQvelZZek8rbmpzTjRBUE1yMVBFSThmeCtiQTJMdEpYcmpJMFZKaUZ6?=
 =?utf-8?B?akYzM2lBV1d2U2lhV015WVIrYzd3R0VWWEZtU3RicEZsbWtLUG1MaEp6Y0dW?=
 =?utf-8?B?VysyTmwzazNrOWVkYzczRUl6WVIzVGtSRldmQUx4cm83S1pBcWRUK21BL1h5?=
 =?utf-8?B?L29ZRTB4VjVSVEE5TitWTDUvdC9pL1E5THNGbklXOENVSFdwWW1PaUJDVHZB?=
 =?utf-8?Q?LTffJmSyTiqxHZ8S41HbWYoIV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8085b8e-7ae0-4d6a-e148-08dc0ccf400a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 02:45:45.4323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fQZgjMIvSLUn8t70yj+aYOEo4vmHfwTDdbnd5ZQw35l4Vc8iEdhfeZFpcGA6V1j6/n9k/7JSv3NhHFbQ1xCrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4630
X-OriginatorOrg: intel.com

On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wrote:
>On Tue, Jan 02, 2024, Jim Mattson wrote:
>> On Tue, Jan 2, 2024 at 3:24 PM Sean Christopherson <seanjc@google.com> wrote:
>> >
>> > On Thu, Dec 21, 2023, Xu Yilun wrote:
>> > > On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson wrote:
>> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> > > > > index c57e181bba21..72634d6b61b2 100644
>> > > > > --- a/arch/x86/kvm/mmu/mmu.c
>> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
>> > > > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
>> > > > >   reset_guest_paging_metadata(vcpu, mmu);
>> > > > >  }
>> > > > >
>> > > > > +/* guest-physical-address bits limited by TDP */
>> > > > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
>> > > > > +{
>> > > > > + return max_tdp_level == 5 ? 57 : 48;
>> > > >
>> > > > Using "57" is kinda sorta wrong, e.g. the SDM says:
>> > > >
>> > > >   Bits 56:52 of each guest-physical address are necessarily zero because
>> > > >   guest-physical addresses are architecturally limited to 52 bits.
>> > > >
>> > > > Rather than split hairs over something that doesn't matter, I think it makes sense
>> > > > for the CPUID code to consume max_tdp_level directly (I forgot that max_tdp_level
>> > > > is still accurate when tdp_root_level is non-zero).
>> > >
>> > > It is still accurate for now. Only AMD SVM sets tdp_root_level the same as
>> > > max_tdp_level:
>> > >
>> > >       kvm_configure_mmu(npt_enabled, get_npt_level(),
>> > >                         get_npt_level(), PG_LEVEL_1G);
>> > >
>> > > But I wanna doulbe confirm if directly using max_tdp_level is fully
>> > > considered.  In your last proposal, it is:
>> > >
>> > >   u8 kvm_mmu_get_max_tdp_level(void)
>> > >   {
>> > >       return tdp_root_level ? tdp_root_level : max_tdp_level;
>> > >   }
>> > >
>> > > and I think it makes more sense, because EPT setup follows the same
>> > > rule.  If any future architechture sets tdp_root_level smaller than
>> > > max_tdp_level, the issue will happen again.
>> >
>> > Setting tdp_root_level != max_tdp_level would be a blatant bug.  max_tdp_level
>> > really means "max possible TDP level KVM can use".  If an exact TDP level is being
>> > forced by tdp_root_level, then by definition it's also the max TDP level, because
>> > it's the _only_ TDP level KVM supports.
>> 
>> This is all just so broken and wrong. The only guest.MAXPHYADDR that
>> can be supported under TDP is the host.MAXPHYADDR. If KVM claims to
>> support a smaller guest.MAXPHYADDR, then KVM is obligated to intercept
>> every #PF,

in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU supports only
4-level EPT), KVM has no need to intercept #PF because accessing a GPA with
RSVD bits 51-48 set leads to EPT violation.

>> and to emulate the faulting instruction to see if the RSVD
>> bit should be set in the error code. Hardware isn't going to do it.

Note for EPT violation VM exits, the CPU stores the GPA that caused this exit
in "guest-physical address" field of VMCS. so, it is not necessary to emulate
the faulting instruction to determine if any RSVD bit is set.

>> Since some page faults may occur in CPL3, this means that KVM has to
>> be prepared to emulate any memory-accessing instruction. That's not
>> practical.

as said above, no need to intercept #PF for this specific case.

